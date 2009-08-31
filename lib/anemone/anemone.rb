require 'ostruct'
require 'anemone/core'

module Anemone
  # Version number
  VERSION = '0.1.2'

  #module-wide options
  def Anemone.options=(options)
    @options = options
  end
  
  def Anemone.options
    @options
  end
  
  #
  # Convenience method to start a crawl using Core
  #
  def Anemone.crawl(urls, options = {}, &block)
    Anemone.options = OpenStruct.new(options)
	
    #by default, run 4 Tentacle threads to fetch pages
    Anemone.options.threads ||= 4
	
    #disable verbose output by default
    Anemone.options.verbose ||= false
	
    #by default, don't throw away the page response body after scanning it for links
    Anemone.options.discard_page_bodies ||= false

    #by default, identify self as Anemone/VERSION
    Anemone.options.user_agent ||= "Anemone/#{self::VERSION}" 
    
    #Obey Robots.txt 
    Anemone.options.obey_robots_dot_txt ||= false 
    if Anemone.options.obey_robots_dot_txt == true
      begin      
        require 'obey_robots_dot_txt'
      rescue LoadError
        warn "You need the 'obey_robots_dot_txt' gem installed, (you may run sudo gem install parolkar-obey_robots_dot_txt --source http://gems.github.com )"
        exit
      end
    end  
    
    #no delay between requests by default
    Anemone.options.delay ||= 0
    
    #use a single thread if a delay was requested
    if(Anemone.options.delay != 0)
      Anemone.options.threads = 1
    end
    
    Core.crawl(urls, &block)
  end
end
