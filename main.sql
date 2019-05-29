-- Database: postgres

-- DROP DATABASE postgres;

CREATE DATABASE postgres
    WITH 
    OWNER = oguzozan
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE postgres
    IS 'default administrative connection database';

    DROP TABLE Member CASCADE;
DROP TABLE Event CASCADE;
DROP TABLE Organizator CASCADE;
DROP TABLE Participation CASCADE;

CREATE TABLE Organizator(
	organizatorId SERIAL PRIMARY KEY,
	username TEXT UNIQUE NOT NULL,
	password TEXT NOT NULL
);

CREATE TABLE Member(
	memberId SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	surname TEXT NOT NULL,
	username TEXT UNIQUE NOT NULL,
	password TEXT NOT NULL,
	birthday DATE NOT NULL,
	bill INTEGER DEFAULT 0,
	membership TEXT DEFAULT 'standart',
	participationCount INTEGER DEFAULT '0',
	CONSTRAINT membershipcheck CHECK (membership IN ('standart', 'gold'))
);

CREATE TABLE Event(
	eventId SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	category TEXT NOT NULL,
	address TEXT,
	country TEXT,
	city TEXT,
	startDate DATE NOT NULL,
	endDate DATE NOT NULL,
	price INTEGER NOT NULL,
	quota INTEGER NOT NULL,
	eventCampaign INTEGER DEFAULT '0',
	oId INTEGER NOT NULL,
	count INTEGER DEFAULT '0',
	CONSTRAINT fk_organizatorId FOREIGN KEY(oId)
	REFERENCES Organizator(organizatorId) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT dateController CHECK (startDate <= endDate)
);

CREATE TABLE Participation(
	participationId SERIAL PRIMARY KEY,
	eventId INTEGER NOT NULL,
	CONSTRAINT fk_eventId FOREIGN KEY(eventId)
	REFERENCES Event(eventId) ON DELETE CASCADE ON UPDATE CASCADE,
	memberId INTEGER NOT NULL,
	CONSTRAINT fk_memId FOREIGN KEY(memberId)
	REFERENCES Member(memberId) ON DELETE CASCADE ON UPDATE CASCADE
);



INSERT INTO Organizator(username,password) values('deu','123456');
INSERT INTO Organizator(username,password) values('yigit','123456');
INSERT INTO Organizator(username,password) values('baris','123456');
INSERT INTO Organizator(username,password) values('ali','123456');

INSERT INTO Member(name,surname,username,password,birthday) VALUES('oguz','ozan','ozokwo','123456','1994-12-09');
INSERT INTO Member(name,surname,username,password,birthday) VALUES('yigit','ulken','ozokwo1','123456','1994-12-09');
INSERT INTO Member(name,surname,username,password,birthday) VALUES('baris','ozan','ozokwo2','123456','1994-12-09');
INSERT INTO Member(name,surname,username,password,birthday) VALUES('oguz3','ozan','ozokwo3','123456','1994-12-09');
INSERT INTO Member(name,surname,username,password,birthday) VALUES('oguz4','ozan','ozokwo4','123456','1994-12-09');
INSERT INTO Member(name,surname,username,password,birthday) VALUES('oguz5','ozan','ozokwo5','123456','1994-12-09');
INSERT INTO Member(name,surname,username,password,birthday) VALUES('oguz6','ozan','ozokwo6','123456','1994-12-09');
INSERT INTO Member(name,surname,username,password,birthday) VALUES('oguz7','ozan','ozokwo7','123456','1994-12-09');

INSERT INTO Event(name,city,startDate,endDate,price,quota,oId,category) VALUES('wedding','izmir','2019-12-07','2019-12-09','100','20',1,'academic');
INSERT INTO Event(name,city,startDate,endDate,price,quota,oId,category) VALUES('spiel','izmir','2019-12-07','2019-12-09','100','20',2,'entertainment');
INSERT INTO Event(name,city,startDate,endDate,price,quota,oId,category) VALUES('fussball','istanbul','2019-12-07','2019-12-09','100','20',3,'academic');
INSERT INTO Event(name,city,startDate,endDate,price,quota,oId,category) VALUES('hockey','bursa','2019-12-07','2019-12-09','100','20',1,'academic');
INSERT INTO Event(name,city,startDate,endDate,price,quota,oId,category) VALUES('camping','eskisehir','2019-12-07','2024-12-09','100','20',2,'concert');
INSERT INTO Event(name,city,startDate,endDate,price,quota,oId,category) VALUES('summer school','antalya','2021-12-07','2021-12-09','100','20',2,'sport');

INSERT INTO Participation(eventId,memberId) VALUES (1,1);
INSERT INTO Participation(eventId,memberId) VALUES (1,2);
INSERT INTO Participation(eventId,memberId) VALUES (1,3);
INSERT INTO Participation(eventId,memberId) VALUES (1,4);
INSERT INTO Participation(eventId,memberId) VALUES (2,1);
INSERT INTO Participation(eventId,memberId) VALUES (4,1);
INSERT INTO Participation(eventId,memberId) VALUES (5,1);
INSERT INTO Participation(eventId,memberId) VALUES (3,2);
INSERT INTO Participation(eventId,memberId) VALUES (4,3);
INSERT INTO Participation(eventId,memberId) VALUES (2,1);
INSERT INTO Participation(eventId,memberId) VALUES (2,4);
INSERT INTO Participation(eventId,memberId) VALUES (2,3);


--Query 1
SELECT * From Event WHERE address = 'izmir';

--Query 2

SELECT eventId AS highestAttendance,COUNT(*) as attendants FROM Participation GROUP BY eventId ORDER BY attendants DESC LIMIT 1;


--Query 3

SELECT category, COUNT(*) as numberOfEvents FROM Event GROUP BY category ORDER BY numberOfEvents DESC;

--Query 4

SELECT name FROM Event WHERE endDate > '2020-06-04';

--Query 5

SELECT name, COUNT(Event.eventId) as C
FROM Event JOIN Participation ON Event.eventId = Participation.eventId 
GROUP BY event.eventId
HAVING Count(Event.eventId) < 3;

--Query 6.1

SELECT Member.memberId, Member.name, COUNT(Member.memberId) FROM Member JOIN Participation ON Member.memberId = Participation.memberId
GROUP BY member.memberId
HAVING COUNT(Member.memberId) >= 3;  

--Query 6.2

UPDATE Member SET membership = 'gold'
WHERE memberId IN 
(SELECT Member.memberId 
FROM Member JOIN Participation ON Member.memberId = Participation.memberId
GROUP BY member.memberId
HAVING COUNT(Member.memberId) >= 3);


--Query 7    << oid='1' is deu >>

DELETE from Event WHERE oid = '1' AND category = 'academic';

--Query 8



--Query 9

UPDATE Event SET eventCampaign = '25' WHERE city LIKE 'i%';

--Query 10

DELETE FROM Member 
WHERE username NOT IN
(SELECT Member.username from Member 
JOIN Participation ON Member.memberId = Participation.memberId
GROUP BY Member.username);



