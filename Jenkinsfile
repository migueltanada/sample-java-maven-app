// Admin Credentials for sonar and nexus (username and Password)
//docker_creds = "DOCKER_LOGIN"

// DockerHub Credentials (username and Password)
admin_creds = "ADMIN_CREDS"

node('docker'){
    // Returns maven install home directory for ADOP Maven
    def mavenHome = tool(
        name: "ADOP Maven",
        type: "maven"
    ) 
    
    // Add maven to PATH
    env.PATH = "${env.PATH}:${mavenHome}/bin"

	stage('Checkout'){
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/migueltanada/sample-java-maven-app']]])
    }
    
	stage('maven'){
        sh "mvn package"	    
	}
	
    withCredentials([usernamePassword(credentialsId: admin_creds, passwordVariable: 'ADMIN_PASSWORD', usernameVariable: 'ADMIN_USER')]) {
    	stage('sonar'){
            // Run sonar
    		sh """
    		mvn --batch-mode sonar:sonar \
    			-Dsonar.login=${ADMIN_USER} \
    			-Dsonar.password=${ADMIN_PASSWORD} \
    			-Dsonar.host.url=http://sonar:9000/sonar \
    			-Dsonar.jdbc.url='jdbc:mysql://sonar-mysql:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true' \
    			-Dsonar.jdbc.username=sonar \
    			-Dsonar.jdbc.password=sonar \
    		"""
    	}
    	
    	stage('nexus'){
            // Upload to Snapshots
    		sh """
            mvn deploy:deploy-file \
                -DgeneratePom=false \
                -DrepositoryId=nexus \
                -Durl=http://${ADMIN_USER}:${ADMIN_PASSWORD}@nexus:8081/nexus/content/repositories/snapshots \
                -DpomFile=pom.xml \
                -Dfile=target/CurrencyConverter.war
    		"""
       }
       
    }
    
    stage('Deploy'){
        
        // Create tomcat-users file
        writeFile file: 'tomcat-users.xml', text: '''\
            |<tomcat-users xmlns="http://tomcat.apache.org/xml"
            |      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            |      xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
            |      version="1.0">
            |
            |    <role rolename="admin-gui"/>
            |    <role rolename="manager-gui"/>
            |    <role rolename="manager-script"/>
            |    <role rolename="manager-jmx"/>
            |    <role rolename="manager-status"/>
            |    <user username="tomcat" password="tomcat" roles="manager-gui,admin-gui,manager-script,manager-jmx,manager-status"/>
            |    
            |</tomcat-users>'''.stripMargin()
            
        // Create Dockerfile
        writeFile file: 'Dockerfile', text: '''\
            |FROM tomcat:7.0
            |COPY tomcat-users.xml /usr/local/tomcat/conf/
            |ADD currencyconverter.war /usr/local/tomcat/webapps/
            '''.stripMargin()

        writeFile file: 'tomcat.conf', text: '''\
        |server{
        |    listen 80;
        |    server_name ~^tomcat*;
        |
        |   access_log  /var/log/nginx/access.log logstash;
        |   proxy_set_header host $host;
        |
        |
        |    location /{
        |        proxy_pass  http://tomcat:8080/;
        |    }
        |}'''.stripMargin()
            
        // Copy war
        sh "mv target/CurrencyConverter.war currencyconverter.war"
        
        //withCredentials([usernamePassword(credentialsId: docker_creds, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
    
            /*
             * Build Image
             * Push to DockerHub
             * Run Image
             * Add to Proxy
             * Reload Proxy
             */
            // sh """
            // #!/bin/bash
            // set +x
            // docker build -t ${DOCKER_USER}/currency-ci:${env.BUILD_ID} .

            // docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
            // docker push ${DOCKER_USER}/currency-ci:${env.BUILD_ID}
            // docker logout

            // if [ "\$(docker ps --format {{.Names}} | grep -w tomcat)" != "" ];then
            //     docker rm -f tomcat
            // fi
            // docker run -it -d -p 8080:8080 --net adop-network --name tomcat ${DOCKER_USER}/currency-ci:${env.BUILD_ID} 

            // docker cp tomcat.conf proxy:/resources/configuration/sites-enabled/
            // docker cp tomcat.conf proxy:/etc/nginx/sites-enabled/

            // docker restart proxy
            // """
            sh """
            #!/bin/bash
            set +x
            docker build -t currency-ci:${env.BUILD_ID} .

            if [ "\$(docker ps -a --format {{.Names}} | grep -w tomcat)" != "" ];then
                docker rm -f tomcat
            fi
            docker run -it -d -p 8080:8080 --net docker-network --name tomcat currency-ci:${env.BUILD_ID} 

            docker cp tomcat.conf proxy:/resources/configuration/sites-enabled/
            docker cp tomcat.conf proxy:/etc/nginx/sites-enabled/

            docker restart proxy
            """
            pub_ip = sh (
                script: 'curl ifconfig.co',
                returnStdout: true
            ).trim()

            print """\
            |======================================================================================================"
            |Tag number: ${env.BUILD_ID}
            |Sonar Report is at "http://${pub_ip}/sonar/dashboard?id=sim%3ACurrencyConverter"
            |War is located at: http://${pub_ip}/nexus/#view-repositories;snapshots~browsestorage
            |visit converter at: http://tomcat.${pub_ip}.xip.io/currencyconverter/
            |======================================================================================================""".stripMargin()
        //}
        
    }
	// TODO add selenium Test
	    
} 
 
