output "project_id" {
  description = "The ID of the project where the BigQuery dataset is located"
  value       = local.project_id
}

output "dataset_id" {
  description = "The ID of the BigQuery dataset"
  value       = google_bigquery_dataset.finte_dataset.dataset_id
}

output "dataset_self_link" {
  description = "The self-link of the BigQuery dataset"
  value       = google_bigquery_dataset.finte_dataset.self_link
}

output "project_created" {
  description = "Whether a new project was created"
  value       = var.create_project
}
