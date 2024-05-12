#!/bin/bash

function createOrgStaff() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/orgStaff.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/orgStaff.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-orgStaff --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgStaff.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgStaff.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgStaff.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgStaff.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/orgStaff.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-orgStaff --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-orgStaff --id.name userStaff --id.secret userStaffpw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-orgStaff --id.name orgStaffadmin --id.secret orgStaffadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-orgStaff -M ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/msp --csr.hosts peer0.orgStaff.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-orgStaff -M ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgStaff.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/orgStaff.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgStaff.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/orgStaff.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgStaff.example.com/tlsca/tlsca.orgStaff.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/orgStaff.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/peers/peer0.orgStaff.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/orgStaff.example.com/ca/ca.orgStaff.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://userStaff:userStaffpw@localhost:7054 --caname ca-orgStaff -M ${PWD}/organizations/peerOrganizations/orgStaff.example.com/users/UserStaff@orgStaff.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgStaff.example.com/users/UserStaff@orgStaff.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://orgStaffadmin:orgStaffadminpw@localhost:7054 --caname ca-orgStaff -M ${PWD}/organizations/peerOrganizations/orgStaff.example.com/users/Admin@orgStaff.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgStaff/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgStaff.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgStaff.example.com/users/Admin@orgStaff.example.com/msp/config.yaml
  
  infoln "Generating the org user msp and registering 10 user staff"
  . ${PWD}organizations/fabric-ca/scripts/userStaff.sh
  
}


function createOrgAccountant() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/orgAccountant.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/orgAccountant.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-orgAccountant --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgAccountant.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgAccountant.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgAccountant.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgAccountant.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-orgAccountant --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user1"
  set -x
  fabric-ca-client register --caname ca-orgAccountant --id.name userAccountant --id.secret userAccountantpw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null
  
  infoln "Registering KT1"
  set -x
  fabric-ca-client register --caname ca-orgAccountant --id.name KT1 --id.secret KT1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null
  
  infoln "Registering KT2"
  set -x
  fabric-ca-client register --caname ca-orgAccountant --id.name KT2 --id.secret KT2pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering KT3"
  set -x
  fabric-ca-client register --caname ca-orgAccountant --id.name KT3 --id.secret KT3pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-orgAccountant --id.name orgAccountantadmin --id.secret orgAccountantadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-orgAccountant -M ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/msp --csr.hosts peer0.orgAccountant.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-orgAccountant -M ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgAccountant.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/tlsca/tlsca.orgAccountant.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/peers/peer0.orgAccountant.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/ca/ca.orgAccountant.example.com-cert.pem

  infoln "Generating the user1 msp"
  set -x
  fabric-ca-client enroll -u https://userAccountant:userAccountantpw@localhost:8054 --caname ca-orgAccountant -M ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/UserAccountant@orgAccountant.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null
  
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/UserAccountant@orgAccountant.example.com/msp/config.yaml

  infoln "Generating the userKT1 msp"
  set -x
  fabric-ca-client enroll -u https://KT1:KT1pw@localhost:8054 --caname ca-orgAccountant -M ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/KT1@orgAccountant.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null
  
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/KT1@orgAccountant.example.com/msp/config.yaml
  
  infoln "Generating the userKT2 msp"
  set -x
  fabric-ca-client enroll -u https://KT2:KT2pw@localhost:8054 --caname ca-orgAccountant -M ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/KT2@orgAccountant.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null
  
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/KT2@orgAccountant.example.com/msp/config.yaml
  
  infoln "Generating the userKT3 msp"
  set -x
  fabric-ca-client enroll -u https://KT3:KT3pw@localhost:8054 --caname ca-orgAccountant -M ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/KT3@orgAccountant.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null
  
  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/KT3@orgAccountant.example.com/msp/config.yaml  

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://orgAccountantadmin:orgAccountantadminpw@localhost:8054 --caname ca-orgAccountant -M ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/Admin@orgAccountant.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgAccountant/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgAccountant.example.com/users/Admin@orgAccountant.example.com/msp/config.yaml
}

function createOrgManager() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/orgManager.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/orgManager.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:21054 --caname ca-orgManager --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-21054-ca-orgManager.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-21054-ca-orgManager.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-21054-ca-orgManager.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-21054-ca-orgManager.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-orgManager --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-orgManager --id.name userManager --id.secret userManagerpw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null
  
  infoln "Registering GD1"
  set -x
  fabric-ca-client register --caname ca-orgManager --id.name GD1 --id.secret GD1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null
  
  infoln "Registering GD2"
  set -x
  fabric-ca-client register --caname ca-orgManager --id.name GD2 --id.secret GD2pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null
  
  infoln "Registering GD3"
  set -x
  fabric-ca-client register --caname ca-orgManager --id.name GD3 --id.secret GD3pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-orgManager --id.name orgManageradmin --id.secret orgManageradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:21054 --caname ca-orgManager -M ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/msp --csr.hosts peer0.orgManager.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:21054 --caname ca-orgManager -M ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgManager.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/orgManager.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgManager.example.com/tlsca/tlsca.orgManager.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/orgManager.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/peers/peer0.orgManager.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/orgManager.example.com/ca/ca.orgManager.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://userManager:userManagerpw@localhost:21054 --caname ca-orgManager -M ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/UserManager@orgManager.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/UserManager@orgManager.example.com/msp/config.yaml
  
  infoln "Generating the GD1 msp"
  set -x
  fabric-ca-client enroll -u https://GD1:GD1pw@localhost:21054 --caname ca-orgManager -M ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/GD1@orgManager.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/GD1@orgManager.example.com/msp/config.yaml
  
  infoln "Generating the GD2 msp"
  set -x
  fabric-ca-client enroll -u https://GD2:GD2pw@localhost:21054 --caname ca-orgManager -M ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/GD2@orgManager.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/GD2@orgManager.example.com/msp/config.yaml

  infoln "Generating the GD3 msp"
  set -x
  fabric-ca-client enroll -u https://GD3:GD3pw@localhost:21054 --caname ca-orgManager -M ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/GD3@orgManager.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/GD3@orgManager.example.com/msp/config.yaml


  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://orgManageradmin:orgManageradminpw@localhost:21054 --caname ca-orgManager -M ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/Admin@orgManager.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgManager/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgManager.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgManager.example.com/users/Admin@orgManager.example.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}
