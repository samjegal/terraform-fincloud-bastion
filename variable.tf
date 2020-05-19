variable "vpc_id" {
  description = "VPC 인스턴스 번호"
}

variable "cidr_block" {
  description = "Bastion 서버의 서브넷 CIDR 값 (IP 주소 범위)"
}

variable "address" {
  description = "Bastion 서버의 IP 주소"
}

variable "prefix" {
  description = "Bastion 용도에 따른 Prefix 문자열"
}

variable "login_key_name" {
  description = "관리자용 로그인 키 정보"
}

variable "init_script_id" {
  description = "초기 스크립트의 번호"
}
