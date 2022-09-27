# basic_terraform-ansible

### 01 파일 읽고 쓰기

### 02 Ec2인스턴스 생성

### 03 module & variable를 통한 VPC & Subnet 생성

### 04 count & for_each를 통한 IAM 유저 생성

### 05 조건에 따른 인터넷게이트웨이 생성

### 06 for문을 통한 IAM 유저 생성 및 조건에따른 권한 부여

### 07 상태관리

1. tfstate 생성된 후 원격에서 상태를 관리하기 위해서 state stroage(Backend) 생성한다.
2. AWS s3 backend / Terraform Cloud로 원격 백엔드 사용한다.
3. local state는 개인작업용도이며, 원격 state 관리 시 동시성 문제가 발생하므로
   locking하여 한작업자가 진행 시 locking을 건다. aws의 경우 DynamoDB로 lock한다.

### 07-1 state 명령어

1. tf state list - 워크스페이스에서 관리중인 리소스 목록 조회
2. tf state show 리소스명 - 리소스 상세 내역 조회
3. tf state mv 를 통해 동일한 리소스에 대해 리팩토링 시 상태 파일에 해당 변경사항 주입
4. tf state rm 테라폼으로 더이상 관리하지 않는 경우

### 08 테라폼 워크스페이스

1. 테라폼 워크스페이스란 프로젝트 상태 관리의 단위
2. 각기 다른 dev /prod 워크스페이스의 코드를 복사하는게 아닌 tfvars로 대체

### 08-1 테라폼 워크스페이스 명령어

1. tf workspace list - 워크스페이스 리스트 조회
2. tf workspace show - 현재 워크스페이스 위치 조회
3. tf workspace new 스페이스명 - 워크스페이스 생성
4. tf workspace select 스페이스명 - 원하는 스페이스로 이동
5. tf workspace delete 스페이스명 - 스페이스 삭제

ex) 원하는 워크스페이스에서 tfvars파일로 변수 지정 후 apply 적용

- tf workspace select dev
- tf apply -var-file=dev.tfvars

### 09 root / child module 생성
