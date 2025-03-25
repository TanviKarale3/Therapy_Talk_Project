CREATE DATABASE therapytalk;
USE therapytalk;

CREATE TABLE patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    disease VARCHAR(100)
);

CREATE TABLE doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_name VARCHAR(100),
    doctor_name VARCHAR(100),
    specialty VARCHAR(100),
    experience INT,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255)
);

CREATE TABLE appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    status ENUM('Pending', 'Approved', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

INSERT INTO doctors (clinic_name, doctor_name, specialty, experience, address, phone, email, password) 
VALUES 
('Apollo Clinic', 'Dr. Raju Sharma', 'Stuttering', 15, '123, MG Road, Amravati, Maharashtra', '9876543210', 'shreyash080204@gmail.com', 'password123'),
('Fortis Clinic', 'Dr. Anjali  verma', 'Stuttering', 10, '456, Station Road, Amravati, Maharashtra', '9876543211', 'anjalii.mehta@example.com', 'password456'),
('Max Healthcare', 'Dr. Vikramakaur Singh', 'Dyslexia', 20, '789, College Road, Amravati, Maharashtra', '9876543212', 'vikrami.singh@example.com', 'password789'),
('Medanta Clinic', 'Dr. Priya khan Iyer', 'Dyslexia', 12, '101, Airport Road, Amravati, Maharashtra', '9876543213', 'priyai.iyer@example.com', 'password101');



UPDATE doctors SET specialty = 'Stuttering' WHERE doctor_name = 'kamo';
ALTER TABLE doctors 
ADD COLUMN age INT AFTER doctor_name,
ADD COLUMN gender ENUM('Male', 'Female', 'Other') AFTER age,
ADD COLUMN license_certificate_no VARCHAR(100) AFTER experience;
SET @num = 1000;
UPDATE doctors 
SET license_certificate_no = CONCAT('TEMP-', @num := @num + 1) 
WHERE license_certificate_no IS NULL OR license_certificate_no = '';
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;
update doctors
set email = "akshayburande71@gmail.com" where  id = 23;
select * from patients;
ALTER TABLE doctors 
MODIFY COLUMN license_certificate_no VARCHAR(100)  UNIQUE;
ALTER TABLE patients 
DROP COLUMN name,
DROP COLUMN email,
DROP COLUMN password,
DROP COLUMN disease;
ALTER TABLE patients 
ADD COLUMN patient_name VARCHAR(100) NOT NULL,
ADD COLUMN age INT NOT NULL,
ADD COLUMN gender ENUM('Male', 'Female', 'Other') NOT NULL,
ADD COLUMN parents_name VARCHAR(100) NOT NULL,
ADD COLUMN contact_no VARCHAR(20) NOT NULL,
ADD COLUMN email VARCHAR(100) UNIQUE NOT NULL,
ADD COLUMN password VARCHAR(255) NOT NULL,
ADD COLUMN address TEXT NOT NULL,
ADD COLUMN disorder VARCHAR(100) NOT NULL;
select * from doctors;
ALTER TABLE patients 

add COLUMN patient_name varchar(100) not null after id;




select * from patients;
UPDATE doctors SET specialty = 'SLP' WHERE specialty = 'Speech-Language Pathologists';
ALTER TABLE appointments
MODIFY status ENUM('Pending', 'Approved', 'Rejected', 'Ongoing', 'Completed');
ALTER TABLE doctors
ADD COLUMN degree varchar(20),
ADD COLUMN fees varchar(20);

ALTER TABLE patients
ADD COLUMN start_session DATETIME;

ALTER TABLE patients
ADD COLUMN todays_session BOOLEAN DEFAULT FALSE;

ALTER TABLE patients
ADD COLUMN upload_plan VARCHAR(255);

CREATE TABLE sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    time_slot DATETIME NOT NULL,
    meeting_link VARCHAR(255),
    session_status VARCHAR(50) DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE therapy_plans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    file_path VARCHAR(255) NOT NULL,
    upload_status VARCHAR(50) DEFAULT 'Pending',
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

ALTER TABLE appointments

ADD COLUMN time_slot TIME;

SELECT * FROM appointments WHERE doctor_id = 17 AND status = 'Approved';
select * from doctors;
select * from appointments;
ALTER TABLE appointments
ADD COLUMN payment_status VARCHAR(20); -- Adjust the column type and length as needed

ALTER TABLE appointments
ADD COLUMN admin_message VARCHAR(20); -- Adjust the column type and length as needed



SELECT a.id, p.patient_name, p.disorder, p.email, p.contact_no, a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.id
WHERE a.doctor_id = 17 AND a.status = 'Approved';

ALTER TABLE appointments ADD COLUMN appointment_date DATETIME;
ALTER TABLE appointment_requests ADD COLUMN session_link VARCHAR(255);

CREATE TABLE appointment_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    time_slot VARCHAR(50),
    account_holder VARCHAR(255),
    transaction_id VARCHAR(255),
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    appointment_status ENUM('Pending', 'Approved', 'Declined', 'Rescheduled', 'Completed') DEFAULT 'Pending',
    admin_message TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

CREATE TABLE payment_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    transaction_id VARCHAR(255),
    amount DECIMAL(10, 2),
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    admin_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);
select * from payments;
SELECT id, patient_id, doctor_id, status 
FROM appointments 
WHERE patient_id = 11 AND status = 'Approved';

select * from therapy_plans;
CREATE TABLE therapy_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    plan_name VARCHAR(255),
    file_path VARCHAR(255),
    uploaded_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

-- Example: Adding an admin user (replace with your actual credentials)
INSERT INTO admins (username, password_hash) VALUES ('admin', 'shre');
select * from admins;
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(255) NOT NULL,
    transaction_id VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE doctors ADD COLUMN patients_allocated INT DEFAULT 0;
ALTER TABLE doctors ADD COLUMN patients_completed INT DEFAULT 0;
ALTER TABLE patients ADD COLUMN therapist_allocated INT DEFAULT 0;
ALTER TABLE patients ADD COLUMN status VARCHAR(50) DEFAULT 'Active';

-- Check therapist data
SELECT doctor_name, patients_allocated, patients_completed FROM doctors;

-- Check patient data
SELECT patient_name, therapist_allocated FROM patients;
ALTER TABLE patients MODIFY COLUMN therapist_allocated VARCHAR(255);
UPDATE doctors d
JOIN (
    SELECT therapist_allocated,  
           COUNT(*) AS total_patients,
           SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_patients
    FROM patients
    WHERE therapist_allocated IS NOT NULL
    GROUP BY therapist_allocated
) p ON BINARY d.doctor_name = BINARY p.therapist_allocated  
SET d.patients_allocated = p.total_patients,
    d.patients_completed = p.completed_patients;



UPDATE patients
SET disorder = 'Stuttering'
WHERE patient_name  = 'gogo';

UPDATE patients
SET status = 'Active'
WHERE status IS NULL;

SELECT therapist_allocated, COUNT(*) 
FROM patients 
WHERE therapist_allocated IS NOT NULL 
GROUP BY therapist_allocated;
select * from doctors;
select * from appointment_requests;

SELECT * FROM appointment_requests WHERE appointment_status = 'Doctor Approved';
SELECT * FROM appointment_requests WHERE id = 52;
DESC appointment_requests;



UPDATE doctors
SET degree = 'VETERINARY', fees = 5000
WHERE doctor_name = 'chandu bhau';
update

UPDATE patients 
SET therapist_allocated = 'Dr. Rajesh Sharma' 
WHERE therapist_allocated IS NULL;
SELECT doctor_name, patients_allocated, patients_completed FROM doctors;
SELECT DISTINCT therapist_allocated 
FROM patients
WHERE therapist_allocated NOT IN (SELECT doctor_name FROM doctors);
UPDATE patients
SET therapist_allocated = TRIM(therapist_allocated);
SELECT DISTINCT therapist_allocated FROM patients ORDER BY therapist_allocated;
SELECT DISTINCT doctor_name FROM doctors ORDER BY doctor_name;
select * from doctors;
UPDATE doctors d
JOIN (
    SELECT therapist_allocated,  
           COUNT(*) AS total_patients,
           SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_patients
    FROM patients
    WHERE therapist_allocated IS NOT NULL
    GROUP BY therapist_allocated
) p ON BINARY d.doctor_name = BINARY p.therapist_allocated  
SET d.patients_allocated = p.total_patients,
    d.patients_completed = p.completed_patients;
    
ALTER TABLE doctors MODIFY COLUMN patients_allocated INT DEFAULT 0;
ALTER TABLE doctors MODIFY COLUMN patients_completed INT DEFAULT 0;
UPDATE patients 
SET therapist_allocated = 'Dr. Rajesh Sharma' 
WHERE therapist_allocated = 'Unassigned' 
LIMIT 4;  -- Assigning only 10 for testing, remove limit if needed.

UPDATE patients 
SET status = 'Completed' 
WHERE therapist_allocated = 'Dr. Rajesh Sharma' 
LIMIT 2; -- Mark 5 patients as completed for testing

UPDATE doctors d
JOIN (
    SELECT therapist_allocated,  
           COUNT(*) AS total_patients,
           SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_patients
    FROM patients
    WHERE therapist_allocated IS NOT NULL AND therapist_allocated != 'Unassigned'
    GROUP BY therapist_allocated
) p ON BINARY d.doctor_name = BINARY p.therapist_allocated  
SET d.patients_allocated = p.total_patients,
    d.patients_completed = p.completed_patients;
    select * from doctors;
    SELECT * FROM appointment_requests ;
    update patients
    set contact_no = "8976453620" where name = ''
    ALTER TABLE appointment_requests 
ADD COLUMN default_amount DECIMAL(10,2) DEFAULT 50;
SELECT 
        d.id, 
        d.doctor_name, 
        d.fees, 
        ar.default_amount  
    FROM doctors d
    JOIN appointment_requests ar ON d.id = ar.doctor_id
    WHERE ar.patient_id = 18
    AND ar.appointment_status = 'Doctor Approved';
    select * from  patients;
    select * from doctors;
    SELECT * FROM appointment_requests ;
    create 


    ALTER TABLE appointments ADD COLUMN account_holder VARCHAR(20);
    ALTER TABLE appointment_requests 
ADD COLUMN request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
DESCRIBE appointment_requests;
SELECT id, payment_status, appointment_status 
FROM appointment_requests 
WHERE id = 4857485454;
SELECT ar.id, p.patient_name, p.email, p.disorder, ar.amount, ar.account_holder, 
       ar.transaction_id, ar.appointment_date, ar.time_slot, ar.request_time
FROM appointment_requests ar
JOIN patients p ON ar.patient_id = p.id
WHERE ar.appointment_status = 'Pending';
SELECT id, patient_id, payment_status, appointment_status
FROM appointment_requests
WHERE id = 1;
SELECT id, patient_id, doctor_id, appointment_date, time_slot, status 
FROM appointments 
WHERE doctor_id = 17 
AND DATE(appointment_date) = CURDATE()
AND status IN ('Accepted', 'Session Scheduled', 'Ongoing');
select * from doctors;
ALTER TABLE therapy_plans ADD COLUMN upload_date DATETIME;
select * from appointment_requests;
ALTER TABLE appointment_requests ADD COLUMN disorder VARCHAR(255);
ALTER TABLE appointment_requests ADD COLUMN email VARCHAR(255);
ALTER TABLE appointment_requests ADD COLUMN contact_no INT(20);
SELECT id, appointment_status FROM appointment_requests WHERE id = 3;
SELECT id, patient_id, doctor_id, appointment_date, time_slot, status 
FROM appointments 
WHERE status = 'Ongoing';
SELECT id, patient_id, doctor_id, appointment_date, time_slot, session_link, status 
FROM appointments 
WHERE status = 'Ongoing' AND patient_id = 6;
SELECT id, patient_id, doctor_id, appointment_date, time_slot, session_link, status 
FROM appointments 
WHERE status = 'Session Ready';
SELECT a.id, p.patient_name, p.disorder, p.email, p.contact_no, 
       ar.appointment_date, ar.time_slot, a.session_link, a.status 
FROM appointments a
JOIN patients p ON a.patient_id = p.id 
JOIN appointment_requests ar ON a.id = ar.id
WHERE a.status IN ('Approved', 'Rescheduled', 'Session Ready');

SELECT id, appointment_status, appointment_date, time_slot 
FROM appointment_requests 
WHERE id = 4;
ALTER TABLE appointments MODIFY COLUMN status VARCHAR(20);
ALTER TABLE appointments MODIFY COLUMN time_slot TIME;
SELECT id, appointment_status, appointment_date, time_slot FROM appointment_requests WHERE id = 3;
SELECT id, appointment_status FROM appointment_requests WHERE id = 3;
SELECT doctor_id, status, appointment_date, time_slot, id  
FROM appointments  
WHERE doctor_id = 3 
GROUP BY doctor_id, status, appointment_date, time_slot, id;
SELECT ar.id, p.patient_name, ar.appointment_date, ar.time_slot, ar.appointment_status
FROM appointment_requests ar
JOIN patients p ON ar.patient_id = p.id
WHERE ar.appointment_status = 'Doctor Pending';
SHOW COLUMNS FROM appointment_requests WHERE Field = 'time_slot';
SELECT time_slot FROM appointment_requests WHERE time_slot IS NOT NULL;
SELECT id, appointment_date, time_slot FROM appointment_requests WHERE doctor_id = 23;
CREATE TABLE appointment_requests_backup AS SELECT * FROM appointment_requests;


SELECT id, appointment_status, appointment_date, time_slot FROM appointment_requests;
SELECT * FROM appointment_requests WHERE id = 3;
ALTER TABLE appointment_requests MODIFY COLUMN appointment_status VARCHAR(50);

UPDATE appointment_requests SET appointment_status = 'Doctor Pending' WHERE id = 3;
SELECT ar.id, ar.time_slot, ar.status, p.patient_name
FROM appointment_requests ar
JOIN patients p ON ar.patient_id = p.id
WHERE ar.doctor_id = 6
  AND a.status IN ('Approved', 'Rescheduled', 'Session Ready');
  
  SELECT a.id, a.time_slot AS a_time_slot, pa.time_slot AS pa_time_slot
FROM appointments a
LEFT JOIN appointments pa ON a.patient_id = pa.patient_id AND pa.status IN ('Processed', 'Pending')
WHERE a.doctor_id = 4
  AND a.status IN ('Approved', 'Rescheduled', 'Session Ready');
  
  SELECT a.id, d.doctor_name, a.appointment_date, a.time_slot, a.session_link
FROM appointments a
JOIN doctors d ON a.doctor_id = d.id
WHERE a.patient_id = %s 
  AND a.status IN ('Ongoing', 'Completed');
  
SELECT a.id, d.doctor_name, a.appointment_date, a.time_slot, a.session_link
FROM appointments a
JOIN doctors d ON a.doctor_id = d.id
WHERE a.patient_id = 1
AND a.status IN ('Ongoing', 'Completed');
alter appointment_requests;
ALTER TABLE appointment_requests 
ALTER COLUMN appointment_date DATE;
ALTER TABLE appointment_requests 
MODIFY appointment_date DATE;
SELECT id, appointment_date, time_slot, session_link, status
FROM appointments
WHERE patient_id = 11
  AND status IN ('Ongoing', 'Completed');
SELECT id, session_link, status FROM appointments WHERE id = 45;
SELECT * FROM therapy_plans WHERE patient_id = 11;
SELECT * FROM patients WHERE id = 11;
DESC appointment_requests;


  SELECT * FROM patients WHERE id = 45;
  SELECT patient_id FROM appointments WHERE patient_id = 45;
  SELECT * FROM patients;
  SELECT * FROM appointments;
  ALTER TABLE doctors ADD COLUMN approval_status VARCHAR(20) DEFAULT 'Pending';

SELECT * FROM doctors;
SELECT * FROM doctors WHERE approval_status = 'Approved';

SELECT * FROM appointments ;
SELECT * FROM patients WHERE id = 16;
SELECT * FROM therapy_plans WHERE patient_id = 16;
SELECT d.doctor_name 
FROM appointments a 
JOIN doctors d ON a.doctor_id = d.id 
WHERE a.patient_id = 11 AND a.status = '' 
LIMIT 1;
SELECT * FROM appointments WHERE patient_id = 11;
UPDATE doctors SET approval_status = 'Approved' WHERE id IN (SELECT doctor_id FROM appointments WHERE status = 'Approved');
ALTER TABLE appointment_requests 
ADD COLUMN admin_approved_status ENUM('Pending', 'Approved', 'Declined') DEFAULT 'Pending';
UPDATE appointment_requests 
SET appointment_status = 'Pending' 
WHERE appointment_status NOT IN ('Pending', 'Approved', 'Rescheduled', 'Declined');

ALTER TABLE appointment_requests 
MODIFY COLUMN appointment_status ENUM('Pending', 'Approved', 'Rescheduled', 'Declined') DEFAULT 'Pending';
SELECT * FROM appointment_requests;
select * from patients;
SELECT id, patient_name, disorder, email, contact_no, address, request_date
    FROM appointment_requests; 
    select * from appointments;
    ALTER TABLE appointments MODIFY COLUMN appointment_date DATE;
    SELECT *
FROM appointment_requests;
ALTER TABLE transactions MODIFY COLUMN status VARCHAR(20) NOT NULL DEFAULT 'Pending';



ALTER TABLE appointment_requests ADD COLUMN request_date DATE DEFAULT NULL;
ALTER TABLE patients ADD COLUMN reset_token VARCHAR(255) DEFAULT NULL, ADD COLUMN token_expiry DATETIME DEFAULT NULL;
ALTER TABLE doctors ADD COLUMN reset_token VARCHAR(255) DEFAULT NULL, ADD COLUMN token_expiry DATETIME DEFAULT NULL;


   
    DESC appointments;
    SELECT * FROM appointment_requests WHERE appointment_status = 'Pending Admin Approval';

    ALTER TABLE appointment_requests MODIFY admin_approved_status VARCHAR(50);
    SELECT DISTINCT admin_approved_status FROM appointment_requests;
    SELECT id, admin_approved_status FROM appointment_requests;
    UPDATE appointment_requests 
SET admin_approved_status = 'Pending' 
WHERE admin_approved_status IS NULL;
ALTER TABLE appointment_requests 
MODIFY admin_approved_status VARCHAR(50) DEFAULT 'Pending';
ALTER TABLE therapy_plans
add column status varchar(50) default "Pending";
select * from therapy_plans;

    
    SELECT id, patient_id, doctor_id, appointment_status 
	FROM appointment_requests 
	WHERE doctor_id = 23 AND appointment_status = 'Approved';
    SELECT id, patient_id, doctor_id, status 
FROM therapy_plans 
WHERE doctor_id = 23 AND status = 'Pending';
SELECT 
    ar.id, 
    p.patient_name, 
    tp.status  
FROM appointment_requests ar 
JOIN patients p ON ar.patient_id = p.id  -- ✅ Join with patients table
JOIN therapy_plans tp  
    ON ar.patient_id = tp.patient_id  
    AND ar.doctor_id = tp.doctor_id  
WHERE 
    ar.doctor_id = 23  
    AND ar.appointment_status = 'Approved'  
    AND tp.status = 'Pending';
    SELECT * FROM appointment_requests WHERE doctor_id = 23 AND appointment_status = 'Approved';
SELECT 
    ar.id, 
    p.patient_name, 
    tp.status  
FROM appointment_requests ar 
JOIN patients p ON ar.patient_id = p.id  
JOIN therapy_plans tp  
    ON CAST(ar.patient_id AS CHAR) = CAST(tp.patient_id AS CHAR)  
    AND CAST(ar.doctor_id AS CHAR) = CAST(tp.doctor_id AS CHAR)  
WHERE 
    ar.doctor_id = 23  
    AND ar.appointment_status = 'Approved'  
    AND tp.status = 'Pending';
SELECT * FROM therapy_plans 
WHERE doctor_id = 23 
AND status = 'Pending';
SELECT ar.patient_id, tp.patient_id 
FROM appointment_requests ar
JOIN therapy_plans tp 
ON ar.patient_id = tp.patient_id
WHERE ar.doctor_id = 23 
AND ar.appointment_status = 'Approved'
AND tp.status = 'Pending';
SELECT ar.patient_id, ar.doctor_id 
FROM appointment_requests ar
WHERE ar.doctor_id = 23 
AND ar.appointment_status = 'Approved' 
AND NOT EXISTS (
    SELECT 1 FROM therapy_plans tp 
    WHERE tp.patient_id = ar.patient_id 
    AND tp.doctor_id = ar.doctor_id
);
ALTER TABLE appointment_requests ADD COLUMN therapy_plan_status varchar(50) DEFAULT 'Pending';






ALTER TABLE patients MODIFY contact_no VARCHAR(30);
SHOW COLUMNS FROM patients LIKE 'contact_no';
SELECT contact_no FROM patients WHERE LENGTH(contact_no) > 10 OR contact_no REGEXP '[^0-9]';
DELETE FROM patients WHERE contact_no NOT REGEXP '^[0-9]{10}$';

SHOW COLUMNS FROM patients LIKE 'contact_no';

select contact_no from patients;
SELECT contact_no FROM patients WHERE LENGTH(contact_no) > 10;
UPDATE patients 
SET contact_no = LEFT(contact_no, 10) 
WHERE LENGTH(contact_no) > 10;
UPDATE patients SET contact_no = '3349969100' WHERE id =22;
UPDATE patients SET contact_no = '4984296450' WHERE contact_no = '49498394379744964736497';
ALTER TABLE patients MODIFY COLUMN contact_no VARCHAR(15);
SHOW CREATE TABLE patients;
SELECT contact_no, LENGTH(contact_no) FROM patients;
ALTER TABLE appointment_requests MODIFY contact_no VARCHAR(15);

ALTER TABLE appointment_requests 
MODIFY COLUMN time_slot varchar(200);
select * from appointment_requests ;
select * from patients;
UPDATE appointment_requests
SET time_slot = STR_TO_DATE(time_slot, '%h:%i %p');
UPDATE appointment_requests 
SET time_slot = CASE 
    WHEN time_slot REGEXP '^[0-9]{1,2}:[0-9]{2} [APap][Mm]$'  -- Matches 12-hour format like '10:12 PM'
    THEN STR_TO_DATE(time_slot, '%h:%i %p')
    ELSE time_slot  -- Keep values already in 24-hour format
END;


desc doctors;
select * from doctors;
SELECT contact_no FROM patients WHERE contact_no NOT REGEXP '^[0-9]{10}$';
DELETE FROM patients WHERE LENGTH(contact_no) <> 10;
UPDATE patients 
SET contact_no = LPAD(FLOOR(RAND() * 10000000000), 10, '0') ;
ALTER TABLE transactions MODIFY COLUMN status VARCHAR(20) NOT NULL DEFAULT 'Pending';


SELECT * FROM patients WHERE LENGTH(contact_no) <> 10;
select * from patients;
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_id INT,
    total_fees DECIMAL(10,2),
    platform_fee DECIMAL(10,2),
    doctor_receivable DECIMAL(10,2),
    phonepe_number VARCHAR(20),
    status ENUM('Pending', 'Paid') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (appointment_id) REFERENCES appointment_requests(id)
);

ALTER TABLE transactions ADD COLUMN doctor_name VARCHAR(255) NOT NULL;


ALTER TABLE transactions ADD COLUMN doctor_name VARCHAR(255) NOT NULL;
ALTER TABLE transactions ADD COLUMN payment_date DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE transactions ADD COLUMN transaction_id VARCHAR(50) UNIQUE NOT NULL;
SELECT * FROM transactions WHERE status = 'Pending';
SELECT * FROM appointment_requests WHERE appointment_status = 'Completed';
select * from trasc; 
SHOW COLUMNS FROM appointment_requests LIKE 'payment_status';
select * from appointment_requests;























  
  




























    
    
    









