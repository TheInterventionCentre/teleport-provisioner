terraform {
 backend "gcs" {
   bucket  = "teleport-gateway-7718"
   prefix  = "terraform/state"
 }
}
