resource "google_compute_network" "dev_network" {
    name = "devnetwork"
    auto_create_subnetworks = true
}

resource "aws_vpc" "env-example" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags {
        Name = "terraform"
    }
  
}

