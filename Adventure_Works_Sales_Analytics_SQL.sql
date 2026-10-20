CREATE DATABASE AdventureWorks;
USE AdventureWorks;
show tables;

SELECT * FROM dimcustomer LIMIT 5;
SELECT * FROM dimproduct LIMIT 5;
SELECT * FROM dimproductcategory LIMIT 5;
SELECT * FROM dimproductsubcategory LIMIT 5;
SELECT * FROM dimsalesterritory LIMIT 5;
SELECT * FROM factinternetsales LIMIT 5;
SELECT * FROM fact_internet_sales_new LIMIT 5;



## Task 0 Union of Fact Internet sales and Fact internet sales new
CREATE TABLE sales AS 
SELECT * FROM factinternetsales
UNION ALL 
SELECT * FROM fact_internet_sales_new;

SELECT * FROM sales;

## Task 1 Lookup the productname from the Product sheet to Sales sheet.

ALTER TABLE sales
 ADD ProductName VARCHAR(200);

UPDATE sales s
JOIN dimproduct p 
ON s.ProductKey=p.ProductKey 
SET s.ProductName=p.EnglishProductName;

## Task 2 Lookup the Customerfullname from the Customer and Unit Price from Product sheet to Sales sheet

SELECT s.*,
CONCAT(c.FirstName,' ',c.LastName) AS CustomerFullName,
p.`Unit price`
FROM FactInternetSales s
LEFT JOIN DimCustomer c
ON s.CustomerKey=c.CustomerKey
LEFT JOIN DimProduct p
ON s.ProductKey=p.ProductKey;

## Task 3
# AA  Create a Date Field from Orderdatekey
SELECT
OrderDateKey,
STR_TO_DATE(OrderDateKey,'%Y%m%d') AS OrderDate
FROM Sales;

# BB Year
SELECT
    OrderDateKey,
    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year
FROM Sales;

# CC  Monthnumber
SELECT
    OrderDateKey,
MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d')) AS MonthNo
FROM Sales;

# DD  Monthfullname
SELECT
    OrderDateKey,
    MONTHNAME(STR_TO_DATE(OrderDateKey,'%Y%m%d')) AS MonthName
    FROM Sales;
    
# EE  Quarter(Q1,Q2,Q3,Q4)
SELECT
    OrderDateKey,
    CONCAT('Q',QUARTER(STR_TO_DATE(OrderDateKey,'%Y%m%d'))) AS Quarter
    FROM Sales;

# FF  YearMonth ( YYYY-MMM)
SELECT
    OrderDateKey,
    DATE_FORMAT(
STR_TO_DATE(OrderDateKey,'%Y%m%d'),
'%Y-%b'
) AS YearMonth
FROM Sales;

# GG  Weekdayno
SELECT
    OrderDateKey,
    DAYOFWEEK(
STR_TO_DATE(OrderDateKey,'%Y%m%d')
) AS WeekdayNo
FROM Sales;

# HH  Weekdayname
SELECT
    OrderDateKey,
    DAYNAME(
STR_TO_DATE(OrderDateKey,'%Y%m%d')
) AS WeekdayName
FROM Sales;

# II  FinancialMonth
SELECT
    OrderDateKey,
CASE
WHEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d'))>=4
THEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d'))-3
ELSE MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d'))+9
END AS FinancialMonth
FROM Sales;

# JJ  Financial Quarter 
SELECT
    OrderDateKey,
CASE
WHEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q1'
WHEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q2'
WHEN MONTH(STR_TO_DATE(OrderDateKey,'%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q3'
ELSE 'Q4'
END AS FinancialQuarter
FROM Sales;

## Task 4 Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)

SELECT
    SalesOrderNumber,
    ProductKey,
    OrderQuantity,
    UnitPrice,
    UnitPriceDiscountPct,
    (UnitPrice * OrderQuantity) -
    (UnitPrice * OrderQuantity * UnitPriceDiscountPct) AS SalesAmount
FROM Sales;

## Task 5 Calculate the Productioncost uning the columns(unit cost ,order quantity)
SELECT
    SalesOrderNumber,
    ProductKey,
    OrderQuantity,
    UnitPrice,
UnitPrice*OrderQuantity
AS ProductionCost
FROM Sales;

##  Task 6  Calculate the profit.
SELECT
    SalesOrderNumber,
    ProductKey,
    OrderQuantity,
    UnitPrice,
    totalproductcost,
    UnitPriceDiscountPct,
(
(UnitPrice*OrderQuantity)
-(UnitPrice*UnitPriceDiscountPct*OrderQuantity)
)-(totalproductcost*OrderQuantity)
AS Profit
FROM Sales;

select * from sales;
