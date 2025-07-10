/**********************************************************
Date Functions Demonstration using the STUDENTS table
***********************************************************/

-- Show current date and time
	SELECT 
		CURDATE() AS today
        , NOW() AS current_datetime;


select * from students;
-- Extract year, month, and day from date_of_birth
SELECT 
	date_of_birth
    , YEAR(date_of_birth) AS birth_year
    , MONTH(date_of_birth) AS birth_month
    , DAY(date_of_birth) AS birth_day 
FROM 
	students 
LIMIT 10;

/*give me the full name of the students whose birthday fall on the 30th of a month*/

Select 
	concat(first_name, ' ', last_name) as Name
    , DATE_FORMAT(date_of_birth, '%M %d, %Y') as DOB
from 
	students
where 
	DAY(date_of_birth) = 30 and MONTH(date_of_birth) = 10;

-- Format date
SELECT 
	concat(first_name, ' ', last_name) as Name
    , date_of_birth
	, DATE_FORMAT(date_of_birth, '%M %d, %Y') AS formatted_dob 
FROM 
	students 
LIMIT 10;


/*****************Date Formatting Options*********************
Format				Meaning						Example/Output
=============================================================
%Y					4-digit year					2025
%y					2-digit year					25
%m					2-digit month (01–12)			05
%c					Numeric month (1–12)			5
%M					Full month name					May
%b					Abbreviated month name			May
%d					Day of the month (01–31)		23
%e					Day of the month (1–31)			23
%W					Full weekday name				Friday
%a					Abbreviated weekday name		Fri
%w					Day of week (0=Sunday, 6=Saturday)	5
%H					Hour (00–23, 24-hour clock)		14
%h / %I				Hour (01–12, 12-hour clock)		02
%i					Minutes (00–59)					30
%s					Seconds (00–59)					45
%p					AM or PM						PM
*************************************************************/

-- Give me all students whose age is more than 20 years and study in computer science branch

-- Calculate age in years
SELECT 
	first_name
    , date_of_birth
    , TIMESTAMPDIFF(MONTH, date_of_birth, CURDATE()) AS Months 
    , TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS Years 
FROM 
	students 
LIMIT 10;

/*get me the full name of all students who are 
-- more than 20 years of age 
-- and in final year (4), 
-- studying in CSE branch */
select 
	concat(first_name, ' ', last_name) as Name
    ,TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())  as age
    ,branch
    ,year_of_study
from 
	students
where
	(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) +1) > 20 and branch = 'CSE' and year_of_study =4;

/*get me the full name of all students who are 
-- and in final year (4), 
-- studying in CSE branch 
-  and will be more than 20 years of age next year*/

select date_of_birth from students;
-- Add days to date_of_birth
SELECT 
	date_of_birth
	, ADDDATE(date_of_birth, INTERVAL 30 DAY) AS after_30_days 
    , ADDDATE(date_of_birth, INTERVAL 1 YEAR) AS after_1_year
FROM 
	students 
LIMIT 10;



/*logic*/
-- TIMESTAMPDIFF(YEAR, DATE_ADD(date_of_birth, INTERVAL 1 YEAR),  CURDATE()) >=20;
-- ADDDATE and DATE_ADD are same functions

/***********************************
We can add the following intervals to a 
MONTH
YEAR
HOUR
MINUTE
SECOND
***************************************/


-- Difference between two dates as number of days
SELECT 
	DATEDIFF(CURDATE(), date_of_birth) AS days_alive 
FROM 
	students 
LIMIT 10;

-- Day of the week and name
-- Name of students born on sunday
SELECT 
	concat(first_name, ' ', last_name) as Name
    , DAYNAME(date_of_birth) AS day_name 
FROM 
	students 
WHERE 
	DAYNAME(date_of_birth) = 'Sunday';


-- Last day of the birth month
SELECT 
	date_of_birth
    , LAST_DAY(date_of_birth) AS last_day_of_birth_month 
FROM 
	students 
LIMIT 10;

/*
Give me the full name of students-
- who were born in months that have 30 days only; 
- are studying in CSE final year (4)
- are more than 20 years of age
*/

SELECT 
	concat(first_name, ' ', last_name) as name
	, MONTH(date_of_birth) as 'Month'
    , branch
    , year_of_study
	-- , DATE_FORMAT(date_of_birth, '%M %d, %Y') as DOB
from 
	students
WHERE 
	DAY(LAST_DAY(date_of_birth)) = 30 and branch = 'CSE' and year_of_study = 4 and 
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) > 20;




/*------------------------------------------------------*/
select * from students;

-- Age of students
SELECT 
	TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) as 'AGE'
FROM
	students;
    
/*
Instead of the YEAR in the above, we can use the below as well to see the difference between two dates.
- MICROSECOND
- SECOND
- MINUTE
- HOUR
- DAY
- WEEK
- MONTH
- QUARTER

e.g. INTERVAL 1 QUARTER
*/

-- Example - Age of students im months
SELECT 
	TIMESTAMPDIFF(MONTH, date_of_birth, CURDATE()) as 'AGE'
FROM
	students;

    
    
-- Output: Age in years


select * from students;


-- SELECT DATE_ADD('2025-05-23', INTERVAL 7 DAY); 

/*Substract from a */
 SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH);

SELECT DATE_SUB(curdate(), INTERVAL 1 MONTH);



/*
Can I subtract a datetime value from date?
Yes, you can subtract a DATETIME from a DATE in MySQL, but MySQL will implicitly convert the DATE to a DATETIME 
by appending 00:00:00 as the time.
*/

SELECT DATEDIFF('2025-05-23', '2025-05-20 14:30:00') AS ‘days_difference’;



/*
The University email address domain has changed from ‘example.com’ to ‘edu.com’. 
Write an SQL using 
- LEFT, 
- INSTR and 
- CONCAT functions to print out the email with the domain name of edu.com.
*/
SELECT 
	first_name
	, LEFT(email, INSTR(email, '@'))
	, CONCAT(LEFT(email, INSTR(email, '@')),'edu.com')
FROM students;



/*



*/

/*
Give me the (a)Full Name and (b)email ids of all students 
- who will turn 20 years next month and 
- are studying in computer science ?
*/

SELECT 
	CONCAT(first_name, ' ', last_name) AS 'Name'
	, email
from
	students
WHERE 
	TIMESTAMPDIFF(YEAR, DATE_ADD(date_of_birth, INTERVAL 1 MONTH),  CURDATE()) >=20;
    
    


