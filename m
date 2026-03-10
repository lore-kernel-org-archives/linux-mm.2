Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB46FCC9A5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96CC6B0005; Mon,  9 Mar 2026 21:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44B76B0088; Mon,  9 Mar 2026 21:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72266B0089; Mon,  9 Mar 2026 21:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97BD46B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:38:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A9CC1C2D3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:38:05 +0000 (UTC)
X-FDA: 84528442530.02.40E428C
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2E47CA0007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:38:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uYKz3pjt;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773106683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhrc2zSy815zRqLDWu0GrGfLpE+YR1s6BVi+lBVNCR0=;
	b=wCi2klYWZ2nhgHRZbfRJeFHnowUiSYJvOQYahmxtq1ghH4U9rDGllSMM8rUcfenY0yo/vH
	JOdtt/lOquzxhTj5HfLsufJvQ1/CpO4HbZg+j80Wqtll0H/7ilhq/Blj7VT4IBpD2Qhtco
	/Jf0a3xvbXieMACZHAFCpDHQCZ5igcw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773106683; a=rsa-sha256;
	cv=none;
	b=UIGmck4CFV0DffqroOZievlD33CS6g6mAqA/xcDCV90vh8J94zoDPtRElZFqueTV4iC8B0
	tFNaKIKyd6B8gbv6u+HUoog+0Ag8eh9omXPx3k+MkNq9qhB0amtmpaPCsrlyEEbrwQttBJ
	ojSZ35Dgaa494xRuxsm+IDm1/bmocqQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uYKz3pjt;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773106678; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mhrc2zSy815zRqLDWu0GrGfLpE+YR1s6BVi+lBVNCR0=;
	b=uYKz3pjts0AQKVevUsR5Blk+N2g791lviMTe1khW8wfMFKNDc5au7EULX5JSk94/IXHHiqGxXZwiD7Dx3CVokS3HfmWRdF2mQfoTqudnXwtSHEdnahnAUL0ghAaF+d4sV7hCX+WvxRs9EXfw7H9YgER5VECqJyr1bJT5P/hSq1s=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-e6KrH_1773106676 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Mar 2026 09:37:56 +0800
Message-ID: <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
Date: Tue, 10 Mar 2026 09:37:55 +0800
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
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ycgf8tmysaw81ga8kh8gk77bcw7icif6
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E47CA0007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773106681-42814
X-HE-Meta: U2FsdGVkX1+v3wrNOwiWwmK28dYn7CoaO9wmtdweZW3fWXvh9f1AaBSC/WjujmXqvXtqXdFnvER3H4oaOiPd1JlqrwBbb48izPDBT9FqXfOjpbJagEqB9tlRObvDBJCDS4jwPprKZA3HFZAlxLuVGTQC6g08fxfjurV5q60HAzLq66ARemt7l6r3jLEjGiXRnLm3xTJSSkfLYBIuzvSPKYjLhf+Z42sofGz1KLczDNwRntdrpU1iMwOzKVrDzxOddWFnuy2SEDRZ5DZO8Mf77zNq4WcFzn2gjNvKwEhX8Q4pV9ju7MxWVxIksnQeTHDuqCVywbu7v2h0oXT9nUunfV0eVu7edl7L1YL8Cn/TR2hqrOyjhoMvYMGId3biHhPcpcLp1PFCWEkeBF9j41ZsK8r0grKVVtulclxMhnZxaEXW0uaDg5o3nqGIUwoNjydKEgpdHq4j+QW7ckLq/qyaxFJYkPSqwRYy5Zbndhqe22NA1+02n1qCUmoKLMEAqA4J5Pf9K8RkApKFCdUuLidT/Su/nWmBBNX7xZyM+/K3Ma/KrY5BSfjHZ6iK/UJavpM1meRXJuIRhuQymqCbl8QDj9fONAd+IGBnNVJO2Q5Txmd6wmNgwSuncCkshkBGNENneeWcR2k0XpVAGp5ncTMkXQgLkv/UNke2+GsR92o470LIyjlWTSyu0b4RZXoF3HnnCaboj3XWI565vPpQWykfUBGZ4KS+pNjisCzv72ahDvp2P2lzqiNaP7mQfeCpYcxcu3nplIlUx1M0RUouSMoirEK9yvwJWowxJhPCzjkP6qC3jbLueeWCslzuQvsohXSS6TQGPZjvEmIM9Q4NDVfaZwysdb5kdkJ8SPssZzEjbcUTJCQnrK0XzeTDtAxecx1DMgDmy2nEO4zHh7gD6OfYP9wcXAanVKyqsgJFG72t6cwjIsNNt7bz+IvZ8+vp2cPzQIepPy50exWhSyqaKRn
 8ewTx2de
 ZcJuRQACWB+9PwFS6wfyulWai1EcoXC0umJVNzloFwcgAouYHXGWtPZpc1KG65NL9qY9J3nsJl9W+I3Go42E90Oemv7wnr9S1RIAfPhIGIcOBcD85CGR9O2dNoxVHM3iM6JPutqXVACEJ5V48ujwcUMEaD6/zFM50qbReTwiB5hMnFcyeIQ5EVFFIrfdP3DtXsX5LJyk6M/IwVeo5iS+/EwqftpXI4aJq4xSxtGewQx+X3YnMdBOf9yvHcbsGs6kg92YKVtJGWqCFqNWpbUR4LkETtBlBGHkPMqiE5Zl8aWXgVcLY98KYh5pWWt9oiHDYyTbPf2x1kNB4j9+5VTHrTMcc6g8nYL27iYdgGWRYRRCdN4GYi6rotnKtUXQ23OMxhJDp3z50oeG8DR+TVbrbMOfZg78q269T514u81KzUcqzRD/KQxqMyWfvVMYsrgab5F+I3IgDKWct7G4/4uYqwm1hew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/7/26 4:02 PM, Barry Song wrote:
> On Sat, Mar 7, 2026 at 10:22 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 3/7/26 5:07 AM, Barry Song wrote:
>>> On Mon, Feb 9, 2026 at 10:07 PM Baolin Wang
>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>
>>>> Currently, folio_referenced_one() always checks the young flag for each PTE
>>>> sequentially, which is inefficient for large folios. This inefficiency is
>>>> especially noticeable when reclaiming clean file-backed large folios, where
>>>> folio_referenced() is observed as a significant performance hotspot.
>>>>
>>>> Moreover, on Arm64 architecture, which supports contiguous PTEs, there is already
>>>> an optimization to clear the young flags for PTEs within a contiguous range.
>>>> However, this is not sufficient. We can extend this to perform batched operations
>>>> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
>>>>
>>>> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
>>>> of the young flags and flushing TLB entries, thereby improving performance
>>>> during large folio reclamation. And it will be overridden by the architecture
>>>> that implements a more efficient batch operation in the following patches.
>>>>
>>>> While we are at it, rename ptep_clear_flush_young_notify() to
>>>> clear_flush_young_ptes_notify() to indicate that this is a batch operation.
>>>>
>>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>
>>> LGTM,
>>>
>>> Reviewed-by: Barry Song <baohua@kernel.org>
>>
>> Thanks.
>>
>>>> ---
>>>>    include/linux/mmu_notifier.h |  9 +++++----
>>>>    include/linux/pgtable.h      | 35 +++++++++++++++++++++++++++++++++++
>>>>    mm/rmap.c                    | 28 +++++++++++++++++++++++++---
>>>>    3 files changed, 65 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>>>> index d1094c2d5fb6..07a2bbaf86e9 100644
>>>> --- a/include/linux/mmu_notifier.h
>>>> +++ b/include/linux/mmu_notifier.h
>>>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>>>           range->owner = owner;
>>>>    }
>>>>
>>>> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)                \
>>>> +#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)  \
>>>>    ({                                                                     \
>>>>           int __young;                                                    \
>>>>           struct vm_area_struct *___vma = __vma;                          \
>>>>           unsigned long ___address = __address;                           \
>>>> -       __young = ptep_clear_flush_young(___vma, ___address, __ptep);   \
>>>> +       unsigned int ___nr = __nr;                                      \
>>>> +       __young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);    \
>>>>           __young |= mmu_notifier_clear_flush_young(___vma->vm_mm,        \
>>>>                                                     ___address,           \
>>>>                                                     ___address +          \
>>>> -                                                       PAGE_SIZE);     \
>>>> +                                                 ___nr * PAGE_SIZE);   \
>>>>           __young;                                                        \
>>>>    })
>>>>
>>>> @@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>>>>
>>>>    #define mmu_notifier_range_update_to_read_only(r) false
>>>>
>>>> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
>>>> +#define clear_flush_young_ptes_notify clear_flush_young_ptes
>>>>    #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>>>>    #define ptep_clear_young_notify ptep_test_and_clear_young
>>>>    #define pmdp_clear_young_notify pmdp_test_and_clear_young
>>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>>> index 21b67d937555..a50df42a893f 100644
>>>> --- a/include/linux/pgtable.h
>>>> +++ b/include/linux/pgtable.h
>>>> @@ -1068,6 +1068,41 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>>>>    }
>>>>    #endif
>>>>
>>>> +#ifndef clear_flush_young_ptes
>>>> +/**
>>>> + * clear_flush_young_ptes - Mark PTEs that map consecutive pages of the same
>>>> + *                         folio as old and flush the TLB.
>>>> + * @vma: The virtual memory area the pages are mapped into.
>>>> + * @addr: Address the first page is mapped at.
>>>> + * @ptep: Page table pointer for the first entry.
>>>> + * @nr: Number of entries to clear access bit.
>>>> + *
>>>> + * May be overridden by the architecture; otherwise, implemented as a simple
>>>> + * loop over ptep_clear_flush_young().
>>>> + *
>>>> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
>>>> + * some PTEs might be write-protected.
>>>> + *
>>>> + * Context: The caller holds the page table lock.  The PTEs map consecutive
>>>> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
>>>> + */
>>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>>> +               unsigned long addr, pte_t *ptep, unsigned int nr)
>>>> +{
>>>> +       int young = 0;
>>>> +
>>>> +       for (;;) {
>>>> +               young |= ptep_clear_flush_young(vma, addr, ptep);
>>>> +               if (--nr == 0)
>>>> +                       break;
>>>> +               ptep++;
>>>> +               addr += PAGE_SIZE;
>>>> +       }
>>>> +
>>>> +       return young;
>>>> +}
>>>> +#endif
>>>
>>> We might have an opportunity to batch the TLB synchronization,
>>> using flush_tlb_range() instead of calling flush_tlb_page()
>>> one by one. Not sure the benefit would be significant though,
>>> especially if only one entry among nr has the young bit set.
>>
>> Yes. In addition, this will involve many architectures’ implementations
>> and their differing TLB flush mechanisms, so it’s difficult to make a
>> reasonable per-architecture measurement. If any architecture has a more
>> efficient flush method, I’d prefer to implement an architecture‑specific
>> clear_flush_young_ptes().
> 
> Right! Since TLBI is usually quite expensive, I wonder if a generic
> implementation for architectures lacking clear_flush_young_ptes()
> might benefit from something like the below (just a very rough idea):
> 
> int clear_flush_young_ptes(struct vm_area_struct *vma,
>                  unsigned long addr, pte_t *ptep, unsigned int nr)
> {
>          unsigned long curr_addr = addr;
>          int young = 0;
> 
>          while (nr--) {
>                  young |= ptep_test_and_clear_young(vma, curr_addr, ptep);
>                  ptep++;
>                  curr_addr += PAGE_SIZE;
>          }
> 
>          if (young)
>                  flush_tlb_range(vma, addr, curr_addr);
>          return young;
> }

I understand your point. I’m concerned that I can’t test this patch on 
every architecture to validate the benefits. Anyway, let me try this on 
my X86 machine first.

