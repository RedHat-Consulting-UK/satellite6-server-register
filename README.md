# satellite6-server-register

Yet another Red Hat Satellite 6 (Sat 6) server registration script, tested with Satellite 6.1.X and higher, including 6.1 Beta.

This script is used to register physical or virtual servers to satellite which have not been created through satellite. Machines which have been vMotioned or moved to different VMware clusters may also need re-registering.

This script has been tested on the following operating systems: RHEL 6.6, RHEL 5.11, RHEL 7 and 7.1

The script requires several variables:

    - Organisation name: This is the name of the organisation you want to register with inside satellite
                      Example: "Any Organization" or "MyOrg"

    - Satellite address: This should be the FQDN or IP address of the satellite server
                      Example: "satellite.domain.com" or "192.168.1.10"

    - Repos to enable: This should be a list of names of repos to enable (use subscription-manager repos list after registering)
                       Example for RHEL6: "rhel-6-server-rh-common-rpms"
                       Example for RHEL7: "rhel-7-server-rh-common-rpms"

    - Activation Key Name: This is the name of the activation key you want to use for the host.
                      Example: "RHEL6" or "RHEL6Production" or "RHEL7DataCenterA"

    - Puppet Environment Name: This is the name of the puppet environment you want your machine to use, these can be found via the satellite server by going to /etc/puppet/enviroment
                      Example: "KT_MyOrg_Library_RHEL7_5" or "KT_MyOrg_Library_RHEL6_5"

# How to use the script:

Copy the script over to the host you wish to register and give it the correct permissions using chmod.

Next, Execute the script as root or using sudo. The server should now appear in the hosts within satellite if registration goes OK:

	./satellite6-register.sh "MyOrg" "vm1.domain.com" "rhel-7-server-rh-common-rpms" "RHEL7" "KT_MyOrg_Library_RHEL7_5"

Here is an example for registering a rhel6 host:

  ./satellite-register.sh "MyOrg" "vm2.domain.com" "rhel-6-server-rh-common-rpms" "RHEL6" "KT_MyOrg_Library_RHEL6_4"

If you can't see the host, set the org to Any Organization and set the location to Any location and check the hosts again.

You can also use the hammer API on the satellite server, which should also show the same thing:  

                      # Default Org
                      hammer host list --org-id 1   

# Known Issues:

After registration sometimes the host ends up in the wrong org or environment and cannot be seen in foreman.
