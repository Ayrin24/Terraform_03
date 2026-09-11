# count-vm.tf

resource "yandex_compute_instance" "count_vm" {
  count = 2

  name        = "web-${count.index + 1}"  # web-1, web-2
  hostname    = "web-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.default_zone

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8g39rqnaa88u265oic"
      size     = 8
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

  depends_on = [yandex_compute_instance.for_each_vm]
}
