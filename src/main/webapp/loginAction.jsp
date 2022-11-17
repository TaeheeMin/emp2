<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. controller : 로그인 사용할 아이디와 비밀번호 입력받아 사용
	request.setCharacterEncoding("utf-8");
	
	// 작성 확인
	if(request.getParameter("empNo") == null
		|| request.getParameter("firstName") == null 
		|| request.getParameter("lastName") == null 
		|| request.getParameter("empNo").equals("")
		|| request.getParameter("firstName").equals("")
		|| request.getParameter("lastName").equals("")) {
		System.out.println("1.로그인실패");
		String msg = URLEncoder.encode("정보를 입해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp?msg="+msg);
		return;
	} // 내용 미입력시 메세지, 폼이동
	
	int empNo = Integer.parseInt(request.getParameter("empNo"));
	String firstName= request.getParameter("firstName");
	String lastName= request.getParameter("lastName");
	// vo setter 호출
	Employee employee = new Employee();
	employee.setEmpNo(empNo);
	employee.setFirstName(firstName);
	employee.setLastName(lastName);
	
	// 2. model
	//db연결
	String driver = "org.mariadb.jdbc.Driver"; 
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String sql = "SELECT emp_no empNo, first_name firstName FROM employees WHERE emp_no = ? AND first_name = ? AND last_name = ?"; 
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, employee.getEmpNo());
	stmt.setString(2, employee.getFirstName());
	stmt.setString(3, employee.getLastName());
	
	ResultSet rs = stmt.executeQuery();
	String targetUrl = "/loginForm.jsp?msg=";
	String msg = null;
	if(rs.next()){
		// 로그인 성공 -> 값저장 -> session
		Employee loginEmp = new Employee();
		loginEmp.setEmpNo(empNo);
		loginEmp.setFirstName(firstName);
		session.setAttribute("loginEmp", loginEmp);
		// Object = loginEmp;
		// 키-loginEmp 값-Object
		msg = URLEncoder.encode(loginEmp.getFirstName() + "(" + loginEmp.getEmpNo() + ")님 반갑습니다","utf-8");
		targetUrl = "/empList.jsp?msg=";
		System.out.println("로그인 성공");
	} else{
		msg = URLEncoder.encode("사원정보를 확인해주세요","utf-8");
		System.out.println("삭제 실패");
	}
	
	rs.close();
	stmt.close();
	conn.close();
	response.sendRedirect(request.getContextPath()+targetUrl+msg);
	// 3. view -> 없음

%>