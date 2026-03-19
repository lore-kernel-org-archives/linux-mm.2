Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DBF41075274
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C086B0424; Thu, 19 Mar 2026 03:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132806B0426; Thu, 19 Mar 2026 03:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047DA6B0427; Thu, 19 Mar 2026 03:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1CC86B0424
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:55:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D0691A03F0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:55:21 +0000 (UTC)
X-FDA: 84562052442.30.A3ACA2F
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf01.hostedemail.com (Postfix) with ESMTP id ECFFA40007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:55:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773906919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w38anHHa/ld+ew6Zu/lYtHTJKenJ8R55lWX38xLL6OY=;
	b=49Jb3mXWyj6Fk7Iaj2vtPBbjl/qKuoQUgpSVFWGConXPb1LRFPZXKS2uUrm/afj4bQeM7+
	9zmSVAP1SiaELPROAasTx9hNN5pgsciZx3P+vxI4q0Wsx18hmRWnxuPRPrGnS7K1pJlGlJ
	ley+chDKGiy7Kf9ZncfYNT1rc+U6xa8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773906919; a=rsa-sha256;
	cv=none;
	b=pivraQsvDLjwyeMnYd9KbDFq+esp3UMhthRWaLtgqUSXErp4O4xkmTpRHvm2c2gI5iJmeP
	rESOiGgG7xCZjXj5aCGImAf7SmHIhT+C/BingSMwf310wPOY4jL4QGTYLnxhwpg5KSeOC8
	d37Vs6fVyTEEptk3jyzEhnrBqLHcH8o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-3f-69bbabe32199
From: Rakie Kim <rakie.kim@sk.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
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
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Keith Busch <kbusch@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Thu, 19 Mar 2026 16:55:08 +0900
Message-ID: <20260319075512.309-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260318120245.0000448e@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHeXfOzjkOh6dl9qphOKiw0tQ03krLIuhEfUiUoAvUyKMbbSqb
	twmRl+iiNoa2tDNRs8jbSBuKzTLbvGeaKN5GXkpNEjXUEsxieZLAbz9+z/P/Px8eCpM04x6U
	IjaBVcfKlFJChIvmnUt9p6peK/xzKgAqrDYRaHSyl0ANw5Eo39ALUMdIOoGqRkwAzdT9Amh1
	tJ1ETdMzOKp8Mkig9roiEuXaBgGqT5sg0UfuPY76GwoJNGZyCFEnV4GjFZ0nGteFoZbqegHK
	6yshkDFdB5Bd3yZAVSY5MraOkWHujIUbJZkScyKTfaefZG63zAuZp2++CRhz5X2CMS/lkkxH
	wRrOWD4fZh5kLhDM4rQdZwzGW0x17QDOfChpIZlls9d5l0uikChWqUhi1QeOXRPJ787pQfyy
	HqTMct5pICMmC1AUpINg+XJUFnD6h9lfrRivCVoK2xqv8NqVDoSzOe9AFhBRGD0ohHOr9wA/
	2ErLob7MgfGM07tgd+kQybOYPgh7xvXCjU4f+OKlHec7negAuNh6iNcS2hnO1jSBjfUtsPPx
	FM4zRu+EmXVGjL8F6XQK5ldVEBs97tBaPozrgQu3KcNtypQAQSWQKGKTVDKFMshPro1VpPhd
	j1OZwfprn9/8ffkVWOqNsAGaAlJncQfXoJAIZUkarcoGIIVJXcXRlnUljpJpU1l13FV1opLV
	2IAnhUu3iwNXkqMkdIwsgb3BsvGs+v9UQDl5pIGjLW99w71RX1/XGdNal+FnT8PaWbeaPQnW
	oYLCk6Ivbo+Ko4//KW/e1p3rVK/KC4n8XqZ/psrCDMui+Q7HAjjSa0n2OV00YL1YrS/Ucp92
	nxPlpfpnpAXHd/ns0EXYvS4IgxsVtcb9oY4fJ9T7ug1jD8nJtfCyEXvdxMipoNBiKa6RywL2
	YmqN7C+0jxVW1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRyHe3fOzjkuJ0ezOmgoTSoK08yUV4gwjHqxDxUtipRy5dEt54XN
	u0heQk1LlpfUzWJpdnErdWSmZea8bCubomhpqYWpNU0yRVAjc0jgt4fn+fP78qcwhxbciZJE
	xbKyKJFUQPBwXumu4L1jmpeSfZ9nPGF5jZaAw2M9BGz6KITmIhUBS4p7ADQOphNQM6gFcLJ+
	CcDFYQMJ5yamMNgyPonD6nsDBDTU3yVhgX4AwLY7Ji5sSPtCwm7lWxz2NZUTcES7woUm5WMc
	LuQ7w9F8f6gfmOTC9poGDizsVRNQlZ4P4JCikwM1WjFcfv5oVXWMkP4uqFE5TCK1Lg7lZfWR
	6Fr7Ty6qfPWDg3TV1wmk+11AImPpMo4av/qhm5kzBJodH8LRwieEKr//4qBi1VVU86wfR13q
	dvKk/XnewVBWKolnZZ6HQnji7GkFiJlTgESLcnsayAjPBTYUQx9g8iZasVxAUQQtYDqbg63a
	kd7PWG68AbmAR2H0AJeZXswB1rCJFjOKhyuYlXF6B/O+4gNpZT7tzZhHFdy1zd3M07oh3Lpp
	Q3sxsx2+Vu1A2zKW2hawdm7PmMq+4VbGaFcms16FKYCtcl1SrktqwKkGjpKo+EiRROrjIY8Q
	J0VJEj0uR0fqwOpbH6T+ufUCzPcd0wOaAgJbvlHZJHHgiuLlSZF6wFCYwJEf1riq+KGipGRW
	Fn1RFidl5XrgTOGCrfzAs2yIAx0uimUjWDaGlf2vHMrGKQ1UGMLup5wSLjK3p9q1GUVuhwNB
	tuT6JffaCPk2s6Z0JcE1B7rpuqvazBbNFuNpXiAhSnlSF5TVsRwvTDgaoCux8wnYnNBfb26p
	avVTddkaZv6eczrSO5LsOz5LMO8qmsuOF86nqjZeObO00+Lu/drnQrfdCVNAUKfQRT1j3pAl
	wOVikdceTCYX/QOKAHw50gIAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: jsz7r77961dq7djjxtjszwqb7af7g46y
X-Rspam-User: 
X-Rspamd-Queue-Id: ECFFA40007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773906918-938040
X-HE-Meta: U2FsdGVkX1+VpugrMLlYYlKk4JVzbkwVygEThX+FRA6y5rWpoRe2zT6e6ct1vBy32NciIbCnhT5zUgUe7tvHx2VoIVE1+eVLv+zHHhqHv7s2zKRVR5rUhpY9cKIJVFd9eP8/j0+sigtxOpF9SRKmhmdk5gECJFj8j9FeFG3sWcgeffcCw465ET2TGOOgcWt+WS+zzsOozqal56jZyDPUggKpAdfBHQ0ySersBBxRgSW/4F1qBcSLXdCYehoeeHbV151BUtoWgP0LEpvg3/UkDUFdMJ1fV1wqfOiEWQcK/l98Lqq+Gt5HwvCPN95LGhKQ/bdpJL2pqMTIj5vBjDVuCvUnrUXWTFL8zGPaHh7qJVqpuhZioizJJYewE3vJe3AL3iq/8vM/uRJ8EY/bXzVKEg31i3R2TUirvGAasTIieoTj6rMBQi8rRlD/LscznwP5cSFaFClwZ3/nGBqOn//L9GWwP1He1zedDEtojmub86cTFu6Wle6TVxGtanmdZU4Id11oowzJIUlfZqXQpnNmfRBS3Qn/h4pgCufkkmMeVbIAplUTF5VORKpdw5AqbkbVyQvaEzMMwyr59T5fY7D0o3yyxftaAT2SKg3tC5gbc/Z2FsVfaDYwLT23/vj6PoUe0LXSCqFroYhDzGOXEXC4CV4BnjWQjOKxT+D+4JLIoan0S6f5T4mgiQ+g3/tUSN1KFGlgfxUWBbOCLI97o7I9LuiaXrMqGDdI1pabKj/CnBZHSskcTlzIzCv59dy+dZBIyYgIYfpa/dR08wi0ZrdFu8v1JZml2M7K+Z03tx0qsb7jkXvVsQLmBWTtbPzIiH/RKBEs3ZRAd94b4mj3htqM+pO0DuErHafEECnN1AW+GnlwwMKwFe3f2UAlIWXT/r5SJTM18JtTEk/owOsuewES2HNbhRZeoIZ8C5N5u4cpLRH6MuadRuVPJKgXph/quVekMA2T5Hfaj4bijoscj3g
 9m6DB+4B
 v34XRvY0mSFwfssN/rp5qHEcSRmhI1iqDDr4K8MR5qVx7vfU8ENbX3bdhdWC0k7VPE6rBlSAbGqrz/vHlfj1hx3glPhnyKP8d+6wU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 12:02:45 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> On Mon, 16 Mar 2026 14:12:48 +0900
> Rakie Kim <rakie.kim@sk.com> wrote:
> 

Hello Jonathan,

Thanks for your detailed review and the insights on various topology cases.

> > This patch series is an RFC to propose and discuss the overall design
> > and concept of a socket-aware weighted interleave mechanism. As there
> > are areas requiring further refinement, the primary goal at this stage
> > is to gather feedback on the architectural approach rather than focusing
> > on fine-grained implementation details.
> > 
> > Weighted interleave distributes page allocations across multiple nodes
> > based on configured weights. However, the current implementation applies
> > a single global weight vector. In multi-socket systems, this creates a
> > mismatch between configured weights and actual hardware performance, as
> > it cannot account for inter-socket interconnect costs. To address this,
> > we propose a socket-aware approach that restricts candidate nodes to
> > the local socket before applying weights.
> > 
> > Flat weighted interleave applies one global weight vector regardless of
> > where a task runs. On multi-socket systems, this ignores inter-socket
> > interconnect costs, meaning the configured weights do not accurately
> > reflect the actual hardware performance.
> > 
> > Consider a dual-socket system:
> > 
> >           node0             node1
> >         +-------+         +-------+
> >         | CPU 0 |---------| CPU 1 |
> >         +-------+         +-------+
> >         | DRAM0 |         | DRAM1 |
> >         +---+---+         +---+---+
> >             |                 |
> >         +---+---+         +---+---+
> >         | CXL 0 |         | CXL 1 |
> >         +-------+         +-------+
> >           node2             node3
> > 
> > Assuming local DRAM provides 300 GB/s and local CXL provides 100 GB/s,
> > the effective bandwidth varies significantly from the perspective of
> > each CPU due to inter-socket interconnect penalties.
> 
> I'm fully on board with this problem and very pleased to see someone
> working on it!
> 
> I have some questions about the example.
> The condition definitely applies when the local node to
> CXL bandwidth > interconnect bandwidth, but that's not true here so this is
> a more complex and I'm curious about the example
> 
> > 
> > Local device capabilities (GB/s) vs. cross-socket effective bandwidth:
> > 
> >          0     1     2     3
> > CPU 0  300   150   100    50
> > CPU 1  150   300    50   100
> 
> These numbers don't seem consistent with the 100 / 300 numbers above.
> These aren't low load bandwidths because if they were you'd not see any
> drop on the CXL numbers as the bottleneck is still the CXL bus.  Given the
> game here is bandwidth interleaving - fair enough that these should be
> loaded bandwidths.
> 
> If these are fully loaded bandwidth then the headline DRAM / CXL numbers need
> to be the sum of all access paths.  So DRAM must be 450GiB/s and CXL 150GiB/s
> The cross CPU interconnect is 200GiB/s in each direction I think.
> This is ignoring caching etc which can make judging interconnect effects tricky
> at best!
> 
> Years ago there were some attempts to standardize the information available
> on topology under load. To put it lightly it got tricky fast and no one
> could agree on how to measure it for an empirical solution.
> 

You are exactly right about the numbers. The values used in the example
were overly simplified just to briefly illustrate the concept of the
interconnect penalty. I realize that this oversimplification caused
confusion regarding the actual bottleneck and fully loaded bandwidth.
In the next update, I will revise the example to use more accurate
numbers based on the actual system I am currently using.

> > 
> > A reasonable global weight vector reflecting the base capabilities is:
> > 
> >      node0=3 node1=3 node2=1 node3=1
> > 
> > However, because these configured node weights do not account for
> > interconnect degradation between sockets, applying them flatly to all
> > sources yields the following effective map from each CPU's perspective:
> > 
> >          0     1     2     3
> > CPU 0    3     3     1     1
> > CPU 1    3     3     1     1
> > 
> > This does not account for the interconnect penalty (e.g., node0->node1
> > drops 300->150, node0->node3 drops 100->50) and thus forces allocations
> > that cause a mismatch with actual performance.
> > 
> > This patch makes weighted interleave socket-aware. Before weighting is
> > applied, the candidate nodes are restricted to the current socket; only
> > if no eligible local nodes remain does the policy fall back to the
> > wider set.
> > 
> > Even if the configured global weights remain identically set:
> > 
> >      node0=3 node1=3 node2=1 node3=1
> > 
> > The resulting effective map from the perspective of each CPU becomes:
> > 
> >          0     1     2     3
> > CPU 0    3     0     1     0
> > CPU 1    0     3     0     1
> > 
> > Now tasks running on node0 prefer DRAM0(3) and CXL0(1), while tasks on
> > node1 prefer DRAM1(3) and CXL1(1). This aligns allocation with actual
> > effective bandwidth, preserves NUMA locality, and reduces cross-socket
> > traffic.
> 
> Workload wise this is kind of assuming each NUMA node is doing something
> similar and keeping to itself. Assuming a nice balanced setup that is
> fine. However, with certain CPU topologies you are likely to see slightly
> messier things.
> 

I agree with your point. Since the current design is still an early draft,
I understand that this assumption may not hold true for all workloads.
This is an area that requires further consideration.

> > 
> > To make this possible, the system requires a mechanism to understand
> > the physical topology. The existing NUMA distance model provides only
> > relative latency values between nodes and lacks any notion of
> > structural grouping such as socket boundaries. This is especially
> > problematic for CXL memory nodes, which appear without an explicit
> > socket association.
> 
> So in a general sense, the missing info here is effectively the same
> stuff we are missing from the HMAT presentation (it's there in the
> table and it's there to compute in CXL cases) just because we decided
> not to surface anything other than distances to memory from nearest
> initiator.  I chatted to Joshua and Kieth about filling in that stuff
> at last LSFMM. To me that's just a bit of engineering work that needs
> doing now we have proven use cases for the data. Mostly it's figuring out
> the presentation to userspace and kernel data structures as it's a
> lot of data in a big system (typically at least 32 NUMA nodes).
> 

Hearing about the discussion on exposing HMAT data is very welcome news.
Because this detailed topology information is not yet fully exposed to
the kernel and userspace, I used a temporary package-based restriction.
Figuring out how to expose and integrate this data into the kernel data
structures is indeed a crucial engineering task we need to solve.

Actually, when I first started this work, I considered fetching the
topology information from HMAT before adopting the current approach.
However, I encountered a firmware issue on my test systems
(Granite Rapids and Sierra Forest).

Although each socket has its own locally attached CXL device, the HMAT
only registers node1 (Socket 1) as the initiator for both CXL memory
nodes (node2 and node3). As a result, the sysfs HMAT initiators for
both node2 and node3 only expose node1.

Even though the distance map shows node2 is physically closer to
Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
routing path strictly through Socket 1. Because the HMAT alone made it
difficult to determine the exact physical socket connections on these
systems, I ended up using the current CXL driver-based approach.

I wonder if others have experienced similar broken HMAT cases with CXL.
If HMAT information becomes more reliable in the future, we could
build a much more efficient structure.

> > 
> > This patch series introduces a socket-aware topology management layer
> > that groups NUMA nodes according to their physical package. It
> > explicitly links CPU and memory-only nodes (such as CXL) under the
> > same socket using an initiator CPU node. This captures the true
> > hardware hierarchy rather than relying solely on flat distance values.
> > 
> > 
> > [Experimental Results]
> > 
> > System Configuration:
> > - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> > 
> >                node0                       node1
> >              +-------+                   +-------+
> >              | CPU 0 |-------------------| CPU 1 |
> >              +-------+                   +-------+
> > 12 Channels  | DRAM0 |                   | DRAM1 |  12 Channels
> > DDR5-6400    +---+---+                   +---+---+  DDR5-6400
> >                  |                           |
> >              +---+---+                   +---+---+
> > 8 Channels   | CXL 0 |                   | CXL 1 |  8 Channels
> > DDR5-6400    +-------+                   +-------+  DDR5-6400
> >                node2                       node3
> > 
> > 1) Throughput (System Bandwidth)
> >    - DRAM Only: 966 GB/s
> >    - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
> >    - Socket-Aware Weighted Interleave: 1329 GB/s (1.33TB/s)
> >      (38% increase compared to DRAM Only,
> >       47% increase compared to Weighted Interleave)
> > 
> > 2) Loaded Latency (Under High Bandwidth)
> >    - DRAM Only: 544 ns
> >    - Weighted Interleave: 545 ns
> >    - Socket-Aware Weighted Interleave: 436 ns
> >      (20% reduction compared to both)
> > 
> 
> This may prove too simplistic so we need to be a little careful.
> It may be enough for now though so I'm not saying we necessarily
> need to change things (yet)!. Just highlighting things I've seen
> turn up before in such discussions.
> 
> Simplest one is that we have more CXL memory on some nodes than
> others.  Only so many lanes and we probably want some of them for
> other purposes!
> 
> More fun, multi NUMA node per sockets systems.
> 
> A typical CPU Die with memory controllers (e.g. taking one of
> our old parts where there are dieshots online kunpeng 920 to
> avoid any chance of leaking anything...).
> 
>                   Socket 0             Socket 1
>  |    node0      |   node 1|       | node2 | |    node 3     |
>  +-----+ +-------+ +-------+       +-------+ +-------+ +-----+
>  | IO  | | CPU 0 | | CPU 1 |-------| CPU 2 | | CPU 3 | | IO  |
>  | DIE | +-------+ +-------+       +-------+ +-------+ | DIE |
>  +--+--+ | DRAM0 | | DRAM1 |       | DRAM2 | | DRAM2 | +--+--+
>     |    +-------+ +-------+       +-------+ +-------+    |
>     |                                                     |
> +---+---+                                             +---+---+ 
> | CXL 0 |                                             | CXL 1 |
> +-------+                                             +-------+
> 
> So only a single CXL device per socket and the socket is multiple
> NUMA nodes as the DRAM interfaces are on the CPU Dies (unlike some
> others where they are on the IO Die alongside the CXL interfaces).
> 
> CXL topology cases:
> 
> A simple dual socket setup with a CXL switch and MLD below it
> makes for a shared link to the CXL memory (and hence a bandwidth
> restriction) that this can't model.
> 
>                 node0                       node1
>               +-------+                   +-------+
>               | CPU 0 |-------------------| CPU 1 |
>               +-------+                   +-------+
>  12 Channels  | DRAM0 |                   | DRAM1 |  12 Channels
>  DDR5-6400    +---+---+                   +---+---+  DDR5-6400
>                   |                           |
>                   |___________________________| 
>                                 |
>                                 |
>                             +---+---+       
>             Many Channels   | CXL 0 |    
>                DDR5-6400    +-------+   
>                 node2/3     
>  
> Note it's still two nodes for the CXL as we aren't accessing the same DPA for
> each host node but their actual memory is interleaved across the same devices
> to give peak BW.
> 
> The reason you might do this is load balancing across lots of CXL devices
> downstream of the switch.
> 
> Note this also effectively happens with MHDs just the load balancing is across
> backend memory being provided via multiple heads.  Whether people wire MHDs
> that way or tend to have multiple top of rack devices with each CPU
> socket connecting to a different one is an open question to me.
> 
> I have no idea yet on how you'd present the resulting bandwidth interference
> effects of such as setup.
> 
> IO Expanders on the CPU interconnect:
> 
> Just for fun, on similar interconnects we've previously also seen
> the following and I'd be surprised if those going for max bandwidth
> don't do this for CXL at some point soon.
> 
> 
>                 node0                       node1
>               +-------+                   +-------+
>               | CPU 0 |-------------------| CPU 1 |
>               +-------+                   +-------+
>  12 Channels  | DRAM0 |                   | DRAM1 |  12 Channels
>  DDR5-6400    +---+---+                   +---+---+  DDR5-6400
>                   |                           |
>                   |___________________________|
>                       |  IO Expander      |
>                       |  CPU interconnect |
>                       |___________________|
>                                 |
>                             +---+---+       
>             Many Channels   | CXL 0 |    
>                DDR5-6400    +-------+   
>                 node2
> 
> That is the CXL memory is effectively the same distance from
> CPU0 and CPU1 - they probably have their own local CXL as well
> as this approach is done to scale up interconnect lanes in a system
> when bandwidth is way more important than compute. Similar to the
> MHD case but in this case we are accessing the same DPAs via
> both paths.
> 
> Anyhow, the exact details of those don't matter beyond the general
> point that even in 'balanced' high performance configurations there
> may not be a clean 1:1 relationship between NUMA nodes and CXL memory
> devices.  Maybe some maths that aggregates some groups of nodes
> together would be enough. I've not really thought it through yet.
> 
> Fun and useful topic.  Whilst I won't be at LSFMM it is definitely
> something I'd like to see move forward in general.
> 
> Thanks,
> 
> Jonathan
> 

The complex topology cases you presented, such as multi-NUMA per socket,
shared CXL switches, and IO expanders, are very important points.
I clearly understand that the simple package-level grouping does not fully
reflect the 1:1 relationship in these future hardware architectures.

I have also thought about the shared CXL switch scenario you mentioned,
and I know the current design falls short in addressing it properly.
While the current implementation starts with a simple socket-local
restriction, I plan to evolve it into a more flexible node aggregation
model to properly reflect all the diverse topologies you suggested.

Thanks again for your time and review.

Rakie Kim

> > 
> > [Additional Considerations]
> > 
> > Please note that this series includes modifications to the CXL driver
> > to register these nodes. However, the necessity and the approach of
> > these driver-side changes require further discussion and consideration.
> > Additionally, this topology layer was originally designed to support
> > both memory tiering and weighted interleave. Currently, it is only
> > utilized by the weighted interleave policy. As a result, several
> > functions exposed by this layer are not actively used in this RFC.
> > Unused portions will be cleaned up and removed in the final patch
> > submission.
> > 
> > Summary of patches:
> > 
> >   [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
> >   This patch adds a new NUMA helper function to find all nodes in a
> >   given nodemask that share the minimum distance from a specified
> >   source node.
> > 
> >   [PATCH 2/4] mm/memory-tiers: introduce socket-aware topology mgmt
> >   This patch introduces a management layer that groups NUMA nodes by
> >   their physical package (socket). It forms a "memory package" to
> >   abstract real hardware locality for predictable NUMA memory
> >   management.
> > 
> >   [PATCH 3/4] mm/memory-tiers: register CXL nodes to socket packages
> >   This patch implements a registration path to bind CXL memory nodes
> >   to a socket-aware memory package using an initiator CPU node. This
> >   ensures CXL nodes are deterministically grouped with the CPUs they
> >   service.
> > 
> >   [PATCH 4/4] mm/mempolicy: enhance weighted interleave with locality
> >   This patch modifies the weighted interleave policy to restrict
> >   candidate nodes to the current socket before applying weights. It
> >   reduces cross-socket traffic and aligns memory allocation with
> >   actual bandwidth.
> > 
> > Any feedback and discussions are highly appreciated.
> > 
> > Thanks
> > 
> > Rakie Kim (4):
> >   mm/numa: introduce nearest_nodes_nodemask()
> >   mm/memory-tiers: introduce socket-aware topology management for NUMA
> >     nodes
> >   mm/memory-tiers: register CXL nodes to socket-aware packages via
> >     initiator
> >   mm/mempolicy: enhance weighted interleave with socket-aware locality
> > 
> >  drivers/cxl/core/region.c    |  46 +++
> >  drivers/cxl/cxl.h            |   1 +
> >  drivers/dax/kmem.c           |   2 +
> >  include/linux/memory-tiers.h |  93 +++++
> >  include/linux/numa.h         |   8 +
> >  mm/memory-tiers.c            | 766 +++++++++++++++++++++++++++++++++++
> >  mm/mempolicy.c               | 135 +++++-
> >  7 files changed, 1047 insertions(+), 4 deletions(-)
> > 
> > 
> > base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> 

