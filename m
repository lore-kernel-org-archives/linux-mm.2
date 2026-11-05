Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108C6606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2543A6B05B0; Thu,  5 Nov 2026 00:49:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE166B05B1; Thu,  5 Nov 2026 00:49:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6656B05B2; Thu,  5 Nov 2026 00:49:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF54C6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:48:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD58BA8649
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:48:58 +0000 (UTC)
X-FDA: 85399986756.02.9E35F8F
Received: from mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 798B6C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:48:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JpMvdsIx;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793857736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/l6O9V7fMoYs7ihQIlg7jRbOXL/S2bFnQjGLeMo1S78=;
	b=FOQ5GM8rQaRLBtbMGWOSr3aSm34i805MsVIrACjqeiPIaIsJSghNlEEeWtKnm9aIPUffsP
	j9Mts0v8/0lpnC77k9RQL18ixBbfnRo6RF79lhDYohm4Lo9dOzV4f6oArPWmnE+SRgTtNc
	6SfQVkTt2J8W/3scb2pWD6rgHKPzu8s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793857736;
	b=ozXvOyCQb0JrBcPLhr9HUI5R6ANSbVDjVf2p+VwgXjST82BrSjfzGLr5KT5arjEHxDdhVA
	miIxN1hZFw7CClAsDh7r+reYGI0tizFu0bu20lwBneKlN/oHAX9OMqW/OAJHQV+3twyAZL
	nbxDj6p1Qfp5PyNdCkeBh34vjt2vZoE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JpMvdsIx;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l/klO32YzidFN2v1G4JzAIJs9vATWMhL2+jw9rYo5BY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793857735; v=1; x=1794462535;
 b=JpMvdsIxUYKjtKIiudsiyW9Sq9GKK1KU4Zx9S9a6W3ZxxzfjNmy/uAkswDpc/2CnYHA6KnI7
 rDnABgQXVr1PgaVyvm5LudW0X6ui3shigSzStXvnUFAyMUzIO4y9veyCYQzX25M3yJGZcvOfMS6
 5nTGhjYDggi2xM9o/B7q1fCg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3f45584444935ba1;
	Thu, 05 Nov 2026 05:48:54 +0000
X-Mizu-Trace-ID: 3f45584444935ba1
X-Migadu-Flow: FLOW_OUT
Message-ID: <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
Date: Thu, 5 Nov 2026 13:48:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261105045406.39871-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ptx8hczcguqfkqcgoej17d71ipdmrj9m
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 798B6C0006
X-Rspam-User: 
X-HE-Tag: 1793857736-694432
X-HE-Meta: U2FsdGVkX1/gDIwJD+hxE+KlsCkUAqPslLwjhxLHlRmtdl2zJOBCGDGysF0e3qoihUib6TXYyCDHzJZI4J8zDI506T+c3zOPF87Mu3M6T62O3KdIQbuVXhsWogC1+H/UxjJ1lCYNmBXPgrHJg94w6qrphY3ZViPOTHWMeyGbBkuuPfuuXNDha+YbHh+vuFiIgiwB52iccu9raGw8Nz2r1v+oGtvOdcWLsjNHLUoXDCE2YNSFv1prqCiUEBhBS9B7vvH8Fb81vgIc2cTvAcTiL/UyuIEUBzW6GcRUaKWrmp82jYV/dli1DS9xKW0GKMD0rDxRr564Ly2SV653vVWJatY1osPbVeq8Z05k2FY+42z5DbMoMJUq3+r/STkRpIUmDJad9zT1N0Qjq5cGA+ylzJ7j329G1frgCj3tx2XckZGtMBhjy4drnrMXDR0pUgDy8q6yxJYIwax3uG4GyPQk01HslPmjUF0JNsQ46TFaUQjVGRQyv4spAIIoQULjUZvCjaRizHBe3CaXV7gY2ZtDwfn3QuzyM4yOaKyYRb3SSxdLLe0TBqFZLS3zCrV5KWBkbXSjaX+2HaXyUREssvcn8pV9oXnjbgLP0G4NH7Y8yhGlJbPOuzGHUgfQ+eHurQQ+l2dM4sKS2htPAIWPr7OicNo2OBx7awkX21UAxgoPhFTiBGZT92XgS9Zx+OWEo1dabcGa9eWx16/rcJk+uksZ4+m3ae+TNIQY3CEDSN4Jotkftj0DbSmbbP2GhsyFUpD+Q2nEAZ+K16VHKv/O2I5oiF9YBr6w4wf8XkPAL14O8XfBn/+sWoyzC0A1JNh3P0NKHgHi2EO30WV5EntdPczIrJcklgXi0/XDd9eTyKyIsvdwdnWhARnnaROvaPZLpyAIv0LZA2Ez6SmYoprlDB16lRAi8W9uSiTBjYkLLWB8IOkXdwtA050LUn4PIpHH1F/Wbsea58ncXgK9r0T9ASl
 DMnWsgXe
 8ulmYxJWZvDOm+LwrrkRtfBV6CTNYVPFk07dic8U0ePgDyVT78f/l5GuLFLAWylOw9aqDZqp100q8iApwO42Eh8OOe7LVTz9Ow+2kgnaKt8Sta1WsOk/JvDuShQDLxC4Gfi/5+7Yr6Ua8kxn9xhnV0C8S7QCFaV7KyO5k1gP907cZkjkweZz1niZudpfLzJQyJBisHEaABzb6QuMqJtrA2Hs6xdiLiCgJ9L32dnAvgeI0rs06/P+RIyu6EZVyv1Xsg+5VDu27c6CX7AlvZ9SIOjPbqhvpIwo07PymEBPBqJ1to/DeSBLDPReibnFlJkbKc4nV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/5 12:54, Lance Yang wrote:
> 
> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
>> with concurrent page table reclamation via zap_empty_pte_table().
> 
> Good catch!
> 
>> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
>> and try_to_migrate(), the other callers do not perform post-walk accounting
>> checks, so the race has no observable impact on them.
>>
>> For migration, the race can cause unnecessary retries. For reclaim via
>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>> fact already unmapped (as shown below), which may lead to unexpected OOM
>> or increased refaults.
>>
>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>> --------------------------------    --------------------------------
>> folio_lock(F)
>> try_to_unmap(F, TTU_SYNC)
>>                                     zap_pte_range(full PMD range)
>>                                       spin_lock(ptl)
>>                                       clear PTEs
>>                                       zap_empty_pte_table()
>>                                         spin_trylock(pml)
>>                                         pmd_clear()
>>                                         spin_unlock(pml)
>>
>>   page_vma_mapped_walk()
>>     observe !pmd_present(pmde)
>>     nr_pages < HPAGE_PMD_NR
>>     skip synchronization
>>     return false
>>
>> try_to_unmap() returns
>> folio_mapped(F) == true
>> nr_unmap_fail += folio_nr_pages(F)
>>                                     tlb_flush_mmu_tlbonly()
>>                                     tlb_flush_rmaps()
>>                                       remove F's rmaps
>>                                     spin_unlock(ptl)
>>
>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>> has already moved the PMD clear operation (via zap_empty_pte_table()) to
>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
>> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
>> issues on weakly ordered CPUs.
>>
>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>> Cc: stable@vger.kernel.org
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> mm/page_vma_mapped.c | 5 +----
>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index e6b6170c2f4f..8797467b6f0c 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> 			spin_unlock(pvmw->ptl);
>> 			pvmw->ptl = NULL;
>> 		} else if (!pmd_present(pmde)) {
>> -			if ((pvmw->flags & PVMW_SYNC) &&
>> -			    thp_vma_suitable_order(vma, pvmw->address,
>> -						   PMD_ORDER) &&
>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>> +			if (pvmw->flags & PVMW_SYNC)
> 
> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
> PTE table can be reclaimed, so those extra checks can skip synchronization
> that the caller explicitly asked for ;)

Ouch ... one thing I missed ... what about order-0 reclaim?

shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
hit the same race there?

Cheers, Lance

> LGTM, thanks!
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> 
>> 				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>
>> 			goto next_pmd;
>> -- 
>> 2.47.3
>>
>>


