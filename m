Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0301ECD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1428C6B0005; Thu,  4 Jun 2026 06:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3AB6B0088; Thu,  4 Jun 2026 06:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008786B008A; Thu,  4 Jun 2026 06:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4A406B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:00:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A4E71A066B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:00:02 +0000 (UTC)
X-FDA: 84841784244.28.0228E9B
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 50EED4000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:00:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u1WINhwK;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780567200;
	b=M3C2eXDgc4WPM5s80ZEu2VppLBb2h4nQNtGzPWrnojjb9yU88HfbZqHuA5aNcx7XUzw8nl
	dM90w0klW5FwjWxSMnh/5M8sYAn7w7pYKxf7NB4lno1+GqFgjvXmsW6twK7PPtHTkAt+Xg
	tqEcVaynhbypks5zIzI0R6gIz67be2A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u1WINhwK;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780567200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnNCPgGv3YfTR2L0YpYUIQ9QlZ8NJJyPklpwDZylJi0=;
	b=qW4CZ5aHDbMe6Ey/wOu9b/onGid8BPoghGv8H3YE5m0dzm94ZwY5M2O8BeAHPefE1Ft9Kh
	y89CJrhYUIaMI09mWHNTlUOYtBV1E19hUNMs2arRmOLLTvB0WeEWPileMAOYNVNOczBpNR
	yY7lGpRxw89+1qVL0D/OGbzI9y2cETw=
Message-ID: <77d12ac6-0a0c-4d1e-8fed-ac59b519fe28@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780567198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pnNCPgGv3YfTR2L0YpYUIQ9QlZ8NJJyPklpwDZylJi0=;
	b=u1WINhwKd596KoayKj5aasyqMCYzUF8bzkYCGty5WR563Pt+vaQt4E6XyxIe7BoeEJ0DKQ
	y2Dr8+5d4HIJaz+e2ZDmDQoJp7bUX8451SnRTU+OmOnB2n2ZwiBok0LS7jb6Ek84dZsAS5
	TQkyL10EzIZXUsooi8UUS8Nmw5hbS7Y=
Date: Thu, 4 Jun 2026 17:59:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Suren Baghdasaryan <surenb@google.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>
References: <20260604024008.46592-1-hao.ge@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260604024008.46592-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 50EED4000C
X-Stat-Signature: po8yp9jot9odzejixpmiwxujhxyryx38
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780567200-793328
X-HE-Meta: U2FsdGVkX1//yUkl+iI9uSERBowIJUYcOQKsXdAV01WyiDLz/0wKwzDAqzVsK1FgjbRtT0zdPcydncpCuvifoh5I+an6/LLWIgANtqWjcnPFD0N73gViqOQKa3k5lTKSo/s9zywrhqtdwxocoQ5FkqHTpuLkj35HsaPzo6QA36UauN/6PNo3PGOSS1mRUkOfzdsjrAYwP/htnTF+fYuXM3VdfHAj/62ZQfu6vlqcKbAkckEk0TFmgns26vIDZWZHuNT2vsFnW3uIxAVAzNKhvjssmCoJC1kzTLwmmUmZFAkqNYoZ3Lkqfy8Xz6GrGfB/V5EZkz19vXPzZD6/tJL4o5BJ2kbodzR0xTYN5c+LR2EqdZJwL9eFHF5DZT2jy3VsZYPmOVz89PA48zFRJsfI1Du1tZrj3pTAKIcsTtEjaOsoCO0EVjLefeO1jGoPNE56jGilxxmsmUNwfNYZ2rHf++2FzK//K0nViMVUuWF1yTidaN1fywOhgVYEZ1yCiMGnyZ7J7DoqttbuKFX7U25CaW7/rmvyl5KNGdJcRkg9693m4sjp/eEp3AwvrSL7T1eeVj7PhXhn68QcEgCPs2AzHxOyprNFX+LxuHdW4R40KZsWLXAdvLZMGjLQapIx6kynvxQxEDG7SBiPZeci3yoBUVnQsFskAOqUrcel2ISBmCGApTNlT5/Wh2CyC7YY+V5PuxppX2VKxWtSvWxzW3waTVUD8gI04wyqVh3zgfHp9FOWfd2c8nIS0NHWaJ45M0Li0RjdjaXo4xoTnnt1Ka1eQ+Q+pwgLNLcSgELmiHo3TjCafDDKds+RhjpdcEUMY4zOzaAtFobsaPmOgElktIzl0luZba+6yomXVTtaDhpKNEKLGOnnk9/7L+GNxZQypuwrJgCcxJzUDNfVV7GuZJOO4DIB+zlHoXPzOqIdcqunMBzq1oMiK0bH6mULF/q0MAZ35ocs2WIYGtbZSYIcRUr
 6q6kwc8Q
 d6vd+beGHy8HVd5BArNjSdQ2M9n0OZu49/9i5MYcDiBBq00G0NrkcowjrUqYWKZuJGrAeBm4CJhCC9XVFAPbrAfozbD0/44dYxJPUnwn0xS+qUfhqjqrlnmFgrXxDtvNiNGBE9C3QZY7FhQIArKL7NrAq3zwhzEOvZHOqwE6kEI4J6m92AQdLD6WK7VCio+ZF1KBEInM6+YrEVG+y9CRjreuDQVng2dFA4zrFwuMToBTObhWaJJXWbjqxh4TCHoRc+uN4cKRrld1+5n/yhrMBfDMMU5rMlzTWxULlYBJVjf4vroBi4rblRndvwjrCm8yMiHMSSFfy3PCaC6EpzkLPJ58AvtBdvkRZz3jfTiG4cqFLRa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Add cc:linux-mm@kvack.org and lost part of the changelog

because of local Git environment glitch.

Sorry for this.


On 2026/6/4 10:40, Hao Ge wrote:
> Pages allocated before page_ext is available have their codetag left
> uninitialized. Track these early PFNs and clear their codetag in
> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> warnings when they are freed later.
>
> Currently a fixed-size array of 8192 entries is used, with a warning if
> the limit is exceeded. However, the number of early allocations depends
> on the number of CPUs and can be larger than 8192.
>
> Replace the fixed-size array with a dynamically allocated linked list
> of pfn_pool structs. Each node is allocated via alloc_page() and mapped
> to a pfn_pool containing a next pointer, an atomic slot counter, and a
> PFN array that fills the remainder of the page.
>
> The tracking pages themselves are allocated via alloc_page(), which
> would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
> recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
> %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
> so that the early path can skip recording allocations that carry this flag.
>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

---

v6:
- Use hardcoded __GFP_HIGH | __GFP_NO_CODETAG instead of inheriting
   caller's gfp_flags for internal pfn_pool page allocation.

> ---
>   include/linux/alloc_tag.h |   4 +-
>   lib/alloc_tag.c           | 140 +++++++++++++++++++++++++-------------
>   mm/page_alloc.c           |  12 ++--
>   3 files changed, 99 insertions(+), 57 deletions(-)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 02de2ede560f..068ba2e77c5d 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(union codetag_ref *ref)
>   {
>   	WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
>   }
> -void alloc_tag_add_early_pfn(unsigned long pfn);
> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
>   #else
>   static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
>   static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
>   #endif
>   
>   /* Caller should verify both ref and tag to be valid */
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index ed1bdcf1f8ab..f2f574bcf383 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -767,50 +767,82 @@ static __init bool need_page_alloc_tagging(void)
>    * their codetag uninitialized. Track these early PFNs so we can clear
>    * their codetag refs later to avoid warnings when they are freed.
>    *
> - * Early allocations include:
> - *   - Base allocations independent of CPU count
> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
> - *     such as trace ring buffers, scheduler per-cpu data)
> - *
> - * For simplicity, we fix the size to 8192.
> - * If insufficient, a warning will be triggered to alert the user.
> + * Each page is cast to a pfn_pool: the first few bytes hold metadata
> + * (next pointer and slot count), the remainder stores PFNs.
> + */
> +struct pfn_pool {
> +	struct pfn_pool *next;
> +	atomic_t count;
> +	unsigned long pfns[];
> +};
> +
> +#define PFN_POOL_SIZE			((PAGE_SIZE - offsetof(struct pfn_pool, pfns)) / \
> +					 sizeof(unsigned long))
> +
> +/*
> + * Skip early PFN recording for a page allocation.  Reuses the
> + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
> + * recursion when allocating pages for the early PFN tracking list
> + * itself.
>    *
> - * TODO: Replace fixed-size array with dynamic allocation using
> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> + * Codetags of the pages allocated with __GFP_NO_CODETAG should be
> + * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
> + * alloc_tag_sub_check() from triggering a warning.
>    */
> -#define EARLY_ALLOC_PFN_MAX		8192
> +#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
>   
> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> -static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
> +static struct pfn_pool *current_pfn_pool __initdata;
>   
>   static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>   {
> -	int old_idx, new_idx;
> +	struct pfn_pool *pool;
> +	int idx;
>   
>   	do {
> -		old_idx = atomic_read(&early_pfn_count);
> -		if (old_idx >= EARLY_ALLOC_PFN_MAX) {
> -			pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> -				      EARLY_ALLOC_PFN_MAX);
> -			return;
> +		pool = READ_ONCE(current_pfn_pool);
> +		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
> +			struct page *new_page = alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
> +			struct pfn_pool *new;
> +
> +			if (!new_page) {
> +				pr_warn_once("early PFN tracking page allocation failed\n");
> +				return;
> +			}
> +			new = page_address(new_page);
> +			new->next = pool;
> +			atomic_set(&new->count, 0);
> +			if (cmpxchg(&current_pfn_pool, pool, new) != pool) {
> +				clear_page_tag_ref(new_page);
> +				__free_page(new_page);
> +				continue;
> +			}
> +			pool = new;
>   		}
> -		new_idx = old_idx + 1;
> -	} while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
> +		idx = atomic_read(&pool->count);
> +		if (idx >= PFN_POOL_SIZE)
> +			continue;
> +		if (atomic_cmpxchg(&pool->count, idx, idx + 1) == idx)
> +			break;
> +	} while (1);
>   
> -	early_pfns[old_idx] = pfn;
> +	pool->pfns[idx] = pfn;
>   }
>   
>   typedef void alloc_tag_add_func(unsigned long pfn);
>   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
>   	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>   
> -void alloc_tag_add_early_pfn(unsigned long pfn)
> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>   {
>   	alloc_tag_add_func *alloc_tag_add;
>   
>   	if (static_key_enabled(&mem_profiling_compressed))
>   		return;
>   
> +	/* Skip allocations for the tracking list itself to avoid recursion. */
> +	if (gfp_flags & __GFP_NO_CODETAG)
> +		return;
> +
>   	rcu_read_lock();
>   	alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
>   	if (alloc_tag_add)
> @@ -820,7 +852,9 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
>   
>   static void __init clear_early_alloc_pfn_tag_refs(void)
>   {
> -	unsigned int i;
> +	struct pfn_pool *pool, *next;
> +	struct page *page;
> +	int i;
>   
>   	if (static_key_enabled(&mem_profiling_compressed))
>   		return;
> @@ -829,37 +863,45 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
>   	/* Make sure we are not racing with __alloc_tag_add_early_pfn() */
>   	synchronize_rcu();
>   
> -	for (i = 0; i < atomic_read(&early_pfn_count); i++) {
> -		unsigned long pfn = early_pfns[i];
> -
> -		if (pfn_valid(pfn)) {
> -			struct page *page = pfn_to_page(pfn);
> -			union pgtag_ref_handle handle;
> -			union codetag_ref ref;
> -
> -			if (get_page_tag_ref(page, &ref, &handle)) {
> -				/*
> -				 * An early-allocated page could be freed and reallocated
> -				 * after its page_ext is initialized but before we clear it.
> -				 * In that case, it already has a valid tag set.
> -				 * We should not overwrite that valid tag with CODETAG_EMPTY.
> -				 *
> -				 * Note: there is still a small race window between checking
> -				 * ref.ct and calling set_codetag_empty(). We accept this
> -				 * race as it's unlikely and the extra complexity of atomic
> -				 * cmpxchg is not worth it for this debug-only code path.
> -				 */
> -				if (ref.ct) {
> +	for (pool = current_pfn_pool; pool; pool = next) {
> +		int nr_pfns = atomic_read(&pool->count);
> +
> +		for (i = 0; i < nr_pfns; i++) {
> +			unsigned long pfn = pool->pfns[i];
> +
> +			if (pfn_valid(pfn)) {
> +				union pgtag_ref_handle handle;
> +				union codetag_ref ref;
> +
> +				if (get_page_tag_ref(pfn_to_page(pfn), &ref, &handle)) {
> +					/*
> +					 * An early-allocated page could be freed and reallocated
> +					 * after its page_ext is initialized but before we clear it.
> +					 * In that case, it already has a valid tag set.
> +					 * We should not overwrite that valid tag
> +					 * with CODETAG_EMPTY.
> +					 *
> +					 * Note: there is still a small race window between checking
> +					 * ref.ct and calling set_codetag_empty(). We accept this
> +					 * race as it's unlikely and the extra complexity of atomic
> +					 * cmpxchg is not worth it for this debug-only code path.
> +					 */
> +					if (ref.ct) {
> +						put_page_tag_ref(handle);
> +						continue;
> +					}
> +
> +					set_codetag_empty(&ref);
> +					update_page_tag_ref(handle, &ref);
>   					put_page_tag_ref(handle);
> -					continue;
>   				}
> -
> -				set_codetag_empty(&ref);
> -				update_page_tag_ref(handle, &ref);
> -				put_page_tag_ref(handle);
>   			}
>   		}
>   
> +		next = pool->next;
> +		page = virt_to_page(pool);
> +		clear_page_tag_ref(page);
> +		__free_page(page);
>   	}
>   }
>   #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d49c254174da..50b2bc8f42d9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1240,7 +1240,7 @@ void __clear_page_tag_ref(struct page *page)
>   /* Should be called only if mem_alloc_profiling_enabled() */
>   static noinline
>   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> -		       unsigned int nr)
> +		       unsigned int nr, gfp_t gfp_flags)
>   {
>   	union pgtag_ref_handle handle;
>   	union codetag_ref ref;
> @@ -1254,17 +1254,17 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>   		 * page_ext is not available yet, record the pfn so we can
>   		 * clear the tag ref later when page_ext is initialized.
>   		 */
> -		alloc_tag_add_early_pfn(page_to_pfn(page));
> +		alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
>   		if (task->alloc_tag)
>   			alloc_tag_set_inaccurate(task->alloc_tag);
>   	}
>   }
>   
>   static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
> -				   unsigned int nr)
> +				   unsigned int nr, gfp_t gfp_flags)
>   {
>   	if (mem_alloc_profiling_enabled())
> -		__pgalloc_tag_add(page, task, nr);
> +		__pgalloc_tag_add(page, task, nr, gfp_flags);
>   }
>   
>   /* Should be called only if mem_alloc_profiling_enabled() */
> @@ -1297,7 +1297,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>   #else /* CONFIG_MEM_ALLOC_PROFILING */
>   
>   static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
> -				   unsigned int nr) {}
> +				   unsigned int nr, gfp_t gfp_flags) {}
>   static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
>   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
>   
> @@ -1852,7 +1852,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>   
>   	set_page_owner(page, order, gfp_flags);
>   	page_table_check_alloc(page, order);
> -	pgalloc_tag_add(page, current, 1 << order);
> +	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
>   }
>   
>   static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,

