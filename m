Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9451CFC9EC0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 02:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201736B0005; Fri,  6 Mar 2026 21:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185366B0089; Fri,  6 Mar 2026 21:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0913D6B008A; Fri,  6 Mar 2026 21:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E91866B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:33:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F0BD1A07A6
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:33:07 +0000 (UTC)
X-FDA: 84517694814.02.382C974
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34DEC140004
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:33:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PZ7LGPjA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772850785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6brpWh0agx2nPIas22wWd/mLtb7xMp58wMN9DhKRy4=;
	b=MNEqWKA9Kn7RMt3XIeyAlUgKUaRlCTMyzeVRZ9SneM9bl8goO9E+UrBUIUboMbEHli+gG4
	Fg6y3jJ9lAZQ3Y7UkwhHoJSqzYodnEM4VjrYOFg4woMbJmNSH5U+P3mrYsYHucHPfIYanN
	tDvUXjBHs42ceHMOqXniJh1QyphAcus=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PZ7LGPjA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772850785; a=rsa-sha256;
	cv=none;
	b=XRPazvvsC5XZAw+GXub4VscYEzE/5GcBPbs8ZPRb12w+QV6kQuDKG3/qzvrzMeN9f9Nyzo
	AO/DN8x9R8MiPZWhNCTnyAV3yKijT1VSAUTIA5LPGUww8VEz8WwfUiyK5gJTwkDuzhSkIs
	fnStB/e/FVr3+1dhGfZ4tivKWSpu7Mw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772850173; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=f6brpWh0agx2nPIas22wWd/mLtb7xMp58wMN9DhKRy4=;
	b=PZ7LGPjAICATEby002B0dSYzJHZ5gW1jEniQyRltlyJxwjq9dyviQ2/hQ5L/vLgHhBiBICjJZSR5s0HH0TgetKyy7o1knn2bbCaAroL0XYRxLZXU9YdBxf9f3SlNmXCSfq75appJF9hnT8k2fXWkdTtHTJoVipFwAcrDn3LCdxA=
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-OZDWt_1772850172 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Mar 2026 10:22:52 +0800
Message-ID: <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
Date: Sat, 7 Mar 2026 10:22:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 34DEC140004
X-Stat-Signature: yqtrckw5jaqi15rbknhp6psupzt8z3wa
X-Rspam-User: 
X-HE-Tag: 1772850783-879905
X-HE-Meta: U2FsdGVkX1/cb+A4Eiatd++MjO0ZjXv8yj9l8JxhN2TrnR/75IC+nCQMud9IuG2Ad29YIRd9Kt2vTySUa9rraN1u76pSlkPHXj5U4RBI1LEjObHUdpTqacQUwZYNheL9jyJkBKGNueBjkQtiZDRsIRqTlKrTgO8Pn6CCc/yvGrBzBqacRwg/RiqlNc7/Jib9g9igDqt8O0Cz8zo1hZs7Qz/WZkQ9+mCPXzlw5xe7rTuIlbz54Rr/HTWdCcm6C4RwwA/zSUaKbIW5TL6O3EqbJQIB6pB+Hq61GIcJMshZdMYQ1mA3AUuzzaxo0ws1GdO3/MjNwtMq8Z0s0ti16u0vE4BBQBI/V+FK135UW2XkQi100R20QapITBofmFGc6ZzPyFZIvZyfyZlWSpD2zX28zw+q/vHxnnU8Rel2CbA6xJeOZifgxDLNKtZx/GLUktyUnPikfHZ0fSjDsQgdvZkTS/fIKl/HWNB1BDcssFOsqCVR8ZanpR7xoW8xx9dZxwh4fSB35b9wJTG55XCWBScOiKWWYU7cqQrDe8XVU3uEwG/Zdwc/SDxkFcVRSvoL/nWtoVkvIJKKi4tYv0B6kCfB7c+EtflWDpAE3qOtOanTcvhk6B9zQpL2KGSEKgEhQUee3PWiPZvOwaS+PpZfbwSDR6om4wOsxww974nOt2dxXocpYTvB1CyoykZZETXK38rgn8q9hqXndFj/vRMhgDDqITT2dssMEsVmWk6FUEjn8nBIaidEGsFY0/94FmnBck/v6bwg5bYRUGkPLTA1qHdCNz4nxKzFXL5PaW5oIleorHaD4Eu0ER/vxXJKA28lI3hAVOwJtxFZCRTrVjnL7ZY55bTK1jx1bWTuMX4Efl0Cn1CpupbbzcCG6niChJyZGgYD3qyHNJQZSEicU+JmRseaKrChHngTQIrLlrOIzWYfhZl/LOubJtOxEiYI8i/YnQiH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/7/26 5:07 AM, Barry Song wrote:
> On Mon, Feb 9, 2026 at 10:07 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
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
>> While we are at it, rename ptep_clear_flush_young_notify() to
>> clear_flush_young_ptes_notify() to indicate that this is a batch operation.
>>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> LGTM,
> 
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks.

>> ---
>>   include/linux/mmu_notifier.h |  9 +++++----
>>   include/linux/pgtable.h      | 35 +++++++++++++++++++++++++++++++++++
>>   mm/rmap.c                    | 28 +++++++++++++++++++++++++---
>>   3 files changed, 65 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index d1094c2d5fb6..07a2bbaf86e9 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>          range->owner = owner;
>>   }
>>
>> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)                \
>> +#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)  \
>>   ({                                                                     \
>>          int __young;                                                    \
>>          struct vm_area_struct *___vma = __vma;                          \
>>          unsigned long ___address = __address;                           \
>> -       __young = ptep_clear_flush_young(___vma, ___address, __ptep);   \
>> +       unsigned int ___nr = __nr;                                      \
>> +       __young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);    \
>>          __young |= mmu_notifier_clear_flush_young(___vma->vm_mm,        \
>>                                                    ___address,           \
>>                                                    ___address +          \
>> -                                                       PAGE_SIZE);     \
>> +                                                 ___nr * PAGE_SIZE);   \
>>          __young;                                                        \
>>   })
>>
>> @@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>>
>>   #define mmu_notifier_range_update_to_read_only(r) false
>>
>> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
>> +#define clear_flush_young_ptes_notify clear_flush_young_ptes
>>   #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>>   #define ptep_clear_young_notify ptep_test_and_clear_young
>>   #define pmdp_clear_young_notify pmdp_test_and_clear_young
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 21b67d937555..a50df42a893f 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -1068,6 +1068,41 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>   }
>>   #endif
>>
>> +#ifndef clear_flush_young_ptes
>> +/**
>> + * clear_flush_young_ptes - Mark PTEs that map consecutive pages of the same
>> + *                         folio as old and flush the TLB.
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
>> +               unsigned long addr, pte_t *ptep, unsigned int nr)
>> +{
>> +       int young = 0;
>> +
>> +       for (;;) {
>> +               young |= ptep_clear_flush_young(vma, addr, ptep);
>> +               if (--nr == 0)
>> +                       break;
>> +               ptep++;
>> +               addr += PAGE_SIZE;
>> +       }
>> +
>> +       return young;
>> +}
>> +#endif
> 
> We might have an opportunity to batch the TLB synchronization,
> using flush_tlb_range() instead of calling flush_tlb_page()
> one by one. Not sure the benefit would be significant though,
> especially if only one entry among nr has the young bit set.

Yes. In addition, this will involve many architectures’ implementations 
and their differing TLB flush mechanisms, so it’s difficult to make a 
reasonable per-architecture measurement. If any architecture has a more 
efficient flush method, I’d prefer to implement an architecture‑specific 
clear_flush_young_ptes().

