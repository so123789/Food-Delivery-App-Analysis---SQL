use  food;

select name from users where user_id not in (select user_id from orders);


select * from foodlist;
select * from restaurants;
select * from order_details;
select f_name as FoodName, round(avg(price),0) AS avg_price 
from foodlist join menu on foodlist.f_id = menu.f_id group by f_name order by avg(price);

select r_name , count(order_id) AS TotalOrders 
from orders join restaurants on orders.r_id = restaurants.r_id 
where date between '2022-06-01' AND '2022-06-30'
 group by r_name
 order by TotalOrders DESC ;
 
 select r.r_name, count(*) AS 'month' 
 from orders o join restaurants r
 on o.r_id = r.r_id 
 where monthname(date) like 'June'
 group by r.r_id, r.r_name
 order by count(*) desc limit 1;
 

 
SELECT r.r_name, SUM(o.amount) AS 'revenue'
FROM orders o 
JOIN restaurants r ON o.r_id = r.r_id
WHERE MONTHNAME(o.date) LIKE 'June'
GROUP BY r.r_id, r.r_name
HAVING revenue > 500
LIMIT 0, 1000;

 
select o.order_id, od.f_id, o.date, r.r_name, f.f_name, o.amount
from orders o join restaurants r  on r.r_id = o.r_id
join order_details od on o.order_id = od.order_id
join foodlist f on f.f_id = od.f_id
where user_id = (select user_id from users where name like 'Ankit')
and date between '2022-06-01' and '2022-07-31';

-- ///
select r.r_name, u.name, count(*) AS 'Visits'from 
orders o join restaurants r on o.r_id=r.r_id
join users u on o.user_id = u.user_id 
group by r.r_name, u.name
having Visits > 1
order by Visits desc;

select r.r_name, count(*) as 'Repeated_Customers'
from (select r_id, user_id, count(*) AS 'Visits'
from orders group by r_id, user_id
having visits > 1) t
join restaurants r on r.r_id = t.r_id
group by r.r_name
order by Repeated_Customers
desc limit 3;

select month, ((revenueg - prev) / prev) * 100 from (
	with sales as (
		select monthname(date) as 'month', sum(amount) as 'revenueg' from orders
        group by month, revenueg
        order by MONTH(date)
	) select month, revenueg, lag(revenueg,1) over(order by revenueg) as 'prev' from sales) t;
    
    
SELECT month, round(((revenueg - prev) / prev) * 100,2) AS growth_percentage
FROM (
    WITH sales AS (
        SELECT MONTHNAME(date) AS month, 
               SUM(amount) AS revenueg
        FROM orders
        GROUP BY MONTH(date), MONTHNAME(date)
        ORDER BY MONTH(date)
    )
    SELECT month, 
           revenueg, 
           LAG(revenueg, 1) OVER (ORDER BY MONTH(STR_TO_DATE(month, '%M'))) AS prev
    FROM sales
) t;


WITH temp AS(
	select o.user_id, od.f_id, count(*) AS Order_Count
    from orders o join order_details od on o.order_id = od.order_id
    group by o.user_id, od.f_id
    )
    select u.name, f.f_name, t1.Order_Count from temp t1
    join users u  on u.user_id = t1.user_id join foodlist f on f.f_id = t1.f_id 
    where t1.Order_Count = (select max(Order_Count) from temp t2 where t2.user_id = t1.user_id);