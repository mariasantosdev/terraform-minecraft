variable "project_id" {
  type        = string
  description = "GCP's project ID to create the resource"
}

variable "region" {
  type = string
  description = "gcp region to create the resources"
  default = "us-east1"
}

variable "admin_ip" {
  type = string
  description = "public ip address from the administrator"
}

variable "ssh_user" {
  type    = string
  default = "madu"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}