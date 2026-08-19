Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422A1C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622256B0092; Wed, 19 Aug 2026 05:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC316B00BC; Wed, 19 Aug 2026 05:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474C66B00BD; Wed, 19 Aug 2026 05:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0636B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:58:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99551C0508
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:58:04 +0000 (UTC)
X-FDA: 85117568088.02.985F001
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5073340005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:58:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uBLyGYxw;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qg0LHKdiIXC16vBZXisodb5ZyYSQ4yPlz3Q6PE27RUE=;
	b=v6TkUbC4jMPVYW4GoLxenQVScu7CSgjC2dqIvT3KwHOHuO5gThsxel01SjxDGSVt/Q9dGQ
	oE9P7RxX+w/v0/XsANOuNCsYqY77Nf9z9ZGmf8IibU8n/vqkf1J+LXCu+aBSgzOjXR6BC7
	YmXdQQCFgWMupWgUeBQblnaFWBtxWwk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uBLyGYxw;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133482;
	b=weM/3Hnc81/dbZnpAkrP9ujfhLl6+NEZ4nVKwCttKCxspo1FhDWcUwMK2fMmJ+VViX3oaw
	LSvH2pt+wqIkN4OHGoN8uPJqf941ZNm2T1K6G+SpyqqkU4lSAiRNaYPKOrtaqxnH5rxD89
	obFtjZlWujfBVUiZa4bn4RM0D0LPfgY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DNPq1Nr9++W1lD30+d9a/DJZLGwqW0h6V2qdStcQ2do=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787133480; v=1; x=1787738280;
 b=uBLyGYxwjY8WIIN+MDm5m+saJcQD3XjN+PCERrMPalT1Sew2r6wt0AUJCFRzB2qa0lpo5Psm
 OBjDH1lYwb3XLRViccvjnPsWBxVwK+l0geu3/+GLD3UEcDbjzZf2AjedLLnkGivJFm9nItbk/k5
 7gOOlywUmXhBbhPpS6aQy4bk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 60972300063a6897;
	Wed, 19 Aug 2026 09:57:50 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ying.huang@linux.alibaba.com
Cc: linmiaohe@huawei.com,
	shivankg@amd.com,
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
Date: Wed, 19 Aug 2026 17:57:38 +0800
Message-Id: <20260819095738.46511-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <87tsoq5tvq.fsf@DESKTOP-5N7EMDA>
References: <87tsoq5tvq.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5073340005
X-Stat-Signature: cd46dh1zuhiyn4c9ztypxufziq6jdxtd
X-Rspam-User: 
X-HE-Tag: 1787133482-169925
X-HE-Meta: U2FsdGVkX1/iMBwqRQYILbogfP6vJ0tjiScLDp55AaVg/pZs0UScaIU7b5MFus7Dt0CMNjHd8FI+LxVfcujhfbzJBL0B+trWJSOMFHPkOIDp81Yyq28JUrIeWDIMhitwHH3b+KgL5BHnh0+cZpL/SWCWfUajiFFVDzNxVawWe09Txup101VwnpKcqNokanI5QLBK3NdpQ8RuW1QIP9OzMKTp0yQAFuMBdTUjPCElHkxMmILFmytrGBzPN4VBUEnAhvWw4/P3b048xY9aHYaKve6I9is76TSezu0CfDYO054bcczpAGLMVPpQoVjP5iU0iMkcpzPbE/I5Q6vhwgwnIgYs8dudsQg1qBbQfO0c/FZNWDfpgNFVupoMgaQPlTHKxC+ahc+E2lzGdmnUuBEI2M0AOOFvu/3mZ85AHgQWPXkrWNyWEIF2yZHeGOGT0JIVQeX0Sm0D/F03+xGvuotGoeCfQfYSAStkrAcpDr64oh4Xw3wWAv4Q0ILJ625YM3i2ZvVPtOfxi4IUdr9J/KHqZ2OGAAuCI6vrrcBJDObM2v3dwNDY2Wk7VPltSLx3E6kh11hngBAMW6d2TMaqMu9ks5E0LoLjV5fw/sw1CFfPvdf8TbTvvEHacwOHWJ6xBxOT6qcjWsyYgn8A1/tKTOeE1pJFbtmlA80KhiCjPRnq060FkGRlXZEmRjXqlcPsVE9Zm6dgG5zTFSxquoL9Jm8J9hb2UQWNsmsRdKIuAXKD84IwFQpshOCg7vuMY67M2Kbe/DZySXxGdO7hMligg4kLKnZw3UH0NQwChxDBHI35sDgUJEUzwksuNs2czM1+ZgHd0HKUyBxWbjbHjUyV1kJOxyXkD+mKhK0YPhpYktgbTMa3Q6ZnSPUyDBeCEGJ5K6J54Acxzi7pH5BLgUMEvkF3ZEIcyYRHA29QV6iDXRvym1taWPshcstKy4ISDTVJqtboZTxi9J/2CDmGrIN+z+O
 YMjD9j28
 IXyEUL6eN5xQHz6U8f7q4/oZuSXS2U2GlKyRcUNhq76/Sp25gvU5ZxGYkfr3fADHx9Eimk6baA2x/195ePkfmlXN23pKLF0yN5Dqe9q/UfLT4PjkA+tqk8dWpFlGHL3RnDfNA3+sox6O0/PLqtDnXsBNkocQaWoviUhjPr1J34shojcGAoheSSbo57DTB23jZnZ+hFbdaZWlTSY6y3D8vsVFrAV5SqINFVxvHuAm/RWMTZKhesjVu1BwZaKw0Oi831LEyjRSuJoC6yVOahY9IDT1Gq6CjXX9sJK7IdwvGib8TFQHj/HyPsPI3D3Y+nyrrtzjtOPbzm8rDZxpY+sB153b3vSu1CQfN4i29sGZq1odGn4MGabk48+o9KMyUV4Da78j6uxtr9CqFcDTa37eBVtRTzBXe0mAaqLwlcZC0+pL6KbEBSULjV073eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Aug 19, 2026 at 05:42:17PM +0800, Huang, Ying wrote:
>Lance Yang <lance.yang@linux.dev> writes:
>
>> On Tue, Aug 18, 2026 at 04:55:06PM +0800, Miaohe Lin wrote:
>>>On 2026/8/17 17:14, Lance Yang wrote:
>>>> +Cc Miaohe
>>>> 
>>>> On Thu, Aug 13, 2026 at 04:23:18AM +0000, Shivank Garg wrote:
>>>>> try_to_migrate_one() converts present PTEs to migration entries one at a
>>>>> time. For a PTE-mapped large folio, this repeat calls to ptep clear+flush,
>>>>> the migration entry build and set, folio_remove_rmap_pte() and folio_put(),
>>>>> each re-entering page_vma_mapped_walk() once per base page (256 times for
>>>>> 1M folio).
>>>>>
>>>>> Mirror try_to_unmap_one() to introduce folio_migrate_pte_batch() to detect
>>>>> eligible batch for PTEs mapping conseuctive subpages of a large folios,
>>>>> and convert the whole batch in one shot using the batched helpers.
>>>>>
>>>>> A side-effect of this change is trace_set_migration_pte() will record
>>>>> one event per batched run instead of earlier behavior of one per base page.
>>>>>
>>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>>> ---
>>>>> mm/rmap.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++----------------
>>>>> 1 file changed, 86 insertions(+), 29 deletions(-)
>>>>>
>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>> index 35752a70f3a0..63b885c0b7ef 100644
>>>>> --- a/mm/rmap.c
>>>>> +++ b/mm/rmap.c
>>>>> @@ -2675,6 +2675,44 @@ static bool try_to_migrate_hugetlb_one(struct folio *folio,
>>>>> 	return ret;
>>>>> }
>>>>>
>>>>> +static inline unsigned int folio_migrate_pte_batch(struct folio *folio,
>>>>> +		struct page_vma_mapped_walk *pvmw, pte_t pte,
>>>>> +		struct page *subpage, bool anon_exclusive)
>>>>> +{
>>>>> +	unsigned long end_addr, addr = pvmw->address;
>>>>> +	struct vm_area_struct *vma = pvmw->vma;
>>>>> +	unsigned int max_nr, nr;
>>>>> +
>>>>> +#ifdef __HAVE_ARCH_UNMAP_ONE
>>>>> +	/* Cannot batch unmap if arch_unmap_one() is defined. */
>>>>> +	return 1;
>>>>> +#endif
>>>>> +
>>>>> +	if (!folio_test_large(folio))
>>>>> +		return 1;
>>>>> +	if (folio_is_zone_device(folio) || folio_test_has_hwpoisoned(folio))
>>>>> +		return 1;
>>>>> +	if (pte_unused(pte))
>>>>> +		return 1;
>>>>> +
>>>>> +	/* We may only batch within a single VMA and a single page table. */
>>>>> +	end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>> +	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>> 
>>>> Hmm ... can this still batch over a poisoned tail page?
>>>> 
>>>> memory_failure() sets PageHWPoison() before taking folio lock, but
>>>> cannot set PG_has_hwpoisoned until it acquires and releases that lock.
>>>> 
>>>> So tail page can already be poisoned while folio_test_has_hwpoisoned()
>>>> still returns false ... no?
>>>
>>>When memory error hits thp pages, memory_failure() first set PG_has_hwpoisoned and
>>>then tries to split thp pages. And try_to_migrate() will be called to set migration
>>>entries for anon pages. Does folio_migrate_pte_batch() work on this case? If so, the
>>>folio_test_has_hwpoisoned() check above could catch the bad pages?
>>>
>>>Or do you worry about the scene that meory error hits a thp while it's under migration?
>>
>> Yeah, latter case is exactly what I meant.
>>
>> try_to_migrate() is called with folio lock held. If migration already
>> owns the lock, memory_failure() can set PageHWPoison() on a tail page and
>> then block in folio_lock(), before reaching folio_set_has_hwpoisoned().
>> try_to_migrate_one() may meanwhile start from a healthy subpage, see
>> PageHWPoison(subpage) clear and PG_has_hwpoisoned still clear, then batch
>> across poisoned tail and install a normal migration entry for it.
>>
>> Once memory_failure() publishes PG_has_hwpoisoned, the folio-level check
>> does stop batching, as you said. It's just this window before publication
>> that worries me ...
>
>I agree with you that we should check PageHWPoison() for each subpage
>before batching.
>
>However, IIUC, your suggestion can only reduce the race window instead
>of avoiding it completely. PageHWPoison() may be set even after checking
>it anyway.

Yeah, agreed. Still racy if PageHWPoison() gets set right after the
check.

IIUC, the real window is earlier than folio_lock(): between
TestSetPageHWPoison() and get_hwpoison_page(). No extra ref pins the old
folio there, so migration can finish and move the mappings to the new
folio. memory_failure() then only handles the old page, leaving the
migrated mapping without HWPoison handling.

Thing is, batching makes that window a whole lot wider ... old loop at
least checks each subpage, while one healthy first page now gives the
whole batch a green light. So it can miss a tail page already poisoned
before batching even starts.

Per-subpage check won't make the race go away, but at least keeps
batching from making it worse.

No clever idea from me yet on how to close it completely ...

Cheers, Lance

>
>---
>Best Regards,
>Huang, Ying
>
>> Thanks, Lance
>>
>>>Thanks both.
>>>.
>>>
>>>> 
>>>> Starting from a healthy first subpage, folio_migrate_pte_batch() can
>>>> then batch across poisoned tail page. hwpoison only describes first
>>>> subpage, so set_softleaf_ptes() installs a normal migration entry for
>>>> poisoned page instead of an HWPoison entry ...
>>>> 
>>>> Should folio_migrate_pte_batch() check PageHWPoison() on every candidate
>>>> subpage and stop before a poisoned one?
>>>> 
>>>> Cheers, Lance
>>>> 
>>>> 
>>>>> +	/*
>>>>> +	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>>>>> +	 * upgrading write permissions for ptes that were not originally writable,
>>>>> +	 * and to avoid losing the soft-dirty bit, use the appropriate FPB flags.
>>>>> +	 */
>>>>> +	nr = folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>>>>> +				   FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>>>> +
>>>>> +	/* Limit possible batch count to a uniform PageAnonExclusive value */
>>>>> +	if (folio_test_anon(folio))
>>>>> +		nr = page_anon_exclusive_batch(0, nr, subpage, anon_exclusive);
>>>>> +
>>>>> +	return nr;
>>>>> +}
>>>>> +
>>>>> /*
>>>>>  * @arg: enum ttu_flags will be passed to this argument.
>>>>>  *
>>>>> @@ -2686,12 +2724,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> {
>>>>> 	struct mm_struct *mm = vma->vm_mm;
>>>>> 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>>>>> -	bool anon_exclusive, writable, ret = true;
>>>>> +	bool anon_exclusive, hwpoison, writable, ret = true;
>>>>> 	pte_t pteval;
>>>>> 	struct page *subpage;
>>>>> 	struct mmu_notifier_range range;
>>>>> 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>>>>> -	unsigned long pfn;
>>>>> +	unsigned long pfn, end_addr, nr_pages;
>>>>>
>>>>> 	/*
>>>>> 	 * When racing against e.g. zap_pte_range() on another cpu,
>>>>> @@ -2744,11 +2782,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>>>>> 					!folio_test_pmd_mappable(folio), folio);
>>>>>
>>>>> -			if (set_pmd_migration_entry(&pvmw, subpage)) {
>>>>> -				ret = false;
>>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>>> -				break;
>>>>> -			}
>>>>> +			if (set_pmd_migration_entry(&pvmw, subpage))
>>>>> +				goto walk_abort;
>>>>> 			continue;
>>>>> #endif
>>>>> 		}
>>>>> @@ -2773,10 +2808,25 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> 		subpage = folio_page(folio, pfn - folio_pfn(folio));
>>>>> 		anon_exclusive = folio_test_anon(folio) &&
>>>>> 				 PageAnonExclusive(subpage);
>>>>> +		/*
>>>>> +		 * memory_failure() can set PageHWPoison concurrently without holding
>>>>> +		 * the folio lock. Snapshot the flag here to decide whether to batch
>>>>> +		 * PTEs or install hwpoison entry.
>>>>> +		 */
>>>>> +		hwpoison = PageHWPoison(subpage);
>>>>>
>>>>> +		nr_pages = 1;
>>>>> 		if (likely(pte_present(pteval))) {
>>>>> -			flush_cache_page(vma, address, pfn);
>>>>> -			/* Nuke the page table entry. */
>>>>> +			if (!hwpoison)
>>>>> +				nr_pages = folio_migrate_pte_batch(folio, &pvmw,
>>>>> +								   pteval, subpage,
>>>>> +								   anon_exclusive);
>>>>> +
>>>>> +			end_addr = address + nr_pages * PAGE_SIZE;
>>>>> +			flush_cache_range(vma, address, end_addr);
>>>>> +
>>>>> +			/* Nuke the page table entries. */
>>>>> +			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>>>>> 			if (should_defer_flush(mm, flags)) {
>>>>> 				/*
>>>>> 				 * We clear the PTE but do not flush so potentially
>>>>> @@ -2786,11 +2836,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> 				 * transition on a cached TLB entry is written through
>>>>> 				 * and traps if the PTE is unmapped.
>>>>> 				 */
>>>>> -				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
>>>>> -
>>>>> -				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
>>>>> +				set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
>>>>> 			} else {
>>>>> -				pteval = ptep_clear_flush(vma, address, pvmw.pte);
>>>>> +				flush_tlb_range(vma, address, end_addr);
>>>>> 			}
>>>>> 			if (pte_dirty(pteval))
>>>>> 				folio_mark_dirty(folio);
>>>>> @@ -2809,7 +2857,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> 		/* Update high watermark before we lower rss */
>>>>> 		update_hiwater_rss(mm);
>>>>>
>>>>> -		if (PageHWPoison(subpage)) {
>>>>> +		if (hwpoison) {
>>>>> +			VM_WARN_ON_ONCE(nr_pages != 1);
>>>>> 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
>>>>>
>>>>> 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>>>>> @@ -2837,19 +2886,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> 			 * so we'll not check/care.
>>>>> 			 */
>>>>> 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>>>>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>>>>> -				ret = false;
>>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>>> -				break;
>>>>> +				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>>>>> +				goto walk_abort;
>>>>> 			}
>>>>>
>>>>> -			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
>>>>> +			/* See folio_try_share_anon_rmap_ptes(): clear PTE first. */
>>>>> 			if (anon_exclusive &&
>>>>> -			    folio_try_share_anon_rmap_pte(folio, subpage)) {
>>>>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>>>>> -				ret = false;
>>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>>> -				break;
>>>>> +			    folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
>>>>> +				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>>>>> +				goto walk_abort;
>>>>> 			}
>>>>>
>>>>> 			/*
>>>>> @@ -2859,19 +2904,31 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> 			 */
>>>>> 			swp_pte = make_migration_pte(subpage, pteval,
>>>>> 						     writable, anon_exclusive);
>>>>> -			set_pte_at(mm, address, pvmw.pte, swp_pte);
>>>>> 			trace_set_migration_pte(address, pte_val(swp_pte),
>>>>> 						folio_order(folio));
>>>>> +
>>>>> +			/* Set nr_pages migration entries, advancing the PFN. */
>>>>> +			set_softleaf_ptes(mm, address, pvmw.pte, swp_pte, nr_pages);
>>>>> 			/*
>>>>> 			 * No need to invalidate here it will synchronize on
>>>>> 			 * against the special swap migration pte.
>>>>> 			 */
>>>>> 		}
>>>>>
>>>>> -		folio_remove_rmap_pte(folio, subpage, vma);
>>>>> -		if (vma->vm_flags & VM_LOCKED)
>>>>> -			mlock_drain_local();
>>>>> -		folio_put(folio);
>>>>> +		finish_folio_unmap(vma, folio, subpage, nr_pages);
>>>>> +
>>>>> +		/*
>>>>> +		 * If we batched the entire folio, there is nothing left to
>>>>> +		 * walk; stop right here.
>>>>> +		 */
>>>>> +		if (nr_pages == folio_nr_pages(folio))
>>>>> +			goto walk_done;
>>>>> +		continue;
>>>>> +walk_abort:
>>>>> +		ret = false;
>>>>> +walk_done:
>>>>> +		page_vma_mapped_walk_done(&pvmw);
>>>>> +		break;
>>>>> 	}
>>>>>
>>>>> 	mmu_notifier_invalidate_range_end(&range);
>>>>>
>>>>> -- 
>>>>> 2.43.0
>>>>>
>>>>>
>>>> .
>>>> 
>>>
>>>
>

