Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BCFEC5DF83
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8106B041F; Tue, 18 Aug 2026 05:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958DF6B078E; Tue, 18 Aug 2026 05:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8210A6B0792; Tue, 18 Aug 2026 05:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E710A6B041F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:20:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74D8FA386F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:20:41 +0000 (UTC)
X-FDA: 85113845082.13.98C9D98
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CCE4140006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:20:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W1/rOEwN";
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787044839;
	b=A8aFZRD3noQfwFYoquzH1ynkaLclw3gKmZ2UbURt4/+54VJBPynvMuJ3rAYzdIKk4B2J1E
	owbhqoeh6yZxNzCsDbOFha5M1Hy0vlc1ztpFv+yTUQP3/H9WIolcEotmmSegZRt1uowPIh
	k6mvpRmImZsUrhVOTWHW0rG9UefvSjE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W1/rOEwN";
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787044839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iaMFEkENevOiafYJhQSzgJjYXspgKydE1cZb/53whg=;
	b=hggY8RTV/bs7YvronM3cNVSYde56Z/R8ejNuktETL0O9vVC78HfZz1aawzzzF08xcegPdx
	ZpHnTE73YTx4J5r/AoQ1W6qD4YpwscMgeQWP7t1KYl0Nh7kLR3ItE02t/vr9AohojaFD0Q
	ep2qHfQ43P0Zi29/GPQebT7dMbSYD9c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=B1m6agvmeh0+Uq3KM3O2ABateFoLYnXjxIldxiUU5DY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787044838; v=1; x=1787649638;
 b=W1/rOEwNCrcocXF0rGLJGMXPVcd488WUGrrF0fuvY8JZ+a6JcJqi03JP9hixULMVWTbONSRR
 +KnhQMa/+Hl4QENdc/PwNW6Smpu3O48n6KwbCQFgFm9Rw5GuTEMi6JjUc2+589AN013X7M8A+9a
 VBP8A9i7OKOMuy+PSkYLL/Vw=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 178fe688d0370b01;
	Tue, 18 Aug 2026 09:20:38 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: linmiaohe@huawei.com
Cc: shivankg@amd.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	kmanaouil.dev@gmail.com,
	fvdl@google.com,
	kinseyho@google.com,
	weixugc@google.com,
	bharata@amd.com,
	rientjes@google.com,
	dev.jain@arm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 7/7] mm/rmap: batch the unmap of large folios in try_to_migrate_one()
Date: Tue, 18 Aug 2026 17:20:32 +0800
Message-Id: <20260818092032.47670-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <860941c2-287f-f88f-920c-6d99e2cd4483@huawei.com>
References: <860941c2-287f-f88f-920c-6d99e2cd4483@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7CCE4140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bcx1ijwws6ty1wxhradkwr4k9d1utaih
X-HE-Tag: 1787044839-644
X-HE-Meta: U2FsdGVkX19Rm8LJznTmc7tHSaWCukPehG/BerXfEjBFoQTxg9I8rLeSH1GVhLygGy2pxc/BOgMpFNefJXr61fHLRws1q8rKjQTIJj1a2CP/vy0Bzf5eec4Bg7KGZaEpUfHtr8tUaf69nSsXrHzwZWXc2bw1slj58OVrGJk/HOGi+1J96CSYGLl+4Xk0OaR6ims7BpzF2m4rDZt0rqXpwI0hYdn1TxG4ojtBydfx9XpgFlSoLR33OlDbMWUv+LSCmVhuVxUTiNpV4dRo/517c9EWGGOcajlFtdO60IbJQo+4J7ZsUuLUfEMm0eSJFsZsgT3R+bxX1XtSjXwky/EmhE1dkun3L58igUnWV/5ELrfyVufuxHDNTeveZ76DQk1spNIdM0Zj9/mR31LzNclwnsVqesEYtprTf3Mpp5i1vtWJXr1iIquuSqS/5N+1uWbfAfty6RKz2YyE0RoNZYKm/63+D7X+KNQ7kIZDorqmFXMrv8uAEFIR3r7c/cOk7SAw0oqmaDR9lAkIt/ZPJdO4blKH6yIf1fQTSuXLNzRKc7lKmkz+Qp0QbtztAUl+Ue9gLRzf7BMZtEWH4Z/dKABAjmseSkK11xotoN8QkjyK5ii03Nl5NRkacEfEBvpkP4JeppV6DWr0WDv2TLp88b/M20bQFYvyxvSJSsgAsmPFNSfjqxf4m59qvwXC8UhATIVETkvO08yTjF9raouO1Rm4JOeM56ZyrmlVv1/occZin8Pn7rRbHLQfA7hRWokcLQFM88pJ37pEXWjZozUrd2d28dnBqjL1cc+dY0wUZv/I6lOj/6ZE2LjALelCimQOZaQK2og7/Lwg6xzqrGrLhZVKKTWvtGFkaQyQAOgf/N8qcR2xIsWSIfD53J7mGDCR1S9P3lIFN1tGkI8gLBf0WHzCVMprbKk5I81C67Jdr1T/BHjrIPKuqiJ5VWC7kFN0sZGj/iRxYSvYBSIg40VG/wv
 cxRuz7YJ
 pHRcEUjccucxTeq55e4TH6+Bgi/cIYT08S3/Uyse1Yk8dO0RsR3vYb0nYlDrdFOxVaSxheVYfEHRFaWJZyJ4oQvvQtBsiMC9Rodf6zvAZBjup7aOV3etuf/szYNbjrjQBk2scmfXiZach6ZTeDjRmKxihxDvzmrp2gHMvM1BNqSK/y1nW9j+gskvTjn+YThJQdovDsaqD0cp5fC+eBbZdfYHcPZtlAzR1xB4DG4R5QgeX3hqMwNfAK3CuNXwP9BUQzF8XprhE/45kH18Fbe2wMHh74mOPpq8P5eV8tpYNb1gx0TLptRNfyqCUIYifJorA9uHYxAU2fhh2j4edTcFTMYe2APHi+IcLEzV926lB83FodL8qG1cCEl6WRyQk7cR7GSit1H3vhPlyaMGizOelJhLe8r0shmwZ5m7+UNSse73w/QxvV1BnwoTxLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 18, 2026 at 04:55:06PM +0800, Miaohe Lin wrote:
>On 2026/8/17 17:14, Lance Yang wrote:
>> +Cc Miaohe
>> 
>> On Thu, Aug 13, 2026 at 04:23:18AM +0000, Shivank Garg wrote:
>>> try_to_migrate_one() converts present PTEs to migration entries one at a
>>> time. For a PTE-mapped large folio, this repeat calls to ptep clear+flush,
>>> the migration entry build and set, folio_remove_rmap_pte() and folio_put(),
>>> each re-entering page_vma_mapped_walk() once per base page (256 times for
>>> 1M folio).
>>>
>>> Mirror try_to_unmap_one() to introduce folio_migrate_pte_batch() to detect
>>> eligible batch for PTEs mapping conseuctive subpages of a large folios,
>>> and convert the whole batch in one shot using the batched helpers.
>>>
>>> A side-effect of this change is trace_set_migration_pte() will record
>>> one event per batched run instead of earlier behavior of one per base page.
>>>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>> mm/rmap.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++----------------
>>> 1 file changed, 86 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 35752a70f3a0..63b885c0b7ef 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2675,6 +2675,44 @@ static bool try_to_migrate_hugetlb_one(struct folio *folio,
>>> 	return ret;
>>> }
>>>
>>> +static inline unsigned int folio_migrate_pte_batch(struct folio *folio,
>>> +		struct page_vma_mapped_walk *pvmw, pte_t pte,
>>> +		struct page *subpage, bool anon_exclusive)
>>> +{
>>> +	unsigned long end_addr, addr = pvmw->address;
>>> +	struct vm_area_struct *vma = pvmw->vma;
>>> +	unsigned int max_nr, nr;
>>> +
>>> +#ifdef __HAVE_ARCH_UNMAP_ONE
>>> +	/* Cannot batch unmap if arch_unmap_one() is defined. */
>>> +	return 1;
>>> +#endif
>>> +
>>> +	if (!folio_test_large(folio))
>>> +		return 1;
>>> +	if (folio_is_zone_device(folio) || folio_test_has_hwpoisoned(folio))
>>> +		return 1;
>>> +	if (pte_unused(pte))
>>> +		return 1;
>>> +
>>> +	/* We may only batch within a single VMA and a single page table. */
>>> +	end_addr = pmd_addr_end(addr, vma->vm_end);
>>> +	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>> 
>> Hmm ... can this still batch over a poisoned tail page?
>> 
>> memory_failure() sets PageHWPoison() before taking folio lock, but
>> cannot set PG_has_hwpoisoned until it acquires and releases that lock.
>> 
>> So tail page can already be poisoned while folio_test_has_hwpoisoned()
>> still returns false ... no?
>
>When memory error hits thp pages, memory_failure() first set PG_has_hwpoisoned and
>then tries to split thp pages. And try_to_migrate() will be called to set migration
>entries for anon pages. Does folio_migrate_pte_batch() work on this case? If so, the
>folio_test_has_hwpoisoned() check above could catch the bad pages?
>
>Or do you worry about the scene that meory error hits a thp while it's under migration?

Yeah, latter case is exactly what I meant.

try_to_migrate() is called with folio lock held. If migration already
owns the lock, memory_failure() can set PageHWPoison() on a tail page and
then block in folio_lock(), before reaching folio_set_has_hwpoisoned().
try_to_migrate_one() may meanwhile start from a healthy subpage, see
PageHWPoison(subpage) clear and PG_has_hwpoisoned still clear, then batch
across poisoned tail and install a normal migration entry for it.

Once memory_failure() publishes PG_has_hwpoisoned, the folio-level check
does stop batching, as you said. It's just this window before publication
that worries me ...

Thanks, Lance

>Thanks both.
>.
>
>> 
>> Starting from a healthy first subpage, folio_migrate_pte_batch() can
>> then batch across poisoned tail page. hwpoison only describes first
>> subpage, so set_softleaf_ptes() installs a normal migration entry for
>> poisoned page instead of an HWPoison entry ...
>> 
>> Should folio_migrate_pte_batch() check PageHWPoison() on every candidate
>> subpage and stop before a poisoned one?
>> 
>> Cheers, Lance
>> 
>> 
>>> +	/*
>>> +	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>>> +	 * upgrading write permissions for ptes that were not originally writable,
>>> +	 * and to avoid losing the soft-dirty bit, use the appropriate FPB flags.
>>> +	 */
>>> +	nr = folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>>> +				   FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>> +
>>> +	/* Limit possible batch count to a uniform PageAnonExclusive value */
>>> +	if (folio_test_anon(folio))
>>> +		nr = page_anon_exclusive_batch(0, nr, subpage, anon_exclusive);
>>> +
>>> +	return nr;
>>> +}
>>> +
>>> /*
>>>  * @arg: enum ttu_flags will be passed to this argument.
>>>  *
>>> @@ -2686,12 +2724,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> {
>>> 	struct mm_struct *mm = vma->vm_mm;
>>> 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>>> -	bool anon_exclusive, writable, ret = true;
>>> +	bool anon_exclusive, hwpoison, writable, ret = true;
>>> 	pte_t pteval;
>>> 	struct page *subpage;
>>> 	struct mmu_notifier_range range;
>>> 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>>> -	unsigned long pfn;
>>> +	unsigned long pfn, end_addr, nr_pages;
>>>
>>> 	/*
>>> 	 * When racing against e.g. zap_pte_range() on another cpu,
>>> @@ -2744,11 +2782,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>>> 					!folio_test_pmd_mappable(folio), folio);
>>>
>>> -			if (set_pmd_migration_entry(&pvmw, subpage)) {
>>> -				ret = false;
>>> -				page_vma_mapped_walk_done(&pvmw);
>>> -				break;
>>> -			}
>>> +			if (set_pmd_migration_entry(&pvmw, subpage))
>>> +				goto walk_abort;
>>> 			continue;
>>> #endif
>>> 		}
>>> @@ -2773,10 +2808,25 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> 		subpage = folio_page(folio, pfn - folio_pfn(folio));
>>> 		anon_exclusive = folio_test_anon(folio) &&
>>> 				 PageAnonExclusive(subpage);
>>> +		/*
>>> +		 * memory_failure() can set PageHWPoison concurrently without holding
>>> +		 * the folio lock. Snapshot the flag here to decide whether to batch
>>> +		 * PTEs or install hwpoison entry.
>>> +		 */
>>> +		hwpoison = PageHWPoison(subpage);
>>>
>>> +		nr_pages = 1;
>>> 		if (likely(pte_present(pteval))) {
>>> -			flush_cache_page(vma, address, pfn);
>>> -			/* Nuke the page table entry. */
>>> +			if (!hwpoison)
>>> +				nr_pages = folio_migrate_pte_batch(folio, &pvmw,
>>> +								   pteval, subpage,
>>> +								   anon_exclusive);
>>> +
>>> +			end_addr = address + nr_pages * PAGE_SIZE;
>>> +			flush_cache_range(vma, address, end_addr);
>>> +
>>> +			/* Nuke the page table entries. */
>>> +			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>>> 			if (should_defer_flush(mm, flags)) {
>>> 				/*
>>> 				 * We clear the PTE but do not flush so potentially
>>> @@ -2786,11 +2836,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> 				 * transition on a cached TLB entry is written through
>>> 				 * and traps if the PTE is unmapped.
>>> 				 */
>>> -				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
>>> -
>>> -				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
>>> +				set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
>>> 			} else {
>>> -				pteval = ptep_clear_flush(vma, address, pvmw.pte);
>>> +				flush_tlb_range(vma, address, end_addr);
>>> 			}
>>> 			if (pte_dirty(pteval))
>>> 				folio_mark_dirty(folio);
>>> @@ -2809,7 +2857,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> 		/* Update high watermark before we lower rss */
>>> 		update_hiwater_rss(mm);
>>>
>>> -		if (PageHWPoison(subpage)) {
>>> +		if (hwpoison) {
>>> +			VM_WARN_ON_ONCE(nr_pages != 1);
>>> 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
>>>
>>> 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>>> @@ -2837,19 +2886,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> 			 * so we'll not check/care.
>>> 			 */
>>> 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>>> -				ret = false;
>>> -				page_vma_mapped_walk_done(&pvmw);
>>> -				break;
>>> +				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>>> +				goto walk_abort;
>>> 			}
>>>
>>> -			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
>>> +			/* See folio_try_share_anon_rmap_ptes(): clear PTE first. */
>>> 			if (anon_exclusive &&
>>> -			    folio_try_share_anon_rmap_pte(folio, subpage)) {
>>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>>> -				ret = false;
>>> -				page_vma_mapped_walk_done(&pvmw);
>>> -				break;
>>> +			    folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
>>> +				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>>> +				goto walk_abort;
>>> 			}
>>>
>>> 			/*
>>> @@ -2859,19 +2904,31 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> 			 */
>>> 			swp_pte = make_migration_pte(subpage, pteval,
>>> 						     writable, anon_exclusive);
>>> -			set_pte_at(mm, address, pvmw.pte, swp_pte);
>>> 			trace_set_migration_pte(address, pte_val(swp_pte),
>>> 						folio_order(folio));
>>> +
>>> +			/* Set nr_pages migration entries, advancing the PFN. */
>>> +			set_softleaf_ptes(mm, address, pvmw.pte, swp_pte, nr_pages);
>>> 			/*
>>> 			 * No need to invalidate here it will synchronize on
>>> 			 * against the special swap migration pte.
>>> 			 */
>>> 		}
>>>
>>> -		folio_remove_rmap_pte(folio, subpage, vma);
>>> -		if (vma->vm_flags & VM_LOCKED)
>>> -			mlock_drain_local();
>>> -		folio_put(folio);
>>> +		finish_folio_unmap(vma, folio, subpage, nr_pages);
>>> +
>>> +		/*
>>> +		 * If we batched the entire folio, there is nothing left to
>>> +		 * walk; stop right here.
>>> +		 */
>>> +		if (nr_pages == folio_nr_pages(folio))
>>> +			goto walk_done;
>>> +		continue;
>>> +walk_abort:
>>> +		ret = false;
>>> +walk_done:
>>> +		page_vma_mapped_walk_done(&pvmw);
>>> +		break;
>>> 	}
>>>
>>> 	mmu_notifier_invalidate_range_end(&range);
>>>
>>> -- 
>>> 2.43.0
>>>
>>>
>> .
>> 
>
>

