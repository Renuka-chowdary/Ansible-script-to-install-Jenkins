# Ansible-script-to-installl-Jennkins

Installs Jenkins CI on Debian/Ubuntu servers.

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


<h3> Configuring Ansible Hosts:<h3/>
 
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
 
<h1> Ansible Playbooks: <h1/>

By using Ansible playbooks we can send commands to remote computers.It is
written in the YAML language.

First  create a empty file and open it for writting ansible script.

          touch ansible.yml
          vi ansible.yml

<h1>Example Playbook:<h1/>

---<br/>
- name: Jenkins upgradation<br/>
  hosts: jenkins<br/>
  gather_facts: true<br/>
  become: yes<br/>
  become_method: sudo<br/>
  <br/>
  tasks:<br/>
  <br/>
  - name: Add Java Repo<br/>
      apt_repository: repo='ppa:openjdk-r/ppa'<br/>
    <br/>
  - name: Install Java 8<br/>
      apt: pkg=openjdk-8-jdk<br/>
      become: yes<br/>
<br/>
<h4>You can see the entire script in playbook.yml<h4/><br/> 

<h1> After Writting the script: </h1>
  
  After writting script run the following command to test the script
 
         ansibl e-playbook ansible.yml

<h1> Issues:<h1>
 If the script is not running and throwing the error like Unable to lock the administration directory (/var/lib/dpkg/) is another process using it?

 First check the process that running and kill it.
  
        ps -a | grep dpkg

 Again if it is showing the same error use the below command
  
        sudo rm /var/lib/apt/lists/lock



