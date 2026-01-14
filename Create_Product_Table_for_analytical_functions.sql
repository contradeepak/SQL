USE University;

DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    Product_id INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(50),
    Product_Category VARCHAR(50),
    Sold INT UNSIGNED,
    Commission DECIMAL(3,2)
);


INSERT INTO Products Values (1,'SQL','Data',50000,0.5);
INSERT INTO Products Values (2,'Tensor Flow','Data',15000,0.4);
INSERT INTO Products Values (3,'Open Text','Data',20000,0.3);
INSERT INTO Products Values (4,'Sentiment Analytics','Data',17000,0.4);
INSERT INTO Products Values (5,'Web Analytics','Data',16000,0.6);
INSERT INTO Products Values (6,'Data Mining','Data',30000,0.2);
INSERT INTO Products Values (7,'Data Visualization','Data',20000,0.4);
INSERT INTO Products Values (8,'Excel','Data',13000,0.3);
INSERT INTO Products Values (9,'Open CV','Data',17000,0.4);
INSERT INTO Products Values (10,'Management','Business',150000,0.5);
INSERT INTO Products Values (11,'Finance','Business',140000,0.5);
INSERT INTO Products Values (12,'Leadership','Business',130000,0.5);
INSERT INTO Products Values (13,'Supply Chain','Business',120000,0.5);
INSERT INTO Products Values (14,'Python','Programming',200000,0.5);
INSERT INTO Products Values (15,'C++','Programming',210000,0.5);
INSERT INTO Products Values (16,'Java','Programming',250000,0.5);

SELECT * from products;
