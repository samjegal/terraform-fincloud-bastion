output "public_ip" {
  description = "서버에 할당된 공인 IP 주소"
  value       = fincloud_public_ip.bastion.address
}

output "security_group_id" {
  description = "ACG 방화벽 그룹의 ID"
  value       = fincloud_security_group.bastion.id
}
