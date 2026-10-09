output "floating_ip" {
  description = "Public floating IP of the Week 7 VM"
  value       = openstack_networking_floatingip_v2.week7.address
}

output "web_url" {
  description = "Public URL of the web server"
  value       = "http://${openstack_networking_floatingip_v2.week7.address}"
}

output "ssh_command" {
  description = "Command to connect to the VM using SSH"
  value       = "ssh -i ~/.ssh/week7_cpouta ubuntu@${openstack_networking_floatingip_v2.week7.address}"
}
