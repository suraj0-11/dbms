-- Table creation for STUDENT
CREATE TABLE STUDENT (
    USN VARCHAR(10) PRIMARY KEY,
    SNAME VARCHAR(25),
    ADDRESS VARCHAR(25),
    PHONE NUMBER(10),
    GENDER CHAR(1)
);

-- Table creation for SEMSEC
CREATE TABLE SEMSEC (
    SSID VARCHAR(5) PRIMARY KEY,
    SEM NUMBER(2),
    SEC CHAR(1)
);

-- Table creation for CLASS
CREATE TABLE CLASS (
    USN VARCHAR(10),
    SSID VARCHAR(5),
    PRIMARY KEY (USN, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT (USN),
    FOREIGN KEY (SSID) REFERENCES SEMSEC (SSID)
);

-- Table creation for SUBJECT
CREATE TABLE SUBJECT (
    SUBCODE VARCHAR(8) PRIMARY KEY,
    TITLE VARCHAR(20),
    SEM NUMBER(2),
    CREDITS NUMBER(2)
);

-- Table creation for IAMARKS
CREATE TABLE IAMARKS (
    USN VARCHAR(10),
    SUBCODE VARCHAR(8),
    SSID VARCHAR(5),
    TEST1 NUMBER(2),
    TEST2 NUMBER(2),
    TEST3 NUMBER(2),
    FINALIA NUMBER(2),
    PRIMARY KEY (USN, SUBCODE, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT (USN),
    FOREIGN KEY (SUBCODE) REFERENCES SUBJECT (SUBCODE),
    FOREIGN KEY (SSID) REFERENCES SEMSEC (SSID)
);

-- Insertion for STUDENT table
INSERT INTO STUDENT VALUES ('1VE13CS020', 'AKSHAY', 'BELAGAVI', 8877881122, 'M');
INSERT INTO STUDENT VALUES ('1VE13CS062', 'SANDHYA', 'BENGALURU', 7722829912, 'F');
INSERT INTO STUDENT VALUES ('1VE13CS091', 'TEESHA', 'BENGALURU', 7712312312, 'F');
INSERT INTO STUDENT VALUES ('1VE13CS066', 'SUPRIYA', 'MANGALURU', 877881122, 'F');

-- Insertion for SEMSEC table
INSERT INTO SEMSEC VALUES ('CSE8A', 8, 'A');
INSERT INTO SEMSEC VALUES ('CSE8B', 8, 'B');
INSERT INTO SEMSEC VALUES ('CSE8C', 8, 'C');
INSERT INTO SEMSEC VALUES ('CSE7A', 7, 'A');

-- Insertion for CLASS table
INSERT INTO CLASS VALUES ('1VE13CS020', 'CSE8A');
INSERT INTO CLASS VALUES ('1VE13CS062', 'CSE8A');
INSERT INTO CLASS VALUES ('1VE13CS066', 'CSE8B');
INSERT INTO CLASS VALUES ('1VE13CS091', 'CSE8C');

-- Insertion for SUBJECT table
INSERT INTO SUBJECT VALUES ('10CS81', 'ACA', 8, 4);
INSERT INTO SUBJECT VALUES ('10CS82', 'SSM', 8, 4);
INSERT INTO SUBJECT VALUES ('10CS83', 'NM', 8, 4);
INSERT INTO SUBJECT VALUES ('10CS84', 'CC', 8, 4);

-- Insertion for IAMARKS table
INSERT INTO IAMARKS VALUES ('1VE13CS020', '10CS81', 'CSE8A', 11, 11, 14, NULL);
INSERT INTO IAMARKS VALUES ('1VE13CS062', '10CS82', 'CSE8A', 12, 16, 14, NULL);
INSERT INTO IAMARKS VALUES ('1VE13CS066', '10CS83', 'CSE8B', 19, 15, 20, NULL);
INSERT INTO IAMARKS VALUES ('1VE13CS091', '10CS84', 'CSE8C', 20, 16, 19, NULL);



SELECT S.*
FROM STUDENT S, CLASS C, SEMSEC SS
WHERE S.USN = C.USN 
AND C.SSID = SS.SSID 
AND SS.SEM = 8
AND SS.SEC = 'C';


SELECT SS.SEM, SS.SEC, S.GENDER, COUNT(S.GENDER) AS COUNT
FROM STUDENT S, CLASS C, SEMSEC SS
WHERE S.USN = C.USN 
AND C.SSID = SS.SSID
GROUP BY SS.SEM, SS.SEC, S.GENDER
ORDER BY SS.SEM, SS.SEC;


CREATE VIEW STU_TEST1_MARKS_VIEW AS
SELECT TEST1, SUBCODE
FROM IAMARKS
WHERE USN = '1VE13CS091';


CREATE OR REPLACE PROCEDURE AVGMARKS AS
BEGIN
    UPDATE IAMARKS 
    SET FINALIA = (TEST1 + TEST2 + TEST3 - LEAST(TEST1, TEST2, TEST3)) / 2
    WHERE FINALIA IS NULL;
END AVGMARKS;


BEGIN
    AVGMARKS;
END;


SELECT * FROM IAMARKS;




SELECT S.USN, S.SNAME, S.ADDRESS, S.PHONE, S.GENDER,
    CASE 
        WHEN IA.FINALIA BETWEEN 17 AND 20 THEN 'OUTSTANDING'
        WHEN IA.FINALIA BETWEEN 12 AND 16 THEN 'AVERAGE'
        ELSE 'WEAK'
    END AS CAT
FROM STUDENT S, CLASS C, SEMSEC SS, IAMARKS IA
WHERE S.USN = IA.USN 
    AND C.USN = S.USN 
    AND C.SSID = SS.SSID 
    AND SS.SEM = 8;
