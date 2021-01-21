data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "^amzn2-ami-hvm.*-ebs"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# data "aws_subnet" "subnets" {
#   count = length(var.elb_subnets)
#   id    = var.elb_subnets[count.index]
# }

#############################################################
# Data sources to get VPC Details
##############################################################
data "aws_vpc" "usbank_vpc" {
  filter {
    name = "tag:Name"
    values = ["bankus_east-1-vpc"]
  }
}


##############################################################
# Data sources to get subnets
##############################################################

data "aws_subnet_ids" "database" {
  vpc_id = data.aws_vpc.usbank_vpc.id
 tags = {
    Name = "bankus_east-1-vpc-db-*"
 }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.usbank_vpc.id
 tags = {
    Name = "bankus_east-1-vpc-public-*"
 }
}


data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.usbank_vpc.id
 tags = {
    Name = "bankus_east-1-vpc-private-*"
 }
}

data "aws_subnet" "private" {
  vpc_id = data.aws_vpc.usbank_vpc.id
  count = length(data.aws_subnet_ids.database.ids)
  id    = local.subnet_ids_list[count.index]
}

data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.usbank_vpc.id
  count = length(data.aws_subnet_ids.public.ids)
  id    = local.subnet_ids_list[count.index]
}

data "aws_subnet" "database" {
  vpc_id = data.aws_vpc.usbank_vpc.id
  count = length(data.aws_subnet_ids.database.ids)
  id    = local.subnet_ids_list[count.index]
}



data "aws_security_group" "this" {
  vpc_id = data.aws_vpc.usbank_vpc.id
  tags = {
  Name = "usbank-appserv"
  }
}




