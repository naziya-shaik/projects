create database zomato;
use zomato;
-- 1)For a high-level overview of the hotels, provide us the top 5 most voted hotels in the delivery category.
select name,votes,rating from zomato
WHERE type = 'Delivery'
order by votes DESC
limit 5;

-- 2)The rating of a hotel is a key identifier in determining a restaurant’s performance. Hence for a particular location called Banashankari find out the top 5 highly rated hotels in the delivery category.
SELECT name, rating,location,type
FROM zomato
WHERE type = 'Delivery' AND location = 'Banashankari'
ORDER BY rating DESC
LIMIT 5;

-- 3)compare the ratings of the cheapest and most expensive hotels in Indiranagar.
select * from zomato where location='indiranagar' order by approx_cost desc;
select * from zomato where location='indiranagar' and approx_cost in(select max(approx_cost) from zomato where location ='indiranagar');
select * from zomato where location='indiranagar' and approx_cost in(select min(approx_cost) from zomato where location= 'indiranagar');
with cte as(
select * from zomato where location='indiranagar')
select * from cte;
select * from zomato;

select rating from zomato where rating=4.3 and location='indiranagar';

with cte1 as (
select rating as rating1 from zomato where rating =3.1 limit 1),
cte2 as (select  rating as rating2 from zomato where rating=3.7 limit 1)
select rating1,rating2 from cte1,cte2; 

-- 4)Online ordering of food has exponentially increased over time. Compare the total votes of restaurants that provide online ordering services and those who don’t provide online ordering service.

select sum(votes)as total_votes,online_order from zomato 
group by online_order;

-- 5)Number of votes defines how much the customers are involved with the service provided by the restaurants For each Restaurant type, 
-- find out the number of restaurants, total votes, and average rating. Display the data with the highest votes on the top( if the first row of 
-- output is NA display the remaining rows).


SELECT type,COUNT(name) AS number_of_restaurants,SUM(votes) AS total_votes,AVG(rating) AS avg_rating
FROM zomato
where type!='NA'
GROUP BY type
ORDER BY CASE WHEN total_votes IS NULL THEN 1 ELSE 0 END, total_votes DESC;

-- 6)What is the most liked dish of the most-voted restaurant on Zomato(as the restaurant has a tie-up with Zomato, the restaurant compulsorily provides online ordering and delivery facilities.

with cte as (SELECT votes
FROM zomato
WHERE online_order = 'Yes' OR type = 'Delivery'
group by name
ORDER BY votes DESC
LIMIT 1)
select name,dish_liked, rating,zomato.votes from cte,zomato
where zomato.votes=16832;

-- 7)To increase the maximum profit, Zomato is in need to expand its business. For doing so Zomato wants the list of the top 15 restaurants which have min 
-- 150 votes, have a rating greater than 3, and is currently not providing online ordering. Display the restaurants with highest votes on the top.

SELECT name, votes, rating,online_order FROM zomato
WHERE online_order = 'No' AND votes >= 150 AND rating > 3
ORDER BY votes DESC
LIMIT 15;







