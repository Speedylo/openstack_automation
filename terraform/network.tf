resource "openstack_networking_network_v2" "private_net" {
  name           = "private"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "private_sub" {
  name            = "private-subnet"
  network_id      = openstack_networking_network_v2.private_net.id
  cidr            = "10.0.0.0/24"
  ip_version      = 4
  dns_nameservers = ["192.168.117.1"]
}

resource "openstack_networking_router_v2" "router" {
  name                = "router1"
  admin_state_up      = true
  external_network_id = "f7ebe285-1c17-4d0e-a800-912b78e36c28"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private_sub.id
}

resource "openstack_networking_port_v2" "webserver_port" {
  name           = "webserver-port"
  network_id     = openstack_networking_network_v2.private_net.id
  admin_state_up = true

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.private_sub.id
  }

  security_group_ids = [
    openstack_networking_secgroup_v2.ssh_group.id,
    openstack_networking_secgroup_v2.http_group.id,
    openstack_networking_secgroup_v2.icmp_group.id
  ]
}

resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "public"
}

resource "openstack_networking_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.floatip_1.address
  port_id     = openstack_networking_port_v2.webserver_port.id
}