Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2ACE78D64
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96FF6B0005; Mon,  9 Feb 2026 04:15:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4ECF6B0088; Mon,  9 Feb 2026 04:15:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78696B0089; Mon,  9 Feb 2026 04:15:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFE136B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:15:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71B86160740
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:15:00 +0000 (UTC)
X-FDA: 84424358760.15.913C6FE
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B8C2C0008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:14:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aE2DyNLZ;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770628498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBNUV6kod+9jlPmpVveNFKDk0XgxjGadUgD7ujMimhw=;
	b=ztJHxIAvziUN9sWERJSLY1zpPfsY+r5eaFNPbx06ENEinGEpL84kXkbwKbMymTv+Xwrb4f
	cPyzDLPA0DIz6f0Y8ZoYIJNrJp3b0o1KhF9+T1qY9sBHo4M1BAzFmRUVexu0/3J5SySg3A
	UwmVKM4mfF8wgfWoQfMN3JTxcZl9i4k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aE2DyNLZ;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770628498; a=rsa-sha256;
	cv=none;
	b=NNc7taTZxC89an17nDzj46iwkfK/KnVhfd6jUrGUm6+vK8wglqEO1ZdyrBKO6Ip7mBi+hC
	gwz0qc61tQQRQQSRvkAmqMWYJRPtjp/7rSUqY/fLWyGdF7I/RmIqAAdVqZfoYkMGzOJy6v
	uTMxgjz9e/OSZ3bFrOhKZJ6e/4LxRGM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770628492; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qBNUV6kod+9jlPmpVveNFKDk0XgxjGadUgD7ujMimhw=;
	b=aE2DyNLZOw6ZbsjIlpO0g0OmOykL0ZLtKWPmgskW2BFj/C3Zm9OfjNKtkAyn0reySN3u5IqjDkEE6lOno7k1mx7IVU0p6ee1+NAhf0EMYVCuNso303g2+5MQlgCUl0Ur5KZrUXVYTK/tJCthfHuMNy/eiZWmzjfL2LOqlVoZs3o=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wyq5Xur_1770628490 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 17:14:51 +0800
Message-ID: <44453a4c-50a2-4e7e-9d2a-ebf973ccf6b7@linux.alibaba.com>
Date: Mon, 9 Feb 2026 17:14:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] mm: rmap: support batched checks of the references
 for large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <18b3eb9c730d16756e5d23c7be22efe2f6219911.1766631066.git.baolin.wang@linux.alibaba.com>
 <3d5cb9a4-6604-4302-a110-3d8ff91baa56@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <3d5cb9a4-6604-4302-a110-3d8ff91baa56@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jh77jdzcktedjo9wwh9f34eq9b51uttn
X-Rspamd-Queue-Id: 7B8C2C0008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770628496-424122
X-HE-Meta: U2FsdGVkX19E6NxKThst2CAJ9e7ygHWs7VxONlmidHeGikXe2fJS8lkVRjXL5rQar2l/POyNvKfB1do2y6t9bir6oRaus+6VIG3kqOxNXOzeTeIG6j0ndmvCNRfQvu7Si4YMzrJEcIztukBb5cC2LEjrECvjzPD4AtaXeUlWmkw0ohTBW8Za7uKyIvm6xqrMCqHxvMfdcbgcXbecOEhRFHTl7N/eD+oDGdfObRR7TIk9M6F5XGIH5yaQPrby7P+aX67yLW0GdZEnNtquCaKHe2hhu7Sba+WLd7Rsz+gyk0aDVtVfpYWIJBiJIAMRx0y12dS9nwnzDpXYbANFeOegZhBWpLpND5j+lNRZEvHz80o6l50LYlkZfE2XEMAygekbyExz9s+3i6OdAaGON7ZEDDcRLvOrai4FQPwuQj24Odn5lUgEocngFHQvsft9CoE/wf0fdsUEhfzCmsg6IuKjHW89PeyrHVAERXAI1kZNA+9A1dhtsn1AoApMaKxdaJBJlvV+6CIaT5OMME6lMBUM8lTuFBIt4iSGLlbvZaMSrlPKPBZceAbZOHe4k123Ezuj3o9G13cHc2yOg5ubV3U00psZFtIGUm9VkHhGWjMkrka4lNx9isAoqhhpS5H//tS3P/qeMv83eLSnM19rJl2YG5fvYkxyreQ6R73LqFzBr7bFhrS+2gxgt4F4DiWtSJaZf8ZzCzocRpTTFiy8vwfMxzlP97P6eXK7fHW20apS8zgcoiHaJTzJd3/rnPf2BI5RrrDIZ0XaDfvbSLXsiGWvg9EMkkkyA7dp79ZwtZRq10Bi00lMHp2kPOueIzSk7trqoTnweQUEMWaWIZ24yEsEdOI+zmBM73zW36IXsznIoEjyJ5Pe/FEI64qMky4EGAh5V+IYr6bE7Lv6V7nb58FD2Ja94hDxdpD/MLn5AMZpWVbablisMfoaWrENHKdB5JB2pVFgvNyWJJJE8kMzP9D
 ElOxg305
 WaU+QrxBcYu8PGryk2aiiNIrHE6MBuRqwHaVWEO1qotknj4h5T/rtaEDuxVrcWf8cSP6UhLL7lq45U8SmK7JWHIUzyMM69HHiNjM0H1MaVP9pDcvkaVx0SStu5IyRB03Dtgd91tjmaRKN1LkuXULqaaAMiKUzzP/E3V7h781nRErRTO0a4cdEaoZSosVAe4xKJX9Ymhi2sV/8kB43AiMbAsXLrMo+5hhTewDo3uDARGA5OyohGAauuRb8+GNjJQOQhM3P4ceaNwzyKL22bwsgXjWy4L2acMRCGi29L4yRKyJB8zFl4mv2HrxohByCB/7bUKc2hT1bEJ1bOkqYhwJxOy4JKwCkrz6qASLs11PEKtmUUESBwrSM4aTtGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/9/26 4:49 PM, David Hildenbrand (Arm) wrote:
> On 12/26/25 07:07, Baolin Wang wrote:
>> Currently, folio_referenced_one() always checks the young flag for 
>> each PTE
>> sequentially, which is inefficient for large folios. This inefficiency is
>> especially noticeable when reclaiming clean file-backed large folios, 
>> where
>> folio_referenced() is observed as a significant performance hotspot.
>>
>> Moreover, on Arm64 architecture, which supports contiguous PTEs, there 
>> is already
>> an optimization to clear the young flags for PTEs within a contiguous 
>> range.
>> However, this is not sufficient. We can extend this to perform batched 
>> operations
>> for the entire large folio (which might exceed the contiguous range: 
>> CONT_PTE_SIZE).
>>
>> Introduce a new API: clear_flush_young_ptes() to facilitate batched 
>> checking
>> of the young flags and flushing TLB entries, thereby improving 
>> performance
>> during large folio reclamation. And it will be overridden by the 
>> architecture
>> that implements a more efficient batch operation in the following 
>> patches.
>>
>> While we are at it, rename ptep_clear_flush_young_notify() to
>> clear_flush_young_ptes_notify() to indicate that this is a batch 
>> operation.
>>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   include/linux/mmu_notifier.h |  9 +++++----
>>   include/linux/pgtable.h      | 31 +++++++++++++++++++++++++++++++
>>   mm/rmap.c                    | 31 ++++++++++++++++++++++++++++---
>>   3 files changed, 64 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index d1094c2d5fb6..07a2bbaf86e9 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>       range->owner = owner;
>>   }
>> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)        \
>> +#define clear_flush_young_ptes_notify(__vma, __address, __ptep, 
>> __nr)    \
>>   ({                                    \
>>       int __young;                            \
>>       struct vm_area_struct *___vma = __vma;                \
>>       unsigned long ___address = __address;                \
>> -    __young = ptep_clear_flush_young(___vma, ___address, __ptep);    \
>> +    unsigned int ___nr = __nr;                    \
>> +    __young = clear_flush_young_ptes(___vma, ___address, __ptep, 
>> ___nr);    \
>>       __young |= mmu_notifier_clear_flush_young(___vma->vm_mm,    \
>>                             ___address,        \
>>                             ___address +        \
>> -                            PAGE_SIZE);    \
>> +                          ___nr * PAGE_SIZE);    \
>>       __young;                            \
>>   })
> 
> Man that's ugly, Not your fault, but can this possibly be turned into an 
> inline function in a follow-up patch.

Yes, the cleanup of these macros is already in my follow-up patch set.

>> +#ifndef clear_flush_young_ptes
>> +/**
>> + * clear_flush_young_ptes - Clear the access bit and perform a TLB 
>> flush for PTEs
>> + *                that map consecutive pages of the same folio.
> 
> With clear_young_dirty_ptes() description in mind, this should probably 
> be "Mark PTEs that map consecutive pages of the same folio as clean and 
> flush the TLB" ?

IMO, “clean” is confusing here, as it sounds like clear the dirty bit to 
make the folio clean.

>> + * @vma: The virtual memory area the pages are mapped into.
>> + * @addr: Address the first page is mapped at.
>> + * @ptep: Page table pointer for the first entry.
>> + * @nr: Number of entries to clear access bit.
>> + *
>> + * May be overridden by the architecture; otherwise, implemented as a 
>> simple
>> + * loop over ptep_clear_flush_young().
>> + *
>> + * Note that PTE bits in the PTE range besides the PFN can differ. 
>> For example,
>> + * some PTEs might be write-protected.
>> + *
>> + * Context: The caller holds the page table lock.  The PTEs map 
>> consecutive
>> + * pages that belong to the same folio.  The PTEs are all in the same 
>> PMD.
>> + */
>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +                     unsigned long addr, pte_t *ptep,
>> +                     unsigned int nr)
> 
> Two-tab alignment on second+ line like all similar functions here.

Sure.

>> +{
>> +    int i, young = 0;
>> +
>> +    for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
>> +        young |= ptep_clear_flush_young(vma, addr, ptep);
>> +
> 
> Why don't we use a similar loop we use in clear_young_dirty_ptes() or 
> clear_full_ptes() etc? It's not only consistent but also optimizes out 
> the first check for nr.
> for (;;) {
>      young |= ptep_clear_flush_young(vma, addr, ptep);
>      if (--nr == 0)
>          break;
>      ptep++;
>      addr += PAGE_SIZE;
> }

We’ve discussed this loop pattern before [1], and it seems that people 
prefer the ‘for (;;)’ loop. Do you have a strong preference for changing 
it back?

[1]https://lore.kernel.org/all/ec49f0fe-9df8-4762-b315-240cbb1ed3ce@arm.com/

>> +    return young;
>> +}
>> +#endif
>> +
>>   /*
>>    * On some architectures hardware does not set page access bit when 
>> accessing
>>    * memory page, it is responsibility of software setting this bit. 
>> It brings
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index e805ddc5a27b..985ab0b085ba 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -828,9 +828,11 @@ static bool folio_referenced_one(struct folio 
>> *folio,
>>       struct folio_referenced_arg *pra = arg;
>>       DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>>       int ptes = 0, referenced = 0;
>> +    unsigned int nr;
>>       while (page_vma_mapped_walk(&pvmw)) {
>>           address = pvmw.address;
>> +        nr = 1;
>>           if (vma->vm_flags & VM_LOCKED) {
>>               ptes++;
>> @@ -875,9 +877,24 @@ static bool folio_referenced_one(struct folio 
>> *folio,
>>               if (lru_gen_look_around(&pvmw))
>>                   referenced++;
>>           } else if (pvmw.pte) {
>> -            if (ptep_clear_flush_young_notify(vma, address,
>> -                        pvmw.pte))
>> +            if (folio_test_large(folio)) {
>> +                unsigned long end_addr =
>> +                    pmd_addr_end(address, vma->vm_end);
>> +                unsigned int max_nr =
>> +                    (end_addr - address) >> PAGE_SHIFT;
> 
> Good news: you can both fit into a single line as we are allowed to 
> exceed 80c if it aids readability.

Sure.

>> +                pte_t pteval = ptep_get(pvmw.pte);
>> +
>> +                nr = folio_pte_batch(folio, pvmw.pte,
>> +                             pteval, max_nr);
>> +            }
>> +
>> +            ptes += nr;
> 
> I'm not sure about whether we should mess with the "ptes" variable that 
> is so far only used for VM_LOCKED vmas. See below, maybe we can just 
> avoid that.

See below.

> 
>> +            if (clear_flush_young_ptes_notify(vma, address,
>> +                        pvmw.pte, nr))
> 
> Could maybe fit that into a single line as well, whatever you prefer.

Sure.

>>                   referenced++;
>> +            /* Skip the batched PTEs */
>> +            pvmw.pte += nr - 1;
>> +            pvmw.address += (nr - 1) * PAGE_SIZE;
>>           } else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>>               if (pmdp_clear_flush_young_notify(vma, address,
>>                           pvmw.pmd))
>> @@ -887,7 +904,15 @@ static bool folio_referenced_one(struct folio 
>> *folio,
>>               WARN_ON_ONCE(1);
>>           }
>> -        pra->mapcount--;
>> +        pra->mapcount -= nr;
>> +        /*
>> +         * If we are sure that we batched the entire folio,
>> +         * we can just optimize and stop right here.
>> +         */
>> +        if (ptes == pvmw.nr_pages) {
>> +            page_vma_mapped_walk_done(&pvmw);
>> +            break;
>> +        }
> Why not check for !pra->mapcount? Then you can also drop the comment, 
> because it's exactly the same thing we check after the loop to indicate 
> what to return to the caller.
> 
> And you will not have to mess with the "ptes" variable?

We can't rely on pra->mapcount here, because a folio can be mapped in 
multiple VMAs. Even if the pra->mapcount is not zero, we can still call 
page_vma_mapped_walk_done() for the current VMA mapping when the entire 
folio is batched.

> Only minor stuff.

Thanks for taking a look.

