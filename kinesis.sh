#!/bin/bash
touch /tmp/score.json # score json file which will be stuffed in html later

# json manipulation functions
# in the end, json looks like {header:{title:"title", inject:false, timestamp:"..."}, vulns:[{name:"vuln", points:5},null,...]}
_header() {
    local title="$1"
    local injectbool="$2"
    local date=$(date)
    echo "{\"header\":{\"title\":\"$title\", \"inject\":$injectbool, \"timestamp\":$date}, \"vulns\":[" >> /tmp/score.json
}

_append_found() {
    local vuln_name="$1"
    local points="$2"

    echo "{\"name\":\"$vuln_name\", \"points\":$points}," >> /tmp/score.json
}

_append_unsolved() {
    echo "null," >> /tmp/score.json
}

_terminate(){
    local template_html_file="$1"
    local html_file="$2"

    # reset html file with template
    cat "$template_html_file" > "$html_file" 
    # remove the trailing comma
    sed -i 's/\(.*\),/\1 /' /tmp/score.json
    # close brackets
    echo "]}" >> /tmp/score.json
    # stuff raw json into html because CORS prevents reading of local files in JS
    sed -i -e "/JSONHERE/r /tmp/score.json" "$html_file"

    rm /tmp/score.json
}

# Function to check if text exists in a file
check_text_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    local points="$4"
    
    if grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

# Function to check if text does not exist in a file
check_text_not_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    local points="$4"
    
    if ! grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

# Function to check if a file exists
check_file_exists() {
    local file="$1"
    local vuln_name="$2"
    local points="$3"
    
    if [ -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

# Function to check if a file has been deleted
check_file_deleted() {
    local file="$1"
    local vuln_name="$2"
    local points="$3"
    
    if [ ! -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

check_file_permissions() {
    local file="$1"
    local expected_permissions="$2"
    local vuln_name="$3"
    local points="$4"
    
    # Get the actual permissions of the file in numeric form (e.g., 644)
    actual_permissions=$(stat -c "%a" "$file")
    
    if [ "$actual_permissions" == "$expected_permissions" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

# keep this line at the beginning, input your image metadata here 
# accepts two args: image name, and injects bool (true/false)
_header "Image Name" "false"



# put vuln checks here, for example: 
check_text_exists "/etc/passwd" "administrator" "Added administrator user" 5 # DELETE THIS



# keep this line at the end, input the path to score report html here
# accepts two args: path to template html file, and path to actual html file
_terminate "/path/to/template/html" "/path/to/actual/html"