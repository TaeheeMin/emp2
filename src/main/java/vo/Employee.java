package vo;

// 캡슐화 단계
// 오픈 정도 public(100%) > protected(같은 패키지와 상속 관계 오픈) > default(같은 패키지 오픈) > private(0% this 오픈, 나만)
// protected나 default는 입문자는 잘 사용 안함
public class Employee { // 모든 필드는 정보은닉
	private int empNo;
	private String birthDate; // 정보은닉 : 필드를 숨기는 것
	private String firstName;
	private String lastName;
	private String gender;
	private String hireDate;
	
	public int getEmpNo() {
		return empNo;
	}
	public void setEmpNo(int empNo) {
		this.empNo = empNo;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getHireDate() {
		return hireDate;
	}
	public void setHireDate(String hireDate) {
		this.hireDate = hireDate;
	}
	// 캡슐화(읽기) -> get method getter
	public String getBirthDate() {
		return this.birthDate;
	}
	// 캡슐화(쓰기) -> set method setter
	// 메서드 실행 후 return 필요없으니 void로
	public void setBirthDate(String birthDate) {
		this.birthDate = birthDate;
	}
}
