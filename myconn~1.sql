/* View Creation */
create view v2 As select Quantity, idshopper, total from bb_basket;
describe v2;
select * from v2;

/* Read Only View Creation */
create view v3 AS select Quantity, idshopper, total from bb_basket with read only;
create view BasketItem6 As select idBasketItem, idproduct, price quantity from BB_basketItem;
select * from BasketItem6 where idproduct = 6;
update v3 set total = 100;

/* DML performed in View */
create view price 
As select idBasketItem, idproduct, price, quantity
from BB_BASKETITEM;
Select * from price where idproduct =6;
update price set price = 40 where idproduct = 6;

/* Order By */
select idBasketItem, idProduct, price from
order by price desc;

/* multi View */
create view multiTableView3
AS SELECT * from BB_BasketItem JOIN BB_Basket
Using(IDBASKET);

 /* Materialized View */
Create MATERIALIZED view BasktItem
REFRESH COMPLETE
START WITH SYSDATE NEXT SYSDATE+7
AS SELECT idBasketItem, idproduct
FROM BB_BasketItem JOIN BB_Basket
Using(IDBASKET);

create MATERIALIZED view v8
REFRESH COMPLETE
START WITH SYSDATE NEXT SYSDATE+7
AS select Quantity, idshopper, total from bb_basket;

/* Left padding */
Select * from BB_DEPARTMENT; 
select deptname, LPAD(deptname, 24, '*') 
from BB_DEPARTMENT
where DEPTNAME like 'C%';

/* Left and Right Padding */
Select * from bb_product;
select productname, LPAD(productname, 15, '$'), RPAD(productname, 15, '$') from BB_PRODUCT where productname like 'S%';

/* */
select productname, LTRIM(productname, 'coffee')"Description"
from bb_product
where productname like'Coffee%'

/* */
select Deptname, DeptDesc, concat(Deptname, Deptdesc) Deptreference
from bb_department;
Select Deptname, DeptDesc, concat(concat(Deptname, ' '), Deptdesc) Deptreference
from bb_department;

Select productname, concat(concat(productname, ' '), description) productreference
from bb_product;

from bb_product
where productname like'Coffee%'



/* Question1 */

SELECT idproduct FROM bb_product WHERE Status='sold' 
select distinct bskt_item.idproduct from bb_basketitem bskt_item, bb_basket bskt
where bskt_item.idbasket = bskt.idbasket and bskt.orderplaced > 0;

/* Question2 */

SELECT  b.idbasket, p.idproduct, p.productname, p.description
FROM bb_basket b, bb_basketitem bi, bb_product p
WHERE b.idbasket = bi.idbasket AND bi.idproduct= p.idproduct and b.orderplaced >  0
ORDER BY b.idbasket;

SELECT bi.idbasket, p.idproduct, p.productname, p.description
FROM bb_product p, bb_basketitem bi
WHERE p.idproduct = bi.idproduct AND (p.ordered > 0 OR p.reorder >0) ;


SELECT b.idbasket, p.idproduct, p.productname, p.description
FROM bb_basket b JOIN bb_basketitem bi USING , bb_product p
WHERE b.idbasket = bi.idbasket AND bi.idproduct= p.idproduct and b.orderplaced >  0
ORDER BY b.idbasket;

describe bb_basket;

/* Question3 */
select s.lastname, b.idbasket, p.idproduct, p.productname
from bb_product p, bb_basket b, bb_shopper s
where p.ordered > 0;

/* Question4 */

SELECT b.idbasket, idshopper, TO_CHAR(b.dtordered,'MONTH DD, YYYY') AS "Date Ordered"
FROM bb_basket b INNER JOIN bb_shopper s USING(idshopper)
WHERE b.orderplaced > 0 
AND TRUNC(b.dtordered, 'MONTH') = '01-FEB-12';

/* Question 5 */
SELECT idproduct, SUM(quantity) AS "Total Quantity" FROM bb_basketitem GROUP BY idproduct ORDER BY idproduct;

/* Question 6 */
SELECT idproduct, SUM(quantity) FROM bb_basketitem GROUP BY idproduct HAVING SUM(quantity) < 3;

/* Question 7 */
SELECT idproduct, productname, price 
FROM bb_product 
WHERE active = 1 AND price > (SELECT AVG(price) from bb_product);

/* Question 8 */
CREATE TABLE contacts
(
con_id NUMBER(4),
company_name VARCHAR2(30));

create table contacts(CON_ID number(4), company_name varchar2(30));
insert into contacts(con_id, company_name) values(123, 'Wipro');

Drop table contacts;

/* Question 9 */
INSERT INTO c
select * from contacts;

describe contacts;

INSERT INTO contacts(con_id, company_name, email, last_date,con_ent) VALUES(1547, 'Wipro', 'Wipmail@wipro.com', '01/01/2017', 12);

insert into contacts (con_id, company_name) values(1547, 'Wipro');

insert into bb_department (iddepartment, deptname) values (12, 'test_dept1');
insert into bb_department (iddepartment, deptname) values (13, 'test_dept1');

describe contacts;


select * from bb_department;
select * from bb_productoption;
select * from bb_productoptiondetail;
select * from bb_productoptioncategory;
select * from bb_product;
select idbasket, orderplaced, dtcreated, dtordered from bb_basket;
select * from bb_basketstatus;
select * from bb_basketitem;
select * from bb_shopper;


