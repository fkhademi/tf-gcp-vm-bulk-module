#variable "name" {}
variable "region" {}
variable "vpc" {}
variable "subnet" {}
variable "ssh_key" {}
# For updating Route53 DNS
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-central-1"
}
variable "instance_size" {
  default = "f1-micro"
}
variable "num_vms" {
  default = 1
}
variable "hostname" {
  default = "srv"
}
variable "domain_name" {
  default = "avxlab.de"
}
variable "cloud_init_data" {}