# Synapse ordering

Synapses are located on axons and <x, y> locations are recorded in table. The order of observation may not match order of synapse along axon. This script presents a general method of determining the order of synapses along axon, indexed by table row. It assumes that order is dependent on Euclidean distance, so acute angles or tortuosity may cause the algorithm to find incorrect, but not terrible solutions.  

A worthwhile improvement would be to code data points as "synapse" or "axon body", so that the intervening "axon body" points could be used to trace the axon body. The code would run the same way, but the extra column would be used to identify nodes which are synapses.  
