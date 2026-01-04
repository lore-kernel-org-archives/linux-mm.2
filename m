Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD120C2A061
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 01:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E862D6B0092; Sat,  3 Jan 2026 20:55:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33F36B0093; Sat,  3 Jan 2026 20:55:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3FDE6B0095; Sat,  3 Jan 2026 20:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C11BE6B0092
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 20:55:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E34E5E40B
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 01:55:32 +0000 (UTC)
X-FDA: 84292614504.21.6E5DDE8
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1FEB04000F
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 01:55:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KjBaJTsv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767491730; a=rsa-sha256;
	cv=none;
	b=IK0f9Q84APL2WwdmtVU320znomyDwS6g6rzC4i7c9nIy1mTytY2ASga2beYiaCn/QY0jMl
	IHNf0pCKQARFNCPkD2x7CcxiGwUmOEKPk4jJkzRwsvHQWZ4RuZ7WqBeZ96khmuau5Mgzcv
	dWfF053E3SzU/pU0OpM+nJO+Obblo6U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KjBaJTsv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767491730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIpYAVwIb6CxAYeydnlfw07j25D/J9qOjlgY2htp9h8=;
	b=1GV7eUW47caarYsCmqtOuSoQ3qgls1ZBanlCFMbzJYMRKz64sOo3bpfStxpD/tiMWCScli
	ILOjILBjLIhRMi+Sw+f/kfPHWJqkhp06xFZBVBGbuZxfS03VBbOxo2e0n0lBboGw89itcj
	DP2Kvo8qRQDuz7lcix99OeB7hUKSqv8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767491726; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZIpYAVwIb6CxAYeydnlfw07j25D/J9qOjlgY2htp9h8=;
	b=KjBaJTsvTD8ShMcRMB2iRBvKauQSZG8Xcqpy7pFZV7IJeFnyyrGPinxxmD+3IuU9lcgzr/VQFmHGMjf58HbXpCWJfCLXiEnmvGLhs4qKRkvVJGzAfrrKownU1HmWKgi2/fKG3v4SqXBwcZfVR0MaYI9975dMBzwCO/2YSCFKrdQ=
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WwA2gEm_1767491724 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 04 Jan 2026 09:55:24 +0800
Message-ID: <e94f80ff-cde9-42b0-b717-419fae3e7385@linux.alibaba.com>
Date: Sun, 4 Jan 2026 09:55:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] arm64: mm: support batch clearing of the young
 flag for large folios
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
 <3b427d9010a6d52f2b91342760f12be097d21cf6.1766455378.git.baolin.wang@linux.alibaba.com>
 <c5df1f9f-952a-4e83-9ae0-bd0a83dedd36@arm.com>
 <02239ca7-9701-4bfa-af0f-dcf0d05a3e89@linux.alibaba.com>
 <85094ce2-21a8-4d25-bd96-7d809c5daa3b@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <85094ce2-21a8-4d25-bd96-7d809c5daa3b@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1FEB04000F
X-Stat-Signature: zwedtzcubfsxhje34uwcke1zu9x4ybr7
X-HE-Tag: 1767491728-40284
X-HE-Meta: U2FsdGVkX1/NkHlHFf7MwjjNf/nGHT/oWlnOvr+wgwWjj7Ruftw0D2UYGmQDfD4SexQ0MOlLguvu0w29/pNc3mai+xTbJdH5Rm8+m2gbfN3sYAnI+qs68XVWvgV1IaZ4pE36lFLhSCxKYcpo6mzanhjhK6zokgnwq3G2iAi6Q5naMgyob39Sz2uN/K4+xK0XQaslGdASSLuwlNpC9pGTEuf/Fl9EMKungURfFX0U2DYGUz+n/YFmKcJcsnKtfRvWMryFNLPSRB9VVMGoID+v5GPz3VKeeihYXgapefx7UkI4fGVQenthjlVssg2MVNElZRhSuFfLYx61r41i6Z/nQpXE1kmswS5u/9NHW8xnFqP6A35HK6axbQDBakHjefKGb9Ye782GLfYo7utwlaP48gnj86YtgI9gvKWqLdV9RT7/f4aLOKKIwsu0hvm5CS+Q8SQ5KvwMIUOi9vJrk5oyKn8hl8XUrTcHOmELo3HJBHg61pG0vbplAVWZizPxR6lsArxoDe91bTZMFRCo8Q1l4Lk9bbhQyX4OEPkqo7R43+LUr4VmjyUilW6bciWTOZ7jYydOBK5Pq8G0qt5jFOq3Ww2FJJRPe0KKVFXFouZ6f1Dwti9FKX0V6dPlVTYeOb6H9TeiQIUfdWJ6P++uSM+O1FYUxRmVp1/4xfW+Rl8R7ct0z9c25Yr0XKD7PE8TdAIuSu+rhuGSXyKMmvQtvLcMBIgyCQja+0SNYkTuv9OwTiOiDfY01SDLrztDn/9jRTXRmCTTtspCfJ3ygvaRwzOa2lrliAKIJKy0PE3w2tJtkBiisu6sI81FZj0L/l38hR3xsqycGAOACSwnAFMNu9OuV5kDG+IZ2XJdbSxujl1W1n2yiPjyFy5J78CUQB+zGnrY3ofpKtmTEEiwISNVbz5JFiMN+6SKK1m4FHkVJauSIj0To0h2N/I8EgdtyvzOw7H4uJ3OTxVjlNrc/cx06FS
 0RhSROQO
 1B9KEqpF5e8OwDHjcD01eGFjOwIkQhaKrxU8cOY+IMyygr4GkbatLlasG42gBTZcjwflmjNruuD5/Gmp3s4cGbmSF44YGvgswhm2tkqGnrPZwaJ7RNe7OKFB8iohEVsVDjP/kxecF+7ZSwvwov0oYTpysTlABTrzeQsYscfQ/rB3Bz26srUrEhdv1U2CkAUXYUq9qRZGFkwWrO1l8WJ8sUwep7IHaUaLpWlhDfxfPGkNPlkjKVBgiSKI7GGDTJ5DBooSmBzz+7K7fvE1Opi1eyut+Y1Cy3vjpzjfeOpbRDVKzbsL1RNqC6xlttivxFIlGVhoo4b6iah6Ecmk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/2/26 8:12 PM, Ryan Roberts wrote:
> On 25/12/2025 02:48, Baolin Wang wrote:
>>
>>
>> On 2025/12/24 22:07, Ryan Roberts wrote:
>>> On 23/12/2025 05:48, Baolin Wang wrote:
>>>> Currently, contpte_ptep_test_and_clear_young() and
>>>> contpte_ptep_clear_flush_young()
>>>> only clear the young flag and flush TLBs for PTEs within the contiguous range.
>>>> To support batch PTE operations for other sized large folios in the following
>>>> patches, adding a new parameter to specify the number of PTEs that map
>>>> consecutive
>>>> pages of the same large folio in a single VMA and a single page table.
>>>>
>>>> While we are at it, rename the functions to maintain consistency with other
>>>> contpte_*() functions.
>>>>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>    arch/arm64/include/asm/pgtable.h | 12 ++++++------
>>>>    arch/arm64/mm/contpte.c          | 33 ++++++++++++++++++--------------
>>>>    2 files changed, 25 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>>> index 445e18e92221..d5fbe72e820a 100644
>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>> @@ -1648,10 +1648,10 @@ extern void contpte_clear_full_ptes(struct mm_struct
>>>> *mm, unsigned long addr,
>>>>    extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>>                    unsigned long addr, pte_t *ptep,
>>>>                    unsigned int nr, int full);
>>>> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>>> -                unsigned long addr, pte_t *ptep);
>>>> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>>>> -                unsigned long addr, pte_t *ptep);
>>>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>>> +                unsigned long addr, pte_t *ptep, unsigned int nr);
>>>> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>>> +                unsigned long addr, pte_t *ptep, unsigned int nr);
>>>>    extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>>>                    pte_t *ptep, unsigned int nr);
>>>>    extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>>> @@ -1823,7 +1823,7 @@ static inline int ptep_test_and_clear_young(struct
>>>> vm_area_struct *vma,
>>>>        if (likely(!pte_valid_cont(orig_pte)))
>>>>            return __ptep_test_and_clear_young(vma, addr, ptep);
>>>>    -    return contpte_ptep_test_and_clear_young(vma, addr, ptep);
>>>> +    return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>>>
>>> As per your fixup patch, I agree that nr should be 1 here, not CONT_PTES.
>>
>> Yes.
>>
>>>>    }
>>>>      #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>>>> @@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young(struct
>>>> vm_area_struct *vma,
>>>>        if (likely(!pte_valid_cont(orig_pte)))
>>>>            return __ptep_clear_flush_young(vma, addr, ptep);
>>>>    -    return contpte_ptep_clear_flush_young(vma, addr, ptep);
>>>> +    return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>>
>>> And same here.
>>>
>>>>    }
>>>>      #define wrprotect_ptes wrprotect_ptes
>>>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>>>> index e4ddeb46f25d..b929a455103f 100644
>>>> --- a/arch/arm64/mm/contpte.c
>>>> +++ b/arch/arm64/mm/contpte.c
>>>> @@ -508,8 +508,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
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
>>>> @@ -518,41 +519,45 @@ int contpte_ptep_test_and_clear_young(struct
>>>> vm_area_struct *vma,
>>>>         * contig range when the range is covered by a single folio, we can get
>>>>         * away with clearing young for the whole contig range here, so we avoid
>>>>         * having to unfold.
>>>> +     *
>>>> +     * The 'nr' means consecutive (present) PTEs that map consecutive pages
>>>> +     * of the same large folio in a single VMA and a single page table.
>>>>         */
>>>>    +    unsigned long end = addr + nr * PAGE_SIZE;
>>>>        int young = 0;
>>>> -    int i;
>>>>    -    ptep = contpte_align_down(ptep);
>>>> -    addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>>> -
>>>> -    for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>>>> +    ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
>>>> +    for (; addr != end; ptep++, addr += PAGE_SIZE)
>>>>            young |= __ptep_test_and_clear_young(vma, addr, ptep);
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
>>>> +        unsigned long end = addr + nr * PAGE_SIZE;
>>>> +
>>>> +        contpte_align_addr_ptep(&addr, &end, ptep, nr);
>>>>            /*
>>>>             * See comment in __ptep_clear_flush_young(); same rationale for
>>>>             * eliding the trailing DSB applies here.
>>>>             */
>>>> -        addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>>> -        __flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
>>>> +        __flush_tlb_range_nosync(vma->vm_mm, addr, end,
>>>>                         PAGE_SIZE, true, 3);
>>>
>>> Hmm... The requirement is that we must flush the _page_ if clearing access for a
>>> pte that does not have the contiguous bit set, or we must flush the _contpte
>>> block_ if clearing access for a pte that does have the contiguous bit set.
>>>
>>> With your changes, you may call for a large range that covers multiple contpte
>>> blocks but only has a single pte in a single contpte block for which the access
>>> bit was previously set. But that will cause flushing the TLB for the full range.
>>> Could this cause a performance issue? Yes, no, maybe... I think it's unlikely
>>> but I wouldn't rule it out in some edge case.
>>>
>>> I wonder if it's better to track the sub-ranges where access was cleared and
>>> only issue tlbi for those sub-ranges? Probably just keep it simple (the way you
>>> have done it) until/unless we see an actual problem?
>>
>> Good question. Indeed, as you said, we flush the TLB per folio now, which might
>> increase the flush range. However, I think this approach is relatively
>> reasonable for now.
>>
>> First, the mm-core also tracks the access status per folio, and it's really
>> unnecessary to add excessive complexity to track the access status of sub-pages
>> (or sub-ranges). I can already imagine that tracking the access status for each
>> cont-block range as well as for non-cont pages across the entire large folio
>> range, which can be too complicated.
>>
>> Second, __flush_tlb_range_nosync() is a lightweight flush. I quickly ran a
>> measurement on my machine and found that the overhead of
>> __flush_tlb_range_nosync() barely changes between nr=16 and nr=256 (both are
>> around 40 ns).
> 
> I'm not concerned about the direct cost of the flush; I agree it should be
> lightweight given we elide the trailing DSB. (although there is a possible case
> on older HW that doesn't support TLBI-by-range where this will be converted to
> multiple TLBI-by-page instructions and that can cause stalls if there are too
> many of them).
> 
> My concern was the opportunity cost of evicting the entries for all the
> non-accessed parts of the folio from the TLB. But of course, I'm talking
> nonsense because the architecture does not allow caching non-accessed entries in
> the TLB.

Ah, now I understand your concern:). Yes, agree.

> So doesn't sound like a problem; I think we can ignore this. Sorry for the noise.

OK. No worries.

>> Therefore, I would still prefer to keep the logic here simple.
> 
> Agreed.

Thanks for your reviewing and valuable input.

