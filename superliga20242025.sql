use SuperligaDB
go
drop table if exists matches
drop table if exists teams
go
create table teams
(
Id char(3) primary key,
name varchar(40),
nomatches int,
ourgoals int,
othergoals int,
points int
)
create table matches
(
id int identity(1,1),
homeid char(3) foreign key references teams(id),
outid char(3) foreign key references teams(id),
homegoal int,
outgoal int,
matchdate date
)
insert into teams values('agf','AGF',0,0,0,0)
insert into teams values('fck','FC København',0,0,0,0)
insert into teams values('rfc','Randers FC',0,0,0,0)
insert into teams values('vib','Viborg',0,0,0,0)
insert into teams values('lyn','Lyngby',0,0,0,0)
insert into teams values('sje','Sønderjyske',0,0,0,0)
insert into teams values('fcm','FC Midtjylland',0,0,0,0)
insert into teams values('bif','Brøndby IF',0,0,0,0)
insert into teams values('fcn','FC Nordsjælland',0,0,0,0)
insert into teams values('vej','Vejle',0,0,0,0)
insert into teams values('sil','Silkeborg',0,0,0,0)
insert into teams values('aab','Aab',0,0,0,0)
go
--
-- Indsæt triggere her

-- Insert trigger
create trigger InsertMatch
on matches
after insert
as
declare @homegoal as int
declare @outgoal as int
set @homegoal = (select homegoal from inserted)
set @outgoal = (select outgoal from inserted)
update teams
set nomatches = nomatches + 1,
ourgoals = ourgoals + @homegoal,
othergoals = othergoals + @outgoal
where id = (select homeid from inserted)
update teams
set nomatches = nomatches + 1,
ourgoals = ourgoals + @outgoal,
othergoals = othergoals + @homegoal
where id = (select outid from inserted)
if @homegoal > @outgoal
	update teams
	set points = points + 3
	where id = (select homeid from inserted)
else if @outgoal > @homegoal
	update teams
	set points = points + 3
	where id = (select outid from inserted)
else
begin
	update teams
	set points = points + 1
	where id = (select homeid from inserted)
	update teams
	set points = points + 1
	where id = (select outid from inserted)
end
go

-- Delete trigger
create trigger DeleteMatch
on matches
after delete
as
declare @homegoal as int
declare @outgoal as int
set @homegoal = (select homegoal from deleted)
set @outgoal = (select outgoal from deleted)
update teams
set nomatches = nomatches - 1,
ourgoals = ourgoals - @homegoal,
othergoals = othergoals - @outgoal
where id = (select homeid from deleted)
update teams
set nomatches = nomatches - 1,
ourgoals = ourgoals - @outgoal,
othergoals = othergoals - @homegoal
where id = (select outid from deleted)
if @homegoal > @outgoal
	update teams
	set points = points - 3
	where id = (select homeid from deleted)
else if @outgoal > @homegoal
	update teams
	set points = points - 3
	where id = (select outid from deleted)
else
begin
	update teams
	set points = points - 1
	where id = (select homeid from deleted)
	update teams
	set points = points - 1
	where id = (select outid from deleted)
end
go

-- Update trigger
create trigger UpdateMatch
on matches
instead of update
as
delete from matches where matchdate = (select matchdate from inserted) and homeid = (select homeid from inserted)
insert into matches values((select homeid from inserted), (select outid from inserted), (select homegoal from inserted), (select outgoal from inserted), (select matchdate from inserted))
go

insert into matches values('agf','fcm',1,1,'2024-7-19')
insert into matches values('fcn','aab',3,0,'2024-7-19')
insert into matches values('sil','sje',1,0,'2024-7-21')
insert into matches values('vej','rfc',2,3,'2024-7-21')
insert into matches values('vib','bif',3,3,'2024-7-21')
insert into matches values('lyn','fck',0,2,'2024-7-22')
-- 2
insert into matches values('sje','lyn',1,1,'2024-7-26')
insert into matches values('fcn','fcm',2,2,'2024-7-27')
insert into matches values('rfc','vib',3,1,'2024-7-28')
insert into matches values('aab','sil',2,1,'2024-7-28')
insert into matches values('fck','agf',3,2,'2024-7-28')
insert into matches values('bif','vej',2,1,'2024-7-29')
-- 3
insert into matches values('agf','sje',4,0,'2024-8-2')
insert into matches values('fcm','aab',2,0,'2024-8-3')
insert into matches values('sil','vib',3,2,'2024-8-4')
insert into matches values('fck','rfc',1,1,'2024-8-4')
insert into matches values('lyn','bif',0,2,'2024-8-4')
insert into matches values('vej','fcn',0,1,'2024-8-5')
-- 4
insert into matches values('fcm','vej',2,0,'2024-8-9')
insert into matches values('rfc','sil',0,2,'2024-8-11')
insert into matches values('fcn','lyn',1,1,'2024-8-11')
insert into matches values('bif','agf',0,1,'2024-8-11')
insert into matches values('sje','fck',0,2,'2024-8-11')
insert into matches values('vib','aab',2,3,'2024-8-12')
-- 5
insert into matches values('lyn','fcm',1,2,'2024-8-16')
insert into matches values('sil','fcn',4,1,'2024-8-18')
insert into matches values('rfc','sje',1,2,'2024-8-18')
insert into matches values('fck','vib',1,1,'2024-8-18')
insert into matches values('aab','bif',0,4,'2024-8-18')
insert into matches values('agf','vej',5,1,'2024-8-19')
-- 6
insert into matches values('aab','agf',0,4,'2024-8-23')
insert into matches values('fcm','sje',3,2,'2024-8-24')
insert into matches values('vej','sil',1,3,'2024-8-25')
insert into matches values('fcn','fck',3,2,'2024-8-25')
insert into matches values('bif','rfc',2,2,'2024-8-25')
insert into matches values('vib','lyn',1,0,'2024-8-26')
-- 7
insert into matches values('lyn','vej',1,0,'2024-8-30')
insert into matches values('agf','fcn',4,2,'2024-8-31')
insert into matches values('fck','bif',3,1,'2024-9-1')
insert into matches values('sje','vib',2,2,'2024-9-1')
insert into matches values('sil','fcm',1,3,'2024-9-1')
insert into matches values('rfc','aab',1,0,'2024-9-1')
--
go

-- Select statement til at se stillingen
select name, nomatches, ourgoals, othergoals, points
from teams
order by points desc, ourgoals - othergoals desc, ourgoals desc
go

-- Stored procedure til at se stillingen på en given dato
drop proc if exists StandingOnDate
go

create proc StandingOnDate
@date date
as
begin

declare @StandingOnDate table
(
Id char(3) primary key,
name varchar(40),
nomatches int,
ourgoals int,
othergoals int,
points int
)

insert into @StandingOnDate values('agf','AGF',0,0,0,0)
insert into @StandingOnDate values('fck','FC København',0,0,0,0)
insert into @StandingOnDate values('rfc','Randers FC',0,0,0,0)
insert into @StandingOnDate values('vib','Viborg',0,0,0,0)
insert into @StandingOnDate values('lyn','Lyngby',0,0,0,0)
insert into @StandingOnDate values('sje','Sønderjyske',0,0,0,0)
insert into @StandingOnDate values('fcm','FC Midtjylland',0,0,0,0)
insert into @StandingOnDate values('bif','Brøndby IF',0,0,0,0)
insert into @StandingOnDate values('fcn','FC Nordsjælland',0,0,0,0)
insert into @StandingOnDate values('vej','Vejle',0,0,0,0)
insert into @StandingOnDate values('sil','Silkeborg',0,0,0,0)
insert into @StandingOnDate values('aab','Aab',0,0,0,0)


declare p cursor
for select homeid, outid, homegoal, outgoal from matches
where matchdate <= @date
declare @homeid char(3), @outid char(3), @homegoal int, @outgoal int
open p
fetch p into @homeid, @outid, @homegoal, @outgoal
while @@fetch_status != -1
begin
  update @StandingOnDate
  set nomatches = nomatches + 1,
  ourgoals = ourgoals + @homegoal,
  othergoals = othergoals + @outgoal
  where id = @homeid
  update @StandingOnDate
  set nomatches = nomatches + 1,
  ourgoals = ourgoals + @outgoal,
  othergoals = othergoals + @homegoal
  where id = @outid
  if @homegoal > @outgoal
	update @StandingOnDate
	set points = points + 3
	where id = @homeid
else if @outgoal > @homegoal
	update @StandingOnDate
	set points = points + 3
	where id = @outid
else
begin
	update @StandingOnDate
	set points = points + 1
	where id = @homeid
	update @StandingOnDate
	set points = points + 1
	where id = @outid
end
  fetch p into @homeid, @outid, @homegoal, @outgoal
end
close p
deallocate p

select *
from @StandingOnDate
order by points desc, ourgoals - othergoals desc, ourgoals desc

end
go

-- Stored procedure til at printe føreren af ligaen for hver dag, der har været kamp
drop proc if exists PrintLeaderOfTheDay
go

create proc PrintLeaderOfTheDay
as
begin

declare f cursor
for select distinct matchdate from matches
declare @matchdate date, @leader varchar(40)
open f
fetch f into @matchdate
while @@fetch_status != -1
begin
  execute @leader = StandingOnDate @matchdate

  print 'On date ' + convert(varchar(20),@matchdate) + ' the leader is ' + @leader
  fetch f into @matchdate
end
close f
deallocate f

end
go

execute PrintLeaderOfTheDay

execute StandingOnDate '2024-7-19'
--delete from matches where matchdate = '2024-8-31' and homeid = 'agf'

/*
update matches
set homegoal = 2,
outgoal = 4
where matchdate = '2024-8-31' and homeid = 'agf'
*/

--select * from matches
--order by matchdate desc