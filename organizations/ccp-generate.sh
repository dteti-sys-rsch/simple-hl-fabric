#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGMSP}/$4/" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGMSP}/$4/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=sardjito
ORGMSP=Sardjito
P0PORT=7021
CAPORT=7011
PEERPEM=organizations/peerOrganizations/sardjito.hospital.com/tlsca/tlsca.sardjito.hospital.com-cert.pem
CAPEM=organizations/peerOrganizations/sardjito.hospital.com/ca/ca.sardjito.hospital.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $ORGMSP $PEERPEM $CAPEM)" > organizations/peerOrganizations/sardjito.hospital.com/connection-sardjito.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $ORGMSP $PEERPEM $CAPEM)" > organizations/peerOrganizations/sardjito.hospital.com/connection-sardjito.yaml

ORG=dharmais
ORGMSP=Dharmais
P0PORT=7031
CAPORT=7012
PEERPEM=organizations/peerOrganizations/dharmais.hospital.com/tlsca/tlsca.dharmais.hospital.com-cert.pem
CAPEM=organizations/peerOrganizations/dharmais.hospital.com/ca/ca.dharmais.hospital.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $ORGMSP $PEERPEM $CAPEM)" > organizations/peerOrganizations/dharmais.hospital.com/connection-dharmais.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $ORGMSP $PEERPEM $CAPEM)" > organizations/peerOrganizations/dharmais.hospital.com/connection-dharmais.yaml
