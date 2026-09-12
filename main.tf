resource "azurerm_resource_group" "rg1"{
    name ="rg"
    location ="centralindia"
}

resource "azurerm_virtual_network" "vnet1"{
    name = "vnet"
    location = azurerm_resource_group.rg1.location
    resource_group_name = azurerm_resource_group.rg1.name
    address_space = ["10.1.0.0/16"]

}

resource "azurerm_subnet" "subnet1"{
    name = "subnet"
    resource_group_name = azurerm_resource_group.rg1.name
    virtual_network_name = azurerm_virtual_network.vnet1.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic1" {
    name = "nic"
    location = azurerm_resource_group.rg1.location
    resource_group_name = azurerm_resource_group.rg1.name

    ip_configuration {
        name = "ipconfig"
        subnet_id = azurerm_subnet.subnet1.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "vm1" {
    name = "vm"
    resource_group_name = azurerm_resource_group.rg1.name
    location = azurerm_resource_group.rg1.location
    size = "Standard_B1s"
    admin_username = "adminuser"
    admin_password = "asdfg@1234"
    network_interface_ids = [azurerm_network_interface.nic1.id]

    # admin_ssh_key {
    #     username = "adminuser"
    #     public_key = file("~/.ssh/id_rsa.pub")
    # }
    
    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
}


