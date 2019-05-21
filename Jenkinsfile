node{
	// stages = boxes represented in pipeline script
	// see: https://wiki.jenkins.io/display/JENKINS/Pipeline+Stage+View+Plugin
	stage('Checkout'){
		// Clone the repository
		checkout([$class: 'GitSCM',
			branches: [[name: '*/master']],
			userRemoteConfigs: [[url: 'https://github.com/migueltanada/sample-java-maven-app']]])
	}
    
	stage('build'){
		// code build, create war in target folder
		// commands in sh block = shell script
		sh "mvn package"	    
	}
	stage('sonar'){
		// Run sonarqube code analysis
		sh "mvn sonar:sonar"
	}
    	
	stage('nexus'){
		// Upload to Nexus
		sh "mvn deploy"
	}
       
    
    
	stage('Deploy'){
		// Create Dockerfile 
		writeFile file: 'Dockerfile', text: '''\
		    |FROM tomcat:7.0 # Use tomcat 7.0 Docker Image
		    |ADD target/currencyconverter.war /usr/local/tomcat/webapps/ # copy built war from target folder to webapps folder
		    '''.stripMargin()

		sh """#!/bin/bash
		# Build Docker Image
		docker build -t ${DOCKER_USER}/currency-ci:latest .
		
		# Run Docker Image
		docker run -it -d -p 8080:8080--name currencyconverter currency-ci:latest
		"""
	}

	    
} 
 
