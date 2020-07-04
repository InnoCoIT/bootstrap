# bootstrap

ZBX AGNT 설치

# 윈도우 #
* 에이전트 다운로드
  * 32bit: https://www.zabbix.com/downloads/5.0.1/zabbix_agent-5.0.1-windows-i386-openssl.zip
  * 64bit: https://www.zabbix.com/downloads/5.0.1/zabbix_agent-5.0.1-windows-amd64-openssl.zip
* 압축해제
  * C:\InnoCoIT 에 압축해제
* 설정파일 변경 (C:\InnoCoIT\conf\zabbix_agentd.conf)
  * LogFile=C:\InnoCoIT\zabbix_agentd.log
  * LogFileSize=10
  * EnableRemoteCommands=1 
  * Server=프록시서버아이피
  * ServerActive=프록시서버아이피
  * Hostname=호스트명
  * HostMetadataItem=system.uname
* 방화벽 오픈
 * 10050/TCP 포트 허용
* 서비스 등록 및 시작
 * cmd 실행 및 cd c:\InnoCoIT
 * bin\zabbix_agentd.exe -c C:\InnoCoIT\conf\zabbix_agentd.conf -i
 * bin\zabbix_agentd.exe -c C:\InnoCoIT\conf\zabbix_agentd.conf -s

# 리눅스 (CentOS 혹은 Redhat) #
* 에이전트 다운로드 및 설치
  * CentOS 6
    * rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/6/x86_64/zabbix-release-5.0-1.el6.noarch.rpm
    * yum clean all
    * yum install zabbix-agent
  * CentOS 7
    * rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
    * yum clean all
    * yum install zabbix-agent
  * CentOS 8
    * rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
    * dnf clean all
    * dnf install zabbix-agent
* 설정파일 변경 (/etc/zabbix/zabbix_agentd.conf)
  * LogFileSize=10
  * EnableRemoteCommands=1 
  * Server=프록시서버아이피
  * ServerActive=프록시서버아이피
  * Hostname=호스트명
  * HostMetadataItem=system.uname
* 방화벽 오픈
  * firewall-cmd --permanent --zone=public --add-rich-rule="rule family=ipv4 source address=프록시서버아이피 port protocol=tcp port=10050 accept"
  * firewall-cmd --reload
* 서비스 등록 및 시작
  * CentOS 6
    * chkconfig --level 345 zabbix_agent on
    * service zabbix-agent restart
  * CentOS 7, 8
    * systemctl enable zabbix-agent
    * systemctl restart zabbix-agent

