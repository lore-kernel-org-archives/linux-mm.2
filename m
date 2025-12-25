Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B380EE784AC
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 02:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5096B0088; Wed, 24 Dec 2025 21:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068956B0089; Wed, 24 Dec 2025 21:48:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA026B008A; Wed, 24 Dec 2025 21:48:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA8676B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:48:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CDC7138C39
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:48:50 +0000 (UTC)
X-FDA: 84256460820.20.E5F4914
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf20.hostedemail.com (Postfix) with ESMTP id 70DA41C0005
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:48:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FVzoLV8G;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766630928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5jiwUqQZpkFncIxj0w47U4jzh93+I75TVRu/PSNklQ=;
	b=WvaCXtaNbXd2DmkeA2WkveyWeI1r6bfR2QEo4eLFKHzbYAk1a1QspqOSXQSRSu9VhGThZh
	DWVepzyGRT4urxTofPKd1TxgkrT6rFBAM2OzGy6JAs3AbhA9BuPGu7jnorxh5BKP0l4lRh
	JUt3LQOu21PzgyKwoRVbXzve+Ow6tCE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FVzoLV8G;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766630928; a=rsa-sha256;
	cv=none;
	b=LIutnWJahIKyfkz3/MObezZ7ivuYo76ZelQU2NuAb0dAf3O0UgZWUumcyFw9//Ddl/treD
	nyFuDFSGVQS8WkursyxhIzFudsxYmZ3OEEkYTmASOyOuTMzy7w09/u/+u455lGuFqvGfun
	xSTuqBxTPtvUEt5mYm0Met1dScWvcoE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766630924; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D5jiwUqQZpkFncIxj0w47U4jzh93+I75TVRu/PSNklQ=;
	b=FVzoLV8G87K52+ZNOdYJzDYStn34oNV5YW5JhmWHax6QNoyWqhcRNKJ7BR1S+2QWw5jtXws5bf8FUm9XJeXjDiYZd1RUjGtt7ybI+7Eml1bRCTHuyHEDGtZd6DFg4JGHUDPugoWgTh4VknPxrdQ1Xb/tK0ODoQA5la+mQrrTCWk=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wvd.uPh_1766630922 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Dec 2025 10:48:43 +0800
Message-ID: <02239ca7-9701-4bfa-af0f-dcf0d05a3e89@linux.alibaba.com>
Date: Thu, 25 Dec 2025 10:48:42 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <c5df1f9f-952a-4e83-9ae0-bd0a83dedd36@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: prb9afrcwzwhgn8e5yfhqid7hnp6odo9
X-Rspam-User: 
X-Rspamd-Queue-Id: 70DA41C0005
X-HE-Tag: 1766630927-758858
X-HE-Meta: U2FsdGVkX1+8AvVs02km6c2gUjBMo94c1rOAhKchzYyHYQUs3O+uIJfZnJ3QxvaS/ZZynoUo46rJ63Z/6D+PNY1KFBORrWiCnAt3+1FhgBsBP2/FFMQ+Yrgu6R9uTSZiTes6mDY5dI9OrkvqH9zflFykOnTwdT1j7DDJqRZx62iUT4GqYgDdaTQNHOA0YY1nLUDRkUIQAB3wxuFu/8xGcN7B+KCNjuGYBfxBH2wFQLATryPtiO3B4nhJH3wOe1Mb+urX0B3UTWjAleLZAR0mTG2ob2N6Du1hTcglgTun2ItdXti6I+f4p0Ge8d4dNX2WZvYvuX1oz4A0G7Zt8B5ucEBH212h8CQj4Fvl1Eog0ycDV0NS18rB1Gz7JPnsu83rJa50pwTw02RvEeedVxAA8P/yPuajbRzBHc+BwWtNpQkG9WzoR5WZys4R7E40u8qzw+Oa99E73I1K6QbvuGNqfDpfC1WTjVPWOY02TTPFDlvqfxY4VDYsgaiTrNC52Qcjyg+F1RMGLNwM1sPGpjGh7hyzV9D9RybrDhteg17vEckE5ma7XH7nbwnQGLshFmibpW36pA7kVGh8o0IW0CMpOtphWl14osus9tKh1WCYotf+IWlVSH0BSsrZolEt4/gIxZHOxPJNPNfMlCHRdwOi3chzEWdeGij4ZPtw9R2xOXqvwOvAe9g7NkO3Ty1OIduqWcoedgjsnljr7HfJTW6Tg4NPzrUMtf1tKeWqb9EFNhzsFG1Kpmgs7J+RsaCP66eLzAH35HfitLMF+izQPBAI22/LcNpRKfiY6i4BaVLpsEghKMlZIgbDkAc5WZ8mvhTwLAhZ8Vdr+83D+42CpeH4moFCDLNAZKydOxYyIWnqiIHP+0iYBnzBcfVaIBza29VeKoYgXl4ABUP1/EUWNPdgIHdWpBPgAvE1+1ecz7GRkVvpXBEJf5zxzqjzM+kyu63CfPTSA4U2vRLLJ1FQCCM
 RlKbEIbd
 BcvccKbexccRe5GKBkgl9OM0/VFp9+eBjuthHh9n4pLBM+wQ1lb/eNsC4OyWWN1jcA35ugNJqLdXfw/ijweuwLDmgBWwD7v3tjCRwDB1XqSNSPg3m0c/cyaDBheYEKDnBLGojVPL1ASQcrtlMhDknBfHF1uH84PQK7gpYmU2DRPTyoj5+wDiyjVgUfpf9RZ6OtOLXD52+SfvIR7J3FFP0Zn0RpKnRi+QX2QJSoFKGPsECo3dkGeAjADkKHmsNGPvcTWZFawcNv9JiYL7EsDEsSVT/NfIhEe+r5k+avophKNCfEXo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/24 22:07, Ryan Roberts wrote:
> On 23/12/2025 05:48, Baolin Wang wrote:
>> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
>> only clear the young flag and flush TLBs for PTEs within the contiguous range.
>> To support batch PTE operations for other sized large folios in the following
>> patches, adding a new parameter to specify the number of PTEs that map consecutive
>> pages of the same large folio in a single VMA and a single page table.
>>
>> While we are at it, rename the functions to maintain consistency with other
>> contpte_*() functions.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 12 ++++++------
>>   arch/arm64/mm/contpte.c          | 33 ++++++++++++++++++--------------
>>   2 files changed, 25 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 445e18e92221..d5fbe72e820a 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1648,10 +1648,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>>   extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>   				unsigned long addr, pte_t *ptep,
>>   				unsigned int nr, int full);
>> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>> -				unsigned long addr, pte_t *ptep);
>> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>> -				unsigned long addr, pte_t *ptep);
>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>>   extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>   				pte_t *ptep, unsigned int nr);
>>   extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>> @@ -1823,7 +1823,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>>   	if (likely(!pte_valid_cont(orig_pte)))
>>   		return __ptep_test_and_clear_young(vma, addr, ptep);
>>   
>> -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
>> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
> 
> As per your fixup patch, I agree that nr should be 1 here, not CONT_PTES.

Yes.

>>   }
>>   
>>   #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>> @@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>>   	if (likely(!pte_valid_cont(orig_pte)))
>>   		return __ptep_clear_flush_young(vma, addr, ptep);
>>   
>> -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
>> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
> 
> And same here.
> 
>>   }
>>   
>>   #define wrprotect_ptes wrprotect_ptes
>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>> index e4ddeb46f25d..b929a455103f 100644
>> --- a/arch/arm64/mm/contpte.c
>> +++ b/arch/arm64/mm/contpte.c
>> @@ -508,8 +508,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>>   }
>>   EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>>   
>> -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>> -					unsigned long addr, pte_t *ptep)
>> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +					unsigned long addr, pte_t *ptep,
>> +					unsigned int nr)
>>   {
>>   	/*
>>   	 * ptep_clear_flush_young() technically requires us to clear the access
>> @@ -518,41 +519,45 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>>   	 * contig range when the range is covered by a single folio, we can get
>>   	 * away with clearing young for the whole contig range here, so we avoid
>>   	 * having to unfold.
>> +	 *
>> +	 * The 'nr' means consecutive (present) PTEs that map consecutive pages
>> +	 * of the same large folio in a single VMA and a single page table.
>>   	 */
>>   
>> +	unsigned long end = addr + nr * PAGE_SIZE;
>>   	int young = 0;
>> -	int i;
>>   
>> -	ptep = contpte_align_down(ptep);
>> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>> -
>> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>> +	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
>> +	for (; addr != end; ptep++, addr += PAGE_SIZE)
>>   		young |= __ptep_test_and_clear_young(vma, addr, ptep);
>>   
>>   	return young;
>>   }
>> -EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
>> +EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
>>   
>> -int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
>> -					unsigned long addr, pte_t *ptep)
>> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
>> +				unsigned long addr, pte_t *ptep,
>> +				unsigned int nr)
>>   {
>>   	int young;
>>   
>> -	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
>> +	young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
>>   
>>   	if (young) {
>> +		unsigned long end = addr + nr * PAGE_SIZE;
>> +
>> +		contpte_align_addr_ptep(&addr, &end, ptep, nr);
>>   		/*
>>   		 * See comment in __ptep_clear_flush_young(); same rationale for
>>   		 * eliding the trailing DSB applies here.
>>   		 */
>> -		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>> -		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
>> +		__flush_tlb_range_nosync(vma->vm_mm, addr, end,
>>   					 PAGE_SIZE, true, 3);
> 
> Hmm... The requirement is that we must flush the _page_ if clearing access for a
> pte that does not have the contiguous bit set, or we must flush the _contpte
> block_ if clearing access for a pte that does have the contiguous bit set.
> 
> With your changes, you may call for a large range that covers multiple contpte
> blocks but only has a single pte in a single contpte block for which the access
> bit was previously set. But that will cause flushing the TLB for the full range.
> Could this cause a performance issue? Yes, no, maybe... I think it's unlikely
> but I wouldn't rule it out in some edge case.
> 
> I wonder if it's better to track the sub-ranges where access was cleared and
> only issue tlbi for those sub-ranges? Probably just keep it simple (the way you
> have done it) until/unless we see an actual problem?

Good question. Indeed, as you said, we flush the TLB per folio now, 
which might increase the flush range. However, I think this approach is 
relatively reasonable for now.

First, the mm-core also tracks the access status per folio, and it's 
really unnecessary to add excessive complexity to track the access 
status of sub-pages (or sub-ranges). I can already imagine that tracking 
the access status for each cont-block range as well as for non-cont 
pages across the entire large folio range, which can be too complicated.

Second, __flush_tlb_range_nosync() is a lightweight flush. I quickly ran 
a measurement on my machine and found that the overhead of 
__flush_tlb_range_nosync() barely changes between nr=16 and nr=256 (both 
are around 40 ns).

Therefore, I would still prefer to keep the logic here simple.

