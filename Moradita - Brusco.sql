-- Trigger para validar que las unidades que entregue el proveedor (las recibidas) sean igual o menores las solicitadas y luego insertar como valor de lo recibido en base al costo que indica la Orden de Compra:
DELIMITER //

CREATE TRIGGER before_recibo_de_mercaderia_insert
BEFORE INSERT ON recibo_de_mercaderia
FOR EACH ROW
BEGIN
    DECLARE ordered_quantity INT;
    DECLARE ordered_price DECIMAL(10, 2);

    -- Obtener la cantidad y el precio de la orden de compra
    SELECT quantity, purchase_price INTO ordered_quantity, ordered_price
    FROM orden_de_compra
    WHERE id_orden_de_compra = NEW.id_orden_de_compra;

    -- Verificar que la cantidad recibida no exceda la cantidad ordenada
    IF NEW.quantity > ordered_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad recibida no puede exceder la cantidad ordenada.';
    END IF;
END; //

DELIMITER ;

-- Trigger para subir stock cuando hay recibo de mercadería:
DELIMITER //

CREATE TRIGGER after_recibo_de_mercaderia_insert
AFTER INSERT ON recibo_de_mercaderia
FOR EACH ROW
BEGIN
    DECLARE current_quantity INT;
    
    -- Valida si hay stock del artículo
    SELECT quantity INTO current_quantity FROM stock WHERE id_articulo = NEW.id_articulo;
    
    IF current_quantity IS NULL THEN
        -- Si aún no hay stock de dicho artículo lo crea el registro.
        INSERT INTO stock (id_articulo, quantity, stock_price, barcode, id_proveedor)
        VALUES (NEW.id_articulo, NEW.quantity, NEW.purchase_price, NEW.barcode, NEW.id_proveedor);
    ELSE
        -- Si existe el artículo en la base de stock, entonces lo actualiza.
        UPDATE stock
        SET quantity = quantity + NEW.quantity
        WHERE id_articulo = NEW.id_articulo;
    END IF;
END; //

DELIMITER ;

-- Trigger para reducir stock cuando hay venta de mercadería:
DELIMITER //

CREATE TRIGGER after_venta_insert
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    -- Update existing stock record
    UPDATE stock
    SET quantity = quantity - NEW.quantity
    WHERE id_articulo = NEW.id_articulo;
END; //

DELIMITER ;

-- Trigger para impactar el código de barras, nombre y precio en la tabla orden_de_compra en base a los datos que están en la tabla articulo al momento de crear el dato en la tabla orden_de_compra:
DELIMITER //

CREATE TRIGGER before_orden_de_compra_insert
BEFORE INSERT ON orden_de_compra
FOR EACH ROW
BEGIN
    DECLARE article_price DECIMAL(10, 2);
    DECLARE article_barcode VARCHAR(20);
    DECLARE article_name VARCHAR(40);

    -- Obtener el precio, código de barras y nombre del artículo desde la tabla articulo.
    SELECT purchase_price, barcode, name INTO article_price, article_barcode, article_name
    FROM articulo
    WHERE id_articulo = NEW.id_articulo;

    -- Asignar estos valores a las columnas correspondientes en la tabla orden_de_compra
    SET NEW.purchase_price = article_price;
    SET NEW.barcode = article_barcode;
    SET NEW.name = article_name;

    -- Calcular el total_price
    SET NEW.total_price = NEW.quantity * article_price;
END; //

DELIMITER ;

-- Trigger para actualizar la tabla catalogo cuando se inserta o actualiza el stock

-- Como MySQL no acepta AFTER INSERT OR UPDATE en una sola declaración lo separo en 2.

-- Trigger para el insert:
DELIMITER //

CREATE TRIGGER after_stock_insert
AFTER INSERT ON stock
FOR EACH ROW
BEGIN
    DECLARE article_name VARCHAR(40);
    DECLARE article_barcode VARCHAR(20);
    DECLARE article_sale_price DECIMAL(10, 2);
    DECLARE article_category INT;

    -- Obtener el nombre, código de barras, precio de venta y categoría del artículo desde la tabla articulo
    SELECT name, barcode, sale_price, id_categoria_articulo INTO article_name, article_barcode, article_sale_price, article_category
    FROM articulo
    WHERE id_articulo = NEW.id_articulo;

    IF NEW.quantity > 0 THEN
        -- Insertar o actualizar la tabla catalogo
        INSERT INTO catalogo (id_articulo, name, barcode, stock_quantity, stock_price, sale_price, id_categoria_articulo)
        VALUES (NEW.id_articulo, article_name, article_barcode, NEW.quantity, NEW.stock_price, article_sale_price, article_category)
        ON DUPLICATE KEY UPDATE
            stock_quantity = VALUES(stock_quantity),
            stock_price = VALUES(stock_price),
            sale_price = VALUES(sale_price),
            id_categoria_articulo = VALUES(id_categoria_articulo);
    ELSE
        -- Eliminar de catalogo si el stock llega a cero o menos
        DELETE FROM catalogo
        WHERE id_articulo = NEW.id_articulo;
    END IF;
END; //

DELIMITER ;

--  Trigger para actualización de stock:
DELIMITER //

CREATE TRIGGER after_stock_update
AFTER UPDATE ON stock
FOR EACH ROW
BEGIN
    DECLARE article_name VARCHAR(40);
    DECLARE article_barcode VARCHAR(20);
    DECLARE article_sale_price DECIMAL(10, 2);
    DECLARE article_category INT;

    -- Obtener el nombre, código de barras, precio de venta y categoría del artículo desde la tabla articulo
    SELECT name, barcode, sale_price, id_categoria_articulo INTO article_name, article_barcode, article_sale_price, article_category
    FROM articulo
    WHERE id_articulo = NEW.id_articulo;

    IF NEW.quantity > 0 THEN
        -- Insertar o actualizar la tabla catalogo
        INSERT INTO catalogo (id_articulo, name, barcode, stock_quantity, stock_price, sale_price, id_categoria_articulo)
        VALUES (NEW.id_articulo, article_name, article_barcode, NEW.quantity, NEW.stock_price, article_sale_price, article_category)
        ON DUPLICATE KEY UPDATE
            stock_quantity = VALUES(stock_quantity),
            stock_price = VALUES(stock_price),
            sale_price = VALUES(sale_price),
            id_categoria_articulo = VALUES(id_categoria_articulo);
    ELSE
        -- Eliminar de catalogo si el stock llega a cero o menos
        DELETE FROM catalogo
        WHERE id_articulo = NEW.id_articulo;
    END IF;
END; //

DELIMITER ;

-- Trigger para verificar que el artículo esté en el catálogo antes de realizar la venta:
DELIMITER //

CREATE TRIGGER before_venta_insert
BEFORE INSERT ON venta
FOR EACH ROW
BEGIN
    DECLARE stock_quantity INT;

    -- Obtener la cantidad de stock del artículo en el catálogo
    SELECT stock_quantity INTO stock_quantity
    FROM catalogo
    WHERE id_articulo = NEW.id_articulo;

    -- Verificar que el artículo esté en el catálogo y tenga suficiente stock
    IF stock_quantity IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El artículo no está en el catálogo o no tiene stock disponible.';
    ELSEIF stock_quantity < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para completar la venta.';
    END IF;
END; //

DELIMITER ;

--  Trigger para actualización del artículo modifique el catalogo:
DELIMITER //

CREATE TRIGGER after_articulo_update
AFTER UPDATE ON articulo
FOR EACH ROW
BEGIN
    DECLARE current_quantity INT;
    DECLARE current_stock_price DECIMAL(10, 2);

    -- Obtener la cantidad y el precio de stock actual
    SELECT quantity, stock_price INTO current_quantity, current_stock_price
    FROM stock
    WHERE id_articulo = NEW.id_articulo;

    IF current_quantity IS NOT NULL THEN
        -- Insertar o actualizar la tabla catalogo
        INSERT INTO catalogo (id_articulo, name, barcode, stock_quantity, stock_price, sale_price, id_categoria_articulo)
        VALUES (NEW.id_articulo, NEW.name, NEW.barcode, current_quantity, current_stock_price, NEW.sale_price, NEW.id_categoria_articulo)
        ON DUPLICATE KEY UPDATE
            name = VALUES(name),
            barcode = VALUES(barcode),
            stock_quantity = VALUES(stock_quantity),
            stock_price = VALUES(stock_price),
            sale_price = VALUES(sale_price),
            id_categoria_articulo = VALUES(id_categoria_articulo);
    ELSE
        -- Opcional: si el artículo no tiene stock, podrías eliminarlo del catálogo.
        DELETE FROM catalogo
        WHERE id_articulo = NEW.id_articulo;
    END IF;
END; //

DELIMITER ;
