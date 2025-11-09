
#!/bin/bash
if [ "${HBBS_ENABLED}" != "true" ] && [ "${HBBR_ENABLED}" != "true" ]; then
  echo "---hbbs and hbbr disabled, please enable at least one, putting container into sleep mode!---"
  sleep infinity
fi

# Build hbbs parameters automatically
HBBS_AUTO_PARAMS=""
if [ -n "${RELAY_SERVER}" ]; then
  HBBS_AUTO_PARAMS="${HBBS_AUTO_PARAMS} -r ${RELAY_SERVER}"
  echo "---Relay server configured: ${RELAY_SERVER}---"
fi
if [ -n "${KEY}" ]; then
  HBBS_AUTO_PARAMS="${HBBS_AUTO_PARAMS} -k ${KEY}"
  HBBR_AUTO_PARAMS="${HBBR_AUTO_PARAMS} -k ${KEY}"
  echo "---Key configured---"
fi

# Combine auto params with manual params
HBBS_FINAL_PARAMS="${HBBS_AUTO_PARAMS} ${HBBS_PARAMS}"
HBBR_FINAL_PARAMS="${HBBR_AUTO_PARAMS} ${HBBR_PARAMS}"

cd ${DATA_DIR}
echo "---Starting RustDesk-Server-AiO---"
if [ "${HBBS_ENABLED}" == "true" ]; then
  echo "---Starting hbbs with params: ${HBBS_FINAL_PARAMS}---"
  /usr/bin/hbbs ${HBBS_FINAL_PARAMS} & > ${DATA_DIR}/hbb.log
else
  echo "---hbbs disabled!---"
fi

if [ "${HBBR_ENABLED}" == "true" ]; then
  echo "---Starting hbbr with params: ${HBBR_FINAL_PARAMS}---"
  /usr/bin/hbbr ${HBBR_FINAL_PARAMS} & > ${DATA_DIR}/hbb.log
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