Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311C2C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 10:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592376B007B; Fri,  7 Aug 2026 06:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569AF6B0088; Fri,  7 Aug 2026 06:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F8B6B0093; Fri,  7 Aug 2026 06:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 196E86B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:03:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15F47A0276
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:03:18 +0000 (UTC)
X-FDA: 85074035676.17.0592D19
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id 808B9140014
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:03:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kkD22/wY";
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786096996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wK+Hb76csLXizlS8WvPBODDy0M/Xsr3U60SIvZ3KC68=;
	b=C5CMT8SczeNnc1VXtmWDF5VlXKGvXbVcr2uG6vwLtdWJNrhFLVjIqk/UK4sJR8fsde3BgW
	7SSdi+TLtYnsa2WvmvE/ePqaQ4ET8TU/rlrTVkU3DpJI48cpd3fnUyDPzpUdLy+tEEe5Nr
	zS09m7B2yJh4EEcYnpBDF/S45uyw8Ec=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786096996;
	b=UYBPfWHLJ2MHDNo4nyW07VPmPlLGtdvkPqMfi8ysrQUWqH1jVJBlmgqvDWiIGsfI1YDGDY
	rkiRV1wB1gzA9jV1o7z2becWgy/D6W58VcBrGWFDsDIasklnQ6IlkxUZRRkeh+tlLBHrvw
	YHbsoDJ5BWLHG9DkIaFE+kOjt6BgwDI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kkD22/wY";
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <46fc75b4-7697-45e2-bbd1-84f09626c686@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786096989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wK+Hb76csLXizlS8WvPBODDy0M/Xsr3U60SIvZ3KC68=;
	b=kkD22/wYJGS4D3H4l0765ZwL17oxiPIvfiVUwnkrqtVbtJ5dCLpHwcvWee4ho/yRPbseWk
	FCbKS3lGI4d2fKD+vcSlqtTe+DtAGlGRUChy3YZtt0rhAsOZR6ZZc2hLs+WSROwHHk2ZLO
	Poz2PTYVqXVY3ORdb71wXFH5D/PFgSE=
Date: Fri, 7 Aug 2026 11:03:05 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 10/11] mm: install PMD swap entries on swap-out
To: Luiz Capitulino <luizcap@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-11-usama.arif@linux.dev>
 <3374e351-f6ad-44b2-9ee1-dd3b9c33fbc3@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <3374e351-f6ad-44b2-9ee1-dd3b9c33fbc3@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qmuodpozj138ar73otqccqixkq1ffyfr
X-Rspamd-Queue-Id: 808B9140014
X-HE-Tag: 1786096994-264831
X-HE-Meta: U2FsdGVkX1+dYtu3QfFwW7WQ5l50yE0efegLQlW4DTSL9hfxDRBatUaqb85YXEbNCoxEahD4eh3PLJKH5YKWJE16Lux4B0FqIkCk99Uqmg7Hgxu7LeeC8F83hpgI4DmvdsYvz28DgQ1iXuBqg7apCw4Z9VlVUE9wONE8hxLmtsVuxjUV5uuaWA/5JqDW8PMNsuaALBXXn4ZF8j+IZA5mTrmHS3duUvjE/xv7un2QbeRDb+/8A19Kmiu5PuDXUxM4WjErPi9UFWcIO6ZtoliPrlmWUy7fUcb53P22grkt3BJcBmmnNjfNaoWiaXmvtjAsGt0gdVFThwfkn9eBS8AIkTvpFvluYwpBlEHwZ6fFO3d7NPpjpGPY4ZDt6pTb8ye2NfXlNtGC63HAwjc0mIsRdEv1y7eqMnJzngLMuxswvn1NKNP3zJorzdKMaFiWSBSf8lsUb9kgxcbmRMG50hj6p51lS38/8EnC8UAHeohffQIHJ6UV3HMhHgkzkl46AJ3Kr+T3PA/6AzCTooY35A+P4wnTV1V8x0RCElfY++NE2Elgp8tRTpsjVNs3mbfD7ur0nzMmcd6Srqtd+ybp3BFhjZDThS990wEHrbaKkhMzikmo7aWj2geJcAEMazC3qH7InKL85mglHJgehoevnyAuCQdiTjqpZryZvLpGIyXbN5flq5BfKdHeU39jXCWMz07+/CNvlpJTbgheymEBRbZo9QuG4mUoEURS8ZnmD0+Pj9vySAwFR9Ngf/dJ57wYdgT7VQW3UdFBnqvh/+ro9Pq8m2M48ys5+hBktkeqtVtYWE1obJANkhw+LAu/z/jwh7SvukYg/JT4eaI+m/neRZ9Ja88QIXT9kv3odLdKquw7EGH5BUN/NUKOxnXrmZRYFG6GBYNTpm6LMeWONHZ2ekq0H3N+b3u/PQ2hjESXK3IGU61vOaR9g7uYTPPVLZUAPd9WHbW4447X7NDPbdo40Uv
 eXtpqFIj
 GnlrWt8STVEOUu8Rgrgjf5k6dPsB9mhSiFtRiYSbwhF00G1zTIcySh2vpgvnXo2OsxkLNKEWpmRPtVGSkCn4ghT8b3iLRYOLN3X/9Nrgg0vweVvGXTD5dwOFkaD/RZASSv/K9Y5wVVhiQVYIHaW1Xe+GgCTTcTcd93l/apfUrUDm1mLf/UgpThW24a9BS1fadmB1bDzIj+Pabo4dACumjShOwL3UO8QW5sgsV9nWFB46dfvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/08/2026 03:29, Luiz Capitulino wrote:
> On 2026-07-22 11:19, Usama Arif wrote:
>> Reclaim today splits a PMD-mapped anonymous THP into 512 PTE swap
>> entries before unmap, losing the huge mapping across the swap
>> round-trip and forcing khugepaged to rebuild it later. The contiguous
>> swap range was already secured when the folio was added to the swap
>> cache (a non-contiguous allocation would have split the folio earlier),
>> so the PMD can be replaced by a single PMD-level swap entry instead.
>>
>> This patch mirrors the existing PTE swap-out path at PMD granularity:
>> - shrink_folio_list() drops TTU_SPLIT_HUGE_PMD for PMD-mappable
>>    swapcache folios. zswap is handled by the PMD swap-in users: if any
>>    covered slot currently has a zswap entry, they split the PMD swap
>>    entry and fall back to the per-PTE path.
>> - try_to_unmap_one() now has a PMD branch that calls
>>    set_pmd_swap_entry() and adjusts MM_ANONPAGES / MM_SWAPENTS by
>>    HPAGE_PMD_NR before walk_done. TTU_SPLIT_HUGE_PMD remains the
>>    fallback.
>> - set_pmd_swap_entry() is the installer. Mirroring the PTE swap-out
>>    sequence at PMD granularity, it clears the present mapping (keeping
>>    the original for rollback), bumps the swap_map refcount for the
>>    folio's 512 slots, transfers the exclusive state in the swap entry,
>>    propagates the dirty bit to the folio so writeback is not lost,
>>    and installs a swap PMD that preserves the original
>>    soft-dirty / uffd-wp / exclusive bits. Any failing step rolls back
>>    the present mapping.
>>
>> The swap entry value matches what 512 PTE swap entries would encode, so
>> swap_map refcounting is unchanged: each of the 512 slots carries a
>> count of 1, released individually on later split or together on swap-in.
>>
>> Add thp_swpout_pmd to count each PMD mapping replaced by a PMD-level
>> swap entry. Unlike the folio-level thp_swpout counter, a fork-shared THP
>> can increment this counter once for each mapping; document that
>> distinction.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>   Documentation/admin-guide/mm/transhuge.rst |  5 ++
>>   include/linux/huge_mm.h                    |  2 +
>>   include/linux/vm_event_item.h              |  1 +
>>   mm/huge_memory.c                           | 80 ++++++++++++++++++++++
>>   mm/rmap.c                                  | 19 +++++
>>   mm/vmscan.c                                |  9 ++-
>>   mm/vmstat.c                                |  1 +
>>   7 files changed, 116 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>> index 16f37135ed80..b421d7982db6 100644
>> --- a/Documentation/admin-guide/mm/transhuge.rst
>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>> @@ -630,6 +630,11 @@ thp_swpout
>>       is incremented every time a huge page is swapout in one
>>       piece without splitting.
>>   +thp_swpout_pmd
>> +    is incremented every time a PMD mapping is replaced by a PMD-level
>> +    swap entry. A fork-shared THP can increment this counter once for each
>> +    PMD mapping that is swapped out.
>> +
>>   thp_swpout_fallback
>>       is incremented if a huge page has to be split before swapout.
>>       Usually because failed to allocate some continuous swap space
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index e7107e0991ad..41cf643a3f55 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -554,6 +554,8 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
>>     #ifdef CONFIG_THP_SWAP
>>   vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
>> +int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
>> +               struct folio *folio);
>>   #else
>>   static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
>>   {
>> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
>> index 2628ccda076a..f8fd4e13698c 100644
>> --- a/include/linux/vm_event_item.h
>> +++ b/include/linux/vm_event_item.h
>> @@ -108,6 +108,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>>           THP_ZERO_PAGE_ALLOC_FAILED,
>>           THP_SWPOUT,
>>           THP_SWPOUT_FALLBACK,
>> +        THP_SWPOUT_PMD,
>>   #endif
>>   #ifdef CONFIG_BALLOON
>>           BALLOON_INFLATE,
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 6ef56936ced4..c014631e5a26 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -5561,3 +5561,83 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>>       trace_remove_migration_pmd(address, pmd_val(pmde));
>>   }
>>   #endif
>> +
>> +#ifdef CONFIG_THP_SWAP
>> +/**
>> + * set_pmd_swap_entry() - Replace a PMD mapping with a PMD-level swap entry.
>> + * @pvmw: Page vma mapped walk context, must have pvmw->pmd set and
>> + *        pvmw->pte NULL (i.e. PMD-mapped).
>> + * @folio: The folio being swapped out. Must be in the swap cache.
>> + *
>> + * This installs a PMD-level swap entry in place of a present PMD mapping,
>> + * avoiding the need to split the PMD into PTE-level swap entries.
>> + *
>> + * Return: 0 on success, negative error code on failure.
>> + */
>> +int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
>> +               struct folio *folio)
>> +{
>> +    struct vm_area_struct *vma = pvmw->vma;
>> +    struct mm_struct *mm = vma->vm_mm;
>> +    unsigned long address = pvmw->address;
>> +    unsigned long haddr = address & HPAGE_PMD_MASK;
>> +    struct page *page = folio_page(folio, 0);
>> +    bool anon_exclusive;
>> +    pmd_t pmdval;
>> +    swp_entry_t entry;
>> +    pmd_t pmdswp;
>> +
>> +    if (!(pvmw->pmd && !pvmw->pte))
>> +        return 0;
> 
> Should we call VM_WARN_ON_ONCE() and return an error instead? This
> function is only called by try_to_unmap_one() under this condition. In
> addition, returning zero would cause try_to_unmap_one() to assume that
> the PMD swap entry was installed, which is not the case.
> 
Thanks for review!

It makes sense, I will add a warning and return -EINVAL.

