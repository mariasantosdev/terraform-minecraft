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