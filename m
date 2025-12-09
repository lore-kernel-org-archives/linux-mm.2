Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98702D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 12:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C766D6B0005; Tue,  9 Dec 2025 07:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00006B0007; Tue,  9 Dec 2025 07:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7C86B0008; Tue,  9 Dec 2025 07:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 948266B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 07:43:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40F21C0583
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:43:11 +0000 (UTC)
X-FDA: 84199897782.27.12EECEC
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03F162000A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:43:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=clYTpwfZ;
	spf=pass (imf13.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765284189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xo7OeA33tWRYz8zbfLCc2jeO2ZGq0wF+pXykwItiK5M=;
	b=HKmuaiSY3qmBaaOCFfXnGl+pLvRnVRW6GgCTp1dB6CDRni569kZTGNr8FFaOKjV9mto96B
	naYoZBvzxmPE+x6KaYGP7MgTho4AZtuKSry02vW9TrFZCAR8MGeeJnIbBhTD3l9tr+nFfC
	MMV0Th09JZmli1LnMWQt25icBO1j61I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=clYTpwfZ;
	spf=pass (imf13.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765284189; a=rsa-sha256;
	cv=none;
	b=LmPAlsVaghBYADqcNyetIMIFYwcCORSG38ZwIsw7RamVDOkZzh6NqYSJoRtc51xsZoMY2G
	zY5v/Q7/YV6HZlVfJXnwEOK8YghdXZUmfYg98TNcGYqgUdlEhFIfOwXnJHK7kkL404LAQ6
	vc48rzEL0pgZMaLWBUk2Xmc97yMnOSo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Xo7OeA33tWRYz8zbfLCc2jeO2ZGq0wF+pXykwItiK5M=;
	b=clYTpwfZL7BLpYpG966W4Z3meJO2GuveIHY1V8afaFkQv6+c8D1xzKjNlDxLLDp6aZzDp8Rld
	bTEB2btV77TGaLxBe5hSORFlJy9L5TE4c2MIMURTFsOZQxxpMzh8bWLXtNPO1npeuCKBdvXhmgU
	lIWpGZjOroINa0EC1GIn78g=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dQdjr166lzpStQ;
	Tue,  9 Dec 2025 20:40:32 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EC90180BD5;
	Tue,  9 Dec 2025 20:43:02 +0800 (CST)
Received: from [10.174.178.114] (10.174.178.114) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Dec 2025 20:43:01 +0800
Message-ID: <fc00c53c-ab54-42a2-979b-0ecb49ff6b48@huawei.com>
Date: Tue, 9 Dec 2025 20:43:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-trace-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kernel-team@meta.com>
Subject: Re: [RFC LPC2025 PATCH 0/4] Deprecate zone_reclaim_mode
To: <joshua.hahnjy@gmail.com>, <willy@infradead.org>, <david@kernel.org>
References: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.114]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Stat-Signature: jz3dqc3etp71db4mfpyzepi4necd593u
X-Rspamd-Queue-Id: 03F162000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765284187-898296
X-HE-Meta: U2FsdGVkX1/KQDfYakDzjRHZ9H3lbcsgfK+52kXk13Hk+D/9JWKi4anj3+49I/8Qhu5B8kU1pfM/WCu1fW3yRbSQz8BHTo/20Ns/rsGW1Zz7S+7pqaGzUSF2lhqPMUKqcigSh69qL1b6baRyIP3RPlj6x1ODRabpNmY3Y5TTsGo1FTJCXt12ds4VlmgMXY+OShUTRsomQGQU432b5BtjfbiYAl03rVoGanWlJrXvkezZyWgEbUhnjm/0h/vJ9cEj2W0fYIG4BFLrxlVQc47s/Amkg2smh1HbmnYTSD9fc7Z9Q6mntJVcmyuhRjV8DNpN/KQHEq2kyTAXfloN3P9KZ7fPaCtvgttBpWzGqIb5xvdp08or1cDlFHOJJMNE+n2oZsl0c76NLAsnqEb5WDRvhSg94XDTtDRQKHJeTgVJHF8gZztokBKvSiCCi3IBWyZ0Qpkap3tB+rU5nGESZL5AAmLEXFzbr3UiOGxBegFtv/awUuN9DL8gDhB3SjbJZtGxL0nO8dsVyR1ITlSrSsfNNZ7x0fBWGyWmwxSUx5qOCusCBYwyI2En/nHwilL9AZMFMxqkyJAF9KtqEWBSrbOWpCR/MuVHpN4h8OZ+e5hULfQ2QmNQJh/KbAoC8kBvoFm6hqdHY4m2fZlP2kdKfy3LEiMJ8v89iaSy+bac3xBpr31FgJw8+CBY/teP+NdrUk2aH6zElHilYYlpP+NY6aRhN6rQxE33PxWBniDaHoiZJSzUOaeB8aLj65x0PlYh9MjlPC/M9d6TQRqULV4k+LkBKkYTdRhDAr2LYduYuhc89OV6Ya1Y5foLHuSlpy+iEUfz6KKohsN0iSGORp0z9lzhD+ALH2JEw4kDQMuKJWoCDG0oBDw8STgdZsy/VDIlGjI9xeI7r/DbPpM3N53y00G4RIuimuCgO8hi1oWXIwSim4PPmcMCS4AU7PxN9YESAJI+KzDLaTk5P9SSO5l9pWu
 EMfCLc0v
 xB64zw391oRXYE5QoMEgHF/tu2ZpiBY9y4b91gNG2aoivZIsnZ00OsHKUIsnXTfdoxzwtsrinpXSU02ayrOw8q41mT0nRk69BUxreFolwemLbw/GtBwBNr8sGBsoGjcWWPOJQrWBUxDVqV6srqSvrX167icVN6SJVm7lif/ymrX+x5Bx0JWsQkPiuIoDfhuC78bYlYl8ugPehEOtoOnfF44BLIoLHITn7pq9IHYL2arxzt8WYsJzevxHaDucD6VMOXvaDb1jaJae7lsvNCcEZ3YoAod5ja37E3o3zEwdVf5j4cOXSY+J10hKjLFQz6QweCRVCgd2yzGL/qw72lVFHmWWVwBOqhN2bFOBfflkgQswZxOK+wpCz6M5A3pIQSwmFfPTEsmlmEab5Cg6UJd1127b10K1+p3aWo7xT+qGuUciWKFOWgOKv4sJppeO/tzz9xj0lXdUPPglBrr4YanTHhaBphkv1lTV3tCOgJHFTT45upKytJNaKPtmCh8bZz4r/F9M32XBWXb41yf5D66CJa1Bu+jEeNVi1nnEjTOjbLzHnVDa3NSfLKTIJCD8yXcDUeO1RCodsv3CPguWdzUI0hGFc+IcYTCYCc1f6krtourmjkY4WuJoGLhMf+KTNRpd3gZZE61KBMsD/a62kmuQQqLXAK0kVEbGM/oQ4r53qjYEEHsY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/6 7:32, Joshua Hahn wrote:
> Hello folks, 
> This is a code RFC for my upcoming discussion at LPC 2025 in Tokyo [1].
> 
> <preface>
> You might notice that the RFC that I'm sending out is different from the
> proposed abstract. Initially when I submitted my proposal, I was interested
> in addressing how fallback allocations work under pressure for
> NUMA-restricted allocations. Soon after, Johannes proposed a patch [2] which
> addressed the problem I was investigating, so I wanted to explore a different
> direction in the same area of fallback allocations.
> 
> At the same time, I was also thinking about zone_reclaim_mode [3]. I thought
> that LPC would be a good opportunity to discuss deprecating zone_reclaim_mode,
> so I hope to discuss this topic at LPC during my presentation slot.
> 
> Sorry for the patch submission so close to the conference as well. I thought
> it would still be better to send this RFC out late, instead of just presenting
> the topic at the conference without giving folks some time to think about it.
> </preface>
> 
> zone_reclaim_mode was introduced in 2005 to prevent the kernel from facing
> the high remote access latency associated with NUMA systems. With it enabled,
> when the kernel sees that the local node is full, it will stall allocations and
> trigger direct reclaim locally, instead of making a remote allocation, even
> when there may still be free memory. Thsi is the preferred way to consume memory
> if remote memory access is more expensive than performing direct reclaim.
> The choice is made on a system-wide basis, but can be toggled at runtime.
> 
> This series deprecates the zone_reclaim_mode sysctl in favor of other NUMA
> aware mechanisms, such as NUMA balancing, memory.reclaim, membind, and
> tiering / promotion / demotion. Let's break down what differences there are
> in these mechanisms, based on workload characteristics.
> 
> Scenario 1) Workload fits in a single NUMA node
> In this case, if the rest of the NUMA node is unused, the zone_reclaim_mode
> does nothing. On the other hand, if there are several workloads competing
> for memory in the same NUMA node, with sum(workload_mem) > mem_capacity(node),
> then zone_reclaim_mode is actively harmful. Direct reclaim is aggressively
> triggered whenever one workload makes an allocation that goes over the limit,
> and there is no fairness mechanism to prevent one workload from completely
> blocking the other workload from making progress.
> 
> Scenario 2) Workload does not fit in a single NUMA node
> Again, in this case, zone_reclaim_mode is actively harmful. Direct reclaim
> will constantly be triggered whenever memory goes above the limit, leading
> to memory thrashing. Moreover, even if the user really wants avoid remote
> allocations, membind is a better alternative in this case; zone_reclaim_mode
> forces the user to make the decision for all workloads on the system, whereas
> membind gives per-process granularity.
> 
> Scenario 3) Workload size is approximately the same as the NUMA capacity
> This is probably the case for most workloads. When it is uncertain whether
> memory consumption will exceed the capacity, it doesn't really make a lot
> of sense to make a system-wide bet on whether direct reclaim is better or
> worse than remote allocations. In other words, it might make more sense to
> allow memory to spill over to remote nodes, and let the kernel handle the
> NUMA balancing depending on how cold or hot the newly allocated memory is.
> 
> These examples might make it seem like zone_reclaim_mode is harmful for
> all scenarios. But that is not the case:
> 
> Scenario 4) Newly allocated memory is going to be hot
> This is probably the scenario that makes zone_reclaim_mode shine the most.
> If the newly allocated memory is going to be hot, then it makes much more
> sense to try and reclaim locally, which would kick out cold(er) memory and
> prevent eating any remote memory access latency frequently.
> 
> Scenario 5) Tiered NUMA system makes remote access latency higher
> In some tiered memory scenarios, remote access latency can be higher for
> lower memory tiers. In these scenarios, the cost of direct reclaim may be
> cheaper, relative to placing hot memory on a remote node with high access
> latency.
> 
> Now, let me try and present a case for deprecating zone_reclaim_mode, despite
> these two scenarios where it performs as intended.
> In scenario 4, the catch is that the system is not an oracle that can predict
> that newly allocated memory is going to be hot. In fact, a lot of the kernel
> assumes that newly allocated memory is cold, and it has to "prove" that it
> is hot through accesses. In a perfect world, the kernel would be able to
> selectively trigger direct reclaim or allocate remotely, based on whehter the
> current allocation will be cold or hot in the future.
> 
> But without these insights, it is difficult to make a system-wide bet and
> always trigger direct reclaim locally, when we might be reclaiming or
> evicting relatively hotter memory from the local node in order to make room.
> 
> In scenario 5, remote access latency is higher, which means the cost of
> placing hot memory in remote nodes is higher. But today, we have many
> strategies that can help us overcome the higher cost of placing hot memory in
> remote nodes. If the system has tiered memory with different memory
> access characteristics per-node, then the user is probably already enabling
> promotion and demotion mechanisms that can quickly correct the placement of
> hot pages in lower tiers. In these systems, it might make more sense to allow
> the kernel to naturally consume all of the memory it can (whether it is local
> or on a lower tier remote node), then allow the kernel to then take corrective
> action based on what it finds as hot or cold memory.
> 
> Of course, demonstrating that there are alternatives is not enough to warrant
> a deprecation. I think that the real benefit of this patch comes in reduced
> sysctl maintenance and what I think is much easier code to read.
> 
> This series which has 466 deletions and 9 insertions:
> - Deprecates the zone_reclaim_mode sysctl (patch 4)
> - Deprecates the min_slab_ratio sysctl (patch 3)
> - Deprecates the min_unmapped_ratio sysctl (patch 3)
> - Removes the node_reclaim() function and simplifies the get_page_from_freelist
>   watermark checks (which is already a very large function) (patch 2)
> - Simplifies hpage_collapse_scan_{pmd, file} (patch 1).
> - There are also more opportunities for future cleanup, like removing
>   __node_reclaim and converting its last caller to use try_to_free_pages
>   (suggested by Johannes Weiner)
> 
> Here are some discussion points that I hope to discuss at LPC:
> - For workloads that are assumed to fit in a NUMA node, is membind really
>   enough to achieve the same effect?

In real-world scenarios, we have observed on a dual-socket (2P) server with multiple
NUMA nodes—each having relatively limited local memory capacity—that page cache
negatively impacts overall performance. The zone_reclaim_node feature is used to
alleviate performance issues.

The main reason is that page cache consumes free memory on the local node, causing
processes without mbind restrictions to fall back to other nodes that still have free
memory. Accessing remote memory comes with a significant latency penalty. In extreme
testing, if a system is fully populated with page cache beforehand, Spark application
performance can drop by 80%. However, with zone_reclaim enabled, the performance
degradation is limited to only about 30%.

Furthermore, for typical HPC applications, memory pressure tends to be balanced
across NUMA nodes. Yet page cache is often generated by background tasks—such as
logging modules—which breaks memory locality and adversely affects overall performance.

At the same time, there are a large number of __GFP_THISNODE memory allocation requests in
the system. Anonymous pages that fall back from other nodes cannot be migrated or easily
reclaimed (especially when swap is disabled), leading to uneven distribution of available
memory within a single node. By enabling zone_reclaim_mode, the kernel preferentially reclaims
file pages within the local NUMA node to satisfy local anonymous-page allocations, which
effectively avoids warn_alloc problems caused by uneven distribution of anonymous pages.

In such scenarios, relying solely on mbind may offer limited flexibility.

We have also experimented with proactively waking kswapd to improve synchronous reclaim
efficiency. Our actual tests show that this can roughly double the memory allocation rate[1].

We could also discuss whether there are better solutions for such HPC scenarios.

[1]: https://lore.kernel.org/all/20251011062043.772549-1-mawupeng1@huawei.com/

> - Is NUMA balancing good enough to correct action when memory spills over to
>   remote nodes, and end up being accessed frequently?
> - How widely is zone_reclaim_mode currently being used?
> - Are there usecases for zone_reclaim_mode that cannot be replaced by any
>   of the mentioned alternatives?
> - Now that node_reclaim() is deprecated in patch 2, patch 3 deprecates
>   min_slab_ratio and min_unmapped_ratio. Does this change make sense?
>   IOW, should proactive reclaim via memory.reclaim still care about
>   these thresholds before making a decision to reclaim?
> - If we agree that there are better alternatives to zone_reclaim_mode, how
>   should we make the transition to deprecate it, along with the other
>   sysctls that are deprecated in this series (min_{slab, unmapped}_ratio)?
> 
> Please also note that I've excluded all individual email addresses for the
> Cc list. It was ~30 addresses, as I just wanted to avoid spamming
> maintainers and reviewers, so I've just left the mailing list targets.
> The individuals are Cc-ed in the relevant patches, though.
> 
> Thank you everyone. I'm looking forward to discussing this idea with you all!
> Joshua
> 
> [1] https://lpc.events/event/19/contributions/2142/
> [2] https://lore.kernel.org/linux-mm/20250919162134.1098208-1-hannes@cmpxchg.org/
> [3] https://lore.kernel.org/all/20250805205048.1518453-1-joshua.hahnjy@gmail.com/
> 
> Joshua Hahn (4):
>   mm/khugepaged: Remove hpage_collapse_scan_abort
>   mm/vmscan/page_alloc: Remove node_reclaim
>   mm/vmscan/page_alloc: Deprecate min_{slab, unmapped}_ratio
>   mm/vmscan: Deprecate zone_reclaim_mode
> 
>  Documentation/admin-guide/sysctl/vm.rst       |  78 ---------
>  Documentation/mm/physical_memory.rst          |   9 -
>  .../translations/zh_CN/mm/physical_memory.rst |   8 -
>  arch/powerpc/include/asm/topology.h           |   4 -
>  include/linux/mmzone.h                        |   8 -
>  include/linux/swap.h                          |   5 -
>  include/linux/topology.h                      |   6 -
>  include/linux/vm_event_item.h                 |   4 -
>  include/trace/events/huge_memory.h            |   1 -
>  include/uapi/linux/mempolicy.h                |  14 --
>  mm/internal.h                                 |  22 ---
>  mm/khugepaged.c                               |  34 ----
>  mm/page_alloc.c                               | 120 +------------
>  mm/vmscan.c                                   | 158 +-----------------
>  mm/vmstat.c                                   |   4 -
>  15 files changed, 9 insertions(+), 466 deletions(-)
> 
> 
> base-commit: e4c4d9892021888be6d874ec1be307e80382f431


