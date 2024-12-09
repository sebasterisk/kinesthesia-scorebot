
#!/bin/bash
echo " "
echo "Kinesis Scorebot v1"
echo "NOTE: Please allow up to 5 minutes for scorebot updates & injects."
echo "Injects: NO" # Modify this if you run an inject

# Function to check if text exists in a file
check_text_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    
    if grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

# Function to check if text does not exist in a file
check_text_not_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    
    if ! grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

# Function to check if a file exists
check_file_exists() {
    local file="$1"
    local vuln_name="$2"
    
    if [ -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

# Function to check if a file has been deleted
check_file_deleted() {
    local file="$1"
    local vuln_name="$2"
    
    if [ ! -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

check_file_permissions() {
    local file="$1"
    local expected_permissions="$2"
    local vuln_name="$3"
    
    # Get the actual permissions of the file in numeric form (e.g., 644)
    actual_permissions=$(stat -c "%a" "$file")
    
    if [ "$actual_permissions" == "$expected_permissions" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

echo " "
echo ">> Arcane R3 <<"
echo " "

# scoring
check_text_exists "/home/ekko/Desktop/Forensics_1.txt" "2024-12-03 14:35:12 Viktor accessed restricted research data." "Forensics 1 Solved."
check_text_exists "/home/ekko/Desktop/Forensics_2.txt" "7b65e03e66bf9159e7e808561469182c" "Forensics 2 Solved."
check_text_exists "/home/ekko/Desktop/Forensics_3.txt" "10.0.0.99" "Forensics 3 Solved."

check_file_deleted "/etc/wireshark" "Removed unauthorized application Wireshark"
check_file_deleted "/etc/wireshark" "Removed unauthorized service Samba"
check_file_deleted "/etc/wireshark" "Removed unauthorized service Apache2"
check_file_deleted "/usr/sbin/4g8" "Removed unauthorized application 4g8"
check_file_deleted "/snap/feroxbuster" "Removed unauthorized application feroxbuster"
