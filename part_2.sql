-- Create a table for users
CREATE​ ​TABLE​ ​"users"​(
"user_id"​ SERIAL PRIMARY ​KEY​,
"username"​ VARCHAR(​25​) U​ NIQUE​ ​NOT​ NULL ​CHECK​ (​LENGTH​(​TRIM​(​"username"​))>​0​), "last_login"​ ​TIMESTAMP
);

-- Create index on username in table users
CREATE​ ​INDEX​ ​ON​ ​"users"​(​"username"​);

-- Create a table for topics
CREATE​ ​TABLE​ ​"topics"​(
"topic_id"​ SERIAL PRIMARY ​KEY​,
"topic_name"​ VARCHAR(​30)​ ​UNIQUE​ ​NOT​ NULL ​CHECK
(​LENGTH​(​TRIM​(​"topic_name"​))>​0​),
"topic_desc"​ TEXT );

-- Create index on topic_name in table topics:
CREATE​ ​INDEX​ ​ON​ ​"topics"​(​"topic_name"​);

-- Create table for posts:
CREATE​ ​TABLE​ ​"posts"​(
"post_id"​ SERIAL PRIMARY ​KEY​,
"post_title"​ VARCHAR(​100​) ​NOT​ NULL ​CHECK​ (​LENGTH​(​TRIM​(​"post_title"​))>​0​), "topic_id"​ INT ​REFERENCES​ "​ topics"​(​"topic_id"​) ​ON​ ​DELETE​ C​ ASCADE​, "user_id"​ INT ​REFERENCES​ ​"users"​(​"user_id"​) ​ON​ ​DELETE​ S​ ET​ NULL,
"url"​ VARCHAR(​2000​),
"text_content"​ TEXT,
CONSTRAINT​ url_text ​CHECK​(("​ url"​ ​IS​ NULL ​AND​ ​"text_content"​ I​ S​ ​NOT​ NULL) ​OR
(​"url"​ ​IS​ ​NOT​ NULL ​AND​ ​"text_content"​ ​IS​ NULL)) );

-- Create index on url in posts:
CREATE​ ​INDEX​ ​ON​ ​"posts"​(​"url"​);

-- Create table for comments:
CREATE​ ​TABLE​ ​"comments"​(
"comment_id"​ SERIAL PRIMARY ​KEY​,
"parent_comment_id"​ INT ​REFERENCES​ ​"comments"​(​"comment_id"​) ​ON​ ​DELETE
CASCADE​,
"post_id"​ INT ​REFERENCES​ ​"posts"​(​"post_id"​) ​ON​ ​DELETE​ C​ ASCADE​, "user_id"​ INT ​REFERENCES​ ​"users"​(​"user_id"​) ​ON​ ​DELETE​ S​ ET​ NULL, "text"​ TEXT ​NOT​ NULL
);

-- Create table for votes:
CREATE​ ​TABLE​ ​"votes"​(
"vote_id"​ SERIAL PRIMARY ​KEY​,
"post_id"​ INT ​REFERENCES​ ​"posts"​(​"post_id"​) ​ON​ ​DELETE​ C​ ASCADE​, "user_id"​ INT ​REFERENCES​ ​"users"​(​"user_id"​) ​ON​ ​DELETE​ S​ ET​ NULL, "vote"​ SMALLINT ​CHECK​("​ vote"​ = ​1​ ​OR​ ​"vote"​ = ​-1​),
CONSTRAINT​ ​"user_vote"​ ​UNIQUE​ (​"user_id"​, ​"post_id"​)
);
