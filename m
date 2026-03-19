Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 293451090242
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3476B0522; Thu, 19 Mar 2026 12:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C786B0524; Thu, 19 Mar 2026 12:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714C36B0525; Thu, 19 Mar 2026 12:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 558B36B0522
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:01:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 797FE14069B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:01:43 +0000 (UTC)
X-FDA: 84563278086.09.7EAA6E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81EA4A0003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:01:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BCjV2tnA;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kMC5YntEu+zF45Vhb3fXLVC3Z8mBAMVYUEuhwEIa4A=;
	b=zqg3Hi3bu7FDfjSGRI3qvQf+rWTSdZtAsvuMlc/j0LZPqH2Za+dHYr9bbbj6FDprcoQHnp
	SzlOvcrmZri4BKtOvrcwxRDRtfWCWqh0fI9erB/NomyfTMVcdNveoGz0dOykFuP6Z6nbCG
	ZCUols7W7btR5lqojlYSNyF99NdpNFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936101; a=rsa-sha256;
	cv=none;
	b=OhW59Y8zlBqG7m+qfyc/mhGTur6KbxgqBjvTVtytU1QwAmqAKGNGrFt9HA9KhXdtI4OwIO
	O1h8DbwK1wuezlFlTdgRuhbKv2nepfFL5ljLpKg3v8ORbtBn7FDeof6S00cZSFIochktEG
	Q/jksPm5g64IDy+ZE6jNo45jOiGdhNw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BCjV2tnA;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DDCD40514;
	Thu, 19 Mar 2026 16:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B91C2BCAF;
	Thu, 19 Mar 2026 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773936100;
	bh=rHuuftICl5U81p2iFVhblQDr411eF4EKt+9WLBWm2CI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BCjV2tnA3/Pqb2ASDP3DMtK6m0UvWQvU8jSABkYsg+QEln7J+20I8R5H5bfBYStFT
	 rrsP8nWUWMDpMulM0z/1hVAV9DkKOkkRGZzGFwbqf1h39Mg1qDvAfKGGwv1dqe0KFZ
	 ji0N+eWY1Q6sVR+AZqrP3Ns+NanQ0br9OF9WwZ2ZuUTLsnQ96cKwAUb8Dy5sTzrrwY
	 rB6IUvGiTMIp7I/UOEeDvyiSvolAM3wtZqIta7o8H7m+sYp/YUWO81da/Sm5T/hePt
	 I66lAgjAWJRmckXZKZDKh0RtoIN3ZE46r72g+tXJwk/WcfCBIYHsMJNSJnf5AsAW2F
	 VHNvw8Lr1LDAg==
Date: Thu, 19 Mar 2026 16:01:37 +0000
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
Subject: Re: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-ID: <c781ec19-724b-4c00-9ad6-56b9733cefa0@lucifer.local>
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-6-npache@redhat.com>
 <f6029c48-3e00-4efa-bb2d-579916029131@lucifer.local>
 <9d9815ed-561b-4071-836f-4f2409830761@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d9815ed-561b-4071-836f-4f2409830761@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81EA4A0003
X-Stat-Signature: ihjqbycshsdz4s67mxgqmdpqsbhozrzj
X-HE-Tag: 1773936101-275897
X-HE-Meta: U2FsdGVkX18JMsX2K5b3EiRITNzAbgOgpLQdjQOBkeL5OmnWyRFGuXTBV8p56g++zDD6it1xNwplebw0+dvvjnADmpe+FYtON0G6rvTw2MuwaPZpxhFGWVmms4MvhUVA29/Wc5xsO71Abbx+g8193KyQaS8xYrt99pzm2Bexe+PrQmN+d/hXmSLsVAYsIGU+OI09B6fOO4VNqWBVUZYSmhLYG4wDiJsywS8kKh8Rb/OvE2zW0ep1LuDhYdbVmzMQkL0fHAOZ6TtnEgFc3TxuwvM0ny9bJYQzRwdVM5UOmoEmfpFiPmWo1Se2LW3DJ6CfvDFkzyzlu0Icnn39X4Z7CBOnbZecifHU/i/+aedorSypOyZhZSf0YIZ8TQtIojyTODaj7BdeWa1x8W++UBnAus62x3xhYFNpNNF6S7MPXjZO1lAg03rcXx1YzCOoc1ik9LVVoMhtdwkS4mmXGD3ESpDyVi9qo1xwp1SK86ZXrhSeDAotg+3blIXan3bY37r+/Y0qXEKOpLd3ua/4RyFA7Vm0N4B/81dlKKbuRR0u8tk5s6+M86NwdZyCVidZNFersaMpghVbCqqDPjNjde/UU4Ac+/VANNSAfwGO/21rFfWyiHVam34ilFD2PJ6t1DQMxMmJMpi9en04AcewCrZGlVyrZcF0cbeRFhh3zr0OYoQHb9gfS57hUfXOCjz8KoNnlgRF5Ot2iHD4ALorvumQ5q8p62lEWAAhxWCp0+WZZcv9S9Vz6s+dioZVWfMDsbmW4HigK8WYlzKUf3Gh97F97NTm3MVWBMo9TMSInTrFM09VaXuIWfrVYKYxh6DAm/p21DhVLA6mKOj8+xa0tTpGsvNa/3FwFPXisaYBl5zkImichyq0WE31KBgxmROneS1DIOBmazjuLVYJVsOcWvERLdzKv30QN/3bdxFbamC1CRhO9TlrNTmsVqvsfyigPslO4W+7g4apedP8hDBaag1
 H6/ILu/j
 znX3NPw4rgk9XntBb4dG23wED3FiG09oSE6IaQCanIUMOsDyUaFvvB8AIu5/7jvAALrtSY8Dl4vG+ri0s6uV84Pmq/w2Hi6JE3mdzj6vIabDApzaYApe4na3NZzBMqOxpJZEGAAfkroIdqYj7XLgld7qIVTZiI1TaSJjw63t/H1s9JLa904SBvskBXkQcvJ5n+t5dPjt79PRy2MVY5nmb6hZr4jPO9Dyxmhff7LAUaQblwWJB6V/6oLjUf28AQUto6tku3yq2ud/4ovpSms7bzQyXYbmp/ZuyO6FnS06+XOP+eyXDI5flBHN2eazXsr4/4CNLFD585cdzhsb3zbQmgQOHaGHKAMvtOZ5DnbLikutqkxdv9rhThiWfTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 11:22:07AM -0600, Nico Pache wrote:
>
>
> On 3/16/26 12:54 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 11, 2026 at 03:13:15PM -0600, Nico Pache wrote:
> >> The khugepaged daemon and madvise_collapse have two different
> >> implementations that do almost the same thing. Create collapse_single_pmd
> >> to increase code reuse and create an entry point to these two users.
> >
> > Ah this is nice :) Thanks!
>
> Thanks :) hopefully more khugepaged cleanups to come after these series' land.
>
> >
> >>
> >> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> >> collapse_single_pmd function. This introduces a minor behavioral change
> >> that is most likely an undiscovered bug. The current implementation of
> >> khugepaged tests collapse_test_exit_or_disable before calling
> >> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> >> case. By unifying these two callers madvise_collapse now also performs
> >> this check. We also modify the return value to be SCAN_ANY_PROCESS which
> >> properly indicates that this process is no longer valid to operate on.
> >>
> >> By moving the madvise_collapse writeback-retry logic into the helper
> >> function we can also avoid having to revalidate the VMA.
> >>
> >> We also guard the khugepaged_pages_collapsed variable to ensure its only
> >> incremented for khugepaged.
> >>
> >> Signed-off-by: Nico Pache <npache@redhat.com>
> >
> > The logic all seems correct to me, just a bunch of nits below really. This is
> > a really nice refactoring! :)
> >
> > With them addressed:
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Thanks I will address those!
>
> >
> > Cheers, Lorenzo
> >
> >> ---
> >>  mm/khugepaged.c | 120 +++++++++++++++++++++++++-----------------------
> >>  1 file changed, 63 insertions(+), 57 deletions(-)
> >>
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 33ae56e313ed..733c4a42c2ce 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -2409,6 +2409,65 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >>  	return result;
> >>  }
> >>
> >> +/*
> >> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> >> + * the results.
> >> + */
> >> +static enum scan_result collapse_single_pmd(unsigned long addr,
> >> +		struct vm_area_struct *vma, bool *mmap_locked,
> >
> > mmap_locked seems mildly pointless here, and it's a semi-code smell to pass 'is
> > locked' flags I think.
> >
> > You never read this, but the parameter implies somebody might pass in mmaplocked
> > == false, but you know it's always true here.
> >
> > Anyway I think it makes more sense to pass in lock_dropped and get rid of
> > mmap_locked in madvise_collapse() and just pass in lock_dropped directly
> > (setting it false if anon).
> >
> > Also obviously update collapse_scan_mm_slot() to use lock_dropped instead just
> > inverted.
> >
> > That's clearer I think since it makes it a verb rather than a noun and the
> > function is dictating whether or not the lock is dropped, it also implies the
> > lock is held on entry.
>
> Ok I will give this a shot!
>
> >
> >> +		struct collapse_control *cc)
> >> +{
> >> +	struct mm_struct *mm = vma->vm_mm;
> >> +	bool triggered_wb = false;
> >> +	enum scan_result result;
> >> +	struct file *file;
> >> +	pgoff_t pgoff;
> >> +
> >
> > Maybe move the mmap_assert_locked() from madvise_collapse() to here? Then we
> > assert it in both cases.
>
> ack, Sounds like a good idea!

Thanks + for above! :)

>
> >
> >> +	if (vma_is_anonymous(vma)) {
> >> +		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
> >> +		goto end;
> >> +	}
> >> +
> >> +	file = get_file(vma->vm_file);
> >> +	pgoff = linear_page_index(vma, addr);
> >> +
> >> +	mmap_read_unlock(mm);
> >> +	*mmap_locked = false;
> >> +retry:
> >> +	result = collapse_scan_file(mm, addr, file, pgoff, cc);
> >> +
> >> +	/*
> >> +	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
> >> +	 * then retry the collapse one time.
> >> +	 */
> >> +	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> >> +	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
> >> +		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> >> +		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> >> +
> >> +		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> >> +		triggered_wb = true;
> >> +		goto retry;
> >
> > Thinking through this logic I do agree that we don't need to revalidate here,
> > which should be quite a nice win, I just don't know why we previously assumed
> > we'd have to... or maybe it was just because it became too spaghetti to goto
> > around it somehow??
>
> I believe the latter, the retry went at the top of the loop, and the
> revalidation was already being done.

Yeah makes sense!

>
> >
> >> +	}
> >> +	fput(file);
> >> +
> >> +	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
> >> +		mmap_read_lock(mm);
> >> +		if (collapse_test_exit_or_disable(mm))
> >> +			result = SCAN_ANY_PROCESS;
> >> +		else
> >> +			result = try_collapse_pte_mapped_thp(mm, addr,
> >> +							     !cc->is_khugepaged);
> >> +		if (result == SCAN_PMD_MAPPED)
> >> +			result = SCAN_SUCCEED;
> >> +		mmap_read_unlock(mm);
> >> +	}
> >> +end:
> >> +	if (cc->is_khugepaged && result == SCAN_SUCCEED)
> >> +		++khugepaged_pages_collapsed;
> >> +	return result;
> >> +}
> >> +
> >>  static void collapse_scan_mm_slot(unsigned int progress_max,
> >>  		enum scan_result *result, struct collapse_control *cc)
> >>  	__releases(&khugepaged_mm_lock)
> >> @@ -2479,34 +2538,9 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
> >>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
> >>  				  khugepaged_scan.address + HPAGE_PMD_SIZE >
> >>  				  hend);
> >
> > Nice-to-have, but could we convert these VM_BUG_ON()'s to VM_WARN_ON_ONCE()'s
> > while we're passing?
>
> Yeah sure, I have a question about these, because they do concern me (perhaps
> out of ignorance). does a WARN_ON_ONCE stop the daemon? I would be concerned
> about a rogue khugepaged instance going through and messing with page tables
> when it fails some assertion. Could this not lead to serious memory/file
> corruptions?

It won't, but all of this is in CONFIG_DEBUG_VM anyway, so it's a kernel bug if
it happens in a release kernel, this is just for visibility when debugging and
those systems should be e.g. VMS etc.

The fact this is VM_xxx and hasn't apparently fired before suggests we're good.

>
> Thanks for the reviews!
>
> Cheers,
> -- Nico
>
> >
> >> -			if (!vma_is_anonymous(vma)) {
> >> -				struct file *file = get_file(vma->vm_file);
> >> -				pgoff_t pgoff = linear_page_index(vma,
> >> -						khugepaged_scan.address);
> >> -
> >> -				mmap_read_unlock(mm);
> >> -				mmap_locked = false;
> >> -				*result = collapse_scan_file(mm,
> >> -					khugepaged_scan.address, file, pgoff, cc);
> >> -				fput(file);
> >> -				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> >> -					mmap_read_lock(mm);
> >> -					if (collapse_test_exit_or_disable(mm))
> >> -						goto breakouterloop;
> >> -					*result = try_collapse_pte_mapped_thp(mm,
> >> -						khugepaged_scan.address, false);
> >> -					if (*result == SCAN_PMD_MAPPED)
> >> -						*result = SCAN_SUCCEED;
> >> -					mmap_read_unlock(mm);
> >> -				}
> >> -			} else {
> >> -				*result = collapse_scan_pmd(mm, vma,
> >> -					khugepaged_scan.address, &mmap_locked, cc);
> >> -			}
> >> -
> >> -			if (*result == SCAN_SUCCEED)
> >> -				++khugepaged_pages_collapsed;
> >>
> >> +			*result = collapse_single_pmd(khugepaged_scan.address,
> >> +						      vma, &mmap_locked, cc);
> >>  			/* move to next address */
> >>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
> >>  			if (!mmap_locked)
> >> @@ -2806,9 +2840,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >>
> >>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> >>  		enum scan_result result = SCAN_FAIL;
> >> -		bool triggered_wb = false;
> >>
> >> -retry:
> >>  		if (!mmap_locked) {
> >>  			cond_resched();
> >>  			mmap_read_lock(mm);
> >> @@ -2823,46 +2855,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >>  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
> >>  		}
> >>  		mmap_assert_locked(mm);
> >> -		if (!vma_is_anonymous(vma)) {
> >> -			struct file *file = get_file(vma->vm_file);
> >> -			pgoff_t pgoff = linear_page_index(vma, addr);
> >>
> >> -			mmap_read_unlock(mm);
> >> -			mmap_locked = false;
> >> -			*lock_dropped = true;
> >> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
> >> -
> >> -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> >> -			    mapping_can_writeback(file->f_mapping)) {
> >> -				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> >> -				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> >> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> >>
> >> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> >> -				triggered_wb = true;
> >> -				fput(file);
> >> -				goto retry;
> >> -			}
> >> -			fput(file);
> >> -		} else {
> >> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
> >> -		}
> >>  		if (!mmap_locked)
> >>  			*lock_dropped = true;
> >>
> >> -handle_result:
> >>  		switch (result) {
> >>  		case SCAN_SUCCEED:
> >>  		case SCAN_PMD_MAPPED:
> >>  			++thps;
> >>  			break;
> >> -		case SCAN_PTE_MAPPED_HUGEPAGE:
> >> -			BUG_ON(mmap_locked);
> >> -			mmap_read_lock(mm);
> >> -			result = try_collapse_pte_mapped_thp(mm, addr, true);
> >> -			mmap_read_unlock(mm);
> >> -			goto handle_result;
> >>  		/* Whitelisted set of results where continuing OK */
> >>  		case SCAN_NO_PTE_TABLE:
> >> +		case SCAN_PTE_MAPPED_HUGEPAGE:
> >>  		case SCAN_PTE_NON_PRESENT:
> >>  		case SCAN_PTE_UFFD_WP:
> >>  		case SCAN_LACK_REFERENCED_PAGE:
> >> --
> >> 2.53.0
> >>
> >
>

Cheers, Lorenzo

