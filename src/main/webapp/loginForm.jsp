<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// session 유효성 검증 코드
	request.setCharacterEncoding("utf-8");
	String msg = request.getParameter("msg");
	
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath()+"/empList.jsp");
		System.out.println("로그인중");
		return;
	}
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>로그인</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			body {
				padding:1.5em;
				background: #f5f5f5
			}
			table {
			 	border: 1px #a39485 solid;
				font-size: .9em;
				box-shadow: 0 2px 5px rgba(0,0,0,.25);
				
				border-collapse: collapse;
				border-radius: 5px;
				overflow: hidden;
				text-align:center;
			}
			a {
				text-decoration: none;
			}
			input {
				font-size: 15px;
				border: 0;
				border-radius: 15px;
				outline: none;
				padding-left: 10px;
				background-color: rgb(233, 233, 233);
				width: 100%;
			}
		</style>
		<script type="text/javascript">
			<%
			if(request.getParameter("msg") != null) {         
				%>   
				alert("<%=request.getParameter("msg")%>");
				<%   
			}
			%>
		</script>
	</head>
	
	<body>
		<form action="<%=request.getContextPath()%>/loginAction.jsp" method="post">
			<table class="table table-bordered table-hover w-50 rounded" style="margin-left: auto; margin-right: auto;">
				<tr>
					<th colspan ="2">로그인</th>			
				</tr>
				<tr>
					<td>empNo</td>
					<td>
						<input type="text" name="empNo" placeholder="사원번호">
					</td>
				</tr>
				<tr>
					<td>First Name</td>
					<td>
						<input type="text" name="firstName" placeholder="FIRST NAME">
					</td>
				</tr>
				<tr>
					<td>Last Name</td>
					<td>
						<input type="text" name="lastName" placeholder="LAST NAME">
					</td>
				</tr>
				<tr>
					<td colspan ="2">
						<button type="submit" class="btn text-black .bg-dark.bg-gradient" style="background-color:#D4D4D4;">로그인</button>
					</td>							
				</tr>
			</table>
		</form>
	</body>
</html>