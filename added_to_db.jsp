<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Save Address and Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            color: #333;
        }
        .container {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 90%;
            max-width: 400px;
        }
        h2 {
            color: #4CAF50;
        }
        .message {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<%
    // Retrieve session attributes
    String name = (String) session.getAttribute("name");
    String address = request.getParameter("address");
    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String note = request.getParameter("note");

    if (name != null && address != null && password != null) {
        // Database connection variables
        String dbURL = "jdbc:oracle:thin:@localhost:1521:xe";
        String dbUser = "system"; // Replace with your DB username
        String dbPassword = "amit1234"; // Replace with your DB password
        Connection con = null;

        try {
            // Load Oracle JDBC driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            // Connect to the Oracle database
            con = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Create a table name dynamically based on the session 'name' attribute
            String tableName = "USER_" + name.toUpperCase().replaceAll("\\s", "_");

            // SQL query to insert data into the dynamically created table
            String sql = "INSERT INTO " + tableName + " (ADDRESS, PASSWORD, ID, NOTE) VALUES (?, ?, ?, ?)";
            
            // Prepare the statement
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, address);
            ps.setString(2, password);
            ps.setString(3, id);
            ps.setString(4, note);

            // Execute the insert statement
            int result = ps.executeUpdate();

            if (result > 0) {
                out.println("<div class='container'><h2>Details Added Successfully!</h2>");
                out.println("<p>Your address and password have been successfully added.</p>");
                out.println("<a href='weluser.jsp'>Go to Dashboard</a></div>");
            } else {
                out.println("<div class='container'><h2>Error</h2>");
                out.println("<p>Something went wrong while saving the details.</p></div>");
            }

            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='container'><h2>Error</h2>");
            out.println("<p>There was an error processing your request: " + e.getMessage() + "</p></div>");
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    } else {
        out.println("<div class='container'><h2>Error</h2>");
        out.println("<p>Please make sure all fields are filled correctly and try again.</p></div>");
    }
%>

</body>
</html>
