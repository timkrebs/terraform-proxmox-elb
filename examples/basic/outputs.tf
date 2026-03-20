output "lb_instance_id" {
  description = "The Proxmox VM ID of the load balancer"
  value       = module.lb.lb_instance_id
}

output "lb_instance_name" {
  description = "The VM name of the load balancer"
  value       = module.lb.lb_instance_name
}

output "dns_name" {
  description = "The DNS name (IP address) of the load balancer"
  value       = module.lb.dns_name
}

output "address" {
  description = "The IP address of the load balancer"
  value       = module.lb.address
}

output "stats_url" {
  description = "URL for the HAProxy stats dashboard"
  value       = module.lb.stats_url
}

output "ssh_connection" {
  description = "SSH connection string"
  value       = module.lb.ssh_connection
}
