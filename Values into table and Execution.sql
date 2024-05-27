insert into faculty values('FC1','nour',2)
insert into faculty values('FC2','dina',2)
insert into faculty values('FC3','marez',2)
insert into faculty values('FC7','marez',2)
insert into faculty values('FC8','marez',2)
insert into faculty values('FC10','marez',2)

insert into major values ('MC1','CS','FC1')
insert into major values ('MC2','ARCH','FC2')
insert into major values ('MC3','ENG','FC3')
insert into major values ('MC4','BUS','FC4')
insert into major values ('MC6','BUS','FC7')
insert into major values ('MC7','BUS','FC7')
insert into major values ('MC10','BUS','FC10')

------------------------

EXEC MakePreferencesLocalProject 

Exec TACreatePR 2,1,'1/1/2003','content'

Exec EEGradeThesis 123, 11, 'Thesis title' , 16
exec EEGradedefense 111,145,'location1',98.5

Exec TACreatePr 1, 2, '3/11/1985' , 'PR Content2'

Exec LecGradedefense 1003322, 7002212, 'Hall2', 150.67

Exec ViewMyThesis 700999, "Title5"
 
 Exec LecturerCreateLocalProject 1002233, '4321', 'Project Description:', '1222', 'SE123'

 Exec LecGradedefense 701, 701, 'Hall2', 150
 --------------


 EXEC LecGradePR 1,12,'2/5/2001',67  --NZABAT HAGAT FL PROGRESS REPORT
 
 Exec MakePreferencesLocalProject 1

 Exec LecturerCreateLocalProject 1,'PC1','title','desc','M1'
 Exec SuperviseIndustrial 1,'PC4'

 --------------
 /*2)a*/
Declare @success1 bit
declare @userid int
EXEC UserLogin 'marezmagdy@gamil.com' , 'WeLoveULeqaa',  @success1 OUTPUT, @userid OUTPUT
Print @success1
print @userid

Declare @user_id int 
Declare @password varchar(10) 
EXEC UserRegister  'lecturer','nour', ' marezmagdy@gmail.com' ,'Maryse' ,'Magdy' , '11-13-2003' , '3.2', '2' , '13 share3 maadi', 'f1' , 'M1', 'Apple' , 'REpname', 'rep@gmail.com' , '01284090290', 'egypt', @user_id output, @password output
print @user_id
print @password

Declare @user_id3 int 
Declare @password3 varchar(10) 
EXEC UserRegister  'External_examiners','nour2', 'nournehad@gmail.com' ,'nours' ,'nehad' , '11-4-2003' , '2.0', '3' , 'rehab city1', 'f3' , 'M4', 'COMP3' , 'NAME3', 'nournehad762@gmail.com' , '01284790555', 'egypt', 
@user_id3 output, @password3 output
print @user_id3
print @password3

Declare @user_id2 int 
Declare @password2 varchar(10) 
EXEC UserRegister  'coordinator','nour', ' whatever@gmail.com' ,'nour' ,'ahmed' , '10-3-2003' , '3.0', '3' , 'rehab city', 'f2' , 'M3', 'COMP2' , 'NAME2', 'nourhelmy762@gmail.com' , '01284090555', 'egypt', 
@user_id2 output, @password2 output
print @user_id2
print @password2

Declare @user_id4 int 
Declare @password4 varchar(10) 
EXEC UserRegister  'Teaching_assistants','nour5', 'nour5hossam@gmail.com' ,'nour5' ,'hossam' , '5-1-2003' , '1.0', '3' , 'madinaty', 'f8' , 'M5', 'COMP7' , 'what', 'nourhossam762@gmail.com' , '01299790555', 'berlin', 
@user_id4 output, @password4 output
print @user_id4
print @password4

Declare @user_id1 int 
Declare @password1 varchar(10) 
EXEC UserRegister  'Student','dina', ' marezmagdy@gmail.com' ,'Dina' ,'Adel' , '11-13-2003' , '3.2', '2' , '13 share3 maadi', 'FC1' , 'MC1', 'COMP1' , 'NAME', 'nourhelmy@gmail.com' , '01284090290', 'egypt', 
@user_id1 output, @password1 output
print @user_id1
print @password1

Declare @user_id1 int 
Declare @password1 varchar(10) 
EXEC UserRegister  'Student','Julie', ' marezmagdy@gmail.com' ,'Dina' ,'Adel' , '11-13-2003' , '3.2', '2' , '13 share3 maadi', 'FC10' , 'MC10', 'COMP1' , 'NAME', 'nourhelmy@gmail.com' , '01284090290', 'egypt', 
@user_id1 output, @password1 output
print @user_id1
print @password1

Declare @user_id1 int 
Declare @password1 varchar(10) 
EXEC UserRegister  'Student','eta', ' marezmagdy@gmail.com' ,'Dina' ,'Adel' , '11-13-2003' , '3.2', '2' , '13 share3 maadi', 'FC10' , 'MC10', 'COMP1' , 'NAME', 'nourhelmy@gmail.com' , '01284090290', 'egypt', 
@user_id1 output, @password1 output
print @user_id1
print @password1

Declare @user_id1 int 
Declare @password1 varchar(10) 
EXEC UserRegister  'Student','Maryse', ' marezmagdy@gmail.com' ,'Dina' ,'Adel' , '11-13-2003' , '3.2', '2' , '13 share3 maadi', 'FC2' , 'MC2', 'COMP1' , 'NAME', 'nourhelmy@gmail.com' , '01284090290', 'egypt', 
@user_id1 output, @password1 output
print @user_id1
print @password1


Declare @user_id1 int 
Declare @password1 varchar(10) 
EXEC UserRegister  'Student','Maryse', ' marezmagdy@gmail.com' ,'maryse' ,'Adel' , '11-13-2003' , '3.2', '2' , '13 share3 maadi', 'FC2' , 'MC2', 'COMP1' , 'NAME', 'nourhelmy@gmail.com' , '01284090290', 'egypt', 
@user_id1 output, @password1 output
print @user_id1
print @password1

Declare @user_id1 int 
Declare @password1 varchar(10) 
EXEC UserRegister  'Company','dina', ' marezmagdy@gmail.com' ,'Dina' ,'Adel' , '11-13-2003' , '3.2', '2' , '13 share3 maadi', 'FC1' , 'MC1', 'COMP1' , 'NAME', 'nourhelmy@gmail.com' , '01284090290', 'egypt', 
@user_id1 output, @password1 output
print @user_id1
print @password1

Declare @user_id1 int 
Declare @password1 varchar(10) 
EXEC UserRegister  'Company','dina', ' marezmagdy@gmail.com' ,'Eta' ,'Adel' , '11-13-2003' , '3.2', '2' , '13 share3 maadi', 'FC1' , 'MC1', 'COMP1' , 'NAME', 'nourhelmy@gmail.com' , '01284090290', 'egypt', 
@user_id1 output, @password1 output
print @user_id1
print @password1


 Exec CreateMeeting 1,'05:30:00','07:30:00','3/10/2004','rehab'
 Exec SpecifyThesisDeadline '3/10/2004'
 EXEC ViewBachelorProjects 'Academic', 1
 Exec ViewProfile 1
 Exec ViewMyThesis 38,'title'

 -----------------
 --Create:

  --exec AddEmployee 16,'marezmagdy@gmail.com' , 'dina', '01284090290' , 'field' ,  

 Exec CreateMeeting 123, 14,'05:30:00','07:30:00','3/10/2004','rehab'
 Exec CreateMeeting 000, 14,'05:30:00','07:30:00','3/10/2004','rehab'
 Exec CreateMeeting 222, 14,'05:30:00','07:30:00','3/10/2004','rehab'
 Exec CreateMeeting 1311, 14,'05:30:00','07:30:00','3/10/2004','rehab'
 exec CompanyCreateLocalProject 16, 'PC8','title','desc','MC7' --idk
 exec CompanyCreateLocalProject 25, 'PC11','title','desc','MC10' 
 Exec LecturerAddToDo 123, 'To do list2'
 exec LecturerCreateLocalProject 14, 'PC5','title', 'Project Description:', 'MC6'
 Exec LecCreatePR 13, 15, '12-12-2022', 'PR Content1'
 Exec TACreatePr 19, 17, '12-12-2022', 'PR Content2'
 Exec TAAddToDo 222, 'To do list3'
 exec StudentAddToDo 1311, 'to do list 4'
 exec EmployeeCreatePR 01, 22, '12-12-2022', 'PR Content3'
 ------------------------------------
 --View
 Exec ViewBachelorProjects 'Academic' , 7
 exec ViewMyThesis 24, 'title'
 exec ViewMyDefense 23
 exec ViewBachelorProjects 'Industrial', 23
 exec ViewMyProgressReports 23, '12-12-2022'
 exec ViewNotBookedMeetings 23
 exec ViewMeeting 222 , 'todolist'

--------
-- MakePreferencesLocalProject
Exec MakePreferencesLocalProject  1,24,'PC8' --error
---- 
exec SubmitMyThesis 24, 'thesisTitle1', 'Pdf1'
---
--update
 exec UpdateMyDefense 23, 'defense content'

 -- 
 --book meeting
 exec BookMeeting 23, 222
