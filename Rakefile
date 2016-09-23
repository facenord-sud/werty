require 'open3'

APT_CACHE='apt-cache'

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

def container_exists?(name)
  out = `docker ps -q -a -f "name=^/${name}$"`
  $?.exitstatus == 0 && not out.blank?
end

def container_running?(name)
  out = `docker inspect --format="{{ .State.Running }}"`
  $?.exitstatus == 0 && out == 'true'
end

def http_proxy
  ENV['HTTP_PROXY'] || ENV['http_proxy'] || ENV['apt_http_proxy']
end

task :apt_cacher_ng do
  return unless http_proxy.blank?
  if container_exists?(APT_CACHE)
    `docker start ${APT_CACHE}` unless container_running?(APT_CACHE)
  else
    `docker run -d -p 3142:3142 --name ${APT_CACHE} --restart always `
  end
end

task :build do
  IO.mkdir_p('setup')
  IO.write(File.join('setup', '01proxy'), "Acquire::http { Proxy \"http://#{container_ip(APT_CACHE)}:3142\"; };")
  `docker build -t tails:latest .`
end
