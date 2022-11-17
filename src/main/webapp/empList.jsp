<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	//1. controller
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	System.out.println("word : " + request.getParameter("word"));
	String msg = URLEncoder.encode("로그인 해주세요","utf-8");
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp?msg="+msg);
		System.out.println("로그인 필요");
		return;
	}

	Object obLoginEmp = session.getAttribute("loginEmp");
	Employee loginEmp = (Employee)obLoginEmp;
	
	int currentPage = 1; // 현재 페이지
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println("currentPage : " + currentPage); // 디버깅
	
	String sort = "ASC";
	if(request.getParameter("sort") != null && request.getParameter("sort").equals("DESC")){
		sort = "DESC";
	}
	
	// 2. model
	int rowPerPage = 10; // 페이지당 보이는 목록개수
	int beginRow = rowPerPage * (currentPage-1); // sql문에 limit beginRow, ROW_PER_PAGE
	
	//db연결
	String driver = "org.mariadb.jdbc.Driver"; 
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 사원목록
	
	/* 
	// ORDER BY first_name ? 이렇게는 불가능
	String sql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY first_name ASC LIMIT ?,?";
	if(sort.equals("DESC")){
		sql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY first_name DESC LIMIT ?,?";
	}
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<Employee> list = new ArrayList<Employee>();
	while(rs.next()) {
		Employee e = new Employee();
		e.setEmpNo(rs.getInt("empNo"));
		e.setFirstName(rs.getString("firstName"));
		e.setLastName(rs.getString("lastName"));
		list.add(e);
	}
	 */
	
	int cnt = 0;
	int lastPage = 0;
	String listSql = null;
	String cntSql = null;
	ResultSet cntRs = null;
	ResultSet listRs = null;
	PreparedStatement listStmt = null;
	PreparedStatement cntStmt = null;
	// model new data
	ArrayList<Employee> empList = new ArrayList<Employee>();
	
	if(word == null || word.equals("")) {
		// null일때 전체 페이지
		cntSql = "SELECT COUNT(*) FROM employees";
		cntStmt = conn.prepareStatement(cntSql);
		cntRs = cntStmt.executeQuery();
		if(cntRs.next()) {
			cnt = cntRs.getInt("COUNT(*)");
		}	
		System.out.println("cnt : " + cnt); // 디버깅
		System.out.println("word null"); // 디버깅
		
		// 마지막 페이지
		lastPage = (int)Math.ceil((double)cnt / (double)rowPerPage);
		System.out.println("lastPage : " + lastPage); // 디버깅
		
		// null일때 목록
		listSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY first_name ASC LIMIT ?,?";
		if(sort.equals("DESC")){
			listSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY first_name DESC LIMIT ?,?";
		}
		listStmt = conn.prepareStatement(listSql); 
		listStmt.setInt(1,beginRow);
		listStmt.setInt(2,rowPerPage);
		
	} else {
		// 검색일 때 페이지
		cntSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1,"%" + word + "%");
		cntRs = cntStmt.executeQuery();
		if(cntRs.next()) {
			cnt = cntRs.getInt("COUNT(*)");
		}	
		System.out.println("cnt : " + cnt); // 디버깅
		System.out.println("word : " + word); // 디버깅
		
		// 마지막 페이지
		lastPage = (int)Math.ceil((double)cnt / (double)rowPerPage);
		System.out.println("lastPage : " + lastPage); // 디버깅
		
		// 검색일 때 목록
		listSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? ORDER BY first_name ASC LIMIT ?,?";
		if(sort.equals("DESC")){
			listSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? ORDER BY first_name DESC LIMIT ?,?";
		}
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%" + word + "%"); // 공백이나 단어검색 했을때 ;
		listStmt.setInt(2,beginRow);
		listStmt.setInt(3,rowPerPage);
	}
	
	listRs = listStmt.executeQuery();
	while(listRs.next()) {
		Employee e = new Employee();
		e.setEmpNo(listRs.getInt("empNo"));
		e.setFirstName(listRs.getString("firstName"));
		e.setLastName(listRs.getString("lastName"));
		empList.add(e);
	}
	
	// 3. view
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>EMP List</title>
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
				width: 100%;
				border-collapse: collapse;
				border-radius: 5px;
				overflow: hidden;
				text-align:center;
			}
			a {
				text-decoration: none;
			}
			img {
				width:20px;
				height: 20px;
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
		<div>
			<!-- jsp 액션 태그 : 동일페이지 출력, 상대주소 사용할수 없다.(서버가 하는거라. 브라우저 입장에서 처리하는것은 절대주소인 context사용 가능 -->
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container-fluid" style="margin-top:80px">
			<table class="table table-bordered table-hover w-50 rounded" style="margin-left: auto; margin-right: auto;">
				<tr>
					<th>사원번호</th>
					<th>
						이름
						<%
						if(sort.equals("ASC")){
							if(word == null){
								%>
								<a href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage%>&sort=DESC">
									<img class="img-concert" src="<%=request.getContextPath()%>/img/DESC.png"/>
								</a>
								<%
							} else {
								%>
								<a href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage%>&sort=DESC&word=<%=word%>">
									<img class="img-concert" src="<%=request.getContextPath()%>/img/DESC.png"/>
								</a>
								<%
							}
						} else {
							if(word == null){
								%>
								<a href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage%>&sort=ASC">
									<img class="img-concert" src="<%=request.getContextPath()%>/img/ASC.png"/>
								</a>
								<%
							} else {
							%>
								<a href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage%>&sort=ASCC&word=<%=word%>">
									<img class="img-concert" src="<%=request.getContextPath()%>/img/ASC.png"/>
								</a>	
							<%
							}
						}
						%>
						
					</th>
				</tr>
				<%
					for(Employee e : empList){
				%>
						<tr>
							<td><%=e.getEmpNo() %></td>
							<td><%=e.getFirstName()%>&nbsp;<%=e.getLastName() %></td>
						</tr>						
				<%
					}
				%>
			</table>
			<ul class="pagination justify-content-center">
				<%
				if(word == null) {
					%>
					<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=1">처음</a></li>
					<%
						if(currentPage > 1){
							%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
							<%
						}
						if(currentPage < lastPage){
							%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
							<%
						}
						%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=lastPage%>">마지막</a></li>
						<%
				} else {
					%>
					<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=1&word=<%=word%>">처음</a></li>
					<%
						if(currentPage > 1){
							%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a></li>
							<%
						}
						if(currentPage < lastPage){
							%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a></li>
							<%
						}
						%>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a></li>
						<%
				}
				%>	
			</ul>
		</div>
	</body>
</html>