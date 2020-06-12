# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "AzureLabs" {
  name     = "AzureLabs"
  location = "East US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "AzureLabs-V1" {
  name                = "AzureLabs-V1"
  resource_group_name = azurerm_resource_group.AzureLabs.name
  location            = azurerm_resource_group.AzureLabs.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "AzureLabsV1-10-1-1" {
  name                 = "AzureLabsV1-10.1.1"
  resource_group_name  = azurerm_resource_group.AzureLabs.name
  virtual_network_name = azurerm_virtual_network.AzureLabs-V1.name
  address_prefix       = "10.1.1.0/24"

}

resource "azurerm_network_interface" "AzureLabsV1-Nic1" {
  name                = "AzureLabsV1-Nic1"
  location            = azurerm_resource_group.AzureLabs.location
  resource_group_name = azurerm_resource_group.AzureLabs.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.AzureLabsV1-10-1-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "AzureLabsV1-Linux1" {
  name                = "AzureLabsV1-Linux1"
  resource_group_name = azurerm_resource_group.AzureLabs.name
  location            = azurerm_resource_group.AzureLabs.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.AzureLabsV1-Nic1.id,
  ]

    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_subnet" "AzureLabsV1-10-1-2" {
  name                 = "AzureLabsV1-10.1.2"
  resource_group_name  = azurerm_resource_group.AzureLabs.name
  virtual_network_name = azurerm_virtual_network.AzureLabs-V1.name
  address_prefix       = "10.1.2.0/24"

}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "AzureLabs-V2" {
  name                = "AzureLabs-V2"
  resource_group_name = azurerm_resource_group.AzureLabs.name
  location            = azurerm_resource_group.AzureLabs.location
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "AzureLabsV2-10-2-1" {
  name                 = "AzureLabsV2-10.2.1"
  resource_group_name  = azurerm_resource_group.AzureLabs.name
  virtual_network_name = azurerm_virtual_network.AzureLabs-V2.name
  address_prefix       = "10.2.1.0/24"

}

resource "azurerm_network_interface" "AzureLabsV2-Nic1" {
  name                = "AzureLabsV2-Nic1"
  location            = azurerm_resource_group.AzureLabs.location
  resource_group_name = azurerm_resource_group.AzureLabs.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.AzureLabsV2-10-2-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "AzureLabsV2-Win" {
  name                = "AzureLabsV2-Win"
  resource_group_name = azurerm_resource_group.AzureLabs.name
  location            = azurerm_resource_group.AzureLabs.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.AzureLabsV2-Nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_subnet" "AzureLabsV2-10-2-2" {
  name                 = "AzureLabsV1-10.2.2"
  resource_group_name  = azurerm_resource_group.AzureLabs.name
  virtual_network_name = azurerm_virtual_network.AzureLabs-V2.name
  address_prefix       = "10.2.2.0/24"

}