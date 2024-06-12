-- Creation of the database Tech Haven
CREATE DATABASE TechHaven;
USE TechHaven;

-- Creation of independent tables

-- Product Table
CREATE TABLE product(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT NOT NULL,

    CONSTRAINT Pk_Product PRIMARY KEY (id)
);

-- Users Table
CREATE TABLE user(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    registerDate DATE NOT NULL,

    CONSTRAINT Pk_User PRIMARY KEY (id)
);

-- Creation of dependent tables

-- order's table
CREATE TABLE orders(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    userId INT UNSIGNED NOT NULL,
    orderDate DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,

    CONSTRAINT Pk_Order PRIMARY KEY (id),
    CONSTRAINT Fk_User_Order FOREIGN KEY (userId) REFERENCES user(id)
);

-- order detail's table
CREATE TABLE order_detail(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    orderId INT UNSIGNED NOT NULL,
    productId INT UNSIGNED,
    quantity INT,
    unitPrice DECIMAL(10,2),

    CONSTRAINT Pk_OrderDetail PRIMARY KEY(id),
    CONSTRAINT Fk_Order_OrderDetail FOREIGN KEY (orderId) REFERENCES orders(id),
    CONSTRAINT Fk_Product_OrderDetail FOREIGN KEY (productId) REFERENCES product(id)
);

