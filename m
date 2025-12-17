Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFF6D64086
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4DF6B0005; Wed, 17 Dec 2025 02:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A34A6B0089; Wed, 17 Dec 2025 02:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1CB6B008A; Wed, 17 Dec 2025 02:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 683AB6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:09:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AE7312F62
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:09:56 +0000 (UTC)
X-FDA: 84228088392.14.D8F4F4F
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id DDFEC40013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:09:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gAFOHui7;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765955394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPdhN2PgYo+tFQS6gBLjYcRITKQ82W662MYUF3IclR8=;
	b=UoKdDDkEP/qwhUHlWVon5le+fosl5R6R/eRXWkfSRKoBcLIqHOHwNHaSntUJxaL3z3mDbs
	Ndw70zYTYHuFywhzph3S6nY6slI1OdO+OU2StmVoSEjtnE5PF7vyuJSghQ4+imZz02Xpe2
	iWm2ULvGH+8leKpMXhCmpAS3La4viGo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gAFOHui7;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765955394; a=rsa-sha256;
	cv=none;
	b=LJnjQigbrSELRWS1L3g54AMLWR21gAt4v0xPYWnL4ozHwTw/8c5/qyuoDr47V2kEAtulx3
	3cWG0TCnxoI8YTGtU0MtTdWnUK8XmQZiM7wqytfFJ4TWj4s0lyBDyY0N9vNT1qnP7ooA8c
	oSV4h0Lg1x5kSnMQhr8mufM5RZdssac=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765955389; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BPdhN2PgYo+tFQS6gBLjYcRITKQ82W662MYUF3IclR8=;
	b=gAFOHui7OtcrIxy+0Dgs5IynSQpQ9ImYB9pnJNlsb43qkgA2s+09idgoFWANKvSxA5eGdGgB+fm9Sqkk2OvIwr4oXRpA8ToIlcqdTeeWuIbVeZnFFCZWLUxTvSBV/w8QAI1ItoOryv/hF2RNAcOHg8ERK4KvjXVp9ldJ+g4rYc4=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv2U.eU_1765955387 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Dec 2025 15:09:48 +0800
Message-ID: <753ee7bd-8c9a-4242-a216-98defcd8280f@linux.alibaba.com>
Date: Wed, 17 Dec 2025 15:09:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@kernel.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
 <52ed7e12-b32e-4a73-ba55-eed993b930b9@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <52ed7e12-b32e-4a73-ba55-eed993b930b9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: bnpi9m5ozyy5hnrm9xsceipb9111wfwo
X-Rspam-User: 
X-Rspamd-Queue-Id: DDFEC40013
X-HE-Tag: 1765955392-843423
X-HE-Meta: U2FsdGVkX1/MGtO6WGUkEHdxtrehEBmCoBbWlza/3/HRStNZsTQ0/NPlgrJkbpwEqpRUqGkeBWHzR73lGHxVNxBTmyS+vYDAl9BnYiWTs8wGZ1iUv0A2KBCb3gkDR42KqMh35eTlrMeu4L5o1OLwdhbEgZzK00I1bSmcVQ+RZxWwu2C68yHTrMbrbL5fb9i5N6e3VWHkwFjHuWYBNLuaf0UwHlyuwp2cVbyUx8x6WesPQQDjlVSoG2sTVLRLR9JIeaH1CZW4FmJAYRbtFb2gVnSVS9TrxFC3PidTUpr8k+sm2SQUypzN0GNQSch33KmXRIY7QN24yt07zdLGmORRGhOKz1IUwRy6FrRUfM3VvqCS7+G2PQ96m6wKjlqmbTuT2Gk2qlDpnSQoLY/yIZrwmcQjKI/Pk7wQwx2F0ll3rMo0RYg8QMXlpTutNy44fhIUCCVXqNSkEVghzBC1abuISNWEiUsgDJzgQlU0BeH3YWmyWn3T9ZlS7xHVd853Wt7+NngUwxBi6kBoUeLB11p3RwWSFVhK/OeKHNEbKC19I1wfZtyZH51nYX4lo/SUHCrRITptIIvnkpZJdgR1ozOu5tyBh3yh0pQ/spKXGfPAw/Ug2B3X3W1qQ6hvoGzf2jsMQKxvzn7cJJ11vuyx/jkZaGJ6jJfhLZ2NfaXBCXwYpgT2iEknQlL5M0EYaAaC0ReTHOJeT+u+Tu8sDJ9hx25EmJznV1yhUoUY7Kdfd6JJhGaE1x6SaoWdrEu3UViVorPoaGCo1tlk91JXvpFPa8awFKcjjza0tXJfq/8yvZsmmOBZXeZRlthoOAh5yvWFx24eleKj7xIqGzuCeeQqttFqT31i4SBWa9xfqcRaWe32dTUgS4KDOZbTeu7BA4YVH0sxAzG+ABGIj9UvKTzDjcDrQlZ254BOTIzchTUYABjg1LIhTLxU/Nx8y9udhsJAnHKWY1LHIDBq2MGZva+ftJP
 tITT+C7v
 129HPxiJWNXwLrOGdhKWg0r+Vc+ifkwodI36DdFq+RmbuVmjoWS1aVcV2FOPyHkawMtJa0gINlFoHpOULQjEV57NGCzWK2zSUZCG9V0w7FCWTk4+v0HXc9qM5Br2OHsU6RLhceOLLhXMaplNuiiy1IG0vij06SsHTA+BqQgjsHSFk0xAAX6dE9yg8BCSGA8Mqehjw0U0EjjiXos0NCEAl3A/B0AZCf83X/WvfCJ4Pi4Uv360TIz5opqBt4we5geKvBQ0AmJMuayIJAFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 14:49, Dev Jain wrote:
> 
> On 11/12/25 1:46 pm, Baolin Wang wrote:
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
>>   
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
> 
> I may be hallucinating here but I am just trying to recall things - is this a bug in
> folio_pte_batch_flags()? A folio may not be naturally aligned in virtual space and hence
> we may cross the PTE table while batching across it, which can be fixed by taking into
> account pmd_addr_end() while computing max_nr.

IMHO, the comments for the folio_pte_batch_flags() function have already 
made clear requirements for the caller to avoid such situations:

"
* @ptep must map any page of the folio. max_nr must be at least one and
* must be limited by the caller so scanning cannot exceed a single VMA and
* a single page table.
"

Additionally, Lance recently fixed a similar issue, see commit 
ddd05742b45b ("mm/rmap: fix potential out-of-bounds page table access 
during batched unmap").

