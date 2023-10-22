data "template_file" "hostname_init" {
  template = file("${path.module}/script.tpl")
  vars = {
    admin_password = var.admin_password
    host_name = var.host_name
  }
}

# data "aws_ami" "windows" {
#   most_recent = true
  
#   filter {
#        name   = "virtualization-type"
#        values = ["hvm"]
#   }

#   filter {
#     name   = "name"
#     values = ["Windows_Server-2019-English-Full-Base-*"]
#   }
# }

resource "aws_instance" "golfzon-windows" {
#   ami           = data.aws_ami.windows.id
  ami           = "ami-0e08d64c86693b8ed"
  instance_type = "t3.micro"

  ## network interface for ip addrs attachment dynamically
  network_interface {
    network_interface_id = aws_network_interface.golfzon-nic.id
    device_index         = 0
  }

  key_name = "golfzon-test-keypair"
  user_data = data.template_file.hostname_init.rendered

  tags = {
    Name = "golfzon-poc-windows"
  }
}

## network interface for instance: 
resource "aws_network_interface" "golfzon-nic" {
  subnet_id   = aws_subnet.golfzon-subnet.id
  private_ips = [var.priv_ip]
  #security_groups = [""]

  tags = {
    Name = "golfzon-poc-windows"
  }
}

## elastic ip: attach to golfzon-nic for instance && associate private ip for instance
resource "aws_eip" "golfzon-eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.golfzon-nic.id
  associate_with_private_ip = var.priv_ip

  tags = {
    Name = "golfzon-poc-windows"
  }

  depends_on = [
    aws_instance.golfzon-windows
  ]

}

## test subnet on golfzon-vpc: golfzon-subnet (10.0.1.0/24)
resource "aws_subnet" "golfzon-subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "golfzon-poc"
  }
}


