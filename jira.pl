use Purple;
use Pidgin;
use Data::Dumper;

%PLUGIN_INFO = (
    perl_api_version => 2,
    name => "Jira Plugin",
    version => "0.3",
    summary => "Auto-link to Jira tickets",
    description => "Create links automatically to Jira issues",
    author => "Scott Lipcon <slipcon\@gmail.com>",
    url => "https://github.com/slipcon/jira-pidgin",
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

    Purple::Signal::connect($convs_handle, "receiving-im-msg",
        $plugin,
        \&receiving_msg_cb, $plugin);
    Purple::Signal::connect($convs_handle, "receiving-chat-msg",
        $plugin,
        \&receiving_msg_cb, $plugin);
    Purple::Signal::connect($convs_handle, "writing-im-msg",
        $plugin,
        \&writing_msg_cb, $plugin);
    Purple::Signal::connect($convs_handle, "writing-chat-msg",
        $plugin,
        \&writing_msg_cb, $plugin);
    Purple::Signal::connect($convs_handle, "sending-im-msg",
        $plugin,
        \&sending_im_msg_cb, $plugin);
    Purple::Signal::connect($convs_handle, "sending-chat-msg",
        $plugin,
        \&sending_chat_msg_cb, $plugin);
}

sub plugin_unload {
    my $plugin = shift;
    Purple::Debug::info("jiraplugin", "plugin_unload() - Jira Plugin Unloaded.\n");
}

sub sending_im_msg_cb {
    my ($account, $sender, $msg) = @_;
    $msg = replace_jira($msg);
    if ($msg) {
        $_[2] = $msg
    }
}

sub sending_chat_msg_cb {
    my ($account, $msg) = @_;
    $msg = replace_jira($msg);
    if ($msg) {
        $_[1] = $msg
    }
}

sub writing_msg_cb {
    my ($account, $sender, $msg) = @_;
    $msg = replace_jira($msg);
    if ($msg) {
        $_[2] = $msg
    }
}


sub receiving_msg_cb {
    my ($account, $who, $msg, $conv, $flags, $data) = @_;
    $msg = replace_jira($msg);
    if ($msg) {
        $_[2] = $msg
    }
}

sub replace_jira {
    my $msg = shift;
    my $jiraurl = Purple::Prefs::get_string("/plugins/core/jira/jiraurl");
    return if ($msg =~ /https?:\/\//);
    return if ($jiraurl eq "" );
    $msg =~ s/(\w+)-(\d+)/<a href=\"$jiraurl\/$1-$2\"\>$1-$2\<\/a\>/g;
    return $msg;
}

sub prefs_info_cb {

  my $frame = Purple::PluginPref::Frame->new();
  $frame->add(Purple::PluginPref->new_with_label("Jira Plugin Settings"));

  $frame->add(Purple::PluginPref->new_with_name_and_label(
        "/plugins/core/jira/jiraurl", "URL Base:"));

  return $frame;

}