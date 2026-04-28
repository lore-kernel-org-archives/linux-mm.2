Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27017FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8366B0088; Mon, 27 Apr 2026 23:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389426B008A; Mon, 27 Apr 2026 23:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E9A6B008C; Mon, 27 Apr 2026 23:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 184756B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:01:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74A4D1A036C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:01:10 +0000 (UTC)
X-FDA: 84706463100.12.F4F62DA
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id 39EB68000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:01:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/orSB0I";
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777345268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DLrKbUFioxw9AWS40F/B8Wy1S1+yW9qEZl4KX1Jd/E=;
	b=IkxXXH9jlVgwNFYWLE82ScWNreMFQ8wfC6Rc+yMpm/wlKrJUxaF9bncW+29u4JpRMuavvs
	BNutedL0MHfO2NxqPDUWcQNn/PAtYofCSiNYHf2kv13kDgGuAXGqIstT5v2Qm0I0i4/X7i
	xt6Vm7b9N/t0vnTuLxXhqAifaskjWVw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/orSB0I";
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777345268; a=rsa-sha256;
	cv=none;
	b=hTg2oHjV/rBSAHNtRka0NoM5ubfMycMnukyy67r/a2BwN/sVCzURdiIc9Li61y/H+s3wjl
	ZGst9TIUhJt5/Kn1Rw2/SMdLIs7EzNUH3qpUU6B+ab7nLaj3Bw7U2cxnFRoK24xmxavVLy
	zUGVL1MraIq/mwIAUokRrTV99TelAes=
Message-ID: <b4735edb-55f9-4562-a0d0-a10e1788979a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777345266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8DLrKbUFioxw9AWS40F/B8Wy1S1+yW9qEZl4KX1Jd/E=;
	b=M/orSB0IxDJ/PEDmxb2z5QY8/HshaAHDhkxppUjAIy5EtcCrmaGO7Doqi8J5pmpU7yccBW
	wNGqgCYuqNuizGp/xxaB/YCK6CzGTgJjJYpAf/4fwlLuM68OYsx86rRfqrg6RYlaVHS1u9
	DXvpEgRYvQ8Z27+egmesFhCizoPhKBA=
Date: Tue, 28 Apr 2026 11:00:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260423083756.157902-1-hao.ge@linux.dev>
 <CAJuCfpEy=rDFRhS+X-a5t-UquPi7veMRmyZzxR_9Z-WKagwFaw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpEy=rDFRhS+X-a5t-UquPi7veMRmyZzxR_9Z-WKagwFaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cwpqr1ecmb7nj1zcs4pegau7nn5y44xc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 39EB68000B
X-Rspam-User: 
X-HE-Tag: 1777345267-292258
X-HE-Meta: U2FsdGVkX182YQxOiNsui4NEeODp1CE/wWypf4ugeXVaywKoUv0AXMV2xsRacK9fkvgXVSojd2M/VroIsZXx8tjOY3ONzC1C7aUYm4bEe68OVHoUgybkUsk9YqEPFwmJC0yTcKGMLYkL7B/hcxHSADASrgvDAz2STq3x5lDwaPjPetv1uC8nTDpFgqguLV8q0ZfK5+Xak4urSo5XoN4ARuzoSIUMA9sCwUv8vqgoDewIJ8o0FgxHLYXkTXECh+UMvMgxyj79/aaH8R8ZbYQkRnHYf65xlB1Zj20Ut18/QPs4I1LIj8fU978eJKaWsxv8GOwb+U7d0DRUZMfwr8oExGVMMDn0pt155Gf//hK4auFfanNngQQ5TkTPbg9onWPmIUUZWLMRD0NaryrduGk+gsSpEvRh0RNVAFq7go3sPM4eU4EzEe6ER/xBf8txi2/KcJbG7czR3+afIUguCmn8OA2cHAgKdgGOfgGoBRIRsAvvqibdEmBMJd360Oy57lZC2HDFqt3hATedLVHzoYthP+LDFkm/pVym8JGstQv0BplA44ZADds2hd21nbdm3LIGbQqKd16GhDa+eBzP57EpAKzpWC35OgB4GmfKefsnjiqiGU+gbRPQMJ1z3YoTgstaXbUaX6GjNYdVgYfHDRkCX0jzOTk8oveLGypIhcuMesEjjyR2VdhZcxYSs2l3h71Y5LV5dMlM6ZJ+t0rSsQiFqTNPyepcr3Va+RsWrnOra5FvQ1ndtt1f5tL/eUdg/sD2XCeC8KkmU20RLXO7mQxCvRN7zOdu9mmgXG5o4Vg5sGBWyD/7ht175P5yZh7V6AoYHzb1MpMqcm7sTBq01icsKEH3YWEjUEzma0+UM3y1klSAO56cLwLSqvEFfDyEnNC9D+2ZNYKPJgfoJ7JVPDruz0TMN0VVQA1DF6EmEGXaenfkXR+8RerKwkeaW/sOOOMj3cJbvshBkSx6NJnX4SZ
 aYeImqJh
 84kOMXvfIEeo77uxPMRmVF5E4WcxKD78sllTuHlCIqBSofL2wrZEdjJ5FLajcNpgVtu4D0LFOZuRbonUD49+BAouCCnGmO/K5Pteq7dwsYIf2EFNxo3GCh4jamsxsNebFkVuVhOgBJziYg9jlSq1vhgJnXG6C2TMYwVx/Q4yugZmbJkXAPkamNwgjrfoR4eZ4MG7A55Ske7vkD1OJaPmOZwM+EWuCQS5BBDODzqVi9wjo0D+FAOYTA3kVTRfyeZiv8LzrAX6JERTdMiwjXACcmyjVkL0BfPSq7Ij35dX3c7XOVFH4sVxCG4uWBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


Thanks a lot for your review and suggestions.


On 2026/4/28 00:02, Suren Baghdasaryan wrote:
> On Thu, Apr 23, 2026 at 1:39 AM Hao Ge <hao.ge@linux.dev> wrote:
>> Pages allocated before page_ext is available have their codetag left
>> uninitialized. Track these early PFNs and clear their codetag in
>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
>> warnings when they are freed later.
>>
>> Currently a fixed-size array of 8192 entries is used, with a warning if
>> the limit is exceeded. However, the number of early allocations depends
>> on the number of CPUs and can be larger than 8192.
>>
>> Replace the fixed-size array with a dynamically allocated linked list
>> of pages. Each page stores PFNs in its page body and uses page->lru
>> to link to the next page, with page->private tracking the number of
>> used slots.
>>
>> The list pages themselves are allocated via alloc_page(), which would
>> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
>> indefinitely. Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
>> bit) and pass gfp_flags through pgalloc_tag_add() so that the early path
>> can skip recording allocations that carry this flag.
>>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>> v3:
>> - Simplify linked list: use page->lru for chaining and page->private as
>>    slot counter, removing the early_pfn_node struct and freelist (suggested
>>    by Suren Baghdasaryan)
>> - Pass gfp_flags through alloc_tag_add_early_pfn() but strip
>>    __GFP_DIRECT_RECLAIM instead of selecting GFP_KERNEL/GFP_ATOMIC,
>>    because __alloc_tag_add_early_pfn() is invoked under rcu_read_lock().
>>
>> v2:
>> - Use cmpxchg to atomically update early_pfn_pages, preventing page leak under concurrent allocation
>> - Pass gfp_flags through the full call chain and use gfpflags_allow_blocking()
>>    to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC in process context
>> ---
>>   include/linux/alloc_tag.h |  22 ++++++-
>>   lib/alloc_tag.c           | 118 +++++++++++++++++++++-----------------
>>   mm/page_alloc.c           |  23 ++++----
>>   3 files changed, 97 insertions(+), 66 deletions(-)
>>
>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>> index 02de2ede560f..ce9b478033bf 100644
>> --- a/include/linux/alloc_tag.h
>> +++ b/include/linux/alloc_tag.h
>> @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
>>   }
>>
>>   #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>> +/*
>> + * Skip early PFN recording for a page allocation.  Reuses the
>> + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
>> + * recursion when allocating pages for the early PFN tracking list
>> + * itself.
>> + *
>> + * Callers must set the codetag to CODETAG_EMPTY (via
>> + * clear_page_tag_ref()) before freeing pages allocated with this
>> + * flag once page_ext becomes available, otherwise
>> + * alloc_tag_sub_check() will trigger a warning.
> nit: Callers must... sounds like someone who uses
> __alloc_tag_add_early_pfn() has to do something extra, however
> clear_page_tag_ref() is done by clear_early_alloc_pfn_tag_refs(), so
> callers don't really need to do this. I suggest rephrasing as:
>
> Codetags of the pages allocated with __GFP_NO_CODETAG should be
> cleared (via clear_page_tag_ref()) before freeing the pages to prevent
> alloc_tag_sub_check() from triggering a warning.

That's reasonable.

I will adjust the wording in v2.
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
>> +static inline bool should_record_early_pfn(gfp_t gfp_flags) { return false; }
>>   #endif
>>
>>   /* Caller should verify both ref and tag to be valid */
>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>> index ed1bdcf1f8ab..a00dc5a867e4 100644
>> --- a/lib/alloc_tag.c
>> +++ b/lib/alloc_tag.c
>> @@ -766,45 +766,49 @@ static __init bool need_page_alloc_tagging(void)
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
>> +#define EARLY_PFNS_PER_PAGE            (PAGE_SIZE / sizeof(unsigned long))
>>
>> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
>> -static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
>> +static struct page *early_pfn_current __initdata;
> So, instead of using early_pfn_current as the head page and then
> page->lru.next directly, I would suggest having "struct llist_head
> early_pfn_head;" as the list head and either using page->pcp_llist to
> link the pages or even better, adding a "struct llist_node llist;"
> into the union containing "struct list_head lru;". Note that
> llist_add() uses try_cmpxchg(), so the link addition is atomic.

Adding a struct llist_node into the page union only for the 
CONFIG_MEM_ALLOC_PROFILING_DEBUG feature,

which may not be quite appropriate from a design perspective.

> And you should probably use folios rather than pages to follow the new trends.
>
>> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>>   {
>> -       int old_idx, new_idx;
>> +       struct page *page;
>> +       unsigned long idx;
>>
>>          do {
>> -               old_idx = atomic_read(&early_pfn_count);
>> -               if (old_idx >= EARLY_ALLOC_PFN_MAX) {
>> -                       pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
>> -                                     EARLY_ALLOC_PFN_MAX);
>> -                       return;
>> +               page = READ_ONCE(early_pfn_current);
>> +               if (!page || READ_ONCE(page->private) >= EARLY_PFNS_PER_PAGE) {
>> +                       gfp_t gfp = gfp_flags & ~__GFP_DIRECT_RECLAIM;
>> +                       struct page *new = alloc_page(gfp | __GFP_NO_CODETAG);
>> +
>> +                       if (!new) {
>> +                               pr_warn_once("early PFN tracking page allocation failed\n");
>> +                               return;
>> +                       }
>> +                       new->lru.next = (struct list_head *)page;
>> +                       if (cmpxchg(&early_pfn_current, page, new) != page) {
>> +                               __free_page(new);
>> +                               continue;
>> +                       }


I also considered using llist_head initially.  like this

static LLIST_HEAD(early_pfn_pages);

static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t 
gfp_flags)
{
         struct page *page;
         unsigned long idx;

         do {
                 page = llist_first(&early_pfn_pages);
                 if (!page || READ_ONCE(page->private) >= 
EARLY_PFNS_PER_PAGE) {
                         gfp_t gfp = gfp_flags & ~__GFP_DIRECT_RECLAIM;
                         struct page *new = alloc_page(gfp | 
__GFP_NO_CODETAG);

                         if (!new) {
                                 pr_warn_once("early PFN tracking page 
allocation failed\n");
                                 return;
                         }
                         new->private = 0;
                         llist_add(&new->pcp_llist, &early_pfn_pages);
                         page = new;
                 }
                 idx = READ_ONCE(page->private);
                 if (idx >= EARLY_PFNS_PER_PAGE)
                         continue;
                 if (cmpxchg(&page->private, idx, idx + 1) == idx)
                         break;
         } while (1);

         ((unsigned long *)page_address(page))[idx] = pfn;
}


The problem is that llist_add() retries internally until it succeeds.

When multiple CPUs concurrently see that the head page is NULL or full ,

they each allocate a new tracking page and all insertions succeed:

CPU0: head page A is full or NULL, allocates B, llist_add(B) → head=B→A

CPU1: head page A is full or NULL, allocates C, llist_add(C) → head=C→B→A

CPU0: claims slot 0 in B

CPU1: claims slot 0 in C

Now the head is C. Once C fills up, a new page D is allocated and 
becomes the new head. But B still has ~511 unused slots and will never

be the head again — we only ever look at llist_first(). Those slots are 
permanently wasted.

That's why I used struct page *early_pfn_current with direct cmpxchg — 
the loser frees its page and retries, avoiding the waste.

That said, I may be missing something. Is there a way to use llist that 
avoids this? I'd appreciate your thoughts.


>> +                       page = new;
>>                  }
>> -               new_idx = old_idx + 1;
>> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
>> +               idx = READ_ONCE(page->private);
>> +               if (idx >= EARLY_PFNS_PER_PAGE)
>> +                       continue;
>> +               if (cmpxchg(&page->private, idx, idx + 1) != idx)
>> +                       continue;
>> +               break;
> nit: This would read more easily:
>
>                 if (cmpxchg(&page->private, idx, idx + 1) == idx)
>                          break;
will fix in the next version.
>
>> +       } while (1);
>>
>> -       early_pfns[old_idx] = pfn;
>> +       ((unsigned long *)page_address(page))[idx] = pfn;
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
>> @@ -814,13 +818,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
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
>> +       struct page *page, *next;
>> +       unsigned long i;
>>
>>          if (static_key_enabled(&mem_profiling_compressed))
>>                  return;
>> @@ -829,37 +834,42 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
>>          /* Make sure we are not racing with __alloc_tag_add_early_pfn() */
>>          synchronize_rcu();
>>
>> -       for (i = 0; i < atomic_read(&early_pfn_count); i++) {
>> -               unsigned long pfn = early_pfns[i];
>> -
>> -               if (pfn_valid(pfn)) {
>> -                       struct page *page = pfn_to_page(pfn);
>> -                       union pgtag_ref_handle handle;
>> -                       union codetag_ref ref;
>> -
>> -                       if (get_page_tag_ref(page, &ref, &handle)) {
>> -                               /*
>> -                                * An early-allocated page could be freed and reallocated
>> -                                * after its page_ext is initialized but before we clear it.
>> -                                * In that case, it already has a valid tag set.
>> -                                * We should not overwrite that valid tag with CODETAG_EMPTY.
>> -                                *
>> -                                * Note: there is still a small race window between checking
>> -                                * ref.ct and calling set_codetag_empty(). We accept this
>> -                                * race as it's unlikely and the extra complexity of atomic
>> -                                * cmpxchg is not worth it for this debug-only code path.
>> -                                */
>> -                               if (ref.ct) {
>> +       for (page = early_pfn_current; page; page = next) {
>> +               for (i = 0; i < page->private; i++) {
>> +                       unsigned long pfn = ((unsigned long *)page_address(page))[i];
> This page_address() can be done in the outer loop since the page does
> not change inside the inner loop.
will fix in the next version.
>> +
>> +                       if (pfn_valid(pfn)) {
>> +                               union pgtag_ref_handle handle;
>> +                               union codetag_ref ref;
>> +
>> +                               if (get_page_tag_ref(pfn_to_page(pfn), &ref, &handle)) {
>> +                                       /*
>> +                                        * An early-allocated page could be freed and reallocated
>> +                                        * after its page_ext is initialized but before we clear it.
>> +                                        * In that case, it already has a valid tag set.
>> +                                        * We should not overwrite that valid tag
>> +                                        * with CODETAG_EMPTY.
>> +                                        *
>> +                                        * Note: there is still a small race window between checking
>> +                                        * ref.ct and calling set_codetag_empty(). We accept this
>> +                                        * race as it's unlikely and the extra complexity of atomic
>> +                                        * cmpxchg is not worth it for this debug-only code path.
>> +                                        */
>> +                                       if (ref.ct) {
>> +                                               put_page_tag_ref(handle);
>> +                                               continue;
>> +                                       }
>> +
>> +                                       set_codetag_empty(&ref);
>> +                                       update_page_tag_ref(handle, &ref);
>>                                          put_page_tag_ref(handle);
>> -                                       continue;
>>                                  }
>> -
>> -                               set_codetag_empty(&ref);
>> -                               update_page_tag_ref(handle, &ref);
>> -                               put_page_tag_ref(handle);
>>                          }
>>                  }
>>
>> +               next = (struct page *)page->lru.next;
>> +               clear_page_tag_ref(page);
>> +               __free_page(page);
>>          }
>>   }
>>   #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 04494bc2e46f..5b7b234967a5 100644
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
>> @@ -1294,21 +1294,24 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
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
>> +                * page_ext is not available yet, record the pfn so the
>> +                * tag ref can be cleared later when page_ext is initialized.
>> +                */
>> +               if (should_record_early_pfn(gfp_flags))
>> +                       alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
> Any reason for changing the order of alloc_tag_add_early_pfn() and
> alloc_tag_set_inaccurate()? I liked the previous version where we
> explain why this is done at the very beginning of the block. You could
> also call should_record_early_pfn() from inside
> alloc_tag_add_early_pfn(), which would keep both
> should_record_early_pfn() and __GFP_NO_CODETAG definitions local to
> alloc_tag.c.
>
will fix in the next version.

Thanks

Best regards.

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
>> @@ -1341,7 +1344,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>>   #else /* CONFIG_MEM_ALLOC_PROFILING */
>>
>>   static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
>> -                                  unsigned int nr) {}
>> +                                  unsigned int nr, gfp_t gfp_flags) {}
>>   static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
>>   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
>>
>> @@ -1896,7 +1899,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
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

