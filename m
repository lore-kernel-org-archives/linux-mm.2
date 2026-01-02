Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CB7FA372F
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 12:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260756B0088; Fri,  2 Jan 2026 07:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E81F6B0089; Fri,  2 Jan 2026 07:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1C06B008A; Fri,  2 Jan 2026 07:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2CAC6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:12:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EC9FBDF4C
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 12:12:13 +0000 (UTC)
X-FDA: 84286910946.01.F0167C9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8563920002
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 12:12:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767355932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lczeKFA1ojXuz98gJwf0pgHJcOtJg8IgdWAAGiyU6eA=;
	b=vOstk+E85yM0lobFaO+rrIP0YsVVpTvZ1RRBUw7G25sD7FZ+A2DpAV2CbKTssu4PSacHCf
	Mbuzl7oh6jFpMfRJ4+A0j1MNOOYRqkKDKpzAAazpDT5wOtzwEt4Hopd6CQchP1DBEzJDsE
	2p4pM0Xr/JKCCHGJib4xlBfbkxZHFNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767355932; a=rsa-sha256;
	cv=none;
	b=lcxrJvlp7sePJACdCQtwDIULILTgJXM0FsUhe/Dwc5BJZWfwThDshyQdVj+ZwPchB0cuQh
	W9ReRo5aEVJukFrd5otkpRuVSzIehGdfufQhdLCPdN64GHz13f8dUFSUr89P01pFIHj7kl
	AzmBtOeu03U/GV+dBsGzVK8/YAg/4BI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EC6E497;
	Fri,  2 Jan 2026 04:12:03 -0800 (PST)
Received: from [10.57.94.221] (unknown [10.57.94.221])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3072E3F63F;
	Fri,  2 Jan 2026 04:12:07 -0800 (PST)
Message-ID: <85094ce2-21a8-4d25-bd96-7d809c5daa3b@arm.com>
Date: Fri, 2 Jan 2026 12:12:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] arm64: mm: support batch clearing of the young
 flag for large folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
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
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <02239ca7-9701-4bfa-af0f-dcf0d05a3e89@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oaxx4m4aa4nhgxixff8fdf1fndbuj3ma
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8563920002
X-Rspam-User: 
X-HE-Tag: 1767355931-971432
X-HE-Meta: U2FsdGVkX18yOzUvSQ24qcCdnQ6sEDHkQA86nci1pOxL+x2CwyZ7yiiJoN3TVsOpcEZ0y2OEc/tynPQ3YO6YvTturDkRP5fo77IyXtyLPk2vl7paIxK+HSE1vmDzA0Ii+Lsxq1EE8sXvKz6SjtfHtC/4BXmXvxTibDugVeFQoH4LK6msMBKwU8ZlRpFuA5RxP/dhjpQ0awqBBfwa1C/CkhUv5ZxuWN8tZj7PVXNghO7MdPZmNazAvzbUdAJVHcOrgOjXOCT9bV/JBJBCzeZpNDOP/e08BGn2Il3J0FXYZwDO4hvalPJPN23QiI4GDi7xxXUxyR4t28I7EyFk6VRFnJxRB5awZ4XW+8iR+I0xMCZY5+Mi6ofwuB2WlKIyTvpbXeroQJg1CnfAsu45RbiBr6XhwifyL9Gseq9xEGyXRbLU+FIjdkMBObpMfX6feC/oyNBGCuXhNqJlt+LW65CYE00d3m+51hW/OnXax08qiHYg1NU5wkFkM4JAelwZAikr89Qp/nmaFazTeO7ucfy4hfLebS0MxQP5CuLWvUpeyJTubyaCTVTlcbZoR8TwYQVphBlcP2tp1riqOeR6r1lSuEfRDgvWaB8cOL8eQtca5AV1cPnLyNiFNzZsm0FFU7xNVBdk+RbH28AYilQeyA6h5iViumvoWVRzNncG0BNoUkwwRCh8Hc5N7POY6aZhMOTQjkF38ghNYIaUQ/ODrAGcRS1dyAOTPnL/jVEHPlVYDTEdM3W/Q+sso4yWyBvgT1jLNkDciQnJmwe1I0qmpUr/Y2cL+MhULgwpC9WfEHCYDM/dS3ychKdj5QAlxY31RlzQ5mVYzObfYrZEykF1jTkc4p/sCcKBuL8/ZT2FYKtMwl3MvBJoWP0kQZSPPgc07KyAwvGQ3calleILE7h89EBw9iwXoY2DeEWWpm/OS1UFbl6HOVFj4Zn+7yksGTfeqQ1qMn8lcyAKpX2TxHu4ywp
 TCvzGwOZ
 o2mEFnV6H+DtPbxAIZ5H2vArmR8/r7dZn2GUTtseJo9styuBGfRdJZMIzzyabIBoYUwEsnUQnAdZ2jPxJUwd4+rcgfRQbhZqinbycJoqFDUrcbaXa8y3I1Un7Qty80PmQ5d93F4SPo6CLPd4TpyLG1SxYjDAZZjvkaDMDWzqrQS7t7SsTz88qstriH+H+W+AOnY9m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/12/2025 02:48, Baolin Wang wrote:
> 
> 
> On 2025/12/24 22:07, Ryan Roberts wrote:
>> On 23/12/2025 05:48, Baolin Wang wrote:
>>> Currently, contpte_ptep_test_and_clear_young() and
>>> contpte_ptep_clear_flush_young()
>>> only clear the young flag and flush TLBs for PTEs within the contiguous range.
>>> To support batch PTE operations for other sized large folios in the following
>>> patches, adding a new parameter to specify the number of PTEs that map
>>> consecutive
>>> pages of the same large folio in a single VMA and a single page table.
>>>
>>> While we are at it, rename the functions to maintain consistency with other
>>> contpte_*() functions.
>>>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   arch/arm64/include/asm/pgtable.h | 12 ++++++------
>>>   arch/arm64/mm/contpte.c          | 33 ++++++++++++++++++--------------
>>>   2 files changed, 25 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index 445e18e92221..d5fbe72e820a 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -1648,10 +1648,10 @@ extern void contpte_clear_full_ptes(struct mm_struct
>>> *mm, unsigned long addr,
>>>   extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>>                   unsigned long addr, pte_t *ptep,
>>>                   unsigned int nr, int full);
>>> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>> -                unsigned long addr, pte_t *ptep);
>>> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>>> -                unsigned long addr, pte_t *ptep);
>>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>>> +                unsigned long addr, pte_t *ptep, unsigned int nr);
>>> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>>> +                unsigned long addr, pte_t *ptep, unsigned int nr);
>>>   extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>>                   pte_t *ptep, unsigned int nr);
>>>   extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>> @@ -1823,7 +1823,7 @@ static inline int ptep_test_and_clear_young(struct
>>> vm_area_struct *vma,
>>>       if (likely(!pte_valid_cont(orig_pte)))
>>>           return __ptep_test_and_clear_young(vma, addr, ptep);
>>>   -    return contpte_ptep_test_and_clear_young(vma, addr, ptep);
>>> +    return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
>>
>> As per your fixup patch, I agree that nr should be 1 here, not CONT_PTES.
> 
> Yes.
> 
>>>   }
>>>     #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>>> @@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young(struct
>>> vm_area_struct *vma,
>>>       if (likely(!pte_valid_cont(orig_pte)))
>>>           return __ptep_clear_flush_young(vma, addr, ptep);
>>>   -    return contpte_ptep_clear_flush_young(vma, addr, ptep);
>>> +    return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>
>> And same here.
>>
>>>   }
>>>     #define wrprotect_ptes wrprotect_ptes
>>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>>> index e4ddeb46f25d..b929a455103f 100644
>>> --- a/arch/arm64/mm/contpte.c
>>> +++ b/arch/arm64/mm/contpte.c
>>> @@ -508,8 +508,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
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
>>> @@ -518,41 +519,45 @@ int contpte_ptep_test_and_clear_young(struct
>>> vm_area_struct *vma,
>>>        * contig range when the range is covered by a single folio, we can get
>>>        * away with clearing young for the whole contig range here, so we avoid
>>>        * having to unfold.
>>> +     *
>>> +     * The 'nr' means consecutive (present) PTEs that map consecutive pages
>>> +     * of the same large folio in a single VMA and a single page table.
>>>        */
>>>   +    unsigned long end = addr + nr * PAGE_SIZE;
>>>       int young = 0;
>>> -    int i;
>>>   -    ptep = contpte_align_down(ptep);
>>> -    addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>> -
>>> -    for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>>> +    ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
>>> +    for (; addr != end; ptep++, addr += PAGE_SIZE)
>>>           young |= __ptep_test_and_clear_young(vma, addr, ptep);
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
>>> +        unsigned long end = addr + nr * PAGE_SIZE;
>>> +
>>> +        contpte_align_addr_ptep(&addr, &end, ptep, nr);
>>>           /*
>>>            * See comment in __ptep_clear_flush_young(); same rationale for
>>>            * eliding the trailing DSB applies here.
>>>            */
>>> -        addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>> -        __flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
>>> +        __flush_tlb_range_nosync(vma->vm_mm, addr, end,
>>>                        PAGE_SIZE, true, 3);
>>
>> Hmm... The requirement is that we must flush the _page_ if clearing access for a
>> pte that does not have the contiguous bit set, or we must flush the _contpte
>> block_ if clearing access for a pte that does have the contiguous bit set.
>>
>> With your changes, you may call for a large range that covers multiple contpte
>> blocks but only has a single pte in a single contpte block for which the access
>> bit was previously set. But that will cause flushing the TLB for the full range.
>> Could this cause a performance issue? Yes, no, maybe... I think it's unlikely
>> but I wouldn't rule it out in some edge case.
>>
>> I wonder if it's better to track the sub-ranges where access was cleared and
>> only issue tlbi for those sub-ranges? Probably just keep it simple (the way you
>> have done it) until/unless we see an actual problem?
> 
> Good question. Indeed, as you said, we flush the TLB per folio now, which might
> increase the flush range. However, I think this approach is relatively
> reasonable for now.
> 
> First, the mm-core also tracks the access status per folio, and it's really
> unnecessary to add excessive complexity to track the access status of sub-pages
> (or sub-ranges). I can already imagine that tracking the access status for each
> cont-block range as well as for non-cont pages across the entire large folio
> range, which can be too complicated.
> 
> Second, __flush_tlb_range_nosync() is a lightweight flush. I quickly ran a
> measurement on my machine and found that the overhead of
> __flush_tlb_range_nosync() barely changes between nr=16 and nr=256 (both are
> around 40 ns).

I'm not concerned about the direct cost of the flush; I agree it should be
lightweight given we elide the trailing DSB. (although there is a possible case
on older HW that doesn't support TLBI-by-range where this will be converted to
multiple TLBI-by-page instructions and that can cause stalls if there are too
many of them).

My concern was the opportunity cost of evicting the entries for all the
non-accessed parts of the folio from the TLB. But of course, I'm talking
nonsense because the architecture does not allow caching non-accessed entries in
the TLB.

So doesn't sound like a problem; I think we can ignore this. Sorry for the noise.

> 
> Therefore, I would still prefer to keep the logic here simple.

Agreed.

Thanks,
Ryan


