quiet

allusers
ignore noroot
ignore nogroups
ignore private-tmp

noblacklist ${HOME}/books
read-only ${HOME}/books

noblacklist /home/share/books
blacklist /home/share/*

include /etc/firejail/pdftotext.profile
