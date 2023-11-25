########## VPC ##########
resource "aws_vpc" "VPCLabFinalITM" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "VPCLabFinalITM"
    Env = "LAB"
  }
}

########## Subnets ##########
resource "aws_subnet" "SUBNET_LaboratorioFinal_1" {
  vpc_id = aws_vpc.VPCLabFinalITM.id
  cidr_block = "${var.subnet_1_cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SUBNET_LaboratorioFinal_1"
    Env = "LAB"
  }
  depends_on = [ aws_vpc.VPCLabFinalITM ]
}

resource "aws_subnet" "SUBNET_LaboratorioFinal_2" {
  vpc_id = aws_vpc.VPCLabFinalITM.id
  cidr_block = "${var.subnet_2_cidr}"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "SUBNET_LaboratorioFinal_2"
    Env = "LAB"
  }
  depends_on = [ aws_vpc.VPCLabFinalITM ]
}

############# Internet Gateway #############

resource "aws_internet_gateway" "IG_ITMLabFinal" {
  vpc_id = aws_vpc.VPCLabFinalITM.id
  tags = {
    Name = "IG_ITMLabFinal"
    Env = "LAB"
  }
}

############# Route Table #############

resource "aws_route_table" "RT_ITMLabFinal" {
  vpc_id = aws_vpc.VPCLabFinalITM.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG_ITMLabFinal.id
  }
 depends_on = [aws_internet_gateway.IG_ITMLabFinal]
 tags = {
    Name = "RT_ITMLabFinal"
    Env = "LAB"
  }
}

resource "aws_main_route_table_association" "RT_AssociationJoomla" {
  route_table_id = aws_route_table.RT_ITMLabFinal.id
  vpc_id         = aws_vpc.VPCLabFinalITM.id
}

############# EC2 Security Group #############

resource "aws_security_group" "SG_ITMLabFinal" {
  name = "SG_ITMLabFinal"
  vpc_id = aws_vpc.VPCLabFinalITM.id
  ingress {
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############# RDS Subnet Group #############

resource "aws_db_subnet_group" "SNG_ITMLabFinal" {
  name = "${var.rds_db_subnet_group_name}"
  subnet_ids = [aws_subnet.SUBNET_LaboratorioFinal_1.id,aws_subnet.SUBNET_LaboratorioFinal_2.id]
}

############# RDS MySQL #############

resource "aws_db_instance" "RDS_ITMLabFinal" {
  identifier           = "${var.rds_identifier}"
  allocated_storage    = "${var.rds_allocated_storage}"
  #name                 = "${var.rds_db_name}"
  engine               = "${var.rds_engine}"
  engine_version       = "${var.rds_engine_version}"
  instance_class       = "${var.rds_instance_class}"
  username             = "${var.rds_username}"
  password             = "${var.rds_password}"
  db_subnet_group_name = aws_db_subnet_group.SNG_ITMLabFinal.name
  vpc_security_group_ids = [aws_security_group.SG_ITMLabFinal.id]
  multi_az             = "${var.rds_multi_az}"
  publicly_accessible  = "${var.rds_publicly_accessible}"
  skip_final_snapshot  = true
}

############# EC2 Joomla Instance #############

resource "aws_instance" "EC2_Ubuntu_LabFinal" {
  ami = "${var.ec2_ubuntu_ami}"
  instance_type = "${var.ec2_Ubuntu_instance_type}"
  count = "${var.ec2_Ubuntu_instance_quantity}"
  subnet_id = aws_subnet.SUBNET_LaboratorioFinal_1.id
  key_name = "${var.aws_keypair}"
  security_groups = [aws_security_group.SG_ITMLabFinal.id]
  tags = {
    Name = "${var.ec2_Ubuntu_instance_name}"
  }
  user_data = <<EOF
#!/bin/bash
#Update and upgrade OS
apt-get update
apt-get upgrade -y
export TZ=America/Bogota
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
apt-get install -y tzdata
#Instalacion python3, pip package manage and virtualenv
apt-get install -y apache2 php libapache2-mod-php
# Start and enable Apache service
systemctl start apache2
systemctl enable apache2
# Add ec2-user to the apache group
usermod -a -G www-data ubuntu
# Grant ownership to ec2-user
chown -R ubuntu:www-data /var/www
# Set permissions
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
# Download sample PHP file
cd /var/www/html
wget https://raw.githubusercontent.com/AbhishekGit-AWS/beanStalk/master/index.php
EOF
}