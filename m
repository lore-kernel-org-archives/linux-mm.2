Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34ED2C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D53E6B0088; Tue,  4 Aug 2026 13:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385A66B0098; Tue,  4 Aug 2026 13:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D356B009D; Tue,  4 Aug 2026 13:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDDB46B0088
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:17:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B6241A028B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:17:14 +0000 (UTC)
X-FDA: 85064242788.26.1B08867
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AAE2140010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:17:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AwBfps2x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785863832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J19P9P6+ypat/OvYRKtICP+Obahh1CzQhSviP26PwVM=;
	b=26R+KOAOXxc+DXM8FS+snNpJ1mjUWVE5KvECR5uBI/vMLFJ59pgGZFh9GgytDKedXJWAx+
	hEnA7T9c++Jz4bH/y+FzaXHcbWu8+VOQsAvsPwcepH3Wiqf7b+ReMcrkkzwrHvdYb9UYly
	RG8MKJmD9K6rm6v3f3o2wXUu7Og0Xnw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AwBfps2x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785863832;
	b=nu6vD+fwBoLnVIHYZvSV9EFPVFXJlugc2Iulqt6QuY/Cpx4MrMFNbg7qlx9TqJZXkTEgYP
	et3d/0+8q1sd3mf2k9HWAEK4DO5dbVrhsQa52F6Sye3O4rh0er1QEcWom62zqk84qWSyY6
	V/u3z8+whyUY+mES0/i0PDqsRQcjYTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E94C543657;
	Tue,  4 Aug 2026 17:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D601F000E9;
	Tue,  4 Aug 2026 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785863831;
	bh=J19P9P6+ypat/OvYRKtICP+Obahh1CzQhSviP26PwVM=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=AwBfps2xwIykpE1Z2NV6S4OZDKZOxIC4vaRgBzCHqVlRGKyU2UJHFFDDTNZ7o2sza
	 frhAZK+MTE0MsyGoY1llOM3iJWO527/XtMoo0HE0HkjGpAiBtpNaex5sz8AAg0kkeT
	 SbepXc+0fw4p/vKTGYKwhHKayur0/FR+SO5skpa9HMNomgQUakdNWDpId3HaZyRc0e
	 ACHKKHrxYd5+IXQRT8DYBLlgIUgydvZ4byJHJEkTPlTCXtjqCpl3tRXxeHyja3PpQY
	 dXqCxEFlHQvdPQPRRw66sj6V6Tqw+za0zoN1znkD+myqYRSnKpSs/JsHPSYzTO4vHG
	 OR5N0J8xIV2ow==
Message-ID: <f2820a92-a694-4dbb-90b3-503a83b7eb4c@kernel.org>
Date: Tue, 4 Aug 2026 19:17:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, rientjes@google.com, kernel-team@meta.com
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-4-usama.arif@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260727162550.2032-4-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: cjriwrsuty3363ee46njxhw38m6eq8yq
X-Rspamd-Queue-Id: AAE2140010
X-HE-Tag: 1785863832-798246
X-HE-Meta: U2FsdGVkX1+EjHIDtlHe9Tu/7IN2Gx94i72HaAEURtUA/h5yWxMVAuKCjP2KSoee/cA0OLg4IlPPuONalvv6a/lkki03lVQQDWWOHnF8RrPzwWAz1HWgLqzxQ75bdVhSbW7X5FlakvHguErtOxLwl/psmPpkJ0RcpurI5RzHhSAX0zGwb/xNQ5GygRwpKmoKbKD4E0gINEmhAiV+/3xfjAzsc3tAqsAFwVEe7XsYQ18hkSYwxUhpGKuN8HSUuTfUoF74VYXpelzUhGd0bLq5+5x2wrmwjy7jnj7jQEfBg8gVJi6Q8P5Fnp+4NMSfJ33scIeHRUBGY03U3GRNIUNsvAAI0KegfU+g6MoiU3szqn/KwhdtUZDXG1/ISdJch9Mahe7p5UBrNcFE4PqqhsOBzVEJGSXNvmfTDkLreE4Da0f2cyYNthnR7bhzixuHt0Th504fIkjbBE6CDZJi3wBuZeubRFzqOe+Q8f2jNY2eHbt944oUM+psE7l1BtHnqhZoDIV9+mNnYMP+sG054g8VOm9GwBIpm0Je/MIEhTygujaLi0nMXlcxvhdouuLXUB2qA4cjzQGReIjUFKjAcTZ9NM+LiK2kVQ4veudhP7D821+sbNzTkrglpVaOxYez/PGxIawHlTps2uGiX71gUQ3REiCG8RqQ3sbSt8RDXU4mYQwd+ZBxMOuPw97B8k3lfy3FsFa7oQK3a9YrAhhk3HIPr3Gtl6cZ7TWvK7vXegilouSLmph7UjBjobHVlhMJIOoUO7qums/0UZC6CLdMUuv8cB4slGxQaLJ6o8qazqpT3oYrmAq/C+cfyEpBKPHWAUejl+g5nRh+uCNdPdZxWwMzWp+I65VBc/BYqtk2meebXK1n6wcsCgE8qyzKu0SwzFflEUFH8AMa9v6gyjT6u7ycT1EeomrmUGS+D3qUsXqDyqjtpTC4nlu6bNYS+Kg+MHPS2Oz5CnEghLieCF3YG4E
 CG3huRGz
 e2lJBaXEeD4UfwMtC4ptNY9izxsqbI2R7ZMj2MAM8PG86IfLhv3iM7TrBm6mlCm3WvbLvZ47EbqDbhM92n2mah6I1h59vpEcRk39KII81LV6dMss/gqlMkjzezuH0i3GVTR6/ARffDft2n+8LVZuqTvp1HLf19OW5TJ7hlI+L1qel3O8bzCXc0LmBFcofq8wLn2VviVzHfhX7IvACytqngO9FF3ompSoYS+K+ThdlaLOraRnn4sRiohxHeLgAolJop/Uvcuq3tq1XFH48e1W9L0X9tBiboa4lTMM7LNRd3xFI7hnJxM8k3DidrhGcDaNP9ZN9gQ9tCA6Ak4C402zHtqnDEm2L3/WsAPTHk6grBOgqcz7mb6MmcqIweWsAsdQ0+iV/hQB/OhEPEyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 18:23, Usama Arif wrote:
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

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


