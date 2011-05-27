use Purple;
use Pidgin;
use Data::Dumper;

%PLUGIN_INFO = (
    perl_api_version => 2,
    name => "Jira Plugin",
    version => "0.2",
    summary => "Auto-link to Jira tickets",
    description => "Create links automatically to Jira issues",
    author => "Scott Lipcon <slipcon\@gmail.com>",
    url => "http://pidgin.im",
    load => "plugin_load",
    unload => "plugin_unload",
    prefs_info => "prefs_info_cb"
);

sub plugin_init {
    return %PLUGIN_INFO;
}

sub plugin_load {
    my $plugin = shift;
    Purple::Debug::info("jiraplugin", "plugin_load() - Jira Plugin Loaded.\n");

    Purple::Prefs::add_none("/plugins/core/jira");
    Purple::Prefs::add_string("/plugins/core/jira/jiraurl", "");

    my $convs_handle = Purple::Conversations::get_handle();

    # Connect the perl sub 'receiving_im_msg_cb' to the event
    # 'receiving-im-msg'
    Purple::Signal::connect($convs_handle, "receiving-im-msg",
        $plugin,
        \&receiving_im_msg_cb, 0);
}

sub plugin_unload {
    my $plugin = shift;
    Purple::Debug::info("jiraplugin", "plugin_unload() - Jira Plugin Unloaded.\n");
}

sub receiving_im_msg_cb {
    my ($account, $who, $msg, $conv, $flags, $data) = @_;
    my $accountname = $account->get_username();
    my $jiraurl = Purple::Prefs::get_string("/plugins/core/jira/jiraurl");

    Purple::Debug::info("jiraplugin", "Message is \'$msg\'\n");

    return if ($msg =~ /https?:\/\//);
    return if ($jiraurl eq "" );

    $msg =~ s/([[:alpha:]]\w+)-(\d+)\b/<a href=\"$jiraurl\/$1-$2\"\>$1-$2\<\/a\>/g;
    $_[2] = $msg;
}


sub prefs_info_cb {

  my $frame = Purple::PluginPref::Frame->new();
  $frame->add(Purple::PluginPref->new_with_label("Jira Plugin Settings"));

  $frame->add(Purple::PluginPref->new_with_name_and_label(
        "/plugins/core/jira/jiraurl", "URL Base:"));

  return $frame;

}
