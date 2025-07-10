/*String Functions Demonstration using the STUDENTS table*/

/*- Concatenation function CONCAT joins two or more strings together
  -Individual values are separated by a comma*/
SELECT
	first_name
	, last_name 
    , CONCAT(first_name,' ', last_name) AS full_name
FROM students
WHERE branch = 'CSE' AND year_of_study =4;

/*Convert to upper case use UPPER function
Convert to lower case use LOWER function*/ 

SELECT 
	UPPER(first_name) AS UPPER
	, LOWER(last_name) AS lower
FROM students;

/*Get length of first name*/
SELECT 
	first_name
	, LENGTH(first_name) AS name_length 
FROM students;

/*all students whose last two letters of last name is 'on'*/
SELECT last_name
FROM students
WHERE RIGHT(last_name, 2) = 'on';

/*all students whose last name ends with on and the number of character is 7*/

SELECT concat(first_name, ' ', last_name) AS Name
FROM students
WHERE RIGHT(last_name, 2) = 'on' AND length(last_name) = 7;

/*Extract 1 character from the third position - SUBSTRING(first_name, 3, 1) = 's'*/
/*Extract 3 characters from the first position - SUBSTRING(first_name, 1, 3)
- The substring takes in 3 parameters (a) the column header; (b) position to begin with
   and (c) the number of characters to extract*/

SELECT first_name
    , SUBSTRING(first_name, 3, 1) as 'One-from-third'
FROM students;

SELECT first_name
    , SUBSTRING(first_name, 1, 3) as 'three-from-first'
FROM students;


/*Replace part of the name - REPLACE(first_name, 'a', '@') AS replaced_name*/

SELECT first_name 
		,REPLACE(first_name, 'll', '@') AS replaced_name
        ,REPLACE(first_name, 'f', '@') AS replaced_f_name
FROM students;
/*Trim function is used to remove whitespaces
SELECT TRIM('  first_name  ') AS trimmed_example;
SELECT LTRIM('  first_name  ') AS trimmed_example;
SELECT RTRIM('  first_name  ') AS trimmed_example;*/

/*Find position of first occurenece of a character in a string - INSTR(first_name, 'l') AS position_of_the_string */

SELECT first_name 
		,INSTR(first_name, 'l') AS position_of_the_string 
FROM students;

/*Reverse a string -- REVERSE(first_name) AS reversed_name*/ 

SELECT first_name 
		,REVERSE(first_name) AS reversed_name
FROM students;


/** write a query using wildcards and substring to print all values 
where third letter is s*/

SELECT * 
FROM students
WHERE first_name LIKE '__s%';
