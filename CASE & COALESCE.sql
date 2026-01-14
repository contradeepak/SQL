-- Drop table
DROP TABLE IF EXISTS Employees;

-- Create the Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2),
    department_code VARCHAR(100), -- Might be inconsistent
    phone_mobile VARCHAR(100),
    phone_office VARCHAR(100),
    email VARCHAR(100)
);

-- Insert sample data
INSERT INTO Employees (employee_id, first_name, last_name, salary, department_code, phone_mobile, phone_office, email) VALUES
(101, 'Alice', 'Smith', 75000.00, 'HR', '9876543210', '0801234567', 'alice.s@example.com'),
(102, 'Bob', 'Johnson', 120000.00, 'ENG', NULL, '0809876543', 'bob.j@example.com'),
(103, 'Charlie', 'Brown', 45000.00, 'SALES', '9988776655', NULL, NULL), -- Missing email
(104, 'David', 'Lee', 180000.00, 'R&D', '9123456789', '0805555444', 'david.l@example.com'),
(105, 'Eve', 'Davis', 60000.00, 'HUMRES', '9000000000', NULL, 'eved@example.com'), -- Old department code
(106, 'Frank', 'White', 30000.00, 'OPPS', NULL, NULL, NULL), -- All contact missing
(107, 'Grace', 'Green', 95000.00, 'TECH', '9765432100', '0801122334', 'grace.g@example.com'),
(108, 'Henry', 'Black', 110000.00, 'ENGINEERING', '9555555555', NULL, 'henry.b@example.com'), -- Another old department code
(109, 'Isabel', 'Cruz', 250000.00, 'EXEC', '9444444444', '0802222333', 'isabel.c@example.com'),
(110, 'Jack', 'Miller', NULL, 'SALES', '9333333333', '0807777888', 'jack.m@example.com'); -- Missing salary


SELECT
    employee_id,
    CONCAT(first_name, ' ', last_name) AS FullName,

    -- 1. CASE (Searched) for Salary Tier
    CASE
        WHEN salary IS NULL THEN 'Not Provided'
        WHEN salary < 50000 THEN 'Tier A (Entry Level)'
        WHEN salary >= 50000 AND salary < 100000 THEN 'Tier B (Mid-Level)'
        WHEN salary >= 100000 AND salary < 200000 THEN 'Tier C (Senior/Lead)'
        ELSE 'Tier D (Executive)' -- For salary >= 200000
    END AS SalaryTier,

    -- 2. CASE (Simple) as DECODE Equivalent for Standardized Department Name
    CASE department_code
        WHEN 'HR' THEN 'Human Resources'
        WHEN 'HUMRES' THEN 'Human Resources'
        WHEN 'ENG' THEN 'Engineering'
        WHEN 'ENGINEERING' THEN 'Engineering'
        WHEN 'SALES' THEN 'Sales'
        WHEN 'R&D' THEN 'Research & Development'
        WHEN 'TECH' THEN 'Technology Services'
        WHEN 'OPPS' THEN 'Operations'
        WHEN 'EXEC' THEN 'Executive Management'
        ELSE 'Other/Uncategorized'
    END AS StandardizedDepartment,

    -- 3. COALESCE for Preferred Contact
    COALESCE(phone_mobile, phone_office, email, 'No Contact Info') AS Preferred_Contact
FROM
    Employees
ORDER BY
    employee_id;
    
/*----------------------------------------------------HOME WORK--------------------------------------------------------------------------------
Use Case: Global Country Economic and Geographic Reporting

Imagine you're preparing a report on countries around the world, and you need to:

1.	Standardize Economic Data: Countries have both GNP (Gross National Product) and GNPOld. 
We want to prioritize the GNP but fall back to GNPOld if GNP is NULL. If both are NULL, we'll default to 0. (This is for COALESCE).

2.	Categorize Economic Status: Based on this standardized GNP value, classify countries into broader income categories 
	(e.g., 'Low Income', 'Middle Income', 'High Income'). 
	
    The classification is as follows
	•	= 0 then the data has not been classified
	•	< 1,000 THEN ‘Low Income’
	•	BETWEEN 1,000 and 10,000 THEN ‘Lowed Middle Income’
	•	BETWEEN 10,000 and 1000000 THEN Upper Middle Income
    
3.	Standardize Geographic Regions: The Region column in the country table is quite granular (e.g., 'Western Europe', 'Southern Europe', 'Eastern Asia'). 
	We want to group these into broader, more standardized regional blocs for higher-level reporting 
	(e.g., all European regions become 'Europe', all Asian regions become 'Asia'). 
    
--------------------------------------------------------------------------------------------------------------------------------------------*/



