Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6189C606A321
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VcygGcjq
Received: by kanga.kvack.org (Postfix)
	id 84BBD6B0157; Tue, 20 Oct 2026 09:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC0F6B04CB; Tue, 20 Oct 2026 09:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711AE6B04CC; Tue, 20 Oct 2026 09:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 467006B0157
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:27:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2DF3A73CE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:27:30 +0000 (UTC)
X-FDA: 85343081460.08.98554F9
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1873CC000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:27:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcygGcjq;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792502849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bNG+O9Mhp5lbrx3BoQ1xdHs39VYHKNeq+AtKI/tfWM=;
	b=4FTfTD/n6x+kFaEQiu9SEAPoOGaoJoSf7YR7M4EW84vBJHc6Q8O9p99Iai1svAPLANMmRx
	anV+Om0EAvEP45s4DPDRMKBre7GIMpR5jHpksATWRUR7Z5w79uvROg0aIomi8J/Hx2Fg4N
	JwzoVvaVwEgzFf6HySshi/L1XcedUkE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcygGcjq;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792502849;
	b=6tno1cwY/9kD800JKarrchCmO4YdCIOnFVRAqqx2Nl4GaRfNlLOqMf/FAVBDaxOPCYO/4P
	Enbf9wvcfJQLgha/2p4MVL+QLcZ94MUwrrRelOg38EOpYpiVG6I/WLIt7oaDnr5hgIpYMy
	4I455EirT/bYzk0lbtqlxLBgYThobys=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5Im6iM6caI5rF/Q5XPuIhrDe6ukl0oG+vIfDRIVnGjs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792502843; v=1; x=1793107643;
 b=VcygGcjqvV37tCuipMSzg+GRPA4KM+Hb0ygAi3SgIbA1+BLRC8i4QJs8kMXylSXlaNw0CX+Z
 OO0CGGJTFiHJ3OjtAP0QjEktgyARLmZfdvDne47xemhIl1ecVnJNYqKe/Kg27TfPrFKOkRYqHrM
 eL0MoGEJUd5VwlGcp+joBPX8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e3f5c746065a4e9d;
	Tue, 20 Oct 2026 13:27:23 +0000
X-Mizu-Trace-ID: e3f5c746065a4e9d
X-Migadu-Flow: FLOW_OUT
Message-ID: <d1ed2d7f-3999-4e8a-a290-1f812a0439af@linux.dev>
Date: Tue, 20 Oct 2026 21:27:14 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the
 mapping functions
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
 sashiko-reviews@lists.linux.dev, Madhavan Srinivasan <maddy@linux.ibm.com>,
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
Content-Language: en-US
In-Reply-To: <2b83dfaa-424b-4464-830e-a7714a816d5c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1873CC000A
X-Stat-Signature: etgrpog6i8e8hfkzonmdwiu7te3eg8ji
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792502846-547043
X-HE-Meta: U2FsdGVkX1+6IjHZsjME22yIDM5NkkbbBWYC4yuw0XvuTh1qfJlMVhciz5HWdITkaj6pGXzghPWbwdpqqskdItuRuBGv+TZ73ozCBZVJbJEXs9jJ4AypkK2IO+kgcBuiJ+zjhWmNXP6qUluz5/+bGZq/yOzFTnspr/Xfkw/TLj+GzBbFiM/o4NF4ty/p6csCSwR3CDkMinNT/26MJkO7xI6aeodM0P9Hh+cnmL0+Lht60X2lQ2a1o6cBLUFoGZh2cBbl04B4B/GT/FOMrA5cGXfxwFK1UXQEsUGF833/MkFZ2batLScZ7CUMLhrzWIdDsJiwLhrgcuOLLMe2stLjdQyd8DVcgjAYcb84H/oOMDTeBwBVoqhZUg0/0g3mpBihFADHwmJvhY53zfsn0Qc1BL6itwjnsyYl2NpMhTYqUcVDcP3ODIoz92MINU0vO31AnXhvN+YchrivkVcmAZ1y6DQ8g6gOEeUzs7uF62jBhaKl8iHi+afH4G0ZMaP/lcmcPdtPT99lHIgN7kMR09ghbk5zvubpEIdj4HrRQCx0/czNr1YLyjkz8fHzia5oa48ZER4ALseliCBD4449JZTW0QPYvtKjnT9t5DRySGsb5F+/oKEXBil8HnGkZaHdP/fkcsXsyMqjpWhaoy1ynGRgl2cS4gdJgcmDN9N/uhzEUf9+4Eo+ChioSgoKupv4A03nCs+9lysPYaW4iaDu1wVC86tE0c8o4CXNjdf6El3B1gsOuLYXXw11sOD+6RXUCT1D1wwFEGgLwCdwIU0WCKLfXYCjKIgu64DFy1fS2p4dwdTrqLdXwrr6ktod5xNxEHb9JQ5cJYXFRdUNyRJsOs8HzMqgK2QgWWimx0n2s/PgWn6MvQEbWeSsQ4cHt6VsfwIjPAjgjxsdTPvBuAYQ9ud5QUtR8naAdTm1+/RAldPYSg7nEzb1TOvHj3rwectPZnAG9ykh7fFnVjpbGmtlao6
 5dl7LQSO
 y+xgfPk7LgKZEzOJyGZQ0E9/qQgwPBeKH+CHLcW7OYuuADkUkVWOQ9VxIhSF6Hut9HhR1GE7fgrvaf33LEUln+i3nAgENlIZeqYi+AbXAqJ7zxsqcAz1VyUyZweCe3WnkzIWOMfQwahfpZ5VXPnkvw2dQVABU6q6+2erh4ylgL/o8IbLp0X+zqKiShZDFUrNyStuVzmbJkWf65WY96YQZxBMSpKOOjF/5XkZqKd9wUP7T+RGNBTBhNUd5GGjtS/idRxFEIkzZ+3CL4VgI1Qk4fPWgPMtzW008uOThvbV4GBeI7gso6uUmTrrKhvcm3Iv3sUHROvmwOCxywBMBkouNarvJ/lfMEzLfQwQLaJGNidaVhipmfPgf5mUi5mjhmz20cIzhJtgKBy1Ow/iavt6DjGRUsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/20/26 18:03, Hao Ge wrote:
> Hi Suren and Ulad
>
> Sashiko reported several issues, and they all look real.
> I have some ideas for fixing the first few;
> of course, please correct me if I get anything wrong.
>
> I'd like to discuss the last issue with you all.
>
>
> On 2026/10/20 13:45, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
>> - [High] mm/vmalloc: infinite loop in vunmap_pte_range() on unaligned error rollback
>> - [High] mm/vmalloc: __vmap_pages_range_noflush() calls cond_resched() in atomic context
>> - [Medium] mm/vmalloc: vmap_page_range() calls flush_cache_vmap() before error rollback
>> --
>>
>> commit 043026437ba63b051df5d14470fe69ce8fa8825c
>> Author: Hao Ge <hao.ge@linux.dev>
>>
>> mm/vmalloc: undo partial mappings inside the mapping functions
>>
>> This commit adds rollback logic using __vunmap_range_noflush() and
>> kmsan_vunmap_range_noflush() into vmap_page_range(),
>> __vmap_pages_range_noflush(), and vmap_pages_range_noflush() when page
>> table installation or KMSAN metadata setup fails. It also adds range and
>> page_shift validation in __vmap_pages_range_noflush().
>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 44e0eb32708f1..75aa5acf55660 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>>   	if (!err)
>>>   		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>>   					       ioremap_max_page_shift);
>>> +	if (err)
>>> +		__vunmap_range_noflush(addr, end);
>>> +
>>>   	return err;
>>>   }
>> [Severity: High]
>> What happens here when vmap_range_noflush() returns -EINVAL for a range
>> where end - addr is not PAGE_SIZE-aligned?
>>
>> In vmap_pte_range(), commit a739e6b557af09 added a check to bail out on
>> unaligned ranges specifically to avoid an infinite loop:
>>
>> mm/vmalloc.c:vmap_pte_range() {
>> 	...
>> 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>> 		return -EINVAL;
>> }
>>
>> This can be reached on 64KB page kernels via pci_remap_iospace() ->
>> vmap_page_range() with 16KB/32KB/48KB PCI I/O ranges (for example via
>> loongson_pci_probe() or acpi_pci_root_remap_iospace()).
>>
>> When vmap_pte_range() returns -EINVAL, vmap_page_range() now calls
>> __vunmap_range_noflush(addr, end) with the unaligned range. Whenever a PMD
>> in [addr, end) is already populated with a PTE table (such as the
>> PCI_IOBASE PMD populated during early boot by reserve_pio_range(), or an
>> earlier PMD mapped in the same call), __vunmap_range_noflush() descends
>> into vunmap_pte_range(), which has no alignment check:
>>
>> mm/vmalloc.c:vunmap_pte_range() {
>> 	...
>> 	do {
>> 		...
>> 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
>> 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
>> 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
>> }
>>
>> Because end - addr is not a multiple of PAGE_SIZE, won't addr step past end
>> and loop infinitely, clearing unrelated kernel PTEs and corrupting memory
>> past the PTE table?
>>
> That sounds reasonable. I will add a separate patch in the next version to fix
> this problem.
>
>> [Severity: Medium]
>> Also in vmap_page_range(), flush_cache_vmap(addr, end) is called
>> unconditionally before checking err and before rolling back with
>> __vunmap_range_noflush(addr, end):
>>
>> mm/vmalloc.c:vmap_page_range() {
>> 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>> 				 ioremap_max_page_shift);
>> 	flush_cache_vmap(addr, end);
>> 	if (!err)
>> 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>> 					       ioremap_max_page_shift);
>> 	if (err)
>> 		__vunmap_range_noflush(addr, end);
>>
>> 	return err;
>> }
>>
>> On UML, flush_cache_vmap is defined as flush_tlb_kernel_range:
>>
>> arch/um/include/asm/cacheflush.h:
>> #define flush_cache_vmap flush_tlb_kernel_range
>>
>> When vmap_range_noflush() fails partway through or
>> kmsan_ioremap_page_range() fails, flush_cache_vmap() runs while the
>> partially installed PTEs are still pte_present(), causing
>> update_pte_range() in arch/um/kernel/tlb.c to map them into the host OS via
>> ops->mmap() and clear _PAGE_NEEDSYNC:
>>
>> arch/um/kernel/tlb.c:update_pte_range() {
>> 	...
>> 		if (pte_present(*pte)) {
>> 			...
>> 			ret = ops->mmap(ops->mm_idp, addr, PAGE_SIZE,
>> 					prot, fd, offset);
>> 		} else
>> 			ret = ops->unmap(ops->mm_idp, addr, PAGE_SIZE);
>>
>> 		*pte = pte_mkuptodate(*pte);
>> }
>>
>> When __vunmap_range_noflush(addr, end) then clears the software PTEs
>> without a subsequent TLB flush or unmap notification, won't those host OS
>> mmap mappings be left behind? Should flush_cache_vmap(addr, end) only be
>> called after both vmap_range_noflush() and kmsan_ioremap_page_range()
>> succeed?
>>
> That sounds reasonable. I will add this logic in the next version.
>
>>> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>>   		pgprot_t prot, struct page **pages, unsigned int page_shift)
>>>   {
>>>   	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>>> +	unsigned long start = addr;
>>> +	int err = 0;
>>> +
>>> +	if (WARN_ON_ONCE(addr >= end))
>>> +		return -EINVAL;
>>>   
>>>   	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>>>   		return -EINVAL;
>>>   
>>>   	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>>> -			page_shift == PAGE_SHIFT)
>>> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
>>> -
>>> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>>> -		int err;
>>> -
>>> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>> +			page_shift == PAGE_SHIFT) {
>>> +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
>>> +	} else {
>>> +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>>> +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>>   					page_to_phys(pages[i]), prot,
>>>   					page_shift);
>>> -		if (err)
>>> -			return err;
>>> +			if (err)
>>> +				break;
>>>   
>>> -		addr += 1UL << page_shift;
>>> +			addr += 1UL << page_shift;
>>> +		}
>>>   	}
>>>   
>>> -	return 0;
>>> +	/* Undo the PTEs installed before the failure. */
>>> +	if (err)
>>> +		__vunmap_range_noflush(start, end);
>>> +
>>> +	return err;
>>>   }
>> [Severity: High]
>> Similarly here, __vmap_pages_range_noflush() checks addr >= end, but does
>> not check PAGE_ALIGNED(addr) or PAGE_ALIGNED(end).
>>
>> If a caller passes a sub-page or unaligned range (for example, 0 < end -
>> addr < PAGE_SIZE), nr = (end - addr) >> PAGE_SHIFT evaluates to 0, so the
>> huge-page path still maps nothing and returns 0, while the small-page path
>> loops infinitely in vmap_pages_pte_range(). And if the huge-page path fails
>> on an unaligned range, __vunmap_range_noflush(start, end) will hit the same
>> infinite loop in vunmap_pte_range().
>>
>> Should both vmap_page_range() and __vmap_pages_range_noflush() validate
>> PAGE_ALIGNED(addr) && PAGE_ALIGNED(end) upfront before attempting to map or
>> unmap?
>>
> I think We need to check both PAGE_ALIGNED(addr) and PAGE_ALIGNED(end).
> As an example: if addr is PAGE-aligned, end is not, and end - addr < PAGE_SIZE,
> then nr becomes zero. On the huge page path, we simply return 0 with no work performed.
>
> At the same time, vmap_pages_pte_range() needs the same guard as commit
> a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned"),
> to protect against unaligned ranges.
>
> So will do next version.
>
>>>   
>>>   int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>> @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>>   
>>>   	if (ret)
>>>   		return ret;
>>> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>>> +
>>> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>>> +	/*
>>> +	 * The page tables undo themselves on failure. Tear down the
>>> +	 * metadata that was fully set up before the mapping failed.
>>> +	 */
>>> +	if (ret)
>>> +		kmsan_vunmap_range_noflush(addr, end);
>>> +
>>> +	return ret;
>>>   }
>> [Severity: High]
>> Can calling __vunmap_range_noflush() and kmsan_vunmap_range_noflush() here
>> trigger a sleeping-in-atomic-context bug when __vmalloc() or kvmalloc() is
>> called with GFP_ATOMIC or GFP_NOWAIT?
>>
>> __vmalloc_area_node() supports non-blocking allocations by wrapping
>> __vmap_pages_range() in memalloc_apply_gfp_scope(gfp_mask):
>>
>> mm/vmalloc.c:__vmalloc_area_node() {
>> 	...
>> 	flags = memalloc_apply_gfp_scope(gfp_mask);
>> 	do {
>> 		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
>> 				page_shift, nested_gfp);
>> 	} while ((gfp_mask & __GFP_NOFAIL) && (ret < 0));
>> 	memalloc_restore_gfp_scope(flags);
>> }
>>
>> When a GFP_ATOMIC or GFP_NOWAIT allocation runs in atomic context (such as
>> under a spinlock, preempt_disable(), or rcu_read_lock()) and page table
>> allocation fails in vmap_small_pages_range_noflush() after at least one PMD
>> in [start, end) is populated (or after kmsan_vmap_pages_range_noflush()
>> populated the KMSAN shadow/origin ranges), __vmap_pages_range_noflush() and
>> kmsan_vunmap_range_noflush() synchronously call __vunmap_range_noflush().
>>
>> __vunmap_range_noflush() walks the populated PMDs via vunmap_pmd_range(),
>> which unconditionally calls cond_resched():
>>
>> mm/vmalloc.c:vunmap_pmd_range() {
>> 	...
>> 	do {
>> 		next = pmd_addr_end(addr, end);
>> 		if (pmd_none_or_clear_bad(pmd))
>> 			continue;
>> 		vunmap_pte_range(pmd, addr, next, mask);
>>
>> 		cond_resched();
>> 	} while (pmd++, addr = next, addr != end);
>> }
>>
>> Commit 9c47753167a6 ("mm/vmalloc: defer freeing partly initialized
>> vm_struct") deferred error-path cleanup in __vmalloc_area_node() to a
>> workqueue specifically because unmapping on failure can sleep. Doesn't
>> calling __vunmap_range_noflush() synchronously inside
>> __vmap_pages_range_noflush() and vmap_pages_range_noflush() reintroduce
>> cond_resched() in atomic context?
>>
> This issue also appears real. One possible approach is to plumb the caller's gfp_mask into vunmap_pmd_range()
> to conditionally skip cond_resched().
> Suren, Ulad, do you have any preferred or cleaner way to handle this?


Alternatively, we can follow the approach from commit 9c47753167a6 
("mm/vmalloc: defer freeing partly initialized vm_struct"):

defer the cleanup to a workqueue when |gfp_mask| has GFP_ATOMIC or 
GFP_NOWAIT，and perform cleanup synchronously

if we are already in process context. Anyway, I will look into this 
further tomorrow.


>
> Thanks
> Best Regards
> Hao
>

