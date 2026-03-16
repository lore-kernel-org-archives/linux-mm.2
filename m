Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D968F53D8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3E86B034B; Mon, 16 Mar 2026 14:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9476A6B034C; Mon, 16 Mar 2026 14:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853AE6B034D; Mon, 16 Mar 2026 14:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 718AE6B034B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:54:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24E6BB908F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:54:08 +0000 (UTC)
X-FDA: 84552826176.09.AD7D757
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79C2E20003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:54:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3xuz+1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773687246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAArdl7EaZX8z/jWMeyYMt0oeKUbmlGdyxZteNzTe3Q=;
	b=MJIhHES++whorixfjV2qkSuYIw+k96PAH4QLv+adTyOVePUvu3xoa3m65bpGG8IS27Lzhh
	Y52kc0cKxVVjji67qhQ6SIu0507HZKVcPz2mU39oVpUIJqHk4XmaG3Atic4JBNLW/IVeGX
	/XRj9zzRUyf5GvOkEzihfuJ0Wa1oBlA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773687246; a=rsa-sha256;
	cv=none;
	b=FtcXn8/rfzKhvx1CycUKDdkW0xpKCU40Ecvxp0U7hIpTb3ySanN0F3eucFAv78Q8zFP5ob
	8uyDSGO1lVzNkMe2tEX9jd7jdLMy1AqKyZFLzRg6iMmWKUKV4kTXuppWGnBfPcgctpMDQV
	9k8xd3ms03PPLSTVEGg/ubDRn+x36Yo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3xuz+1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A404660123;
	Mon, 16 Mar 2026 18:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3420C19421;
	Mon, 16 Mar 2026 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773687245;
	bh=7+1pt7j7D2qnVA9uCZuqifM+Dqo+V4s9K4ZaH0VJI+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q3xuz+1wz2sLcyvTchb22arPvEzlHz06YTP2geWVo1K7sUmkzHj6gG8mmQQxr4NMZ
	 mR/fu0j0FFXr7PmfcyIMT9xHwPx/flspE/xXySgKXV85LGS8opm0IdtKBBoq4E3ToM
	 JCgvbuJBvB5UpJMlbY+PA/6cmenGAvZivzcyOOLKyAV+Vs3PLyoEqUDpbsii2AhwSQ
	 lrJ5JmlwV8+Xa0RKB1rlV5RjiD36Nug9aGDCuLZ7UplFEEjuBwogZEVbvYcXWhNgnk
	 7e2N2IS/KbiuC+NNDCwM9fTQSx4MDZZZ0I9ROZR7k/0RraLRILImserDtkPGGKBUfQ
	 IDa63AhiAnjZw==
Date: Mon, 16 Mar 2026 18:54:03 +0000
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
Message-ID: <f6029c48-3e00-4efa-bb2d-579916029131@lucifer.local>
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-6-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311211315.450947-6-npache@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 79C2E20003
X-Stat-Signature: zasbzu4w5k1qh5nri4wtgsfqn4zqjdzy
X-Rspam-User: 
X-HE-Tag: 1773687246-529177
X-HE-Meta: U2FsdGVkX189H4FMGPQ1ddM1V8ARrgcB1miCLwe1I7sG614+L5GQaI5TvlehT0IYvC/jkxApw1kfSsQdqtUbmJylg59vPJfDzoEVSG89J0k2+LclfTzOmrEJNFN2RurabwvXLi5KCqpqm98btnOz3nlEOO/4kOPZ132thjpVTtxaIiuZB8cdNDC3mtOChGC6gRLGtr++ta945d+SnKaYQJ5xbP/f4JqlyhDc4Ni2Tiv5GBtrUofOa2f6S0f2s5KWAmdf4WNvSsTfp9sr04lCjHo3fP+s3znqcCmjlS0duTssVIh79iMXQYnQuh/n1R06zFfeHeb04ymlpq7Hpys28J6YEinnOc+kmwTzTNYClYey9RA73SN8F4NC2W1ouOHk8qLb6PgB7rrqeyZMrx64ioNH7PM8nW0XPrLUGmLOS1VNy9ws2FzX7ANJt+zi4UrVJo9t/GZlfS+7NmVsv7rAgrtET490wF0rl7uvYCdyYTIDVGHWjDkBW8ekXbpOAyw0ldyVIHah3F9ik/yO7z1BFBXI+/JByXYj0uRfTINQ5OLvqhqdOUexdjaeqWlA/qJFh/gjsPA5HqGFEVUt/Hmkwj8/eZCXIJlt/gJLS1Pj2Yd3XXBacPkHz5NNZa17V3rLbk/zHvXT8jhuo/z214eiSkXLTM8OHFnEDA6ePHkBwdVQZOtKxEeLOwY2+D28NL02SESZlxsyUKgawQh1HFprEvJQ7CcsqRMbU1rUp7T/vjIkVUFl6+HuX3xJhboMuLcZrExQmQwNzeAhzyczeCeGBpZCwWTTrQhF69rqrZoTdnGTE8H445QhSw83elPnTFM1m6IOLr3Xrm6pDkSofIk9PNtj/D334pR+JRA8Y5UONvIHcswXhokuPT+Ym3tkpj8bJWDcPC17cuug9QBYEkx84LPOEUlOvVqm3oWxuW3t4e7xXkl1GMDJ0ArQVaPCjt5jxK8HftjIku8NS0NIJbD
 U/G2d6uh
 uqgnL/kPNg2yjGfiMTCRtfvjfsZfwcuwsqlqSqD2CFOb1cNJ2hzdFsOmWNG6giuQ38z7rs/OR3XyVAwbkjV45ZLmKh8xc56lKNYWT2hxSHkoWyoX3tqZLnT6m2g+CWNd+4OEUocX+2wVJrCNnWO+jmV8pbCbmlmPoERFv01c7v3eISvFKf5VrsJ5lqrDhkDwRA64BPAsvtQMCGv9iwqBY51Qtd6wxJ+bxsj6K5eQpSRpRd7xb9jxTbnC+c/qfUOk1IUvPAiYiEN8jQ7OhpNUaHEQv4HPaqvkrqgwNMTH3KC1WHxridjFm+Q6pc9bg4J3hLyc7w4YbC+no4C2gHQA2PAd4p6C7RYn69kS1pZKMxxOqubUPXCPpC9CVwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 03:13:15PM -0600, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing. Create collapse_single_pmd
> to increase code reuse and create an entry point to these two users.

Ah this is nice :) Thanks!

>
> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> collapse_single_pmd function. This introduces a minor behavioral change
> that is most likely an undiscovered bug. The current implementation of
> khugepaged tests collapse_test_exit_or_disable before calling
> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> case. By unifying these two callers madvise_collapse now also performs
> this check. We also modify the return value to be SCAN_ANY_PROCESS which
> properly indicates that this process is no longer valid to operate on.
>
> By moving the madvise_collapse writeback-retry logic into the helper
> function we can also avoid having to revalidate the VMA.
>
> We also guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
>
> Signed-off-by: Nico Pache <npache@redhat.com>

The logic all seems correct to me, just a bunch of nits below really. This is
a really nice refactoring! :)

With them addressed:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Cheers, Lorenzo

> ---
>  mm/khugepaged.c | 120 +++++++++++++++++++++++++-----------------------
>  1 file changed, 63 insertions(+), 57 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 33ae56e313ed..733c4a42c2ce 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2409,6 +2409,65 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	return result;
>  }
>
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> + * the results.
> + */
> +static enum scan_result collapse_single_pmd(unsigned long addr,
> +		struct vm_area_struct *vma, bool *mmap_locked,

mmap_locked seems mildly pointless here, and it's a semi-code smell to pass 'is
locked' flags I think.

You never read this, but the parameter implies somebody might pass in mmaplocked
== false, but you know it's always true here.

Anyway I think it makes more sense to pass in lock_dropped and get rid of
mmap_locked in madvise_collapse() and just pass in lock_dropped directly
(setting it false if anon).

Also obviously update collapse_scan_mm_slot() to use lock_dropped instead just
inverted.

That's clearer I think since it makes it a verb rather than a noun and the
function is dictating whether or not the lock is dropped, it also implies the
lock is held on entry.

> +		struct collapse_control *cc)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	bool triggered_wb = false;
> +	enum scan_result result;
> +	struct file *file;
> +	pgoff_t pgoff;
> +

Maybe move the mmap_assert_locked() from madvise_collapse() to here? Then we
assert it in both cases.

> +	if (vma_is_anonymous(vma)) {
> +		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
> +		goto end;
> +	}
> +
> +	file = get_file(vma->vm_file);
> +	pgoff = linear_page_index(vma, addr);
> +
> +	mmap_read_unlock(mm);
> +	*mmap_locked = false;
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

Thinking through this logic I do agree that we don't need to revalidate here,
which should be quite a nice win, I just don't know why we previously assumed
we'd have to... or maybe it was just because it became too spaghetti to goto
around it somehow??

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
> @@ -2479,34 +2538,9 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
>  				  khugepaged_scan.address + HPAGE_PMD_SIZE >
>  				  hend);

Nice-to-have, but could we convert these VM_BUG_ON()'s to VM_WARN_ON_ONCE()'s
while we're passing?

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
> +						      vma, &mmap_locked, cc);
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
>  			if (!mmap_locked)
> @@ -2806,9 +2840,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>  		enum scan_result result = SCAN_FAIL;
> -		bool triggered_wb = false;
>
> -retry:
>  		if (!mmap_locked) {
>  			cond_resched();
>  			mmap_read_lock(mm);
> @@ -2823,46 +2855,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>  		}
>  		mmap_assert_locked(mm);
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
> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
>
> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> -				triggered_wb = true;
> -				fput(file);
> -				goto retry;
> -			}
> -			fput(file);
> -		} else {
> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
> -		}
>  		if (!mmap_locked)
>  			*lock_dropped = true;
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
> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>  		case SCAN_PTE_NON_PRESENT:
>  		case SCAN_PTE_UFFD_WP:
>  		case SCAN_LACK_REFERENCED_PAGE:
> --
> 2.53.0
>

