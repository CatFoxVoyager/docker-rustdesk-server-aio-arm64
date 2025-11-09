
#!/bin/bash
if [ "${HBBS_ENABLED}" != "true" ] && [ "${HBBR_ENABLED}" != "true" ]; then
  echo "---hbbs and hbbr disabled, please enable at least one, putting container into sleep mode!---"
  sleep infinity
fi

# Build parameters automatically
HBBS_PARAMS=""
HBBR_PARAMS=""

if [ -n "${RELAY_SERVER}" ]; then
  HBBS_PARAMS="${HBBS_PARAMS} -r ${RELAY_SERVER}"
  echo "---Relay server configured: ${RELAY_SERVER}---"
fi

if [ -n "${KEY}" ]; then
  HBBS_PARAMS="${HBBS_PARAMS} -k ${KEY}"
  HBBR_PARAMS="${HBBR_PARAMS} -k ${KEY}"
  echo "---Key configured---"
fi

cd ${DATA_DIR}
echo "---Starting RustDesk-Server-AiO---"
if [ "${HBBS_ENABLED}" == "true" ]; then
  echo "---Starting hbbs with params:${HBBS_PARAMS}---"
  /usr/bin/hbbs ${HBBS_PARAMS} & > ${DATA_DIR}/hbb.log
else
  echo "---hbbs disabled!---"
fi

if [ "${HBBR_ENABLED}" == "true" ]; then
  echo "---Starting hbbr with params:${HBBR_PARAMS}---"
  /usr/bin/hbbr ${HBBR_PARAMS} & > ${DATA_DIR}/hbb.log
else
  echo "---hbbr disabled!---"
fi

/opt/scripts/start-watchdog.sh &

if [ -f ${DATA_DIR}/id_ed25519.pub ]; then
  echo
  echo "--------------------------------------------"
  echo "Public key:"
  echo
  echo "$(cat ${DATA_DIR}/id_ed25519.pub)"
  echo "--------------------------------------------"
  echo
fi


tail -f ${DATA_DIR}/hbb.log