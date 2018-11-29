use 5.024;
use strictures 2;
use IO::All -binary;
use JSON::MaybeXS qw' encode_json decode_json ';

run();

sub run {
    my $json   = JSON::MaybeXS->new( utf8 => 1, pretty => 1, canonical => 1 );
    my $quotes = "quotes.json";
    my $data   = $json->decode( io("quotes.json")->all );
    io("quotes.json")->print( $json->encode($data) );
}
