-- Crear el esquema Moradita
DROP DATABASE IF EXISTS moradita_proyecto_final;
CREATE DATABASE moradita_proyecto_final;

-- Utilizar el esquema creado
USE moradita_proyecto_final;

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

-- Crear tabla iva
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

-- Crear tabla depósito
CREATE TABLE deposito (
    id_deposito INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    description TEXT
);

-- Crear tabla orden de compra
CREATE TABLE orden_de_compra (
    id_orden_de_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    id_proveedor INT NOT NULL,
    id_iva INT NOT NULL,
    id_deposito INT NOT NULL,
    document_number VARCHAR(40) NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva),
    FOREIGN KEY (id_deposito) REFERENCES deposito(id_deposito)
);

-- Crear tabla recibo de mercadería
CREATE TABLE recibo_de_mercaderia (
    id_recibo_de_mercaderia INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    id_orden_de_compra INT NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    receipt_date DATE NOT NULL,
    id_proveedor INT NOT NULL,
    id_iva INT NOT NULL,
    id_deposito INT NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_orden_de_compra) REFERENCES orden_de_compra(id_orden_de_compra),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva),
    FOREIGN KEY (id_deposito) REFERENCES deposito(id_deposito)
);

-- Crear tabla compras
CREATE TABLE compra (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    id_orden_de_compra INT NOT NULL,
    id_recibo_de_mercaderia INT NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    purchase_date DATE NOT NULL,
    id_proveedor INT NOT NULL,
    id_iva INT NOT NULL,
    id_deposito INT NOT NULL,
    document_number VARCHAR(40) NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_orden_de_compra) REFERENCES orden_de_compra(id_orden_de_compra),
    FOREIGN KEY (id_recibo_de_mercaderia) REFERENCES recibo_de_mercaderia(id_recibo_de_mercaderia),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva),
    FOREIGN KEY (id_deposito) REFERENCES deposito(id_deposito)
);


-- Crear tabla stock
CREATE TABLE stock (
    id_articulo INT NOT NULL,
    id_deposito INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_deposito) REFERENCES deposito(id_deposito)
);

-- Crear tabla cliente
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthday DATE,
    email VARCHAR(100),
    city VARCHAR(50),
    neighborhood VARCHAR(50),
    address VARCHAR(255),
    address_number VARCHAR(20),
    phone_number VARCHAR(20),
    document_type VARCHAR(20),
    document_number VARCHAR(20) UNIQUE,
    gender ENUM('M', 'H', 'Otro') NOT NULL
);

-- Crear tabla tipo de movimiento
CREATE TABLE tipo_de_movimiento (
    id_tipo_de_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(40) NOT NULL
);

-- Crear tabla venta
CREATE TABLE venta (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    quantity INT NOT NULL,
    sale_price DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    bank VARCHAR(50),
    bank_account_number VARCHAR(50),
    currency VARCHAR(10) NOT NULL,
    id_cliente INT NOT NULL,
    id_iva INT NOT NULL,
    id_deposito INT NOT NULL,
    id_tipo_de_movimiento INT NOT NULL,
    document_number VARCHAR(40) NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva),
    FOREIGN KEY (id_deposito) REFERENCES deposito(id_deposito),
    FOREIGN KEY (id_tipo_de_movimiento) REFERENCES tipo_de_movimiento(id_tipo_de_movimiento)
);


-- Crear tabla promociones
CREATE TABLE promociones (
    id_promocion INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(255) NOT NULL,
    discount_percentage DECIMAL(5, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- Crear tabla articulo_promocion
CREATE TABLE articulo_promocion (
    id_articulo INT NOT NULL,
    id_promocion INT NOT NULL,
    PRIMARY KEY (id_articulo, id_promocion),
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_promocion) REFERENCES promociones(id_promocion)
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

-- Crear tabla historial_cambios_precios
CREATE TABLE historial_cambios_precios (
    id_cambio INT PRIMARY KEY AUTO_INCREMENT,
    id_articulo INT NOT NULL,
    fecha_cambio DATE NOT NULL,
    precio_anterior DECIMAL(10, 2) NOT NULL,
    precio_nuevo DECIMAL(10, 2) NOT NULL,
    motivo_cambio VARCHAR(100),
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo)
);

-- 1) Trigger para aumentar el stock con recepción de mercadería
DELIMITER //

CREATE TRIGGER after_recibo_de_mercaderia_insert
AFTER INSERT ON recibo_de_mercaderia
FOR EACH ROW
BEGIN
    -- Intentar actualizar el stock si ya existe
    UPDATE stock
    SET quantity = quantity + NEW.quantity
    WHERE id_articulo = NEW.id_articulo AND id_deposito = NEW.id_deposito;

    -- Si no se actualizó ninguna fila, significa que no existe ese artículo en el stock, por lo que se inserta uno nuevo
    IF ROW_COUNT() = 0 THEN
        INSERT INTO stock (id_articulo, id_deposito, quantity)
        VALUES (NEW.id_articulo, NEW.id_deposito, NEW.quantity);
    END IF;
END //

DELIMITER ;

-- 2) Trigger para reducir el stock con venta de mercadería y aumentarlo ante una devolución.

DELIMITER //

CREATE TRIGGER after_venta_insert
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    -- Verificar el tipo de movimiento
    IF NEW.id_tipo_de_movimiento = 1 THEN
        -- Tipo de movimiento: Venta
        -- Verificar que el stock no quede en negativo
        IF (SELECT quantity FROM stock WHERE id_articulo = NEW.id_articulo AND id_deposito = NEW.id_deposito) >= NEW.quantity THEN
            -- Reducir el stock
            UPDATE stock
            SET quantity = quantity - NEW.quantity
            WHERE id_articulo = NEW.id_articulo AND id_deposito = NEW.id_deposito;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Stock insuficiente para realizar la venta.';
        END IF;
    ELSEIF NEW.id_tipo_de_movimiento = 2 THEN
        -- Tipo de movimiento: Devolución de Venta
        -- Aumentar el stock
        UPDATE stock
        SET quantity = quantity + NEW.quantity
        WHERE id_articulo = NEW.id_articulo AND id_deposito = NEW.id_deposito;
    END IF;
END //

DELIMITER ;


-- Trigger de auditoría de cambios en los artículos
DELIMITER //

-- 3) Trigger para actualización en la tabla articulo
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

-- 4) Trigger para inserción en la tabla articulo
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

-- 5) Trigger para eliminación en la tabla articulo
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

-- 5) Trigger para actualización de la tabla historial_cambios_precios

DELIMITER //

CREATE TRIGGER after_articulo_update
AFTER UPDATE ON articulo
FOR EACH ROW
BEGIN
    -- Insertar en historial_cambios_precios si el precio de venta o el precio de compra cambia
    IF OLD.sale_price <> NEW.sale_price OR OLD.purchase_price <> NEW.purchase_price THEN
        INSERT INTO historial_cambios_precios (
            id_articulo,
            fecha_cambio,
            precio_anterior,
            precio_nuevo,
            motivo_cambio
        ) VALUES (
            OLD.id_articulo,
            NOW(),
            OLD.sale_price,
            NEW.sale_price,
            'Actualización de precio en la tabla articulo'
        );
    END IF;
END //

DELIMITER ;

-- Insertar Datos:

-- Proveedor
INSERT INTO proveedor (name, email, address, phone_number, bank, bank_account_number, currency, payment_deadline) VALUES 
('Proveedor A', 'contacto@proveedora.com', 'Av. Libertador 1000, Montevideo', '+598 1234 5678', 'Banco República', '123-456-7890', 'UYU', 30),
('Proveedor B', 'ventas@proveedorb.com', 'Calle 25 de Agosto 2345, Montevideo', '+598 2345 6789', 'Santander', '234-567-8901', 'UYU', 45),
('Proveedor C', 'info@proveedorc.com', 'Av. Italia 456, Montevideo', '+598 3456 7890', 'BBVA', '345-678-9012', 'UYU', 60),
('Proveedor D', 'contacto@proveedord.com', 'Calle San José 6789, Montevideo', '+598 4567 8901', 'Itaú', '456-789-0123', 'UYU', 15),
('Proveedor E', 'ventas@proveedore.com', 'Av. 18 de Julio 1234, Montevideo', '+598 5678 9012', 'Scotiabank', '567-890-1234', 'UYU', 30),
('Proveedor F', 'info@proveedorf.com', 'Calle 18 de Julio 5678, Montevideo', '+598 6789 0123', 'Banco República', '678-901-2345', 'UYU', 90),
('Proveedor G', 'contacto@proveedorg.com', 'Av. 21 de Setiembre 910, Montevideo', '+598 7890 1234', 'Santander', '789-012-3456', 'UYU', 45),
('Proveedor H', 'ventas@proveedorh.com', 'Calle 21 de Setiembre 2345, Montevideo', '+598 8901 2345', 'BBVA', '890-123-4567', 'UYU', 60),
('Proveedor I', 'info@proveedori.com', 'Calle Cerrito 345, Montevideo', '+598 9012 3456', 'Itaú', '901-234-5678', 'UYU', 30),
('Proveedor J', 'contacto@proveedoj.com', 'Av. Rivera 678, Montevideo', '+598 1234 5679', 'Scotiabank', '012-345-6789', 'UYU', 15);

-- Insertar datos en la tabla depósito
INSERT INTO deposito (name, description) VALUES
('Depósito Central', 'Depósito principal de la empresa ubicado en Montevideo.'),
('Depósito Pocitos', 'Depósito en la zona de Pocitos, Montevideo.'),
('Depósito Ciudad Vieja', 'Depósito en el centro histórico de Montevideo.'),
('Depósito Carrasco', 'Depósito en la zona de Carrasco, Montevideo.'),
('Depósito Malvín', 'Depósito en la zona de Malvín, Montevideo.'),
('Depósito Parque Batlle', 'Depósito en la zona de Parque Batlle, Montevideo.'),
('Depósito Buceo', 'Depósito en la zona de Buceo, Montevideo.'),
('Depósito Tres Cruces', 'Depósito cerca de la terminal de Tres Cruces, Montevideo.'),
('Depósito La Blanqueada', 'Depósito en la zona de La Blanqueada, Montevideo.'),
('Depósito Web', 'Depósito exclusivo para operaciones web y e-commerce.');

-- Categoría
INSERT INTO categoria_articulo (name) VALUES 
('Electrónica'),
('Ropa'),
('Muebles'),
('Juguetes'),
('Calzado'),
('Cuidado Personal'),
('Hogar'),
('Deportes'),
('Libros'),
('Alimentos');

-- IVA
INSERT INTO iva (name, value) VALUES 
('22%', 22.00),
('10%', 10.00),
('0%', 0.00);

-- Artículo
INSERT INTO articulo (name, id_iva, sale_price, purchase_price, barcode, id_categoria_articulo, id_proveedor) VALUES 
('Televisor LED', 1, 15000.00, 10000.00, '1234567890123', 1, 1),
('Camiseta', 2, 1200.00, 800.00, '2345678901234', 2, 2),
('Sofa', 1, 35000.00, 25000.00, '3456789012345', 3, 3),
('Pelota de fútbol', 2, 800.00, 600.00, '4567890123456', 8, 4),
('Zapatos deportivos', 2, 2000.00, 1500.00, '5678901234567', 5, 5),
('Shampoo', 3, 300.00, 200.00, '6789012345678', 6, 6),
('Mesa de comedor', 1, 45000.00, 35000.00, '7890123456789', 7, 7),
('Raqueta de tenis', 2, 1500.00, 1200.00, '8901234567890', 8, 8),
('Novela', 2, 500.00, 350.00, '9012345678901', 9, 9),
('Galletas', 3, 200.00, 150.00, '0123456789012', 10, 10),
('Monitor', 1, 12000.00, 9000.00, '1234567890124', 1, 1),
('Camisa', 2, 1500.00, 1000.00, '2345678901235', 2, 2),
('Espejo', 1, 5000.00, 3500.00, '3456789012346', 7, 3),
('Barbacoa', 1, 25000.00, 20000.00, '4567890123457', 7, 4),
('Lámpara', 1, 1500.00, 1200.00, '5678901234568', 7, 5);

-- Insertar datos en orden_de_compra
INSERT INTO orden_de_compra (id_articulo, order_date, quantity, purchase_price, id_proveedor, id_iva, id_deposito, document_number) VALUES 
(1, '2024-01-10', 20, 10000.00, 1, 1, 1, 'ORD001'),
(2, '2024-01-15', 30, 1500.00, 2, 1, 2, 'ORD002'),
(3, '2024-02-01', 25, 25000.00, 3, 2, 3, 'ORD003'),
(4, '2024-02-05', 10, 600.00, 4, 1, 4, 'ORD004'),
(5, '2024-02-20', 35, 1200.00, 5, 2, 5, 'ORD005'),
(6, '2024-03-05', 15, 2000.00, 6, 2, 6, 'ORD006'),
(7, '2024-03-15', 20, 35000.00, 7, 1, 7, 'ORD007'),
(8, '2024-04-01', 10, 800.00, 8, 1, 8, 'ORD008'),
(9, '2024-04-15', 30, 1000.00, 9, 2, 9, 'ORD009'),
(10, '2024-05-01', 75, 3000.00, 10, 2, 10, 'ORD010'),
(11, '2024-05-10', 22, 11000.00, 1, 1, 1, 'ORD011'),
(12, '2024-06-01', 18, 1800.00, 2, 1, 2, 'ORD012'),
(13, '2024-06-15', 20, 27000.00, 3, 2, 3, 'ORD013'),
(14, '2024-07-01', 28, 650.00, 4, 1, 4, 'ORD014'),
(15, '2024-07-15', 12, 1300.00, 5, 2, 5, 'ORD015'),
(1, '2024-08-01', 30, 2200.00, 6, 2, 6, 'ORD016'),
(2, '2024-08-15', 25, 36000.00, 7, 1, 7, 'ORD017'),
(3, '2024-09-01', 15, 900.00, 8, 1, 8, 'ORD018'),
(4, '2024-09-15', 12, 3200.00, 9, 2, 9, 'ORD019'),
(5, '2024-10-01', 30, 3100.00, 10, 2, 10, 'ORD020'),
(6, '2024-10-15', 20, 10500.00, 1, 1, 1, 'ORD021'),
(7, '2024-11-01', 25, 2000.00, 2, 1, 2, 'ORD022'),
(8, '2024-11-15', 28, 26000.00, 3, 2, 3, 'ORD023'),
(9, '2024-12-01', 15, 700.00, 4, 1, 4, 'ORD024'),
(10, '2024-12-15', 12, 1200.00, 5, 2, 5, 'ORD025'),
(11, '2024-12-20', 30, 2500.00, 6, 2, 6, 'ORD026'),
(12, '2024-12-25', 22, 37000.00, 7, 1, 7, 'ORD027'),
(13, '2024-12-30', 15, 1100.00, 8, 2, 8, 'ORD028'),
(14, '2024-12-31', 18, 4000.00, 9, 1, 9, 'ORD029'),
(15, '2024-12-31', 25, 1500.00, 10, 2, 10, 'ORD030');

-- Insertar datos en recibo_de_mercaderia
INSERT INTO recibo_de_mercaderia (id_articulo, id_orden_de_compra, quantity, purchase_price, receipt_date, id_proveedor, id_iva, id_deposito) VALUES 
(1, 1, 15, 7500.00, '2024-01-15', 1, 1, 1),
(2, 2, 20, 1000.00, '2024-01-18', 2, 1, 2),
(3, 3, 20, 20000.00, '2024-02-10', 3, 2, 3),
(4, 4, 8, 480.00, '2024-02-12', 4, 1, 4),
(5, 5, 30, 1200.00, '2024-02-22', 5, 2, 5),
(6, 6, 12, 1600.00, '2024-03-10', 6, 2, 6),
(7, 7, 18, 31500.00, '2024-03-18', 7, 1, 7),
(8, 8, 8, 640.00, '2024-04-05', 8, 1, 8),
(9, 9, 25, 833.33, '2024-04-18', 9, 2, 9),
(10, 10, 30, 2400.00, '2024-05-10', 10, 2, 10),
(11, 11, 18, 9000.00, '2024-05-20', 1, 1, 1),
(12, 12, 15, 1500.00, '2024-06-10', 2, 1, 2),
(13, 13, 18, 24300.00, '2024-06-20', 3, 2, 3),
(14, 14, 25, 650.00, '2024-07-10', 4, 1, 4),
(15, 15, 10, 1300.00, '2024-07-20', 5, 2, 5),
(1, 16, 25, 1750.00, '2024-08-10', 6, 2, 6),
(2, 17, 20, 28800.00, '2024-08-20', 7, 1, 7),
(3, 18, 12, 720.00, '2024-09-10', 8, 1, 8),
(4, 19, 10, 1600.00, '2024-09-20', 9, 2, 9),
(5, 20, 25, 2600.00, '2024-10-10', 10, 2, 10),
(6, 21, 15, 7875.00, '2024-10-20', 1, 1, 1),
(7, 22, 20, 2000.00, '2024-11-10', 2, 1, 2),
(8, 23, 25, 19500.00, '2024-11-20', 3, 2, 3),
(9, 24, 12, 420.00, '2024-12-05', 4, 1, 4),
(10, 25, 10, 1200.00, '2024-12-15', 5, 2, 5),
(11, 26, 25, 2500.00, '2024-12-20', 6, 2, 6),
(12, 27, 20, 37000.00, '2024-12-25', 7, 1, 7),
(13, 28, 12, 1100.00, '2024-12-27', 8, 2, 8),
(14, 29, 15, 3000.00, '2024-12-28', 9, 1, 9),
(15, 30, 20, 1200.00, '2024-12-30', 10, 2, 10);

-- Insertar datos en compras
INSERT INTO compra (id_articulo, id_recibo_de_mercaderia, id_orden_de_compra, quantity, purchase_price, purchase_date, id_proveedor, id_iva, id_deposito, document_number) VALUES 
(1, 1, 1, 15, 7500.00, '2024-01-18', 1, 1, 1, 'COMP001'),
(2, 2, 2, 20, 1000.00, '2024-01-25', 2, 1, 2, 'COMP002'),
(3, 3, 3, 20, 20000.00, '2024-02-15', 3, 2, 3, 'COMP003'),
(4, 4, 4, 8, 480.00, '2024-02-20', 4, 1, 4, 'COMP004'),
(5, 5, 5, 30, 1200.00, '2024-02-28', 5, 2, 5, 'COMP005'),
(6, 6, 6, 12, 1600.00, '2024-03-25', 6, 2, 6, 'COMP006'),
(7, 7, 7, 18, 31500.00, '2024-03-30', 7, 1, 7, 'COMP007'),
(8, 8, 8, 8, 640.00, '2024-04-15', 8, 1, 8, 'COMP008'),
(9, 9, 9, 25, 833.33, '2024-04-30', 9, 2, 9, 'COMP009'),
(10, 10, 10, 30, 2400.00, '2024-05-25', 10, 2, 10, 'COMP010'),
(11, 11, 11, 18, 9000.00, '2024-06-05', 1, 1, 1, 'COMP011'),
(12, 12, 12, 15, 1500.00, '2024-06-30', 2, 1, 2, 'COMP012'),
(13, 13, 13, 18, 24300.00, '2024-07-15', 3, 2, 3, 'COMP013'),
(14, 14, 14, 25, 650.00, '2024-07-30', 4, 1, 4, 'COMP014'),
(15, 15, 15, 10, 1300.00, '2024-08-10', 5, 2, 5, 'COMP015'),
(1, 16, 16, 25, 1750.00, '2024-08-30', 6, 2, 6, 'COMP016'),
(2, 17, 17, 20, 28800.00, '2024-09-10', 7, 1, 7, 'COMP017'),
(3, 18, 18, 12, 720.00, '2024-09-30', 8, 1, 8, 'COMP018'),
(4, 19, 19, 10, 1600.00, '2024-10-10', 9, 2, 9, 'COMP019'),
(5, 20, 20, 25, 2600.00, '2024-10-30', 10, 2, 10, 'COMP020'),
(6, 21, 21, 15, 7875.00, '2024-11-20', 1, 1, 1, 'COMP021'),
(7, 22, 22, 20, 2000.00, '2024-11-30', 2, 1, 2, 'COMP022'),
(8, 23, 23, 25, 19500.00, '2024-12-05', 3, 2, 3, 'COMP023'),
(9, 24, 24, 12, 420.00, '2024-12-15', 4, 1, 4, 'COMP024'),
(10, 25, 25, 10, 1200.00, '2024-12-30', 5, 2, 5, 'COMP025'),
(11, 26, 26, 25, 2500.00, '2024-12-31', 6, 2, 6, 'COMP026'),
(12, 27, 27, 20, 37000.00, '2024-12-31', 7, 1, 7, 'COMP027'),
(13, 28, 28, 12, 1100.00, '2024-12-31', 8, 2, 8, 'COMP028'),
(14, 29, 29, 15, 3000.00, '2024-12-31', 9, 1, 9, 'COMP029'),
(15, 30, 30, 20, 1200.00, '2024-12-31', 10, 2, 10, 'COMP030');


-- Cliente
INSERT INTO cliente (first_name, last_name, birthday, email, city, neighborhood, address, address_number, phone_number, document_type, document_number, gender) VALUES 
('Ana', 'Pérez', '1985-01-15', 'ana.perez@gmail.com', 'Montevideo', 'Centro', 'Av. Brasil', '2000', '+598 1234 5678', 'Cédula', '12345678', 'M'),
('Juan', 'Gómez', '1990-02-20', 'juan.gomez@gmail.com', 'Montevideo', 'Pocitos', 'Calle Pocitos', '1000', '+598 2345 6789', 'Cédula', '23456789', 'H'),
('María', 'Fernández', '1982-03-10', 'maria.fernandez@gmail.com', 'Montevideo', 'Carrasco', 'Av. Rivera', '4000', '+598 3456 7890', 'Cédula', '34567890', 'M'),
('Luis', 'García', '1995-04-25', 'luis.garcia@gmail.com', 'Montevideo', 'El Prado', 'Calle 18 de Julio', '500', '+598 4567 8901', 'Cédula', '45678901', 'H'),
('Laura', 'Martínez', '1988-05-30', 'laura.martinez@gmail.com', 'Montevideo', 'Malvín', 'Av. Italia', '3000', '+598 5678 9012', 'Cédula', '56789012', 'M'),
('Carlos', 'Rodríguez', '1992-06-15', 'carlos.rodriguez@gmail.com', 'Montevideo', 'Montevideo', 'Calle Cerrito', '600', '+598 6789 0123', 'Cédula', '67890123', 'H'),
('Paula', 'Hernández', '1986-07-10', 'paula.hernandez@gmail.com', 'Montevideo', 'La Teja', 'Calle Uruguay', '700', '+598 7890 1234', 'Cédula', '78901234', 'M'),
('Santiago', 'Gómez', '1993-08-05', 'santiago.gomez@gmail.com', 'Montevideo', 'Centro', 'Av. San Martín', '800', '+598 8901 2345', 'Cédula', '89012345', 'H'),
('Lucía', 'Ramírez', '1984-09-20', 'lucia.ramirez@gmail.com', 'Montevideo', 'Pocitos', 'Calle Arenal Grande', '900', '+598 9012 3456', 'Cédula', '90123456', 'M'),
('Matías', 'Morales', '1991-10-10', 'matias.morales@gmail.com', 'Montevideo', 'Ciudad Vieja', 'Calle Artigas', '1000', '+598 1234 5679', 'Cédula', '01234567', 'H');

-- Tipo de Movimiento
INSERT INTO tipo_de_movimiento (descripcion) VALUES 
('Venta'),
('Devolución de Venta');

INSERT INTO promociones (description, discount_percentage, start_date, end_date) VALUES 
('Descuento de Verano - 10% en toda la tienda', 10.00, '2024-01-01', '2024-03-31'),
('Black Friday - 20% en electrónica', 20.00, '2024-11-25', '2024-11-30'),
('Promoción de Navidad - 15% en ropa', 15.00, '2024-12-01', '2024-12-31'),
('Descuento en juguetes - 25% en compras mayores a $1000', 25.00, '2024-06-01', '2024-06-30'),
('Promo Salud - 5% en suplementos vitamínicos', 5.00, '2024-05-01', '2024-05-31'),
('Oferta de Año Nuevo - 30% en muebles', 30.00, '2024-12-31', '2025-01-15'),
('Descuento por Compras Mayores - 10% en compras mayores a $5000', 10.00, '2024-07-01', '2024-07-31'),
('Descuento por Fidelidad - 15% para clientes recurrentes', 15.00, '2024-08-01', '2024-08-31');

INSERT INTO articulo_promocion (id_articulo, id_promocion) VALUES 
(1, 1),
(2, 3),
(3, 6),
(4, 7),
(5, 2),
(6, 5),
(7, 3),
(8, 6),
(9, 4),
(10, 8);

-- Venta
INSERT INTO venta (id_articulo, quantity, sale_price, payment_method, bank, bank_account_number, currency, id_cliente, id_iva, id_deposito, id_tipo_de_movimiento, document_number, fecha)
VALUES 
(1, 2, 15000.00, 'Tarjeta de crédito', 'Banco Santander', '123456789012', 'UYU', 1, 1, 1, 1, 'VEN001', '2024-02-10'),
(2, 5, 1000.00, 'Efecivo', NULL, NULL, 'UYU', 2, 2, 2, 1, 'VEN002', '2024-03-15'),
(3, 1, 25000.00, 'Transferencia bancaria', 'Banco Itaú', '987654321098', 'UYU', 3, 1, 3, 1, 'VEN003', '2024-04-20'),
(4, 2, 600.00, 'Tarjeta de crédito', 'Banco República', '11122334455', 'UYU', 4, 2, 4, 1, 'VEN004', '2024-05-22'),
(5, 3, 1500.00, 'Efectivo', NULL, NULL, 'UYU', 5, 2, 5, 1, 'VEN005', '2024-06-05'),
(6, 6, 200.00, 'Tarjeta de débito', 'Banco Santander', '543210987654', 'UYU', 6, 3, 6, 1, 'VEN006', '2024-07-10'),
(7, 3, 35000.00, 'Transferencia bancaria', 'Banco Itaú', '321098765432', 'UYU', 7, 1, 7, 1, 'VEN007', '2024-08-15'),
(8, 5, 1200.00, 'Efectivo', NULL, NULL, 'UYU', 8, 2, 8, 1, 'VEN008', '2024-09-01'),
(9, 7, 350.00, 'Tarjeta de crédito', 'Banco República', '22334455667', 'UYU', 9, 2, 9, 1, 'VEN009', '2024-06-18'),
(10, 10, 150.00, 'Efectivo', NULL, NULL, 'UYU', 10, 3, 10, 1, 'VEN010', '2024-10-05'),
(11, 7, 700.00, 'Transferencia bancaria', 'Banco Itaú', '432109876543', 'UYU', 10, 1, 1, 1, 'VEN011', '2024-11-12'),
(12, 10, 950.00, 'Tarjeta de crédito', 'Banco Santander', '654321098765', 'UYU', 9, 2, 2, 1, 'VEN012', '2024-11-22'),
(13, 4, 12000.00, 'Efectivo', NULL, NULL, 'UYU', 6, 1, 3, 1, 'VEN013', '2024-12-01'),
(14, 7, 500.00, 'Tarjeta de crédito', 'Banco República', '345678901234', 'UYU', 7, 2, 4, 1, 'VEN014', '2024-12-10'),
(15, 5, 200.00, 'Efectivo', NULL, NULL, 'UYU', 10, 3, 5, 1, 'VEN015', '2024-12-15'),
(1, 3, 15500.00, 'Tarjeta de débito', 'Banco Santander', '123098456789', 'UYU', 5, 1, 1, 1, 'VEN016', '2024-01-25'),
(1, 1, 1100.00, 'Efectivo', NULL, NULL, 'UYU', 2, 1, 1, 1, 'VEN017', '2024-02-18'),
(3, 2, 25000.00, 'Transferencia bancaria', 'Banco Itaú', '543210987654', 'UYU', 3, 1, 3, 1, 'VEN018', '2024-03-22'),
(4, 2, 580.00, 'Tarjeta de crédito', 'Banco República', '99922334455', 'UYU', 4, 2, 4, 1, 'VEN019', '2024-04-15'),
(5, 5, 1450.00, 'Efectivo', NULL, NULL, 'UYU', 5, 2, 5, 1, 'VEN020', '2024-05-30');

-- Devolución de ventas
INSERT INTO venta (id_articulo, quantity, sale_price, payment_method, bank, bank_account_number, currency, id_cliente, id_iva, id_deposito, id_tipo_de_movimiento, document_number, fecha) VALUES 
(1, 1, 15000.00, 'Tarjeta de crédito', 'Banco Santander', '123456789012', 'UYU', 1, 1, 1, 2, 'DOC011', '2024-09-16'),
(3, 1, 35000.00, 'Transferencia bancaria', 'Banco Itaú', '987654321098', 'UYU', 2, 1, 2, 2, 'DOC012', '2024-09-17'),
(5, 2, 2000.00, 'Efectivo', NULL, NULL, 'UYU', 3, 2, 3, 2, 'DOC013', '2024-09-18'),
(7, 1, 45000.00, 'Transferencia bancaria', 'Banco Itaú', '321098765432', 'UYU', 4, 1, 4, 2, 'DOC014', '2024-09-19'),
(9, 7, 500.00, 'Tarjeta de crédito', 'Banco República', '22334455667', 'UYU', 5, 2, 5, 2, 'DOC015', '2024-09-20');


-- Creación de funciones.

-- 1) Cálculo de IVA
DELIMITER //

CREATE FUNCTION calcular_iva(id_ticket INT, id_articulo INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_price DECIMAL(10, 2);
    DECLARE value_iva DECIMAL(5, 2);

    -- Obtener el precio total y el porcentaje de IVA desde la tabla venta y iva
    SELECT v.quantity * v.sale_price, i.value
    INTO total_price, value_iva
    FROM venta v
    JOIN iva i ON v.id_iva = i.id_iva
    WHERE v.id_ticket = id_ticket
      AND v.id_articulo = id_articulo
    LIMIT 1;

    -- Calcular y devolver el IVA
    RETURN total_price * (value_iva / 100);
END //

DELIMITER ;

-- 2) Función para tener el precio redondeado.
DELIMITER //

CREATE FUNCTION redondear_precio(precio DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    RETURN ROUND(precio, 2);
END //

DELIMITER ;

-- Procedimientos Almacenados:

-- 1) Procedimiento Almacenado para Actualizar el Precio y el Costo de un Artículo.
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

-- 2) Procedimiento Almacenado para Generar el Reporte Mensual de Ventas
DELIMITER //

CREATE PROCEDURE generar_reporte_ventas_mensual(IN p_mes INT, IN p_anio INT)
BEGIN
    SELECT 
        CONCAT(p_anio, '-', LPAD(p_mes, 2, '0')) AS mes,
        ROUND(SUM(v.quantity * v.sale_price), 2) AS total_ventas,
        ROUND(SUM(v.quantity * v.sale_price * (i.value / 100)), 2) AS total_iva
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

CALL generar_reporte_ventas_mensual(9, 2024);


-- Crear las vistas

-- 1) Vista para ver los distintos SKUs
CREATE OR REPLACE VIEW sku AS 
SELECT DISTINCT a.id_articulo, a.name 
FROM articulo a;

SELECT * FROM sku;

-- 2) Vista para ver los SKUs vendidos, cantidad de unidades e importe
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

SELECT * FROM ventas_por_sku;

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

SELECT * FROM ventas_por_sku_clientes;

-- 4) Vista para saber las ventas y cuánto pagar por cada tipo de IVA por mes

CREATE OR REPLACE VIEW ventas_e_iva_por_mes AS
SELECT 
    YEAR(v.fecha) AS anio,
    MONTH(v.fecha) AS mes,
    SUM(v.quantity) AS total_unidades, -- Total de unidades vendidas
    ROUND(SUM(v.quantity * v.sale_price), 2) AS total_venta, -- Total de ventas
    ROUND(SUM(v.quantity * v.sale_price * (i.value / 100)), 2) AS total_iva_a_pagar -- Total de IVA a pagar
FROM 
    venta v
JOIN 
    iva i ON v.id_iva = i.id_iva
GROUP BY 
    YEAR(v.fecha), MONTH(v.fecha);

-- Consultar la vista ordenada por fecha (año y mes)
SELECT * 
FROM ventas_e_iva_por_mes
ORDER BY 
    anio ASC, 
    mes ASC;


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


SELECT * FROM proveedor_mas_vendido;

-- 6) Vista para cálculo de precios en ventas
CREATE OR REPLACE VIEW vista_ventas AS
SELECT 
    v.document_number,
    v.id_articulo,
    v.quantity,
    v.sale_price,
    v.quantity * v.sale_price AS total_price, -- Cálculo del total
    v.id_tipo_de_movimiento,
    COALESCE(a.purchase_price, v.sale_price) AS precio_bruto, -- Precio bruto basado en la tabla articulo
    COALESCE(p.discount_percentage, 0) AS descuento,
    COALESCE(a.purchase_price, v.sale_price) * (1 - COALESCE(p.discount_percentage, 0) / 100) AS precio_real_vendido, -- Calcular precio real vendido
    v.payment_method,
    v.bank,
    v.bank_account_number,
    v.currency,
    v.id_cliente,
    v.id_iva,
    v.fecha
FROM 
    venta v
LEFT JOIN 
    articulo a ON v.id_articulo = a.id_articulo
LEFT JOIN 
    articulo_promocion ap ON v.id_articulo = ap.id_articulo
LEFT JOIN 
    promociones p ON ap.id_promocion = p.id_promocion
    AND v.fecha BETWEEN p.start_date AND p.end_date;
    
SELECT * FROM vista_ventas;

-- 7) Vista catálogo_web
CREATE OR REPLACE VIEW catalogo_web AS
SELECT
    a.id_articulo,
    a.name,
    a.barcode,
    COALESCE(s.quantity, 0) AS stock_quantity,
    a.purchase_price AS stock_price,
    a.sale_price,
    a.id_categoria_articulo,
    a.id_iva
FROM
    articulo a
LEFT JOIN
    stock s ON a.id_articulo = s.id_articulo AND s.id_deposito = (SELECT id_deposito FROM deposito WHERE name = 'web');
  
  SELECT * FROM catalogo_web;
-- 8) Cumplimiento de entrega de los proveedores:

CREATE OR REPLACE VIEW  cumplimiento_de_los_proveedores AS
SELECT 
    o.id_articulo,
    a.name AS nombre_articulo,
	o.id_proveedor,
    o.order_date AS fecha_orden,
    o.quantity AS cantidad_pedida,
	o.quantity * o.purchase_price AS monto_orden,
    COALESCE(SUM(r.quantity), 0) AS cantidad_entregada,
	COALESCE(SUM(r.quantity * r.purchase_price), 0) AS monto_entregado,
	MIN(r.receipt_date) AS fecha_recibo,
    COALESCE(SUM(c.quantity), 0) AS cantidad_comprada,
    COALESCE(SUM(c.quantity * c.purchase_price), 0) AS monto_comprado,
    MIN(c.purchase_date) AS fecha_compra
FROM 
    orden_de_compra o
LEFT JOIN 
    recibo_de_mercaderia r 
    ON o.id_articulo = r.id_articulo 
    AND o.id_orden_de_compra = r.id_orden_de_compra
LEFT JOIN 
    compra c 
    ON o.id_articulo = c.id_articulo 
    AND o.id_orden_de_compra = c.id_orden_de_compra
LEFT JOIN 
    articulo a 
    ON o.id_articulo = a.id_articulo
GROUP BY 
    o.id_articulo, 
    a.name, 
    o.order_date, 
    o.quantity, 
    o.purchase_price,
    o.id_proveedor;

-- Consultar la vista ordenada por cumplimiento
SELECT 
    *,
    CASE 
        WHEN cantidad_pedida = 0 THEN 0
        ELSE cantidad_entregada / cantidad_pedida
    END AS cumplimiento
FROM 
    cumplimiento_de_los_proveedores
ORDER BY 
    cumplimiento ASC, 
    id_proveedor;

-- 9) Resultado promociones:
CREATE OR REPLACE VIEW ventas_con_descuento AS
SELECT 
    v.id_venta,
    v.id_articulo,
    v.quantity,
    v.sale_price AS precio_original,
    ROUND(v.quantity * v.sale_price, 2) AS monto_original,
    COALESCE(p.description, 'Sin promoción') AS descripcion_promocion,
    COALESCE(p.discount_percentage, 0) AS porcentaje_descuento,
    ROUND(v.sale_price * (1 - COALESCE(p.discount_percentage, 0) / 100), 2) AS precio_con_descuento,
    ROUND(v.quantity * v.sale_price * (1 - COALESCE(p.discount_percentage, 0) / 100), 2) AS monto_con_descuento,
    YEAR(v.fecha) AS anio,
    MONTH(v.fecha) AS mes
FROM 
    venta v
LEFT JOIN 
    articulo_promocion ap ON v.id_articulo = ap.id_articulo
LEFT JOIN 
    promociones p ON ap.id_promocion = p.id_promocion
AND v.fecha BETWEEN p.start_date AND p.end_date;
SELECT 
    descripcion_promocion,
    anio,
    mes,
    SUM(monto_original) AS total_original,
    SUM(monto_con_descuento) AS total_con_descuento,
    SUM(monto_original) - SUM(monto_con_descuento) AS diferencia
FROM 
    ventas_con_descuento
GROUP BY 
    descripcion_promocion,
    anio,
    mes
ORDER BY 
    anio,
    mes,
    descripcion_promocion;


-- Bonus track: Cree un usuario que solo puede utilizar select para validar que todo haya quedado OK, comparto aquí las consultas:
-- CREATE USER coderhouse@localhost identified BY '123';
-- GRANT SELECT ON moradita.* TO coderhouse1@localhost;
-- use mysql;
-- select * from user;


select * from articulo;
select * from articulo_promocion;
select * from categoria_articulo;
select * from cliente;
select * from compra;
select * from deposito;
select * from historial_cambios_precios;
select * from iva;
select * from orden_de_compra;
select * from promociones;
select * from articulo_promocion;
select * from proveedor;
select * from recibo_de_mercaderia;
select * from stock;
select * from venta;
select * from tipo_de_movimiento;
select * from auditoria;
