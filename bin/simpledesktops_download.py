#!/usr/bin/python
__doc__ = """
simpledesktops_download.py

A quick script that fetches desktop images from the http://simpledesktops.com/ site.

It will start at the most current list of images and keep moving backwards, downloading
desktop images in to a directory on your local machine, until it finds an image that
already exists on disk. At that point it will stop.

Image names are prefixed with the yyyy-mm-dd string from the URL so images with
the same names, but published on different dates, don't collide on disk.

This lets you run the script infrequently and have it fill in the missing images on
your disk, stopping when it gets to the point where you last downloaded images from
the site.

- Please be gentle when downloading files.
- Browse around their site to give them support!

Future Work:
------------
- TODO Improve the way the URI for the image is devined from the source, make less fragile
- TODO Switch to using their RSS feed: http://stackoverflow.com/questions/5722963/python-rss-parser-that-also-handles-feedburner
- TODO See the feed at: http://feeds.feedburner.com/simpledesktops

Created by Will Nowack (wan@ccs.neu.edu)
Additional contributions by Ian Chesal (ian.chesal@gmail.com)

Requirements:
-------------
BeautifulSoup: http://www.crummy.com/software/BeautifulSoup/#Download

   pip install beautifulsoup4
   
Usage:
------
$ simpledesktops_download.py
Downloading images from: http://simpledesktops.com/browse
Saving images in:        /Users/ian/Pictures/Desktops/simpledesktops
Downloading http://static.simpledesktops.com/uploads/desktops/2013/05/25/spining2.png --> /Users/ian/Pictures/Desktops/simpledesktops/2013-05-25-spining2.png

Use --help for more information on options.
"""

__author__ = 'Will Nowak <wan@ccs.neu.edu>'
__contributors__ = ('Ian Chesal <ian.chesal@gmail.com>')
__version__ = '1.1.0'

import urllib
import urlparse
import os
import re
from bs4 import BeautifulSoup
import sys
import argparse
from time import sleep


def build_command_line_parser():
    parser = argparse.ArgumentParser(description='Download desktop images from simpledesktops.com')
    parser.add_argument('--url', '-u',
                        dest='baseurl',
                        default='http://simpledesktops.com/browse',
                        help='base URL to search for new images from')
    parser.add_argument('--path', '-p',
                        dest="path",
                        default=os.path.expanduser('~/Pictures/Desktops/simpledesktops'),
                        help="directory where images should be stored")
    parser.add_argument('--offset', '-o',
                        dest='offset',
                        type=int,
                        default=1,
                        help='starting offset value for browsing the picture history')
    parser.add_argument('--timeout', '-t',
                        dest='timeout',
                        type=float,
                        default=5.0,
                        help='time to wait in seconds between downloads')
    return parser


def form_file_name(urlpath):
    '''
    Parse a simpledesktops.com URL and turn it in to a file name that
    takes the form yyyy-mm-dd-filename so we can handle repeating file
    names that seem to occur over time with the site.
    '''
    # The parsed URLs take the form:
    #   /desktops/2011/07/07/Safari_Desktop_Picture.png
    filename = os.path.basename(urlpath)
    matches = re.match('.*/(\d{4})/(\d{2})/(\d{2})/%s$' % filename, urlpath)
    if matches:
        filename = '%s-%s-%s-%s' % (matches.group(1), matches.group(2), matches.group(3), filename)
    else:
        print 'Error: Cannot parse date from %s' % urlpath
    return filename


def main():
    parser = build_command_line_parser()
    options = parser.parse_args()
    
    # If the dowload directory doesn't exist: error
    if not os.path.isdir(options.path):
        print 'Error: Download destination %s does not exist' % options.path
        return 1
    if not options.timeout > 1:
        print 'Error: --timeout value must be > 1 second -- play nice!'
        return 1
    
    print "Downloading images from: %s" % options.baseurl
    print "Saving images in:        %s" % options.path

    for i in range(options.offset, 1000):
        # Browse backwards until we find a file that already exists
        # on disk and then stop browsing. This lets us run this script
        # periodically to "catch up" to the last time we downloaded
        # images from simpledesktops.com...
        stop_parsing = False
        url = '%s/%s/' % (options.baseurl, i)
        b = BeautifulSoup(urllib.urlopen(url).read())
        for x in b.findAll(attrs={'class': 'desktop'}):
            uri = x.find('img')['src']
            # Image links are in the form: http://static.simpledesktops.com/desktops/2011/07/07/Safari_Desktop_Picture.png.295x184_q100.png
            # Need to drop the .295x184_q100.png from the end to get the full size version of the image
            if uri.endswith('.295x184_q100.png'):
                uri = uri.replace('.295x184_q100.png', '')
            else:
                print 'Error: Encountered an img URI I do not understand: %s' % uri
                return 1
            file_name = form_file_name(urlparse.urlparse(uri).path)
            f = os.path.join(options.path, file_name)
            if os.path.isfile(f):
                print 'Found existing image %s -- halting downloads' % f
                stop_parsing = True
                break
            print '[%04d] Downloading %s --> %s' % (i, uri, f)
            urllib.urlretrieve(uri, f)
            sleep(options.timeout)
    
        if stop_parsing:
            break

    print 'All done!'
    return 0


if __name__ == '__main__':
    sys.exit(main())
