$env:JAVA_HOME = "C:\Program Files\Java\jdk1.7.0_80"
$env:PATH = "$($env:JAVA_HOME)\bin;$($env:PATH)"
.\gradlew.bat --no-daemon --recompile-scripts --refresh-dependencies clean build
.\gradlew.bat  --no-daemon publishToMavenLocal publishGradlePluginPublicationToMavenLocal

$xlDeployVersion = "0.4.1-SNAPSHOT"
$xlDeployReleaseVersion = "0.4.1-sic"
$xlDeployDir = "$env:USERPROFILE\.m2\repository\com\xebialabs\gradle\xl-deploy-gradle-plugin\0.4.1-SNAPSHOT"
$xlDeployPom = "xl-deploy-gradle-plugin-$($xlDeployReleaseVersion).pom"
$xlDeployJar = "xl-deploy-gradle-plugin-$($xlDeployReleaseVersion).jar"

rmdir -Recurse tmp
mkdir tmp
copy -Recurse "$xlDeployDir\xl-deploy-gradle-plugin-*" tmp
move "tmp\xl-deploy-gradle-plugin-$($xlDeployVersion)-javadoc.jar" "tmp\xl-deploy-gradle-plugin-$($xlDeployReleaseVersion)-javadoc.jar"
move "tmp\xl-deploy-gradle-plugin-$($xlDeployVersion)-sources.jar" "tmp\xl-deploy-gradle-plugin-$($xlDeployReleaseVersion)-sources.jar"
move "tmp\xl-deploy-gradle-plugin-$($xlDeployVersion).jar" "tmp\xl-deploy-gradle-plugin-$($xlDeployReleaseVersion).jar"
move "tmp\xl-deploy-gradle-plugin-$($xlDeployVersion).pom" "tmp\xl-deploy-gradle-plugin-$($xlDeployReleaseVersion).pom"
cat "tmp\xl-deploy-gradle-plugin-$($xlDeployReleaseVersion).pom" | foreach { $_ -replace $xlDeployVersion, $xlDeployReleaseVersion } | Out-file -Encoding OEM "tmp\xl-deploy-gradle-plugin-$($xlDeployReleaseVersion).pom.tmp"
move -Force "tmp\xl-deploy-gradle-plugin-$($xlDeployReleaseVersion).pom.tmp" "tmp\xl-deploy-gradle-plugin-$($xlDeployReleaseVersion).pom"



mvn deploy:deploy-file "-DpomFile=tmp\$($xlDeployPom)" `
  -DgeneratePom=false `
  "-Dfile=tmp\$($xlDeployJar)" `
  -DrepositoryId=nexus-releases `
  -Durl=https://nexus.standard.com:8443/nexus/repository/releases
  
mvn deploy:deploy-file "-DpomFile=com.xebialabs.xl-deploy.gradle.plugin-$($xlDeployReleaseVersion).pom" `
  -DgeneratePom=false `
  "-Dfile=com.xebialabs.xl-deploy.gradle.plugin-$($xlDeployReleaseVersion).pom" `
  -DrepositoryId=nexus-releases `
  -Durl=https://nexus.standard.com:8443/nexus/repository/releases