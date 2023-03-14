DROP DATABASE limitedrip;
CREATE DATABASE IF NOT EXISTS limitedrip;
USE limitedrip;

CREATE TABLE IF NOT EXISTS `customer` (
  `CUSTOMER_ID` INT AUTO_INCREMENT,
  `FIRST_NAME` VARCHAR(30) NOT NULL,
  `LAST_NAME` VARCHAR(30) DEFAULT NULL,
  `AGE` INT(3) NOT NULL,
  `EMAIL` VARCHAR(75) DEFAULT NULL,
  `PHONE_NUMBER` VARCHAR(13) DEFAULT NULL,
  `LOCATION_ID` INT DEFAULT NULL,
  PRIMARY KEY (`CUSTOMER_ID`)
);

CREATE TABLE IF NOT EXISTS `location` (
  `LOCATION_ID` INT AUTO_INCREMENT NOT NULL,
  `STREET` VARCHAR(40) NOT NULL,
  `POSTAL_CODE` VARCHAR(10) NOT NULL,
  `CITY` VARCHAR(25) NOT NULL,
  `DISTRICT` VARCHAR(25) DEFAULT NULL,
  `COUNTRY_ID` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`LOCATION_ID`)
) ;

CREATE TABLE IF NOT EXISTS `country` (
  `COUNTRY_ID` VARCHAR(3) NOT NULL,
  `COUNTRY_NAME` VARCHAR(30) NOT NULL,
  `CONTINENT_ID` INT NOT NULL,
  PRIMARY KEY (`COUNTRY_ID`)
);

CREATE TABLE IF NOT EXISTS `CONTINENT` (
  `CONTINENT_ID` INT AUTO_INCREMENT NOT NULL,
  `CONTINENT_NAME` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`CONTINENT_ID`)
);

CREATE TABLE IF NOT EXISTS `warehouse` (
  `WAREHOUSE_ID` INT NOT NULL AUTO_INCREMENT,
  `EMAIL` VARCHAR(30) NOT NULL,
  `PHONE_NUMBER` VARCHAR(13) NOT NULL,
  `LOCATION_ID` INT NOT NULL,
  PRIMARY KEY (`WAREHOUSE_ID`)
  );
  
   CREATE TABLE IF NOT EXISTS `product` (
  `PRODUCT_ID` INT AUTO_INCREMENT NOT NULL,
  `PRODUCT_NAME` VARCHAR(40) NOT NULL,
  `PRODUCT_PRICE` DECIMAL(8,2) NOT NULL, 
  `PRODUCT_DISCOUNT` FLOAT(2,2) DEFAULT '0.00',
  PRIMARY KEY (`PRODUCT_ID`)
);

CREATE TABLE IF NOT EXISTS `discount` (
   `DISCOUNT_ID` INT AUTO_INCREMENT NOT NULL,
   `DISCOUNT_CODE` VARCHAR(20) NOT NULL,
   `DISCOUNT_DESCRIPTION` VARCHAR(100) NOT NULL,
   `DATE_START` DATETIME DEFAULT NULL,
   `DATE_END` DATETIME DEFAULT NULL,
   `DISCOUNT_VALUE` FLOAT(2,2) DEFAULT '0.00',
   PRIMARY KEY (`DISCOUNT_ID`)
   );

CREATE TABLE IF NOT EXISTS `stock` (
  `PRODUCT_ID` INT NOT NULL, 
  `WAREHOUSE_ID` INT NOT NULL, 
  `QUANTITY` INT(5) NOT NULL,
  `LAST_DATE` DATETIME DEFAULT NOW(), #Stock was updated
  PRIMARY KEY (`PRODUCT_ID`, `WAREHOUSE_ID`)
);

CREATE TABLE IF NOT EXISTS `invoice` (
  `INVOICE_ID` INT AUTO_INCREMENT NOT NULL,
  `DATE_OF_ISSUE` DATETIME DEFAULT NOW(),
  `TOTAL` INT DEFAULT '0.00',
  `TAX_RATE` FLOAT(2,2) DEFAULT '0.06',
  `CUSTOMER_ID` INT NOT NULL,
  `DISCOUNT_ID` INT DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ID`)
) ;

CREATE TABLE IF NOT EXISTS `order` (
  `INVOICE_ID` INT NOT NULL,
  `PRODUCT_ID` INT NOT NULL,
  `WAREHOUSE_ID` INT NOT NULL,
  `QUANTITY` INT(5) NOT NULL, 
  `DATE_OF_PURCHASE` DATETIME DEFAULT NOW(),
  PRIMARY KEY (`INVOICE_ID`, `PRODUCT_ID`, `WAREHOUSE_ID`)
) ;

CREATE TABLE IF NOT EXISTS `rating` (
  `RATING_ID` INT AUTO_INCREMENT NOT NULL,
  `CUSTOMER_ID` INT NOT NULL,
  `PRODUCT_ID` INT NOT NULL,
  `RATING_DATE` DATETIME DEFAULT NOW(), 
  `RATING` INT DEFAULT NULL,
  `COMMENT` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`RATING_ID`)
);

#FOREIGN KEY'S DEFINITION:

ALTER TABLE `country`
ADD CONSTRAINT `fk_country`
  FOREIGN KEY (`CONTINENT_ID`)
  REFERENCES `continent` (`CONTINENT_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
  ALTER TABLE `location`
ADD CONSTRAINT `fk_location`
  FOREIGN KEY (`COUNTRY_ID`)
  REFERENCES `country` (`COUNTRY_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
  ALTER TABLE `warehouse`
ADD CONSTRAINT `fk_warehouse`
  FOREIGN KEY (`LOCATION_ID`)
  REFERENCES `location` (`LOCATION_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
  ALTER TABLE `customer`
ADD CONSTRAINT `fk_customer`
  FOREIGN KEY (`LOCATION_ID`)
  REFERENCES `location` (`LOCATION_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
  ALTER TABLE `stock`
ADD CONSTRAINT `fk_stock`
  FOREIGN KEY (`WAREHOUSE_ID`)
  REFERENCES `warehouse` (`WAREHOUSE_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_stock_2`
  FOREIGN KEY (`PRODUCT_ID`)
  REFERENCES `product` (`PRODUCT_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
  ALTER TABLE `order`
ADD CONSTRAINT `fk_order`
  FOREIGN KEY (`PRODUCT_ID`)
  REFERENCES `product` (`PRODUCT_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_order_2`
  FOREIGN KEY (`INVOICE_ID`)
  REFERENCES `invoice` (`INVOICE_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_order_3`
  FOREIGN KEY (`WAREHOUSE_ID`)
  REFERENCES `warehouse` (`WAREHOUSE_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
  ALTER TABLE `invoice`
ADD CONSTRAINT `fk_invoice`
  FOREIGN KEY (`DISCOUNT_ID`)
  REFERENCES `discount` (`DISCOUNT_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_invoice_2`
  FOREIGN KEY (`CUSTOMER_ID`)
  REFERENCES `customer` (`CUSTOMER_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
ALTER TABLE `rating`
ADD CONSTRAINT `fk_rating`
  FOREIGN KEY (`CUSTOMER_ID`)
  REFERENCES `customer` (`CUSTOMER_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_rating_2`
  FOREIGN KEY (`PRODUCT_ID`)
  REFERENCES `product` (`PRODUCT_ID`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
insert into `continent` (`continent_id`, `continent_name`) values
(1, 'Europe');

INSERT INTO `country` (`COUNTRY_ID`, `COUNTRY_NAME`, `CONTINENT_ID`) VALUES
('PT', 'Portugal', 1),
('GER', 'Germany', 1),
('UK', 'United Kingdom',1),
('SPA', 'Spain',1);

INSERT INTO `location` (`LOCATION_ID`, `STREET`, `POSTAL_CODE`, `CITY`, `DISTRICT`, `COUNTRY_ID`) VALUES
(1, 'Rua Pulido Valente 2', '2675', 'Lisboa', 'Lisboa', 'PT'),
(2, 'Rua da Gloria 9', '1250-114', 'Lisboa', 'Lisboa', 'PT'),
(3, 'Avenida dos Aliados 42', '	4000-064', 'Porto', 'Porto', 'PT'),
(4, 'Rua da Cruz da Pedra 132', '4700-219', 'Braga', 'Braga', 'PT'),
(5, 'Helmstedter Str. 22', 1000-950, 'Berlin', 'Berlin', 'GER'),
(6, 'Brandenburgische Straße 45', 10369, 'Berlin Lichtenberg', 'Berlin', 'GER'),
(7, 'An der Schillingbrucke 41', 73450, 'Neresheim', 'Baden-Württemberg', 'GER'),
(8, 'Heiligengeistbrücke 77', 91542, 'Dinkelsbühl', 'Freistaat Bayern', 'GER'),
(9, 'Schoenebergerstrasse 64', 08383, 'Meerane', 'Freistaat Sachsen', 'GER'),
(10, '90 Cambridge Road', 'CA6 3AB', 'Nook', NULL, 'UK'),
(11, '13 Walden Road', 'AB42 9FG', 'Greenheads', NULL, 'UK'),
(12, '65 Pendwyallt Road', 'NG14 3NW', 'Burton Joyce', NULL, 'UK'),
(13, 'Escuadro 58', 46870, 'Ontinyent', 'Valencia', 'SPA'),
(14, 'Plaza Colón 74', 25280, 'Solsona', 'Lleida', 'SPA'),
(15, 'Rua Pascoal de Melo, 134', '1000-131', 'Lisboa', 'Lisboa', 'PT'),
(16, 'Rua Miguel Nogueira Junior, 50', '1950-162', 'Lisboa', 'Lisboa', 'PT');

insert into `customer` (`CUSTOMER_ID`, `FIRST_NAME`, `LAST_NAME`, `AGE`, `LOCATION_ID`) values
(1, 'João', 'Duarte', 21, 1),
(2, 'Carolina', 'Fonseca', 22, 2),
(3, 'João', 'Gouveia', 22, 2),
(4, 'Artur', 'Almeida', 27,3),
(5, 'Vasco', 'Costa', 16, 2),
(6, 'Juliana', 'Alexandre', 55, 4),
(7, 'Catarina', 'Silva', 68, 12),
(8, 'Rui', 'Pedro', 63, 6),
(9, 'Pedro', 'Afonso', 34, 7),
(10, 'Simão', 'Moita', 26, 12),
(11, 'Mariana', 'Varela', 27, 10),
(12, 'Afonso', 'Serra', 39, 7),
(13, 'Francisca', 'Esteves', 31, 3),
(14, 'Francisco', 'Farrajota', 30, 4),
(15, 'Inês', 'Oliveira', 35, 5),
(16, 'Alice', 'Rocha', 27, 11),
(17, 'Teresa', 'Coelho', 24, 13),
(18, 'Ana', 'Pinto', 23, 14),
(19, 'Patrícia', 'Almeida', 41, 1),
(20, 'Joana', 'Amado', 56, 2),
(21, 'Marta', 'Alves', 31, 12),
(22, 'Jorge', 'Sócrates', 45, 8),
(23, 'Tiago', 'Luís', 38, 8),
(24, 'Gabriel', 'Correia', 45, 4),
(25, 'Nuno', 'Carvalho', 62, 5);

insert into `warehouse` (`WAREHOUSE_ID`, `EMAIL`, `PHONE_NUMBER`, `LOCATION_ID`) values 
(1, 'w1.pt@limiteddrip.com', '219 281 307', 16), 
(2, 'w2.de@limiteddrip.com', '778 69467', 5);

insert into `product` (`PRODUCT_ID`, `PRODUCT_NAME`,`PRODUCT_PRICE`) values
(1, 'Nike Dunk Low', 199.99),
(2, 'Converse All Star', 69.99),
(3, 'Nike AIR Force', 99.75),
(4, 'Air Jordan', 119.99),
(5, 'Adidas Stan Smith', 69.99),
(6, 'Adidas Forum Low', 89.99), 
(7, 'Adidas Yeezy', 250.00),
(8, 'Merrell Chameleon',119.75),
(9, 'New Balance CT300v3', 89.75),
(10, 'New Balance 530', 139.99),
(11, 'New Balance 327', 110.99),
(12, 'New Balance 574', 200.0),
(13, 'Veja V-10', 139.99),
(14, 'Nike SB', 89.00),
(15, 'Golden Goose', 435.00),
(16, 'Nike AIR Max', 180.00),
(17, 'Vans Old Skool',79.99),
(18, 'PUMA CA Pro Luxe', 99.99),
(19, 'Tommy Hilfiger Core Vulc Varsity', 109.50),
(20, 'Geox U Delray', 88.00),
(21, 'Adidas x Gucci', 650.00),
(22, 'Geox U Spherica EC1C', 103.92),
(23, 'Paez Combi Sand', 44.90),
(24, 'Adidas Dame 8', 99.99),
(25, 'Mens Web rubber slide sandal', 300.00);

insert into `discount` (`DISCOUNT_ID`, `DISCOUNT_CODE`, `DISCOUNT_DESCRIPTION`) values
(1, 'CHRISTMAS22', 'Christmas discount code for 2022'),
(2, 'CHRISTMAS23', 'Christmas discount code for 2023'),
(3, 'SUMMER22', 'Holidays discount code for 2022'),
(4, 'SUMMER23', 'Holidays discount code for 2023');

insert into `stock` (`PRODUCT_ID`,`WAREHOUSE_ID`,`QUANTITY`, `LAST_DATE`) values
(1, 1,10,'2022-01-01'),
(1, 2,10,'2022-01-01'),
(2, 1,10,'2022-01-01'),
(2, 2,10,'2022-01-01'),
(3, 1,10,'2022-01-01'),
(3, 2,10,'2022-01-01'),
(4, 1,10,'2022-01-01'),
(4, 2,10,'2022-01-01'),
(5, 1,10,'2022-01-01'),
(5, 2,10,'2022-01-01'),
(6, 1,10,'2022-01-01'),
(6, 2,10,'2022-01-01'),
(7, 1,10,'2022-01-01'),
(7, 2,10,'2022-01-01'),
(8, 1,10,'2022-01-01'),
(8, 2,10,'2022-01-01'),
(9, 1,10,'2022-01-01'),
(9, 2,10,'2022-01-01'),
(10, 1,10,'2022-01-01'),
(10, 2,10,'2022-01-01'),
(11, 1,10,'2022-01-01'),
(11, 2,10,'2022-01-01'),
(12, 2,10,'2022-01-01'),
(12, 1,10,'2022-01-01'),
(13, 2,10,'2022-01-01'),
(13, 1,10,'2022-01-01'),
(14, 2,10,'2022-01-01'),
(14, 1,10,'2022-01-01'),
(15, 2,10,'2022-01-01'),
(15, 1,10,'2022-01-01'),
(16, 1,10,'2022-01-01'),
(16, 2,10,'2022-01-01'),
(17, 1,10,'2022-01-01'),
(17, 2,10,'2022-01-01'),
(18, 1,10,'2022-01-01'),
(18, 2,10,'2022-01-01'),
(19, 1,10,'2022-01-01'),
(19, 2,10,'2022-01-01'),
(20, 2,10,'2022-01-01'),
(20, 1,10,'2022-01-01'),
(21, 2,10,'2022-01-01'),
(21, 1,10,'2022-01-01'),
(22, 2,10,'2022-01-01'),
(22, 1,22,'2022-01-01'),
(23, 2,10,'2022-01-01'),
(23, 1,10,'2022-01-01'),
(24, 2,10,'2022-01-01'),
(24, 1,10,'2022-01-01'),
(25, 2,10,'2022-01-01'),
(25, 1,10,'2022-01-01');

insert into `invoice` (`INVOICE_ID`,`CUSTOMER_ID`,`DATE_OF_ISSUE`,`DISCOUNT_ID`) values
(1, 1,'2022-03-25', NULL),
(2, 17,'2022-03-28', NULL),
(3, 2,'2022-04-08', NULL),
(4, 1,'2022-04-12', NULL),
(5, 7,'2022-04-23', NULL),
(6, 2,'2022-05-12', NULL),
(7, 5,'2022-05-29', NULL),
(8, 12,'2022-06-01', 3),
(9, 13,'2022-06-23', 3),
(10, 22,'2022-07-14', 3),
(11, 20,'2022-07-29', 3),
(12, 6,'2022-08-23', NULL),
(13, 25,'2022-08-25', NULL),
(14, 22,'2022-09-19', NULL),
(15, 18,'2022-09-29', NULL),
(16, 2,'2022-09-30', NULL),
(17, 4,'2022-10-26', NULL),
(18, 18,'2022-11-11', NULL),
(19, 13,'2022-12-15', 1),
(20, 16,'2022-12-23', 1),
(21, 5,'2023-01-14', NULL),
(22, 3,'2023-04-22', NULL),
(23, 14,'2023-05-23', NULL),
(24, 17,'2024-02-13', 4),
(25, 22,'2024-04-26', 4);

insert into `order` (`INVOICE_ID`,`PRODUCT_ID`,`WAREHOUSE_ID`,`QUANTITY`,`DATE_OF_PURCHASE`) values
(1, 13,1,1,'2022-03-25'),
(1, 12,1,1,'2022-03-25'),
(1, 11,2,1,'2022-03-25'),
(2, 10,2,2,'2022-03-28'),
(3, 3,1,1,'2022-04-08'),
(3, 25,2,1,'2022-04-08'),
(4, 21,1,2,'2022-04-12'),
(4, 12,1,1,'2022-04-12'),
(5, 13,1,1,'2022-04-23'),
(6, 3,1,2,'2022-05-12'),
(6, 11,2,1,'2022-05-12'),
(7, 22,1,1,'2022-05-29'),
(8, 23,2,1,'2022-06-01'),
(9, 17,1,1,'2022-06-23'),
(9, 9,1,1,'2022-06-23'),
(10, 8,2,2,'2022-07-14'),
(10, 4,2,1,'2022-07-14'),
(11, 6,2,1,'2022-07-29'),
(11, 1,1,2,'2022-07-29'),
(11, 5,1,2,'2022-07-29'),
(12, 19,1,1,'2022-08-23'),
(13, 18,2,1,'2022-08-25'),
(14, 13,1,1,'2022-09-19'),
(15, 13,1,1,'2022-09-29'),
(16, 11,2,2,'2022-09-30'),
(17, 5,2,2,'2022-10-26'),
(18, 6,1,1,'2022-11-11'),
(18, 7,2,2,'2022-11-11'),
(19, 7,2,2,'2022-12-15'),
(20, 13,2,1,'2022-12-23'),
(20, 18,1,1,'2022-12-23'),
(20, 4,2,2,'2022-12-23'),
(21, 2,1,3,'2023-01-14'),
(21, 22,1,1,'2023-01-14'),
(22, 21,1,2,'2023-04-22'),
(23, 24,1,2,'2023-05-23'),
(24, 24,2,2,'2024-02-13'),
(25, 25,2,2,'2024-04-26'),
(25, 12,2,1,'2024-04-26'),
(25, 15,1,3,'2024-04-26');

insert into `rating` (`CUSTOMER_ID`,`PRODUCT_ID`,`RATING`) values
(1, 13, 3),
(2, 10, 4),
(3, 3, 5),
(4, 21, 1),
(5, 13, 5),
(6, 3, 3),
(7, 22, 2),
(8, 23, 5),
(9, 17, 5),
(10, 8, 5),
(11, 6, 4),
(12, 19, 5),
(13, 18, 3),
(14, 13, 3),
(15, 13, 4),
(16, 11, 5),
(17, 5, 4),
(18, 6, 5),
(19, 7, 4),
(20, 13, 3),
(21, 23, 4),
(22, 2, 1),
(23, 24, 3),
(24, 24, 4),
(25, 15, 5);
  
  
#TRIGGERS

#1 stock update after order
delimiter $$
create trigger stock_update 
before insert
on `order`
for each row
begin

if exists (select 1 from stock s where new.quantity <= s.quantity) then 
update stock s
set s.quantity = s.quantity-new.quantity, s.last_date = new.date_of_purchase
where new.quantity <= s.quantity and new.product_id = s.product_id and 
new.warehouse_id = s.warehouse_id;

else if exists (select 1 from stock s where new.quantity > s.quantity) then 
	SIGNAL SQLSTATE '45000'
	set message_text = 'There is not enough stock!';
    
end if;
end if;

end $$
delimiter ;

#2) trigger that inserts a row in a “log” table
Create Table IF NOT EXISTS log (
	ID integer unsigned auto_increment Primary Key, 	
    usr varchar(30),
	TS datetime,
	PRICE DECIMAL(8,2),
    PRICE_UPDATED DECIMAL(8,2),
	PRODUCTID integer (10));
    
delimiter $$
create trigger price_update
after update
on PRODUCT
for each row
Begin
	insert into log(usr, TS, PRODUCTID, PRICE, PRICE_UPDATED) values
    (user(), now(), NEW.PRODUCT_ID, OLD.PRODUCT_PRICE, NEW.PRODUCT_PRICE);
End $$
delimiter ;


#test the triggers

#Trigger 1
#insert into `invoice` (`INVOICE_ID`,`CUSTOMER_ID`) values
#(26, 1),
#(27, 7);
#insert into `order` (`INVOICE_ID`,`PRODUCT_ID`,`WAREHOUSE_ID`,`QUANTITY`,`DATE_OF_PURCHASE`) values
#(26, 3,2,1,'2023-07-27'),
#(27, 4,2,1,'2023-08-05');
#select * from `stock`;
#select * from `order`;


#Trigger 2
#update PRODUCT set product_price = 200.99
#where product_id = 1;
#select * from `log`;

#VIEWS INVOICES

CREATE OR REPLACE VIEW INVOICE_DETAILS as 
SELECT i.INVOICE_ID as INVOICE_NUMBER, p.PRODUCT_NAME as "Product Name", (p.PRODUCT_PRICE-(p.PRODUCT_PRICE*p.PRODUCT_DISCOUNT)) as Price, 
SUM(o.QUANTITY) as "Total Quantity", SUM(o.QUANTITY)*(p.PRODUCT_PRICE-(p.PRODUCT_PRICE*p.PRODUCT_DISCOUNT)) as Amount
from product as p
join `order` o on p.PRODUCT_ID=O.PRODUCT_ID
join `invoice` i on o.INVOICE_ID=i.INVOICE_ID
group by p.PRODUCT_ID;


#view for the head and totals
#We defined the tax rated as 6%
#We will try this view for INVOICE_NUMBER = 1
create or replace view INVOICE_HEAD_TOTALS as 
select i.INVOICE_ID as INVOICE_NUMBER, i.DATE_OF_ISSUE as DATE_OF_ISSUE, 
concat(c.FIRST_NAME, " ", c.LAST_NAME) as COSTUMER_NAME, l.STREET as STREET, 
concat(l.CITY, ", ", l.DISTRICT, ", ", co.COUNTRY_NAME) as `CITY, DISTRICT, COUNTRY`, l.POSTAL_CODE as POSTAL_CODE, 
"Miguel Nogueira Junior Street, 50, 1950-162, Lisboa, Portugal" as LIMITEDRIP, TOTAL.SUB_TOTAL , ifnull((di.DISCOUNT_VALUE*TOTAL.SUB_TOTAL), 0) as DISCOUNT, i.TAX_RATE as TAX_RATE, 
(i.TAX_RATE* TOTAL.SUB_TOTAL) as TAX, (TOTAL.SUB_TOTAL-ifnull((di.DISCOUNT_VALUE*TOTAL.SUB_TOTAL),0)+(i.TAX_RATE*TOTAL.SUB_TOTAL)) as INVOICE_TOTAL
from invoice as i
join customer c on c.CUSTOMER_ID=i.CUSTOMER_ID 
join location l on l.LOCATION_ID=c.LOCATION_ID 
join country co on co.COUNTRY_ID=l.COUNTRY_ID
LEFT join discount di on di.DISCOUNT_ID=i.DISCOUNT_ID
join (select i.INVOICE_ID, SUM((o.QUANTITY)*(p.PRODUCT_PRICE-(p.PRODUCT_PRICE*p.PRODUCT_DISCOUNT))) as SUB_TOTAL
from product as p
join `order` o on p.PRODUCT_ID=O.PRODUCT_ID
join invoice i on o.INVOICE_ID=i.INVOICE_ID
group by i.INVOICE_ID ) AS TOTAL
on TOTAL.INVOICE_ID=i.INVOICE_ID;

#In order to see the views
#SELECT *
#FROM INVOICE_HEAD_TOTALS
#WHERE INVOICE_NUMBER = 1;

#Select *
#from INVOICE_DETAILS
#WHERE INVOICE_NUMBER = 1