variable "instance_type" {
  type        = string
  default = "t2.micro"
}

variable "ami_id" {
  type        = string
  default = "ami-002068ed284fb165b"
}

variable "region" {
  type        = string
  default = "us-east-2"
}
