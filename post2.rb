require 'selenium-webdriver'
browser = Selenium::WebDriver.for(:firefox)

files = []
Dir[File.dirname(__FILE__) + '/images/*'].each {|file| files << file }

creds = {email: 'justice80088008@gmail.com', pw: 'vendetta01'}

add = {
    text: "!!!Buyer Beware of Arctic Wholesale!!!\n- False 1 Year Warranty claims. They will charge a lot of money for labor if your appliance breaks after 90 days. There is a pending class action lawsuit regarding this.\n- Spam of appliances on the owner section. Most are not still for sale. They will try to bait and switch you.\n- They will hustle you to pay in cash to avoid paying taxes.\nDo not fall for their tricks."
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
    filename = files.shuffle.first
    add[:header] = filename[0..-4]
    post browser, add

    #upload images when appropriate
    uploadImage browser, File.join(Dir.pwd, filename)

    # too finally post a draft
    browser.find_element(:css, 'button.bigbutton').click
    sleep 1800
end
