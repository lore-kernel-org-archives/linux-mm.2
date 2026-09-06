Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40273C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 05:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11206B00B6; Sun,  6 Sep 2026 01:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2416B00D0; Sun,  6 Sep 2026 01:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFA96B00D1; Sun,  6 Sep 2026 01:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB5B16B00B6
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:05:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2846F1A045F
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:05:41 +0000 (UTC)
X-FDA: 85182149682.12.EE34951
Received: from mta1.migadu.com (out-16.mta1.migadu.com [95.215.58.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04461C0004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:05:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YLdvTY+B;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.16 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788671139;
	b=dCsFkFFvgpqv+llZkFFbqNeWP90FRhPYY3I0Bko8lO6QorYtKfnOK/MWB8Ij2TH2fyvBmO
	R9JIJDIabQm8WD0EtdM/ymkH41XVfbveeRQ0ArNfluazutH91z9L7Ig+p6JXUEEvtYvojH
	WI2EPH+Q2K4RCMtte051Vj1E9FM/Rbg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788671139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CX7PufplC8BcEv6BPDm5tHrDUM3U9H51ZYT3tZk522A=;
	b=t/uC79LIxUggvtZ0KI4yQRjP1424biYg5NeeVZEEE89t28vTREfvwkWQLo9Ddl+C89DVJA
	qRNBH+DlATIX9Je11cTacSVIqYXCKRs1TJPUpgttDVLqD1IaCUeBtoSecubVUjnPRDg7Cj
	EJ7Sn6hOga70SrBVzZX652jw7ZxGcgc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YLdvTY+B;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.16 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=90c8t894CaHOARptfQVdz1/jF1xpxhRk1kEXilNjskc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788671137; v=1; x=1789275937;
 b=YLdvTY+BdhyNetq/FhXe4EJRfKs9DSQjDHNoaWd8l9uLh9kMqYxUOh+IO1tnDOxXrJjw3EGC
 lZabqH3rKazj6pm80QQRLvsFcYlYbxPQGySi9bvJEJakjd8zPRAtLhmno2C0r73+txoiF5K7J+E
 iOK0VDADYSR4rly3oQfumg3c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1352ad230425d981;
	Sun, 06 Sep 2026 05:05:36 +0000
X-Mizu-Trace-ID: 1352ad230425d981
X-Migadu-Flow: FLOW_OUT
Date: Sat, 5 Sep 2026 22:05:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, yosry@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/memcontrol: skip non-hierarchical memcg-wide stats
 when v1 is unavailable
Message-ID: <20260906050459.GA80665@shakeel.butt@linux.dev>
References: <20260903215616.1456239-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903215616.1456239-1-joannelkoong@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 04461C0004
X-Stat-Signature: qz94cir35ofwexoizjqo6yanq8zpgphn
X-HE-Tag: 1788671138-410851
X-HE-Meta: U2FsdGVkX19JVLbRG9oiNcAuUl9It/D3VtAkRiNkile0ZMD3lbcSvLdzAJ55Nl6/u4iyBbELPWXXkOM4dnG47Godv3kpmoUdhsiXnpvh4/spwMewCwUCcTBfTM7ga7OZH5LsKH62mydfAq6aLbxvgyEs4j+iPfJfXDDWcqiqTI1Jl2oaLKcAjNVqW6I+z8f/oeK662YKp2tQ5W+roaN+bWlpk1yKZRtVnBQqA767KDPmWDFQkOTjPnYKAaOytdqQS9sq0R2wGU3vywzrFfJcHYFiKewROJtilDmOTTwXD9DbwCk87LwVZq2AtJKPNxjyYuGeCgLMeF8FDsnv/bLfPJS1ImTw77Gpcn56pxACQ6gIx4+jDdOtKu5pjr89Njg7il6aG9niYnYFjLGh6BnHjH4rB16fdfzEEThHXev4xcX5TN0xHNcQAESfZKJEWpEY9AuwldE4AQut95n1jevri48hLHGWZfvM3/2jfSNNLDpI6zN2g6oMZoRzqR5xLyg/ci+LO9MSIo8oA9LI/UEw80Wm2+rQWALQOPupsBj6yT5OCn1Ky04vU0SSGf8ExfZbGOd9F/bKJxgwE2PLhqPbee5bKaKsRtrWfdOeb6MBohYOhTzdElWssDQCRttYDLf2GxCEKG+mvP23KUTysQVMTJwp8bvjeRA9TDTVu4MUua89XkO1xDMGY/k+0tj5HdpfS5W/DfXsPhUBImA53hIiHpMX5zoWNMmQhjNQohGtHd5qZs/qNoO47ibHWOq94C05oY5vdNfLltyIz1wzZBWLAJ0fvCcNejgp+OjRz9EnEdnaSav2LJXX1bgnvbUZG4z2Y44+5+hcX9XSe3xcC5wDleB+QkZ/AJNCHOuHtiI6D8er08ecPee3k5uzXxmH7A8lNzJXW+8UkppmzxQKsW/OLY63wE9ViXEh0nnqbqTCCT5J+QnOPDRxyh9N8LyaZxdoj0Uj4tTmUvQZ772P9VA
 YwbPTblU
 GlAmEy/JPx7CYw35Rq/MA3wDiyeuXdet/LSjVWWZ4zVLH55Tpi10u0es3+47MvY70giwAlQIyG87da0YtatspZ2+v+UNws9ZYU8vaiCDdThszIIusQQbUXOK7NVr/pJiD98PlOAjidA/S7u120I0YE+bvL/nQP9hxjh8bMtU/63fBNrFSoWC3gf7EKBc3FZbYWtlHwPrZIqNTMaY1DUknFmqulr76YOCemoUP4F/T505NajON+BTnNE9Bk679HpoR1gzS5XLWaRZ/FQpfsvbqxBagFuzQ68peKzOG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 02:56:16PM -0700, Joanne Koong wrote:
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline.
> All of them live under CONFIG_MEMCG_V1, and their accessors
> (memcg_page_state_local() and memcg_events_local()) are already compiled
> out with it. This means on a CONFIG_MEMCG_V1=n kernel, memcg_vmstats's
> non-hierarchical arrays are written to on every rstat flush, despite
> their values never being read / accessed.
> 
> The same holds when the kernel does support v1 but the controller has
> been blocked from v1 hierarchies with the boot param
> cgroup_no_v1={memory,all}. A v1 mount is refused in that case, so the
> legacy memory.stat can never exist and the arrays are just as unread /
> unaccessed.
> 
> Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
> not set. If it is set but cgroup_no_v1= has blocked the controller, skip
> updates on the arrays.
> 
> This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
> read-modify-write of ac->local[i]. Nothing else accesses state_local or
> events_local, so those cachelines were getting pulled in solely for the
> writes and they are separate from the ones the loop is already walking.
> 
> On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
> dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
> counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
> flush showed roughly
> 
>                          before   after    delta
> memcg-wide aggregation   1231     1180     -4.1%
> overall flush function   2452     2397     -2.2%
> 
> These numbers are from taking the median of 70 samples, one per 20s
> window on each kernel. The 95% intervals observed on the two deltas are
> [-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
> timing overhead itself, so only the delta is meaningful here.
> 
> Counting the items that actually changed, a median of 1.5 of the 77
> memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
> each flush, which means the benchmarks above are with one or two fewer
> cachelines pulled in per flush. The count is low because the benchmark
> reads memory.stat in a loop to keep the flush rate up. For cases where
> flushes are triggered only by the 2s periodic worker, more changes will
> have accumulated between flushes, so more cachelines are skipped and the
> per-flush saving should be larger.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

