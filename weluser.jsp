<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(120deg, #3498db, #2ecc71);
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: #fff;
        }
        .container {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            animation: fadeIn 1s ease-in-out;
            width: 90%;
            max-width: 400px;
        }
        h1 {
            font-size: 2rem;
            margin-bottom: 20px;
            animation: slideDown 1s ease-in-out;
        }
        button {
            background: #2ecc71;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            color: #fff;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        button:hover {
            background: #27ae60;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        @keyframes slideDown {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        /* Responsive Design */
        @media (max-width: 600px) {
            h1 {
                font-size: 1.5rem;
            }
            button {
                font-size: 0.9rem;
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>
<%
    // Retrieve name from the session
    String name = (String) session.getAttribute("name");
    if (name == null) {
        // Redirect to login if session is invalid
        response.sendRedirect("Login page.html");
    }

    // Oracle database connection variables
    String dbURL = "jdbc:oracle:thin:@localhost:1521:xe";
    String dbUser = "system"; // Replace with your DB username
    String dbPassword = "amit1234"; // Replace with your DB password
    Connection con = null;

    try {
        // Load Oracle JDBC driver
        Class.forName("oracle.jdbc.driver.OracleDriver");
        // Connect to Oracle Database
        con = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Create a table with the name based on the session value
        Statement stmt = con.createStatement();
        String tableName = "USER_" + name.toUpperCase().replaceAll("\\s", "_");

        // SQL query to create the table
        String createTableSQL = "CREATE TABLE " + tableName + " ("
                + "ID NUMBER PRIMARY KEY, "
                + "ADDRESS VARCHAR2(255), "
                + "PASSWORD VARCHAR2(255)"
                + ")";

        // Execute the table creation SQL
        stmt.executeUpdate(createTableSQL);

        // Create sequence for auto-incrementing ID
        String createSequenceSQL = "CREATE SEQUENCE " + tableName + "_SEQ START WITH 1 INCREMENT BY 1";
        stmt.executeUpdate(createSequenceSQL);

        // Create trigger to automatically use the sequence for ID
        String createTriggerSQL = "CREATE OR REPLACE TRIGGER " + tableName + "_TRG "
                + "BEFORE INSERT ON " + tableName + " "
                + "FOR EACH ROW "
                + "BEGIN "
                + "   SELECT " + tableName + "_SEQ.NEXTVAL INTO :new.ID FROM dual; "
                + "END;";
        stmt.executeUpdate(createTriggerSQL);

        stmt.close();

%>
        <script>alert("Table, Sequence, and Trigger Created Successfully")</script>
<%
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (con != null) {
            try {
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>

<div class="container">
    <h1>Welcome, <%= name %>!</h1>
    <!-- Button to redirect to add_details.html -->
    <form action="add_details.html">
        <button type="submit">Add Address, Password</button>
    </form>
</div>
</body>
</html>
