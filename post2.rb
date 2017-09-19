require 'selenium-webdriver'
require 'json'


class Post
    def initialize(data)
        @creds = data['creds']
        @ads = data['posts']
        @index = 0
        @frequency = data['frequency']
        puts "posting every #{@frequency} minutes"
    end

    def login(browser)
        browser.get('https://accounts.craigslist.org/login')
        sleep(3)
        browser.find_element(:id, 'inputEmailHandle').send_keys @creds['email']
        sleep(3)
        browser.find_element(:id, 'inputPassword').send_keys @creds['pw']
        sleep(3)
        login_button = browser.find_element(:css, 'button.accountform-btn').click
        sleep(3)
    end

    def post(browser, postdetails)
        browser.get('https://post.craigslist.org/c/rcs')
        sleep(3)
        browser.find_element(:css, 'input[value=fsd]').click
        sleep(3)
        browser.find_element(:css, 'button.pickbutton').click
        sleep(3)
        browser.find_elements(:css, 'span.right-side').select {|el| el.text.include? 'appliances - by owner' }.first.click
        sleep(3)
        browser.find_element(:id, 'PostingTitle').send_keys postdetails['title']
        sleep(3)
        browser.find_element(:id, 'postal_code').send_keys postdetails['zip']
        sleep(3)
        browser.find_element(:id, 'PostingBody').send_keys postdetails['text']
        sleep(3)
        browser.find_element(:css, 'button.bigbutton').click
        sleep(3)
        browser.find_element(:css, 'button.continue.bigbutton').click
        sleep(3)
    end

    def uploadImage(browser, image)
        browser.find_element(:css, 'input[type=file]').send_keys image
        sleep(3)
        browser.find_element(:css, 'button.done.bigbutton').click
        sleep(3)
    end

    def make_post(browser, add)
        login browser
        post browser, add

        #upload images when appropriate
        uploadImage browser, File.join(Dir.pwd, add['filename'])

        # too finally post a draft
        #browser.find_element(:css, 'button.bigbutton').click
    end

    def doPost(browser)
        return if !@last_exec.nil? and Time.now < (@last_exec + (@frequency * 60))
        if @ads[@index].nil?
            ad = @ads.first
            @index = 1
        else
            ad = @ads[@index]
            @index = @index + 1
        end

        puts "Posting: " + ad['title']
        @last_exec = Time.now
        make_post(browser, ad)
    end
end

rochester_file = File.read('rochester.json')
syracus_file = File.read('syracus.json')
#buffalo_file = File.read('buffalo.json')
feeds = [Post.new(JSON.parse(rochester_file)), Post.new(JSON.parse(syracus_file))]

browser = Selenium::WebDriver.for(:firefox)

loop do
  feeds.each do |f|
    f.doPost browser
  end
  puts 'sleeping for 1m'
  sleep(60)
end
