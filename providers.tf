terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.32.1"
    }
  }
}



# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}