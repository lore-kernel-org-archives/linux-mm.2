Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F6B606A339
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eU0/+8ZS
Received: by kanga.kvack.org (Postfix)
	id 94C6F6B05B6; Thu,  5 Nov 2026 08:03:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925276B05B7; Thu,  5 Nov 2026 08:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8622F6B05B8; Thu,  5 Nov 2026 08:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 635C16B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:03:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CD311609F0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:39 +0000 (UTC)
X-FDA: 85401082158.09.25837A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id BCC368000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eU0/+8ZS";
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883817;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdqB/RGsrLA7sKG9xZRF8niksu12JMQ7l8bVShjk9+Q=;
	b=EGOnwh95kAY8PAualdcLpIxrS/f2BGBDHrmWlzgElFF6TwRpn7sm1Aanl4jf9BX3hNql6t
	k2tz2YmUsVrkX9LJejoeijFGlHmG+5LLFDDfhiEYksd9fyAwrIriTDE8NEOMvjIp2wa2Yz
	si3JLz+DGauB6gHirkoL+kPvJilO+ms=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eU0/+8ZS";
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883817;
	b=N4JjbOz+JeftXckofpfy0CjPQEPXFGb9+5x8BI7oDkbXAQQvhSHmkAxhmIU5jqOD24PDfY
	z+j6Q6WJgnmUPZP8XH7A94KnPXiZ0REbLHWZOAS6VUFHSBvvlE3DCS1AgPGLiph3cOWCfx
	llrIsDZNqgDrpBMn94vJd7xYpudAxho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EA2340347;
	Thu,  5 Nov 2026 13:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE3A1F000C1;
	Thu,  5 Nov 2026 13:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883817;
	bh=FdqB/RGsrLA7sKG9xZRF8niksu12JMQ7l8bVShjk9+Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eU0/+8ZSYcY/4DPL/gcQcTOLIyRFFFreR6ItEJEUuQaztwFLFCz41cQi2FD3qMcHq
	 6lBV+Y6UfVEZWsA+zlunUNDKn+BmozrYp1yPdKxviQW7cKQ6HvzxWIjkLQPsfxDa60
	 gJG+a1GwwDWSvLyxmo/GG6nV4uBVLikWYryPPPgU2vUKDkuR9wnUja29WoNfAko5fA
	 oeKu/RDTz/4uV8+QawCPPLcRb3iJFxQSWt9oqOd/9oM0279IUO94T1a+Bbgm42Sn3c
	 i0G9bt9pGo+GKckmERLx5QrT+b4TZHy6K3hIXQrS9rcgZmWLg00KgYyXEkBoGW+jhf
	 em1qF1j2wKmng==
Message-ID: <sashiko-outbox-199099@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 06/18] mm: free the pages waiting for a grace
 period before OOM
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Harry Yoo" <harry@kernel.org>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E. McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Luis
 Chamberlain" <mcgrof@kernel.org>, "Ilya Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk
 Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261104130118.2507513-7-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-7-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:03:34 +0000
X-Stat-Signature: 39jqnk4wpzasfbxrjp9znpsyefu1o63s
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BCC368000C
X-HE-Tag: 1793883817-928481
X-HE-Meta: U2FsdGVkX190LDQaXgEKihZRWQpsYIZVJp41u2mrMA/cwQNTOlM5P46YlsLpHwjDjA+nafTEImImRpDrj6qteWxWxx/hh00fqH0IUgXuRQ/Z6HXAjnDppaSt3tgUXnrUIJ16iR+CXr8/B/C15dl8aO08TgKcAM07MznjrIPh50GozBb7QJbsdDBb9oERvbArjt42HNTWrbtL4yFe//QODNRDfqAm86z97//152V/Vjb49YqKRsjF1HHKgw+FrldbR1a/I5ZRVY8YYjeZf1ukReorOZjym0jnqQLM+R3r4jLTuP2C+XqpusJItBeXTJNLKmr7epsQnsgkAbEeUj6d3HYC2XI5+3lpuazn/cfLYdKeb+kAi4DpfRkUczGA5SyvzMht1bDvdh6DiVjqS/AZ6FbY7pg6eIvhJD7BkMkOQUV8/Y+uQFbfaaV9DhdK7jy4tHWm6tEQvRc2qd7eLy5Up3luZ5rgDls8VqIgMcIBOcq4hOYGtlIQApcacZRECouCoUGKsfPKtZlOc7E0qm83fed8B3paRmT1ZxniAAkle4880GEratYhuJ7EVmXQIRYBRGSMl5SL89bntpN8Ds6OmtKiRlYJGwX8CJBeoQnqSBrMxGYywjPTlq9dCLruia/yC69/5TGA56nRwXGipP6Ih/NN5OOktdVaULxkN93QH4R9prpplQHK02ugInW07kgd8HbSFMwiqY6+N1LSX27VUIU9nXxIr3gXkKtoh40Ke53GJytTGQhLNq6tr8UHH6k43vjLFM/m7yEo97Zsxtua7j7+kAWs2tWbUVrHA8ILS/l0yrQdZwiOzpZaLZHR2bpaCRItuKAuC7xtTwe4kRiM8ARbtIO3AomHbm0AqSBD5Qup+a0JIyCTstg0BPlf21hd5TvBmRnZhMRs52HoOY3fEPsOz29aFEd6Jf+DNLbGF0HcPlyIik2d+vIF3uY74opgU8ZXZj9EXieK5cxpHTo
 qHHzOob4
 uDCcBhs6iumsetjBxpX9bb+/ZOAsfduLiJAcFNeRQqXqnXAH/SfBXmKY93lqhqUzWShPbu150dv5YYIT13PPkFpZ+4m5X1NS+/xfHevN+0wO8NwFseVitNejptqiGZxhKqPrb09WX9OSKnYgGPgFvTI20q3l47mfuUf2nGFWmoeeIvd+1LoXe48Epc9AgjoDdhKercbDtBk+E9YHDZM8FNJqGq8E9+9m1PmsGh08ngPg95Jy8znuIa6XGW+7g2e8czlAw4dJLCYU7Yj0pdvmABlGCUG4im6BclRKNw27NYKn9E+cttwRHh4nvND46vjZ+u0GuIDCuCIgCLeJChw2rs3kHJCgag4Qh/7zIXDk9g4/pis8nBsoYFyYHdB/icyb0EcAc8okegT5m8IkESCeSn2bGtLifUpZXmB/pGUuDejpUpUMnGu8XHdceKFCfaimh9mqzd/bW0e0b3X9iuLrNkFuube/wB+owt3sSgrErqg8dh2uEtn/ZTeP5LZUEZLwdW5ru+MwDRTzXgZ0A5yAbH1wVAtSmUH6cs+LZWToZwCztMpE7w7kpf6TDrDdcPCJeMTw9iKsF5qKFPlJRznRZoEqvk5EiP3oxHCgUsRxkfF/w7DfeNnDrSyRKcSkaV9M4iT3R8LaRapN/brHiiuw88z9f9d35amcmQsMBqfnkrDL/4Ab/SX0/A8nSt3SgFycPqpQLYwDmGhTy1uw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mm: order-0 check in rcu_free_wait() starves high-order compaction
- [High] mm: rcu_free_drain() misses rcu_free_workfn() and PCP-freed pages
- [Medium] mm: rcu_free_wait() counts unreclaimable pages after retry limit
--

commit 4b538833b03e67798c223181a1b410cee9126502
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm: free the pages waiting for a grace period before OOM

Before should_reclaim_retry() gives up on reclaim, this commit drains
RCU-deferred pages directly to the buddy lists and retries the allocation
if those pages along with reclaimable memory would bring an eligible zone
above its minimum watermark.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a9058d414f92d..9caaa57bf51d7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c

[ ... ]

> @@ -1398,7 +1405,7 @@ static void rcu_free_workfn(struct work_struct *wor=
k)
>  	rcu_free_start(r);
>  	spin_unlock_irq(&r->lock);
> =20
> -	rcu_free_pages(&done);
> +	rcu_free_pages(&done, false);
>  }
> =20
>  static void rcu_free_expedite_workfn(struct work_struct *work)
> @@ -1411,7 +1418,7 @@ static void rcu_free_expedite_workfn(struct work_st=
ruct *work)
>  	rcu_free_take(r, &list);
>  	spin_unlock_irq(&r->lock);
> =20
> -	if (rcu_free_flush(&list))
> +	if (rcu_free_flush(&list, false))
>  		count_vm_event(PGFREE_RCU_EXPEDITE);
>  }
> =20
> @@ -1445,6 +1452,33 @@ static void rcu_free_defer(struct folio *folio)
>  		queue_work(rcu_free_wq, &r->expedite);
>  }
> =20
> +/*
> + * Free what every CPU's lists hold, straight to the buddy lists: the
> + * callers want to allocate the pages next.  A concurrent drain holds the
> + * lock until it has freed what it took.
> + */
> +static void rcu_free_drain(void)
> +{
> +	static DEFINE_MUTEX(lock);
> +	LIST_HEAD(list);
> +	int cpu;
> +
> +	mutex_lock(&lock);
> +	for_each_possible_cpu(cpu) {
> +		struct rcu_free_pcpu *r =3D per_cpu_ptr(&rcu_free_pcpu, cpu);
> +
> +		spin_lock_irq(&r->lock);
> +		rcu_free_take(r, &list);
> +		spin_unlock_irq(&r->lock);
> +	}
> +	if (rcu_free_flush(&list, true))
> +		count_vm_event(PGFREE_RCU_DRAIN);
> +	/* An expedite in flight holds pages it took off the lists */
> +	for_each_possible_cpu(cpu)
> +		flush_work(&per_cpu_ptr(&rcu_free_pcpu, cpu)->expedite);
> +	mutex_unlock(&lock);
> +}

[Severity: High]
As reported by Sashiko on RFC [1], what happens if the pages counted in
NR_FREE_RCU_PAGES were already spliced off r->batch or r->pending by an
in-flight rcu_free_workfn() or rcu_free_expedite_workfn() when
rcu_free_drain() runs?

First, rcu_free_workfn() splices r->batch onto its stack-local done list
under r->lock and then drops the lock before calling
rcu_free_pages(&done, false), which decrements NR_FREE_RCU_PAGES one folio
at a time and can sleep at cond_resched_tasks_rcu_qs(). Because
rcu_free_drain() only calls flush_work(&r->expedite) and does not flush
r->rwork.work, rcu_free_take() can find the per-CPU lists empty and
rcu_free_drain() can return before rcu_free_workfn() finishes freeing its
done list.

Second, both rcu_free_workfn() and rcu_free_expedite_workfn() call
rcu_free_pages() with direct set to false, which passes pcp_allowed_order()
folios to free_unref_folios() and places them onto the worker CPU's per-CPU
pageset lists rather than the buddy lists while decrementing
NR_FREE_RCU_PAGES to 0.

On the subsequent retry in __alloc_pages_slowpath(), pages sitting on PCP
lists are not counted in NR_FREE_PAGES, and __alloc_pages_direct_reclaim()
skips drain_all_pages(NULL) when __perform_reclaim() makes no progress. On
the next should_reclaim_retry() call, NR_FREE_RCU_PAGES is 0 and
NR_FREE_PAGES is still below min_wmark_pages(zone). Could this cause
__alloc_pages_slowpath() to proceed to __alloc_pages_may_oom() while those
freed pages remain stranded on PCP lists?

[ ... ]

> @@ -4792,6 +4826,58 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
>  	return !!__gfp_pfmemalloc_flags(gfp_mask);
>  }
> =20
> +/*
> + * Reclaim is about to give up: if the pages waiting for a grace period,
> + * with what reclaim can still free, would bring an eligible zone above =
its
> + * min watermark, free them and retry.  Not for a dying task, which frees
> + * memory by exiting.
> + */
> +static bool rcu_free_wait(gfp_t gfp_mask, unsigned int order,
> +			  struct alloc_context *ac, int alloc_flags,
> +			  int *rcu_free_waits)
> +{
> +	struct zone *zone;
> +	struct zoneref *z;
> +
> +	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
> +		return false;
> +	if (tsk_is_oom_victim(current) || fatal_signal_pending(current))
> +		return false;
> +	if (*rcu_free_waits >=3D MAX_RECLAIM_RETRIES ||
> +	    order > PAGE_ALLOC_COSTLY_ORDER)
> +		return false;
> +
> +	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
> +				ac->highest_zoneidx, ac->nodemask) {
> +		unsigned long waiting, available;
> +
> +		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
> +		    !__cpuset_zone_allowed(zone, gfp_mask))
> +			continue;
> +
> +		waiting =3D zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES);
> +		if (!waiting)
> +			continue;
> +
> +		available =3D waiting + zone_reclaimable_pages(zone) +
> +			    zone_page_state_snapshot(zone, NR_FREE_PAGES);
> +		/*
> +		 * Count pages only: for order > 0 __zone_watermark_ok() also
> +		 * wants a free block of that order, and the waiting pages are
> +		 * not free yet.
> +		 */
> +		if (__zone_watermark_ok(zone, 0, min_wmark_pages(zone),
> +					ac->highest_zoneidx, alloc_flags,
> +					available)) {

[Severity: Medium]
When should_reclaim_retry() reaches out: via the
*no_progress_loops > MAX_RECLAIM_RETRIES check, direct reclaim has failed
to make progress 16 times in a row even though
zone_reclaimable_pages(zone) + NR_FREE_PAGES was above min_wmark_pages(zone)
(for instance under GFP_NOFS or when remaining LRU pages are dirty, under
writeback, or pinned).

In that situation, since rcu_free_wait() still includes
zone_reclaimable_pages(zone) in available, won't
zone_reclaimable_pages(zone) + NR_FREE_PAGES already exceed
min_wmark_pages(zone) on its own, causing even a single waiting page
(waiting =3D=3D 1) to trigger up to MAX_RECLAIM_RETRIES additional
rcu_free_drain() calls and no-progress reclaim loops while also skipping
the PF_WQ_WORKER sleep in should_reclaim_retry()?

> +			(*rcu_free_waits)++;
> +			rcu_free_drain();
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * Checks whether it makes sense to retry the reclaim to make a forward =
progress
>   * for the given allocation request.
> @@ -4805,7 +4891,8 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
>  static inline bool
>  should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>  		     struct alloc_context *ac, int alloc_flags,
> -		     bool did_some_progress, int *no_progress_loops)
> +		     bool did_some_progress, int *no_progress_loops,
> +		     int *rcu_free_waits)
>  {
>  	struct zone *zone;
>  	struct zoneref *z;
> @@ -4816,10 +4903,12 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned ord=
er,
>  	 * their order will become available due to high fragmentation so
>  	 * always increment the no progress counter for them
>  	 */
> -	if (did_some_progress && order <=3D PAGE_ALLOC_COSTLY_ORDER)
> +	if (did_some_progress && order <=3D PAGE_ALLOC_COSTLY_ORDER) {
>  		*no_progress_loops =3D 0;
> -	else
> +		*rcu_free_waits =3D 0;
> +	} else {
>  		(*no_progress_loops)++;
> +	}
> =20
>  	if (*no_progress_loops > MAX_RECLAIM_RETRIES)
>  		goto out;
> @@ -4872,6 +4961,10 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned orde=
r,
>  	else
>  		cond_resched();
>  out:
> +	if (!ret && rcu_free_wait(gfp_mask, order, ac, alloc_flags,
> +				  rcu_free_waits))
> +		return true;

[Severity: High]
Can this starve compaction for non-costly high-order allocations
(1 <=3D order <=3D PAGE_ALLOC_COSTLY_ORDER)?

In should_reclaim_retry(), the zone loop calls:

    wmark =3D __zone_watermark_ok(zone, order, min_wmark,
            ac->highest_zoneidx, alloc_flags, available);

For order > 0, __zone_watermark_ok() requires a free block of at least that
order in zone->free_area[]. When a high-order allocation fails due to
fragmentation despite having plenty of order-0 memory
(reclaimable + NR_FREE_PAGES > min_wmark), should_reclaim_retry() previously
returned false so __alloc_pages_slowpath() could reach
should_compact_retry() (to escalate compact_priority toward
COMPACT_PRIO_SYNC_FULL) and relax ALLOC_NOFRAGMENT:

    if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
                             did_some_progress > 0, &no_progress_loops,
                             &rcu_free_waits))
            goto retry;

    if (did_some_progress > 0 && can_compact &&
        should_compact_retry(gfp_mask, ac, order, alloc_flags,
                             compact_result, &compact_priority,
                             &compaction_retries))
            goto retry;

With rcu_free_wait() checking __zone_watermark_ok() at order 0, any non-zero
NR_FREE_RCU_PAGES count (including pages just evicted by direct reclaim
itself) satisfies the order-0 watermark check whenever order-0 memory is
already above min_wmark.

Furthermore, because __alloc_pages_direct_reclaim() sets did_some_progress
whenever it reclaims pages or sees sc->compaction_ready,
should_reclaim_retry() resets *rcu_free_waits =3D 0 on every iteration.
Doesn't this cause __alloc_pages_slowpath() to loop on goto retry via
should_reclaim_retry(), repeatedly firing synchronize_rcu_expedited() in
rcu_free_drain() and reclaiming page cache without ever reaching
should_compact_retry()?

[1] https://lore.kernel.org/r/20261019154913.1765974-7-kas@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104130118.2507=
513-1-kas@kernel.org?part=3D6

