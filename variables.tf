variable "name_prefix" {
  description = "Prefix used for the created resources"
  type        = string
}

variable "project_network" {
  description = "Name of the existing project network"
  type        = string
}

variable "image_name" {
  description = "Name of the image used for the VM"
  type        = string
}

variable "flavor_name" {
  description = "Flavor used for the VM"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR address allowed to connect using SSH"
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "ssh_allowed_cidr must be a valid CIDR address."
  }
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "page_message" {
  description = "Message displayed on the web page"
  type        = string
}
