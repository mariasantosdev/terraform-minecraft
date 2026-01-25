output "instance_ip" {
  description = "IP publico da VM workloads"
  value       = google_compute_instance.workloads_compute.network_interface[0].access_config[0].nat_ip
}
