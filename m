Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E8E3CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B746C6B009B; Thu,  4 Jun 2026 07:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE156B009D; Thu,  4 Jun 2026 07:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECEB6B009E; Thu,  4 Jun 2026 07:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2566B009B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:38:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E46F1C20CA
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:38:33 +0000 (UTC)
X-FDA: 84842032506.07.8104EA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A600CA0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:38:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mFxoq+6d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780573111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Cs5HltYdoJIMxaPhRAbM656+FdrapHi9nkAsTwvgJs=;
	b=ERQ9FU/xpPHC1Ld+ttEsVIQ6RLoEfVbtPGzWlKW6eVpZUNy4A/+dGq7vQHqOYIhK1T4QHv
	hjHo4uYszY1qNuetHQkCbqb3ph/ouNFX5iuadG7dlQSyItsXk6Zg1f7YWiMyODpEbGnp3L
	rIyo0Shnard6MnqVCztGhY2qHUmdRWo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mFxoq+6d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780573111;
	b=z46zLqSsjkSQsSOpkk/5sYI9vUSpKS7MYAHRA+xcrfrWsOmxGb4/kV0p1Pku6Mc9kIz+sq
	SiQ9ogaysE21E/KC8YPTC1So2D7pqhZLJZX8lFwK1DpJ4P1xlVEx6n9J6AIbZhgyTISHxg
	A+bloybHRwm+/wwvx65xQ7KqNaIoak4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0A646024D;
	Thu,  4 Jun 2026 11:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001A41F00898;
	Thu,  4 Jun 2026 11:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780573110;
	bh=0Cs5HltYdoJIMxaPhRAbM656+FdrapHi9nkAsTwvgJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mFxoq+6dwmB63YA4eNje+poauaE108YtMyQzjeUIVWivqr6B0Z/N/8uE7lnIo9Nd4
	 FFIU1+jAIvqnVvjFOwuRuahuM8yP+S33zThST2xFhJ83iYtjfYWvQ5xC+x3ClIQASI
	 IECYBxbT5ufcfQ7SbE6M+9B24G0iFU9XRjq94SKuCszF17U5xrVRsddXrIQafQEzlj
	 M34f2pOG/jPs2YDq9Its1aG37nFh5cf91N4L3mmDMpRCOXk9EKD/x8rwC9kOt3qVVw
	 YBg8fusqS3krzm/TSgeqRd+CAlp7r8NGhUU4/HLkYJ2KTvUhgZhmCVdfTB6jSnE7XJ
	 3H2uIvr2GPzfg==
Date: Thu, 4 Jun 2026 12:38:16 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <aiFTSLb0kkTR7I9A@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-7-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522150009.121603-7-npache@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A600CA0005
X-Stat-Signature: njwperie7p8xgrqdgak5au139hrepdbi
X-Rspam-User: 
X-HE-Tag: 1780573111-307745
X-HE-Meta: U2FsdGVkX1+6As7qhTXoCf7kYLPS7G93anoHy+QVsyssxNFoKrIdqsD58ZPHIrhF3JnpxKq0UUxjP+9IlL0iZKdUFrWHo6Cdd4WBnWj5cF3tBv8YAHLBJlOij1LM2azwN4sZHcMCIyuKEln6FEqKjjzIo5kaF/fV3bhNiT6HjrLgi7FPfOI/7aO6eVDbcfyfIP0rgw89ia819CYvEYdufY9hcz/9l4TS8QTQ4J0064Wom78pZW64A/5Lgv9+ubipkYD1TaXQLb11+tctz2IO1Etas9Bqm8fCiAK+PCeVF0e3FELcVrBdTtN46TlDNZRjJNS5V3Y8FtfA7bwNL7a0rsNqkoqN3yxuRA0720dJiZFHCZs3ons5bWx63pRH+XmykVg0OHE+NgeMoHtV2z0b0kUquZlOKkEcw6cNn60ehrOeg8lY97OGuPBkulM3uYVuGAPozlAj37EjMX6VxZ/xEt72kbUqsjvvyK3Apo+7neJNy0/pAQJQTfedw3+wwhoUOaTGwEcvk2O2CZCbWA4v3i9MMC/APwVGE0nAB8enog7ehcLX4V/gkYbvCjY3F+R5mAAOzfUChsUj+dVdXt0SpVsECKvMB3RJ1bRvA+LUQUKMbRShENCoqwP+Ra/nKBXKDPE2hoDqUzPxfwUOBjE8JDNZer7lpXDrf5/B1tFjQgWyL+uyqPXIkHUgexoj5OPsXX2E5bNsSwzQFfIkX25aP9S29eD2WPOqJhc34kqUhWMgItYhlNN6osYNLjLZbqTCZ3v6+r5nWO+TtrRWFczjLfobnXsJHiKe0tjuhWIIOZZsGvvfStZ6h0P6jVO1yQKddpt3a7s4QstzX/1DKVCIFB5G6FUh6UXT90DrZ66j6UOMYZJKX28hj55TAxsSq9FtZ0WF53JecIdWGNO5sJjVoPxB5hoElrvXVFNIwUa7lINcV/taWRfD0gT1613XjLu3DwtVxQmVaiMw47B8gTn
 ANOswazf
 iv9pGBqdBFjCJfF3OLtc0nZ1p4DaIM9EzyeFn4ZyTLydQ5YlOkakqSjME0DCgAViazlxAyh0bq6TnL7cPv9WjaGeOJOAznELMAa15MM53LbbeJJl7gU8TqlaTH0NZWOhnqS1mm2ZvKM4eb3aU6i2A79trmRevTcSbpNzgn1Wf7Mj6DV9f/ci5hWPxRke1rpSD91eVdxZ+D1ZXoQMcfB2yZ2Y13EOq/ozj2zGcM3K4hYc2VeE1++4lLGY+jXZv/L/JpMHRQCQjocrE3883C+qD98mcN6PmrUauugBOeVL/2wDfSPKkfFzntjJ9nuOW5/LhcZc1xIES0Fep9IDrTySkdSZLGKcDaEIABwdzZ19roK7uLzGzk3aVedJYKrEsbRwoJAOMeJeXUSZSwfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I will go review the thread about the cache maintenance separately and
respond about that.

On Fri, May 22, 2026 at 09:00:01AM -0600, Nico Pache wrote:
> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
>
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the mTHP case this is not true, and we must keep the lock to prevent
> access/changes to the page tables. This can happen if the rmap walkers hit
> a pmd_none while the PMD entry is currently unavailable due to being
> temporarily removed during the collapse phase.
>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>

The logic LGTM generally, some questions for understanding below, and of
course as per above I want to review the Lance/David subthread.

Thanks!

> ---
>  mm/khugepaged.c | 93 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 55 insertions(+), 38 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fab35d318641..d64f42f66236 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1214,34 +1214,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>   * while allocating a THP, as that could trigger direct reclaim/compaction.
>   * Note that the VMA must be rechecked after grabbing the mmap_lock again.
>   */
> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -		int referenced, int unmapped, struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		unsigned int order)
>  {
> +	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
> +	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> -	pte_t *pte;
> +	pte_t *pte = NULL;

As mentioned elsewhere for some reason this was dropped in
mm-unstable. Maybe a bad conflict resolution?

>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	enum scan_result result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
> +	bool anon_vma_locked = false;
>
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> -
> -	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> +	result = alloc_charge_folio(&folio, mm, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> +					 &vma, cc, order);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
>  	}
>
> -	result = find_pmd_or_thp_or_none(mm, address, &pmd);
> +	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
> @@ -1253,8 +1255,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 * released when it fails. So we jump out_nolock directly in
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
> -		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced, HPAGE_PMD_ORDER);
> +		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
> +						     referenced, order);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
> @@ -1269,20 +1271,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> +					 &vma, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
>  	vma_start_write(vma);
> -	result = check_pmd_still_valid(mm, address, pmd);
> +	result = check_pmd_still_valid(mm, pmd_addr, pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>
>  	anon_vma_lock_write(vma->anon_vma);
> +	anon_vma_locked = true;

I worry that we hold this lock a lot longer now? Maybe the algorithmic
change alters that, but Claude did suggest on the s390 bug that longer lock
hold might be an issue.

I wonder if we'll observe lock contention as a result?

Correct me if I'm wrong and we're not holding longer than previously,
however. Just appears that we do.

>
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> -				address + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
> +				end_addr);
>  	mmu_notifier_invalidate_range_start(&range);
>
>  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> @@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * Parallel GUP-fast is fine since GUP-fast will back off when
>  	 * it detects PMD is changed.
>  	 */
> -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> +	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);
>  	spin_unlock(pmd_ptl);
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_remove_table_sync_one();
>
> -	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> +	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
>  	if (pte) {
> -		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> -						      HPAGE_PMD_ORDER,
> -						      &compound_pagelist);
> +		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
> +						      order, &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_NO_PTE_TABLE;
>  	}
>
>  	if (unlikely(result != SCAN_SUCCEED)) {
> -		if (pte)
> -			pte_unmap(pte);

OK I seem to remember this is because we're holding the anon_vma lock
longer. That does imply that on e.g. x86-64 the RCU lock is being held a
bit longer also as well as the anon_vma loc.

I guess it's also because we need to hold anon_vma and pte lock because
we're fiddling around at PTE level for mTHP not just PMD level as 'classic'
THP did.

(Rememberings going on here :)

>  		spin_lock(pmd_ptl);
> -		BUG_ON(!pmd_none(*pmd));
> +		WARN_ON_ONCE(!pmd_none(*pmd));
>  		/*
>  		 * We can only use set_pmd_at when establishing
>  		 * hugepmds and never for establishing regular pmds that
> @@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 */
>  		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>  		spin_unlock(pmd_ptl);
> -		anon_vma_unlock_write(vma->anon_vma);
>  		goto out_up_write;
>  	}
>
>  	/*
> -	 * All pages are isolated and locked so anon_vma rmap
> -	 * can't run anymore.
> +	 * For PMD collapse all pages are isolated and locked so anon_vma
> +	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
> +	 * removed and not all pages are isolated and locked, so we must hold

Right because some PTE entries be unaffected by the change.

> +	 * the lock to prevent neighboring folios from attempting to access
> +	 * this PMD until its reinstalled.

OK. This is slightly annoying for my CoW context work as it means there's
another case where we need to explicitly hold an anon_vma lock for
correctness :)

Anyway I will think about that separately, is what it is. And in fact
motivates to want this merged earlier so I can work against it :)


>  	 */
> -	anon_vma_unlock_write(vma->anon_vma);
> +	if (is_pmd_order(order)) {
> +		anon_vma_unlock_write(vma->anon_vma);
> +		anon_vma_locked = false;
> +	}
>
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> -					   vma, address, pte_ptl,
> -					   HPAGE_PMD_ORDER,
> -					   &compound_pagelist);
> -	pte_unmap(pte);
> +					   vma, start_addr, pte_ptl,
> +					   order, &compound_pagelist);
>  	if (unlikely(result != SCAN_SUCCEED))
>  		goto out_up_write;
>
> @@ -1345,18 +1348,32 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * write.
>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> -
>  	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> +	WARN_ON_ONCE(!pmd_none(*pmd));
> +	if (is_pmd_order(order)) {
> +		pgtable = pmd_pgtable(_pmd);
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> +	} else {
> +		/*
> +		 * set_ptes is called in map_anon_folio_pte_nopf with the
> +		 * pmd_ptl lock still held; this is safe as the PMD is expected

PMD entry you mean?

> +		 * to be none. The pmd entry is then repopulated below.
> +		 */
> +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);

So here we populate entries in the existing PTE _table_ to point at the new
order>0 folio? With arm64 of course doing transparent contpte stuff?

> +		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));

And then we reinstall the pre-existing PMD _entry_ from none -> what it was
before?

> +	}
>  	spin_unlock(pmd_ptl);
>
>  	folio = NULL;
>
>  	result = SCAN_SUCCEED;
>  out_up_write:
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
> +	if (pte)
> +		pte_unmap(pte);
>  	mmap_write_unlock(mm);
>  out_nolock:
>  	if (folio)
> @@ -1536,7 +1553,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		/* collapse_huge_page expects the lock to be dropped before calling */
>  		mmap_read_unlock(mm);
>  		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc);
> +					    unmapped, cc, HPAGE_PMD_ORDER);
>  		/* collapse_huge_page will return with the mmap_lock released */
>  		*lock_dropped = true;
>  	}
> --
> 2.54.0
>

