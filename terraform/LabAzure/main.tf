# Bloque para crear un grupo de recursos en Azure
resource "azurerm_resource_group" "main" {
  name     = "Lab-Azure"  # Nombre del grupo de recursos
  location = "east us"    # Ubicación geográfica del grupo de recursos
}

# Bloque para crear una red virtual en Azure
resource "azurerm_virtual_network" "main" {
  name                = "virtualnet-lab"  # Nombre de la red virtual
  address_space       = ["10.0.0.0/16"]  # Rango de direcciones IP de la red
  location            = "${azurerm_resource_group.main.location}"  # Ubicación del grupo de recursos
  resource_group_name = "${azurerm_resource_group.main.name}"      # Nombre del grupo de recursos asociado
}

# Bloque para crear una subred en la red virtual
resource "azurerm_subnet" "internal" {
  name                 = "internal"  # Nombre de la subred
  resource_group_name  = "${azurerm_resource_group.main.name}"         # Nombre del grupo de recursos
  virtual_network_name = "${azurerm_virtual_network.main.name}"         # Nombre de la red virtual
  address_prefixes     = ["10.0.2.0/24"]  # Rango de direcciones IP de la subred
}

# Bloque para crear una interfaz de red
resource "azurerm_network_interface" "main" {
  name                = "Interfaz-Red-Lab"  # Nombre de la interfaz de red
  location            = "${azurerm_resource_group.main.location}"      # Ubicación del grupo de recursos
  resource_group_name = "${azurerm_resource_group.main.name}"          # Nombre del grupo de recursos asociado

  # Configuración de la dirección IP de la interfaz de red
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"     # ID de la subred asociada
    private_ip_address_allocation = "Dynamic"  # Asignación de IP privada dinámica
  }
}

# Bloque para crear una máquina virtual en Azure
resource "azurerm_virtual_machine" "main" {
  name                  = "LabAzure"  # Nombre de la máquina virtual
  location              = "${azurerm_resource_group.main.location}"  # Ubicación del grupo de recursos
  resource_group_name   = "${azurerm_resource_group.main.name}"      # Nombre del grupo de recursos asociado
  network_interface_ids = ["${azurerm_network_interface.main.id}"]   # ID de la interfaz de red asociada
  vm_size               = "Standard_DS1_v2"  # Tamaño de la VM

  # Configuración para eliminar el disco del sistema operativo al terminar la VM
  delete_os_disk_on_termination = true

  # Configuración para eliminar los discos de datos al terminar la VM
  delete_data_disks_on_termination = true

  # Configuración de la imagen del sistema operativo
  storage_image_reference {
    publisher = "microsoftwindowsserver"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  # Configuración del disco del sistema operativo
  storage_os_disk {
    name              = "DiskLab"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Configuración del perfil del sistema operativo
  os_profile {
    computer_name  = "rcwinservervm"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  # Configuración adicional del sistema operativo (Windows)
  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent       = true
  }

  # Etiquetas para identificar la VM
  tags = {
    environment = "dev"
  }
}

# Bloque de configuración del proveedor "azurerm"
provider "azurerm" {
  features {}  # Sin características adicionales habilitadas
  skip_provider_registration = true  # Deshabilita el registro automático de proveedores
}
