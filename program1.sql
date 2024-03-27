CREATE TABLE SALESMAN (
    SALESMAN_ID NUMBER(4),
    NAME VARCHAR2(20),
    CITY VARCHAR2(20),
    COMMISSION VARCHAR2(20),
    PRIMARY KEY (SALESMAN_ID)
);

DROP TABLE SALESMAN;

CREATE TABLE CUSTOMER1 (
    CUSTOMER_ID NUMBER(4),
    CUST_NAME VARCHAR2(20),
    CITY VARCHAR2(20),
    GRADE NUMBER(3),
    PRIMARY KEY (CUSTOMER_ID),
    SALESMAN_ID NUMBER(4) REFERENCES SALESMAN (SALESMAN_ID) ON DELETE SET NULL
);

CREATE TABLE ORDERS (
    ORD_NO NUMBER(5),
    PURCHASE_AMT NUMBER(10, 2),
    ORD_DATE VARCHAR(20),
    CUSTOMER_ID NUMBER(4) REFERENCES CUSTOMER1 (CUSTOMER_ID) ON DELETE CASCADE,
    SALESMAN_ID NUMBER(4) REFERENCES SALESMAN (SALESMAN_ID) ON DELETE CASCADE,
    PRIMARY KEY (ORD_NO)
);




-- Insertion statements
INSERT INTO SALESMAN VALUES (1000, 'JOHN', 'BANGALORE', '25%');
INSERT INTO SALESMAN VALUES (2000, 'RAVI', 'BANGALORE', '20%');
INSERT INTO SALESMAN VALUES (3000, 'KUMAR', 'MYSORE', '15%');
INSERT INTO SALESMAN VALUES (4000, 'SMITH', 'DELHI', '30%');
INSERT INTO SALESMAN VALUES (5000, 'HARSHA', 'HYDERABAD', '15%');

SELECT * FROM CUSTOMER1;

INSERT INTO CUSTOMER1 VALUES (10, 'PREETHI', 'BANGALORE', 100, 1000);
INSERT INTO CUSTOMER1 VALUES (11, 'VIVEK', 'MANGALORE', 300, 1000);
INSERT INTO CUSTOMER1 VALUES (12, 'BHASKAR', 'CHENNAI', 400, 2000);
INSERT INTO CUSTOMER1 VALUES (13, 'CHETHAN', 'BANGALORE', 200, 2000);
INSERT INTO CUSTOMER1 VALUES (14, 'MAMATHA', 'BANGALORE', 400, 3000);

INSERT INTO ORDERS VALUES (50, 5000, '04-MAY-17', 10, 1000);
INSERT INTO ORDERS VALUES (51, 450, '20-JAN-17', 10, 2000);
INSERT INTO ORDERS VALUES (52, 1000, '24-FEB-17', 13, 2000);
INSERT INTO ORDERS VALUES (53, 3500, '13-APR-17', 14, 3000);
INSERT INTO ORDERS VALUES (54, 550, '09-MAR-17', 12, 2000);

-- Queries
-- 1. Count the customers with grades above Bangalore’s average.

SELECT COUNT(*)
FROM CUSTOMER1
WHERE GRADE > (
    SELECT AVG(GRADE)
    FROM CUSTOMER1
    WHERE CITY = 'BANGALORE'
);

-- 2. Find the name and numbers of all salesmen who had more than one customer.

SELECT S.NAME, COUNT(*) AS Number_of_Customers
FROM SALESMAN S
JOIN CUSTOMER1 C ON S.SALESMAN_ID = C.SALESMAN_ID
GROUP BY S.NAME
HAVING COUNT(*) > 1;


-- 3. List salesmen with their customers or indicate if they have no customers in their cities
SELECT S.SALESMAN_ID, S.NAME, S.COMMISSION,
       NVL(C.CUST_NAME, 'NO CUSTOMER') AS CUSTOMER_NAME
FROM SALESMAN S
LEFT JOIN CUSTOMER1 C ON S.CITY = C.CITY;

-- 4. Create a view to find the salesman with the highest daily order
CREATE VIEW ELITSALESMAN AS
SELECT S.SALESMAN_ID, S.NAME, O.ORD_DATE, O.ORD_NO
FROM SALESMAN S
JOIN ORDERS O ON S.SALESMAN_ID = O.SALESMAN_ID
WHERE (O.ORD_DATE, O.PURCHASE_AMT) IN (
    SELECT ORD_DATE, MAX(PURCHASE_AMT) FROM ORDERS GROUP BY ORD_DATE
);


-- 5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted.

DELETE FROM ORDERS WHERE SALESMAN_ID = 1000;
DELETE FROM SALESMAN WHERE SALESMAN_ID = 1000;
