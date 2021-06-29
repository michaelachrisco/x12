# X12

Current version has been upgraded to run under ruby version >= 1.9.1

Changes welcome, especially new document types or better tests.

# License

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

## Installation

If running Ubuntu, you may need to install libxml2-dev

Add this line to your application's Gemfile:

    gem 'gm_x12'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gm_x12


 
## Documentation
### Wiki Page: https://github.com/GoodmeasuresLLC/x12/wiki

## Major deficiencies

    Validation is not implemented.
    Field types are ignored.
    No access methods for composites’ fields.
    Segments can't repeat by repeating the declaration.

# Acknowledgments

The authors of the project were inspired by the following works:

    * The Perl X12 parser by Prasad Poruporuthan, search.cpan.org/~prasad/X12-0.09/lib/X12/Parser.pm
    * The Ruby port of the above by Chris Parker, rubyforge.org/projects/x12-parser/
    * This project originated from App Design's X12 parser.  
	* Project was forked by Sean Walberg, creating version 1.2.0 in April 2012.
	* Project was forked by Marty Petersen in November 2012, creating gm_x12.
    * Project was forked by GoodMeasures, Jun 2021, trying to make it work for large eligibility files, and work for Ruby 2.7.1. In particular, work for a file of about 300K members from Wellcare.


# Change Log
21/07/10 - release 1.6.2
* tl;dr - Made this gem actually useful.
* 834 Definition file was fixed - it was only processing one transaction, and had
  multiple syntax errors/missing elements. At least, it now works for the client file I have
* client file was ~300000 records. At the rate of processing when I forked the gem, it would have taken about a month to process a monthly file
* performance fix - use string compare before using a regex, as 90% of the segment parses fail as the gem backs its way up.
* because the gem uses tail recursion, it failed after about ~4000 eligibility records. Converted that code to using iteration instead
* because the gem parses everything into memory, it consumes about 12GB before finishing. Added a callback feature for each record, so that you can process each record and then discard the memory.

11/2/15 - release 1.5.3, 1.5.2
* Updated 837p.xml Loop 20102AB to include REF segments
* fixed misspelling

4/16/15 - release 1.5.1
* Added inpsect method to loop class to resolve infinite loop due to changes with inspect and to_s methods in ruby 2.0.0
* Thank you to Wylan for troubleshooting and providing the fix 

11/8/14 - release 1.5.0
* converted from ReXML to LibXML for speed improvement on XML parsing 

9/14/13 - release 1.4.7
* Added 276 / 277 transaction messages 
* Fixed issue with 835.xml file

4/15/13 - release 1.4.5
* Factories now enforce minimum sizes - wbajzek contributed
* 270Interchange.xml updated ST segment's field list - wbajzek contributed
* Test updated for minimum size - wbajzek contributed

3/22/13 - releases 1.4.1 - 1.4.3
* Fix errors in the 835.xml file

3/11/13 - release 1.4.0
* Added X12 definitions for 271 transaction
* Renamed the gem to be all lower case so Rails and other frameworks autoload the project as a gem
* Added an each method to segments to simplify looping through repeating segments

