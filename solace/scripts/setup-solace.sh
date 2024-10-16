# read files from semp folder and create the necessary objects in Solace

# Read the SEMP files and create the necessary objects in Solace
me=`basename "$0"`
SOLACE_URL=https://solace-10:1943
SEMP_USERNAME=admin
SEMP_PASSWORD=admin
#VPN=default - read from dir
echo "$(date): $me Creating objects in Solace"
echo "SOLACE_URL: ${SOLACE_URL}"
echo "SEMP_USERNAME: ${SEMP_USERNAME}"
#echo "VPN: ${VPN}"

#echo "$(date): $me Sleeping for 15 seconds"
#sleep 15

echo
echo " Setting up Queues"
for file in $(ls -C1 /app/scripts/SEMP/*/queues/*/queue.json); do
    echo
    purl=$(echo "$file" | awk -F'/SEMP/' '{print $2}' | awk -F'/' '{print $1"/"$2}')
    echo "$(date): Processing Queue file: $file (URL: $purl)"
    curl -k -X POST -u ${SEMP_USERNAME}:${SEMP_PASSWORD} -H "Content-Type: application/json" -d @${file} ${SOLACE_URL}/SEMP/v2/config/msgVpns/${purl}
    echo
done

echo
echo " Setting up Queue subscriptions"
for file in $(ls -C1 /app/scripts/SEMP/*/queues/*/subscriptions.json); do
    purl=$(echo "$file" | awk -F'/SEMP/' '{print $2}' | awk -F'.json' '{print $1}')
    echo
    echo "$(date): Processing Q Subscription file: $file (URL: $purl)"
    curl -k -X POST -u ${SEMP_USERNAME}:${SEMP_PASSWORD} -H "Content-Type: application/json" -d @${file} ${SOLACE_URL}/SEMP/v2/config/msgVpns/${purl}
    echo
done

#echo "$(date): $me Sleeping for 5 min before exiting"
#sleep 600

echo "$(date): $me Exiting"