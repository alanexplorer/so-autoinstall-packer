packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.0"
    }
  }
}

source "qemu" "ubuntu" {
  iso_url      = "iso/ubuntu-24.04-live-server.iso"
  iso_checksum = "none"

  output_directory = "output"
  format           = "qcow2"
  disk_size        = "20G"

  headless    = true
  accelerator = "none"

  memory = 2048
  cpus   = 2

  communicator = "ssh"
  ssh_username = "dev"
  ssh_password = "dev"
  ssh_timeout  = "30m"

  http_directory = "autoinstall"

  boot_wait = "5s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "console=tty1 console=ttyS0<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]

  # se quiser, deixe sem logs extras de qemu por enquanto
}

build {
  name    = "so-ubuntu-24.04-autoinstall"
  sources = ["source.qemu.ubuntu"]
}
