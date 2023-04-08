def newDownload(repo)
{
  git "https://github.com/intelliqittrainings/${repo}"
}

def newBuild()
{
  sh "mvn package"
} 

def Dockerfilecreation(jobname)
{
  sh "scp /var/lib/jenkins/workspace/${jobname}/webapp/target/webapp.war ."
  sh  '''cat > dockerfile << EOF
         FROM tomee
         MAINTAINER ravindra
         COPY  webapp.war  /usr/local/tomee/webapps/testapp.war'''
}

def dockerimagecreation(imagename)
{
  sh "sudo docker build -t ${imagename} ."
} 

def pushdockerimage(imagename)
{
  sh "sudo docker login -u ravisree900 -p Sree@6367+-"
  sh "sudo docker push ${imagename}"
}
def deployintotestserver(ip, playbookname)
{
  sh "ssh ubuntu@${ip} ansible-playbook ${playbookname} -b"
}

def runselenium(jobname)
{
  sh "java -jar /var/lib/jenkins/workspace/${jobname}/testing.jar"
}

def deployintoprodserver(ipaddress, definationfilename)
{
  sh "ssh ubuntu@${ipaddress} kubectl apply -f ${definationfilename}"
}
