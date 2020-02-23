/* the char lengths were kind of just guessed on */
/*Parts 1 and 2 of PHASE 3 Team 37 Surya Vadivazhagu & James Flynn */

-- Drop the tables first
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Room CASCADE CONSTRAINTS;
DROP TABLE Equipment CASCADE CONSTRAINTS;
DROP TABLE EquipmentType CASCADE CONSTRAINTS;
DROP TABLE RoomAccess CASCADE CONSTRAINTS;
DROP TABLE RoomService CASCADE CONSTRAINTS;
DROP TABLE Patient CASCADE CONSTRAINTS;
DROP TABLE Doctor CASCADE CONSTRAINTS;
DROP TABLE Admission CASCADE CONSTRAINTS;
DROP TABLE Examine CASCADE CONSTRAINTS;
DROP TABLE StayIn CASCADE CONSTRAINTS;


/* Employee */
CREATE TABLE Employee(
    ID INTEGER NOT NULL PRIMARY KEY,
    FName VARCHAR(30) NOT NULL,
    LName VARCHAR(30) NOT NULL,
    Salary FLOAT NOT NULL,
    JobTitle VARCHAR(30) NOT NULL,
    OfficeNum VARCHAR(5) NOT NULL UNIQUE,   /* Two employee's can't have the same office so it has to be unique */
    EmpRank INTEGER NOT NULL, /* 0 = Regular, 1  = Division Manager, 2 = General Manager */
    SupervisorId INTEGER, /*It's not NOT NULL because General Manager doesn't have a manager so this would be NULL for them. */
    CONSTRAINT CHK_EmpRank CHECK (EmpRank = 0 OR EmpRank = 1 OR EmpRank = 2)
);

/* Room entity */
CREATE TABLE Room(
    Num INTEGER NOT NULL PRIMARY KEY,
    Occupied CHAR(1) NOT NULL,
    CONSTRAINT CHK_Occupied CHECK (Occupied = 0 OR Occupied = 1) /*if occupied, 1, if not, 0 */
);

CREATE TABLE EquipmentType(
    Id VARCHAR(20) NOT NULL PRIMARY KEY,
    Description VARCHAR(20), /* May or may not have a description */
    ModelType VARCHAR(20) NOT NULL,
    Instructions VARCHAR(500) /* May or may not have instructions */
);

CREATE TABLE Equipment(
    Serial VARCHAR(20) NOT NULL PRIMARY KEY,
    TypeId VARCHAR(20) NOT NULL,
    PurchaseYear DATE NOT NULL,
    LastInspection DATE,
    RoomNum INTEGER NOT NULL,
    FOREIGN KEY (RoomNum) REFERENCES Room(Num),
    FOREIGN KEY (TypeId) REFERENCES EquipmentType(Id),
    CONSTRAINT CHK_Equipment CHECK (LastInspection >= PurchaseYear)
);

CREATE TABLE RoomService(
    RoomNum INTEGER NOT NULL,
    Service CHAR(20) NOT NULL,
    CONSTRAINT PK_RoomService PRIMARY KEY (RoomNum, Service),
    FOREIGN KEY (RoomNum) REFERENCES Room(Num)
);

CREATE TABLE RoomAccess(
    RoomNum INTEGER NOT NULL,
    EmpId INTEGER NOT NULL,
    CONSTRAINT PK_RoomAccess PRIMARY KEY (RoomNum, EmpId),
    FOREIGN KEY (RoomNum) REFERENCES Room(Num),
    FOREIGN KEY (EmpId) REFERENCES Employee(Id)
);

CREATE TABLE Patient(
    SSN VARCHAR(9) NOT NULL PRIMARY KEY, /* Assuming it's format 123456789 */
    FirstName VARCHAR(15) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    Address VARCHAR(30) NOT NULL,
    TelNum VARCHAR(10) NOT NULL /* Assuming it's format 1234567890 */
);

CREATE TABLE Doctor(
    Id INTEGER NOT NULL PRIMARY KEY,
    FirstName VARCHAR(15) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    Gender CHAR(1) NOT NULL, /*Assuming either M or F */
    Specialty VARCHAR(30) NOT NULL, /*If no specialty, assuming can mark as such */
    CONSTRAINT CHK_Gender CHECK (Gender = 'M' OR Gender = 'F')
);

CREATE TABLE Admission(
    AdmissionNum INTEGER NOT NULL PRIMARY KEY,
    AdmissionDate DATE NOT NULL,
    LeaveDate DATE, /*Assuming that a patient's leave date isn't always known */
    TotalPayment REAL NOT NULL,
    InsurancePayment REAL, /*Not all patients have insurance, so can be null */
    PatientSSN VARCHAR(9) NOT NULL,
    FutureVisit DATE, /*patient doesn't always need a future visit can be null */
    FOREIGN KEY (PatientSSN) REFERENCES Patient(SSN),
    CONSTRAINT CHK_Admission CHECK (AdmissionDate<=LeaveDate),
    CONSTRAINT CHK_Future CHECK (LeaveDate<FutureVisit),
    CONSTRAINT CHK_Payment CHECK (InsurancePayment<=TotalPayment)
);

CREATE TABLE Examine(
    DoctorId INTEGER NOT NULL,
    AdmissionNum INTEGER NOT NULL,
    Comments VARCHAR(300), /* assuming not every exam requires a comment. doc can leave no comment (null) */
    CONSTRAINT PK_Examine PRIMARY KEY (DoctorId, AdmissionNum),
    FOREIGN KEY (DoctorId) REFERENCES Doctor(Id),
    FOREIGN KEY (AdmissionNum) REFERENCES Admission(AdmissionNum)
);

CREATE TABLE StayIn(
    AdmissionNum INTEGER NOT NULL,
    RoomNum INTEGER NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE, /* assuming patient can stay at hospital indefinitely */
    CONSTRAINT PK_StayIn PRIMARY KEY (AdmissionNum, RoomNum, StartDate),
    FOREIGN KEY (AdmissionNum) REFERENCES Admission(AdmissionNum),
    FOREIGN KEY (RoomNum) REFERENCES Room(Num)
);

--Part 3 Data insertion
--Doctor
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(59835,'Amanda','Green','F','Nose');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(48396,'Curtis','Cordova','M','Lungs');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(33951,'Tiffany','Park','M','General');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(15844,'Terri','Wolfe','F','Mouth');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(73205,'Richard','Nichols','M','Brain');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(67393,'Blake','Preston','F','Back');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(16729,'Sandra','Romero','M','Nose');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(91088,'Stephanie','Washington','M','Mouth');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(61531,'Chris','Johnson','M','Nose');
insert into Doctor(Id,FirstName,LastName,Gender,Specialty) values(67914,'David','Weaver','F','Chest');


--Patient
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('100081645','William','Jacobs','07809 Sanchez Falls Apt.','5281819495');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('749960232','Shannon','Johnson','987 Ethan Avenue','8566653428');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('129896304','Dawn','Sherman','PSC 8224, Box 9826','7630264412');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('236056202','Bobby','Garcia','60143 Smith Fields','6282007745');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('986031220','Michael','Jackson','928 Patel Estates Leeches','7035758669');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('249175256','Chris','Suarez','86570 Gardner Mission Apt.','6581046444');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('743450197','Austin','Collins','73304 Marsh Orchard North W','1066168043');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('559207164','Mrs.','Morales','3937 Timothy Mountains','911009678');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('760907382','Anne','Phillips','80292 John Forges','8056277602');
insert into Patient(SSN,FirstName,LastName,Address,TelNum) values('324402615','David','Wolf','41208 Thompson Turnpike','390194562');

--Room
insert into Room(Num,Occupied) values(172,'1');
insert into Room(Num,Occupied) values(800,'1');
insert into Room(Num,Occupied) values(335,'1');
insert into Room(Num,Occupied) values(586,'0');
insert into Room(Num,Occupied) values(879,'0');
insert into Room(Num,Occupied) values(461,'1');
insert into Room(Num,Occupied) values(782,'0');
insert into Room(Num,Occupied) values(678,'1');
insert into Room(Num,Occupied) values(871,'1');
insert into Room(Num,Occupied) values(636,'1');

--Room 172
insert into RoomService(RoomNum, Service) values (172, 'Emergency');
insert into RoomService(RoomNum, Service) values (172, 'Surgery');

--Room800
insert into RoomService(RoomNum, Service) values (800, 'Pharmacy');
insert into RoomService(RoomNum, Service) values (800, 'Billing');

--Rooom335
insert into RoomService(RoomNum, Service) values (335, 'Waiting Room');
insert into RoomService(RoomNum, Service) values (335, 'Morgue');


--EquipmentType
insert into EquipmentType(Id, Description, ModelType, Instructions) values ('100', 'Surgical', 'Damaging', 'Be Careful');
insert into EquipmentType(Id, Description, ModelType, Instructions) values ('200', 'Stitching', 'Healing', 'Take Care');
insert into EquipmentType(Id, Description, ModelType, Instructions) values ('300', 'Pills', 'Treatment', 'No OD');

--Equipment 
insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('1', '100', TO_DATE('1997', 'yyyy'), TO_DATE('2013/03/24', 'yyyy/mm/dd'), 172);
insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('2', '100', TO_DATE('1998', 'yyyy'), TO_DATE('2014/05/30', 'yyyy/mm/dd' ), 800);
insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('3', '100', TO_DATE('1999/05/24', 'yyyy/mm/dd'),TO_DATE('2015/06/30', 'yyyy/mm/dd'), 335);

insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('4', '200', TO_DATE('2000/06/24', 'yyyy/mm/dd'), TO_DATE('2016/07/30', 'yyyy/mm/dd'), 586);
insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('5', '200', TO_DATE('2001/07/24', 'yyyy/mm/dd'), TO_DATE('2017/08/30', 'yyyy/mm/dd'), 879);
insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('6', '200', TO_DATE('2002/08/24', 'yyyy/mm/dd'), TO_DATE('2018/09/30', 'yyyy/mm/dd'), 461);

insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('7', '300', TO_DATE('2003/09/24', 'yyyy/mm/dd'), TO_DATE('2019/10/30', 'yyyy/mm/dd'), 782);
insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('8', '300', TO_DATE('2004/10/24', 'yyyy/mm/dd'), TO_DATE('2019/11/30', 'yyyy/mm/dd'), 678);
insert into Equipment(Serial, TypeId, PurchaseYear, LastInspection, RoomNum) values ('9', '300', TO_DATE('2005/11/24', 'yyyy/mm/dd'), TO_DATE('2019/12/30', 'yyyy/mm/dd'), 871);

--Admission 
insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (1, TO_DATE('2019/01/02', 'yyyy/mm/dd'), TO_DATE('2019/02/15', 'yyyy/mm/dd'), 500000.0, 15000.0, '100081645', TO_DATE('2019/03/02', 'yyyy/mm/dd'));
insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (2, TO_DATE('2019/03/02', 'yyyy/mm/dd'), TO_DATE('2019/04/15', 'yyyy/mm/dd'), 1500000.0, 5000.0, '100081645', null);

insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (3, TO_DATE('2019/02/02', 'yyyy/mm/dd'), TO_DATE('2019/03/15', 'yyyy/mm/dd'), 2750.0, 750.0, '749960232', TO_DATE('2019/04/02', 'yyyy/mm/dd'));
insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (4, TO_DATE('2019/04/02', 'yyyy/mm/dd'), TO_DATE('2019/05/15', 'yyyy/mm/dd'), 500.0, 100.0, '749960232', null);

insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (5, TO_DATE('2019/05/02', 'yyyy/mm/dd'), TO_DATE('2019/06/15', 'yyyy/mm/dd'), 2000.0, 500.0, '129896304', TO_DATE('2019/06/20', 'yyyy/mm/dd'));
insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (6, TO_DATE('2019/06/20', 'yyyy/mm/dd'), TO_DATE('2020/01/02', 'yyyy/mm/dd'), 100000.0, 50000.0, '129896304', null);

insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (7, TO_DATE('2019/07/02', 'yyyy/mm/dd'), TO_DATE('2019/08/15', 'yyyy/mm/dd'), 25000.0, 20000.0,'236056202', TO_DATE('2019/08/20', 'yyyy/mm/dd'));
insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (8, TO_DATE('2019/08/20', 'yyyy/mm/dd'), TO_DATE('2020/09/15', 'yyyy/mm/dd'), 2500000.0, 2000.0,'236056202', null );

insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (9, TO_DATE('2019/07/02', 'yyyy/mm/dd'), TO_DATE('2019/08/15', 'yyyy/mm/dd'), 250000.0, 20000.0,'986031220', TO_DATE('2020/06/01', 'yyyy/mm/dd'));
insert into Admission(admissionnum, admissiondate, leavedate, totalpayment, insurancepayment, patientssn, futurevisit) values (10, TO_DATE('2020/06/01', 'yyyy/mm/dd'), TO_DATE('2021/08/15', 'yyyy/mm/dd'), 25000.0, 20000.0, '986031220' , null);



--Employee 

    -- 10Regular 
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (100, 'John', 'Doe', 35000, 'Janitor', '114', 0, 1100);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (200, 'Jane', 'Doe', 35000, 'Receptionist', '001', 0, 1200);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (300, 'James', 'Fox', 35000, 'Cleaner', '115', 0, 1300);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (400, 'Janet', 'Thompson', 35000, 'Cook', '002', 0, 1100);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (500, 'Alex', 'Wurts', 35000, 'Cook', '116', 0, 1400);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (600, 'Surya', 'Vee', 35000, 'Nurse', '003', 0, 1300);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (700, 'Danny', 'McD', 35000, 'Lab Tech', '117', 0, 1400);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (800, 'James', 'Flynn', 35000, 'Janitor', '004', 0, 1200);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (900, 'Roger', 'Federer', 35000, 'Janitor', '118', 0, 1400);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (1000, 'Rafael', 'Nadal', 35000, 'Receptionist', '005', 0, 1200);

--4 division manager 
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (1100, 'Drew', 'Doe', 50000, 'Shift Mgr', '666', 1, 9999);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (1200, 'Suzy', 'Doe', 50000, 'Exec Manager', '667', 1, 9999);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (1300, 'Michael', 'Fox', 50000, 'Head Chef', '668', 1, 10000);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (1400, 'Janet', 'Jackson', 50000, 'Assistant', '669', 1, 10000);


    --2 general manager 
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (9999, 'Bill ', 'Gates', 999999, 'Big Boss', '999', 2, null);
    insert into Employee(id, fname, lname, salary, jobtitle, officenum, emprank, supervisorid) values (10000, 'Jeff', 'Bezos', 100000, 'Hospital CEO', '1000', 2, null);

--Doctor Examination Inserts
insert into Examine(doctorid, admissionnum, comments) values (59835, 1, 'Get surgery');
insert into Examine(doctorid, admissionnum, comments) values (48396, 2, 'Get medicine');
insert into Examine(doctorid, admissionnum, comments) values (33951, 3, 'Get a cast');
insert into Examine(doctorid, admissionnum, comments) values (15844, 4, 'Get some pills');


--RoomAccess Inserts
insert into RoomAccess(roomnum, empid) values (172, 800);
insert into RoomAccess(roomnum, empid) values (800, 900);
insert into RoomAccess(roomnum, empid) values (335, 1000);


--StayIn Inserts
insert into StayIn(admissionnum, roomnum, startdate, enddate) values (1, 172, TO_DATE('2019/01/02', 'yyyy/mm/dd'), TO_DATE('2019/02/15', 'yyyy/mm/dd'));
insert into StayIn(admissionnum, roomnum, startdate, enddate) values (2, 800, TO_DATE('2019/03/02', 'yyyy/mm/dd'), TO_DATE('2019/04/15', 'yyyy/mm/dd'));


-- Part 1 : CriticalCases View
create or replace view CriticalCases(Patient_SSN, firstName, lastName, numberOfAdmissionsToICU) AS
    SELECT q.patientSSN, P.firstName, p.lastName, q.numberOfAdmissionsToICU
	FROM Patient P,
	(SELECT A.patientSSN, COUNT(*) as numberOfAdmissionsToICU
	from Admission A,
	(SELECT AdmissionNum FROM StayIn A WHERE A.ROOMNUM in
								(SELECT RoomService.RoomNum FROM roomService WHERE Service = 'ICU')) q
	WHERE A.AdmissionNum = q.AdmissionNum
	GROUP BY patientSSN) q
	WHERE q.patientSSN = P.SSN AND q.numberOfAdmissionsToICU >= 2;

--Part 1 : DoctorsLoad View
CREATE OR REPLACE VIEW DoctorsLoad(DoctorID, gender, load) AS
	(SELECT D.Id as DoctorID, D.gender, 'Underloaded' as load
	FROM Doctor D,
        (SELECT D.Id
        FROM Doctor D,Examine E
	   WHERE D.Id = E.DOCTORID
	    GROUP BY D.Id
	    HAVING COUNT(*) <= 10) c
	WHERE D.Id = c.Id)
	UNION
	(SELECT D.Id as DoctorID, D.gender, 'Overloaded' as load
	FROM Doctor D,
        (SELECT D.Id
        FROM Doctor D,Examine E
	   WHERE D.Id = E.DOCTORID
	    GROUP BY  D.ID
	    HAVING COUNT(*) >= 10) c
	WHERE D.Id = c.Id);
--Should return only 4 results, each of which is an Underloaded doctor. 2 M and 2 F doctors.


--Part 1 : Reporting Critical-Case patients with numAdmissions to ICU > 4
SELECT CriticalCases.Patient_SSN, CriticalCases.firstName, CriticalCases.lastName
FROM CriticalCases
WHERE numberOfAdmissionsToICU > 4;
--Should return nothing, as no patients in the sample data have been to the 'ICU' multiple times.


--Part 1 : Reporting all female overloaded Doctors.
SELECT Doctor.Id, firstName, lastName
FROM DoctorsLoad
LEFT JOIN Doctor
ON Doctor.Id = DoctorsLoad.DoctorID
WHERE DoctorsLoad.Gender = 'F'
AND DoctorsLoad.load = 'Overloaded';
--Should return nothing, as there are only 4 doctors who have examined patients, and each of those doctors is underloaded.


--Part 1 : Reporting comments inserted by UNDERLOADED doctors when examining critical-case patients
SELECT A.DoctorId, D.PATIENTSSN, C.COMMENTS
FROM DoctorsLoad A, CriticalCases B, Examine C, Admission D
WHERE A.load = 'Underloaded'
AND A.DOCTORID = C.DOCTORID
AND C.ADMISSIONNUM = D.ADMISSIONNUM
AND D.PATIENTSSN = B.PATIENT_SSN
--Should return nothing as we have no patients in the CriticalCases view as it is.
;



--Part 2: Database Triggers. We put each bullet point instruction as its own trigger instead of combining many to one.

-- Part 2 : Doctor must leave comment if visiting patient in ICU
CREATE OR REPLACE Trigger LeaveComment
    BEFORE INSERT ON Examine
    FOR EACH ROW
    DECLARE
        CNT varchar2(20);
    BEGIN
        SELECT count(*) INTO CNT
        FROM RoomService,StayIn
        WHERE AdmissionNum = :new.AdmissionNum AND RoomService.RoomNum = StayIn.RoomNum AND RoomService.Service = 'ICU';
            IF CNT !=0 then
                IF :new.Comments IS NULL then
                RAISE_APPLICATION_ERROR(-20000, 'Doctor must leave a comment if visiting patient in ICU');
                END IF;
            END IF;
    END;
/

-- Part 2 : Insurance Payment Automatically calculated at 65% of total payment
CREATE OR REPLACE TRIGGER AutomaticPaymentCalculation
    BEFORE INSERT or UPDATE ON Admission
    FOR EACH ROW
    BEGIN
        :new.InsurancePayment := :new.totalPayment*0.65;
    END;
/


--Part 2 : Emp with Rank 0 must have supervisor at Rank 1. Reg employee must always have supervisor
CREATE OR REPLACE TRIGGER RegEmpMustHaveSup
    before insert or update on Employee
    for each row
    when (new.EmpRank = 0)
    declare divManagerRank INTEGER := 1;
    Begin
        select EmpRank into divManagerRank from Employee where EmpRank = :new.SupervisorId;
        If(divManagerRank != 1) then
            RAISE_APPLICATION_ERROR(-20001, 'Regular Employees  must have Division Managers as their supervisor.' );

        end if;
    end;
/

-- Part 2: Emp with Rank 1 must have a supervisor at Rank 2
create or replace trigger DivMangMustHaveSup
    before insert or update on Employee
    for each row
    when (new.EmpRank = 1)
    declare gmRank INTEGER;
    begin
        select EmpRank into gmRank from Employee where ID =:new.SupervisorId;
            if(gmRank != 2) then
                RAISE_APPLICATION_ERROR(-20002, 'Division Managers need to have a General Manager as their supervisor');
            end if;
    end;
/

-- Part 2 : General Managers can't have a supervisor
create or replace trigger GMangNoSup
    BEFORE INSERT or UPDATE on Employee
    FOR EACH ROW
    WHEN (new.EmpRank = 2)
    DECLARE gmRank number;
    BEGIN
        SELECT EmpRank INTO gmRank FROM Employee WHERE ID =:new.SupervisorId;
            IF(gmRank is not NULL)then
                RAISE_APPLICATION_ERROR(-20003, 'General managers should have no manager');
            END IF;
    END;
/

-- Part 2 : When a patient is admitted into room w/ service "emergency service" futurevist should be 2 months after that

create or replace trigger autoSetFutureVisit
    BEFORE INSERT ON StayIn
    FOR EACH ROW
    DECLARE roomService varchar(20);
    admitDate date;
    Begin
        SELECT RoomService.Service, Admission.admissionDate INTO roomService, admitDate
        FROM Admission, RoomService, StayIn
        WHERE :new.admissionNum = Admission.admissionNum
        AND :new.RoomNum = RoomService.RoomNum
        AND RoomService.Service = 'Emergency';
        IF(roomService != null) Then
            UPDATE Admission SET futureVisit = ADD_MONTHS(admitDate, 2) WHERE admissionNum = :new.admissionNum;
            END IF;
    END;
/

-- Part 2 : if a piece of equipment is of type Ct scanner or Ultrasound purchase year != null, must be after 2006
create or replace trigger EquipmentPurchaseYearCheck
    before insert or update on Equipment
    for each row
    begin
        if(:new.TypeId = 'Ultrasound' or :new.TypeId = 'CT Scanner') then
            if(:new.PurchaseYear = null or EXTRACT(YEAR FROM :new.purchaseYear) < 2007 ) then
                raise_application_error(-20004, 'Purchase year cannot be null or before 2006 for CT scanner and Ultrasound');
            end if;
        end if;
    end;
/

-- Part 2 : When a patient leaves hospital print out their fname, lname, address, all comments, and which doctor

create or replace trigger PrintPatientInfo
        after update on Admission
        for each row
        declare cursor doctorRegistry is select Doctor.FirstName, Doctor.LastName, Examine.Comments FROM Doctor,
        Examine where Doctor.Id = Examine.DoctorId and :new.AdmissionNum = Examine.AdmissionNum;
        patientFname varchar2(30);
        patientLname varchar2(30);
        patientAdd varchar2(50);
        patientDoc doctorRegistry%ROWTYPE;
        begin
            select FirstName, LastName, Address INTO patientFname, patientLname, patientAdd
            from Patient
            where Patient.SSN = :new.PatientSSN;
        open doctorRegistry;
            loop
                fetch doctorRegistry into patientDoc;
                exit when doctorRegistry%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(patientFname);
                DBMS_OUTPUT.PUT_LINE(patientLname);
                dbms_output.put_line(patientAdd);
                dbms_output.PUT_LINE(patientDoc.FirstName);
                dbms_output.PUT_LINE(patientDoc.LastName);
                dbms_output.PUT_LINE(patientDoc.Comments);
            end loop;
        close doctorRegistry;
        end;
/












