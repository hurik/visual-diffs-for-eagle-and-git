# visual-diffs-for-eagle-and-git

## Information
If you are working on an [CadSoft EAGLE](http://www.cadsoftusa.com/eagle-pcb-design-software/) project with a team and you are tracking your progress with [Git](http://git-scm.com/), this little programm can help you to see what your team has changed. It makes an diff image which shows the changes on the schematics and boards between the commits.

But first some notes:
* Tested under Windows and Linux (Ubuntu).
* Schematics and Boards must always have different names, also when they are in different directories.
* The files are not allowed to have spaces in their name.
* This my first ruby programm. It is very, very ugly written.
* Sorry for my bad English!
* **Every help is welcome and appreciated!**

You can test it with the [testrepo](https://github.com/hurik/visual-diffs-for-eagle-and-git_testrepo).

This little programm based on [eagle-converter](https://gitorious.org/gitedaous/eagle-converter) by Patrick Franken.
He made the countSheets.ulp file and most of the code is from him, but i didn't get his code running and so I made my own programm.


# Example image
![Example image](/hurik/visual-diffs-for-eagle-and-git/raw/master/example.png)
* Brightened elements were not changed
* Red elements were deleted
* Green elements are new
* Red and green elements which are connected, can be moved elements


# Requirements
**grit**
> gem install grit

**oily_png**
> gem install oily_png

**Both gems are native extension:**
* Under windows you need the [Development Kit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) to install it.
* Under linux you need the ruby-dev package.


## Usage
1. Open the vdfeag.rb file and set the repoPath, repoBranch and @eaglePath.
1. Start the file!
1. After some time your find the diff images under images/diff.


## TODO
* **Improve code**
* Improve speed more
* Improve folder structure
* Improve file naming
* Improve diff images
    * Board diffs are very ugly ...
* Improve comments
* Improve programm output
* Improve everything ...
* Add a gui


## DONE
* Improve speed (v0.1.2)
* Improve diff images (v0.1.3)
    * Removed elements should be red (v0.1.3)
    * Added elements should be green (v0.1.3)
    * Unchanged elements should be brightened (v0.1.3)


## Changelog
#### v0.1.3
* Highly improved diff images
* Fixed little bug with image size
* Example image added

#### v0.1.2
* Massiv speedup with oily_png. Now about 14 times faster!

#### v0.1.1
* Now it is proccessing files in subfolders

### v0.1.0
* First commit