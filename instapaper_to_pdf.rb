#!ruby
# coding: utf-8

# Copyright (c) 2011 David Aaron Fendley
#
# Instapaper-to-PDF is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

# This requires the htmldoc to be installed on your system. Mac users with MacPorts can install this with:
# sudo port install htmldoc
# Windows and Linux users, check here: http://www.htmldoc.org/

require 'rubygems'
require "mechanize"
require 'htmldoc'
require "./sanitize_filename"
require "./import_to_devonthink"

# Delete articles from Instapaper..
def delete_articles(page)
  page.links_with(:text => "Delete").each do |link|
    page = link.click
  end
end

# Instapaper credentials
instapaper_username = "USERNAME"
instapaper_password = "PASSWORD"
pdf_destination = "/Users/username/Downloads"

# Go to the login page.
agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'
agent.redirect_ok = true
page = agent.get "http://www.instapaper.com/user/login"

# Login.
puts "Logging in..."
form =  page.forms.first
form.username = instapaper_username
form.password = instapaper_password
page = agent.submit form

# Follow the redirect.
page = page.link_with(:text => "Click here if you aren't redirected").click

# Print a PDF of each article.
page.links_with(:text => "Text").each do |link|
  article_page = link.click
  file_path = "\"" + pdf_destination + "/#{sanitize_filename(article_page.title)}.pdf\""

  pdf = PDF::HTMLDoc.new

  pdf.set_option :outfile, file_path
  pdf.set_option :bodycolor, :white
  pdf.set_option :links, true

  pdf << article_page.body

  puts "Printing a PDF for \"#{article_page.title}\""
  pdf.generate

  # Enable importing to DEVONthink here. Syntax: path_to_file, database, folder.
  # import_to_devonthink(file_path, "Personal", "Articles")
end

# Delete from Instapaper.
# puts "Deleting articles from Instapaper"
# delete_articles(page)

puts "Mission accomplished."