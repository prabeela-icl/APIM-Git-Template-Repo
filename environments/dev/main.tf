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

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = "prabeela-sandbox"
  location = var.location
}

resource "azurerm_api_management" "apim" {
  name                = "apim-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "ICL"
  publisher_email     = "p.sundararaj@imperial.ac.uk"
  sku_name            = var.sku

  # Enable public access
  virtual_network_type = "None"

    identity {
        type = "SystemAssigned"
    }
}

resource "azurerm_api_management_api" "sample_api" {
  name                = "sample-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Sample Public API"
  path                = "sample"
  protocols           = ["https"]
  service_url         = "https://api.publicapis.org/entries"

  import {
    content_format = "swagger-link-json"
    content_value  = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/examples/v3.0/petstore.json"
  }
}



resource "azurerm_api_management_api_policy" "public_policy" {
  api_name            = azurerm_api_management_api.sample_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <cors allow-credentials="false">
            <allowed-origins>
                <origin>*</origin>
            </allowed-origins>
            <allowed-methods>
                <method>GET</method>
                <method>POST</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
        </cors>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
</policies>
XML
}

output "apim_url" {
  value = azurerm_api_management.apim.gateway_url
}