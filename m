Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1615B606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XF8uB9LR
Received: by kanga.kvack.org (Postfix)
	id 1E29E6B05B0; Thu,  5 Nov 2026 04:00:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172FA6B05B1; Thu,  5 Nov 2026 04:00:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083046B05B3; Thu,  5 Nov 2026 04:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C90716B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:00:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51E334099D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:00:12 +0000 (UTC)
X-FDA: 85400468664.12.6AE183C
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf04.hostedemail.com (Postfix) with ESMTP id EBD0E40011
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:00:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XF8uB9LR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793869210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qpa3NEcxqfBmlG+KsMNpjxHv3Qlvd6eoPxtMyefULAQ=;
	b=gOldaUccLNLB4pb82G1+hlbwLQFg47owdyM3gORZB3dQgc3vHvj84uweIBcuh40iq7lXyk
	8a5PZKknc9/bnaH0LLcI9mbueRctUTbuR7vs7CDNHRNLem7JFVX+z0qI8J4VdRHT33TDkd
	P/eDjT9AkpIU1FkT1IbL1TuHDPAs9ew=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XF8uB9LR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793869210;
	b=Eoyc2SVA4VZqPmWvWL6Vai010zEZXzPoohyUhHZUHTLOnbgmvvYsMaDDd35k6qroLmF1z2
	eREyqFectpMAc96Rww3jauGZ8f73SjdU2rmWs1UzDvKiBP67QISM5NjMjCPmH6XG+jRNvW
	xB1w6iXmJje0B6rZXLSOgurRsQ1mzPE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793869206; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Qpa3NEcxqfBmlG+KsMNpjxHv3Qlvd6eoPxtMyefULAQ=;
	b=XF8uB9LRlwoMOTZanlZAsRNFt0RLs62YIFn67isvl2HuWPJEeRXfZg5lmWiHkhM+kD+KHTSC5d+khAlLEtTHth1yBkzuEkXwyeT13WSiwPzK4cY6+UntS4TDoI+YSgiErTgOpZy7h3AvMLpFZux4Rkv9hN/MmEtCma/LyvlIfVo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XE8DxBe_1793869204;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XE8DxBe_1793869204 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:00:05 +0800
Message-ID: <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com>
Date: Thu, 5 Nov 2026 17:00:03 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Lance Yang <lance.yang@linux.dev>, Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev>
 <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBD0E40011
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mbchot3c5bir7zabfpg8yue6tgujg3ej
X-HE-Tag: 1793869208-501980
X-HE-Meta: U2FsdGVkX18r8/DrpsTtwFAGjkdhIY6zpJgt9d9tl6qjnRnTyVgN/+/DTwafrSfdzEn7Lx+b3Ggc/P6MqNjms29cIrf02+Sc5XtPVOFAOQUTxsLCGKBNlnHnfRa0EIAGGMNw/tSkpQnBEkJu9uzXJ60GeN+iLcbY610MP5FjQ3BCmj2xKMYOsnr2N2r/11ti0yTVoHFNA0arVNZqBvenevT7CqiPfYCGrY8q9cqhsNrYeR3Hq+WpLUAGtC3b0R7qw/54knHt2QmYSIBR2i91u8rTKacRtRYYT7FtqUSsEa/YBt29uha9D5EP2EjKVs4Hisj44lV59bEm9wGJGFeQdIo8TGbM9Qmsh6V874du7psNjHSqTSVsoJ+HFRjTFCIN1GLHYGhotOvpwZa9X8LF1I+gaKDEocFDa1yYSQCih1j22YIChx0beySjIoW517/34R9qO5fwZzk4BMtoCseHbIGjjhmPxX3ZrZw93O5T2ZFu+lKkx7VaTHlYWygVccxDpsbgZzoqN5HSF1OnjAlWZ2tcJVMPYPrApQj9hstXYLUyp/qgEa/Zh4mF8e11e0E8tN4fn5H6dnVxL21Bd1/+RXKRCwkBY7/czxcyKEVMHoi+Rit3LVwuAMVElyH4DKIvJ8ZkRaTjDOOkFJMCNjd/5zNElVSteSzMTlJ2RsYT839WmK4wR6nStqNw4JrV/2+ZPxDYlhi4FaQUXfuK/HGXS+QYdonT5N6KK+gL1N3h8CUabTGRdM6xZ3ICkqARw4Y174tNxP/K/Y6BWRdw9giguyw36/L4GdgtIGOdh5L71fCid//KaqxT2mV5hgB8mDrZbVwA+JQVcwTyJ4FbWsmD/D8Ke7pYdOEBMH+clOipBa1CyhUmS97ArECLFcofY2NkLG2TjCdmRV2o6QpXzmzVd1iOHd1f+uyH0GICMO0xesmydFxceYET4tQ6B5b7KfGrKIbqVEF2LhdkItw6hpl
 aFkVELcg
 BEl1yzacHROnKkCr5v0H4rnGgbXz2V3CNoVqjDR5OGqI3Tmxqd8w9S5td0TYeXlHfMhaW6fFquhVvmotnkBM6H9cEkcbSQIOQ0lGTO1sd/KL4zfU1KLuC1kJKmv4CHjlUBoUIItCP1/N+CTa3DN9+5R7YvFwVoJePTQbNA8s+T/aeuD85tYd3bBX5y3dOELw0rRocwyzSe77av4UVuGW0Znbuuwe9ny9HwbKD5SjcHX6I0/0W/9yaNB4WsMr1xR8f0rHy2AGkRauUFMK/sJ41l96IiySS+N7cjVSveysGTSxamHuUABGMwTwavLu5f9xBT5IZWWpGq191O5A4u2IGEXbHbA+YvoJhFSOL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CC Barry, who added the TTU_SYNC in shrink_folio_list().

On 11/5/26 1:48 PM, Lance Yang wrote:
> 
> 
> On 2026/11/5 12:54, Lance Yang wrote:
>>
>> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing 
>>> mapped
>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can 
>>> also race
>>> with concurrent page table reclamation via zap_empty_pte_table().
>>
>> Good catch!
>>
>>> page_vma_mapped_walk() is used by many functions including 
>>> try_to_unmap(),
>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), 
>>> remove_migration_ptes(),
>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for 
>>> try_to_unmap()
>>> and try_to_migrate(), the other callers do not perform post-walk 
>>> accounting
>>> checks, so the race has no observable impact on them.
>>>
>>> For migration, the race can cause unnecessary retries. For reclaim via
>>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>>> fact already unmapped (as shown below), which may lead to unexpected OOM
>>> or increased refaults.
>>>
>>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>>> --------------------------------    --------------------------------
>>> folio_lock(F)
>>> try_to_unmap(F, TTU_SYNC)
>>>                                     zap_pte_range(full PMD range)
>>>                                       spin_lock(ptl)
>>>                                       clear PTEs
>>>                                       zap_empty_pte_table()
>>>                                         spin_trylock(pml)
>>>                                         pmd_clear()
>>>                                         spin_unlock(pml)
>>>
>>>   page_vma_mapped_walk()
>>>     observe !pmd_present(pmde)
>>>     nr_pages < HPAGE_PMD_NR
>>>     skip synchronization
>>>     return false
>>>
>>> try_to_unmap() returns
>>> folio_mapped(F) == true
>>> nr_unmap_fail += folio_nr_pages(F)
>>>                                     tlb_flush_mmu_tlbonly()
>>>                                     tlb_flush_rmaps()
>>>                                       remove F's rmaps
>>>                                     spin_unlock(ptl)
>>>
>>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped 
>>> folios")
>>> has already moved the PMD clear operation (via zap_empty_pte_table()) to
>>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
>>> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
>>> issues on weakly ordered CPUs.
>>>
>>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in 
>>> madvise(MADV_DONTNEED)")
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>> mm/page_vma_mapped.c | 5 +----
>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index e6b6170c2f4f..8797467b6f0c 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct 
>>> page_vma_mapped_walk *pvmw)
>>>             spin_unlock(pvmw->ptl);
>>>             pvmw->ptl = NULL;
>>>         } else if (!pmd_present(pmde)) {
>>> -            if ((pvmw->flags & PVMW_SYNC) &&
>>> -                thp_vma_suitable_order(vma, pvmw->address,
>>> -                           PMD_ORDER) &&
>>> -                (pvmw->nr_pages >= HPAGE_PMD_NR))
>>> +            if (pvmw->flags & PVMW_SYNC)
>>
>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>> PTE table can be reclaimed, so those extra checks can skip 
>> synchronization
>> that the caller explicitly asked for ;)
> 
> Ouch ... one thing I missed ... what about order-0 reclaim?
> 
> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
> hit the same race there?

Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which 
is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set, 
it means the caller can tolerate some racy checks.

For this case, I think we should set TTU_SYNC unconditionally in 
shrink_folio_list(). Barry, what do you think?

