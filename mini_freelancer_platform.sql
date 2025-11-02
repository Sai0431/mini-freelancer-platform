-- Create Database
CREATE DATABASE mini_freelancer_platform;
USE mini_freelancer_platform;

-- 1. students table
CREATE TABLE students (
    stu_id INT PRIMARY KEY AUTO_INCREMENT,
    stu_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    skills VARCHAR(255),
    description TEXT
);

-- 2. clients table
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    contact_no VARCHAR(15)
);

-- 3. projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    budget DECIMAL(10,2),
    deadline DATE,
    required_skills VARCHAR(255),
    status ENUM('Open', 'Assigned', 'Completed') DEFAULT 'Open',
    assigned_to INT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES students(stu_id) ON DELETE SET NULL
);

-- 4. applications table
CREATE TABLE applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    stu_id INT,
    cover_letter TEXT,
    application_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (stu_id) REFERENCES students(stu_id) ON DELETE CASCADE
);

-- 5. skills table (optional)
CREATE TABLE skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) NOT NULL,
    category VARCHAR(100)
);

-- Students
INSERT INTO students VALUES
(1, 'Vaishnavi Sable', 'vaish@gmail.com', 'pass123', 'Java,Python', 'Passionate about coding'),
(2, 'Rajesh Kumar', 'rajesh@gmail.com', 'rajesh2025', 'React,Node.js', 'Web developer'),
(3, 'Priya Singh', 'priya@gmail.com', 'priya321', 'Java,SQL', 'Interested in DBMS'),
(4, 'Ankit Sharma', 'ankit@gmail.com', 'ankit001', 'Python,ML', 'AI enthusiast'),
(5, 'Sneha Patil', 'sneha@gmail.com', 'sneha789', 'JavaScript,HTML,CSS', 'Frontend developer'),
(6, 'Rohit Mehta', 'rohit@gmail.com', 'rohit555', 'Java,Spring', 'Backend developer'),
(7, 'Aisha Khan', 'aisha@gmail.com', 'aisha123', 'Python,Data Analysis', 'Loves data visualization'),
(8, 'Karan Verma', 'karan@gmail.com', 'karan111', 'C++,Java', 'Algorithm enthusiast'),
(9, 'Meera Joshi', 'meera@gmail.com', 'meera456', 'ML,Python', 'AI/ML student'),
(10, 'Arjun Reddy', 'arjun@gmail.com', 'arjun789', 'React,Node.js', 'Full-stack developer'),
(11, 'Nisha Gupta', 'nisha@gmail.com', 'nisha007', 'Java,Android', 'Mobile app developer'),
(12, 'Sameer Bhatia', 'sameer@gmail.com', 'sameer123', 'Python,Django', 'Web app developer'),
(13, 'Tanya Roy', 'tanya@gmail.com', 'tanya321', 'C,Python', 'Embedded systems enthusiast'),
(14, 'Devansh Malhotra', 'devansh@gmail.com', 'devansh101', 'SQL,Data Analysis', 'Data enthusiast'),
(15, 'Ritu Agarwal', 'ritu@gmail.com', 'ritu2025', 'HTML,CSS,JS', 'UI/UX designer');

-- Clients
INSERT INTO clients VALUES
(1, 'TechCorp', 'info@techcorp.com', 'tc123', '9876543210'),
(2, 'Innovatech', 'hello@innovatech.com', 'inno2025', '9123456780'),
(3, 'WebSolutions', 'contact@websolutions.com', 'web789', '9988776655'),
(4, 'Alpha Systems', 'alpha@alphasys.com', 'alpha321', '9871234560'),
(5, 'BetaSoft', 'beta@betasoft.com', 'beta111', '9765432109'),
(6, 'SmartTech', 'smart@smarttech.com', 'smart2025', '9456781230'),
(7, 'CodeCrafters', 'code@codecrafters.com', 'code007', '9321456780'),
(8, 'DigiSolutions', 'info@digisol.com', 'digi101', '9898989898'),
(9, 'NextGen Tech', 'contact@nextgen.com', 'next2025', '9012345678'),
(10, 'FutureSoft', 'hello@futuresoft.com', 'fut123', '9234567890'),
(11, 'AppMasters', 'app@appmasters.com', 'app321', '9345678901'),
(12, 'NetInnovators', 'info@netinnovators.com', 'net111', '9456789012'),
(13, 'CloudSolutions', 'cloud@cloudsol.com', 'cloud2025', '9567890123'),
(14, 'DigitalHub', 'hub@digitalhub.com', 'hub123', '9678901234'),
(15, 'NextWave', 'contact@nextwave.com', 'wave321', '9789012345');

-- Skills
INSERT INTO skills VALUES
(1, 'Java', 'Programming'),
(2, 'Python', 'Programming'),
(3, 'C++', 'Programming'),
(4, 'React', 'Web Development'),
(5, 'Node.js', 'Web Development'),
(6, 'HTML', 'Web Development'),
(7, 'CSS', 'Web Development'),
(8, 'SQL', 'Database'),
(9, 'ML', 'AI/ML'),
(10, 'Data Analysis', 'AI/ML'),
(11, 'Spring', 'Backend'),
(12, 'Django', 'Backend'),
(13, 'Android', 'Mobile Development'),
(14, 'JavaScript', 'Web Development'),
(15, 'UI/UX', 'Design');

-- Projects
INSERT INTO projects VALUES
(1, 1, 'AI Chatbot', 'Develop AI Chatbot', 50000, '2025-12-31', 'Python,ML', 'Open', NULL),
(2, 2, 'E-commerce Website', 'Build E-commerce platform', 75000, '2025-11-30', 'React,Node.js', 'Open', NULL),
(3, 3, 'Mobile App', 'Create Android app', 40000, '2025-10-31', 'Java,Android', 'Open', NULL),
(4, 4, 'Data Analytics', 'Analyze sales data', 30000, '2025-09-30', 'Python,Data Analysis', 'Open', NULL),
(5, 5, 'Portfolio Website', 'Develop portfolio site', 20000, '2025-10-15', 'HTML,CSS,JS', 'Open', NULL),
(6, 6, 'Backend API', 'Create REST API', 45000, '2025-12-15', 'Java,Spring', 'Open', NULL),
(7, 7, 'Machine Learning Model', 'Predict customer behavior', 60000, '2025-11-15', 'Python,ML', 'Open', NULL),
(8, 8, 'UI Redesign', 'Redesign web UI', 25000, '2025-10-25', 'UI/UX,HTML,CSS', 'Open', NULL),
(9, 9, 'Database Optimization', 'Optimize DB queries', 35000, '2025-11-05', 'SQL', 'Open', NULL),
(10, 10, 'IoT Device Integration', 'Connect devices to cloud', 55000, '2025-12-01', 'Python,C++', 'Open', NULL),
(11, 11, 'Chat App', 'Build real-time chat app', 40000, '2025-12-20', 'React,Node.js', 'Open', NULL),
(12, 12, 'Stock Prediction', 'Predict stock prices', 70000, '2025-12-31', 'Python,ML', 'Open', NULL),
(13, 13, 'Website Maintenance', 'Maintain company website', 20000, '2025-10-31', 'HTML,CSS,JS', 'Open', NULL),
(14, 14, 'Data Dashboard', 'Build dashboard for sales', 50000, '2025-11-20', 'Python,Data Analysis', 'Open', NULL),
(15, 15, 'API Integration', 'Integrate external APIs', 45000, '2025-12-10', 'Node.js,React', 'Open', NULL);

-- Applications
INSERT INTO applications VALUES
(1, 1, 4, 'I can build the AI model efficiently', '2025-10-01', 'Pending'),
(2, 2, 2, 'Experienced in full-stack development', '2025-10-02', 'Pending'),
(3, 3, 11, 'Expert in Android app development', '2025-10-03', 'Pending'),
(4, 4, 7, 'Can analyze data and visualize results', '2025-10-04', 'Pending'),
(5, 5, 15, 'Can design modern UI/UX', '2025-10-05', 'Pending'),
(6, 6, 6, 'Backend development expertise', '2025-10-06', 'Pending'),
(7, 7, 9, 'Strong in ML modeling', '2025-10-07', 'Pending'),
(8, 8, 15, 'UI redesign experience', '2025-10-08', 'Pending'),
(9, 9, 3, 'SQL optimization expert', '2025-10-09', 'Pending'),
(10, 10, 8, 'IoT integration experience', '2025-10-10', 'Pending'),
(11, 11, 2, 'Full-stack chat app experience', '2025-10-11', 'Pending'),
(12, 12, 4, 'Stock prediction with ML', '2025-10-12', 'Pending'),
(13, 13, 15, 'Website maintenance experience', '2025-10-13', 'Pending'),
(14, 14, 7, 'Data dashboard development', '2025-10-14', 'Pending'),
(15, 15, 2, 'API integration experience', '2025-10-15', 'Pending');
