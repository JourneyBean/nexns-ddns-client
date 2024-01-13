# NexNS DDNS Client

Some useful scripts or clients to perform DDNS update.

## Usage

1. Modify neccessary params

    For example, update A record of www.example.com:

    ```bash
    CONTROLLER_URL="http://localhost:8000"
    DOMAIN_NAME="example.com"
    SUBDOMAIN="www"     # "" if update A record of example.com
    ZONE_NAME="default"
    TYPE="A"
    TTL=3600
    ```

2. Add to crontab

    ```bash
    crontab -e

    */30 * * * * /path/to/nexns_update_ddns_v4.sh
    */30 * * * * /path/to/nexns_update_ddns_v6.sh
    ```

3. (Optional) Update using interface's ip address

    Modify `get_ip()` function.

    For IPv4:

    ```bash
    get_ip() {
        network_interface=en0
        IP=$(ip -4 addr show dev "${network_interface}" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
        if [ -z "${IP}" ]; then
            echo "Error: can't get ip"
            exit 1
        fi
    }
    ```

    For IPv6:

    ```bash
    get_ip() {
        network_interface="en0"
        ipv6_prefix="2003:"
        IP=$(ip -6 addr show dev "${network_interface}" | grep "${ipv6_prefix}" | grep -oP '(?<=inet6\s)[0-9a-fA-F:]+' | head -n 1)

        if [ -z "${IP}" ]; then
            echo "Error: can't get ip"
            exit 1
        fi
    }
    ```
