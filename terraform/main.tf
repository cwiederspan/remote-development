terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  version = "=1.35.0"
}

variable "name_prefix" { }
variable "name_base" { }
variable "name_suffix" { }

variable "location" { }

variable "computerName" { }
variable "username" { }
variable "password" { }

variable "timezone" { }

variable "vm" {
  type = "map"
}

locals {
  base_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}

resource "azurerm_resource_group" "myGroup" {
  name     = "${local.base_name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "myVnet" {
  name                = "${local.base_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.myGroup.location}"
  resource_group_name = "${azurerm_resource_group.myGroup.name}"
}

resource "azurerm_subnet" "mySubnet" {
  name                 = "${local.base_name}-subnet"
  resource_group_name  = azurerm_resource_group.myGroup.name
  virtual_network_name = azurerm_virtual_network.myVnet.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "myIp" {
  name                = "${local.base_name}-ip"
  resource_group_name = azurerm_resource_group.myGroup.name
  location            = azurerm_resource_group.myGroup.location
  allocation_method   = "Static"
  domain_name_label   = "${lower(var.computerName)}"
}

resource "azurerm_network_security_group" "myNsg" {
  name                = "${local.base_name}-nsg"
  resource_group_name = azurerm_resource_group.myGroup.name
  location            = azurerm_resource_group.myGroup.location

  security_rule {
    name                      = "RDP"
    priority                  = 300
    direction                 = "Inbound"
    access                    = "Allow"
    protocol                  = "Tcp"
    source_address_prefix       = "*"
    source_port_range           = "*"
    destination_address_prefix  = "*"
    destination_port_range      = "3389"
  }
}

resource "azurerm_network_interface" "myNic" {
  name                      = "${local.base_name}-nic"
  location                  = azurerm_resource_group.myGroup.location
  resource_group_name       = azurerm_resource_group.myGroup.name
  network_security_group_id = azurerm_network_security_group.myNsg.id

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.mySubnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.myIp.id
  }
}

resource "azurerm_virtual_machine" "myVm" {
  name                  = var.computerName
  location              = var.location
  resource_group_name   = azurerm_resource_group.myGroup.name
  network_interface_ids = [azurerm_network_interface.myNic.id]  
  vm_size               = "Standard_D8s_v3"
  license_type          = "Windows_Client"  # Use Hybrid License

  delete_data_disks_on_termination = false  # Hard-coded for safety

  storage_image_reference {
    publisher = var.vm["publisher"]
    offer     = var.vm["offer"]
    sku       = var.vm["sku"]
    version   = var.vm["version"]
  }
  
  storage_os_disk {
    name              = "${local.base_name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = "128"   # Can also be 256
  }  
  
  os_profile {
    computer_name  = var.computerName
    admin_username = var.username
    admin_password = var.password
  }
  
  os_profile_windows_config {
    enable_automatic_upgrades = true  
    provision_vm_agent        = true
    timezone                  = var.timezone
  }
}