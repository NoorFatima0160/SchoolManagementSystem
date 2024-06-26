USE [FinalPro1]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](255) NOT NULL,
	[LastName] [varchar](255) NOT NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [varchar](255) NULL,
	[Contact] [varchar](255) NULL,
	[Email] [varchar](255) NULL,
	[Status] [int] NULL,
	[Address] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[PersonID] [int] NOT NULL,
	[Registration_Number] [varchar](255) NULL,
	[Fee] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Class]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Class](
	[ClassID] [int] IDENTITY(1,1) NOT NULL,
	[ClassName] [varchar](255) NOT NULL,
	[Flag] [int] NULL,
	[seat] [int] NULL,
	[Strength] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fee]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fee](
	[Amount] [decimal](10, 2) NOT NULL,
	[ClassID] [int] NULL,
	[StudentID] [int] NULL,
	[IsLate] [int] NULL,
	[Status] [int] NULL,
	[FeeDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentAssignedClass]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentAssignedClass](
	[ClassID] [int] NULL,
	[StudentID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Get_Fee]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Get_Fee] AS
SELECT 
    (P.FirstName + ' ' + P.LastName) AS Name,
    S.Registration_Number,
    C.ClassName,
    F.Amount,
    F.FeeDate,
    CASE 
        WHEN F.Status = 0 THEN 'Not Paid'
        WHEN F.Status = 1 THEN 'Paid'
        ELSE 'Not Paid'
    END AS Status,
    CASE 
        WHEN F.IsLate = 0 THEN 'Late'
        WHEN F.IsLate = 1 THEN 'On Time'
        ELSE 'Not Paid'
    END AS IsLate
FROM 
    Person P
JOIN 
    Student S ON P.PersonID = S.PersonID
JOIN 
    StudentAssignedClass AC ON AC.StudentID = S.PersonID
JOIN 
    Class C ON C.ClassID = AC.ClassID
LEFT JOIN 
    Fee F ON F.StudentID = AC.StudentID;
GO
/****** Object:  View [dbo].[get_class]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view  [dbo].[get_class]
as
select
ClassName,seat,Strength,flag
from Class
GO
/****** Object:  Table [dbo].[Faculty]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculty](
	[PersonID] [int] NOT NULL,
	[Salary] [varchar](255) NULL,
	[Qualification] [varchar](255) NULL,
	[Designation] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeacherAssignedClass]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeacherAssignedClass](
	[ClassID] [int] NULL,
	[TeacherID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Get_Faculty]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Get_Faculty] AS
SELECT
    P.FirstName,
    P.LastName,
    P.DateOfBirth,
    P.Email,
    P.Contact,
    P.Address,
    P.Gender,
    P.Status,
    F.Salary,
    F.Designation,
    F.Qualification,
    COUNT(T.ClassID) AS TotalClasses,
    STRING_AGG(C.ClassName, ', ') AS ClassNames  -- Concatenate class names using comma separator
FROM 
    Person P
JOIN 
    Faculty F ON P.PersonID = F.PersonID
LEFT JOIN 
    TeacherAssignedClass T ON F.PersonID = T.TeacherID
LEFT JOIN 
    Class C ON T.ClassID = C.ClassID
GROUP BY 
    P.FirstName,
    P.LastName,
    P.DateOfBirth,
    P.Email,
    P.Contact,
    P.Address,
    P.Gender,
    P.Status,
    F.Salary,
    F.Designation,
    F.Qualification;
GO
/****** Object:  View [dbo].[get_Student]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create View [dbo].[get_Student]
as
SELECT  P.FirstName , P.LastName ,P.Address ,P.Gender, (SELECT FORMAT(P.DateOfBirth, 'dd-MM-yyyy')) AS DateOfBirth, P.Contact, P.Email,S.Registration_Number,C.ClassName,S.Fee  ,P.Status ,P.PersonID  FROM Person P JOIN Student S ON S.PersonID= P.PersonID Join StudentAssignedClass as SAC ON P.PersonID = Sac.StudentID Join  Class C On Sac.ClassID = C.ClassID;
GO
/****** Object:  View [dbo].[get_addStudent]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[get_addStudent]
as
SELECT  (P.FirstName + ' ' + P.LastName) AS Name,P.Address ,P.Gender, (SELECT FORMAT(P.DateOfBirth, 'dd-MM-yyyy')) AS [DoB], P.Contact, P.Email,S.Registration_Number,C.ClassName,S.Fee    FROM Person P JOIN Student S ON S.PersonID= P.PersonID Join StudentAssignedClass as SAC ON P.PersonID = Sac.StudentID Join  Class C On Sac.ClassID = C.ClassID   where P.Status=1
GO
/****** Object:  View [dbo].[get_inactiveStudent]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[get_inactiveStudent]
as
SELECT  (P.FirstName + ' ' + P.LastName) AS Name,P.Address ,P.Gender, (SELECT FORMAT(P.DateOfBirth, 'dd-MM-yyyy')) AS [DoB], P.Contact, P.Email,S.Registration_Number,C.ClassName,S.Fee    FROM Person P JOIN Student S ON S.PersonID= P.PersonID Join StudentAssignedClass as SAC ON P.PersonID = Sac.StudentID Join  Class C On Sac.ClassID = C.ClassID    where P.Status=0;
GO
/****** Object:  Table [dbo].[Utilizers]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Utilizers](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](255) NOT NULL,
	[PersonID] [int] NULL,
	[Role] [varchar](255) NULL,
	[Password] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[get_StudentNotUsers]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[get_StudentNotUsers]
as
SELECT C.ClassName ,  S.Registration_Number,(P.FirstName + ' ' + P.LastName) AS Name, P.Contact, P.Email ,P.PersonID FROM Person P JOIN Student S ON S.PersonID= P.PersonID  Join StudentAssignedClass as SAC ON P.PersonID = Sac.StudentID Join  Class C On Sac.ClassID = C.ClassID  Where P.PersonID Not in (SElect P.PersonID From Person P  JOIN Utilizers U ON P.PersonID =U.PersonID ) and  P.Status=1;
GO
/****** Object:  View [dbo].[get_TeacherNotUsers]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[get_TeacherNotUsers]
as
SELECT F.Designation, (P.FirstName + ' ' + P.LastName) AS Name, P.Contact, P.Email , F.Qualification,F.Salary , P.PersonID From Person P JOIN Faculty as F ON F.PersonID= P.PersonID    Where P.PersonID Not in (SElect P.PersonID From Person P  JOIN Utilizers U ON P.PersonID =U.PersonID ) and  P.Status=1;
GO
/****** Object:  View [dbo].[get_allUsers]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[get_allUsers]
as
SELECT (P.FirstName + ' ' + P.LastName) AS Name,U.UserName,U.password,U.Role, P.Contact, P.Email , P.PersonID From Person P     JOIN Utilizers U ON P.PersonID =U.PersonID  Where  P.Status=1;
GO
/****** Object:  Table [dbo].[Attendance]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attendance](
	[StudentID] [int] NULL,
	[ClassID] [int] NULL,
	[Status] [int] NULL,
	[ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[class_Attendance]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[class_Attendance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Attendance_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lookup]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lookup](
	[ID] [int] NOT NULL,
	[category] [varchar](255) NULL,
	[Attendance_status] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Result]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Result](
	[ResultID] [int] IDENTITY(1,1) NOT NULL,
	[Subject_Name] [varchar](255) NULL,
	[ResultTypeID] [int] NULL,
	[TeacherID] [int] NULL,
	[StudentID] [int] NULL,
	[ObtainedMarks] [decimal](10, 2) NULL,
	[DateCreated] [date] NULL,
	[TotalMarks] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResultType]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResultType](
	[ResultTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ResultTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Test]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test](
	[TestID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
	[TeacherID] [int] NULL,
	[SubjectName] [varchar](255) NOT NULL,
	[TotalMarks] [decimal](10, 2) NULL,
	[CreatedDate] [datetime] NULL,
	[ClassID] [int] NULL,
	[DeadLine] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[TestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Attendance] ([StudentID], [ClassID], [Status], [ID]) VALUES (1, 2, 1, 5)
INSERT [dbo].[Attendance] ([StudentID], [ClassID], [Status], [ID]) VALUES (5, 2, 1, 5)
GO
SET IDENTITY_INSERT [dbo].[Class] ON 

INSERT [dbo].[Class] ([ClassID], [ClassName], [Flag], [seat], [Strength]) VALUES (1, N'Two', 1, 50, 2)
INSERT [dbo].[Class] ([ClassID], [ClassName], [Flag], [seat], [Strength]) VALUES (2, N'Four', 1, 50, 3)
INSERT [dbo].[Class] ([ClassID], [ClassName], [Flag], [seat], [Strength]) VALUES (3, N'one', 1, 50, 0)
INSERT [dbo].[Class] ([ClassID], [ClassName], [Flag], [seat], [Strength]) VALUES (4, N'Three', 1, 50, 0)
SET IDENTITY_INSERT [dbo].[Class] OFF
GO
SET IDENTITY_INSERT [dbo].[class_Attendance] ON 

INSERT [dbo].[class_Attendance] ([ID], [Attendance_date]) VALUES (5, CAST(N'2024-05-09' AS Date))
SET IDENTITY_INSERT [dbo].[class_Attendance] OFF
GO
INSERT [dbo].[Faculty] ([PersonID], [Salary], [Qualification], [Designation]) VALUES (6, N'10000', N'MA English', N'Professor')
INSERT [dbo].[Faculty] ([PersonID], [Salary], [Qualification], [Designation]) VALUES (7, N'12000', N'MA Urdu', N'Vice Principal')
INSERT [dbo].[Faculty] ([PersonID], [Salary], [Qualification], [Designation]) VALUES (9, N'10000', N'MA Math', N'Teacher')
INSERT [dbo].[Faculty] ([PersonID], [Salary], [Qualification], [Designation]) VALUES (10, N'908', N'bnw', N'Teacher')
GO
INSERT [dbo].[lookup] ([ID], [category], [Attendance_status]) VALUES (1, N'PRESENT', N'Status')
INSERT [dbo].[lookup] ([ID], [category], [Attendance_status]) VALUES (2, N'ABSENT', N'Status')
INSERT [dbo].[lookup] ([ID], [category], [Attendance_status]) VALUES (3, N'LEAVE', N'Status')
GO
SET IDENTITY_INSERT [dbo].[Person] ON 

INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (1, N'Noor', N'Fatima', CAST(N'2020-03-04' AS Date), N'Female', N'+92-3018224455', N'Noor@gmail.com', 1, N'Gojra,Pakistan')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (3, N'dvd', N'cvfgv', CAST(N'2000-05-04' AS Date), N'Female', N'+92-3018224455', N'Noori@gmail.com', 0, N'nnnn,nmbjkj')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (4, N'Muskan', N'Awais', CAST(N'2006-06-29' AS Date), N'Female', N'+92-3018225566', N'muskan@gmai.com', 1, N'sgftydft,cgsdhg')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (5, N'Hafsa', N'Amjad', CAST(N'2024-05-05' AS Date), N'Female', N'+92-3018225544', N'hafsa@gmai.com', 1, N'sgftydft,cgsdhg')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (6, N'Fariha', N'Imran', CAST(N'2000-03-12' AS Date), N'Female', N'+92-3018423456', N'fariha@gmail.com', 1, N'bshjdgs,vsdhdb')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (7, N'Amara', N'Khan', CAST(N'2020-03-04' AS Date), N'Female', N'+92-3012233423', N'amara@gmail.com', 1, N'hvvh, vawdb')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (8, N'Iqra', N'Tariq', CAST(N'2020-03-05' AS Date), N'Female', N'+92-3012233123', N'iqra@gmail.com', 1, N'hvvh, vawdb')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (9, N'Bushra', N'Arif', CAST(N'2001-07-06' AS Date), N'Male', N'+92-3018994433', N'sdu@gmail.com', 1, N'dusahfzuzenf')
INSERT [dbo].[Person] ([PersonID], [FirstName], [LastName], [DateOfBirth], [Gender], [Contact], [Email], [Status], [Address]) VALUES (10, N'hsghj', N'hbs', CAST(N'2024-05-06' AS Date), N'Female', N'bb', N'vhjgu', 1, N'bn')
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
SET IDENTITY_INSERT [dbo].[Result] ON 

INSERT [dbo].[Result] ([ResultID], [Subject_Name], [ResultTypeID], [TeacherID], [StudentID], [ObtainedMarks], [DateCreated], [TotalMarks]) VALUES (1, N'English', 1, 6, 1, CAST(85.00 AS Decimal(10, 2)), CAST(N'2024-05-10' AS Date), 100)
INSERT [dbo].[Result] ([ResultID], [Subject_Name], [ResultTypeID], [TeacherID], [StudentID], [ObtainedMarks], [DateCreated], [TotalMarks]) VALUES (2, N'English', 1, 6, 5, CAST(80.00 AS Decimal(10, 2)), CAST(N'2024-05-10' AS Date), 100)
INSERT [dbo].[Result] ([ResultID], [Subject_Name], [ResultTypeID], [TeacherID], [StudentID], [ObtainedMarks], [DateCreated], [TotalMarks]) VALUES (3, N'Urdu', 1, 6, 5, CAST(80.00 AS Decimal(10, 2)), CAST(N'2024-05-10' AS Date), 100)
INSERT [dbo].[Result] ([ResultID], [Subject_Name], [ResultTypeID], [TeacherID], [StudentID], [ObtainedMarks], [DateCreated], [TotalMarks]) VALUES (4, N'Urdu', 1, 6, 1, CAST(79.00 AS Decimal(10, 2)), CAST(N'2024-05-10' AS Date), 100)
SET IDENTITY_INSERT [dbo].[Result] OFF
GO
SET IDENTITY_INSERT [dbo].[ResultType] ON 

INSERT [dbo].[ResultType] ([ResultTypeID], [TypeName]) VALUES (1, N'1st Term')
INSERT [dbo].[ResultType] ([ResultTypeID], [TypeName]) VALUES (2, N'2nd Term')
INSERT [dbo].[ResultType] ([ResultTypeID], [TypeName]) VALUES (3, N'Final Term')
SET IDENTITY_INSERT [dbo].[ResultType] OFF
GO
INSERT [dbo].[Student] ([PersonID], [Registration_Number], [Fee]) VALUES (1, N'01', N'1000')
INSERT [dbo].[Student] ([PersonID], [Registration_Number], [Fee]) VALUES (3, N'04', N'1000')
INSERT [dbo].[Student] ([PersonID], [Registration_Number], [Fee]) VALUES (4, N'15', N'1000')
INSERT [dbo].[Student] ([PersonID], [Registration_Number], [Fee]) VALUES (5, N'02', N'1000')
INSERT [dbo].[Student] ([PersonID], [Registration_Number], [Fee]) VALUES (8, N'06', N'1000')
GO
INSERT [dbo].[StudentAssignedClass] ([ClassID], [StudentID]) VALUES (2, 1)
INSERT [dbo].[StudentAssignedClass] ([ClassID], [StudentID]) VALUES (2, 3)
INSERT [dbo].[StudentAssignedClass] ([ClassID], [StudentID]) VALUES (1, 4)
INSERT [dbo].[StudentAssignedClass] ([ClassID], [StudentID]) VALUES (2, 5)
INSERT [dbo].[StudentAssignedClass] ([ClassID], [StudentID]) VALUES (1, 8)
GO
INSERT [dbo].[TeacherAssignedClass] ([ClassID], [TeacherID]) VALUES (2, 6)
INSERT [dbo].[TeacherAssignedClass] ([ClassID], [TeacherID]) VALUES (1, 9)
INSERT [dbo].[TeacherAssignedClass] ([ClassID], [TeacherID]) VALUES (3, 10)
GO
SET IDENTITY_INSERT [dbo].[Test] ON 

INSERT [dbo].[Test] ([TestID], [Description], [TeacherID], [SubjectName], [TotalMarks], [CreatedDate], [ClassID], [DeadLine]) VALUES (1, N'Ass2', 6, N'English', CAST(10.00 AS Decimal(10, 2)), CAST(N'2024-05-10T00:00:00.000' AS DateTime), 2, N'May 14 2024  1:53PM')
SET IDENTITY_INSERT [dbo].[Test] OFF
GO
SET IDENTITY_INSERT [dbo].[Utilizers] ON 

INSERT [dbo].[Utilizers] ([UserID], [UserName], [PersonID], [Role], [Password]) VALUES (5, N'four-01   ', 1, N'Student   ', N'1234')
INSERT [dbo].[Utilizers] ([UserID], [UserName], [PersonID], [Role], [Password]) VALUES (6, N'Four-4    ', 3, N'Student   ', N'12345')
INSERT [dbo].[Utilizers] ([UserID], [UserName], [PersonID], [Role], [Password]) VALUES (7, N'Two-15    ', 4, N'Student   ', N'qwerty')
INSERT [dbo].[Utilizers] ([UserID], [UserName], [PersonID], [Role], [Password]) VALUES (9, N'Four-02', 5, N'Student   ', N'6789')
INSERT [dbo].[Utilizers] ([UserID], [UserName], [PersonID], [Role], [Password]) VALUES (10, N'fariha-02 ', 6, N'Teacher   ', N'67890')
INSERT [dbo].[Utilizers] ([UserID], [UserName], [PersonID], [Role], [Password]) VALUES (11, N'misskhan  ', 7, N'Admin     ', N'0000')
SET IDENTITY_INSERT [dbo].[Utilizers] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UC_ClassName]    Script Date: 5/10/2024 7:10:36 PM ******/
ALTER TABLE [dbo].[Class] ADD  CONSTRAINT [UC_ClassName] UNIQUE NONCLUSTERED 
(
	[ClassName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD FOREIGN KEY([ClassID])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD FOREIGN KEY([Status])
REFERENCES [dbo].[lookup] ([ID])
GO
ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([PersonID])
GO
ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD FOREIGN KEY([ID])
REFERENCES [dbo].[class_Attendance] ([ID])
GO
ALTER TABLE [dbo].[Faculty]  WITH CHECK ADD FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Fee]  WITH CHECK ADD FOREIGN KEY([ClassID])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[Fee]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([PersonID])
GO
ALTER TABLE [dbo].[Result]  WITH CHECK ADD FOREIGN KEY([ResultTypeID])
REFERENCES [dbo].[ResultType] ([ResultTypeID])
GO
ALTER TABLE [dbo].[Result]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([PersonID])
GO
ALTER TABLE [dbo].[Result]  WITH CHECK ADD FOREIGN KEY([TeacherID])
REFERENCES [dbo].[Faculty] ([PersonID])
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[StudentAssignedClass]  WITH CHECK ADD FOREIGN KEY([ClassID])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[StudentAssignedClass]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([PersonID])
GO
ALTER TABLE [dbo].[TeacherAssignedClass]  WITH CHECK ADD FOREIGN KEY([ClassID])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[TeacherAssignedClass]  WITH CHECK ADD FOREIGN KEY([TeacherID])
REFERENCES [dbo].[Faculty] ([PersonID])
GO
ALTER TABLE [dbo].[Test]  WITH CHECK ADD FOREIGN KEY([ClassID])
REFERENCES [dbo].[Class] ([ClassID])
GO
ALTER TABLE [dbo].[Test]  WITH CHECK ADD FOREIGN KEY([TeacherID])
REFERENCES [dbo].[Faculty] ([PersonID])
GO
ALTER TABLE [dbo].[Utilizers]  WITH CHECK ADD FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertPerson]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertPerson]
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DateOfBirth DATE,
    @Email NVARCHAR(100),
    @Contact NVARCHAR(100),
    @Address NVARCHAR(100),
    @Gender NVARCHAR(100),
    @Status NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Person (FirstName, LastName, DateOfBirth, Email, Contact, Address, Gender, Status)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Email, @Contact, @Address, @Gender, @Status);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateClass]    Script Date: 5/10/2024 7:10:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateClass]
    @ClassID INT,
    @ClassName NVARCHAR(100),
    @Seat INT,
	@flag int
AS
BEGIN
    UPDATE Class
    SET 
        ClassName = @ClassName,
        Seat = @Seat,
		flag = @flag
    WHERE
        ClassID = @ClassID;
END;
GO
