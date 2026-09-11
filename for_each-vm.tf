# for_each-vm.tf

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
    core_fraction = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 4
      ram         = 4
      disk_volume = 10
      core_fraction = 20
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 2
      disk_volume = 8
      core_fraction = 20
    }
  ]
}

resource "yandex_compute_instance" "for_each_vm" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  hostname    = each.value.vm_name
  platform_id = "standard-v3"
  zone        = var.default_zone
  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = "fd8g39rqnaa88u265oic" 
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "mulenkois:${local.ssh_public_key}"
  }
}
