resource "google_compute_instance" "instance" {
  count = var.num_vms

  name         = "${var.hostname}-${count.index}"
  machine_type = var.instance_size
  zone         = "${var.region}-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network    = var.vpc
    subnetwork = var.subnet
  }

  tags = ["allow-ssh-${var.hostname}-${count.index}"]
  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}",
    metadata = var.cloud_init_data
  }
}

resource "google_compute_firewall" "fw" {
  count = var.num_vms

  name    = "allow-ssh-${var.hostname}-${count.index}"
  network = var.vpc

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["5201"]
  }

  allow {
    protocol = "udp"
    ports    = ["5201"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh-${var.hostname}-${count.index}"]
}

resource "aws_route53_record" "srv" {
  count = var.num_vms

  zone_id = data.aws_route53_zone.domain_name.zone_id
  name    = "${var.hostname}${count.index}.${data.aws_route53_zone.domain_name.name}"
  type    = "A"
  ttl     = "1"
  records = [google_compute_instance.instance[count.index].network_interface[0].network_ip]
}