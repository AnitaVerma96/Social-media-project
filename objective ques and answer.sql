/*2.What is the distribution of user activity levels (e.g., number of posts, likes, comments) across the user base?*/

-- with cte as (Select t2.id, count(*) as  comments
-- from comments as t1
-- join users as t2 on 
-- t2.id=t1.user_id
-- group by t2.id),

-- cte2 as (
-- Select t2.id, count(*) as likes 
--  from likes as t1
--  join users as t2 on 
--  t2.id=t1.user_id
--  group by t2.id
-- ),

-- cte3 as (select t2.id, count(*) as photos
-- from photos t1
-- join users as t2 on 
--  t2.id=t1.user_id group by t2.id)
--  
--   select c.id, c.comments,c1.likes ,c2.photos
--   from cte c
--   join cte2 c1
--    on c.id=c1.id
--    join  cte3 c2 on 
--    c2.id=c1.id



/*3.Calculate the average number of tags per post (photo_tags and photos tables).*/

-- select p.id as PostId,avg(pt.tag_id) as AvgPerPost
-- from photos p 
-- join photo_tags pt on p.id=pt.photo_id
-- group by p.id
-- order by p.id




/*4.	Identify the top users with the highest engagement rates (likes, comments) on their posts and rank them.*/

-- Step 1: Calculate total likes and comments for each photo
-- WITH for_photo_engagement AS (
--     SELECT
--         p.id AS photo_id,
--         p.user_id,
--         COUNT(DISTINCT l.user_id) AS like_count,
--         COUNT(DISTINCT c.id) AS comment_count
--     FROM
--         photos p
--         LEFT JOIN likes l ON p.id = l.photo_id
--         LEFT JOIN comments c ON p.id = c.photo_id
--     GROUP BY
--         p.id
-- ),

-- -- Step 2: Aggregate total engagement per user
-- for_user_engagement AS (
--     SELECT
--         pe.user_id,
--         SUM(pe.like_count) AS total_likes,
--         SUM(pe.comment_count) AS total_comments,
--         SUM(pe.like_count + pe.comment_count) AS total_engagement
--     FROM
--         photo_engagement pe
--     GROUP BY
--         pe.user_id
-- )

-- -- Step 3: Rank users based on their engagement
-- SELECT
--     ue.user_id,
--     u.username,
--     ue.total_likes,
--     ue.total_comments,
--     ue.total_engagement,
--     RANK() OVER (ORDER BY ue.total_engagement DESC) AS rnk
-- FROM
--     user_engagement ue
--     JOIN users u ON ue.user_id = u.id
-- ORDER BY
--     ue.total_engagement DESC;



/* 5.Which users have the highest number of followers and followings?*/

-- select *
-- from follows as t1 
-- WITH followers_count AS (
--     SELECT follower_id,COUNT(follower_id) AS num_followers
--     FROM follows
--     group by follower_id
-- ),
-- followings_count AS (
--     SELECT followee_id,COUNT(followee_id) AS num_followings
--     FROM follows
--     group by followee_id
-- )
-- SELECT u.username, 
-- MAX(f.num_followers) AS max_followers,
--  MAX(f1.num_followings) AS max_followings
-- FROM users u
-- LEFT JOIN followers_count f ON u.id = f.follower_id
-- LEFT JOIN followings_count f1 ON u.id = f1.followee_id
-- GROUP BY u.username
-- ORDER BY max_followers DESC, max_followings DESC
-- LIMIT 1;







/*6.Calculate the average engagement rate (likes, comments) per post for each user.*/
-- WITH photo_engagement AS (
--     SELECT
--         p.id AS photo_id,
--         p.user_id,
--         COUNT(DISTINCT l.user_id) AS like_count,
--         COUNT(DISTINCT c.id) AS comment_count,
--         COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) AS total_engagement
--     FROM
--         photos p
--         LEFT JOIN likes l ON p.id = l.photo_id
--         LEFT JOIN comments c ON p.id = c.photo_id
--     GROUP BY
--         p.id
-- ),
-- user_engagement AS (
--     SELECT
--         pe.user_id,
--         SUM(pe.total_engagement) AS total_engagement,
--         COUNT(pe.photo_id) AS post_count
--     FROM
--         photo_engagement pe
--     GROUP BY
--         pe.user_id
-- )
-- SELECT
--     ue.user_id,
--     u.username,
--     ue.total_engagement,
--     ue.post_count,
-- 	round((ue.total_engagement / ue.post_count),2)
--     as average_engagement_per_post
-- FROM
--     user_engagement ue
--     JOIN users u ON ue.user_id = u.id
-- ORDER BY
--     average_engagement_per_post DESC;





/*7.	Get the list of users who have never liked any post (users and likes tables)*/
-- select id,username
-- from users where id not in (select user_id from likes)





-- 10.	Calculate the total number of likes, comments, and photo tags for each user.
   -- with  comments as (select  user_id,count(*) as total_comments 
--       from users as t1
--    join comments as t2 on 
--      t1.id=t2.user_id
--      group by user_id
--       order by user_id desc),
--       
--       



-- 	likes as (select  user_id,count(*) as total_likes 
--      from users as t1
--     join likes  as t2 on 
--     t1.id=t2.user_id
--       group by user_id
--        order by user_id desc),
--     photo_tag as(select  user_id,count(*) as total_photo_tags
--      from users as t1
--       join photos as t2 on 
--      t1.id=t2.user_id
--        join photo_tags as t3 on 
--        t2.id=t3.photo_id
--      group by user_id
--   order by user_id desc)

--   select c.user_id,c.total_comments ,l.total_likes ,p.total_photo_tags
--   from  comments as c
--   join likes as l on 
--   c.user_id=l.user_id 
--   join photo_tag p on
--   c.user_id=p.user_id
--   










--qustion 11: Calculate total likes and comments for each photo within the past month
-- WITH photo_engagement AS (
--     SELECT
--         p.user_id,
--         COUNT(DISTINCT l.user_id) AS like_count,
--         COUNT(DISTINCT c.id) AS comment_count,
--         COUNT(DISTINCT l.user_id) + COUNT(DISTINCT c.id) AS total_engagement
--     FROM
--         photos p
--         LEFT JOIN likes l ON p.id = l.photo_id
--         LEFT JOIN comments c ON p.id = c.photo_id
--     WHERE
--         p.created_dat >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
--     GROUP BY
--         p.user_id
-- ),

-- Step 2: Aggregate total engagement per user
-- user_engagement AS (
--     SELECT
--         pe.user_id,
--         SUM(pe.total_engagement) AS total_engagement
--     FROM
--         photo_engagement pe
--     GROUP BY
--         pe.user_id
-- )

-- Step 3: Rank users based on their total engagement
-- SELECT
--     ue.user_id,
--     u.username,
--     ue.total_engagement,
--     RANK() OVER (ORDER BY ue.total_engagement DESC) AS rnk
-- FROM
--     user_engagement ue
--     JOIN users u ON ue.user_id = u.id
-- ORDER BY
--     rnk;


/*12.	Retrieve the hashtags that have been used in posts with the highest average 
number of likes. Use a CTE to calculate the average likes for each hashtag first.*/

-- with avg_likes_per_tag as 
-- ( 
-- 	select 
-- 		pt.tag_id, 
-- 		round(avg(l.user_id),2) as avg_likes 
--     from photo_tags pt 
--     join photos p on pt.photo_id = p.id 
--     join likes l on p.id = l.photo_id 
--     group by pt.tag_id 
-- )
-- select 
-- 	t.tag_name,
-- 	alt.avg_likes 
-- from avg_likes_per_tag alt 
-- join tags t on alt.tag_id = t.id 
-- order by alt.avg_likes desc;








-- select 
-- 	distinct u1.username 
-- from users u1 
-- join follows f1 on u1.id = f1.follower_id 
-- join follows f2 on u1.id = f2.followee_id 
-- where f1.created_at < f2.created_at


/*13.	Retrieve the users who have started following someone after being followed by that person   */    
   --     select 
-- 	 distinct u1.username 
--         from users u1 
--           join follows f1 on u1.id = f1.follower_id 
--           join follows f2 on u1.id = f2.followee_id 
--           where f1.created_at < f2.created_at














