# Bastion 네트워크 접근 정책
resource "fincloud_network_acl" "bastion" {
  vpc_id = var.vpc_id

  name        = format("%s-bastion-acl", var.prefix)
  description = "Bastion 네트워크 접근 정책"
}

# Bastion 네트워크 방화벽 정책
resource "fincloud_security_group" "bastion" {
  vpc_id = var.vpc_id

  name        = format("%s-bastion-acg", var.prefix)
  description = "Bastion 보안 정책"
}

# Bastion 네트워크 방화벽 정책 룰
resource "fincloud_security_group_rule" "stage-bastion" {
  vpc_id            = var.vpc_id
  security_group_id = fincloud_security_group.bastion.id

  rule {
    direction   = "inbound"
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    port        = "22"
    description = "SSH 접속 허용"
  }

  rule {
    direction   = "outbound"
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    port        = "1-65535"
    description = "TCP 트래픽 허용"
  }

  rule {
    direction   = "outbound"
    protocol    = "udp"
    cidr_block  = "0.0.0.0/0"
    port        = "1-65535"
    description = "UDP 트래픽 허용"
  }

  rule {
    direction   = "outbound"
    protocol    = "icmp"
    cidr_block  = "0.0.0.0/0"
    description = "ICMP 트래픽 허용"
  }
}

# Bastion 메인 서브넷
resource "fincloud_subnet" "bastion" {
  vpc_id         = var.vpc_id
  network_acl_id = fincloud_network_acl.bastion.id

  name       = format("%s-bastion-subnet", var.prefix)
  cidr_block = var.cidr_block
  type       = "public"
  purpose    = "normal"
}

# Bastion 라우트 테이블 (추가 예정)
# resource "fincloud_route_table" "bastion" {
#   vpc_id = var.vpc_id

#   name  = format("%s-bastion-rt-public", var.prefix)
#   usage = "public"

#   subnet = [
#     fincloud_subnet.bastion.id
#   ]
# }

# Bastion 서버에 할당될 네트워크 인터페이스
resource "fincloud_network_interface" "bastion" {
  vpc_id    = var.vpc_id
  subnet_id = fincloud_subnet.bastion.id

  name        = format("%s-bastion-nic", var.prefix)
  address     = var.address
  description = "Bastion 네트워크 인터페이스"

  security_groups = [
    fincloud_security_group.bastion.id
  ]
}

# Bastion 서버 인스턴스
resource "fincloud_server" "bastion" {
  vpc_id    = var.vpc_id
  subnet_id = fincloud_subnet.bastion.id

  name        = format("%s-bastion-server", var.prefix)
  spec        = "SVR.VSVR.STAND.C002.M004.NET.SSD.B050.G001"
  oscode      = "SW.VSVR.OS.LNX64.CNTOS.0703.B050"
  description = "Bastion 서버"

  login_key {
    name = var.login_key_name
  }

  network_interface {
    id        = fincloud_network_interface.bastion.id
    subnet_id = fincloud_subnet.bastion.id
    address   = fincloud_network_interface.bastion.address
    security_groups = [
      fincloud_security_group.bastion.id
    ]
  }

  init_script_id = var.init_script_id

  security_groups = [
    fincloud_security_group.bastion.id
  ]
}

# Bastion 공인 IP
resource "fincloud_public_ip" "bastion" {
  server_id = fincloud_server.bastion.id
}
