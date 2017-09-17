require 'selenium-webdriver'
browser = Selenium::WebDriver.for(:firefox)

files = []
Dir[File.dirname(__FILE__) + '/images/*'].each {|file| files << file }

creds = {email: 'repaireguy1984@gmail.com', pw: 'h0me0ffice'}

add = {
    header: 'WARNING!!! - POSSIBLE CLASS ACTION LAWSUIT AGAINST ARCTIC WHOLESALE',
    text: "WE ARE COLLECTING INFORMATION LEADING TO A POSSIBLE CLASS ACTION LAWSUIT AGAINST ARCTIC WHOLESALE FOR WARRANTY WORK.\nARCTIC WHOLESALE REFUSAL TO DO WARRANTY WORK, CHARGING FOR WARRANTY WORK, EXTENSIVE TIME FRAMES FOR WARRANTY WORK TO BE COMPLETED.\nPLEASE EMAIL THE ISSUES YOU HAVE HAD WITH ARCTIC WHOLESALE ALONG WITH BASIC CONTACT INFO."
}


def login(browser, creds)
    browser.get('https://accounts.craigslist.org/login')
    sleep(10)
    browser.find_element(:id, 'inputEmailHandle').send_keys creds[:email]
    sleep(10)
    browser.find_element(:id, 'inputPassword').send_keys creds[:pw]
    sleep(10)
    login_button = browser.find_element(:css, 'button.accountform-btn').click
    sleep(10)
end

def post(browser, postdetails)
    browser.get('https://post.craigslist.org/c/rcs')
    sleep(10)
    browser.find_element(:css, 'input[value=fsd]').click
    sleep(10)
    browser.find_element(:css, 'button.pickbutton').click
    sleep(10)
    browser.find_elements(:css, 'span.right-side').select {|el| el.text.include? 'appliances - by owner'}.first.click
    sleep(10)
    browser.find_element(:id, 'PostingTitle').send_keys postdetails[:header]
    sleep(10)
    browser.find_element(:id, 'postal_code').send_keys 14607
    sleep(10)
    browser.find_element(:id, 'PostingBody').send_keys postdetails[:text]
    sleep(10)
    browser.find_element(:css, 'button.bigbutton').click
    sleep(10)
    browser.find_element(:css, 'button.continue.bigbutton').click
    sleep(10)
end

def uploadImage(browser, image)
    browser.find_element(:css, 'input[type=file]').send_keys image
    sleep(10)
    browser.find_element(:css, 'button.done.bigbutton').click
    sleep(10)
end

loop do
    login browser, creds
    post browser, add

    # too finally post a draft
    browser.find_element(:css, 'button.bigbutton').click
end
