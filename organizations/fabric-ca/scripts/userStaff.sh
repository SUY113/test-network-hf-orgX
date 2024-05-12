#!/bin/bash 

#!/bin/bash

# Hàm in thông báo
infoln() {
  echo -e "\x1B[1m$@\x1B[0m"
}

# Hàm tạo người dùng
create_user() {
  fabric-ca-client register --caname ca-orgStaff --id.name $1 --id.secret ${1}pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  
  fabric-ca-client enroll -u https://$1:${1}pw@localhost:7054 --caname ca-orgStaff -M ${PWD}/organizations/peerOrganizations/orgStaff.example.com/users/${1}@orgStaff.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgStaff.example.com/users/${1}@orgStaff.example.com/msp/config.yaml
}

# Số lượng người dùng cần tạo
number_of_users=10

# Vòng lặp tạo người dùng
for ((i=1; i<=$number_of_users; i++)); do
  username="NV$i"
  infoln "Registering and generating the user msp for $username"
  create_user $username
done

