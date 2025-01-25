<%-- 
    Document   : adminlogin
    Created on : 7 Aug, 2024, 7:08:41 PM
    Author     : ASUS
--%>

<%@page import="java.net.URLEncoder"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Authentication</title>
    </head>
    <body>
         <%@page import="java.sql.DriverManager" %>
        <%@page import="java.sql.ResultSet" %>
        <%@page import="java.sql.Statement" %>
        <%@page import="java.sql.Connection" %>
        <%@page import="java.sql.*,java.util.*" %>
        
        <%
            try {
                String un = request.getParameter("user");
                String pd = request.getParameter("pass");

                Class.forName("oracle.jdbc.driver.OracleDriver");

                Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "amit1234");
                PreparedStatement ps = con.prepareStatement("select * from auth where email=? and password=?");
                ps.setString(1, un);
                ps.setString(2, pd);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    // Login Successfully
                     String name=rs.getString("name");
                     session.setAttribute("name", name);     // Store the name in the session
                     response.sendRedirect("weluser.jsp");
                     
                             
                } else {   
                    // out.println("SORRY YOU GIVE WRONG PASSWORD");
                    
                    %><script>
                        alert("Invalid Username or Password");
                        window.location.href = "Login page.html";
                    </script>
                    <%}
            } catch (Exception e) {
                e.printStackTrace();
                %><script>
                        alert("Execution Fail, Check Try() Block");
                        window.location.href = "Login page.html";
                    </script>
                    <%
            }%>
    </body>
</html>
