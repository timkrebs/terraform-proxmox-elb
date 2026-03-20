locals {
  # AWS ELB instance class mappings
  instance_types = {
    "elb.t3.small"   = { cores = 2, memory = 2048 }
    "elb.t3.medium"  = { cores = 2, memory = 4096 }
    "elb.t3.large"   = { cores = 2, memory = 8192 }
    "elb.t3.xlarge"  = { cores = 4, memory = 16384 }
    "elb.t3.2xlarge" = { cores = 8, memory = 32768 }
    "custom"         = { cores = var.custom_cores, memory = var.custom_memory }
  }

  selected  = local.instance_types[var.instance_class]
  vm_cores  = local.selected.cores
  vm_memory = local.selected.memory

  # IP without CIDR prefix
  instance_address = split("/", var.ip_address)[0]

  # Convert map tags to list format for Proxmox
  tag_list = [for k, v in var.tags : "${lower(k)}-${lower(v)}"]
}
