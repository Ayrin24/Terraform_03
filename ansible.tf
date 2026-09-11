# ansible.tf

locals {
   ansible_hosts = {
    webservers = [
      for idx, vm in yandex_compute_instance.count_vm :
      {
        name        = vm.name
        ansible_host = vm.network_interface[0].nat_ip_address
        fqdn        = vm.fqdn
      }
    ]
    databases = [
      for key, vm in yandex_compute_instance.for_each_vm :
      {
        name        = vm.name
        ansible_host = vm.network_interface[0].nat_ip_address
        fqdn        = vm.fqdn
      }
    ]
    storage = [
      {
        name        = yandex_compute_instance.storage.name
        ansible_host = yandex_compute_instance.storage.network_interface[0].nat_ip_address
        fqdn        = yandex_compute_instance.storage.fqdn
      }
    ]
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tftpl", {
    hosts = local.ansible_hosts
  })
  filename = "${path.module}/inventory.ini"
}
