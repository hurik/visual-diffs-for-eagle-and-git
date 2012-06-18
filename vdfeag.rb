# visual-diffs-for-eagle-and-git
# https://github.com/hurik/visual-diffs-for-eagle-and-git
#
# v0.2.1
#
# Created by Andreas Giemza on 2012-06-18.
#
# Based on: https://gitorious.org/gitedaous/eagle-converter
#           http://jeffkreeftmeijer.com/2011/comparing-images-and-creating-image-diffs/

require 'grit'
require 'oily_png'
include ChunkyPNG::Color

# Options
repoPath = "e:/visual-diffs-for-eagle-and-git_testrepo"
repoBranch = "master"
@eaglePath = "c:/Programme/EAGLE-6.1.0/bin/eagle.exe"
firstCommitHash = "a40b10cd466a09660f3c324e03216301073a5b1c"
# Set firstCommitHash = "" to parse all commits

# Checks if a directory exists and when not, it creates it
def createDirectory(path)
  if !File.directory? (path)
    puts "Creating #{path} directory"
    Dir.mkdir(path)
  end
end

# Creates the diff image
def createDiffImage(oldImage, newImage, diffImage)
  images = [
    ChunkyPNG::Image.from_file(oldImage),
    ChunkyPNG::Image.from_file(newImage)
  ]

  width = [images.first.width, images.last.width].max
  height = [images.first.height, images.last.height].max

  if images.first.width != width or images.first.height != height
    oldTemp = ChunkyPNG::Image.new(width, height, WHITE)

    images.first.height.times do |y|
      images.first.row(y).each_with_index do |pixel, x|
        oldTemp[x,y] = pixel
      end
    end

    images[0] = oldTemp
  end

  if images.last.width != width or images.last.height != height
    newTemp = ChunkyPNG::Image.new(width, height, WHITE)

    images.last.height.times do |y|
      images.last.row(y).each_with_index do |pixel, x|
        newTemp[x,y] = pixel
      end
    end

    images[1] = newTemp
  end

  output = ChunkyPNG::Image.new(width, height, WHITE)

  images.first.height.times do |y|
    images.first.row(y).each_with_index do |pixel, x|
      if pixel == images.last[x,y]
        if pixel == WHITE
          next
        else
          output[x,y] = interpolate_quick(pixel, WHITE, 80)
        end
      elsif pixel == WHITE
        output[x,y] = :green
      elsif images.last[x,y] == WHITE
        output[x,y] = :red
      else
        output[x,y] = :grey
      end
    end
  end

  output.save(diffImage)
end

# Parse the commits
def parseTree(tree, currentFolder)
  if tree.name != nil
    currentFolder = currentFolder + tree.name.to_s + "_-_"
  end

  tree.contents.each do |content|
    if content.kind_of? Grit::Blob
      type = content.name.split('.').last
      if type == 'sch' or type == 'brd'
        puts "Got EAGLE file: #{content.name}"

        temp_data = @tempPath + '/' + content.name

        file = File.new(temp_data, "w")
        file.puts(content.data)
        file.close

        `#{@eaglePath} -C 'RUN #{@currentPath}/countSheets.ulp #{@tempPath}/sheet_info.txt; QUIT' #{temp_data}`

        sheetCount = IO.read("#{@tempPath}/sheet_info.txt").to_i

        if sheetCount == 0
          `#{@eaglePath} -C 'EXPORT IMAGE #{@commitPath}/#{currentFolder}#{content.name}.png 150; QUIT' #{temp_data}`
        else
          sheetCount.times do |i|
            `#{@eaglePath} -C "EDIT .s#{i+1}; EXPORT IMAGE #{@commitPath}/#{currentFolder}#{content.name}_page#{i+1}.png 150; QUIT" #{temp_data}`
          end
        end

        File.delete(temp_data)
      end
    end
    if content.kind_of? Grit::Tree
      parseTree(content, currentFolder)
    end
  end
end

puts "\nInitializing"
puts "------------\n"

@currentPath = Dir.getwd
@tempPath = @currentPath + "/temp"
@commitImagesPath = @tempPath + "/commits"
@diffImagesPath = @currentPath + "/diffs"

createDirectory(@tempPath)
createDirectory(@commitImagesPath)
createDirectory(@diffImagesPath)

puts "Done!"

puts "\nParsing repo"
puts "------------\n"

puts "Opening repository at #{repoPath} with branch #{repoBranch}"
repo = Grit::Repo.new(repoPath)

commitCounter = 0

parse = false

repo.commits(repoBranch).reverse_each do |commit|
  commitCounter += 1

  if (firstCommitHash == "" or firstCommitHash == commit.id) and parse == false
    parse = true
  end

  if parse
    @commitPath = @commitImagesPath + "/#{commitCounter}"

    if !File.directory? (@commitPath)
      puts "Parsing tree #{commit.id}"
      createDirectory(@commitPath)
      parseTree(commit.tree, "")
    end
  end
end

puts "Done!"

puts "\nDiff images"
puts "-----------\n"

loop do
  commitPath1 = "#{@commitImagesPath}/#{commitCounter-1}"
  commitPath2 = "#{@commitImagesPath}/#{commitCounter}"

  if File.directory? (commitPath1) and File.directory? (commitPath2)
    for file in Dir.entries(commitPath1)
      if !(file == "." || file == "..") and File.exist? ("#{commitPath2}/#{file}")

        diffImageFolder = "#{@diffImagesPath}/#{file.chomp(".png")}"

        createDirectory(diffImageFolder)

        diffImageFile = "#{diffImageFolder}/#{commitCounter-1}_#{commitCounter}_#{file}"

        if !File.exist? (diffImageFile)
          puts "Creating diff image: #{commitCounter-1}_#{commitCounter}_#{file}"

          createDiffImage("#{commitPath1}/#{file}", "#{commitPath2}/#{file}", diffImageFile)
        end
      end
    end
  else
    break
  end

  commitCounter -= 1
end

puts "Done!"