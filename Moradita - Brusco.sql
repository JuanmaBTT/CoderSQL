-- Crear el esquema Moradita
CREATE SCHEMA moradita;

-- Utilizar el esquema creado
USE moradita;

-- Crear tabla proveedor
CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    email VARCHAR(40) NOT NULL,
    address VARCHAR(40) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    bank VARCHAR(20) NOT NULL,
    bank_account_number VARCHAR(20) NOT NULL,
    currency VARCHAR(20) NOT NULL,
    payment_deadline INT NOT NULL
);

-- Crear tabla IVA
CREATE TABLE iva (
    id_iva INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    value DECIMAL(5, 2) NOT NULL
);

-- Crear tabla categoría de artículo
CREATE TABLE categoria_articulo (
    id_categoria_articulo INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL
);

-- Crear tabla artículo
CREATE TABLE articulo (
    id_articulo INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    id_iva INT,
    sale_price DECIMAL(10, 2) NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    barcode VARCHAR(20) NOT NULL,
    id_categoria_articulo INT,
    id_proveedor INT,
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva),
    FOREIGN KEY (id_categoria_articulo) REFERENCES categoria_articulo(id_categoria_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- Crear tabla orden de compra
CREATE TABLE orden_de_compra (
    id_orden_de_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT,
    name VARCHAR(40) NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2),
    barcode VARCHAR(20) NOT NULL,
    id_proveedor INT,
    id_iva INT,
    document_number VARCHAR(40),
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

-- Crear tabla recibo de mercadería
CREATE TABLE recibo_de_mercaderia (
    id_recibo_de_mercaderia INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT,
    name VARCHAR(40) NOT NULL,
    id_orden_de_compra INT,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2),
    barcode VARCHAR(20) NOT NULL,
    receipt_date DATE NOT NULL,
    id_proveedor INT,
    id_iva INT,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_orden_de_compra) REFERENCES orden_de_compra(id_orden_de_compra),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

-- Crear tabla compras
CREATE TABLE compras (
    id_compras INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT,
    name VARCHAR(40) NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2),
    barcode VARCHAR(20) NOT NULL,
    purchase_date DATE NOT NULL,
    id_proveedor INT,
    id_iva INT,
    document_number VARCHAR(40),
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

-- Crear tabla stock
CREATE TABLE stock (
    id_articulo INT PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    quantity INT NOT NULL,
    stock_price DECIMAL(10, 2) NOT NULL,
    total_stock_price DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * stock_price) STORED,
    barcode VARCHAR(20) NOT NULL,
    id_proveedor INT,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- Crear tabla catálogo
CREATE TABLE catalogo (
    id_articulo INT PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    barcode VARCHAR(20) NOT NULL,
    stock_quantity INT NOT NULL,
    stock_price DECIMAL(10, 2) NOT NULL,
    sale_price DECIMAL(10, 2) NOT NULL,
    id_categoria_articulo INT NOT NULL,
    id_iva INT NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_categoria_articulo) REFERENCES categoria_articulo(id_categoria_articulo),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

-- Crear tabla cliente
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    birthday DATE,
    email VARCHAR(40) NOT NULL,
    city VARCHAR(40) NOT NULL,
    neighborhood VARCHAR(40) NOT NULL,
    address VARCHAR(40) NOT NULL,
    address_number VARCHAR(10) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    document_type VARCHAR(20) NOT NULL,
    document_number VARCHAR(20) NOT NULL,
    gender VARCHAR(10) NOT NULL
);

-- Crear tabla venta
CREATE TABLE venta (
    id_ticket INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT,
    name VARCHAR(40) NOT NULL,
    quantity INT NOT NULL,
    sale_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2),
    payment_method VARCHAR(20) NOT NULL,
    bank VARCHAR(20),
    bank_account_number VARCHAR(20),
    currency VARCHAR(20) NOT NULL,
    stock INT,
    id_cliente INT,
    id_iva INT,
    document_number VARCHAR(40),
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

-- Triggers

-- Trigger para validar que las unidades recibidas no excedan las solicitadas
DELIMITER //

CREATE TRIGGER before_recibo_de_mercaderia_insert
BEFORE INSERT ON recibo_de_mercaderia
FOR EACH ROW
BEGIN
    DECLARE ordered_quantity INT;

    -- Obtener la cantidad de la orden de compra
    SELECT quantity INTO ordered_quantity
    FROM orden_de_compra
    WHERE id_orden_de_compra = NEW.id_orden_de_compra;

    -- Verificar que la cantidad recibida no exceda la cantidad ordenada
    IF NEW.quantity > ordered_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad recibida no puede exceder la cantidad ordenada.';
    END IF;
END; //

DELIMITER ;

-- Trigger para subir stock cuando hay recibo de mercadería
DELIMITER //

-- Trigger para subir stock cuando hay recibo de mercadería
DELIMITER //

CREATE TRIGGER after_recibo_de_mercaderia_insert
AFTER INSERT ON recibo_de_mercaderia
FOR EACH ROW
BEGIN
    DECLARE current_quantity INT;
    DECLARE art_sale_price DECIMAL(10, 2);
    DECLARE art_categoria INT;

    -- Valida si hay stock del artículo
    SELECT quantity INTO current_quantity 
    FROM stock 
    WHERE id_articulo = NEW.id_articulo;

    IF current_quantity IS NULL THEN
        -- Si aún no hay stock del artículo, lo crea:
        INSERT INTO stock (id_articulo, name, quantity, stock_price, barcode, id_proveedor)
        VALUES (NEW.id_articulo, NEW.name, NEW.quantity, NEW.purchase_price, NEW.barcode, NEW.id_proveedor);
    ELSE
        -- Si existe el artículo en stock, lo actualiza:
        UPDATE stock
        SET quantity = quantity + NEW.quantity
        WHERE id_articulo = NEW.id_articulo;
    END IF;

    -- Obtener el precio de venta y la categoría del artículo
    SELECT sale_price, id_categoria_articulo INTO art_sale_price, art_categoria
    FROM articulo
    WHERE id_articulo = NEW.id_articulo;

    -- Actualizar el catálogo con la nueva información:
    INSERT INTO catalogo (id_articulo, name, barcode, stock_quantity, stock_price, sale_price, id_categoria_articulo, id_iva)
    VALUES (NEW.id_articulo, NEW.name, NEW.barcode, NEW.quantity, NEW.purchase_price, art_sale_price, art_categoria, NEW.id_iva)
    ON DUPLICATE KEY UPDATE
        stock_quantity = VALUES(stock_quantity),
        stock_price = VALUES(stock_price),
        sale_price = VALUES(sale_price);
END; //

DELIMITER ;

-- Trigger para calcular el IVA en la tabla de compras:
DELIMITER //

CREATE TRIGGER before_compras_insert
BEFORE INSERT ON compras
FOR EACH ROW
BEGIN
    DECLARE iva_value DECIMAL(5, 2);
    
    -- Obtener el valor del IVA desde la tabla articulo
    SELECT value INTO iva_value
    FROM iva
    WHERE id_iva = (SELECT id_iva FROM articulo WHERE id_articulo = NEW.id_articulo);

    -- Calcular el total_price incluyendo el IVA
    SET NEW.total_price = NEW.quantity * NEW.purchase_price * (1 + iva_value / 100);
END; //

DELIMITER ;

-- Trigger para actualizar stock en la tabla de ventas:
DELIMITER //

CREATE TRIGGER after_venta_insert
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    -- Obtener la cantidad de stock disponible:
    SELECT quantity INTO current_stock 
    FROM stock 
    WHERE id_articulo = NEW.id_articulo;

    -- Verificar y actualizar la cantidad en stock:
    IF current_stock IS NOT NULL THEN
        IF current_stock < NEW.quantity THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No hay suficiente stock disponible para la venta.';
        ELSE
            UPDATE stock
            SET quantity = quantity - NEW.quantity
            WHERE id_articulo = NEW.id_articulo;
        END IF;
    END IF;
END; //

DELIMITER ;