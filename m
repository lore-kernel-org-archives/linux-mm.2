Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED16EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 20:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07726B0088; Thu, 12 Feb 2026 15:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB54D6B0089; Thu, 12 Feb 2026 15:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C556B008A; Thu, 12 Feb 2026 15:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4C766B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:03:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 650EBC1749
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:03:28 +0000 (UTC)
X-FDA: 84436879296.02.41F1228
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B72901C000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:03:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FXQETFg5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770926606; a=rsa-sha256;
	cv=none;
	b=EBRe6n1S3Y/IeGdTKoNrWpZUmuLxPuzP+rs38qdjk4cHFvfxjWyPuENkRF+lDxDjYNMOZU
	pxYQJN+7sF4zvBRGjBCamhgmHhR9nD6KELxAZ84SlheDWJbwLw5AfllgX09xYyzquMJSAE
	7P5jJgk9fNp2/rVTHPqA65eAxaBfWAg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FXQETFg5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770926606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZjz39G3N9P7EnA30YUTdX1EQIjyss8o3IDGsuH9dZg=;
	b=7lAo00DumEMVg0zxns6b05a5JcSz8Ps4lqGmNsKkqpKaaHna+2yorBsFG8r7+ExcksVR95
	49fD2+6TWLYB5+w5e0+63Qoh/mfwg115205JPI8cwCxlfs2YixELkNVFgO//PVkX2pklWO
	05r868EJSOHuP1uxg8XSTb90P6Vv2b0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E40443762;
	Thu, 12 Feb 2026 20:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC35C19424;
	Thu, 12 Feb 2026 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770926605;
	bh=I2APJnv08E/BN3W/8naXtyyT6xVyNn/i9atrCbqm9QM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FXQETFg5deUjKct5d+accqItVeDue6agLBDSL9AawqqbQtXLPzDbarKhV7tVn3HYD
	 2NT1XCHrybkEGkvVHirRk1jckT+YI6ORQMt/hA+dQT+gU1xZ+QUynBUJtvJmXjB34O
	 p5R1Qrp3SQsJeN5b6ZYNApE04tRpugqMWDOP1rxhij5+N0PPxdPTbTWCZBf4+ftdvl
	 JnNq0LW9W5/cejUjYkKn1Iw7gsmZxLf58d5jYC+C5EFlowarAE41p1r8KK4WoqOCjc
	 fQa6XqzTw5A3ZRY78o1EVuYHmHtZFdRkbyVndUG1nVAv1kN9V6u0Iq4pKqyrLjA4zD
	 S9czODqqNxL0A==
Message-ID: <164bfaf0-5e8a-4bd2-a04c-93d61856a941@kernel.org>
Date: Thu, 12 Feb 2026 21:03:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and
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
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212022512.19076-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260212022512.19076-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B72901C000D
X-Stat-Signature: ngxi17rjjfrcsk8nn8k4immy5tmyozdu
X-HE-Tag: 1770926606-321651
X-HE-Meta: U2FsdGVkX19wZxC33DAoYjjlTnNLcmFMHhoLptSr3oxNRLA1sCEMvvxmG50/RScnPWIYidMv5njOp4uNt0/InbQnceniQVKDH7hGe0Xqk/9DSNVibtp2RdTfASE38p0ciajOZYQbGYd0GmN5RU09fxghlbT5iyK+qdJ3F6ZwzmisT0g8+toAeDbFZrxShi/uz3/mzHzULcsMjdROeGcTZcr3JlhTSFtpQ57JMuLjKChJXf/VM2JywT18QsyK+PjvNh3Y7bL+VO4j8u4INuH5S80GlpJQYNfgDgeGksFYVS0rKoul+cskVHogVQbOmBJTWIAwMMIw8agctIqSJ5wC7yV/lHbyF34aXax09zURvPuQUSFYPCR+p8GZi/e5+Z6egI4JIsR2tCThcLbMHE0e/lf7f3/+Rupb9bALuhSPXF3km9KVw0mFASNA7huFyUSgPmVOhTQuQSNkGX+n2WOR83dB/XdJL/jj7gIwY3gy4IiIMLW2JIhrelYoK/ypyWJyeJH/PRY8CPQ2yrZvtsQisk5nYA7pzev7ocC7s6GjxSLmLHZ0ocqezBs/z4QlBy9GnZZ4oKDTytNUIbv/+eyHcTtQfv7IlVtt0EtK8msXgLZb0pCZFbg8vMvoRenGNbOFdHfonqYS14ZfeNLcKoiwPTOqTuPn1IyzGG3sU7iJg+myD16G7rDwtgE6DLdmoSdLtdvuOxX3vBRkzXk52Njuzdp3x1cbh4wv/DmV9RHyH6frh84J/fgz8C+cbbeANdssLj+EClCxKru5qr8hjfhSXj5WantvouPXvtMcyr3g3+NCGC+oYYi9hrGp2H0Hx6o5njAlvEJrxPtM2KTDj5LWa9d3h8jVI73zQ0UHx+9oqWTSrrspXOFJJmpWN7RBJzbg5jssFeof86st5vEmwHrr1MU5zGS2yDVboL03UBcu14pvKFt6d7vc8KBXZbsCJY7PJY6bk21OJwSUB06dxG3
 IxKVA540
 qfWmmnHo84pUKR4O2w4+eYm4VEpIMMEpFomWd7QlyiTYL3hs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 03:25, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing.
> 
> Create collapse_single_pmd to increase code reuse and create an entry
> point to these two users.
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
> We also guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>   mm/khugepaged.c | 121 ++++++++++++++++++++++++++----------------------
>   1 file changed, 66 insertions(+), 55 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fa41480f6948..0839a781bedd 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2395,6 +2395,62 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
>   	return result;
>   }
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
> +	result = collapse_scan_file(mm, addr, file, pgoff, cc);
> +
> +	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> +	    mapping_can_writeback(file->f_mapping)) {
> +		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +
> +		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> +	}
> +	fput(file);
> +
> +	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> +		goto end;
> +
> +	mmap_read_lock(mm);
> +	*mmap_locked = true;
> +	if (collapse_test_exit_or_disable(mm)) {
> +		mmap_read_unlock(mm);
> +		*mmap_locked = false;
> +		return SCAN_ANY_PROCESS;
> +	}
> +	result = try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
> +	if (result == SCAN_PMD_MAPPED)
> +		result = SCAN_SUCCEED;
> +	mmap_read_unlock(mm);
> +	*mmap_locked = false;
> +
> +end:
> +	if (cc->is_khugepaged && result == SCAN_SUCCEED)
> +		++khugepaged_pages_collapsed;
> +	return result;
> +}
> +
>   static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
>   					    struct collapse_control *cc)
>   	__releases(&khugepaged_mm_lock)
> @@ -2466,34 +2522,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
>   			VM_BUG_ON(khugepaged_scan.address < hstart ||
>   				  khugepaged_scan.address + HPAGE_PMD_SIZE >
>   				  hend);
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
>   			/* move to next address */
>   			khugepaged_scan.address += HPAGE_PMD_SIZE;
>   			progress += HPAGE_PMD_NR;
> @@ -2799,6 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			cond_resched();
>   			mmap_read_lock(mm);
>   			mmap_locked = true;
> +			*lock_dropped = true;
>   			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>   							 cc);
>   			if (result  != SCAN_SUCCEED) {
> @@ -2809,46 +2841,25 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>   		}
>   		mmap_assert_locked(mm);
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
>   		if (!mmap_locked)
>   			*lock_dropped = true;
>   
> -handle_result:
> +		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> +			triggered_wb = true;
> +			goto retry;
> +		}

Having triggered_wb set where writeback is not actually triggered is 
suboptimal.

And you can tell that by realizing that you would now retry once even 
thought the mapping does not support writeback ( 
mapping_can_writeback(file->f_mapping)) and no writeback actually happened.

Further, we would also try to call filemap_write_and_wait_range() now 
twice instead of only during the first round.

-- 
Cheers,

David

