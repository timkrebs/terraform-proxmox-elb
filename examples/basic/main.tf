terraform {
  required_version = ">= 1.13.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.94"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent       = false
    username    = "root"
    private_key = var.ssh_private_key
  }
}

module "lb" {
  source = "../../"

  identifier     = "my-alb"
  instance_class = "elb.t3.small"
  type           = "application"

  listeners = [
    {
      name              = "web"
      frontend_port     = 80
      backend_port      = 8080
      protocol          = "http"
      balance_algorithm = "roundrobin"
    }
  ]

  backend_servers = [
    { name = "app-1", address = "192.168.1.50" },
    { name = "app-2", address = "192.168.1.51" },
  ]

  stats_enabled  = true
  stats_port     = 8404
  stats_username = "admin"
  stats_password = var.stats_password

  target_node = "pve"
  template_id = 9000

  ip_address     = "192.168.1.72/24"
  gateway        = "192.168.1.1"
  network_bridge = "vmbr0"

  ssh_user        = "ubuntu"
  ssh_public_keys = [var.ssh_public_key]

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
