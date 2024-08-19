-- Crear el esquema Moradita
DROP DATABASE IF EXISTS moradita;
CREATE DATABASE moradita;

-- Utilizar el esquema creado
USE moradita;

-- Crear tabla proveedor
CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    email VARCHAR(40) NOT NULL,
    address VARCHAR(40) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    bank VARCHAR(40) NOT NULL,
    bank_account_number VARCHAR(40) NOT NULL,
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
    id_iva INT NOT NULL,
    sale_price DECIMAL(10, 2) NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    barcode VARCHAR(20),
    id_categoria_articulo INT NOT NULL,
    id_proveedor INT NOT NULL,
    constraint fk_iva_articulo FOREIGN KEY (id_iva) REFERENCES iva(id_iva) ,
    constraint fk_categoria_articulo FOREIGN KEY (id_categoria_articulo) REFERENCES categoria_articulo(id_categoria_articulo),
    constraint fk_id_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- Crear tabla orden de compra
CREATE TABLE orden_de_compra (
    id_orden_de_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    name VARCHAR(40) NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * purchase_price) STORED,
    barcode VARCHAR(20),
    id_proveedor INT NOT NULL,
    id_iva INT NOT NULL,
    document_number VARCHAR(40) NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

-- Crear tabla recibo de mercadería
CREATE TABLE recibo_de_mercaderia (
    id_recibo_de_mercaderia INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    name VARCHAR(40) NOT NULL,
    id_orden_de_compra INT NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * purchase_price) STORED,
    barcode VARCHAR(20) ,
    receipt_date DATE NOT NULL,
    id_proveedor INT NOT NULL,
    id_iva INT NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_orden_de_compra) REFERENCES orden_de_compra(id_orden_de_compra),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

-- Crear tabla compras
CREATE TABLE compras (
    id_compras INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    name VARCHAR(40) NOT NULL,
	id_orden_de_compra INT NOT NULL,
    id_recibo_de_mercaderia INT NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * purchase_price) STORED,
    barcode VARCHAR(20) NOT NULL,
    purchase_date DATE NOT NULL,
    id_proveedor INT NOT NULL,
    id_iva INT NOT NULL,
    document_number VARCHAR(40) NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
	FOREIGN KEY (id_orden_de_compra) REFERENCES orden_de_compra(id_orden_de_compra),
	FOREIGN KEY (id_recibo_de_mercaderia) REFERENCES recibo_de_mercaderia(id_recibo_de_mercaderia),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

-- Crear tabla stock
CREATE TABLE stock (
    id_articulo INT PRIMARY KEY,
    name VARCHAR(40),
    quantity INT NOT NULL,
    stock_price DECIMAL(10, 2) NOT NULL,
    total_stock_price DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * stock_price) STORED,
    barcode VARCHAR(20) NOT NULL,
    id_proveedor INT NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- Crear tabla catálogo
CREATE TABLE catalogo (
    id_articulo INT PRIMARY KEY,
    name VARCHAR(40),
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
    birthday DATE NOT NULL,
    email VARCHAR(40) NOT NULL,
    city VARCHAR(40) NOT NULL,
    neighborhood VARCHAR(40) NOT NULL,
    address VARCHAR(40) NOT NULL,
    address_number VARCHAR(10) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    document_type VARCHAR(20) NOT NULL,
    document_number VARCHAR(20) NOT NULL,
    gender ENUM('H','M','ND') NOT NULL
);

-- Crear tabla venta
CREATE TABLE venta (
    id_ticket INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    name VARCHAR(40),
    quantity INT NOT NULL,
    sale_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * sale_price) STORED,
    payment_method VARCHAR(40) NOT NULL,
    bank VARCHAR(40),
    bank_account_number VARCHAR(20),
    currency VARCHAR(20) NOT NULL,
    id_cliente INT NOT NULL,
    id_iva INT NOT NULL,
    document_number VARCHAR(40)  NOT NULL,
	fecha DATE NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);

CREATE TABLE auditoria (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    tabla_nombre VARCHAR(50) NOT NULL,
    id_registro INT NOT NULL,
    fecha_modificacion DATETIME NOT NULL,
    usuario_modificacion VARCHAR(50) NOT NULL,
    tipo_cambio ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    campos_modificados TEXT
);

-- Triggers

-- 1) Trigger para aumentar el stock con recepción de mercadería

DELIMITER //

CREATE TRIGGER after_recibo_de_mercaderia_insert
AFTER INSERT ON recibo_de_mercaderia
FOR EACH ROW
BEGIN
    -- Intentar actualizar el stock si ya existe
    UPDATE stock
    SET quantity = quantity + NEW.quantity
    WHERE id_articulo = NEW.id_articulo;

    -- Si no se actualizó ninguna fila, significa que no existe ese artículo en el stock, por lo que se inserta uno nuevo
    IF ROW_COUNT() = 0 THEN
        INSERT INTO stock (id_articulo, name, quantity, stock_price, barcode, id_proveedor)
        VALUES (NEW.id_articulo, NEW.name, NEW.quantity, NEW.purchase_price, NEW.barcode, NEW.id_proveedor);
    END IF;
END //

DELIMITER ;

-- 2) Trigger para reducir el stock con venta de mercadería
DELIMITER //

CREATE TRIGGER after_venta_insert
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    -- Verificar que el stock no quede en negativo
    IF (SELECT quantity FROM stock WHERE id_articulo = NEW.id_articulo) >= NEW.quantity THEN
        -- Reducir el stock
        UPDATE stock
        SET quantity = quantity - NEW.quantity
        WHERE id_articulo = NEW.id_articulo;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Stock insuficiente para realizar la venta.';
    END IF;
END //

DELIMITER ;

--  3) Trigger para que la actualización del artículo modifique el catalogo:

DELIMITER //

CREATE TRIGGER after_articulo_update
AFTER UPDATE ON articulo
FOR EACH ROW
BEGIN
    DECLARE current_quantity INT;
    DECLARE current_stock_price DECIMAL(10, 2);

    -- Obtener la cantidad y el precio de stock actual desde la tabla stock
    SELECT quantity, stock_price INTO current_quantity, current_stock_price
    FROM stock
    WHERE id_articulo = NEW.id_articulo;

    IF current_quantity IS NOT NULL THEN
        -- Insertar o actualizar la tabla catalogo
        INSERT INTO catalogo (id_articulo, name, barcode, stock_quantity, stock_price, sale_price, id_categoria_articulo, id_iva)
        VALUES (NEW.id_articulo, NEW.name, NEW.barcode, current_quantity, NEW.purchase_price, NEW.sale_price, NEW.id_categoria_articulo, NEW.id_iva)
        ON DUPLICATE KEY UPDATE
            name = VALUES(name),
            barcode = VALUES(barcode),
            stock_quantity = VALUES(stock_quantity),
            stock_price = VALUES(stock_price),
            sale_price = VALUES(sale_price),
            id_categoria_articulo = VALUES(id_categoria_articulo),
            id_iva = VALUES(id_iva);
    ELSE
        -- Opcional: si el artículo no tiene stock, podrías eliminarlo del catálogo.
        DELETE FROM catalogo
        WHERE id_articulo = NEW.id_articulo;
    END IF;
END //

DELIMITER ;


-- 4) Triggers de auditoria de cambios en los artículos

DELIMITER //

-- Trigger para actualización en la tabla articulo
CREATE TRIGGER audit_articulo_update
AFTER UPDATE ON articulo
FOR EACH ROW
BEGIN
    DECLARE campos TEXT;
    DECLARE usuario VARCHAR(50) DEFAULT 'SYSTEM'; -- Puedes ajustar esto para obtener el usuario actual

    -- Construir una cadena de texto con los campos modificados
    SET campos = CONCAT(
        'name: ', IF(OLD.name != NEW.name, CONCAT(OLD.name, ' -> ', NEW.name), ''),
        ', sale_price: ', IF(OLD.sale_price != NEW.sale_price, CONCAT(OLD.sale_price, ' -> ', NEW.sale_price), ''),
        ', purchase_price: ', IF(OLD.purchase_price != NEW.purchase_price, CONCAT(OLD.purchase_price, ' -> ', NEW.purchase_price), ''),
        ', barcode: ', IF(OLD.barcode != NEW.barcode, CONCAT(OLD.barcode, ' -> ', NEW.barcode), '')
    );

    -- Insertar un registro en la tabla de auditoría
    INSERT INTO auditoria (tabla_nombre, id_registro, fecha_modificacion, usuario_modificacion, tipo_cambio, campos_modificados)
    VALUES ('articulo', OLD.id_articulo, NOW(), usuario, 'UPDATE', campos);
END //

-- Trigger para inserción en la tabla articulo
CREATE TRIGGER audit_articulo_insert
AFTER INSERT ON articulo
FOR EACH ROW
BEGIN
    DECLARE usuario VARCHAR(50) DEFAULT 'SYSTEM'; -- Puedes ajustar esto para obtener el usuario actual

    -- Insertar un registro en la tabla de auditoría
    INSERT INTO auditoria (tabla_nombre, id_registro, fecha_modificacion, usuario_modificacion, tipo_cambio, campos_modificados)
    VALUES ('articulo', NEW.id_articulo, NOW(), usuario, 'INSERT', CONCAT(
        'name: ', NEW.name,
        ', sale_price: ', NEW.sale_price,
        ', purchase_price: ', NEW.purchase_price,
        ', barcode: ', NEW.barcode
    ));
END //

-- Trigger para eliminación en la tabla articulo
CREATE TRIGGER audit_articulo_delete
AFTER DELETE ON articulo
FOR EACH ROW
BEGIN
    DECLARE usuario VARCHAR(50) DEFAULT 'SYSTEM'; -- Puedes ajustar esto para obtener el usuario actual

    -- Insertar un registro en la tabla de auditoría
    INSERT INTO auditoria (tabla_nombre, id_registro, fecha_modificacion, usuario_modificacion, tipo_cambio, campos_modificados)
    VALUES ('articulo', OLD.id_articulo, NOW(), usuario, 'DELETE', CONCAT(
        'name: ', OLD.name,
        ', sale_price: ', OLD.sale_price,
        ', purchase_price: ', OLD.purchase_price,
        ', barcode: ', OLD.barcode
    ));
END //

DELIMITER ;

-- Inserción de datos: La tabla stock, catalogo y auditoría se cargan mediante los triggers.

-- Utilizar el esquema moradita
USE moradita;

-- Insertar datos en la tabla IVA
INSERT INTO iva (name, value) VALUES
('IVA 22%', 22.00),
('IVA 10%', 10.00),
('IVA Exento', 0.00);

-- Insertar datos en la tabla categoría de artículo
INSERT INTO categoria_articulo (name) VALUES
('Electrodomésticos'),
('Alimentos'),
('Libros'),
('Ropa'),
('Hogar'),
('Juguetes'),
('Deportes'),
('Belleza'),
('Salud'),
('Tecnología');

-- Insertar datos en la tabla proveedor
INSERT INTO proveedor (name, email, address, phone_number, bank, bank_account_number, currency, payment_deadline) VALUES
('ElectroHogar SA', 'contacto@electrohogar.com', 'Av. Principal 123', '099123456', 'Banco Nacional', '001122334455', 'UYU', 30),
('Alimentos del Sur', 'ventas@alimentosdelsur.com', 'Calle del Mercado 456', '099654321', 'Banco Comercial', '006677889900', 'UYU', 30),
('Librería El Saber', 'info@libreriaelsaber.com', 'Calle de los Libros 789', '099987654', 'Banco de la República', '009988776655', 'UYU', 30),
('Ropa Trendy', 'contacto@ropatrendy.com', 'Av. Ropa 123', '099321654', 'Banco Nacional', '001122334456', 'UYU', 30),
('Hogar y Más', 'info@hogarymas.com', 'Calle del Hogar 789', '099654789', 'Banco Comercial', '006677889901', 'UYU', 30),
('Juguetes Fantásticos', 'ventas@juguetesfantasticos.com', 'Calle de los Juguetes 456', '099987321', 'Banco de la República', '009988776656', 'UYU', 30);

-- Insertar datos en la tabla artículo
INSERT INTO articulo (name, id_iva, sale_price, purchase_price, barcode, id_categoria_articulo, id_proveedor) VALUES
('Heladera', 1, 50000.00, 45000.00, '1234567890123', 1, 1),
('Leche', 2, 30.00, 25.00, '1234567890126', 2, 2),
('Libro de Historia', 3, 400.00, 350.00, '1234567890129', 3, 3),
('Camisa de Algodón', 2, 1500.00, 1200.00, '1234567890130', 4, 4),
('Sofá de Cuero', 1, 15000.00, 12000.00, '1234567890131', 5, 5),
('Muñeca Barbie', 2, 800.00, 600.00, '1234567890132', 6, 6),
('Balón de Fútbol', 2, 600.00, 500.00, '1234567890133', 7, 6),
('Shampoo Nutritivo', 3, 350.00, 300.00, '1234567890134', 8, 4),
('Vitaminas C', 3, 600.00, 500.00, '1234567890135', 9, 5),
('Laptop Gaming', 1, 50000.00, 45000.00, '1234567890136', 10, 1);

-- Insertar datos en la tabla orden de compra
INSERT INTO orden_de_compra (id_articulo, name, order_date, quantity, purchase_price, barcode, id_proveedor, id_iva, document_number) VALUES
(1, 'Heladera', '2024-06-01', 20, 45000.00, '1234567890123', 1, 1, 'ORD123456'),
(2, 'Leche', '2024-06-02', 1000, 25.00, '1234567890126', 2, 2, 'ORD123457'),
(3, 'Libro de Historia', '2024-06-03', 20, 350.00, '1234567890129', 3, 3, 'ORD123458'),
(4, 'Camisa de Algodón', '2024-06-04', 50, 1200.00, '1234567890130', 4, 2, 'ORD123459'),
(5, 'Sofá de Cuero', '2024-06-05', 10, 12000.00, '1234567890131', 5, 1, 'ORD123460'),
(6, 'Muñeca Barbie', '2024-06-06', 100, 600.00, '1234567890132', 6, 2, 'ORD123461'),
(7, 'Balón de Fútbol', '2024-06-07', 200, 500.00, '1234567890133', 6, 2, 'ORD123462'),
(8, 'Shampoo Nutritivo', '2024-06-08', 300, 300.00, '1234567890134', 4, 3, 'ORD123463'),
(9, 'Vitaminas C', '2024-06-09', 150, 500.00, '1234567890135', 5, 3, 'ORD123464'),
(10, 'Laptop Gaming', '2024-06-10', 15, 45000.00, '1234567890136', 1, 1, 'ORD123465');

-- Insertar datos en la tabla recibo de mercadería
INSERT INTO recibo_de_mercaderia (id_articulo, name, barcode, id_orden_de_compra, quantity, purchase_price, receipt_date, id_proveedor, id_iva) VALUES
(1, 'Heladera', '1234567890123', 1, 10, 45000.00, '2024-06-05', 1, 1),
(2, 'Leche','1234567890126', 2, 1000, 25.00, '2024-06-06', 2, 2),
(3, 'Libro de Historia','1234567890129', 3, 20, 350.00, '2024-06-07', 3, 3),
(4, 'Camisa de Algodón', '1234567890130', 4, 50, 1200.00, '2024-06-08', 4, 2),
(5, 'Sofá de Cuero', '1234567890131', 5, 10, 12000.00, '2024-06-09', 5, 1),
(6, 'Muñeca Barbie', '1234567890132', 6, 100, 600.00, '2024-06-10', 6, 2),
(7, 'Balón de Fútbol', '1234567890133', 7, 200, 500.00, '2024-06-11', 6, 2),
(8, 'Shampoo Nutritivo', '1234567890134', 8, 300, 300.00, '2024-06-12', 4, 3),
(9, 'Vitaminas C', '1234567890135', 9, 150, 500.00, '2024-06-13', 5, 3),
(10, 'Laptop Gaming', '1234567890136', 10, 15, 45000.00, '2024-06-14', 1, 1);

-- Insertar datos en la tabla compras
INSERT INTO compras (id_articulo, name, id_orden_de_compra, id_recibo_de_mercaderia, quantity, purchase_price, barcode, purchase_date, id_proveedor, id_iva, document_number) VALUES
(1, 'Heladera', 1, 1, 10, 45000.00, '1234567890123', '2024-06-05', 1, 1, 'COMP123456'),
(2, 'Leche', 2, 2, 1000, 25.00, '1234567890126', '2024-06-06', 2, 2, 'COMP123457'),
(3, 'Libro de Historia', 3, 3, 20, 350.00, '1234567890129', '2024-06-07', 3, 3, 'COMP123458'),
(4, 'Camisa de Algodón', 4, 4, 50, 1200.00, '1234567890130', '2024-06-08', 4, 2, 'COMP123459'),
(5, 'Sofá de Cuero', 5, 5, 10, 12000.00, '1234567890131', '2024-06-09', 5, 1, 'COMP123460'),
(6, 'Muñeca Barbie', 6, 6, 100, 600.00, '1234567890132', '2024-06-10', 6, 2, 'COMP123461'),
(7, 'Balón de Fútbol', 7, 7, 200, 500.00, '1234567890133', '2024-06-11', 6, 2, 'COMP123462'),
(8, 'Shampoo Nutritivo', 8, 8, 300, 300.00, '1234567890134', '2024-06-12', 4, 3, 'COMP123463'),
(9, 'Vitaminas C', 9, 9, 150, 500.00, '1234567890135', '2024-06-13', 5, 3, 'COMP123464'),
(10, 'Laptop Gaming', 10, 10, 15, 45000.00, '1234567890136', '2024-06-14', 1, 1, 'COMP123465');

-- Insertar datos en la tabla cliente
INSERT INTO cliente (first_name, last_name, birthday, email, city, neighborhood, address, address_number, phone_number, document_type, document_number, gender) VALUES
('Ana', 'Gómez', '1990-05-15', 'ana.gomez@cliente.com', 'Montevideo', 'Centro', 'Calle Falsa', '123', '099123456', 'Cédula', '12345678', 'M'),
('Carlos', 'Martínez', '1985-09-20', 'carlos.martinez@cliente.com', 'Montevideo', 'Pocitos', 'Avenida Brasil', '456', '099654321', 'Cédula', '87654321', 'H'),
('Laura', 'Fernández', '1992-11-30', 'laura.fernandez@cliente.com', 'Montevideo', 'Buena Vista', 'Calle del Sol', '789', '099987654', 'Cédula', '11223344', 'M'),
('Sofía', 'Méndez', '1988-03-12', 'sofia.mendez@cliente.com', 'Montevideo', 'Cordón', 'Calle del Trabajo', '321', '099321987', 'Cédula', '22334455', 'M'),
('Martín', 'Rodríguez', '1979-07-25', 'martin.rodriguez@cliente.com', 'Montevideo', 'Malvín', 'Calle del Mar', '654', '099654987', 'Cédula', '33445566', 'H'),
('Valentina', 'Pérez', '1995-01-10', 'valentina.perez@cliente.com', 'Montevideo', 'Villa Biarritz', 'Calle Nueva', '987', '099987654', 'Cédula', '44556677', 'M');

-- Insertar datos en la tabla venta
INSERT INTO venta (id_articulo, name, quantity, sale_price, payment_method, bank, bank_account_number, currency, id_cliente, id_iva, document_number, fecha) VALUES
(1, 'Heladera', 2, 50000.00, 'Tarjeta de Crédito', 'Banco Nacional', '001122334455', 'UYU', 1, 1, 'VENT123456', '2024-08-01'),
(2, 'Leche', 50, 30.00, 'Efectivo', NULL, NULL, 'UYU', 2, 2, 'VENT123457', '2024-08-02'),
(2, 'Leche', 100, 30.00, 'Efectivo', NULL, NULL, 'UYU', 3, 2, 'VENT123458', '2024-08-03'),
(3, 'Libro de Historia', 5, 400.00, 'Transferencia Bancaria', 'Banco de la República', '009988776655', 'UYU', 3, 3, 'VENT123459', '2024-08-04'),
(4, 'Camisa de Algodón', 3, 1500.00, 'Tarjeta de Crédito', 'Banco Nacional', '001122334456', 'UYU', 4, 2, 'VENT123460', '2024-07-01'),
(5, 'Sofá de Cuero', 1, 15000.00, 'Efectivo', NULL, NULL, 'UYU', 5, 1, 'VENT123461', '2024-07-02'),
(6, 'Muñeca Barbie', 2, 800.00, 'Transferencia Bancaria', 'Banco de la República', '009988776656', 'UYU', 6, 2, 'VENT123462', '2024-07-03'),
(7, 'Balón de Fútbol', 6, 600.00, 'Efectivo', NULL, NULL, 'UYU', 6, 2, 'VENT123463', '2024-07-04'),
(8, 'Shampoo Nutritivo', 8, 350.00, 'Tarjeta de Crédito', 'Banco Nacional', '001122334457', 'UYU', 4, 3, 'VENT123464', '2024-07-05'),
(9, 'Vitaminas C', 4, 600.00, 'Transferencia Bancaria', 'Banco de la República', '009988776657', 'UYU', 5, 3, 'VENT123465', '2024-07-06'),
(10, 'Laptop Gaming', 1, 50000.00, 'Tarjeta de Crédito', 'Banco Nacional', '001122334458', 'UYU', 1, 1, 'VENT123466', '2024-07-07');


-- Creación de funciones.

-- 1) Cálculo de IVA

DELIMITER //

CREATE FUNCTION calcular_iva(id_ticket INT, id_articulo INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_price DECIMAL(10, 2);
    DECLARE value_iva DECIMAL(5, 2);

    -- Obtener el precio final y el porcentaje de IVA desde la tabla ivas
    SELECT v.total_price, i.value
    INTO total_price, value_iva
    FROM venta v
    JOIN iva i ON v.id_iva = i.id_iva
    WHERE v.id_ticket = id_ticket
      AND v.id_articulo = id_articulo
    LIMIT 1;

    -- Calcular y devolver el IVA
    RETURN total_price * (value_iva/100);
END //

DELIMITER ;

SELECT id_ticket, id_articulo, total_price, calcular_iva(id_ticket, id_articulo) AS iva
FROM venta;

-- 2) Función para tener el precio redondeado.

DELIMITER //

CREATE FUNCTION redondear_precio(precio DECIMAL(10, 0))
RETURNS DECIMAL(10, 0)
DETERMINISTIC
BEGIN
    RETURN ROUND(precio, 0);
END //

DELIMITER ;

SELECT id_ticket, name, quantity, sale_price, redondear_precio(total_price) AS total_price_redondeado
FROM venta;

-- Stored Procedures:

-- 1) Procedimiento Almacenado para Actualizar el Precio y el Costo de un Artículo. También da la opción de actualizar todos los artículos del proveedor a X precio de compra e Y de venta o modificarlos el mismo porcentaje de forma masiva.

DELIMITER //

CREATE PROCEDURE actualizar_precio_costo(
    IN p_id_articulo INT,
    IN p_id_proveedor INT,
    IN p_modificar_por VARCHAR(10), -- 'FIJO' o 'PORCENTAJE'
    IN p_nuevo_precio DECIMAL(10, 2),
    IN p_nuevo_costo DECIMAL(10, 2),
    IN p_aplicar_a_todos BOOLEAN -- TRUE para aplicar a todos los artículos de un proveedor
)
BEGIN
    IF p_aplicar_a_todos THEN
        -- Actualizar todos los artículos del proveedor
        IF p_modificar_por = 'FIJO' THEN
            UPDATE articulo
            SET sale_price = ROUND(p_nuevo_precio, 2),
                purchase_price = ROUND(p_nuevo_costo, 2)
            WHERE id_proveedor = p_id_proveedor;

        ELSEIF p_modificar_por = 'PORCENTAJE' THEN
            UPDATE articulo
            SET sale_price = ROUND(sale_price * (1 + p_nuevo_precio / 100), 2),
                purchase_price = ROUND(purchase_price * (1 + p_nuevo_costo / 100), 2)
            WHERE id_proveedor = p_id_proveedor;

        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Modo de modificación inválido. Use "FIJO" o "PORCENTAJE".';
        END IF;

    ELSE
        -- Actualizar solo el artículo específico
        IF p_modificar_por = 'FIJO' THEN
            UPDATE articulo
            SET sale_price = ROUND(p_nuevo_precio, 2),
                purchase_price = ROUND(p_nuevo_costo, 2)
            WHERE id_articulo = p_id_articulo;

        ELSEIF p_modificar_por = 'PORCENTAJE' THEN
            UPDATE articulo
            SET sale_price = ROUND(sale_price * (1 + p_nuevo_precio / 100), 2),
                purchase_price = ROUND(purchase_price * (1 + p_nuevo_costo / 100), 2)
            WHERE id_articulo = p_id_articulo;

        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Modo de modificación inválido. Use "FIJO" o "PORCENTAJE".';
        END IF;
    END IF;
END //

DELIMITER ;



CALL actualizar_precio_costo(1, NULL, 'FIJO', 600.00, 450.00, FALSE);
CALL actualizar_precio_costo(1, NULL, 'PORCENTAJE', 10, 5, FALSE);
CALL actualizar_precio_costo(NULL, 2, 'FIJO', 200.00, 150.00, TRUE);
CALL actualizar_precio_costo(NULL, 2, 'PORCENTAJE', 8, 3, TRUE);


-- 2) Procedimiento Almacenado para Generar el Reporte Mensual de Ventas:

DELIMITER //

CREATE PROCEDURE generar_reporte_ventas_mensual(IN p_mes INT, IN p_anio INT)
BEGIN
    SELECT 
        CONCAT(p_anio, '-', LPAD(p_mes, 2, '0')) AS mes,
        ROUND(SUM(total_price), 2) AS total_ventas,
        ROUND(SUM(total_price * (i.value / 100)), 2) AS total_iva
    FROM 
        venta v
    JOIN 
        iva i ON v.id_iva = i.id_iva
    WHERE 
        MONTH(v.fecha) = p_mes
        AND YEAR(v.fecha) = p_anio
    GROUP BY 
        YEAR(v.fecha), MONTH(v.fecha);
END //

DELIMITER ;


CALL generar_reporte_ventas_mensual(8, 2024);

-- Vistas:

-- 1) Vista para ver los distintos SKUs.

USE moradita;

create or replace view sku as 
select distinct a.id_articulo,a.name from articulo a;

select * from sku;

-- 2) Vista para ver los SKUs vendidos, cantidad de unidades e importe.

CREATE OR REPLACE VIEW ventas_por_sku AS
SELECT
    a.id_articulo,
    a.name AS descripcion_del_articulo,
    SUM(v.quantity) AS cantidad_de_ventas,
    SUM(v.quantity * v.sale_price) AS total_price
FROM
    articulo a
JOIN
    venta v ON a.id_articulo = v.id_articulo
GROUP BY
    a.id_articulo, a.name
ORDER BY
    total_price DESC;


select * from ventas_por_sku;

-- 3) Vista para ver los SKUs vendidos y Clientes diferentes que compraron
CREATE OR REPLACE VIEW ventas_por_sku_clientes AS
SELECT
    a.id_articulo,
    a.name AS descripcion_del_articulo,
    COUNT(DISTINCT v.id_cliente) AS clientes_diferentes
FROM
    articulo a
JOIN
    venta v ON a.id_articulo = v.id_articulo
GROUP BY
    a.id_articulo
ORDER BY
    clientes_diferentes DESC;


select * from ventas_por_sku_clientes;

-- 4) Vista para saber cuanto pagar por cada tipo de IVA por mes:

CREATE VIEW iva_por_mes AS
SELECT 
    YEAR(v.fecha) AS anio,
    MONTH(v.fecha) AS mes,
    ROUND(SUM(v.total_price * (i.value / 100)),2) AS total_iva_a_pagar
FROM 
    venta v
JOIN 
    iva i ON v.id_iva = i.id_iva
GROUP BY 
    YEAR(v.fecha), MONTH(v.fecha);

SELECT * FROM iva_por_mes;

-- 5) Vista para ver el proveedor que más ha vendido
CREATE OR REPLACE VIEW proveedor_mas_vendido AS
SELECT
    p.name AS proveedor,
    SUM(v.quantity) AS cantidad_de_unidades_vendidas,
    SUM(v.quantity * v.sale_price) AS total_ventas
FROM
    venta v
JOIN
    articulo a ON v.id_articulo = a.id_articulo
JOIN
    proveedor p ON a.id_proveedor = p.id_proveedor
GROUP BY
    p.name
ORDER BY
    total_ventas DESC;
    
select * from proveedor_mas_vendido;

-- Bonus track: Cree un usuario que solo puede utilizar select para validar que todo haya quedado OK, comparto aquí las consultas:
-- CREATE USER coderhouse@localhost identified BY '123';
-- GRANT SELECT ON moradita.* TO coderhouse1@localhost;
-- use mysql;
-- select * from user;


USE moradita;
select * from articulo;
select * from catalogo;
select * from categoria_articulo;
select * from cliente;
select * from compras;
select * from iva;
select * from orden_de_compra;
select * from proveedor;
select * from recibo_de_mercaderia;
select * from stock;
select * from venta;
select * from auditoria;
