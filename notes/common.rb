#!/usr/bin/env ruby

frameworks = {}
platforms = Dir.glob('*.txt')

platforms.each do |file|
  File.read(file).lines.each do |framework|
    count = frameworks[framework] || 0
    count += 1
    frameworks[framework] = count
  end
end

frameworks.each do |key, value|
  print key if value == platforms.count
end

