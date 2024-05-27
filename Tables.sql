
CREATE Database PortalSure1;

CREATE TABLE Users(
userid INT Identity PRIMARY KEY,
USERNAME VARCHAR(20),
PASSWORD VARCHAR(10),
EMAIL VARCHAR(50),
ROLE VARCHAR(20),
PHONE_NUMBER VARCHAR(20)
);

CREATE Table lecturer(
Lecturer_id INT PRIMARY KEY ,
Schedule varchar(20),
foreign key (lecturer_id) references users  on delete cascade on update cascade,
);

CREATE Table lecturerFields(
Lecturer_id int PRIMARY KEY ,
field varchar(25),
foreign key (Lecturer_id) references lecturer  on delete cascade on update cascade,
);

CREATE TABLE Faculty(
faculty_code varchar(10) PRIMARY KEY ,
name varchar(20),
dean int,
foreign key(dean) REFERENCES lecturer(Lecturer_id) on delete cascade on update cascade,
);

CREATE Table Teaching_assistants(
TA_id int Primary key ,
Schedule varchar(20),
foreign key (TA_id) references users on delete cascade on update cascade,
);


CREATE Table External_examiners(
EE_id int PRIMARY KEY ,
schedule varchar(20),
foreign key (EE_id) references users on delete cascade on update cascade,
);

CREATE Table Coordinator(
coordinator_id int PRIMARY KEY ,
foreign key (coordinator_id) references users on delete cascade on update cascade

);


CREATE Table Company(
company_id int PRIMARY KEY ,
name varchar(20),
representative_name varchar(20),
representative_email varchar(50),
location varchar(20),
foreign key (company_id) references users on delete cascade on update cascade,
);


CREATE TABLE Employee(
staff_id int  ,
Company_id int  ,
primary key (staff_id, Company_id),
field varchar(25),
USERNAME VARCHAR(20),
EMAIL VARCHAR(50),
ROLE VARCHAR(20),
PHONE_NUMBER VARCHAR(20)
foreign key (Company_id)  references Company on delete cascade on update cascade
);


CREATE TABLE Bachelor_project(
code varchar(10) PRIMARY KEY,
name varchar(20),
submitted_material varchar(20),
description varchar(200)
);

CREATE TABLE BachelorSubmittedMaterials(
Code varchar(10) PRIMARY KEY,
Material varchar(20),
foreign key(Code) REFERENCES Bachelor_project on delete cascade on update cascade,
);


CREATE TABLE Major(
major_code varchar(10) PRIMARY KEY,
major_name varchar(20),
Faculty_code varchar(10),
foreign key (Faculty_code) REFERENCES Faculty(faculty_code) on delete cascade on update cascade,
);



CREATE TABLE Meeting(
Meeting_id int PRIMARY KEY ,
Stime Time,
Etime Time,
duration time,
date DATETIME,
Meeting_point varchar(5),
L_id int ,
foreign key(L_id) REFERENCES Lecturer on delete cascade on update cascade,
);

CREATE table MeetingToDoList(
Meeting_id int PRIMARY KEY ,
ToDoList varchar(200),
foreign key(Meeting_id) REFERENCES Meeting on delete cascade on update cascade,
);



CREATE table MeetingAttendants(
Meeting_id int ,
Attendant_id int, 
primary key (Meeting_id, Attendant_id),
foreign key(Meeting_id) REFERENCES Meeting on delete cascade on update cascade,

);


CREATE TABLE MajorHasBachelorProject(
Major_code varchar(10)  ,
Project_code varchar(10)  ,
PRIMARY KEY(Major_code, Project_code),
foreign key(Major_code) REFERENCES Major on delete cascade on update cascade,
foreign key(Project_code) REFERENCES bachelor_project on delete cascade on update cascade,
);


CREATE Table Student(
sid INT Primary key ,
first_name varchar(20),
last_name varchar(20),
date_of_birth datetime ,
GPA decimal(3,2),
semester int,
address varchar(100),
age int,
TotalBachelorGrade int,
major_code varchar(10),
Assigned_Project_code varchar(10),
foreign key(major_code) REFERENCES Major on delete no action on update no action,
foreign key(Assigned_Project_code) REFERENCES bachelor_project  on delete no action  on update no action,
foreign key (sid) references users on delete  no action on update no action
);


CREATE TABLE Industrial(
Industrial_code varchar(10) PRIMARY KEY  ,
C_id int,
L_id int,
E_id int,
foreign key(Industrial_code) REFERENCES Bachelor_project on delete  no action on update no action,
foreign key(L_id) REFERENCES Lecturer  on delete  no action on update no action,
foreign key(E_id, c_id) REFERENCES Employee(staff_id , company_id) on delete  no action on update no action,
);

CREATE TABLE Academic(
Academic_code varchar(10) PRIMARY KEY  ,
L_id int,
TA_id int,
EE_id int,
foreign key(Academic_code) REFERENCES Bachelor_project on delete  no action on update no action,
foreign key(L_id) REFERENCES lecturer on delete  no action on update no action,
foreign key(TA_id) REFERENCES Teaching_assistants on delete  no action on update no action,
foreign key(EE_id) REFERENCES External_Examiners on delete  no action on update no action,
);




CREATE TABLE Thesis(
sid int  ,
Title varchar(50) ,
PRIMARY KEY(sid,title),
Deadline DateTime,
PDF_Doc Varchar(1000),
Total_grade int,
foreign key(sid) REFERENCES Student on delete cascade on update cascade,
);


CREATE TABLE Defense(
sid  int ,
Location varchar(20) ,
PRIMARY KEY(sid, Location),
Content varchar(1000),
Time Time,
Date DateTime,
Total_grade int,
foreign key(sid) REFERENCES Student on delete cascade on update cascade,
);


CREATE TABLE ProgressReport(
sid  int  ,
Date DateTime ,
primary key (sid,Date), 
Content varchar(1000),
grade int,
ComulativeProgressReportGrade int,
updatingUser_id int,
foreign key(sid) REFERENCES Student on delete no action on update no action,
foreign key(updatingUser_id) REFERENCES users on delete no action on update no action,
);

CREATE TABLE GradeIndustrialPR(
sid int ,
Date DateTime,
PRIMARY KEY(sid, Date),
Company_grade int,
Lecturer_grade int,
C_id int,
foreign key(C_id) REFERENCES Company on delete cascade on update cascade,
foreign key(sid, date) REFERENCES ProgressReport on delete cascade on update cascade,
);

CREATE TABLE GradeAcademicPR(
sid int  ,
Date DateTime,
PRIMARY KEY(sid,DATE),
Lecturer_grade int,
L_id int,
foreign key(L_id) REFERENCES Lecturer on delete cascade on update cascade,
foreign key(sid, date) REFERENCES ProgressReport on delete cascade on update cascade,
);

CREATE TABLE StudentPreferences(
PreferenceNumber int,
sid INT PRIMARY KEY ,
Pcode varchar(10) unique,
foreign key(sid) REFERENCES Student on delete cascade on update cascade,
foreign key(PCode) REFERENCES bachelor_project on delete cascade on update cascade,
);



CREATE TABLE GradeAcademicThesis(
sid int ,
Title varchar(50),
PRIMARY KEY(sid, title),
EE_grade int,
Lecturer_grade int,
L_id int,
EE_id int,
foreign key(L_id) REFERENCES Lecturer on delete no action on update no action,
foreign key(EE_id) REFERENCES External_Examiners on delete no action on update no action,
foreign key(sid, title) REFERENCES Thesis on delete no action on update no action,

);


CREATE TABLE GradeIndustrialThesis(
sid int ,
Title varchar(50)  ,
PRIMARY KEY(sid, Title),
Company_grade int,
Employee_grade int,
C_id int,
E_id int,
foreign key( E_id, C_id) REFERENCES Employee on delete no action on update no action,
foreign key(sid, title) REFERENCES Thesis on delete no action on update no action,
);

CREATE TABLE GradeAcademicDefense(
sid int, 
Location varchar(20),
PRIMARY KEY (sid, Location),
EE_grade int,
LECTURER_grade int,
L_id int,
EE_id int,
foreign key(L_id) REFERENCES Lecturer on delete no action on update no action,
foreign key(EE_id) REFERENCES External_Examiners on delete no action on update no action,
foreign key( sid, Location) REFERENCES Defense on delete no action on update no action,
);

CREATE TABLE GradeIndustrialDefense(
sid int,
Location varchar(20),
PRIMARY KEY (sid, Location),
Company_grade int,
Employee_grade int,
C_id int,
E_id int,
foreign key(C_id) REFERENCES Company on delete no action on update no action,
foreign key(E_id, C_id) REFERENCES Employee on delete no action on update no action,
foreign key(sid, Location) REFERENCES Defense on delete no action on update no action,

);

CREATE TABLE LecturerReccomendEE(
EE_id int ,
Pcode varchar(10) ,
PRIMARY KEY(EE_id, Pcode),
L_id int,
foreign key(L_id) REFERENCES Lecturer on delete  no action on update no action,
foreign key(EE_id) REFERENCES External_Examiners on delete  no action on update no action,
foreign key(PCode) REFERENCES Academic on delete  no action on update no action,
);

