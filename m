Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C57C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 18:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C196B007B; Fri, 24 Jul 2026 14:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903F26B0088; Fri, 24 Jul 2026 14:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3586B008A; Fri, 24 Jul 2026 14:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 498CD6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:32:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB795C0121
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:32:55 +0000 (UTC)
X-FDA: 85024516710.05.425DAE1
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 90AFC140008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:32:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hKQt0EEN;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784917973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXz8gdKZyjeAUSJH5WauhE2Y5aZihjLOBIOIDBnII0I=;
	b=OSMynYPsKdAlDVii+/w6rGTFfW3e6lQ5xatGhiSVDu58VleBzoXiXrxQi5BwuArfr0wwAp
	fb4jhOPBZpVauU9LcYcpbNSW1SHGjBM0WTs1bn9jexnARydbafzwM3vTNfkGKeuV/v6Mya
	Lh87H6iskCPeQfWGyhevR8dwOdI2mPI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hKQt0EEN;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784917973;
	b=1MKGsA9TLfq6TEzE0/fxaGKxGkbeDqUaOTYkV8daTET6I386zSStQzGSMiLP14L7+k/WxW
	kEcC5333fNA18PtupF5YIFh4y7PlgZakiLozlYDX2yDh3y5dFIgmShXlSLr0bPgkhBxRai
	R8BrSeBHGxfpilBgBGkGP7P8akPNSos=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8efcef23d21so7631146d6.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784917972; x=1785522772; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pXz8gdKZyjeAUSJH5WauhE2Y5aZihjLOBIOIDBnII0I=;
        b=hKQt0EENftBdSpZN3uNNZzTTuzQ65jN975k67nmmjFVvrhMCZJ9ISiR81Wv38J1C2W
         Eipb6/WkqXPPiiqi8SE1ghVbeWjc71J1x6c/VV5u7zReHG86zfPDY8Gsg468+ixo8sc+
         BVduYFP9A0Oador1xJud/KdoxRMXX1/HdGUueslooxaHpIe4ibDvWXMPh8flKAoMN43L
         Nw1BdyFvazqRv/l2mYP70RBLsn5ycyGPB3DY3eu5Kt4UBEtCdSjbnXk1ecBM5/azM2EO
         GdoNBztqQYknm51nXxkQyYVXWBCsOYepTHiuvaF5b4Oqcx7U2yFhc7kqxi083Mgnfdwx
         qduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784917972; x=1785522772;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pXz8gdKZyjeAUSJH5WauhE2Y5aZihjLOBIOIDBnII0I=;
        b=d6zgP7e4AVeIWNat3QAqrly73uHSws4qdlynGvfsmtSPuccqVdntKhRbt7ROVyR1SV
         pIGmWvfajAnX+0HY0PXprPndhHnxz6UXgQAIy7EKjqZy2IWgamXwF4MKGY7sX7vbdYAv
         mPoqn6Jrvf/Fb6e2bDyvSfaEitkwAH88KvrWFewTS2VqtHZpB4Nbk6ru/0povVly3rMu
         GAFdc6/86bIOkXz1KaD9hrZGuK6YUTBa/jB8aWgGqDSwzmLimnkSkr/qG87BrvqCH6Q2
         1kFnA1AuKLW23cfCLuWn+zgFD1sdASg3P13Gh+hvq0Kk55SS92GOCp97rmdxraN4oXJn
         W1Hw==
X-Forwarded-Encrypted: i=1; AHgh+Rq+ipF7dfR7ZXU5O3cd5J0d1d6ZoozsX1chsPPusa49n3oQy8cdpcrH4UnzgfgVvCZX3RLAhhC5RQ==@kvack.org
X-Gm-Message-State: AOJu0Yxr0+DUUuI9wAeT3DMibJnwiQpoFo2cfzy4wuGUG7O+C0m5fW0z
	nugl8b8e6WVxY5E5ihc9vwNvpqsHimz7Eoj5HIJ3UwX3DahAcK05lWG2bx04arN6SvM=
X-Gm-Gg: AR+sD10osMBMP46DggHLUw6+p74VnvRbdOBgT8l0phQdG3XLHAjnVf2iu1l+gYeYzlc
	UY4XuHxhd2d3KlIO7jM5nhD+X5x8CHlx6rYrVtOmf/BddKaEssyec8OqqYXWkIKcUrVznaSeXLV
	VLDEM+CFeRtuarJ4TfLAyVtAkGKmA/B11ucmPAkP3YWLYOWjEf3WxbuK6aCQkHlpX+SeL7VkOyR
	mLsEbFR2VSS/RFpsTAcn7mPAcnJTCULqEuwwyVM7CPkF2dsoz/uk29+ZpXh1bJ0rAJvRHZdBF0/
	cDlE1IcXi4T4jdwhkKrdD94rT+tdUYJAPIBLGo1cvMMHKh62iDS/SjnE1pss98Zrm0Ry+LT23Rl
	vb68fVI30WHQ31WAINj+g1j6fDJx0wIWHurGB1oD6FIJSHjWVZagdH8rhXYqK2jzCnC/XqOmnfs
	8t
X-Received: by 2002:a05:6214:5191:b0:8e9:f62b:bee9 with SMTP id 6a1803df08f44-907ca8df69fmr99553356d6.57.1784917972296;
        Fri, 24 Jul 2026 11:32:52 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e85241e7sm4261406d6.8.2026.07.24.11.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 11:32:51 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:32:48 -0400
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
Message-ID: <amOv0MlF1S-oFZHX@cmpxchg.org>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
 <amK-ApfqfwkPheC5@linux.dev>
 <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 90AFC140008
X-Rspamd-Server: rspam01
X-Stat-Signature: w17b4xtekr56563rsqwzf3qysaetnrqz
X-HE-Tag: 1784917973-415499
X-HE-Meta: U2FsdGVkX18Uo5XXjfJJxA/T39JHrRIFVc6g1zAB4aQSRGQCc1IPfSip07tY9ikfETRsZIn/Soz5Wajk6ujcbhlbKVF7FQkc4ut8RsxsRxwJgDFNvetX34GldUUsT2cSszLuZIgkAASLSv/jLHftDWv6g55QXCiFbS8kO4NYefJl3fzcSU/7M/dYElwmao9XTe8WM3dE7/k0kPXG+oRCwwuWG0xzxKZ0e9VnZ4u9ZpbQUhKpZDxKscx3AmSe7eciO89IWKNRvqk9ObI0VbaaQahMAWkyd1ME+sCTuWqB/GeZvR/s/iGRWTXbwNplgaJEdMe3GFRKUVQOXvhlL3XsPHTavI6t8NkZXpWA52AHDYG895IOF7haMLvAQd0+lp797J28Tv3XJ657AcTqmcmGL6x7HfOajWPeIrDGmuKHhslsSpH3meNBy0vaqO3L9yPtneayLidERCoVffq+qHcBqwWRQ2lCqNAV27Fhh3SMoihL1BDiVrendMiM1xmyOXZC+vzDJ3ljw2GoXSYAfMmrvj9dSoB8TE5bjBx3k/G3LfhMVwQ2G1VhtwZaonOb9W+we8WubWb2s6L+lbXh7vtz2eT1hBKsvXEjIvWIcCVQAkgqgyuOMYx2jMEvPiFAwo2mfp+13Nk7QHMB+0vDuazujWp/bfz07IUdrfwUAN8aHUeDpIkfzxW4HLFP/yTXnyE1Vd86St463s8ilbX2VW3ZWOTs5aGAnkAy2zOj25R7FGiu9Hpj7LLqWLln2MMVTTl3eizEHGJnT0KjjeJFlvOFVTaPTRWTGmM+w7/rohWiFqLS5UPflWaFN1+u2j5JyVLqIR+0CNoyTBvyL2z3fvqmIsUeuwSO/oYqwP8r/RfnqeD7NqnxrdmcCpbdkgKwEVxYxUrf60CFqNkGUNDBOVe3Ibsx93kU+IOI4lV6P3b/+QO53azd7LSlLvtQnJrZVuwtC4E8PfR6YKqoxpN+lq/
 Gb6iF6uH
 iWWP+m58bIBPXPFVD75N87w/J4AYyjs7Jw4+cCP1XX9XXlK0HZTfxCOEMzd8hQTs+egbsYJnOTKoTmZNg/aE280g4PxOJKYUtjxF/BJICHQStNbWD94AsW0Ez4KzYG6FRVcMOjv36VN3y5XMha09ukHp02rSZBW+QpL7fm/nkJ3kz05EmWdUFjUrNgnFiooqOo36msC7tIfjW16viSrixr4mEqevPc9pLk7+aESF/2BRmJ1Y1oj5ZxU0p7FNHU/65qwDL5s575VN18jqDjyoZwPp4VL25M0RJOxuGKoFwgEkZW5wuKJjpeoRQ6qle4h/h6RbizbpFqGvGlcPGoI2DLneDHPhn2oU4EipCYDXH03G77ExiLxJXHGx5PnT5RGYZtEM3H5GIs66HaxnLM1eKjxEKeWpWQXTxhwcG08858kgJeYrel5Ji8VPi4OnRRfeE5pknffhJB8vyMhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 02:29:23PM +0100, Usama Arif wrote:
> 
> 
> On 24/07/2026 02:53, Shakeel Butt wrote:
> > On Mon, Jul 20, 2026 at 09:41:23AM -0700, Usama Arif wrote:
> >> The anon/file scan balance in get_scan_count() is driven by two scalars
> >> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> >> producer under lruvec->lru_lock. The acquisition sites for cost work
> >> specifically are:
> >>
> >>   - shrink_inactive_list() re-takes lru_lock at function exit purely
> >>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
> >>     nr_reclaimed). One acquisition per inactive shrink.
> >>   - shrink_active_list() does the same with (0, nr_rotated). One
> >>     acquisition per active shrink.
> >>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
> >>     purely to record the refault cost. One acquisition per refault.
> >>   - prepare_scan_control() takes lru_lock just to snapshot the two
> >>     scalars into sc->{anon,file}_cost.
> >>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
> >>     re-acquires lru_lock on each ancestor to propagate the update,
> >>     adding O(memcg-depth) acquisitions per producer call.
> >>
> >> This hurts because lru_lock is already a heavy contention point on
> >> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> >> and folio_add_lru() takes it. The cost work itself is trivial (two
> >> scalar bumps and one comparison), but it contends with and causes
> >> contention for actual LRU manipulation. The parent_lruvec() walk also
> >> multiplies cost-update overhead by memcg hierarchy depth.
> >>
> >> Replace the producer-side accumulators with a read-side accumulator fed
> >> from per-LRU vmstat counters. The old producer formula was:
> >>
> >>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> >>
> >> Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
> >> already bumped by writeout() for the same successful outcome that fed
> >> reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
> >> this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
> >> lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
> >> be sampled per lruvec and aggregated through the memcg hierarchy.
> >>
> >> Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
> >> producer-local input. They are bumped from shrink_inactive_list() by
> >> nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
> >> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> >> lru_note_cost_refault() used to bill.
> >>
> >> Add a per-side struct lru_cost { count, last_rotated, last_io } to
> >> struct lruvec. In prepare_scan_control() the two monotonic inputs are
> >> sampled separately - rotated from PGROTATE_ANON/FILE, io from
> >> WORKINGSET_RESTORE_BASE + f plus (for anon) NR_VMSCAN_WRITE - and the
> >> raw per-side deltas are computed against cost->last_rotated and
> >> cost->last_io before the SWAP_CLUSTER_MAX IO weighting is applied.
> >> Extracting the deltas from the individual counters (rather than from a
> >> pre-weighted sum) keeps the unsigned modular subtraction bounded by the
> >> true per-counter growth, so a signed-long wraparound of any underlying
> >> vmstat still yields the correct delta on 32-bit. The weighted delta is
> >> folded into cost->count. Since one vmstat delta can cover many producer
> >> events between reclaim passes, halve cost->count on both sides until
> >> their sum is back within the lrusize/4 bound instead of halving only
> >> once.
> >>
> >> Moving accumulation and decay to the reclaim side also improves the cost
> >> model across reclaim gaps. With producer-side decay, events that happen
> >> while reclaim is idle still age each other before reclaim ever samples
> >> the costs. If a workload refaults a large anon set and then a smaller
> >> file set before reclaim runs again, the later file activity can age the
> >> earlier anon activity out of the cost model. The new scheme observes the
> >> whole between-reclaim delta and decays anon and file proportionally, so
> >> the scan-balance history better represents what happened since the last
> >> reclaim pass.
> >>
> >> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
> >> extraction, the cost->count update and the halving loop against
> >> concurrent reclaimers in the same memcg+node.
> >>
> >> Hierarchy aggregation is now implicit in the vmstat accounting. The
> >> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> >> existed only because anon_cost/file_cost were private lruvec fields. With
> >> the cost expressed as lruvec vmstats, rstat propagates the underlying
> >> counters through the memcg hierarchy and prepare_scan_control() consumes
> >> the same ratelimited rstat view as the surrounding reclaim heuristics.
> >>
> >> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
> >> no longer needed and is removed.
> >>
> >> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> >> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
> >> The reported values only refresh when prepare_scan_control() runs and
> >> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> >> they express is unchanged.
> >>
> >> Under pure MGLRU the scan-balance signal itself is not consumed (both
> >> prepare_scan_control() and get_scan_count() are short-circuited on the
> >> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
> >> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
> >> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
> >> either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
> >> evict_folios() so per-memcg observability of rotation-driven reclaim work
> >> stays consistent across both implementations.
> >>
> >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > 
> > Oh man too long commit message, please follow Johannes's suggestion.
> 
> Will do!
> > 
> > The patch looks good but I have one question. We already have concept of
> > pgrotated through /proc/vmstat which represents number of pages we have moved to
> > the tail of inactive LRU to make them next reclaim candidates. This patch is
> > exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> > the number of pages we scanned but didn't reclaim plus number of pages given one
> > more trip in the active LRU.
> > 
> > Older and newer pgrotate metrics kind of represent something different. It may
> > cause confusion. Now before suggesting to change the name, let me ask do we
> > really need to expose these to the userspace? How exactly users can use these
> > new metrics? I think you can use them here without exposing to userspace. So,
> > does it makes sense to delay userspace exposure later when we have a more solid
> > usecase for that unless you have it already.
> > 
> 
> I do think the userspace counters have diagnostic value. They can be another metric
> to show how much anon/file reclaim work is spent on pages that are not immediately
> reclaimed, including pages retained on actie LRU. It could help explain if there
> is elevated reclaim CPU usage.

Hm, this is an interesting discussion.

The existing PGROTATED is kind of useless. When it's bumped:

- truncation fails and moves folios to the LRU tail for faster reclaim
- writeback ends on folio that was tried to reclaim, moves to LRU tail for fast retry

Ok, who needs to know this? The new counters you're adding, on the
other hand, they capture the information you frequently need for
understanding reclaim behavior.

That said, looking closer at this one more time, you can already
(almost) derive them fully from existing counters:

drotated = (dPGSCAN_ANON - dPGSTEAL_ANON) + dPGDEACTIVATE_ANON

The first two are already split by anon and file. The third you'd have
to (1) split by type and (2) stop counting, or have a separate event,
for MADV_COLD driven deactivations.

And (2) seems overdue anyway. There is no point in maintaining counts
for what userspace madvises. And it adds noise when it gets conflated
with a stat tracking kernel reclaim behavior.

