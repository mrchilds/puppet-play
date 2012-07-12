class drupal::install {

	package { ['apache2',
		   'php5-mysql',
		   'php5-gd',
		   'libapache2-mod-php5',
		   'mysql-server']:	
		ensure 		=> installed,
	}

	package { ['drupal7']:
		ensure 		=> installed,
		require 	=> Package['apache2'],
	}

        file { 'default_conf':
                source    	=> 'puppet:///modules/drupal/default',
                path      	=> '/etc/apache2/site-available/',
                require   	=> Package['apache2'],
        }

        service { 'apache2':
                ensure    	=> running,
                require   	=> Package['apache2'],
                subscribe 	=> File['default_conf', 'drupal.conf'],
        }

	file { 'drupal.conf':
		source 		=> '/etc/drupal/7/apache2.conf',
		path		=> '/etc/apache2/mods-enabled/drupal.conf',
		require 	=> Package['drupal7'],
	}
}
