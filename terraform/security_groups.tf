resource "openstack_networking_secgroup_v2" "ssh_group" {
  name = "Allow SSH Ingress"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_ip
  security_group_id = openstack_networking_secgroup_v2.ssh_group.id
}

resource "openstack_networking_secgroup_v2" "http_group" {
  name = "Allow HTTP Ingress"
}

resource "openstack_networking_secgroup_rule_v2" "http_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = var.admin_ip
  security_group_id = openstack_networking_secgroup_v2.http_group.id
}

resource "openstack_networking_secgroup_v2" "icmp_group" {
  name = "Allow ICMP Ingress"
}

resource "openstack_networking_secgroup_rule_v2" "icmp_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.admin_ip
  security_group_id = openstack_networking_secgroup_v2.icmp_group.id
}