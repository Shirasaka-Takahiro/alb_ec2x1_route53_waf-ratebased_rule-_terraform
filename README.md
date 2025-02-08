README.md
■Set-Up
1. Create S3 for tfstate ex)example-dev-tfstate-bucket
2. Generate public and private key
3. Write resource's variables in terraform.tfvars

■Resources
<br />
Network
<br />
EC2
<br />
ALb x 1(HTTP Listener)
<br />
Route53
<br />
WAF (ratebased_rule x 1 , managed_rule x 5)
<br />
SNS
<br />
CloudWatch
<br />

■Deploy
1. Move to direstory
2. terraform init
3. terraform plan
4. terraform apply