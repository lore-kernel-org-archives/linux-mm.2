Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65E7D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252806B0088; Thu, 18 Dec 2025 20:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6B56B0089; Thu, 18 Dec 2025 20:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3056B008A; Thu, 18 Dec 2025 20:00:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF5876B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:00:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F307F868A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:00:41 +0000 (UTC)
X-FDA: 84234415482.25.1603683
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf11.hostedemail.com (Postfix) with ESMTP id B79EB4000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:00:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=T9n7HrpS;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766106040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVOeY+3SuOrvYNqzmFJNbA4A4ujnPrtjXb52VW//WT8=;
	b=IUQbHcC371PkSYw9cHz0DiikLqplAujyXIT243pKv8NLrLb3DtjkJr5X1H3hYQcUoe1KCL
	SSK2AMo5Rt3yURi3v7V1y0mWRX/ILjqdwqoDDJ//h8fS9aROrK3wdfdGgV4swFtHN07FXw
	bULFHmgHGduVJXOLdCqnktxLPpt7hwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766106040; a=rsa-sha256;
	cv=none;
	b=dVZe5+ZgaWyiMGcsU8ESF3Rz/bkp3eixk7nMUEJ7jz/n9hGcAO+ZFLY6J9f8X68n2VHwLo
	cDcid4TXtCNzx9HqvbNkZIlt3MonHKeF7gtLFpJyk11X+PO/qkzouNL2D4Tkjt2oLsO+iD
	TKCwnrfSnw64rdkR5Jo6bE766ttUfpU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=T9n7HrpS;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766106036; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IVOeY+3SuOrvYNqzmFJNbA4A4ujnPrtjXb52VW//WT8=;
	b=T9n7HrpShv/EXa6XSaqoE0ydytE70mLojserRFrD3M3uNFcGplrNAYecWKLl3uhgrhZjftgGg8Tncw6+VgVf4KXXfgWIhl8sxxJLbUyKVvH/8zCo1G4maMe0KmOPVIj7U9ATYKIjJ/AtQBKl7IxZMpbr7O6gJQ7clfwhXMQz4KM=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvARIF8_1766106034 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 09:00:34 +0800
Message-ID: <9c6393e1-fc88-46bf-9a3e-b28b8cda1c75@linux.alibaba.com>
Date: Fri, 19 Dec 2025 09:00:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
 <1beaa7de-4b31-4f19-abee-83872f868e28@arm.com>
 <96c0adcc-abfd-4a44-be93-1c6bd7942d6d@linux.alibaba.com>
 <d3b40df8-e5cf-42aa-8205-de624024fad1@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <d3b40df8-e5cf-42aa-8205-de624024fad1@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gmawz4emg6cyhmjf5xonf9ugwkmkscb8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B79EB4000F
X-Rspam-User: 
X-HE-Tag: 1766106039-39468
X-HE-Meta: U2FsdGVkX1/2YWcjHYLL5FuZ9E/1AuDvvftCrKDe7pbS1y0itZCoREl1o4wcDzL8gGZu44UsAQjMS/0Lqy/FesugrKuDC2qr6FFJ2j3KNXDNvkYiQGzaqByeyL/ksJ5nDz0DdCYXT2V4LRdg2aGWn4idRid64pm0TCqgOsXzmvWbvL5DRIL5w5D7ka4EmOeAQEKwf2WwcgjVNYjR8//YtkEwBXtgD/bpGiAcquXR7XDs7vicjG7ytGCRUXaJiMQsgx7l7mhe7eA6d1PfAWTe3ilK2XRp5axFJ5nfD472/KASNrgE/vFr/xjGUr8w/E+OHX2STfMTHDJrR41duGh/5AxvaYCmQAJ+elmgCtogg7xblY6VgLzIpvQzVXHPMpzcyZX6lZdARRajMkJoAqGqZWl9RmOSI3hFft7fV+a25W2MspmSVzAjn/kE3Wh4+qubhjWXKY4epxFenKMO346yXJq1/hurzZ06RFN/EHVXSPCwHF0TZ3LDXtbt5S2D3Y4Cg8fI3YW04skwtiSLtsg17O2TFdpzKXkmmx0pCPks3FXYlpxFVxlXTEFjl/g0+VDrViI8cp4VcNzRlTk/PJu6gfOBdTE+5M0q4Ly/oIGN518Fogt3uj6mUgEERNa0F/wFTVWutAOz5wCMEcN64YCM175QoX/LN/D5xeUU2Btz0k5FXi6cb9FPjEieu/bnqPx7RCXUFjTCbZV/uRo1JYZAuopJzEi0QOhzfrpBfZTHkcnSrzZktJl9scLB80v6BTkhn/LaAThwAZbp/v8TDxbNiZeIphTJrFFLT23xjPpk+ORqgMeP43zhEWuxjk74YKO8eQIEeSyUYv2WOF9xKW9I8qAGL6j0UY6/a3jlY+MjKjmLanxxgxUOuYQYtijDkdLuuRdSzIOTd31YZ3W2xW5FXo4n6RFNDEJt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 20:20, Ryan Roberts wrote:
> On 18/12/2025 07:15, Baolin Wang wrote:
>>
>>
>> On 2025/12/17 23:43, Ryan Roberts wrote:
>>> Sorry I'm a bit late to the party...
>>
>> Never mind. It's not late and comments are always welcome :)
>>
>>> On 11/12/2025 08:16, Baolin Wang wrote:
>>>> Currently, contpte_ptep_test_and_clear_young() and
>>>> contpte_ptep_clear_flush_young()
>>>> only clear the young flag and flush TLBs for PTEs within the contiguous range.
>>>> To support batch PTE operations for other sized large folios in the following
>>>> patches, adding a new parameter to specify the number of PTEs.
>>>>
>>>> While we are at it, rename the functions to maintain consistency with other
>>>> contpte_*() functions.
>>>>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>    arch/arm64/include/asm/pgtable.h | 12 ++++-----
>>>>    arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
>>>>    2 files changed, 37 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>>> index 0944e296dd4a..e03034683156 100644
>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>> @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct
>>>> *mm, unsigned long addr,
>>>>    extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>>                    unsigned long addr, pte_t *ptep,
>>>>                    unsigned int nr, int full);
>>>> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>> -                unsigned long addr, pte_t *ptep);
>>>> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>>>> -                unsigned long addr, pte_t *ptep);
>>>> +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>>> +                unsigned long addr, pte_t *ptep, unsigned int nr);
>>>> +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>>> +                unsigned long addr, pte_t *ptep, unsigned int nr);
>>>
>>> The "contpte_" functions are intended to be private to the arm64 arch and should
>>> be exposed via the generic APIs. But I don't see any generic batched API for
>>> this, so you're only actually able to pass CONT_PTES as nr. Perhaps you're
>>> planning to define "test_and_clear_young_ptes()" and "clear_flush_young_ptes()"
>>> in later patches?
>>
>> Right. This is a preparation patch, and will be used in patch 2.
>>
>>>>    extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>>>                    pte_t *ptep, unsigned int nr);
>>>>    extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>>> @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct
>>>> vm_area_struct *vma,
>>>>        if (likely(!pte_valid_cont(orig_pte)))
>>>>            return __ptep_test_and_clear_young(vma, addr, ptep);
>>>>    -    return contpte_ptep_test_and_clear_young(vma, addr, ptep);
>>>> +    return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>>>>    }
>>>>      #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>>>> @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct
>>>> vm_area_struct *vma,
>>>>        if (likely(!pte_valid_cont(orig_pte)))
>>>>            return __ptep_clear_flush_young(vma, addr, ptep);
>>>>    -    return contpte_ptep_clear_flush_young(vma, addr, ptep);
>>>> +    return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>>>    }
>>>>      #define wrprotect_ptes wrprotect_ptes
>>>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>>>> index c0557945939c..19b122441be3 100644
>>>> --- a/arch/arm64/mm/contpte.c
>>>> +++ b/arch/arm64/mm/contpte.c
>>>> @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>>>>    -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>> -                    unsigned long addr, pte_t *ptep)
>>>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>>> +                    unsigned long addr, pte_t *ptep,
>>>> +                    unsigned int nr)
>>>>    {
>>>>        /*
>>>>         * ptep_clear_flush_young() technically requires us to clear the access
>>>> @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct
>>>> vm_area_struct *vma,
>>>>         * having to unfold.
>>>>         */
>>>>    +    unsigned long start = addr;
>>>
>>> Personally I wouldn't bother defining start - just reuse addr. You're
>>> incrementing start in the below loop, so it's more appropriate to call it addr
>>> anyway.
>>
>> OK.
>>
>>>> +    unsigned long end = start + nr * PAGE_SIZE;
>>>>        int young = 0;
>>>>        int i;
>>>>    -    ptep = contpte_align_down(ptep);
>>>> -    addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>>> +    if (pte_cont(__ptep_get(ptep + nr - 1)))
>>>> +        end = ALIGN(end, CONT_PTE_SIZE);
>>>>    -    for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>>>> -        young |= __ptep_test_and_clear_young(vma, addr, ptep);
>>>> +    if (pte_cont(__ptep_get(ptep))) {
>>>> +        start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>>>> +        ptep = contpte_align_down(ptep);
>>>> +    }
>>>> +
>>>> +    nr = (end - start) / PAGE_SIZE;
>>>> +    for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
>>>
>>> Given you're now defining end, perhaps we don't need nr?
>>>
>>>      for (; addr != end; ptep++, addr += PAGE_SIZE)
>>>          young |= __ptep_test_and_clear_young(vma, addr, ptep);
>>
>> Yes, good point.
>>
>>>> +        young |= __ptep_test_and_clear_young(vma, start, ptep);
>>>>          return young;
>>>>    }
>>>> -EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
>>>> +EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
>>>>    -int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>>>> -                    unsigned long addr, pte_t *ptep)
>>>> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>>> +                unsigned long addr, pte_t *ptep,
>>>> +                unsigned int nr)
>>>>    {
>>>>        int young;
>>>>    -    young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
>>>> +    young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
>>>>          if (young) {
>>>> +        unsigned long start = addr;
>>>> +        unsigned long end = start + nr * PAGE_SIZE;
>>>> +
>>>> +        if (pte_cont(__ptep_get(ptep + nr - 1)))
>>>> +            end = ALIGN(end, CONT_PTE_SIZE);
>>>> +
>>>> +        if (pte_cont(__ptep_get(ptep)))
>>>> +            start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>>>> +
>>>
>>> We now have this pattern of expanding contpte blocks up and down in 3 places.
>>> Perhaps create a helper?
>>
>> Sounds reasonable. How about the following helper?
>>
>> static pte_t *contpte_align_addr_ptep(unsigned long *start, unsigned long *end,
>>                                          pte_t *ptep, unsigned int nr)
>> {
>>          unsigned long end_addr = *start + nr * PAGE_SIZE;
>>
>>          if (pte_cont(__ptep_get(ptep + nr - 1)))
> 
> I think this is safe but calling it out to check; you're not checking that the
> pte is valid, so theoretically you could have a swap-entry here with whatever
> overlays the contiguous bit set. So then you would incorrectly extend.
> 
> But I think it is safe because the expectation is that core-mm has already
> checked that the whole range is present?

Yes. They must be present PTEs that map consecutive pages of the same 
large folio within a single VMA and a single page table. I will add some 
comments to make this clear.

>>                  *end = ALIGN(end_addr, CONT_PTE_SIZE);
>>
>>          if (pte_cont(__ptep_get(ptep))) {
>>                  *start = ALIGN_DOWN(*start, CONT_PTE_SIZE);
>>                  ptep = contpte_align_down(ptep);
>>          }
>>
>>          return ptep;
>> }
> 
> Looks good.

Thanks for reviewing.

