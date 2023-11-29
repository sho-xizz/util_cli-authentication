# # # # # # # # # # # # # # # # 
#     GENERATE_OATH_TOKEN     #
# # # # # # # # # # # # # # # # 
CONFIG_FILE=$(dirname $0)"/secrets.json"
echo "CONFIG_FILE: $CONFIG_FILE"
CONFIG_JSON=`cat $CONFIG_FILE`
if [ -z "$CONFIG_JSON" ]; then
    echo "$CONFIG_FILE is null. Initialize secrets.json."
    echo '{"configs":[{"name":"","secret":""}]}' | jq . > $CONFIG_FILE
    chmod 600 $CONFIG_FILE
fi

echo "\n----------------"
cat $CONFIG_FILE |
    jq -c '.configs[]' |
    while read -r array; do
        target_name=`echo $array | jq -r '.name'`
        target_secret=`echo $array | jq -r '.secret'`
        if [ -z "$target_name" ]; then
            echo "!!!Config ERROR!!! name is null."
            exit 1
        elif [ -z "$target_secret" ]; then
            echo "!!!Config ERROR!!! $target_name secret is null."
            exit 1
        fi
        echo $target_name: `oathtool --totp --base32 "$target_secret"`
    done
echo "----------------\n"
