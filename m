Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF2AD58B22
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 05:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D65E6B0118; Mon, 16 Mar 2026 01:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884E06B0119; Mon, 16 Mar 2026 01:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758CD6B011A; Mon, 16 Mar 2026 01:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 603916B0118
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:13:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E11BB8D26D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:13 +0000 (UTC)
X-FDA: 84550757466.18.A145F68
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5FCE580005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773637992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=3VeM6JuwxeUu9CjFtBxLLsjcX+IiA1hmi9MCt8F34Co=;
	b=k7ykGz8vwRjaWlwno5ySOVfswCoz6iDkypcs0gViiFkwtH9DiHt+4RyxkoktOBC8qXLznL
	qncekQzKlsO3QPvNT2mwcfxMpgpY8GCPF29y2erqrhk2dpz3vHIL1dTcckdeacPLYehXC3
	D5mWOQNHvCtOuoTZxeouqDgIS7NGHPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773637992; a=rsa-sha256;
	cv=none;
	b=XCRZQlAuK9zyI1KgjT/gW05SGoboebAVBaNoxHPE0LJ3jfMaIZdId3eCMMW/ROA3DAhwhb
	neJPfAQ4Z4O4OErA1Da/0CoR0RQUdgIfpPUgZ3UAJiVpvwpnWj0RsN6m8KqVwePW/Byvey
	1ls6eFtV2bl9M/cLlbo9uPtwumc0+LI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-20-69b7915fc5ad
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rakie.kim@sk.com
Subject: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Mon, 16 Mar 2026 14:12:48 +0900
Message-ID: <20260316051258.246-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsXC9ZZnkW78xO2ZBkd3SVvMWb+GzeLu4wts
	FrtuhFhMn3qB0eLEzUY2i9U31zBaPN/6i9Hi593j7Bb7nz5nsVi18BqbxfGt89gttjc8YLc4
	P+sUi8XlXXPYLO6t+c9qcXLWShaLb33SFvf7HCyOrN/OZDH50gI2i9mNfYwWtyYcY7JYvSbD
	YvbRe+wOEh47Z91l91iwqdSju+0yu0fLkbesHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NKj
	t/kdm8fHp7dYPKbOrvdYv+Uqi8eZBUfYPT5vkgvgj+KySUnNySxLLdK3S+DK2HPpOnvBDeuK
	y7cuMTUw/tHuYuTkkBAwkZi8s4cdxn4wawVTFyMHB5uAksSxvTEgYREBWYmpf8+zdDFycTAL
	rGSVOH/yNzNIjbBAisSyiWBjWARUJRasecEIEuYVMJZ4+zYCYqKmxLqNt1hAbF4BQYmTM5+w
	gJQwC6hLrJ8nBBJmFpCXaN46mxlkuoTAW3aJb903mSF6JSUOrrjBMoGRbxaS9lkI7bOQtC9g
	ZF7FKJSZV5abmJljopdRmZdZoZecn7uJERiny2r/RO9g/HQh+BCjAAejEg9vxqFtmUKsiWXF
	lbmHGCU4mJVEeJcdAQrxpiRWVqUW5ccXleakFh9ilOZgURLnNfpWniIkkJ5YkpqdmlqQWgST
	ZeLglGpgVOS6ElMwpz677UeuR03nk8lnqnpX9GrKHFzi8MWbU18lwLteoO69fNGH7czJfpPP
	6ZgGTmw+J9cVZ3djs7TFx7cbRbvPePw0UDsjvm3VNOmwE6oNTx40F39jnutzku3Xqa4Y6du5
	9+7n3/De+M96xTMvi3mXmE7n6d85+0NXlqvte/8y96OblFiKMxINtZiLihMB60C6/s8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsXCNUM9Rjd+4vZMg5aXvBZz1q9hs7j7+AKb
	xa4bIRbnpsxms5g+9QKjxYmbjWwWq2+uYbR4vvUXo8XPu8fZLT4/e81ssf/pcxaLVQuvsVkc
	3zqP3eLw3JOsFtsbHrBbnJ91isXi8q45bBb31vxntTg5ayWLxbc+aYv7fQ4Wh649Z7U4sn47
	k8XkSwvYLGY39jFa3JpwjMli9ZoMi9/bVgCFjt5jd5D12DnrLrvHgk2lHt1tl9k9Wo68ZfVY
	vOclk8emVZ1sHps+TWL3ODHjN4vHzoeWHr3N79g8Pj69xeLx7baHx+IXH5g8ps6u91i/5SqL
	x5kFR9gDBKO4bFJSczLLUov07RK4MvZcus5ecMO64vKtS0wNjH+0uxg5OSQETCQezFrB1MXI
	wcEmoCRxbG8MSFhEQFZi6t/zLF2MXBzMAitZJc6f/M0MUiMskCKxbCJYK4uAqsSCNS8YQcK8
	AsYSb99GQEzUlFi38RYLiM0rIChxcuYTFpASZgF1ifXzhEDCzALyEs1bZzNPYOSehaRqFkLV
	LCRVCxiZVzGKZOaV5SZm5pjqFWdnVOZlVugl5+duYgRG57LaPxN3MH657H6IUYCDUYmHN+PQ
	tkwh1sSy4srcQ4wSHMxKIrzLjgCFeFMSK6tSi/Lji0pzUosPMUpzsCiJ83qFpyYICaQnlqRm
	p6YWpBbBZJk4OKUaGKekFyUysEzdcuZwcY9V0pzKI4mnWR/N0UsTvsLrvEnt/8ws8xl9VvYl
	nolHe09f6d91/92MQo5NdvK/xV6HqCew7K3Wu81tUmjDdLpi0sUw7reGDF8uvapvVbl7KszC
	3/TG2207qgXsY6/vb+wTieZM2PA3LlpzhVrEkYOXIr6vlT3x+kvKGSWW4oxEQy3mouJEAHGx
	5tLKAgAA
X-CFilter-Loop: Reflected
X-Stat-Signature: eejgpw1ybsgeq6iw6cazs4tc5tzkodys
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FCE580005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773637989-340534
X-HE-Meta: U2FsdGVkX19UNSIkIkQkqw5XqpgRugt7eIgmhfhZuUWwY3rxcFkecg0mllcA6gCQUr07H4ydIo8b5DePiS3FtdJqt8fb27xbKqqX7leh/wYw7Aev3okqlvoTsvSmvv44BrcfaMASc1+T2uPb3j6AYWSFqMHBP2IEsohoqbd/GvehAfhh1IGm3Za7lRaqgrTiQ9GOHHofrC/Qk4bt7fDoZZcVVrB1Re5Q+gu8CozUrPG5ORlMuvfw/pdMaUo9snM30CvJ+HOizHGu9AzXCPm7PeI2Bqa95V8q9l2u/e+dupMSdyjhP+lRD2ZY+Wjn+kFXEPsgUwv7DH9TMn7AcWJfJqtX9pTJ7JiOiDm3F8dQwvVRh9Fy/VX0axGcnUNgsPRFWDLK6npvwOXO5KBWrQuPfhBRua2IQKf8pSlejDFKPo8idZ39ArzSDo9CXv6W4bOlnG3ZEi6DArFC1XfnHGgRM72ugGfzvMohzwPluPLgt8IB/0Dw2YUHMBKT+yxRspibWIAhMVy8DNQ4hTpdCgg0vLnkTj4G6jUfTLcFChv55CYicXMaXXdVqRToWMXEPd1pZjkXFPDp5y6nDPOh7nwHjlcaVgruL5EayZqEFO7sIs4c1rwk8LAUS6qGTpf36U71k9y2VdspDoIBwh4WUOIfvQYKCjrjqX5Mm0V+1CZhKnowivvmYmhXg02PJ004WMNmNDpfHdqNA91ovGUkQxSxMOFklERiZTZ/Pqwhae/H6fGmcUth5apze1G+CgACyMoLbex9C6TM9UiEheuu7s63mncCzBueqiHh8MP7gLhMsSsxLx8sG+7L2xKUFLRvhs439uKnbjS8EDu0uA/1T8sJCL5knw2nl2VrUCtxGRGe7OJArNBoJfKE1WZEUE8/ElHOhhVTS+7LpdSc2Esd8ee998nqmW0j/M37zMCSRTypSs+NIMs84F4zq7frFOxHSCI3XoF93rlTwK3sv+1+N0A
 gh5GUyce
 LScqHwzCsty4+Qr/y8h9fQV5mRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is an RFC to propose and discuss the overall design
and concept of a socket-aware weighted interleave mechanism. As there
are areas requiring further refinement, the primary goal at this stage
is to gather feedback on the architectural approach rather than focusing
on fine-grained implementation details.

Weighted interleave distributes page allocations across multiple nodes
based on configured weights. However, the current implementation applies
a single global weight vector. In multi-socket systems, this creates a
mismatch between configured weights and actual hardware performance, as
it cannot account for inter-socket interconnect costs. To address this,
we propose a socket-aware approach that restricts candidate nodes to
the local socket before applying weights.

Flat weighted interleave applies one global weight vector regardless of
where a task runs. On multi-socket systems, this ignores inter-socket
interconnect costs, meaning the configured weights do not accurately
reflect the actual hardware performance.

Consider a dual-socket system:

          node0             node1
        +-------+         +-------+
        | CPU 0 |---------| CPU 1 |
        +-------+         +-------+
        | DRAM0 |         | DRAM1 |
        +---+---+         +---+---+
            |                 |
        +---+---+         +---+---+
        | CXL 0 |         | CXL 1 |
        +-------+         +-------+
          node2             node3

Assuming local DRAM provides 300 GB/s and local CXL provides 100 GB/s,
the effective bandwidth varies significantly from the perspective of
each CPU due to inter-socket interconnect penalties.

Local device capabilities (GB/s) vs. cross-socket effective bandwidth:

         0     1     2     3
CPU 0  300   150   100    50
CPU 1  150   300    50   100

A reasonable global weight vector reflecting the base capabilities is:

     node0=3 node1=3 node2=1 node3=1

However, because these configured node weights do not account for
interconnect degradation between sockets, applying them flatly to all
sources yields the following effective map from each CPU's perspective:

         0     1     2     3
CPU 0    3     3     1     1
CPU 1    3     3     1     1

This does not account for the interconnect penalty (e.g., node0->node1
drops 300->150, node0->node3 drops 100->50) and thus forces allocations
that cause a mismatch with actual performance.

This patch makes weighted interleave socket-aware. Before weighting is
applied, the candidate nodes are restricted to the current socket; only
if no eligible local nodes remain does the policy fall back to the
wider set.

Even if the configured global weights remain identically set:

     node0=3 node1=3 node2=1 node3=1

The resulting effective map from the perspective of each CPU becomes:

         0     1     2     3
CPU 0    3     0     1     0
CPU 1    0     3     0     1

Now tasks running on node0 prefer DRAM0(3) and CXL0(1), while tasks on
node1 prefer DRAM1(3) and CXL1(1). This aligns allocation with actual
effective bandwidth, preserves NUMA locality, and reduces cross-socket
traffic.

To make this possible, the system requires a mechanism to understand
the physical topology. The existing NUMA distance model provides only
relative latency values between nodes and lacks any notion of
structural grouping such as socket boundaries. This is especially
problematic for CXL memory nodes, which appear without an explicit
socket association.

This patch series introduces a socket-aware topology management layer
that groups NUMA nodes according to their physical package. It
explicitly links CPU and memory-only nodes (such as CXL) under the
same socket using an initiator CPU node. This captures the true
hardware hierarchy rather than relying solely on flat distance values.


[Experimental Results]

System Configuration:
- Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)

               node0                       node1
             +-------+                   +-------+
             | CPU 0 |-------------------| CPU 1 |
             +-------+                   +-------+
12 Channels  | DRAM0 |                   | DRAM1 |  12 Channels
DDR5-6400    +---+---+                   +---+---+  DDR5-6400
                 |                           |
             +---+---+                   +---+---+
8 Channels   | CXL 0 |                   | CXL 1 |  8 Channels
DDR5-6400    +-------+                   +-------+  DDR5-6400
               node2                       node3

1) Throughput (System Bandwidth)
   - DRAM Only: 966 GB/s
   - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
   - Socket-Aware Weighted Interleave: 1329 GB/s (1.33TB/s)
     (38% increase compared to DRAM Only,
      47% increase compared to Weighted Interleave)

2) Loaded Latency (Under High Bandwidth)
   - DRAM Only: 544 ns
   - Weighted Interleave: 545 ns
   - Socket-Aware Weighted Interleave: 436 ns
     (20% reduction compared to both)


[Additional Considerations]

Please note that this series includes modifications to the CXL driver
to register these nodes. However, the necessity and the approach of
these driver-side changes require further discussion and consideration.
Additionally, this topology layer was originally designed to support
both memory tiering and weighted interleave. Currently, it is only
utilized by the weighted interleave policy. As a result, several
functions exposed by this layer are not actively used in this RFC.
Unused portions will be cleaned up and removed in the final patch
submission.

Summary of patches:

  [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
  This patch adds a new NUMA helper function to find all nodes in a
  given nodemask that share the minimum distance from a specified
  source node.

  [PATCH 2/4] mm/memory-tiers: introduce socket-aware topology mgmt
  This patch introduces a management layer that groups NUMA nodes by
  their physical package (socket). It forms a "memory package" to
  abstract real hardware locality for predictable NUMA memory
  management.

  [PATCH 3/4] mm/memory-tiers: register CXL nodes to socket packages
  This patch implements a registration path to bind CXL memory nodes
  to a socket-aware memory package using an initiator CPU node. This
  ensures CXL nodes are deterministically grouped with the CPUs they
  service.

  [PATCH 4/4] mm/mempolicy: enhance weighted interleave with locality
  This patch modifies the weighted interleave policy to restrict
  candidate nodes to the current socket before applying weights. It
  reduces cross-socket traffic and aligns memory allocation with
  actual bandwidth.

Any feedback and discussions are highly appreciated.

Thanks

Rakie Kim (4):
  mm/numa: introduce nearest_nodes_nodemask()
  mm/memory-tiers: introduce socket-aware topology management for NUMA
    nodes
  mm/memory-tiers: register CXL nodes to socket-aware packages via
    initiator
  mm/mempolicy: enhance weighted interleave with socket-aware locality

 drivers/cxl/core/region.c    |  46 +++
 drivers/cxl/cxl.h            |   1 +
 drivers/dax/kmem.c           |   2 +
 include/linux/memory-tiers.h |  93 +++++
 include/linux/numa.h         |   8 +
 mm/memory-tiers.c            | 766 +++++++++++++++++++++++++++++++++++
 mm/mempolicy.c               | 135 +++++-
 7 files changed, 1047 insertions(+), 4 deletions(-)


base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
-- 
2.34.1


