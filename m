Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E787D64083
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719846B0005; Wed, 17 Dec 2025 02:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7646B0089; Wed, 17 Dec 2025 02:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59CD96B008A; Wed, 17 Dec 2025 02:23:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 457FE6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:23:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B64D113BE05
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:23:57 +0000 (UTC)
X-FDA: 84228123714.13.61BE625
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7EEB11C0006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:23:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956236; a=rsa-sha256;
	cv=none;
	b=OgmB9GrNVt5wrY9PdkYZsNAirGVCuum49rczuw2tFOuUWDHeFhyW977V8sf7q1tLqMjOU9
	9kPHK5zHm1PSbvsvQOpd2Boz8OAJUuI19WcsFi/bjGF9snoVdld749RRiMvfUugUdawo80
	SsIM4O32DPgoObMhiilZbDs0bhRzcyo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgRpvePxGoVV4YlwIyS2Oquq2eRhgUkEpMbAKegj3fo=;
	b=c3vz7IqwRaVS01/KreV1nbQY2KRf+lg2prcDL9mDlNuvCow4UdJ6GXu67xDWKQvXPwfDF6
	muq6sX0zScmjLx2MhcnCOarj+3EC+B5XqpvKiqygXPJ7887mxvblmmuS1/fIK91U5a8aid
	z7jjpsyg4pJ96Kny6tUGfNVhlEuIXfw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C4ADFEC;
	Tue, 16 Dec 2025 23:23:47 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1803C3F73F;
	Tue, 16 Dec 2025 23:23:48 -0800 (PST)
Message-ID: <b1075258-a42d-4e2f-95d7-5f8cb11f0d7d@arm.com>
Date: Wed, 17 Dec 2025 12:53:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
 <52ed7e12-b32e-4a73-ba55-eed993b930b9@arm.com>
 <753ee7bd-8c9a-4242-a216-98defcd8280f@linux.alibaba.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <753ee7bd-8c9a-4242-a216-98defcd8280f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7EEB11C0006
X-Stat-Signature: j1xsbmweco1x7d1mty3bhskisczrfrw6
X-Rspam-User: 
X-HE-Tag: 1765956235-559538
X-HE-Meta: U2FsdGVkX197difJ4YAnJnBK+VAS0HQVC8In/CptXxGakGnB690uVLfg0U3PMmogyikhX1CYDNRxWUdiObezgn4o4c4AGqF5NIqgU/DATdfE6BW7Mqf0oUvrV4dq++LrsBtfcFwhGwCdCXM1ES4EGSTD+Vj9SSdqZSCjyyYlwnCYQ4M5x8pMZXxaNoEArDgKazGfdTRPA1/Ww0y4ff29BxULt6uQlCcfTaNtheH8/kS9uOoqezviRYekMUm4nRMdn1ALVYZQ+ceFaiHQblwMRMYCFrg8Q1/8yyfFoUe81GRctxIMevu6Xv9hMvdTewrGkTbYg/ZZtaj5GLAJqiJ5k4RZSPPXMiOi3JFOX/kq7hWLzio/cG0Px1P9WnWMo6IDEFAjl5/8MwztUyWnUYkK6yeoCv441foMxJEbAmtf1Hn27gR6feK8xlDT7tI6SmP/VWb/a0K1hbrNb3tlkgTNVl9+j1axNwiY5xv3enSQCMRoAacmanG1fv44taI4v7paKqFc0tbOysi8MgOZElRygevW9BDcu2fa8hh8hdBjqlQ4KAXmNQsGehFpROOdpKTcJ//VK9+Ki6SD4lhds9L83HvDiDDT7xdGldgrsMM2FZ4/bUJRKbbjLPAJvCU2UfOryixL2fhza/oDSFMGqozd6Iol3Bvy7HDC8SRM9JskczO94/hGUHw0CwBLD0X8OPtuq38GkZB1bPhCXRAkuIyuImidZBCsdf4Ozs1RkXbHZ294qgWu21tZM6khLDMttOwGOdVig/bYHyQs5cfK2FwLwFLj2S8ssZyMRFguATUXekjVsQGn5UoZR+wNcAXhNJyY6dJIqRBXb1dt9LPLzXL4/uGEfGj1sn+UDAqkz1EqqGrh7DuekglV7yzMBfwmDF1mQ5q9iQBu9xMpFLH016KEos9hU+vysueDrvuX+IfTUSNJiMEG14awCpNNNP5SPLQrEHJqRX+k2FzjrItN4MC
 aI0aL1lZ
 8U4spe+cT6E6lQJ12rW8MfYRrtLL+LhnVmFYbQe/u+6MCN07nCBMW9XPoU4mXf52VipgymmqS7DBN9LaIYjPRa9WIYnkydD4KMg/iA4O1/VqnqKxVHBHhkeZ4z0V/7OB3LayWvc/uQBoTiwi1Eop1LKDECQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 17/12/25 12:39 pm, Baolin Wang wrote:
>
>
> On 2025/12/17 14:49, Dev Jain wrote:
>>
>> On 11/12/25 1:46 pm, Baolin Wang wrote:
>>> Currently, folio_referenced_one() always checks the young flag for each PTE
>>> sequentially, which is inefficient for large folios. This inefficiency is
>>> especially noticeable when reclaiming clean file-backed large folios, where
>>> folio_referenced() is observed as a significant performance hotspot.
>>>
>>> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
>>> an optimization to clear the young flags for PTEs within a contiguous range.
>>> However, this is not sufficient. We can extend this to perform batched
>>> operations
>>> for the entire large folio (which might exceed the contiguous range:
>>> CONT_PTE_SIZE).
>>>
>>> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
>>> of the young flags and flushing TLB entries, thereby improving performance
>>> during large folio reclamation.
>>>
>>> Performance testing:
>>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>>> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
>>> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
>>> from approximately 35% to around 5%.
>>>
>>> W/o patchset:
>>> real    0m1.518s
>>> user    0m0.000s
>>> sys    0m1.518s
>>>
>>> W/ patchset:
>>> real    0m1.018s
>>> user    0m0.000s
>>> sys    0m1.018s
>>>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>>>   include/linux/mmu_notifier.h     |  9 +++++----
>>>   include/linux/pgtable.h          | 19 +++++++++++++++++++
>>>   mm/rmap.c                        | 22 ++++++++++++++++++++--
>>>   4 files changed, 55 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h
>>> b/arch/arm64/include/asm/pgtable.h
>>> index e03034683156..a865bd8c46a3 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -1869,6 +1869,17 @@ static inline int ptep_clear_flush_young(struct
>>> vm_area_struct *vma,
>>>       return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>>   }
>>>   +#define clear_flush_young_ptes clear_flush_young_ptes
>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>> +                    unsigned long addr, pte_t *ptep,
>>> +                    unsigned int nr)
>>> +{
>>> +    if (likely(nr == 1))
>>> +        return __ptep_clear_flush_young(vma, addr, ptep);
>>> +
>>> +    return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
>>> +}
>>> +
>>>   #define wrprotect_ptes wrprotect_ptes
>>>   static __always_inline void wrprotect_ptes(struct mm_struct *mm,
>>>                   unsigned long addr, pte_t *ptep, unsigned int nr)
>>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>>> index d1094c2d5fb6..be594b274729 100644
>>> --- a/include/linux/mmu_notifier.h
>>> +++ b/include/linux/mmu_notifier.h
>>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>>       range->owner = owner;
>>>   }
>>>   -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)        \
>>> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)    \
>>>   ({                                    \
>>>       int __young;                            \
>>>       struct vm_area_struct *___vma = __vma;                \
>>>       unsigned long ___address = __address;                \
>>> -    __young = ptep_clear_flush_young(___vma, ___address, __ptep);    \
>>> +    unsigned int ___nr = __nr;                    \
>>> +    __young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);    \
>>>       __young |= mmu_notifier_clear_flush_young(___vma->vm_mm,    \
>>>                             ___address,        \
>>>                             ___address +        \
>>> -                            PAGE_SIZE);    \
>>> +                        nr * PAGE_SIZE);    \
>>>       __young;                            \
>>>   })
>>>   @@ -650,7 +651,7 @@ static inline void
>>> mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>>>     #define mmu_notifier_range_update_to_read_only(r) false
>>>   -#define ptep_clear_flush_young_notify ptep_clear_flush_young
>>> +#define ptep_clear_flush_young_notify clear_flush_young_ptes
>>>   #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>>>   #define ptep_clear_young_notify ptep_test_and_clear_young
>>>   #define pmdp_clear_young_notify pmdp_test_and_clear_young
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index b13b6f42be3c..c7d0fd228cb7 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -947,6 +947,25 @@ static inline void wrprotect_ptes(struct mm_struct *mm,
>>> unsigned long addr,
>>>   }
>>>   #endif
>>>   +#ifndef clear_flush_young_ptes
>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>> +                     unsigned long addr, pte_t *ptep,
>>> +                     unsigned int nr)
>>> +{
>>> +    int young = 0;
>>> +
>>> +    for (;;) {
>>> +        young |= ptep_clear_flush_young(vma, addr, ptep);
>>> +        if (--nr == 0)
>>> +            break;
>>> +        ptep++;
>>> +        addr += PAGE_SIZE;
>>> +    }
>>> +
>>> +    return young;
>>> +}
>>> +#endif
>>> +
>>>   /*
>>>    * On some architectures hardware does not set page access bit when accessing
>>>    * memory page, it is responsibility of software setting this bit. It brings
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index d6799afe1114..ec232165c47d 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -827,9 +827,11 @@ static bool folio_referenced_one(struct folio *folio,
>>>       struct folio_referenced_arg *pra = arg;
>>>       DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>>>       int ptes = 0, referenced = 0;
>>> +    unsigned int nr;
>>>         while (page_vma_mapped_walk(&pvmw)) {
>>>           address = pvmw.address;
>>> +        nr = 1;
>>>             if (vma->vm_flags & VM_LOCKED) {
>>>               ptes++;
>>> @@ -874,9 +876,21 @@ static bool folio_referenced_one(struct folio *folio,
>>>               if (lru_gen_look_around(&pvmw))
>>>                   referenced++;
>>>           } else if (pvmw.pte) {
>>> +            if (folio_test_large(folio)) {
>>> +                unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
>>
>> I may be hallucinating here but I am just trying to recall things - is this a
>> bug in
>> folio_pte_batch_flags()? A folio may not be naturally aligned in virtual
>> space and hence
>> we may cross the PTE table while batching across it, which can be fixed by
>> taking into
>> account pmd_addr_end() while computing max_nr.
>
> IMHO, the comments for the folio_pte_batch_flags() function have already made
> clear requirements for the caller to avoid such situations:
>
> "
> * @ptep must map any page of the folio. max_nr must be at least one and
> * must be limited by the caller so scanning cannot exceed a single VMA and
> * a single page table.
> "
>
> Additionally, Lance recently fixed a similar issue, see commit ddd05742b45b
> ("mm/rmap: fix potential out-of-bounds page table access during batched unmap").
 

Ah I see, all other users of the folio_pte_batch API constrain start and end
because they are already operating on a single PTE table. But for rmap code

this may not be the case. 


