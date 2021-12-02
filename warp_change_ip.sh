#bin/bash!

#Github @luoxue-bot
#Blog https://ty.al

region_area(){
	region=$(curl --user-agent "${UA_Browser}" -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | sed 's/.*com\/\([^-]*\).*/\1/g')
	region=${region:-US}

	area2=("${area}" "*")
	display2=("Region: ${region} Done, monitoring..." "Not match, Changing IP...")
	cmd2=("" "systemctl restart wg-quick@wgcf")
	sleep_sec2=("6" "3")
        
	for ((j=0; j<${#area2[@]}; j++)); do
		[[ "$region" == ${area2[j]} ]] && break
	done
	echo -e ${display2[j]} && (${cmd2[j]}; sleep ${sleep_sec2[j]})
	}

output=("404" "403" "000" "200")
display1=("Originals Only, Changing IP..." "No, Changing IP..." "Failed, retrying..." "Matching the region...")
cmd1=("systemctl restart wg-quick@wgcf" "systemctl restart wg-quick@wgcf" "systemctl restart wg-quick@wgcf" "region_area")
sleep_sec1=("3" "3" "0" "0")

area=$1
[[ -n $area ]] && area=$(echo $area | tr '[:upper:]' '[:lower:]')

UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
[[ -n $(wg) ]] && [[ -z $area ]] && read -rp "Input the region you want(e.g. hk,sg):" area && area=$(echo $area | tr '[:upper:]' '[:lower:]')
[[ -z $(wg) ]] && echo "Install WARP first" && bash <(curl -fsSL https://raw.githubusercontent.com/fscarmen/warp/main/menu.sh)

while [[ -n $(wg) ]]; do
	curl ip.gs
	result=$(curl --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1)
		for ((i=0; i<${#output[@]}; i++)); do
			[[ "$result" == ${output[i]} ]] && break
		done
	echo -e ${display1[i]}; ${cmd1[i]}; sleep ${sleep_sec1[i]}
done
