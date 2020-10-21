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

  metadata_startup_script = "sudo apt-get update && sudo apt-get install iperf3 -y"

  tags = ["allow-ssh-${var.hostname}-${count.index}"]
  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
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