-- Table creation for DEPARTMENT
CREATE TABLE DEPARTMENT (
    DNO VARCHAR2(20) PRIMARY KEY,
    DNAME VARCHAR2(20),
    MGRSTARTDATE DATE,
    MGRSSN VARCHAR2(20) REFERENCES EMPLOYEE (SSN)
);

-- Table creation for EMPLOYEE
CREATE TABLE EMPLOYEE (
    SSN VARCHAR2(20) PRIMARY KEY,
    FNAME VARCHAR2(20),
    LNAME VARCHAR2(20),
    ADDRESS VARCHAR2(20),
    SEX CHAR(1),
    SALARY INTEGER,
    SUPERSSN VARCHAR2(20) REFERENCES EMPLOYEE (SSN),
    DNO VARCHAR2(20) REFERENCES DEPARTMENT (DNO)
);

-- Table creation for DLOCATION
CREATE TABLE DLOCATION (
    DLOC VARCHAR2(20),
    DNO VARCHAR2(20) REFERENCES DEPARTMENT (DNO),
    PRIMARY KEY (DNO, DLOC)
);

-- Table creation for PROJECT
CREATE TABLE PROJECT (
    PNO INTEGER PRIMARY KEY,
    PNAME VARCHAR2(20),
    PLOCATION VARCHAR2(20),
    DNO VARCHAR2(20) REFERENCES DEPARTMENT (DNO)
);

-- Table creation for WORKS_ON
CREATE TABLE WORKS_ON (
    HOURS NUMBER(2),
    SSN VARCHAR2(20) REFERENCES EMPLOYEE (SSN),
    PNO INTEGER REFERENCES PROJECT(PNO),
    PRIMARY KEY (SSN, PNO)
);


-- Query 1: List all project numbers for projects that involve an employee whose last name is ‘Scott’
SELECT DISTINCT PNo
FROM WORKS_ON
WHERE SSN IN (SELECT SSN FROM EMPLOYEE WHERE Name LIKE '%Scott%')
OR SSN IN (SELECT MgrSSN FROM DEPARTMENT WHERE DNo IN (SELECT DNo FROM PROJECT));

-- Query 2: Show resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise
UPDATE EMPLOYEE
SET Salary = Salary * 1.10
WHERE SSN IN (SELECT SSN FROM WORKS_ON WHERE PNo = (SELECT PNo FROM PROJECT WHERE PName = 'IoT'));

-- Query 3: Find sum, maximum, minimum, and average salary of employees in the 'Accounts' department
SELECT SUM(Salary) AS Total_Salary, MAX(Salary) AS Max_Salary, MIN(Salary) AS Min_Salary, AVG(Salary) AS Avg_Salary
FROM EMPLOYEE
WHERE DNo IN (SELECT DNo FROM DEPARTMENT WHERE DName = 'Accounts');

-- Query 4: Retrieve names of employees working on all projects controlled by department number 5
SELECT Name
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT PNo
    FROM PROJECT P
    WHERE P.DNo = 5
    AND P.PNo NOT IN (
        SELECT PNo
        FROM WORKS_ON W
        WHERE W.SSN = E.SSN
    )
);

-- Query 5: Retrieve department numbers and counts of employees making more than Rs. 600,000
SELECT DNo, COUNT(*) AS Employee_Count
FROM EMPLOYEE
WHERE Salary > 600000
GROUP BY DNo
HAVING COUNT(*) > 5;
