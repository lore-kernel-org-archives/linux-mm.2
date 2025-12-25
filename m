Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC82E776FC
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 01:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D59E6B0088; Wed, 24 Dec 2025 20:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D4D6B0089; Wed, 24 Dec 2025 20:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188D86B008A; Wed, 24 Dec 2025 20:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0788B6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 20:01:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5407260615
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:01:55 +0000 (UTC)
X-FDA: 84256191390.27.C3E79CC
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4ED1180007
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:01:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tMLkseGI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766624513; a=rsa-sha256;
	cv=none;
	b=BwDAYQNm6oPRbmVdEjKecUntARXv8zGG8/XpJRYYi+EOrhFyBiB+WI7YbhmfzXnIGP9CFW
	Nlr4gFBGHXUmkGLS06lyBy1NcaJKsRJV6qqRgVMqu9vRUrrCXQQoPvdYufGkMYptrKo6HX
	5VtTsE+iuLnqm/a96y4dMguMmrQ0A1Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tMLkseGI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766624513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fy7EXMdCyEH27NzJMvO2tdqkUATW53yXrUXnni0WAs=;
	b=k/xssVFHukY+gu+15w/3k7st+7+WcKPihDIVL27k9phg+5m5d4r8WQzJIC6VvjSdNVv9dy
	ykpcK4IOxpVi5E8R+Fn5v41Tu7hOslpxgEfh2UCPhSqf3OTMFq7pEp5gqXTOhL8NNgYuDM
	xLV4Iz9f3E1C4SJYNr/vzfilUDVfeGg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766624509; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2fy7EXMdCyEH27NzJMvO2tdqkUATW53yXrUXnni0WAs=;
	b=tMLkseGIapPUs6MMj3V/MMkcUxYOIwiypM8y1icvH/kbDszEtwkkcS6X3on18Q5bE5+DLYWdIiFhxZKZJ7N0QObPwE5AEFzaC5CHnjM0WccDJkwCGwVFSSDusmPvG5m8cxQSOnh/SLT2bfA6ZdcPtI+HXr62x1nD0fOGg8/+to4=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wvci210_1766624507 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Dec 2025 09:01:48 +0800
Message-ID: <43b6ef51-c88f-4b0c-b512-c7195afdd31b@linux.alibaba.com>
Date: Thu, 25 Dec 2025 09:01:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
 <e9ff5fa689740f3b6f3ed1c1ec0e3244f20c1f06.1766455378.git.baolin.wang@linux.alibaba.com>
 <ec49f0fe-9df8-4762-b315-240cbb1ed3ce@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ec49f0fe-9df8-4762-b315-240cbb1ed3ce@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4ED1180007
X-Stat-Signature: o747atqhfqx448yujyr8bq6weryowxp4
X-HE-Tag: 1766624511-248301
X-HE-Meta: U2FsdGVkX1+L9z4VrFSIyKtQWzUNoDmTYKs4kSst3YUDN8u2PYMG1htQK60dYpxglgfMdzSvKeFw1qaCeMxO2IrM7e4oYawlnxiVx8/Qp8sGjnbc8ICa89CxPGp36AREKAdWaK4KRZmb3QvmXDDvBCb810xxWiPra9CUcF6co9nfUvqj1Lw2oJKAJnHgMJ/HD5DTw3YGNUqhfJ7MrSntIz7Hc/eAciq5RGTOf/VReM+kl1+yQpTI2DI4FV2eO3XKyWUvqK2uNUnJueYktC8k2EuDi1/tCLYbi2hBOuqafw3F7nsUMmqhgOaidPE6qQiscuEk7WqkhaFqrmUXVrqzCLE9dscSfEyG1P/3E1dDZdABYUs/ZtvgYIHRmQTVCLsyFGpJFOOK9LPHh/glZjb4jmg/7e6gKczSEZkQggaPm6S7VsjM1IP0JNoT5TjCJgaZGRUyVbMI0uPamaeO/XizNNvnXUzFJaUhBfKHbh8Sk7XNqY6HLowumy9AF51TIGSeuRZ7X1nqgFuuUfLIxFwjfHiEAwPn9kitxPl6e5j81Neuj4voLYVpkV2FdhmllMQV/HNFwD+Xov8nw0BKOBeNGragwXSeSb2XB6OjpSRcykqSNyjBLj8L6slAf+bvortKAe1eWlPCu0NYO+naG1OFwyLQZfgEXzmKED78Z5GQeyw3CGOPnJVd7CRfewoUU6xO2FE9jqNJQYJGiUxjhizt1lm2CFjrRGcmNEsgC1gq0g5j8eJSN4zRgWL9lnS5DUEp4fy42HMVqbSbsu3SwpMYqAVeWTqCDUCb/3gFovqvcMu6udv3HuE+IVZXuxSp7vl1TF6maerfw8JXM0BUSL8IPpjlQUbUtonp8hFXdwN88uF7ot+O5Gucw5vLQ8XdbLymbIQ5/c7V14PxoR70jXGxU04dFLKJVSBuUPQTL5CKnEk/tB2z2ieh7qMHkAQ2ojvEuEWtYzIwIgAKTNvlaBA
 yNRyyvFk
 hY51T4rpjI1lBq86ude8jjakFOk/UqcmumtyHAyFeb1ONVDTbBI68CK7XgM4E8jfR/uxYMGz8eL7OS7E4HyXV/ptfJcbEYhyDCzdZuMlU+eY21PLNYbKDfsPrJh98qAr1hLpzJ2R85Kx7VipGxNSAV6tq8jn6sOa7bYtRfovcC3/PxmIl3oKa51lfrOcXhGkL7ojoK5oEfolSD8+xVMjRHWYwDI5HpMek5Nskt/IQ+uD3IFfGkdheRSQrauDTBPICwEX9KwnG1qRdfmeP05zeKZkVT+bfjrPBCpAkLOsmayXBQg71FKISG2r+UOzBZ+WbPF4Qu/KJhOxCH1RFHnHuseGhZzo8eOd5vvunCkapSHXRSj6Zq0gWLWxJ6cXAvHw/JJXjiqNECYbkmHM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryan,

On 2025/12/24 21:24, Ryan Roberts wrote:
> On 23/12/2025 05:48, Baolin Wang wrote:
>> Currently, folio_referenced_one() always checks the young flag for each PTE
>> sequentially, which is inefficient for large folios. This inefficiency is
>> especially noticeable when reclaiming clean file-backed large folios, where
>> folio_referenced() is observed as a significant performance hotspot.
>>
>> Moreover, on Arm64 architecture, which supports contiguous PTEs, there is already
>> an optimization to clear the young flags for PTEs within a contiguous range.
>> However, this is not sufficient. We can extend this to perform batched operations
>> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
>>
>> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
>> of the young flags and flushing TLB entries, thereby improving performance
>> during large folio reclamation. And it will be overridden by the architecture
>> that implements a more efficient batch operation in the following patches.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> With the 2 niggles below addressed:
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

Thanks.

>> ---
>>   include/linux/mmu_notifier.h |  9 +++++----
>>   include/linux/pgtable.h      | 35 +++++++++++++++++++++++++++++++++++
>>   mm/rmap.c                    | 29 +++++++++++++++++++++++++++--
>>   3 files changed, 67 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index d1094c2d5fb6..dbbdcef4abf1 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>   	range->owner = owner;
>>   }
>>   
>> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
>> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
> 
> I think I previously suggested that this should be renamed to
> clear_flush_young_ptes_notify() given that it is now a batch operation. Were
> others against that or did you forget?

Sorry, I missed this comment. Yes, sounds reasonable to me. Will do in 
the next version.

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
>> +						  ___nr * PAGE_SIZE);	\
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
>> index 2f0dd3a4ace1..fcf7a7820061 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -1087,6 +1087,41 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>   }
>>   #endif
>>   
>> +#ifndef clear_flush_young_ptes
>> +/**
>> + * clear_flush_young_ptes - Clear the access bit and perform a TLB flush for PTEs
>> + *			    that map consecutive pages of the same folio.
>> + * @vma: The virtual memory area the pages are mapped into.
>> + * @addr: Address the first page is mapped at.
>> + * @ptep: Page table pointer for the first entry.
>> + * @nr: Number of entries to clear access bit.
>> + *
>> + * May be overridden by the architecture; otherwise, implemented as a simple
>> + * loop over ptep_clear_flush_young().
>> + *
>> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
>> + * some PTEs might be write-protected.
>> + *
>> + * Context: The caller holds the page table lock.  The PTEs map consecutive
>> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
>> + */
>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +					 unsigned long addr, pte_t *ptep,
>> +					 unsigned int nr)
>> +{
>> +	int young;
>> +
>> +	young = ptep_clear_flush_young(vma, addr, ptep);
>> +	while (--nr) {
>> +		ptep++;
>> +		addr += PAGE_SIZE;
>> +		young |= ptep_clear_flush_young(vma, addr, ptep);
>> +	}
> 
> I think it's better to avoid the two ptep_clear_flush_young() calls if we can.
> Personally I think we should just go for the simple:
> 
> 	for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
> 		young |= ptep_clear_flush_young(vma, addr, ptep);

ACK. Thanks for reviewing.

