package vo;

public class EmployeeTest {

	public static void main(String[] args) {
		Employee e = new Employee();
		// e.birthDate = "2000-01-01";
		e.setBirthDate("2000-01-01");
		System.out.println(e.getBirthDate()); // this = e
		
		Employee e2 = new Employee();
		e2.setBirthDate("2000-01-01");
		System.out.println(e2.getBirthDate()); // this = e2
		// 호출시점 메서드 시작  
	}

}
