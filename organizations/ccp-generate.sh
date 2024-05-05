#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=Staff
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/orgStaff.example.com/tlsca/tlsca.orgStaff.example.com-cert.pem
CAPEM=organizations/peerOrganizations/orgStaff.example.com/ca/ca.orgStaff.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgStaff.example.com/connection-orgStaff.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgStaff.example.com/connection-orgStaff.yaml

ORG=Accountant
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/orgAccountant.example.com/tlsca/tlsca.orgAccountant.example.com-cert.pem
CAPEM=organizations/peerOrganizations/orgAccountant.example.com/ca/ca.orgAccountant.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgAccountant.example.com/connection-orgAccountant.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgAccountant.example.com/connection-orgAccountant.yaml
