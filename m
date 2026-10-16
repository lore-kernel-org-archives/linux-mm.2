Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1B1CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79C06B0098; Thu, 15 Oct 2026 21:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2ABD6B0099; Thu, 15 Oct 2026 21:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18F16B009B; Thu, 15 Oct 2026 21:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9449F6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:47:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 032CB12024D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:47:27 +0000 (UTC)
X-FDA: 85326802176.01.6B2A53A
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf20.hostedemail.com (Postfix) with ESMTP id 830CA1C0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:47:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="GD/Tpsky";
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792115246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfUIw3nBCJ2Tb9sCItT56mvQgYidiqFThC9FCi7zIMI=;
	b=IZmvttf2v07Seq4eyE4667rE/2y9nED7/LZP6OCqZuBLhFSLEZ55V7+FZjwkSx36sDOIpm
	nM2fabiOc6ZhMagWO3Jp8Dj1p732QldH0AQmwjkQXlFjSEStaLSFLmnKiggELaWXlygYE9
	WlGBocAGuZN3n95nW8yEajgzOMM9v7Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792115246;
	b=a/4tYSD5i+H0UP0XO4EZpcxwu/nNSKSnxA2pf/V3JIkx2d3g83IK9c+RphhFTosvPdX65A
	cLgfi5ZqZaZcJN/ybWXgS4ziZa8SFE66sJI1oRuOdnK2htJfMncX5dycOSsiul+E5LWMk3
	7sDRvaZqmKwn0mRop4ZePLrdQk446BM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="GD/Tpsky";
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792115241; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dfUIw3nBCJ2Tb9sCItT56mvQgYidiqFThC9FCi7zIMI=;
	b=GD/TpskyDMUuwDqy2PreHSaG5knX5fgqORrKK45wunB+3JAWYid7E54ScfvmA6/5NqsvV0gQqo7n8S6fhQRIq1iIJB958yxB9zyr0+i8C7g5J/WTbpBQbmaADYDKpIwCSTuB2SA1wJ+1Fe3Q2q5l8o5UQxCPR9lNo59BLyg0fP8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCt4VcS_1792115238;
Received: from 30.74.144.163(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCt4VcS_1792115238 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Oct 2026 09:47:19 +0800
Message-ID: <b1a9b500-0ddc-4791-9e1f-00087e367426@linux.alibaba.com>
Date: Fri, 16 Oct 2026 09:47:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
 <405811f5-ee36-4b3c-80d0-7dc6827ab5d4@linux.alibaba.com>
 <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
 <02c9a968-92e2-49e2-bffc-74d264a5c911@linux.alibaba.com>
 <f7735584-e020-4ee1-8afb-2b5d580cfa49@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <f7735584-e020-4ee1-8afb-2b5d580cfa49@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 830CA1C0003
X-Rspam-User: 
X-Stat-Signature: owu93utneuhpoeznay79g9xm1ci6rhdm
X-HE-Tag: 1792115244-270522
X-HE-Meta: U2FsdGVkX19GoS31JL8CybiJMCsYd66DFQ4zVffqTKL6CMq3ustE0l5oKYFEyW/XXVNe5+LJjqiobXHa8br5glNNup6MqI1+i20V1enP0hF9hp5jjGyn+qBqW2hpS0Q7jSr/ckmCTd+6neSP5iKPE2jzN+DpdEYSPiYuW9F5bgfeaofpXID/yw3FDZyptdqL/fJhdBo/pbbxknFY+keVp7EwCRj221wqShl5MBocOxKYojPnjf9AsJQnzzTC19ncP8BCd4bVczHjkHeuVyqVmImTVHxJRAX0CMZPIjhz+lXJmWuH3EnPhapLvrf3z/raCTNZ1KfUvFY7MvA5Bn8p06ScirLDBEEg2ioatazk77iBhFgmig7eMBrwNi/S0IHNYQitTRi6fuacR+yc4KAn9nlvyReVcgyrFusYPj+oSq9ci5HYO/HTE3XvhR8AKQEBUKsfCFsAAe5th7RE5eGHmA67/v9trWsmPUhf6QGzmK1/sXSTxiSWfAcKAcJkT0Q1i7L26qcVkzxbnKIHUZq+q0UswjLGK+WCWG2HyLiOQ7G8T0JtVE49mvcvNMetkm1pOczLTJVmTK9XYkDWi/UYaflAcP+Vjn+xhwPJm9LAJ5bCMN/0XLLZsm/AU8Cg4EklBp2IzmOsXL5tDJ4fKy0yfU5NeOaXMqiTtkULFF8MrEbOKHWCA5k/U00QY24N3MLrCdL6L0Wc6iD0O1DWdbDopDmRgMkb+vcXWnlJKgI+wrTqveyx9gIRy0U56+TpQMiWGbLpwiI1VH/SGmuf5WK8psUBYGBlJXSAzqH6m3R9y92zWNfiCP1doLdnFP5D6Yxba/I7TzRfCKa7gHq6xUj84sZzEVpdc5GsqOJVbH+hpGEzG2QELS8hlzDzRfFouOaS4ROoPztQnV92pTMx2A2rqwu8bF50eM7EokMDv04S1YJ/zZaD9Ybo8B5cxuRXogBKvz/7Fc3l/r3C0kLq+GC
 ardHV0dE
 09FgG9F5FO19sJcTJTQe10pfv9AYhVXaMiF6y5vbx142CrxaJkKFU8zTOHPG9LNrwh9CD1VNPU703SUpP1e0EOV+E6ZmKvqEMWdEs1T481pd+QfLb3ZQ+9Gi2H6/h2REyTQ1F6NyPpmbdczWZkVbXz5TMdDbah4HeESpdQVvtrTi18qdvmF7V1nRo4n+0bY+1rUlGvqktpL8qelq1AihRPzU9Hb981wOG9uQAvIi8Dsxa5PslqRwWLvZib66fBfF+VGlZmmNi5ucXl94TW+dUUjeikZD1UVpkgEgncBCiMwtSjC6zZdkQO21zTt+XGGbdt6WjOoXkjgdG9LVzm+RhBewzjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/16/26 3:00 AM, David Hildenbrand (Arm) wrote:
> On 10/15/26 08:41, Baolin Wang wrote:
>>
>>
>> On 10/14/26 9:25 PM, David Hildenbrand (Arm) wrote:
>>> On 10/13/26 11:36, Baolin Wang wrote:
>>>>
>>>>
>>>>
>>>> I had considered this approach before, but it is not feasible. IIUC, the
>>>> sync_with_folio_pmd_zap() is used to address the race with zap_huge_pmd(), and
>>>> both the PMD clear and the folio mapcount decrement are performed under the PMD
>>>> lock in zap_huge_pmd().
>>>
>>> Just to be clear, I am thinking about something like the following on the
>>> zap_pmd_range() side:
>>>
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index 38b1165212c94..a8820ad7e2f21 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -584,14 +584,15 @@ void free_pgtables(struct mmu_gather *tlb, struct
>>> unmap_desc *desc);
>>>    void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>>
>>>    /**
>>> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
>>> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>>     * @mm: The mm_struct.
>>>     * @pmdp: Pointer to the pmd that was found to be pmd_none().
>>>     *
>>>     * When we find a pmd_none() while unmapping a folio without holding the PTL,
>>> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
>>> - * indicate that it's unmapped. Skipping the PMD without synchronization could
>>> - * make folio unmapping code assume that unmapping failed.
>>> + * zap_huge_pmd() or zap_empty_pte_table() may have cleared the PMD but not
>>> + * yet modified the mapped folios to indicate they are unmapped. Skipping the
>>> + * PMD without synchronization could make folio unmapping code assume that
>>> + * unmapping failed.
>>>     *
>>>     * Wait for concurrent zapping to complete by grabbing the PTL.
>>>     */
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 8b0c2c735d3de..c585f5eb255c9 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -2139,9 +2139,7 @@ static inline unsigned long zap_pmd_range(struct
>>> mmu_gather *tlb,
>>>                                   continue;
>>>                           }
>>>                           /* fall through */
>>> -               } else if (details && details->single_folio &&
>>> -                          folio_test_pmd_mappable(details->single_folio) &&
>>> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>>> +               } else if (details && details->single_folio && pmd_none(*pmd)) {
>>>                           sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>                   }
>>>                   if (pmd_none(*pmd)) {
>>>
>>
>> Yes, I've considered that. However, implicit memory barriers give me a headache,
>> so I ended up going with explicit memory barriers (suggested by Pedro).
>>
>> If you don't like memory barriers, let me re-check whether the implicit memory
>> barriers here can ensure race safety with sync_with_folio_pmd_zap(). A
>> simplified logic is as follows:
>>
>> CPU 0 (truncation)                        CPU 1 (zapping)
>> down_read() ->Acquire A1.                pte spin_lock() ->Acquire A4
>>                                           clear mapcount
>>
>>                                           pmd spin_lock() ->Acquire A5
>>                                           clear pmd
>>                                           pmd spin_unlock() ->Release R5
>>
>> if (pmd_none()) { //read pmd
>>                                           pte spin_unlock() ->Release R4
>>      pmd spin_lock() ->Acquire A2
>>      pmd spin_unlock() ->Release R2
>> }
>> up_read() -> Release R1
>>
>> spin_lock(y) ->Acquire A3
>> folio_mapped() // read mapcount
>> spin_unlock(y) ->Release R3
>>
>> CPU 0 constraints:
>> 1. R2 is a release, so "read pmd" completes before R2.
>> 2. A2 completes before A3 (ACQUIRE vs ACQUIRE).
>> 3. "read mapcount" completes after A3, hence after A2.
>>
>> CPU 1 constraints:
>> 1. R5 is a release. Both "clear mapcount" and "clear pmd" complete before R5.
>>
>> According to above constraints, if CPU0 sees pmd_none() caused by CPU1's clear
>> pmd, and CPU0 then acquires the same pmd lock released by CPU1 at R5, then
>> CPU1's clear mapcount happens before CPU0's later folio_mapped().
>>
>> Therefore folio_mapped() is guaranteed not to read the old mapcount in this
>> case. So I think sync_with_folio_pmd_zap() can work, but needs a small change to
>> avoid the double pmd_none() check.
> 
> 
> I'd be okay with some (follow-up?) memory barrier handling inside
> sync_with_folio_pmd_zap(), for example, based on the folio size and with proper
> documentation why we need the PT lock in one case and why the memory barrier is
> ok in the other case.

I'm afraid that we can't fit all the memory barriers into 
sync_with_folio_pmd_zap(). As the current patch does, we need memory 
barriers on both the writer and reader sides.

>> David, does the following diff look good to you?
> 
> I think we should extend the sync_with_folio_pmd_zap() doc as suggested.

Ack.

>> diff --git a/mm/memory.c b/mm/memory.c
>> index 6a8e7772b8d6..c0aadab1b59e 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>                  }
>>          } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
>>
>> +       add_mm_rss_vec(mm, rss);
>> +       lazy_mmu_mode_disable();
>> +
>> +       /* Do the actual TLB flush before dropping ptl */
>> +       if (force_flush) {
>> +               tlb_flush_mmu_tlbonly(tlb);
>> +               tlb_flush_rmaps(tlb, vma);
>> +       }
>> +
>>          /*
>>           * Fast path: try to hold the pmd lock and unmap the PTE page.
>>           *
>> @@ -2044,16 +2053,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>           * to ensure they are still none, thereby preventing the pte entries
>>           * from being repopulated by another thread.
>>           */
>> -       if (can_reclaim_pt && direct_reclaim && addr == end)
>> +       if (can_reclaim_pt && direct_reclaim && addr == end) {
>>                  direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>> -
>> -       add_mm_rss_vec(mm, rss);
>> -       lazy_mmu_mode_disable();
>> -
>> -       /* Do the actual TLB flush before dropping ptl */
>> -       if (force_flush) {
>> -               tlb_flush_mmu_tlbonly(tlb);
>> -               tlb_flush_rmaps(tlb, vma);
>>          }
>>          pte_unmap_unlock(start_pte, ptl);
>>
>> @@ -2102,12 +2103,11 @@ static inline unsigned long zap_pmd_range(struct
>> mmu_gather *tlb,
>>                                  continue;
>>                          }
>>                          /* fall through */
>> -               } else if (details && details->single_folio &&
>> -                          folio_test_pmd_mappable(details->single_folio) &&
>> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>> -                       sync_with_folio_pmd_zap(tlb->mm, pmd);
>>                  }
>> +
>>                  if (pmd_none(*pmd)) {
>> +                       if (details && details->single_folio)
>> +                               sync_with_folio_pmd_zap(tlb->mm, pmd);
>>                          addr = next;
>>                          continue;
>>                  }
> 
> We do have another sync_with_folio_pmd_zap() user in page_vma_mapped_walk(),
> does that one need care as well?

Good point. But I don't want to add page_vma_mapped_walk() changes into 
this fix patch. I need to analyze all callers of page_vma_mapped_walk() 
and the potential races. I'll look into whether it should be changed in 
a follow-up patch.

Thanks for your comments.

