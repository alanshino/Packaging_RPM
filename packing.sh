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
cat << EOF > testrpm.c
#include <stdio.h>

int main(int argc, char **argv)
{
        printf("Packaging software by using the RPM package management system\n");
        return 0;
}
EOF

# Prepare Makefile
cat << EOF > Makefile
testrpm:
	gcc -g -o testrpm testrpm.c
clean:
	rm testrpm
install:
	mkdir -p \$(DESTDIR)/usr/bin
	install -m 0755 testrpm \$(DESTDIR)/usr/bin/testrpm

.PHONY:
	clean
EOF

# Prepare LICENSE
cat << EOF > LICENSE
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
EOF

# Creating a source code archive for a sample C program.
# Create the environment required for packaging
SRCDIR=testrpm-1.0
mkdir $SRCDIR
files=("testrpm.c" "Makefile" "LICENSE")

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

tar -cvzf testrpm-1.0.tar.gz testrpm-1.0

# Create environment for rpmbuild command stores the files for building packages
# Prepare packaging software
#RPMDIR=~/rpmbuild/SOURCES/
#mkdir -p $RPMDIR
rpmdev-setuptree
# create the RPM packaging workspace
# rpmbuild/
# ├── BUILD
# ├── RPMS
# ├── SOURCES
# ├── SPECS
# └── SRPMS

# Prepare RPM SPECS
cat << EOF > testrpm.spec
Name:           testrpm
Version:        1.0
Release:        1%{?dist}
Summary:        RPM package example implemented in C

License:        GPLv3+
URL:            https://www.example.com/%{name}
Source0:        https://www.example.com/%{name}/releases/%{name}-%{version}.tar.gz

BuildRequires:  gcc
BuildRequires:  make

%description
The long-tail description for our RPM Packages Example implemented in C.

%prep
%autosetup

%build
make %{?_smp_mflags}

%install
%make_install


%files
%license LICENSE
%{_bindir}/%{name}


%changelog
* `date +"%a %b %d %Y"` `git config user.name` <`git config user.email`>
- First RPM package
EOF

# Building source RPMs
# Rebuilding a binary RPM from a source RPM 
SPECDIR=~/rpmbuild/SPECS
RPMSRCDIR=~/rpmbuild/SOURCES
SRPMSDIR=~/rpmbuild/SRPMS
mv testrpm.spec $SPECDIR
mv testrpm-1.0.tar.gz $RPMSRCDIR

rpmbuild -bs $SPECDIR/testrpm.spec
SRPMSFILE=`find $SRPMSDIR -maxdepth 1 -type f`
if [ -e "$SRPMSFILE" ]; then 
    echo "src.rpm file created successfully"
    rpmbuild --rebuild $SRPMSFILE
    echo -e "\033[93mThe RPM package is created successfully and you can find it in the ~/rpmbuild/RPMS directory"
else
    echo "src.rpm file created fail"
    exit 1
fi

