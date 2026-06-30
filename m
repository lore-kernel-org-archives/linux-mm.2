Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77CCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72B96B00A7; Mon, 29 Jun 2026 21:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23A66B00A9; Mon, 29 Jun 2026 21:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11AF6B00B3; Mon, 29 Jun 2026 21:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89F2A6B00A7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:56:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C2E3C1872
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:56:22 +0000 (UTC)
X-FDA: 84934914204.17.16F557E
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0C26420007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:56:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m2v5V2xq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784580;
	b=Tg4O9PdPffyFalO0nHHdCdNuVJ0zFghjbrIaOnzXc6HGCz5gjLAfm8rTIC/Edvu8EAw51y
	j8XhD0yi730kqp9zpq0TnqxhoPBjJbuQJ1CxB8REWLUsoGoEVQj7m9pjT8tiUx4lD3XAXJ
	pdGT/xP+jVsIXqMg+BCPDHNR1v72sgw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TRuvrtSLLctFqmJrmRT58y1lma9yqJsPk1O5IlqUh0=;
	b=1SBsVIm2XQLsJf+/jsMrGmp47PTLa/dwnoYZDy7wQzjFDpCn64y8Rv3kGQ8ZOateaJ0q3V
	FOhzIAiuhevEK48Rh2f4sImkN1cx+AYs0BjHdfZ3NzFIYDSVfwWVFfdFJ7eBfpO3TNY7zR
	E2QIyqQOJRMbzDN4YIC6G1IWKCyF/Fs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m2v5V2xq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3TRuvrtSLLctFqmJrmRT58y1lma9yqJsPk1O5IlqUh0=;
	b=m2v5V2xq/I8Z+IljbNIuC2XPHWWXD6XFtEf2jVm7NF5YjQfiQecO70y37e/qS1mWDrA9ot
	3qbmIkqamyI9tZvNJL+0sYSOMdUcrwKI9nxZrlFN23iqT+M2htLmpelRTc1HEYVZ+QzLgT
	GPw6g3vkRlWHycH8KKNfy9WQVp5T35c=
Date: Tue, 30 Jun 2026 09:55:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 15/16] mm: replace __GFP_NO_CODETAG with
 ALLOC_NO_CODETAG
To: Brendan Jackman <jackmanb@google.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C26420007
X-Stat-Signature: diupinfh5w516c6ga5ss5z7gkxdjtnub
X-HE-Tag: 1782784579-792541
X-HE-Meta: U2FsdGVkX1/Arc3a5o1/IU0Wf3XYM+gAIPeQx5d9I0Xmvyk2sSgE30Prm8j2T8kspGYbMEmWbbsYmJZBL0zc2Wja8t/DqX8spCS+kPIEAFYdeNt90SLqQlZtUIhUuo+FGRsujQgblOWvpO5CH9Qy3TbWi7YM2atE9Xq260b6f91ZQAkeCVsCAB/qMcC/yrbCtIoS7WxliHBQQilekxYc9hkOfuQ5/Lg502SShDpMuYXjg5X99U/qWSM8lWR+TxKCbSGq7Bsn6Z8SnXt3qsSUCbZaxEwTJPj7CaL5mw1bkMAY6ZR/U0TwTRXGUwTWNyyFB4khg/R0VeikNaO/x52SN5G2O/tUYCdSbZVmVpYaNl7HDORMYmI8nwXwKWTOBO3eBpZ+PSgYoDrp6WNXC3QkmZeZe8RxOiJmgqkXQGR80Rxc55v7CRNzKjb5SEh2JAtj93gFZ5KgfI+cmvZfbnWPlxOZrQqekDDZE/bdu600W4k1k+MJvnvnZ3tzMwRRmqH6OMSX9CEHZNe6HA7KXBA/x3EHoQPl275GK/F3Aqmf7B7a9Bey3gKqgNo1tfKN4RkzbfgN8troHwN9nBX4GbB01Uizkew7MX/b5DqkZToa7DDB3L/h1PLozK3D19I5H9N14wckP8Gd233kKQqBO2RT6zH100XhA0GcBfSbMJj8KZjV+JUtDRz5prRif4EcR8GXHvIFOgSt3qJDQlW1qKnOF52v9pTAtsPM2pVrW+ssMZUtfeEkkqXv/UEkiFEgB3d+PnWrs0t1F+u29dADgYMPfWKfB61ltrXZ96GpmbjTJExklZQBC7wGvpMXTDWx2qDCO9zCCuyDNI/OhK77t5xpcEnwa4MrOIRZhSI8izS1yrnezdRcZtlMU+Nd80l9sVCssc1LGJksRjKVKoXv4e1F7Zi9OJzIvHm7r+qb1Hb8O+MGU6Hy+IT6wGCi1urqhlBrb88LiHeitFkA66gAxmo
 YlMkd9nE
 bgfTFjXnP6EaNp1dvBB6ztTlz+0F+LQaPq/E2BWhThXMpXZLb0mwZOb8mkuPO2NjAbj7owy1LD7cXsUgspk3QDLFRS6wDoz+n0uFPSlMmvy8zEQfhwGpHUgpXcdZOk2rIucJmZMTer7+FiasXYKJckyI5jo7QF9GKYAD19beDFqxywSXLRisuo8eiVizvmKuvvQvnPOeXebiPsctb5cawvo33CTXwQ7nkQTU9ss0bWAdZm8Sh9axWlfsp/qstXOOx8d1S6H9alD2/5YKrCQnUMD2gq3b0XMsepcb1pf2eFn/hBLRUcMBVfyQ1YHB7Bku+ZmeLulxHLnSwlyZZ/uvhVKGy8inJ89na5/XWnFVtvCrnBdnPBwztSQhJjmg7cPLyycj0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan


On 2026/6/29 21:12, Brendan Jackman wrote:
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
> No functional change intended.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>   mm/alloc_tag.c       | 22 ++++++----------------
>   mm/compaction.c      |  4 ++--
>   mm/internal.h        |  1 -
>   mm/page_alloc.c      | 42 ++++++++++++++++++++++++------------------
>   mm/page_alloc.h      | 17 +++++++++++++++--
>   mm/page_frag_cache.c |  4 ++--
>   6 files changed, 49 insertions(+), 41 deletions(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index d9be1cf5187d9..a32a94e759b94 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -15,6 +15,8 @@
>   #include <linux/vmalloc.h>
>   #include <linux/kmemleak.h>
>   
> +#include "internal.h"


Should we include page_alloc.h here, as we call __alloc_pages later in 
this file?


> +
>   #define ALLOCINFO_FILE_NAME		"allocinfo"
>   #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
>   #define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
> @@ -783,19 +785,6 @@ struct pfn_pool {
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
> @@ -806,7 +795,8 @@ static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>   	do {
>   		pool = READ_ONCE(current_pfn_pool);
>   		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
> -			struct page *new_page = alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
> +			struct page *new_page = __alloc_pages(__GFP_HIGH, 0, numa_mem_id(),
> +							      NULL, ALLOC_NO_CODETAG);
>   			struct pfn_pool *new;
>   
>   			if (!new_page) {
> @@ -837,7 +827,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
>   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
>   	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>   
> -void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> +void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)


alloc_tag_add_early_pfn() has three occurrences across the codebase:

1. Definition in mm/alloc_tag.c:830:

void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)

2. Declaration in include/linux/alloc_tag.h:166:

void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)

3. Static inline stub in include/linux/alloc_tag.h:170:

static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t 
gfp_flags) {}

This patch updates the definition in alloc_tag.c to take unsigned int 
alloc_flags,

but the two declarations in alloc_tag.h are left with the old gfp_t 
gfp_flags signature

These should be updated to match.


>   {
>   	alloc_tag_add_func *alloc_tag_add;
>   
> @@ -845,7 +835,7 @@ void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
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
> index c22284f04fc9e..369c656c63fa8 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1237,7 +1237,6 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>   enum ttu_flags;
>   struct tlbflush_unmap_batch;
>   
> -
>   /*
>    * only for MM internal work items which do not depend on
>    * any allocations or locks which might depend on allocations
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 026f33f217036..803b32e5a5e47 100644
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


Same situation as alloc_tag_add_early_pfn() — the #else stub

at mm/page_alloc.c:1309 still uses gfp_t gfp_flags instead of unsigned int

alloc_flags.


>   {
>   	if (mem_alloc_profiling_enabled())
> -		__pgalloc_tag_add(page, task, nr, gfp_flags);
> +		__pgalloc_tag_add(page, task, nr, alloc_flags);
>   }
>   
>   /* Should be called only if mem_alloc_profiling_enabled() */
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
> @@ -5236,7 +5240,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>   	return nr_populated;
>   
>   failed:
> -	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
> +	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
>   	if (page)
>   		page_array[nr_populated++] = page;
>   	goto out;
> @@ -5344,11 +5348,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
> @@ -5417,12 +5423,12 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
> @@ -5436,7 +5442,7 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
>   	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>   	warn_if_node_offline(nid, gfp_mask);
>   
> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> +	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
>   }
>   EXPORT_SYMBOL(alloc_pages_node_noprof);
>   
> @@ -5444,7 +5450,7 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
>   		nodemask_t *nodemask)
>   {
>   	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
> -					preferred_nid, nodemask);
> +					preferred_nid, nodemask, ALLOC_DEFAULT);
>   	return page_rmappable_folio(page);
>   }
>   EXPORT_SYMBOL(__folio_alloc_noprof);
> @@ -7126,7 +7132,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>   		list_for_each_entry_safe(page, next, &list[order], lru) {
>   			int i;
>   
> -			post_alloc_hook(page, order, gfp_mask);
> +			post_alloc_hook(page, order, gfp_mask, ALLOC_DEFAULT);
>   			if (!order)
>   				continue;
>   
> @@ -7331,7 +7337,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>   		struct page *head = pfn_to_page(start);
>   
>   		check_new_pages(head, order);
> -		prep_new_page(head, order, gfp_mask, 0);
> +		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
>   	} else {
>   		ret = -EINVAL;
>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index 2058cbdca56e7..2614bff6795b0 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -49,6 +49,16 @@
>   #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
>   #define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
>   #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
> +/*
> + * Skip early PFN recording for a page allocation.  Used by
> + * __alloc_tag_add_early_pfn() to avoid recursion when allocating pages for the
> + * early PFN tracking list itself.
> + *
> + * Codetags of the pages allocated with __GFP_NO_CODETAG should be
> + * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
> + * alloc_tag_sub_check() from triggering a warning.
> + */


I originally wrote this lengthy comment because the logic lives inside 
alloc_tag.c.

I wanted to document all the context to avoid confusion when revisiting 
this code later on.

We've since replaced __GFP_NO_CODETAG with ALLOC_NO_CODETAG, a generic 
alloc_flags bit defined in page_alloc.h.

The original long comment is no longer accurate:

Given that, I suggest updating it to the following:

/*

  * Avoid alloc_tag recursion for internal allocations.

  * Callers must clear_page_tag_ref() before
  * freeing to avoid warnings from alloc_tag_sub_check().

  */


Thanks

Best Regards

Hao


> +#define ALLOC_NO_CODETAG       0x1000
>   
>   /* Flags that allow allocations below the min watermark. */
>   #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> @@ -84,6 +94,8 @@ struct alloc_context {
>   	 */
>   	enum zone_type highest_zoneidx;
>   	bool spread_dirty_pages;
> +	/* Only flags that are global to the whole allocation go here. */
> +	unsigned int alloc_flags;
>   };
>   
>   /*
> @@ -214,7 +226,8 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>   extern void __free_pages_core(struct page *page, unsigned int order,
>   		enum meminit_context context);
>   
> -void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
> +void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
> +		     unsigned int alloc_flags);
>   extern bool free_pages_prepare(struct page *page, unsigned int order);
>   
>   extern int user_min_free_kbytes;
> @@ -245,7 +258,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
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

