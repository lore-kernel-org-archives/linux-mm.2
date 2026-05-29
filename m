Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1CC1CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668BF6B0005; Fri, 29 May 2026 01:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1C06B0088; Fri, 29 May 2026 01:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507816B008A; Fri, 29 May 2026 01:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAF66B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:28:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C30951C0D29
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:28:17 +0000 (UTC)
X-FDA: 84819326634.07.45731B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id A78A040009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:28:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vmO7qK43;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780032496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCawjAl+NONgE8jzAgegLJ0ZSZ0Z5OkZOZKFtqUGpZc=;
	b=AYtbC+X6R3haeMqgQX1hy5bL330TVIwRgas5gHYsj+6ix2OGySO2uonR2sxVK0570JzmgD
	+1x2caGBVkDVExcEp418NI3UxZvBh1ZDqufOwDt1/YH/TvPczNUYhr4Zz5yLc0pgIbo/gq
	xUefjsgbuy/y9EsjZHmdYOdeR9MOeZs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vmO7qK43;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780032496; a=rsa-sha256;
	cv=none;
	b=G0shBk3Mr62doRUn3SZ864et8FVBZJpgiHxSOyOLq5MkBledEb62i8x4MZiPiHX2ayWeyj
	q3tF0VLm/nGBuuX3QTEvReaBQ9ouYOE9aMJfk8pYbjwKGRKscU/MuLTsvSZepV56vYoAvd
	72EaivYZeGHjDmkvcKya9u+D8Aj2pss=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9282C202C;
	Thu, 28 May 2026 22:28:09 -0700 (PDT)
Received: from [10.164.19.8] (unknown [10.164.19.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A14243F7B4;
	Thu, 28 May 2026 22:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780032494; bh=GoSBuQs1KCUsbRbVPKVRa5mhiCL1VyTOqr0I0dgdgWc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vmO7qK43eGTwswE9djxFlSMuCgSf4V+12iZVIAIyIDt3TKQyzQoUidtrtNB5sHj1Y
	 N7jUgrqCK7UsLKGLqhgXck32WCaOk5YQG69VSjTaCFlhk6JzI7dwgj77y1wsE2f64m
	 ukk+iLqeQ6Z9i4aEKZR5NafmNQy9OZGNYBIk6QuQ=
Message-ID: <d9b97a50-a7d7-46e4-8e93-608d82926401@arm.com>
Date: Fri, 29 May 2026 10:58:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
 rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
 jiangwen6@xiaomi.com
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-5-jiangwenxiaomi@gmail.com>
 <46b0f2a7-3c0d-4372-a45d-946d8259d410@arm.com>
 <CAHKocdEfX3dgUr3O6q1WOe4PddN2=LKfX6Y5DfrfTwF9MM5J3w@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAHKocdEfX3dgUr3O6q1WOe4PddN2=LKfX6Y5DfrfTwF9MM5J3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g6wio7tgr77q7kmehamzi41ffwd9ygmw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A78A040009
X-HE-Tag: 1780032495-443845
X-HE-Meta: U2FsdGVkX19tppjvPc3ml9zru1AeXhmgUpHz14OnVx/L0G5cFx6pbPvq0vuJOhQCFYGicCvmqpkrrn2jTSw4F26vB7RSpeqcN/wi3DWZVXMVlDH7yubKg0hN8ca7q4cH7aSvZ1c/et/AtGOKWzCR3dSXw4aSXmaQljMC9yUSdA+wBQ0Ih+snQZ4bcyBoN5GfM5eQ7o+3W+Yb4hoUjh4aohRTnokizj8/t0Fkk5oHIUUuJMHrmT0PuzR3p84mfcenPxfIVLfzDi4zZtjUhFhHjisIdNsstkx+lsSL1vh5D1t57Sg9WisBpNpO2XeMJkVOUVJ+zkGszjJsxLrUL6BvOgkNiHZ3FEk/0gnzT6XsriMAcLwGgEb8l7RGZcF1lNCmqKfNZhZcUf6e9wDhNPjvwJECRQXNQIXV20TC6g7dQlEclpkyYT0oVD/AhdMgHR2T6qEYhTJT7yWzmFPzsHJqo8e0kkCvYvD5W5yBmRGqx1LZH8sxztwDIcn97tBcm7Usw9ubGj27fWayURTnbAlh+xudJNktP9AZd+/J2hQ97PtSV/O3VlpaFJgP5Q75Wwv1XS51afzQTDRk1eTlxKyS05JEcbyUv9hVWADHdOh6d3pHFvtdV2HDNAdUdGYZmUkUSLlfPhfU3ujcZCb46yZH3LwpLKyPzw4gjogDCHi6UPMcd9hv7Z5HX+D3XI7FG6nbR3FbDYPRUrCqZhdP+QOaNgEz6TwQEvPJsEr0/um+Rqlm5acywavOMd+qPMmI3E4iupUNhmeZy4pKTFQ/0ceEDReREmddp1Ga4d/ws8wLYNkVWnpv10eAOSpd+TkaFHiAK7J/9uHGW2haJlSFEAV9thm1LxScB71QvQT1prWkwI0zfkUVGWdwti+FXEdWTczgS5mjs+L1dPq9oQMNA4U/ZBydoXnTSqtCAvWnx5MqIFuwuU08kR1v3UqHgGo61F8E/NBY4Zw0TweZBnqKSJe
 Oat+Skhg
 tIebpWPZFhYQ73jG6WdWYmYQqHpOGY8MtqObsnPl/jZz2OzOSIzbvxWGhyFnLeN1fmJhTdaacmB+YuxmfMMNpr6AKvXVYefkEarwlGCOUEJbfbErUfaoZnVWU8ocmXpSTnxDorzApDyb426l09uo2Z7Le1rj3duEJaOFipqEMZRIbUPjYY3AVMU3P6I21ESe+LT/wWtFDg9e9mBN8L/rElbFI1tefFVwdrwye/q6n33laqQh6voV2nUeDyIvK6pjTq6hD0zUpWfUadUmrmhvCf3dpmyYOcw9AWyjNXi3MZXt6Xma2Kn4QQc+tme2qtnZcXi3hCsvqVWr03+OZOir5ZasrZOq67Cx8wWSDUD4+h+fQDXxvl/76lHnUmPbExHs7oj/56EJjwzidUYvseYrMztQp1hOoWJpGRGZLQawEq9XRc4J9ZHc6nniXtUxiJfqSFjRfIb8ZqrYsXgqvXla5f2BQKm3eOQiDt/A5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/05/26 9:09 am, Wen Jiang wrote:
> On Wed, 27 May 2026 at 13:59, Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 22/05/26 11:01 am, Wen Jiang wrote:
>> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>>
>> vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
>> provides a clean interface by taking struct page **pages and mapping them
>> via direct PTE iteration. This avoids the page table rewalk seen when
>> using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
>>
>> Extend it to support larger page_shift values, and add PMD- and
>> contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
>> since it now handles more than just small pages.
>>
>> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
>> iterate over pages one by one via vmap_range_noflush(), which would
>> otherwise lead to page table rewalk. The code is now unified with the
>> PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
>>
>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>> ---
>>  mm/vmalloc.c | 71 +++++++++++++++++++++++++++++-----------------------
>>  1 file changed, 40 insertions(+), 31 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 53fd4ee460ea4..deb764abc0571 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -543,8 +543,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
>>
>>  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
>> -             pgtbl_mod_mask *mask)
>> +             pgtbl_mod_mask *mask, unsigned int shift)
>>  {
>> +     unsigned long pfn, size;
>> +     unsigned int steps;
>>       int err = 0;
>>       pte_t *pte;
>>
>> @@ -575,9 +577,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>>                       break;
>>               }
>>
>> -             set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
>> -             (*nr)++;
>> -     } while (pte++, addr += PAGE_SIZE, addr != end);
>> +             pfn = page_to_pfn(page);
>> +             size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
>> +             steps = PFN_DOWN(size);
>> +     } while (pte += steps, *nr += steps, addr += size, addr != end);
>>
>>       lazy_mmu_mode_disable();
>>       *mask |= PGTBL_PTE_MODIFIED;
>> @@ -587,7 +590,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>>
>>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
>> -             pgtbl_mod_mask *mask)
>> +             pgtbl_mod_mask *mask, unsigned int shift)
>>  {
>>       pmd_t *pmd;
>>       unsigned long next;
>>> @@ -597,7 +600,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>>>               return -ENOMEM;
>>>       do {
>>>               next = pmd_addr_end(addr, end);
>>> -             if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
>>> +
>>> +             if (shift == PMD_SHIFT) {
>>> +                     struct page *page = pages[*nr];
>>> +                     phys_addr_t phys_addr;
>>> +
>>> +                     if (WARN_ON(!page))
>>> +                             return -ENOMEM;
>>> +                     if (WARN_ON(!pfn_valid(page_to_pfn(page))))
>>> +                             return -EINVAL;
>>
>>
>> So I know these !page and !pfn_valid checks have been copied from vmap_pages_pte_range,
>> but do they mean anything?
>>
>> I think pfn_valid() makes sense in that someone may take a random VA/PA, convert it into a struct
>> page and pass to vmap layer. But I don't see how anyone would pass page == NULL? At the
>> very least, returning ENOMEM does not make sense because the pages are not being
>> allocated by vmap() but have already been allocated.
> 
> Hi Dev,
> 
> vmap() is EXPORT_SYMBOL with many callers across drivers, each
> constructing the pages array differently. The !page check guards
> against malformed arrays at this API boundary.
> 
> The same -ENOMEM issue also exists in vmap_pages_pte_range().
> Should I fix both in this patchset or leave it as a separate cleanup?

Hmm - I think this is the issue of who validates what. I think the change
should be done but this is not an urgent issue, so let us leave this
for now.

> 
>>
>>> +
>>> +                     phys_addr = page_to_phys(page);
>>> +
>>> +                     if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
>>> +                                             shift)) {
>>> +                             *mask |= PGTBL_PMD_MODIFIED;
>>> +                             *nr += 1 << (shift - PAGE_SHIFT);
>>> +                             continue;
>>> +                     }
>>> +             }
>>> +
>>> +             if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
>>>                       return -ENOMEM;
>>>       } while (pmd++, addr = next, addr != end);
>>>       return 0;
>>> @@ -605,7 +628,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>>>
>>>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>>>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
>>> -             pgtbl_mod_mask *mask)
>>> +             pgtbl_mod_mask *mask, unsigned int shift)
>>>  {
>>>       pud_t *pud;
>>>       unsigned long next;
>>> @@ -615,7 +638,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>>>               return -ENOMEM;
>>>       do {
>>>               next = pud_addr_end(addr, end);
>>> -             if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
>>> +             if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
>>>                       return -ENOMEM;
>>>       } while (pud++, addr = next, addr != end);
>>>       return 0;
>>> @@ -623,7 +646,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>>>
>>>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>>>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
>>> -             pgtbl_mod_mask *mask)
>>> +             pgtbl_mod_mask *mask, unsigned int shift)
>>>  {
>>>       p4d_t *p4d;
>>>       unsigned long next;
>>> @@ -633,14 +656,14 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>>>               return -ENOMEM;
>>>       do {
>>>               next = p4d_addr_end(addr, end);
>>> -             if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
>>> +             if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
>>>                       return -ENOMEM;
>>>       } while (p4d++, addr = next, addr != end);
>>>       return 0;
>>>  }
>>>
>>> -static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>>> -             pgprot_t prot, struct page **pages)
>>> +static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>>> +             pgprot_t prot, struct page **pages, unsigned int shift)
>>>  {
>>>       unsigned long start = addr;
>>>       pgd_t *pgd;
>>> @@ -655,7 +678,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>>>               next = pgd_addr_end(addr, end);
>>>               if (pgd_bad(*pgd))
>>>                       mask |= PGTBL_PGD_MODIFIED;
>>> -             err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
>>> +             err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
>>>               if (err)
>>>                       break;
>>>       } while (pgd++, addr = next, addr != end);
>>> @@ -678,27 +701,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>>>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>>               pgprot_t prot, struct page **pages, unsigned int page_shift)
>>>  {
>>> -     unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>>> -
>>>       WARN_ON(page_shift < PAGE_SHIFT);
>>>
>>> -     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>>> -                     page_shift == PAGE_SHIFT)
>>> -             return vmap_small_pages_range_noflush(addr, end, prot, pages);
>>> +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>>> +             page_shift = PAGE_SHIFT;
>>>
>>> -     for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>>> -             int err;
>>> -
>>> -             err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>> -                                     page_to_phys(pages[i]), prot,
>>> -                                     page_shift);
>>> -             if (err)
>>> -                     return err;
>>> -
>>> -             addr += 1UL << page_shift;
>>> -     }
>>> -
>>> -     return 0;
>>> +     return vmap_pages_range_noflush_walk(addr, end, prot, pages,
>>> +                     min(page_shift, PMD_SHIFT));
>>
>>
>> We can easily extend to PUD huge mappings right? Not sure whether we
>> should keep everything symmetric to how vmap_range_noflush() operates
>> right now, since P4D mappings don't exist, but PUD looks worthwhile.
>>
> 
> PUD mapping requires 1GB of contiguous physical memory, but the buddy
> allocator's MAX_PAGE_ORDER is 10 (4MB on 4K pages). So page_shift
> passed to vmap_pages_range_noflush_walk() never exceeds PMD_SHIFT.

Ah okay. It is really confusing to see PUD helpers everywhere when
they are basically dead code ...

> 
> Thanks,
> Wen
>>>  }
>>>
>>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>


