variable "hcloud_token" {
  sensitive = true # Requires terraform >= 0.14
}

variable "install_minecraft" {
  description = "If set to true, install minecraft server"
  type        = bool
}