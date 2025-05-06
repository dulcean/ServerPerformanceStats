#!/bin/bash

bashdays_box() {
    local headertext="$1"
    local message="$2"

    local white=$'\e[38;5;007m'
    local reset=$'\e[0m'
    local color

    case "$headertext" in
        INFO)  color=$'\e[38;5;39m' ;;
        OK)    color=$'\e[38;5;34m' ;;
        DONE)  color=$'\e[38;5;34m' ;;
        WARN)  color=$'\e[38;5;214m' ;;
        ERROR) color=$'\e[38;5;196m' ;;
        DEBUG) color=$'\e[38;5;244m' ;;
        TASK)  color=$'\e[38;5;141m' ;;
        NOTE)  color=$'\e[38;5;45m' ;;
        *)     color=$'\e[38;5;244m' ;;
    esac

    local headerpadding=$(( ${#message} - ${#headertext} ))
    local header=${message:0:headerpadding}

    echo -e "\n${color}╭ ${headertext} ${header//?/─}────╮" \
        "\n│   ${message//?/ }   │" \
        "\n│   ${white}${message}${color}   │" \
        "\n│   ${message//?/ }   │" \
        "\n╰──${message//?/─}────╯${reset}"
}

bashdays_box "INFO" "Server Performance Stats"

bashdays_box "INFO" "OS Version"
uname -a

bashdays_box "INFO" "Uptime and Load Average"
uptime

bashdays_box "INFO" "Logged in users"
who

bashdays_box "WARN" "Last 10 Failed SSH Login Attempts"
journalctl _COMM=sshd 2>/dev/null | grep "Failed password" | tail -n 10 || echo "Not available (no journalctl access?)"

bashdays_box "INFO" "CPU Usage"
top -bn1 | grep "Cpu(s)" | \
awk '{print "CPU Usage: "100 - $8"% (Used)"}'

bashdays_box "INFO" "Memory Usage"
free -h
echo ""
free | awk '/Mem:/ {
    total=$2; used=$3; 
    printf("Used: %.2f%%\n", used/total*100)
}'

bashdays_box "INFO" "Disk Usage"
df -h --total | grep total

bashdays_box "INFO" "Top 5 Processes by CPU Usage"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6

bashdays_box "INFO" "Top 5 Processes by Memory Usage"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6

bashdays_box "DONE" "All system stats collected"

