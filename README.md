
# gcp-terraform-finte-billing-data-setup

GCP terraform module to create the BigQuery dataset to store billing data. Based on the [Export Cloud Billing data to BigQuery](https://cloud.google.com/billing/docs/how-to/export-data-bigquery) GCP documentation.

# Pre requirements

The service account running this Terraform script needs the following permissions:

## If Creating a New Project:
- `roles/resourcemanager.projectCreator` - Create new projects
- `roles/serviceusage.serviceUsageAdmin` - Enable APIs
- `roles/bigquery.dataEditor` - Create and manage BigQuery datasets

## If Using an Existing Project:
- `roles/serviceusage.serviceUsageAdmin` - Enable APIs
- `roles/bigquery.dataEditor` - Create and manage BigQuery datasets

## Organization Access:
- `roles/resourcemanager.organizationViewer` - Read organization information

## Example Usage

The example below uses `ref=main` (which is appended in the URL),  but it is recommended to use a specific tag version (i.e. `ref=1.0.0`) to avoid breaking changes. Go to the release page for a list of published versions. [releases page](https://github.com/finte-public-ai/gcp-terraform-finte-billing-data-setup/releases) for a list of published versions.

Replace `YOUR_ORGANIZATON_ID` with the organization ID. i.e. `111111111111`.

```
module "finte_billing_data" {
  source = "git::https://github.com/finte-public-ai/gcp-terraform-finte-billing-data-setup.git?ref=main"

  gcp_org_id                        = "YOUR_ORGANIZATON_ID"
}

output "finte_billing_data_info" {
  description = "Information about the billing data dataset"
  value = {
    project_id = module.finte_billing_data.project_id
    dataset_id = module.finte_billing_data.dataset_id
    project_created = module.finte_billing_data.project_created
  }
}
```

## Setup

### Terraform Instuctions
The following steps demonstrate how to create the billing dataset in GCP using this terraform module.

1. Add the code above to your terraform project.
2. Make sure the service account to authenticate this script has the necessary permissions as mentioned above.
3. Replace `main` in `ref=main` with the latest version from the [releases page](https://github.com/finte-public-ai/gcp-terraform-finte-billing-data-setup/releases).
4. Replace `YOUR_ORGANIZATON_ID` with the GCP organization domain.
8. Back in your terminal, run `terraform init` to download/update the module.
9. Run `terraform apply` and **IMPORTANT** review the plan output before typing `yes`.
10. Note the data output at the end of the terraform apply command as you will need to input this information to the FinTe "Add Credentials" form.

### Enable Billing Export
Once the terraform has created the billing dataset, you will still need to manually configure GCP to extract the billing data to your dataset as detailed in the [Billing Export](https://docs.google.com/document/d/1U9wysY8wVnQMd4If3QJ1wzUZaSlAFZhRCjxnAYTr1eI/edit?tab=t.mkwww84swex5) section of the FinTe Knowledge Base as this is not something that we are able to automate with terraform (see [Resource to export billing data to bigquery #4848](https://github.com/hashicorp/terraform-provider-google/issues/4848) for more information).

### Add Credentials to FinTe
You will need to include the Billing Project ID and Billing Dataset ID in the FinTe Credentials page to officially connect FinTe to your GCP instance. You can find the necessary credentials from the output that is generated after your terraform apply command completes successfully, which will look like the following:
```
Outputs:

finte_billing_data_info = {
  "dataset_id" = "all_billing_data"
  "project_created" = true
  "project_id" = "finte-billing-a38cc3d5"
}
```
Enter the value you find for `project_id` for the "Billing Project ID" and `dataset_id` for the "Billing Dataset ID".



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=5.16.0, <7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=5.16.0, <7.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.finte_dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_project.finte_billing_data_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_service.services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [random_id.project_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_project"></a> [create\_project](#input\_create\_project) | Whether to create a new project. If false, gcp\_billing\_data\_project\_id must be provided. | `bool` | `true` | no |
| <a name="input_gcp_billing_account_id"></a> [gcp\_billing\_account\_id](#input\_gcp\_billing\_account\_id) | GCP Billing Account ID. | `string` | n/a | yes |
| <a name="input_gcp_billing_data_dataset_description"></a> [gcp\_billing\_data\_dataset\_description](#input\_gcp\_billing\_data\_dataset\_description) | Dataset description for the billing data. | `string` | `"All billing data (required by FinTe)"` | no |
| <a name="input_gcp_billing_data_dataset_id"></a> [gcp\_billing\_data\_dataset\_id](#input\_gcp\_billing\_data\_dataset\_id) | Dataset identifier where the billing data will be stored. | `string` | `"all_billing_data"` | no |
| <a name="input_gcp_billing_data_project_id"></a> [gcp\_billing\_data\_project\_id](#input\_gcp\_billing\_data\_project\_id) | Project identifier where the billing data will be stored. If not provided and create\_project=true, a new project ID will be generated. | `string` | `null` | no |
| <a name="input_gcp_org_id"></a> [gcp\_org\_id](#input\_gcp\_org\_id) | GCP Organization ID. | `string` | n/a | yes |
| <a name="input_gcp_services"></a> [gcp\_services](#input\_gcp\_services) | List of Google Cloud APIs to enable. | `list(string)` | <pre>[<br/>  "bigquery.googleapis.com",<br/>  "bigquerydatatransfer.googleapis.com"<br/>]</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name for the new project (only used if create\_project is true). | `string` | `"Billing BigQuery"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataset_id"></a> [dataset\_id](#output\_dataset\_id) | The ID of the BigQuery dataset |
| <a name="output_dataset_self_link"></a> [dataset\_self\_link](#output\_dataset\_self\_link) | The self-link of the BigQuery dataset |
| <a name="output_project_created"></a> [project\_created](#output\_project\_created) | Whether a new project was created |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The ID of the project where the BigQuery dataset is located |
<!-- END_TF_DOCS -->
