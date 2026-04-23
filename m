Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310B0FAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BE76B0005; Wed, 22 Apr 2026 22:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834416B008A; Wed, 22 Apr 2026 22:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7222B6B008C; Wed, 22 Apr 2026 22:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6188D6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:10:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9FA51403FC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:10:42 +0000 (UTC)
X-FDA: 84688191924.27.678CDB4
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id CD45BC0002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:10:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xPydnDoi;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776910241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUP+MiZKx1TpbahvwAghqbXiqiafKtQ76tYAx0gMQDw=;
	b=3xO+d87XYPZBI7p/0E7w/rjfSzIAsWl3jPi2+3Phg+jTZGeo4y0ApGrrtw9hr3miiI8TGv
	MaWZPVfphc1JnLtRDEp19ss5v1Af1GGk/7M796sA55SU4FkW0+xGJoxmOvROD2c17Ggsyy
	4Bv2vVZcaSwm6ELlw8LdFaD5oMsRJFw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xPydnDoi;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776910241; a=rsa-sha256;
	cv=none;
	b=i9eDcyvcPEiz9XSv/WKnM4HeFpcYwfEBHOoAhwmMv7ftPVWSJe00OaA6pcCt2pDQ/SjBnX
	+BTyFoVxAiGx0TZZsPNvKdPTliJyDn/41ewl9yb1CZrY9kdVpxLFhr+mbZGd2HNjsWEuiy
	cibyuvWjCaxs7OgMOpzcqbiNwH71qR0=
Message-ID: <a4d4ac18-fbae-4ace-8f1c-651c8fefcf38@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776910235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rUP+MiZKx1TpbahvwAghqbXiqiafKtQ76tYAx0gMQDw=;
	b=xPydnDoi1XVxGml1ouEiNHHuoWDpvGHlgJrIfyBZIPBfz6OyQVifmynH866kSVdgQLUcU4
	6awrQxKBtJBSWuQclU3EpB/6zzNAXYGgmB6RMp8LDyRNXW16jh10iFqSVeCzTHKId3HrMg
	MJSrhKaCoUxgFHL7RYl1Yw7pgA/3QGw=
Date: Thu, 23 Apr 2026 10:09:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260421031406.1189000-1-hao.ge@linux.dev>
 <CAJuCfpHvCODeKG1y3Ndte9immkW6cUzqsaduOozSEhDv17x82w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHvCODeKG1y3Ndte9immkW6cUzqsaduOozSEhDv17x82w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: by47ochd7ucq74b64icew8q8gatjrpwd
X-Rspamd-Queue-Id: CD45BC0002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776910240-987125
X-HE-Meta: U2FsdGVkX19ZlHDK3yNNt2CDMsbUjaVVvlNNFHXjxvHs96JMg5whkziw/RefQErdP7URakNTBkpKM4jk3XM37ma7B6RvaAX2bwEACFwIRyS9yfnIO3VsfE1WTIjhUIiNDULnb6SJvH8Es5gb1N7hJnyjRVdJHxJKsi8JjVTzq1INlM3+lSl2gTinhRl3k+TDcZlCB3HupqMRjb7PjzWOApdnHv2+93NDz4ztwk/jU7stGy2QmeA6eEl5BisGbe4tvxORhtavl9srBqgm3pEPhbEVfh8Dz5rPD4k+ZaYUVlC7Q5ji1rTZJvJIrdYkgEOJ6BSxsu8cO1ZfrVULDfrMgOkVsM9bvrsvHCqnSXb5b7K3dx9Upn1IL61OPw401FcKvD1oLLTJpaLWvMrGJU1w3pXZPAnbnhzmJ67MxBpAA+D986aSeidHOLHUDP1WC4uoI04IFDVGU/WvatO4PkRU29QdbwI4ZWQcbTlZ4nJqcMiYrsqZVj6ijzyznj2TbLtn6agU0tkNJAU6dc5bDQhL+FdMgwmGW0iFtUpwfEGpbFJ5By2qkxK7wfbBenUdE0kKQtaprYG2fqkKutIko0DqOJEM0oBdi5XOREYyVitpeFtXCxL28/EyELAdpsY2UVGsI7w8hiHSaETMdcX87847RGOV7A+2EXE4ymMxZSePD2QaUQF8TwS0RA5Y0VL7lm3DekAxySOUBfQyy+0vfXjrZRcKUqfnfm8dCpFDoBICCBtd5aSs5/obLmhlGSZoUNhe6IPddW1XyBPhGUHiAX9O2oeoPRqpCu37eaLmeyQRKpXqZ8rrQbDg1P7Ptl7eKuiRfcnyCX+vkDn2NstLoEpXURGcytJ3rEib8/WDHxRHnyL6gxB5BuanVYsrybxgQUyoP1bbdq//jbvBd2gciH+Vjn+ZJcx+a68QH1ziHctIHiOpW9Qa8GGfVYjYPRAPBOVYwJcB6X+27UrN7DRsQvv
 ht1St7Qy
 I2IN0rydM4IEpx7D/NVZqhWX+S5iCNn1NWljlNjy5ctUIK3LSJ5uoNh7RO04ztytK2cMukZSVdrU3R5q1GT6dEZrUKE7MBpGUDbU0S5E3Zz9Xro49JoyuyK47Sb2E+n+mRd7UgRzOTcK7lyS9XewepVaZOKfpEAeWFjFUF7mS/p+bWRKXV/Vs0UjPqECsiylprk+kS2xvEY/e9q8JFwD4Ggmv0skacFhCikGocPB0MODOCd42M9yc5DEVKVj/NRG+lBhPUqrGiV1HZU9nljWXphNB3xz7bPreIRj6z4A/6XUCJ33y6q78kH/L+nJtGIVzbomxMKvpote+yByNhzvio8++gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/4/23 01:32, Suren Baghdasaryan wrote:
> On Mon, Apr 20, 2026 at 8:15 PM Hao Ge <hao.ge@linux.dev> wrote:
>> Pages allocated before page_ext is available have their codetag left
>> uninitialized. Track these early PFNs and clear their codetag in
>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
>> warnings when they are freed later.
>>
>> Currently a fixed-size array of 8192 entries is used, with a warning if
>> the limit is exceeded. However, the number of early allocations depends
>> on the number of CPUs and can be larger than 8192.
>>
>> Replace the fixed-size array with a dynamically allocated linked list.
>> Each page is carved into early_pfn_node entries and the remainder is
>> kept as a freelist for subsequent allocations.
>>
>> The list nodes themselves are allocated via alloc_page(), which would
>> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() ->
>> alloc_early_pfn_node() and recurse indefinitely.  Introduce
>> __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT bit) and pass
>> gfp_flags through pgalloc_tag_add() so that the early path can skip
>> recording allocations that carry this flag.
Hi Suren
> Hi Hao,
> Thanks for following up on this!

Happy to help further develop this feature.

Feel free to reach out if there's anything else I can do.


>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>> v2:
>> - Use cmpxchg to atomically update early_pfn_pages, preventing page leak under concurrent allocation
>> - Pass gfp_flags through the full call chain and use gfpflags_allow_blocking()
>>    to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC in process context
>> ---
>>   include/linux/alloc_tag.h |  22 +++++++-
>>   lib/alloc_tag.c           | 102 ++++++++++++++++++++++++++------------
>>   mm/page_alloc.c           |  29 +++++++----
>>   3 files changed, 108 insertions(+), 45 deletions(-)
>>
>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>> index 02de2ede560f..2fa695bd3c53 100644
>> --- a/include/linux/alloc_tag.h
>> +++ b/include/linux/alloc_tag.h
>> @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
>>   }
>>
>>   #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>> +/*
>> + * Skip early PFN recording for a page allocation.  Reuses the
>> + * %__GFP_NO_OBJ_EXT bit.  Used by alloc_early_pfn_node() to avoid
>> + * recursion when allocating pages for the early PFN tracking list
>> + * itself.
>> + *
>> + * Callers must set the codetag to CODETAG_EMPTY (via
>> + * clear_page_tag_ref()) before freeing pages allocated with this
>> + * flag once page_ext becomes available, otherwise
>> + * alloc_tag_sub_check() will trigger a warning.
>> + */
>> +#define __GFP_NO_CODETAG       __GFP_NO_OBJ_EXT
>> +
>> +static inline bool should_record_early_pfn(gfp_t gfp_flags)
>> +{
>> +       return !(gfp_flags & __GFP_NO_CODETAG);
>> +}
>>   static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag)
>>   {
>>          WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
>> @@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union codetag_ref *ref)
>>   {
>>          WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
>>   }
>> -void alloc_tag_add_early_pfn(unsigned long pfn);
>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
>>   #else
>>   static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
>>   static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
>> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
>> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
>> +static inline bool should_record_early_pfn(gfp_t gfp_flags) { return true; }
>
> If CONFIG_MEM_ALLOC_PROFILING_DEBUG=n why should we record early pfns?
Good point! I'll address this in the next patch.
>>   #endif
>>
>>   /* Caller should verify both ref and tag to be valid */
>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>> index ed1bdcf1f8ab..cfc68e397eba 100644
>> --- a/lib/alloc_tag.c
>> +++ b/lib/alloc_tag.c
>> @@ -766,45 +766,75 @@ static __init bool need_page_alloc_tagging(void)
>>    * Some pages are allocated before page_ext becomes available, leaving
>>    * their codetag uninitialized. Track these early PFNs so we can clear
>>    * their codetag refs later to avoid warnings when they are freed.
>> - *
>> - * Early allocations include:
>> - *   - Base allocations independent of CPU count
>> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
>> - *     such as trace ring buffers, scheduler per-cpu data)
>> - *
>> - * For simplicity, we fix the size to 8192.
>> - * If insufficient, a warning will be triggered to alert the user.
>> - *
>> - * TODO: Replace fixed-size array with dynamic allocation using
>> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
>>    */
>> -#define EARLY_ALLOC_PFN_MAX            8192
>> +struct early_pfn_node {
>> +       struct early_pfn_node   *next;
>> +       unsigned long           pfn;
>> +};
>> +
>> +#define NODES_PER_PAGE         (PAGE_SIZE / sizeof(struct early_pfn_node))
>>
>> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
>> -static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
>> +static struct early_pfn_node *early_pfn_list __initdata;
>> +static struct early_pfn_node *early_pfn_freelist __initdata;
>> +static struct page *early_pfn_pages __initdata;
> This early_pfn_node linked list seems overly complex. Why not just
> allocate a page and use page->lru to place it into a linked list? I
> think the code will end up much simpler.

Ah, yes! You mentioned this before, but I misunderstood your point.

I apologize for the confusion. I'll optimize this in the next revision.

>
>> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>> +static struct early_pfn_node *__init alloc_early_pfn_node(gfp_t gfp_flags)
>>   {
>> -       int old_idx, new_idx;
>> +       struct early_pfn_node *ep, *new;
>> +       struct page *page, *old_page;
>> +       gfp_t gfp = gfpflags_allow_blocking(gfp_flags) ? GFP_KERNEL : GFP_ATOMIC;
>> +       int i;
>> +
>> +retry:
>> +       ep = READ_ONCE(early_pfn_freelist);
>> +       if (ep) {
>> +               struct early_pfn_node *next = READ_ONCE(ep->next);
>> +
>> +               if (try_cmpxchg(&early_pfn_freelist, &ep, next))
>> +                       return ep;
>> +               goto retry;
>> +       }
>> +
>> +       page = alloc_page(gfp | __GFP_NO_CODETAG | __GFP_ZERO);

One more question: since this is called in an RCU context, should we use 
GFP_ATOMIC by default?

Also, should we remove GFP_KSWAPD_RECLAIM here? I'm not entirely sure, 
but I recall Sashiko mentioned a warning about this before:

---

page = alloc_page(GFP_ATOMIC | __GFP_NO_CODETAG | __GFP_ZERO);

Sashiko's concerns:

Can this lead to a deadlock by introducing lock recursion?
alloc_early_pfn_node() is invoked as a post-allocation hook for early boot
pages via pgalloc_tag_add(). GFP_ATOMIC includes __GFP_KSWAPD_RECLAIM,
which triggers wakeup_kswapd() and acquires scheduler locks.
If the original allocation was made under scheduler locks and intentionally
stripped __GFP_KSWAPD_RECLAIM to prevent recursion, does this hardcoded
GFP_ATOMIC force it back on? Should the hook inherit or constrain its flags
based on the caller's gfp_flags instead?

---

Even though this only happens during early boot, should we handle it 
more safely?

>> +       if (!page)
>> +               return NULL;
>> +
>> +       new = page_address(page);
>> +       for (i = 0; i < NODES_PER_PAGE - 1; i++)
>> +               new[i].next = &new[i + 1];
>> +       new[NODES_PER_PAGE - 1].next = NULL;
>> +
>> +       if (cmpxchg(&early_pfn_freelist, NULL, new + 1)) {
>> +               __free_page(page);
>> +               goto retry;
>> +       }
>>
>>          do {
>> -               old_idx = atomic_read(&early_pfn_count);
>> -               if (old_idx >= EARLY_ALLOC_PFN_MAX) {
>> -                       pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
>> -                                     EARLY_ALLOC_PFN_MAX);
>> -                       return;
>> -               }
>> -               new_idx = old_idx + 1;
>> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
>> +               old_page = READ_ONCE(early_pfn_pages);
>> +               page->private = (unsigned long)old_page;
>> +       } while (cmpxchg(&early_pfn_pages, old_page, page) != old_page);
> I don't think this whole lockless schema is worth the complexity.
> alloc_early_pfn_node() is called only during early init and is called
> perhaps a few hundred times in total. Why not use a simple spinlock to
> synchronize this operation and be done with it?

I initially used a simple spinlock, but Sashiko raised a good point in 
his review:

https://sashiko.dev/#/patchset/20260319083153.2488005-1-hao.ge%40linux.dev

Since alloc_early_pfn_node() is called during early init from an unknown 
context, in the early page allocation path,

a lockless approach is safer. However, you're right that if we use 
page->lru as a linked list (which you suggested earlier),

the code becomes much simpler. I plan to simplify the code and continue 
using the lockless approach in the next version.


>> +
>> +       return new;
>> +}
>> +
>> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>> +{
>> +       struct early_pfn_node *ep = alloc_early_pfn_node(gfp_flags);
>>
>> -       early_pfns[old_idx] = pfn;
>> +       if (!ep)
>> +               return;
>> +
>> +       ep->pfn = pfn;
>> +       do {
>> +               ep->next = READ_ONCE(early_pfn_list);
>> +       } while (!try_cmpxchg(&early_pfn_list, &ep->next, ep));
>>   }
>>
>> -typedef void alloc_tag_add_func(unsigned long pfn);
>> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
>>   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
>>          RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>>
>> -void alloc_tag_add_early_pfn(unsigned long pfn)
>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>>   {
>>          alloc_tag_add_func *alloc_tag_add;
>>
>> @@ -814,13 +844,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
>>          rcu_read_lock();
>>          alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
>>          if (alloc_tag_add)
>> -               alloc_tag_add(pfn);
>> +               alloc_tag_add(pfn, gfp_flags);
>>          rcu_read_unlock();
>>   }
>>
>>   static void __init clear_early_alloc_pfn_tag_refs(void)
>>   {
>> -       unsigned int i;
>> +       struct early_pfn_node *ep;
>> +       struct page *page, *next;
>>
>>          if (static_key_enabled(&mem_profiling_compressed))
>>                  return;
>> @@ -829,14 +860,13 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
>>          /* Make sure we are not racing with __alloc_tag_add_early_pfn() */
>>          synchronize_rcu();
>>
>> -       for (i = 0; i < atomic_read(&early_pfn_count); i++) {
>> -               unsigned long pfn = early_pfns[i];
>> +       for (ep = early_pfn_list; ep; ep = ep->next) {
>>
>> -               if (pfn_valid(pfn)) {
>> -                       struct page *page = pfn_to_page(pfn);
>> +               if (pfn_valid(ep->pfn)) {
>>                          union pgtag_ref_handle handle;
>>                          union codetag_ref ref;
>>
>> +                       page = pfn_to_page(ep->pfn);
>>                          if (get_page_tag_ref(page, &ref, &handle)) {
>>                                  /*
>>                                   * An early-allocated page could be freed and reallocated
>> @@ -861,6 +891,12 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
>>                  }
>>
>>          }
>> +
>> +       for (page = early_pfn_pages; page; page = next) {
>> +               next = (struct page *)page->private;
>> +               clear_page_tag_ref(page);
>> +               __free_page(page);
>> +       }
>>   }
>>   #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>   static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 04494bc2e46f..4e2bfb3714e1 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
>>   /* Should be called only if mem_alloc_profiling_enabled() */
>>   static noinline
>>   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>> -                      unsigned int nr)
>> +                      unsigned int nr, gfp_t gfp_flags)
>>   {
>>          union pgtag_ref_handle handle;
>>          union codetag_ref ref;
>> @@ -1294,21 +1294,30 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>>                  update_page_tag_ref(handle, &ref);
>>                  put_page_tag_ref(handle);
>>          } else {
>> -               /*
>> -                * page_ext is not available yet, record the pfn so we can
>> -                * clear the tag ref later when page_ext is initialized.
>> -                */
>> -               alloc_tag_add_early_pfn(page_to_pfn(page));
>> +
>>                  if (task->alloc_tag)
>>                          alloc_tag_set_inaccurate(task->alloc_tag);
>> +
>> +               /*
>> +                * page_ext is not available yet, skip if this allocation
>> +                * doesn't need early PFN recording.
>> +                */
>> +               if (unlikely(!should_record_early_pfn(gfp_flags)))
>> +                       return;
>> +
>> +               /*
>> +                * Record the pfn so the tag ref can be cleared later
>> +                * when page_ext is initialized.
>> +                */
>> +               alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
> nit: This seems shorter and more readable:
>
>                 if (unlikely(should_record_early_pfn(gfp_flags)))
>                              alloc_tag_add_early_pfn(page_to_pfn(page),
> gfp_flags);

OK, will improve it in the next version.


Thanks for taking the time to review and provide these suggestions!

Thanks

Best Regards

Hao

>>          }
>>   }
>>
>>   static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
>> -                                  unsigned int nr)
>> +                                  unsigned int nr, gfp_t gfp_flags)
>>   {
>>          if (mem_alloc_profiling_enabled())
>> -               __pgalloc_tag_add(page, task, nr);
>> +               __pgalloc_tag_add(page, task, nr, gfp_flags);
>>   }
>>
>>   /* Should be called only if mem_alloc_profiling_enabled() */
>> @@ -1341,7 +1350,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>>   #else /* CONFIG_MEM_ALLOC_PROFILING */
>>
>>   static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
>> -                                  unsigned int nr) {}
>> +                                  unsigned int nr, gfp_t gfp_flags) {}
>>   static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
>>   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
>>
>> @@ -1896,7 +1905,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>>
>>          set_page_owner(page, order, gfp_flags);
>>          page_table_check_alloc(page, order);
>> -       pgalloc_tag_add(page, current, 1 << order);
>> +       pgalloc_tag_add(page, current, 1 << order, gfp_flags);
>>   }
>>
>>   static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
>> --
>> 2.25.1
>>

