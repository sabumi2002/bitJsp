<%@ page import="connector.MySqlConnectionMaker" %>
<%@ page import="controller.UserController" %>
<%@ page import="connector.ConnectionMaker" %>
<%@ page import="model.UserDTO" %><%--
  Created by IntelliJ IDEA.
  User: Sabeom
  Date: 2023-02-10
  Time: 오전 10:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>로그인</title>
</head>
<body>
<%
    ConnectionMaker connectionMaker = new MySqlConnectionMaker();
    UserController userController = new UserController(connectionMaker);

    String username = request.getParameter("username"); // form 밑 input태그 name을 가져옴
    String password = request.getParameter("password"); // form 안에 name 이 password인것을 가져옴

    UserDTO userDTO = userController.auth(username, password);

    String address;
    if(userDTO == null){
        address = "/index.jsp";
    }else{
        address = "/board/printList.jsp";
        session.setAttribute("logIn", userDTO); // 세션에 로그인객체 저장
    }

    response.sendRedirect(address); // 입력한 url로 이동.
%>
</body>
</html>
