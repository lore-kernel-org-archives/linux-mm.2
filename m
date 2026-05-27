Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CCCFCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 05:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D866B008C; Wed, 27 May 2026 01:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317626B0092; Wed, 27 May 2026 01:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206246B0093; Wed, 27 May 2026 01:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 084366B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:23:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC8B18D259
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:22:59 +0000 (UTC)
X-FDA: 84812055678.21.1CAE78E
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D0744000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:22:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VK8cOhwL;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779859378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kw9RI9StduSPTNHetPsT3vDemyb9Huga1WtnCcK65cg=;
	b=ultOeCVmFh32WP/lJxjSLeudv9cmhFuKiTkkcw9qFsVKDZudeUg++UwcozxlJT9WAv4IDQ
	Vsxn7r2iPCmPHEkVhnSYcxwDUiBGDNgvpBPjyga6Rq12Zp433ca6xIX6viePENb0kXlAZu
	8uY+yDMG0eUPfy1mUQJOzUNmp7+y89o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VK8cOhwL;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779859378; a=rsa-sha256;
	cv=none;
	b=ReOYnROGzF5C7fzAz3oj+7O7VBmsjDqp2GjSNSYxUHJd6JD01HjPnaStzzSNYQLHGcBiX8
	c0RCMZm7slNV740otKyVN2rzf5CSLjq12UX1bbDOnBtEmrSWxKrGOCNaK4GoSjPqCtJPam
	6xQRKpmCEIaSPSNHE+oQiHfop8v/3dc=
Message-ID: <0e835109-9068-464f-88e2-c1847cd34c71@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779859375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kw9RI9StduSPTNHetPsT3vDemyb9Huga1WtnCcK65cg=;
	b=VK8cOhwLdBcdQnc2vnFo+0RAEqUQHpmOXDQvS2iOZ8tvqgk/rWnqkNjblURUlotglo2lHU
	/MfuBucL1yqpjKdC318kTIG3BhnFokHwiGHbJnAYrAF8k68PDAg9eIl8jYbiOMarwHbB3N
	TI94xdXBI/aOV3KcQR7RstjYvKxbY5Q=
Date: Wed, 27 May 2026 13:22:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>
References: <20260506022256.32664-1-hao.ge@linux.dev>
 <20260508171251.9bfb5e833859090d4480e222@linux-foundation.org>
 <20260526190015.d4edd406962fcc3a1ee4cb53@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kent Overstreet <kent.overstreet@linux.dev>
In-Reply-To: <20260526190015.d4edd406962fcc3a1ee4cb53@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3iifskmbaqcd88158xpyapwj1bzuisjy
X-Rspamd-Queue-Id: 9D0744000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779859377-812206
X-HE-Meta: U2FsdGVkX19dhwmTeWAHG4XAySa8uWsHEkVFYW9zCs63l5yxm0goauQ1HCuEJfIRJCgE/PcwF3DiUE0Rn3ja6auf2ozKI1nsL+zcR+R+LTFPgYdSb+vLL7E5q2LSPVPmBtV99xIlO2tJhKTke+dorXliksqzGXFEgUaVbva1vYgmW9WgYBSr0bxoC0jzlBXIH5itZs0DxeH6/kcbnGlZUX+auxLRpU8EdWZGZwhVHRgXaY/oinjzXdyw/wu3FeO89zF3dgEiaRWWqeHERndrGwMxm0AcvMn2X6S3mVWAPsO0YFPr/28hQrIU0t1TcFjAlg5UCYAze7zIhc7WR+x/qYx58QIVebE/CbErCK+t9TTJuciMtlWE3HGeGzaDk0Hr4DyBsGrKu41MxfYjlFGkQv43DCYtwOZzaSej2ohqAZr9CP2blQcbJEXihD/i1dmdDl0PdY5AUH4gE2+WmIAnS5HBvHwoHjWrPR22wnlElDQXemlNbkWXXMMvr57dhFCrfO5uEHWFkXI0Y1Uz0pHmzhM7gkToEK7PW+PF2w8H0xKWOyZuDdl1abIy2sD3uhV2a6EhsB839Vf/VhJ9yvisk/x2YPuimPqGmixW/1MG8VyNtB650f/Y8qO9cVw4o489vKEaNsm3dtgbD9r+7G1dHcgt/0PKXsc9O/bCOcINNBerQsbNFcl5018itUnB0rXIb5WHdXTnbAHxWv0VfSeJxPWCYNuKu+TRm86CWs2Cy3dSTNSRZYOt+4RC4XNeZX/BZaU7RcP43/4cXc87tvPcumf+C6x4AI6XuqGRLSyFXAijsokM2spFd+UGctT2D7+UZG4RbM0YnO3DQMMEl9OnEZieuLfQ/Z+0El5EWLbn82vXJweLJix5I8qIgyFP0ecDS4k8E8TLmdiz7xO3BvJQUaOvuvKck00+4oqc5gnhKw7PQO9x7Sz8XyrARj5as7sfu0RsvrnEG5F1ipn5l5q
 6e2QGQus
 eFVultr1UeMJSMe+f/Y5XUvSIJcC4Of6PlhG9KuSY7sD4rlGMrKuEMMFvRt2NQj6EztSPdqJRHct/wG7S8vMtn61QkHvSo2t2DrwmDLI9XKdPUeXz5wMamF0tVmvC/6xDWWXdnWdQcdB3IcVoLDtEXzfCwQPzMv8zHL5WPlf3px0RKDGIxYjjrWvv5C30yRIe94XPIPfzd8nwoKaUOhUEbs/hM/2KAyMN1xDucDkXPTOSyk63JknckWGsqbSaiSoqoltnp7oh33Qg4rraN/TqifZqv3tewGpog6pIw9YPPb7b7q3lPd657fcdUZwRFHPjYv1/1MNJNS8mvSQxRx9YyvIy0qGeoC2Vcv+UpOGzFvOAIdxh5fUCR8UufmUZbelkbbbHbhTNMgQTfRzH0Djs7PX13jLMjrGIbnnxbx2mxtLRE5SO2ScJzb+i9f9OvGxh4ypzpkmcTufT6gbf4PVX8ki0bjx7HQXhlRp+pQzJ0FO19WJ365rIYQJMvxV21XK1ZEEf/JXv+OFAAgIY6DAn2ZuYMzr+ykJMlD2vU+X5HhXenTILD7Z8fa3Rn8aQjA+EVkLgy8jvzJP795Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/5/27 10:00, Andrew Morton wrote:
> On Fri, 8 May 2026 17:12:51 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Wed,  6 May 2026 10:22:56 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>
>>> Pages allocated before page_ext is available have their codetag left
>>> uninitialized. Track these early PFNs and clear their codetag in
>>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
>>> warnings when they are freed later.
>>>
>>> Currently a fixed-size array of 8192 entries is used, with a warning if
>>> the limit is exceeded. However, the number of early allocations depends
>>> on the number of CPUs and can be larger than 8192.
>>>
>>> Replace the fixed-size array with a dynamically allocated linked list
>>> of pfn_pool structs. Each node is allocated via alloc_page() and mapped
>>> to a pfn_pool containing a next pointer, an atomic slot counter, and a
>>> PFN array that fills the remainder of the page.
>>>
>>> The tracking pages themselves are allocated via alloc_page(), which
>>> would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
>>> recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
>>> %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
>>> so that the early path can skip recording allocations that carry this
>>> flag.
>> AI review asked a couple of things.  I have a feeling we saw at least
>> one of these, so probably already dealt with.
>> 	https://sashiko.dev/#/patchset/20260506022256.32664-1-hao.ge@linux.dev

Hi Andrew

My apologies. I'm also waiting for Suren's review. He may have been tied 
up lately

and might not have time to get to this.


Sashiko raised two issues this time. I've already responded to the first 
one.

See the link below:

https://lore.kernel.org/all/0b9969e2-b208-46c2-a9a5-bf620239275a@linux.dev/

If I haven't missed any details, it should be a false positive.


As for the second point, let me address it.

The early PFN tracking window is entirely within mm_core_init(),

which is called from start_kernel():

start_kernel()

     mm_core_init()

         memblock_free_all();

         mem_init() //start early PFN tracking

         kmem_cache_init()                           // SLUB bootstrap + 
kmalloc caches
...
         page_ext_init()                                   // clears 
alloc_tag_add_early_pfn_ptr

     ...

     rest_init() //spawns kernel_init thread


kernel_init() → kernel_init_freeable()            // separate thread, later

     smp_init()                                    // secondary CPUs 
come online here

Within the early PFN window (mem_init() to page_ext_init()):

  1. We are still in start_kernel(), single CPU. The buddy allocator

was just initialized from memblock and should have plenty of free

pages, so alloc_page() would likely be satisfied from the fast

path. If so, the __GFP_NOFAIL without __GFP_DIRECT_RECLAIM

check in the slowpath would not be reached.

2. Since only the boot CPU is running, alloc_page() targets the

boot node, which has memory. So even if __GFP_THISNODE were

inherited, it would not fail on the boot node during this window.


So Sashiko's analysis applies to the general case, and indeed the issues

he raised could occur there.

However, in the early boot scenario, I believe the current patch is safe,

even though it is not fully generic (after all, no one can predict 
future use cases).

Therefore, I agree with his suggestion that using a clean mask like  
GFP_NOWAIT | __GFP_NOWARN.


In any case, I will wait for your and Suren's feedback. You may have 
different opinions on this matter.


Thanks

Best Regards

Hao


> Please?
>
> Also, this patch has no evidence of human review.
>
>
> From: Hao Ge <hao.ge@linux.dev>
> Subject: mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
> Date: Wed, 6 May 2026 10:22:56 +0800
>
> Pages allocated before page_ext is available have their codetag left
> uninitialized.  Track these early PFNs and clear their codetag in
> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set" warnings
> when they are freed later.
>
> Currently a fixed-size array of 8192 entries is used, with a warning if
> the limit is exceeded.  However, the number of early allocations depends
> on the number of CPUs and can be larger than 8192.
>
> Replace the fixed-size array with a dynamically allocated linked list of
> pfn_pool structs.  Each node is allocated via alloc_page() and mapped to a
> pfn_pool containing a next pointer, an atomic slot counter, and a PFN
> array that fills the remainder of the page.
>
> The tracking pages themselves are allocated via alloc_page(), which would
> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
> indefinitely.  Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
> bit) and pass gfp_flags through pgalloc_tag_add() so that the early path
> can skip recording allocations that carry this flag.
>
> Link: https://lore.kernel.org/20260506022256.32664-1-hao.ge@linux.dev
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   include/linux/alloc_tag.h |    4
>   lib/alloc_tag.c           |  145 +++++++++++++++++++++++-------------
>   mm/page_alloc.c           |   12 +-
>   3 files changed, 102 insertions(+), 59 deletions(-)
>
> --- a/include/linux/alloc_tag.h~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
> +++ a/include/linux/alloc_tag.h
> @@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(u
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
> --- a/lib/alloc_tag.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
> +++ a/lib/alloc_tag.c
> @@ -767,60 +767,95 @@ static __init bool need_page_alloc_taggi
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
> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
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
> +			gfp_t gfp = gfp_flags & ~(__GFP_DIRECT_RECLAIM | GFP_ZONEMASK);
> +			struct page *new_page = alloc_page(gfp | __GFP_NO_CODETAG);
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
> -typedef void alloc_tag_add_func(unsigned long pfn);
> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
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
> -		alloc_tag_add(pfn);
> +		alloc_tag_add(pfn, gfp_flags);
>   	rcu_read_unlock();
>   }
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
> @@ -829,37 +864,45 @@ static void __init clear_early_alloc_pfn
>   	/* Make sure we are not racing with __alloc_tag_add_early_pfn() */
>   	synchronize_rcu();
>   
> -	for (i = 0; i < atomic_read(&early_pfn_count); i++) {
> -		unsigned long pfn = early_pfns[i];
> +	for (pool = current_pfn_pool; pool; pool = next) {
> +		int nr_pfns = atomic_read(&pool->count);
> +
> +		for (i = 0; i < nr_pfns; i++) {
> +			unsigned long pfn = pool->pfns[i];
>   
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
> --- a/mm/page_alloc.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
> +++ a/mm/page_alloc.c
> @@ -1255,7 +1255,7 @@ void __clear_page_tag_ref(struct page *p
>   /* Should be called only if mem_alloc_profiling_enabled() */
>   static noinline
>   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> -		       unsigned int nr)
> +		       unsigned int nr, gfp_t gfp_flags)
>   {
>   	union pgtag_ref_handle handle;
>   	union codetag_ref ref;
> @@ -1269,17 +1269,17 @@ void __pgalloc_tag_add(struct page *page
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
> @@ -1312,7 +1312,7 @@ static inline void pgalloc_tag_sub_pages
>   #else /* CONFIG_MEM_ALLOC_PROFILING */
>   
>   static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
> -				   unsigned int nr) {}
> +				   unsigned int nr, gfp_t gfp_flags) {}
>   static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
>   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
>   
> @@ -1867,7 +1867,7 @@ inline void post_alloc_hook(struct page
>   
>   	set_page_owner(page, order, gfp_flags);
>   	page_table_check_alloc(page, order);
> -	pgalloc_tag_add(page, current, 1 << order);
> +	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
>   }
>   
>   static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
> _
>

