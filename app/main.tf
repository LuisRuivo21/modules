# PROVIDER
#----------------------------------------
provider "aws" {
  region = var.aws_region
}


# TERRAFORM CONFIGURATION 
#----------------------------------------
terraform {

  # Required providers and their versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}


# REUSABLE MODULES
#----------------------------------------

# module "alb" {
#   source         = "github.com/LuisRuivo21/modules//infrastructure/alb?ref=v1.0.0"
#   ec2_sg_id      = module.sg.ec2_sg_id
#   vpc_id         = module.network.vpc_id
#   public_subnets = [for subnet in module.network.public_subnets : subnet.id]
# }

module "asg" {
  source          = "github.com/LuisRuivo21/modules//infrastructure/asg?ref=v1.0.0"
  private_subnets = [for subnet in module.network.private_subnets : subnet.id]
  alb_tg_http_arn = module.alb.alb_tg_http_arn
  ssh_sg_id       = [module.sg.ssh_sg_id]
  alb_sg_id       = [module.sg.alb_sg_id]
  ec2_id          = module.ec2.ec2_id
}

module "ec2" {
  source         = "github.com/LuisRuivo21/modules//infrastructure//ec2?ref=v1.0.0"
  ssh_alb_sg_ids = module.sg.ssh_alb_sg_ids
}

module "network" {
  source = "github.com/LuisRuivo21/modules//infrastructure/network?ref=v1.0.0"
}

module "sg" {
  source = "github.com/LuisRuivo21/modules//infrastructure/asg?ref=v1.0.0"
  vpc_id = module.network.vpc_id
}