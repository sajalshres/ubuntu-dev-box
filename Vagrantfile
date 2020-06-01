# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

###############################################################################
# Load configuration
###############################################################################
current_dir = File.dirname(File.expand_path(__FILE__))
all_config = YAML.load_file("#{current_dir}/config.yaml")

###############################################################################
# Utility functions
###############################################################################

# Convert the shell provisioner arguments from configuration file
# into an array for the vagrant shell provisioner
def shell_provisioner_args(yaml_arguments)
    shell_arguments = Array.new

    # Arguments may or may not be named,
    # and named arguments may or may not have a value.
    yaml_arguments.each do |argument|
        argument.key?('name') && shell_arguments.push(argument['name'])
        argument.key?('value') && shell_arguments.push(argument['value'])
    end

    shell_arguments
end

###############################################################################
# Vagrant setup functions
###############################################################################

# Setup VM base config
def setup_basic_config(config, vm_config)
    # Vargrant Box
    config.vm.box = vm_config['base_box']
    
    if vm_config['base_box_version'] != 'latest'
        config.vm.box_version = vm_config['base_box_version']
    end
        
    # Vagrant box name
    config.vm.define vm_config['name']

    # Setup virtual machine name
    config.vm.host_name = vm_config['name']

end

# Setup provider
def setup_provider(config, vm_config)
    providers = vm_config['providers']
    providers && providers.each do |type, params|
        config.vm.provider type do |provider|
            params.each do |key, value|
                provider.send("#{key}=", value)
            end
        end
    end

    # Provider specific configuration
    config.vm.provider 'virtualbox' do |vb|
        vb.name = vm_config['name']
        vb.customize [ 'modifyvm', :id, '--cpus', vm_config['cpus'] ]
        vb.customize [ 'modifyvm', :id, '--memory', vm_config['memory'] ]
        # Additional customizations
        # Shared clipboard
        vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    end
end

# Setup provision
def setup_provisioners(config, provisioners)
    provisioners && provisioners.each do |provisioner|
        provisioner.each do |provisioner_name, provisioner_detail|
            if provisioner_detail['enable']
                if provisioner_detail['type'] == 'shell'
                    if provisioner_detail['arguments']
                        config.vm.provision provisioner_name, 
                            type:"shell", 
                            path: provisioner_detail['path'],
                            :args => shell_provisioner_args(provisioner_detail['arguments']),
                            privileged: provisioner_detail['privileged']
                    else
                        config.vm.provision provisioner_name, 
                            type:"shell", 
                            path: provisioner_detail['path'],
                            privileged: provisioner_detail['privileged']
                    end
                elsif provisioner_detail['type'] == 'file'
                    config.vm.provision provisioner_name,
                    type: "file",
                    source: provisioner_detail['source'],
                    destination: provisioner_detail['destination']
                end
            end
        end
    end
end

###############################################################################
# Configure Vagrant
###############################################################################
Vagrant.configure(all_config['api_version']) do |config|
    # Virtual machine configuration
    vm_config = all_config['vm']
    # Provision config
    provision_config = all_config['provisioners']
    
    # Setup base config
    setup_basic_config(config, vm_config)
    
    # Setup virtual box provider
    setup_provider(config, vm_config)

    # Setup provisioning
    setup_provisioners(config, provision_config)
end
