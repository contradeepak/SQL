/*********************************************************************************************************
				Wild card searches in MySQL
**********************************************************************************************************/

-- 1.	% (Percent Sign)
		/*used in conjunction with a LIKE operator; matches zero one or more character.
		Usage 
		-- 'app%': Matches any string that starts with "app" (e.g., "apple", "application", "approach").
		-- '%app': Matches any string that ends with "app" (e.g., "webapp", "myapp")
		-- '%app%': Matches any string that contains "app" anywhere (e.g., "application", "happy", "applepie")
		*/

-- Gimme the full name of students whose name begins with a J

select * from students where first_name like 'J%';
select * from students where last_name like '%e';

-- Gimme the full name of all students whose first or last name have the letters 'on'



/*Gimme the fullname of students (a)who are more than 20 years of age
, (b)in the final year of (c)CSE and have a 'on' in their last_name or first_name */

select 
	concat(first_name, ' ', last_name) as Name
    ,branch
    , year_of_study
    ,TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) as age
from 
	students 
where 
	TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) > 20
	and branch ='CSE' and year_of_study = 4 and (first_name like '%on%' OR last_name like '%on%');


-- 2. _ (underscore sign)
		/* Represents exactly one character
        Usage
		-- 'h_t': Matches "hat", "hot", "hit", but not "heat" or "hott".
        -- '____': Matches any string that is exactly five characters long.
        -- 'J_n%': Matches "John", "Jane", "June", etc.
		*/
        
      select * from students where first_name like '_____';

-- 3. NOT LIKE
	  /*Opposite of LIKE */
      
      -- select * from students where first_name not like 'D%';
      select * from students where first_name not like 'M%';
      
      
-- 4. A few exercises by combining wildcards
