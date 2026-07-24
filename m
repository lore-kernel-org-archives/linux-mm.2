Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72168C531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200A16B00AC; Thu, 23 Jul 2026 21:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A796B00AD; Thu, 23 Jul 2026 21:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C886B00AE; Thu, 23 Jul 2026 21:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B23DE6B00AC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:54:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31DA3140187
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:54:40 +0000 (UTC)
X-FDA: 85022001120.05.EDA71CD
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 07ABE1A0004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:54:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d6GRTJe3;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784858078;
	b=QEPjakOiIGOVcJkNGyw522AC+rwzNjG4KfhUTvaluIuqBg1Y8PC2Nyhh8yROuFdP63FPJ+
	lwlPVN+kxkv1MKDYgsT7XsY6PYq14+/hpImQpHCbzatA7eTzDw17QqJHupoUE5v6dawwTz
	jUd4f9T0TcKU/deDeVfmlvk+ZVSxhh8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d6GRTJe3;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784858078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Uo80B0gJ4nFnJDjBKSb2WqdqmzTtmF4qygD8Kxnt1s=;
	b=VSuP/R3MJIqwy3stuvnu7sQ3UE5NIhTE2Hli8of6nnXwSJLwlr9s7nCjnZ2WMtDOFrXtKw
	rgiRjgLY46Cj4rWBoX85+XAK4gPHJGWN7iKpwUwpkxwYWAb3eCNA5JN4DUaKoL62weWfZ0
	JIy/64CnWyD178ScQX4anMFgR5B8TAg=
Date: Thu, 23 Jul 2026 18:53:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784858075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Uo80B0gJ4nFnJDjBKSb2WqdqmzTtmF4qygD8Kxnt1s=;
	b=d6GRTJe3yobovDb/SD+n6Hclux25W43hYIZjkIRvhmGzCFyY69hAqFr4f8gsU8bUQ9ibRn
	Lgbpdyr/Y+kP49gCsby6g4iAtnWCZ3tlwlDvEealJ4Ph6/DiK3c6Njp7l0ynhVbrbRwaIo
	YdycinAxOYT0TOdWAQcrfcLDJoqz/GI=
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
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amK-ApfqfwkPheC5@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720164207.450685-3-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 07ABE1A0004
X-Stat-Signature: 6m4ekw3wmue3ztz9nmq9oyef3wz7ctx3
X-Rspam-User: 
X-HE-Tag: 1784858077-991017
X-HE-Meta: U2FsdGVkX19NbaKWllwvMzljS/rQ5iqBv0N16nGjSNlrukD4TYzALhiHRXGCAOeQzHRWGp6iNrnfwPY3w+6ikLoWnn03rOcBbetMiBdDW6i1tf5t74uSsNLU9joouvNwPhpdzZYJS2jR6SeXIjz5d0znKDl4EsJ1Bv7uUs1agMHBKr1O2YWd4Kq42hbaBl+YaEc/kWo98Pjku7kAapP92ZrTm5Hd128yLZLsf3JILbYqS8BKMkF+FRgPzmi8uBItlwSds5EJ9gLVctL6Ld+sEQDUr+12z0F1wx49xmn395g+h3hED5uRLatiSvti9d72oBq8xT+SrMn8T3t2BvUQo6IHr/0puvC9kEuV6SaVC3NSOGUuYna2Zyx7sUoAezDcyKdLwu9xxK3NCprA83tRCndJqSiTzvQFJhgQgCdk67Fs9U3WT8YsIjz8CZPQc0Zl2151+V+KfUbMtPNjfz8Y6MDC/7U/tLrjgxYvBwwhik8vH/SNvhUIerYoUrVtIdrdP6kV5g/OMuBwgTWaFPuPHtis8p29dDl+yiPCSCefvGxFmrA02J8WiljnUdDnh4jgkgwdpXjil63E+fxpFwQJ9FKyVo8DebY6jPCCnpNk7mbUbEr+GmY3pBJl7no2075KeXmRQCglsGA1+rpR9DcehWxD1Wf3VhXsbwdfx0+gz+QuQU6klRHcVk5eoSC1jah3dWPHxn3klrL8B6SNTMnqToxnxChr7WDU7B3iIJHGHExCKqKVpBuXa2oAQyz92grFEQCIikcvW8hjoIpZQO9zvYT4nkBmSewdinrLqYQNkh/oO9vG6Q+hM2hte5DoR6c4WKqwZFxGAdnYWtooOijOU9DCThbcPYz2Gejp9ke9oL/6sqReViVzgmNLpt+Fdyi6YW2CZ4DnmpO/eHn6rRadoolH10eJhMfYY3fI98kKcbaPeU6CkD+gkM5E27bOUK8bQbCZhZYCwdPnJTXlBPY
 U5+Z02cO
 Ae8N08ZqFBAxjVG+s08UyzooMVROY+txZMOIUvBppfKHvXRG56aA+Okf+582DRltKqU04Rb0mM+x8YceIPgzhKxB8e2+FlpDZx+MFw2o9Rny/fq3QVCMm7FkYT6+GOkhcSvnTywGAucPxWrA41DdxEGeQCpkcbfNei+J76sW283tETXnCX9XG33Bo/jDT1JDGw3jAJlzCjOGtH4lTBUBoVe5zC0yuge6UJUJRaVuLfHWk9EQumCgpkvhkx94juzQixj9W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 09:41:23AM -0700, Usama Arif wrote:
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
> Replace the producer-side accumulators with a read-side accumulator fed
> from per-LRU vmstat counters. The old producer formula was:
> 
>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> 
> Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
> already bumped by writeout() for the same successful outcome that fed
> reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
> this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
> lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
> be sampled per lruvec and aggregated through the memcg hierarchy.
> 
> Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
> producer-local input. They are bumped from shrink_inactive_list() by
> nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> lru_note_cost_refault() used to bill.
> 
> Add a per-side struct lru_cost { count, last_rotated, last_io } to
> struct lruvec. In prepare_scan_control() the two monotonic inputs are
> sampled separately - rotated from PGROTATE_ANON/FILE, io from
> WORKINGSET_RESTORE_BASE + f plus (for anon) NR_VMSCAN_WRITE - and the
> raw per-side deltas are computed against cost->last_rotated and
> cost->last_io before the SWAP_CLUSTER_MAX IO weighting is applied.
> Extracting the deltas from the individual counters (rather than from a
> pre-weighted sum) keeps the unsigned modular subtraction bounded by the
> true per-counter growth, so a signed-long wraparound of any underlying
> vmstat still yields the correct delta on 32-bit. The weighted delta is
> folded into cost->count. Since one vmstat delta can cover many producer
> events between reclaim passes, halve cost->count on both sides until
> their sum is back within the lrusize/4 bound instead of halving only
> once.
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
> Hierarchy aggregation is now implicit in the vmstat accounting. The
> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> existed only because anon_cost/file_cost were private lruvec fields. With
> the cost expressed as lruvec vmstats, rstat propagates the underlying
> counters through the memcg hierarchy and prepare_scan_control() consumes
> the same ratelimited rstat view as the surrounding reclaim heuristics.
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
> either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
> evict_folios() so per-memcg observability of rotation-driven reclaim work
> stays consistent across both implementations.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Oh man too long commit message, please follow Johannes's suggestion.

The patch looks good but I have one question. We already have concept of
pgrotated through /proc/vmstat which represents number of pages we have moved to
the tail of inactive LRU to make them next reclaim candidates. This patch is
exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
the number of pages we scanned but didn't reclaim plus number of pages given one
more trip in the active LRU.

Older and newer pgrotate metrics kind of represent something different. It may
cause confusion. Now before suggesting to change the name, let me ask do we
really need to expose these to the userspace? How exactly users can use these
new metrics? I think you can use them here without exposing to userspace. So,
does it makes sense to delay userspace exposure later when we have a more solid
usecase for that unless you have it already.

BTW really awesome work and I really like how these patches have reduced the lru
lock contention drastically.

