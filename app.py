from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
from flask_mail import Mail, Message
from werkzeug.security import generate_password_hash, check_password_hash
from config import Config

app = Flask(__name__)
app.config.from_object(Config)

mysql = MySQL(app)
mail = Mail(app)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/services')
def services():
    return render_template('services.html')

@app.route('/contact_us')
def contact_us():
    return render_template('contact-us.html')

@app.route('/our_gallery')
def our_gallery():
    return render_template('our-gallery.html')


# Patient Signup

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        try:
            # 🟢 Debugging: Print Form Data
            print("➡️ Signup Form Submitted")
            print(request.form)

            patient_name = request.form['patient-name']
            age = request.form['age']
            gender = request.form['gender']
            parents_name = request.form['parents-name']
            contact_no = request.form['contact-no']
            email = request.form['email']
            password = request.form['password']
            address = request.form['address']
            disorder = request.form['disorder']

            # 🟢 Debugging: Check Values
            print(f"📌 Name: {patient_name}, Email: {email}, Disorder: {disorder}")

            # Hash the password before storing
            hashed_password = generate_password_hash(password)

            cur = mysql.connection.cursor()
            cur.execute("""
                INSERT INTO patients (patient_name, age, gender, parents_name, contact_no, email, password, address, disorder)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (patient_name, age, gender, parents_name, contact_no, email, hashed_password, address, disorder))

            mysql.connection.commit()
            cur.close()

            flash("✅ Signup successful! Please log in.", "success")
            print("✅ User registered successfully!")  # Debugging
            return redirect(url_for('login'))

        except Exception as e:
            print(f"❌ Error: {str(e)}")  # Debugging
            flash(f"⚠️ Error: {str(e)}", "danger")
            return redirect(url_for('signup'))

    return render_template('signup.html')


# Doctor Signup
@app.route('/doctor_signup', methods=['GET', 'POST'])
def doctor_signup():
    if request.method == 'POST':
        clinic_name = request.form['clinic_name']
        doctor_name = request.form['doctor_name']
        age = request.form['age']
        gender = request.form['gender']
        specialty = request.form['specialty']
        experience = request.form['experience']
        license_certificate_no = request.form['license_certificate_no']
        address = request.form['address']
        phone = request.form['phone']
        email = request.form['email']
        password = generate_password_hash(request.form['password'])  # Hashing Password

        try:
            cur = mysql.connection.cursor()
            cur.execute("""
                INSERT INTO doctors (clinic_name, doctor_name, age, gender, specialty, experience, license_certificate_no, address, phone, email, password) 
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (clinic_name, doctor_name, age, gender, specialty, experience, license_certificate_no, address, phone, email, password))
            mysql.connection.commit()
            cur.close()

            flash("✅ Signup Successful! Redirecting to Select Doctor...", "success")
            print("✅ Doctor registered successfully! Redirecting to login...")  # Debugging
            return redirect(url_for('doctor_login'))  # Redirect to Doctor Login Page

        except Exception as e:
            print(f"❌ Error during doctor signup: {e}")  # Debugging
            flash(f"❌ Error: {e}", "danger")
            return redirect(url_for('doctor_signup'))  # Redirect back to signup page on error

    return render_template('doctor_signup.html')




@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM patients WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()

        if user:
            stored_password = user[7]  # Assuming the password is in the 7th column (index 6)
            
            if check_password_hash(stored_password, password):  # Validate password
                session['loggedin'] = True  # Set session variable
                session['role'] = 'patient'  # Set role
                session['user_id'] = user[0]  # Store user ID in session
                session['user_name'] = user[1]  # Store username for display
                session['email'] = email  # Store email in session

                flash("✅ Login successful!", "success")
                print("✅ Login successful! Redirecting to select_doctor...")  # Debugging
                return redirect(url_for('select_doctor'))  # Redirect to Select Doctor Page
            
            else:
                flash("⚠️ Incorrect password. Try again!", "danger")
        else:
            flash("⚠️ Email not found. Please sign up!", "danger")

    return render_template('login.html')  # Reload login page if login fails



@app.route('/doctor_login', methods=['GET', 'POST'])
def doctor_login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM doctors WHERE email = %s", (email,))
        doctor = cur.fetchone()
        cur.close()

        if doctor:
            stored_password = doctor[11]  # Assuming password is the 12th column (index 11)
            
            # Debugging: Print stored and entered passwords
            print(f"✅ Doctor Found: {doctor}")
            print(f"🔍 Stored Password: {stored_password}")
            print(f"🔍 Entered Password: {password}")

            if stored_password and check_password_hash(stored_password, password):  # Validate password
                session['loggedin'] = True
                session['email'] = email
                session['role'] = 'doctor'
                print("✅ Login Successful!")  # Debugging
                return redirect(url_for('doctor_dashboard'))
            else:
                print("❌ Invalid Password")  # Debugging
                flash('Invalid password. Please try again.', 'danger')
        else:
            print("❌ Doctor Not Found")  # Debugging
            flash('Doctor not found. Please sign up.', 'danger')

    return render_template('doctor_login.html')




# Select Doctor Based on Disorder
@app.route('/select_doctor', methods=['GET'])
def select_doctor():
    if 'loggedin' not in session or session['role'] != 'patient':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    
    # 🔹 Get the patient's disorder
    cur.execute("SELECT disorder FROM patients WHERE email = %s", (session['email'],))
    patient_disease = cur.fetchone()

    # Mapping of disorders to specialist doctors (aligned with DB entries)
    disorder_to_specialist = {
        "Stuttering": ["Speech-Language Pathologist (SLP)"],
        "Voice Disorder": ["Otolaryngologist (ENT Specialist)", "ENT"],
        "Neurological Speech Issue": ["Neurologist"],
        "Pediatric Speech Delay": ["Pediatrician", "Developmental Pediatrician"],
        "Autism Communication Issue": ["Psychiatrist"],
        "Post-Surgery Recovery": ["Rehabilitation Specialist"],
        "Hearing and Speech Issue": ["Audiologist"],
    }

    doctors = []

    if patient_disease:
        disorder = patient_disease[0]

        # 🔹 Get the relevant specialties for the disorder
        relevant_specialties = disorder_to_specialist.get(disorder, [])

        if relevant_specialties:
            # 🔹 Use SQL IN clause to fetch doctors matching any relevant specialty
            format_strings = ','.join(['%s'] * len(relevant_specialties))
            cur.execute(f"SELECT id, doctor_name, specialty, experience, phone FROM doctors WHERE specialty IN ({format_strings})", tuple(relevant_specialties))
            doctors = cur.fetchall()

    cur.close()

    return render_template('select_doctor.html', doctors=doctors)



# Request Appointment
@app.route('/request_appointment/<int:doctor_id>', methods=['POST'])
def request_appointment(doctor_id):
    if 'loggedin' not in session or session['role'] != 'patient':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    
    # 🔹 Fetch patient details
    cur.execute("SELECT id, patient_name FROM patients WHERE email = %s", (session['email'],))
    patient = cur.fetchone()
    
    # 🔹 Fetch doctor details (including email)
    cur.execute("SELECT doctor_name, email FROM doctors WHERE id = %s", (doctor_id,))
    doctor = cur.fetchone()

    if patient and doctor:
        patient_id = patient[0]
        patient_name = patient[1]
        doctor_name = doctor[0]
        doctor_email = doctor[1]  # 🔹 Fetch email dynamically from DB

        # 🔹 Insert the appointment with a "Pending" status
        cur.execute("INSERT INTO appointments (patient_id, doctor_id, status) VALUES (%s, %s, 'Pending')",
                    (patient_id, doctor_id))
        mysql.connection.commit()

        # 🔹 Send email to the doctor
        msg = Message("New Appointment Request",
                      sender="vinaykakad56@gmail.com",
                      recipients=[doctor_email])  # 🔹 Automatically fetched email
        msg.body = f"Dear Dr. {doctor_name},\n\nYou have received a new appointment request from {patient_name}.\n\nPlease log in to your dashboard to respond.\n\nBest Regards,\nTherapyTalk Team"

        try:
            mail.send(msg)
            flash('Appointment request sent! The doctor has been notified via email.', 'success')
        except Exception as e:
            flash(f'Appointment requested, but email could not be sent: {str(e)}', 'warning')

    cur.close()
    return redirect(url_for('patient_dashboard'))


# Patient Dashboard
@app.route('/patient_dashboard')
def patient_dashboard():
    if 'loggedin' not in session or session['role'] != 'patient':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    # Fetch patient ID
    cur.execute("SELECT id, patient_name FROM patients WHERE email = %s", (session['email'],))
    patient = cur.fetchone()

    if not patient:
        flash("Patient not found!", "danger")
        return redirect(url_for('login'))

    patient_id = patient[0]
    patient_name = patient[1]

    print(f"DEBUG: Logged-in Patient ID = {patient_id}")  # Debugging

    # Fetch appointment statistics
    cur.execute("SELECT COUNT(*) FROM appointments WHERE patient_id = %s", (patient_id,))
    total_requests = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM appointments WHERE patient_id = %s AND status = 'Approved'", (patient_id,))
    approved_requests = cur.fetchone()[0]

    cur.execute("SELECT COUNT(*) FROM appointments WHERE patient_id = %s AND status = 'Pending'", (patient_id,))
    pending_requests = cur.fetchone()[0]

    # Fetch appointments
    cur.execute("""
        SELECT a.id, d.doctor_name, d.specialty, a.status 
        FROM appointments a 
        JOIN doctors d ON a.doctor_id = d.id 
        WHERE a.patient_id = %s
    """, (patient_id,))
    appointments = cur.fetchall()
    cur.close()

    print(f"DEBUG: Retrieved appointments = {appointments}")  # Debugging

    if not appointments:
        flash("No appointments found!", "warning")

    return render_template(
        'patient_dashboard.html',
        patient_name=patient_name,
        total_requests=total_requests,
        approved_requests=approved_requests,
        pending_requests=pending_requests,
        appointments=appointments
    )
from flask_mail import Message

@app.route('/accept_appointment/<int:appointment_id>', methods=['POST'])
def accept_appointment(appointment_id):
    if 'loggedin' not in session or session['role'] != 'doctor':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    try:
        # Update the appointment status to "Approved"
        cur.execute("UPDATE appointments SET status = 'Approved' WHERE id = %s", (appointment_id,))
        mysql.connection.commit()

        # Fetch appointment details
        cur.execute("""
            SELECT p.patient_name, p.email, d.doctor_name, d.specialty 
            FROM appointments a 
            JOIN patients p ON a.patient_id = p.id 
            JOIN doctors d ON a.doctor_id = d.id 
            WHERE a.id = %s
        """, (appointment_id,))
        appointment_details = cur.fetchone()

        if appointment_details:
            patient_name, patient_email, doctor_name, specialty = appointment_details

            # Send email to the patient
            msg = Message(
                subject="Appointment Approved - TherapyTalk",
                sender="vinaykakad56@gmail.com",  # Replace with your email
                recipients=[patient_email]
            )
            msg.body = f"""
            Dear {patient_name},

            Your appointment request with Dr. {doctor_name} ({specialty}) has been approved.

            Appointment Details:
            - Doctor: Dr. {doctor_name}
            - Specialty: {specialty}
            - Status: Approved

            Please log in to your TherapyTalk account for further details.

            Best Regards,
            TherapyTalk Team
            """
            mail.send(msg)

            flash("Appointment approved and patient notified via email.", "success")
        else:
            flash("Appointment not found.", "danger")

    except Exception as e:
        print(f"Error: {e}")
        flash("An error occurred while processing your request.", "danger")

    finally:
        cur.close()

    return redirect(url_for('doctor_dashboard'))

@app.route('/reject_appointment/<int:appointment_id>', methods=['POST'])
def reject_appointment(appointment_id):
    if 'loggedin' not in session or session['role'] != 'doctor':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    try:
        # Update the appointment status to "Rejected"
        cur.execute("UPDATE appointments SET status = 'Rejected' WHERE id = %s", (appointment_id,))
        mysql.connection.commit()

        # Fetch appointment details
        cur.execute("""
            SELECT p.patient_name, p.email, d.doctor_name, d.specialty 
            FROM appointments a 
            JOIN patients p ON a.patient_id = p.id 
            JOIN doctors d ON a.doctor_id = d.id 
            WHERE a.id = %s
        """, (appointment_id,))
        appointment_details = cur.fetchone()

        if appointment_details:
            patient_name, patient_email, doctor_name, specialty = appointment_details

            # Send email to the patient
            msg = Message(
                subject="Appointment Rejected - TherapyTalk",
                sender="tanviikarale17@gmail.com",
                recipients=[patient_email]
            )
            msg.body = f"""
            Dear {patient_name},

            We regret to inform you that your appointment request with Dr. {doctor_name} ({specialty}) has been rejected.

            Appointment Details:
            - Doctor: Dr. {doctor_name}
            - Specialty: {specialty}
            - Status: Rejected

            Please log in to your TherapyTalk account to request another appointment.

            Best Regards,
            TherapyTalk Team
            """
            mail.send(msg)

            flash("Appointment rejected and patient notified via email.", "success")
        else:
            flash("Appointment not found.", "danger")

    except Exception as e:
        print(f"Error: {e}")
        flash("An error occurred while processing your request.", "danger")

    finally:
        cur.close()

    return redirect(url_for('doctor_dashboard'))

@app.route('/test')
def test():
    return render_template('test.html')

# Doctor Dashboard
@app.route('/doctor_dashboard')
def doctor_dashboard():
    if 'loggedin' not in session or session['role'] != 'doctor':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    # Fetch Therapist Information
    cur.execute("SELECT doctor_name, specialty FROM doctors WHERE email = %s", (session['email'],))
    therapist_info = cur.fetchone()

    # Fetch Patient Activity
    cur.execute("""
        SELECT 
            COUNT(*) AS total_requests,
            SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END) AS approved_requests,
            SUM(CASE WHEN status = 'Ongoing' THEN 1 ELSE 0 END) AS active_patients,
            SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_cases
        FROM appointments 
        WHERE doctor_id = (SELECT id FROM doctors WHERE email = %s)
    """, (session['email'],))
    patient_activity = cur.fetchone()

    # Fetch Pending Approvals
    # Fetch Pending Approvals
    cur.execute("""
        SELECT a.id, p.patient_name, p.address, p.disorder, p.contact_no, p.email, a.status 
        FROM appointments a 
        JOIN patients p ON a.patient_id = p.id 
        WHERE a.doctor_id = (SELECT id FROM doctors WHERE email = %s) AND a.status = 'Pending'
        """, (session['email'],))
    pending_approvals = cur.fetchall()

    # Fetch Active Patients
    cur.execute("""
        SELECT a.id, p.patient_name, p.disorder, a.status 
        FROM appointments a 
        JOIN patients p ON a.patient_id = p.id 
        WHERE a.doctor_id = (SELECT id FROM doctors WHERE email = %s) AND a.status = 'Ongoing'
    """, (session['email'],))
    active_patients = cur.fetchall()

    # Fetch Successfully Completed Therapy Cases
    cur.execute("""
        SELECT a.id, p.patient_name, p.disorder, a.status 
        FROM appointments a 
        JOIN patients p ON a.patient_id = p.id 
        WHERE a.doctor_id = (SELECT id FROM doctors WHERE email = %s) AND a.status = 'Completed'
    """, (session['email'],))
    completed_cases = cur.fetchall()

    cur.close()

    return render_template(
        'doctor_dashboard.html',
        therapist_info=therapist_info,
        patient_activity=patient_activity,
        pending_approvals=pending_approvals,
        active_patients=active_patients,
        completed_cases=completed_cases
    )

if __name__ == '__main__':
    app.run(debug=True)
