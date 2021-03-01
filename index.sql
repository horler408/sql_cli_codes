-- To Access Mysql on command line
cd C:\"Program Files (x86)\Ampps\mysql\bin"
mysql -u root -pmysql

--cmd
SHOW databases;

--To create database from CLI
CREATE DATABASE publications;
USE publications;

--To create User using CLI
GRANT PRIVILEGES ON database.object TO 'username'@'hostname'
IDENTIFIED BY 'password';

GRANT ALL ON publications.* TO 'jim'@'localhost'
IDENTIFIED BY 'mypasswd';

--*.*, databaseName.*, databaseName.tableName

--To create Table Classics
CREATE TABLE classics (
author VARCHAR(128),
title VARCHAR(128),
type VARCHAR(16),
year CHAR(4)) ENGINE InnoDB;

ALTER TABLE classics ADD id INT UNSIGNED NOT NULL AUTO_INCREMENT KEY;
ALTER TABLE classics DROP id;

CREATE TABLE classics (
author VARCHAR(128),
title VARCHAR(128),
type VARCHAR(16),
year CHAR(4),
id INT UNSIGNED NOT NULL AUTO_INCREMENT KEY) ENGINE InnoDB;

--To show a table structure
DESCRIBE classics;

--To ad users to the table
INSERT INTO classics(author, title, type, year)
VALUES('Mark Twain','The Adventures of Tom Sawyer','Fiction','1876');
INSERT INTO classics(author, title, type, year)
VALUES('Jane Austen','Pride and Prejudice','Fiction','1811');
INSERT INTO classics(author, title, type, year)
VALUES('Charles Darwin','The Origin of Species','Non-Fiction','1856');
INSERT INTO classics(author, title, type, year)
VALUES('Charles Dickens','The Old Curiosity Shop','Fiction','1841');
INSERT INTO classics(author, title, type, year)
VALUES('William Shakespeare','Romeo and Juliet','Play','1594');

--To Rename a table
ALTER TABLE classics RENAME pre1900;
--To change the data type of a column in a table
ALTER TABLE classics MODIFY year SMALLINT;
--To add extra column to a table
ALTER TABLE classics ADD pages SMALLINT UNSIGNED;
--To rename a field/column in a table
ALTER TABLE classics CHANGE type category VARCHAR(16);
--Removing a column in a table
ALTER TABLE classics DROP pages;
--Deleting a table in a database
DROP TABLE disposable;
SHOW tables;

--To add index to table classics
ALTER TABLE classics ADD INDEX(author(20));
ALTER TABLE classics ADD INDEX(title(20));
ALTER TABLE classics ADD INDEX(category(4));
ALTER TABLE classics ADD INDEX(year);

--Using Create Index Command
ALTER TABLE classics ADD INDEX(author(20));
CREATE INDEX author ON classics (author(20)); --Equivalent to above

--To add indexes while creating Table
CREATE TABLE classics (
author VARCHAR(128),
title VARCHAR(128),
category VARCHAR(16),
year SMALLINT,
INDEX(author(20)),
INDEX(title(20)),
INDEX(category(4)),
INDEX(year)) ENGINE InnoDB;

--Setting Primary Key for empty table
ALTER TABLE classics ADD isbn CHAR(13) PRIMARY KEY;

--Adding Primary Key to already populated table
ALTER TABLE classics ADD isbn CHAR(13);
UPDATE classics SET isbn='9781598184891' WHERE year='1876';
UPDATE classics SET isbn='9780582506206' WHERE year='1811';
UPDATE classics SET isbn='9780517123201' WHERE year='1856';
UPDATE classics SET isbn='9780099533474' WHERE year='1841';
UPDATE classics SET isbn='9780192814968' WHERE year='1594';
ALTER TABLE classics ADD PRIMARY KEY(isbn);

--To create a Table with Primary Key
CREATE TABLE classics (
author VARCHAR(128),
title VARCHAR(128),
category VARCHAR(16),
year SMALLINT,
isbn CHAR(13),
INDEX(author(20)),
INDEX(title(20)),
INDEX(category(4)),
INDEX(year),
PRIMARY KEY (isbn)) ENGINE InnoDB;

--To change Engine Type
ALTER TABLE tablename ENGINE = MyISAM;

--To FULLTEXT Index
ALTER TABLE classics ADD FULLTEXT(author,title);

--Querying The Database
SELECT author,title FROM classics;
SELECT title,isbn FROM classics;
SELECT COUNT(*) FROM classics;
SELECT author FROM classics;
SELECT DISTINCT author FROM classics;
DELETE FROM classics WHERE title='Little Dorrit';
SELECT author,title FROM classics WHERE author="Mark Twain";
SELECT author,title FROM classics WHERE isbn="9781598184891";
SELECT author,title FROM classics WHERE author LIKE "Charles%";
SELECT author,title FROM classics WHERE title LIKE "%Species";
SELECT author,title FROM classics WHERE title LIKE "%and%";
--LIMIT(offset, number of rows)
SELECT author,title FROM classics LIMIT 3;
SELECT author,title FROM classics LIMIT 1,2; --Skip row and return the next two rows
SELECT author,title FROM classics LIMIT 3,1; --Skip the first three rows and return the next one row

--MATCH...AGAINST construct
--They are used on columns that has been given FULLTEXT index
SELECT author,title FROM classics
WHERE MATCH(author,title) AGAINST('and'); --Returns empty because 'and' is a stopword
SELECT author,title FROM classics
WHERE MATCH(author,title) AGAINST('curiosity shop'); --//Result must contain the included words
SELECT author,title FROM classics
WHERE MATCH(author,title) AGAINST('tom sawyer');

SELECT author,title FROM classics
WHERE MATCH(author,title)
AGAINST('+charles -species' IN BOOLEAN MODE); --The rerurned query must contain word 'charles' but must not include word 'species'
SELECT author,title FROM classics
WHERE MATCH(author,title)
AGAINST('"origin of"' IN BOOLEAN MODE); --Returns all rows cotaining the exact phrase 'Origin of'

--Double quote can override stopwprds

--UPDATE...SET
UPDATE classics SET author='Mark Twain (Samuel Langhorne Clemens)'
WHERE author='Mark Twain';
UPDATE classics SET category='Classic Fiction'
WHERE category='Fiction';

--ORDER BY
SELECT author,title FROM classics ORDER BY author;
SELECT author,title FROM classics ORDER BY title DESC;
SELECT author,title,year FROM classics ORDER BY author,year DESC;
SELECT author,title,year FROM classics ORDER BY author ASC,year DESC;

--GROUP BY
SELECT category,COUNT(author) FROM classics GROUP BY category;
category | COUNT(author) |
+-----------------+---------------+
| Classic Fiction   | 3 |
| Non-Fiction       | 1 |
| Play              | 1 |

--Table Joining
--CReating table Customer
CREATE TABLE customers (
name VARCHAR(128),
isbn VARCHAR(13),
PRIMARY KEY (isbn)) ENGINE InnoDB;
INSERT INTO customers(name,isbn)
VALUES('Joe Bloggs','9780099533474');
INSERT INTO customers(name,isbn)
VALUES('Mary Smith','9780582506206');
INSERT INTO customers(name,isbn)
VALUES('Jack Wilson','9780517123201');
SELECT * FROM customers;

INSERT INTO customers(name,isbn) VALUES
('Joe Bloggs','9780099533474'),
('Mary Smith','9780582506206'),
('Jack Wilson','9780517123201');

--Joinning Table
SELECT name,author,title FROM customers,classics
WHERE customers.isbn=classics.isbn;

SELECT name,author,title FROM customers NATURAL JOIN classics;

SELECT name,author,title from
customers AS cust, classics AS class WHERE cust.isbn=class.isbn;

SELECT author,title FROM classics WHERE
author LIKE "Charles%" AND author LIKE "%Darwin";
SELECT author,title FROM classics WHERE
author LIKE "%Mark Twain%" OR author LIKE "%Samuel Langhorne Clemens%";
SELECT author,title FROM classics WHERE
author LIKE "Charles%" AND author NOT LIKE "%Darwin";

SELECT Customers.CustomerName, Orders.QuantityOrdered, Products.ProductName
FROM Customers JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
JOIN Products
ON Orders.ProductID = Products.ProductID

--View
--To create a view on the Orders table that lists the orders for 
--a specific product (in this case, product P1) like this:
CREATE VIEW P1Orders AS
SELECT CustomerID, OrderID, Quantity
FROM Orders
WHERE ProductID = "P1"

--The following query finds the orders for customer C1 using the 
--view. This query will only return orders for product P1 made by the customer:
SELECT CustomerID, OrderID, Quantity
FROM P1Orders
WHERE CustomerID = "C1";

--A view can also join tables together. If you regularly needed 
--to find the details of customers and the products that they've 
--ordered, you could create a view based on the join query 
--shown in the previous unit:
CREATE VIEW CustomersProducts AS
SELECT Customers.CustomerName, Orders.QuantityOrdered, Products.ProductName
FROM Customers JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
JOIN Products
ON Orders.ProductID = Products.ProductID;

--The following query finds the customer name and product names of all 
--orders placed by customer C2, using this view:
SELECT CustomerName, ProductName
FROM CustomersProducts
WHERE CustomerID = "C2"

--AZURE MySql Codes
-- Create a database
-- DROP DATABASE IF EXISTS quickstartdb;
CREATE DATABASE quickstartdb;
USE quickstartdb;

-- Create a table and insert rows
DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory (id serial PRIMARY KEY, name VARCHAR(50), quantity INTEGER);
INSERT INTO inventory (name, quantity) VALUES ('banana', 150);
INSERT INTO inventory (name, quantity) VALUES ('orange', 154);
INSERT INTO inventory (name, quantity) VALUES ('apple', 100);

-- Read
SELECT * FROM inventory;

-- Update
UPDATE inventory SET quantity = 200 WHERE id = 1;
SELECT * FROM inventory;

-- Delete
DELETE FROM inventory WHERE id = 2;
SELECT * FROM inventory;

CREATE TABLE PEOPLE(NAME TEXT NOT NULL, AGE INT NOT NULL);
INSERT INTO PEOPLE(NAME, AGE) VALUES ('Bob', 35);
INSERT INTO PEOPLE(NAME, AGE) VALUES ('Sarah', 28);
CREATE TABLE LOCATIONS(CITY TEXT NOT NULL, STATE TEXT NOT NULL);
INSERT INTO LOCATIONS(CITY, STATE) VALUES ('New York', 'NY');
INSERT INTO LOCATIONS(CITY, STATE) VALUES ('Flint', 'MI');

-- Create a new table called 'customers'
CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR (50) NOT NULL,
    location VARCHAR (50) NOT NULL,
    email VARCHAR (50) NOT NULL
);
\l to list databases.
\dt to list the tables in the current database.
-- Insert rows into table 'customers'
INSERT INTO customers
    (customer_id, name, location, email)
VALUES
    ( 1, 'Orlando', 'Australia', ''),
    ( 2, 'Keith', 'India', 'keith0@adventure-works.com'),
    ( 3, 'Donna', 'Germany', 'donna0@adventure-works.com'),
    ( 4, 'Janet', 'United States','janet1@adventure-works.com');

--Azure SQL Database
IF NOT EXISTS (
   SELECT name
   FROM sys.databases
   WHERE name = N'TutorialDB'
)
CREATE DATABASE [TutorialDB];
GO
    
ALTER DATABASE [TutorialDB] SET QUERY_STORE=ON;
GO

-- Switch to the TutorialDB database
USE [TutorialDB]
GO

-- Create a new table called 'Customers' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
DROP TABLE dbo.Customers;
GO

-- Create the table in the specified schema
CREATE TABLE dbo.Customers
(
   CustomerId        INT    NOT NULL   PRIMARY KEY, -- primary key column
   Name      [NVARCHAR](50)  NOT NULL,
   Location  [NVARCHAR](50)  NOT NULL,
   Email     [NVARCHAR](50)  NOT NULL
);
GO
    
-- Insert rows into table 'Customers'
INSERT INTO dbo.Customers
   ([CustomerId],[Name],[Location],[Email])
VALUES
   ( 1, N'Orlando', N'Australia', N''),
   ( 2, N'Keith', N'India', N'keith0@adventure-works.com'),
   ( 3, N'Donna', N'Germany', N'donna0@adventure-works.com'),
   ( 4, N'Janet', N'United States', N'janet1@adventure-works.com');
GO
--DATABASE DESIGN

