CREATE DATABASE SQL_PROJECT_P1;

USE SQL_PROJECT_P1;

SELECT * FROM retail_sales;


-- Top 10 rows
SELECT top(10) * from retail_sales;


-- Total no of sales
SELECT COUNT(*) FROM retail_sales;


--Data cleaning


SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;



-- KPI


--Total no of customers
select count(distinct customer_id) from retail_sales;


--Total sale value
select sum(total_sale) as Total_sales from retail_sales;


--Type of categories
select distinct category from retail_sales;


--All Transactions for sales made on '2022-11-05
   select * from retail_sales
   where sale_date = '2022-11-05';


-- All transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
       select * from retail_sales
	   where category = 'Clothing' and YEAR(sale_date) = '2022' and month(sale_date) = '11' and quantity > 10;

	                            
-- Calculation of total sales for each category.
       select category,Sum(total_sale) as Turnover ,count(*) as total_order from retail_sales
	   group by category;



-- Average age of customers who purchased items from the 'Beauty' category.
       select avg(age) as avg_age ,category  from retail_sales
	   where category = 'Beauty'
	   group by category;



--All transactions where the total_sale is greater than 1000.
    select * from retail_sales
	where total_sale > 1000;


-- Total number of transactions  made by each gender in each category.
      select   category , gender ,count(transactions_id) as no_of_transactions from retail_sales
	  group by gender , category
	  order by no_of_transactions desc;


-- Calculation of average sale for each month. Find out best selling month in each year
    
	select years ,months, avg_sales from 
	(
	select year(sale_date) as years,
	        month(sale_date) as months,
			avg(total_sale) as avg_sales ,
			rank() over( partition by year(sale_date) order by  avg(total_sale) desc) as ranking
	 from retail_sales
	 group by  year(sale_date), month(sale_date)
	 ) as T1
	 where ranking = 1;
	
	
	  
	 

--Top 5 customers based on the highest total sales 
     select top 5
	    customer_id ,
	    sum(total_sale) as TS 
	 from retail_sales
	 group by customer_id
	 order by TS desc;
	
	






-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
        select  category ,
		        count(distinct(customer_id))
		from retail_sales
		group by category ;





-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
 


select 
      case when DATEPART(HOUR,sale_time) <=12 then 'Morning'
	       when DATEPART(HOUR , sale_time) between 12 and 17 then 'Afternoon'
		   Else 'Evening'
	  End as Shift ,
		   count(*) as 'Total_orders'
		   from retail_sales
group by 
      case when DATEPART(HOUR,sale_time) <=12 then 'Morning'
	       when DATEPART(HOUR , sale_time) between 12 and 17 then 'Afternoon'
		   Else 'Evening'
	  End;





   