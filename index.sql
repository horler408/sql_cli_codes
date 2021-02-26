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


--DATABASE DESIGN
