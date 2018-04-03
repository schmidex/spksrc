SVC_CWD="${SYNOPKG_PKGDEST}"
DNSCRYPT_PROXY=${SYNOPKG_PKGDEST}/dnscrypt-proxy
PID_FILE=${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.pid
CFG_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.toml"
TEMPLATE_CFG_FILE="${SYNOPKG_PKGDEST}/example-dnscrypt-proxy.toml"

SERVICE_COMMAND="${DNSCRYPT_PROXY} --config ${CFG_FILE} --pidfile ${PID_FILE}"
SVC_BACKGROUND=y

service_postinst ()
{
    mkdir -p "${SYNOPKG_PKGDEST}"/var
    if [ ! -e "${CFG_FILE}" ]; then
        echo "Applying settings from Wizard..." >> "${INST_LOG}"
        cp -f "${TEMPLATE_CFG_FILE}" "${CFG_FILE}" >> "${INST_LOG}"

        # change default address, port, only use dnssec enabled servers, ipv6, logfile, change logfile location
        listen_addresses="['0.0.0.0:${wizard_port:=10053}']" # $SERVICE_PORT
        sed -i -e "s/listen_addresses = .*/listen_addresses = ${listen_addresses}/" \
            -e "s/require_dnssec = .*/require_dnssec = true/" \
            -e "s/ipv6_servers = .*/ipv6_servers = ${wizard_ipv6:=false}/" \
            "${CFG_FILE}" >> "${INST_LOG}"
    fi
}
