output "node_name" {
  value = "${openstack_compute_instance_v2.central-manager.name}"
}

output "ip_v4_internal" {
  value = "${openstack_compute_instance_v2.central-manager.network.1.fixed_ip_v4}"
}

output "ip_v4_public" {
  value = "${openstack_compute_instance_v2.central-manager.access_ip_v4}"
}

output "name" {
  "make a list of all exec node IPv4 adresses"
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "vgcn.key"
  file_permission = "0600"
}