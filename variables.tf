################################################################################
# Instance Identity
################################################################################

variable "identifier" {
  type        = string
  description = "Name of the load balancer instance (used as VM name)"
}

variable "vm_id" {
  type        = number
  default     = null
  description = "Proxmox VM ID (auto-assigned if not specified)"
}

################################################################################
# Instance Class
################################################################################

variable "instance_class" {
  type        = string
  description = "Instance class defining CPU and memory (e.g., 'elb.t3.small', 'elb.t3.medium')"
  default     = "elb.t3.small"

  validation {
    condition     = contains(["elb.t3.small", "elb.t3.medium", "elb.t3.large", "elb.t3.xlarge", "elb.t3.2xlarge", "custom"], var.instance_class)
    error_message = "instance_class must be one of: elb.t3.small, elb.t3.medium, elb.t3.large, elb.t3.xlarge, elb.t3.2xlarge, custom."
  }
}

variable "custom_cores" {
  type        = number
  default     = null
  description = "CPU cores (only used when instance_class = 'custom')"
}

variable "custom_memory" {
  type        = number
  default     = null
  description = "Memory in MB (only used when instance_class = 'custom')"
}

variable "cpu_type" {
  type        = string
  description = "CPU type for the VM (see Proxmox documentation for available types)"
  default     = "x86-64-v2-AES"
}

################################################################################
# Storage
################################################################################

variable "allocated_storage" {
  type        = number
  description = "Disk size in GB for the load balancer VM"
  default     = 10
}

variable "storage_pool" {
  type        = string
  description = "Proxmox storage pool for the VM disk"
  default     = "local-lvm"
}

variable "snippets_storage" {
  type        = string
  description = "Proxmox storage for cloud-init snippets (must support 'snippets' content type)"
  default     = "local"
}

################################################################################
# Load Balancer Configuration
################################################################################

variable "type" {
  type        = string
  description = "Load balancer type: 'application' (HTTP/HTTPS - ALB) or 'network' (TCP/UDP - NLB)"
  default     = "application"

  validation {
    condition     = contains(["application", "network"], var.type)
    error_message = "type must be one of: application, network."
  }
}

variable "listeners" {
  type = list(object({
    name              = string
    frontend_port     = number
    backend_port      = number
    protocol          = optional(string, "http")
    balance_algorithm = optional(string, "roundrobin")
  }))
  description = "List of listener configurations for the load balancer"

  validation {
    condition     = length(var.listeners) > 0
    error_message = "At least one listener must be defined."
  }
}

variable "backend_servers" {
  type = list(object({
    name    = string
    address = string
  }))
  description = "List of backend servers to load balance traffic to"

  validation {
    condition     = length(var.backend_servers) > 0
    error_message = "At least one backend server must be defined."
  }
}

variable "health_check_interval" {
  type        = number
  description = "Health check interval in seconds"
  default     = 5
}

variable "health_check_timeout" {
  type        = number
  description = "Health check timeout in seconds"
  default     = 3
}

variable "stats_enabled" {
  type        = bool
  description = "Enable the HAProxy stats dashboard"
  default     = true
}

variable "stats_port" {
  type        = number
  description = "Port for the HAProxy stats dashboard"
  default     = 8404
}

variable "stats_uri" {
  type        = string
  description = "URI path for the HAProxy stats dashboard"
  default     = "/stats"
}

variable "stats_username" {
  type        = string
  description = "Username for HAProxy stats authentication"
  default     = "admin"
}

variable "stats_password" {
  type        = string
  description = "Password for HAProxy stats authentication"
  sensitive   = true
}

################################################################################
# Proxmox Target
################################################################################

variable "target_node" {
  type        = string
  description = "Proxmox node to deploy the VM on"
}

variable "template_id" {
  type        = number
  description = "VM template ID to clone from (must have cloud-init and qemu-guest-agent)"
}

################################################################################
# Network
################################################################################

variable "ip_address" {
  type        = string
  description = "Static IP in CIDR notation (e.g., '192.168.1.72/24')"

  validation {
    condition     = can(cidrhost(var.ip_address, 0))
    error_message = "ip_address must be a valid CIDR notation (e.g., '192.168.1.72/24')."
  }
}

variable "gateway" {
  type        = string
  description = "Network gateway IP address"

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", var.gateway))
    error_message = "gateway must be a valid IPv4 address (e.g., '192.168.1.1')."
  }
}

variable "network_bridge" {
  type        = string
  description = "Proxmox network bridge"
  default     = "vmbr0"
}

################################################################################
# SSH / Cloud-Init
################################################################################

variable "ssh_user" {
  type        = string
  description = "Cloud-init user for SSH access"
  default     = "ubuntu"
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys for VM access"
}

################################################################################
# Tags
################################################################################

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VM (converted to Proxmox tag list)"
  default     = {}
}
