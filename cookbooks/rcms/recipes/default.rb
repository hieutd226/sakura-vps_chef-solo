#
# php
#
execute "yum upgrade -y" do
    command "yum upgrade -y"
end

remote_file "/tmp/epel-release-6-8.noarch.rpm" do
    source "http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end
package "epel-release" do
    action :install
    not_if "rpm -q epel-release"
    source "/tmp/epel-release-6-8.noarch.rpm"
end

remote_file "/tmp/remi-release-6.rpm" do
    source "http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
end

package "remi-release" do
    action :install
    not_if "rpm -q remi-release"
    source "/tmp/remi-release-6.rpm"
end

cookbook_file "/etc/yum.repos.d/remi.repo" do
    source "remi.repo"
end

#nginx
remote_file "/tmp/nginx-release-centos-6-0.el6.ngx.noarch.rpm" do
    source "http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm"
end
package "nginx" do
    action :install
    not_if "rpm -q nginx"
    source "/tmp/nginx-release-centos-6-0.el6.ngx.noarch.rpm"
end

#after repo add
execute "yum upgrade -y" do
    command "yum upgrade -y"
end

#
# Package install
#
%w{
    yum-fastestmirror
    wget
    crontabs
    pcre-devel
    php
    httpd
    mod_ssl
    php-cli
    php-common
    php-pdo
    php-pgsql
    php-mysql
    php-mbstring
    php-gd
    php-imap
    php-dom
    php-devel
    php-pecl-apc
    php-xml
    php-pear
    php-soap
    php-gd
    php-mcrypt
    php-pecl-memcache
    libgcj
    java-gcj-compat
    postfix
    automake
    libtool
    gcc
    gcc-c++
    openssl-devel
    zlib-devel
    make
    readline-devel
    bzip2-devel
    ImageMagick
    memcached
    xpdf
    s3cmd
    sysstat
}.each do |pkgname|
    package "#{pkgname}" do
        action :install
        not_if "rpm -q #{pkgname}"
    end
end


#IPA Fonts 落ちてる、、
#remote_file "/tmp/IPAexfont00103.zip" do
#    source "http://ossipedia.ipa.go.jp/ipafont/IPAexfont00103.php"
#end
#execute "install-IPAexfont" do
#    command "unzip /tmp/IPAexfont00103.zip -d /tmp/ && cp /tmp/IPAexfont00103/*ttf /usr/share/fonts/"
#end

#pdftk
remote_file "/tmp/pdftk-1.44-2.el6.rf.x86_64.rpm" do
    source "http://pkgs.repoforge.org/pdftk/pdftk-1.44-2.el6.rf.x86_64.rpm"
end

package "pdftk" do
    action :install
    not_if "rpm -q pdftk"
    source "/tmp/pdftk-1.44-2.el6.rf.x86_64.rpm"
end

#ffmpeg
remote_file "/tmp/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm" do
    source "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm"
end

package "rpmforge-release" do
    action :install
    not_if "rpm -q rpmforge-release"
    source "/tmp/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm"
end
execute "install-ffmpeg" do
    command "yum --enablerepo=rpmforge -y install ffmpeg ffmpeg-devel"
end

directory "/home/rcms" do
    owner "root"
    group "root"
    mode 00755
    action :create
end

cookbook_file "/home/rcms/ioncube_loader_lin_5.4.so" do
    source "ioncube_loader_lin_5.4.so"
end

template "/etc/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode "0644"
end

#
# service
#
service "httpd" do
    action [ :enable , :restart ]
end




