data "openstack_networking_network_v2" "project" {
  name = var.project_network
}

data "openstack_images_image_v2" "ubuntu" {
  name        = var.image_name
  most_recent = true
}

resource "openstack_compute_keypair_v2" "week7" {
  name       = "${var.name_prefix}-key"
  public_key = file(pathexpand(var.public_key_path))
}

resource "openstack_networking_secgroup_v2" "week7" {
  name        = "${var.name_prefix}-security-group"
  description = "Security group for Cloud Services Week 7"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.ssh_allowed_cidr
  security_group_id = openstack_networking_secgroup_v2.week7.id
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.week7.id
}

resource "openstack_networking_port_v2" "week7" {
  name       = "${var.name_prefix}-port"
  network_id = data.openstack_networking_network_v2.project.id

  security_group_ids = [
    openstack_networking_secgroup_v2.week7.id
  ]
}

resource "openstack_compute_instance_v2" "week7" {
  name        = "${var.name_prefix}-vm"
  image_id    = data.openstack_images_image_v2.ubuntu.id
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.week7.name

  network {
    port = openstack_networking_port_v2.week7.id
  }

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    page_message = var.page_message
  })
}

resource "openstack_networking_floatingip_v2" "week7" {
  pool = "public"
}

resource "openstack_networking_floatingip_associate_v2" "week7" {
  floating_ip = openstack_networking_floatingip_v2.week7.address
  port_id     = openstack_networking_port_v2.week7.id
}
