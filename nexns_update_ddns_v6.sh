#!/bin/bash

# please modify the following params
CONTROLLER_URL="http://localhost:8000"
DOMAIN_NAME="example.com"
SUBDOMAIN="www" # can be empty string if you want to update "AAAA" of "example.com" only
ZONE_NAME="default"
TYPE="AAAA"
TTL=3600

# API URL
API_URL="${CONTROLLER_URL}/api/v1/record-quick-update/"

# check curl or wget
check_curl() {
    if command -v curl &> /dev/null; then
        HTTP_COMMAND="curl"
    else
        if command -v wget &> /dev/null; then
            HTTP_COMMAND="wget -qO -"
        else
            echo "Error: curl or wget not found."
            exit 1
        fi
    fi
}

# get ip
# you can edit this function
get_ip() {
    IP=$(${HTTP_COMMAND} https://api6.ipify.org?format=text)
    # if you need ipv6 address of nic:
    #network_interface="en0"
    #ipv6_prefix="2408"
    #IP=$(ip -6 addr show dev "${network_interface}" | grep "${ipv6_prefix}" | grep -oP '(?<=inet6\s)[0-9a-fA-F:]+' | head -n 1)
    # for ifconfig:
    #IP=$(ifconfig "${network_interface}" | grep "${ipv6_prefix}" | grep -oE 'inet6\s[0-9a-fA-F:]+' | awk '{print $2}' | head -n 1)

    if [ -z "${IP}" ]; then
        echo "Error: can't get ip"
        exit 1
    fi
}

# PUT to controller api
send_put_request() {
    local url=$1
    local zone_name=$2
    local domain_name=$3
    local type=$4
    local subdomain=$5
    local ttl=$6
    local data=$7

    ${HTTP_COMMAND} -X PUT "${url}?zone_name=${zone_name}&domain_name=${domain_name}&type=${type}&subdomain=${subdomain}" \
        -d "ttl=${ttl}&data=${data}"
}

check_curl
get_ip
send_put_request "${API_URL}" "${ZONE_NAME}" "${DOMAIN_NAME}" "${TYPE}" "${SUBDOMAIN}" "${TTL}" "${IP}"
