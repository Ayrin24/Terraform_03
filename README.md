# Terraform_03

Задание 1.

<img width="992" height="675" alt="image" src="https://github.com/user-attachments/assets/093c9bef-138e-4737-8fbe-4167a0af6e7d" />

Задание 2.

<img width="1826" height="214" alt="image" src="https://github.com/user-attachments/assets/29bda2c4-5bb4-4f12-96fe-540c423c8a64" />

Задание 3.

<img width="1732" height="121" alt="image" src="https://github.com/user-attachments/assets/74b90bb5-b4b3-489e-90c5-f0b7d3f6d657" />

<img width="1752" height="55" alt="image" src="https://github.com/user-attachments/assets/ef2dfd35-738b-4d97-ae36-d507270b76aa" />

Задание 4.

<img width="672" height="173" alt="image" src="https://github.com/user-attachments/assets/7970fde5-f08b-4153-a08c-71bf94e2025d" />

Задание 5.

<img width="665" height="331" alt="image" src="https://github.com/user-attachments/assets/bab0fb5b-735f-48ab-adbf-b9c51855f9ff" />

Задание 7


``
merge(local.vpc, {
  for k, v in local.vpc :
  k => [for i, x in v : x if i != 2] if can(tolist(v))
})
``
Либо
``
merge(local.vpc, {
  subnet_ids   = [for i, v in local.vpc.subnet_ids   : v if i != 2]
  subnet_zones = [for i, v in local.vpc.subnet_zones : v if i != 2]
})
``

Задание 8


Было:

``
[webservers]
%{~ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"] platform_id=${i["platform_id "]}}
%{~ endfor ~}
``


Стало:


``
[webservers]
%{ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]} platform_id=${i["platform_id"]}
%{ endfor ~}
``
