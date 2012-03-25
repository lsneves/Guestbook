<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="guestbook.PMF" %>

<html>
  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>
  <body>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
%>
<p>Olá, <%= user.getNickname() %>! (Você pode
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">se deslogar</a>.)</p>
<%
    } else {
%>
<p>Olá seu otário!!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Faça o Login</a>
para incluir o seu login e eu saber quem postou aqui, para nossa alegria =)</p>
<%
    }
%>

<%
    PersistenceManager pm = PMF.get().getPersistenceManager();
    String query = "select from " + Greeting.class.getName() + " order by date desc range 0,5";
    List<Greeting> greetings = (List<Greeting>) pm.newQuery(query).execute();
    if (greetings.isEmpty()) {
%>
<p>The guestbook has no messages.</p>
<%
    } else {
        for (Greeting g : greetings) {
            if (g.getAuthor() == null) {
%>
<p>O imbecil anonimo escreveu:</p>
<%
            } else {
%>
<p><b><%= g.getAuthor().getNickname() %></b> wrote:</p>
<%
            }
%>
<blockquote><%= g.getContent() %></blockquote>
<%
        }
    }
    pm.close();
%>

	<form action="/sign" method="post">
    	<div><textarea name="content" rows="3" cols="60"></textarea></div>
    	<div><input type="submit" value="Posta ae =)" /></div>
  	</form>
  </body>
</html>