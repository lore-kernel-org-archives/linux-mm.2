Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9DB3F327C9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04CBC6B0092; Tue, 21 Apr 2026 05:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F626B0093; Tue, 21 Apr 2026 05:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56616B0095; Tue, 21 Apr 2026 05:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3C3C6B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:03:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A7B0160D21
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:03:26 +0000 (UTC)
X-FDA: 84681974412.02.05BBAE9
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id B577B2000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:03:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lWKgmMLr;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776762205; a=rsa-sha256;
	cv=none;
	b=NbHontvfwsS7AAWilmaTfXEQSjUq8IY+1kUEwqVtvhakr7AX2q0WjfTzSyOGdSvGgGeReG
	Tp08NwvEnlaM84nFsfCMXeQGhwlSH814pJ7yNGuoq+HaqZe0IsgbZuhsfsz4gLWeD1HSm3
	Ca7Rr6RdkpnEOSlUbIGNaQS0phb3iWg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lWKgmMLr;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776762205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcbno30aQf+arGIaZ+mgE/N2zcPrSQwito+V5BR9IcI=;
	b=YNtC619O1IfTgZLqJ18XkWf4tWZab8QLtuSnvCzTotwebiVGvziP+gFK79STNIr4+SigiH
	tQ6MYa3QdW9b2G9676dQaQYLaIjd8M/iUUxnXjj/1M1L3ZpNju+3U19Y4v7o+9ARxUytnF
	fZllbWOAEB7J5tiVD3KHMpm3zGvGhqA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776762200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcbno30aQf+arGIaZ+mgE/N2zcPrSQwito+V5BR9IcI=;
	b=lWKgmMLrHixk3NnTk1fk/bAMn/tWOyeai/Bm2e7om76q1rs5NbaK8iSO4fVO19SlWq4Uzm
	aCZNOSh2DkRueIyYOODOao4BqcnjX7hFeJ+Zstht2dzhS5zBjHlAFGo/1t0frnKd2jyUeu
	87YkgtY59xQ0iIuf4au95EFxQBtANZY=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	dev.jain@arm.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
Date: Tue, 21 Apr 2026 17:03:06 +0800
Message-Id: <20260421090306.45979-1-lance.yang@linux.dev>
In-Reply-To: <94fdc376-9c43-4334-b293-20a54acbdc3a@kernel.org>
References: <94fdc376-9c43-4334-b293-20a54acbdc3a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B577B2000B
X-Stat-Signature: z57oqtt6sw4abbrehk1xcids6pxfhxf5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776762204-695985
X-HE-Meta: U2FsdGVkX1+4uL5BhbgQpQ6vQl5DzLfdM3xiBYka2MmXBT9MSgoapVYc2CHubZxqvpQYWiAHINYv7qtNhhSfLWGbce2mJIga7dtKZCWJq9wzwfTF0Vqz4nngbu637U5+dWrX7KXwYL0fdOe9zO3FTMDHVc3yckuyQkxy2vcMqjpQietewN25kZ1vXQlJVsdDvOIF1ZAHbxSLlolgxkP5XJ27IOSgpnNh+HqKWb5UqH996J3NOdtRN51nWYOOkUvKj6gaqBjt5YG/kQWCG+KsTPRcBACttbya8QLcSy+6M+cuEAgtdOalqDelNEQ2y3eRv1PE2NGgLkSE313AMvEoNtRYwmfb1NJqCw1dMhfaMaeJ6omkXRhbWa3UTe6PsHl3cEg4O6FJG5AGRFQISE33eoLLbigdx1xvOHuz3D3WHLEF/llnomsvvtQUjODpr5lYYwWG9R4JMUoYlKa4oNS6WCnZ0xACYr4ZdBCucdIXXTEQzg4T32UCUw0Vl43lZdiv8Xif0CakTLI7ABduaezxVdwZkR9Kfpnp/QXiYIu3X8t8UsrtSd7lx/bqTR2E+FumU5YVCSUv3sIR9981Q0i6OqiqWISDKtigm/MklkX9YXvfzKYASBp6dB5VtrZlHJe7EMnAWALUmhJskp115UUXcY6VBXAb151bdCrNq0FtHmOnkKkn4yYx8KuttssoeDmbce4ze9SZoaUEDuT8xVl51L12HsCFycOg3wUh1VIXHD6tABYjQLocmE2g0ALmJIl+DHImMibIIcFvZSDCfXgxAPjip81pHRvsxHHsdKY3lEZQ3S3pJMYtKEdHtomkR+Bs2z3P46GerSHSfG+srpHIuuJhOd1K8pHNgsbU8ClJqEiRMg6x4plntOPi9vz8U0i6WZFitItHpySPM++lnW76UKxaMcUoHeGGfqGJieikQveqpK6LPehZtoZs6GHpE1vLTdUU/8aFXT/9co34Afc
 5cgpTUFc
 cCTMeDRcLM5UZOsnKwibhZievv0eaaMcHLnSv7JpYPMcbEOJI8+W1BCg8QIL1NsR4UPWZ3w3yUYdpSL+xyy40xigqm1sJ/QyCyPVKiyv11pVpMwfyCQ9SjAQIij1r/R2Z/+vVkVgDupiyOH56wR5WXwqadv4t8dNWkHR7zzUrObIIV4XwQQbYBXGxevurybWmMxx7YQ+vTXkjHOIpv38/3KgQ9/oBf8T3y1Xwro3Iy/7ODN2TTH8fmctppf2CT5nYn1oJ5S3108EaWflHNx0TZBz+70lAolF640L3b/ne2bcZ/WvlEx33SnLmxSU1UkLzokL8vYl8gZv6iwYEqf0EEZFcAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 21, 2026 at 10:06:54AM +0200, David Hildenbrand (Arm) wrote:
>On 4/21/26 09:06, Dev Jain wrote:
>> 
>> 
>> On 21/04/26 2:46 am, David Hildenbrand (Arm) wrote:
>>> __GFP_ZEROTAGS semantics are currently a bit weird, but effectively this
>>> flag is only ever set alongside __GFP_ZERO and __GFP_SKIP_KASAN.
>>>
>>> If we run with init_on_free, we will zero out pages during
>>> __free_pages_prepare(), to skip zeroing on the allocation path.
>>>
>>> However, when allocating with __GFP_ZEROTAG set, post_alloc_hook() will
>>> consequently not only skip clearing page content, but also skip
>>> clearing tag memory.
>>>
>>> Not clearing tags through __GFP_ZEROTAGS is irrelevant for most pages that
>>> will get mapped to user space through set_pte_at() later: set_pte_at() and
>>> friends will detect that the tags have not been initialized yet
>>> (PG_mte_tagged not set), and initialize them.
>>>
>>> However, for the huge zero folio, which will be mapped through a PMD
>>> marked as special, this initialization will not be performed, ending up
>>> exposing whatever tags were still set for the pages.
>>>
>>> The docs (Documentation/arch/arm64/memory-tagging-extension.rst) state
>>> that allocation tags are set to 0 when a page is first mapped to user
>>> space. That no longer holds with the huge zero folio when init_on_free
>>> is enabled.
>>>
>>> Fix it by decoupling __GFP_ZEROTAGS from __GFP_ZERO, passing to
>>> tag_clear_highpages() whether we want to also clear page content.
>>>
>>> As we are touching the interface either way, just clean it up by
>>> only calling it when HW tags are enabled, dropping the return value, and
>>> dropping the common code stub.
>>>
>>> Reproduced with the huge zero folio by modifying the check_buffer_fill
>>> arm64/mte selftest to use a 2 MiB area, after making sure that pages have
>>> a non-0 tag set when freeing (note that, during boot, we will not
>>> actually initialize tags, but only set KASAN_TAG_KERNEL in the page
>>> flags).
>>>
>>> 	$ ./check_buffer_fill
>>> 	1..20
>>> 	...
>>> 	not ok 17 Check initial tags with private mapping, sync error mode and mmap memory
>>> 	not ok 18 Check initial tags with private mapping, sync error mode and mmap/mprotect memory
>>> 	...
>>>
>>> This code needs more cleanups; we'll tackle that next, like
>>> decoupling __GFP_ZEROTAGS from __GFP_SKIP_KASAN, moving all the
>>> KASAN magic into a separate helper, and consolidating HW-tag handling.
>>>
>>> Fixes: adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>  arch/arm64/include/asm/page.h |  3 ---
>>>  arch/arm64/mm/fault.c         | 16 +++++-----------
>>>  include/linux/gfp_types.h     | 10 +++++-----
>>>  include/linux/highmem.h       | 10 +---------
>>>  mm/page_alloc.c               | 12 +++++++-----
>>>  5 files changed, 18 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
>>> index e25d0d18f6d7..5c6cbfbbd34c 100644
>>> --- a/arch/arm64/include/asm/page.h
>>> +++ b/arch/arm64/include/asm/page.h
>>> @@ -33,9 +33,6 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>>>  						unsigned long vaddr);
>>>  #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
>>>  
>>> -bool tag_clear_highpages(struct page *to, int numpages);
>>> -#define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
>>> -
>>>  #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
>>>  
>>>  typedef struct page *pgtable_t;
>>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>>> index 0f3c5c7ca054..32a3723f2d34 100644
>>> --- a/arch/arm64/mm/fault.c
>>> +++ b/arch/arm64/mm/fault.c
>>> @@ -1018,21 +1018,15 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>>>  	return vma_alloc_folio(flags, 0, vma, vaddr);
>>>  }
>>>  
>>> -bool tag_clear_highpages(struct page *page, int numpages)
>>> +void tag_clear_highpages(struct page *page, int numpages, bool clear_pages)
>>>  {
>>> -	/*
>>> -	 * Check if MTE is supported and fall back to clear_highpage().
>>> -	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
>>> -	 * post_alloc_hook() will invoke tag_clear_highpages().
>>> -	 */
>>> -	if (!system_supports_mte())
>>> -		return false;
>>> -
>>>  	/* Newly allocated pages, shouldn't have been tagged yet */
>>>  	for (int i = 0; i < numpages; i++, page++) {
>>>  		WARN_ON_ONCE(!try_page_mte_tagging(page));
>>> -		mte_zero_clear_page_tags(page_address(page));
>>> +		if (clear_pages)
>>> +			mte_zero_clear_page_tags(page_address(page));
>>> +		else
>>> +			mte_clear_page_tags(page_address(page));
>>>  		set_page_mte_tagged(page);
>>>  	}
>>> -	return true;
>>>  }
>>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>>> index 6c75df30a281..fd53a6fba33f 100644
>>> --- a/include/linux/gfp_types.h
>>> +++ b/include/linux/gfp_types.h
>>> @@ -273,11 +273,11 @@ enum {
>>>   *
>>>   * %__GFP_ZERO returns a zeroed page on success.
>>>   *
>>> - * %__GFP_ZEROTAGS zeroes memory tags at allocation time if the memory itself
>>> - * is being zeroed (either via __GFP_ZERO or via init_on_alloc, provided that
>>> - * __GFP_SKIP_ZERO is not set). This flag is intended for optimization: setting
>>> - * memory tags at the same time as zeroing memory has minimal additional
>>> - * performance impact.
>>> + * %__GFP_ZEROTAGS zeroes memory tags at allocation time. This flag is intended
>>> + * for optimization: setting memory tags at the same time as zeroing memory
>>> + * (e.g., with __GPF_ZERO) has minimal additional performance impact. However,
>>> + * __GFP_ZEROTAGS also zeroes the tags even if memory is not getting zeroed at
>>> + * allocation time (e.g., with init_on_free).
>>>   *
>>>   * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
>>>   * Used for userspace and vmalloc pages; the latter are unpoisoned by
>>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>>> index af03db851a1d..62f589baa343 100644
>>> --- a/include/linux/highmem.h
>>> +++ b/include/linux/highmem.h
>>> @@ -345,15 +345,7 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>>>  	kunmap_local(kaddr);
>>>  }
>>>  
>>> -#ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
>>> -
>>> -/* Return false to let people know we did not initialize the pages */
>>> -static inline bool tag_clear_highpages(struct page *page, int numpages)
>>> -{
>>> -	return false;
>>> -}
>>> -
>>> -#endif
>>> +void tag_clear_highpages(struct page *to, int numpages, bool clear_pages);
>>>  
>>>  /*
>>>   * If we pass in a base or tail page, we can zero up to PAGE_SIZE.
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 65e205111553..8c6821d25a00 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1808,9 +1808,9 @@ static inline bool should_skip_init(gfp_t flags)
>>>  inline void post_alloc_hook(struct page *page, unsigned int order,
>>>  				gfp_t gfp_flags)
>>>  {
>>> +	const bool zero_tags = kasan_hw_tags_enabled() && (gfp_flags & __GFP_ZEROTAGS);
>> 
>> Sashiko:
>> 
>> https://sashiko.dev/#/patchset/20260420-zerotags-v1-1-3edc93e95bb4%40kernel.org
>> 
>> PROT_MTE works without KASAN_HW_TAGS, so probably just retain the
>> system_supports_mte() check in tag_clear_highpages(), and document
>> that GFP_ZEROTAGS is only for MTE?
>
>Right, we have to clear tags here even without kasan. God, what an ugly
>mess people created here with these GFP flags.

Yeah, with kasan=off, kasan_init_hw_tags() returns early, so
kasan_hw_tags_enabled() stays false and tag_clear_highpages() is still
skipped.

With the small debug change below, it still reproduces reliably:

---8<---
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..d5b6e2474f47 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -225,8 +225,7 @@ static bool get_huge_zero_folio(void)
        if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
                return true;

-       zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
-                                ~__GFP_MOVABLE,
+       zero_folio = folio_alloc(GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS,
                        HPAGE_PMD_ORDER);
        if (!zero_folio) {
                count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
---

Cheers,
Lance

