resource "openstack_compute_instance_v2" "webserver" {
  name            = "webserver1"
  image_id        = "c3c0e181-8fe1-4197-b23e-1ccbd22604a3"
  flavor_name     = "ds2G"
  key_pair        = "openstack_terraform"
  security_groups = [openstack_networking_secgroup_v2.ssh_group.name, openstack_networking_secgroup_v2.http_group.name, openstack_networking_secgroup_v2.icmp_group.name]

  network {
    port = openstack_networking_port_v2.webserver_port.id
  }

  provisioner "local-exec" {
    command = <<EOT
     echo 'Waiting for SSH port...';
     while ! nc -z -w 3 ${openstack_networking_floatingip_v2.floatip_1.address} 22; do sleep 5; done;

  	echo 'SSH port open! Waiting for cloud-init background updates to finish completely...';
  	ssh -o StrictHostKeyChecking=no -i ~/.ssh/openstack_terraform.pem ubuntu@${openstack_networking_floatingip_v2.floatip_1.address} "cloud-init status --wait"

  	echo 'VM is completely idle. Executing Ansible...';
  	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i ${openstack_networking_floatingip_v2.floatip_1.address}, -e ansible_python_interpreter=/usr/bin/python3 --private-key=~/.ssh/openstack_terraform.pem ../ansible/site.yml
   EOT
  }
}