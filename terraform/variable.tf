variable "instances" {
  type = map(string)
  default = {
    jenkins = "jenkins"
    docker  = "docker"
    tomcat  = "tomcat"
    ansible = "ansible"
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_pair" {
  type    = string
  default = "aws"
}

variable "security_group" {
  type    = set(string)
  default = ["launch-wizard-22"]
}

variable "volume_size_gb" {
  type    = number
  default = 20
}

variable "ami_id" {
  type    = string
  default = "ami-06a0cd9728546d178"
}