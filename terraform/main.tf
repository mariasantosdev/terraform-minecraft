module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.3"

  project_id   = var.project_id
  network_name = "workloads-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "workload-subnet"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    }
  ]

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}

module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = module.vpc.network_name

  rules = [{
    name                    = "allow-ssh-ingress"
    description             = "admin ssh access"
    direction               = "INGRESS"
    priority                = null
    source_ranges           = [format("%s/32", var.admin_ip)]
    target_tags             = ["ingress-inet"]
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
  }]
}

resource "google_compute_instance" "workloads_compute" {
  name         = "workloads"
  machine_type = "n4-standard-2"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = module.vpc.network_name
    subnetwork = module.vpc.subnets_names[0]

    access_config {
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "VM pronta" > /test.txt
  EOF
}
