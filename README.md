### Packaging_RPM

##### package.sh will automatically create an RPM package.

##### This project refers to the Packaging and distributing software of Red Hat Document

Document link: https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html-single/packaging_and_distributing_software/index#introduction-to-rpm_packaging-and-distributing-software

##### I use C language as the sample language for this packaging

The process of creating an RPM package is as follows
- Check rpmdevtools package is installed, which provides utilities for packaging RPMs.
- Create a C program.
- Create a Makefile.
- Create a LICENSE. 
- Create the archive for distribution.
- Use rpmdev-setuptree command to create rpmbuild directory.
- Create an RPM SPECS archive and place it in rpmbuild/SPECS.
- Put the previously packaged tar file into rpmbuild/SOURCES.
- Use rpmbuild command to build a binary RPM.
