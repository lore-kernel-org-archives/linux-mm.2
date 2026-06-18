Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8154CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 06:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9376B0088; Thu, 18 Jun 2026 02:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5692D6B008A; Thu, 18 Jun 2026 02:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430B76B008C; Thu, 18 Jun 2026 02:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6CC6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:57:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 778F7C2B27
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 06:57:12 +0000 (UTC)
X-FDA: 84892126704.11.02736B3
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id 736E440009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 06:57:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xQxAoqXs;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781765830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dqf9F9qHuC8tR8KMxMvYcvcyUdtxSSOksnkUTOeNUHE=;
	b=xPRsuAyh0mQkGAy+WAIwh8XcMTnNlMdzG+q5xSCSF22jchSotzBlN2jir+TlQE+yOe3mhZ
	6yfDVnXDQyf+IT1+NHd3wjcppdvEJ5xG22a/gIa3r6l/4EE99Q+55ui2ZZz86Y+0jrDs5C
	kBko9Y+xjB3sBpA7AypNyJ3CyThZsLk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781765830;
	b=R7qs2F6cc0fL7Kr4Agnd4XncYcZuatGcRlm4MrDd8wagnP564Sz/ho3RxJIlsmZF7o2b4d
	qRNaLRti8AA+jBUOSH/EF3DL1Tr3gKC484Sxl3rZNcQZgJMwDFPYFphff6S1M2CRe3xdKF
	yMvuojAqwzy5HbZrz3k24mpLJNRwjSI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xQxAoqXs;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <692d9bfb-66ee-448c-942f-a26c07a19f61@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781765826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dqf9F9qHuC8tR8KMxMvYcvcyUdtxSSOksnkUTOeNUHE=;
	b=xQxAoqXs/W9q4rZApfMSPyA/JPEm2KeCtY+54x71cpmxYh8SAE+RnYHh+EDN3FjkuFSsiR
	r1XqvGIrFlK5kKKIB5wRS9KkklVMlU2PmxSp4aq9SVmyuk4UWf85I4yqK1gZnM49WK5NlC
	LtsLKUb9Z/NBfss4uX6nD5TZrc9Ljes=
Date: Thu, 18 Jun 2026 14:56:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 736E440009
X-Stat-Signature: ob716r3phpshyarm9gcamn1u1wxwsrb4
X-HE-Tag: 1781765828-215168
X-HE-Meta: U2FsdGVkX197SeNxnYaoOZFSS+2lbOwotaTOLGUKGeIckavFnkAMgA3gKB5By0BTJTAiP2aTN5UJigNPN1z5C5nTtCcw1esiRAqfgJ+aMi/5Jalv0FEIOyWUc2UAI83EqLMjA4geKBOnop85ecrI3PIeZg9NF40A8/hTKE6JUDl79ZNHtYssSwbsagmHacHkJuj90kClVSY/oTi35GOEvmJVczch/CzvJWT4++QOM617Uiw13Z+smpaMjvzYmAXOVaGS8zg8BiLU+uWQwmreW0pEAIRNo4a1umoc4AX0NV5rp2rHDARP31c0OF97rv2VorFOwrmF1PacaSYC2AFzJCMYSYZWOwbnX97QUdog5XdT6VPwImd5lGYf8NtdUoCZJbF373CqZOPuBLkuGuKXTLouE4Ee5qLzHsX29q9/a5vmD1+mW1ca563+2zOOj/6865DwEkPE1bh5+4pzD9z/PQF0Q5oONvggCLummkPlLa9N+KZYr/2na40GYcGOXYptZvOIXTiFSBtO5KnW4rqQw5zsM+Rwz8gWfygxobrJcd3094cWWX/tzPwKIlXGsB2Ljzg6I2X8ydp5IzRyVw3j5Qezdx42NRQWzPD4/n1nXTgY9On7XLTkSKEl2vsa1Gc9RvqsgW9c4uXnx+/FE5BjaoYnpbZqZjS3s5o3TJVXIzC6/3rj5dI511XkjogiQuwd+TlBsnai8n1W4F3wvfrshFw2WdK7lkiw5FMXx8cTfCibimlbLxLyxc9VPVYN8e5zxayPtOfjtBvD9ZUsTnVoRjFhYDxYHogoa4JmBQ/R1kNj1X+qQVGr0UhPVZDgxs0h2895bpyjP1RgTy348Y6wzAAetq0r+iO0Tmir3JmJ4Wo2clVzhneCZQYOrqaAdjLI4jTC9+ooVhrA5rM3nCHhXjLAP3GnFMArzFiAv9SdvVDItGnXg2QYzlj4w+e00O4w4YxfZRH1tdSp4hDk18V
 LqwDBFvC
 Ff/Sw9iDkMT1YuUp0RVF3hoSjQp27ZTtd71w/LdIUwxJN9C+mE0aRmOrG00bCXfKjNHqzjGbjOd24xULTPO8fl/08/DxyXSwSzWPZYylO094WqdYfnDo6+mx9BhZ92nRknM4vX7weydzBly7VGA4JHReSNfp9bgmbCKL9ZHWmwjBE1p89PuuGrx2aIwYR6VgR7aMOn8c9gaXgP51NjxPD/6LBzmzxjGgwegeFu3pM3WZjhbJMAi0+yhnEZeRQQFKhh0n+XoVjHzKRthbuNJj/VmmpFTddVgyMAHOLoq6h+wieDpdpgHgwzrXSBQibRclFmV5QWRbla+h3K2Ef24Wc39HIfG2IryTmGUNyg7+peQ7SOmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan


On 2026/6/17 23:29, Brendan Jackman wrote:
> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
> main entry point function is significantly different from the normal
> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>
> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
> exposed to mm/) and then turn the nolock variant into a thin wrapper
> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
> how some of the wrappers in gfp.h do).
>
> Rationale that this doesn't change anything:
>
> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>     the new alloc_order_allowed(), alloc_trylock_allowed() and
>     gfp_trylock.
>
> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>     previously in the nolock variant:
>
>     a. Application of gfp_allowed_mask; this only affects early boot, and
>        only flags that affect the slowpath get changed here.
>
>     b. Application of current_gfp_context() - also only affects the
>        slowpath
>
> 3. The slowpath itself: this is now just explicitly skipped under
>     !ALLOC_TRYLOCK.
>
> Ulterior motive: adding an alloc_flags arg to the allocator's
> mm-internal entrypoint can later be used to do more allocation
> customisation without needing to create new GFP flags.


If so, I believe we could generalize this further.

Under the current logic, |__alloc_pages_slowpath| cannot access the 
alloc_flags
passed down from upper-level callers.
As I discussed in another thread, we can introduce a new alloc_flags to
replace the |__GFP_NO_CODETAG| (|__GFP_NO_OBJ_EXT|) GFP flag.
This newly added flag needs to be propagated along the entire call
chain down to |prep_new_page|, which means |__alloc_pages_slowpath| also 
has to
handle this flag accordingly.

I'm wondering if we could introduce a caller_alloc_flags field within 
struct alloc_context
to handle alloc_flags that need to persist throughout the entire page 
allocation cycle, when such flags exist.
I'm sure others will have more appropriate solutions.

Thanks
Best Regards
Hao

>
> No functional change intended.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>   mm/hugetlb.c    |   2 +-
>   mm/internal.h   |   4 +-
>   mm/mempolicy.c  |   8 +--
>   mm/page_alloc.c | 175 +++++++++++++++++++++++++++++---------------------------
>   mm/slub.c       |   4 +-
>   5 files changed, 99 insertions(+), 94 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835e..619f6307dc98d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1806,7 +1806,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
>   	if (alloc_try_hard)
>   		gfp_mask |= __GFP_RETRY_MAYFAIL;
>   
> -	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
> +	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, 0);
>   
>   	/*
>   	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a20..1043eb833836c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -913,7 +913,7 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
>   extern int user_min_free_kbytes;
>   
>   struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
> -		nodemask_t *);
> +		nodemask_t *, unsigned int alloc_flags);
>   #define __alloc_frozen_pages(...) \
>   	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
>   void free_frozen_pages(struct page *page, unsigned int order);
> @@ -924,7 +924,7 @@ struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
>   #else
>   static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
>   {
> -	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
> +	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL, 0);
>   }
>   #endif
>   
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 36699fabd3c22..dccff90682035 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2425,9 +2425,9 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
>   	 */
>   	preferred_gfp = gfp | __GFP_NOWARN;
>   	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
> -	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
> +	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask, 0);
>   	if (!page)
> -		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
> +		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL, 0);
>   
>   	return page;
>   }
> @@ -2475,7 +2475,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>   			 */
>   			page = __alloc_frozen_pages_noprof(
>   				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
> -				nid, NULL);
> +				nid, NULL, 0);
>   			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
>   				return page;
>   			/*
> @@ -2487,7 +2487,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>   		}
>   	}
>   
> -	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
> +	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, 0);
>   
>   	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
>   		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0111cdbdb5321..fc4d07bbf44b5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5253,24 +5253,98 @@ void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>   	}
>   }
>   
> -/*
> - * This is the 'heart' of the zoned buddy allocator.
> - */
> -struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
> -		int preferred_nid, nodemask_t *nodemask)
> +static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
> +				       unsigned int alloc_flags)
>   {
> -	struct page *page;
> -	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> -	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
> -	struct alloc_context ac = { };
> +
> +	if (alloc_flags & ALLOC_TRYLOCK)
> +		return pcp_allowed_order(order);
>   
>   	/*
>   	 * There are several places where we assume that the order value is sane
>   	 * so bail out early if the request is out of bound.
>   	 */
> -	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
> +	return !(WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp));
> +}
> +
> +static inline bool alloc_trylock_allowed(void)
> +{
> +	/*
> +	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
> +	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
> +	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
> +	 * mark the task as the owner of another rt_spin_lock which will
> +	 * confuse PI logic, so return immediately if called from hard IRQ or
> +	 * NMI.
> +	 *
> +	 * Note, irqs_disabled() case is ok. This function can be called
> +	 * from raw_spin_lock_irqsave region.
> +	 */
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> +		return false;
> +
> +	/* On UP, spin_trylock() always succeeds even when it is locked */
> +	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> +		return false;
> +
> +	/* Bailout, since _deferred_grow_zone() needs to take a lock */
> +	if (deferred_pages_enabled())
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
> + * GFP flags to set for ALLOC_TRYLOCK i.e. alloc_pages_nolock().
> + *
> + * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
> + * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
> + * is not safe in arbitrary context.
> + *
> + * These two are the conditions for gfpflags_allow_spinning() being true.
> + *
> + * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
> + * to warn. Also warn would trigger printk() which is unsafe from
> + * various contexts. We cannot use printk_deferred_enter() to mitigate,
> + * since the running context is unknown.
> + *
> + * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
> + * is safe in any context. Also zeroing the page is mandatory for
> + * BPF use cases.
> + *
> + * Though __GFP_NOMEMALLOC is not checked in the code path below,
> + * specify it here to highlight that alloc_pages_nolock()
> + * doesn't want to deplete reserves.
> + */
> +static const gfp_t gfp_trylock = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC |
> +				__GFP_COMP;
> +
> +/*
> + * This is the 'heart' of the zoned buddy allocator.
> + */
> +struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
> +		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
> +{
> +	struct page *page;
> +	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
> +	struct alloc_context ac = { };
> +
> +	/* Other flags could be supported later if needed. */
> +	if (WARN_ON(alloc_flags & ~ALLOC_TRYLOCK))
>   		return NULL;
>   
> +	if (!alloc_order_allowed(gfp, order, alloc_flags))
> +		return NULL;
> +
> +	if (alloc_flags & ALLOC_TRYLOCK) {
> +		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
> +		if (!alloc_trylock_allowed())
> +			return NULL;
> +		gfp |= gfp_trylock;
> +	} else {
> +		alloc_flags |= ALLOC_WMARK_LOW;
> +	}
> +
>   	gfp &= gfp_allowed_mask;
>   	/*
>   	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
> @@ -5291,9 +5365,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>   	 */
>   	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
>   
> -	/* First allocation attempt */
> +	/* First allocation attempt (or, for trylock, only attempt) */
>   	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
> -	if (likely(page))
> +	if (likely(page) || (alloc_flags & ALLOC_TRYLOCK))
>   		goto out;
>   
>   	alloc_gfp = gfp;
> @@ -5310,7 +5384,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>   out:
>   	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
>   	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
> -		free_frozen_pages(page, order);
> +		__free_frozen_pages(page, order,
> +				    alloc_flags & ALLOC_TRYLOCK ? FPI_TRYLOCK : 0);
>   		page = NULL;
>   	}
>   
> @@ -5326,7 +5401,7 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
>   {
>   	struct page *page;
>   
> -	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
> +	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask, 0);
>   	if (page)
>   		set_page_refcounted(page);
>   	return page;
> @@ -7856,80 +7931,10 @@ static bool __free_unaccepted(struct page *page)
>   
>   struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
>   {
> -	/*
> -	 * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
> -	 * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
> -	 * is not safe in arbitrary context.
> -	 *
> -	 * These two are the conditions for gfpflags_allow_spinning() being true.
> -	 *
> -	 * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
> -	 * to warn. Also warn would trigger printk() which is unsafe from
> -	 * various contexts. We cannot use printk_deferred_enter() to mitigate,
> -	 * since the running context is unknown.
> -	 *
> -	 * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
> -	 * is safe in any context. Also zeroing the page is mandatory for
> -	 * BPF use cases.
> -	 *
> -	 * Though __GFP_NOMEMALLOC is not checked in the code path below,
> -	 * specify it here to highlight that alloc_pages_nolock()
> -	 * doesn't want to deplete reserves.
> -	 */
> -	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
> -			| gfp_flags;
> -	unsigned int alloc_flags = ALLOC_TRYLOCK;
> -	struct alloc_context ac = { };
> -	struct page *page;
> -
> -	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
> -	/*
> -	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
> -	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
> -	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
> -	 * mark the task as the owner of another rt_spin_lock which will
> -	 * confuse PI logic, so return immediately if called from hard IRQ or
> -	 * NMI.
> -	 *
> -	 * Note, irqs_disabled() case is ok. This function can be called
> -	 * from raw_spin_lock_irqsave region.
> -	 */
> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> -		return NULL;
> -
> -	/* On UP, spin_trylock() always succeeds even when it is locked */
> -	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> -		return NULL;
> -
> -	if (!pcp_allowed_order(order))
> -		return NULL;
> -
> -	/* Bailout, since _deferred_grow_zone() needs to take a lock */
> -	if (deferred_pages_enabled())
> -		return NULL;
> -
>   	if (nid == NUMA_NO_NODE)
>   		nid = numa_node_id();
>   
> -	prepare_alloc_pages(alloc_gfp, order, nid, NULL, &ac,
> -			    &alloc_gfp, &alloc_flags);
> -
> -	/*
> -	 * Best effort allocation from percpu free list.
> -	 * If it's empty attempt to spin_trylock zone->lock.
> -	 */
> -	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
> -
> -	/* Unlike regular alloc_pages() there is no __alloc_pages_slowpath(). */
> -
> -	if (memcg_kmem_online() && page && (gfp_flags & __GFP_ACCOUNT) &&
> -	    unlikely(__memcg_kmem_charge_page(page, alloc_gfp, order) != 0)) {
> -		__free_frozen_pages(page, order, FPI_TRYLOCK);
> -		page = NULL;
> -	}
> -	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
> -	kmsan_alloc_page(page, order, alloc_gfp);
> -	return page;
> +	return __alloc_frozen_pages_noprof(gfp_flags, order, nid, NULL, ALLOC_TRYLOCK);
>   }
>   /**
>    * alloc_pages_nolock - opportunistic reentrant allocation from any context
> diff --git a/mm/slub.c b/mm/slub.c
> index a2bf3756ca7d0..b9fb66071bd07 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3275,7 +3275,7 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
>   	else if (node == NUMA_NO_NODE)
>   		page = alloc_frozen_pages(flags, order);
>   	else
> -		page = __alloc_frozen_pages(flags, order, node, NULL);
> +		page = __alloc_frozen_pages(flags, order, node, NULL, 0);
>   
>   	if (!page)
>   		return NULL;
> @@ -5236,7 +5236,7 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
>   	if (node == NUMA_NO_NODE)
>   		page = alloc_frozen_pages_noprof(flags, order);
>   	else
> -		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
> +		page = __alloc_frozen_pages_noprof(flags, order, node, NULL, 0);
>   
>   	if (page) {
>   		ptr = page_address(page);
>
> ---
> base-commit: 1111012ec6508a38a39f8d20c213c8c9cf3c96c0
> change-id: 20260617-alloc-trylock-14ad37dab337
>
> Best regards,
> --
> Brendan Jackman <jackmanb@google.com>
>
>

