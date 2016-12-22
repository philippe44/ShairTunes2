package Plugins::ShairTunes2W::Settings;
use base qw(Slim::Web::Settings);

use strict;

use List::Util qw(min max);
use Data::Dumper;

use Slim::Utils::Prefs;
use Slim::Utils::Log;

my $log = logger('plugin.shairtunes');

sub name {
	return 'PLUGIN_SHAIRTUNES2';
}

sub page {
	return 'plugins/ShairTunes2W/settings/basic.html';
}

sub prefs {
	return (preferences('plugin.shairtunes'), qw(squeezelite bufferThreshold loglevel));
}

my $prefs = preferences('plugin.shairtunes');

sub handler {
	my ($class, $client, $params, $callback, @args) = @_;
	
	$params->{logdir} = Plugins::ShairTunes2W::Plugin::logFile("[mac]");
	
	# get all LMS players and filter out squeezelite if needed
	my @players =  map { { mac => $_->id, name => $_->name, model => $_->model, FW => $_->revision } } Slim::Player::Client::clients();
		
	if ($params->{saveSettings}) {
		@players = grep { $_->{model} ne 'squeezelite' || $_->{FW} } @players if !$params->{pref_squeezelite};
		foreach my $player (@players) {
			my $enabled = $params->{'enabled.'.$player->{mac}} // 0;
			$prefs->set($player->{mac}, $enabled);
			$player->{enabled} = $enabled;
		}
		
		$params->{pref_bufferThreshold} = min($params->{pref_bufferThreshold}, 255);
	
	} 
	else {
		@players = grep { $_->{model} ne 'squeezelite' || $_->{FW} } @players if !$prefs->get('squeezelite');
		foreach my $player (@players) {
			$player->{enabled} = $prefs->get($player->{mac}) // 1;
		}	
	}	

	@{$params->{players}} = @players;
	
	$callback->($client, $params, $class->SUPER::handler($client, $params), @args);
}

	
1;
