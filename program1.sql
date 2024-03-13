CREATE TABLE PUBLISHER (
    NAME VARCHAR2(20) PRIMARY KEY,
    PHONE INTEGER,
    ADDRESS VARCHAR2(20)
);

CREATE TABLE BOOK (
    BOOK_ID INTEGER PRIMARY KEY,
    TITLE VARCHAR2(20),
    PUB_YEAR VARCHAR2(20),
    PUBLISHER_NAME VARCHAR2(20) REFERENCES PUBLISHER(NAME) ON DELETE CASCADE
);

CREATE TABLE BOOK_AUTHORS (
    AUTHOR_NAME VARCHAR2(20),
    BOOK_ID INTEGER REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE,
    PRIMARY KEY (BOOK_ID, AUTHOR_NAME)
);

CREATE TABLE LIBRARY_BRANCH (
    BRANCH_ID INTEGER PRIMARY KEY,
    BRANCH_NAME VARCHAR2(50),
    ADDRESS VARCHAR2(50)
);

CREATE TABLE BOOK_COPIES (
    NO_OF_COPIES INTEGER,
    BOOK_ID INTEGER REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE,
    BRANCH_ID INTEGER REFERENCES LIBRARY_BRANCH(BRANCH_ID) ON DELETE CASCADE,
    PRIMARY KEY (BOOK_ID, BRANCH_ID)
);

CREATE TABLE CARD (
    CARD_NO INTEGER PRIMARY KEY
);

CREATE TABLE BOOK_LENDING (
    DATE_OUT DATE,
    DUE_DATE DATE,
    BOOK_ID INTEGER REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE,
    BRANCH_ID INTEGER REFERENCES LIBRARY_BRANCH(BRANCH_ID) ON DELETE CASCADE,
    CARD_NO INTEGER REFERENCES CARD(CARD_NO) ON DELETE CASCADE,
    PRIMARY KEY (BOOK_ID, BRANCH_ID, CARD_NO)
);

INSERT INTO PUBLISHER VALUES ('MCGRAW-HILL', 9989076587, 'BANGALORE');
INSERT INTO PUBLISHER VALUES ('PEARSON', 9889076565, 'NEW DELHI');
INSERT INTO PUBLISHER VALUES ('RANDOM HOUSE', 7455679345, 'HYDERABAD');
INSERT INTO PUBLISHER VALUES ('HACHETTE LIVRE', 8970862340, 'CHENNAI');
INSERT INTO PUBLISHER VALUES ('GRUPO PLANETA', 7756120238, 'BANGALORE');

INSERT INTO BOOK VALUES (1, 'DBMS', 'JAN-2017', 'MCGRAW-HILL');
INSERT INTO BOOK VALUES (2, 'ADBMS', 'JUN-2016', 'MCGRAW-HILL');
INSERT INTO BOOK VALUES (3, 'CN', 'SEP-2016', 'PEARSON');
INSERT INTO BOOK VALUES (4, 'CG', 'SEP-2015', 'GRUPO PLANETA');
INSERT INTO BOOK VALUES (5, 'OS', 'MAY-2016', 'PEARSON');

INSERT INTO BOOK_AUTHORS VALUES ('NAVATHE', 1);
INSERT INTO BOOK_AUTHORS VALUES ('NAVATHE', 2);
INSERT INTO BOOK_AUTHORS VALUES ('TANENBAUM', 3);
INSERT INTO BOOK_AUTHORS VALUES ('EDWARD ANGEL', 4);
INSERT INTO BOOK_AUTHORS VALUES ('GALVIN', 5);

INSERT INTO LIBRARY_BRANCH VALUES (10, 'RR NAGAR', 'BANGALORE');
INSERT INTO LIBRARY_BRANCH VALUES (11, 'RNSIT', 'BANGALORE');
INSERT INTO LIBRARY_BRANCH VALUES (12, 'RAJAJINAGAR', 'BANGALORE');
INSERT INTO LIBRARY_BRANCH VALUES (13, 'NITTE', 'MANGALORE');
INSERT INTO LIBRARY_BRANCH VALUES (14, 'MANIPAL', 'UDUPI');

INSERT INTO BOOK_COPIES VALUES (10, 1, 10);
INSERT INTO BOOK_COPIES VALUES (5, 1, 11);
INSERT INTO BOOK_COPIES VALUES (2, 2, 12);
INSERT INTO BOOK_COPIES VALUES (5, 2, 13);
INSERT INTO BOOK_COPIES VALUES (7, 3, 14);
INSERT INTO BOOK_COPIES VALUES (1, 5, 10);
INSERT INTO BOOK_COPIES VALUES (3, 4, 11);

INSERT INTO CARD VALUES (100);
INSERT INTO CARD VALUES (101);
INSERT INTO CARD VALUES (102);
INSERT INTO CARD VALUES (103);
INSERT INTO CARD VALUES (104);

INSERT INTO BOOK_LENDING VALUES ('01-JAN-17', '01-JUN-17', 1, 10, 101);
INSERT INTO BOOK_LENDING VALUES ('11-JAN-17', '11-MAR-17', 3, 14, 101);
INSERT INTO BOOK_LENDING VALUES ('21-FEB-17', '21-APR-17', 2, 13, 101);
INSERT INTO BOOK_LENDING VALUES ('15-MAR-17', '15-JUL-17', 4, 11, 101);
INSERT INTO BOOK_LENDING VALUES ('12-APR-17', '12-MAY-17', 1, 11, 104);



SELECT 
    B.Book_id,
    B.Title,
    B.Publisher_Name,
    BA.Author_Name,
    BC.Branch_id,
    BC.No_of_Copies
FROM 
    BOOK B
JOIN 
    BOOK_AUTHORS BA ON B.Book_id = BA.Book_id
JOIN 
    BOOK_COPIES BC ON B.Book_id = BC.Book_id;


SELECT CARD_NO
FROM BOOK_LENDING
WHERE DATE_OUT BETWEEN '01-JAN-2017' AND '01-JUL-2017'
GROUP BY CARD_NO
HAVING COUNT(*) > 3;


DELETE FROM BOOK
WHERE BOOK_ID = 3;


CREATE VIEW V_PUBLICATION AS
SELECT PUB_YEAR, COUNT(*) AS BOOK_COUNT
FROM BOOK
GROUP BY PUB_YEAR;


CREATE VIEW V_BOOKS AS
SELECT B.BOOK_ID, B.TITLE, C.NO_OF_COPIES
FROM BOOK B
JOIN BOOK_COPIES C ON B.BOOK_ID = C.BOOK_ID;

SELECT * FROM V_BOOKS;
