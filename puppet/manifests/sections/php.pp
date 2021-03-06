include php

class {
	'php::composer':;
	'php::fpm':
		provider => 'apt';
	'php::dev':
		provider => 'apt';
	'php::pear':
		provider => 'apt';
	'php::extension::imagick':
		package => 'php5-imagick',
		provider => 'apt';
	# 'php::extension::xdebug':
	# 	package => 'php5-xdebug',
	# 	provider => 'apt';
	'php::extension::mcrypt':
		package => 'php5-mcrypt',
		provider => 'apt';
	'php::extension::mysql':
		package => 'php5-mysql',
		provider => 'apt';
	'php::extension::curl':
		package => 'php5-curl',
		provider => 'apt';
	'php::extension::gd':
		package => 'php5-gd',
		provider => 'apt';
	'php::extension::apc':
		package => 'php-apc',
		provider => 'apt';
}

php::fpm::conf { 'www': user => 'vagrant' }

package { 'memcached': ensure => present }
package { 'php5-memcache': ensure => present }
package { 'phpmyadmin':
	ensure => present,
	require => Package['nginx']
}

# TODO: Make this not gross
package { 'php5-xdebug': ensure => 'present' }
exec { 'configure php5-xdebug':
	command => 'echo "zend_extension=`sudo find / -name \'xdebug.so\' | head -1`" | sudo tee -a /etc/php5/conf.d/xdebug.ini',
	unless => 'test -f /etc/php5/conf.d/xdebug.ini && cat /etc/php5/conf.d/xdebug.ini | grep zend_extension',
	notify => Service['php5-fpm'],
	require => Package['php5-xdebug']
}

# Turn on html_errors
exec { 'html_errors = On':
	command => 'sed -i "s/html_errors = Off/html_errors = On/g" /etc/php5/fpm/php.ini',
	unless => 'cat /etc/php5/fpm/php.ini | grep "html_errors = On"',
	user => root,
	notify => Service['php5-fpm']
}
