Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 683D9D6ACF1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36266B0088; Thu, 18 Dec 2025 07:20:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7026B0089; Thu, 18 Dec 2025 07:20:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C374F6B008A; Thu, 18 Dec 2025 07:20:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B316C6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:20:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 706B313C37D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:20:20 +0000 (UTC)
X-FDA: 84232499400.18.D72F11C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7DD5E100003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:20:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766060418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gCsoRPXq8HBtgip3JToLrUCxpLycBpcDqFKAnkAsok=;
	b=IJrWDA9EEjPVFWPOBrp9KTSAzt7/Ra4hKOB7cSsn/RS5qxksbMSSa67910pwMOezkOqT71
	8OGPwvm75IVtJvo/UeWgdzXpg2WHI0pDbXZ8L1+15xYJ2vhTPrG5+zNl6H04kefGk6Z8Ik
	WCrZ5Vle8Pew4QYzeT884NIOdkcHIYU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766060418; a=rsa-sha256;
	cv=none;
	b=OCnmtawiplgydlA5/DPKypeuRH8uwNYgOLRK5xu9MNqTDQwwPjBV5wBye1s/OlJFn5zS3s
	kDwapgWOIIJrwDQ1jrbFb6UKZDf+cEi4I5nBc0b1duiQn3dgxbb146IOQC7xF5WfmAggOv
	+cF/lZWASrN4FK5OpAIWQhrzLU5ZdOw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F75EFEC;
	Thu, 18 Dec 2025 04:20:10 -0800 (PST)
Received: from [10.1.39.180] (unknown [10.1.39.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 929F73F762;
	Thu, 18 Dec 2025 04:20:14 -0800 (PST)
Message-ID: <d3b40df8-e5cf-42aa-8205-de624024fad1@arm.com>
Date: Thu, 18 Dec 2025 12:20:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
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
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <96c0adcc-abfd-4a44-be93-1c6bd7942d6d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: q78xhqo1s6ia4773mjrrk8pqxqkwxmez
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DD5E100003
X-HE-Tag: 1766060418-192053
X-HE-Meta: U2FsdGVkX1/oR8qsYCmic9uBkSStHMSC+s0o1ZcxnP3ZoazyAwFXF+Aq1kwyrpSjpyYWkbnQYpQ8g7P9q4d/x0DRgnb2i7t9X+oBn1Kn3w6GDHsMvuAWwFSQSNFsoMEgi8WUcdrDARUK/Dkq9wGrkocJEaHtHwLkdnQJouj4ZwyLn+oyEObQRoflIAvno/VIpFqKfUdg8g03iyxsPTeTk/Uv8y4MgVPTEmELNw1XSd7ISSmrLir1hXJnvj6T9VXbBI5qxZZ4Fu7LpXwAMH0rdUkT4Yq3/oYB1OdoamQKghRkNOIbKG4Hs7qAGS4jq4NryaeDu6GSMPgTlaI+t0vH6GSVJ5a3LrLzwp4eTpN+dZ/zYFcQtY4TAGBMPA9ftqc2cbIAoN+LLmz71rrIuVRHMC00zddIkkZBRgVFLC4Swc4UVal0XyM5AJz1Cdssm5yj5mDENtrgTPnVW1Ue4Y2Ks//iWiC6HAgsY6dNR92m+WlPENAJp5eTK9V0PP78kw1g+UGY83Ojz2VvajBA7cXAbBdQFE8+i+O+CeiPp+ipF2Q9iLB73fuOqs4zsDxa6l2AX7P4d029ew24ZO/SX0ksUgGGZHnNOr1dJRJNgSFuk5vN4+tpfv3t9mjUJNsUDUyNjo9L9aUM6ML4x94xYRCkEeKf/85DodhhdgK/xbztfRDfpElkgzYGnyA5lOyMj54uArRruKAfL3JqicsmLv+Khv9O86tTIYrYhBHtG2WH2gaBqieM12dxyNM1e/+q5O2FIqIztm9wnbrKNrr+JB6hq10PhnDGB6sCSH4p64Jx4EfXhxt4IuERTdJbNsOS0EbX5aqn8xAW6jmN/m1S4pVJp9EEWNp+4TPM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/12/2025 07:15, Baolin Wang wrote:
> 
> 
> On 2025/12/17 23:43, Ryan Roberts wrote:
>> Sorry I'm a bit late to the party...
> 
> Never mind. It's not late and comments are always welcome :)
> 
>> On 11/12/2025 08:16, Baolin Wang wrote:
>>> Currently, contpte_ptep_test_and_clear_young() and
>>> contpte_ptep_clear_flush_young()
>>> only clear the young flag and flush TLBs for PTEs within the contiguous range.
>>> To support batch PTE operations for other sized large folios in the following
>>> patches, adding a new parameter to specify the number of PTEs.
>>>
>>> While we are at it, rename the functions to maintain consistency with other
>>> contpte_*() functions.
>>>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   arch/arm64/include/asm/pgtable.h | 12 ++++-----
>>>   arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
>>>   2 files changed, 37 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index 0944e296dd4a..e03034683156 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct
>>> *mm, unsigned long addr,
>>>   extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>                   unsigned long addr, pte_t *ptep,
>>>                   unsigned int nr, int full);
>>> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>> -                unsigned long addr, pte_t *ptep);
>>> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>>> -                unsigned long addr, pte_t *ptep);
>>> +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>> +                unsigned long addr, pte_t *ptep, unsigned int nr);
>>> +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>> +                unsigned long addr, pte_t *ptep, unsigned int nr);
>>
>> The "contpte_" functions are intended to be private to the arm64 arch and should
>> be exposed via the generic APIs. But I don't see any generic batched API for
>> this, so you're only actually able to pass CONT_PTES as nr. Perhaps you're
>> planning to define "test_and_clear_young_ptes()" and "clear_flush_young_ptes()"
>> in later patches?
> 
> Right. This is a preparation patch, and will be used in patch 2.
> 
>>>   extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>>                   pte_t *ptep, unsigned int nr);
>>>   extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>> @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct
>>> vm_area_struct *vma,
>>>       if (likely(!pte_valid_cont(orig_pte)))
>>>           return __ptep_test_and_clear_young(vma, addr, ptep);
>>>   -    return contpte_ptep_test_and_clear_young(vma, addr, ptep);
>>> +    return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>>>   }
>>>     #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>>> @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct
>>> vm_area_struct *vma,
>>>       if (likely(!pte_valid_cont(orig_pte)))
>>>           return __ptep_clear_flush_young(vma, addr, ptep);
>>>   -    return contpte_ptep_clear_flush_young(vma, addr, ptep);
>>> +    return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>>   }
>>>     #define wrprotect_ptes wrprotect_ptes
>>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>>> index c0557945939c..19b122441be3 100644
>>> --- a/arch/arm64/mm/contpte.c
>>> +++ b/arch/arm64/mm/contpte.c
>>> @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>   }
>>>   EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>>>   -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>> -                    unsigned long addr, pte_t *ptep)
>>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>> +                    unsigned long addr, pte_t *ptep,
>>> +                    unsigned int nr)
>>>   {
>>>       /*
>>>        * ptep_clear_flush_young() technically requires us to clear the access
>>> @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct
>>> vm_area_struct *vma,
>>>        * having to unfold.
>>>        */
>>>   +    unsigned long start = addr;
>>
>> Personally I wouldn't bother defining start - just reuse addr. You're
>> incrementing start in the below loop, so it's more appropriate to call it addr
>> anyway.
> 
> OK.
> 
>>> +    unsigned long end = start + nr * PAGE_SIZE;
>>>       int young = 0;
>>>       int i;
>>>   -    ptep = contpte_align_down(ptep);
>>> -    addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>> +    if (pte_cont(__ptep_get(ptep + nr - 1)))
>>> +        end = ALIGN(end, CONT_PTE_SIZE);
>>>   -    for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>>> -        young |= __ptep_test_and_clear_young(vma, addr, ptep);
>>> +    if (pte_cont(__ptep_get(ptep))) {
>>> +        start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>>> +        ptep = contpte_align_down(ptep);
>>> +    }
>>> +
>>> +    nr = (end - start) / PAGE_SIZE;
>>> +    for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
>>
>> Given you're now defining end, perhaps we don't need nr?
>>
>>     for (; addr != end; ptep++, addr += PAGE_SIZE)
>>         young |= __ptep_test_and_clear_young(vma, addr, ptep);
> 
> Yes, good point.
> 
>>> +        young |= __ptep_test_and_clear_young(vma, start, ptep);
>>>         return young;
>>>   }
>>> -EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
>>> +EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
>>>   -int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>>> -                    unsigned long addr, pte_t *ptep)
>>> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>> +                unsigned long addr, pte_t *ptep,
>>> +                unsigned int nr)
>>>   {
>>>       int young;
>>>   -    young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
>>> +    young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
>>>         if (young) {
>>> +        unsigned long start = addr;
>>> +        unsigned long end = start + nr * PAGE_SIZE;
>>> +
>>> +        if (pte_cont(__ptep_get(ptep + nr - 1)))
>>> +            end = ALIGN(end, CONT_PTE_SIZE);
>>> +
>>> +        if (pte_cont(__ptep_get(ptep)))
>>> +            start = ALIGN_DOWN(start, CONT_PTE_SIZE);
>>> +
>>
>> We now have this pattern of expanding contpte blocks up and down in 3 places.
>> Perhaps create a helper?
> 
> Sounds reasonable. How about the following helper?
> 
> static pte_t *contpte_align_addr_ptep(unsigned long *start, unsigned long *end,
>                                         pte_t *ptep, unsigned int nr)
> {
>         unsigned long end_addr = *start + nr * PAGE_SIZE;
> 
>         if (pte_cont(__ptep_get(ptep + nr - 1)))

I think this is safe but calling it out to check; you're not checking that the
pte is valid, so theoretically you could have a swap-entry here with whatever
overlays the contiguous bit set. So then you would incorrectly extend.

But I think it is safe because the expectation is that core-mm has already
checked that the whole range is present?

>                 *end = ALIGN(end_addr, CONT_PTE_SIZE);
> 
>         if (pte_cont(__ptep_get(ptep))) {
>                 *start = ALIGN_DOWN(*start, CONT_PTE_SIZE);
>                 ptep = contpte_align_down(ptep);
>         }
> 
>         return ptep;
> }

Looks good.


