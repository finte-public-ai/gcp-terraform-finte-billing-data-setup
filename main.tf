# Random suffix for project ID (only when creating new project without provided ID)
resource "random_id" "project_suffix" {
  count       = var.create_project && var.gcp_billing_data_project_id == null ? 1 : 0
  byte_length = 4
}

# Create project if requested
resource "google_project" "finte_billing_data_project" {
  count           = var.create_project ? 1 : 0
  name            = var.project_name
  project_id      = var.gcp_billing_data_project_id != null ? var.gcp_billing_data_project_id : "finte-billing-${random_id.project_suffix[0].hex}"
  org_id          = var.gcp_org_id
  billing_account = var.gcp_billing_account_id
}

# Determine the project ID to use for all resources
locals {
  project_id = var.create_project ? google_project.finte_billing_data_project[0].project_id : var.gcp_billing_data_project_id
}

# Enable required APIs
resource "google_project_service" "services" {
  for_each = toset(var.gcp_services)
  project  = local.project_id
  service  = each.value
}

# Create BigQuery dataset
resource "google_bigquery_dataset" "finte_dataset" {
  project     = local.project_id
  dataset_id  = var.gcp_billing_data_dataset_id
  description = var.gcp_billing_data_dataset_description

  depends_on = [google_project_service.services]
}
