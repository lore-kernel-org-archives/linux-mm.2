Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543F4E67A6B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 06:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0D66B0005; Tue,  3 Mar 2026 01:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75EB56B0088; Tue,  3 Mar 2026 01:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660E76B0089; Tue,  3 Mar 2026 01:04:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51E7F6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:04:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E557214064C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:04:04 +0000 (UTC)
X-FDA: 84503711208.26.26D9D1C
Received: from out199-9.us.a.mail.aliyun.com (out199-9.us.a.mail.aliyun.com [47.90.199.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id 90BC514000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:03:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IcApRh75;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.9 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772517843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LY/fRLCch2WMY1U+LqLFNZMzn9HmzfAceCungi2ykLY=;
	b=YFzZgcb98lzdx33J9wNBzQVJDdq8/kf3AAagH4KxNKANxRi8OBzyEY1AWRHn/4lp+BDSxV
	koASxbdx3kiEjOdsgqi3MyX3sSE4Lc6Wv/jdcPQqyJQF+LVVi6VXqCVxEuEOSt9dre6hny
	3RzmLrLPdFwdf9nhwxeiiAKsqO8WNM0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IcApRh75;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.9 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772517843; a=rsa-sha256;
	cv=none;
	b=KJwvMjODeCB17hzLwXAb8NwwZ9Qu4AwnD0i6Yw83eN3KMOmMOI2uGgvX8E693wPmfrzHMh
	91ueWOdp7WN9G/MfLsT3tatFF7r4jEul7oYao6bf0m2lQ0Z9cq33aMJyIXDUyUrTDZ6t7w
	1lTwrCfJXY4Du5G2CKuXKsMRmU5oQxc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772517817; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LY/fRLCch2WMY1U+LqLFNZMzn9HmzfAceCungi2ykLY=;
	b=IcApRh75pmveT9hR3YtXgZH5noh1PCV3+X01sDgKaq1oUQQsQS5kNvQq8hf9yucKZ75UgTg2ayO7tvtTkAHBgJRFY6JHTni07zn02N3BW0Ix8t4Ofqpqpn5u+bQKfB5BuNk5yYWW03Cgvy2KFhghb5lwkBZRt6SXh+lluRh1WFM=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-8iWyn_1772517815 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 14:03:36 +0800
Message-ID: <3701c315-b19c-4c87-aff3-cc76e1009a43@linux.alibaba.com>
Date: Tue, 3 Mar 2026 14:03:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] mm: support batched checking of the young flag for
 MGLRU
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
 <f84233f95f209d59c3bc9c72a757af09337f0d40.1772185080.git.baolin.wang@linux.alibaba.com>
 <7f2973f0-0a34-4e4f-8ed6-13c531f77453@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <7f2973f0-0a34-4e4f-8ed6-13c531f77453@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 90BC514000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 6k6qsorcufzpsaiufjuhybp5mjdq5t9m
X-Rspam-User: 
X-HE-Tag: 1772517838-987364
X-HE-Meta: U2FsdGVkX1/ObA6f8yhqpXxJrxyC7iscpxWFqRaEn57HoFazvWDMvMfVMReAlAZie5aiH2MQUQI1BBdFhdS8ICG54FX/vpnDLFPnJbGNaRoE58LdXhuPy+TakqepYRnW0T7DvK7iUp6EvyhQx74ytYG8xSg8yOLgYd9AmOvvEkp/LKechI7masuo6TyiwnElp7LPnq8r2NaoxmtwnHNMACaNXeskxFX8mFF2+lryltNoADgRBascj5A7wMBRxbQ1IGiRfguzwcyjzU1DkIQzbLHSA0qWNaS7zpHDUc7iZ2m0Gwrwk8WnjpPgiUBWhlcRALxSHVELdkJwbzoHwHMJF8qk83Kl3Qa8zpAoThuTE5vMu3GjVWXKBn51EqmLCujK2pWBKCNBELcO4dlDc2L5FRkwm1Kj5wHdAHvI+Idst9Cx6DBNE5/HwN5GMG7g4IJ8rJzVfZRoQr5G9lMIPuD5vgWTDDjAJexTSpIIntyHlSYlmN6BQgwUp0pKyLZLw2/q65rXgCBdCNQiBXb+e6IIvO2poFsYwKmAc6xTiOga2XqRuw1cI5uJ8lkcuTTGt6n5Ph0p9ZcEbQ3RJ6XrMBbKRHI5c3GjKpuBUAy2I6lCqe5gxil2kTPFih7+rvADyA0ZTRujiObrui+HFckC/ZOA4JKWGUxbkc5DSFgme2x4+Rtf++MkE7uRCXXak8k/rFYKhTnzzVHlj1iaFviwjQQETathcZ9Tf6ylbG/vNYJQxPVzCW/NNQ1o53jS6hXagv5TotntWHhEMvLksvg2Mb39ZPlqE4bhLgoXBRN3ockAnAh2FSTD1vQobXhhzdyX2OYTovnG1k1npf4KeVDKZlI4+f+1+MA3gUlgqLzO0N1zpO/ZQg6PAO6XfiCIs62mfLkQXsqyv4BTOxaEnkVVx6FBhYYEjcny3K3YR9s7HbabifpuLAn3uBGSHMPUnYW1YZiMXFwmRhXAtM9LhtZGWTe
 W0vRebiH
 Kdk5ruL8tbORXeQhnthxJvKuUgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/2/26 5:57 PM, David Hildenbrand (Arm) wrote:
> On 2/27/26 10:44, Baolin Wang wrote:
>> Use the batched helper test_and_clear_young_ptes_notify() to check and clear
>> the young flag to improve the performance during large folio reclamation when
>> MGLRU is enabled.
>>
>> Meanwhile, we can also support batched checking the young and dirty flag
>> when MGLRU walks the mm's pagetable to update the folios' generation
>> counter. Since MGLRU also checks the PTE dirty bit, use folio_pte_batch_flags()
>> with FPB_MERGE_YOUNG_DIRTY set to detect batches of PTEs for a large folio.
>>
>> Then we can remove the ptep_test_and_clear_young_notify() since it has
>> no users now.
>>
>> Note that we also update the 'young' counter and 'mm_stats[MM_LEAF_YOUNG]' counter
>> with the batched count in the lru_gen_look_around() and walk_pte_range(). However,
>> the batched operations may inflate these two counters, because in a large folio not
>> all PTEs may have been accessed. (Additionally, tracking how many PTEs have been
>> accessed within a large folio is not very meaningful, since the mm core actually
>> tracks access/dirty on a per-folio basis, not per page). The impact analysis is as
>> follows:
>>
>> 1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and is mainly for
>> debugging.
>>
>> 2. The 'young' counter is used to decide whether to place the current PMD entry into the
>> bloom filters by suitable_to_scan() (so that next time we can check whether it has been
>> accessed again), which may set the hash bit in the bloom filters for a PMD entry that
>> hasn’t seen much access. However, bloom filters inherently allow some error, so this
>> effect appears negligible.
> 
> 
> Doesn't checkpatch complain about long lines in the patch description?

Will update the commit message.

>> Reviewed-by: Rik van Riel <riel@surriel.com>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
> 
> ...
> 
>> index a5f0a264ad56..a1b3967afe41 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1843,10 +1843,4 @@ static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
>>   
>>   #endif /* CONFIG_MMU_NOTIFIER */
>>   
>> -static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
>> -		unsigned long addr, pte_t *ptep)
>> -{
>> -	return test_and_clear_young_ptes_notify(vma, addr, ptep, 1);
>> -}
>> -
>>   #endif	/* __MM_INTERNAL_H */
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 11cc6171344f..beb423f3e8ec 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -958,25 +958,21 @@ static bool folio_referenced_one(struct folio *folio,
>>   			return false;
>>   		}
>>   
>> +		if (pvmw.pte && folio_test_large(folio)) {
>> +			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
>> +			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
>> +			pte_t pteval = ptep_get(pvmw.pte);
>> +
>> +			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
>> +			ptes += nr;
> 
> Could we move that "ptes += nr;" just before the "pra->mapcount -= nr;"?
> 
> Would make the whole thing look less weird (only incrementing "ptes" with large folios).

OK. Sounds reasonable.

>> +		}
>> +
>>   		if (lru_gen_enabled() && pvmw.pte) {
>> -			if (lru_gen_look_around(&pvmw))
>> +			if (lru_gen_look_around(&pvmw, nr))
>>   				referenced++;
>>   		} else if (pvmw.pte) {
>> -			if (folio_test_large(folio)) {
>> -				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
>> -				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
>> -				pte_t pteval = ptep_get(pvmw.pte);
>> -
>> -				nr = folio_pte_batch(folio, pvmw.pte,
>> -						     pteval, max_nr);
>> -			}
>> -
>> -			ptes += nr;
>>   			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
>>   				referenced++;
>> -			/* Skip the batched PTEs */
>> -			pvmw.pte += nr - 1;
>> -			pvmw.address += (nr - 1) * PAGE_SIZE;
>>   		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>>   			if (pmdp_clear_flush_young_notify(vma, address,
>>   						pvmw.pmd))
>> @@ -995,6 +991,10 @@ static bool folio_referenced_one(struct folio *folio,
>>   			page_vma_mapped_walk_done(&pvmw);
>>   			break;
>>   		}
>> +
>> +		/* Skip the batched PTEs */
>> +		pvmw.pte += nr - 1;
>> +		pvmw.address += (nr - 1) * PAGE_SIZE;
>>   	}
>>   
>>   	if (referenced)
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 0a5622420987..7457b3c06fa3 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3474,6 +3474,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>>   	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
>>   	DEFINE_MAX_SEQ(walk->lruvec);
>>   	int gen = lru_gen_from_seq(max_seq);
>> +	unsigned int nr;
>>   	pmd_t pmdval;
>>   
>>   	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
>> @@ -3492,11 +3493,13 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>>   
>>   	lazy_mmu_mode_enable();
>>   restart:
>> -	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
>> +	for (i = pte_index(start), addr = start; addr != end; i += nr, addr += nr * PAGE_SIZE) {
>>   		unsigned long pfn;
>>   		struct folio *folio;
>> -		pte_t ptent = ptep_get(pte + i);
>> +		pte_t *cur_pte = pte + i;
>> +		pte_t ptent = ptep_get(cur_pte);
>>   
>> +		nr = 1;
> 
> 
> Looking at this again, we should get rid of "i" completely and instead
> * rename pte to start_pte
> * Add a new pte, which we increment in the loop
> 
> So we end up with something like
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 54cf4924d223..150cbb2253b9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3486,9 +3486,8 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
>   static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>                             struct mm_walk *args)
>   {
> -       int i;
>          bool dirty;
> -       pte_t *pte;
> +       pte_t *start_pte, pte;
>          spinlock_t *ptl;
>          unsigned long addr;
>          int total = 0;
> @@ -3499,29 +3498,31 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>          struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
>          DEFINE_MAX_SEQ(walk->lruvec);
>          int gen = lru_gen_from_seq(max_seq);
> +       unsigned int nr;
>          pmd_t pmdval;
>   
> -       pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
> -       if (!pte)
> +       start_pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
> +       if (!start_pte)
>                  return false;
>   
>          if (!spin_trylock(ptl)) {
> -               pte_unmap(pte);
> +               pte_unmap(start_pte);
>                  return true;
>          }
>   
>          if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
> -               pte_unmap_unlock(pte, ptl);
> +               pte_unmap_unlock(start_pte, ptl);
>                  return false;
>          }
>   
>          lazy_mmu_mode_enable();
>   restart:
> -       for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
> +       for (addr = start, pte = start_pte; addr != end; addr += nr * PAGE_SIZE, pte += nr) {
>                  unsigned long pfn;
>                  struct folio *folio;
> -               pte_t ptent = ptep_get(pte + i);
> +               pte_t ptent = ptep_get(pte);
>   
> +               nr = 1;
>                  total++;
>                  walk->mm_stats[MM_LEAF_TOTAL]++;
>   
> @@ -3533,7 +3534,16 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>                  if (!folio)
>                          continue;

Thanks for the code. I considered simplifying the logic this way, but 
this logic would be incorrect. Because the 'start' can be updated by the 
get_next_vma() below, when we goto restart, we will get a new 'i' value 
by 'pte_index(start)', so I kept the 'i' variable.

>>   	walk_update_folio(walk, last, gen, dirty);
>> @@ -4166,7 +4178,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
>>    * the PTE table to the Bloom filter. This forms a feedback loop between the
>>    * eviction and the aging.
>>    */
>> -bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>> +bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>>   {
>>   	int i;
>>   	bool dirty;
>> @@ -4184,12 +4196,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>>   	struct lruvec *lruvec;
>>   	struct lru_gen_mm_state *mm_state;
>>   	unsigned long max_seq;
>> +	pte_t *cur_pte;
>>   	int gen;
>>   
>>   	lockdep_assert_held(pvmw->ptl);
>>   	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
>>   
>> -	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
>> +	if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
>>   		return false;
>>   
>>   	if (spin_is_contended(pvmw->ptl))
>> @@ -4229,10 +4242,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>>   
>>   	pte -= (addr - start) / PAGE_SIZE;
>>   
>> -	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
>> +	for (i = 0, addr = start, cur_pte = pte; addr != end;
>> +	     i += nr, cur_pte += nr, addr += nr * PAGE_SIZE) {
>>   		unsigned long pfn;
>> -		pte_t ptent = ptep_get(pte + i);
>> +		pte_t ptent = ptep_get(cur_pte);
>>   
>> +		nr = 1;
> 
> Can't you just use pte and increment that, right?
> 
> "pte" is not used afterwards.

Yes. Will do. Thanks for your comments.

