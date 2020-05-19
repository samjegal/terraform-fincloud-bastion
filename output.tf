output "public_ip" {
  description = "서버에 할당된 공인 IP 주소"
  value       = fincloud_public_ip.bastion.address
}
