Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48172D68BE8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8DF76B0089; Thu, 18 Dec 2025 02:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CAB6B008A; Thu, 18 Dec 2025 02:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91DCD6B008C; Thu, 18 Dec 2025 02:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2826B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:47:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7551160DD1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:47:16 +0000 (UTC)
X-FDA: 84231811272.15.98B4741
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9666540002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:47:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DPhdx9VI;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766044035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtgxMJy+nJmKfNZGRwA0XhkF4m6Mp5Z7MBUdEpNpwCs=;
	b=Z/nN0qlFOky2BxU4crRRi3JvjjUTTOr9BEsDk8Rf17VUyGq/dNetPOLSnsLK/sbnIAagRE
	2mpST/LfyBsJx8nL9j1k794CEbsClymBsyMeuRCFCvfu4fvvjXtkwnnSqGo7xvDp7SPFbO
	Bdt+VsIh6oVN4ZaTqdSDS1CkYsIKi34=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DPhdx9VI;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766044035; a=rsa-sha256;
	cv=none;
	b=vsLmtHbHQFclXVkqfr7Ha1FD3QlhWgrjO7HRGT6k0NRCyPfvMHUyVWZ+E3LZMYMoPUj4ea
	+VWBbdz/6RQjlT5JkbST8xUsW4OxemQNnw6McQFFq8El1mwJYp0b4ZLyKin69pHqN6C4Yk
	ymOlefwIO/Pa8eESSs30mbZ9D4/ovTo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766044030; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xtgxMJy+nJmKfNZGRwA0XhkF4m6Mp5Z7MBUdEpNpwCs=;
	b=DPhdx9VIfOzHZvJREc7n/0EhyREH2O7r3PvvspSDDI00dNFi8l7Cv7tA02lXcnQax7SW1qIQL4DwJJbNrBl5yQQZwSgVzkDY3k3s2VI+Rlgp/gEvnAp4OsGRSAQstk4d+hP2sNcXSqqOg1qjMt+b5d8r057h4nJWrRM8DfSA4iU=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv7mHTb_1766044027 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 15:47:08 +0800
Message-ID: <89cdd927-fc88-42cf-b8a1-2fbd736d5f7c@linux.alibaba.com>
Date: Thu, 18 Dec 2025 15:47:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
 <cb4d7243-d8c6-4706-a254-6f5afc148910@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <cb4d7243-d8c6-4706-a254-6f5afc148910@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9666540002
X-Stat-Signature: yohik84yq8yyixawpg543akojjenbfx3
X-HE-Tag: 1766044033-920476
X-HE-Meta: U2FsdGVkX18JdVz/bOW52xL0/3SLhUMTznp13JvASB4oz7LyO4fSFioIDfibh3xBFtOVdD4Gux4a9UcD0TXodC2q0p8GGZrvIRsX1WQ7qKuKgjBoWdvTQBRRzXP6yiSYIgmZ7fUvXHN9c8k5BQMaTaXWH58Z3e75STLAMvhS8FCGzaln4/G9J/sgoO0ozvOhhd1qWKoxUsgAuYV540IrArZxlQPpltXfFD6sof2Md9BsNfjdJLyk2Ste2WMR7GAkAbK5tlr1q2bhW+XzSNrXo0KsPaxawsv765D2uLz53vUVdrmHDmPjHoocMsBPhuXr52Jru4F5dj6mFomiiwF8VgpTJH3mzy006F9f/BjQs9neD7Ma20p3KXJBFktGA8AQxE74c28RcLX2kwcuS7J/TLxZuxqMBKYvTWV1QyMLKxQ2BKgHiqFOa2scnT1L++wu1lKie+wN2GC1MqLe1hsJW36J9ipHbZE/LOAL5yr0vUrMN6tA9vZg+JA7xitnqXVTZwYalrmJqxTLQRiI74LIdvEr8G9DvnJLXXnN4+ZhNadZvxq2qtAIE8AplGGQCyrxGunKz7DFLD9PYRiBDqCz2mzqtiwGujM1TJAPeJDd5PiMqzvztl4g7r2whUKhwUm2II9UFd3RYO/06KGc8VwipKIrGd2JZx1MxeZgdePbZQIQoxkrJFaF1ZdiF0zs54Mm9BekW8DmYANSLsP0S8HXAR4Xz1/SeOw9Ki82QxQhege+/qG3Jk92xTIUEp1DlM/AZWk6wswYe+35qy3nEsSWeROwTbot4nUjEUC7mW4EcWe4lAXiPxdyGj0zPRCXRva+95k3mkGA0lz0uSq4ownfMCD0Wf2bw2f3BI2Jg87q5uhW/s8biZMHS0itJRN/esps211I1OSs3amOG1wG0Xw2FpTD/A05KvgyfANG0QJMAjgqQ47arSmxIjRZOTrRKTOgkqtRqopSim9HLG2wXwU
 Mm2sARWH
 1ZYMdTx59l8D3ALKKmHIZImOiTBN8N/drRknABKBkFAepaZBW5zL1Pdoh0LVVzTPqki2VIhidWWIm8FOp/WH0Ok5+lcUCAUpGNJNy69HOwqPWW5UexHqlM6aKU7PwFrmjpmQmXW5+8mRW1kEJcnFMzcXFqp6dZNkUW8D2EH55EmW8X62Gfci0NME17iixGdraBYRm3epvhqFMv6kAgfryAvfrAQgIucgtZ54T1399Jat2yKA9INtgzso8/MRDYvWcAzyb6iqM+ON0tG5YHfXT0sQb82RA76vrWTyJ3OCwQiZBhJBxwPJII/L7k5lIsmBVupQDMKNFBnEXqyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 00:39, Ryan Roberts wrote:
> On 11/12/2025 08:16, Baolin Wang wrote:
>> Currently, folio_referenced_one() always checks the young flag for each PTE
>> sequentially, which is inefficient for large folios. This inefficiency is
>> especially noticeable when reclaiming clean file-backed large folios, where
>> folio_referenced() is observed as a significant performance hotspot.
>>
>> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
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
>>
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
> 
> Bug: This is broken if core-mm tries to call this for nr=1 on a pte that is part
> of a contpte mapping.
> 
> The similar fastpaths are here to prevent regressing the common small folio case.

Thanks for catching this. I had considered this before, but I still 
missed it.

> I guess here the best approach is (note no leading underscores):
> 
> 	if (likely(nr == 1))
> 		return ptep_clear_flush_young(vma, addr, ptep);

However, I prefer to use pte_cont() to check it. Later, I plan to clean 
up the ptep_clear_flush_young().

	if (nr == 1 && !pte_cont(__ptep_get(ptep))
		return __ptep_clear_flush_young(vma, addr, ptep);

>> +
>> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
>> +}
>> +
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
> 
> Shouldn't we rename this macro to clear_flush_young_ptes_notify()?
> 
> And potentially:
> 
> #define ptep_clear_flush_young_notify(__vma, __address, __ptep) \
> 	clear_flush_young_ptes_notify(__vma, __address, __ptep, 1)
> 
> if there are other non-batched users remaining.

There are no other non-batched users now, so seems there is no need to 
add another redundant API.

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
>>   > @@ -650,7 +651,7 @@ static inline void
> mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
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
> 
> Let's have some function documentation here please.

Sure. Will do.

>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +					 unsigned long addr, pte_t *ptep,
>> +					 unsigned int nr)
>> +{
>> +	int young = 0;
>> +
>> +	for (;;) {
> 
> I know Lorenzo is pretty allergic to this style of looping :)
> 
> He's right of course, we should probably just do this the ideomatic way and not
> worry about it looking a bit different to the others.

Let me use the 'while (--nr) { }' instead.

> 
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
>> +			}
>> +
>> +			ptes += nr;
>>   			if (ptep_clear_flush_young_notify(vma, address,
>> -						pvmw.pte))
>> +						pvmw.pte, nr))
>>   				referenced++;
>> +			/* Skip the batched PTEs */
>> +			pvmw.pte += nr - 1;
>> +			pvmw.address += (nr - 1) * PAGE_SIZE;
> 
> The -1 part is because the walker will increment by 1 I'm guessing?

Right.

> 
>>   		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>>   			if (pmdp_clear_flush_young_notify(vma, address,
>>   						pvmw.pmd))
>> @@ -886,7 +900,11 @@ static bool folio_referenced_one(struct folio *folio,
>>   			WARN_ON_ONCE(1);
>>   		}
>>   
>> -		pra->mapcount--;
>> +		pra->mapcount -= nr;
>> +		if (ptes == pvmw.nr_pages) {
>> +			page_vma_mapped_walk_done(&pvmw);
>> +			break;
> 
> What's this needed for? I'm suspicious because there wasn't an equivalent here
> before.

If we are sure that we batched the entire folio, we can just optimize 
and stop right here.

Thanks for reviewing.

