output "lb_instance_id" {
  description = "The Proxmox VM ID of the load balancer instance"
  value       = proxmox_virtual_environment_vm.lb_instance.vm_id
}

output "lb_instance_name" {
  description = "The VM name of the load balancer instance"
  value       = proxmox_virtual_environment_vm.lb_instance.name
}

output "dns_name" {
  description = "The IP address of the load balancer (mimics ALB dns_name output)"
  value       = local.instance_address
}

output "address" {
  description = "The IP address of the load balancer instance"
  value       = local.instance_address
}

output "stats_url" {
  description = "URL for the HAProxy stats dashboard"
  value       = var.stats_enabled ? "http://${local.instance_address}:${var.stats_port}${var.stats_uri}" : null
}

output "ssh_connection" {
  description = "SSH connection string for management"
  value       = "${var.ssh_user}@${local.instance_address}"
}
