Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 690D0C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8452C6B0099; Mon, 24 Aug 2026 04:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CBB6B009B; Mon, 24 Aug 2026 04:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7595A6B009D; Mon, 24 Aug 2026 04:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3EF6B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:43:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD1E3802B2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:42:59 +0000 (UTC)
X-FDA: 85135522878.30.D9956AC
Received: from mta1.migadu.com (out-22.mta1.migadu.com [95.215.58.22])
	by imf21.hostedemail.com (Postfix) with ESMTP id 553031C0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:42:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Udc3AjIH;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.22 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787560978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntzODhn9rXQnazJjVE8N1IOl00AEOP2fkyYLqZwbxzw=;
	b=Q5fD/jPENoepbx95jxAetQMlVNuxTupKgcCBs74rDB+ZGq6oHp2TNZk8GlcfRTR9PQWlEF
	jwSRgnmxf1GMZTjkgiUJEIi13WRk9vloJUrqJHlhbvNn8zsL9JhJ3RoEkgoxpxZBH4gi8u
	vRjsbxEbZ9tKMdNLKMoCT8aBalbAEPY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787560978;
	b=DGiH6BmaFQ30UZOmPKuWaQTyk20jxftsAtmrImEMxzmTgtqR07lMyOyrTI1wY2wJusVUJe
	TKmahe2R8ghR6Ofu35xIEghGVVLgNgbWQQNlRDq69BcYbT2za0b6bimIe4Stm5azV148UF
	mQnSgXlv9QNmsDYx0OdjI+6M1Lc5eSs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Udc3AjIH;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.22 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=a7I01ceEBwjGUHz7eVfy6nfOZJ7Sz8KIAjmLETcZems=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787560975; v=1; x=1788165775;
 b=Udc3AjIHLQc1Fe8XSGgUfN9eDcuLC4fpx2RwmiN2RV/wnQA4vmnT06x3b7I4C7/f2OWHTirs
 0wMC8TEC6pL+XsZUlEpTWE3aJwbBlv24FpY0kn4n1gEPsKt2iZVTEidvVSNxhk+o1wT7b3Aulu+
 UeP+oTLBmYcZr0XP7bFinusU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id e004af43b8cd7349;
	Mon, 24 Aug 2026 08:42:55 +0000
X-Mizu-Trace-ID: e004af43b8cd7349
X-Migadu-Flow: FLOW_OUT
Date: Mon, 24 Aug 2026 16:42:44 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, kasong@tencent.com,
	baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/9] mm/mglru: suppress empty page table walks during
 aging
Message-ID: <aowEBGJPwLdsJZLt@fedora>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
X-Rspam-User: 
X-Stat-Signature: aahjq1pzwx3nbwbwthw659cgmxbjr4dc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 553031C0008
X-HE-Tag: 1787560976-338818
X-HE-Meta: U2FsdGVkX1/Z62X10lXlf4OitJKRDODr/LifU74zgN4hzNXBK3yMRhBxL5GnVAc/IfWF6mgN8hEa2j+2tqJqbLMDLYZ+8cax8ZByInYrrn71RvNhyuH7Z1UVrIpYgts2CdKMmnM2p9joFQSErpnQGAjrUWGTVAx/QKJwcUNvXP5OrVb08Xb1YxDeRjrfxkIdvs8jGSoSR15wONJNbxIT59EuoRcdfSnr82JwmduRXHPpBulGgfzTOFGvTSIs5NlncpBOoGedmbQXGdsY6CmgZnt5YBQP5mbG/kUSltu9JCtF1BEV0KLEaicPO+v+CX0VXm8anGjjStYzcRTtC0t1/dt8DJK63vsRWQAKbf5XLeIeRwH0vHyO4RYyxrlrUUJwYbMrOY7tOeQs4b7A4TlAQBgPUtNTVLFVHtPHuChYXuq3bPAprtVp7vJ1CBd86wBoOVLDHi1ffq9NssAN9+ppbGmEwMZLM9UnL7XR5g5L2Mmf3cCq+SkdTFa/8DzfEilRIuQTDD5UhmYyOB8HG7yRuuduW+0XuElYAuO4m9Reqnox4oMpcIib/CbaISUn2CWuaqJ/yjzh7dSxmY1vrENi7ORdum7ADfNPvLqOxENsv9gqm/r5uwKiNiKJXkmBd8JA1Gul1qXsB0Wa2I+VkTTl1W9VShE3rL2qP1lNywO3m3S5hnNyEgO1njmPUIJgc8mCFfdlny+hYQgDqSldQC5B30yHfzNW8TBKlIddsf7KJZv7DU5ykkjHF/Yc8JLlXRTPXGVck6mtF8nFWtap4pOl8nTmwElv2inYwqfF+6vd3gPVxy+BxatWIJmA2cprQHKEEaO7TdB9To8DmsSQGU3lCq2nbvk+fz8mh8iA4wKARykqZ9eFe1AH0goqgILFmhrzQbg2ByiYlmD52xERa9ARe7GveSJGHRivp28m2CpaBXEmKAI2JttnV9vYAHV9GWvl4cwB5YQbkHFbkgnanIy
 mZLSZ4tQ
 oHd9nDFvE6OYF5KVRV2LM9mP/pmlTsBsuYe4AmLkz9jj6J0/hydFso+MXWUkEPaOjy8MRXq/Mm4pFqgHfifoISaNuTd8RJ3ZK9zcSjgAed2Rx9Lz7Rb7Wq5loLeXR4iWoR+PpIsKztjEJv0tx2y+YIC91gE3qM1T64dI/QJ1E+5mEan7/k+0C9ZyK7qC73+8z9b2NSKRiWWcR+qKyGR68FhHVvh7shgT6lcIjzXlzqFRtKlMluA6iMwc8mnhCFitSKElBEsEz4i3eTuf2578MSthoGIj8cytH24xuegqQLZz3akIYzwL1CGgDX8otkbZL2F0MmuoEREN01f9HZnMpwwvF4//y6Yt1KiA5dKr4IMpz/WbGtwF/VJFTGoZMOBBW1lY5Y3pkn82MuPLE8CSnq41axVdU4WOTIye2AFC+e74ArkY2CZsMMbe3DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/24/26 at 03:37pm, Baoquan He wrote:
> In the current MGLRU, lru_gen_use_mm() will mark an mm for all nodes at
> each context switch, so on each node aging will walk into each mm's page
> table independently. On a multi-NUMA node system, one process launched
> on one or a subset of nodes, its mm is walked by all other nodes's aging
> while finds on pages for their lruvec. This is pure waste (100% walks
> are empty on those other nodes)
> 
> This patch series suppresses these empty page table walks with two
> complementary mechanisms at different levels:
> 
>   - empty_map (cross-node specifc). At mm granularity, one process's mm
>     whose walk found no pages for one node's lruvec is skipped on that
>     node between re-scan passes.
> 
>   - PUD-level Bloom filter (general). One level up from the existing PMD
>     filters, it skips any 1GB PUD that had no young entries last
>     generation - namely whose 512 PMDs all failed PMD test. Cross-node
>     empty walks can prove its effect the best, but it also suppresses
>     purely code PUD inside local mms. So it reduces unnecessary walking
>     in any workload with cold areas.
> 
> The two complement each other: empty_map reduces the *number* of
> cross-node walks, the PUD-level filter reduces the *cost* of the walks
> that remain.
> 
> Measurement test (3-socket Xeon 6766E, 32 x 256MB workers pinned to node 0):
> 
>   node 1 (foreign mm walks):
>     empty_map off (PUD filter on): 3300 walks, all empty, ~1238 PTE scans/walk
>     both on:                       900 walks (-73%), ~0 PTE scans/walk

node 1 (foreign mm walks):
  no (PUD filter|empty_map) (baseline): 3300 walks, all empty, ~1238 PTE scans/walk
  empty_map off (PUD filter on):        3300 walks, all empty, ~0 PTE scans/walk
  both on:                              900 walks (-73%), ~0 PTE scans/walk

Sorry, double check here and found I pasted the wrong content. The above
table is the right one. The 1st case means on baseline kernel, no pud
filter and no empty_map, on node 1 3300 walks are all empty walks, and
each walk scans ~1238 PTE.

> 
>   - empty_map cuts node 1's walk count by ~73% (every 4th pass re-scans
>     to close migration/fault windows).
>   - the PUD-level filter makes the remaining walks nearly free: the 1GB
>     subtrees are skipped instead of iterating their 512 PMDs
>     (leaf_total drops from ~1238 to ~0 per walk).
>   - worker RSS is unchanged in both modes - no premature reclaim. A
>     force_scan pass confirms the local pages are found young and eligible
>     (leaf_eligible == young == 21320 on node 0) when the filters are
>     bypassed, i.e. the pages are hot and the aging walker can find them.
> 
> Performance regression test (make -j4 in a 3G memory cgroup, 4 vCPU / 8GB
> 2-NUMA VM, median of 3 runs):
> 
>                   baseline   patch    diff
>     build time     10m01s    9m41s    -3.4%
>     pgpgin        136868    138080   +0.9%
>     pgmajfault      1832      1862   +1.6%
> 
> Build time, page-in and major-fault counts are within run-to-run
> variance of a no-patch baseline - no measurable regression. The build
> time is if anything slightly lower, consistent with the suppression
> reducing reclaim overhead (fewer cross-node empty walks) during a real
> memory-pressure workload.
> 
> The test codes/scripts (numa_workload + run_test_v4.sh) are available at:
> https://github.com/baoquan-he/mglru-empty-walk-test
> 
> RFC-v1:
>   - Bloom filter helpers are named symmetrically -
>     test/update/reset_pmd_bloom_filter() alongside the PUD-level ones, and
>     the struct field filters -> pmd_filters (Barry).
> 
>   - An mm is marked empty only when its page tables were actually walked
>     (a failed mmap_read_trylock() or a stale seq is not empty), and the skip
>     is invalidated on the major page-fault and migration paths. (Sashiko)
> 
>   - Reworked the re-scan: the old shared counter across nodes got stuck at
>     the slowest node, so the skip never really engaged. Now each node re-scans
>     its empty mms every N passes on its own clock. N is the skip_empty knob
>     (default 4, proper read/write with input validation). (Sashiko)
> 
>   - Added measurement counters/tracepoint, and a kernel-build regression
>     test (no measurable impact).
> 
> 
> Baoquan He (9):
>   mm/mglru: add MM_WALK_EMPTY stats and tracepoint
>   mm/mglru: suppress cross-node empty page table walks
>   mm/mglru: add debugfs knob for the empty-walk skip threshold
>   mm/mglru: invalidate empty-walk skip on page fault and migration
>   mm/mglru: add PUD-level Bloom filter state
>   mm/mglru: refactor Bloom filter helpers for two filter levels
>   mm/mglru: skip PUD subtrees during aging
>   mm/mglru: report hot PUDs from the rmap feedback path
>   mm/mglru: count PUD subtrees skipped by the PUD-level filter
> 
>  include/linux/mm_types.h      |  22 ++++
>  include/linux/mmzone.h        |  13 ++-
>  include/trace/events/vmscan.h |  30 +++++
>  mm/huge_memory.c              |   3 +
>  mm/memory.c                   |  15 +++
>  mm/migrate.c                  |   4 +
>  mm/vmscan.c                   | 205 +++++++++++++++++++++++++++++-----
>  7 files changed, 264 insertions(+), 28 deletions(-)
> 
> 
> base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
> -- 
> 2.54.0
> 
> 

