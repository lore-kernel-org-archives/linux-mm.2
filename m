Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AF2CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC206B0005; Thu,  4 Jun 2026 08:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393236B0088; Thu,  4 Jun 2026 08:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8E96B008A; Thu,  4 Jun 2026 08:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19BF66B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:40:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C8F6163349
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:40:05 +0000 (UTC)
X-FDA: 84842187570.29.CBA74B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DFBCF18000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:40:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NQcWP/EL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780576803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4opj3K3uvrQEthGEJN16ENfmtJloc4qZSIKDG3RA7Eo=;
	b=qinytQkUY4X0RxQqky/b2tAwtMKvTLadzFTYqDaqIJcNA5xxfagKB4VL0CZrHqt8MgncMP
	n+QYJKU/MdLk6r9G3698ntiSBMne77xstZEbJkWXu7PkRRx+Ef6/dcXI1cgD/Q4p0aFfA5
	gGor7/K1U3Od2lzL7thSihaLDgDpBio=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NQcWP/EL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780576803;
	b=QoYLPnJeEa5Xz/j61RTSWmoPtPNG7G4qjcLVnZD5uT02TVwPg9RW5Pg5q8YVls1I/1MBZE
	VSpWEyITppF0yNjevsS1lLKkomfsKdpBXlL55COX0qebzMnl7/+cGYyysZOD/6TpZtBOwH
	rNlVJavh5Y8T4AGJht1R0fTUP4ojPn4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A9E46025B;
	Thu,  4 Jun 2026 12:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BB81F00893;
	Thu,  4 Jun 2026 12:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780576802;
	bh=4opj3K3uvrQEthGEJN16ENfmtJloc4qZSIKDG3RA7Eo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NQcWP/EL7C6pg9NfqaZ2/W/FLgJwoEBsiF2qspJ7ArpAAHHaFprJ7Owscsu0ObHEK
	 +nv7dN08Gg7R/ljt1B9d2k8qb6z+yIzfBlALlPL2NibVIfwKCC0kKPZrEz9aSOg+de
	 fqyj6nMO058us8qPDQU0uVUHOJHSAQWOLtCIPYR3hMki6Ftw6Apb8HTbw6zvyFMd/h
	 5dPazzKOJ7kWztn9FhL8Y1Dc1W5YTGdkexWL0i4HxmmMIVJbNf0GDjtcVaKDmCuIeN
	 yRqzbeJOGgIsXeUgE3clScJoWp6R+9gIGCvyKG5Bw1GBAFsi8Euii5szkYPuP9ym5Q
	 QbG46cDWxTdjg==
Date: Thu, 4 Jun 2026 13:39:47 +0100
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
Message-ID: <aiFw80oLty6F_-8m@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-7-npache@redhat.com>
 <aiFTSLb0kkTR7I9A@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiFTSLb0kkTR7I9A@lucifer>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: i5gsab9ed6ubpig7xmj8fbtekrk7xcpc
X-Rspamd-Queue-Id: DFBCF18000A
X-HE-Tag: 1780576803-25232
X-HE-Meta: U2FsdGVkX18lhTh16o6ED0ZKT5bMXu3zkFC6ImLNyVF0XRSkXzvN1MpwLN9zfDDy1XDNj0RCchsqHMZ3jp75li4Ns1pJbZYCVu8XPS5FjlU9Xjhwv2zSJYZwxzY2U+d/TycM5UbbxBzA8Q8d43dah60HlKM+fZXmtaIHs1dl07KVlX8QXNTM2l2MOtcsIUSUzpWWPXfNyqTRkKEmky6zqP7wTHp3WQR1BJTtNOoxuphUG9qc+8kXltwh1SNiKY8oNaagJcdyJsvpj7sFTAr/FV5+yEEcbLew0dnHvzuWPd4Sp48W6TsvMktzUHxiA6kN6Xm08WajfOTk3rnbd6GGRzkB2/7bMs2pQ5QjaCENBgiHdlFxoY1SSoZdW+orAtKjBiCrG4+fhOM3GTTK6XLNFz2NxbaYSn4Ea2azOF6KbfGg6A5TcsyFS59vRGKxcnwdz2FCR9rBLNEZiJ4LU/h4EA73bxHhvZaPBLSwSguTZ37ZRiZnQDNxzBEdn+RJqNcPpZ/yf38czJZQeQALrvq4lA8DTmJtX+B4t54HWQC2ul4+/F8q5jjSdoeqBzir7QoW0F88TSlh5k7fEnwGpXSCwxj4A5Ev5sdiNzgVXN7SfoaqRmkwJN2z1H7AZguD6TeP9Erd9eTOS74ELUN13jxcw9/CBPVIhgLPA34bqoW9nbPyN048lpTKx3NtBblbhy6YaroyjXzhwEVa4dbyZ6unuQ3P5fdxIHSBmqd3gq/HahPqWm5mtldnsEWYkbL68rlxs4JIpHhQdePaapVd5dlzSRozffoBRQp1Wo2f3yYgGxGY5qnFLHCskop97eK2385xOkoij7ijmDbsdBFbJRx7q1Cad0nZ67yRE/OrC1mX7fhEVRNuLWNY9cMh+0SinDfgeJWqchFc75aWZhpg5dAOVJrVYDtXxc6Ey9rfhT3XkMNaH+Q9+jT/4ZQpG6Ozwbf8bWDzeqd3af1tLRfgZ0k
 lbG45X69
 cJosfgbOJeN/6EWUyzNg0QMS6YC434hzQWXSNxZNorB0St9qBgEnLNmc2YZ9qvCAOT3+wJBWF1l4UAG3B4OpvknYimHOHKsVFbxjJFWYSn9BzWbdQ6K9kf9G9Wi2Hm+BptIixKT+4islz5eOhowItqScF5YMuWcX6qsAUjpF+oU/3j1LpMgs9BMhIfc+xLeNuFo/QhF4Mw+s9097WgElkM6c65b2x45khheCbhc4wAsyTMZ2KetVWM0f0w8cXVhT9VCK3gqWhakK2Fusj36dkP8kTMI0+aEi8Lm4UaNqQmHq2xVDGH2eyc6HaYZi4tA7OetVOyOUDFyKFhW4bslrKGjQXMmDizZKkPOkoQ5ux1b9fvVH8XqqkaJkjHrSnChh6ceocX7r5rRri5Wg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 12:38:30PM +0100, Lorenzo Stoakes wrote:
> I will go review the thread about the cache maintenance separately and
> respond about that.
>
> On Fri, May 22, 2026 at 09:00:01AM -0600, Nico Pache wrote:
> > Pass an order and offset to collapse_huge_page to support collapsing anon
> > memory to arbitrary orders within a PMD. order indicates what mTHP size we
> > are attempting to collapse to, and offset indicates were in the PMD to
> > start the collapse attempt.
> >
> > For non-PMD collapse we must leave the anon VMA write locked until after
> > we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> > the mTHP case this is not true, and we must keep the lock to prevent
> > access/changes to the page tables. This can happen if the rmap walkers hit
> > a pmd_none while the PMD entry is currently unavailable due to being
> > temporarily removed during the collapse phase.
> >
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> The logic LGTM generally, some questions for understanding below, and of
> course as per above I want to review the Lance/David subthread.
>
> Thanks!
>
> > ---
> >  mm/khugepaged.c | 93 +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 55 insertions(+), 38 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index fab35d318641..d64f42f66236 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1214,34 +1214,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> >   * while allocating a THP, as that could trigger direct reclaim/compaction.
> >   * Note that the VMA must be rechecked after grabbing the mmap_lock again.
> >   */
> > -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> > -		int referenced, int unmapped, struct collapse_control *cc)
> > +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> > +		int referenced, int unmapped, struct collapse_control *cc,
> > +		unsigned int order)
> >  {
> > +	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
> > +	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
> >  	LIST_HEAD(compound_pagelist);
> >  	pmd_t *pmd, _pmd;
> > -	pte_t *pte;
> > +	pte_t *pte = NULL;
>
> As mentioned elsewhere for some reason this was dropped in
> mm-unstable. Maybe a bad conflict resolution?
>
> >  	pgtable_t pgtable;
> >  	struct folio *folio;
> >  	spinlock_t *pmd_ptl, *pte_ptl;
> >  	enum scan_result result = SCAN_FAIL;
> >  	struct vm_area_struct *vma;
> >  	struct mmu_notifier_range range;
> > +	bool anon_vma_locked = false;
> >
> > -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> > -
> > -	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> > +	result = alloc_charge_folio(&folio, mm, cc, order);
> >  	if (result != SCAN_SUCCEED)
> >  		goto out_nolock;
> >
> >  	mmap_read_lock(mm);
> > -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > -					 HPAGE_PMD_ORDER);
> > +	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> > +					 &vma, cc, order);
> >  	if (result != SCAN_SUCCEED) {
> >  		mmap_read_unlock(mm);
> >  		goto out_nolock;
> >  	}
> >
> > -	result = find_pmd_or_thp_or_none(mm, address, &pmd);
> > +	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
> >  	if (result != SCAN_SUCCEED) {
> >  		mmap_read_unlock(mm);
> >  		goto out_nolock;
> > @@ -1253,8 +1255,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >  		 * released when it fails. So we jump out_nolock directly in
> >  		 * that case.  Continuing to collapse causes inconsistency.
> >  		 */
> > -		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> > -						     referenced, HPAGE_PMD_ORDER);
> > +		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
> > +						     referenced, order);
> >  		if (result != SCAN_SUCCEED)
> >  			goto out_nolock;
> >  	}
> > @@ -1269,20 +1271,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >  	 * mmap_lock.
> >  	 */
> >  	mmap_write_lock(mm);
> > -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> > -					 HPAGE_PMD_ORDER);
> > +	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> > +					 &vma, cc, order);
> >  	if (result != SCAN_SUCCEED)
> >  		goto out_up_write;
> >  	/* check if the pmd is still valid */
> >  	vma_start_write(vma);

Hmm actually I think we have another problem here.

For PMD THP this is fine. Only a single VMA can span the range we need, and it
will span the entire PMD.

But for mTHP we have an issue...

See below...

> > -	result = check_pmd_still_valid(mm, address, pmd);
> > +	result = check_pmd_still_valid(mm, pmd_addr, pmd);
> >  	if (result != SCAN_SUCCEED)
> >  		goto out_up_write;
> >
> >  	anon_vma_lock_write(vma->anon_vma);
> > +	anon_vma_locked = true;
>
> I worry that we hold this lock a lot longer now? Maybe the algorithmic
> change alters that, but Claude did suggest on the s390 bug that longer lock
> hold might be an issue.
>
> I wonder if we'll observe lock contention as a result?
>
> Correct me if I'm wrong and we're not holding longer than previously,
> however. Just appears that we do.
>
> >
> > -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> > -				address + HPAGE_PMD_SIZE);
> > +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
> > +				end_addr);
> >  	mmu_notifier_invalidate_range_start(&range);
> >
> >  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> > @@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >  	 * Parallel GUP-fast is fine since GUP-fast will back off when
> >  	 * it detects PMD is changed.
> >  	 */
> > -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> > +	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);

...So we exclude VMA locked faults faulting in a new PMD entry for PMD-sized THP
but for mTHP we might have _another_ VMA that spans another part of the range
mapped by the same PMD entry.

So we clear this, but we do not have a write lock on any other VMA, and so
racing VMA read locks can install a new PMD entry.

> >  	spin_unlock(pmd_ptl);

Especially since you unlock this :)

And...

> >  	mmu_notifier_invalidate_range_end(&range);
> >  	tlb_remove_table_sync_one();
> >
> > -	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> > +	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
> >  	if (pte) {
> > -		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> > -						      HPAGE_PMD_ORDER,
> > -						      &compound_pagelist);
> > +		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
> > +						      order, &compound_pagelist);
> >  		spin_unlock(pte_ptl);
> >  	} else {
> >  		result = SCAN_NO_PTE_TABLE;
> >  	}
> >
> >  	if (unlikely(result != SCAN_SUCCEED)) {
> > -		if (pte)
> > -			pte_unmap(pte);
>
> OK I seem to remember this is because we're holding the anon_vma lock
> longer. That does imply that on e.g. x86-64 the RCU lock is being held a
> bit longer also as well as the anon_vma loc.
>
> I guess it's also because we need to hold anon_vma and pte lock because
> we're fiddling around at PTE level for mTHP not just PMD level as 'classic'
> THP did.
>
> (Rememberings going on here :)
>
> >  		spin_lock(pmd_ptl);
> > -		BUG_ON(!pmd_none(*pmd));
> > +		WARN_ON_ONCE(!pmd_none(*pmd));

...this will get triggered.

I don't know whether we can safely hold the PMD lock across everything here for
mTHP?

Maybe the solution would have to be to scan through VMAs in the range of the PMD
and VMA write lock each of them?

That could cause some 'interesting' lock contention issues though? Then again,
we will be releasing the mmap write lock soon enough which will drop the VMA
write locks.

> >  		/*
> >  		 * We can only use set_pmd_at when establishing
> >  		 * hugepmds and never for establishing regular pmds that
> > @@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >  		 */
> >  		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> >  		spin_unlock(pmd_ptl);
> > -		anon_vma_unlock_write(vma->anon_vma);
> >  		goto out_up_write;
> >  	}
> >
> >  	/*
> > -	 * All pages are isolated and locked so anon_vma rmap
> > -	 * can't run anymore.
> > +	 * For PMD collapse all pages are isolated and locked so anon_vma
> > +	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
> > +	 * removed and not all pages are isolated and locked, so we must hold
>
> Right because some PTE entries be unaffected by the change.
>
> > +	 * the lock to prevent neighboring folios from attempting to access
> > +	 * this PMD until its reinstalled.
>
> OK. This is slightly annoying for my CoW context work as it means there's
> another case where we need to explicitly hold an anon_vma lock for
> correctness :)
>
> Anyway I will think about that separately, is what it is. And in fact
> motivates to want this merged earlier so I can work against it :)
>
>
> >  	 */
> > -	anon_vma_unlock_write(vma->anon_vma);
> > +	if (is_pmd_order(order)) {
> > +		anon_vma_unlock_write(vma->anon_vma);
> > +		anon_vma_locked = false;
> > +	}
> >
> >  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> > -					   vma, address, pte_ptl,
> > -					   HPAGE_PMD_ORDER,
> > -					   &compound_pagelist);
> > -	pte_unmap(pte);
> > +					   vma, start_addr, pte_ptl,
> > +					   order, &compound_pagelist);
> >  	if (unlikely(result != SCAN_SUCCEED))
> >  		goto out_up_write;
> >
> > @@ -1345,18 +1348,32 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >  	 * write.
> >  	 */
> >  	__folio_mark_uptodate(folio);
> > -	pgtable = pmd_pgtable(_pmd);
> > -
> >  	spin_lock(pmd_ptl);
> > -	BUG_ON(!pmd_none(*pmd));
> > -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> > +	WARN_ON_ONCE(!pmd_none(*pmd));
> > +	if (is_pmd_order(order)) {
> > +		pgtable = pmd_pgtable(_pmd);
> > +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> > +	} else {
> > +		/*
> > +		 * set_ptes is called in map_anon_folio_pte_nopf with the
> > +		 * pmd_ptl lock still held; this is safe as the PMD is expected
>
> PMD entry you mean?
>
> > +		 * to be none. The pmd entry is then repopulated below.
> > +		 */
> > +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
>
> So here we populate entries in the existing PTE _table_ to point at the new
> order>0 folio? With arm64 of course doing transparent contpte stuff?
>
> > +		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> > +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>
> And then we reinstall the pre-existing PMD _entry_ from none -> what it was
> before?
>
> > +	}
> >  	spin_unlock(pmd_ptl);
> >
> >  	folio = NULL;
> >
> >  	result = SCAN_SUCCEED;
> >  out_up_write:
> > +	if (anon_vma_locked)
> > +		anon_vma_unlock_write(vma->anon_vma);
> > +	if (pte)
> > +		pte_unmap(pte);
> >  	mmap_write_unlock(mm);
> >  out_nolock:
> >  	if (folio)
> > @@ -1536,7 +1553,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  		/* collapse_huge_page expects the lock to be dropped before calling */
> >  		mmap_read_unlock(mm);
> >  		result = collapse_huge_page(mm, start_addr, referenced,
> > -					    unmapped, cc);
> > +					    unmapped, cc, HPAGE_PMD_ORDER);
> >  		/* collapse_huge_page will return with the mmap_lock released */
> >  		*lock_dropped = true;
> >  	}
> > --
> > 2.54.0
> >

Thanks, Lorenzo

