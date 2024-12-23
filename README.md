# System Monitoring Script

This script monitors the system's disk usage, memory usage, CPU usage, and top 5 running processes. It sends email alerts when specific thresholds are exceeded, and logs the system's status in a log file.

## Features

- Monitor disk usage and send email alerts if usage exceeds a specified threshold.
- Check memory usage and alert if memory is below a defined threshold.
- Monitor CPU usage and alert if CPU usage exceeds a given threshold.
- Log system statistics including disk usage, memory usage, CPU usage, and running processes.
- Supports customization of file name, disk threshold, and email account via command-line options.

## Requirements

- Linux-based system with `df`, `free`, `top`, and `msmtp` commands available.
- `msmtp` configured for sending email notifications.

## Installation

1. Save the script to a file (e.g., `system_monitoring.sh`).
2. Make the script executable:

    ```bash
    chmod +x system_monitoring.sh
    ```

3. Install `msmtp` (if not installed) to send email notifications:

    ```bash
    sudo apt-get install msmtp
    ```

4. Configure `msmtp` with your email provider's SMTP settings

    ```bash
    sudo cat ~/.msmtprc 
    ```
```    
account default
host smtp.gmail.com
port 587
from <sender>@gmail.com
user <sender>@gmail.com
password <TOKEN>  // create password at google don't put your email password 
auth plain
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
```

## screenshots
![EX1](/screenshots/Screenshot%20from%202024-12-03%2022-45-23.png)
![EX2](screenshots/Screenshot%20from%202024-12-03%2022-45-35.png)
![EX3](screenshots/Screenshot%20from%202024-12-03%2022-45-51.png)
![EX4](screenshots/Screenshot%20from%202024-12-03%2022-46-03.png)

## output file EX 
```
===========================================
===========================================
===========================================
hello user
Sat Dec  8 14:03:12 UTC 2024
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           1.6G  2.3M  1.6G   1% /run
/dev/sdb3       115G   34G   76G  31% /
tmpfs           7.8G  119M  7.7G   2% /dev/shm
tmpfs           5.0M   12K  5.0M   1% /run/lock
efivarfs        128K   73K   51K  60% /sys/firmware/efi/efivars
tmpfs           7.8G     0  7.8G   0% /run/qemu
/dev/sdb1       944M  181M  698M  21% /boot
/dev/sdb2       1.1G  6.2M  1.1G   1% /boot/efi
/dev/sda2       466G  392G   74G  85% /mnt/d
tmpfs           1.6G  128K  1.6G   1% /run/user/1000
total           602G  426G  170G  80% -
...
------Warning------
disk usage is 80%
This is a system monitoring alert for machine user.

Please check your disk usage; it's more than 80%.
...
memory usage is
total memory: 8Gi
used memory: 6Gi
free memory: 1Gi
...
------Warning------
CPU is 80%
Please check your CPU; it's above 80%
...
Top 5 Running Processes
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
  11533 muhamme+  20   0   14500   5376   3328 R  16.7   0.0   0:00.03 top
      1 root      20   0   23828  14952   9448 S   0.0   0.1   0:03.84 systemd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.00 kthreadd
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00 pool_workqueue_release
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-rcu_g
...
```

## Usage

Run the script with optional flags for customization:

```bash
./system_monitoring.sh [-f file_name] [-t disk_threshold] [-e email_account]

