# Ansible-script-to-install-Jenkins

Ansible script to install Jenkins and takes us directly to Jenkins dashboard.

<h1> Requirements:</h1>

 1. Ansible 1.4 or higher<br/> 
 2. Ubuntu 16.04 server<br/>
 3. vagrant<br/>
 4. curl<br/> 
 5. JAVA 8+<br/>
 6. 3 - VM's (1- host machine, 2-remote machines <br/>

    eg: 192.168.33.90  ---> host<br/>
        192.168.33.91  ---> remote-1<br/>
        192.168.33.92  ---> remote-2<br/>

<h1>Installing and configuring ansible host</h1>


 To get Ansible for Ubuntu we should add the project's PPA (personal package archive) to our system

            sudo apt-add-repository ppa:ansible/ansible


To install Ansible and check the version.<br/>

            sudo apt-get install ansible
            ansible --version


Configuring Ansible Hosts:
 
 First generate the key on host machine and copy the key from host to remote machines.<br/>
           
           1. ssh-keygen

           2. ssh-copy-id ubuntu@192.168.33.91
              ssh-copy-id ubuntu@192.168.33.92 

                  
 Then open the ansible host file and add the remote IP's in ansible file,under group name as shown below:
 
           1. sudo nano /etc/ansible/hosts
            
           2. [jenkins] --> group name
              192.168.33.91
              192.168.33.92


 Install python on two remote machines because python is requried.
             
          sudo  apt-get install python-simplejson


Now  we have our hosts set up and we can successfully connect to our hosts,by typing
 
          ansible -m ping jenkins (or) ansible -m ping all
 
Ansible Playbooks:

By using Ansible playbooks we can send commands to remote computers.It is
written in the YAML language.

First  create a empty file and open it for writting ansible script.

          touch ansible.yml
          vi ansible.yml


Example Playbook:

       See jenkins.sh file
 

 After writting script run the following command to test the script
 
         ansible-playbook ansible.yml
         
   Playbook starts running.Once copmleted, go to browser and type
   
   http://192.168.33.91:8080
   
   The below image is the output:    
         
   
![4](https://user-images.githubusercontent.com/33515288/37864010-561e5fd4-2f8e-11e8-8352-bac3992ef54e.jpg)

Issues you may get:<br/>

 If the script is not running and throwing the error like Unable to lock the administration directory (/var/lib/dpkg/) is another process using it?

 First check the process that running and kill it.
  
        ps -a | grep dpkg

 Again if it is showing the same error use the below command
  
        sudo rm /var/lib/apt/lists/lock
