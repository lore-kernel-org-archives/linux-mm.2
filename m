Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C411CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF08A6B0088; Tue, 23 Jun 2026 03:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA12D6B008A; Tue, 23 Jun 2026 03:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D903C6B008C; Tue, 23 Jun 2026 03:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86BAA6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:57:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F15988D788
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:57:22 +0000 (UTC)
X-FDA: 84910422324.18.D2AF765
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id AF5A580003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:57:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z5WDdIhQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782201441;
	b=5tZnFgHFdtJ2IG7EHxsXYhlVoEhNO3WpUA2/XUyD5jB7z1W2HvZWflVuajERFUti/Q7rV3
	QBrVbl6D2LZnhMVq43UCykq8I8rnW7fIWuuyR/k393Tn1uWg/uGW50GWNLDxtFO7mjjAvV
	oXCG/T/6s86Eb7guaNj/PwwA3NyY6FI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782201441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YOsWN24QMyB1OibJVwjOiiMJTHDGvvI4KR4pW3FCPv8=;
	b=xs3fsbKQE62TWzmDaQjJCxcEUp5eAz+pyZTRAfy5a+Mn0TE52OCaUDCis9iBKZMts//rPZ
	lklx1RLh+X8Z4FZmaz2N08Udi7fbZPcor9NMUYeQZQzSOuY4FZ0+m6rYFJLAaU10y1H8i3
	qFUPEixBkZq6wRxSuCHq+sGlNSnf1jo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z5WDdIhQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <6e312b15-d2b5-4137-aa3f-720ec214c7ab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782201438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOsWN24QMyB1OibJVwjOiiMJTHDGvvI4KR4pW3FCPv8=;
	b=Z5WDdIhQcPKYwsP7139hwnDvuxIFsJURgopt4k0Kk/bsCErWp1NK/K6Xlp62focm/inEn1
	RHe2tkAe2wQP7kIEUxuzievOTEHmyxs+8JaJ6S+hOCm3cqGnW+7YQi+uoAAufTnR5Wlvyf
	hYHpWYv555v+dUIeT/roTWAEACAWYD4=
Date: Tue, 23 Jun 2026 15:56:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 13/13] mm: remove __GFP_NO_CODETAG
To: Brendan Jackman <jackmanb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Alistair Popple <apopple@nvidia.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Suren Baghdasaryan <surenb@google.com>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-13-31f31367d420@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260622-alloc-trylock-v2-13-31f31367d420@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF5A580003
X-Stat-Signature: 8uz8zp6zf71is6nhynhyoc5t8iwk5ita
X-HE-Tag: 1782201440-94469
X-HE-Meta: U2FsdGVkX18o5PuLdKu0hPMASwRU54eu629SFlkotgnDdtSbD/EQiOpwjSJa4K4+PfZTVjuoWT8Mcw80PUFD0ZM8ERdv/PxD5gtMXsu3cG6npvTQ8me1vTfvZ7CHD9lIHmxRA5I0SlSoh/zv4SiwstX+/nbC6TOea9NJZ5NhNrJTl0D7N6qhOULlV/V/Y5sSYg3nUCQ4NEY27nQvOdPe24HQGPO9fbIcmtWDmxg8nayAg2QqhOSoET4anF8wR0MzAXxH3UBxFNYu7MMHhNRmbQv2CsRjap6UfAsQ3zhB6pabSNO0wkPvmAPzIGYQDSLfeYXKVL8XbQqp9137mHfw2Iz/ugJ4qYvBNoydsv4ycTixuvs551eKq1t/KrU4hhvD/un9m6O6u9qNzvZW+EiRATfRelUV6vK4vLGl68Sk/zOcSs/XvYct6uLYDnwvO2840byTgT8ZXzuR8jvfjvPMEIFCfSQYk4iXobEa/jBAK5npLGBG7MI9zLW2LlTFJcoOsysH6B9YqVUxq079dmZKWy/33xvXFkoId5rBkUkm0lSkowDdtZPCzwW4h7mdNuGP3vzx7JBDRy+2HwfMLofux5x94BqS85M2HArJbtEXe4lD2l7r9iyO6weviS7PuFD2fPHV/knRUuFTXZikxj79xTYCxybB/UNjFLFQHpPMeyzpatY4J6uHHEOzgBc/gmKuDVmc+SxDJOHw1Z01TVck1KtFvZdcVJa4gt4+zUnY5EconjpaUXBo5C02kXWFMBdHPYnbnXGdcQsMOMlUkjq6xIRQd6gqYi6DiICcOiKvCUbYHxM7G7nXc8rcSlHtXlGfUVNP0+OnAlp159DXdEEBDFuOmh9hHjibxseq/2CZybc8hS5s6JbuZEGs0I7p3t5F1K/QC8HXQjeiHFECTKjkP92QtCvVqe/EqjI7muUGSb1Iuu42OdlbRRTvBSC5moW9EX9yQckeN7XFkzcNjXw
 vKYZeEPr
 ryRp1zg63EbOm56U1UtEMEErzdHDaYqehKmA8mdR1lcKY/2QysJQt3H1syvW/eYQBYlWpeyHTvmtvVblmW+b/YGH0g8JMsO4xfmFfwwNgmOFcMjcG4kAxDeSkH3J/FVni4A9W4NvPdDBE9bh9cd3mXD7qw9yXFybAdvKji3BFFdKx/4Ff5KJQxcmdZGwZswOAGkMTNpnV7GmLJYnGGS2vnCVRUA0CHd/PhDmBhl0bWHSWTlp9rW5qJ+VQ9iZnCGKZwfQpK8WPVAF5pfRM7IJXzP4duMKWBPLSKk0vPRZqAtzDZR/0CEhuejUV6LAUxCHmMrgdGcRXzyv46ajWxg1kWeJAL3dXyvlRldVBbp0OOt1+NhwKEpIf4XlthEr1IAlRT9Qm2CZtCjLUNuhEbHoOQlFRHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan


On 2026/6/22 18:01, Brendan Jackman wrote:
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
> To try and keep the new ALLOC_NO_CODETAG's scope nice and narrow, don't
> define it in mm/internal.h, instead just define a "reserved bit" and
> then use that in places that don't care about what it means.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>


Nit: The title says "remove __GFP_NO_CODETAG" but the flag isn't really 
removed — it's migrated from gfp_t to alloc_flags as

ALLOC_NO_CODETAG. Something like "mm: replace __GFP_NO_CODETAG with an 
alloc_flag" would be more accurate.


Additionally, as Lorenzo pointed out in another thread, you will likely 
need to rebase this series later.

I noticed Vlastimil has already landed the slab changes removing 
__GFP_NO_OBJ_EXT into mainline:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=335c347686e76df9d2c7d7f61b5ea627a4c5cb4c

For v3, it might make sense to fold in Vlastimil's patch so the full 
removal of __GFP_NO_OBJ_EXT can be completed end-to-end

https://lore.kernel.org/all/20260609-slab_alloc_flags-v1-15-2bf4a4b9b526@kernel.org/


> ---
>   mm/alloc_tag.c       | 18 ++++++++++--------
>   mm/compaction.c      |  4 ++--
>   mm/internal.h        |  8 ++++++--
>   mm/page_alloc.c      | 42 ++++++++++++++++++++++++------------------
>   mm/page_frag_cache.c |  4 ++--
>   5 files changed, 44 insertions(+), 32 deletions(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index d9be1cf5187d9..61a6cba32ff35 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -15,6 +15,8 @@
>   #include <linux/vmalloc.h>
>   #include <linux/kmemleak.h>
>   
> +#include "internal.h"
> +
>   #define ALLOCINFO_FILE_NAME		"allocinfo"
>   #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
>   #define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
> @@ -785,16 +787,15 @@ struct pfn_pool {
>   					 sizeof(unsigned long))
>   
>   /*
> - * Skip early PFN recording for a page allocation.  Reuses the
> - * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
> - * recursion when allocating pages for the early PFN tracking list
> - * itself.
> + * Skip early PFN recording for a page allocation.  Used by
> + * __alloc_tag_add_early_pfn() to avoid recursion when allocating pages for the
> + * early PFN tracking list itself.
>    *
>    * Codetags of the pages allocated with __GFP_NO_CODETAG should be
>    * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
>    * alloc_tag_sub_check() from triggering a warning.
>    */
> -#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
> +#define ALLOC_NO_CODETAG		__ALLOC_ALLOC_TAG
>   
>   static struct pfn_pool *current_pfn_pool __initdata;
>   
> @@ -806,7 +807,8 @@ static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>   	do {
>   		pool = READ_ONCE(current_pfn_pool);
>   		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
> -			struct page *new_page = alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
> +			struct page *new_page = __alloc_pages(__GFP_HIGH, 0, numa_mem_id(),
> +							      NULL, ALLOC_NO_CODETAG);
>   			struct pfn_pool *new;
>   
>   			if (!new_page) {
> @@ -837,7 +839,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
>   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
>   	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>   
> -void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> +void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)


alloc_tag_add_early_pfn is actually declared in include/linux/alloc_tag.h,

so we need to update this header in sync as well.

include/linux/alloc_tag.h:166:void alloc_tag_add_early_pfn(unsigned long 
pfn, gfp_t gfp_flags);
include/linux/alloc_tag.h:170:static inline void 
alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}


>   {
>   	alloc_tag_add_func *alloc_tag_add;
>   
> @@ -845,7 +847,7 @@ void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>   		return;
>   
>   	/* Skip allocations for the tracking list itself to avoid recursion. */
> -	if (gfp_flags & __GFP_NO_CODETAG)
> +	if (alloc_flags & ALLOC_NO_CODETAG)
>   		return;
>   
>   	rcu_read_lock();
> diff --git a/mm/compaction.c b/mm/compaction.c
> index b776f35ad0200..e90ebd2c54f48 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -82,7 +82,7 @@ static inline bool is_via_compact_memory(int order) { return false; }
>   
>   static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
>   {
> -	post_alloc_hook(page, order, __GFP_MOVABLE);
> +	post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
>   	set_page_refcounted(page);
>   	return page;
>   }
> @@ -1850,7 +1850,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
>   	}
>   	dst = (struct folio *)freepage;
>   
> -	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
> +	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
>   	set_page_refcounted(&dst->page);
>   	if (order)
>   		prep_compound_page(&dst->page, order);
> diff --git a/mm/internal.h b/mm/internal.h
> index 0847b55bfc147..a45bedb9ada5f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -684,6 +684,8 @@ struct alloc_context {
>   	 */
>   	enum zone_type highest_zoneidx;
>   	bool spread_dirty_pages;
> +	/* Only flags that are global to the whole allocation go here. */
> +	unsigned int alloc_flags;
>   };
>   
>   /*
> @@ -907,7 +909,8 @@ static inline void init_compound_tail(struct page *tail,
>   	prep_compound_tail(tail, head, order);
>   }
>   
> -void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
> +void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
> +		     unsigned int alloc_flags);
>   extern bool free_pages_prepare(struct page *page, unsigned int order);
>   
>   extern int user_min_free_kbytes;
> @@ -1481,6 +1484,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>   #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
>   #define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
>   #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
> +#define __ALLOC_ALLOC_TAG      0x1000 /* Reserved bit for use by alloc_tag code */
>   
>   /* Flags that allow allocations below the min watermark. */
>   #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> @@ -1956,7 +1960,7 @@ bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
>   		   unsigned long npages);
>   
>   struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
> -		nodemask_t *nodemask);
> +		nodemask_t *nodemask, unsigned int alloc_flags);
>   #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
>   
>   #endif	/* __MM_INTERNAL_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d99e4ea8307ea..d50fd9c77a2e8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1246,7 +1246,7 @@ void __clear_page_tag_ref(struct page *page)
>   /* Should be called only if mem_alloc_profiling_enabled() */
>   static noinline
>   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> -		       unsigned int nr, gfp_t gfp_flags)
> +		       unsigned int nr, unsigned int alloc_flags)
>   {
>   	union pgtag_ref_handle handle;
>   	union codetag_ref ref;
> @@ -1260,17 +1260,17 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
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


The pgalloc_tag_add() stub in the non-CONFIG_MEM_ALLOC_PROFILING build 
could use the same parameter types for consistency


Thanks

Best Regards

Hao


>   {
>   	if (mem_alloc_profiling_enabled())
> -		__pgalloc_tag_add(page, task, nr, gfp_flags);
> +		__pgalloc_tag_add(page, task, nr, alloc_flags);
>   }
>   
>   /* Should be called only if mem_alloc_profiling_enabled() */
> @@ -1807,7 +1807,7 @@ static inline bool should_skip_init(gfp_t flags)
>   }
>   
>   inline void post_alloc_hook(struct page *page, unsigned int order,
> -				gfp_t gfp_flags)
> +				gfp_t gfp_flags, unsigned int alloc_flags)
>   {
>   	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
>   	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
> @@ -1858,13 +1858,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
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
> @@ -4773,8 +4773,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>   	 * The fast path uses conservative alloc_flags to succeed only until
>   	 * kswapd needs to be woken up, and to avoid the cost of setting up
>   	 * alloc_flags precisely. So we do that now.
> +	 *
> +	 * Can't just or alloc_flags if it contains WMARK bits, but those flags
> +	 * shouldn't be set in ac->alloc_flags.
>   	 */
> -	alloc_flags = slowpath_alloc_flags(gfp_mask, order);
> +	VM_WARN_ON(ac->alloc_flags & ALLOC_WMARK_MASK);
> +	alloc_flags = ac->alloc_flags | slowpath_alloc_flags(gfp_mask, order);
>   
>   	/*
>   	 * We need to recalculate the starting point for the zonelist iterator
> @@ -4816,7 +4820,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>   	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
>   	if (reserve_flags)
>   		alloc_flags = cma_alloc_flags(gfp_mask, reserve_flags) |
> -					  (alloc_flags & ALLOC_KSWAPD);
> +				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
>   
>   	/*
>   	 * Reset the nodemask and zonelist iterators if memory policies can be
> @@ -5218,7 +5222,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>   	return nr_populated;
>   
>   failed:
> -	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
> +	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
>   	if (page)
>   		page_array[nr_populated++] = page;
>   	goto out;
> @@ -5326,11 +5330,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
> +	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | __ALLOC_ALLOC_TAG)))
>   		return NULL;
>   
>   	if (!alloc_order_allowed(gfp, order, alloc_flags))
> @@ -5398,12 +5404,12 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
> @@ -5418,14 +5424,14 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
>   	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>   	warn_if_node_offline(nid, gfp_mask);
>   
> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> +	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
>   }
>   
>   struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
>   		nodemask_t *nodemask)
>   {
>   	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
> -					preferred_nid, nodemask);
> +					preferred_nid, nodemask, ALLOC_DEFAULT);
>   	return page_rmappable_folio(page);
>   }
>   EXPORT_SYMBOL(__folio_alloc_noprof);
> @@ -7107,7 +7113,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>   		list_for_each_entry_safe(page, next, &list[order], lru) {
>   			int i;
>   
> -			post_alloc_hook(page, order, gfp_mask);
> +			post_alloc_hook(page, order, gfp_mask, ALLOC_DEFAULT);
>   			if (!order)
>   				continue;
>   
> @@ -7312,7 +7318,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>   		struct page *head = pfn_to_page(start);
>   
>   		check_new_pages(head, order);
> -		prep_new_page(head, order, gfp_mask, 0);
> +		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
>   	} else {
>   		ret = -EINVAL;
>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> index d2423f30577e4..d9573170e0719 100644
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

