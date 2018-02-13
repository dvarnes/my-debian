# How to prepare custom Debian image

## Motivation

- minimal system, starting from netinstall image;
- i3wm, no gnome/KDE/LXCDE/etc;
- all my favorite packages included;
- fast install at any PC, laptop or VM and continue my work;
- firewall, apparmor, ssh protection, other security options included;
- my personal settings, config files, browser plugins included;
- my locale and keyboard settings included;
- printer/scanner drivers;
- my personal scripts, backup solution;
- only choose partitions during installation, all other choises provided;
- build packages from sources during setup?
- after setup: sync fresh files from backup and ready to go;

## What's needed

1. Debian on PC or in VM.  I installed it in VirtualBox on Mac OS X.
   VirtualBox can be installed with 
    
    brew cask install virtualbox
    brew cask install virtualbox-extension-pack

   Note: installation was not smooth, first attempt failed, I requested to
   enable extension at security page in the system preferences panel. Next 
   attempt was successful.

   It's convenient to install 2 VM - one to build and one to test installation.

2. On Debian I installed `mc` (get used to it), one convenient feature of it is
   `F9 > Left > Shell link...` menu, where `sh://nick@10.0.2.2` could be used
   to share folders with the host (with Debian as a VirtualBox guest) - no need
   to install vbox extensions in the guest system.

3. So, on guest Debian:

    sudo apt-get install mc vim simple-cdd dh-make debconf-utils
    mkdir ~/my-cdd
    cd ~/my-cdd
    # Use mc or scp to copy files into my-cdd from this project.
    # See docs in `/usr/share/doc/simple-cdd` and `man simple-cdd`.
    # Alternatively, install `git` and use `git clone`.
    ./build

4. It requires several minutes to create an image within VM on my Mac mini.
   When it finish, the image will be in the `images` subfolder.
   This image can be used to install VM or can be used to make a bootable USB
   stick.

## Custom files

- `./custom_extra/cfg`: subdirectories of this dir will be `tar`'ed and stored
  at installation media directory `simple-cdd/cfg` (for example:
  `./custom_extra/cfg/foo/ -> /cdrom/simple-cdd/foo.tar`) and later unpacked to
  the target root dir; this is for general configuration (like console, grub,
  etc);
- `./custom_extra/pkg-src`: subdirectories of this dir will be converted to
  `deb` packages with `dh-make` and `dpkg-buildpackage` (script will take care
  of this);
- `./custom_extra/pkg`: temporary dir of packages, built from `pkg-src`, should
  not be put into version control;

## VirtualBox Guest Additions

In case of executing this image as a VirtualBox guest, I had an issues starting
Xorg. This is, probably, due xorg trying to load module, requiring vbox
additions.  At least, it can be cured with installation of guest additions, so
I put the script to install them into default user's profile.

So, if you cannot login into the first console after OS installation, due X
errors, use Alt+F2 to login into the second console and run script from there.
Script should be in the user's home dir: `~/install-vb-guest-additions`.

## Make installation USB stick

Conveniently, `simple-cdd` creates an image suitable to be "burn" to USB drive
with just terminal tools. I haven't try to do it in Linux yet, only on Mac OS
X.  (I use Mac mini as a backup computer, so, for me it's currently more
important to be able to create an installation media with it.)

Both Mac OS X and Linux can use similar method, so if it works on Mac, it
should work on Linux as well.

    # For Linux:
    sudo dd bs=4M if=input.iso of=/dev/sdX conv=fdatasync
    # For Mac OS X:
    sudo dd if=inputfile.img of=/dev/diskX bs=4m && sync

To check correct device name on Linux, I'd use `lsblk` (and `punmount sdX` to
unmount it). With Mac OS X it was not so trivial.  When I inserted my USB stick
into it, it complained that it cannot read it, and gives 3 buttons to choose.
Correct one was to "Ignore".  My USB had EXT4 partitions, so it could not be
mounted in Mac OS X. I had to open "Disk Utility" GUI app, to find out correct
device name.  Console app (`diskutil list`) did not show it, probably, I don't
know how to use it properly.

Note: `dd` is awfuly slow! I used
[trick](http://daoyuan.li/solution-dd-too-slow-on-mac-os-x/) to complete
operation faster (notice `rdisk1` instead of `disk1`):

    sudo dd if=debian-9.3-amd64-CD-1.iso of=/dev/rdisk1 bs=4m && sync

It was a lot faster, than my first attempt with `disk1` (and produced working
bootable USB stick).  Another hint: `Ctrl+T` in the terminal shows some
progress of the `dd` command.

[This link](https://askubuntu.com/questions/220652/is-dd-command-taking-too-long)
suggests, that for Ubuntu (and Debian, I suppose) `dd` is also slow. Answerer
recommends to use `pv` instead. I've also seen suggestions to use even `cut`,
but haven't tested them yet.

## Links

1. http://silicone.homelinux.org/2013/06/19/building-a-custom-debian-cd/
2. https://computermouth.com/tutorials/custom-debian-distro-simple-cdd/
3. https://www.debian.org/releases/stable/i386/apb.html
4. https://shrimpworks.za.net/2015/03/29/clean-and-lean-debian-install-with-i3/
5. https://virtualboxes.org/doc/installing-guest-additions-on-debian/
6. https://askubuntu.com/questions/372607/how-to-create-a-bootable-ubuntu-usb-flash-drive-from-terminal
7. https://askubuntu.com/a/377561
8. https://askubuntu.com/questions/220652/is-dd-command-taking-too-long
9. http://daoyuan.li/solution-dd-too-slow-on-mac-os-x/

https://askubuntu.com/questions/542327/how-do-i-preseed-partman-recipe-two-disks
https://github.com/xobs/debian-installer/blob/master/doc/devel/partman-auto-recipe.txt

