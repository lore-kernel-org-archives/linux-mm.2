Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B859BCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 16:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13EE6B0005; Wed, 17 Jun 2026 12:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4686B0088; Wed, 17 Jun 2026 12:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865E16B008C; Wed, 17 Jun 2026 12:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56CC66B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:39:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2D3F140509
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:39:24 +0000 (UTC)
X-FDA: 84889965048.10.FDC34D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0349140007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:39:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmlbaOZe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781714363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLDkg4WxnXGnsAZI8cb873zZ7d7ZuisTrkvapay2URM=;
	b=SnWfDJ7uTOXVfKbduXPc1oiijbn9O2ZhOKoyj+t685GwIRfouosmWHK+j4KLHMEgesr2mg
	e7HZ9NHEoRat1xsf1R8ZhpaooUt8gvdNC1EShpI+GVIEdHuLG4cSnE8tTFK2eOJceKqghe
	/i/alXkpeSJK6Z5PCZwb9tEQZwXH1NE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmlbaOZe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781714363;
	b=IvBzHQc4eCngxpYza4aAO6xKv1A54UZZYGG1mZuYgoOQ0zfHMgNm539yw4TrcplzvZ2SRF
	mVHIUUWKQ35/wnkJ9ADNtD5uYmCEJ8SKWcNghGr5WhaJn7uzG3mdVt3kZ/3YqZ+cVfemFy
	xg7ZKoZcIsVllg8un8yufQQsLlVj7fI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF41A41660;
	Wed, 17 Jun 2026 16:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD271F000E9;
	Wed, 17 Jun 2026 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781714361;
	bh=eLDkg4WxnXGnsAZI8cb873zZ7d7ZuisTrkvapay2URM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nmlbaOZewZyXiU0WW4bU4/DKdnYUY6HTFd4ZBsRXPtiSwN3C+4Cx3qSQmYZ2Q/4dx
	 fJOxcQ1w6vTIUN2yOMbvfDlPnXy9RI+A/b+5xAqmRS3oAENHR42thV6Ap12v5AQsNE
	 dHBKFcmUGlhlM/UZymISqvt3JPi5204VfHeHxSNBRiY2pQuWIMnUEeiCO/hqAW3IOn
	 bv6DJz4NZTcpSBnZ4lt6qtXGat+dIWtriC1nMBdqdGlSeQM5UsSJmgQg3WMSI/a/OR
	 jAyDvfxZvUsweFBvVILxFDEyiJxUgj2MoX9bohbMnWvc6PgAYvBRRpdqUOO/+GRgwd
	 w1RBStSaDfPAA==
Message-ID: <2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org>
Date: Wed, 17 Jun 2026 18:39:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fa54dj1m8uh9kkwnjzi4j4gb95ywpjxh
X-Rspamd-Queue-Id: F0349140007
X-HE-Tag: 1781714362-164629
X-HE-Meta: U2FsdGVkX18ST157t9kcPj2l6YLJR/TDOIa4RdnLwVBa/gBrhf93aX49iNTL22ECDLuke3tVUh1W9kGQ24bzz/zI8OI9FwMGXBNCnrBlpbeeqgoabGydqc/SVMKd1deisZ3IdlQqoI5gB9QASyr0un19CkiX81UihzygtLcHae496dXMjQO9gcfXe/uiz4uDRIH8/Imac4xBVxfWgGJInOuLZpWWCDInc0F3I2sC9xK6Pd7ba7y1yGH1fC2Prl4Bqq989Y9+eSoEUlFGTt26eLATgub1ACWcoRs2pcanNgUwoZnoqJzmKaix89LL006H2kS3EPW9VuNKDEbUX52LtBFNybiLStNMX9a1RUjqlNy6wgQd1jp3Q816Rwg4147Vjxv5l6DBhoumnVs5ZWfUk/43VJxpRzrZ26QgJpx0/eocrvwz3gxeL3x2x25OipMwAsLHM3rb6IGDDX8yUD9LmGQFQ5MaTnHvElaJqci0LuBfvDEPZDLzpK8WraPCT4bnSEKuHnqFuVJnCXwochzlJLqZUPOX68GH8zo0AQ4r/ZLV8tNO3Qcg8ypTchNWmHE2J59P6TqHD9bZdRS0YhXHhzM6J3qxFFxEwDIaoDp1/7gh53rzcpm9dTfp4xwnKivgqkeqYATTOlq505+B6me3BtlYqEZu6SSbqfFtIsrixvyxK9nQZDirioiPZdd0yxEVneLemAkDjTMT497gZRTarc7tIp9RrmJd4BVOg6Q6iZpMmHMd9jH+N9XokHNZT0gaQBlacNPI/zSmwwAsrQ3ruOl2aS9E+CUkhHTDuvmJ1tpMDDvX5EzDoSyIPCEeY+R5bkY7oydtUNwbjoZvm3O77i6OaLRre2/ImWiPBEAOTpY0STsFQ1OehawzqX02Lf3oxf4bn9k5eHINV65mIopX69e/+fuzw6VkQMbUUJtaY19O0/5hrTtfEYNFx6CPki5O3/McWzZLH9qn5kVO5A1
 thAzo5N2
 aCy/RzH/Rug7z8EEq9a9a7SJ2+iW89V9FknsJAny0FuUEJ8dvEzhI26WPLRpD64ED/btP3fqa9jmH2Zvqpf8QUyQH9c72ZVN5YhHgrqk1ho53vIHyBZjOAwnXiYYWFaSRnpEJRW8WgXd//5kFSc2w9OvhYTxsyztbFQUwsWUP8RKq2K2HEDsgdkzs9tDuwIsi0EA95VNdU/qcQlNLoSkGyOq8WIktI/Mfpw6y/hfHn7O4B+ljSItoapy0ZohW00EHuXPq8qQtlCH7wUrLL6fe6C+m+EB7RHunjDdykJYW+dNmgiZsV3dfv3CqmRMCBtPIbzn3dwhBJIk4E3Go4R8TDiItaME7AUtJv8TyEK9MRiuOoa8BFQhYv5QzfHQ9NMulDtwQNC/qEE2gxg/r/WzsiTRsT7p7mlNtqrvk9uelCYUVnzwRBtlSnNuoDlwPmnIag8zjHXHguKuZdj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Alexei

On 6/17/26 17:29, Brendan Jackman wrote:
> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the

It's not, it's ALLOC_TRYLOCK! Thanks for proving that we need to rename it
to ALLOC_NOLOCK:

https://lore.kernel.org/all/DJ9QPTO2WXNB.10E88ZHWRDHB0@gmail.com/

So you just won the job to do the rename :) I think it should be done before
this patch, so that the new usages and other _trylock names introduced here
can be done as _nolock outright.

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
>    the new alloc_order_allowed(), alloc_trylock_allowed() and
>    gfp_trylock.
> 
> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>    previously in the nolock variant:
> 
>    a. Application of gfp_allowed_mask; this only affects early boot, and
>       only flags that affect the slowpath get changed here.
> 
>    b. Application of current_gfp_context() - also only affects the
>       slowpath
> 
> 3. The slowpath itself: this is now just explicitly skipped under
>    !ALLOC_TRYLOCK.

I'll have to ponder it more closely.

> Ulterior motive: adding an alloc_flags arg to the allocator's
> mm-internal entrypoint can later be used to do more allocation
> customisation without needing to create new GFP flags.

Ack.

> No functional change intended.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Besides the need to ponder unintended effects, mostly LGTM. Just not a fan
of the hardcoded '0' passed at various places. In the slab variant of this
(the thread I've linked above) I went with SLAB_ALLOC_DEFAULT, so you can do
e.g. ALLOC_DEFAULT here?

> ---
>  mm/hugetlb.c    |   2 +-
>  mm/internal.h   |   4 +-
>  mm/mempolicy.c  |   8 +--
>  mm/page_alloc.c | 175 +++++++++++++++++++++++++++++---------------------------
>  mm/slub.c       |   4 +-
>  5 files changed, 99 insertions(+), 94 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835e..619f6307dc98d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1806,7 +1806,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
>  	if (alloc_try_hard)
>  		gfp_mask |= __GFP_RETRY_MAYFAIL;
>  
> -	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
> +	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, 0);
>  
>  	/*
>  	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a20..1043eb833836c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -913,7 +913,7 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
>  extern int user_min_free_kbytes;
>  
>  struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
> -		nodemask_t *);
> +		nodemask_t *, unsigned int alloc_flags);
>  #define __alloc_frozen_pages(...) \
>  	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
>  void free_frozen_pages(struct page *page, unsigned int order);
> @@ -924,7 +924,7 @@ struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
>  #else
>  static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
>  {
> -	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
> +	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL, 0);
>  }
>  #endif
>  
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 36699fabd3c22..dccff90682035 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2425,9 +2425,9 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
>  	 */
>  	preferred_gfp = gfp | __GFP_NOWARN;
>  	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
> -	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
> +	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask, 0);
>  	if (!page)
> -		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
> +		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL, 0);
>  
>  	return page;
>  }
> @@ -2475,7 +2475,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  			 */
>  			page = __alloc_frozen_pages_noprof(
>  				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
> -				nid, NULL);
> +				nid, NULL, 0);
>  			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
>  				return page;
>  			/*
> @@ -2487,7 +2487,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  		}
>  	}
>  
> -	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
> +	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, 0);
>  
>  	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
>  		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0111cdbdb5321..fc4d07bbf44b5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5253,24 +5253,98 @@ void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>  	}
>  }
>  
> -/*
> - * This is the 'heart' of the zoned buddy allocator.
> - */
> -struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
> -		int preferred_nid, nodemask_t *nodemask)
> +static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
> +				       unsigned int alloc_flags)
>  {
> -	struct page *page;
> -	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> -	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
> -	struct alloc_context ac = { };
> +
> +	if (alloc_flags & ALLOC_TRYLOCK)
> +		return pcp_allowed_order(order);
>  
>  	/*
>  	 * There are several places where we assume that the order value is sane
>  	 * so bail out early if the request is out of bound.
>  	 */
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
>  		return NULL;
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
>  	gfp &= gfp_allowed_mask;
>  	/*
>  	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
> @@ -5291,9 +5365,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  	 */
>  	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
>  
> -	/* First allocation attempt */
> +	/* First allocation attempt (or, for trylock, only attempt) */
>  	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
> -	if (likely(page))
> +	if (likely(page) || (alloc_flags & ALLOC_TRYLOCK))
>  		goto out;
>  
>  	alloc_gfp = gfp;
> @@ -5310,7 +5384,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  out:
>  	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
>  	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
> -		free_frozen_pages(page, order);
> +		__free_frozen_pages(page, order,
> +				    alloc_flags & ALLOC_TRYLOCK ? FPI_TRYLOCK : 0);
>  		page = NULL;
>  	}
>  
> @@ -5326,7 +5401,7 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
>  {
>  	struct page *page;
>  
> -	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
> +	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask, 0);
>  	if (page)
>  		set_page_refcounted(page);
>  	return page;
> @@ -7856,80 +7931,10 @@ static bool __free_unaccepted(struct page *page)
>  
>  struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
>  {
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
>  	if (nid == NUMA_NO_NODE)
>  		nid = numa_node_id();
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
>  }
>  /**
>   * alloc_pages_nolock - opportunistic reentrant allocation from any context
> diff --git a/mm/slub.c b/mm/slub.c
> index a2bf3756ca7d0..b9fb66071bd07 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3275,7 +3275,7 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
>  	else if (node == NUMA_NO_NODE)
>  		page = alloc_frozen_pages(flags, order);
>  	else
> -		page = __alloc_frozen_pages(flags, order, node, NULL);
> +		page = __alloc_frozen_pages(flags, order, node, NULL, 0);
>  
>  	if (!page)
>  		return NULL;
> @@ -5236,7 +5236,7 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
>  	if (node == NUMA_NO_NODE)
>  		page = alloc_frozen_pages_noprof(flags, order);
>  	else
> -		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
> +		page = __alloc_frozen_pages_noprof(flags, order, node, NULL, 0);
>  
>  	if (page) {
>  		ptr = page_address(page);
> 
> ---
> base-commit: 1111012ec6508a38a39f8d20c213c8c9cf3c96c0
> change-id: 20260617-alloc-trylock-14ad37dab337
> 
> Best regards,
> --  
> Brendan Jackman <jackmanb@google.com>
> 


