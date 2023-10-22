variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "priv_ip" {
  description = "customed private ip for instance"
  type        = string
}

variable "host_name" {
  description = "customed hostname for instance"
  type        = string
}

variable "admin_password" {
  description = "Initial Password for Windows Admin"
  type        = string
  default     = "rhfvmwhs1!"
}

variable "vpc_id" {
  description = "vpc id"
  type = string
  default = "vpc-07b3a2c8059d7baa4"
}