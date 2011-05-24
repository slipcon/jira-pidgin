use Purple;
use Data::Dumper;

my $jiraurl = "http://jira.myhost.com/browse";

%PLUGIN_INFO = (
    perl_api_version => 2,
    name => "Jira Plugin",
    version => "0.1",
    summary => "Auto-link to Jira tickets",
    description => "Create links automatically to Jira issues",
    author => "Scott Lipcon <slipcon\@gmail.com",
    url => "http://pidgin.im",
    load => "plugin_load",
    unload => "plugin_unload"
);
sub plugin_init {
    return %PLUGIN_INFO;
}
sub plugin_load {
    my $plugin = shift;
    Purple::Debug::info("jiraplugin", "plugin_load() - Jira Plugin Loaded.\n");

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

    Purple::Debug::info("jiraplugin", "Message is \'$msg\'\n");

    return if ($msg =~ /https?:\/\//);

    $msg =~ s/([[:alpha:]]\w+)-(\d+)\b/<a href=\"$jiraurl\/$1-$2\"\>$1-$2\<\/a\>/g;
    $_[2] = $msg;
}


