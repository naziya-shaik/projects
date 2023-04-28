create database instagram ;
use instagram;
select * from comments;
select * from users;
select * from follows;
select * from likes;
select * from tags;
select * from photo_tags;
select * from photos;

-- module 2:
-- task1:find the oldest users
select *  from users where id=47;
select * from users order by created_at limit 5;

-- task2:What day of the week do most users register on? We need to figure out when to schedule an ad campgain
with cte as(
select *,(dayname(created_at))day_of_the_week from users order by day_of_the_week)
select day_of_the_week,(count(day_of_the_week))total_registration from cte group by day_of_the_week order by total_registration desc;
-- or
SELECT DATE_FORMAT(created_at, '%W') AS day_of_week, COUNT(*) AS total_registration 
FROM users
GROUP BY 1
ORDER BY 2 DESC;

-- task3:We want to target our inactive users with an email campaign. Find the users who have never posted a photo
select id,username from users where id not in(select user_id from photos);

-- task4:We're running a new contest to see who can get the most likes on a single photo. WHO WON?

select u.username,p.id,p.image_url,count(*)as total_likes from likes l
inner join photos p on p.id=l.photo_id
inner join users u on u.id=l.user_id
group by p.id
order by Total_likes desc 
limit 1;

SELECT u.username, p.id, p.image_url, COUNT(l.created_at) AS Total_Likes
FROM photos p
INNER JOIN likes l ON p.id = l.photo_id
INNER JOIN users u ON p.user_id = u.id
GROUP BY u.username, p.id, p.image_url
ORDER BY 4 DESC
LIMIT 1;

-- task 5:Our Investors want to know...How many times does the average user post? (total number of photos/total number of users)
    select ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2); 
-- or
WITH table1 as (
    SELECT
    count(*) as total_photos
    from photos
    ),
table2 as (
    SELECT
    count(*) as total_users
    from users
    )
SELECT
round((t1.total_photos/t2.total_users),2)
from table1 t1 ,table2 t2;

-- task6:user ranking by postings higher to lower
select  u.username,count(photos.image_url) from users u
inner join photos on u.id=photos.user_id
group by u.id
order by 2 desc;

-- task7:Total Posts by users (longer versionof SELECT COUNT(*)FROM photos)
with user_posts as(
select u.username,count(*) as total_posts_per_user from photos p
inner join users u on p.user_id=u.id
group by u.id)
select sum(user_posts.total_posts_per_user) from user_posts;

-- task8:Total numbers of users who have posted at least one time
WITH table1 as (
    SELECT user_id,COUNT(image_url) as total_sum FROM photos
	GROUP BY 1 
    ORDER BY 2)
SELECT
COUNT(*)
FROM table1;
-- task9:A brand wants to know which hashtags to use in a post. What are the top 5 most commonly used hashtags?
SELECT
tag_name,COUNT(tag_id) as total_sum
from tags t 
JOIN photo_tags pt
ON t.id=pt.tag_id
GROUP BY 1
ORDER by 2 DESC;

-- task10:We have a small problem with bots on our site. Find users who have liked every single photo on the site
WITH table1 as (
    SELECT
	user_id,
	COUNT(photo_id) as total_likes_by_user
	from likes
	GROUP BY 1
	ORDER BY 2 DESC
    )
SELECT
u.id,u.username,t1.total_likes_by_user
from table1 t1 
JOIN users u 
on u.id=t1.user_id
WHERE t1.total_likes_by_user=257;

-- task 11:We also have a problem with celebrities. Find users who have never commented on a photo
with cte as (
select u.id,u.username from users u where u.id not in(select user_id from comments ))
select username,c.comment_text from cte 
left join  comments c on cte.id=c.user_id;

-- task 12:Are we overrun with bots and celebrity accounts? Find the percentage of our users who have either never commented on a photo
--  or have commented on every photo
select A.total_A as 'Number of users who never commented',(A.total_A/(select count(*)from users))*100 as'%',
B.total_B as 'Number of Users who likes every photos',(B.total_B/(select count(*)from users))*100 as'%'
from (
select count(*) as total_A from (
select username,comment_text from users u
left join comments c on u.id=c.user_id
group by u.id
having comment_text is null )as total_number_of_users_without_comments)as A
join (
select count(*)as total_B from (
select u.id,username,count(u.id)as total_likes_by_user
from users u
join likes l on u.id=l.user_id
group by u.id
having total_likes_by_user=(select count(*) from photos))as total_number_users_likes_every_photos)as B;

-- task 13:Find users who have ever commented on a photo

select username,comment_text from users u
left join comments c on u.id=c.user_id
group by u.id
having comment_text is not null;

-- task14:Are we overrun with bots and celebrity accounts? Find the percentage of our users who have either never commented on a photo
--  or have commented on photos before.

select A.total_A as 'Number of users who never commented',(A.total_A/(select count(*)from users))*100 as'%',
B.total_B as 'Number of Users who commented on photos',(B.total_B/(select count(*)from users))*100 as'%'
from (
select count(*) as total_A 
from (
select username,comment_text from users u
left join comments c on u.id=c.user_id
group by u.id
having comment_text is null )as total_number_of_users_without_comments)as A
join (
select count(*)as total_B from (
select username,comment_text
from users u
left join comments c on u.id=c.user_id
group by u.id
having comment_text is not null)as total_number_users_likes_with_comments)as B;

