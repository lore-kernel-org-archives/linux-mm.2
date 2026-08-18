Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1964FC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C2A6B0207; Tue, 18 Aug 2026 04:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113BC6B020F; Tue, 18 Aug 2026 04:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0299A6B020E; Tue, 18 Aug 2026 04:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9E6B6B0590
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:55:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 324101C1FCF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:55:21 +0000 (UTC)
X-FDA: 85113781242.26.98C0322
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4E0AB180008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:55:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=khK6KdnF;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787043319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4mZniCDA8t7+WaShjbdSaKjsh0mLEC6shWNiqjBdH4=;
	b=pDrdAy7TTDbbBeXaY4NPue4i3bl3I9bo0cEy4IRd0d9AGORKnC9KKxf7jQfBAk4F6JCcwm
	woEQPPIhosjxB2l1LuaW7neW46roY0ZUvMaSUAUF0/MnHvygMYfG6XzELr5pRZEHtvxUXQ
	VHdZ/ewybuwczFbR/8Yzwz//8jYNL+M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=khK6KdnF;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787043319;
	b=kCtGhKTW5AydiPVALDLNVe3Wyh3RrQfVyxfLs8JAVVy9fiQAxcrKVLApwHtokyC03LseZU
	+CSxVRoVbhsk+gEBBSPLry5X3o+0ocRD0lWkV7xq55+/fTD9eqYcnhtF/WooiOQxMjz4DO
	6aLzATLqYnH+S8VTU7Y8JU7vC8jAa6k=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N4mZniCDA8t7+WaShjbdSaKjsh0mLEC6shWNiqjBdH4=;
	b=khK6KdnF9jQJ1MFIVA0f6gyRBr687iqbT2CxAuZF/Jzmz87t6A7YIJN4NU+W6PanhZsDqwBgU
	kf1ip0l6bQQSOeX7oHAwkrkl8ZEbumYCxNiFA5/zSynw0SGG0strcpvQuwG6vxkhFky4O9Kyy6v
	JOWRKKQivdzgoVNvU8GRpEA=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hPNYB1HLzzRhRG;
	Tue, 18 Aug 2026 16:44:30 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 102A64058C;
	Tue, 18 Aug 2026 16:55:09 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Aug 2026 16:55:08 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Aug 2026 16:55:07 +0800
Subject: Re: [PATCH v2 7/7] mm/rmap: batch the unmap of large folios in
 try_to_migrate_one()
To: Lance Yang <lance.yang@linux.dev>, <shivankg@amd.com>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<riel@surriel.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<harry@kernel.org>, <jannh@google.com>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <kmanaouil.dev@gmail.com>, <fvdl@google.com>,
	<kinseyho@google.com>, <weixugc@google.com>, <bharata@amd.com>,
	<rientjes@google.com>, <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260813-migrate-rmap-batch-v2-7-3c5424c555c7@amd.com>
 <20260817091444.58876-1-lance.yang@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <860941c2-287f-f88f-920c-6d99e2cd4483@huawei.com>
Date: Tue, 18 Aug 2026 16:55:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260817091444.58876-1-lance.yang@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E0AB180008
X-Rspamd-Server: rspam07
X-Stat-Signature: zjkkr8gayu7zb5t7ftj9m4czraksc9fy
X-HE-Tag: 1787043317-159576
X-HE-Meta: U2FsdGVkX1954jWqya3v4BZvdeuaxQvU5im2CtHtEuvZlwiG6QSVgPy0Yt4JhAVQ2lGdO30i+KI5LOfF9wX21xWOn0vqGcyRD5s1IfCThJ2mfG3PoMymjGpA9e2oAdQ7/XK+tt4enZloX3qccPgY65AzRCr4lkUauDhavXE6ixQ0woqvt6Uwrro70pdm3zUqOTgFT7kqYBSmjnFqDczn6/1/dnZPEG26MhtM8MdXJAcSc0OXv7t5AbJk4JywH0KMS4WDqwStWJL1i2lJK8W8WOhL5fpGJ9t9i5MLF7lGS5okpQXzjLxaFMUHkP8qa7rchCUnlB9Bbuf3t5QeDWTjHU6JXqt8ybl4GUCVOBcOhemLxSP6eeKwXEUXdpdqalopoZLd71JFoTSN2svVWmqK+I47WBy0X/5YYdaqVMEs78p1KY9QswHbV3A88wkoAyZS6xRf8L7z8gNN58oaGFO934ldJ2XIXoC4UmJTZ19Rb0jhTMdPGW5gUZ6pamjqffhaspQffgROAXoXNvI1WflL8kbAJD8NAEBRWIC5lIpf37hOXgZ+VdlNJvwG+vO7vaTXJSca0P9PtYadUn4FOaVRTlB+YBKnnYP/JgI1ZFnTBNTlYGKuqcOgFNzymNHgUzEAlw4MNV87ulYU+B2jbysDUy6tyFjUnJXqe8YH5imw5KB4To4Y+cZqzKypgDvajSV0x5pXTLngcxRz1+WUG0Uv+/io3ASl545yAPXnjxk4rZ0s5cQvQqkMF/R4eOZakaYB5fS91eB3UpOB30IhtRqb4mMjcu5LMvIZI1V9dk92U7Z6K4OEEc/Hqy/W88VuBdtLpaMo7l3bBjpfpKcujPR79kz7zJquM8m7bOjB7q5yec49bel8caVhRbhsP4k2r4dSq5Y+pl/PhkNlfJW+HqRV1kV4VUKcOxHCVdAtCTe402JZ+rqTlmFVwPbjltNdBg13JvZm812wP1driavp4IC
 XBkfSrwh
 viSzByiU8lOkUA/4s1TZbfmfLCa+hw2F1NnpIwhHmp1L8h096nL6LNttF0IkHQN06CUwE0TN9fi/4o/sD4FWaIlsU3Xl1WUqDMO8/geltNRt+LjdcF3vkePn19MoHqSsJk76/1KpoAOYF7L5UHNGKkG2WYP/SNJHiuXHK+inHeviwN71NL0ZoQ6w1r1FbA9XvsK0HbWBd5IlfC6lLPkOUJYFVBscb0vWurnxhVps2+Uh/WNnzWFBpho6CaKb5ruL9GHe1Py0tCypN4PfHVtFNc97o6n9D5CGl9V+t9YxoPR+Nh1uh+ah9fig+vSHAZeOwtuzcim5MKqsbNWxk293V5x4Wanlyz3Ju1/XW1P1WwYxnvIgBvCIHOeXN/3IaG0UqxXE5A+QuSIlW9Ubji00WzDsLapsd11smiw22YWeFCNuG8DM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/17 17:14, Lance Yang wrote:
> +Cc Miaohe
> 
> On Thu, Aug 13, 2026 at 04:23:18AM +0000, Shivank Garg wrote:
>> try_to_migrate_one() converts present PTEs to migration entries one at a
>> time. For a PTE-mapped large folio, this repeat calls to ptep clear+flush,
>> the migration entry build and set, folio_remove_rmap_pte() and folio_put(),
>> each re-entering page_vma_mapped_walk() once per base page (256 times for
>> 1M folio).
>>
>> Mirror try_to_unmap_one() to introduce folio_migrate_pte_batch() to detect
>> eligible batch for PTEs mapping conseuctive subpages of a large folios,
>> and convert the whole batch in one shot using the batched helpers.
>>
>> A side-effect of this change is trace_set_migration_pte() will record
>> one event per batched run instead of earlier behavior of one per base page.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>> mm/rmap.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++----------------
>> 1 file changed, 86 insertions(+), 29 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 35752a70f3a0..63b885c0b7ef 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2675,6 +2675,44 @@ static bool try_to_migrate_hugetlb_one(struct folio *folio,
>> 	return ret;
>> }
>>
>> +static inline unsigned int folio_migrate_pte_batch(struct folio *folio,
>> +		struct page_vma_mapped_walk *pvmw, pte_t pte,
>> +		struct page *subpage, bool anon_exclusive)
>> +{
>> +	unsigned long end_addr, addr = pvmw->address;
>> +	struct vm_area_struct *vma = pvmw->vma;
>> +	unsigned int max_nr, nr;
>> +
>> +#ifdef __HAVE_ARCH_UNMAP_ONE
>> +	/* Cannot batch unmap if arch_unmap_one() is defined. */
>> +	return 1;
>> +#endif
>> +
>> +	if (!folio_test_large(folio))
>> +		return 1;
>> +	if (folio_is_zone_device(folio) || folio_test_has_hwpoisoned(folio))
>> +		return 1;
>> +	if (pte_unused(pte))
>> +		return 1;
>> +
>> +	/* We may only batch within a single VMA and a single page table. */
>> +	end_addr = pmd_addr_end(addr, vma->vm_end);
>> +	max_nr = (end_addr - addr) >> PAGE_SHIFT;
> 
> Hmm ... can this still batch over a poisoned tail page?
> 
> memory_failure() sets PageHWPoison() before taking folio lock, but
> cannot set PG_has_hwpoisoned until it acquires and releases that lock.
> 
> So tail page can already be poisoned while folio_test_has_hwpoisoned()
> still returns false ... no?

When memory error hits thp pages, memory_failure() first set PG_has_hwpoisoned and
then tries to split thp pages. And try_to_migrate() will be called to set migration
entries for anon pages. Does folio_migrate_pte_batch() work on this case? If so, the
folio_test_has_hwpoisoned() check above could catch the bad pages?

Or do you worry about the scene that meory error hits a thp while it's under migration?

Thanks both.
.

> 
> Starting from a healthy first subpage, folio_migrate_pte_batch() can
> then batch across poisoned tail page. hwpoison only describes first
> subpage, so set_softleaf_ptes() installs a normal migration entry for
> poisoned page instead of an HWPoison entry ...
> 
> Should folio_migrate_pte_batch() check PageHWPoison() on every candidate
> subpage and stop before a poisoned one?
> 
> Cheers, Lance
> 
> 
>> +	/*
>> +	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>> +	 * upgrading write permissions for ptes that were not originally writable,
>> +	 * and to avoid losing the soft-dirty bit, use the appropriate FPB flags.
>> +	 */
>> +	nr = folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>> +				   FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>> +
>> +	/* Limit possible batch count to a uniform PageAnonExclusive value */
>> +	if (folio_test_anon(folio))
>> +		nr = page_anon_exclusive_batch(0, nr, subpage, anon_exclusive);
>> +
>> +	return nr;
>> +}
>> +
>> /*
>>  * @arg: enum ttu_flags will be passed to this argument.
>>  *
>> @@ -2686,12 +2724,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>> {
>> 	struct mm_struct *mm = vma->vm_mm;
>> 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>> -	bool anon_exclusive, writable, ret = true;
>> +	bool anon_exclusive, hwpoison, writable, ret = true;
>> 	pte_t pteval;
>> 	struct page *subpage;
>> 	struct mmu_notifier_range range;
>> 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>> -	unsigned long pfn;
>> +	unsigned long pfn, end_addr, nr_pages;
>>
>> 	/*
>> 	 * When racing against e.g. zap_pte_range() on another cpu,
>> @@ -2744,11 +2782,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>> 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>> 					!folio_test_pmd_mappable(folio), folio);
>>
>> -			if (set_pmd_migration_entry(&pvmw, subpage)) {
>> -				ret = false;
>> -				page_vma_mapped_walk_done(&pvmw);
>> -				break;
>> -			}
>> +			if (set_pmd_migration_entry(&pvmw, subpage))
>> +				goto walk_abort;
>> 			continue;
>> #endif
>> 		}
>> @@ -2773,10 +2808,25 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>> 		subpage = folio_page(folio, pfn - folio_pfn(folio));
>> 		anon_exclusive = folio_test_anon(folio) &&
>> 				 PageAnonExclusive(subpage);
>> +		/*
>> +		 * memory_failure() can set PageHWPoison concurrently without holding
>> +		 * the folio lock. Snapshot the flag here to decide whether to batch
>> +		 * PTEs or install hwpoison entry.
>> +		 */
>> +		hwpoison = PageHWPoison(subpage);
>>
>> +		nr_pages = 1;
>> 		if (likely(pte_present(pteval))) {
>> -			flush_cache_page(vma, address, pfn);
>> -			/* Nuke the page table entry. */
>> +			if (!hwpoison)
>> +				nr_pages = folio_migrate_pte_batch(folio, &pvmw,
>> +								   pteval, subpage,
>> +								   anon_exclusive);
>> +
>> +			end_addr = address + nr_pages * PAGE_SIZE;
>> +			flush_cache_range(vma, address, end_addr);
>> +
>> +			/* Nuke the page table entries. */
>> +			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>> 			if (should_defer_flush(mm, flags)) {
>> 				/*
>> 				 * We clear the PTE but do not flush so potentially
>> @@ -2786,11 +2836,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>> 				 * transition on a cached TLB entry is written through
>> 				 * and traps if the PTE is unmapped.
>> 				 */
>> -				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
>> -
>> -				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
>> +				set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
>> 			} else {
>> -				pteval = ptep_clear_flush(vma, address, pvmw.pte);
>> +				flush_tlb_range(vma, address, end_addr);
>> 			}
>> 			if (pte_dirty(pteval))
>> 				folio_mark_dirty(folio);
>> @@ -2809,7 +2857,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>> 		/* Update high watermark before we lower rss */
>> 		update_hiwater_rss(mm);
>>
>> -		if (PageHWPoison(subpage)) {
>> +		if (hwpoison) {
>> +			VM_WARN_ON_ONCE(nr_pages != 1);
>> 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
>>
>> 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>> @@ -2837,19 +2886,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>> 			 * so we'll not check/care.
>> 			 */
>> 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>> -				ret = false;
>> -				page_vma_mapped_walk_done(&pvmw);
>> -				break;
>> +				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>> +				goto walk_abort;
>> 			}
>>
>> -			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
>> +			/* See folio_try_share_anon_rmap_ptes(): clear PTE first. */
>> 			if (anon_exclusive &&
>> -			    folio_try_share_anon_rmap_pte(folio, subpage)) {
>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>> -				ret = false;
>> -				page_vma_mapped_walk_done(&pvmw);
>> -				break;
>> +			    folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
>> +				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>> +				goto walk_abort;
>> 			}
>>
>> 			/*
>> @@ -2859,19 +2904,31 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>> 			 */
>> 			swp_pte = make_migration_pte(subpage, pteval,
>> 						     writable, anon_exclusive);
>> -			set_pte_at(mm, address, pvmw.pte, swp_pte);
>> 			trace_set_migration_pte(address, pte_val(swp_pte),
>> 						folio_order(folio));
>> +
>> +			/* Set nr_pages migration entries, advancing the PFN. */
>> +			set_softleaf_ptes(mm, address, pvmw.pte, swp_pte, nr_pages);
>> 			/*
>> 			 * No need to invalidate here it will synchronize on
>> 			 * against the special swap migration pte.
>> 			 */
>> 		}
>>
>> -		folio_remove_rmap_pte(folio, subpage, vma);
>> -		if (vma->vm_flags & VM_LOCKED)
>> -			mlock_drain_local();
>> -		folio_put(folio);
>> +		finish_folio_unmap(vma, folio, subpage, nr_pages);
>> +
>> +		/*
>> +		 * If we batched the entire folio, there is nothing left to
>> +		 * walk; stop right here.
>> +		 */
>> +		if (nr_pages == folio_nr_pages(folio))
>> +			goto walk_done;
>> +		continue;
>> +walk_abort:
>> +		ret = false;
>> +walk_done:
>> +		page_vma_mapped_walk_done(&pvmw);
>> +		break;
>> 	}
>>
>> 	mmu_notifier_invalidate_range_end(&range);
>>
>> -- 
>> 2.43.0
>>
>>
> .
> 


