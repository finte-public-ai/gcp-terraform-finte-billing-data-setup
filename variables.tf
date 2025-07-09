variable "gcp_org_id" {
  type        = string
  description = "GCP Organization ID."
}

variable "gcp_billing_data_project_id" {
  type        = string
  description = "Project identifier where the billing data will be stored. If not provided and create_project=true, a new project ID will be generated."
  default     = null
}

variable "gcp_billing_data_dataset_id" {
  type        = string
  description = "Dataset identifier where the billing data will be stored."
  default     = "all_billing_data"
}

variable "gcp_billing_data_dataset_description" {
  type        = string
  description = "Dataset description for the billing data."
  default     = "All billing data (required by FinTe)"
}

variable "create_project" {
  type        = bool
  description = "Whether to create a new project. If false, gcp_billing_data_project_id must be provided."
  default     = true
}

variable "project_name" {
  type        = string
  description = "Name for the new project (only used if create_project is true)."
  default     = "Billing BigQuery"
}

variable "gcp_billing_account_id" {
  type        = string
  description = "GCP Billing Account ID."
}

variable "gcp_services" {
  type = list(string)
  default = [
    "bigquery.googleapis.com",
    "bigquerydatatransfer.googleapis.com"
  ]
  description = "List of Google Cloud APIs to enable."
}
