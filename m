Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4358606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NXlWi6C9
Received: by kanga.kvack.org (Postfix)
	id B36886B0AA9; Thu, 22 Oct 2026 22:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7726B0AAA; Thu, 22 Oct 2026 22:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D65C6B0AAB; Thu, 22 Oct 2026 22:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5013B6B0AA9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:17:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 969E61202D9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:17:53 +0000 (UTC)
X-FDA: 85352280426.24.6B17984
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1319320006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:17:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NXlWi6C9;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792721871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQlhdkDUWhp2bBMbCCKQIjfwnHjZWGbDEzViyuYq5Sg=;
	b=dgud610lSjAosLEmO5A/VRr4gKKefXDCtB37Yil2Fw+yc1jkUDhhUQrNvzJR8jP/FurGmW
	I1aoPsfW1oGs9cPftjBJKirJbBBE+u8HTH/w3s/92d57aDST4qRDPku6dZZR7PMQnOcCMP
	LCSBcew0eqQuEgrg7pz6j49l/do7IS8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792721871;
	b=zzsa2dZuTJAx56hLIoeJm9qzLdO1ODs0+wd3wgLlOx4We/3EhmSSayGl6oqwMtUEOnrxhY
	ioJ2Xa/xyIUY4DRdFbKz+/DxXQMs03VukU53gNXQE8NauvPIfmW6q1SD8W5yae4hCk3vR8
	7WoDvn1QoY4ETmWUpI7lWdv2l5smswM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NXlWi6C9;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ERjrrk8nq4us/oPECnIv/8sbPA0XErnz752qADiuHps=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792721869; v=1; x=1793326669;
 b=NXlWi6C92Zyu970fQnoNc2+q9//4XKOZJOXpSzas24IyyMGE1ki/Sbro0KX4bnb4CeGeq3Pu
 FLSBw2AYPnGGa9u8MhSQAJkbjSTBeNuraPqjTVUCqVqBcxZCsfAyQ93+vEOm5Qf1uofsw5NM0Gy
 yu7QhHe/2afrm/bANJ+pVQoQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1ec964235bbeeb93;
	Fri, 23 Oct 2026 02:17:49 +0000
X-Mizu-Trace-ID: 1ec964235bbeeb93
X-Migadu-Flow: FLOW_OUT
Message-ID: <b838b389-c4a4-47d9-b723-b3a89714c885@linux.dev>
Date: Fri, 23 Oct 2026 10:18:57 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, sashiko-reviews@lists.linux.dev,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-4-hao.ge@linux.dev> <sashiko-outbox-178439@kernel.org>
 <2b83dfaa-424b-4464-830e-a7714a816d5c@linux.dev>
 <d1ed2d7f-3999-4e8a-a290-1f812a0439af@linux.dev> <ateD6VVhyiUAtsER@milan>
 <e58f1712-cfd1-4757-a47f-f8df53b8baf9@linux.dev> <atpHuSch1sbl9Cz3@milan>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <atpHuSch1sbl9Cz3@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1319320006
X-Stat-Signature: 7mkknws7rx4ahxq4u9h13khh3is67mhw
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792721870-135285
X-HE-Meta: U2FsdGVkX1/AXnt4BhVQTHe2R4i/pqT9XFmK3oUnGrLw1iCwwcjpqAx7nBcMtrTFaJxggy71PW5QZB/5mrpX0ofOoA9hX4FrBIRKPIPN2BdrCP+wZejB4RC3ue5/CfYPWp2IP1gy4z6Kl803vwQ+h3VsZZawuzHFau277TFhELt6IWUksqjMFh2YJh5eEKbhk/4ASSUwDaguKqNjFAC6H3AGb8t4UABrCsdm9eGR7YjP0rsHsrPbVQ0j52xcUykwwniziEtbtsIGkdD35hrHdxMJGEml3rEdJEARfhiAZj8y+y9B5+g4GV0IVOjmxYL8GDx+J7l+a5QQSP3Px+QUDLT7VhIWNWLBiVlRDhhluRvRvJ+FYOT40UZU6Y+lHYPiCpdqm6PcBMO+eKknmaz2BKT3miW1uby3aSCThj+B/0iSuh0yGnhdzW/gAA0ptHiTMAAoRRaYY8vtTOwfICsAYJAhNRO8/Ji3AMnXlVC+wNx/7dbFTkbiostrA3gdteO9g1dzF0ORUUnJYx7KCE6osQz9ATRDtT7kN+zPyyHojAZGbBaR4xEMZHQhIP8tW7kPc1S7g771n2WM3/xHBEeHH7r6T/OpNjNtTJ04xMgzebOxtMo6lvum/1uCWniqQWGvaodRnmz/Zf1ptYJz77q3op2N3lCjnSLEz6jJ8FwQQHF6QAfhnXmfRvJ3oc1zw0jr5n1qXtnW4KpzKdGnjdZUqwEQ2O4Gl+bTiBP2ux1N1u7wt0FX7RhD2IyVIdsXeHDIQF/1Qr73I9aOR8mpVEV2yB9AbcCnp6ljhUhbnTxcPezbuwvbY9c0IOT0VF6s3TQmu19MPnXm91UvwTjYbS8bmY9aJ6cydesN0TrnugoNDsiAx/QUc1wT4TXZEI3CHzZuDfE7XHXK9cOFWsM29UcC4NcH7tbbkttZpVle3JJMeJrpVgFq+5PtRrXF2F0vuwUKg3IXwZa1EN4MwJai3a1
 kdnCARRl
 r0VSxhAqVjmH79aBGAgkaW1FxNllZr1aQxKva+/7Kc1K+MnMUMQG3kqCu9UPmfBUw+OhxZTqmnvNLZlWqeLRFRjHTkynffy0Umxpuj0HLN9XpkpeU0MHI2jvJIxxknVnUqXXrjgLzV5ybJ0ZD7ZdQY4MjyKXIcUdgqq6zJgFjJdVyeC8mjGygW72sN2ZPFZSHm6QFu9YExJPj91WZi8qLler0GDT2OVFP9k277R/HTTqnWNrqqc0GCZNBUhonnarPzyXzDPRnYQ+byeQ5US+b5JDjEXM4hPuwALPTpNXsUPtFxKluOTIAJ14J3+WeiUc6XuGIO5MjqQbSRKGvNaXtPR/mttDgTLMlNi2j6l94A+YfM3USvlIM2hM8VbtyGKe5UvNHCQHOuxjRmEoVqbIUDbhYPlAWRAjLwmCdKaqT3D3ZEkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/23 01:28, Uladzislau Rezki wrote:
> On Thu, Oct 22, 2026 at 09:33:19PM +0800, Hao Ge wrote:
>> Hi Uladzislau and Suren
>>
>> On 2026/10/20 23:08, Uladzislau Rezki wrote:
>>> On Tue, Oct 20, 2026 at 09:27:14PM +0800, Hao Ge wrote:
>>>>
>>>> On 10/20/26 18:03, Hao Ge wrote:
>>>>> Hi Suren and Ulad
>>>>>
>>>>> Sashiko reported several issues, and they all look real.
>>>>> I have some ideas for fixing the first few;
>>>>> of course, please correct me if I get anything wrong.
>>>>>
>>>>> I'd like to discuss the last issue with you all.
>>>>>
>>>>>
>>>>> On 2026/10/20 13:45, sashiko-bot@kernel.org wrote:
>>>>>> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
>>>>>> - [High] mm/vmalloc: infinite loop in vunmap_pte_range() on unaligned error rollback
>>>>>> - [High] mm/vmalloc: __vmap_pages_range_noflush() calls cond_resched() in atomic context
>>>>>> - [Medium] mm/vmalloc: vmap_page_range() calls flush_cache_vmap() before error rollback
>>>>>> --
>>>>>>
>>>>>> commit 043026437ba63b051df5d14470fe69ce8fa8825c
>>>>>> Author: Hao Ge <hao.ge@linux.dev>
>>>>>>
>>>>>> mm/vmalloc: undo partial mappings inside the mapping functions
>>>>>>
>>>>>> This commit adds rollback logic using __vunmap_range_noflush() and
>>>>>> kmsan_vunmap_range_noflush() into vmap_page_range(),
>>>>>> __vmap_pages_range_noflush(), and vmap_pages_range_noflush() when page
>>>>>> table installation or KMSAN metadata setup fails. It also adds range and
>>>>>> page_shift validation in __vmap_pages_range_noflush().
>>>>>>
>>>>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>>>>> index 44e0eb32708f1..75aa5acf55660 100644
>>>>>>> --- a/mm/vmalloc.c
>>>>>>> +++ b/mm/vmalloc.c
>>>>>>> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>>>>>>   	if (!err)
>>>>>>>   		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>>>>>>   					       ioremap_max_page_shift);
>>>>>>> +	if (err)
>>>>>>> +		__vunmap_range_noflush(addr, end);
>>>>>>> +
>>>>>>>   	return err;
>>>>>>>   }
>>>>>> [Severity: High]
>>>>>> What happens here when vmap_range_noflush() returns -EINVAL for a range
>>>>>> where end - addr is not PAGE_SIZE-aligned?
>>>>>>
>>>>>> In vmap_pte_range(), commit a739e6b557af09 added a check to bail out on
>>>>>> unaligned ranges specifically to avoid an infinite loop:
>>>>>>
>>>>>> mm/vmalloc.c:vmap_pte_range() {
>>>>>> 	...
>>>>>> 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>>>>>> 		return -EINVAL;
>>>>>> }
>>>>>>
>>>>>> This can be reached on 64KB page kernels via pci_remap_iospace() ->
>>>>>> vmap_page_range() with 16KB/32KB/48KB PCI I/O ranges (for example via
>>>>>> loongson_pci_probe() or acpi_pci_root_remap_iospace()).
>>>>>>
>>>>>> When vmap_pte_range() returns -EINVAL, vmap_page_range() now calls
>>>>>> __vunmap_range_noflush(addr, end) with the unaligned range. Whenever a PMD
>>>>>> in [addr, end) is already populated with a PTE table (such as the
>>>>>> PCI_IOBASE PMD populated during early boot by reserve_pio_range(), or an
>>>>>> earlier PMD mapped in the same call), __vunmap_range_noflush() descends
>>>>>> into vunmap_pte_range(), which has no alignment check:
>>>>>>
>>>>>> mm/vmalloc.c:vunmap_pte_range() {
>>>>>> 	...
>>>>>> 	do {
>>>>>> 		...
>>>>>> 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
>>>>>> 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
>>>>>> 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
>>>>>> }
>>>>>>
>>>>>> Because end - addr is not a multiple of PAGE_SIZE, won't addr step past end
>>>>>> and loop infinitely, clearing unrelated kernel PTEs and corrupting memory
>>>>>> past the PTE table?
>>>>>>
>>>>> That sounds reasonable. I will add a separate patch in the next version to fix
>>>>> this problem.
>>>>>
>>>>>> [Severity: Medium]
>>>>>> Also in vmap_page_range(), flush_cache_vmap(addr, end) is called
>>>>>> unconditionally before checking err and before rolling back with
>>>>>> __vunmap_range_noflush(addr, end):
>>>>>>
>>>>>> mm/vmalloc.c:vmap_page_range() {
>>>>>> 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>>>>>> 				 ioremap_max_page_shift);
>>>>>> 	flush_cache_vmap(addr, end);
>>>>>> 	if (!err)
>>>>>> 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>>>>> 					       ioremap_max_page_shift);
>>>>>> 	if (err)
>>>>>> 		__vunmap_range_noflush(addr, end);
>>>>>>
>>>>>> 	return err;
>>>>>> }
>>>>>>
>>>>>> On UML, flush_cache_vmap is defined as flush_tlb_kernel_range:
>>>>>>
>>>>>> arch/um/include/asm/cacheflush.h:
>>>>>> #define flush_cache_vmap flush_tlb_kernel_range
>>>>>>
>>>>>> When vmap_range_noflush() fails partway through or
>>>>>> kmsan_ioremap_page_range() fails, flush_cache_vmap() runs while the
>>>>>> partially installed PTEs are still pte_present(), causing
>>>>>> update_pte_range() in arch/um/kernel/tlb.c to map them into the host OS via
>>>>>> ops->mmap() and clear _PAGE_NEEDSYNC:
>>>>>>
>>>>>> arch/um/kernel/tlb.c:update_pte_range() {
>>>>>> 	...
>>>>>> 		if (pte_present(*pte)) {
>>>>>> 			...
>>>>>> 			ret = ops->mmap(ops->mm_idp, addr, PAGE_SIZE,
>>>>>> 					prot, fd, offset);
>>>>>> 		} else
>>>>>> 			ret = ops->unmap(ops->mm_idp, addr, PAGE_SIZE);
>>>>>>
>>>>>> 		*pte = pte_mkuptodate(*pte);
>>>>>> }
>>>>>>
>>>>>> When __vunmap_range_noflush(addr, end) then clears the software PTEs
>>>>>> without a subsequent TLB flush or unmap notification, won't those host OS
>>>>>> mmap mappings be left behind? Should flush_cache_vmap(addr, end) only be
>>>>>> called after both vmap_range_noflush() and kmsan_ioremap_page_range()
>>>>>> succeed?
>>>>>>
>>>>> That sounds reasonable. I will add this logic in the next version.
>>>>>
>>>>>>> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>>>>>>   		pgprot_t prot, struct page **pages, unsigned int page_shift)
>>>>>>>   {
>>>>>>>   	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>>>>>>> +	unsigned long start = addr;
>>>>>>> +	int err = 0;
>>>>>>> +
>>>>>>> +	if (WARN_ON_ONCE(addr >= end))
>>>>>>> +		return -EINVAL;
>>>>>>>   	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>>>>>>>   		return -EINVAL;
>>>>>>>   	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>>>>>>> -			page_shift == PAGE_SHIFT)
>>>>>>> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
>>>>>>> -
>>>>>>> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>>>>>>> -		int err;
>>>>>>> -
>>>>>>> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>>>>>> +			page_shift == PAGE_SHIFT) {
>>>>>>> +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
>>>>>>> +	} else {
>>>>>>> +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>>>>>>> +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>>>>>>   					page_to_phys(pages[i]), prot,
>>>>>>>   					page_shift);
>>>>>>> -		if (err)
>>>>>>> -			return err;
>>>>>>> +			if (err)
>>>>>>> +				break;
>>>>>>> -		addr += 1UL << page_shift;
>>>>>>> +			addr += 1UL << page_shift;
>>>>>>> +		}
>>>>>>>   	}
>>>>>>> -	return 0;
>>>>>>> +	/* Undo the PTEs installed before the failure. */
>>>>>>> +	if (err)
>>>>>>> +		__vunmap_range_noflush(start, end);
>>>>>>> +
>>>>>>> +	return err;
>>>>>>>   }
>>>>>> [Severity: High]
>>>>>> Similarly here, __vmap_pages_range_noflush() checks addr >= end, but does
>>>>>> not check PAGE_ALIGNED(addr) or PAGE_ALIGNED(end).
>>>>>>
>>>>>> If a caller passes a sub-page or unaligned range (for example, 0 < end -
>>>>>> addr < PAGE_SIZE), nr = (end - addr) >> PAGE_SHIFT evaluates to 0, so the
>>>>>> huge-page path still maps nothing and returns 0, while the small-page path
>>>>>> loops infinitely in vmap_pages_pte_range(). And if the huge-page path fails
>>>>>> on an unaligned range, __vunmap_range_noflush(start, end) will hit the same
>>>>>> infinite loop in vunmap_pte_range().
>>>>>>
>>>>>> Should both vmap_page_range() and __vmap_pages_range_noflush() validate
>>>>>> PAGE_ALIGNED(addr) && PAGE_ALIGNED(end) upfront before attempting to map or
>>>>>> unmap?
>>>>>>
>>>>> I think We need to check both PAGE_ALIGNED(addr) and PAGE_ALIGNED(end).
>>>>> As an example: if addr is PAGE-aligned, end is not, and end - addr < PAGE_SIZE,
>>>>> then nr becomes zero. On the huge page path, we simply return 0 with no work performed.
>>>>>
>>>>> At the same time, vmap_pages_pte_range() needs the same guard as commit
>>>>> a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned"),
>>>>> to protect against unaligned ranges.
>>>>>
>>>>> So will do next version.
>>>>>
>>>>>>>   int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>>>>>> @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>>>>>>   	if (ret)
>>>>>>>   		return ret;
>>>>>>> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>>>>>>> +
>>>>>>> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>>>>>>> +	/*
>>>>>>> +	 * The page tables undo themselves on failure. Tear down the
>>>>>>> +	 * metadata that was fully set up before the mapping failed.
>>>>>>> +	 */
>>>>>>> +	if (ret)
>>>>>>> +		kmsan_vunmap_range_noflush(addr, end);
>>>>>>> +
>>>>>>> +	return ret;
>>>>>>>   }
>>>>>> [Severity: High]
>>>>>> Can calling __vunmap_range_noflush() and kmsan_vunmap_range_noflush() here
>>>>>> trigger a sleeping-in-atomic-context bug when __vmalloc() or kvmalloc() is
>>>>>> called with GFP_ATOMIC or GFP_NOWAIT?
>>>>>>
>>>>>> __vmalloc_area_node() supports non-blocking allocations by wrapping
>>>>>> __vmap_pages_range() in memalloc_apply_gfp_scope(gfp_mask):
>>>>>>
>>>>>> mm/vmalloc.c:__vmalloc_area_node() {
>>>>>> 	...
>>>>>> 	flags = memalloc_apply_gfp_scope(gfp_mask);
>>>>>> 	do {
>>>>>> 		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
>>>>>> 				page_shift, nested_gfp);
>>>>>> 	} while ((gfp_mask & __GFP_NOFAIL) && (ret < 0));
>>>>>> 	memalloc_restore_gfp_scope(flags);
>>>>>> }
>>>>>>
>>>>>> When a GFP_ATOMIC or GFP_NOWAIT allocation runs in atomic context (such as
>>>>>> under a spinlock, preempt_disable(), or rcu_read_lock()) and page table
>>>>>> allocation fails in vmap_small_pages_range_noflush() after at least one PMD
>>>>>> in [start, end) is populated (or after kmsan_vmap_pages_range_noflush()
>>>>>> populated the KMSAN shadow/origin ranges), __vmap_pages_range_noflush() and
>>>>>> kmsan_vunmap_range_noflush() synchronously call __vunmap_range_noflush().
>>>>>>
>>>>>> __vunmap_range_noflush() walks the populated PMDs via vunmap_pmd_range(),
>>>>>> which unconditionally calls cond_resched():
>>>>>>
>>>>>> mm/vmalloc.c:vunmap_pmd_range() {
>>>>>> 	...
>>>>>> 	do {
>>>>>> 		next = pmd_addr_end(addr, end);
>>>>>> 		if (pmd_none_or_clear_bad(pmd))
>>>>>> 			continue;
>>>>>> 		vunmap_pte_range(pmd, addr, next, mask);
>>>>>>
>>>>>> 		cond_resched();
>>>>>> 	} while (pmd++, addr = next, addr != end);
>>>>>> }
>>>>>>
>>>>>> Commit 9c47753167a6 ("mm/vmalloc: defer freeing partly initialized
>>>>>> vm_struct") deferred error-path cleanup in __vmalloc_area_node() to a
>>>>>> workqueue specifically because unmapping on failure can sleep. Doesn't
>>>>>> calling __vunmap_range_noflush() synchronously inside
>>>>>> __vmap_pages_range_noflush() and vmap_pages_range_noflush() reintroduce
>>>>>> cond_resched() in atomic context?
>>>>>>
>>>>> This issue also appears real. One possible approach is to plumb the caller's gfp_mask into vunmap_pmd_range()
>>>>> to conditionally skip cond_resched().
>>>>> Suren, Ulad, do you have any preferred or cleaner way to handle this?
>>>>
>>>>
>>>> Alternatively, we can follow the approach from commit 9c47753167a6
>>>> ("mm/vmalloc: defer freeing partly initialized vm_struct"):
>>>>
>>>> defer the cleanup to a workqueue when |gfp_mask| has GFP_ATOMIC or
>>>> GFP_NOWAIT，and perform cleanup synchronously
>>>>
>>>> if we are already in process context. Anyway, I will look into this further
>>>> tomorrow.
>>>>
>>> I will check the AI concern.
>>>
>>
>> Thank you very much for the quick reply and for offering to check
>> the AI concern. Much appreciated!
>>
>> Here is a summary of what I have found over the last few days.
>> I went through the history first. The cond_resched() in vunmap_pmd_range()
>> was added by commit e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range"),
>> modeled after zap_pte_range(). It fixed a real soft lockup: on a non-preemptible
>> kernel, unmapping a large persistent-memory namespace (hence a large I/O map region)
>> kept a CPU busy for 23 seconds inside the walk:
>>
>> 	watchdog: BUG: soft lockup - CPU#49 stuck for 23s! [ndctl:50777]
>>
>> Then I looked at how vfree() handles atomic contexts: it defers the
>> whole free to a workqueue from interrupt context (vfree_atomic()),
>> and 9c47753167a6 does the same for a partly initialized vm_struct.
>>
>> Unfortunately I do not think deferral works for this rollback case.
>> A deferred rollback returns with the PTEs still installed, and if
>> that range is mapped again before the workqueue runs, the mapping
>> hits the leftovers: a warning and -EBUSY on the small-page path, a
>> BUG() on the huge path.
>>
>> So I kept it simple: plumb the caller's gfp_mask down to the unmap
>> walk and call cond_resched() conditionally, like
>> commit 660654f90e7f ("mm/vmalloc.c: add a schedule point to vmalloc()")
>> did:
>> 	if (gfp_mask & __GFP_WAIT)
>> 		cond_resched();
>>
> Sounds good to me. But we have the helper: gfpflags_allow_blocking(gfp_mask))

Right.

> Another option is probably we can remove cond_resched(); from unmap path?

I'm wondering if removing cond_resched() from the unmap path would reintroduce
the softlockup issue fixed by below commit:

commit e47110e90584a22e9980510b00d0dfad3a83354e
Author: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Date:   Thu Aug 20 17:42:05 2020 -0700

    mm/vunmap: add cond_resched() in vunmap_pmd_range
    
    Like zap_pte_range add cond_resched so that we can avoid softlockups as
    reported below.  On non-preemptible kernel with large I/O map region (like
    the one we get when using persistent memory with sector mode), an unmap of
    the namespace can report below softlockups.
    
    22724.027334] watchdog: BUG: soft lockup - CPU#49 stuck for 23s! [ndctl:50777]
     NIP [c0000000000dc224] plpar_hcall+0x38/0x58
     LR [c0000000000d8898] pSeries_lpar_hpte_invalidate+0x68/0xb0
     Call Trace:
        flush_hash_page+0x114/0x200
        hpte_need_flush+0x2dc/0x540
        vunmap_page_range+0x538/0x6f0
        free_unmap_vmap_area+0x30/0x70
        remove_vm_area+0xfc/0x140
        __vunmap+0x68/0x270
        __iounmap.part.0+0x34/0x60
        memunmap+0x54/0x70
        release_nodes+0x28c/0x300
        device_release_driver_internal+0x16c/0x280
        unbind_store+0x124/0x170
        drv_attr_store+0x44/0x60
        sysfs_kf_write+0x64/0x90
        kernfs_fop_write+0x1b0/0x290
        __vfs_write+0x3c/0x70
        vfs_write+0xd8/0x260
        ksys_write+0xdc/0x130
        system_call+0x5c/0x70

Even though we gained lazy MMU mode after that issue was fixed, I suspect I
may be missing some technical details. Could you walk me through the reasoning
for removing this cond_resched()?

Thanks very much!

Thanks
Best Regards
Hao

> 
> --
> Uladzsislau Rezki

