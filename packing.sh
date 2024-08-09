#!/bin/bash

# This project refers to Packaging and distributing software of Red Hat Document.
# Introduction
# check rpmdevtools is installed
rpm -qi rpmdevtools &> /dev/null
result=$?

if [ $result -eq 0 ]; then
	echo "rpmdevtools package is installed."
else
	echo "rpmdevtools package uninstall."
	sudo dnf install rpmdevtools
fi

# Creating software for RPM packaging
# Prepare C program
cat << EOF > test.c
#include <stdio.h>

int main(int argc, char **argv)
{
        printf("Packaging software by using the RPM package management system\n");
        return 0;
}
EOF

# Prepare Makefile
cat << EOF > Makefile
test:
	gcc -g -o test test.c
clean:
	rm test

.PHONY clean
EOF

# Prepare LICENSE
cat << EOF > LICENSE
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
EOF

# Creating a source code archive for a sample C program.
# Create the environment required for packaging
SRCDIR=testc-1.0
mkdir $SRCDIR
files=("test.c" "Makefile" "LICENSE")

# Check file exist
for file in "${files[@]}"
do
  if [ -e "$file" ]; then
    echo "$file exist"
    mv $file $SRCDIR
  else
    echo "$file not exist"
  fi
done

tar -cvzf testc-1.0.tar.gz testc-1.0

# Create environment for rpmbuild command stores the files for building packages
RPMDIR=~/rpmbuild/SOURCES/
mkdir -p $RPMDIR

#rpmdev-setuptree
