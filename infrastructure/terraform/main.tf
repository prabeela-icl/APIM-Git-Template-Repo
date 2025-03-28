
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_api_management" "apim" {
  name                = "my-apim-instance"
  resource_group_name = "my-resource-group"
  location            = "East US"
  publisher_name      = "My Company"
  publisher_email     = "admin@company.com"
  sku_name            = "Consumption_0"
}
