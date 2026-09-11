# disk_vm.tf

resource "yandex_compute_disk" "additional" {
  count = 3
  name  = "storage-disk-${count.index + 1}"
  type  = "network-hdd"
  zone  = var.default_zone
  size  = 1
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  hostname    = "storage"
  platform_id = "standard-v3"
  zone        = var.default_zone

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8g39rqnaa88u265oic"
      size     = 8
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.additional
    content {
      disk_id     = secondary_disk.value.id
      auto_delete = false
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
