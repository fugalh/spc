#!/usr/bin/ruby
require 'rexml/document'
doc = REXML::Document.new '<flat-profile/>'
decl = REXML::XMLDecl.new
decl.encoding = "ISO-8859-1"
#doc << decl

root = doc.root

ARGF.each_line do |l|
  next if l =~ /^\s*(#.*)?$/
  raise "Parse Error\n#{l}" unless l =~ /([^\s"\[\]]+)(\[(\d)\])?(\s+([!?])?\s*"([^"]*)")?\s*;\s*$/
  name = $1
  name += "_#{$3}_" unless $3.nil?
  ua = case $5
  when '!'
    'rw'
  when '?'
    'ro'
  else
    'na'
  end
  val = $6
  
  el = root.add_element name
  el.attributes['ua'] = ua
  el.text = val
end

s = ""
doc.write s, 0
puts s.gsub(/='([^']*)'/,'="\1"')

