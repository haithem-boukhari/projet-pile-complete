variable "vnet_address_space" {
  default = "10.0.0.0/16"
}

variable "subnet_prefix" {
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24",
    ]

}

resource "azurerm_resource_group" "test" {
  name     = "projetTerra1"
  location = "West Europe"
}

resource "azurerm_virtual_network" "test" {
  name                = "VnetProjet"
  address_space       = ["${var.vnet_address_space}"]
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "test1" {
  name                 = "testsubnet1"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "${var.subnet_prefix[0]}"
}

resource "azurerm_subnet" "test2" {
  name                 = "testsubnet2"                                                                                resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "${var.subnet_prefix[1]}"
}
