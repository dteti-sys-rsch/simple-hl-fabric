#!/bin/bash

function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/sardjito.hospital.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/sardjito.hospital.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7011 --caname ca-sardjito --tls.certfiles ${PWD}/organizations/fabric-ca/sardjito/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7011-ca-sardjito.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7011-ca-sardjito.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7011-ca-sardjito.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7011-ca-sardjito.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/sardjito.hospital.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-sardjito --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/sardjito/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-sardjito --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/sardjito/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-sardjito --id.name sardjitoadmin --id.secret sardjitoadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/sardjito/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7011 --caname ca-sardjito -M ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/msp --csr.hosts peer0.sardjito.hospital.com --tls.certfiles ${PWD}/organizations/fabric-ca/sardjito/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7011 --caname ca-sardjito -M ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls --enrollment.profile tls --csr.hosts peer0.sardjito.hospital.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/sardjito/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/tlsca/tlsca.sardjito.hospital.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/ca
  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/peers/peer0.sardjito.hospital.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/ca/ca.sardjito.hospital.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7011 --caname ca-sardjito -M ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/users/User1@sardjito.hospital.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sardjito/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/users/User1@sardjito.hospital.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://sardjitoadmin:sardjitoadminpw@localhost:7011 --caname ca-sardjito -M ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/users/Admin@sardjito.hospital.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sardjito/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sardjito.hospital.com/users/Admin@sardjito.hospital.com/msp/config.yaml
}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/dharmais.hospital.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/dharmais.hospital.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7012 --caname ca-dharmais --tls.certfiles ${PWD}/organizations/fabric-ca/dharmais/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7012-ca-dharmais.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7012-ca-dharmais.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7012-ca-dharmais.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7012-ca-dharmais.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/dharmais.hospital.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-dharmais --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/dharmais/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-dharmais --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/dharmais/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-dharmais --id.name dharmaisadmin --id.secret dharmaisadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/dharmais/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7012 --caname ca-dharmais -M ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/msp --csr.hosts peer0.dharmais.hospital.com --tls.certfiles ${PWD}/organizations/fabric-ca/dharmais/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7012 --caname ca-dharmais -M ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls --enrollment.profile tls --csr.hosts peer0.dharmais.hospital.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/dharmais/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/tlsca/tlsca.dharmais.hospital.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/ca
  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/peers/peer0.dharmais.hospital.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/ca/ca.dharmais.hospital.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7012 --caname ca-dharmais -M ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/users/User1@dharmais.hospital.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/dharmais/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/users/User1@dharmais.hospital.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://dharmaisadmin:dharmaisadminpw@localhost:7012 --caname ca-dharmais -M ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/users/Admin@dharmais.hospital.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/dharmais/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/dharmais.hospital.com/users/Admin@dharmais.hospital.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/hospital.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/hospital.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7010 --caname ca-arsada --tls.certfiles ${PWD}/organizations/fabric-ca/arsadaOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7010-ca-arsada.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7010-ca-arsada.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7010-ca-arsada.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7010-ca-arsada.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/hospital.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-arsada --id.name arsada --id.secret arsadapw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/arsadaOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-arsada --id.name arsadaAdmin --id.secret arsadaAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/arsadaOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://arsada:arsadapw@localhost:7010 --caname ca-arsada -M ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/msp --csr.hosts arsada.hospital.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/arsadaOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/hospital.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://arsada:arsadapw@localhost:7010 --caname ca-arsada -M ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls --enrollment.profile tls --csr.hosts arsada.hospital.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/arsadaOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/msp/tlscacerts/tlsca.hospital.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/hospital.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/hospital.com/orderers/arsada.hospital.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/hospital.com/msp/tlscacerts/tlsca.hospital.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://arsadaAdmin:arsadaAdminpw@localhost:7010 --caname ca-arsada -M ${PWD}/organizations/ordererOrganizations/hospital.com/users/Admin@hospital.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/arsadaOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/hospital.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/hospital.com/users/Admin@hospital.com/msp/config.yaml
}
