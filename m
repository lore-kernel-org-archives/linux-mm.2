Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C3F606A320
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7216B0503; Tue, 20 Oct 2026 11:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F906B0504; Tue, 20 Oct 2026 11:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBDE6B0505; Tue, 20 Oct 2026 11:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03F636B0503
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:52:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91EC4C02AE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:52:06 +0000 (UTC)
X-FDA: 85343445852.20.9DDD267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0F8FC000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:52:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792511525;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F4PgIOIOdxD8OVxXY3JsTmivlXUupfdYHiqTfKL168I=;
	b=KjRAkew3bfDX/IlA2NzVL6Sx1u90zv2eM1qJSZ8a435Hi5c89JzWmpqKim/t8et7OoXzJd
	W+e74nuqmPH110tz3gi5GdFe/6V7vyn3kSRHhcqpnqGZZpMyu/7uwZ547kSOG9lErTalD0
	ozu/b3PaFTw21zWWp2CQT0AA/7KhuHs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792511525;
	b=rNNRmpyW4I0gTTyX+tj62V8LfgsVU0NqsqiIwggNS4tWV9UnC893YHmQyXPootybJtyWx6
	tDC92h4lwGUYiGxUHc2zieN4eqq6u6tZG2QhfFnID+TUfRR3xAx2QJfzGRM9xycz82sJLF
	3oxlEnuhGSVPyx256YkrPFJVKO8MO0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E860403F0;
	Tue, 20 Oct 2026 15:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEFB1F000C4;
	Tue, 20 Oct 2026 15:52:01 +0000 (UTC)
Message-ID: <sashiko-outbox-179304@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 06/18] mm: free the pages waiting for a grace period
 before OOM
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R . Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E . McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Harry
 Yoo" <harry@kernel.org>, "Luis Chamberlain" <mcgrof@kernel.org>, "Ilya
 Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261019154913.1765974-7-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
 <20261019154913.1765974-7-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 15:51:30 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F0F8FC000A
X-Stat-Signature: cye1iq6miadhrdt4wxhhh8ot7wh4iuau
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792511524-849556
X-HE-Meta: U2FsdGVkX19Qgp+ZMaxNeninVxoGmSVjTRWxGs7vG83rIfXpuEqP6xHg/2OW+ZwZ7YY7HmVM8VsKuA+oEMOpKyJpVmcdgqZkBjyG6FQzzeJdcOUVMPjAVFEpm5nSh5/mBdDBpIGn0vsDbAwRRpdfBk1ohXFRwIO8mItWdQ5YpqW8r7/eqTvN+sWlEgt5dnD8RVstNeZO7cIjkDx3AUoTXTXAME2l8yuYuHHLzJnenHa2OHRE8kQ0/Z/PDNCpLvuELDBuWOA5h5IDHv1LMiHv3wZvtYpDfqv9uAv95LpqewgnTGK3dBtC7d/QMWBscHXQf/jSVegIWpBrWINP5WiSEdTxR+6onwXOg2yl9xO99Q0BH+X6EGABsH/yDZUP3OFhrlZeO2hECRndwlcNYzEFn9DOy6Gf+0U82Y6Z1aMI15DcEWWLnf4WOBIfcT0cxqG8dwHSO1ETWyQ6Ri4IQ0JD+QBW28AwdYSVR2OBjxrHzCB0QUDAo9i8yu/AshyhtziFy1tpvnoQ/vZv/Y2zbzeRyiNO4wdneTDfQp6YONyymsurG6m8hMuqeZeYFUcXTU0rx2C2KRo8+CHd5I/NU67ueNC7AOaAkV/Z/Hn5QO8cp1JrldVvG7jvc1g/z7BCR7+Gz4fcWR+0pwJ2JcHrmLF4T3kKIJjyikNUd1heeHr0sDVD/xYxyZhVx+sTc+N82ppBJ4/pGfeF+GvlpLeQRVQhZXWbbgm/eDfCtKM+mKXYjLJhgs4gpocgnUk5gKqOli2Pf2riFDEPMChjT+i3wusLtRfpW7Whx5GDX16v1mZvmXnxweGiSkGz0HFPCTxwru9Wja8bJ+I5Lri4Z1r3nVtE2AU4+XSmCWWLNiZB8tlw39j31ohmJN/dtaa//QJcP3+BeYb2QZsYpbPtFtEgD4g5HsCJhfZNsAqMpn3T9V1OTeCQ48xJ7Kl+d2HTsZbBOBIXYR+7nD9NkMx1t6ERX8c
 kpjrZdRU
 i4NkK5uQUlWxZv+dwejVYDOFoBGzf/MqV9Er3HxgL/v+yXCiGdNtXz2nq5JB5J1s+kVKVTnVY/lqOr+2j8U0twMl3sMfFaERjc5WxFp/ljWBhij6bWDKwJ5q9ybzVOo7kSxaWfmssVwcgyNbiLkZWa9lzx7r7EGkT+FDTf+M+id7uQSTpzBkldK0r1yRD/scjn+US8XbY0mY54a92tQXqzga6QaBqqXnXkecaz4LqzU+Ai3LFnon0Ykg7e/39gzxMIknU4AIDQy8Ail70gj1T5DOmqsH3Xdb32MLVq0yxU5YlIUdVtlwFvzEQhkgOAW3okLMwBbR5o2LJYrJ7j5fjZf8YVOhnpvLanHro7KGKx9JF+actEnyvPUof9/hBtkapIGs7nYe9U+o18tdOV0aGuVxUhDAB/qiUiiqfshThqojJyjIQm2HR/CWOU51GltJd7F7OBctGNUUzl20fYZoP2S7mm5puHQnFNfXVp3E9N9FWYbUWp9tJHZCQUbcegNIUNiWeRTfWkNbPYDIHfMaRadmPQtw9nMjK+88fiqkx+zm2FThlKJhQHtjYq3v42jM6o/kvnQw4MQoJae0gFU/Dc7vGwkxcedH6Jma0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] mm: rcu_free_drain() fails to wait for in-flight RCU free workers
- [High] mm: rcu_free_wait() passes high order to __zone_watermark_ok()
- [High] mm: should_reclaim_retry() splits reclaimable and RCU-waiting pages
- [High] mm: rcu_free_drain() leaves freed pages on PCP lists instead of bu=
ddy
--

commit 7de2bde642756023a3c02e6554282a28f501cd38
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm: free the pages waiting for a grace period before OOM

This commit adds rcu_free_wait() and rcu_free_drain() to
should_reclaim_retry() so that pages deferred for an RCU grace period are
drained via an expedited grace period before giving up and invoking the OOM
killer. It also introduces the PGFREE_RCU_DRAIN vmstat event to count drains
that freed pages.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a9058d414f92d..bec9128d80db8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1445,6 +1445,29 @@ static void rcu_free_defer(struct folio *folio)
>  		queue_work(rcu_free_wq, &r->expedite);
>  }
> =20
> +/*
> + * Free what every CPU's lists hold.  A concurrent drain holds the lock
> + * until it has freed what it took.
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
> +	if (rcu_free_flush(&list))
> +		count_vm_event(PGFREE_RCU_DRAIN);
> +	mutex_unlock(&lock);
> +}

[Severity: High]
What happens if rcu_free_expedite_workfn() or rcu_free_workfn() has already
spliced the folios off r->batch and r->pending before rcu_free_drain() runs?

In rcu_free_expedite_workfn(), the worker takes the per-CPU lists into a
local list and drops r->lock before blocking in synchronize_rcu_expedited():

mm/page_alloc.c:rcu_free_expedite_workfn() {
	spin_lock_irq(&r->lock);
	rcu_free_take(r, &list);
	spin_unlock_irq(&r->lock);

	if (rcu_free_flush(&list))
		count_vm_event(PGFREE_RCU_EXPEDITE);
}

Similarly, rcu_free_workfn() splices r->batch into a local list under r->lo=
ck
before calling rcu_free_pages(), and NR_FREE_RCU_PAGES is only decremented
inside rcu_free_pages() as each folio is freed.

Because neither worker acquires the mutex in rcu_free_drain(), a task
entering rcu_free_wait() -> rcu_free_drain() while a worker is in flight
sees elevated NR_FREE_RCU_PAGES, finds r->batch and r->pending empty, and
returns immediately from rcu_free_flush(&list) without waiting. Once
*no_progress_loops > MAX_RECLAIM_RETRIES, should_reclaim_retry() also jumps
to out: and skips cond_resched().

Can __alloc_pages_slowpath() then spin through all MAX_RECLAIM_RETRIES
iterations of rcu_free_waits while the worker is still in
synchronize_rcu_expedited() and trigger a premature OOM kill?

[Severity: High]
Also, when rcu_free_drain() calls rcu_free_flush(&list) -> rcu_free_pages()=
 ->
free_unref_folios(), folios with pcp_allowed_order(order) are freed via
free_frozen_page_commit() onto the local CPU's PCP list rather than directly
into the zone's buddy free_area (and NR_FREE_PAGES is only updated when pag=
es
move from PCP to buddy).

When __alloc_pages_slowpath() jumps back to retry:, get_page_from_freelist()
checks zone_watermark_fast() using NR_FREE_PAGES before reaching rmqueue(),
and when __alloc_pages_direct_reclaim() sees *did_some_progress =3D=3D 0, it
jumps to out: without calling drain_all_pages(NULL):

mm/page_alloc.c:__alloc_pages_direct_reclaim() {
	*did_some_progress =3D __perform_reclaim(gfp_mask, reclaim_order, ac);
	if (unlikely(!(*did_some_progress)))
		goto out;
	...
		drain_all_pages(NULL);
out:
}

If the pages freed by rcu_free_drain() stay on the PCP list and do not
increase NR_FREE_PAGES above min_wmark_pages(zone), won't the subsequent
retry fail the watermark check in get_page_from_freelist() and proceed to
__alloc_pages_may_oom() with those pages still stranded on PCP?

> +
>  static void __init rcu_free_init(void)
>  {
>  	int cpu;
> @@ -4792,6 +4815,52 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
>  	return !!__gfp_pfmemalloc_flags(gfp_mask);
>  }
> =20
> +/*
> + * Reclaim is about to give up: if the pages waiting for a grace period
> + * would bring an eligible zone above its min watermark, free them and
> + * retry.  Not for a dying task, which frees memory by exiting.
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
> +		available =3D waiting +
> +			    zone_page_state_snapshot(zone, NR_FREE_PAGES);
> +		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
> +					ac->highest_zoneidx, alloc_flags,
> +					available)) {

[Severity: High]
For non-costly high-order allocations (1 <=3D order <=3D PAGE_ALLOC_COSTLY_=
ORDER),
does passing order to __zone_watermark_ok() here prevent rcu_free_drain()
from being called when z->free_area[o >=3D order] is currently empty?

In __zone_watermark_ok(), the free_pages argument (available) is only check=
ed
against min + z->lowmem_reserve[highest_zoneidx], after which order > 0
requires an existing free block in z->free_area[o >=3D order]:

mm/page_alloc.c:__zone_watermark_ok() {
	if (free_pages <=3D min + z->lowmem_reserve[highest_zoneidx])
		return false;

	/* If this is an order-0 request then the watermark is fine */
	if (!order)
		return true;

	/* For a high-order request, check at least one suitable page is free */
	for (o =3D order; o < NR_PAGE_ORDERS; o++) {
		struct free_area *area =3D &z->free_area[o];
		...
}

Because the pages in NR_FREE_RCU_PAGES have not been freed into z->free_area
yet, won't __zone_watermark_ok() return false before rcu_free_drain() has a
chance to free them?

[Severity: High]
Also, should available in should_reclaim_retry() and rcu_free_wait() account
for zone_reclaimable_pages(zone) and NR_FREE_RCU_PAGES together?

When direct reclaim frees folios marked with PG_rcu_free,
__free_pages_prepare() diverts them to rcu_free_defer(), moving those pages
out of zone_reclaimable_pages(zone) and into NR_FREE_RCU_PAGES rather than
NR_FREE_PAGES.

In should_reclaim_retry(), the loop checks:

	available =3D reclaimable =3D zone_reclaimable_pages(zone);
	available +=3D zone_page_state_snapshot(zone, NR_FREE_PAGES);

and if that fails, rcu_free_wait() checks:

	available =3D waiting +
		    zone_page_state_snapshot(zone, NR_FREE_PAGES);

If the pages needed to reach min_wmark_pages(zone) are split between
remaining reclaimable pages on the LRU and already-reclaimed pages waiting =
in
NR_FREE_RCU_PAGES, won't both checks fail individually and cause
should_reclaim_retry() to return false while reclaim is still making progre=
ss?

> +			(*rcu_free_waits)++;
> +			rcu_free_drain();
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}

[ ... ]

>dari

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019154913.1765=
974-1-kas@kernel.org?part=3D6

