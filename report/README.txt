======================================================
NWEA Web-based MAP Automated Report Services

------------------------------------------------------

 The Web-based MAP system provides a scripting interface for automated 
retrieval of data export (DEX) files containing student test result data.


______________________
Release Notes
======================

 Please read the RELEASE_NOTES.txt for a complete list of new features
available in this release.


______________________
Documentation
======================

 Your script can retrieve a file generated from the Data Export Scheduler tool 
in the MAP system and copy it to a URL or file location of your choice. 
The retrievable file types are:
     - Comprehensive Data File
     - Combined Data File
     - CompassLearning(R) XML File

 You continue to schedule data exports in the MAP user interface as usual, 
with a maximum frequency of one file export per day. A script lets you bypass 
the MAP user interface to retrieve the file. You can also manually download the 
same file through the user interface.

See the MAP online help for information about scheduling and retrieving data
export files through the user interface.


______________________
Configuration
======================

 User credentials and path to retrieved data files are configured in:
       services_kit/report/conf/reporting.conf


______________________
Dependencies
======================

 For the Perl scripts, the following packages are not included with the standard Perl
installation and must be installed on your system:

    - WWW::Curl::Easy
    - WWW::Curl::Form
    - Config::Properties

See http://www.cpan.org/modules/INSTALL.html for instructions on installing Perl modules


______________________
Example Script
======================

retrieve_dex.pl
    - Retrieves a data file from MAP and saves it to the configured path


______________________
Response Codes
======================

400	ERR_NO_FILE_AVAILABLE		No data file available
400	ERR_DEX_STATUS_IN_PROCESS	Retrieval request status is in progress
500	ERR_DEX_STATUS_ERROR		Error generating data file for export
500	ERR_UNABLE_TO_RETRIEVE		Error retrieving data file


______________________
Support
======================

These scripts are provided as-is.  Customization, configuration, and use of these scripts is completely optional and at
each district�s discretion.  Scripting support, including but not limited to alterations to scripts, use or
configuration of third-party software, or changes to the data extraction services listed in the scripts, is not provided by NWEA.
