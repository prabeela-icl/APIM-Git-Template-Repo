variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "UK West"
}

variable "sku" {
  description = "APIM SKU type"
  type        = string
  default     = "Developer_1" # Change for production
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "AZURE_RESOURCE_GROUP" {
  description = "Azure Resource Group Name"
  type        = string
}
