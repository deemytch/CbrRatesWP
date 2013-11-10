#!/usr/bin/perl
use utf8;
use LWP::Simple;
use DBI();
my $data = get("http://www.cbr.ru/scripts/XML_daily.asp");

$host = 'localhost';
$db = 'YOUR DB HERE';
$user = 'YOUR USER HERE';
$pass = 'YOUR PASS HERE';
$wpdb = 'wp_currencies';

$dbh = DBI->connect("DBI:mysql:database=$db;host=$host", $user, $pass);
$dbh->do("CREATE TABLE IF NOT EXISTS ${wpdb} (id varchar(10) KEY, charcode varchar(3) UNIQUE, nominal integer unsigned, name varchar(50), value float)");

%codes = (
  'EUR' => 'R01239',
  'USD' => 'R01235',
  'TRY' => 'R01700J',
  'UAH' => 'R01720'
);

for $code(keys(%codes)){
  $data =~ m{Valute\s+ID="$codes{$code}".*?CharCode>(\w{3}).*?Nominal>([0-9]+)</Nominal.*?Name>([^<]+).*?Value>([0-9,.]+)}si;
  print "$1 ($code) $2 $3 $4\n";
  ($id,$charcode,$nominal,$name,$value) = ($codes{$code},$1,$2,$3,$4);
  $value =~ s/,/./;
  $dbh->do("INSERT INTO $wpdb (id,charcode,nominal,name,value) VALUES (\"$id\",\"$charcode\",$nominal,\"$name\",$value)" .
    "ON DUPLICATE KEY UPDATE id = VALUES(id), charcode = VALUES(charcode), nominal = VALUES(nominal), name = VALUES(name), value = VALUES(value)"
    );
}
$dbh->disconnect();
