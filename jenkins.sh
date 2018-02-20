---
- name: Jenkins upgradation
  hosts: jenkins

  tasks:
# Adding Java repository for Java
   - name: Add Java Repo
     apt_repository:  repo='ppa:openjdk-r/ppa'

# Installing Java
   - name: Install Java 8
     apt: pkg=openjdk-8-jdk
     become: yes

# Downloading Jenkins repository 
   - name: Add jenkins.io key
     apt_key:
       url: "https://pkg.jenkins.io/debian/jenkins.io.key  "
       state: present

#Adding jenkins to source list
    - apt_repository:
      repo: deb http://pkg.jenkins.io/debian-stable binary/
      state: present
# Installing jenkins
  - name: installing jenkins
     apt: pkg=jenkins state=installed update_cache=true

# allowing Port 8080
   - name: Allow port 8080
     shell: iptables -I INPUT -p tcp --dport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT




# avoiding the jenkins setup pages
   - name: Disable wizards via java argument
     lineinfile:
      regexp: JENKINS_JAVA_OPTIONS="(.*headless=true)"
      backrefs: yes
      line: JENKINS_JAVA_OPTSS="\1 -Djenkins.install.runSetupWizard=false"
      dest: /etc/default/jenkins

   - name: Disable the wizard via files as well
     lineinfile:
      dest: ~jenkins/{{ item }}
      create: yes
      line: 2.7.3
     with_items:
       - jenkins.install.InstallUtil.lastExecVersion
       - jenkins.install.UpgradeWizard.state

# start the jenkins server
   - name: start jenkins service
     service:
      name: jenkins
      state: running
      enabled: yes
     register: svc_status



                            


