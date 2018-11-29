use 5.024;
use strictures 2;
use IO::All -binary;
use JSON::MaybeXS qw' encode_json decode_json ';
use XML::LibXML;

run();

sub run {
    my $xml = XML::LibXML->new->parse_string( io("mst_shiptext.xml")->all );

    my %map;
    for my $i ( $xml->getElementsByTagName("mst_shiptext") ) {
        my %child = map +( $_, $i->getChildrenByTagName($_)->string_value ), qw( Id Getmes Sinfo );
        $map{ $child{Id} } = \%child;
    }

    my $json   = JSON::MaybeXS->new( utf8 => 1, pretty => 1, canonical => 1 );
    my $quotes = "quotes.json";
    my $data   = $json->decode( io("quotes.json")->all );

    for my $key ( keys %map ) {
        my $new_child = $map{$key};
        next if !$new_child->{Getmes} and !$new_child->{Sinfo};
        my $entry = $data->{$key};
        die $key if !$entry;
        if ( $new_child->{Getmes} ) {
            if ( $entry->{1} ) {
                $entry->{1} = $new_child->{Getmes};
            }
            else {
                #warn "$key has no entry 1";
            }
        }
        if ( $new_child->{Sinfo} ) {
            if ( $entry->{25} ) {
                $entry->{25} = $new_child->{Sinfo};
            }
            else {
                #warn "$key has no entry 25";
            }
        }
    }

    io("quotes.json")->print( $json->encode($data) );
}
