Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3787CCD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 06:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6582F6B0088; Fri,  5 Jun 2026 02:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608716B008A; Fri,  5 Jun 2026 02:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7756B008C; Fri,  5 Jun 2026 02:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5956B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 02:02:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3A00A0365
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:02:49 +0000 (UTC)
X-FDA: 84844815258.03.6F6BBE8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id B8CE614000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:02:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WQvDMaFU;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780639368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oamaMfzM9b8JvJK765Em42sr9TcA79ICVEv58eHRJqw=;
	b=MhLK25Qw2Sh/ZHhuYk9LnMZOmtEwlo0FO8ECagplm3DPnKOKSb/h9BEU9WXfdujLYcM5ao
	YKUPjfp2YSCo5qp2r9C/O/GZ97965JnZpUo94h6MMsCEA0vv02pzFBfdlYX76knoAxYv7n
	tdx57Z606skSXK8gSO0pExUZf0aGWvE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WQvDMaFU;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780639368;
	b=Ju5tZnsHOGCHKbufPdiFHQ8k2QKkYTOej01+1wX5ryVSO3Wajj3Cuyuc380wTuUFH8PejY
	TAgLsmDIpJEk1HApjmRF8gKxGmOOXr2QRidSTlZNpCC4ODYbtbKG58NSbIKiGgbBk69HJv
	qKC2lpL5MvQMNNc28L5H3dJLO3iNpJ0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF01132AB;
	Thu,  4 Jun 2026 23:02:41 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 368793F86F;
	Thu,  4 Jun 2026 23:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780639366; bh=uh/GZdKZTzhxTkN2icyg9PhUzHZ6pL9SivtCFDI0ugM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WQvDMaFUXNSK+QfT0babDWN0PqczaocaeP11xLDjWIwm6SxkeZIALqX7/gr6y3q7k
	 MiS7e2ST/Ug55d4/EbZVFBvcHh5Js9O7gnzQwz3jQLJD3XAlukINZVZdaO7k7+onST
	 I2030DWVL9Pyf0pTwWclD2zoRkH01zfhwaAxPZLE=
Message-ID: <53a51128-8ad5-4faa-9151-1245084bdd4c@arm.com>
Date: Fri, 5 Jun 2026 11:32:37 +0530
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B8CE614000A
X-Stat-Signature: nzx9bfq134dgs8pnki77bmwghixdw97y
X-Rspam-User: 
X-HE-Tag: 1780639367-956721
X-HE-Meta: U2FsdGVkX18ZfIQu1au7hSj+NxmTjnjcRDOaGsOi/SLOSNbef4ztBVtplwLNtwdFAODeJ7Kqh0MjAwb9EppJqXrz45Qb0VAa/kxFsiATuWwQDOUjZKtSu3vNbs12jMH8ZrCmNkcrhRB2pxCBv2yFbYxD287+1OsnG1QzJK5H1MLpbRAdtNtZb/iXCHpQFX7N/V8KFHcUMkYjOU5t4Hvs1o/tix8hpP1SHRwnsm4WBWpWzxV5mFY7pVuUCJPLrxBuUjVRw9VmfainLcF/foiFIlQ/deixF/5/GEENUcWvaeomrJx5OnfIl40wUReZnv4tji1rTMxOwXWDutDuzg4Smq3hoyps2GrWID7/8ZxEovPKAadmBi+AfObQ8XS7WKEaHkHD5agXo6CAsnZLgDtbl2aGSwA4LR0yJ8OMTBIbLUng811iw8lMW3W2aPlh31lpPI7GwKkSrS52cqjwPHQzPLyg9Y7nONoTTlrAxcVQXztCKoGgQ03vjYNd2IyNxkoP6gSvepoTLg95X9VAGY77ehEentUZwh0GxhBgrW64iOCzCIMiJbseNHZA+n8sAJeOf8Bq0HOdr190vzAeiV2SY4bVndUFdRR2gZA48Au7aBrKyxgn2Cc+xmtuoGRDVefn9yRK8tWLsOrg993MFPLIxYn+s0nBd0QSempe/rQn20q0FZFIWXei91/8wcVV69PhqLAayL2vTFKZfIQNAGNd0/cQyae/+NP2wJrvytd0dd1I/uuylYaEYH/wY57hWLZBR2mGx5ix0saBkq+dB4OTVT+5uCCH54lt/f+6/1/lx2hncUo+9KOceyYcgTXyWbZ0Ofj7EqlhJQ8SUKSuUBECjg32yzobzQ9lonHT05YcBaRxlCt4iWHHvdqM06M+sCvns5HSYhpYs4co5+O/fsatTm+6ws0f+C7UdsPQ88CFTbHkymdYJfwQ1y0RtRuaEmQx6/JdzMIJmop1WbkkTp4
 vGHTKn+c
 WahHa2LheYbM1FBAJnVY5t/0eniGptHonYY0tNHLqA0VPFfavUk0ji69wB3jmlXxop9Ftmyj2w1fIIGYVDO1r3AOLswgR95p3R+LjVq2s5f5i6GCf11ZM4xLvE+VWoPDN999BVvv1/hPAJRIQ1vinNQXWvukQdMx5SHmVUJ6MjM3AWBXT9AsfdPbUqd51uJruLjnYW17Nt+xvAcbiWbCh3mDS95yH1JJ1LXn9rUxqUFn6Dmhw6nac5kEHeS0bcdqYNY3LBAZYtZMLJKjHqGQ9zQk8UNi8OF5jKKBuKz95thvXB5G1qxuU3dEcbB6DwptgrNbYdjLJm+upmnnLKx5a6RcuhGTabwg6UvNrTOQao+wdcLL7+m1ho45U9i1HuSD3mb4kxsh++ophH8Pl5QYCYDfbyN8UUy0PzgX7r/yeNGlm5VPxKEL9ukv1CrCYCyMCyG7Hy02r4ln4gQfFQaBdkRi0+qaF4Wx9gO1Qfu/s57p6vUE=
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

Can we then just drop the min()? You can guard the try_huge_pmd with
shift >= PMD_SHIFT - the walker has the necessary ingredients to work
with a shift > PMD_SHIFT, so let us not confuse by this min() truncation.

> 
> Thanks,
> Wen
>>>  }
>>>
>>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>


