# this creates a micro instance to host our teleport-gateway
resource "google_compute_instance" "default" {
  name         = "teleport-gateway"
  machine_type = "e2-micro"
  zone         = "europe-north1-a"
  project      = "teleport-gateway-7717"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  =  "911666449602-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}
