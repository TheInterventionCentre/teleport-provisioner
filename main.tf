variable "nodename" {
  type = string
  description = "This should be a fully qualified domain name (e.g., teleport.ivs.ai)"
  default = "teleport.ivs.ai"
}

variable "acme_companion_debug" {
  type = bool
  description = "Enable debug mode for acme companion"
  default = false
}

variable "letsencrypt_testcert" {
  type = bool
  description = "Enable debug mode for acme companion"
  default = false
}

resource "google_storage_bucket" "default" {
  project       = "teleport-gateway-7718"
  name          = "teleport-bucket-7718"
  force_destroy = false
  location      = "EU"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

resource "google_compute_address" "static" {
  project   = "teleport-gateway-7718"
  name      = "ipv4-address"
  region    = "europe-north1"
}

resource "google_compute_firewall" "ssh" {
  project   = "teleport-gateway-7718"
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = "teleport-network"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default" {
  project   = "teleport-gateway-7718"
  name    = "test-firewall"
  network = "teleport-network"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "3023", "3024", "3025", "3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  destroy_duration = "60s"
}

# this creates a micro instance to host our teleport-gateway
resource "google_compute_instance" "default" {
  name         = "teleport-gateway"
  machine_type = "e2-small"
  zone         = "europe-north1-a"
  project      = "teleport-gateway-7718"

  depends_on = [time_sleep.wait_60_seconds]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "teleport-network"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata_startup_script = templatefile("./scripts/startup.sh.tftpl", {nodename=var.nodename, acme_companion_debug=var.acme_companion_debug, letsencrypt_testcert=var.letsencrypt_testcert})

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  =  "674062162217-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}
