Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296C7C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157716B0088; Thu,  6 Aug 2026 07:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108696B008A; Thu,  6 Aug 2026 07:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D9C6B0092; Thu,  6 Aug 2026 07:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD4B26B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:07:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3559DC06F5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:07:42 +0000 (UTC)
X-FDA: 85070569164.13.186255F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 78EA340011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:07:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hcW/YmTW";
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786014460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umeg7T32naGcJC9MzeautcojuTNjpQjQcwcgWxX/wig=;
	b=BgZceol/6AXk8r0+J0FEdeeCqUQBQfJGwkABJ3gJJRye89P0Fm4aZvA4ACbYcfL2Y7YGLD
	XQI5CFZvBWwHvhuIhzoTPHjZRaGu45X7R0bcR+QbUud3x6c8SteLGDMUKcGDQGsQqoV+45
	/WRjQ2iECcxVz54mV/J/iGq+1DP+Ppg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786014460;
	b=uq2XWoyOOqbNRYmRmPuXRyQio/L6l6oWEsNZl+jF0pbnyLUUKegak8bRJuurxPeD3mUGUb
	FFs7jM873BPNJpoV9C8uPx6rW7i5RLur8DbEj29iB149ix4nm++lrNy5WZGGLSu68FSes4
	Qubd3YKww/AKTsaPdMpfLbiKv5x9kcE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hcW/YmTW";
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <007cdb8b-01e3-4d73-9ac9-1a52ab5798dd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786014459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=umeg7T32naGcJC9MzeautcojuTNjpQjQcwcgWxX/wig=;
	b=hcW/YmTWu8rMYvyiIgd5FnpBnnsvyKdtYB13BU82KR0gatM1/3wXRw1pCBQ9MyKsf8DUPC
	kiAoFeH5CBh018Gv1n0EQF01ytl1jmY7fOS2XskqCUwiDFl0NPqQcaOtQL1pQYf3ZS7NZB
	hujwJYjhy6eveLPkHXkJV/3IohB8Boc=
Date: Thu, 6 Aug 2026 12:07:36 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
To: Sourav Panda <souravpanda@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260726072935.3513996-1-souravpanda@google.com>
 <20260805202444.1573218-1-usama.arif@linux.dev>
 <2qq6r5zvegrk5bbx7qbkscwqmccda7mxtzuvd3wln24yjm2qhx@663fzadsgmg3>
 <CANruzcT9PEXYRu1t_ge9ZNE8hLBpt6rWP4CwsBUkoZQTtpPKdA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CANruzcT9PEXYRu1t_ge9ZNE8hLBpt6rWP4CwsBUkoZQTtpPKdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78EA340011
X-Rspam-User: 
X-Stat-Signature: 9qiep3ejzhbg5f5d4tgrsc7b6fq1ekmd
X-HE-Tag: 1786014460-244575
X-HE-Meta: U2FsdGVkX19S4KJZpIEOi12AhcgmBJ37v9vlBTbV1BNrcTQnepIctjJp6UB7hXkcgPwLuU1nhG4Y8PQL3/yOtHCF/EGwHYG65vl/WeeH32JPm9bZAWQmBb/B/sgm+63YDxh+bL1dbTRiEYUxeiPfGhCWv13aZsPtUk04uyiVjOj7PFoY03IEx51o8dhHJb8kXILFO6kiKnlWjslbzSOrNLguafIno0bRTzdwH57N9QMLAZqHqhVZcis37asgi9lOZEyLQiyls6bFVO45lqMkmr2eUJPvhIgATiIdmvoTQKtn8WY7x0TMxBF27l6mwjBMqRUZn970DC2qaX52K0oO1wfjl1K42TL1inxliWVOTmmA98sTKK/+0KO3PKi07X+NBZ01iV0T1TXbSFuhKlV0A0+9qlFtevHVqaEcWFO/zNCPO+BnoPf3S6rrZ/MmPi+3Qq12NePUcmdE+O9UFhhPG0JN3SUk5ly6RMhsNwI4ptN01nKr0UuoMcQ82thpo9aeLXLD9V/kAHfKWIkI8sUWf4YQSNde7jiNwZRyECpZPPuMbJOBLODndUCmeFPx64Kb6bPUjf44m2BNwDehlnwnIL2pU6UswKWZFCUiIqixjOfo7xEFH3YEkkssf57wfx2QywpEzzdEu33BcbITQ/j/T8sNQT27pMFqwODt2TLJ5uUcWtD1t59mU7ZHUCDRhGzli0LRiJ/Ns/2qz6wHRD8VeSkUbJwQ+VcuIUNZIKA58e0xvVFld7aMUXtzKEbRqK57qGE+qgn/1hlpiXOkcaVs0XMzg0CiMIrlUh+gwuZOoSEmjT0aK0WEViNOKcJBDCf5Whf6YwezU0RB1dzXXay0sI0svkTIJBLEQx7pTmO1OI5+gJaEpbBayR8aSvgYffRM+xjRbT+qFEllcM2IyiKlIH+pQGvQjImtATnZGbSMyNWvHjkqAcU05SjIHkF+SqH4wtDzfw/CLd242T8bd6l
 KPR0wfOw
 njvgvqvVUXzDAr9cwYyqYuEj8bONGSeNrISVuqK0cFzQTaPYyNpmU6U7Txz2jQueCF1J6C+IG6CCtqsDAJMg146t6LHvhOb00AS0nqF0RH8mqfs5IsP59UsHCYRQ/FNvCxsjh0739OHlMwCGBdy7Sl6kGjejsR5Kw1IQcDvi67wlxvoUHRcdc2VHS8bnWVCL53qOfx4sPLRC155fxwbYFutb64FEP5x6JNxleDeWLvB5BGTqoiZDHMJ8JpZASU5QXtgC6SXENer4FcfqhcSmGtLhEHCipcFdCJQHQTpus+7TB2MYhaTjM2yhZIFcyKgU9UyTTRdU83dAUQaKYEr0OtWfQ0Y3jJke2FUe8QjNsuW8gQWapurj9yMjz8wUy3o25Z8LQX35dOzShvSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/08/2026 06:33, Sourav Panda wrote:
> On Wed, Aug 5, 2026 at 7:47 PM Anshuman Khandual
> <anshuman.khandual@arm.com> wrote:
>>
>> On Wed, Aug 05, 2026 at 01:24:42PM -0700, Usama Arif wrote:
>>> On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.com> wrote:
>>>
>>>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
>>>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
>>>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
>>>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
>>>> alloc_gigantic_frozen_folio().
>>>>
>>>> hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
>>>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
>>>> leading to a null pointer dereference kernel panic.
>>>>
>>>> Fix this by checking if nodemask is NULL in
>>>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
>>>> node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
>>>> back to any node with memory, keeping behavior consistent with
>>>> alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
>>>>
>>>> >From a userspace perspective, this bug allows an unprivileged user to
>>>> crash the kernel (trigger a panic) by requesting a gigantic hugepage
>>>> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
>>>> configured on a subset of NUMA nodes.
>>>>
>>>> This can be reproduced by booting a VM with two NUMA nodes, restricting
>>>> CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
>>>> hugepagesz=1G hugepages=0), and running a program that allocates a
>>>> 1GB hugepage area without reserving, restricts allocation to Node 0
>>>> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
>>>>
>>>>   void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
>>>>                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
>>>>                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>>>>   unsigned long nodemask = 1; /* Node 0 */
>>>>   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
>>>>         sizeof(nodemask) * 8, 0);
>>>>   memset(ptr, 0, 1UL << 30); /* Trigger fault */
>>>>
>>>> This results in a NULL pointer dereference:
>>>>
>>>>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>>>>   #PF: supervisor read access in kernel mode
>>>>   #PF: error_code(0x0000) - not-present page
>>>>   Oops: Oops: 0000 [#1] SMP NOPTI
>>>>   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>>>>   Call Trace:
>>>>    <TASK>
>>>>    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>>>>    alloc_surplus_hugetlb_folio+0x6d/0x100
>>>>    alloc_hugetlb_folio+0x3c5/0x660
>>>>    hugetlb_no_page+0x3d9/0x650
>>>>
>>>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Sourav Panda <souravpanda@google.com>
>>>> ---
>>>> Changes in v4:
>>>> - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach from v3.
>>>>   As Muchun Song pointed out, snapshotting cpuset_current_mems_allowed does
>>>>   not prevent false-positive allocation failures without complex retry loops,
>>>>   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() already handle
>>>>   NULL nodemasks safely internally.
>>>> - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_folio()
>>>>   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
>>>>   HugeTLB allocators clean and consistent.
>>>> - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
>>>> - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
>>>> - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
>>>>
>>>>  mm/hugetlb_cma.c | 5 ++++-
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>>>> index 39344d6c78d8..5744de0ceeb7 100644
>>>> --- a/mm/hugetlb_cma.c
>>>> +++ b/mm/hugetlb_cma.c
>>>> @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>>>>     if (!hugetlb_cma_size)
>>>>             return NULL;
>>>>
>>>> -   if (hugetlb_cma[nid])
>>>> +   if (!nodemask)
>>>> +           nodemask = &node_states[N_MEMORY];
>>>
>>> Hi Sourav,
>>>
>>> hmm what if cpuset.mems only allows allocation from node 0, and hugetlb CMA
>>> is only available on node 1. This will no now allow allocating a gigantic page
>>> on node 1 when its explicitly not allowed?
>>
>> That's fair point but should not the user be also responsible in provding a right
>> nodemask containing CMA memory if it prefers avoiding node_states[N_MEMORY] based
>> fallback mechanism in kernel ?
>>

I don't think the task can be made responsible for providing a CMA-aware fallback mask
here.  Userspace supplies the MPOL_PREFERRED_MANY preference, but the kernel itself
changes the second attempt to a NULL nodemask.  That permits fallback outside the
preferred policy nodes; it does not permit fallback outside the task's hardwall cpuset.

> 
> We have precedence for three options, which makes selecting one difficult :)
> 
> 1) nodemask = &cpuset_current_mems_allowed is currently being used in:
>        only_alloc_fresh_hugetlb_folio --> alloc_buddy_frozen_folio -->
> __alloc_frozen_pages_noprof --> prepare_alloc_pages.

Here I think using &cpuset_current_mems_allowed is part of the page allocator's wider cpuset handling.

> 2) Some places use cookies with cpuset_current_mems_allowed to prevent
> torn writes. But this adds complexity.
>        An example would be dequeue_hugetlb_folio_nodemask()
> 3) node_states[N_MEMORY] is sprinkled all over the kernel (simplest).
> 

I would prefer option 2.  A NULL mempolicy mask should fall back to
cpuset_current_mems_allowed, not all N_MEMORY nodes. 


>>>
>>> Would it not be better to check cpuset as well?
>>>
>>> Thanks,
>>> Usama
>>>
>>>> +
>>>> +   if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
>>>>             page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>>>>
>>>>     if (!page && !(gfp_mask & __GFP_THISNODE)) {
>>>> --
>>>> 2.55.0
>>>>


