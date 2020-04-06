variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "infra-vpc-cidr" {
  description = "CIDR for the ext VPC"
  default     = "10.110.0.0/20"
}

variable "infra-public-subnet-cidr-01" {
  description = "CIDR for the ext public subnet 01"
  default     = "10.110.0.0/24"
}

variable "infra-public-subnet-cidr-02" {
  description = "CIDR for the ext public subnet 02"
  default     = "10.110.2.0/24"
}

variable "infra-public-subnet-cidr-03" {
  description = "CIDR for the ext public subnet 03"
  default     = "10.110.4.0/24"
}

variable "infra-private-subnet-cidr-01" {
  description = "CIDR for the ext private subnet 01"
  default     = "10.110.1.0/24"
}

variable "infra-private-subnet-cidr-02" {
  description = "CIDR for the ext private subnet 02"
  default     = "10.110.3.0/24"
}

variable "infra-private-subnet-cidr-03" {
  description = "CIDR for the ext private subnet 03"
  default     = "10.110.5.0/24"
}