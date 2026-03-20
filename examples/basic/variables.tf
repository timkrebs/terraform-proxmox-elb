variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL (e.g., https://pve.example.com:8006)"
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox API token (e.g., user@pam!token=uuid)"
  sensitive   = true
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key for Proxmox provider connection"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for VM access"
}

variable "stats_password" {
  type        = string
  description = "Password for HAProxy stats dashboard"
  sensitive   = true
}
