provider "google" {
  version = "3.5.0"

  credentials = file("terraform-key.json") #user API login

  project = var.project
  region = var.region
  zone = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "new-terraform-network"
}
resource "google_compute_instance" "default_instance" {
  name = "tf-host"
  metadata_startup_script = file("startup.sh") # Scripts for installing httpd
  machine_type = "f1 micro"
  tags = ["web"]#tag for firewall
  zone = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
#firewall allow icmp, 80,8080,1000-2000 TCP with tag web
resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.vpc_default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  target_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}