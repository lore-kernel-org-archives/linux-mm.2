Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59DAB109B46F
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629436B0092; Tue, 31 Mar 2026 10:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9DA6B0095; Tue, 31 Mar 2026 10:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8B66B0096; Tue, 31 Mar 2026 10:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37AD46B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:01:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98CAC1A0274
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:01:30 +0000 (UTC)
X-FDA: 84606520740.27.544CD51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85BD314002C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:01:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H/p5VStt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774965688; a=rsa-sha256;
	cv=none;
	b=a/YjVNiK4TXO7U5A5w5raLeBDMGPgKRmZhkjEswEFldxO6y5CUH0PE3PQ0WuARQ4nDJv9f
	2Mj5tQH/g0jC0ufgoV3h2AMSW3bGpDJoNPr3TSGht2jOrMGMgd0+oRuNRv8WmExlE2Po9M
	sM/6r2oq2ts0fPaAMaGhG5EBvMVlYcU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H/p5VStt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774965688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZeQMKn83dTBNI2qdgRiArrnx+r8Lzs28TlV966LFQ8=;
	b=JL4donmwR2zh6gspb9/JNm/jJg9/Qk0FWBJ2477/Z6sJWQYSE7ZFVin4zq2Bou/NPk2ox4
	KL/URVE9CSoNWvlYVABJCys4tnmxWNLoPGyJaxk9CGZ3LDVJqpuvTcqi+nNi59WaWb4Lbr
	AMgPvQjb1JZIB+lIl8qNbAYXwr3B78U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6629E6012B;
	Tue, 31 Mar 2026 14:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD91C19423;
	Tue, 31 Mar 2026 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774965687;
	bh=3QNAlIt/WGhu+lu5S3zjSgStPUULTKuWD0FUaxX7abQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H/p5VSttub3eCYiW7dnMryStndIsldqT0G5v03so+IsVIEJr7dR0Ar4GYeUX+HSqf
	 dpkH3E0kz7iudg4DNN0GQzl42wqHsR2jpfs434VnnY/Y15/ENQVmiCHoTgIrtqiJ6B
	 kRfs4ZJW4TTl2NjMnT5UU0nyZ4AhrAlRJFCgjIuIecaVD9uVK5MgKhVO6BPvugLD2c
	 KRveICMxn+VVI89419/ztbMkxtu7Xsxhpzg+qX0Hnh6fO5ZJdmGW9ZkTcoI21SyPgm
	 C1v3QZifqNJM9N4PljR8dX71gk5VTtdte2j1uYTzsGYzBHqeyGGaTjOydzMJUgR4FJ
	 +jPqf4pX5g2RQ==
Date: Tue, 31 Mar 2026 15:01:24 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-ID: <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325114022.444081-6-npache@redhat.com>
X-Rspamd-Queue-Id: 85BD314002C
X-Stat-Signature: keatbbebnrdrapx1y5q9kucp8cis1xk3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774965688-66168
X-HE-Meta: U2FsdGVkX1/UpLglU5spqnwt+4/UlP6RQn4flHIMYJNCSQwuswUsQRKIJ5Udnkq/Ow60gT2HGyFkCfMSZcE8rtLiFyvCJhtzFAKQNU/7ME5/MNGPDqrpmMN6HfeWDCAE7UcobAZ5QajlAa1XGunQDpqB5r25cLtfUTYGO+B0vmjL9KHGgwr73fDWNS1bvkx9ojoAxDLQoyD4FWf6lNoEV3BHMeD5Sxmrerj7U6+AAZCPDVUnZReRfRDI6KISGaANmGutIxOaRio11gxdQoPhEcKWAlWhpjvFtFNge+RAJa+/LapRGsYarNsk77ergffYKrTZieUaBQ1v9YkdIBKRWyLpKKkosHDE6AMEloggGtmm9zDJin18hY3jo5cpR2mELBtzvlgmnYsyqod4ISpLmj0PSR+MPFsytDHLduqqqFfWtSxrz4t1Heh5NIZuoKOTZtEk33x4MQNBbJapDcXf7uKlGrETyjkx/rDOPEFo4WvFO3z7liGmTNy/5PpzxzKo4wCRjS7iSbOUgBAndWGxoO7c2OIa88NMxCtp2PDw+tebHolAutv6M5j81rRGPfl3xNJFcmfbmiyB3kgK8yebB7WMMw4Xh1qc4C57szuHMPVqW4XT44dZcMOAA3OBb5Qh5icipeSio+WGGMcSGfgODq+3kYqtdQpgfemRm86yRxCEyVGcXJFJDBloPrqqA6nocP6yYGi6QzRguG0LNFgPsm5sq8lP2y6Q0G4aECSLYHH0LhW+/RJLX/pQM01qxt78fN0Znpeg/kEXAuS7j1DJpTWIUnTDkY4MYUnUdZ3jH8/UFpPxEynyoW2r8krDRBm3EsD4+UmxLcXOVgnHlNUlQ4VB0BlCJ1qB6+2UHGXH2RO34Z14xfIngfAKrsbvsRoWjSk0DVDbFaB3v/oLugXSY8DKHnzSomNS8m8igTqBR74jpZPR3LLJ1NHd7pl9qiafF4I7pJ6LUpyEe02A1lU
 zgPqX4Bm
 7+Az9NjOaPYMNHGRHYfKxgwMMEQJW4coKKVz0wa2A6kIYWefsE7vgfptta6C9cvG8KP9czHLzVspwfZg83aH34Ex60spgvOX8IWz8miHfqKGX0KeYGL5bJWoBZAn3c0bpZKkR81zx5kbz0GZrRNtlPgWMli+4L2h5/WBSONd2LhIkp09BX+ThbsPsZr4FRee8FQW8e5poqPO2hdht4eua29wGmSeRwX6OPU7enVSMCNnXGp5K9RDu255/M8sPDdIn1XVV6ULz+WJEh9JDTdwVy2GRbM4IlI3K8axyRh3xYltFcQ64mS+fPRmuCd/vSeVaGQosAl9fOac+aHGsa7FvDTQ3Wp8+B9voKArQBJsMEfcZFfj7j1TwOt25bEKC2wY7zSPaf1L4ksWTtfq6GLa6/NeSIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK we need a fairly urgent fix for this as this has triggered a syzbot. See [0]
for an analysis.

I show inline where the issue is, and attach a fix-patch for the bug.

[0]: https://lore.kernel.org/all/e1cb33b8-c1f7-4972-8628-3a2169077d6e@lucifer.local/

See below for details.

Cheers, Lorenzo

On Wed, Mar 25, 2026 at 05:40:22AM -0600, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing. Create collapse_single_pmd
> to increase code reuse and create an entry point to these two users.
>
> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> collapse_single_pmd function. To help reduce confusion around the
> mmap_locked variable, we rename mmap_locked to lock_dropped in the
> collapse_scan_mm_slot() function, and remove the redundant mmap_locked
> in madvise_collapse(); this further unifies the code readiblity. the
> SCAN_PTE_MAPPED_HUGEPAGE enum is no longer reachable in the
> madvise_collapse() function, so we drop it from the list of "continuing"
> enums.
>
> This introduces a minor behavioral change that is most likely an
> undiscovered bug. The current implementation of khugepaged tests
> collapse_test_exit_or_disable() before calling collapse_pte_mapped_thp,
> but we weren't doing it in the madvise_collapse case. By unifying these
> two callers madvise_collapse now also performs this check. We also modify
> the return value to be SCAN_ANY_PROCESS which properly indicates that this
> process is no longer valid to operate on.
>
> By moving the madvise_collapse writeback-retry logic into the helper
> function we can also avoid having to revalidate the VMA.
>
> We guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
>
> As requested we also convert a VM_BUG_ON to a VM_WARN_ON.
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 142 ++++++++++++++++++++++++------------------------
>  1 file changed, 72 insertions(+), 70 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 3728a2cf133c..d06d84219e1b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1257,7 +1257,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>
>  static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		struct vm_area_struct *vma, unsigned long start_addr,
> -		bool *mmap_locked, struct collapse_control *cc)
> +		bool *lock_dropped, struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> @@ -1432,7 +1432,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		result = collapse_huge_page(mm, start_addr, referenced,
>  					    unmapped, cc);
>  		/* collapse_huge_page will return with the mmap_lock released */
> -		*mmap_locked = false;
> +		*lock_dropped = true;
>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> @@ -2424,6 +2424,67 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	return result;
>  }
>
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> + * the results.
> + */
> +static enum scan_result collapse_single_pmd(unsigned long addr,
> +		struct vm_area_struct *vma, bool *lock_dropped,
> +		struct collapse_control *cc)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	bool triggered_wb = false;
> +	enum scan_result result;
> +	struct file *file;
> +	pgoff_t pgoff;
> +
> +	mmap_assert_locked(mm);
> +
> +	if (vma_is_anonymous(vma)) {
> +		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
> +		goto end;
> +	}
> +
> +	file = get_file(vma->vm_file);
> +	pgoff = linear_page_index(vma, addr);
> +
> +	mmap_read_unlock(mm);
> +	*lock_dropped = true;
> +retry:
> +	result = collapse_scan_file(mm, addr, file, pgoff, cc);
> +
> +	/*
> +	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
> +	 * then retry the collapse one time.
> +	 */
> +	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> +	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
> +		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +
> +		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> +		triggered_wb = true;
> +		goto retry;
> +	}
> +	fput(file);
> +
> +	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
> +		mmap_read_lock(mm);
> +		if (collapse_test_exit_or_disable(mm))
> +			result = SCAN_ANY_PROCESS;
> +		else
> +			result = try_collapse_pte_mapped_thp(mm, addr,
> +							     !cc->is_khugepaged);
> +		if (result == SCAN_PMD_MAPPED)
> +			result = SCAN_SUCCEED;
> +		mmap_read_unlock(mm);
> +	}
> +end:
> +	if (cc->is_khugepaged && result == SCAN_SUCCEED)
> +		++khugepaged_pages_collapsed;
> +	return result;
> +}
> +
>  static void collapse_scan_mm_slot(unsigned int progress_max,
>  		enum scan_result *result, struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
> @@ -2485,46 +2546,21 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
>
>  		while (khugepaged_scan.address < hend) {
> -			bool mmap_locked = true;
> +			bool lock_dropped = false;
>
>  			cond_resched();
>  			if (unlikely(collapse_test_exit_or_disable(mm)))
>  				goto breakouterloop;
>
> -			VM_BUG_ON(khugepaged_scan.address < hstart ||
> +			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart ||
>  				  khugepaged_scan.address + HPAGE_PMD_SIZE >
>  				  hend);
> -			if (!vma_is_anonymous(vma)) {
> -				struct file *file = get_file(vma->vm_file);
> -				pgoff_t pgoff = linear_page_index(vma,
> -						khugepaged_scan.address);
> -
> -				mmap_read_unlock(mm);
> -				mmap_locked = false;
> -				*result = collapse_scan_file(mm,
> -					khugepaged_scan.address, file, pgoff, cc);
> -				fput(file);
> -				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> -					mmap_read_lock(mm);
> -					if (collapse_test_exit_or_disable(mm))
> -						goto breakouterloop;
> -					*result = try_collapse_pte_mapped_thp(mm,
> -						khugepaged_scan.address, false);
> -					if (*result == SCAN_PMD_MAPPED)
> -						*result = SCAN_SUCCEED;
> -					mmap_read_unlock(mm);
> -				}
> -			} else {
> -				*result = collapse_scan_pmd(mm, vma,
> -					khugepaged_scan.address, &mmap_locked, cc);
> -			}
> -
> -			if (*result == SCAN_SUCCEED)
> -				++khugepaged_pages_collapsed;
>
> +			*result = collapse_single_pmd(khugepaged_scan.address,
> +						      vma, &lock_dropped, cc);
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
> -			if (!mmap_locked)
> +			if (lock_dropped)
>  				/*
>  				 * We released mmap_lock so break loop.  Note
>  				 * that we drop mmap_lock before all hugepage
> @@ -2799,7 +2835,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	unsigned long hstart, hend, addr;
>  	enum scan_result last_fail = SCAN_FAIL;
>  	int thps = 0;
> -	bool mmap_locked = true;
>
>  	BUG_ON(vma->vm_start > start);
>  	BUG_ON(vma->vm_end < end);
> @@ -2821,13 +2856,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>  		enum scan_result result = SCAN_FAIL;
> -		bool triggered_wb = false;
>
> -retry:
> -		if (!mmap_locked) {
> +		if (*lock_dropped) {
>  			cond_resched();
>  			mmap_read_lock(mm);
> -			mmap_locked = true;
> +			*lock_dropped = false;

So this is the bug. 'lock_dropped' needs to record if the lock was _ever_
dropped, not if it is _currently_ dropped.

This is probably a mea culpa on my part on review, so apologies.

See below for a fix-patch.

>  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>  							 cc);
>  			if (result  != SCAN_SUCCEED) {
> @@ -2837,45 +2870,14 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>
>  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>  		}
> -		mmap_assert_locked(mm);
> -		if (!vma_is_anonymous(vma)) {
> -			struct file *file = get_file(vma->vm_file);
> -			pgoff_t pgoff = linear_page_index(vma, addr);
>
> -			mmap_read_unlock(mm);
> -			mmap_locked = false;
> -			*lock_dropped = true;
> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
> -
> -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> -			    mapping_can_writeback(file->f_mapping)) {
> -				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> -				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> -
> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> -				triggered_wb = true;
> -				fput(file);
> -				goto retry;
> -			}
> -			fput(file);
> -		} else {
> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
> -		}
> -		if (!mmap_locked)
> -			*lock_dropped = true;
> +		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
>
> -handle_result:
>  		switch (result) {
>  		case SCAN_SUCCEED:
>  		case SCAN_PMD_MAPPED:
>  			++thps;
>  			break;
> -		case SCAN_PTE_MAPPED_HUGEPAGE:
> -			BUG_ON(mmap_locked);
> -			mmap_read_lock(mm);
> -			result = try_collapse_pte_mapped_thp(mm, addr, true);
> -			mmap_read_unlock(mm);
> -			goto handle_result;
>  		/* Whitelisted set of results where continuing OK */
>  		case SCAN_NO_PTE_TABLE:
>  		case SCAN_PTE_NON_PRESENT:
> @@ -2898,7 +2900,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>
>  out_maybelock:
>  	/* Caller expects us to hold mmap_lock on return */
> -	if (!mmap_locked)
> +	if (*lock_dropped)
>  		mmap_read_lock(mm);
>  out_nolock:
>  	mmap_assert_locked(mm);
> --
> 2.53.0
>

Fix patch follows:

----8<----
From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Tue, 31 Mar 2026 13:11:18 +0100
Subject: [PATCH] mm/khugepaged: fix issue with tracking lock

We are incorrectly treating lock_dropped to track both whether the lock is
currently held and whether or not the lock was ever dropped.

Update this change to account for this.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/khugepaged.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d21348b85a59..b8452dbdb043 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
+	bool mmap_unlocked = false;

 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;

-		if (*lock_dropped) {
+		if (mmap_unlocked) {
 			cond_resched();
 			mmap_read_lock(mm);
-			*lock_dropped = false;
+			mmap_unlocked = false;
+			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}

-		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
+		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);

 		switch (result) {
 		case SCAN_SUCCEED:
@@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,

 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (*lock_dropped)
+	if (mmap_unlocked) {
+		*lock_dropped = true;
 		mmap_read_lock(mm);
+	}
 out_nolock:
 	mmap_assert_locked(mm);
 	mmdrop(mm);
--
2.53.0

