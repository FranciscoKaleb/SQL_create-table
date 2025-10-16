CREATE DATABASE product_inventory;

USE product_inventory;

CREATE TABLE products (
  id int NOT NULL AUTO_INCREMENT,
  product_name varchar(100) NOT NULL,
  category varchar(50) DEFAULT NULL,
  price decimal(10,2) NOT NULL,
  stock int DEFAULT '0',
  PRIMARY KEY (product_id)
);

DROP table products;

-- inventory

INSERT INTO products(product_name,category, price, stock ) VALUES('Milk', 'powdered drink', 120, 250);
INSERT INTO products(product_name,category, price, stock ) VALUES('Milo', 'powdered drink', 60, 300);
INSERT INTO products(product_name,category, price, stock ) VALUES('Egg', 'perishable', 8, 300);
INSERT INTO products(product_name,category, price, stock ) VALUES('Shampoo', 'Hygiene', 10, 55);

SELECT * FROM products;

DELETE FROM products WHERE product_id = 1;

UPDATE products set price = 200 WHERE product_id = 13;



