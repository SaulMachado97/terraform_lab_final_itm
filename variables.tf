#VPC CIDR Block
variable "vpc_cidr" {
    default = "172.30.0.0/16"
}

#Subunet 1 CIDR Block
variable "subnet_1_cidr" {
    default = "172.30.0.0/24"
}

#Subunet 2 CIDR Block
variable "subnet_2_cidr" {
    default = "172.30.1.0/24"
}

########## EC2 Instance Ubuntu ##########

#KeyPair
variable "aws_keypair"{
    default = "KP-LabITM-1"
}

#Ubuntu AMI
variable "ec2_ubuntu_ami"{
    default = "ami-06aa3f7caf3a30282"
}

#EC2 Instancance quantity
variable "ec2_Ubuntu_instance_quantity"{
    default = 1
}

# EC2 Joomla Instance Name
variable "ec2_Ubuntu_instance_name" {
  default = "Ubuntu Linux ITMLabFinal"
}

variable "ec2_Ubuntu_instance_type"{
    default = "t2.micro"
}

variable "ec2_Ubuntu_instance_ebs_name"{
    default = "/dev/sda1/"
}

# EC2 EBS Size
variable "ec2_Ubuntu_instance_ebs_size" {
  default = 10
}
#EC2 EBS Type
variable "ec2_Ubuntu_instance_ebs_type" {
  default = "gp2"
}
# RDS Allocated Storage
variable "rds_allocated_storage" {
  default = 20
}
# RDS DB Name
variable "rds_db_name" {
  default = "lab-smachado"
}
# RDS Identifier
variable "rds_identifier" {
  default = "dbsmachado"
}
# RDS DB Engine
variable "rds_engine" {
  default = "mysql"
}
# RDS DB Engine Version
variable "rds_engine_version" {
  default = "8.0.33"
}
# RDS Instance Class
variable "rds_instance_class" {
  default = "db.t3.micro"
}
# RDS Master Username
variable "rds_username" {
  default = "admin"
}
# RDS Master User Password
variable "rds_password" {
  default = "itmLab2023"
}
# RDS Subnet Group
variable "rds_db_subnet_group_name" {
  default = "itmlabfinal2023"
}
# RDS Multi AZ
variable "rds_multi_az" {
  default = false
}
# RDS Publicly Accessible
variable "rds_publicly_accessible" {
  default = true
}