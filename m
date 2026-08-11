Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA930C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADEDA6B009D; Mon, 10 Aug 2026 23:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB71A6B009F; Mon, 10 Aug 2026 23:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2AC6B00A0; Mon, 10 Aug 2026 23:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7106B6B009D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:09:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E912CA0352
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:09:20 +0000 (UTC)
X-FDA: 85087507680.21.98D84B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C3686C0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:09:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XFtWJJ29;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786417759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vji7dtSYo7mrUp//f6RrWJI+/bXE2NsJpbtTjmdbFtw=;
	b=D0ZTLvJCfZwrCQARvXnyk2ZUIKjoDQVeamhV9k7UHEIfOPbuWwOIyiClvyLLTJ9f5JFmrr
	MOnFIg0gTmEUxkvDBxZcB526D2MIYY4jcIvOW1gfVuWR+ypIf8mcG0HXt55SJLAHHz/NOM
	PSmeRzEB2IbojY7sQlUo+8HQ5H/Z3AI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XFtWJJ29;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786417759;
	b=HKFL6hzY+6We2ff8jXNYrdJETV25WyU0RW0tHjjLuz/AlIOlVfNe8dfSlSaGqrbnRM8A/w
	5bE6gKg9Wrr+lmbXcW5URd4yzQZb6Ihc3gptXDgnx7WMDXvdC2kAOSgtTkTeJpAP02l1vl
	LI1xIVxkeUfDaQ5BUUhvbjzsOL9MGcw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6D6B410A8;
	Tue, 11 Aug 2026 03:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAD41F00A3A;
	Tue, 11 Aug 2026 03:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786417756;
	bh=Vji7dtSYo7mrUp//f6RrWJI+/bXE2NsJpbtTjmdbFtw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XFtWJJ29SV6P9bos6+/MbHWrR8k2oaeZg/a3jmfvNLC9gFW9l2oiZtoLLi906KLCg
	 h8cXrQmcWbkji0swlpJeBwkbj5WeajYikDx5GiBIBA6w7qj4oc/uOBG37UvwRQTIhc
	 phSOIv503rMWjQqpoQjzsGg/9lTSEuzVJpZyzj/c=
Date: Mon, 10 Aug 2026 20:09:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Yunzhao Li <yunzhao@cloudflare.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, nphamcs@gmail.com, yosryahmed@google.com,
 shakeel.butt@linux.dev, zhouchengming@bytedance.com, James Houghton
 <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in
 zswap_shrinker_count()
Message-Id: <20260810200915.8461c16060fe1b79c18bced2@linux-foundation.org>
In-Reply-To: <CAO9r8zOPMNDQWZ8z+RsApbA0cddE1au5hTHdRT0NYe-EjmP4aw@mail.gmail.com>
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
	<akbHBZP9HxOJMtQB@cmpxchg.org>
	<CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
	<6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org>
	<CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
	<CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
	<CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
	<CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com>
	<CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com>
	<CAAnvDSyDYU4MvRo1rNwxQcnmwHe2_UW43-hZEU-Zf76B2euYQQ@mail.gmail.com>
	<CAO9r8zOPMNDQWZ8z+RsApbA0cddE1au5hTHdRT0NYe-EjmP4aw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3686C0007
X-Stat-Signature: zdtydq4rj5wnttieqs73wwpzr7j8zf7k
X-HE-Tag: 1786417758-537141
X-HE-Meta: U2FsdGVkX195jaFLLZVsdctzhJlEMd2x8nu3x82hx/7ibjfR7pdRw3Bh8RPxSZi6jczIBSBVXvRCZNv6FJ7jxf36gX+s6oVj6bionosBrkLQNqUkcOamprSjZ3Hs9/qiznJCUIAbhHEE9zWA/UZC8c92lfRdRg65r9lTyatl2SmnveqePqB7kFkXiXDlpl5fpWsZCRrvCBZLtjeIfbZa93voOnugrzr2DMH+sZMJGh6oybDBy7wFJfFC+lSqcIVeV3aV/DKchxpHKJP9Ex3lTDX34EUwmxtQ0v3at/drDaqbLZSD9BHgsRcwjvDWxdpqAY5mYm0FqD99pEAjFhWPqCCnIRjAPM/mDlaf/8NaIru7D1Za6bmRGj15+y/eEqYcUaPf94ziH/84dnV3BHxKtUgo7eKTWYT03VGWZ7ForVTBcvXcQSNemliwLEIDw3YdbCmdQEhN8Efv1iQ6lt4SXWgTVHC8jspGWO3DwC++uDb61Rm8W8qBCzmvk20RxWlr+7A8i8YGsFfLEU3ZhTsNe5tHX2LzztrfDdm3IbpuEw0usqFAJ735VMnAGCu91WkQSJzyGkTH98SMVwJUog+q8RU7NJmTh7Dkk/PpnvsGaGX4puwtwI4jeEtgRMhI8QO1sb+89lazLBOnTIvqguNeSFLTSsFUo5DiDMbyv53Pq5WDG+esPhCy8rie4vPwHVIg7Iv/87G602C2/K0dRDQ3JuoVY/DedaQOKs9Xcd7qmXezXnVL9p9U8MyvL0CG40lqluAODieChG0MX8ZyEGOPSZ5iWbUXbuWhEtwXGixOYMX4JnjQB3fcFkz0nzkqBTG6tTQiF9nkYOheBwm1z+F3j/gPpCYZhPTD/kid6YMfu9nGhu9BPCYSAdhmXgR9OlTxTLOI7cwD5Bol2JK4LgARBN+GC1UU0pzWIJ4aluI67I2X+Nz6f2Ed+KfE1EbscbVoBu52OM+UGVTIHtw3XhW
 1qX9tb7G
 Jt3aETGuHK2nWul3GTOdpR6BVJ0c3SPvg/Cq04bquUvVi6uQPDaVxNgPh/BCWHPFDjBnFoCO9OxDIbWWov+CL7gbWzEf1Gh67QwKgtULfrkHJLSSujPJlLEdiQn+8mry1VqDaVwu9RuZ8g2z6rlMK+9MXRNX2traTip/AEWz+9zFKEPXqcF2tIKBjcKfgauscB2T/00wQdHeoSChsgYJuPhCwRd0YStDrVKuYI5mdjsns57xaCTqwdVDFypBmR3H4fkwxvEsFjFnbkYVWLBfzkepYxXjqn4silIzn3COL++wHCjj+RhrRJApJ7CxhsEuPIgH3P9o8MUyvzkMMCaxBQahcXLDVZDRvO477e4+SrCNWF/fSlieYAt4sD6Ymf2+wVJcRpE6Piii5hYHV6Lwt4MHRBsKSQU4FskO1ACclPY6hVqH8Nwas4vYFuegMSXa0dUb01vRKmYvnOsMxaYWC216TDIHIUsPyqpdyix5bHUWga4J2eLE3ogc9gAReCNSC2WqhOluIh25VNwGL4IbXcfej2mCboawqO/zjz2rr10aCUx7KpksEA1FkB0b8ZI/6+9yQnAHg+Cu3L9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 11:27:31 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Fri, Jul 10, 2026 at 9:36 AM Yunzhao Li <yunzhao@cloudflare.com> wrote:
> >
> > > Yeah the per-fault latency is exactly what I was looking for. Seems
> > > like most of the faults are not faulting in the pages written back to
> > > disk, nice.
> >
> > Yeah, at least for our workloads the cold entries seem to
> > stay cold.
> >
> >
> > > Would you be able to take a stab at eliminating the flushes as I
> > > suggested above as an alternative?
> >
> > memcg internals are a bit out of my depth to be honest. I can
> > definitely test a patch on our fleet though and get it verified
> > if someone picks it up.
> 
> I can try to come up with a patch if you can help with testing, but it
> won't be for a week or two. How long would it generally take to verify
> such a patch?
> 
> > The ratelimited fix in mm-new is working well for us in the
> > meantime, so it'd be great to keep that moving forward.
> 
> Hmm we can keep it in the pipeline for now and perhaps drop it if we
> can get a proper fix before the next merge window. Does this sound
> good to you?

So it doesn't seem this will be happening.

The original ratelimiting patch seems useful, is well-tested and
well-reviewed.  I'll plan on upstreaming it in the second week of the
merge window unless someone stops me!




From: Yunzhao Li <yunzhao@cloudflare.com>
Subject: mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
Date: Thu, 2 Jul 2026 11:07:35 -0700

zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes the
global cgroup rstat lock synchronously.  On machines with many CPUs and
NUMA nodes, this creates severe lock contention in the kswapd reclaim
path:

  - Multiple kswapd threads (one per NUMA node) run concurrently.
  - do_shrink_slab() invokes zswap_shrinker_count() for each
    memcg-aware shrinker pass.
  - Each call flushes the full cgroup rstat hierarchy under the global
    lock.

On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes) running
production workloads with zswap enabled, perf shows 2.88% of kernel cycles
in osq_lock contention from this path:

     2.88%  [k] osq_lock
              --__mutex_lock.constprop.0
                  --__cgroup_rstat_lock
                      --cgroup_rstat_flush_locked
                          --cgroup_rstat_flush
                              --zswap_shrinker_count
                                  do_shrink_slab
                                  shrink_slab
                                  shrink_node
                                  balance_pgdat
                                  kswapd

84% of kswapd kernel cycles are spent in
shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in actual
page reclaim (shrink_lruvec).

Controlled A/B on identical hardware and workload:

  shrinker=Y: 2.88% osq_lock, memory PSI 1.58%
  shrinker=N: 0.00% osq_lock, memory PSI 0.57%

eBPF-based rstat lock wait measurement across 8 production metals
confirms the contention splits cleanly along shrinker enablement:

  shrinker=Y: 50-250x more contended lock acquisitions (248/s vs 1.1/s)
  shrinker=N: baseline lock wait (0.0017 s/s vs 1.04 s/s)

zswap_shrinker_count() only produces a heuristic estimate, scaled by
compression ratio via mult_frac(). The actual writeback happens in
zswap_shrinker_scan(). Slightly stale stats are acceptable here.

Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
the periodic 2-second flusher is one full cycle late. This matches the
approach already used in prepare_scan_control() (mm/vmscan.c) for the
same reclaim path.

After applying this patch, rstat flush latency and lock wait time on
shrinker=Y machines dropped to the same level as shrinker=N controls,
while the zswap shrinker continues to function (pool size remains
bounded under the max_pool_percent cap).

Previously discussed:
  - Chengming Zhou (Dec 2023): rstat contention from
    zswap_shrinker_count [1]
  - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
    flush [2]
  - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
    flushers [3]
  - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]

Link: https://lore.kernel.org/20260702180908.150136-1-yunzhao@cloudflare.com
Link: https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhouchengming@bytedance.com/ [1]
Link: https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40HPGMKQwX_=NPCWB_mFW+oQ@mail.gmail.com/ [2]
Link: https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDxtpsNp-c5CGOA-4Bq9oXSg@mail.gmail.com/ [3]
Link: https://lore.kernel.org/linux-mm/172616070094.2055617.17676042522679701515.stgit@firesoul/ [4]
Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
Tested-by: Yunzhao Li <yunzhao@cloudflare.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yunzhao Li <yunzhao@cloudflare.com>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-use-ratelimited-stats-flush-in-zswap_shrinker_count
+++ a/mm/zswap.c
@@ -1219,7 +1219,7 @@ static unsigned long zswap_shrinker_coun
 	 * Without memcg, use the zswap pool-wide metrics.
 	 */
 	if (!mem_cgroup_disabled()) {
-		mem_cgroup_flush_stats(memcg);
+		mem_cgroup_flush_stats_ratelimited(memcg);
 		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 	} else {
_


