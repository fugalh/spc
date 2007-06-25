#!/usr/bin/ruby
# spc.rb - Sipura's spc text-to-xml compiler clone
# Copyright (C) 2006  Hans Fugal <hans@fugal.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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

