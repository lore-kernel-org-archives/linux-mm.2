Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DDF7C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0996B00F8; Mon, 27 Jul 2026 09:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77AFE6B00F9; Mon, 27 Jul 2026 09:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669F96B00FA; Mon, 27 Jul 2026 09:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3711E6B00F8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:57:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB92014074D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:57:13 +0000 (UTC)
X-FDA: 85034708346.15.9627614
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id A2653A0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:57:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=QFA4WWY1;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785160632;
	b=NRx3+IVRQEhVdVh4QmlzBcBMKPSGwvBmztSVo0ec01dLaqk0WK7VoSOvWWtyYnx9ut/Ifj
	rK7LJqU2u+HNJhHJujkzhKfT8TqF428YZFC6t/MMdl5gRdxhZ/p+a+tMfg1YecYOMBw5GM
	H1ZyNWdc1ry/UjLOR2hUF11GWAEf0OY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=QFA4WWY1;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785160631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dv5JiNRF60oQDhK8RjpXqzwpwgZnaK0KnGMf0oeIKbw=;
	b=iaUT0XrlGgeXSX+A4ZCblgj/lNx5W4hDLFP2JVTwcGqG+xs45B7H1u5i3EfCVI0pcytczg
	i176UYQsLPSYm6IycMuhS0u0FrsnkeSKopYfzsF0cSqkDvn1MEC+4D04c3B9qqXxpVNidr
	cKC9UAS9btme/YTOdZpObEFy/qGNBjo=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8eeb4508f29so24646336d6.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785160631; x=1785765431; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dv5JiNRF60oQDhK8RjpXqzwpwgZnaK0KnGMf0oeIKbw=;
        b=QFA4WWY1f0G9eW0RzLqCxJcBmMZGSZegQ7Uko1qbaDMFQbwSwJEddg9QYHKe2nu6Ty
         n2Fe1y1poi1ekRru9sDHufWs1iDbvMaYOwMb0Ry/oCK0ELBBAbp3h0N/LI5RM0EE9AYj
         vVbOdfPqxq2bImaEAeG7TRMN/khIoEYJyfogn+zW3NNyoV6bMBXsozwXiKk+M+dy3LSA
         M1deLljxg8gi95uUz297JFq5YDKOuU7Dd+ZzQ1eCRUos5hr3ridAh+Sp2Y9HXpZ3S60W
         Wn/0vgWpqSAXxnLdaFuswpSAYgPwO9JlRtWoaMVGWK1r62F8K1sAudvrA+zdQpbDLBv8
         /3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785160631; x=1785765431;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dv5JiNRF60oQDhK8RjpXqzwpwgZnaK0KnGMf0oeIKbw=;
        b=BkVO9v+SXiUZ5wnQBRSZw2Pyf03MohN2DmYvXZ0NQQvm9SNhMq55rFKxtjjeCLV+Ut
         f+7PyPmGpKTUJQkQpVT56Nd1hEFv3KKLwG1zxr+uR9QifcTDNu9eNP6TRV/Mxm/Fcg2r
         n+kaI8fOMsaxYCWAXbWto32SJWmHUr76KaYLmJAofUDEX3nYmI/KjAN46QWc3KE3r/Rs
         tWZwLRaKSFkwy9y9xoPj0zN6/BLQwhthYPjLmgVplO4yNE6Uh/4/LXqQYXQwGe/1TxOh
         LtkdhBy0twWtX/6KWyeb+JW1BXcGhhxizHtDmQrtkrKaIWvO8qxgJ1FVIOJl8s+/xsaa
         kqaQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr5X20ZPveYMdF2I8xSmunYbCFsLTo1VJXoSagM4HNRDQU+uN7Ry0fsC7sM9gjHniEQQ6E5glMwdw==@kvack.org
X-Gm-Message-State: AOJu0Yx1iRLTHKOodD+aArkgq1YMHtamIZAzhIelAOFtEAg1b0waotsX
	91YtkQ6Yal04yleEYhqlci0/3fQqP2St5MaaFfnhsEiV44pc5/n3j1O5qa+m9P80Ul0=
X-Gm-Gg: AR+sD12dgOqOCHuz9qJPTAY/mQK0WiVegL0qKWQHC2KRWuEdTeKyLfGN9a+qiro5gNc
	gIdjTQVpOwhZi5afucdLL6h5EaShywtuxXFOh1SOM2r0OCVwYFNS0ir3bZQTk1csoH8GQO4rxWM
	vvwi/4NbYGxFkt39zdKpFq+QZEvO4d0ibVkvxabLNNi2q+l8Ox4DET4mFo0Ee76KeCUHHnH8R42
	IJySJvu6Al3uBN0irPmtb0XqWdb5pqZ1V8vWt7bubQJ1WSTBzvYmsO3iYLFsM13flKSdorKWD/D
	WRBTYHx7obOyJL/incfekal4b4NMv/ZPFntRETmJMBpxTKijBj+KdgL7Mc+XnamJp8xu/dkr+m4
	hRQtkJmNWjyitnnuKutQGhz6bVdWfzs9p/fkLnTAzoMc6aub5Ty3esuzLCHCq/4ayqFT7Jok4vN
	JI
X-Received: by 2002:a05:6214:4108:b0:8f0:367c:eb80 with SMTP id 6a1803df08f44-907ec7898b2mr107227636d6.25.1785160630232;
        Mon, 27 Jul 2026 06:57:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e85275a6sm65855326d6.3.2026.07.27.06.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 06:57:09 -0700 (PDT)
Date: Mon, 27 Jul 2026 09:57:05 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amdjsVuNYW98Q--Z@cmpxchg.org>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
 <amK-ApfqfwkPheC5@linux.dev>
 <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
 <amOv0MlF1S-oFZHX@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amOv0MlF1S-oFZHX@cmpxchg.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A2653A0006
X-Stat-Signature: 6ab446nytpmjhcx7qqqzg6kggtf51ynp
X-Rspam-User: 
X-HE-Tag: 1785160631-872688
X-HE-Meta: U2FsdGVkX18dOZaCmwz4ru3Q7qoNq6xWtBAyJroAAcveUkEwwJ72Vi/yv+68FucRHXOEAKtTAq27r/xiDfopkV4Xps1NUEDZZ5eFzj81VW7k8r+7LRZXMqq3/Q3rxRn45kLeom2yL4ZwLuYI+p5NNxREUTsaTe3BOHNUAAiiOL8xDgCUrU5DBjHydlloRTt9vbEM+G4b5JEoUEsLRxI9HEO5tYy37bm8iFimrwfmvRktInyHlMC423exW1R4CTX1uM+ahflPnrSxJ0izpuWXoYUsRfhdkH+GPvctqK2v/hEpCi/0bdBmGEGuog4vEpb0JxZpqli0vF1FNgA77z+/0fDtvbbH/P4QHQmiCPPT3kji85j3qdFNIJvlCoJH3itHIQjTgDP9kuQpt0xOWSHnN7s15rCjYgG3GbgrIjZKrgQasTsRVf+Z3JUTY7RkcIZ7Pu6I+nBsBZMFdqfdS+XdRmA0cE/3ygB9iB4GtAiJ40EoZD9YdFuf/l/HpfXZvuS8tsEb5QqIZXI6L/0iIGAOOtq2HxbY4o4bCQh2Vf62HRJypxzrerKW0/BzO6YRSfhyhhItBaVGOVUxjtlcVO7XxHH1UKoTAomT/nB5IZesRGI82xsSzwpB8kNXGl0wbbmG48zqxD315Mrmgv+mRnPJ02DddULgrLg/wiIJkbDaqLmvKH0V9NPSvQ0cdqQIGnqmDP0Z5G0e4QWaKVKHz28PZh+iMKhDYl/Giy/4BqhT6mTSq7JhJafg61GzLpI219uIjgWPTd9I50QoLAJdadthQywSXUllXrgIN3gsOW5nvCqOg0c85CqIufzuE3Tc1wyUW8+BKnoTRSkQEhEHpL/Jy9PTATilEfYZgtaNPDDaj32RBNvgEPVdbX/5BYCTb4tpqQ0b7DyC5U4DL+fJHVWsd9onSTwfr6caNWqbGvqV50hztgMaXGVZE/XwgOEgARBLM/ZihBoJBS1p6BbWlFY
 WMcXBdio
 upW5CK6jweBuhnbiMTXAaJ45m+xbruSbGIdbV7fin4P4WpTEa1ZzwDlKec0gce0edoHWtx3TApYW1zlnC/VFHGn4Cb3TdRKBqbLJT1/Q9ddt2BMlPainDx1uVwP6WNJnAPyuIL9f1TchT+MNI0q8Mc8lSii7c4x1BGCCXcxnNTMhcgnm59CFetUzBwHV4E/cSv8rsA5osOb9tUuNT/f4/rt9j363IMsTy2KMoImhkwYbmbWhoVqSEu1lyWo6iaC8czHN3FfHFTdn4U6hKt3RRn2efmwLknCn/NszNxNekvVLtSSGIS+nGtRGji0ur0H6m30tkh70hq5/Bd+nWAP3TgTlosv4RHS8tfpEZWEOpkG7W0PyG+wLbe03qljdjfuhLSV9Bwr+wJSMvMbmx7p5k72cFvjHnznUP/AzgRUqrotHI42RIAON/Lq3yNKy1b3fsFWlvl78b+xCx5Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 02:32:52PM -0400, Johannes Weiner wrote:
> On Fri, Jul 24, 2026 at 02:29:23PM +0100, Usama Arif wrote:
> > 
> > 
> > On 24/07/2026 02:53, Shakeel Butt wrote:
> > > On Mon, Jul 20, 2026 at 09:41:23AM -0700, Usama Arif wrote:
> > >> The anon/file scan balance in get_scan_count() is driven by two scalars
> > >> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> > >> producer under lruvec->lru_lock. The acquisition sites for cost work
> > >> specifically are:
> > >>
> > >>   - shrink_inactive_list() re-takes lru_lock at function exit purely
> > >>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
> > >>     nr_reclaimed). One acquisition per inactive shrink.
> > >>   - shrink_active_list() does the same with (0, nr_rotated). One
> > >>     acquisition per active shrink.
> > >>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
> > >>     purely to record the refault cost. One acquisition per refault.
> > >>   - prepare_scan_control() takes lru_lock just to snapshot the two
> > >>     scalars into sc->{anon,file}_cost.
> > >>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
> > >>     re-acquires lru_lock on each ancestor to propagate the update,
> > >>     adding O(memcg-depth) acquisitions per producer call.
> > >>
> > >> This hurts because lru_lock is already a heavy contention point on
> > >> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> > >> and folio_add_lru() takes it. The cost work itself is trivial (two
> > >> scalar bumps and one comparison), but it contends with and causes
> > >> contention for actual LRU manipulation. The parent_lruvec() walk also
> > >> multiplies cost-update overhead by memcg hierarchy depth.
> > >>
> > >> Replace the producer-side accumulators with a read-side accumulator fed
> > >> from per-LRU vmstat counters. The old producer formula was:
> > >>
> > >>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> > >>
> > >> Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
> > >> already bumped by writeout() for the same successful outcome that fed
> > >> reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
> > >> this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
> > >> lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
> > >> be sampled per lruvec and aggregated through the memcg hierarchy.
> > >>
> > >> Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
> > >> producer-local input. They are bumped from shrink_inactive_list() by
> > >> nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
> > >> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> > >> lru_note_cost_refault() used to bill.
> > >>
> > >> Add a per-side struct lru_cost { count, last_rotated, last_io } to
> > >> struct lruvec. In prepare_scan_control() the two monotonic inputs are
> > >> sampled separately - rotated from PGROTATE_ANON/FILE, io from
> > >> WORKINGSET_RESTORE_BASE + f plus (for anon) NR_VMSCAN_WRITE - and the
> > >> raw per-side deltas are computed against cost->last_rotated and
> > >> cost->last_io before the SWAP_CLUSTER_MAX IO weighting is applied.
> > >> Extracting the deltas from the individual counters (rather than from a
> > >> pre-weighted sum) keeps the unsigned modular subtraction bounded by the
> > >> true per-counter growth, so a signed-long wraparound of any underlying
> > >> vmstat still yields the correct delta on 32-bit. The weighted delta is
> > >> folded into cost->count. Since one vmstat delta can cover many producer
> > >> events between reclaim passes, halve cost->count on both sides until
> > >> their sum is back within the lrusize/4 bound instead of halving only
> > >> once.
> > >>
> > >> Moving accumulation and decay to the reclaim side also improves the cost
> > >> model across reclaim gaps. With producer-side decay, events that happen
> > >> while reclaim is idle still age each other before reclaim ever samples
> > >> the costs. If a workload refaults a large anon set and then a smaller
> > >> file set before reclaim runs again, the later file activity can age the
> > >> earlier anon activity out of the cost model. The new scheme observes the
> > >> whole between-reclaim delta and decays anon and file proportionally, so
> > >> the scan-balance history better represents what happened since the last
> > >> reclaim pass.
> > >>
> > >> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
> > >> extraction, the cost->count update and the halving loop against
> > >> concurrent reclaimers in the same memcg+node.
> > >>
> > >> Hierarchy aggregation is now implicit in the vmstat accounting. The
> > >> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> > >> existed only because anon_cost/file_cost were private lruvec fields. With
> > >> the cost expressed as lruvec vmstats, rstat propagates the underlying
> > >> counters through the memcg hierarchy and prepare_scan_control() consumes
> > >> the same ratelimited rstat view as the surrounding reclaim heuristics.
> > >>
> > >> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
> > >> no longer needed and is removed.
> > >>
> > >> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> > >> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
> > >> The reported values only refresh when prepare_scan_control() runs and
> > >> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> > >> they express is unchanged.
> > >>
> > >> Under pure MGLRU the scan-balance signal itself is not consumed (both
> > >> prepare_scan_control() and get_scan_count() are short-circuited on the
> > >> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
> > >> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
> > >> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
> > >> either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
> > >> evict_folios() so per-memcg observability of rotation-driven reclaim work
> > >> stays consistent across both implementations.
> > >>
> > >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > > 
> > > Oh man too long commit message, please follow Johannes's suggestion.
> > 
> > Will do!
> > > 
> > > The patch looks good but I have one question. We already have concept of
> > > pgrotated through /proc/vmstat which represents number of pages we have moved to
> > > the tail of inactive LRU to make them next reclaim candidates. This patch is
> > > exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> > > the number of pages we scanned but didn't reclaim plus number of pages given one
> > > more trip in the active LRU.
> > > 
> > > Older and newer pgrotate metrics kind of represent something different. It may
> > > cause confusion. Now before suggesting to change the name, let me ask do we
> > > really need to expose these to the userspace? How exactly users can use these
> > > new metrics? I think you can use them here without exposing to userspace. So,
> > > does it makes sense to delay userspace exposure later when we have a more solid
> > > usecase for that unless you have it already.
> > > 
> > 
> > I do think the userspace counters have diagnostic value. They can be another metric
> > to show how much anon/file reclaim work is spent on pages that are not immediately
> > reclaimed, including pages retained on actie LRU. It could help explain if there
> > is elevated reclaim CPU usage.
> 
> Hm, this is an interesting discussion.
> 
> The existing PGROTATED is kind of useless. When it's bumped:
> 
> - truncation fails and moves folios to the LRU tail for faster reclaim
> - writeback ends on folio that was tried to reclaim, moves to LRU tail for fast retry
> 
> Ok, who needs to know this? The new counters you're adding, on the
> other hand, they capture the information you frequently need for
> understanding reclaim behavior.
> 
> That said, looking closer at this one more time, you can already
> (almost) derive them fully from existing counters:
> 
> drotated = (dPGSCAN_ANON - dPGSTEAL_ANON) + dPGDEACTIVATE_ANON

Talking with Usama offlist, there are two problems with this:

- PGDEACTIVATE is obviously wrong. We want the the pages we don't
  deactivate (hot file executables)

- PGSCAN includes things that didn't work out due to caller
  restrictions (reclaim_idx) and race conditions (tryget, !lru) that
  shouldn't contribute to the balance.

So let's go with PGROTATE as Usama proposed.

But I'm against hiding them from the vmstats.

I'd rather remove or rename the existing one if we're worried about
confusion. We've historically applied a much lower bar to vmstat
stability. It's geared towards understanding detailed MM behavior
behavior, which undergoes constant changes.

