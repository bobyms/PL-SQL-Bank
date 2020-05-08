drop table if exists branch;
/
drop table if exists customer;
/
drop table if exists account;
/
declare
  command1 varchar2(200):=
    'create table if not exists branch(
    numb char(3) NOT NULL Primary Key,
    addy varchar2(10) NOT NULL unique)';
  command2 varchar2(200):=
    'create table if not exists customer(
     numb char(5) NOT NULL Primary Key,
     name varchar2(10) NOT NULL unique)';
  command3 varchar2(300):=
    'create table if not exists account(
     numb char(7) NOT NULL Primary Key,
     c_numb varchar2(5) NOT NULL,
     balance int NOT NULL,
     foreign key (c_numb) references customer(numb)
       ON DELETE CASCADE)';
 begin
  execute immediate command1;
  execute immediate command2;
  execute immediate command3;
 end;
