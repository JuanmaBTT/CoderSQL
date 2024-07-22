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
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva),
    FOREIGN KEY (id_categoria_articulo) REFERENCES categoria_articulo(id_categoria_articulo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
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
    FOREIGN KEY (id_articulo) REFERENCES articulo(id_articulo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_iva) REFERENCES iva(id_iva)
);