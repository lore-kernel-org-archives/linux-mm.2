Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6022FED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4EF6B0088; Tue, 17 Mar 2026 12:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C496B008A; Tue, 17 Mar 2026 12:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9B56B008C; Tue, 17 Mar 2026 12:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CAB76B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:51:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD8DF8AB0A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:51:56 +0000 (UTC)
X-FDA: 84556147032.14.0129BD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 077F3140004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:51:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gKu/QThN";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr9xh2GRyX6mPb+qYaJ1zQhjzjzMd2k7IqB0ezpHLec=;
	b=DNSKvZ6lthzM+wCQyi73feM1edg8CP/pzWJz5bcWmjUwoAxjzUmZt6CA8HkEHLS0xiWABp
	qvXJssx+KqESNlh8Tz2lCfKocQjQXa2UgmGPBItTMTsUsUOM74fS+q1PBoilDzUQt7KD2z
	gY7p0M83HJl/CV/AIYyYFJaDcmCPr54=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gKu/QThN";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766315; a=rsa-sha256;
	cv=none;
	b=CtmWtn/6qlfghsuh3U0BNRuqLq+a5Zt9cr46iSo8CNnf+mE23ny19Jdj54uEjCgzdQ7+M+
	n00DAGFzbEPWK7/0Bf+YkysLWOkPDwSSVuTA/g31+mcZLZCFsiPANCi+ihb21hrrw/oiR8
	n6mMCEA5axSwyrhvEVvYm0AAjCNsRVw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08F7C60103;
	Tue, 17 Mar 2026 16:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C04C4CEF7;
	Tue, 17 Mar 2026 16:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766313;
	bh=UKJIY4eu8ESTIARqeE1Cg/acgL4R+iCO/sf4VM3QK5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gKu/QThNyy0B77QGS3g1olLQOIZFhUts5+ejjRlTtkWITySx7TZg5yGl1LmdVfq+t
	 Uf9hCUDiSBhfwpEMOgHLK5WXpl3V+5r4978oCcqN409KgjLwfB7Mmf+hTcsCv9hBG+
	 zrrJtzQQZx982xXHV1M39+ai0/awF9b/5e+FT8TswYb//UuXrFq+zSLAZ0/TmLciqD
	 v8mjjA3gwI/eR1EWlkD2AHP34wSLoOce87AbkqzrvB5R9307AbAKAmkPQWahf3Yo8q
	 gjjRLFq3xV0PqF58mmRs1OVxGi/uKorp9D7+TuVvEb7ZL6FpQfgg3lSDb8iv9ZCjy4
	 /C4N5uG23kTYA==
Date: Tue, 17 Mar 2026 16:51:51 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 05/13] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <9f0b8790-eace-4caa-a0c0-45f66285887f@lucifer.local>
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032427.233282-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226032427.233282-1-npache@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 077F3140004
X-Rspamd-Server: rspam08
X-Stat-Signature: nxpdrsfazk16huhm8cmpfbqbix8jk7u4
X-HE-Tag: 1773766314-762138
X-HE-Meta: U2FsdGVkX1/5lFb4W9D8dEdnZfGcyiCMbK8qWZVKFH9kqaEfRGttxWk++VwqvR4OzvG8WmM2dK6yD10y0zRirGwmiOQl7tzcZDo6eHBRCfx6sUr1HsdOn6uTUSI2b8LE62MUQ/wdQolfEr9jEYlPP28USvCQRZKJqhXumr4GDyfsCHi1fP8TEAFpam1F250eiD7syG6x/ECqrkcEoyYyEji29qK3GXqOd9tCZRqx0iwC9yRJz5FTTkILToSkSj0+VdhvwsRWmNDAlNcmTdwoTwAvz8JH59S6IOMDKaPbb/l8gYdoWuMQSswmaVITn1U1+tF62BEepunQqtFbHD23uW9VxRI6lFi1muxdmokof+XE9CNyra2WkehioYQ3zWqrBS5g96aTrN6iuQhVELrfUiQuVYfjN9JF+kn1S5fYGI2ITEGbJPvn3IRY0/FL26e05rCSmGI5KOn59xaud4HIDbyqtqLABl+aVyx5mxLn5nYN0bA2frvfygp7Zpti8dHHlcpJ0+GeG72c8RoiVWx1CWrKkIR5Ppxo/0Ol7RrLX0Xogrh/S5YwwUNJ+0SirNboTTdPkAdwrloBdyv4wyz9ME5KUZCG9Sm8uQANDGI8sGaOQkbqh656c25PeDCq50m7m9D8BGZEpV75WlH35uM2jJsPT0h0KfiZkTQIxYOj+eX2RnLfW8uy4e16dv+AvyB9aw8O0xTW19O/qtdRatTwfQ7nRaZ5/ehAm6NJbyfOj/DPUbgk3rPdLIFTdrv+VoNtjIReD7871vUoGWCwyDXDy0/OC4wtsS2qAWvx8cfIaNiYXwnTQSjwzU7M4giO7LvBz9o+KYkFXXwRs5brJ3nzF7VUZdhae26Ff5s9XzuukM840Owb7NtNPLmsvLax/+PvIbWVExrG4KSNd73M+w+1YhN/78hAkYitmuRk0GPVWupgTI/jyJO0vGvIfQTnZV9xK9Xjm9rrZ1cOjCscAWS
 KB/lh6+C
 CB4OhO3ZfM0tfWUVYwf8JFce+0UHwfMKU9lSynR7SXaElaLupQSDpwQ+fmX3YjDxZHo/v1yZmKAb/zpMuhW7/2Qqimlclq9ScBzLWMz4XdRSGnR64GuCR5tH/ydAWTAouY4HLMvB8dQbuzJurHLeAtnkQnaTMxGLFgRCNBtNzY80U+39O/QnSz00eKO2IPlzBfPZwYnt5EOUkZAOpgojJdEg4B9igeKTdk3DSPX0t1LHs3ZkxeMXkJPLi1XxVHoCcNr+HWYKEMyXVVx3wJ0ary5c6ZVLBwFd8D7rguynMzbpivmKX54e5MgRb/N9VaRTGRcsfZnaNHElNILx5XeYJR7At6w1f9AFnQ8zN/DbM1nfuE/ieARD2YnvHTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:24:27PM -0700, Nico Pache wrote:
> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
>
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in

The '--' seems weird here :) maybe meant to be ' - '?

> the mTHP case this is not true, and we must keep the lock to prevent
> changes to the VMA from occurring.

You mean changes to the page tables right? rmap won't alter VMA parameters
without a VMA lock. Better to be specific.

>
> Also convert these BUG_ON's to WARN_ON_ONCE's as these conditions, while
> unexpected, should not bring down the system.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 102 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 62 insertions(+), 40 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 99f78f0e44c6..fb3ba8fe5a6c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1150,44 +1150,53 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	return SCAN_SUCCEED;
>  }
>
> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -		int referenced, int unmapped, struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		bool *mmap_locked, unsigned int order)

This is getting horrible, could we maybe look at passing through a helper
struct or something?

>  {
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> -	pte_t *pte;
> +	pte_t *pte = NULL;
>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	enum scan_result result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
> +	bool anon_vma_locked = false;
> +	const unsigned long pmd_address = start_addr & HPAGE_PMD_MASK;

We have start_addr and pmd_address, let's make our mind up and call both
either addr or address please.

>
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> +	VM_WARN_ON_ONCE(pmd_address & ~HPAGE_PMD_MASK);

You just masked this with HPAGE_PMD_MASK then check & ~HPAGE_PMD_MASK? :)

Can we just drop it? :)

>
>  	/*
>  	 * Before allocating the hugepage, release the mmap_lock read lock.
>  	 * The allocation can take potentially a long time if it involves
>  	 * sync compaction, and we do not need to hold the mmap_lock during
>  	 * that. We will recheck the vma after taking it again in write mode.
> +	 * If collapsing mTHPs we may have already released the read_lock.
>  	 */
> -	mmap_read_unlock(mm);
> +	if (*mmap_locked) {
> +		mmap_read_unlock(mm);
> +		*mmap_locked = false;
> +	}

If you use a helper struct you can write a function that'll do both of
these at once, E.g.:

static void scan_mmap_unlock(struct scan_state *scan)
{
	if (!scan->mmap_locked)
		return;

	mmap_read_unlock(scan->mm);
	scan->mmap_locked = false;
}

	...

	scan_mmap_unlock(scan_state);

>
> -	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> +	result = alloc_charge_folio(&folio, mm, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	*mmap_locked = true;
> +	result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);

Be nice to add a /*expect_anon=*/true, here so we can read what parameter
that is at a glance.

>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
> +		*mmap_locked = false;
>  		goto out_nolock;
>  	}
>
> -	result = find_pmd_or_thp_or_none(mm, address, &pmd);
> +	result = find_pmd_or_thp_or_none(mm, pmd_address, &pmd);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
> +		*mmap_locked = false;
>  		goto out_nolock;
>  	}
>
> @@ -1197,13 +1206,16 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 * released when it fails. So we jump out_nolock directly in
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
> -		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced, HPAGE_PMD_ORDER);
> -		if (result != SCAN_SUCCEED)
> +		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
> +						     referenced, order);
> +		if (result != SCAN_SUCCEED) {
> +			*mmap_locked = false;
>  			goto out_nolock;
> +		}
>  	}
>
>  	mmap_read_unlock(mm);
> +	*mmap_locked = false;
>  	/*
>  	 * Prevent all access to pagetables with the exception of
>  	 * gup_fast later handled by the ptep_clear_flush and the VM
> @@ -1213,20 +1225,20 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);

Hmm you take an mmap... write lock here then don/t set *mmap_locked =
true... It's inconsistent and bug prone.

I'm also seriously not a fan of switching between mmap read and write lock
here but keeping an *mmap_locked parameter here which is begging for a bug.

In general though, you seem to always make sure in the (fairly hideous
honestly) error goto labels to have the mmap lock dropped, so what is the
point in keeping the *mmap_locked parameter updated throughou this anyway?

Are we ever exiting with it set? If not why not drop the parameter/helper
struct field and just have the caller understand that it's dropped on exit
(and document that).

Since you're just dropping the lock on entry, why not have the caller do
that and document that you have to enter unlocked anyway?


> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
>  	vma_start_write(vma);
> -	result = check_pmd_still_valid(mm, address, pmd);
> +	result = check_pmd_still_valid(mm, pmd_address, pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>
>  	anon_vma_lock_write(vma->anon_vma);
> +	anon_vma_locked = true;

Again with a helper struct you can abstract this and avoid more noise.

E.g. scan_anon_vma_lock_write(scan);

>
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> -				address + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
> +				start_addr + (PAGE_SIZE << order));

I hate this open-coded 'start_addr + (PAGE_SIZE << order)' construct.

If you use a helper struct (theme here :) you could have a macro that
generates it set an end param to this.


>  	mmu_notifier_invalidate_range_start(&range);
>
>  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> @@ -1238,24 +1250,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * Parallel GUP-fast is fine since GUP-fast will back off when
>  	 * it detects PMD is changed.
>  	 */
> -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> +	_pmd = pmdp_collapse_flush(vma, pmd_address, pmd);
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

Will this work correctly with the non-PMD aligned start_addr?

>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_NO_PTE_TABLE;
>  	}
>
>  	if (unlikely(result != SCAN_SUCCEED)) {
> -		if (pte)
> -			pte_unmap(pte);
>  		spin_lock(pmd_ptl);
>  		BUG_ON(!pmd_none(*pmd));

Can we downgrade to WARN_ON_ONCE() as we pass by any BUG_ON()'s please?
Since we're churning here anyway it's worth doing :)

>  		/*
> @@ -1265,21 +1274,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
> +	 * rmap can't run anymore. For mTHP collapse we must hold the lock

This is really unclear. What does 'can't run anymore' mean? Why must we
hold the lock for mTHP?

I realise the previous comment was equally as unclear but let's make this
make sense please :)

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
> @@ -1289,20 +1298,34 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * write.
>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> +	if (is_pmd_order(order)) { /* PMD collapse */

At this point we still hold the pte lock, is that intended? Are we sure
there won't be any issues leaving it held during the operations that now
happen before you release it?

> +		pgtable = pmd_pgtable(_pmd);
>
> -	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> +		spin_lock(pmd_ptl);
> +		WARN_ON_ONCE(!pmd_none(*pmd));
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_address);

If we're PMD order start_addr == pmd_address right?

> +	} else { /* mTHP collapse */
> +		spin_lock(pmd_ptl);
> +		WARN_ON_ONCE(!pmd_none(*pmd));

You duplicate both of these lines in both branches, pull them out?

> +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
> +		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */

It'd be much nicer to call pmd_install() :)

Or maybe even to separate out the unlocked bit from pmd_install(), put that
in e.g. __pmd_install(), then use that after lock acquired?

> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> +	}
>  	spin_unlock(pmd_ptl);
>
>  	folio = NULL;

Not your code but... why? I guess to avoid the folio_put() below but
gross. Anyway this function needs refactoring, can be a follow up.

>
>  	result = SCAN_SUCCEED;
>  out_up_write:
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
> +	if (pte)
> +		pte_unmap(pte);

Again can be helped with helper struct :)

>  	mmap_write_unlock(mm);
> +	*mmap_locked = false;

And this... I also hate the break from if (*mmap_locked) ... etc.

>  out_nolock:
> +	WARN_ON_ONCE(*mmap_locked);

Should be a VM_WARN_ON_ONCE() if we keep it.

>  	if (folio)
>  		folio_put(folio);
>  	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
> @@ -1483,9 +1506,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
>  		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc);
> -		/* collapse_huge_page will return with the mmap_lock released */

Hm except this is true :) We also should probably just unlock before
entering as mentioned before.

> -		*mmap_locked = false;
> +					    unmapped, cc, mmap_locked,
> +					    HPAGE_PMD_ORDER);
>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> --
> 2.53.0
>

Cheers, Lorenzo

