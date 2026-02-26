Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48AEFD460E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232B56B008A; Wed, 25 Feb 2026 22:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0D76B00A7; Wed, 25 Feb 2026 22:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2A06B00A8; Wed, 25 Feb 2026 22:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAFA76B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:36:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE7E71CB0B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:36:47 +0000 (UTC)
X-FDA: 84485196054.13.A9908DD
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8236A80010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:36:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wGe2FI2i;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772077005; a=rsa-sha256;
	cv=none;
	b=R08l59f8dMYk/IXn0d5Deyc2jZmf3ZKguYEVR2Mygsfrh1StuJWXTnHv7YvqTbC8rOYER/
	WOAO0fe4klqeomcPibdfjSpYufdhm8+Qne0O/ctyGEZ5W6fLeGF4qyeYR7p1DC7OImDmNe
	tRmAUzkBB0T8kCQA330oIV+spAHbuNg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wGe2FI2i;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772077005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpzgBIQcGsuSWrw8v83C+dnRIF10MeSyjQBe5C87dLY=;
	b=Q6PyIdKWnE9U21rWRmdaHNjEswMFySIvmzYLmDrwopZmaF9gJfsrkoCqB21WMe+oISkFXk
	sYca3vvr4I/2Hwq/uWtPLC2x3saVDLgizkPJNIoYjaJJrHE+o5Q7hItGmVhzukCD+mQV8m
	6BaCxVKWPhdZ5phPsMReoUIzrh7PyBQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772076996; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xpzgBIQcGsuSWrw8v83C+dnRIF10MeSyjQBe5C87dLY=;
	b=wGe2FI2iwtDLzFCr32SRgQYfJp6qAkb/Dp6TgW9k79bLKdvqKzR4OE/oN+PbiDzd4ntN73bYGgZcPOu7iqYz3yI85fGrOL8EVBsZJy++UQ1pvsM5DLSrnugpClE2gbOUBN74IhTa5UC0UfFcIIgR0N8ocVNwQKFxwwWy/RI/Xsc=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzpnG4Z_1772076994 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 11:36:35 +0800
Message-ID: <41be3f15-2cc6-4ec3-beab-9a5c4da532a2@linux.alibaba.com>
Date: Thu, 26 Feb 2026 11:36:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: use inline helper functions instead of ugly
 macros
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <dc94552605926f9ce84f9fc2ddfe5f7d1319e41c.1771897150.git.baolin.wang@linux.alibaba.com>
 <1e90b26c-5934-47e4-a0ea-96fd8af45076@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1e90b26c-5934-47e4-a0ea-96fd8af45076@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8236A80010
X-Stat-Signature: k4gcbn5uny4i75nkyz5bqt89wezcqkzg
X-HE-Tag: 1772077002-663235
X-HE-Meta: U2FsdGVkX19jBBb9KEQeJWZw3KsRszGRK4Q3TmotKGi0s4P5O4rKVaMnWS9OZQkaAdRjsSZqZrVdG60qy1xsNdYQM6dpjmWNX2PCdFnQPE0U42Q9O2WxwBXghJl9SYk5s/ShhhIgyA7b+Sf7Q/So6o5YVwoLgMKTp6AA2v+ct9P5FMHgu+8cGoKxL3bU6ccScGK7SYcwHWVPzmuhtPKSaV2CFHwOeSQbejSYeIsRxqSMq1n/4/2aVCBdg+Vb+ORRfDwh2dkTQlNhMQ4tpy2Yhfh2FrRaqI5btpRRNriNXaBxVUZPtfT4JUfJUjYq4NV3EoHMUw4rDpJqqyFpw23BJy5LijQm9ZMKmBfyfCbh98PDmNPtr++K6nZT5aiiwGBeedK9DfdcCCVW9uWw8hY7Bm49OcxJvfQZbcr1BxiellQyjrxs8h7Lr/emmXLBl7fZzUOjQ8/t+U1xtSeKkvKmKQdCVbp4WqvJT2x1hEfLV0zNMUcaqKvsP3J08dZ84u2nrYfP6eC3fk541TPsGD2eCBZKST8ZpcGaZWj9FbogDFx0ctULUGUqGFrgaW337kWFYnDB76Yg1cSMHUcycDKEN5CdrR85F6N158KiV18pzTfHz5Txr3jBWoFmP33HW1vwlxQ4wssoPjYoF5eA3hJXgZXCJRqhHFkSX8jiNEr0XWBNfPH4I6XvzJetcPcNfecSBaCtXMmISzw+Whi2HZkynzVHygGSAs4U9qXToQBng47xJ5uSWdV4PY7UZqWo+3CL/mKuaZqq0f4GpXLLhcpVYq0G7ICTOOwxM7PuHiXwfpvwK6kmWbfjrW7gNO5bPmpGO9VHAhQGS65nDMoG1fwKWq5KQ9d8AHYpBj/PLnlA/tgG1mqk+TTUS4DeiEJakk3p0w4bW2pugLTtrbXiy4iXDu19IK4QFTiu6HjKPa924N6GLaiC0y7hoURP1WBpwrHKCYnreNZYQjzC/nJHS/+
 c2fFQUId
 uvGqY3N/RCGantfpLysR/6nVA0ZpTC5eiOoG4SXlaWgg5seM/ri9oFfcxqLa0Pwf+gp/T+DekDa309y0jBkDayWnsGz2rnd7dzSdY3ajaiDeiWt8jPtlyDcf2Q7z6D7JQpVLQ29MXsvvBPesMdASUhCuxjMZjrwT1jCKpRkEd44sfpsIrDYalubM/pzKCPy6IRX0fl5FUcyTA57huZmFOEXuJNWVn6nT/4EQTqbXpOqLRSkMhNA7t9t20Z7tAhOwmSYfyR+2bioYEFgK3ag7P9m4F7Xp0Kj3m35AfHKlLVuUVazI5opkKCvLZeETKCxZJhD8vn6iaL32YfofDM8EQ6VoIsXtWNXGqcHxKFKa601V0/6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/25/26 9:56 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 02:56, Baolin Wang wrote:
>> People have already complained that these *_clear_young_notify() related
>> macros are very ugly, so let's use inline helpers to make them more readable.
> 
> Could it have been me :)

Lorenzo and Matthew have also said they dislike these ugly macros:)

>> In addition, I cannot implement these inline helper functions in the
> 
> "We cannot implement ..."

Sure.

>> mmu_notifier.h file, because some arch-specific files will include the
>> mmu_notifier.h, which introduces header compilation dependencies and causes
>> build errors (e.g., arch/arm64/include/asm/tlbflush.h). Moreover, since
>> these functions are only used in the mm, implementing these inline helpers
>> in the mm/internal.h header seems reasonable.
> 
> Agreed. if it compiles, all good.
> 
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   include/linux/mmu_notifier.h | 54 ------------------------------------
>>   mm/internal.h                | 53 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 53 insertions(+), 54 deletions(-)
>>
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index 07a2bbaf86e9..93894b90c8c1 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -515,55 +515,6 @@ static inline void mmu_notifier_range_init_owner(
>>   	range->owner = owner;
>>   }
>>   
>> -#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)	\
>> -({									\
>> -	int __young;							\
>> -	struct vm_area_struct *___vma = __vma;				\
>> -	unsigned long ___address = __address;				\
>> -	unsigned int ___nr = __nr;					\
>> -	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
>> -	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>> -						  ___address,		\
>> -						  ___address +		\
>> -						  ___nr * PAGE_SIZE);	\
>> -	__young;							\
>> -})
>> -
>> -#define pmdp_clear_flush_young_notify(__vma, __address, __pmdp)		\
>> -({									\
>> -	int __young;							\
>> -	struct vm_area_struct *___vma = __vma;				\
>> -	unsigned long ___address = __address;				\
>> -	__young = pmdp_clear_flush_young(___vma, ___address, __pmdp);	\
>> -	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>> -						  ___address,		\
>> -						  ___address +		\
>> -							PMD_SIZE);	\
>> -	__young;							\
>> -})
>> -
>> -#define ptep_clear_young_notify(__vma, __address, __ptep)		\
>> -({									\
>> -	int __young;							\
>> -	struct vm_area_struct *___vma = __vma;				\
>> -	unsigned long ___address = __address;				\
>> -	__young = ptep_test_and_clear_young(___vma, ___address, __ptep);\
>> -	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
>> -					    ___address + PAGE_SIZE);	\
>> -	__young;							\
>> -})
>> -
>> -#define pmdp_clear_young_notify(__vma, __address, __pmdp)		\
>> -({									\
>> -	int __young;							\
>> -	struct vm_area_struct *___vma = __vma;				\
>> -	unsigned long ___address = __address;				\
>> -	__young = pmdp_test_and_clear_young(___vma, ___address, __pmdp);\
>> -	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
>> -					    ___address + PMD_SIZE);	\
>> -	__young;							\
>> -})
>> -
>>   #else /* CONFIG_MMU_NOTIFIER */
>>   
>>   struct mmu_notifier_range {
>> @@ -651,11 +602,6 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>>   
>>   #define mmu_notifier_range_update_to_read_only(r) false
>>   
>> -#define clear_flush_young_ptes_notify clear_flush_young_ptes
>> -#define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>> -#define ptep_clear_young_notify ptep_test_and_clear_young
>> -#define pmdp_clear_young_notify pmdp_test_and_clear_young
>> -
>>   static inline void mmu_notifier_synchronize(void)
>>   {
>>   }
>> diff --git a/mm/internal.h b/mm/internal.h
>> index e0ef192b0be3..1ba175b8d4f1 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -11,6 +11,7 @@
>>   #include <linux/khugepaged.h>
>>   #include <linux/mm.h>
>>   #include <linux/mm_inline.h>
>> +#include <linux/mmu_notifier.h>
>>   #include <linux/pagemap.h>
>>   #include <linux/pagewalk.h>
>>   #include <linux/rmap.h>
>> @@ -1789,4 +1790,56 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
>>   	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
>>   }
>>   
>> +#ifdef CONFIG_MMU_NOTIFIER
>> +static inline int clear_flush_young_ptes_notify(struct vm_area_struct *vma,
>> +						unsigned long addr, pte_t *ptep,
>> +						unsigned int nr)
> 
> Two tabs indent on the second line makes this fit into two lines.

OK.

> Same for the others.
> 
> With that
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>> +{
>> +	int young;
>> +
>> +	young = clear_flush_young_ptes(vma, addr, ptep, nr);
>> +	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr,
>> +						addr + nr * PAGE_SIZE);
>> +	return young;
>> +}
>> +
>> +static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
>> +						unsigned long addr, pmd_t *pmdp)
>> +{
>> +	int young;
>> +
>> +	young = pmdp_clear_flush_young(vma, addr, pmdp);
>> +	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr, addr + PMD_SIZE);
>> +	return young;
>> +}
>> +
>> +static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
>> +					  unsigned long addr, pte_t *ptep)
>> +{
>> +	int young;
>> +
>> +	young = ptep_test_and_clear_young(vma, addr, ptep);
>> +	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
>> +	return young;
>> +}
>> +
>> +static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
>> +					  unsigned long addr, pmd_t *pmdp)
>> +{
>> +	int young;
>> +
>> +	young = pmdp_test_and_clear_young(vma, addr, pmdp);
>> +	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
>> +	return young;
>> +}
> 
> Wonder why someone thought it would be a good idea to not include the
> "test_and_", to make the function names inconsistent.

Sounds reasonable. I can send a patch to rename them to:
ptep_test_and_clear_young_notify
pmdp_test_and_clear_young_notify

