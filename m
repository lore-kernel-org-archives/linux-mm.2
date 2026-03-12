Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E86FED2F8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402076B0089; Thu, 12 Mar 2026 05:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CBFD6B008A; Thu, 12 Mar 2026 05:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF0A6B008C; Thu, 12 Mar 2026 05:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA776B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:28:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 993721B8BA7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:28:04 +0000 (UTC)
X-FDA: 84536884488.24.3791D1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E0F9140005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:28:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=utqP9oHb;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773307682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/U+LHToLd/hfwYtkvP350G++WIMiy5DMAJ0TaP/0no=;
	b=7WCa6OSrSR3ZhwK09anb8QpERb/FGGe5it2RXOcdOhuRckX5vrJpViyZSWdgcxPoweObrD
	gn+j9Bvp5WRoRTLG0yFznczKrLViB9Vr0lPXgw01D69A1qC0iVO09MbTNhZQfVPPbEmO5H
	GoVxBTo/mse3kRv6B2zNCnr0zTyPBp8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773307682; a=rsa-sha256;
	cv=none;
	b=6k8jzOKBQPJVQ89J9lzc+QXhVgUZ7VzxhWG3fNQN/mNJ6rcaR4V8TR7OD21X5r+A4CIlyj
	+0FNzsKln3I4bUiOmSmDxubZOcLQ/crIEutLHxmtnceuM3/C5E/Mm56HawknZFzl/awQBh
	WAe86nPLdiiNkOz35RpcQ3eu++Yjmno=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=utqP9oHb;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C56640657;
	Thu, 12 Mar 2026 09:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39321C4CEF7;
	Thu, 12 Mar 2026 09:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773307681;
	bh=t46q27OHEznktHpGJY4IwWs1xMeoaulAJuHSpd0ICrM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=utqP9oHbhs5h0axqgKUQ8EVhZspF/01+L8RMIchQwEJbwSxodZ2XK5RNV+Ulp3R/+
	 rWHvMGEpLW5I+uFjgj1PdJcktrR3LuNNO44t5jYTJ9D8Qi3hXwmHdkjbrco02TYY9B
	 4U2BWbL/RJKE6dGSDzyeLRl4MuMQkrrgXIFyPQiaPeSWD9NO8f0MW5V6mnlIChyrvv
	 06LXFI/j51NrNvMyWd9ZK3Ky14ZSKKnLCQd+APmh8zxV7K3LzO9R/zahIk2494fb7C
	 eLVfAtc54SEEIfR/+UCPZZF2WB+TPin5jA3RUxdYU1FaUZ/InK+Sda0NOzIGkksvzJ
	 b9XKaDeGVNIvQ==
Message-ID: <56e07b6a-dd33-46eb-9faf-0310169e22cc@kernel.org>
Date: Thu, 12 Mar 2026 10:27:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-6-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260311211315.450947-6-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E0F9140005
X-Stat-Signature: bw8jycg9ct31q8ghn4x1a7e6xjx5wbt9
X-Rspam-User: 
X-HE-Tag: 1773307682-165211
X-HE-Meta: U2FsdGVkX1+niRm6EIRB6ATGMkP6fNWzOpnZWrO6NwoUCKDbygWSRZuJGPa0Y4ZbcNUqG+kYSRoIExuOn607nfTW0igmH/9471mrKJc82HDLPwX1DbNJjmy9KhdFrUfrq/GAJYCcJ1O/Vkj9VN5pjvlaEt4lYgMTaxFgWAzAMnEgHavIqGrR0M6wewajXmFq3R5eRwNsbgvcQanpOfPdn6JdlURiER+GDPP0GaPWxoBiIsB4OdouSZ5glUKtTFdBxV+wtnQv2mmwgkxmFTwh661TDMNt0qEhhupVLN95pPXlx3eGuTKa2ed8AFgXZGIkqDa6OXqbJIljlGeqZnGICbrk7jY0x037Wx3aFylbQXvjrkAaRY6z6qKRtY6jtmf/8AaPGK7FA3uYooOpHhyJEy6XCvH/wdFABYZWIleTZqJA6nlNHVdi+xklvR/s5VzHA+iEkTnaOWvaVu9OBUsqkP5697JVH7SzO7qk54LmdDaOKMHijx3JekcKdlYXB/AElsV6ZAE+rFEBA+0HxVnvAGQ0X/+TT5kufGJL8UphFpqd2fBW6CYmnzYXJq58gUA4jPzyk/GrvZQIoR+KXHW0h7HjXr0dNNHo84if9O7z4DuSAwDMPz3Tn8zcVAzMBDGorYMs8Nj4pM0diPc0GAPinJkieVL+KiPOAlkgDpRKGshY+zCwnguX7fb+XNcu+4y6+WkVR8tgSmhCgLAkuJ2ONunYNddeFKzUL06uNlWvqPyeojcTq03jYndlKzzbYkD+ppMPmMcmZsKE9PXlD3IxNUe07OM6AfJtcDvOZB57YrSRQ75bpKCAd71KElvkLIfMcPOTy9e6mmES/7n7a0onU/1E5E9icPrzyEhT9LqIMU8U2HiPv24hI1nQ72v4zrBl7ugfiva1YLMkYTuNXqZl0F2Fh6KFn0whNIavXIB7I3Pc98t7tPFXBIvrl2fQxhMwbiFkRd6Xfvfq7QGFXI1
 ARnFp6xc
 tKEK3Xb9pH3x5LjTwS51A4Tf1uysI4Wer5O66co+1zuaXZ0Uj0zIwtwl6wvb5t8owC9uf2hUyErema6y66abm1d3IYot2QIjur5dla8tTUztOCWtchpwij5+0KWMkPueERwZZrWkBCoMci8vGCermEi92cOlR2lzXe2eiQZcdKZJZ/56zU/Avd98dvTxj4oxmhuoZBiWG3Aokzm0IpTXPuh/nSP7iBMZWLHk5/xr7qdynt0gtqiEmKK+wCrneJwgT+dQw9T1qwWbXrxxP0HKllvjLUMAUrdxD60B2xE58c677B/0jqwSC3dZqt/lmQevorEberfqgJRGR0FEMvSqIdbmzXEstGm/+sIwOv/E91bdd2uukDFO2hhnv6miciER9OT8DqWWCdDlanYNxg4UQ5BS92RzO+wKS14BXwSfjfk9+rGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 22:13, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing. Create collapse_single_pmd
> to increase code reuse and create an entry point to these two users.
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
> +		struct collapse_control *cc)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	bool triggered_wb = false;
> +	enum scan_result result;
> +	struct file *file;
> +	pgoff_t pgoff;
> +
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

Okay, we can get rid of this because collapse_single_pmd() will never
drop the lock, to retake it, returning with "mmap_locked == true".

If it dropped the lock, even if it relocked, it will always return with
the lock dropped and "mmap_locked == false".

The "if (!mmap_locked)" will properly set "*lock_dropped = true;".

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

