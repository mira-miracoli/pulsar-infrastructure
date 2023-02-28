resource "openstack_compute_instance_v2" "exec-node" {

  count           = "${var.exec_node_count}"
  name            = "${var.name_prefix}exec-node-${count.index}${var.name_suffix}"
  flavor_name     = "${var.flavors["exec-node"]}"
  image_id        = "${data.openstack_images_image_v2.vgcn-image.id}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.secgroups}"


  network {
    uuid = "${data.openstack_networking_network_v2.internal.id}"
  }

  provisioner "remote-exec" {
    inline = ["sudo dnf update -y", "echo Done!"]

    connection {
      host        = self.access_ip_v4
      type        = "ssh"
      user        = "centos"
      private_key = file(var.pvt_key)
    }
  }

  provisioner "local-exec" {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --ssh_extra_args='-o IdentitiesOnly=yes -o PasswordAuthentication=no' -u centos -b -i '${self.access_ip_v4},' --private-key ${var.pvt_key} --extra-vars='condor_ip_range=${var.private_network.cidr4} condor_host=${self.access_ip_v4} condor_ip_range=${var.private_network.cidr4}' condor-install-exec.yml"
  }

  user_data = <<-EOF
    #cloud-config
    write_files:
    - content: |
        CONDOR_HOST = ${openstack_compute_instance_v2.central-manager.network.1.fixed_ip_v4}
        ALLOW_WRITE = *
        ALLOW_READ = $(ALLOW_WRITE)
        ALLOW_ADMINISTRATOR = *
        ALLOW_NEGOTIATOR = $(ALLOW_ADMINISTRATOR)
        ALLOW_CONFIG = $(ALLOW_ADMINISTRATOR)
        ALLOW_DAEMON = $(ALLOW_ADMINISTRATOR)
        ALLOW_OWNER = $(ALLOW_ADMINISTRATOR)
        ALLOW_CLIENT = *
        DAEMON_LIST = MASTER, SCHEDD, STARTD
        FILESYSTEM_DOMAIN = vgcn
        UID_DOMAIN = vgcn
        TRUST_UID_DOMAIN = True
        SOFT_UID_DOMAIN = True
        # run with partitionable slots
        CLAIM_PARTITIONABLE_LEFTOVERS = True
        NUM_SLOTS = 1
        NUM_SLOTS_TYPE_1 = 1
        SLOT_TYPE_1 = 100%
        SLOT_TYPE_1_PARTITIONABLE = True
        ALLOW_PSLOT_PREEMPTION = False
        STARTD.PROPORTIONAL_SWAP_ASSIGNMENT = True
      owner: root:root
      path: /etc/condor/condor_config.local
      permissions: '0644'
    - content: |
        /data           /etc/auto.data          nfsvers=3
      owner: root:root
      path: /etc/auto.master.d/data.autofs
      permissions: '0644'
    - content: |
        share  -rw,hard,intr,nosuid,quota  ${openstack_compute_instance_v2.nfs-server.access_ip_v4}:/data/share
      owner: root:root
      path: /etc/auto.data
      permissions: '0644'
  EOF
}
