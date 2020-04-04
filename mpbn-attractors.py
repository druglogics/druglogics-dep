import sys
import mpbn

def join_states(dict_obj):
    return ''.join(str(state) for state in dict_obj.values())

def get_attractors(bnet_file):
    net = mpbn.MPBooleanNetwork(bnet_file)
    traps = list(net.attractors())
    print('\n'.join(join_states(trap) for trap in traps))

get_attractors(sys.argv[1])
