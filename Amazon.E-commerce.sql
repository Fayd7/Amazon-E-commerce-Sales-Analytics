use amazon;
select * from sales;

#Q1: Find the total revenue (price × quantity) per region.

select region, round(sum(price * quantity),2) as total_revenue
from sales
group by region
order by sum(price * quantity) desc;

#Q2: Show top 5 product categories by total revenue.

select  category, round(sum(price * quantity),2) as total_revenue
from sales
group by category
order by total_revenue desc 
limit 5;


#Q3: Calculate average discount (%) for each payment method.

select payment_method, round(avg(discount),2) as avg_discount
from sales
group by payment_method
order  by avg_discount desc;


#Q4: Find orders where delivery delay is more than 10 days.

select order_id,customer_name,delivery_delay_days from sales
where delivery_delay_days >=10
group by order_id,customer_name,delivery_delay_days
order by delivery_delay_days desc;

#Q5: Count how many orders were made each month of 2024.

select month( order_date) as month,
count(*) as total_orders 
from sales
where extract(year from order_date)= 2024
group by  month
order by month asc;


#Q6: Find number of returned vs. non-returned orders by region.

select region,
       sum(case when return_requested = True then 1 else 0 end) as returned,
	   sum(case when return_requested = False then 1 else 0 end) as non_returned
from sales
group by region;

#Q7: Rank customers by total spending across all orders.
 
 select customer_name, round(sum(price*quantity),2) as total_spent,
 rank() over(order by round(sum(price*quantity),2)) as rnk
 from sales 
 group by customer_name;
 
 #Q8: Within each region, rank categories by revenue.
 
select category, region ,round(sum(price*quantity),2) as revenue,
rank() over (partition by region order by round(sum(price*quantity),2)desc) as rnk
from sales
group by  category, region;
 
#Q9: Using a CTE, find top customer per region by total spending.

with customer_spending as (
        select customer_name, region ,round(sum(price*quantity),2) as total_spent,
		rank() over(partition by region order by round(sum(price*quantity),2) desc) as spend_rnk
		from sales
        group by customer_name, region 
)
select customer_name, region ,total_spent
from customer_spending
where spend_rnk = 1;

#Q10: Find average shipping cost per order by region.

select region, round(AVG(shipping_cost),2) as avg_cost
from sales
group by region
order by avg_cost DESC;

#Q11: Find how many reviews mention “refund”.

SELECT count(*) as refund_mentions
from sales
where lower(review_text) like 'refund';


#Q12: Find most commonly used payment method in each region.


WITH payment_counts AS (
    SELECT 
        region, 
        payment_method, 
        COUNT(*) AS usage_count
    FROM sales
    GROUP BY region, payment_method
),
ranked AS (
    SELECT 
        region, 
        payment_method, 
        usage_count,
        RANK() OVER (PARTITION BY region ORDER BY usage_count DESC) AS rnk
    FROM payment_counts
)
SELECT region, payment_method, usage_count
FROM ranked
WHERE rnk = 1;

#Q13: Estimate total sales in USD assuming all non-USD currencies use a 0.27 exchange rate.

select 
round(sum(case when currency = 'usd' then price*quantity
     else price*quantity*0.27 end ),2) as total_sale_usd
from sales;


#Q14: Rank each product within its category by number of orders.

 select category,product_name, count(order_id) as total_orders,
rank() over (partition  by category order by  count(order_id) desc) as rnk
from sales 
group  by  category,product_name;

#Q15: Find the top 3 customers per region by total spending.
 
 with ranked_customer as
 (
 select region,customer_name, round(sum(price*quantity),2) as total_spent,
 rank() over ( partition by region order by round(sum(price*quantity),2) desc) as rnk
 from sales
 group by region,customer_name
) 
select region,customer_name,total_spent
from ranked_customer
where rnk <=3;

 
#Q17: Compute 3-month rolling total revenue.

SELECT 
    month( order_date) AS month,
    SUM(price * quantity) AS monthly_sales,
    SUM(SUM(price * quantity)) OVER (ORDER BY month( order_date)
                                     ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3_month_sales
FROM sales
GROUP BY month
ORDER BY month;


#Q18: Find the difference in daily sales compared to the previous day.

select order_date , round(SUM(price * quantity),2) AS daily_sales,
SUM(price * quantity) - lag(round(SUM(price * quantity),2)) over (order by order_date) as sales_change
from sales
group by order_date
order by order_date;




#Q19: Find the top 5 highest-rated products per category.

select * from
(
select category,product_name, rating,
rank() over (partition  by category order by  rating desc) as rnk
from sales 
group by  category,product_name, rating
) sub
where rnk <=5;




#Q20: Find orders that have a higher price than the average price of their category.

SELECT order_id, product_name, price, category
FROM sales s
WHERE price > (
    SELECT AVG(price)
    FROM sales
    WHERE category = 
    s.category);










