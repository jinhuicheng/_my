<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.packtpub.felix.bookshelf.webapp.beans.SessionBean"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta http-equiv="Cache-Control" content="no-store" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<title>osgi web app</title>
</head>
<body>
<h1>osgi web app</h1>

<%
	SessionBean sessionBean = new SessionBean();
	sessionBean.initialize(application);
%>
<div>书列表
<ul>
	<%
		for (String isbn : sessionBean.getBookshelf().searchBooksByAuthor(
				sessionBean.getSessionId(), "%")) {
	%>
	<li>
	<%= sessionBean.getBookshelf().getBook(sessionBean.getSessionId(), isbn)%>
	</li>
	<%
		}
	%>
</ul>
</div>
</body>

</html>