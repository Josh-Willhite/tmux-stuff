#!/usr/bin/python
import tmuxp
import sys
from subprocess import check_output

def get_curr_session_name():
    return check_output(['tmux', 'display-message', '-p', '#S']).strip()

def get_hosts():
    hosts = []
    for line in sys.stdin:
        hosts.append(line.strip())
    return hosts

def build_window(window_name, hosts):
    server = tmuxp.Server()
    session = server.findWhere({ "session_name": get_curr_session_name() })
    window = session.new_window(attach=False, window_name=window_name)
    
    for host in hosts:
        if hosts.index(host) == 0:
            pane = window.panes[0]
            pane.send_keys('ssh {}'.format(host))
        else:
            window.select_layout(layout='even-vertical')
            pane = window.split_window()
            pane.send_keys('ssh {}'.format(host))

    window.select_layout(layout='even-vertical')
    window.set_window_option('synchronize-panes', 'on')


build_window(sys.argv[1], get_hosts())