# visual-diffs-for-eagle-and-git

## Information
If you are working on an [CadSoft EAGLE](http://www.cadsoftusa.com/eagle-pcb-design-software/) project with a team and you are tracking your progress with [Git](http://git-scm.com/), this little programm can help you to see what your team has changed. It makes an diff image which shows the changes on the schematics and boards between the commits.

But first some notes:
* Tested under Windows and Linux (Ubuntu).
* Schematics and Boards must always have different names, also when they are in different directories.
* The files are not allowed to have spaces in their name.
* This my first ruby programm. It is very, very ugly written.
* It's very slow! For every diff image it takes about one minute. But when only one commit is new, it only makes diff images for the new commit.
* Sorry for my bad English!
* **Every help is welcome and appreciated!**

You can test it with the [testrepo](https://github.com/hurik/visual-diffs-for-eagle-and-git_testrepo).

This little programm based on [eagle-converter](https://gitorious.org/gitedaous/eagle-converter) by Patrick Franken.
He made the countSheets.ulp file and most of the code is from him, but i didn't get his code running and so I made my own programm.


# Requirements
**grit**
> gem install grit

grit is a native extension:
* Under windows you need the [Development Kit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) to install it.
* Under linux you need the ruby-dev package.

**chunky_png**
> gem install chunky_png


## Usage
1. Open the vdfeag.rb file and set the repoPath, repoBranch and @eaglePath.
1. Start the file!
1. After some time your find the diff images under images/diff.


## TODO
* Improve code
* Improve speed
* Improve folder structure
* Improve file naming
* Improve diff images
    * Removed elements should be red
    * Added elements should be green
    * Unchanged elements should be shown with half opaque 
    * Board diffs are very ugly ...
* Improve comments
* Improve programm output
* Improve everything ...
* Add a gui


## Changelog
#### v0.1.1
* Now it is proccessing files in subfolders

### v0.1.0
* First commit