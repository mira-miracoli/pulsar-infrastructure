variable "nfs_disk_size" {
  default = 200
}

variable "flavors" {
  type = map
  default = {
    "central-manager" = "m1.medium"
    "nfs-server" = "m1.medium"
    "exec-node" = "m1.small"
    "gpu-node" = "m1.small"
  }
}

variable "exec_node_count" {
  default = 2
}

variable "gpu_node_count" {
  default = 0
}

variable "image" {
  type = map
  default = {
    "name" = "vggp-v60-j221-e2504756580f-dev"
    "image_source_url" = "https://usegalaxy.eu/static/vgcn/vggp-v60-j221-e2504756580f-dev.raw"
    "container_format" = "bare"
    "disk_format" = "raw"
   }
}

variable "public_key" {
  type = map
  default = {
    name = "cloud_key"
    pubkey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHWh97MWkn8+9aBrjoCP2RqkgXACMyBVgF2ug4JZDtpQpG2MjCor7G4AbuNuvRb5lxsiQk4kaV4IrJv7PaAHmM4= mk@galaxy-mira"
  }
}

variable "name_prefix" {
  default = "vgcn-mira-"
}

variable "name_suffix" {
  default = ".pulsar"
}

variable "secgroups_cm" {
  type = list
  default = [
    "public-ssh",
    "ingress-private",
    "egress-public",
  ]
}

variable "secgroups" {
  type = list
  default = [
    "ingress-private",
    "egress-public",
  ]
}

variable "public_network" {
  default  = "public"
}

variable "private_network" {
  type = map
  default  = {
    name = "vgcn-private"
    subnet_name = "vgcn-private-subnet"
    cidr4 = "192.52.32.0/20"
  }
}

variable "ssh-port" {
  default = "22"
}

variable "pvt_key" {}