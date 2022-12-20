CREATE DATABASE fundraiser;

USE fundraiser;

GRANT ALL PRIVILEGES ON fundraiser.* TO 'admin'@'%';

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS summary;
CREATE TABLE summary (
id INT NOT NULL AUTO_INCREMENT,
student_name VARCHAR(50),
file_name VARCHAR(50),
file_description VARCHAR(50) DEFAULT '2022 Virginia Public Schools Fundraiser',
PRIMARY KEY (id)
);

-- Users uploaded some files and the application captured upload file meta data
INSERT INTO summary (student_name,file_name) SELECT 'John Smith','jsmith_2022_fundraiser.csv';
INSERT INTO summary (student_name,file_name) SELECT 'Jane Doe','Jane Doe Fundraiser.xlsx';

DROP TABLE IF EXISTS detail;
CREATE TABLE detail (
id INT NOT NULL AUTO_INCREMENT,
summary_id INT,
product_id INT,
product_quantity INT,
donor_name VARCHAR(50),
donor_address VARCHAR(100),
donor_phone VARCHAR(50),
donor_email VARCHAR(50),
PRIMARY KEY (id),
FOREIGN KEY (summary_id) REFERENCES summary(id)
);

-- Users uploaded some files and the application captured all of the file's data
-- File 1
INSERT INTO detail (summary_id,product_id,product_quantity,donor_name,donor_address,donor_phone,donor_email)
SELECT 1,1,1,'David Axmark','123 MySQL Street, Virginia Beach, VA 23333','7571234567','dave@mail.com';

INSERT INTO detail (summary_id,product_id,product_quantity,donor_name,donor_address,donor_phone,donor_email)
SELECT 1,2,6,NULL,'456 RDBMS Lane, Chesapeake, VA 23444','A7572223456','allan@mail.com';

INSERT INTO detail (summary_id,product_id,product_quantity,donor_name,donor_address,donor_phone,donor_email)
SELECT 1,3,12,'Monty Widenius',NULL,'757888X3456','MontyEmail';

-- File 2
INSERT INTO detail (summary_id,product_id,product_quantity,donor_name,donor_address,donor_phone,donor_email)
SELECT 2,3,4,'Ted Healey','888 Stooge Drive, Arlington, VA 23311','757888999','tedemail';

INSERT INTO detail (summary_id,product_id,product_quantity,donor_name,donor_address,donor_phone,donor_email)
SELECT 2,6,5,'Moe Howard','999 Slapstick Way, Alexandria, VA 23444','7573334444','moe@mail.com';



-- Create table to hold all of our validation checks, these checks can be maintained via intiuive UI with users working within the app and the app translating to where clauses with Regular Expressions
DROP TABLE IF EXISTS validation_check;
CREATE TABLE validation_check (
id INT NOT NULL AUTO_INCREMENT,
validation_description VARCHAR(100),
field_name VARCHAR(50),
where_clause VARCHAR(255),
PRIMARY KEY (id)
);

-- Insert some data validation checks, we'll pretend these were inserted by the app UI 
INSERT INTO validation_check (validation_description,field_name,where_clause)
SELECT 'Missing Donor Name','donor_name', 'IS NULL'; 

INSERT INTO validation_check (validation_description,field_name,where_clause)
SELECT 'Missing Donor Address','donor_address', 'IS NULL'; 

INSERT INTO validation_check (validation_description,field_name,where_clause)
SELECT 'Missing Donor Phone','donor_phone', 'IS NULL'; 

INSERT INTO validation_check (validation_description,field_name,where_clause)
SELECT 'Missing Donor Email','donor_email', 'IS NULL'; 

INSERT INTO validation_check (validation_description,field_name,where_clause)
SELECT 'Invalid Phone Number','donor_phone', 'NOT REGEXP ' '''^[0-9]+$'''; 

INSERT INTO validation_check (validation_description,field_name,where_clause)
SELECT 'Invalid Email', 'donor_email', 'NOT REGEXP ' '''^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9._-]@[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]\\.[a-zA-Z]{2,63}$''';

-- Create a table to save the validation results
DROP TABLE IF EXISTS validation_detail;
CREATE TABLE validation_detail (
id INT NOT NULL AUTO_INCREMENT,
detail_id INT,
validation_check_id INT,
field_name VARCHAR(50),
field_value VARCHAR(255),
PRIMARY KEY (id),
FOREIGN KEY (detail_id) REFERENCES detail(id),
FOREIGN KEY (validation_check_id) REFERENCES validation_check(id)
);

SET FOREIGN_KEY_CHECKS = 1;
