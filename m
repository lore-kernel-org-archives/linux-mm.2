Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3E3C5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590E96B0092; Wed, 19 Aug 2026 05:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542786B0095; Wed, 19 Aug 2026 05:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431446B0098; Wed, 19 Aug 2026 05:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125AF6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:42:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69C394048D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:42:37 +0000 (UTC)
X-FDA: 85117529154.22.BD869DE
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA13C140009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:42:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KBjAvsHg;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787132555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dffCyQdhxpyTf0QdT24ZzmspKjAdOG5vF+UT74r+vrg=;
	b=zZdOp+xC3nO7MnDwKscgwHmLnk44aH82z+DHUTBh0nWTzqunw5WR6m0LHNx5jY1swCK6Qb
	qcA6TRbEY78WvQi1ljp3EFDna/tU1rqg5GFAMJQTJfPgdCGTU0QrzPC+kQVnVBAZa1IgW2
	dz88xVocUD3/k5kd4DQN0e4ljilv1oA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KBjAvsHg;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787132555;
	b=yCJvwGnnxAJQk9cmmvax6j7fJe5wZQstf68ewgtG3yJdLWOPO/C2N/bBwUx8hYPso4fYGz
	RsxyNUdhR9YFhtT/l+kSQCFmEmYBfr0eZkp02u7NTdy/cGucdhK86y2LhIOTp+b1K6MZfg
	8LIM8PrVz5sE9MGqPPPoVdxItHsmopY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787132550; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=dffCyQdhxpyTf0QdT24ZzmspKjAdOG5vF+UT74r+vrg=;
	b=KBjAvsHgEskz9IBsGzcttCfVnpcOTkZsTxUEtTRJY9ZiFxxdpBGQb9Fjh0y8YYvZOk2n8QbYnqwRJUY7ecdv82JUTUB+McXHifdrrPumpbHnrP3KuG4EnmEwnxtVb8y840bsu2yBCs2W8INnWohkK/aG856CeyCvcu37DtPSxC8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X9GGn5p_1787132538;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X9GGn5p_1787132538 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:42:26 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: linmiaohe@huawei.com,  shivankg@amd.com,  akpm@linux-foundation.org,
  david@kernel.org,  ljs@kernel.org,  riel@surriel.com,
  liam@infradead.org,  vbabka@kernel.org,  harry@kernel.org,
  jannh@google.com,  rppt@kernel.org,  surenb@google.com,  mhocko@suse.com,
  ziy@nvidia.com,  matthew.brost@intel.com,  joshua.hahnjy@gmail.com,
  rakie.kim@sk.com,  byungchul@sk.com,  gourry@gourry.net,
  apopple@nvidia.com,  kmanaouil.dev@gmail.com,  fvdl@google.com,
  kinseyho@google.com,  weixugc@google.com,  bharata@amd.com,
  rientjes@google.com,  dev.jain@arm.com,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] mm/rmap: batch the unmap of large folios in
 try_to_migrate_one()
In-Reply-To: <20260818092032.47670-1-lance.yang@linux.dev> (Lance Yang's
	message of "Tue, 18 Aug 2026 17:20:32 +0800")
References: <860941c2-287f-f88f-920c-6d99e2cd4483@huawei.com>
	<20260818092032.47670-1-lance.yang@linux.dev>
Date: Wed, 19 Aug 2026 17:42:17 +0800
Message-ID: <87tsoq5tvq.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Stat-Signature: t8opnatnhruxco41rwke6895qcpjhjp3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA13C140009
X-HE-Tag: 1787132553-424481
X-HE-Meta: U2FsdGVkX1/vkKvk9pQtidQ1ZD8JzFQCM+9HIMQyvQJviBcQw8+x5Ljzf8RsmWuUnTvdq9HbO4MbgLBI0vGRFnyCBua36kP2MbK2amNMz7llbtstOuNzzNu1I/Le/noUcJ6bDQnaWVRmBIWgjBYMsxB9swsv5m5LN0jyTHmSFnxj1h1ImzGCmQbvJnyqn/lRM1IPUZ9XkjpGc0lTLW7XX1JRqIoea3Kn0uA2KAHiU62sH7xFtwivNPXgy7/SUB2gBvVd31IXa6V0DWVyK11y4Y9LlpwDsiwRYI1tg3JJZfOZro3BhMoR0iZowzatuiqNYgl9TY90VMzyCRcpElqcVwRcR4Vf+qDArQZMHhfZADjezQd3p4zBVDVFElu+UV7eEnsxbivephJ8szZpHICTOrXZKgFMpiYEzsoSQSFJAwUNtx0wmg56OZpINxLnmL0O/HY7jsEEH4yS0K9LNbGm3jsm/WU0lsG8VC8nV4FWdECYxolCLd+NxBEzOXpU/aVQbUPRG+zBBQZuGvOqF2N9IkiNOLM+4T/kSlmBTx2v+B9l2jmpYYMQm33qFJwIrQ1fkhEW032bPCOZHwO4IUtRCN4GZkfMX6InCWURlsnV1GSugNr75KFjLx9OThXlEDNRsELNuehW+c04blEDVxw3TpMHgyRmXW041CztUUA1TWQOLh24WyZjRDXwqkeXaqPAWuFUCsQAK1Ls8gyXdD7gBbB/jAmwbqc9Pr/iyXMURTloveyEPZjVZkYe2xGOSjhyzbqE3HVM3nK7jHVhaSblFtA+DkkvqWSrZGEMjMoBo9/xEB+ruYGLRvbO8oL5czfgmibZnQs7pToRrRuZH0HwFrpfAWwhnjd5hbpxMY7jaf9cpQ9BV1oF3wnwK4kQhvuIhiZ/3InZ4zsjbsPvYyRGYG93bAtZzENegNrb/qmbTgZmKU1F5reCB1Wt5Cil+lMYmguUZ1k6ji32gySKb+w
 EK8s1m75
 W9eGZjy/nll8i8xhAbqSIx6ACUmyUL0YsthR5yv1GpxPcKf/DmwR7vJ5MOjNEdd2SRUQWRxQR4kEdYDDqcdwkgx77zqInyZaJOrjiD3eh+xQyAVwRLGsktLHCud0gXvE+67tDNwNxDmsutMW6SMb6lPTYuUSuiGszH5r6Op0sgo54ydFLZZnNTcQUsAQyE3cAu7K0MBqEL97HXn2LM/Q7z3XrpAFBn2U7i4KVFteQEOpyAP2RUMy/bQ1FSWPAXWJhAAoi4F8+Ws50tZD5yy46XKLdw21ZByqiremgfeAcqhiajVPnBzMoWZgd3uPVrIe9J96zRl02NWRzkTcSZTZqlZitTaBPMmRLxBoXOmrk3kAfsrOLSUh7jdJ1/Ns96WhJLk8oJi+4wi/czpuC2DiwU5GSWAB2y12FGc/xrW6cmk/uyOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lance Yang <lance.yang@linux.dev> writes:

> On Tue, Aug 18, 2026 at 04:55:06PM +0800, Miaohe Lin wrote:
>>On 2026/8/17 17:14, Lance Yang wrote:
>>> +Cc Miaohe
>>> 
>>> On Thu, Aug 13, 2026 at 04:23:18AM +0000, Shivank Garg wrote:
>>>> try_to_migrate_one() converts present PTEs to migration entries one at a
>>>> time. For a PTE-mapped large folio, this repeat calls to ptep clear+flush,
>>>> the migration entry build and set, folio_remove_rmap_pte() and folio_put(),
>>>> each re-entering page_vma_mapped_walk() once per base page (256 times for
>>>> 1M folio).
>>>>
>>>> Mirror try_to_unmap_one() to introduce folio_migrate_pte_batch() to detect
>>>> eligible batch for PTEs mapping conseuctive subpages of a large folios,
>>>> and convert the whole batch in one shot using the batched helpers.
>>>>
>>>> A side-effect of this change is trace_set_migration_pte() will record
>>>> one event per batched run instead of earlier behavior of one per base page.
>>>>
>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>> ---
>>>> mm/rmap.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++----------------
>>>> 1 file changed, 86 insertions(+), 29 deletions(-)
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 35752a70f3a0..63b885c0b7ef 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2675,6 +2675,44 @@ static bool try_to_migrate_hugetlb_one(struct folio *folio,
>>>> 	return ret;
>>>> }
>>>>
>>>> +static inline unsigned int folio_migrate_pte_batch(struct folio *folio,
>>>> +		struct page_vma_mapped_walk *pvmw, pte_t pte,
>>>> +		struct page *subpage, bool anon_exclusive)
>>>> +{
>>>> +	unsigned long end_addr, addr = pvmw->address;
>>>> +	struct vm_area_struct *vma = pvmw->vma;
>>>> +	unsigned int max_nr, nr;
>>>> +
>>>> +#ifdef __HAVE_ARCH_UNMAP_ONE
>>>> +	/* Cannot batch unmap if arch_unmap_one() is defined. */
>>>> +	return 1;
>>>> +#endif
>>>> +
>>>> +	if (!folio_test_large(folio))
>>>> +		return 1;
>>>> +	if (folio_is_zone_device(folio) || folio_test_has_hwpoisoned(folio))
>>>> +		return 1;
>>>> +	if (pte_unused(pte))
>>>> +		return 1;
>>>> +
>>>> +	/* We may only batch within a single VMA and a single page table. */
>>>> +	end_addr = pmd_addr_end(addr, vma->vm_end);
>>>> +	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>> 
>>> Hmm ... can this still batch over a poisoned tail page?
>>> 
>>> memory_failure() sets PageHWPoison() before taking folio lock, but
>>> cannot set PG_has_hwpoisoned until it acquires and releases that lock.
>>> 
>>> So tail page can already be poisoned while folio_test_has_hwpoisoned()
>>> still returns false ... no?
>>
>>When memory error hits thp pages, memory_failure() first set PG_has_hwpoisoned and
>>then tries to split thp pages. And try_to_migrate() will be called to set migration
>>entries for anon pages. Does folio_migrate_pte_batch() work on this case? If so, the
>>folio_test_has_hwpoisoned() check above could catch the bad pages?
>>
>>Or do you worry about the scene that meory error hits a thp while it's under migration?
>
> Yeah, latter case is exactly what I meant.
>
> try_to_migrate() is called with folio lock held. If migration already
> owns the lock, memory_failure() can set PageHWPoison() on a tail page and
> then block in folio_lock(), before reaching folio_set_has_hwpoisoned().
> try_to_migrate_one() may meanwhile start from a healthy subpage, see
> PageHWPoison(subpage) clear and PG_has_hwpoisoned still clear, then batch
> across poisoned tail and install a normal migration entry for it.
>
> Once memory_failure() publishes PG_has_hwpoisoned, the folio-level check
> does stop batching, as you said. It's just this window before publication
> that worries me ...

I agree with you that we should check PageHWPoison() for each subpage
before batching.

However, IIUC, your suggestion can only reduce the race window instead
of avoiding it completely. PageHWPoison() may be set even after checking
it anyway.

---
Best Regards,
Huang, Ying

> Thanks, Lance
>
>>Thanks both.
>>.
>>
>>> 
>>> Starting from a healthy first subpage, folio_migrate_pte_batch() can
>>> then batch across poisoned tail page. hwpoison only describes first
>>> subpage, so set_softleaf_ptes() installs a normal migration entry for
>>> poisoned page instead of an HWPoison entry ...
>>> 
>>> Should folio_migrate_pte_batch() check PageHWPoison() on every candidate
>>> subpage and stop before a poisoned one?
>>> 
>>> Cheers, Lance
>>> 
>>> 
>>>> +	/*
>>>> +	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>>>> +	 * upgrading write permissions for ptes that were not originally writable,
>>>> +	 * and to avoid losing the soft-dirty bit, use the appropriate FPB flags.
>>>> +	 */
>>>> +	nr = folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>>>> +				   FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>>> +
>>>> +	/* Limit possible batch count to a uniform PageAnonExclusive value */
>>>> +	if (folio_test_anon(folio))
>>>> +		nr = page_anon_exclusive_batch(0, nr, subpage, anon_exclusive);
>>>> +
>>>> +	return nr;
>>>> +}
>>>> +
>>>> /*
>>>>  * @arg: enum ttu_flags will be passed to this argument.
>>>>  *
>>>> @@ -2686,12 +2724,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>> {
>>>> 	struct mm_struct *mm = vma->vm_mm;
>>>> 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>>>> -	bool anon_exclusive, writable, ret = true;
>>>> +	bool anon_exclusive, hwpoison, writable, ret = true;
>>>> 	pte_t pteval;
>>>> 	struct page *subpage;
>>>> 	struct mmu_notifier_range range;
>>>> 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>>>> -	unsigned long pfn;
>>>> +	unsigned long pfn, end_addr, nr_pages;
>>>>
>>>> 	/*
>>>> 	 * When racing against e.g. zap_pte_range() on another cpu,
>>>> @@ -2744,11 +2782,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>> 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>>>> 					!folio_test_pmd_mappable(folio), folio);
>>>>
>>>> -			if (set_pmd_migration_entry(&pvmw, subpage)) {
>>>> -				ret = false;
>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>> -				break;
>>>> -			}
>>>> +			if (set_pmd_migration_entry(&pvmw, subpage))
>>>> +				goto walk_abort;
>>>> 			continue;
>>>> #endif
>>>> 		}
>>>> @@ -2773,10 +2808,25 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>> 		subpage = folio_page(folio, pfn - folio_pfn(folio));
>>>> 		anon_exclusive = folio_test_anon(folio) &&
>>>> 				 PageAnonExclusive(subpage);
>>>> +		/*
>>>> +		 * memory_failure() can set PageHWPoison concurrently without holding
>>>> +		 * the folio lock. Snapshot the flag here to decide whether to batch
>>>> +		 * PTEs or install hwpoison entry.
>>>> +		 */
>>>> +		hwpoison = PageHWPoison(subpage);
>>>>
>>>> +		nr_pages = 1;
>>>> 		if (likely(pte_present(pteval))) {
>>>> -			flush_cache_page(vma, address, pfn);
>>>> -			/* Nuke the page table entry. */
>>>> +			if (!hwpoison)
>>>> +				nr_pages = folio_migrate_pte_batch(folio, &pvmw,
>>>> +								   pteval, subpage,
>>>> +								   anon_exclusive);
>>>> +
>>>> +			end_addr = address + nr_pages * PAGE_SIZE;
>>>> +			flush_cache_range(vma, address, end_addr);
>>>> +
>>>> +			/* Nuke the page table entries. */
>>>> +			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>>>> 			if (should_defer_flush(mm, flags)) {
>>>> 				/*
>>>> 				 * We clear the PTE but do not flush so potentially
>>>> @@ -2786,11 +2836,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>> 				 * transition on a cached TLB entry is written through
>>>> 				 * and traps if the PTE is unmapped.
>>>> 				 */
>>>> -				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
>>>> -
>>>> -				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
>>>> +				set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
>>>> 			} else {
>>>> -				pteval = ptep_clear_flush(vma, address, pvmw.pte);
>>>> +				flush_tlb_range(vma, address, end_addr);
>>>> 			}
>>>> 			if (pte_dirty(pteval))
>>>> 				folio_mark_dirty(folio);
>>>> @@ -2809,7 +2857,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>> 		/* Update high watermark before we lower rss */
>>>> 		update_hiwater_rss(mm);
>>>>
>>>> -		if (PageHWPoison(subpage)) {
>>>> +		if (hwpoison) {
>>>> +			VM_WARN_ON_ONCE(nr_pages != 1);
>>>> 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
>>>>
>>>> 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>>>> @@ -2837,19 +2886,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>> 			 * so we'll not check/care.
>>>> 			 */
>>>> 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>>>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>>>> -				ret = false;
>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>> -				break;
>>>> +				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>>>> +				goto walk_abort;
>>>> 			}
>>>>
>>>> -			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
>>>> +			/* See folio_try_share_anon_rmap_ptes(): clear PTE first. */
>>>> 			if (anon_exclusive &&
>>>> -			    folio_try_share_anon_rmap_pte(folio, subpage)) {
>>>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>>>> -				ret = false;
>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>> -				break;
>>>> +			    folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
>>>> +				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>>>> +				goto walk_abort;
>>>> 			}
>>>>
>>>> 			/*
>>>> @@ -2859,19 +2904,31 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>> 			 */
>>>> 			swp_pte = make_migration_pte(subpage, pteval,
>>>> 						     writable, anon_exclusive);
>>>> -			set_pte_at(mm, address, pvmw.pte, swp_pte);
>>>> 			trace_set_migration_pte(address, pte_val(swp_pte),
>>>> 						folio_order(folio));
>>>> +
>>>> +			/* Set nr_pages migration entries, advancing the PFN. */
>>>> +			set_softleaf_ptes(mm, address, pvmw.pte, swp_pte, nr_pages);
>>>> 			/*
>>>> 			 * No need to invalidate here it will synchronize on
>>>> 			 * against the special swap migration pte.
>>>> 			 */
>>>> 		}
>>>>
>>>> -		folio_remove_rmap_pte(folio, subpage, vma);
>>>> -		if (vma->vm_flags & VM_LOCKED)
>>>> -			mlock_drain_local();
>>>> -		folio_put(folio);
>>>> +		finish_folio_unmap(vma, folio, subpage, nr_pages);
>>>> +
>>>> +		/*
>>>> +		 * If we batched the entire folio, there is nothing left to
>>>> +		 * walk; stop right here.
>>>> +		 */
>>>> +		if (nr_pages == folio_nr_pages(folio))
>>>> +			goto walk_done;
>>>> +		continue;
>>>> +walk_abort:
>>>> +		ret = false;
>>>> +walk_done:
>>>> +		page_vma_mapped_walk_done(&pvmw);
>>>> +		break;
>>>> 	}
>>>>
>>>> 	mmu_notifier_invalidate_range_end(&range);
>>>>
>>>> -- 
>>>> 2.43.0
>>>>
>>>>
>>> .
>>> 
>>
>>

