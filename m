Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 998F3C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB976B00B0; Thu,  2 Jul 2026 22:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92916B0195; Thu,  2 Jul 2026 22:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81F76B0197; Thu,  2 Jul 2026 22:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD936B00B0
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:30:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7BEC8D8BC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:30:13 +0000 (UTC)
X-FDA: 84945885906.06.2926FB5
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id C6BF41C000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:30:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=asw8Vo+d;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783045812;
	b=6knifJihJ3N6ggNy9oWGNvqrPTt9WioiaXOasPQ9Kws6h1At7jHcY+kwPoZOUVyu1vCllu
	ildjKPBZG7O8srLiT+SmYAzcntwm52W/LdgtRiKGtBPSD2fFmEKd/lWQaJzUzlNYQ+V3w6
	5Non3VmXY0bCCH6wPyUk7Fk7xbLQBIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783045812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEVguKTs0idsev8R2DKDbRRwlG6crNlKXgJKMM+TDiY=;
	b=45VTXUlETm9d0RdetuvaCFzrg4FSjzo+D2Ew7SSDQPlwkBNeBLxeYnARNcfJ8fCPOdy8P9
	1gfMMU2LbWhCq8bLHZhj2PoKW0LGGYPjdtI+F5ulpzMKHz3omkxyePodQkzyALI0NzHbI9
	ffzIcntT8VB4PjtCUrwY62CHGNT4UVU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=asw8Vo+d;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0d9bdb0e-ff4a-439d-a354-64e4fb82f153@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783045809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TEVguKTs0idsev8R2DKDbRRwlG6crNlKXgJKMM+TDiY=;
	b=asw8Vo+dnnFpom6xEc5gefthSN6b2NXFkDMkBAW+Hypi9HgXQ2bAzX08AAsjye03OGlUKs
	lbhZyb5EVX5oZCdDuht3qy0S2qjQ1oX4r4KRFoFASs0Tp5FQ2Gf9anj+xrq/OTAR8+KA51
	SAVzzv0JAf3Dn5lbI7Bz9FD76FSesas=
Date: Fri, 3 Jul 2026 10:29:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 15/18] mm: replace __GFP_NO_CODETAG with
 ALLOC_NO_CODETAG
To: Brendan Jackman <jackmanb@google.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 derkling@google.com, reijiw@google.com, Yosry Ahmed <yosry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>,
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
References: <20260702-alloc-trylock-v4-0-0af8ff387e80@google.com>
 <20260702-alloc-trylock-v4-15-0af8ff387e80@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260702-alloc-trylock-v4-15-0af8ff387e80@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 58gpixrrgm9raetder5etwwx4diskex9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C6BF41C000A
X-HE-Tag: 1783045811-449045
X-HE-Meta: U2FsdGVkX1+SFPwn6zlXQNLb2E2FVfli7cSVbb24gy10cfYo6F73+/7+AtvMeGifo1suGMeiaFlCPVhCtBiEQHFfDdyLiHXtdRBB86vEKYXIDL0t1DkrV9URpBJ8cVo1sg44VpV4jn6I6Kyv3e9RNErLkeitu0LkrV1sKCJhPVgnlsk02caYyTYj90Du4bgIdjQEVrBHViGabO8bHlkJAUwVHIjMc7FRBoKIeEjv+TvR7X2iWDhoMiu7U5K8M2Fa89qtNvgvqg3/8SY7YrF+MoRTKGJ7o5ampH2UwL/9icMhWEee62Y0t8kHsb5mxCGSsDeNcTdhO4Qv2wJYcazjilq1J/1iwCG9R7XfbIifXOo7FPEIC57u1u7bSLhJcOz7kMigCkvdTrnpkMMeoaM2tpkwe6FhizBmpTxMTdLZXSLeuytOa8QZKUZ7SPx31QOREjbBi5CmUKqXTq764VJ1YMzDphVJaiARsTShMt3y40ox+8kyJGADakLy19+wU8vwY53jjp+Bzx/s1A1X1zllRWcwQ1hK2sEB/sB57AB3wxwDmQ3e1wf3eKWTN2KHp5JNcAqexocGKPzIqWD75wQSRgvSyjm+1rvbYlTSUKzY0MjNK6z4X7SAzDd7oizCO/LffebsRsgZEge9pSipEPfOldzA/jnL4MRUYYZEmL1SOmEElhaqCc70DNRsHhi1jN4x4N7KcBdWhR3+6pGL7yUYWujdBuMgZJHivqMDfG/nhl99xshJZOQvTUZrfnR/9SsbW2zb85+QRTISbQs8wjSpgC71RsxqN/K0nXtuCXeRff5vlBN/Ap+ILI2UjRtnIWtldHspB+CdYmEgXzi3IdwAnJjo/QS05pVLOO+U3oFeRlxjz+SntsBTGlujk12m3YBRgrp91KpMwcXr7C0Klc++nOzQz58zSwpCblILVkIdOVkDD+lmPtIRElaZwxbgRayCM7I+koAzyJUHZW5TQ2w
 W8dGUumD
 axm5zLyJLTbKS0SbzL7dDxlU4JwQ42BwNLKUoJBpyI+zaByaXu+zE1N4rhixBCwwNx622+XHgUtvRStS8tLgwGKbyNU0I3+oY2dKYw1ZhL7AtUQ3bydJEaJ6BUM9SSZrZ43f9ghQg8sJC+G2fTfr7wdk1BNpaBk/ffleW10x9OTb0vJLzwJXDtJ2xsjf7SZTuv9eoMJWiVrUNyieqh7537PCuUNm2AnX3WYOyHEmyCb4qIwagnvjtSpurq3+43n0oT0oj4xwLmd2MLA9KaE3Dh/3zLLhmWbTFBBs1mDNAY9f39NJuOMVEjqdnpXHnX4uufOIVg2vrGK7xZ+RQ4a8M8Tq9pt15R9GPWV6bnK2ex60RL9FSl4Rj8EjV9INMMyEGSshU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan


On 2026/7/2 17:49, Brendan Jackman wrote:
> Now that alloc_pages has an entrypoint that allows passing alloc_flags,
> we can take advantage of this to start removing GFP flags that are only
> used for mm-internal stuff.
>
> This requires also plumbing the alloc_flags into some more of the
> allocator code, in particular __alloc_pages[_noprof]() gets an
> alloc_flags arg to go along with its callees, and we now need to pass
> those flags deeper into the allocator so they can reach the alloc_tag
> code.
>
> While moving the flag definition into page_alloc.h, also update the
> comment per Hao's suggestion.
>
> No functional change intended.
>
> Link: https://lore.kernel.org/all/b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>


Tested in the same environment as commit 6b1842775a46,

the boot-time "alloc_tag was not set" warning does not regress.


Aside from the minor nit below, this patch looks correct to me.


Tested-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Hao Ge <hao.ge@linux.dev>


> ---
>   include/linux/alloc_tag.h |  4 ++--
>   mm/alloc_tag.c            | 23 +++++++--------------
>   mm/compaction.c           |  4 ++--
>   mm/internal.h             |  1 -
>   mm/page_alloc.c           | 52 +++++++++++++++++++++++++++--------------------
>   mm/page_alloc.h           | 14 +++++++++++--
>   mm/page_frag_cache.c      |  4 ++--
>   7 files changed, 55 insertions(+), 47 deletions(-)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 068ba2e77c5d6..fcf90e6b24204 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(union codetag_ref *ref)
>   {
>   	WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
>   }
> -void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
> +void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags);
>   #else
>   static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
>   static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> -static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags) {}
>   #endif
>   
>   /* Caller should verify both ref and tag to be valid */
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index d9be1cf5187d9..cf65e9992fda3 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -15,6 +15,9 @@
>   #include <linux/vmalloc.h>
>   #include <linux/kmemleak.h>
>   
> +#include "internal.h"
> +#include "page_alloc.h"
> +
>   #define ALLOCINFO_FILE_NAME		"allocinfo"
>   #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
>   #define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
> @@ -783,19 +786,6 @@ struct pfn_pool {
>   
>   #define PFN_POOL_SIZE			((PAGE_SIZE - offsetof(struct pfn_pool, pfns)) / \
>   					 sizeof(unsigned long))
> -
> -/*
> - * Skip early PFN recording for a page allocation.  Reuses the
> - * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
> - * recursion when allocating pages for the early PFN tracking list
> - * itself.
> - *
> - * Codetags of the pages allocated with __GFP_NO_CODETAG should be
> - * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
> - * alloc_tag_sub_check() from triggering a warning.
> - */
> -#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
> -
>   static struct pfn_pool *current_pfn_pool __initdata;
>   
>   static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> @@ -806,7 +796,8 @@ static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>   	do {
>   		pool = READ_ONCE(current_pfn_pool);
>   		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
> -			struct page *new_page = alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
> +			struct page *new_page = __alloc_pages(__GFP_HIGH, 0, numa_mem_id(),
> +							      NULL, ALLOC_NO_CODETAG);
>   			struct pfn_pool *new;
>   
>   			if (!new_page) {
> @@ -837,7 +828,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
>   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
>   	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>   
> -void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> +void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)
>   {
>   	alloc_tag_add_func *alloc_tag_add;
>   
> @@ -845,7 +836,7 @@ void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>   		return;
>   
>   	/* Skip allocations for the tracking list itself to avoid recursion. */
> -	if (gfp_flags & __GFP_NO_CODETAG)
> +	if (alloc_flags & ALLOC_NO_CODETAG)
>   		return;
>   
>   	rcu_read_lock();
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 7d80735502d9a..4b2318fad4eb5 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -83,7 +83,7 @@ static inline bool is_via_compact_memory(int order) { return false; }
>   
>   static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
>   {
> -	post_alloc_hook(page, order, __GFP_MOVABLE);
> +	post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
>   	set_page_refcounted(page);
>   	return page;
>   }
> @@ -1851,7 +1851,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
>   	}
>   	dst = (struct folio *)freepage;
>   
> -	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
> +	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
>   	set_page_refcounted(&dst->page);
>   	if (order)
>   		prep_compound_page(&dst->page, order);
> diff --git a/mm/internal.h b/mm/internal.h
> index 7e3b2386e274b..3c00eaf5f45a4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1237,7 +1237,6 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>   enum ttu_flags;
>   struct tlbflush_unmap_batch;
>   
> -


Nit: The blank line removal in mm/internal.h looks like an unrelated 
cleanup.


Thanks

Best Regards

Hao


>   /*
>    * only for MM internal work items which do not depend on
>    * any allocations or locks which might depend on allocations
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f68b2b138a2e8..cfaf16244f56d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1249,7 +1249,7 @@ void __clear_page_tag_ref(struct page *page)
>   /* Should be called only if mem_alloc_profiling_enabled() */
>   static noinline
>   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> -		       unsigned int nr, gfp_t gfp_flags)
> +		       unsigned int nr, unsigned int alloc_flags)
>   {
>   	union pgtag_ref_handle handle;
>   	union codetag_ref ref;
> @@ -1263,17 +1263,17 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>   		 * page_ext is not available yet, record the pfn so we can
>   		 * clear the tag ref later when page_ext is initialized.
>   		 */
> -		alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
> +		alloc_tag_add_early_pfn(page_to_pfn(page), alloc_flags);
>   		if (task->alloc_tag)
>   			alloc_tag_set_inaccurate(task->alloc_tag);
>   	}
>   }
>   
>   static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
> -				   unsigned int nr, gfp_t gfp_flags)
> +				   unsigned int nr, unsigned int alloc_flags)
>   {
>   	if (mem_alloc_profiling_enabled())
> -		__pgalloc_tag_add(page, task, nr, gfp_flags);
> +		__pgalloc_tag_add(page, task, nr, alloc_flags);
>   }
>   
>   /* Should be called only if mem_alloc_profiling_enabled() */
> @@ -1306,7 +1306,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>   #else /* CONFIG_MEM_ALLOC_PROFILING */
>   
>   static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
> -				   unsigned int nr, gfp_t gfp_flags) {}
> +				   unsigned int nr, unsigned int alloc_flags) {}
>   static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
>   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
>   
> @@ -1810,7 +1810,7 @@ static inline bool should_skip_init(gfp_t flags)
>   }
>   
>   inline void post_alloc_hook(struct page *page, unsigned int order,
> -				gfp_t gfp_flags)
> +				gfp_t gfp_flags, unsigned int alloc_flags)
>   {
>   	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
>   	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
> @@ -1861,13 +1861,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>   
>   	set_page_owner(page, order, gfp_flags);
>   	page_table_check_alloc(page, order);
> -	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> +	pgalloc_tag_add(page, current, 1 << order, alloc_flags);
>   }
>   
>   static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
>   							unsigned int alloc_flags)
>   {
> -	post_alloc_hook(page, order, gfp_flags);
> +	post_alloc_hook(page, order, gfp_flags, alloc_flags);
>   
>   	if (order && (gfp_flags & __GFP_COMP))
>   		prep_compound_page(page, order);
> @@ -4078,7 +4078,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>   	 */
>   	page = get_page_from_freelist((gfp_mask | __GFP_HARDWALL) &
>   				      ~__GFP_DIRECT_RECLAIM, order,
> -				      ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
> +				      ac->alloc_flags|ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
>   	if (page)
>   		goto out;
>   
> @@ -4124,7 +4124,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>   		 */
>   		if (gfp_mask & __GFP_NOFAIL)
>   			page = __alloc_pages_cpuset_fallback(gfp_mask, order,
> -					ALLOC_NO_WATERMARKS, ac);
> +					ac->alloc_flags|ALLOC_NO_WATERMARKS, ac);
>   	}
>   out:
>   	mutex_unlock(&oom_lock);
> @@ -4791,8 +4791,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>   	 * The fast path uses conservative alloc_flags to succeed only until
>   	 * kswapd needs to be woken up, and to avoid the cost of setting up
>   	 * alloc_flags precisely. So we do that now.
> +	 *
> +	 * Can't just or alloc_flags if it contains WMARK bits, but those flags
> +	 * shouldn't be set in ac->alloc_flags.
>   	 */
> -	alloc_flags = alloc_flags_slowpath(gfp_mask, order);
> +	VM_WARN_ON(ac->alloc_flags & ALLOC_WMARK_MASK);
> +	alloc_flags = ac->alloc_flags | alloc_flags_slowpath(gfp_mask, order);
>   
>   	/*
>   	 * We need to recalculate the starting point for the zonelist iterator
> @@ -4834,7 +4838,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>   	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
>   	if (reserve_flags)
>   		alloc_flags = alloc_flags_cma(gfp_mask, reserve_flags) |
> -					  (alloc_flags & ALLOC_KSWAPD);
> +				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
>   
>   	/*
>   	 * Reset the nodemask and zonelist iterators if memory policies can be
> @@ -5003,6 +5007,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>   	 * we always retry
>   	 */
>   	if (unlikely(nofail)) {
> +		unsigned int alloc_flags = ac->alloc_flags | ALLOC_MIN_RESERVE;
> +
>   		/*
>   		 * Lacking direct_reclaim we can't do anything to reclaim memory,
>   		 * we disregard these unreasonable nofail requests and still
> @@ -5018,7 +5024,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>   		 * could deplete whole memory reserves which would just make
>   		 * the situation worse.
>   		 */
> -		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE, ac);
> +		page = __alloc_pages_cpuset_fallback(gfp_mask, order, alloc_flags, ac);
>   		if (page)
>   			goto got_pg;
>   
> @@ -5236,7 +5242,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>   	return nr_populated;
>   
>   failed:
> -	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
> +	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
>   	if (page)
>   		page_array[nr_populated++] = page;
>   	goto out;
> @@ -5344,11 +5350,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>   {
>   	struct page *page;
>   	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
> -	struct alloc_context ac = { };
> +	struct alloc_context ac = {
> +		.alloc_flags = alloc_flags,
> +	};
>   	unsigned int fastpath_alloc_flags = alloc_flags;
>   
>   	/* Other flags could be supported later if needed. */
> -	if (WARN_ON(alloc_flags & ~ALLOC_NOLOCK))
> +	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
>   		return NULL;
>   
>   	if (!alloc_order_allowed(gfp, order, alloc_flags))
> @@ -5421,12 +5429,12 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>   EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
>   
>   struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
> -		int preferred_nid, nodemask_t *nodemask)
> +		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
>   {
>   	struct page *page;
>   
>   	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask,
> -					   ALLOC_DEFAULT);
> +					   alloc_flags);
>   	if (page)
>   		set_page_refcounted(page);
>   	return page;
> @@ -5440,7 +5448,7 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
>   	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>   	warn_if_node_offline(nid, gfp_mask);
>   
> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> +	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
>   }
>   EXPORT_SYMBOL(alloc_pages_node_noprof);
>   
> @@ -5448,7 +5456,7 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
>   		nodemask_t *nodemask)
>   {
>   	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
> -					preferred_nid, nodemask);
> +					preferred_nid, nodemask, ALLOC_DEFAULT);
>   	return page_rmappable_folio(page);
>   }
>   EXPORT_SYMBOL(__folio_alloc_noprof);
> @@ -7130,7 +7138,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>   		list_for_each_entry_safe(page, next, &list[order], lru) {
>   			int i;
>   
> -			post_alloc_hook(page, order, gfp_mask);
> +			post_alloc_hook(page, order, gfp_mask, ALLOC_DEFAULT);
>   			if (!order)
>   				continue;
>   
> @@ -7335,7 +7343,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>   		struct page *head = pfn_to_page(start);
>   
>   		check_new_pages(head, order);
> -		prep_new_page(head, order, gfp_mask, 0);
> +		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
>   	} else {
>   		ret = -EINVAL;
>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index 3b8a4709b1497..06f8b6f150cdf 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -49,6 +49,13 @@
>   #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
>   #define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
>   #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
> +/*
> + * Avoid alloc_tag recursion for internal allocations.
> + *
> + * Callers must clear_page_tag_ref() before freeing to avoid warnings from
> + * alloc_tag_sub_check().
> + */
> +#define ALLOC_NO_CODETAG       0x1000
>   
>   /* Flags that allow allocations below the min watermark. */
>   #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> @@ -84,6 +91,8 @@ struct alloc_context {
>   	 */
>   	enum zone_type highest_zoneidx;
>   	bool spread_dirty_pages;
> +	/* Only flags that are global to the whole allocation go here. */
> +	unsigned int alloc_flags;
>   };
>   
>   /*
> @@ -214,7 +223,8 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>   extern void __free_pages_core(struct page *page, unsigned int order,
>   		enum meminit_context context);
>   
> -void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
> +void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
> +		     unsigned int alloc_flags);
>   extern bool free_pages_prepare(struct page *page, unsigned int order);
>   
>   extern int user_min_free_kbytes;
> @@ -245,7 +255,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
>   void free_frozen_pages_nolock(struct page *page, unsigned int order);
>   
>   struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
> -		nodemask_t *nodemask);
> +		nodemask_t *nodemask, unsigned int alloc_flags);
>   #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
>   
>   extern void zone_pcp_reset(struct zone *zone);
> diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> index a1077cef3a791..e63efe78b7d4b 100644
> --- a/mm/page_frag_cache.c
> +++ b/mm/page_frag_cache.c
> @@ -57,10 +57,10 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
>   	gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
>   		   __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
>   	page = __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
> -			     numa_mem_id(), NULL);
> +			     numa_mem_id(), NULL, ALLOC_DEFAULT);
>   #endif
>   	if (unlikely(!page)) {
> -		page = __alloc_pages(gfp, 0, numa_mem_id(), NULL);
> +		page = __alloc_pages(gfp, 0, numa_mem_id(), NULL, ALLOC_DEFAULT);
>   		order = 0;
>   	}
>   
>

