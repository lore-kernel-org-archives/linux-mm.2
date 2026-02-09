Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71865E78D6F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76D46B0005; Mon,  9 Feb 2026 04:20:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58086B0088; Mon,  9 Feb 2026 04:20:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A816B0089; Mon,  9 Feb 2026 04:20:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 831966B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:20:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C30001B33A3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:20:38 +0000 (UTC)
X-FDA: 84424372956.14.28EE87F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42AFF40003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRu7ByVK;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770628837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k97W7kYgKafjPkdnv9KkGY6BPnV+S9ibALMBwWuDm7s=;
	b=gyf94fbmXdRXHh3aO50x+unylyfoLzIL2lKp/oD3tpDaPJ9ZylbNR9OWDuSg3w3TCwJ2xU
	J9nmadz1eVHxbqXWVcHasoaHkx0WXKtHXaYTtP3uOWDp/Qx3Ga74DlIU6kgx7Larjzm70N
	rOv8qfxB7zUWhyuyf6sHpzkExKvQnDQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRu7ByVK;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770628837; a=rsa-sha256;
	cv=none;
	b=zwujnXSqSDy5TM0F3wBqju8g7qvaLAH9c30bQZOM0IUAFkcV7RV4jw+XLcy8DBaOMsx3sP
	R7+e79iIBNbbWDJElm1g6I1RjDeJIBvWsHoQMIy+G8eNbxLfeQ3jqUHcmWrUwqur0UuJw3
	edpCCFHJuggUvbojqw8+hZ4hzJRUVG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 829DC600B0;
	Mon,  9 Feb 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3835EC116C6;
	Mon,  9 Feb 2026 09:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770628836;
	bh=YOwWSoeB9IFLBV0QEE3Nf3YjGyMCC+nrtfbMU+GozAc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sRu7ByVKlrWjDKFlIeI2mLe4rUg9E10YvdBSEN40HroBGLPzXYbtVHUUYqR8YJHwM
	 ugu2K2NITLipAfmOWmifPnC6nIf3vIq5vwy7nmRZNwFLbs1lBWVY5cUSMiBEtUINWd
	 U/RTc7hf6OWw6uFYp6aM31fGk0aTKxKr2ChhPWAz/0hH4LNbAFZ4u7MSzStDNZMIJj
	 E/g8TUa9cK5wojTbIemP25pgkkiQ5dbvYBWhh7AHNQECJIDlA/xTcmSFVIdMM3/+16
	 j+XtNukX9YpWi7DwyWcTFkjRT/GUXZVs+oNzr6neIf8J+g2QYLcNf5tVekRWbYAwKD
	 8TnnROa1T61/Q==
Message-ID: <b86bfd4e-302c-4152-8dfd-41f67515b71d@kernel.org>
Date: Mon, 9 Feb 2026 10:20:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <18b3eb9c730d16756e5d23c7be22efe2f6219911.1766631066.git.baolin.wang@linux.alibaba.com>
 <3d5cb9a4-6604-4302-a110-3d8ff91baa56@kernel.org>
 <44453a4c-50a2-4e7e-9d2a-ebf973ccf6b7@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <44453a4c-50a2-4e7e-9d2a-ebf973ccf6b7@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: npn8wfrwywxkbmnehckwxoxhgzymo5m9
X-Rspamd-Queue-Id: 42AFF40003
X-Rspam-User: 
X-HE-Tag: 1770628837-159795
X-HE-Meta: U2FsdGVkX1/6aNk4DDVA/SXCRP72ST18vI14VQ2CaPwS6/cqsOmqpBrnwct7v1HyHo3SC76SK/BMRkMDs6sn1eH0z8Z0OzJyVGHD55ztcU2t16iUYk4fqXtck8y8AhsSM8w/aUlDR6c0t4KuDW3NjdcHrI60P9lIeYukXKFx/PYwG/DdwqvLl7pF+dZmk3TRxxeD4A2ojek9K3IMJ8y3hMjx67trMmxmpZmfnqev/71kYouIQpQVJlo8w9cFnoOUVqzWoIcHB7+YPy9bGCIaahAcwbJl+UTuzTgfbKaFjaJDVGsqB1BS557STe0NJ+Dyk5L2Ck8uV2lgh9nhZy6z5lFh7XWGoZGPknnRG1FA3Bxp/n7p3362WBFXIVIf5oILG9ocsdjsqxX2cXubH9ZNZn90a9SXQXW6ScElZxhztIzsaK9wWG2eZQPOY3H2KUUyWyKPsIMk8zVt4tKfJU9sKqYjpu5sTSVEQvqTg+xDV1DGw8FDBvg48uSkf4UIMQ7vj43gmhVUBvwvmYdlVjJHrdK6Lh9LPYQbl7wzDfRHcbZSrSqKE/uWKbo+MRqG30nixzig7h69TIp9SXoYqAKf8WorARv17OKGYsOlJqSo1gpwl9MUuS/ocJ231Moud1Fk08iXqvGneOtgu+hKvWLICW5pETNEJ25YmMS25K9RG5JEolXeSXAra4mFDGKHR5v1EaGyissYqXhlwixeIXJhhKsUW02NSnLTEJQcmegJRnmAV2th2NC9OyLiDHJncPmgZkM9G5M7qY4j9MvDqgdeDHIRVly9JTi3HVgvJZpAWFfY9affqjKuGGLVoqla6QR4cqqadC320JV4TIg+dMLMcLhmlynHY+wLN9pOYQENGAeQq2c7NBqQbATKqz5qh5mPPd2pg0rxQZ1oziuBrgYXgQEWFiDlC3tupQUms8Lpv8audxiCMmmTRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 10:14, Baolin Wang wrote:
> 
> 
> On 2/9/26 4:49 PM, David Hildenbrand (Arm) wrote:
>> On 12/26/25 07:07, Baolin Wang wrote:
>>> Currently, folio_referenced_one() always checks the young flag for 
>>> each PTE
>>> sequentially, which is inefficient for large folios. This 
>>> inefficiency is
>>> especially noticeable when reclaiming clean file-backed large folios, 
>>> where
>>> folio_referenced() is observed as a significant performance hotspot.
>>>
>>> Moreover, on Arm64 architecture, which supports contiguous PTEs, 
>>> there is already
>>> an optimization to clear the young flags for PTEs within a contiguous 
>>> range.
>>> However, this is not sufficient. We can extend this to perform 
>>> batched operations
>>> for the entire large folio (which might exceed the contiguous range: 
>>> CONT_PTE_SIZE).
>>>
>>> Introduce a new API: clear_flush_young_ptes() to facilitate batched 
>>> checking
>>> of the young flags and flushing TLB entries, thereby improving 
>>> performance
>>> during large folio reclamation. And it will be overridden by the 
>>> architecture
>>> that implements a more efficient batch operation in the following 
>>> patches.
>>>
>>> While we are at it, rename ptep_clear_flush_young_notify() to
>>> clear_flush_young_ptes_notify() to indicate that this is a batch 
>>> operation.
>>>
>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   include/linux/mmu_notifier.h |  9 +++++----
>>>   include/linux/pgtable.h      | 31 +++++++++++++++++++++++++++++++
>>>   mm/rmap.c                    | 31 ++++++++++++++++++++++++++++---
>>>   3 files changed, 64 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>>> index d1094c2d5fb6..07a2bbaf86e9 100644
>>> --- a/include/linux/mmu_notifier.h
>>> +++ b/include/linux/mmu_notifier.h
>>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>>       range->owner = owner;
>>>   }
>>> -#define ptep_clear_flush_young_notify(__vma, __address, 
>>> __ptep)        \
>>> +#define clear_flush_young_ptes_notify(__vma, __address, __ptep, 
>>> __nr)    \
>>>   ({                                    \
>>>       int __young;                            \
>>>       struct vm_area_struct *___vma = __vma;                \
>>>       unsigned long ___address = __address;                \
>>> -    __young = ptep_clear_flush_young(___vma, ___address, __ptep);    \
>>> +    unsigned int ___nr = __nr;                    \
>>> +    __young = clear_flush_young_ptes(___vma, ___address, __ptep, 
>>> ___nr);    \
>>>       __young |= mmu_notifier_clear_flush_young(___vma->vm_mm,    \
>>>                             ___address,        \
>>>                             ___address +        \
>>> -                            PAGE_SIZE);    \
>>> +                          ___nr * PAGE_SIZE);    \
>>>       __young;                            \
>>>   })
>>
>> Man that's ugly, Not your fault, but can this possibly be turned into 
>> an inline function in a follow-up patch.
> 
> Yes, the cleanup of these macros is already in my follow-up patch set.
> 
>>> +#ifndef clear_flush_young_ptes
>>> +/**
>>> + * clear_flush_young_ptes - Clear the access bit and perform a TLB 
>>> flush for PTEs
>>> + *                that map consecutive pages of the same folio.
>>
>> With clear_young_dirty_ptes() description in mind, this should 
>> probably be "Mark PTEs that map consecutive pages of the same folio as 
>> clean and flush the TLB" ?
> 
> IMO, “clean” is confusing here, as it sounds like clear the dirty bit to 
> make the folio clean.

"as old", sorry, I used the wrong part of the description.

> 
>>> + * @vma: The virtual memory area the pages are mapped into.
>>> + * @addr: Address the first page is mapped at.
>>> + * @ptep: Page table pointer for the first entry.
>>> + * @nr: Number of entries to clear access bit.
>>> + *
>>> + * May be overridden by the architecture; otherwise, implemented as 
>>> a simple
>>> + * loop over ptep_clear_flush_young().
>>> + *
>>> + * Note that PTE bits in the PTE range besides the PFN can differ. 
>>> For example,
>>> + * some PTEs might be write-protected.
>>> + *
>>> + * Context: The caller holds the page table lock.  The PTEs map 
>>> consecutive
>>> + * pages that belong to the same folio.  The PTEs are all in the 
>>> same PMD.
>>> + */
>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>> +                     unsigned long addr, pte_t *ptep,
>>> +                     unsigned int nr)
>>
>> Two-tab alignment on second+ line like all similar functions here.
> 
> Sure.
> 
>>> +{
>>> +    int i, young = 0;
>>> +
>>> +    for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
>>> +        young |= ptep_clear_flush_young(vma, addr, ptep);
>>> +
>>
>> Why don't we use a similar loop we use in clear_young_dirty_ptes() or 
>> clear_full_ptes() etc? It's not only consistent but also optimizes out 
>> the first check for nr.
>> for (;;) {
>>      young |= ptep_clear_flush_young(vma, addr, ptep);
>>      if (--nr == 0)
>>          break;
>>      ptep++;
>>      addr += PAGE_SIZE;
>> }
> 
> We’ve discussed this loop pattern before [1], and it seems that people 
> prefer the ‘for (;;)’ loop. Do you have a strong preference for changing 
> it back?

Yes, to make all such helpers look consistent. Note that your version 
was also not consistent with the other variants.

Ryans point was about avoiding two ptep_clear_flush_young() calls, which 
the for(;;) avoids as well.

[...]

>>
>> And you will not have to mess with the "ptes" variable?
> 
> We can't rely on pra->mapcount here, because a folio can be mapped in 
> multiple VMAs. Even if the pra->mapcount is not zero, we can still call 
> page_vma_mapped_walk_done() for the current VMA mapping when the entire 
> folio is batched.

You are absolutely right for folios that are mapped into multiple processes.

-- 
Cheers,

David

