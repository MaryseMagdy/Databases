
GO
CREATE PROC UserRegister
@usertype varchar(20), @userName varchar(20), @email varchar(50), @first_name varchar(20),@last_name varchar(20), 
@birth_date datetime, @GPA decimal(3,2), @semester int, @address varchar(100), 
@faculty_code varchar(10), @major_code varchar(10), @company_name varchar(20),
@representative_name varchar(20), @representative_email varchar(50), 
@phone_number varchar(20),@country_of_residence varchar(20), @user_id int OUTPUT, @password varchar(10) OUTPUT
AS
INSERT INTO Users(Username, Password, Email, Role, phone_number) VALUES(@userName, @password, @email, @usertype, @phone_number) 
SELECT @user_id = userid from Users where @userName = Username
set @password ='loveULeqaa'

IF @usertype = 'Lecturer'
INSERT INTO Lecturer(Lecturer_id) VALUES(@user_id)
    
ELSE IF @usertype = 'Company'
INSERT INTO Company(Company_id, Name, Representative_name, Representative_Email, Location) VALUES(@user_id, @userName, @representative_name, @representative_email, @address)

ELSE IF @usertype = 'Student'
INSERT INTO Student(sid, first_name, last_name, major_code, Date_Of_Birth, address, semester) VALUES(@user_id, @first_name, @last_name, @major_code, @birth_date, @address, @semester)

ELSE IF @usertype = 'Teaching_assistants'
INSERT INTO Teaching_assistants(TA_id) VALUES(@user_id)

ELSE IF @usertype = 'External_examiners'
INSERT INTO External_examiners(EE_id) VALUES(@user_id)

ELSE IF @usertype = 'Coordinator'
INSERT INTO Coordinator(coordinator_id) VALUES(@user_id)


-------------------------------------------------------
/*USER LOG IN*/
DROP PROC UserLogin
go
create proc UserLogin
@email varchar(50), @password varchar (10),
@success bit OUTPUT , @user_id int OUTPUT
AS

begin
if ( NOT EXISTS(  
select userid from Users
where email = @email
AND
password = @password))
begin
set @user_id = '-1'
set @success = '0'
end
else  
select @user_id = userid from Users
where email = @email
AND
password = @password
set @success = '1'
end
------------------------------------

/*VIEW PROFILE*/
DROP PROC ViewProfile
GO
create proc ViewProfile
@user_id int
AS
BEGIN
DECLARE @userid int 
Select *
From Users
where userid = @userid
Select *
From Student
where sid = @userid
Select *
From Company
where company_id = @userid
Select *
From lecturer
where Lecturer_id = @userid
Select *
From Teaching_assistants
where TA_id = @userid
Select *
From External_examiners 
where EE_id = @userid
Select *
from Coordinator
where coordinator_id=@user_id
END
------------------------
--3)c) exec done
GO
create proc ViewBachelorProjects
@ProjectType varchar(20), @User_id int
AS

IF (@ProjectType IS NULL AND @User_id is NOT null)
begin
Select A.*
From Academic A
where @User_id = L_id OR @User_id = TA_id OR @User_id = EE_id

Select I.*
From Industrial I
where @User_id = L_id OR @User_id = C_id OR @User_id = E_id
  END
  ELSE

IF (@ProjectType IS NULL and @User_id IS NULL)
  BEGIN
  SELECT *
  from Bachelor_project
  END

IF (@ProjectType IS not  NULL)
  IF ( @ProjectType = 'Academic') begin
  Select A.*
  From Academic A INNER JOIN Bachelor_project BP ON A.Academic_code = BP.code
  END
  
  IF (@ProjectType = 'Industrial') begin
  Select I.*
  From Industrial I INNER JOIN Bachelor_project BP ON I.Industrial_code = BP.code
  END
-------------------------------
/*MakePreferencesLocalProject*/ 
--exec done 1 error

GO
CREATE PROC  MakePreferencesLocalProject
@sid int,  @preference_number int , @bachelor_code varchar(10)
AS 
Insert into StudentPreferences (PreferenceNumber , sid , Pcode)values(@preference_number, @sid , @bachelor_code)


-----------------------------
/* ViewMyThesis  */
--exec done
DROP PROC ViewMyThesis
GO 
CREATE PROC ViewMyThesis 
@sid int, @title varchar(50)
AS

declare @AssignedPcode varchar(10)
Select s.Assigned_Project_code from Student s  where sid = @sid

if(Exists(
select *  from Academic A  where A.Academic_code = @AssignedPcode
))

declare @EEGrade int
select GAT.EE_grade from GradeAcademicThesis GAT  where sid = @sid

declare @LecturerGrade int
select GAT.Lecturer_grade from GradeAcademicThesis GAT where sid = @sid

declare @Total_grade int 
Select t.Total_grade from Thesis t where t.sid = @sid and t.Title = @title

if(Exists ( Select GAT.EE_grade, GAT.Lecturer_grade
From GradeAcademicThesis GAT 
where GAT.EE_grade is not null and GAT.Lecturer_grade is not null))
update Thesis 
set Total_grade = (select (GAT.EE_grade + GAT.Lecturer_grade)/2
from GradeAcademicThesis GAT 
where GAT.Title = @title AND GAT.sid = @sid)



if(Exists(
select *  from Industrial I  where I.Industrial_code = @AssignedPcode
))

declare @EmpGrade int
select GIT.Employee_grade from GradeIndustrialThesis GIT  where GIT.sid = @sid

declare @CoGrade int
select GIT.Company_grade from GradeIndustrialThesis GIT  where GIT.sid = @sid

declare @Total_grade2 int 
Select t.Total_grade from Thesis t where t.sid = @sid and t.Title = @title

if(Exists ( Select GIT.Company_grade , GIT.Employee_grade
From GradeIndustrialThesis GIT 
where GIT.Company_grade is not null and GIT.Employee_grade is not null))
update Thesis 
set Total_grade = (select (GIT.Company_grade + GIT.Employee_grade)/2
from GradeIndustrialThesis GIT 
where GIT.Title = @title AND GIT.sid = @sid)

Select *
from Thesis where sid = @sid and Title = @title
------------------------------
/*SubmitMyThesis*/
--exec done
Go
CREATE proc SubmitMyThesis
@sid int, @title varchar(50), @PDF_Document varchar(1000)
AS
select PDF_Doc
FROM Thesis
where sid = @sid
and
Title = @title

update Thesis
set PDF_Doc = @PDF_Document,
Total_grade = (select (GIT.Company_grade + GIT.Employee_grade)/2
from GradeIndustrialThesis GIT 
where GIT.Title = @title AND GIT.sid = @sid)
insert into THESIS (sid, Title, PDF_doc) values (@sid , @title, @PDF_Document)
----------------------------------
/* ViewMyDefense  */
--exec done
GO 
CREATE PROC ViewMyDefense 
@sid int
AS
declare @AssignedPcode varchar(10)
Select s.Assigned_Project_code from Student s  where sid = @sid

if(Exists(
select *  from Academic A  where A.Academic_code = @AssignedPcode
))

declare @EEGrade int
select GAD.EE_grade from GradeAcademicDefense GAD  where sid = @sid

declare @LecturerGrade int
select GAD.Lecturer_grade from GradeAcademicDefense GAD where sid = @sid

declare @Total_grade int 
Select d.Total_grade from Defense d where d.sid = @sid 

if(Exists ( Select GAD.EE_grade, GAD.Lecturer_grade
From GradeAcademicDefense GAD 
where GAD.EE_grade is not null and GAD.Lecturer_grade is not null))
update Defense 
set Total_grade = (select (GAD.EE_grade + GAD.Lecturer_grade)/2
from GradeAcademicDefense GAD 
where GAD.sid = @sid)



if(Exists(
select *  from Industrial I  where I.Industrial_code = @AssignedPcode
))

declare @EmpGrade int
select GID.Employee_grade from GradeIndustrialDefense GID  where GID.sid = @sid

declare @CoGrade int
select GID.Company_grade from GradeIndustrialDefense GID  where GID.sid = @sid

declare @Total_grade2 int 
Select D.Total_grade from Defense D where D.sid = @sid

if(Exists ( Select GID.Company_grade , GID.Employee_grade
From GradeIndustrialDefense GID 
where GID.Company_grade is not null and GID.Employee_grade is not null))
update Defense 
set Total_grade = (select (GID.Company_grade + GID.Employee_grade)/2
from GradeIndustrialDefense GID 
where GID.sid = @sid)

Select *
from Defense where sid = @sid 
-------------------------------------
--exec done
GO
CREATE PROC UpdateMyDefense
@sid int, @defense_content varchar(1000)
AS
Select *
from Defense
where sid = @sid
and
Content = @defense_content
update Defense
set Content = @defense_content 

update Defense 
set Total_grade = (select (GID.Company_grade + GID.Employee_grade)/2
from GradeIndustrialDefense GID 
where GID.sid = @sid)

update Defense 
set Total_grade = (select (GAD.EE_grade + GAD.Lecturer_grade)/2
from GradeAcademicDefense GAD 
where GAD.sid = @sid)


--------------------------------------
--exec done
GO
CREATE PROC ViewMyBachelorProjectGrade
@sid int , @BachelorGrade decimal(4,2) OUTPUT
AS


declare @ThesisGrade int
select t.Total_grade from Thesis t  where t.sid = @sid

declare @DefenseGrade int
select d.Total_grade from Defense d  where d.sid = @sid

declare @commulativeProgressReport int
select pr.ComulativeProgressReportGrade from ProgressReport pr  where pr.sid = @sid

declare @BTotal_grade int 
Select s.TotalBachelorGrade from Student s where s.sid = @sid 

if(Exists ( Select Total_grade
From  Thesis 
where Total_grade is not null
))

if(Exists ( Select Total_grade
From  Defense 
where Total_grade is not null
))

if(Exists ( Select ComulativeProgressReportGrade
From  ProgressReport 
where ComulativeProgressReportGrade is not null
))

update Student 
set @BTotal_grade = (select (0.3* @ThesisGrade+0.3*@DefenseGrade+
0.4*@commulativeProgressReport)
from Student s  
where s.sid = @sid)
------------------------------------------
--3)d)
--exec done
GO
CREATE PROC ViewMyProgressReports
@sid int,
@date DATETIME
AS 
IF @date IS not NULL
BEGIN
	SELECT*
	FROM ProgressReport PR
	WHERE @sid =sid and
	@date = Date
	ORDER BY Date 
	
END
	else if @date is  null 
BEGIN
SELECT*
From ProgressReport 
order by Date
END

---------------------------------
---3)h)
--exec done
GO
CREATE PROC ViewNotBookedMeetings
@sid int 
AS 
DECLARE @ProjCode int
SET @ProjCode = (SELECT Assigned_Project_code FROM Student WHERE sid = @sid)
DECLARE @L_id int
SET @L_id = (SELECT L_id FROM Academic WHERE Academic_code = @ProjCode)

SELECT * 
FROM Meeting M INNER JOIN
MeetingAttendants MA
ON M.Meeting_id = MA.Meeting_id WHERE L_id = @L_id AND Attendant_id NOT IN (SELECT sid FROM Student)


--------------------------
-- exec done
GO
CREATE PROC ViewMeeting
@meeting_id int,
@to_do_list varchar(200)

AS
	SELECT*
	from Meeting M
	Where @meeting_id = meeting_id

-----------------------------------------
--3)K)
--exec done
GO
CREATE PROC StudentAddToDo
@meeting_id int, @to_do_list varchar(200)
AS
begin
Select *
From MeetingToDoList
where Meeting_ID = @meeting_id
INSERT INTO MeetingToDoList (Meeting_id , ToDoList) VALUES(@meeting_id,  @to_do_list)
End
------------------------------------------
--3)I)
-- exec donee
GO
CREATE PROC BookMeeting
@sid int,@meeting_id int
AS
begin

select Meeting_id, L_id
FROM meeting
where meeting_id=@meeting_id

UPDATE MeetingAttendants
set Meeting_id = @meeting_id
WHERE Attendant_id = @sid
INSERT INTO MeetingAttendants(Meeting_id , Attendant_id) VALUES(@meeting_id,@sid)
END

------------------------------------
--4)A) okkk
-- NOT YET ATTENTION !!!!!!!!!!!!!!!!!!!!!!!!!!!
GO
CREATE PROC AddEmployee
@Company_ID int, @email varchar(50), @name varchar(20), @phone_number varchar(20),
@field varchar(25),  @StaffID int OUTPUT , @ComapnyID1 int OUTPUT, @password varchar(10) OUTPUT
AS
Select userid
from Users
where userid = @StaffID
INSERT INTO Employees (staff_id, company_id, field, phone_number, email ) values (@StaffID, @Company_ID, @Field,@phone_number ,@email)

-----------------
--4)B) OKKK-- exec done 
GO 
 CREATE PROC CompanyCreateLocalProject
 @company_id int, @proj_code varchar(10), @title varchar(50), @description varchar(200), @major_code varchar(10)
 AS 
 INSERT INTO Bachelor_project (code, name, description)  VALUES (@proj_code , @title, @description)
 INSERT INTO Industrial (C_id , Industrial_code ) VALUES ( @company_id,@proj_code )
 INSERT INTO MajorHasBachelorProject (Major_code , Project_code )values (@major_code , @proj_code)
-----------------------------------
 --4)c) okkk
 GO
CREATE PROC AssignEmployee
@bachelor_code varchar(10), @Company_id int, @staff_id int OUTPUT
 AS

IF EXISTS(SELECT company_id FROM Company WHERE Company.company_id = @Company_id)
BEGIN
UPDATE Industrial 
set E_id = @staff_id
WHERE Industrial_code = @bachelor_code
END
-------------------------------
--4)d) okkk
GO
CREATE PROC CompanyGradeThesis
@Company_id int, @sid int, @thesis_title varchar(50), @Company_grade Decimal(4,2)
AS
begin

Select*
FROM Thesis
Where title =  @thesis_title AND sid = @sid 

UPDATE GradeIndustrialThesis
set C_id = @Company_id,   Company_grade = @Company_grade
WHERE
sid=@sid AND Title=@thesis_title AND C_id=@Company_id AND Company_grade=@Company_grade

INSERT INTO GradeIndustrialThesis (sid, Title, Company_grade , C_id) VALUES(@sid, @thesis_title, @Company_grade, @Company_id)

End
--------------------------------
--4)E) okkk

GO
CREATE PROC CompanyGradeDefense
@Company_id int, @sid int, @defense_location varchar(5), @Company_grade Decimal(4,2)
AS
begin

Select*
FROM Defense
Where Location =  @defense_location AND sid = @sid 

UPDATE GradeIndustrialDefense
set C_id = @Company_id,   Company_grade = @Company_grade
WHERE
sid=@sid AND Location=@defense_location AND C_id=@Company_id AND Company_grade=@Company_grade

INSERT INTO gradeGradeIndustrialDefense(sid, Location, Company_grade , C_id) VALUES(@sid, @defense_location, @Company_grade, @Company_id)

End
----------------------------------
--4)f) okk
GO
CREATE PROC CompanyGradePR
@Company_id int, @sid int, @date datetime, @Company_grade Decimal(4,2)
AS
begin
Select*
FROM GradeIndustrialPR
Where C_id = @company_id AND sid=@sid AND Date=@date AND company_grade=@company_grade

UPDATE GradeIndustrialPR
set C_id = @Company_id, Company_grade = @Company_grade

WHERE sid=@sid AND Date=@date
AND C_id=@Company_id 
AND Company_grade=@Company_grade
INSERT INTO GradeIndustrialPR (C_id, sid, Date, Company_grade) VALUES(@Company_id,@sid,@date,@Company_grade)
End
----------------------------------
---five---LECTURER
---5)a) okkk --exec done 
GO
CREATE PROC LecturerCreateLocalProject
@Lecturer_id int, @proj_code varchar(10), @title varchar(50), @description varchar(200),
@major_code varchar(10)
AS
IF ((SELECT Lecturer_id FROM lecturer WHERE Lecturer_id = @Lecturer_id) = @Lecturer_id)
	BEGIN
	INSERT INTO Bachelor_project(code, name, description) VALUES(@proj_code, @title, @description)
	INSERT INTO Academic(L_id, Academic_code ) VALUES ( @Lecturer_id,@proj_code )
	INSERt INTO MajorHasBachelorProject(Major_code, Project_code) VALUES(@major_code, @proj_code)
	END
ELSE
	PRINT 'Lectuer_Id not found'

--------------------------------
--5)B) okkkk
GO
CREATE PROC SpecifyThesisDeadline
@deadline datetime
AS
begin
select Deadline
FROM THESIS
where Deadline=@deadline
update thesis
set Deadline=@deadline
END

------------------------
--5)c)okkkk -- exec done
GO
CREATE PROC CreateMeeting
@meetingid int , @Lecturer_id int, @start_time time, @end_time time, @date datetime, @meeting_point
varchar(5)
AS
begin

SELECT *
FROM Meeting
WHERE L_id=@Lecturer_id  AND Stime=@start_time AND Etime=@end_time AND date=@date AND meeting_point=@meeting_point

update Meeting
set STime=@start_time , ETime=@end_time ,Meeting_Point=@meeting_point
where STime=@start_time AND Etime=@end_time AND date=@date AND meeting_point=@meeting_point

Insert into Meeting (Meeting_id,L_id, Stime, Etime, date, Meeting_point) VALUES (@meetingid, @Lecturer_id , @start_time, @end_time , @date , @meeting_point)
END
--------------------------------------------------
---5)D)okkk --exec done
GO
CREATE PROC LecturerAddToDo
@meeting_id int, @to_do_list varchar(200)
AS
begin

Select *
From MeetingToDoList
where Meeting_ID=@meeting_id
INSERT INTO MeetingToDoList (ToDoList, Meeting_id)VALUES(@to_do_list, @meeting_id)

End
-----------------------------------------
--5)E) okkk
GO
CREATE PROC ViewMeetingLecturer
@Lecturer_id int, @meeting_id int
AS
if(@meeting_id is not null)
begin
Select *
From Meeting
where Meeting_id = @meeting_id
and
L_id = @Lecturer_id
ORDER BY date
end

else 
Select *
From Meeting
where Meeting_id = @meeting_id
order by date
-----------------------------------------
---5)f) okkk
GO 
CREATE PROC ViewEE
as 
select * from External_examiners where External_examiners.EE_id  NOT IN  (select EE_id from LecturerReccomendEE)

-------------------
--5)G) okkk
GO
CREATE PROC RecommendEE
@Lecturer_id int, @proj_code varchar(10), @EE_id int
AS
Select L_id,EE_id
From Academic
where L_id=@Lecturer_id AND EE_id=@EE_id
UPDATE LecturerRecommendEE
set L_id=@Lecturer_id ,
PCode=@proj_code, 
EE_id=@EE_id
WHERE L_id=@Lecturer_id AND PCode=@proj_code AND EE_id=@EE_id
INSERT INTO LecturerRecommendEE (L_id , Pcode, EE_id) VALUES  (@Lecturer_id, @proj_code, @EE_id)


------------------------------------
---5)H) okkk
GO
CREATE PROC SuperviseIndustrial
 @Lecturer_id int, @proj_code varchar(10)
  AS
  begin
Select *
From Industrial
where L_id=@Lecturer_id
 INSERT INTO Industrial (L_id, Industrial_code) VALUES(@Lecturer_id, @proj_code)
  End
---------------------------------------------------
--5)I) okkkk
GO
CREATE PROC LecGradeThesis
@Lecturer_id int, @sid int, @thesis_title varchar(50), @Lecturer_grade Decimal(4,2)
AS
Select*
FROM GradeAcademicThesis
Where L_id = @Lecturer_id AND sid=@sid AND
Title=@thesis_title AND Lecturer_grade=@Lecturer_grade

UPDATE GradeAcademicThesis
set L_id=@Lecturer_id,Lecturer_grade=@Lecturer_grade
WHERE sid=@sid AND Title=@thesis_title AND L_id=@Lecturer_id AND Lecturer_grade=@Lecturer_grade
INSERT INTO GradeAcademicThesis (L_id, sid, Title, Lecturer_grade)VALUES(@Lecturer_id,@sid,@thesis_title,@Lecturer_grade)



----------------------------------
--5)J) okkkk
GO
CREATE PROC LecGradedefense
@Lecturer_id int, @sid int, @defense_location varchar(5), @Lecturer_grade int
AS
 begin
Select*
FROM GradeAcademicDefense
Where L_id = @Lecturer_id AND sid=@sid AND
Location = @defense_location AND Lecturer_grade=@Lecturer_grade

UPDATE GradeAcademicDefense
set L_id = @Lecturer_id,
Lecturer_grade = @Lecturer_grade
WHERE sid = @sid AND Location = @defense_location
INSERT INTO GradeAcademicDefense (L_id, sid, Location, LECTURER_grade ) VAlues (@Lecturer_id,@sid,@defense_location,@Lecturer_grade)
End
--------------------------------------------
--5)K) OKK --exec done
GO
CREATE PROC LecCreatePR
@Lecturer_id int, @sid int, @date datetime, @content varchar(1000) 
AS
INSERT INTO ProgressReport(sid,Date,Content,UpdatingUser_id) VALUES (@sid,@date,@content,@lecturer_id)
Print 'Progress Report is created'
------------------------------------------------------
--5)L) okkkk
GO
CREATE PROC LecGradePR
@Lecturer_id int, @sid int, @date datetime, @lecturer_grade decimal(4,2)
AS
Select*
FROM GradeAcademicPR
Where L_id = @Lecturer_id AND sid=@sid AND
Date=@date AND L_id=@lecturer_grade

UPDATE GradeAcademicPR
set L_id = @Lecturer_id,
Lecturer_grade = @Lecturer_grade
WHERE sid=@sid AND Date=@date
INSERT INTO GradeAcademicPR(L_id, sid, Date, Lecturer_grade) VALUES(@Lecturer_id,@sid,@date,@lecturer_grade)

-----------------------------------
--6)a) --exec done
GO
CREATE PROC TACreatePR
@TA_id int, @sid int, @date DATETIME, @content varchar(1000)
AS 
Insert into ProgressReport (sid, Date , Content, updatingUser_id) VALUES (@sid , @date, @content , @TA_id)
Print 'Progress Report is created by TA'
---------------------------------------
--6)B) exec done
GO 
CREATE PROC TAAddToDo 
@meeting_id int, @to_do_list varchar(200)
AS
BEGIN
select *
from MeetingToDoList
where Meeting_id = @meeting_id AND ToDoList = @to_do_list

update MeetingToDoList
set Meeting_id = @meeting_id , ToDoList = @to_do_list
where Meeting_id = @meeting_id and ToDoList = @to_do_list

Insert into MeetingToDoList (Meeting_id , ToDoList) Values (@meeting_id , @to_do_list)
Print ' TA added to the meeting to do list'
END
--------------------------------
--7A)
GO
CREATE PROC EEGradeThesis
@EE_id int, @sid int, @thesis_title varchar(50), @EE_grade DECIMAL(4,2)
AS

UPDATE GradeAcademicThesis
Set EE_id = @EE_id, EE_grade = @EE_grade
Where sid = @sid AND Title = @thesis_title

INSERT INTO GradeAcademicThesis(sid , Title, EE_grade , EE_id) VALUES (@sid, @thesis_title, @EE_grade, @EE_id)
------------------------------
--7)B)
GO
CREATE PROC EEGradedefense 
@EE_id int, @sid int, @defense_location varchar(5), @EE_grade DECIMAL(4,2)
AS

UPDATE GradeAcademicDefense
SET  EE_id =@EE_id , EE_grade = @EE_grade
WHERE sid = @sid AND Location = @defense_location  
INSERT INTO GradeAcademicDefense (sid , Location, EE_grade , EE_id) VALUES (@sid, @defense_location, @EE_grade, @EE_id)
  ----------------
  --8)A)----okkkk
GO
CREATE PROC ViewUsers
@User_type varchar(20), @User_id int 
AS
BEGIN 

IF @User_type is NULL begin
Select *
From Users
end

IF @User_id IS NOT NULL Begin
SELECT @User_id
From Users
where userid = @User_id
end

IF  @User_type = 'Student' BEGIN
Select *
From Student 
where sid = @User_id 
end

IF  @User_type = 'Lecturer' BEGIN
Select *
From Lecturer
where Lecturer_id = @User_id 
END

IF  @User_type = 'Teaching_assistants' BEGIN
Select *
From Teaching_assistants
where TA_id = @User_id
END


IF  @User_type = 'Company' BEGIN
Select *
From Company
where company_id = @User_id
END

IF  @User_type = 'External_examiners' BEGIN
Select *
From External_examiners
where EE_id = @User_id
END

IF  @User_type = 'Coordinator' BEGIN
Select *
From Coordinator
where coordinator_id = @User_id
END



END
--------------------------
--8)b) NOT YET ---- assign the students to the project
  GO
  CREATE PROC AssignAllStudentsToLocalProject
  AS 
  Select*
  from StudentPreferences right join  Bachelor_Project
  on StudentPreferences.Pcode =Bachelor_Project.code 
  Order by StudentPreferences.PreferenceNumber , Student.GPACompanyGradeThesis
  
--------------------------

---8)C) OKKK
GO
CREATE PROC AssignTAs
@coordinator_id int, @TA_id int, @proj_code varchar(10)
AS
IF EXISTS(SELECT Coordinator_id FROM Coordinator WHERE Coordinator.Coordinator_id = @coordinator_id)
BEGIN
    UPDATE Academic 
    SET TA_id = @TA_id
    WHERE Academic_code = @proj_code
END
----------------------------
--8)D) OKKK
GO
CREATE PROC ViewRecommendation
@lecture_id int
AS
SELECT L_id , EE_id
from LecturerReccomendEE
order by l_id ASC

------------------------------
--8)E) OKKK
GO
 CREATE PROC AssignEE
 @coordinator_id int, @EE_id int, @proj_code varchar(10)
 AS
IF EXISTS( SELECT @coordinator_id  From Coordinator WHERE Coordinator.coordinator_id = @coordinator_id)
 UPDATE Academic 
 set EE_id = @EE_id
 WHERE  Academic_code=@proj_code
-------------------------------------

--8)F) 
GO
CREATE PROC ScheduleDefense
@sid int, @date datetime, @time time, @location varchar(5)
AS
Insert into Defense(date , Time , Location) VALUES (@date, @time, @location)



---------------------

---nine--EMPLOYEE
 ---9)A) okkk
GO
CREATE PROC EmployeeGradeThesis
@Employee_id int, @sid int, @thesis_title varchar(50), @Employee_grade Decimal(4,2)
AS
UPDATE GradeIndustrialThesis
set E_id =@Employee_id ,Employee_grade=@Employee_grade
WHERE sid=@sid AND Title=@thesis_title
INSERT INTO GradeIndustrialThesis(E_id , sid, Title, Employee_grade) VALUES(@Employee_id,@sid,@thesis_title,@Employee_grade)

 ---------------------------------
 ---9)B) okkk
GO
CREATE PROC EmployeeGradedefense
@Employee_id int, @sid int, @defense_location varchar(5), @Employee_grade Decimal(4,2)
AS
UPDATE GradeIndustrialDefense
set E_id=@Employee_id ,Employee_grade=@Employee_grade
WHERE sid=@sid AND location=@defense_location
INSERT INTO GradeIndustrialDefense(E_id, sid, Location, Employee_grade) VALUES(@Employee_id,@sid,@defense_location,@Employee_grade)


 -----------------------------------
 ---9)C) okkk exec doneee
GO
CREATE PROC EmployeeCreatePR
@Employee_id int, @sid int, @date datetime, @content varchar(1000)
AS
INSERT INTO ProgressReport(sid,Date,Content,UpdatingUser_id) VALUES (@sid,@date,@content,@Employee_id)
Print 'Progress Report is created by employee'
--------------------------