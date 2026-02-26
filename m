Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0064F55451
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 05:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289226B0088; Thu, 26 Feb 2026 00:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2375B6B008A; Thu, 26 Feb 2026 00:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118D86B008C; Thu, 26 Feb 2026 00:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3A3F6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:56:37 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E2885BD61
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:56:37 +0000 (UTC)
X-FDA: 84485548434.20.A36B1CE
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf09.hostedemail.com (Postfix) with ESMTP id 74CA9140003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:56:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jjekpZRR;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772085395; a=rsa-sha256;
	cv=none;
	b=2IB2Vw6e9oBIhBANlBheavds6uQeFYG7CCAWdJ8aUWhCsDUmHPccMN+61r3YBaeM4+EjGc
	U02WQzf2zEx/tI0N+N7Y0818iAM5auY1Gm8LOXPgCxtAdtqFnE2v8mQsfcEyl07nVwz+zk
	1hk59FxTci9j0c2DGha0wPK12Ii8Q7s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jjekpZRR;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772085395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9qs2zE0FueYonacX/ztnskZqTvxRHERhL76d+GCneQ=;
	b=3zfX5Yz1bulVNXjpnMU88sApCfpIZ+9oWVZezhCgitYYnkjI0K9nDWrqzx3dH1GRNTfYaq
	DyGF4PRp0owFnkNNTlcecOFMQxi1qJwzwdlCsW5k9buNmI6/Ctg2m2lyn7nYDH5dhj+wXh
	+PUyZkZDazIN6t4/eNGgmQa0lTs88Mw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772085391; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=A9qs2zE0FueYonacX/ztnskZqTvxRHERhL76d+GCneQ=;
	b=jjekpZRRoQmkHaECBrekxx1mq9aIn+a5iA1VSseMRSSqQ3Y9WofCq+9Rsj7mqJI8toTruGwWtBDYhWFd83WVogzNXoozxwtP9Qu8CIKUv1zaK1UpL0D3Th4lvcvDHX0oAPIPKaDRJ0mLRcwYvx0MteQqAOFqlVxCdsOJpgdAxFI=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzqFsiZ_1772085389 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 13:56:30 +0800
Message-ID: <0871edb9-08a2-46a0-ade6-af842a12e0d3@linux.alibaba.com>
Date: Thu, 26 Feb 2026 13:56:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm: support batched checking of the young flag for
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
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <84d2426c63c1eafeaa0cfbad7c5cc11e9c11b980.1771897150.git.baolin.wang@linux.alibaba.com>
 <2e7a1e24-3616-4b79-b943-b5f7efde2d31@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <2e7a1e24-3616-4b79-b943-b5f7efde2d31@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74CA9140003
X-Stat-Signature: 7q4sjif4tmzks6e8xh1oethgd54ric6w
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772085394-349582
X-HE-Meta: U2FsdGVkX1+75uKDr+ksuXSni9LO/lrQdm0oggGmQplv85ESNCyos97d/r+j8HodFU41/0T5/eepSjd6RdkNoYWPQrnb3LiN7oJ4++CSnTgFXKxqbGXOfC8zMZPYtfm81QAazUDrqt/6IoVqtm+NSfCaEM3cEWWxruIU0nsnh/PTnwv24QoLgMTVq7q8Vdi4poRt2GDRB/t2UioCQYIiIVm/l2Fp5d5lNn4S89q1UpH091Qb7BJBEfNGf7AyFKvhtN2cSliehSrWYlk3A62viaHONK1iWpWTbawIGV0+jag7MWHky338jpzwjwb3DbSGEJivAkIWbfVd39Kdr8a463nRJO/A4o6gjv27mcrVVE377Lqj7imvbO0c8/V97C9AlVnJl2XVt9oeYONOLbpCB1r7AbzGD2uGm2A+wmifi2L7ij2UkLe7ffOomgpq/6EWiqFo5INmQtZwwYWKUQJvRmE3NffYUJVJEZP3B3ppNs3+oawPTYRebveG9C8hAqMkRX8U+HgsRXfDYc6iZ8bfZPae32GU+zKBygoXf9je407XySmpX+QW0hGbSFb/gTnSHP+ISxbNJeudCaju5eVAHl52oUXDT+km+pCWsosDAZCOXVCa455uHgi0ptdVgqsZaqEN5714pDPzZVBLrfQudXQCwWnl7Rzu9KDYlVIYqa9xYdgdWkJmkAuwnS2fIijEPUkGqvf7+dpA9MbonFt9aKiY4Mrx6ciazQRT6Uxpua+MGj3x6lo5nlMNevv+tlSbHH2PyDdU4O27EcaoSbVYco+QsswmEBT5mBNW8adQHfsyGWYQ1e9uhZB3btevBMhc1fls2DKGfKUujPduDgXLulN9yhAjBfz1X9zRKeHzCsv5vJz3jybMP/zH0ggwM4nQf37ImjBL3j10K/M2WeDsS1msM3vtqGOJGyOALWmozSv0FPpQL6FIR88T3F+4QkL3bbk5AcC5yztvyqdjT3z
 C0sFXg4w
 sNcNvsdKfQGXYBj2hbZE8LU2+wUMhPQ3Flb26Y48a2s/Opft2rAbuHDffNvlnRHoOv9huxnnfWXh5cmS+lI9UU9MK0P25l+qT7gJTiTRZCzPgfuHu9fo7uvHTcbmOEVpcMWqRAOYGEN0Kf29LZx3S3opDJiPlcgyfU4QNuiQCSCBZ3VQolxR2tSvlB4fYt/XlszyKICyx2qXXciunWOHq6j2kyLCVq8rsri2kx+wInHmMJMJcA3vp8pj7Mxy5faM9lUzVHvHy1bUnrxWq3LEmwEST4ttdtjTA90cC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/25/26 10:25 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 02:56, Baolin Wang wrote:
>> Use the batched helper clear_young_ptes_notify() to check and clear the
>> young flag to improve the performance during large folio reclamation when
>> MGLRU is enabled.
>>
>> Meanwhile, we can also support batched checking the young and dirty flag
>> when MGLRU walks the mm's pagetable to update the folios' generation
>> counter. Since MGLRU also checks the PTE dirty bit, use folio_pte_batch_flags()
>> with FPB_MERGE_YOUNG_DIRTY set to detect batches of PTEs for a large folio.
>>
>> Then we can remove the ptep_clear_young_notify() since it has no users now.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
> 
> [...]
> 
>>   
>> -static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
>> -					  unsigned long addr, pte_t *ptep)
>> -{
>> -	return clear_young_ptes_notify(vma, addr, ptep, 1);
>> -}
>> -
>>   static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
>>   					  unsigned long addr, pmd_t *pmdp)
>>   {
>> @@ -1847,12 +1841,6 @@ static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
>>   #define clear_young_ptes_notify	test_and_clear_young_ptes
>>   #define pmdp_clear_young_notify	pmdp_test_and_clear_young
>>   
>> -static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
>> -					  unsigned long addr, pte_t *ptep)
>> -{
>> -	return test_and_clear_young_ptes(vma, addr, ptep, 1);
>> -}
>> -
> 
> Oh, we remove the last user, nice.
> 
> 
>>   #endif /* CONFIG_MMU_NOTIFIER */
>>   
>>   #endif	/* __MM_INTERNAL_H */
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index be785dfc9336..1c147251ae28 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -958,25 +958,21 @@ static bool folio_referenced_one(struct folio *folio,
>>   			return false;
>>   		}
>>   
>> +		if (pvmw.pte && folio_test_large(folio)) {
>> +			unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
>> +			unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
> 
> Both could be const.

Ack.

> 
>> +			pte_t pteval = ptep_get(pvmw.pte);
> 
> I wonder if there could be a way to avoid this ptep_get() by letting
> page_vma_mapped_walk() just provide the last value it used (in
> check_pte() I guess). Something for another patch.

Well, we’d need to add a new field to ‘struct page_vma_mapped_walk’ to 
store the last value (e.g., pvmw.pteval), but this makes me wonder if it 
is worth adding a new field just to avoid a lightweight read (which 
should have no obvious performance impact).

>> +
>> +			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
>> +			ptes += nr;
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
>> @@ -995,6 +991,12 @@ static bool folio_referenced_one(struct folio *folio,
>>   			page_vma_mapped_walk_done(&pvmw);
>>   			break;
>>   		}
>> +
>> +		/* Skip the batched PTEs */
>> +		if (nr > 1) {
>> +			pvmw.pte += nr - 1;
>> +			pvmw.address += (nr - 1) * PAGE_SIZE;
>> +		}
> 
> As nr >= 1, you can just unconditionaly do
> 
> pvmw.pte += nr - 1;
> pvmw.address += (nr - 1) * PAGE_SIZE;

Actually, I want to filter out the THP case where the 'pvmw.pte' is 
NULL. But it shouldn’t be a problem, because 'nr' is always 1 for the 
THP case. I can remove the check.

>>   	}
>>   
>>   	if (referenced)
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 728868c61750..d83962468b2e 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3494,6 +3494,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>>   	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
>>   	DEFINE_MAX_SEQ(walk->lruvec);
>>   	int gen = lru_gen_from_seq(max_seq);
>> +	unsigned int nr;
>>   	pmd_t pmdval;
>>   
>>   	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
>> @@ -3512,11 +3513,13 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>>   
>>   	lazy_mmu_mode_enable();
>>   restart:
>> -	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
>> +	for (i = pte_index(start), addr = start; addr != end; i += nr, addr += nr * PAGE_SIZE) {
>>   		unsigned long pfn;
>>   		struct folio *folio;
>> -		pte_t ptent = ptep_get(pte + i);
>> +		pte_t *ptep = pte + i;
>> +		pte_t ptent = ptep_get(ptep);
> 
> 
> Existing "pte vs ptent" vs. "ptep vs. pte" is already confusing.
> Combining them into "pte vs. ptep vs. ptent" is no good.
> 
> If you need another variable, call it "cur_pte". Or rename "pte" to
> "start_pte".

OK. "cur_pte" sounds good to me.

>> +		nr = 1;
>>   		total++;
>>   		walk->mm_stats[MM_LEAF_TOTAL]++;
>>   
>> @@ -3528,7 +3531,14 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>>   		if (!folio)
>>   			continue;
>>   
>> -		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
>> +		if (folio_test_large(folio)) {
>> +			unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
>> +
>> +			nr = folio_pte_batch_flags(folio, NULL, ptep, &ptent,
>> +						   max_nr, FPB_MERGE_YOUNG_DIRTY);
>> +		}
>> +
>> +		if (!clear_young_ptes_notify(args->vma, addr, ptep, nr))
>>   			continue;
>>   
>>   		if (last != folio) {
>> @@ -4186,7 +4196,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
>>    * the PTE table to the Bloom filter. This forms a feedback loop between the
>>    * eviction and the aging.
>>    */
>> -bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>> +bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int batched)
> 
> What is "batched"? Did you mean "nr_ptes" ? Or just the initial value
> for "nr" ?

There is already an 'nr' variable in this function. "nr_ptes" sounds 
good to me, and will use it.

>> -		if (!ptep_clear_young_notify(vma, addr, pte + i))
>> +		if (folio_test_large(folio)) {
>> +			unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
> 
> Can be const.

Ack.

> 
>> +
>> +			nr = folio_pte_batch_flags(folio, NULL, ptep, &ptent,
>> +						   max_nr, FPB_MERGE_YOUNG_DIRTY);
>> +		}
> 
> I guess we might benefit from a FPB_MERGE_YOUNG only here. But this
> should work.

I’ve thought about it. Instead of adding another flag and some new 'if' 
branches for folio_pte_batch_flags(), and given that it brings no 
performance improvement for MGLRU, I still prefer the current 
FPB_MERGE_YOUNG_DIRTY method. :)

Thanks for reviewing.

