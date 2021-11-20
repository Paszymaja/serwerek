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

resource "null_resource" "update_server" {
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

resource "null_resource" "install_minecraft" {
  count      = var.install_minecraft ? 1 : 0
  depends_on = [hcloud_server.serwerek]

  triggers = { status = hcloud_server.serwerek.status }

  connection {
    type        = "ssh"
    private_key = file("secrets/terraform")
    host        = hcloud_server.serwerek.ipv4_address
    user        = "root"
  }

  provisioner "file" {
    source      = "minecraft.sh"
    destination = "/tmp/minecraft.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/minecraft.sh",
      "/tmp/minecraft.sh args",
    ]
  }
}
output "ip" {
  value = hcloud_server.serwerek.ipv4_address
}
