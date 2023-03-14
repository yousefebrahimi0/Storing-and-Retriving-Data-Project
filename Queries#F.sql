USE limitedrip;
#Question F

#1 List all the customer’s names, dates, and products or services used/booked/rented/bought by these customers in a range of two dates.
SELECT concat(c.`FIRST_NAME`, ' ', c.`LAST_NAME`) as `Customer Name`, o.`DATE_OF_PURCHASE` as `Date of purchase`, p.`PRODUCT_NAME` as `Product bought`
FROM CUSTOMER c, `ORDER` o, PRODUCT p, `INVOICE` i
WHERE c.customer_id = i.customer_id and o.invoice_id = i.invoice_id and o.product_id = p.product_id and o.`DATE_OF_PURCHASE` between '2022-03-25' and '2022-04-08';

#2 List the best three customers/products/services/places - People who bought most shoes
SELECT concat(c.`FIRST_NAME`, ' ', c.`LAST_NAME`) as `Customer Name`, 
sum((o.QUANTITY)) as `Pairs of shoes bought`
FROM `CUSTOMER` c, `ORDER` o, `PRODUCT` p, `INVOICE` i
WHERE c.customer_id = i.customer_id and o.invoice_id = i.invoice_id and o.product_id = p.product_id 
GROUP BY `Customer Name`
ORDER BY `Pairs of shoes bought` DESC
LIMIT 3; #we only want the 3 best costumers

#3 Get the average amount of sales/bookings/rents/deliveries for a period that involves 2 or more years
#year = 365 days and month = 30 days
SELECT concat(min(o.`DATE_OF_PURCHASE`), ' - ', max(o.`DATE_OF_PURCHASE`)) as Period_of_Sales, 
sum((o.QUANTITY)*(p.PRODUCT_PRICE-(p.PRODUCT_PRICE*p.PRODUCT_DISCOUNT))) as Total_Sales, 
round(sum((o.QUANTITY)*(p.PRODUCT_PRICE))/(datediff(max(o.`DATE_OF_PURCHASE`), min(o.`DATE_OF_PURCHASE`))/365), 2) as Yearly_Average,
round(sum((o.QUANTITY)*(p.PRODUCT_PRICE))/(datediff(max(o.`DATE_OF_PURCHASE`), min(o.`DATE_OF_PURCHASE`))/30), 2) as Monthly_Average
FROM `CUSTOMER` c, `ORDER` o, `PRODUCT` p, `INVOICE` i
WHERE c.customer_id = i.customer_id and o.invoice_id = i.invoice_id and o.product_id = p.product_id;

#4 Total pairs of shoes sold by city 
select co.COUNTRY_NAME as Country, l.CITY as City, SUM(o.QUANTITY) as ShoesSoldPerCity
from product as p
join `order` o on p.PRODUCT_ID=O.PRODUCT_ID
join invoice i on o.INVOICE_ID=i.INVOICE_ID
join customer c on c.CUSTOMER_ID=i.CUSTOMER_ID
join location l on c.LOCATION_ID=l.LOCATION_ID
join country co on l.COUNTRY_ID=co.COUNTRY_ID
group by co.COUNTRY_ID, l.CITY;

#5 List all the locations where products/services were sold, and the product has customer’s ratings
select distinct(concat(l.STREET, ", ", l.POSTAL_CODE, ", ", l.CITY)) as Location
,p.PRODUCT_NAME as Product, r.RATING as Rating
from location l
join customer c on c.LOCATION_ID=l.LOCATION_ID
join rating r on c.CUSTOMER_ID=r.CUSTOMER_ID
join product p on r.PRODUCT_ID=p.PRODUCT_ID;