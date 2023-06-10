#!/bin/bash

echo "PXE (Preboot Execution Environment) from an Ubuntu Server. PXE allows you to boot computers over a network using the network interface card (NIC), without the need for a local hard drive or other storage devices."
echo "To set up PXE on Ubuntu Server, you need to perform the following steps:"<br><br>
echo "Install and configure a DHCP server: PXE relies on DHCP to assign IP addresses and provide network configuration to the client computers. Install a DHCP server on your Ubuntu Server and configure it to provide the necessary PXE-related information."
echo "Install and configure a TFTP server: PXE requires a TFTP (Trivial File Transfer Protocol) server to transfer the boot files to the client computers. Install and configure a TFTP server on your Ubuntu Server, and make sure it's accessible to the network."
echo "Prepare the boot files: PXE requires specific boot files for the clients to boot over the network. You need to obtain these files and configure them accordingly. The boot files usually include the PXE bootloader (such as PXELINUX or iPXE) and the kernel/initrd files for the operating system you want to boot."
echo "Configure the DHCP server: Modify the DHCP server configuration to provide the appropriate PXE boot file and the location of the TFTP server to the clients. This information will be used by the clients to fetch the necessary files and boot over the network."
echo "Set up the TFTP server: Place the boot files obtained in step 3 in the appropriate directory of the TFTP server. The exact location may vary depending on the TFTP server software you are using."
echo "Test the PXE boot: Connect a client computer to the same network as your Ubuntu Server and configure it to boot from the network (PXE). When you start the client computer, it should receive an IP address from the DHCP server, fetch the necessary boot files from the TFTP server, and initiate the network boot process."
echo "By following these steps, you can successfully set up PXE on your Ubuntu Server and use it to boot client computers over the network. Make sure to consult the documentation or specific guides for the DHCP and TFTP server software you choose to ensure proper configuration and compatibility."


#!/bin/bash

# Function to install and configure the DHCP server
install_configure_dhcp_server() {
    # Install DHCP server
    sudo apt-get update
    sudo apt-get install -y isc-dhcp-server

    # Configure DHCP server
    # Edit the /etc/dhcp/dhcpd.conf file to add PXE-related information
    # For example:
    sudo sed -i '/^# option domain-name/s/^# //' /etc/dhcp/dhcpd.conf
    sudo sed -i '/^# option domain-name-servers/s/^# //' /etc/dhcp/dhcpd.conf
    sudo sed -i '/^# option subnet-mask/s/^# //' /etc/dhcp/dhcpd.conf
    sudo sed -i '/^# option broadcast-address/s/^# //' /etc/dhcp/dhcpd.conf
    sudo sed -i '/^# option routers/s/^# //' /etc/dhcp/dhcpd.conf
    sudo sed -i '/^# option tftp-server-name/s/^# //' /etc/dhcp/dhcpd.conf
    sudo sed -i '/^# filename/s/^# //' /etc/dhcp/dhcpd.conf

    # Restart DHCP server
    sudo systemctl restart isc-dhcp-server
}

# Function to install and configure the TFTP server
install_configure_tftp_server() {
    # Install TFTP server
    sudo apt-get update
    sudo apt-get install -y tftpd-hpa

    # Configure TFTP server
    # Edit the /etc/default/tftpd-hpa file to set TFTP_DIRECTORY to the appropriate directory
    # For example:
    sudo sed -i 's/^TFTP_DIRECTORY=.*/TFTP_DIRECTORY="\/var\/lib\/tftpboot"/' /etc/default/tftpd-hpa

    # Restart TFTP server
    sudo systemctl restart tftpd-hpa
}

# Function to prepare the boot files
prepare_boot_files() {
    # Obtain and configure the boot files
    # Place the boot files (PXE bootloader, kernel, initrd, etc.) in the appropriate directory
    # For example, create /var/lib/tftpboot directory and copy the files there
    sudo mkdir -p /var/lib/tftpboot
    # Copy the necessary boot files to /var/lib/tftpboot

    # Set permissions for TFTP server
    sudo chown -R nobody:nogroup /var/lib/tftpboot

    # Restart TFTP server
    sudo systemctl restart tftpd-hpa
}

# Function to configure the DHCP server
configure_dhcp_server() {
    # Edit the /etc/dhcp/dhcpd.conf file to provide the appropriate PXE boot file and TFTP server location
    # For example:
    sudo sed -i 's/option tftp-server-name.*/option tftp-server-name "192.168.1.100";/' /etc/dhcp/dhcpd.conf
    sudo sed -i 's/filename "pxelinux.0";/filename "filename_of_pxe_boot_file";/' /etc/dhcp/dhcpd.conf

    # Restart DHCP server
    sudo systemctl restart isc-dhcp-server
}

# Function to test the PXE boot
test_pxe_boot() {
    echo " Connect a client computer to the network and configure it to boot from the network (PXE)"
    echo " Start the client computer and check if it receives an IP address from the DHCP server"
    echo " Verify if the client fetches the necessary boot files from the TFTP server and initiates the network boot process"
    echo " Monitor the logs on the DHCP and TFTP servers for any errors"
}

# Main script

# Call the functions in the desired order
install_configure_dhcp_server
install_configure_tftp_server
prepare_boot_files
configure_dhcp_server
test_pxe_boot
