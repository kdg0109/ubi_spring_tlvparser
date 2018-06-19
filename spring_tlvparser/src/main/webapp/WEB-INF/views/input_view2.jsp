<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="tlvparser.TLVObject" %>
    <%@ taglib prefix="c" uri= "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Input HexaString</title>
</head>

<style>
  table, th, td {
    border: 1px solid #bcbcbc;
  }
  table {
    width: 70%;
    height: 400px;
    margin: auto;
  }
  input {
    width: 100%;
    height: 100%;
  }
  
</style>

<body>
<%
	ArrayList<TLVObject> list = (ArrayList<TLVObject>) request.getAttribute("TlvList");
%>

<%
	list.size();
%>
	<%-- <table border="1">

		<%
		    for ( int i = 0; i < 8; i++ )
		    {
		%>

		<tr>

			<td><%=i + "번째 드라마"%></td>

			<td><%=8%></td>

		</tr>

		<%
		    }
		%>

	</table> --%>
</body>
</html>