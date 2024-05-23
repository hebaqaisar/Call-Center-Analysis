# Create a table that will insert all the values from .csv file to this table

CREATE TABLE calls (
	ID CHAR(50),
	customer_name CHAR (50),
	sentiment CHAR (20),
	csat_score INT,
	call_timestamp CHAR (10),
	reason CHAR (20),
	city CHAR (20),
	state CHAR (20),
	chanel CHAR (20),
	response_time CHAR (20),
	call_duration_minutes INT,
	call_center CHAR (20)
);

# To make sure that the data needed has been stored in the table

SELECT 
    *
FROM
    calls;

# Since the call_timestamp value is a string, we will need to convert it into date type format

SET SQL_SAFE_UPDATES = 0;

UPDATE calls 
SET 
call_timestamp = STR_TO_DATE(call_timestamp, '%m/%d/%Y');

UPDATE calls 
SET 
csat_score = NULL
WHERE
csat_score = 0;

SET SQL_SAFE_UPDATES = 1;

SELECT 
*
FROM
calls
LIMIT 10;

# Now that the data has been cleaned, let's begin with exploring our data

SELECT 
    COUNT(*) AS rows_num
FROM
    calls;
    
SELECT 
    COUNT(*) AS cols_num
FROM
    information_schema.columns
WHERE
    table_name = 'calls';
    
#Now lets check the distinct values in the columns of our table

SELECT DISTINCT
    sentiment
FROM
    calls;
    
SELECT DISTINCT
    reason
FROM
    calls;
    
SELECT DISTINCT
    channel
FROM
    calls;
SELECT DISTINCT
    response_time
FROM
    calls;
    
SELECT DISTINCT
    call_center
FROM
    calls;
    
# Lets calculate the count and precentage from total of each of the distinct values

SELECT sentiment, count(*) as Total, ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS Percentage
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT channel, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT response_time, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT call_center, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;


SELECT DAYNAME(call_timestamp) as Day_of_call, COUNT(*) num_of_calls FROM calls GROUP BY 1 ORDER BY 2 DESC;


# Now lets perform aggregations

SELECT MIN(csat_score) AS min_score, MAX(csat_score) AS max_score, ROUND(AVG(csat_score),1) AS avg_score
FROM calls WHERE csat_score != 0; 

SELECT MIN(call_timestamp) AS earliest_date, MAX(call_timestamp) AS most_recent FROM calls;

SELECT MIN(call_duration_minutes) AS min_call_duration, MAX(call_duration_minutes) AS max_call_duration, AVG(call_duration_minutes) AS avg_call_duration FROM calls;

SELECT call_center, response_time, COUNT(*) AS count
FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

SELECT 
    call_center, AVG(call_duration_minutes)
FROM
    calls
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    channel, AVG(call_duration_minutes)
FROM
    calls
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    state, COUNT(*)
FROM
    calls
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    state, reason, COUNT(*)
FROM
    calls
GROUP BY 1 , 2
ORDER BY 1 , 2 , 3 DESC;

SELECT 
    state, sentiment, COUNT(*)
FROM
    calls
GROUP BY 1 , 2
ORDER BY 1 , 3 DESC;

SELECT 
    state, AVG(csat_score) AS avg_csat_score
FROM
    calls
WHERE
    csat_score != 0
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
    sentiment, AVG(call_duration_minutes)
FROM
    calls
GROUP BY 1
ORDER BY 2 DESC;

# More advanced queries

SELECT call_timestamp, MAX(call_duration_minutes) OVER(PARTITION BY call_timestamp) AS max_call_duration 
FROM calls 
GROUP BY 1 
ORDER BY 2 DESC;
