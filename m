Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E961E78D74
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C78F6B0005; Mon,  9 Feb 2026 04:25:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575666B0088; Mon,  9 Feb 2026 04:25:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4811B6B0089; Mon,  9 Feb 2026 04:25:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 346BE6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:25:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6CB75A78C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:25:43 +0000 (UTC)
X-FDA: 84424385766.06.CCF8B6F
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf05.hostedemail.com (Postfix) with ESMTP id 00D4B10000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:25:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=O3DmQUvK;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770629142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iospfJfgnCbZaQYzfaA2tvvmLSeoePlQ9WvdImbWy2c=;
	b=Bza+AWOhKuFkpn0TMF3GlndFeCRvcjYSpefg1dJ6BmUfe28ISEravLpJtwJe2xcsyevqSN
	7KGpVsSkRyGWxW8CbG47yBHjdxoELjRpLbku8C0zfxvf9xSzuX0fAj7+4ojnFa5z9YggeR
	mJVZJ4KqmOg7gfGnJ7O/6n0bl2Pj+DA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770629142; a=rsa-sha256;
	cv=none;
	b=g5eKKCwTTfIOBh0yBKk+YkcMN4CW8/zzUIuA2QaF6qwiKNUuFYNBqVZR+isDyi6bDy2+wt
	7wFw6J28gziTOn7PPZw9GAt6Vgm5x4TzXAjIF7tSOYHi5OzMZUMvqSV9MQziNoh3UiJj4Y
	EUiPkcJ4maLd1i25GpAteJ/CW2GjYXg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=O3DmQUvK;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770629135; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iospfJfgnCbZaQYzfaA2tvvmLSeoePlQ9WvdImbWy2c=;
	b=O3DmQUvKZqYKeBI5/v1ErPj/ru11mpK/egFtZT3MScyplbVD7DcfXYqEcKqgvKvCI3h7NJ/d3KKL3IENKyKBvnhMXvPxvZiQ/VUJqfbfCY5tIYQBHCH56D2Hj3+gYjB9foDPs3n8TRw2AbRMhHYGKZ3oV1DXepGuMQ/69iJK6h8=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyqDuq3_1770629133 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 17:25:34 +0800
Message-ID: <f21ee001-91b5-4047-8e45-6e2ef320bcdf@linux.alibaba.com>
Date: Mon, 9 Feb 2026 17:25:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] mm: rmap: support batched checks of the references
 for large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
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
 <b86bfd4e-302c-4152-8dfd-41f67515b71d@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <b86bfd4e-302c-4152-8dfd-41f67515b71d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 00D4B10000A
X-Stat-Signature: 4pqoosxcrcmyjxzn8ufmfkhteorca633
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770629140-525645
X-HE-Meta: U2FsdGVkX18moUnKLCKGkcFe0TNsaQ0q8NCwtFniZIQ8hbD34yG20jy/SvG2x3T8eKtR4FPrs9dd0BfegNolj0cgLouRf0O4Jw7ATKtnNOE4Yr1hJsRxnHSxLQevvnDNheh+RqXtZHF9WQ7/tFwV6s2XyMzwNSd/AXGP6cj7f7R9PIlCtIAjvbCZUD10OOlWBATcr1Yk1qRoR7oZE9sx5vcyqRpFU0Nfjgpp+wk0IsuA5QT0sCzDO2Ec89/eRKv3nfYgrE8b9G2LxGI0CogOVfw1t5dPbygfUTT3Tp/pqsxmeqqaQ1wc4xzkS97zhe7BEzgknAI92/o1cYJ5z55bFrIHWLIF8fe3/daHK+MVoSTHXQ3pu0L211NN1BvCL+Di2lHdD1p3r7WNGL0cw9fcX43HnwF2rkgfbu2vl7bfhgZVuv1rMOV4TrqrsjbQJ2rB3UqMQjKGREZeTMYtglfjACbGm/xNSzp+dRd+90uHnohkUsUd3sCl8pgyU4kIGsXKvL53q4czAmG6/bc75GI/fdNDxWig5xOSlm5Zox5NxjB1g3xTDfcS2i2pP8Hy84zTGrlS+n//lRT8mcvbE1QJFrLRYVbWK2uTVhs9XBzaFB1wAKGb6vnQ0OYN5hCGos7M8UaEpXK4Gqm3uUXkqnTwogvxhZ03RUbMTQMv/XM62FmYvdfahrEI/fbs7U75HlVO2sCUfyt8NGm10kKxjvEp4CMCvtBd6Q/xTupDti8A3y2P4xsKkXk4jUaYNKg+wW1AJeRYjPsg1eFVFoec0LREpqReUndUyXxz/K8qVlcDNkg69t/u79uQEX0AbEP2Bh7f6TAEUWfWvvKRePMguyQK+lLaXB3ec/zCD7hsvL5/lF4az+mEcA3S66rcSrW9ord6TsDv65eqVSk/9RnN6nYk9s1j4Xp4Y4BLt22Jjy1z6jNfVmWGopfKVdBVBSMg1XuvOREuWCwb598Dz5F4mnV
 EmHh7dfi
 d7mmkyeSUTjyNiyq9+MN+lVlZFqQzRboAx5c3rlRR7V46mFn2L/UJr8YqQzHH4WXkM3hGSsB+PpYJvwKnshiBEuIJyCFePqG+xYkdj1iKCysXC9RncJkBlX8Nycd/IyqjHriELYa6AFBGSzQVuNuZvUE/ixA0u1mRZAzcj3N/CxC5M+nz25Bwoo0eCzYbvBwLYA2ok/YsnpRciO5/KeqPZtpQQ+rqjRwwj7ig/Fu5eq6lTdklMi2gynE6r7ea5aYvWM5WUgGvqVevGbm0PPNmpMzPdOhZNZRdRCuLQfuwK9SL7G6gOVq30OaTDJ5PHSrnCWpER27htZrF8XiMxCNhCjncXaGp1yiEAZIBECj2LN1O8VKDSp/stNMtwnLorYSFM5wFjzlXyBavhN8yFdnaRPjX3/tvTbS8nGNy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/9/26 5:20 PM, David Hildenbrand (Arm) wrote:
> On 2/9/26 10:14, Baolin Wang wrote:
>>
>>
>> On 2/9/26 4:49 PM, David Hildenbrand (Arm) wrote:
>>> On 12/26/25 07:07, Baolin Wang wrote:
>>>> Currently, folio_referenced_one() always checks the young flag for 
>>>> each PTE
>>>> sequentially, which is inefficient for large folios. This 
>>>> inefficiency is
>>>> especially noticeable when reclaiming clean file-backed large 
>>>> folios, where
>>>> folio_referenced() is observed as a significant performance hotspot.
>>>>
>>>> Moreover, on Arm64 architecture, which supports contiguous PTEs, 
>>>> there is already
>>>> an optimization to clear the young flags for PTEs within a 
>>>> contiguous range.
>>>> However, this is not sufficient. We can extend this to perform 
>>>> batched operations
>>>> for the entire large folio (which might exceed the contiguous range: 
>>>> CONT_PTE_SIZE).
>>>>
>>>> Introduce a new API: clear_flush_young_ptes() to facilitate batched 
>>>> checking
>>>> of the young flags and flushing TLB entries, thereby improving 
>>>> performance
>>>> during large folio reclamation. And it will be overridden by the 
>>>> architecture
>>>> that implements a more efficient batch operation in the following 
>>>> patches.
>>>>
>>>> While we are at it, rename ptep_clear_flush_young_notify() to
>>>> clear_flush_young_ptes_notify() to indicate that this is a batch 
>>>> operation.
>>>>
>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>   include/linux/mmu_notifier.h |  9 +++++----
>>>>   include/linux/pgtable.h      | 31 +++++++++++++++++++++++++++++++
>>>>   mm/rmap.c                    | 31 ++++++++++++++++++++++++++++---
>>>>   3 files changed, 64 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/include/linux/mmu_notifier.h b/include/linux/ 
>>>> mmu_notifier.h
>>>> index d1094c2d5fb6..07a2bbaf86e9 100644
>>>> --- a/include/linux/mmu_notifier.h
>>>> +++ b/include/linux/mmu_notifier.h
>>>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>>>       range->owner = owner;
>>>>   }
>>>> -#define ptep_clear_flush_young_notify(__vma, __address, 
>>>> __ptep)        \
>>>> +#define clear_flush_young_ptes_notify(__vma, __address, __ptep, 
>>>> __nr)    \
>>>>   ({                                    \
>>>>       int __young;                            \
>>>>       struct vm_area_struct *___vma = __vma;                \
>>>>       unsigned long ___address = __address;                \
>>>> -    __young = ptep_clear_flush_young(___vma, ___address, __ptep);    \
>>>> +    unsigned int ___nr = __nr;                    \
>>>> +    __young = clear_flush_young_ptes(___vma, ___address, __ptep, 
>>>> ___nr);    \
>>>>       __young |= mmu_notifier_clear_flush_young(___vma->vm_mm,    \
>>>>                             ___address,        \
>>>>                             ___address +        \
>>>> -                            PAGE_SIZE);    \
>>>> +                          ___nr * PAGE_SIZE);    \
>>>>       __young;                            \
>>>>   })
>>>
>>> Man that's ugly, Not your fault, but can this possibly be turned into 
>>> an inline function in a follow-up patch.
>>
>> Yes, the cleanup of these macros is already in my follow-up patch set.
>>
>>>> +#ifndef clear_flush_young_ptes
>>>> +/**
>>>> + * clear_flush_young_ptes - Clear the access bit and perform a TLB 
>>>> flush for PTEs
>>>> + *                that map consecutive pages of the same folio.
>>>
>>> With clear_young_dirty_ptes() description in mind, this should 
>>> probably be "Mark PTEs that map consecutive pages of the same folio 
>>> as clean and flush the TLB" ?
>>
>> IMO, “clean” is confusing here, as it sounds like clear the dirty bit 
>> to make the folio clean.
> 
> "as old", sorry, I used the wrong part of the description.

OK.

>>>> + * @vma: The virtual memory area the pages are mapped into.
>>>> + * @addr: Address the first page is mapped at.
>>>> + * @ptep: Page table pointer for the first entry.
>>>> + * @nr: Number of entries to clear access bit.
>>>> + *
>>>> + * May be overridden by the architecture; otherwise, implemented as 
>>>> a simple
>>>> + * loop over ptep_clear_flush_young().
>>>> + *
>>>> + * Note that PTE bits in the PTE range besides the PFN can differ. 
>>>> For example,
>>>> + * some PTEs might be write-protected.
>>>> + *
>>>> + * Context: The caller holds the page table lock.  The PTEs map 
>>>> consecutive
>>>> + * pages that belong to the same folio.  The PTEs are all in the 
>>>> same PMD.
>>>> + */
>>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>>> +                     unsigned long addr, pte_t *ptep,
>>>> +                     unsigned int nr)
>>>
>>> Two-tab alignment on second+ line like all similar functions here.
>>
>> Sure.
>>
>>>> +{
>>>> +    int i, young = 0;
>>>> +
>>>> +    for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
>>>> +        young |= ptep_clear_flush_young(vma, addr, ptep);
>>>> +
>>>
>>> Why don't we use a similar loop we use in clear_young_dirty_ptes() or 
>>> clear_full_ptes() etc? It's not only consistent but also optimizes 
>>> out the first check for nr.
>>> for (;;) {
>>>      young |= ptep_clear_flush_young(vma, addr, ptep);
>>>      if (--nr == 0)
>>>          break;
>>>      ptep++;
>>>      addr += PAGE_SIZE;
>>> }
>>
>> We’ve discussed this loop pattern before [1], and it seems that people 
>> prefer the ‘for (;;)’ loop. Do you have a strong preference for 
>> changing it back?
> 
> Yes, to make all such helpers look consistent. Note that your version 
> was also not consistent with the other variants.
> 
> Ryans point was about avoiding two ptep_clear_flush_young() calls, which 
> the for(;;) avoids as well.

Actually my v2[1] is following the previous pattern, anyway let me 
change it back.

[1] 
https://lore.kernel.org/all/545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com/

