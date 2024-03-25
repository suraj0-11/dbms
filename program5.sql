-- Table creation for DEPARTMENT
CREATE TABLE DEPARTMENT (
    DNO VARCHAR2(20) PRIMARY KEY,
    DNAME VARCHAR2(20),
    MGRSTARTDATE DATE,
    MGRSSN VARCHAR2(20)
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



-- Insertion for DEPARTMENT table
INSERT INTO DEPARTMENT VALUES ('D001', 'HR', TO_DATE('01-JAN-2024', 'DD-MON-YYYY'), 'SSN001');
INSERT INTO DEPARTMENT VALUES ('D002', 'IT', TO_DATE('01-JAN-2024', 'DD-MON-YYYY'), 'SSN002');
INSERT INTO DEPARTMENT VALUES ('D003', 'Finance', TO_DATE('01-JAN-2024', 'DD-MON-YYYY'), 'SSN003');

-- Insertion for EMPLOYEE table
INSERT INTO EMPLOYEE VALUES ('SSN001', 'John', 'Scott', '123 Main St', 'M', 60000, NULL, 'D001');
INSERT INTO EMPLOYEE VALUES ('SSN002', 'Jane', 'Doe', '456 Elm St', 'F', 70000, NULL, 'D002');
INSERT INTO EMPLOYEE VALUES ('SSN003', 'Michael', 'Johnson', '789 Oak St', 'M', 80000, 'SSN001', 'D003');

-- Insertion for DLOCATION table
INSERT INTO DLOCATION VALUES ('Location1', 'D001');
INSERT INTO DLOCATION VALUES ('Location2', 'D002');
INSERT INTO DLOCATION VALUES ('Location3', 'D003');

-- Insertion for PROJECT table
INSERT INTO PROJECT VALUES (101, 'Project1', 'Location1', 'D001');
INSERT INTO PROJECT VALUES (102, 'Project2', 'Location2', 'D002');
INSERT INTO PROJECT VALUES (103, 'Project3', 'Location3', 'D003');

-- Insertion for WORKS_ON table
INSERT INTO WORKS_ON VALUES (40, 'SSN001', 101);
INSERT INTO WORKS_ON VALUES (35, 'SSN002', 102);
INSERT INTO WORKS_ON VALUES (30, 'SSN003', 103);



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
