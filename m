Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B618CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8536B0005; Wed,  3 Jun 2026 22:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78CD6B0088; Wed,  3 Jun 2026 22:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9943D6B008A; Wed,  3 Jun 2026 22:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87B736B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:47:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E0411C1F0D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:47:24 +0000 (UTC)
X-FDA: 84840694008.02.8C6CF36
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4AB9DC000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:47:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bL3Wec/F";
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780541242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oc2cFp0FMXbmvOjO2kTB3hYUBYCGypWm+I/Pq6w+9FI=;
	b=qudVFTL5+tRrWJB3ZgaQIv+dCpTOX2YW10dGSI0l0mPPyDR2ZFGRdQLUSvjyvZ7oFG1sYx
	o2y95hln5UYDLQ8BQciSzviydtS4Y1/UKb8V64+TxUcnnIxMDJGJ0xFkV6zIYgWcWLrgQ8
	/AL/td9YTAdv9VqA0ZB4OoCKE6i9lgA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bL3Wec/F";
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780541242;
	b=QIooMgWmYOZmM+aEhyphhszGSYTSEhn3lsWrxu0t8uvRlMHBmzC4IfFfmJDrcrsNBqjx4D
	BXpIO5qOjR1jKqE3L3Aq24rMX5t0WQFRuAh4dRv4ZgJwc8dS2xQl+SfW5g17IaO6TViJak
	7bF7BRGVOxlLwRkG83/FENxMaKl1WJQ=
Message-ID: <edb60c5c-5d94-4d85-860e-8c0d4537fcb3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780541238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc2cFp0FMXbmvOjO2kTB3hYUBYCGypWm+I/Pq6w+9FI=;
	b=bL3Wec/Fnr4AMwjhDB7/+OlXhmT3Oki+1MGaYSjrFOhLCnooIex9Ajyc4hN6M6wG/045Vy
	6YQGJDTtOB+SoeIkVmQJ4Pl3GVd+RtBAXyATKpF2TrUt9UkpSWB1IGU7rnZowOzawI1TZd
	FCtXNNiN/ES1o/qiANLKhEKu8QllPcA=
Date: Thu, 4 Jun 2026 10:46:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20260506022256.32664-1-hao.ge@linux.dev>
 <20260508171251.9bfb5e833859090d4480e222@linux-foundation.org>
 <20260526190015.d4edd406962fcc3a1ee4cb53@linux-foundation.org>
 <0e835109-9068-464f-88e2-c1847cd34c71@linux.dev>
 <CAJuCfpGjPFbd+Fw52_cz-HSQZndUDDiGTXH38y8U-6sZF4=YwA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGjPFbd+Fw52_cz-HSQZndUDDiGTXH38y8U-6sZF4=YwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4AB9DC000D
X-Stat-Signature: 4dexwthu9n19zsftheq7wzcnknem497r
X-Rspam-User: 
X-HE-Tag: 1780541242-666958
X-HE-Meta: U2FsdGVkX1/IkrLGVgAIwKGYWaroOW9L9BqioYvY8I9eVbv+EfYkvjJbCNan/d6c9mz9R+KDllR6VwZVx4JDF2k9QPDA+d3FRXNgMW3snqlw70KgB4WZpCkUvd5QuvY9mEslxZX11nf0a7QAKjuzLP15juArr9xARt5wNFM33XPULKE26Lj87gBRO89HFzFz7YrLz2TiE3YTJYcdPC9ADOk1LsV0EJa04GxuiYAPXSVaEaoIlFmB3WlqIYJnUth5NBXRa0J7KwJs0O8L0PibgYyDnkHWghgYBo4e6C8AS05VmVmA44yMRAr+xFRTImzhTBpk9Gia4IcaBwBNMGsUk131THKSeNProd4eWZnAayxIW1SJ4IMtDdwvEFRpuVpWmOfYjbCfeqVVQI3/6l7AuKYhorDIVCzubN0sw67ZRAMr1+3iQySV+lDOlfA0gGkXK6qpz5n2esZpNaDUGDbUSEyoZZX/hTGoaMzEpNCSjG6wbs39FYUPDkftrwlbHjnSVJcSngJ61olXEFpntsVEKLiZFQG2bkkiDzVjD3iNOOlEktXfHv/SjzY0qayHm7PsUxYFPXnlbI1ckZw1xoeGBm+5tw1DsiZuKmRo6O5tEaPSKvZIfY5X7hkBjLKHh6BMXVB40MfGvYYf9v2Bg40ibdH7QEpQEMfS8DwteoMZIw4iA2lr2sPgmzvp2GrtRySP9egSq4Qsr9qdh1V0bR+MS7sUCPY4NsLixXxyolnbWoUANjHpGPA0/v5xPcQJbCyyzh5cFCG0cZlunJQ1B1xoNotjkZP7Y2yv/hSgbGdy8Cp59N6ELj7jO5fXazw68tTedyjX2VaEv9GxUFZDJuelGTsedqkUF5LNqG5e1XAtB4tNM+18gJI3W+rVOtwt88YvWUXXtyYv/fLt2rzyqiGSCf6atm4ITFDTl60NCuJwIVf8+5zcRQ2MLPQ+68PG+BSne7jwY5PIajd8SjuU5YJ
 glMOqwnN
 1qvg/PV5gcUvffMekfE7ucVMmYvaL6UTwb3vXVFpeE7MNnjwZV2vqMsTJuhGcZZto7l/XYeslly2cg7vE1Y8sY77kUBzFF6zYvHPgfXHjy2o7hgpMZ4lwxndtLpWW/yZVHv4HipLdF7sK6JiYNqLq8IhG256iHqeU4JCAXPaS87S04d2BNZqdyFCC2qIOx5aJyL+f9hF2ack8PP0vYdK2VYsKkCd4IkNFyU0EoQGruKp6TSHcTy7mJHXtFyykfhAA4SXoTn+ytsee3U2vKCZ06/H5QGY17Ibap5DiNtgAqB6y1xO4QYbdRTJmshWDEx1hTGzE3JTupOcPnO0MCrhOKuRFOe0S6gDZ3uGwY+LGNtOwoIJ9UJwuNuGzFFc67kpAFxKktMPpCBrs/YY+zbhjqszfpIbcNnkwENtfXuqncETWHZBsG/ugQfihJ5d8FdCuav/Um6FS1vwCyk8Y+6KAiml76dzTC1ENGmLXv2Z4lh7c1xAIPg08gW18MSkyxdhBUZmHCfcFgU+E3uWIOfiXBk2sxZ4C1WXcLQTvTVQUXSkZIRi83UeCDtqqPfiWMd0t+BQrarRgD+tgWY/8JSRy/bXXPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/4 00:54, Suren Baghdasaryan wrote:
> On Tue, May 26, 2026 at 10:22 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> On 2026/5/27 10:00, Andrew Morton wrote:
>>> On Fri, 8 May 2026 17:12:51 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>> On Wed,  6 May 2026 10:22:56 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>>>
>>>>> Pages allocated before page_ext is available have their codetag left
>>>>> uninitialized. Track these early PFNs and clear their codetag in
>>>>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
>>>>> warnings when they are freed later.
>>>>>
>>>>> Currently a fixed-size array of 8192 entries is used, with a warning if
>>>>> the limit is exceeded. However, the number of early allocations depends
>>>>> on the number of CPUs and can be larger than 8192.
>>>>>
>>>>> Replace the fixed-size array with a dynamically allocated linked list
>>>>> of pfn_pool structs. Each node is allocated via alloc_page() and mapped
>>>>> to a pfn_pool containing a next pointer, an atomic slot counter, and a
>>>>> PFN array that fills the remainder of the page.
>>>>>
>>>>> The tracking pages themselves are allocated via alloc_page(), which
>>>>> would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
>>>>> recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
>>>>> %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
>>>>> so that the early path can skip recording allocations that carry this
>>>>> flag.
>>>> AI review asked a couple of things.  I have a feeling we saw at least
>>>> one of these, so probably already dealt with.
>>>>       https://sashiko.dev/#/patchset/20260506022256.32664-1-hao.ge@linux.dev
>> Hi Andrew
>>
>> My apologies. I'm also waiting for Suren's review. He may have been tied
>> up lately
>>
>> and might not have time to get to this.
>>
>>
>> Sashiko raised two issues this time. I've already responded to the first
>> one.
>>
>> See the link below:
>>
>> https://lore.kernel.org/all/0b9969e2-b208-46c2-a9a5-bf620239275a@linux.dev/
>>
>> If I haven't missed any details, it should be a false positive.
> That seems to be the case. I wonder why Sashiko did not consider
> that... CC'ing Roman to see if Sashiko can be improved (unless we both
> are missing something).
>
>>
>> As for the second point, let me address it.
>>
>> The early PFN tracking window is entirely within mm_core_init(),
>>
>> which is called from start_kernel():
>>
>> start_kernel()
>>
>>       mm_core_init()
>>
>>           memblock_free_all();
>>
>>           mem_init() //start early PFN tracking
>>
>>           kmem_cache_init()                           // SLUB bootstrap +
>> kmalloc caches
>> ...
>>           page_ext_init()                                   // clears
>> alloc_tag_add_early_pfn_ptr
>>
>>       ...
>>
>>       rest_init() //spawns kernel_init thread
>>
>>
>> kernel_init() → kernel_init_freeable()            // separate thread, later
>>
>>       smp_init()                                    // secondary CPUs
>> come online here
>>
>> Within the early PFN window (mem_init() to page_ext_init()):
>>
>>    1. We are still in start_kernel(), single CPU. The buddy allocator
>>
>> was just initialized from memblock and should have plenty of free
>>
>> pages, so alloc_page() would likely be satisfied from the fast
>>
>> path. If so, the __GFP_NOFAIL without __GFP_DIRECT_RECLAIM
>>
>> check in the slowpath would not be reached.
>>
>> 2. Since only the boot CPU is running, alloc_page() targets the
>>
>> boot node, which has memory. So even if __GFP_THISNODE were
>>
>> inherited, it would not fail on the boot node during this window.
>>
>>
>> So Sashiko's analysis applies to the general case, and indeed the issues
>>
>> he raised could occur there.
>>
>> However, in the early boot scenario, I believe the current patch is safe,
>>
>> even though it is not fully generic (after all, no one can predict
>> future use cases).
>>
>> Therefore, I agree with his suggestion that using a clean mask like
>> GFP_NOWAIT | __GFP_NOWARN.

Hi Suren

I've been thinking about the GFP flags issue for the past few days. 
There are actually a couple of issues

with the suggestion of using GFP_NOWAIT | __GFP_NOWARN.

First, GFP_NOWAIT already includes __GFP_NOWARN, so it's redundant.

Second, GFP_NOWAIT also includes __GFP_KSWAPD_RECLAIM, which is exactly 
the same issue he flagged

previously with GFP_ATOMIC — it can still trigger wakeup_kswapd() and 
acquire scheduler locks, leading to

potential deadlock in the same scenario he described.

So I think __GFP_HIGH | __GFP_NO_CODETAG is the right choice.

Since this runs under rcu_read_lock(), we can't have __GFP_DIRECT_RECLAIM.

And since Sashiko pointed out the scheduler lock concern with 
__GFP_KSWAPD_RECLAIM,

we can't have that either.

I have posted the v6 revision, would you please kindly review it at your 
convenience?

https://lore.kernel.org/all/20260604024008.46592-1-hao.ge@linux.dev/

Thanks

Best Regards

Hao

> This sounds good to me. With that change feel free to add:
>
> Acked-by: Suren Baghdasaryan <surenb@google.com>
>
>>
>> In any case, I will wait for your and Suren's feedback. You may have
>> different opinions on this matter.
>>
>>
>> Thanks
>>
>> Best Regards
>>
>> Hao
>>
>>
>>> Please?
>>>
>>> Also, this patch has no evidence of human review.
>>>
>>>
>>> From: Hao Ge <hao.ge@linux.dev>
>>> Subject: mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
>>> Date: Wed, 6 May 2026 10:22:56 +0800
>>>
>>> Pages allocated before page_ext is available have their codetag left
>>> uninitialized.  Track these early PFNs and clear their codetag in
>>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set" warnings
>>> when they are freed later.
>>>
>>> Currently a fixed-size array of 8192 entries is used, with a warning if
>>> the limit is exceeded.  However, the number of early allocations depends
>>> on the number of CPUs and can be larger than 8192.
>>>
>>> Replace the fixed-size array with a dynamically allocated linked list of
>>> pfn_pool structs.  Each node is allocated via alloc_page() and mapped to a
>>> pfn_pool containing a next pointer, an atomic slot counter, and a PFN
>>> array that fills the remainder of the page.
>>>
>>> The tracking pages themselves are allocated via alloc_page(), which would
>>> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
>>> indefinitely.  Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
>>> bit) and pass gfp_flags through pgalloc_tag_add() so that the early path
>>> can skip recording allocations that carry this flag.
>>>
>>> Link: https://lore.kernel.org/20260506022256.32664-1-hao.ge@linux.dev
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>>> Cc: Brendan Jackman <jackmanb@google.com>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Cc: Kent Overstreet <kent.overstreet@linux.dev>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Vlastimil Babka <vbabka@kernel.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>>
>>>    include/linux/alloc_tag.h |    4
>>>    lib/alloc_tag.c           |  145 +++++++++++++++++++++++-------------
>>>    mm/page_alloc.c           |   12 +-
>>>    3 files changed, 102 insertions(+), 59 deletions(-)
>>>
>>> --- a/include/linux/alloc_tag.h~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
>>> +++ a/include/linux/alloc_tag.h
>>> @@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(u
>>>    {
>>>        WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
>>>    }
>>> -void alloc_tag_add_early_pfn(unsigned long pfn);
>>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
>>>    #else
>>>    static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
>>>    static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
>>> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
>>> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
>>>    #endif
>>>
>>>    /* Caller should verify both ref and tag to be valid */
>>> --- a/lib/alloc_tag.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
>>> +++ a/lib/alloc_tag.c
>>> @@ -767,60 +767,95 @@ static __init bool need_page_alloc_taggi
>>>     * their codetag uninitialized. Track these early PFNs so we can clear
>>>     * their codetag refs later to avoid warnings when they are freed.
>>>     *
>>> - * Early allocations include:
>>> - *   - Base allocations independent of CPU count
>>> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
>>> - *     such as trace ring buffers, scheduler per-cpu data)
>>> - *
>>> - * For simplicity, we fix the size to 8192.
>>> - * If insufficient, a warning will be triggered to alert the user.
>>> + * Each page is cast to a pfn_pool: the first few bytes hold metadata
>>> + * (next pointer and slot count), the remainder stores PFNs.
>>> + */
>>> +struct pfn_pool {
>>> +     struct pfn_pool *next;
>>> +     atomic_t count;
>>> +     unsigned long pfns[];
>>> +};
>>> +
>>> +#define PFN_POOL_SIZE                        ((PAGE_SIZE - offsetof(struct pfn_pool, pfns)) / \
>>> +                                      sizeof(unsigned long))
>>> +
>>> +/*
>>> + * Skip early PFN recording for a page allocation.  Reuses the
>>> + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
>>> + * recursion when allocating pages for the early PFN tracking list
>>> + * itself.
>>>     *
>>> - * TODO: Replace fixed-size array with dynamic allocation using
>>> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
>>> + * Codetags of the pages allocated with __GFP_NO_CODETAG should be
>>> + * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
>>> + * alloc_tag_sub_check() from triggering a warning.
>>>     */
>>> -#define EARLY_ALLOC_PFN_MAX          8192
>>> +#define __GFP_NO_CODETAG             __GFP_NO_OBJ_EXT
>>>
>>> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
>>> -static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
>>> +static struct pfn_pool *current_pfn_pool __initdata;
>>>
>>> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>>> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>>>    {
>>> -     int old_idx, new_idx;
>>> +     struct pfn_pool *pool;
>>> +     int idx;
>>>
>>>        do {
>>> -             old_idx = atomic_read(&early_pfn_count);
>>> -             if (old_idx >= EARLY_ALLOC_PFN_MAX) {
>>> -                     pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
>>> -                                   EARLY_ALLOC_PFN_MAX);
>>> -                     return;
>>> +             pool = READ_ONCE(current_pfn_pool);
>>> +             if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
>>> +                     gfp_t gfp = gfp_flags & ~(__GFP_DIRECT_RECLAIM | GFP_ZONEMASK);
>>> +                     struct page *new_page = alloc_page(gfp | __GFP_NO_CODETAG);
>>> +                     struct pfn_pool *new;
>>> +
>>> +                     if (!new_page) {
>>> +                             pr_warn_once("early PFN tracking page allocation failed\n");
>>> +                             return;
>>> +                     }
>>> +                     new = page_address(new_page);
>>> +                     new->next = pool;
>>> +                     atomic_set(&new->count, 0);
>>> +                     if (cmpxchg(&current_pfn_pool, pool, new) != pool) {
>>> +                             clear_page_tag_ref(new_page);
>>> +                             __free_page(new_page);
>>> +                             continue;
>>> +                     }
>>> +                     pool = new;
>>>                }
>>> -             new_idx = old_idx + 1;
>>> -     } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
>>> +             idx = atomic_read(&pool->count);
>>> +             if (idx >= PFN_POOL_SIZE)
>>> +                     continue;
>>> +             if (atomic_cmpxchg(&pool->count, idx, idx + 1) == idx)
>>> +                     break;
>>> +     } while (1);
>>>
>>> -     early_pfns[old_idx] = pfn;
>>> +     pool->pfns[idx] = pfn;
>>>    }
>>>
>>> -typedef void alloc_tag_add_func(unsigned long pfn);
>>> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
>>>    static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
>>>        RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>>>
>>> -void alloc_tag_add_early_pfn(unsigned long pfn)
>>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>>>    {
>>>        alloc_tag_add_func *alloc_tag_add;
>>>
>>>        if (static_key_enabled(&mem_profiling_compressed))
>>>                return;
>>>
>>> +     /* Skip allocations for the tracking list itself to avoid recursion. */
>>> +     if (gfp_flags & __GFP_NO_CODETAG)
>>> +             return;
>>> +
>>>        rcu_read_lock();
>>>        alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
>>>        if (alloc_tag_add)
>>> -             alloc_tag_add(pfn);
>>> +             alloc_tag_add(pfn, gfp_flags);
>>>        rcu_read_unlock();
>>>    }
>>>
>>>    static void __init clear_early_alloc_pfn_tag_refs(void)
>>>    {
>>> -     unsigned int i;
>>> +     struct pfn_pool *pool, *next;
>>> +     struct page *page;
>>> +     int i;
>>>
>>>        if (static_key_enabled(&mem_profiling_compressed))
>>>                return;
>>> @@ -829,37 +864,45 @@ static void __init clear_early_alloc_pfn
>>>        /* Make sure we are not racing with __alloc_tag_add_early_pfn() */
>>>        synchronize_rcu();
>>>
>>> -     for (i = 0; i < atomic_read(&early_pfn_count); i++) {
>>> -             unsigned long pfn = early_pfns[i];
>>> +     for (pool = current_pfn_pool; pool; pool = next) {
>>> +             int nr_pfns = atomic_read(&pool->count);
>>> +
>>> +             for (i = 0; i < nr_pfns; i++) {
>>> +                     unsigned long pfn = pool->pfns[i];
>>>
>>> -             if (pfn_valid(pfn)) {
>>> -                     struct page *page = pfn_to_page(pfn);
>>> -                     union pgtag_ref_handle handle;
>>> -                     union codetag_ref ref;
>>> -
>>> -                     if (get_page_tag_ref(page, &ref, &handle)) {
>>> -                             /*
>>> -                              * An early-allocated page could be freed and reallocated
>>> -                              * after its page_ext is initialized but before we clear it.
>>> -                              * In that case, it already has a valid tag set.
>>> -                              * We should not overwrite that valid tag with CODETAG_EMPTY.
>>> -                              *
>>> -                              * Note: there is still a small race window between checking
>>> -                              * ref.ct and calling set_codetag_empty(). We accept this
>>> -                              * race as it's unlikely and the extra complexity of atomic
>>> -                              * cmpxchg is not worth it for this debug-only code path.
>>> -                              */
>>> -                             if (ref.ct) {
>>> +                     if (pfn_valid(pfn)) {
>>> +                             union pgtag_ref_handle handle;
>>> +                             union codetag_ref ref;
>>> +
>>> +                             if (get_page_tag_ref(pfn_to_page(pfn), &ref, &handle)) {
>>> +                                     /*
>>> +                                      * An early-allocated page could be freed and reallocated
>>> +                                      * after its page_ext is initialized but before we clear it.
>>> +                                      * In that case, it already has a valid tag set.
>>> +                                      * We should not overwrite that valid tag
>>> +                                      * with CODETAG_EMPTY.
>>> +                                      *
>>> +                                      * Note: there is still a small race window between checking
>>> +                                      * ref.ct and calling set_codetag_empty(). We accept this
>>> +                                      * race as it's unlikely and the extra complexity of atomic
>>> +                                      * cmpxchg is not worth it for this debug-only code path.
>>> +                                      */
>>> +                                     if (ref.ct) {
>>> +                                             put_page_tag_ref(handle);
>>> +                                             continue;
>>> +                                     }
>>> +
>>> +                                     set_codetag_empty(&ref);
>>> +                                     update_page_tag_ref(handle, &ref);
>>>                                        put_page_tag_ref(handle);
>>> -                                     continue;
>>>                                }
>>> -
>>> -                             set_codetag_empty(&ref);
>>> -                             update_page_tag_ref(handle, &ref);
>>> -                             put_page_tag_ref(handle);
>>>                        }
>>>                }
>>>
>>> +             next = pool->next;
>>> +             page = virt_to_page(pool);
>>> +             clear_page_tag_ref(page);
>>> +             __free_page(page);
>>>        }
>>>    }
>>>    #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>> --- a/mm/page_alloc.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
>>> +++ a/mm/page_alloc.c
>>> @@ -1255,7 +1255,7 @@ void __clear_page_tag_ref(struct page *p
>>>    /* Should be called only if mem_alloc_profiling_enabled() */
>>>    static noinline
>>>    void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>>> -                    unsigned int nr)
>>> +                    unsigned int nr, gfp_t gfp_flags)
>>>    {
>>>        union pgtag_ref_handle handle;
>>>        union codetag_ref ref;
>>> @@ -1269,17 +1269,17 @@ void __pgalloc_tag_add(struct page *page
>>>                 * page_ext is not available yet, record the pfn so we can
>>>                 * clear the tag ref later when page_ext is initialized.
>>>                 */
>>> -             alloc_tag_add_early_pfn(page_to_pfn(page));
>>> +             alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
>>>                if (task->alloc_tag)
>>>                        alloc_tag_set_inaccurate(task->alloc_tag);
>>>        }
>>>    }
>>>
>>>    static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
>>> -                                unsigned int nr)
>>> +                                unsigned int nr, gfp_t gfp_flags)
>>>    {
>>>        if (mem_alloc_profiling_enabled())
>>> -             __pgalloc_tag_add(page, task, nr);
>>> +             __pgalloc_tag_add(page, task, nr, gfp_flags);
>>>    }
>>>
>>>    /* Should be called only if mem_alloc_profiling_enabled() */
>>> @@ -1312,7 +1312,7 @@ static inline void pgalloc_tag_sub_pages
>>>    #else /* CONFIG_MEM_ALLOC_PROFILING */
>>>
>>>    static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
>>> -                                unsigned int nr) {}
>>> +                                unsigned int nr, gfp_t gfp_flags) {}
>>>    static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
>>>    static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
>>>
>>> @@ -1867,7 +1867,7 @@ inline void post_alloc_hook(struct page
>>>
>>>        set_page_owner(page, order, gfp_flags);
>>>        page_table_check_alloc(page, order);
>>> -     pgalloc_tag_add(page, current, 1 << order);
>>> +     pgalloc_tag_add(page, current, 1 << order, gfp_flags);
>>>    }
>>>
>>>    static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
>>> _
>>>

