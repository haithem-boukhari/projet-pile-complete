data "azurerm_subnet" "example" {
  name                 = "testsubnet2"
  virtual_network_name = "VnetProjet"
  resource_group_name  = "projetTerra1"
}

resource "azurerm_network_security_group" "mySecnsg" {
  name                = "nsgProjet2"
  location            = "West Europe"
  resource_group_name = "projetTerra1"

 security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "inbound"
    access                     = "allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

 security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 security_rule {
    name                       = "port-HTTP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"                                                   
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "mySecPubIp" {
  name                = "secpubip"
  resource_group_name = "projetTerra1"
  location            = "West Europe"
  allocation_method   = "Static"
  domain_name_label   = "my-vm-pile"
}


resource "azurerm_network_interface" "mySecNIC" {
  name                = "nameNIC2"
  location            = "West Europe"
  resource_group_name = "projetTerra1"
  network_security_group_id = "${azurerm_network_security_group.mySecnsg.id}"

  ip_configuration {
    name                          = "nameNICConfig2"
    subnet_id                     = "${data.azurerm_subnet.example.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.mySecPubIp.id}"
  }
}

resource "azurerm_virtual_machine" "mySecVm" {
  name                  = "vm2"
  location              = "West Europe"
  resource_group_name   = "projetTerra1"
  network_interface_ids = ["${azurerm_network_interface.mySecNIC.id}"]
  vm_size               = "Standard_B1ms"

  storage_os_disk {
    name              = "myosdisk20"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "projetAzure"
    admin_username = "pileUser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/pileUser/.ssh/authorized_keys"
      key_data = "${var.pubKey}"
    }
 }
}
