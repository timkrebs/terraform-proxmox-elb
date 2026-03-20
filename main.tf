################################################################################
# Cloud-Init Snippet
################################################################################

resource "proxmox_virtual_environment_file" "cloud_init" {
  content_type = "snippets"
  datastore_id = var.snippets_storage
  node_name    = var.target_node

  source_raw {
    data = templatefile("${path.module}/templates/haproxy-cloud-init.yaml.tftpl", {
      identifier           = var.identifier
      type                 = var.type
      listeners            = var.listeners
      backend_servers      = var.backend_servers
      health_check_interval = var.health_check_interval
      health_check_timeout = var.health_check_timeout
      stats_enabled        = var.stats_enabled
      stats_port           = var.stats_port
      stats_uri            = var.stats_uri
      stats_username       = var.stats_username
      stats_password       = var.stats_password
    })
    file_name = "${var.identifier}-cloud-init.yaml"
  }
}

################################################################################
# ELB-like Load Balancer Instance
################################################################################

resource "proxmox_virtual_environment_vm" "lb_instance" {
  name      = var.identifier
  node_name = var.target_node
  vm_id     = var.vm_id

  clone {
    vm_id = var.template_id
    full  = true
  }

  cpu {
    cores = local.vm_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = local.vm_memory
  }

  disk {
    datastore_id = var.storage_pool
    size         = var.allocated_storage
    interface    = "virtio0"
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      username = var.ssh_user
      keys     = var.ssh_public_keys
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
    datastore_id      = var.storage_pool
  }

  agent {
    enabled = true
  }

  tags = local.tag_list

  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}
