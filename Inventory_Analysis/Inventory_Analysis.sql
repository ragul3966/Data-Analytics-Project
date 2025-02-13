USE SALES;


--Retreiving all the tables using SELECT command

SELECT * FROM data_dictionary;--This table is just for describing the data which will not been considered to evaluate.
select * from sales;
select * from products;
select * from calendar
select * from inv;
select * from stores;


--DATA CLEANING (checking for null values and Data Types of each )

-- DATA TYPES AS BEFORE

/*RELATIONSHIP DRAWING
1.Store_ID(tinyint),
  Store_name(nvarchar),
  Store_City(nvarchar),
  Store_Location(nvarchar),
  Store_open_date(date)             
summary:-stores  (no missing values in each column)

2.Sale_ID(int),
  ConvertedDate(Date),
  Store_ID(int),
  Product_ID(int),
  units(int)
Summary:-sales   (no missing values in each column)

3.Product_ID(tinyint),
  Product_Name(nvarchar),
  Product_Category(nvarchar),
  Product_Cost(money),
  Product_Price(money)
Summary:-products (no missing values in each column)

4.Store_ID(tinyint),
  Product_ID(tinyint),
  Stock_On_Hand(tinyint)
Summary:-inventory (no missing values in each column)

5.Date(date)
summary:-calendar  (no missing values in each column) */

--Inventory and products columns are lookingv fine


--UPDATING TABLE SALES 

SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales';

ALTER TABLE sales
ALTER COLUMN Sale_ID INT;

ALTER TABLE sales
ALTER COLUMN store_ID INT;

ALTER TABLE sales
ALTER COLUMN Product_ID INT;

ALTER TABLE sales
ALTER COLUMN Units INT;




--UPDATING TABLE PRODUCTS

SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Products';

ALTER TABLE Products
ALTER COLUMN Product_ID INT;

ALTER TABLE Products
ALTER COLUMN Product_Cost INT;

ALTER TABLE Products
ALTER COLUMN Product_Price INT;




--UPDATING TABLE STORES

SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'stores';

ALTER TABLE stores
ALTER COLUMN Store_ID INT;




--UPDATING TABLE INVENTORY

SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'inv';

ALTER TABLE inv
ALTER COLUMN Store_ID INT;

ALTER TABLE inv
ALTER COLUMN Product_ID INT;

ALTER TABLE inv
ALTER COLUMN Stock_On_Hand INT;


--Adding constraints to the columns (Add all the respective keys and constraints to improve data consistency and accuracy.)

--Stores table

SELECT * FROM stores;

ALTER TABLE stores 
ALTER COLUMN Store_Name NVARCHAR(100) NOT NULL;

ALTER TABLE stores
ALTER COLUMN Store_City NVARCHAR(100) NOT NULL;

ALTER TABLE stores 
ALTER COLUMN Store_Location VARCHAR(100) NOT NULL;

ALTER TABLE stores 
ALTER COLUMN Store_open_date DATE NOT NULL;

ALTER TABLE stores
ALTER COLUMN Store_ID INT NOT NULL;

ALTER TABLE stores 
ADD CONSTRAINT PK_Store_ID PRIMARY KEY (Store_ID);

ALTER TABLE stores 
ADD CONSTRAINT UQ_Store_name UNIQUE (Store_name);



--Sales table

SELECT * FROM sales;

ALTER TABLE sales 
ALTER COLUMN  Date  DATE NOT NULL;

ALTER TABLE sales 
ALTER COLUMN Store_ID INT NOT NULL;

ALTER TABLE sales 
ALTER COLUMN Product_ID INT NOT NULL;

ALTER TABLE sales 
ALTER COLUMN units INT NOT NULL;

ALTER TABLE sales 
ALTER COLUMN Sale_ID INT NOT NULL;

ALTER TABLE sales 
ADD CONSTRAINT PK_Sale_ID PRIMARY KEY (Sale_ID);

ALTER TABLE sales 
ADD CONSTRAINT FK_Sales_Store_ID FOREIGN KEY (Store_ID) REFERENCES stores(Store_ID);

ALTER TABLE sales 
ADD CONSTRAINT FK_Sales_Product_ID FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID);



-- Products table

select * from products

ALTER TABLE products 
ALTER COLUMN Product_Name NVARCHAR(100) NOT NULL;

ALTER TABLE products 
ALTER COLUMN Product_Category NVARCHAR(100) NOT NULL;

ALTER TABLE products 
ALTER COLUMN Product_Cost money NOT NULL;

ALTER TABLE products 
ALTER COLUMN Product_Price money NOT NULL;

ALTER TABLE products 
ALTER COLUMN Product_ID INT NOT NULL;

ALTER TABLE products 
ADD CONSTRAINT PK_Product_ID PRIMARY KEY (Product_ID);

ALTER TABLE products 
ADD CONSTRAINT UQ_Product_Name UNIQUE (Product_Name);



-- Inventory table 


SELECT * FROM inv;

ALTER TABLE inv
ALTER COLUMN Stock_On_Hand INT NOT NULL;

ALTER TABLE inv
ADD CONSTRAINT FK_Inventory_Sale_ID FOREIGN KEY (Store_ID) REFERENCES stores(Store_ID);

ALTER TABLE inv
ADD CONSTRAINT FK_Inv_Product_ID FOREIGN KEY (Product_ID) REFERENCES products(Product_ID);




--Key Factors

--Top sales by store(which store sold more products)

SELECT s.Store_name, SUM(sa.units) AS Total_Units_Sold
FROM sales sa
JOIN stores s ON sa.Store_ID = s.Store_ID
GROUP BY s.Store_name
ORDER BY Total_Units_Sold DESC;

--Top selling products(what are all the top selling products)

SELECT p.Product_Name, SUM(sa.units) AS Total_Units_Sold
FROM sales sa
JOIN products p ON sa.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Units_Sold DESC;

--Inventory status((which product stock is left more in the inventory)
SELECT p.Product_Name, i.Stock_On_Hand
FROM inv i
JOIN products p ON i.Product_ID = p.Product_ID
ORDER BY i.Stock_On_Hand DESC;

--Sales overtime(Sales happend from start to end,with total units sold)
SELECT c.Date, SUM(s.units) AS Total_Units_Sold
FROM sales s
JOIN calendar c ON s.DATE =c.DATE
GROUP BY c.DATE
ORDER BY c.DATE;

--Store sales performance
SELECT s.Store_name, SUM(sa.units * p.Product_Price) AS Total_Sales
FROM sales sa
JOIN stores s ON sa.Store_ID = s.Store_ID
JOIN products p ON sa.Product_ID = p.Product_ID
GROUP BY s.Store_name
ORDER BY Total_Sales DESC;



--Analysis 


--1. Production Performance Analysis
--Goal- Identify top-performing products based on total sales and profit.

SELECT P.PRODUCT_ID,  P.PRODUCT_NAME, ROUND(SUM(S.UNITS * P.PRODUCT_PRICE),0) AS TOTAL_SALES ,SUM((P.PRODUCT_PRICE - P.PRODUCT_COST)*S.UNITS) AS TOTAL_PROFIT
FROM Products p
INNER JOIN SALES s
ON P.PRODUCT_ID = S.PRODUCT_ID
GROUP BY P.PRODUCT_ID , P.PRODUCT_NAME
ORDER BY TOTAL_PROFIT DESC, TOTAL_SALES DESC;


--2. Store Performance Analysis
--Goal- Analyse sales performance for each store, including total revenue and profit margin. 

SELECT 
      ST.STORE_ID,
	  ST.STORE_NAME,
       ROUND(SUM(SS.UNITS * PP.PRODUCT_PRICE),0) AS TOTAL_SALES,
	   SUM((PP.PRODUCT_PRICE - PP.PRODUCT_COST)*SS.UNITS) AS TOTAL_PROFIT,
	   ROUND(
        (SUM((PP.product_price - PP.product_cost) * SS.UNITS) / 
         NULLIF(SUM(SS.UNITS * PP.product_price), 0)) * 100, 2
    ) AS profit_margin
	
FROM STORES ST
INNER JOIN SALES SS
ON ST.STORE_ID = SS.STORE_ID
INNER JOIN  PRODUCTS PP
ON SS.PRODUCT_ID = PP.PRODUCT_ID
GROUP BY ST.STORE_ID , ST.STORE_NAME
ORDER BY TOTAL_SALES DESC;


--3. Complex Monthly Sales Trend Analysis:
-- Goal- Examine monthly sales trends, considering the rolling 3-month average and identifying months with significant growth or decline.

-- Create an index on DATE in the sales table
CREATE INDEX idx_sales_date ON sales(DATE);

-- Create an index on Product_ID in the sales table
CREATE INDEX idx_sales_product_id ON sales(Product_ID);

-- Create an index on Product_ID in the products table
CREATE INDEX idx_products_product_id ON products(Product_ID);



SELECT FORMAT(s.DATE, 'yyyy-MM') AS Month,SUM(s.units * p.Product_Price) AS Total_Revenue,
       AVG(SUM(s.units * p.Product_Price)) OVER (ORDER BY FORMAT(s.DATE, 'yyyy-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Three_Month_Avg,
    CASE 
        WHEN SUM(s.units * p.Product_Price) > AVG(SUM(s.units * p.Product_Price)) OVER (ORDER BY FORMAT(s.DATE, 'yyyy-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) * 1.1 THEN 'Significant Growth'
        WHEN SUM(s.units * p.Product_Price) < AVG(SUM(s.units * p.Product_Price)) OVER (ORDER BY FORMAT(s.DATE, 'yyyy-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) * 0.9 THEN 'Significant Decline'
        ELSE 'Stable'
    END AS Performance
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY FORMAT(s.DATE, 'yyyy-MM')
ORDER BY Month;


--4.Cumulative Distribution of Profit Margin:
--Goal- Calculate the cumulative distribution of profit margin for each product category, consider where products are having profit.

SELECT
    p.Product_Category,
    p.Product_Name,
    ((p.Product_Price - p.Product_Cost) / p.Product_Price) * 100 AS Profit_Margin,
    SUM(((p.Product_Price - p.Product_Cost) / p.Product_Price) * 100) 
        OVER (PARTITION BY p.Product_Category ORDER BY ((p.Product_Price - p.Product_Cost) / p.Product_Price) * 100 ASC) AS Cumulative_Profit_Margin
FROM products p
WHERE p.Product_Price > p.Product_Cost -- Only include profitable products
ORDER BY p.Product_Category,Cumulative_Profit_Margin;



--5. Store Inventory Turnover Analysis:
--Goal: Analyze the efficiency of inventory turnover for each store by calculating the Inventory Turnover Ratio.


SELECT s.Store_ID,SUM(s.units * p.Product_Cost) AS COGS,AVG(i.Stock_On_Hand) AS Avg_Inventory,    --COGS-->Cost Of Goods Sold
    CASE 
        WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL -- To handle division by zero
        ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
    END AS Inventory_Turnover_Ratio,
    -- Calculate Max_Turnover_Ratio across all stores
    MAX(CASE 
        WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
        ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
    END) OVER () AS Max_Turnover_Ratio,
    -- Calculate efficiency percentage based on Max_Turnover_Ratio
    CASE 
        WHEN MAX(CASE 
                    WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
                    ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
                 END) OVER () IS NULL
            OR MAX(CASE 
                    WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
                    ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
                 END) OVER () = 0 THEN NULL
        ELSE (CASE 
                WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
                ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
             END / MAX(CASE 
                            WHEN AVG(i.Stock_On_Hand) = 0 THEN NULL
                            ELSE SUM(s.units * p.Product_Cost) / AVG(i.Stock_On_Hand)
                         END) OVER ()) * 100
    END AS Inventory_Turnover_Efficiency_Percentage
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
JOIN inv i ON s.Store_ID = i.Store_ID
GROUP BY s.Store_ID
ORDER BY s.Store_ID;


