Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7D7C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DED36B00A2; Mon, 27 Jul 2026 12:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FD66B00A3; Mon, 27 Jul 2026 12:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF676B00A4; Mon, 27 Jul 2026 12:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35EF36B00A2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:35:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AED3480107
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:35:27 +0000 (UTC)
X-FDA: 85035107094.25.E034FAD
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 89DCCA0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:35:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yval0zVP;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjxJ4Ft7V0oMbE64yyZGCpBckJXYaY+q8Ii9o6DiK/g=;
	b=EuOCErdXjUH4rRQBBp71X4F/BlwYzIs1qSN81ALQxFJWCLFp5zwwkhY83XNS4gW1DGDw47
	Zcu6KbmSSkCf5SH1otC/jEtgIp0cMFMYnA8Bhr5kK6RyBcfXtk8u4CjIAtAoy6KP0bRDNl
	1fqKQlMyH5FX1zyemuQpmXd27hqV9QE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170125;
	b=gzC5wBQs5brl6Ny84D7L60TYns+RTPeowYd/5ylWUjX9OKEXJeFMu0leoehLfB9xc9Ur7H
	LrCELpcopQE5fB4ux2rA8dWwyV50Ot1WSXlMEzjYMt0Pdqp6eIPPkkcyRBPyjkwc3xtcCq
	h1Rud/A++xZc0mzHB7tgxj+4zetqC84=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yval0zVP;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 27 Jul 2026 09:35:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785170123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjxJ4Ft7V0oMbE64yyZGCpBckJXYaY+q8Ii9o6DiK/g=;
	b=Yval0zVPqmXh4i741fO04m8Ycl1EtwHSU8rOp72V/QNS0dUUSV/8wa+LYO2glX5Tip2lw0
	XjQsrif9WzwtKdtiSe+MQ0wSIMngI4W3rUy/Tj5c0KIiBQ9F2CGpfRH2DEVAluiAqXssf6
	2dlFOqiBZykQ9SjvkqIIkL9b5yg5KUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, chrisl@kernel.org, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rientjes@google.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/3] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <ameIpQtXv9pC2aaT@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-4-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727162550.2032-4-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89DCCA0006
X-Stat-Signature: btdfmh9e1ncfg3jch5t4bhep5jynzrd9
X-Rspam-User: 
X-HE-Tag: 1785170125-246875
X-HE-Meta: U2FsdGVkX18XLxIKP8o83T58czHaILpA9BTQNrpZN/Zwgw19d3sq0oCW3UTLZwqGbZB5+0x3xvEb7++5iF34yOl2+DKlvSzNAjlCBLOXi6Lzhi5NJxCW8S2CArCFxSI2utBdMdoBZk8EWjZBpQKZwTLbp1wzrCWQxbTu5VELs+X98OoWF7OgKZW6WmwvDs6ayyemlvF8ph1H/U6TTJkQh0/HVf0S6GJRCk8/MMY0CXkcIO/aJvht8WvaC4sNfCFQMASz8Ij+ALoQOh1UP0IX3yPwjtAaTmlxjWjq2pjLE29eB8HiqPeUNGJCBfESPQzzDnc1PV7Z5wwrcAdVz9h3JRz21AmOdadxNPx4E8uOU4eOMRFMQg5Wh95aoJr9yE4idMcPH2HrguwxsgTJxHH0EzJ/IE7gZwpjusF5DuqsNoALovmsJ690JvdodreH3ga7EhuYydOv21RVrz1C9p7ooNnkiE1yJPlIHGNGPpfUH66H806xWrZMINcXMJnfFDrOOuJvx/ytUo40YBBC4GI7Aje+R4k2ATl8ZXCP76zRsrt7W4PVZl/k8JT5/SPwroQqndL+cPOqjm5Qxra0Db1vQg+tJTEupFsTV8OksTaPn4fkaqD//f5J13v+9u6SMtMaWNl0K8ZnIcqq7ASDeZIPLPZDElCEhG9rRlcaEsa1iaLDvs/aRPe2dHTByfK8N60e4WqLRzwb3wUZOSfdoMG4IEqzzIDM7zGRvK5pwNLW4/LqJWUOZzVzf/T3be/2UzSNg3zHeZqIrs8UnLIH5y+89l9ugp2ztDDezXd2jwnjp/hslzWb+f7dAjUK+AbyKNy/3Ny97qCAzTM5tTuMEaQbL2ePcloDyw7+0Ihs7hxyAyvdNxFVghN7Lse0AVnHzBtmPO6MW7k70QT1rCBZ9yYW0xIR0hY0oRrH5uXgX/GadFreHU2lKG4VY86tWgkLTbnWBWmC9nT1mpDX4xtUqWG
 P7UC9wCa
 YPEBg1W/MJ0TLgHECR1NBtx3gRhA2B4CpvZHuLKe67Nf7NCZDiJ7n0T7SrUwtZ0xv6WWc1oxybzvseTHuQfXhHEr087ODBZY6d+1zGkw+k5Bx596VDAQmrxLKS+n/mA6fCZEnI1Uz5bY4c8BlFWdI8XC+nLm3m6DlIJHFTsoWaHmj/VzIvy4NuGSGlUGfC1/lZTJXwUJ3Fuj4OhhqqXOrr95QJ2MuyErvXv3Ih7qUtaWnKUj+UTn2L90Q1Aghcbz1PzzqLU+2MdvpJeSrHfFv7mBU3ezbSuJssjY5wHVkP/GM/AKWZbu1KCYlS4ajX7TNLWeZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 09:23:25AM -0700, Usama Arif wrote:
> The anon/file scan balance in get_scan_count() is driven by two scalars
> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> producer under lruvec->lru_lock. The acquisition sites for cost work
> specifically are:
> 
>   - shrink_inactive_list() re-takes lru_lock at function exit purely
>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
>     nr_reclaimed). One acquisition per inactive shrink.
>   - shrink_active_list() does the same with (0, nr_rotated). One
>     acquisition per active shrink.
>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
>     purely to record the refault cost. One acquisition per refault.
>   - prepare_scan_control() takes lru_lock just to snapshot the two
>     scalars into sc->{anon,file}_cost.
>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
>     re-acquires lru_lock on each ancestor to propagate the update,
>     adding O(memcg-depth) acquisitions per producer call.
> 
> This hurts because lru_lock is already a heavy contention point on
> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> and folio_add_lru() takes it. The cost work itself is trivial (two
> scalar bumps and one comparison), but it contends with and causes
> contention for actual LRU manipulation. The parent_lruvec() walk also
> multiplies cost-update overhead by memcg hierarchy depth.
> 
> The balance formula for anon and file, respectively, is this:
> 
>     cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> 
> Instead of recording cost and running averaging logic directly when
> these events occur, snapshot running vmstat counters once per reclaim
> cycle and derive the balance from event deltas since the last run.
> 
> Use PGROTATE_* from the preceding patch for the rotation input.
> WORKINGSET_RESTORE_* and NR_VMSCAN_WRITE provide the remaining event
> counters. Charge NR_VMSCAN_WRITE through lruvec stats so all inputs can
> be sampled per lruvec and aggregated through the memcg hierarchy. This
> is overall cheaper and has fewer lock acquisition sites.
> 
> Moving accumulation and decay to the reclaim side also improves the cost
> model across reclaim gaps. With producer-side decay, events that happen
> while reclaim is idle still age each other before reclaim ever samples
> the costs. If a workload refaults a large anon set and then a smaller
> file set before reclaim runs again, the later file activity can age the
> earlier anon activity out of the cost model. The new scheme observes the
> whole between-reclaim delta and decays anon and file proportionally, so
> the scan-balance history better represents what happened since the last
> reclaim pass.
> 
> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
> extraction, the cost->count update and the halving loop against
> concurrent reclaimers in the same memcg+node.
> 
> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
> no longer needed and is removed.
> 
> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
> The reported values only refresh when prepare_scan_control() runs and
> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> they express is unchanged.
> 
> Under pure MGLRU the scan-balance signal itself is not consumed (both
> prepare_scan_control() and get_scan_count() are short-circuited on the
> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
> either reclaim implementation. The preceding patch also bumps
> PGROTATE_{ANON,FILE} from evict_folios(), so rotation-driven reclaim
> work is accounted consistently across both implementations.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I see you already added my Ack here. Sounds good.


