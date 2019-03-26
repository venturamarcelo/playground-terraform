# gcp
resource "google_compute_network" "dev_network" {
    name = "devnetwork"
    auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "dev-subnet" {
    ip_cidr_range = "10.0.1.0/24"
    name = "devsubnet"
    network = "${google_compute_network.dev_network.self_link}"
    region = "us-west1"
}

# aws
resource "aws_vpc" "env-example" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags {
        Name = "terraform"
    }

}
resource "aws_subnet" "subnet1" {
    cidr_block = "${cidrsubnet(aws_vpc.env-example.cidr_block, 3, 1)}"
    vpc_id = "${aws_vpc.env-example.id}"
    availability_zone = "us-west-2a"
  
}

resource "aws_subnet" "subnet2" {
    cidr_block = "${cidrsubnet(aws_vpc.env-example.cidr_block, 2, 2)}"
    vpc_id = "${aws_vpc.env-example.id}"
    availability_zone = "us-west-2b"
}

resource "aws_security_group" "subnetsec" {
    vpc_id = "${aws_vpc.env-example.id}"
    ingress {
        cidr_blocks = ["${aws_vpc.env-example.cidr_block}"]
        from_port = 80
        to_port = 80
        protocol = "tcp"

    }

}
# Azure
resource "azurerm_resource_group" "azy_network" {
    location = "West US"
    name = "devresgr"

}

resource "azurerm_virtual_network" "blue_virtual_network" {
    address_space = ["10.0.0.0/16"]
    location = "West US"
    name = "bluevirtnetwork"
    resource_group_name = "${azurerm_resource_group.azy_network.name}"
    dns_servers = ["10.0.0.4","10.0.0.5"]
    subnet {
        name = "subnet1"
        address_prefix = "10.0.1.0/24"
    }
    subnet {
        name = "subnet2"
        address_prefix = "10.0.2.0/24"
    }
    tags {
        environment = "blue-world-finder"
    }
  
}

