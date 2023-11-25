terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.0"
    }
  }
  backend "s3"{
    bucket = "laboratoriofinal.smachado.itm"
    key = "terraform.tfstate"
  #  region = "us-east-1"
  #  profile = "730806271232"
  }
}


provider "aws" {
  region = "us-east-1"
  #profile = "730806271232"
}