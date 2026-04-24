Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11017FDEE5E
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081916B0005; Thu, 23 Apr 2026 22:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032FE6B008A; Thu, 23 Apr 2026 22:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62E36B008C; Thu, 23 Apr 2026 22:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBFCD6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:43:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 297E51B8E54
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:43:58 +0000 (UTC)
X-FDA: 84691904556.03.57FCBD0
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3837814000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:43:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DEJgBHtj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776998636; a=rsa-sha256;
	cv=none;
	b=FPFq4Ni7/6UVQ5vQO3ZPAcK6Jn+XTB3/ThN92orDcjXnEH2rqLiy5iqWesLzaILm4UvynQ
	L3IVaT+OyLxYl7eqOqhf9BYH46iDLh5wph4kl3nH02EKZCygd1dGWIyqAUMv/afQxd+rUV
	uUhcGyEGTTOjxD2CDXQWT25BWVAf730=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DEJgBHtj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776998636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RO4V253MZEIDTpHGw3UaYeZwGEgMYAIpsz+50OjDg3s=;
	b=BAZPSnZyr6AgDZs23TSZgc5NyWYsCE8xkZo7NRcVTQELetNSi7BB3vjwNDMY5VoDFw8Q3F
	JSZAHXCPJJqHEd4hTEG4lClxQWstyJIel/n5ZfDK2AMQlzlsp5PfovCzkAbFyir1Lg9VLh
	bTofTSEAy3zY4dAR4UTYQ4dKcPVK04w=
Message-ID: <e0902ce5-b817-44c2-b126-72948f8347d1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776998630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RO4V253MZEIDTpHGw3UaYeZwGEgMYAIpsz+50OjDg3s=;
	b=DEJgBHtjPqw00641ZXF36ORVQfB7pdivPsAM4HeEUO3cvc3k1lqAXg77D7hiMLKUdLjStJ
	hcBiCOoJah9m6Bo8mF9dLdoBGWTxHNBhmobjlM3pvu2Y3baJCJqCN8MBLDkwNSk9E3ISZa
	jBi3h9z5ab/p2Curm3nH+T4UQFQJvJo=
Date: Fri, 24 Apr 2026 10:43:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260421031406.1189000-1-hao.ge@linux.dev>
 <CAJuCfpHvCODeKG1y3Ndte9immkW6cUzqsaduOozSEhDv17x82w@mail.gmail.com>
 <a4d4ac18-fbae-4ace-8f1c-651c8fefcf38@linux.dev>
 <CAJuCfpGOd=p4UOkn1UF=KmAFL6Xxm4FGomZt83eRj_cjeUxAjw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGOd=p4UOkn1UF=KmAFL6Xxm4FGomZt83eRj_cjeUxAjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3837814000F
X-Rspamd-Server: rspam12
X-Stat-Signature: 9npai5fdyzisy183qoqn6zxdkxt3rt7d
X-Rspam-User: 
X-HE-Tag: 1776998635-106685
X-HE-Meta: U2FsdGVkX19pjy+aIvFkXdzARKQyiQiPNDtwtViM4cUE9v3U+G37NmB2JrwOIscPggvXOkzYKD5TXIiin9sz7bwNEsIJQ+Ov1aOJj72k0lzNZwGFNg29ObStTMhHZ5VRg8iDbXKRk0HDoAjXsiUEsXjFqJM38nfTIY3JACh2qT45tH+FC95DkWWy3BWarH49B/unhKMu1F1MKQd4wyM9ouk6tWFVPS4US0TOWTAEj3LVhbfN3ksKHS9ZfD9cxfH5W21cspQWVbCBXQ3dzxAOlqywqtd+iulJEM8iGdnGnyWSEOI0s3THin1VUugmUMX8VzbSegP9ZCZq2GyvhznBToDsPKmX4tLCyGYuZIrx1LVuXTTQ49DCSdIVA032dGyHSolyxaRJ28Ib05YoJUjiwpZq1p++p8k4jhdSkSYIbPVKEPhA45VaeiQUp4aYPzYfj0aOuhSyskUNgMchuFvnlQBQ0ljnPFuGyYEUQI841Zp7h7nttCUW4BwlKsvFSStqe7gdmnCPQP/DLkVyZN1DvuCczPBgh+BxTf1no7ac6wegQZ5fyuqLubbi3uZLavVs78MUxTFdcvcgXQ2bXHIcQyJhR9uqy2E+fr8yStzQOW6DF7riy/QCq6U0hDCf/Jc1Ol8huXSaA9uZvcOKbRiCd6G0H6AB5XghAU5bh3XZ0My0MC+chN6Jk1X11ojGsPwWdYqv6B2Zcug1OdzmfCu5KuG23yM1c2zyeXU2Vd2j+a8aqkOZI2+SJjL9l126FiRwKLrOxdqwr7KT1NGiI6X6fUDCe/JrUoa694tn2LFc+5/nluAF7BEQj/As+2yzijbLYxs9VAeWqWEdjc6VM1VqheiOZ7Rq5n+pV5JS/GAF8Ak+n7yPJVQjHLbQujaMlwMCqNTKZkvkSfCGKf7Sw/LpmJ2Y41ESu5R1ExecBvgKJVKWtvBIqEqhCvY5Vbbv2Ic7xv9ZmsVh+31ZvAA3DBL
 PmWXOIi9
 7ozD2D4jTXbYCICJ3SHv6G2vzd6HKAst/MwTUt+vuGqPDhHDlDqj0xdosnDP4rGm5yZfn8/a96w/bmeGpNUEKYJbCnFCqo17VdtKiOm98BQyrvoPl5sTkvhoSmwY7GR62/Wx+XuDncutMXuM9TK+IV4GWQKPVelzjOOdyO5S/v7jjS2hMK0K+vhLtVedVGQtcnwxNuPu81sq+XpiLlK0hQCfI6I/IMq3qHY0UBUgjG7zM6+HGsQDdIoiH/Km4vsxP9zWZozuhoBNoaBKdEtpiXoyGG2ZQ7l5sPeHOg1WrKzrE1Ljf2PVo5n5lMxI7B+spzw6Z0iBbbxD3cjoGG8kPhkTWaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/4/23 12:10, Suren Baghdasaryan wrote:
> On Wed, Apr 22, 2026 at 7:10 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> On 2026/4/23 01:32, Suren Baghdasaryan wrote:
>>> On Mon, Apr 20, 2026 at 8:15 PM Hao Ge <hao.ge@linux.dev> wrote:
>>>> Pages allocated before page_ext is available have their codetag left
>>>> uninitialized. Track these early PFNs and clear their codetag in
>>>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
>>>> warnings when they are freed later.
>>>>
>>>> Currently a fixed-size array of 8192 entries is used, with a warning if
>>>> the limit is exceeded. However, the number of early allocations depends
>>>> on the number of CPUs and can be larger than 8192.
>>>>
>>>> Replace the fixed-size array with a dynamically allocated linked list.
>>>> Each page is carved into early_pfn_node entries and the remainder is
>>>> kept as a freelist for subsequent allocations.
>>>>
>>>> The list nodes themselves are allocated via alloc_page(), which would
>>>> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() ->
>>>> alloc_early_pfn_node() and recurse indefinitely.  Introduce
>>>> __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT bit) and pass
>>>> gfp_flags through pgalloc_tag_add() so that the early path can skip
>>>> recording allocations that carry this flag.
>> Hi Suren
>>> Hi Hao,
>>> Thanks for following up on this!
>> Happy to help further develop this feature.
>>
>> Feel free to reach out if there's anything else I can do.
>>
>>
>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>>> ---
>>>> v2:
>>>> - Use cmpxchg to atomically update early_pfn_pages, preventing page leak under concurrent allocation
>>>> - Pass gfp_flags through the full call chain and use gfpflags_allow_blocking()
>>>>     to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC in process context
>>>> ---
>>>>    include/linux/alloc_tag.h |  22 +++++++-
>>>>    lib/alloc_tag.c           | 102 ++++++++++++++++++++++++++------------
>>>>    mm/page_alloc.c           |  29 +++++++----
>>>>    3 files changed, 108 insertions(+), 45 deletions(-)
>>>>
>>>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>>>> index 02de2ede560f..2fa695bd3c53 100644
>>>> --- a/include/linux/alloc_tag.h
>>>> +++ b/include/linux/alloc_tag.h
>>>> @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
>>>>    }
>>>>
>>>>    #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>>>> +/*
>>>> + * Skip early PFN recording for a page allocation.  Reuses the
>>>> + * %__GFP_NO_OBJ_EXT bit.  Used by alloc_early_pfn_node() to avoid
>>>> + * recursion when allocating pages for the early PFN tracking list
>>>> + * itself.
>>>> + *
>>>> + * Callers must set the codetag to CODETAG_EMPTY (via
>>>> + * clear_page_tag_ref()) before freeing pages allocated with this
>>>> + * flag once page_ext becomes available, otherwise
>>>> + * alloc_tag_sub_check() will trigger a warning.
>>>> + */
>>>> +#define __GFP_NO_CODETAG       __GFP_NO_OBJ_EXT
>>>> +
>>>> +static inline bool should_record_early_pfn(gfp_t gfp_flags)
>>>> +{
>>>> +       return !(gfp_flags & __GFP_NO_CODETAG);
>>>> +}
>>>>    static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag)
>>>>    {
>>>>           WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
>>>> @@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union codetag_ref *ref)
>>>>    {
>>>>           WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
>>>>    }
>>>> -void alloc_tag_add_early_pfn(unsigned long pfn);
>>>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
>>>>    #else
>>>>    static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
>>>>    static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
>>>> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
>>>> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
>>>> +static inline bool should_record_early_pfn(gfp_t gfp_flags) { return true; }
>>> If CONFIG_MEM_ALLOC_PROFILING_DEBUG=n why should we record early pfns?
>> Good point! I'll address this in the next patch.
>>>>    #endif
>>>>
>>>>    /* Caller should verify both ref and tag to be valid */
>>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>>>> index ed1bdcf1f8ab..cfc68e397eba 100644
>>>> --- a/lib/alloc_tag.c
>>>> +++ b/lib/alloc_tag.c
>>>> @@ -766,45 +766,75 @@ static __init bool need_page_alloc_tagging(void)
>>>>     * Some pages are allocated before page_ext becomes available, leaving
>>>>     * their codetag uninitialized. Track these early PFNs so we can clear
>>>>     * their codetag refs later to avoid warnings when they are freed.
>>>> - *
>>>> - * Early allocations include:
>>>> - *   - Base allocations independent of CPU count
>>>> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
>>>> - *     such as trace ring buffers, scheduler per-cpu data)
>>>> - *
>>>> - * For simplicity, we fix the size to 8192.
>>>> - * If insufficient, a warning will be triggered to alert the user.
>>>> - *
>>>> - * TODO: Replace fixed-size array with dynamic allocation using
>>>> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
>>>>     */
>>>> -#define EARLY_ALLOC_PFN_MAX            8192
>>>> +struct early_pfn_node {
>>>> +       struct early_pfn_node   *next;
>>>> +       unsigned long           pfn;
>>>> +};
>>>> +
>>>> +#define NODES_PER_PAGE         (PAGE_SIZE / sizeof(struct early_pfn_node))
>>>>
>>>> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
>>>> -static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
>>>> +static struct early_pfn_node *early_pfn_list __initdata;
>>>> +static struct early_pfn_node *early_pfn_freelist __initdata;
>>>> +static struct page *early_pfn_pages __initdata;
>>> This early_pfn_node linked list seems overly complex. Why not just
>>> allocate a page and use page->lru to place it into a linked list? I
>>> think the code will end up much simpler.
>> Ah, yes! You mentioned this before, but I misunderstood your point.
>>
>> I apologize for the confusion. I'll optimize this in the next revision.
>>
>>>> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>>>> +static struct early_pfn_node *__init alloc_early_pfn_node(gfp_t gfp_flags)
>>>>    {
>>>> -       int old_idx, new_idx;
>>>> +       struct early_pfn_node *ep, *new;
>>>> +       struct page *page, *old_page;
>>>> +       gfp_t gfp = gfpflags_allow_blocking(gfp_flags) ? GFP_KERNEL : GFP_ATOMIC;
>>>> +       int i;
>>>> +
>>>> +retry:
>>>> +       ep = READ_ONCE(early_pfn_freelist);
>>>> +       if (ep) {
>>>> +               struct early_pfn_node *next = READ_ONCE(ep->next);
>>>> +
>>>> +               if (try_cmpxchg(&early_pfn_freelist, &ep, next))
>>>> +                       return ep;
>>>> +               goto retry;
>>>> +       }
>>>> +
>>>> +       page = alloc_page(gfp | __GFP_NO_CODETAG | __GFP_ZERO);
>> One more question: since this is called in an RCU context, should we use
>> GFP_ATOMIC by default?
> You mean it might be called in RCU context, right? If so then I think
> we should not use GFP_ATOMIC when GFP_KERNEL can be used.

Hi Suren

__alloc_tag_add_early_pfn() is invoked under rcu_read_lock(). The full 
call chain is:

post_alloc_hook()

-> pgalloc_tag_add()

     -> __pgalloc_tag_add()

         -> alloc_tag_add_early_pfn(pfn, gfp_flags)

                 rcu_read_lock();

                     alloc_tag_add(pfn, gfp_flags)

                         -> __alloc_tag_add_early_pfn()

                         -> alloc_page(gfp)      // lib/alloc_tag.c:783

                 rcu_read_unlock();

>
>> Also, should we remove GFP_KSWAPD_RECLAIM here? I'm not entirely sure,
>> but I recall Sashiko mentioned a warning about this before:
>>
>> ---
>>
>> page = alloc_page(GFP_ATOMIC | __GFP_NO_CODETAG | __GFP_ZERO);
>>
>> Sashiko's concerns:
>>
>> Can this lead to a deadlock by introducing lock recursion?
>> alloc_early_pfn_node() is invoked as a post-allocation hook for early boot
>> pages via pgalloc_tag_add(). GFP_ATOMIC includes __GFP_KSWAPD_RECLAIM,
>> which triggers wakeup_kswapd() and acquires scheduler locks.
>> If the original allocation was made under scheduler locks and intentionally
>> stripped __GFP_KSWAPD_RECLAIM to prevent recursion, does this hardcoded
>> GFP_ATOMIC force it back on? Should the hook inherit or constrain its flags
>> based on the caller's gfp_flags instead?
>>
>> ---
>>
>> Even though this only happens during early boot, should we handle it
>> more safely?
> That seems reasonable. Any reason you are not doing simply: page =
> alloc_page(gfp_flags | __GFP_NO_CODETAG | __GFP_ZERO); ? IOW why
> aren't you simply inheriting the flags?

As I described above, __alloc_tag_add_early_pfn() is invoked under 
rcu_read_lock().

We cannot simply pass through gfp_flags, since it may cause sleep,

That is the reason why I chose to use GFP_ATOMIC initially.

Thanks

Best Ragards

Hao

>>>> +       if (!page)
>>>> +               return NULL;
>>>> +
>>>> +       new = page_address(page);
>>>> +       for (i = 0; i < NODES_PER_PAGE - 1; i++)
>>>> +               new[i].next = &new[i + 1];
>>>> +       new[NODES_PER_PAGE - 1].next = NULL;
>>>> +
>>>> +       if (cmpxchg(&early_pfn_freelist, NULL, new + 1)) {
>>>> +               __free_page(page);
>>>> +               goto retry;
>>>> +       }
>>>>
>>>>           do {
>>>> -               old_idx = atomic_read(&early_pfn_count);
>>>> -               if (old_idx >= EARLY_ALLOC_PFN_MAX) {
>>>> -                       pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
>>>> -                                     EARLY_ALLOC_PFN_MAX);
>>>> -                       return;
>>>> -               }
>>>> -               new_idx = old_idx + 1;
>>>> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
>>>> +               old_page = READ_ONCE(early_pfn_pages);
>>>> +               page->private = (unsigned long)old_page;
>>>> +       } while (cmpxchg(&early_pfn_pages, old_page, page) != old_page);
>>> I don't think this whole lockless schema is worth the complexity.
>>> alloc_early_pfn_node() is called only during early init and is called
>>> perhaps a few hundred times in total. Why not use a simple spinlock to
>>> synchronize this operation and be done with it?
>> I initially used a simple spinlock, but Sashiko raised a good point in
>> his review:
>>
>> https://sashiko.dev/#/patchset/20260319083153.2488005-1-hao.ge%40linux.dev
>>
>> Since alloc_early_pfn_node() is called during early init from an unknown
>> context, in the early page allocation path,
>>
>> a lockless approach is safer. However, you're right that if we use
>> page->lru as a linked list (which you suggested earlier),
>>
>> the code becomes much simpler. I plan to simplify the code and continue
>> using the lockless approach in the next version.
> Ok, let's see the result and decide then. Allocating a page from NMI
> context sounds extreme to me. I would expect NMI context to use only
> preallocated memory.
>
>>
>>>> +
>>>> +       return new;
>>>> +}
>>>> +
>>>> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>>>> +{
>>>> +       struct early_pfn_node *ep = alloc_early_pfn_node(gfp_flags);
>>>>
>>>> -       early_pfns[old_idx] = pfn;
>>>> +       if (!ep)
>>>> +               return;
>>>> +
>>>> +       ep->pfn = pfn;
>>>> +       do {
>>>> +               ep->next = READ_ONCE(early_pfn_list);
>>>> +       } while (!try_cmpxchg(&early_pfn_list, &ep->next, ep));
>>>>    }
>>>>
>>>> -typedef void alloc_tag_add_func(unsigned long pfn);
>>>> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
>>>>    static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
>>>>           RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>>>>
>>>> -void alloc_tag_add_early_pfn(unsigned long pfn)
>>>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>>>>    {
>>>>           alloc_tag_add_func *alloc_tag_add;
>>>>
>>>> @@ -814,13 +844,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
>>>>           rcu_read_lock();
>>>>           alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
>>>>           if (alloc_tag_add)
>>>> -               alloc_tag_add(pfn);
>>>> +               alloc_tag_add(pfn, gfp_flags);
>>>>           rcu_read_unlock();
>>>>    }
>>>>
>>>>    static void __init clear_early_alloc_pfn_tag_refs(void)
>>>>    {
>>>> -       unsigned int i;
>>>> +       struct early_pfn_node *ep;
>>>> +       struct page *page, *next;
>>>>
>>>>           if (static_key_enabled(&mem_profiling_compressed))
>>>>                   return;
>>>> @@ -829,14 +860,13 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
>>>>           /* Make sure we are not racing with __alloc_tag_add_early_pfn() */
>>>>           synchronize_rcu();
>>>>
>>>> -       for (i = 0; i < atomic_read(&early_pfn_count); i++) {
>>>> -               unsigned long pfn = early_pfns[i];
>>>> +       for (ep = early_pfn_list; ep; ep = ep->next) {
>>>>
>>>> -               if (pfn_valid(pfn)) {
>>>> -                       struct page *page = pfn_to_page(pfn);
>>>> +               if (pfn_valid(ep->pfn)) {
>>>>                           union pgtag_ref_handle handle;
>>>>                           union codetag_ref ref;
>>>>
>>>> +                       page = pfn_to_page(ep->pfn);
>>>>                           if (get_page_tag_ref(page, &ref, &handle)) {
>>>>                                   /*
>>>>                                    * An early-allocated page could be freed and reallocated
>>>> @@ -861,6 +891,12 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
>>>>                   }
>>>>
>>>>           }
>>>> +
>>>> +       for (page = early_pfn_pages; page; page = next) {
>>>> +               next = (struct page *)page->private;
>>>> +               clear_page_tag_ref(page);
>>>> +               __free_page(page);
>>>> +       }
>>>>    }
>>>>    #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>>>    static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index 04494bc2e46f..4e2bfb3714e1 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
>>>>    /* Should be called only if mem_alloc_profiling_enabled() */
>>>>    static noinline
>>>>    void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>>>> -                      unsigned int nr)
>>>> +                      unsigned int nr, gfp_t gfp_flags)
>>>>    {
>>>>           union pgtag_ref_handle handle;
>>>>           union codetag_ref ref;
>>>> @@ -1294,21 +1294,30 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>>>>                   update_page_tag_ref(handle, &ref);
>>>>                   put_page_tag_ref(handle);
>>>>           } else {
>>>> -               /*
>>>> -                * page_ext is not available yet, record the pfn so we can
>>>> -                * clear the tag ref later when page_ext is initialized.
>>>> -                */
>>>> -               alloc_tag_add_early_pfn(page_to_pfn(page));
>>>> +
>>>>                   if (task->alloc_tag)
>>>>                           alloc_tag_set_inaccurate(task->alloc_tag);
>>>> +
>>>> +               /*
>>>> +                * page_ext is not available yet, skip if this allocation
>>>> +                * doesn't need early PFN recording.
>>>> +                */
>>>> +               if (unlikely(!should_record_early_pfn(gfp_flags)))
>>>> +                       return;
>>>> +
>>>> +               /*
>>>> +                * Record the pfn so the tag ref can be cleared later
>>>> +                * when page_ext is initialized.
>>>> +                */
>>>> +               alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
>>> nit: This seems shorter and more readable:
>>>
>>>                  if (unlikely(should_record_early_pfn(gfp_flags)))
>>>                               alloc_tag_add_early_pfn(page_to_pfn(page),
>>> gfp_flags);
>> OK, will improve it in the next version.
> Thanks,
> Suren.
>
>>
>> Thanks for taking the time to review and provide these suggestions!
>>
>> Thanks
>>
>> Best Regards
>>
>> Hao
>>
>>>>           }
>>>>    }
>>>>
>>>>    static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
>>>> -                                  unsigned int nr)
>>>> +                                  unsigned int nr, gfp_t gfp_flags)
>>>>    {
>>>>           if (mem_alloc_profiling_enabled())
>>>> -               __pgalloc_tag_add(page, task, nr);
>>>> +               __pgalloc_tag_add(page, task, nr, gfp_flags);
>>>>    }
>>>>
>>>>    /* Should be called only if mem_alloc_profiling_enabled() */
>>>> @@ -1341,7 +1350,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>>>>    #else /* CONFIG_MEM_ALLOC_PROFILING */
>>>>
>>>>    static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
>>>> -                                  unsigned int nr) {}
>>>> +                                  unsigned int nr, gfp_t gfp_flags) {}
>>>>    static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
>>>>    static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
>>>>
>>>> @@ -1896,7 +1905,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>>>>
>>>>           set_page_owner(page, order, gfp_flags);
>>>>           page_table_check_alloc(page, order);
>>>> -       pgalloc_tag_add(page, current, 1 << order);
>>>> +       pgalloc_tag_add(page, current, 1 << order, gfp_flags);
>>>>    }
>>>>
>>>>    static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
>>>> --
>>>> 2.25.1
>>>>

