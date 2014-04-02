Nostalgia
=========

_Batch renames your photos based on their EXIF date._

I have a problem. Half of my photos come from my iPhone (via the Dropbox uploader), which creates filenames based on the date they were taken. But all the photos from my awesome DSLR are named `BLAHBLAH_7001.jpg` and `BLAHBLAH_7002.jpg`. That annoys me. I want all of my filenames to be date based so I can quickly sort them and find the photos I'm looking for.

Much to my dismay, [Hazel](http://www.noodlesoft.com/hazel.php) and [Automator](https://en.wikipedia.org/wiki/Automator_(software)) can't solve that problem.

This Mac app does.

Launch the app, drag and drop a bunch of photos onto the window (or the Dock icon), and boom! Everything gets renamed appropriately based on the EXIF date.

Currently, there's no way to customize the output date format. It's set to `yyyy-MM-dd HH.mm.ss`. I make no apologies for that. If you'd like something different, feel free to modify the Xcode project or submit a pull request with the ability to customize the date :) Also, it only looks for the standards based `yyyy:MM:dd HH:mm:ss` EXIF format. If your camera doesn't follow along, Nostalgia won't be able to parse it. Again, pull requests are very much welcome.

You can download Nostalgia for your Mac [from here](https://github.com/tylerhall/Nostalgia/releases). 

![Screenshot](https://raw.githubusercontent.com/tylerhall/Nostalgia/master/screenshot.png)
