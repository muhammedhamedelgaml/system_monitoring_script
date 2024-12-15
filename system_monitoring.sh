#!/bin/bash

#file_name=${2:-system_monitoring.log}  #pass arg2 , default  "system_monitoring.log"
#disk_threshold=${1:-80}  # if disk or partition is more than 80%    ## you can pass arg1 , default 80 

# default values
file_name="system_monitoring.log"
disk_threshold=70
email_account="default@gmail.com"
mem_threshold="2"   ## if memory less than 2Gi
cpu_thershold="80"   ## if CPU above 80%


# optional args -f FILE -t DISK_THRESHOLD
while getopts "f:t:e:" opt; do
  case $opt in
    f) file="$OPTARG"  # The file argument follows the '-f' option
    ;;
    t) disk_threshold="$OPTARG"  # The threshold argument follows the '-t' option
    ;;
    e) email_account="$OPTARG"  # The email argument follows the '-e' option
    ;;
    \?) 
      echo "Usage: $0 [-f file_name] [-t disk_threshold] [-e email_account]"
      exit 1
    ;;
  esac
done



touch $file_name


# email content
email_Disk_content=$(echo -e "\nThis is a system monitoring alert for machine $DESKTOP_SESSION.\n\nPlease check your disk usage; it's more than $disk_threshold %.\n")
email_Part_content=$(echo -e "\nThis is a system monitoring alert for machine $DESKTOP_SESSION.\n\nPlease check your parttions usage; it's more than $disk_threshold %.\n")
email_mem_content=$(echo -e "\nThis is a system monitoring alert for machine $DESKTOP_SESSION.\n\nPlease check your memory; it's less than $mem_threshold Gi \n")
email_CPU_content=$(echo -e "\nThis is a system monitoring alert for machine $DESKTOP_SESSION.\n\nPlease check your CPU; it's above  $cpu_thershold % \n")



echo "===========================================" > $file_name
echo "===========================================" >> $file_name
echo "===========================================" >> $file_name
echo "hello $USERNAME "  >> $file_name
date  >> $file_name



line_no=`df -h | wc -l`
disk_usage=` df -h --total ` 
disk_status=` df -h --total  | awk -v line_no=$line_no 'NR == line_no+1 {print $5}'  | cut -d'%' -f1 `
echo " $disk_usage "   >> $file_name
if [ "$disk_status" -ge "$disk_threshold" ];
then
  echo -e "\e[31m------Warning------\e[0m"  >> $file_name
  echo " disk usage is $disk_status% " >> $file_name
  echo -e "$email_Disk_content"   | msmtp  $email_account
fi



for i in $( seq 2 $line_no ); do
    part=$(df -h | awk "NR==$i {print \$5}" | cut -d'%' -f1 )
    if [ $part -ge $disk_threshold ] ; then
        echo -e "\e[31m------Warning------\e[0m"  >> $file_name
        echo -e "chech partition ` df -h | awk "NR==$i" ` "     >> $file_name
        echo -e " $email_Part_content \n ` df -h | awk "NR==$i" ` "   | msmtp muhammedhamedelgaml@gmail.com
    fi
done



echo "==========================================="   >> $file_name
echo "memory usage is"    >> $file_name
mem_usage=` free -th `  
# mem_used=`  free -th | grep "Total"  | awk '{print $3}'  `
mem_used=`  free -th  | awk 'NR==4 {print $3}'  `
mem_free=`  free -th  | awk 'NR==4 {print $4}' | cut -d'G' -f1 `
mem_total=`  free -th  | awk 'NR==4 {print $2}' `
mem_free_no=$(printf "%.0f" "$mem_free")

if [ "$mem_free_no" -le  "$mem_threshold" ]; 
 then 
 echo -e "\e[31m------Warning------\e[0m"  >> $file_name
 echo " memory is low"   >> $file_name
 echo -e "$email_mem_content"  | msmtp muhammedhamedelgaml@gmail.com
 fi 

echo " total memory: $mem_total"   >> $file_name
echo " used memory: $mem_used"    >> $file_name
echo " free memory: $mem_free Gi"   >> $file_name





echo "==========================================="   >> $file_name
echo "----------CPU usage------------"    >> $file_name
echo "number of CPU `nproc` "       >> $file_name
cpu_usage=`top -bn 1 | grep "Cpu(s)" | awk 'NR==1 {print $2} ' `
cpu_usage_no=$(printf "%.0f" "$cpu_usage")
echo "cpu usage is $cpu_usage %"     >> $file_name
if [ "$cpu_usage_no" -ge $cpu_thershold ];
then 
echo -e "\e[31m------Warning------\e[0m"  >> $file_name 
echo  " CPU is $cpu_usage % " >> $file_name
echo -e "$email_CPU_content"  | msmtp muhammedhamedelgaml@gmail.com
fi 




echo "==========================================="   >> $file_name
echo "Top 5 Running Processes"    >> $file_name
top_out=$(top -bn1) 
for i in {7..12}; do
    top=$(echo "$top_out" | awk "NR==$i")
    echo "$top"   >> $file_name
done
