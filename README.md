# kinesthesia scorebot

fork of kinesis that allows for automatic scoring and hooks results to a local html file, as well as giving each vuln a point value (because why not)

## how it works

a json file is created by the scorebot which is then "stuffed" into the score report html. what more can i say

## setup and usage

it's easy!

1. create a copy of kinesis.sh onto your image repository or somewhere accessable on a web server.

2. in your image create a directory anywhere and copy getscore.sh and report.html there. 
    
    * in getscore.sh, be sure to paste the URL to the scorebot raw file in the appropriate place (if using a github repository, make sure it's public)

    * the report.html file stored here will act as the template

3. create another copy of report.html and put in the desktop or somewhere easily viewable by users

4. configure kinesis.sh

    * scroll to the bottom, and edit the `_header` line with the appropriate information (this must be the first line after function definitions)

    * put vuln checks after _header (see [the original repo](https://github.com/mattkoco/Kinesis-Scorebot) for information about available functions)

    * edit the `_terminate` line with the appropriate information (this must be the last line)

5. create a cron job that runs the getscore.sh as often as desired. remember to notify users to not remove it

6. alias the getscore.sh script to something like `score` if you anticipate someone liking the command line version better. remember to notify users to not remove it

    