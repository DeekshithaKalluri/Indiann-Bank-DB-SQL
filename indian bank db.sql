select * from PRODUCTMASTER 
select * from RegionMaster 
select * from BranchMaster
select * from UserMaster
select * from AccountMaster
select * from TxnnMaster
sp_help PRODUCTMASTER
sp_help RegionMaster
sp_help BranchMaster
sp_help UserMaster
sp_help AccountMaster
sp_help TxnnMaster
use master

create database INDIAN_BANK

use INDIAN_BANK

create table PRODUCTMASTER
(
	PID				CHAR(2)			Primary Key,
	PRODUCTNAME		VARCHAR(25)		NOT NULL 
)

insert into PRODUCTMASTER values ('SB', 'Savings Bank')
insert into PRODUCTMASTER values ('LA', 'Loan Account')
insert into PRODUCTMASTER values ('FD', 'Fixed Deposit')
insert into PRODUCTMASTER values ('RD', 'Recurring deposits')

--Regionmaster
create table RegionMaster
(
	RID			INTEGER			Primary Key,
	REGIONNAME	CHAR(6)			NOT NULL
)

insert into RegionMaster values (1, 'South')
insert into RegionMaster values (2, 'North')
insert into RegionMaster values (3, 'East')
insert into RegionMaster values (4, 'West')

--BranchMaster
create table BranchMaster
(
	BRID			CHAR(3)			Primary Key,
	BRANCHNAME		VARCHAR(30)		NOT NULL,
	BRANCHADDRESS	VARCHAR(50)		NOT NULL,
	RID				INT				NOT NULL Foreign Key references RegionMaster(RID)
)

insert into BranchMaster values ('BR1', 'Goa', 'Opp: KLM Mall, Panaji, Goa-677123', 2)
insert into BranchMaster values ('BR2', 'Hyd', 'Hitech city, hitex, Hyd-576234', 1)
insert into BranchMaster values ('BR3', 'Mumbai', 'Aidheri, Mum-544234', 2)
insert into BranchMaster values ('BR4', 'delhi', 'delhi, del-545434', 3)

--UserMaster
create table UserMaster
(
	USERID			INTEGER			Primary Key,
	USERNAME		VARCHAR(30)		NOT NULL,
	DESIGNATION		CHAR(1)			NOT NULL check(DESIGNATION in ('M', 'C', 'T', 'O'))
)

insert into UserMaster values(1, 'Bhaskar jogi', 'M')
insert into UserMaster values(2, 'Ravi', 'T')
insert into UserMaster values(3, 'Krishan', 'O')
insert into UserMaster values(4, 'John', 'C')
--AccountMaster
create table AccountMaster
(
	ACID				INTEGER				Primary Key,
	NAME				VARCHAR(40)			NOT NULL,
	ADDRESS				VARCHAR(50)			NOT NULL,
	BRID				CHAR(3)				NOT NULL Foreign Key references Branchmaster(BRID),
	PID					CHAR(2)				NOT NULL Foreign Key references PRODUCTMASTER(PID),
	DOO					DATETIME			NOT NULL,
	CBALANCE			MONEY				NULL,
	UBALANCE			MONEY				NULL,
	STATUS				CHAR(1)				NOT NULL check(STATUS in ('O', 'I', 'C'))
)

insert into AccountMaster values (101, 'Raveena', 'USA', 'BR1', 'SB', '2018/12/23', 1000, 1000, 'O')
insert into AccountMaster values (102, 'Ahmed', 'Mumbai', 'BR2', 'SB', '2018/12/27', 2000, 2000, 'O')
insert into AccountMaster values (103, 'Ram', 'Delhi', 'BR3', 'RD', '2019/12/27', 3000, 9000, 'I')
insert into AccountMaster values (104, 'John', 'Pune', 'BR2', 'FD', '2019/01/17', 4000, 8000, 'C')
insert into AccountMaster values (105, 'Deeksha', 'Gujarat', 'BR4', 'LA', '2019/01/27', 5000, 7000, 'O')
insert into AccountMaster values (106, 'Bhaskar', 'Mumbai', 'BR1', 'RD', '2019/02/17', 6000, 6000, 'C')
insert into AccountMaster values (107, 'Hemanth', 'Vijayawada', 'BR3', 'FD', '2019/02/27', 7000, 5000, 'I')
insert into AccountMaster values (108, 'Nuva', 'hyd', 'BR2', 'LA', '2019/02/27', 8000, 4000, 'C')
insert into AccountMaster values (109, 'ravi', 'chennai', 'BR4', 'SB', '2019/03/17', 9000, 3000, 'I')
insert into AccountMaster values (110, 'shiva', 'delhi', 'BR3', 'FD', '2019/03/27', 2000, 2000, 'C')

--TransactionMaster
create table TxnnMaster
(
	TNO			INT				Primary Key Identity(1,1),
	DOT			DATETIME		NOT NULL,
	ACID		INTEGER			NOT NULL Foreign Key references Accountmaster(ACID),
	BRID		CHAR(3)			NOT NULL Foreign Key references BranchMaster(BRID),
	TXN_TYPE	CHAR(3)			NOT NULL check(TXN_TYPE in ('CW', 'CD', 'CQD')),
	CHQ_NO		INTEGER			NULL,
	CHQ_DATE	SMALLDATETIME	NULL,
	TXN_AMOUNT	MONEY			NOT NULL,
	USERID		INTEGER			NOT NULL Foreign Key references UserMaster(UserID),
)

insert into TxnnMaster values ('2019/1/12', 101, 'BR1', 'CD', null, null, 1000, 1)
insert into TxnnMaster values ('2019/1/12', 102, 'BR1', 'CD', null, null, 4000, 3)
insert into TxnnMaster values ('2019/1/15', 102, 'BR1', 'CW', null, null, 2000, 4)

--Add check constraint to TxnnMaster
Alter table TxnnMaster
add check (TXN_AMOUNT >= 0);

--or
alter table TxnnMaster
add constraint CK_TxnnMaster_TXN_Amt_Cannot_Negative check(TXN_AMOUNT >= 0);

--drop
alter table TxnnMaster
drop constraint CK__TxnnMaste__TXN_A__45F365D3

--add FK
alter table TxnnMaster
add foreign key (UserID) references UserMaster(UserID);

--drop FK
alter table TxnnMaster
drop foreign key FK__TxnnMaste__USERI__398D8EEE

--all rows and columns
select * from AccountMaster

--all rows and some columns
select PID, name, CBALANCE from AccountMaster

--some rows and all columns
select * from AccountMaster where PID = 'SB'

--some rows and some columns
select pid, name, CBALANCE
from AccountMaster
where brid = 'BR1'

--sorting
select * from AccountMaster order by name asc--DESC
select * from AccountMaster order by CBALANCE asc--DESC

--list acid and name only for SB accounts and list the names in descending order
select acid,name 
from AccountMaster
where pid = 'SB'
order by name desc

--concatenate
--use + symbol
select acid, name + ' is doing SQL' as course
from AccountMaster

--counts number of rows in a table/ find out no of customers
select COUNT(*) 'No of Customers' from AccountMaster

--find out no of customers in branch
select COUNT(*) 'No of Customers'
from AccountMaster
where BRID = 'BR1'

--find out no of customers in branch BR1 and BR2
select COUNT(*) 'No of Customers'
from AccountMaster
where BRID = 'BR1' or BRID = 'BR2'

--find out no of customers in branch BR1 and BR2, BR4
select COUNT(*) 'No of Customers'
from AccountMaster
where BRID in ('BR1', 'BR2', 'BR4')

--gets the total value
select sum(CBALANCE) as [Total Bal]
from AccountMaster
where BRID = 'BR2'

--gets the minimum value
select min(CBALANCE) as [Minimum Bal]
from AccountMaster
where BRID = 'BR2'

--gets the maximum value
select max(CBALANCE) as [Maximum Bal]
from AccountMaster
where BRID = 'BR2'

--gets the average value
select avg(CBALANCE) as [Average Bal]
from AccountMaster

--All
select 
	count(1) 'No of Customers',
	Avg(CBALANCE) as AvgBal,
	Max(CBALANCE) as MaxBal,
	Min(CBALANCE) as MinBal,
	sum(CBALANCE) as TotalBal
from AccountMaster
where BRID = 'BR2'

--no of customers in BR1
select COUNT(*) as [No of Customers] from AccountMaster where BRID = 'BR1'

--group by(no of customers in all groups like BR1,BR2,BR3,BR4)
select BRID, count(*) as [No of Customer]
from AccountMaster 
Group by BRID

--group by(no of customers in all groups like BR1,BR2,BR3,BR4) by using WHERE clause
select BRID, count(*) as [No of Customer]
from AccountMaster 
where ADDRESS = 'Mumbai'
Group by BRID

--group by(no of customers in all groups like BR1,BR2,BR3,BR4) with order by descending order
select PID, count(*) as [No of Customer]
from AccountMaster 
Group by PID
order by PID desc  --order by PID(or 1) desc --order by No of customers(or 2) desc

--group in a group
--branch wise, product wise no of customers
select BRID, PID, count(*) as cnt
from AccountMaster
group by BRID,PID

--branch wise, product wise no of customers in the year 2018
select BRID, PID, count(*) as cnt
from AccountMaster
where year(DOO) = 2018
group by BRID,PID

--distict is used to remove duplicates
--get all branches
select distinct BRID from AccountMaster

select BRID from AccountMaster group by BRID --bad choice
--because group by clause needs to be used only for aggregration
--Do not use group by clause if there is no aggregration 

--find out no of branches
select count(distinct BRID) as NoOfBRs from AccountMaster

