CREATE DATABASE pos_db;
USE pos_db;

CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int DEFAULT '0',
  PRIMARY KEY (`product_id`)
);


CREATE TABLE `pending_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) GENERATED ALWAYS AS ((`quantity` * `price`)) STORED,
  PRIMARY KEY (`id`)
);

CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_type` varchar(45) NOT NULL DEFAULT 'cash',
  `cash_` decimal(10,2) NOT NULL,
  `change_` decimal(10,2) NOT NULL,
  `transaction_status` varchar(20) DEFAULT 'valid',
  PRIMARY KEY (`transaction_id`)
);


CREATE TABLE `transaction_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `transaction_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) GENERATED ALWAYS AS ((`quantity` * `price`)) STORED,
  PRIMARY KEY (`item_id`)
);

DROP table pending_items;
DROP table products;
DROP table transaction_items;
DROP table transactions;




-- inventory

INSERT INTO products(product_name,category, price, stock ) VALUES('Milk', 'powdered drink', 120, 250);
INSERT INTO products(product_name,category, price, stock ) VALUES('Milo', 'powdered drink', 60, 300);

SELECT * FROM products;

DELETE FROM products WHERE product_id = 1;

UPDATE products set price = 200 WHERE product_id = 13;




-- cashier
-- [1] inserting items to pending
INSERT INTO pos_db.pending_items(product_id, quantity, price) 
SELECT product_id, 1, price FROM products WHERE product_id = 1;

SELECT pending_items.id, products.product_name, pending_items.quantity, pending_items.price, pending_items.subtotal 
FROM products JOIN pending_items ON products.product_id = pending_items.product_id ORDER BY pending_items.id ASC;

-- [2] getting the total sum of price of all the items
SELECT SUM(subtotal) FROM pending_items;


-- [3] when transaction is finished       - this is summary of sales per transaction
INSERT INTO transactions(date , total_amount, cash_, change_, transaction_status) 
VALUES(NOW(),(SELECT SUM(subtotal) FROM pending_items AS total) , 1000, total - 1000, 'Complete');

SELECT * FROM transactions;

-- [3] detailed summary of transaction, this is what we see in receipts
INSERT INTO transaction_items(transaction_id, product_id, quantity, price)
SELECT (SELECT MAX(transaction_id) FROM transactions), product_id, quantity, price FROM pending_items; 


-- [4] deduct from products the quantity of bought items
-- not yet done hehe


SELECT * FROM transaction_items;

-- [5] empty pending items after a transaction
TRUNCATE pending_items;






-- admin

SELECT * FROM transactions;

UPDATE transactions SET transaction_status = 'void' WHERE transaction_id = 1;
