-- migrate users from bad_posts and bad_comments tables into users table
INSERT​ ​INTO​ ​"users"​(​"username"​)
SELECT​ ​DISTINCT​ ​"username"
FROM​ ​"bad_posts"
UNION
SELECT​ ​DISTINCT​ ​"username"
FROM​ ​"bad_comments"
UNION
SELECT​ ​DISTINCT​ REGEXP_SPLIT_TO_TABLE(​"upvotes"​, ​','​)
FROM​ ​"bad_posts"
UNION
SELECT​ ​DISTINCT​ REGEXP_SPLIT_TO_TABLE(​"downvotes"​,​','​)
FROM​ ​"bad_posts"​;

-- migrate topics from bad_posts to topics table
INSERT​ ​INTO​ ​"topics"​(​"topic_name"​)
SELECT​ ​DISTINCT​ ​"topic"
FROM​ ​"bad_posts"​;

-- migrate posts from bad_posts to posts table
INSERT​ ​INTO​ ​"posts"​(​"post_title"​, ​"topic_id"​, ​"user_id"​, ​"url",​ "text_content"​)
SELECT​ ​SUBSTRING​(​"bp"​.​"title"​, ​1​, ​100​), ​"ts"​.​"topic_id"​, ​"u"​.​"user_id",​ "bp"​.​"url"​, ​"bp"​.​"text_content"
FROM​ ​"bad_posts"​ ​"bp"
JOIN​ ​"topics"​ ​"ts"
ON​ ​"bp"​.​"topic"​ = ​"ts"​.​"topic_name"
JOIN​ ​"users"​ ​"u"
ON​ ​"bp"​.​"username"​ = ​"u"​.​"username"​;

-- migrate upvotes from bad_posts to votes table
INSERT​ ​INTO​ ​"votes"​(​"post_id"​, ​"user_id"​, ​"vote"​)
SELECT​ ​"bp"​.​"id"​, ​"u"​.​"user_id"​, ​1​ ​AS​ ​"up_vote"
FROM​(
SELECT​ ​"id"​, REGEXP_SPLIT_TO_TABLE(​"upvotes"​, ​','​) A​ S​ "​ upvotes"
FROM​ ​"bad_posts"​) ​"bp"
JOIN​ ​"users"​ ​"u"
ON​ ​"bp"​.​"upvotes"​ = ​"u"​.​"username"​;

-- migrate downvotes from bad_posts to votes table
INSERT​ ​INTO​ ​"votes"​(​"post_id"​, ​"user_id"​, ​"vote"​)
SELECT​ ​"bp"​.​"id"​, ​"u"​.​"user_id"​, ​-1​ ​AS​ ​"downvote"
FROM​(
SELECT​ ​"id"​, REGEXP_SPLIT_TO_TABLE(​"downvotes"​, ​','​) ​AS​ ​"downvotes"
FROM​ ​"bad_posts"​) ​"bp"
JOIN​ ​"users"​ ​"u"
ON​ ​"bp"​.​"downvotes"​ = ​"u"​.​"username"​;

-- migrate comments from bad_comments to comments table
INSERT​ ​INTO​ ​"comments"​(​"post_id"​,​"user_id"​, ​"text"​)
SELECT​ ​"po"​.​"post_id"​, ​"u"​.​"user_id"​, ​"bc"​.​"text_content"
FROM​ ​"bad_comments"​ ​"bc"
JOIN​ ​"posts"​ ​"po"
ON​ ​"bc"​.​"post_id"​ = ​"po"​.​"post_id"
JOIN​ ​"users"​ ​"u"
ON​ ​"bc"​.​"username"​ = ​"u"​.​"username"​;
