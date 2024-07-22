

-- /*11.	Rank users based on their total engagement (likes, comments, */
-- WITH LikesCount AS (
--     SELECT 
--         p.user_id,
--         COUNT(l.photo_id) AS total_likes
--     FROM 
--         photos p
--     LEFT JOIN 
--         likes l ON p.id = l.photo_id
--     WHERE 
--         l.created_at >= NOW() - INTERVAL 1 MONTH
--     GROUP BY 
--         p.user_id
-- ),
-- CommentsCount AS (
--     SELECT 
--         p.user_id,
--         COUNT(c.photo_id) AS total_comments
--     FROM 
--         photos p
--     LEFT JOIN 
--         comments c ON p.id = c.photo_id
--     WHERE 
--         c.created_at >= NOW() - INTERVAL 1 MONTH
--     GROUP BY 
--         p.user_id
-- ),
-- Engagement AS (
--     SELECT 
--         u.id AS user_id,
--         u.username,
--         COALESCE(l.total_likes, 0) + COALESCE(c.total_comments, 0) AS total_engagement
--     FROM 
--         users u
--     LEFT JOIN 
--         LikesCount l ON u.id = l.user_id
--     LEFT JOIN 
--         CommentsCount c ON u.id = c.user_id
-- )
-- SELECT 
--     user_id,
--     username,
--     total_engagement,
--     RANK() OVER (ORDER BY total_engagement DESC) AS engagement_rank
-- FROM 
--     Engagement
-- ORDER BY 
--     engagement_rank;


/*1.	Based on user engagement and activity levels, which users would you consider the most loyal or valuable? How would you reward or incentivize these users?*/

-- WITH LikesGiven AS (
--     SELECT user_id, COUNT(*) AS likes_given
--     FROM likes
--     WHERE created_at >= NOW() - INTERVAL 1 MONTH
--     GROUP BY user_id
-- ),
-- LikesReceived AS (
--     SELECT p.user_id, COUNT(*) AS likes_received
--     FROM likes l
--     JOIN photos p ON l.photo_id = p.id
--     WHERE l.created_at >= NOW() - INTERVAL 1 MONTH
--     GROUP BY p.user_id
-- ),
-- CommentsGiven AS (
--     SELECT user_id, COUNT(*) AS comments_given
--     FROM comments
--     WHERE created_at >= NOW() - INTERVAL 1 MONTH
--     GROUP BY user_id
-- ),
-- CommentsReceived AS (
--     SELECT p.user_id, COUNT(*) AS comments_received
--     FROM comments c
--     JOIN photos p ON c.photo_id = p.id
--     WHERE c.created_at >= NOW() - INTERVAL 1 MONTH
--     GROUP BY p.user_id
-- ),
-- PhotosUploaded AS (
--     SELECT user_id, COUNT(*) AS photos_uploaded
--     FROM photos
--     WHERE created_dat >= NOW() - INTERVAL 1 MONTH
--     GROUP BY user_id
-- ),
-- Followers AS (
--     SELECT followee_id AS user_id, COUNT(*) AS followers
--     FROM follows
--     GROUP BY followee_id
-- ),
-- Following AS (
--     SELECT follower_id AS user_id, COUNT(*) AS following
--     FROM follows
--     GROUP BY follower_id
-- ),
-- Engagement AS (
--     SELECT 
--         u.id AS user_id,
--         u.username,
--         COALESCE(lg.likes_given, 0) + COALESCE(lr.likes_received, 0) +
--         COALESCE(cg.comments_given, 0) + COALESCE(cr.comments_received, 0) +
--         COALESCE(pu.photos_uploaded, 0) + COALESCE(f.followers, 0) +
--         COALESCE(fg.following, 0) AS total_engagement
--     FROM 
--         users u
--     LEFT JOIN LikesGiven lg ON u.id = lg.user_id
--     LEFT JOIN LikesReceived lr ON u.id = lr.user_id
--     LEFT JOIN CommentsGiven cg ON u.id = cg.user_id
--     LEFT JOIN CommentsReceived cr ON u.id = cr.user_id
--     LEFT JOIN PhotosUploaded pu ON u.id = pu.user_id
--     LEFT JOIN Followers f ON u.id = f.user_id
--     LEFT JOIN Following fg ON u.id = fg.user_id
-- )

-- SELECT 
--     user_id,
--     username,
--     total_engagement,
--     RANK() OVER (ORDER BY total_engagement DESC) AS engagement_rank
-- FROM 
--     Engagement
-- ORDER BY 
--     engagement_rank;



/*2.	For inactive users, what strategies would you recommend to re-engage them and encourage them to start posting or engaging again*/

-- Identify inactive users who haven't liked, commented, or posted in the last 3 months
-- WITH LastActivity AS (
--     SELECT 
--         u.id AS user_id,
--         MAX(GREATEST(
--             COALESCE(l.created_at, '1970-01-01'),
--             COALESCE(c.created_at, '1970-01-01'),
--             COALESCE(p.created_dat, '1970-01-01')
--         )) AS last_activity
--     FROM 
--         users u
--     LEFT JOIN 
--         likes l ON u.id = l.user_id
--     LEFT JOIN 
--         comments c ON u.id = c.user_id
--     LEFT JOIN 
--         photos p ON u.id = p.user_id
--     GROUP BY 
--         u.id
-- )
-- SELECT 
--     u.id,
--     u.username,
--     la.last_activity
-- FROM 
--     users u
-- JOIN 
--     LastActivity la ON u.id = la.user_id
-- WHERE 
--     la.last_activity < NOW() - INTERVAL 3 MONTH;





/*3.	Which hashtags or content topics have the highest engagement rates? How can this information guide content strategy and ad campaigns?*/
-- WITH PhotoEngagement AS (
--     SELECT 
--         p.id AS photo_id,
--         COALESCE(COUNT(DISTINCT l.user_id), 0) + COALESCE(COUNT(DISTINCT c.id), 0) AS total_engagement
--     FROM 
--         photos p
--     LEFT JOIN 
--         likes l ON p.id = l.photo_id
--     LEFT JOIN 
--         comments c ON p.id = c.photo_id
--     GROUP BY 
--         p.id
-- ),
-- HashtagEngagement AS (
--     SELECT 
--         t.id AS tag_id,
--         t.tag_name,
--         COALESCE(SUM(pe.total_engagement), 0) AS total_engagement
--     FROM 
--         tags t
--     LEFT JOIN 
--         photo_tags pt ON t.id = pt.tag_id
--     LEFT JOIN 
--         PhotoEngagement pe ON pt.photo_id = pe.photo_id
--     GROUP BY 
--         t.id, t.tag_name
-- )
-- SELECT 
--     tag_name,
--     total_engagement
-- FROM 
--     HashtagEngagement
-- ORDER BY 
--     total_engagement DESC






/*	Are there any patterns or trends in user engagement based on
 demographics (age, location, gender) or posting times? How can these insights inform targeted marketing campaigns?*/





