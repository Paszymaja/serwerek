terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.32.1"
    }
  }
}

variable "hcloud_token" {
  sensitive = true # Requires terraform >= 0.14
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# Create a new server running debian
resource "hcloud_server" "serwerek" {
  name        = "serwerek"
  image       = "ubuntu-20.04"
  server_type = "cx11"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.tf_ssh_key.id, hcloud_ssh_key.paszymaja_key.id]

}

resource "hcloud_ssh_key" "tf_ssh_key" {
  name       = "tf_ssh_key"
  public_key = file("secrets/terraform.pub")
}

resource "hcloud_ssh_key" "paszymaja_key" {
  name       = "paszymaja_key"
  public_key = file("/home/paszymaja/.ssh/id_rsa.pub")
}

resource "null_resource" "run_script" {
  depends_on = [hcloud_server.serwerek]

  triggers = { status = hcloud_server.serwerek.status }

  connection {
    type        = "ssh"
    private_key = file("secrets/terraform")
    host        = hcloud_server.serwerek.ipv4_address
    user        = "root"
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }
}

output "ip" {
  value = hcloud_server.serwerek.ipv4_address
}
