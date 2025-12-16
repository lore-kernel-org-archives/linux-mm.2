Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E762DD5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1B316B0005; Mon, 15 Dec 2025 22:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3676B0089; Mon, 15 Dec 2025 22:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1706B008A; Mon, 15 Dec 2025 22:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C73F66B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:47:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E8AAC0468
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:47:08 +0000 (UTC)
X-FDA: 84223948536.16.22ACA1D
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7CEE440004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:47:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N7E4bWO0;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765856826; a=rsa-sha256;
	cv=none;
	b=kSCeAF6trsUTtwWsYxzvvuCxMn/eQizVO2KShUQMxxlix0xOce9otCgVsSu0inVzXwZRf8
	1NylbqP5engmahb4XwrIIbH5Eaz2YhHQBtHSc+C+HMmACl3orbTFKoZNO9l5so5AQxnwi3
	yJoDnmGT/fKgQHjtsMEwWdGiDSwBbxc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N7E4bWO0;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765856826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHI8MwEkAMVbXFoi4qV2CciOuoz7wsRR0Mr9u7abYfA=;
	b=jrMoVVLHfPMWvpUTKHkKBCyNgAQeg8j6hutszwvxsLOn3rQsa9g5ZKUAFy2jcLWjS1htPP
	NrvgHpzULKVAA5/9Tkvlqskvybw1uIJEGWJXxtdtWxsq2PeB2sGZ5O5/tdidkEAKJVOINR
	Q6d8JeWEydyZMkWuwCwJdA1ybmuuETk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765856822; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OHI8MwEkAMVbXFoi4qV2CciOuoz7wsRR0Mr9u7abYfA=;
	b=N7E4bWO0eGOI7iraZyf/Jxia+B7QApkGnyLVIiiOaUMCGq5M4WInDL2M78D0/Fl+fPqMU0oMIw0XKIccIRX0iHGmROjzUQvAGD0XYnGv2IxSrT92AjJ0MBeRX6KoPM63WukFXY6aWgplrWHwUG7px5KH7R3Kb2d0Dj1R3ymd8U0=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuxZNce_1765856820 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 11:47:01 +0800
Message-ID: <7391d74f-782c-4d5a-9f9d-02afcefdbf87@linux.alibaba.com>
Date: Tue, 16 Dec 2025 11:47:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
 <4413d7f4-7734-4715-a450-2ba09db5ed22@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <4413d7f4-7734-4715-a450-2ba09db5ed22@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7CEE440004
X-Rspamd-Server: rspam03
X-Stat-Signature: hxjmneo9759fhn9g398gbkmbn6fgecie
X-Rspam-User: 
X-HE-Tag: 1765856825-42536
X-HE-Meta: U2FsdGVkX1/RFLCvj0xHqvSdUwtAM/bmqOnBo/WtJ8ENcvxRoAGfnlIycypgBTKmXw8gUJ5+QrGPG9drCTuXMYMerwPx6esjVORj08LJpdKjW+tPK9cDtYq5+qMPd97KwcZUpbiCBUlPx66h+Rl6g+XHlodsjew0CieMSwiuQpSwDZRQG/cle7rzdmvCIYdeoCYz2I52fDsJVZNpsQK7gSI4UYDeiHZ78pJohUl2Ro1IJuJ8GOhvSCDK+hENJEipsZQTj49oBlku7Z2Begx5tJX17bU8+fJ+/siGen3VYFwFBvyRL/Q+xnO+xYJgHCkX/lPEj5ChnFWZ6YUOrXseodMni+Yny7h23EyTbupsE/4VVAYInCHsuizhj4QtQfE45Na9vJuC/KlVwK9fg4n4q/qkAfV7Yul6vZwxzqWxRg+jP+5UxHrYHZqKh3m/k7owyGeSatNHBePBTFLgfJMs0qH17cbXlehfYtu5vOHYkqOXkwHZwWMcSOA1bmiAdOz8YjxGfVrN9wTjR+tjF1u7oO3G/lQXAgEHv2Gg0b1krHo6/9SLFvQZsGMGkqHhtv+sgSxRuZZLXk4SJ/LLC+2aWE+6196IynRt+mlettbMdcMryth0S/v/g18cETTqkkuO8CxDaoq+TOlt+37PN/nLb9ZpjjEB+VcYmHQAEGyJSUwsq3zsby242xEgec1z2Wx5CxyzE9aIUNIU+uEHhsG7Rh8wcE+WwOAXNZtCKY4HyDadjZqHHg1p2IlIoPJ+Uzs8gTJjUZP73WV3qdND0IKTwiZLCjOCwADYGJGvww9dMKxprodck/yhM/WMF2G0qzOYyWBTN5x+uIVaydnc86QWyBTSGlGdIwspbaLCNaxg06w/cpWVuvoXbEcU3JYJ1Z4LH7V6QqE4PcuhK4mRXK4gvQkil7MH5BdWiPKk8LmwEGHvZmKw9Oa+jHawSnMXB9ipd+MNqq4USnZHP/PihMa
 CUywjj8p
 ghlz738NiD7Vfbgl63nonxbud046/JMTgB8qE+XXW+yQPbnllBS/haIiqrkyZHlbo2NiaZCL5m7aUVHys0kqCoZ3CXxmPh/jASWnDlrUc0Ccs0T8tqkAGe6J1DjidLyVGrqE9vyHQL2AicKE3AyBCZh3/Yu2A0FNeoj3TIXhNll2UG1zZTqcWFhl0y8VuhPA8QXAlEYeQfhzB9b/2+CfgxoCL25d0pXCEwpXaYeY87xLsxQj9MylJlz+b0YJgusPpJ3yP8FBCHL0RoNBMDtG4iPnCWvvth1zVqNzi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/15 20:22, Lorenzo Stoakes wrote:
> On Thu, Dec 11, 2025 at 04:16:55PM +0800, Baolin Wang wrote:
>> Currently, folio_referenced_one() always checks the young flag for each PTE
>> sequentially, which is inefficient for large folios. This inefficiency is
>> especially noticeable when reclaiming clean file-backed large folios, where
>> folio_referenced() is observed as a significant performance hotspot.
>>
>> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
> 
> arm64 you mean :)

Right. Will make it clear.

>> an optimization to clear the young flags for PTEs within a contiguous range.
>> However, this is not sufficient. We can extend this to perform batched operations
>> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
>>
>> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
>> of the young flags and flushing TLB entries, thereby improving performance
>> during large folio reclamation.
>>
>> Performance testing:
>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
>> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
>> from approximately 35% to around 5%.
>>
>> W/o patchset:
>> real	0m1.518s
>> user	0m0.000s
>> sys	0m1.518s
>>
>> W/ patchset:
>> real	0m1.018s
>> user	0m0.000s
>> sys	0m1.018s
> 
> That's nice!
> 
> Have you performed the same kind of performance testing on non-arm64? As in the
> past we've had a batch optimisation go horribly wrong on non-arm64 even if it
> was ok on arm64 :)

Yes, seems you missed my test results for the x86 machine in the commit 
message :)

"I can observe 33% performance improvement on my Arm64 32-core server 
(and 10%+ improvement on my X86 machine)."

>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>>   include/linux/mmu_notifier.h     |  9 +++++----
>>   include/linux/pgtable.h          | 19 +++++++++++++++++++
>>   mm/rmap.c                        | 22 ++++++++++++++++++++--
>>   4 files changed, 55 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index e03034683156..a865bd8c46a3 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1869,6 +1869,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>>   	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>   }
>>
>> +#define clear_flush_young_ptes clear_flush_young_ptes
>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +					unsigned long addr, pte_t *ptep,
>> +					unsigned int nr)
>> +{
>> +	if (likely(nr == 1))
>> +		return __ptep_clear_flush_young(vma, addr, ptep);
>> +
>> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
>> +}
> 
> Hmm again this is a weird way of exposing a contepte-specific function, you
> really need to rework that as discussed in patch 1/3.
> 
> It seems to me we can share code to avoid this.

Sorry I don't think so. This is the current way of exposing a contpte 
for Arm64. Please take a look at set_ptes(), clear_full_ptes(), 
wrprotect_ptes() and so on (in this file).

>>   #define wrprotect_ptes wrprotect_ptes
>>   static __always_inline void wrprotect_ptes(struct mm_struct *mm,
>>   				unsigned long addr, pte_t *ptep, unsigned int nr)
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index d1094c2d5fb6..be594b274729 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>   	range->owner = owner;
>>   }
>>
>> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
>> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
>>   ({									\
>>   	int __young;							\
>>   	struct vm_area_struct *___vma = __vma;				\
>>   	unsigned long ___address = __address;				\
>> -	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
>> +	unsigned int ___nr = __nr;					\
>> +	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
>>   	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>>   						  ___address,		\
>>   						  ___address +		\
>> -							PAGE_SIZE);	\
>> +						nr * PAGE_SIZE);	\
>>   	__young;							\
>>   })
> 
> An aside, but I wonder why this needs to be a (pretty disgusting) macro?

Um, I can send a follow-up to clean up all these related macros.

>> @@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>>
>>   #define mmu_notifier_range_update_to_read_only(r) false
>>
>> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
>> +#define ptep_clear_flush_young_notify clear_flush_young_ptes
>>   #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>>   #define ptep_clear_young_notify ptep_test_and_clear_young
>>   #define pmdp_clear_young_notify pmdp_test_and_clear_young
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index b13b6f42be3c..c7d0fd228cb7 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -947,6 +947,25 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>   }
>>   #endif
>>
>> +#ifndef clear_flush_young_ptes
>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +					 unsigned long addr, pte_t *ptep,
>> +					 unsigned int nr)
>> +{
>> +	int young = 0;
>> +
>> +	for (;;) {
>> +		young |= ptep_clear_flush_young(vma, addr, ptep);
>> +		if (--nr == 0)
>> +			break;
>> +		ptep++;
>> +		addr += PAGE_SIZE;
>> +	}
>> +
>> +	return young;
>> +}
>> +#endif
>> +
>>   /*
>>    * On some architectures hardware does not set page access bit when accessing
>>    * memory page, it is responsibility of software setting this bit. It brings
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index d6799afe1114..ec232165c47d 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -827,9 +827,11 @@ static bool folio_referenced_one(struct folio *folio,
>>   	struct folio_referenced_arg *pra = arg;
>>   	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>>   	int ptes = 0, referenced = 0;
>> +	unsigned int nr;
>>
>>   	while (page_vma_mapped_walk(&pvmw)) {
>>   		address = pvmw.address;
>> +		nr = 1;
>>
>>   		if (vma->vm_flags & VM_LOCKED) {
>>   			ptes++;
>> @@ -874,9 +876,21 @@ static bool folio_referenced_one(struct folio *folio,
>>   			if (lru_gen_look_around(&pvmw))
>>   				referenced++;
>>   		} else if (pvmw.pte) {
>> +			if (folio_test_large(folio)) {
>> +				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
>> +				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
>> +				pte_t pteval = ptep_get(pvmw.pte);
>> +
>> +				nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
> 
> I do wish we could put this fiddly logic into a helper for each place in
> which we do similar kind 'end of the PTE table, maximum number we could
> have' logic.

Um, the logic is already simple, and I don’t think adding a new helper 
would improve readability. If some code can reuse this logic, we can 
factor it out into a helper at that point.

>> +			}
> 
> NIT but we're running into pretty long lines here.

OK. Will fix this.

>> +
>> +			ptes += nr;
>>   			if (ptep_clear_flush_young_notify(vma, address,
>> -						pvmw.pte))
>> +						pvmw.pte, nr))
>>   				referenced++;
> 
> I find this referenced logic weird, it seems like it should be a boolean,
> but this is outside the scope of your patch here :)

Right. Thanks for reviewing.

