#!/usr/bin/env ruby

# Configures the git author to a list of developers when pair programming
#
# Usage: pair lm bh (Sets the author to 'Luke Melia and Bryan Helmkamp')
#        pair       (Unsets the author so the git global config takes effect)
#
# Author: Bryan Helmkamp (http://brynary.com)
# http://www.brynary.com/2008/9/1/setting-the-git-commit-author-to-pair-programmers-names

#######################################################################
## Configuration


PAIR_EMAIL = "pair@chargify.com"

AUTHORS = {
  "mk" => "Michael Klett",
  "nv" => "Nathan Verni",
  "jr" => "Jeremy Rowe",
  "jn" => "James Newton",
  "gm" => "Graham McIntire"
}

GITHUB_EMAILS = {
  "mk" => "",
  "nv" => "",
  "jr" => "jeremy.w.rowe@gmail.com",
  "jn" => "",
  "gm" => "gmcintire@gmail.com"
}

## End of configuration
#######################################################################

unless File.exists?(".git")
  puts "This doesn't look like a git repository."
  exit 1
end

authors = ARGV.map do |initials|
  if AUTHORS[initials.downcase]
    AUTHORS[initials.downcase]
  else
    puts "Couldn't find author name for initials: #{initials}"
    exit 1
  end
end

if authors.any?
  email = PAIR_EMAIL
  if authors.size == 1
    authors = authors.first
    email   = GITHUB_EMAILS[AUTHORS.invert[authors]]
  elsif authors.size == 2
    authors = authors.join(" and ")
  else
    authors = authors[0..-2].join(", ") + " and " + authors.last
  end

  initials = ARGV.join('/')

  `git config user.name '#{authors}'`
  `git config user.initials '#{initials}'`
  `git config user.email '#{email}'`

  puts "user.name = #{authors}"
  puts "user.initials = #{initials}"
  puts "user.email = #{email}"
else
  `git config --unset user.name`
  `git config --unset user.initials`
  `git config --unset user.email`

  puts "Unset user.name, user.initials, and user.email"
end

