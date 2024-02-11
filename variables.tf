resource "aws_vpc" "myvpc1" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub4" {
  vpc_id                  = aws_vpc.myvpc1.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub5" {
  vpc_id                  = aws_vpc.myvpc1.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub6" {
  vpc_id                  = aws_vpc.myvpc1.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.myvpc1.id
}

resource "aws_route_table" "RT1" {
  vpc_id = aws_vpc.myvpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta5" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta6" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSg1" {
  name   = "web"
  vpc_id = aws_vpc.myvpc1.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_s3_bucket" "example1" {
  bucket = "devchuckterraform2024project"
}

resource "aws_instance" "webserver4" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data              = base64encode(file("userdata.sh"))
}

resource "aws_instance" "webserver5" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data              = base64encode(file("userdata1.sh"))
}

resource "aws_instance" "webserver6" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub3.id
  user_data              = base64encode(file("userdata2.sh"))
}