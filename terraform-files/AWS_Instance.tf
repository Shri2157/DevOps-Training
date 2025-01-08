provider aws {
        region= us-east-1
    }

resource "aws_vpc" "test-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = test-vpc
    }
  
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.test-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "Public-subnet"
    }
     
}

resource "aws_internet_gateway" "test-IG" {
    vpc_id = aws_vpc.test-vpc.id
    tags = {
      Name = "Test-IG"
    }
}

resource "aws_route_table" "test_RT" {
    vpc_id = aws_vpc.test-vpc.id
    route {
        cidr_block = "10.1.0.0/16"
        gateway_id = aws_internet_gateway.test-IG.id
    }
    tags = {
        Name = "Test-RT"
    }
  
}

resource "aws_route_table_association" "RT-subnet-association" {
    subnet_id = aws_subnet.public-subnet.id
    route_table_id = aws_route_table.test_RT.id
}

resource "aws_security_group" "Test-SG" {
    vpc_id = aws_vpc.test-vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "Test-SG"
    }
  
}


/*
resource "aws_vpc_security_group_ingress_rule" "allow-443" {
    security_group_id = aws_security_group.Test-SG.id
    cidr_ipv4 = aws_vpc.test-vpc.cidr_block
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh-22" {
    security_group_id = aws_security_group.Test-SG.id
    cidr_ipv4 = aws_vpc.test-vpc.cidr_block
    from_port = 22
    ip_protocol = "ssh"
    to_port = 22
  
}

resource "aws_vpc_security_group_egress_rule" "allow-outbound-traffic" {
    security_group_id = aws_security_group.Test-SG.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
  
}
*/


resource "aws_instance" "test-server" {
    ami= "ami-830c94e3"
    instance_type = "t2.micro"
    
    subnet_id = aws_subnet.public-subnet.id
    security_groups = [aws_security_group.Test-SG.name]
    

    tags = {
        Name = test_server
    }
  
}


