# Remove Development with VS Code

## Getting Started

VS Code now offers the ability to develop remotely against containers, SSH and WSL. This allows
developers to quickly get up to speed on new technologies and on-ramp into existing projects with
ease.

For more information, here are more resources:

* [Remote Development Overview](https://code.visualstudio.com/docs/remote/remote-overview)
* [Tutorials](https://code.visualstudio.com/docs/remote/remote-tutorials)


## Clone this Repository

```bash
git clone https://github.com/cwiederspan/remote-development.git

cd remote-development
```

## Virtual Machine Setup (Optional)

You can create a lab VM in Azure using the following [Terraform](terraform/main.tf) script like this:

```bash
# Navigate to the terraform directory
cd terraform

# Declare your Username and Password for the VM
echo -e "username = \"YOUR_USERNAME\"\npassword = \"YOUR_PASSWORD\"" >> secrets.tfvars

# Execute the Terraform script
terraform apply --var-file secrets.tfvars
```

Once your VM has booted up, you can RDP into the box, where you will need to make the following changes:

* [Set Windows Update to use the Fast Ring](https://insider.windows.com/en-us/how-to-pc/) - This enables WSL 2 support

* [Turn on the Windows Subsystem for Linux feature](https://docs.microsoft.com/en-us/windows/wsl/install-win10) - This enables the WSL/WSL2 feature
  
  ```powershell
  # Open PowerShell as Administrator and run this command
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
  ```

* [Turn on the Hyper-V](https://docs.microsoft.com/en-us/windows/wsl/install-win10) - This enables Hyper-V which is required for Docker
  
  ```powershell
  # Open PowerShell as Administrator and run this command
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
  ```

* [Install Ubuntu 18.04 LTS from the Windows Store](https://www.microsoft.com/en-us/p/ubuntu-1804-lts/9n9tngvndl3q?activetab=pivot:overviewtab) - Install the Linux kernel

* [Make Ubuntu the default distribution](https://docs.microsoft.com/en-us/windows/wsl/wsl2-install) - Make it the default distribution
  
  ```bash
  wsl --set-version Ubuntu-18.04 2
  ```

* [Install VS Code](https://code.visualstudio.com/) - Get the VS Code application

* [Install the Docker for WSL 2 Tech Preview](https://docs.docker.com/docker-for-windows/wsl-tech-preview/) - A special version of Docker that with support for WSL 2

* [Install Terminal Preview from Windows Store](https://www.microsoft.com/en-us/p/windows-terminal-preview/9n0dx20hk701?activetab=pivot:overviewtab) - A better terminal experience

