# visual-diffs-for-eagle-and-git

## Information
If you are working on an [CadSoft EAGLE](http://www.cadsoftusa.com/eagle-pcb-design-software/) project with a team and you are tracking your progress with [Git](http://git-scm.com/), this little programm can help you to see what your team has changed. It makes an diff image which shows the changes on the schematics and boards between the commits.

But first some notes:
* **The files are not allowed to have spaces in their name.**
* **The first commit has the number 1, the last commit has the highest number!**
* This my first ruby programm. It is very, very ugly written.
* Tested under Windows and Linux (Ubuntu).
* Sorry for my bad English!
* **Every help is welcome and appreciated!**

You can test it with the [testrepo](https://github.com/hurik/visual-diffs-for-eagle-and-git_testrepo).

This little programm based on [eagle-converter](https://gitorious.org/gitedaous/eagle-converter) by Patrick Franken. He made the countSheets.ulp file and most of the code is from him, but i didn't get his code running and so I made my own programm.


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
1. After some time your find the diff images under diff for each file in the repo.
1. When a new commit was added, you can rerun the programm and it's only makes the diff images for the new commit.

**Important:** When you want to get diff images of another repo, you have to delete the diff and temp folder!


## TODO
* Important fixes/improvements
	* **Memory should be released after generating the diff image**
	* **Make a diff image of the current working directory**
	* Allow spaces in filenames and folders
	* Improve board diffs (Not sure if it should make images of all layers)
	* Only make an diff image if there was a change (That would safe some time)
* Minor fixes/improvements
	* Improve code
	* Improve speed
	* Improve folder structure (Not sure it it would be better to get all diff images of one commit in one folder or keep the current structure)
	* Improve file naming
	* Improve comments
* fixes/improvements for the future
	* Add a gui (Where you can choose the commits and files of which you want the diff image)


## Changelog
#### v0.2.1
* **Added the possibility to set an commit hash, as first commit to parse** (In the project I'm working on, we have a lot of commits where we only are adding lib for the elements ...)

### v0.2.0
* **Subfolders are now included in the name (Files with same name in different folders are now working)**
* **Diff images now working when the images size is not the same**
* Code was cleaned a lot
* Programm output a little better
* Improved folder structure
* Improve file naming

#### v0.1.3
* **Highly improved diff images**
* Fixed little bug with image size
* Example image added

#### v0.1.2
* **Massiv speedup with oily_png. Now about 14 times faster!**

#### v0.1.1
* **Now it is proccessing files in subfolders**

### v0.1.0
* First commit