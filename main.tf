resource "google_compute_address" "static" {
  project   = "teleport-gateway-7717"
  name      = "ipv4-address"
  region    = "europe-north1"
}


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
      nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = <<SCRIPT
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt install docker.io -y
    sudo systemctl enable docker --now
    useradd -m teleport
    mkdir -p ~/teleport/config ~/teleport/data
    docker run --hostname localhost --rm \
               --entrypoint=/bin/sh \
               -v ~/teleport/config:/etc/teleport \
               quay.io/gravitational/teleport:9.3.7 -c "teleport configure > /etc/teleport/teleport.yaml"
    docker run --hostname localhost --name teleport \
               -v ~/teleport/config:/etc/teleport \
               -v ~/teleport/data:/var/lib/teleport \
               -p 3023:3023 -p 3025:3025 -p 3080:3080 \
               quay.io/gravitational/teleport:9.3.7
    SCRIPT

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  =  "911666449602-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}
