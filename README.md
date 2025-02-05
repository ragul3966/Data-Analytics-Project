# Retail Sales Analysis SQL Project

## Project Overview
 
**Database**: `SQL_PROJECT_P1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Data Source

The primary data source used for the csv table that is " Retail Sales.csv ",all the details are mentioned in the table.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `SQL_PROJECT_P1`.
- **Import of Dataset**: A table named `retail_sales` was imported to retrive the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```
### 3. Data Analysis & Findings

###  KPI
**Total no of customers**
```sql
select count(distinct customer_id) from retail_sales;
```
**Total sale value**
```sql
select sum(total_sale) as Total_sales from retail_sales;
```
**Type of categories**
```sql
select distinct category from retail_sales;
```



### 4 . The following SQL queries were developed to answer specific business questions:

 **All Transactions for sales made on '2022-11-05**
  ```sql
 select * from retail_sales
 where sale_date = '2022-11-05';
```
**All transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022**
```sql
   select * from retail_sales
   where category = 'Clothing' and YEAR(sale_date) = '2022' and month(sale_date) = '11' and quantity > 10;
```                          
**Calculation of total sales for each category.**
```sql
select category,Sum(total_sale) as Turnover ,count(*) as total_order from retail_sales
group by category;
```

**Average age of customers who purchased items from the 'Beauty' category**
```sql
select avg(age) as avg_age ,category  from retail_sales
where category = 'Beauty'
group by category;
```

**All transactions where the total_sale is greater than 1000.**
```sql
select * from retail_sales
where total_sale > 1000;
```

**Total number of transactions  made by each gender in each category.**
  ```sql
select   category , gender ,count(transactions_id) as no_of_transactions from retail_sales
group by gender , category
order by no_of_transactions desc;
```

**Calculation of average sale for each month. Find out best selling month in each year**
```sql
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
```
	
**Top 5 customers based on the highest total sales**
```sql
select top 5
   customer_id ,
   sum(total_sale) as TS 
 from retail_sales
 group by customer_id
 order by TS desc;
```	

**Number of unique customers who purchased items from each category.**
```sql
 select  category ,
            count(distinct(customer_id))
from retail_sales
group by category ;
```

**Each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)**
```sql 
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons for each years.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL data analysis, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author   - 

**RAGUL.C**
