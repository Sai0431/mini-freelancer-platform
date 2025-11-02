from flask import Flask, render_template, request, redirect, url_for, session, flash
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# MySQL connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="mini_freelancer_platform"
)

cursor = db.cursor(dictionary=True)

@app.route('/student_register', methods=['GET', 'POST'])
def student_register():
    if request.method == 'POST':
        stu_name = request.form['stu_name']
        email = request.form['email']
        password = request.form['password']
        skills = request.form['skills']
        description = request.form['description']

        # Check if email exists
        cursor.execute("SELECT * FROM students WHERE email=%s", (email,))
        existing = cursor.fetchone()
        if existing:
            return "Email already registered!"

        # Insert new student
        cursor.execute(
            "INSERT INTO students (stu_name, email, password, skills, description) VALUES (%s, %s, %s, %s, %s)",
            (stu_name, email, password, skills, description)
        )
        db.commit()
        return "Registration successful!"

    return render_template('student_register.html')

@app.route('/apply_project/<int:project_id>', methods=['POST'])
def apply_project(project_id):
    if 'stu_id' not in session:
        return redirect(url_for('login'))

    stu_id = session['stu_id']

    # Check if already applied
    cursor.execute("SELECT * FROM applications WHERE stu_id = %s AND project_id = %s", (stu_id, project_id))
    existing = cursor.fetchone()
    if existing:
        flash("You have already applied for this project.")
        return redirect(url_for('student_dashboard'))

    # Insert application
    cursor.execute(
        "INSERT INTO applications (stu_id, project_id, status) VALUES (%s, %s, %s)",
        (stu_id, project_id, 'Pending')
    )
    db.commit()

    flash("Application submitted successfully!")
    return redirect(url_for('student_dashboard'))

@app.route('/client_register', methods=['GET', 'POST'])
def client_register():
    if request.method == 'POST':
        client_name = request.form['client_name']
        email = request.form['email']
        password = request.form['password']
        contact_no = request.form['contact_no']

        cursor.execute("SELECT * FROM clients WHERE email=%s", (email,))
        existing = cursor.fetchone()
        if existing:
            return "Email already registered!"

        cursor.execute(
            "INSERT INTO clients (client_name, email, password, contact_no) VALUES (%s, %s, %s, %s)",
            (client_name, email, password, contact_no)
        )
        db.commit()
        return "Registration successful!"

    return render_template('client_register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user_type = request.form['user_type']

        if user_type == 'student':
            cursor.execute("SELECT * FROM students WHERE email = %s AND password = %s", (email, password))
            student = cursor.fetchone()
            if student:
                session['stu_id'] = student['stu_id']
                return redirect('/student_dashboard')
            else:
                return "Invalid student credentials"
        
        elif user_type == 'client':
            cursor.execute("SELECT * FROM clients WHERE email = %s AND password = %s", (email, password))
            client = cursor.fetchone()
            if client:
                session['client_id'] = client['client_id']
                return redirect('/client_dashboard')  # You can make this later
            else:
                return "Invalid client credentials"
    return render_template('login.html')

@app.route('/student_dashboard')
def student_dashboard():
    # Check if student is logged in
    if 'stu_id' not in session:
        return redirect('/login')
    
    stu_id = session['stu_id']

    # Get student details
    cursor.execute("SELECT * FROM students WHERE stu_id = %s", (stu_id,))
    student = cursor.fetchone()

    # Get all available projects
    cursor.execute("SELECT * FROM projects WHERE status = 'open'")
    projects = cursor.fetchall()

    # Get all projects student has applied to
    cursor.execute("SELECT project_id FROM applications WHERE stu_id = %s", (stu_id,))
    applied_projects = [row['project_id'] for row in cursor.fetchall()]


    return render_template('student_dashboard.html', student=student, projects=projects, applied_projects=applied_projects)

@app.route('/client_dashboard')
def client_dashboard():
    if 'client_id' not in session:
        return redirect(url_for('login'))

    client_id = session['client_id']

    # Get client details
    cursor.execute("SELECT * FROM clients WHERE client_id = %s", (client_id,))
    client = cursor.fetchone()

    # Get all projects posted by this client
    cursor.execute("SELECT * FROM projects WHERE client_id = %s", (client_id,))
    projects = cursor.fetchall()

    # For each project, get the number of applicants AND applicant details
    for project in projects:
        # Count total applicants
        cursor.execute("SELECT COUNT(*) AS count FROM applications WHERE project_id = %s", (project['project_id'],))
        result = cursor.fetchone()
        project['applicant_count'] = result['count'] if result else 0

        # Get applicants details
        cursor.execute("""
            SELECT a.application_id, a.status, s.stu_name, s.email
            FROM applications a
            JOIN students s ON a.stu_id = s.stu_id
            WHERE a.project_id = %s
        """, (project['project_id'],))
        project['applications'] = cursor.fetchall()

    return render_template('client_dashboard.html', client=client, projects=projects)


@app.route('/view_applicants/<int:project_id>')
def view_applicants(project_id):
    if 'client_id' not in session:
        return redirect(url_for('login'))

    # Get project details
    cursor.execute("SELECT * FROM projects WHERE project_id = %s", (project_id,))
    project = cursor.fetchone()

    # Get all applicants with application_id
    cursor.execute("""
        SELECT a.application_id, a.status, s.stu_name, s.email, s.skills, s.description
        FROM applications a
        JOIN students s ON a.stu_id = s.stu_id
        WHERE a.project_id = %s
    """, (project_id,))
    applicants = cursor.fetchall()

    return render_template('view_applicants.html', project=project, applicants=applicants)


@app.route('/update_application_status/<int:application_id>', methods=['POST'])
def update_application_status(application_id):
    if 'client_id' not in session:
        return redirect(url_for('login'))

    new_status = request.form['status']
    cursor.execute("UPDATE applications SET status = %s WHERE application_id = %s", (new_status, application_id))
    db.commit()

    # Get the project_id of this application to redirect back
    cursor.execute("SELECT project_id FROM applications WHERE application_id = %s", (application_id,))
    project_id = cursor.fetchone()['project_id']

    flash(f"Application {new_status.lower()} successfully!", "success")
    return redirect(url_for('view_applicants', project_id=project_id))


@app.route('/post_project', methods=['GET', 'POST'])
def post_project():
    if 'client_id' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        title = request.form['title']
        description = request.form['description']
        required_skills = request.form['required_skills']
        budget = request.form['budget']
        deadline = request.form['deadline']
        client_id = session['client_id']

        cursor.execute(
            "INSERT INTO projects (title, description, required_skills, budget, deadline, client_id, status) VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (title, description, required_skills, budget, deadline, client_id, 'Open')
        )
        db.commit()

        return redirect(url_for('client_dashboard'))

    return render_template('post_project.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/login')


@app.route('/dashboard')
def dashboard():
    if 'user' not in session:
        return redirect(url_for('login'))

    return f"Welcome {session['user']['stu_name'] if session['user_type']=='student' else session['user']['client_name']}!"


if __name__ == '__main__':
    app.run(debug=True)
