<%@ page import="businessObjects.UserHandler" %>
<%@ page import="ui.UserInfo" %>
<%@ page import="ui.BookInfo" %>
<%@ page import="businessObjects.BookHandler" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Collection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello Betty!" %>
</h1>
<br/>
<a href="hello-servlet">Hello Servlet</a>
<% UserInfo user = UserHandler.getUserByEmail("poriazov@kth.se");%>
<%= user.getName() %>

<% BookInfo book = BookHandler.getBookByISBN("9781451690316");%>
<%= book.getTitle() %>

<% Collection<BookInfo> books = BookHandler.getAllBooks();
    Iterator<BookInfo> it = books.iterator();
    for (; it.hasNext();) {
        BookInfo b = it.next();%>
        <%= b.getTitle()%>
    <%}%>
</body>
</html>