USE Hospital

--Q1--
/*Obtain the names of all physicians that have performed a medical procedure 
they have never been certified to perform.*/

SELECT  
ph.Name,
tr.Physician AS Trained_Physician
FROM Undergoes un LEFT JOIN Trained_In tr 
ON tr.Physician = un.Physician
AND tr.Treatment = un.or_procedure
LEFT JOIN Physician ph 
ON un.Physician = ph.EmployeeID
WHERE tr.Physician IS NULL 

--Q2--
/*Obtain the names of all physicians that have performed a medical procedure 
that they are certified to perform, 
but such that the procedure was done at a date (Undergoes.Date)
after the physician's certification expired (Trained_In.CertificationExpires).*/

SELECT
ph.Name,
un.DateUndergoes,
tr.CertificationExpires
FROM Physician ph JOIN Trained_In tr
ON ph.EmployeeID = tr.Physician
JOIN Undergoes un
ON tr.Physician = un.Physician
WHERE un.DateUndergoes > tr.CertificationExpires

--Q3--
/*Obtain the information for appointments where a patient met with a physician other than his/her primary care physician.
Show the following information: 
Patient name, 
physician name, 
nurse name (if any),
start and end time of appointment, 
examination room, 
and the name of the patient's primary care physician.*/

SELECT * FROM Appointment

SELECT  
p.Name AS Patient_name,
ph.Name AS Physican_name,
n.Name AS Nurse_Name,
a.start_time,
a.end_time,
a.ExaminationRoom AS Room,
ph.Name AS Primary_physician
FROM Appointment a LEFT JOIN Patient p
ON a.Patient = p.SSN
JOIN Physician ph
ON ph.EmployeeID = p.PCP
LEFT JOIN Nurse n
ON n.EmployeeID =a.PrepNurse
WHERE p.PCP <> a.Physician

--Q4--
/*The Patient field in Undergoes is redundant, since we can obtain it from the Stay table.
There are no constraints in force to prevent inconsistencies between these two tables.
More specifically-the Undergoes table may include a row where the patient ID does not match the
one we would obtain from the Stay table.
Select all rows from Undergoes that exhibit this inconsistency.*/

SELECT
u.Patient AS Patient_id_from_Undergoes,
u.Stay,
s.Patient AS Patient_id_from_Stay
FROM Undergoes u LEFT JOIN Stay s
ON u.Stay = s.StayID
WHERE u.Patient <> s.Patient

--Q5--
/*Obtain the names of all the nurses who have ever been on call for room 123*/

SELECT 
n.Name
FROM Nurse n JOIN On_Call o
ON n.EmployeeID = o.Nurse
JOIN Room r
ON o.BlockCode=r.BlockCode
WHERE r.RoomNumber = 123

--Q6--
/*The hospital has several examination rooms where appointments take place.
Obtain the
number of appointments that have taken place in each examination room.*/

SELECT
ExaminationRoom,
COUNT (AppointmentID) AS Number_of_appointments
FROM Appointment
GROUP BY ExaminationRoom

--Q7--
/*Obtain the names of all patients who have been prescribed some medication 
by their primary care physician*/

SELECT
pat.Name
FROM Patient pat JOIN Prescribes pr
ON pat.PCP = pr.Physician

--Q8--
/*Obtain the names of all patients who have been undergone a procedure 
with a cost larger that $5,000*/

SELECT
pat.Name,
cod.Cost
FROM Patient pat JOIN Undergoes un
ON pat.SSN = un.Patient
JOIN or_procedure cod
ON un.or_procedure = cod.Code
WHERE cod.Cost > 5000

--Q9--
/*Obtain the names of all patients who have had at least two appointment*/

SELECT 
pat.Name,
COUNT (ap.AppointmentID) AS Number_of_appointments
FROM Patient pat JOIN Appointment ap
ON pat.SSN = ap.Patient
GROUP BY pat.Name
HAVING COUNT (ap.AppointmentID) >= 2

--Q10--
/*Obtain the names of all patients which 
their care physician is not the head of any department*/

SELECT 
pat.Name AS Name_of_patient,
dep.Head AS If_physician_head_of_departmen --בדיקה--
FROM Patient pat LEFT JOIN Department dep 
ON pat.PCP = dep.Head
WHERE dep.Head is null