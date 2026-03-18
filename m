Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D82103E168
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2AA36B0194; Wed, 18 Mar 2026 08:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02D26B0196; Wed, 18 Mar 2026 08:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF21B6B0197; Wed, 18 Mar 2026 08:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B908A6B0194
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:02:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B5695A0A1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:02:55 +0000 (UTC)
X-FDA: 84559047510.04.4F287B8
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 13A1D40005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:02:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773835373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x5w4gEa5NCiJkfv+o5VBadggp49QnW6p+xeBjufdY5o=;
	b=yxEwk72Y+/Sv6rodNxZMxDq2Ud93g6PVEkpEFrRCnoCkkm5Bo919q+yQ75YCDoBWL8z5Wp
	Ch9CAT/Rxe5HU1sUF7BxTtyaDg9f5ZUsWwi8PTn9N7MUz0aBI4JZSsmP95OQyTt7Fbavna
	GszFJqPBX+Im6uW6qmzJE7am2OV+rls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773835373; a=rsa-sha256;
	cv=none;
	b=Vr5P9xJvRlQZT8XnYn8k9l5ziRkHSQo4khqDVBk3H1hb4y0et3FFwXbhCeAde/V90pGkOV
	EAcLaS38Dn//I7RtQwm/mmy18PxovcthdncZcED3bA+7jjmFcDgtFE8eGI18gyg9+G7A0W
	WUpJZIGaoIkcKrk0V+o90p2UEjUUrwY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fbS9W0TmdzJ4673;
	Wed, 18 Mar 2026 20:01:51 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id A83784058B;
	Wed, 18 Mar 2026 20:02:48 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 18 Mar
 2026 12:02:47 +0000
Date: Wed, 18 Mar 2026 12:02:45 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Rakie Kim <rakie.kim@sk.com>
CC: <akpm@linux-foundation.org>, <gourry@gourry.net>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<ziy@nvidia.com>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<byungchul@sk.com>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<david@kernel.org>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <kernel_team@skhynix.com>, <honggyu.kim@sk.com>,
	<yunjeong.mun@sk.com>, Keith Busch <kbusch@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
Message-ID: <20260318120245.0000448e@huawei.com>
In-Reply-To: <20260316051258.246-1-rakie.kim@sk.com>
References: <20260316051258.246-1-rakie.kim@sk.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13A1D40005
X-Stat-Signature: miozkee5xp8hmaxfkuk56kgtbpqpfwff
X-Rspam-User: 
X-HE-Tag: 1773835372-641433
X-HE-Meta: U2FsdGVkX18NkBntsKgd5sWMrNZaIZnvCVUML5UT5c/nJDRaqFU9yUdtweGFnyajnaxpn8Ywwn23Vi4KvH7lNTSQ1liUW6DoX8lHlzf1x7oeXy/uF2MWkuPWlHxjz0Qe1UnQyBxPbkg10xG4bzIMoXvQ9i/UR0KVSweoo8t+RWEhi3SrPsfPYveyFYz7JHCsS5Q26rvxahPgZUgjodSHAK6b2OzsnLiR0ArC7nrKXiqKp0gDbwucEZQyXXU4Nrc+ClV7PG/c0oic6KB8DNErGdKxNTUn8CZcYp4T/FPnk6QzpmfGSkV6IxtCd2+56YcVuPVseYTmRFTpEz3P61A4zJgl5Jmxzie1WO6L4OJIYBmcb6R8DIargGTu28s/4Ajgyg2fWlB0fpL/IQ80dwn5/hPFHPM5QeHlQhpZI7XNIWlpX3kub+PKir47Iw+wZ0Zlucwp0Nb3LC7uw9Ermv+s25s58rQ1oHSjhfphYMVYy1xTNpL5HC6V2PjqcCT1tEzNkzKgMzlySbu9RIG0XbZCqszQTfhyWXFkIoseIgIz3inU30fa7w1uJKNGUl2eqHFDTSS1DPQe81kqN9HERwGZWh0XFr+1g63PGNsxCgEc0uaslNYs0HuTT/GgHi15DVR3uxkOoJnPbtgebeNcjyA+4iIqRfEjeaNVShoF2DWRRXGv1TunYn3K0r8QFH/VQluVu12kYpej+WJWW4MpiJNOG0jgfHNnDd5heoWn5ezlLKO5OLp/E13nxyouh4L9dU81IdEo4rw9UmImqhSpMSuirjM7HQLhTLqd4wok81gRYdh+WsEgmVe3idfCOj4gba7Gbp05mvoka3EBOYlpnB8zDJPX+ndm+d6+hkt/cPbqcXYnq7MRI6ZlalVtcAlfU3cWDdUYqSUWfSieK1ARQaeCJIA/rpkdozyZeGrZnqd0uYTxt3Li375dLunHHsCCkYnrnYl5DpBCjBUQ3R93+js
 ExxTZX2j
 9pNKQ3LYEOIE9VW8/c/CwnLihK+JLE3Rsf7BxUJBhpG/UvJjmIHcsjEoDC5TL/KLvAKo0nK0ONVeMUIc2Ae7edfjgL1lmkzP6vuMlqPvUx87BHbbzLAZLsyqo+2ObEngj2lwy5LkRLkv2YWx1FlUxfM9qeW61uCO5qdOX19UhUk81/P2HTrWcIHMhGaP2u9y1zGQoO1g3p89NgEZFQ46qN/YV4Ihk4AN/AwL9PlifM0qCAmDJ+MxrQIu569P4woiO10r34UK3ecVGrHeV0Q+RFgKKbZ9ErfbH8NHsFxiQV62QR4kCHsj+PeGuiu/del5taS/CTB1vkW0+547VoC93DPS3uppoHMb67gxH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 14:12:48 +0900
Rakie Kim <rakie.kim@sk.com> wrote:

> This patch series is an RFC to propose and discuss the overall design
> and concept of a socket-aware weighted interleave mechanism. As there
> are areas requiring further refinement, the primary goal at this stage
> is to gather feedback on the architectural approach rather than focusing
> on fine-grained implementation details.
> 
> Weighted interleave distributes page allocations across multiple nodes
> based on configured weights. However, the current implementation applies
> a single global weight vector. In multi-socket systems, this creates a
> mismatch between configured weights and actual hardware performance, as
> it cannot account for inter-socket interconnect costs. To address this,
> we propose a socket-aware approach that restricts candidate nodes to
> the local socket before applying weights.
> 
> Flat weighted interleave applies one global weight vector regardless of
> where a task runs. On multi-socket systems, this ignores inter-socket
> interconnect costs, meaning the configured weights do not accurately
> reflect the actual hardware performance.
> 
> Consider a dual-socket system:
> 
>           node0             node1
>         +-------+         +-------+
>         | CPU 0 |---------| CPU 1 |
>         +-------+         +-------+
>         | DRAM0 |         | DRAM1 |
>         +---+---+         +---+---+
>             |                 |
>         +---+---+         +---+---+
>         | CXL 0 |         | CXL 1 |
>         +-------+         +-------+
>           node2             node3
> 
> Assuming local DRAM provides 300 GB/s and local CXL provides 100 GB/s,
> the effective bandwidth varies significantly from the perspective of
> each CPU due to inter-socket interconnect penalties.

I'm fully on board with this problem and very pleased to see someone
working on it!

I have some questions about the example.
The condition definitely applies when the local node to
CXL bandwidth > interconnect bandwidth, but that's not true here so this is
a more complex and I'm curious about the example

> 
> Local device capabilities (GB/s) vs. cross-socket effective bandwidth:
> 
>          0     1     2     3
> CPU 0  300   150   100    50
> CPU 1  150   300    50   100

These numbers don't seem consistent with the 100 / 300 numbers above.
These aren't low load bandwidths because if they were you'd not see any
drop on the CXL numbers as the bottleneck is still the CXL bus.  Given the
game here is bandwidth interleaving - fair enough that these should be
loaded bandwidths.

If these are fully loaded bandwidth then the headline DRAM / CXL numbers need
to be the sum of all access paths.  So DRAM must be 450GiB/s and CXL 150GiB/s
The cross CPU interconnect is 200GiB/s in each direction I think.
This is ignoring caching etc which can make judging interconnect effects tricky
at best!

Years ago there were some attempts to standardize the information available
on topology under load. To put it lightly it got tricky fast and no one
could agree on how to measure it for an empirical solution.

> 
> A reasonable global weight vector reflecting the base capabilities is:
> 
>      node0=3 node1=3 node2=1 node3=1
> 
> However, because these configured node weights do not account for
> interconnect degradation between sockets, applying them flatly to all
> sources yields the following effective map from each CPU's perspective:
> 
>          0     1     2     3
> CPU 0    3     3     1     1
> CPU 1    3     3     1     1
> 
> This does not account for the interconnect penalty (e.g., node0->node1
> drops 300->150, node0->node3 drops 100->50) and thus forces allocations
> that cause a mismatch with actual performance.
> 
> This patch makes weighted interleave socket-aware. Before weighting is
> applied, the candidate nodes are restricted to the current socket; only
> if no eligible local nodes remain does the policy fall back to the
> wider set.
> 
> Even if the configured global weights remain identically set:
> 
>      node0=3 node1=3 node2=1 node3=1
> 
> The resulting effective map from the perspective of each CPU becomes:
> 
>          0     1     2     3
> CPU 0    3     0     1     0
> CPU 1    0     3     0     1
> 
> Now tasks running on node0 prefer DRAM0(3) and CXL0(1), while tasks on
> node1 prefer DRAM1(3) and CXL1(1). This aligns allocation with actual
> effective bandwidth, preserves NUMA locality, and reduces cross-socket
> traffic.

Workload wise this is kind of assuming each NUMA node is doing something
similar and keeping to itself. Assuming a nice balanced setup that is
fine. However, with certain CPU topologies you are likely to see slightly
messier things.

> 
> To make this possible, the system requires a mechanism to understand
> the physical topology. The existing NUMA distance model provides only
> relative latency values between nodes and lacks any notion of
> structural grouping such as socket boundaries. This is especially
> problematic for CXL memory nodes, which appear without an explicit
> socket association.

So in a general sense, the missing info here is effectively the same
stuff we are missing from the HMAT presentation (it's there in the
table and it's there to compute in CXL cases) just because we decided
not to surface anything other than distances to memory from nearest
initiator.  I chatted to Joshua and Kieth about filling in that stuff
at last LSFMM. To me that's just a bit of engineering work that needs
doing now we have proven use cases for the data. Mostly it's figuring out
the presentation to userspace and kernel data structures as it's a
lot of data in a big system (typically at least 32 NUMA nodes).

> 
> This patch series introduces a socket-aware topology management layer
> that groups NUMA nodes according to their physical package. It
> explicitly links CPU and memory-only nodes (such as CXL) under the
> same socket using an initiator CPU node. This captures the true
> hardware hierarchy rather than relying solely on flat distance values.
> 
> 
> [Experimental Results]
> 
> System Configuration:
> - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> 
>                node0                       node1
>              +-------+                   +-------+
>              | CPU 0 |-------------------| CPU 1 |
>              +-------+                   +-------+
> 12 Channels  | DRAM0 |                   | DRAM1 |  12 Channels
> DDR5-6400    +---+---+                   +---+---+  DDR5-6400
>                  |                           |
>              +---+---+                   +---+---+
> 8 Channels   | CXL 0 |                   | CXL 1 |  8 Channels
> DDR5-6400    +-------+                   +-------+  DDR5-6400
>                node2                       node3
> 
> 1) Throughput (System Bandwidth)
>    - DRAM Only: 966 GB/s
>    - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
>    - Socket-Aware Weighted Interleave: 1329 GB/s (1.33TB/s)
>      (38% increase compared to DRAM Only,
>       47% increase compared to Weighted Interleave)
> 
> 2) Loaded Latency (Under High Bandwidth)
>    - DRAM Only: 544 ns
>    - Weighted Interleave: 545 ns
>    - Socket-Aware Weighted Interleave: 436 ns
>      (20% reduction compared to both)
> 

This may prove too simplistic so we need to be a little careful.
It may be enough for now though so I'm not saying we necessarily
need to change things (yet)!. Just highlighting things I've seen
turn up before in such discussions.

Simplest one is that we have more CXL memory on some nodes than
others.  Only so many lanes and we probably want some of them for
other purposes!

More fun, multi NUMA node per sockets systems.

A typical CPU Die with memory controllers (e.g. taking one of
our old parts where there are dieshots online kunpeng 920 to
avoid any chance of leaking anything...).

                  Socket 0             Socket 1
 |    node0      |   node 1|       | node2 | |    node 3     |
 +-----+ +-------+ +-------+       +-------+ +-------+ +-----+
 | IO  | | CPU 0 | | CPU 1 |-------| CPU 2 | | CPU 3 | | IO  |
 | DIE | +-------+ +-------+       +-------+ +-------+ | DIE |
 +--+--+ | DRAM0 | | DRAM1 |       | DRAM2 | | DRAM2 | +--+--+
    |    +-------+ +-------+       +-------+ +-------+    |
    |                                                     |
+---+---+                                             +---+---+ 
| CXL 0 |                                             | CXL 1 |
+-------+                                             +-------+

So only a single CXL device per socket and the socket is multiple
NUMA nodes as the DRAM interfaces are on the CPU Dies (unlike some
others where they are on the IO Die alongside the CXL interfaces).

CXL topology cases:

A simple dual socket setup with a CXL switch and MLD below it
makes for a shared link to the CXL memory (and hence a bandwidth
restriction) that this can't model.

                node0                       node1
              +-------+                   +-------+
              | CPU 0 |-------------------| CPU 1 |
              +-------+                   +-------+
 12 Channels  | DRAM0 |                   | DRAM1 |  12 Channels
 DDR5-6400    +---+---+                   +---+---+  DDR5-6400
                  |                           |
                  |___________________________| 
                                |
                                |
                            +---+---+       
            Many Channels   | CXL 0 |    
               DDR5-6400    +-------+   
                node2/3     
 
Note it's still two nodes for the CXL as we aren't accessing the same DPA for
each host node but their actual memory is interleaved across the same devices
to give peak BW.

The reason you might do this is load balancing across lots of CXL devices
downstream of the switch.

Note this also effectively happens with MHDs just the load balancing is across
backend memory being provided via multiple heads.  Whether people wire MHDs
that way or tend to have multiple top of rack devices with each CPU
socket connecting to a different one is an open question to me.

I have no idea yet on how you'd present the resulting bandwidth interference
effects of such as setup.

IO Expanders on the CPU interconnect:

Just for fun, on similar interconnects we've previously also seen
the following and I'd be surprised if those going for max bandwidth
don't do this for CXL at some point soon.


                node0                       node1
              +-------+                   +-------+
              | CPU 0 |-------------------| CPU 1 |
              +-------+                   +-------+
 12 Channels  | DRAM0 |                   | DRAM1 |  12 Channels
 DDR5-6400    +---+---+                   +---+---+  DDR5-6400
                  |                           |
                  |___________________________|
                      |  IO Expander      |
                      |  CPU interconnect |
                      |___________________|
                                |
                            +---+---+       
            Many Channels   | CXL 0 |    
               DDR5-6400    +-------+   
                node2

That is the CXL memory is effectively the same distance from
CPU0 and CPU1 - they probably have their own local CXL as well
as this approach is done to scale up interconnect lanes in a system
when bandwidth is way more important than compute. Similar to the
MHD case but in this case we are accessing the same DPAs via
both paths.

Anyhow, the exact details of those don't matter beyond the general
point that even in 'balanced' high performance configurations there
may not be a clean 1:1 relationship between NUMA nodes and CXL memory
devices.  Maybe some maths that aggregates some groups of nodes
together would be enough. I've not really thought it through yet.

Fun and useful topic.  Whilst I won't be at LSFMM it is definitely
something I'd like to see move forward in general.

Thanks,

Jonathan

> 
> [Additional Considerations]
> 
> Please note that this series includes modifications to the CXL driver
> to register these nodes. However, the necessity and the approach of
> these driver-side changes require further discussion and consideration.
> Additionally, this topology layer was originally designed to support
> both memory tiering and weighted interleave. Currently, it is only
> utilized by the weighted interleave policy. As a result, several
> functions exposed by this layer are not actively used in this RFC.
> Unused portions will be cleaned up and removed in the final patch
> submission.
> 
> Summary of patches:
> 
>   [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
>   This patch adds a new NUMA helper function to find all nodes in a
>   given nodemask that share the minimum distance from a specified
>   source node.
> 
>   [PATCH 2/4] mm/memory-tiers: introduce socket-aware topology mgmt
>   This patch introduces a management layer that groups NUMA nodes by
>   their physical package (socket). It forms a "memory package" to
>   abstract real hardware locality for predictable NUMA memory
>   management.
> 
>   [PATCH 3/4] mm/memory-tiers: register CXL nodes to socket packages
>   This patch implements a registration path to bind CXL memory nodes
>   to a socket-aware memory package using an initiator CPU node. This
>   ensures CXL nodes are deterministically grouped with the CPUs they
>   service.
> 
>   [PATCH 4/4] mm/mempolicy: enhance weighted interleave with locality
>   This patch modifies the weighted interleave policy to restrict
>   candidate nodes to the current socket before applying weights. It
>   reduces cross-socket traffic and aligns memory allocation with
>   actual bandwidth.
> 
> Any feedback and discussions are highly appreciated.
> 
> Thanks
> 
> Rakie Kim (4):
>   mm/numa: introduce nearest_nodes_nodemask()
>   mm/memory-tiers: introduce socket-aware topology management for NUMA
>     nodes
>   mm/memory-tiers: register CXL nodes to socket-aware packages via
>     initiator
>   mm/mempolicy: enhance weighted interleave with socket-aware locality
> 
>  drivers/cxl/core/region.c    |  46 +++
>  drivers/cxl/cxl.h            |   1 +
>  drivers/dax/kmem.c           |   2 +
>  include/linux/memory-tiers.h |  93 +++++
>  include/linux/numa.h         |   8 +
>  mm/memory-tiers.c            | 766 +++++++++++++++++++++++++++++++++++
>  mm/mempolicy.c               | 135 +++++-
>  7 files changed, 1047 insertions(+), 4 deletions(-)
> 
> 
> base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b


