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

  ssh_username           = "dev"
  ssh_password           = "dev"
  ssh_timeout            = "30m"
  ssh_handshake_attempts = 20

  communicator = "ssh"

  http_directory = "autoinstall"

  boot_wait = "5s"
  boot_command = [
    "<esc><wait>",
    "<esc><wait>",
    "linux /casper/vmlinuz --- autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "quiet ",
    "initrd /casper/initrd",
    "<enter>"
  ]
}

build {
  name    = "so-ubuntu-24.04-autoinstall"
  sources = ["source.qemu.ubuntu"]
}
