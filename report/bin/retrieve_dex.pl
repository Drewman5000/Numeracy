#!/usr/bin/perl
use WWW::Curl::Easy;
use WWW::Curl::Form;
use Config::Properties;
use Encode;

# constants:
my $NO_FILE_RESPONSE = "ERR_NO_FILE_AVAILABLE";

# read properties
my $conf_file = '../conf/reporting.conf';
my $props;
read_props();

# REST url for requesting dex
my $host = $props->getProperty('host');
my $path = $props->getProperty('dex_path');
my $url = $host . $path;

# MAP username/pwd
my $username = $props->getProperty('username');
my $password = $props->getProperty('password');

# output dir for errors
my $dex_output_dir = $props->getProperty('dex_output_dir');

my $curl = WWW::Curl::Easy->new;
$curl->setopt(CURLOPT_HEADER,0);
$curl->setopt(CURLOPT_URL, $url);
$curl->setopt(CURLOPT_ENCODING, 'gzip');

# verbose debugging
$curl->setopt(CURLOPT_VERBOSE, 1);

my $headers;
$curl->setopt(CURLOPT_WRITEHEADER, \$headers);

# set basic auth header
$curl->setopt(CURLOPT_USERPWD, $username . ":" . $password);

my $response_body;
$curl->setopt(CURLOPT_WRITEDATA,\$response_body);

# do GET
print "attempting to retrieve data export...\n";
my $retcode = $curl->perform;
my $decoded_content;
my $content_type;

if($retcode == 0){
    my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
    $content_type = $curl->getinfo(CURLINFO_CONTENT_TYPE);
    $decoded_content = decode ('utf-8', $response_body);
    print "HTTP response_code: $response_code\n";
    if($response_code == 200){
        if ($content_type =~ /(csv)|(zip)/) {
            print "retrieved data export file from MAP system.\n";
            save_dex_file();
        }else{
            print "unknown content_type: $content_type\n";
        }
    }else{
        if($decoded_content eq 'ERR_NO_FILE_AVAILABLE'){
            print $props->getProperty('ERR_NO_FILE_AVAILABLE') . "\n";
        }elsif($decoded_content eq 'ERR_DEX_STATUS_IN_PROCESS'){
            print $props->getProperty('ERR_DEX_STATUS_IN_PROCESS') . "\n";
        }elsif($decoded_content eq 'ERR_DEX_STATUS_ERROR'){
            print $props->getProperty('ERR_DEX_STATUS_ERROR') . "\n";
        }elsif($decoded_content eq 'ERR_UNABLE_TO_RETRIEVE'){
            print $props->getProperty('ERR_UNABLE_TO_RETRIEVE') . "\n";
        }
    }
}

print "done.\n\n";



sub save_dex_file(){
    my $dex_fname = get_att_fname();
    mkdir "$dex_output_dir", 0777 unless -d "$dex_output_dir";
    print "saving retrieved file to: $dex_output_dir/$dex_fname\n";
    open (DEX_FILE, ">$dex_output_dir/$dex_fname");
    if($content_type =~ /zip/){
        binmode DEX_FILE;
        print DEX_FILE $response_body;
    }else{
        print DEX_FILE decode('utf-8',$response_body);
    }
    close (DEX_FILE);
}


# extracts attachment filename from Content-Disposition header line
sub get_att_fname(){

    my $fname = "";

    foreach(split(/\n/, $headers)){
        my $ln = $_;
        chomp($ln);
        if( $ln =~ /Content-Disposition/ ){
            if( $ln =~ /"(.*)"/){
                $fname = $1;
                break;
            }
        }
    }
    $fname;
}


sub read_props
{
    open my $fh, '<', $conf_file
    or die "unable to open configuration file";

    $props = Config::Properties->new();
    $props->load($fh);
}
