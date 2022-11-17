<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String word = request.getParameter("word");
	System.out.println("word : " + request.getParameter("word"));
%>
<!DOCTYPE html>
<nav class="navbar navbar-expand-sm navbar-dark bg-dark fixed-top">
  <div class="container-fluid">
    <a class="navbar-brand" href="javascript:void(0)">GOODEE</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mynavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="mynavbar">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link" href="<%=request.getContextPath()%>/empList.jsp">사원목록</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="javascript:void(0)">사원관리</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a>
        </li>
      </ul>
      <form class="d-flex" action="<%=request.getContextPath()%>/empList.jsp" method="post">
        <%
        	if(word == null){
        	%>
        		 <input class="form-control me-2" type="text" placeholder="Search" name="word">
        	<%
        	} else {
        	%>
        		<input class="form-control me-2" type="text" placeholder="Search" name="word" value="<%=word%>">	 
        	<%
        	}
        %>
        <button class="btn btn-primary" type="submit">Search</button>
      </form>
    </div>
  </div>
</nav>