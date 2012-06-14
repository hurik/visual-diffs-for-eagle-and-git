# visual-diffs-for-eagle-and-git
# https://github.com/hurik/visual-diffs-for-eagle-and-git
#
# v0.1.1
#
# Created by Andreas Giemza on 2012-06-14.
#
# Based on: https://gitorious.org/gitedaous/eagle-converter
#           http://jeffkreeftmeijer.com/2011/comparing-images-and-creating-image-diffs/

require 'grit'
require 'chunky_png'
include ChunkyPNG::Color

# Oprions
repoPath = "e:/visual-diffs-for-eagle-and-git_testrepo"
repoBranch = "master"
@eaglePath = "c:/Programme/EAGLE-6.1.0/bin/eagle.exe"


def parseTree(tree)
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
	            	`#{@eaglePath} -C 'EXPORT IMAGE #{@commitPath}/#{content.name}.png 150; QUIT' #{temp_data}`
	            else
	            	sheetCount.times do |i|
	            	`#{@eaglePath} -C "EDIT .s#{i+1}; EXPORT IMAGE #{@commitPath}/#{content.name}_#{i+1}.png 150; QUIT" #{temp_data}`
	            	end
	            end

            	File.delete(temp_data)
			end
		end
		if content.kind_of? Grit::Tree
			parseTree(content)
		end
	end
end

puts "Initializing"
@currentPath = Dir.getwd
@tempPath = @currentPath + "/temp"
@imagesPath = @currentPath + "/images"
@commitImagesPath = @imagesPath + "/commits"
@diffImagesPath = @imagesPath + "/diff"

if !File.directory? (@tempPath)
	puts "Creating temp directory"
	Dir.mkdir(@tempPath)
end

if !File.directory? (@imagesPath)
	puts "Creating images directory"
	Dir.mkdir(@imagesPath)
end

if !File.directory? (@commitImagesPath)
	puts "Creating images/commits directory"
	Dir.mkdir(@commitImagesPath)
end

if !File.directory? (@diffImagesPath)
	puts "Creating images/commits directory"
	Dir.mkdir(@diffImagesPath)
end

puts "Opening repository at #{repoPath} with branch #{repoBranch}"
repo = Grit::Repo.new(repoPath)

commitCounter = 0

repo.commits(repoBranch).reverse_each do |commit|
	commitCounter += 1

	@commitPath = @commitImagesPath + "/#{commitCounter}"

	if File.directory? (@commitPath)
		puts "Already parsed #{commit.id}"
	else
		puts "Parsing tree #{commit.id}"
		Dir.mkdir(@commitPath)
		parseTree(commit.tree)
	end
end

commitCounter = 0

loop do
	commitCounter += 1

	commitPath1 = "#{@commitImagesPath}/#{commitCounter}"

	if File.directory? (commitPath1)
		commitPath2 = "#{@commitImagesPath}/#{commitCounter+1}"

		if File.directory? (commitPath2)
			for file in Dir.entries(commitPath1)
				if !(file == "." || file == "..")
					if File.exist? ("#{commitPath2}/#{file}")

						diffImageFolder = "#{@diffImagesPath}/#{file}"

						if !File.directory? (diffImageFolder)
							puts "Creating images/commits directory"
							Dir.mkdir(diffImageFolder)
						end						

						diffImageFile = "#{diffImageFolder}/#{commitCounter}_#{commitCounter+1}_#{file}"

						if !File.exist? (diffImageFile)
							puts "Creating #{commitCounter}_#{commitCounter+1}_#{file}"

							images = [
							  ChunkyPNG::Image.from_file("#{commitPath1}/#{file}"),
							  ChunkyPNG::Image.from_file("#{commitPath2}/#{file}")
							]

							output = ChunkyPNG::Image.new(images.first.width, images.last.width, WHITE)

							diff = []

							images.first.height.times do |y|
							  images.first.row(y).each_with_index do |pixel, x|
							    unless pixel == images.last[x,y]
							      score = Math.sqrt(
							        (r(images.last[x,y]) - r(pixel)) ** 2 +
							        (g(images.last[x,y]) - g(pixel)) ** 2 +
							        (b(images.last[x,y]) - b(pixel)) ** 2
							      ) / Math.sqrt(MAX ** 2 * 3)

							      output[x,y] = grayscale(MAX - (score * MAX).round)
							      diff << score
							    end
							  end
							end

							output.save(diffImageFile)
						else
							puts "Already created #{commitCounter}_#{commitCounter+1}_#{file}"
						end
					end
				end
			end
		else
			break
		end
	else
		break
	end
end