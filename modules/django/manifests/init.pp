class django::install {

	#Installing the hardway to refresh my brain

	Exec {
		path => [
			'/usr/local/bin',
			'/opt/local/bin',
			'/usr/bin',
			'/usr/sbin',
			'/bin',
			'/sbin'],
		logoutput => true,
	}

	#TODO - Create custom fact to remove excess unlesses		
	
	exec { 'get-django':
		cwd		=> '/tmp/',
		command		=> 'wget http://www.djangoproject.com/m/releases/1.4/Django-1.4.tar.gz',
		unless		=> 'ls /usr/local/bin/django-admin.py',	
	}

	exec { 'tar xzvf Django-1.4.tar.gz':
		cwd		=> '/tmp/',
		require		=> Exec['get-django'],
		unless          => 'ls /usr/local/bin/django-admin.py',
	}

	exec { 'python setup.py install':
		cwd		=> '/tmp/Django-1.4',	
		require		=> Exec['tar xzvf Django-1.4.tar.gz'],
		unless          => 'ls /usr/local/bin/django-admin.py',
	}	

	exec { 'rm -r Django-1.4':
		cwd		=> '/tmp/',
		command 	=> 'rm -r Django-1.4',
		onlyif		=> 'ls /tmp/Django-1.4',
	}

	exec { 'rm Django-1.4.tar.gz':
		cwd		=> '/tmp/',
		onlyif		=> 'ls /tmp/Django-1.4.tar.gz',
	}

	exec { 'mkdir -p /var/www/django':
		require 	=> Exec['get-django'],
		creates 	=> '/var/www/django/',
		unless 		=> 'ls /var/www/django/',
	}

	#Lets use command
	exec { 'django-admin':
		require		=> Exec['mkdir -p /var/www/django'],
		cwd		=> '/var/www/django',
		command		=> '/usr/local/bin/django-admin.py startproject foo',
		unless		=> 'ls /var/www/django/foo/',
	}

}
