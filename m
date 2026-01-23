Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB93D6CFC6
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 05:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF196B03BF; Fri, 23 Jan 2026 00:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7CF46B03C0; Fri, 23 Jan 2026 00:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E9F6B03C1; Fri, 23 Jan 2026 00:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86E996B03BF
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:07:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EE15B7497
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:07:52 +0000 (UTC)
X-FDA: 84362046384.10.6E439BB
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3D654180004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:07:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pdgnYyyX;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769144870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFRsUB2fiki1rnBoFdqWSSWTb0H7HGcu8eMrImuExro=;
	b=L14/b/YTeknrFQad3bAFWr0M3si7uHnG7hDOza0NC4XfJfUiDtJ4KBxZeuahzQQ/5PNGJg
	RzWYLss7lWAFSyq3CsNj1Cy94534wn96yEpF0l7X1+wKesRJzaq1rVOOrPewrJU8mZmqno
	stfXbYeTuWCCgMESqB9YkRq/xVQ7lAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769144870; a=rsa-sha256;
	cv=none;
	b=eXUr2iob6kqGli3+408xKXutJaQq1Zn9gwHykFEYxrYA4GLWtlcL9gXHjVWUbdAQmO0m47
	J9HtDsm3DeoLMjpheN/jsBJTYXyu+WUxl5i+XPhXcCuq/+EYigvrII9IqaCT+geBqCoX7Z
	AsqriuvmwLfBx/nWezEb/sf5yaiw3jU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pdgnYyyX;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769144867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFRsUB2fiki1rnBoFdqWSSWTb0H7HGcu8eMrImuExro=;
	b=pdgnYyyX9QKwooSTwRL3gPwN0gQ6ctxRiNO92M2DPTle3a4TI9mETzpWXx0W/pUXyMNP8p
	2tROMYwNQQa9BT2Xzq7S/r/SJtavAE/SZu358cQUx1El2Vxrjlt3RGLYyAP54+9awzmb/b
	+F2Rv1n+PCL/fv20UtoAoh6IOcSqREY=
Date: Fri, 23 Jan 2026 13:07:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
Content-Language: en-US
To: Nico Pache <npache@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
 hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, zokeefe@google.com, rientjes@google.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-4-npache@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260122192841.128719-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3D654180004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rm166dk1rbcbd5qiabr5qjz4zf6by8n5
X-HE-Tag: 1769144870-322824
X-HE-Meta: U2FsdGVkX1/R7KbkS+YXgmdw83t14h63oDgJKK4Nm4vpEXQC/aBndiRm2Je8vDKykVF8AR01TsfbsUQ73rCdeXRM6htvZ/PEX5tjJOXaJbcGwP64oENpwRBjWPPlPPbZoeA4o678wKfqpC0GCqcguS0fr0jIjkQzcT2Jrf/iSEcV5pwIqbF+TfFqXpgqdsTdLE+2VeiOPZ/2T7gLhmf6WcUj7pKfKOw0IVbXbdeYPtePDBAQE9NU3vo3PSEShkGevaLB2bxk1hRfmAGtEkfsIWVFD1haZQCDHMeDrDMISJcZ6C7OoN1wLe1vXlkrYvstjo0B6BEHNmgR+IjSTy2COFwiu/rNs43lxzYDYOtVHJ/0ZgVjY5QyS3MhXH2/bS7IxvvJyLdol19OYGwycLBMGlLFb8KvVdcJRJ16YJaS9e4zbVDBkQA3/V9il8dCuRVycz4BXSvBa5IjrkQOeZvjkpB3VBhfQ/JGzr4WuFCwRLUAl+fgz3uyYmKpUjXll8JiBIuZG1FeUOABDQ9RHho6RfqnpU+aMc81SzB3VhjAQTH8dwk+QWnbdmIWhwjonL5Mf+bFIDoU8Xv4xXznCDj0wi2YYmlMIvSFvJyVy+In5Pr9jYvPK10dP3twF5/7DS/h0Bca8Vwhv1e4eucpaeKhPCZXEm5hU6lyvq9aYdmWeTl2v5Kjypc85hcjIEDVagJ7tBqs/KJ14rY7+X/wa3TxjwWgL+btB8KuwHftAeSYKYS/IldI23Yyz7lg8SEencZbLH5v9s4np348xl9K8iXIpiGwwFdPv/zUYFn9rHCh5uNQYilMVYAuAkI4nt4N55KM88VNIm/+HIbJFI+hMOHjd0JTQqWQTdxYDDRTGZBarxGOsLwJKsUkWaff5cEeiWT6P1twFpAfeoLRYavzr0wAu6yQUVX2P5laMU2AwK0jE+3efi6+8yjaKoemSm66PqWM+m+wgoMNQmKCBnx/4ww
 Oz2+d9ho
 gfp1nbnKwlj0kV4MuSOeBYa3gmrp+DMY7rVTdYnTCtoPp50/G4mYGRkrFe0XHqbFIJJd9L0fjouB83nEFSwoyy9ZjN+0lyDPHTzkQZ0XnRjTZvt6jHtB4DermgarH9Hqp73UDn0sNlpEzIdnnGUGsbXtqtXQv37kL5HGhww2Koro1tglOuESy/Sy00gOPAvK65RQFUk5cAflHqsfAr/G/QN2ZW9RajKlKvrReCPUSFDuAV5j24DH5behO9z1MfWnEI443RQEYs/CAb2glyTYL5t/4gf2Y3p3QfBhBS4ZO2qdVhs6eOB2ApgWTmZPW5GzvintgXrJsQYFfL0aX5f/JZioo6YjY6QDNB9h7jB7/o1T12te5IxGP2Of/pXEzDLuSO7+rOqQ9fGKqXSkEE/b7252OlTRItYNfsbF4BEA+6d+MKmzT+9lCK1hJ/eZ1DUUJ26wXbi9fJqFeb/23524AhBSPzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/23 03:28, Nico Pache wrote:
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
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

I think this patch introduces some functional changes compared to previous
version[1] ...

Maybe we should drop the r-b tags and let folks take another look?

There might be an issue with the vma access in madvise_collapse(). See 
below:

[1] 
https://lore.kernel.org/linux-mm/20251201174627.23295-3-npache@redhat.com/

>   mm/khugepaged.c | 106 +++++++++++++++++++++++++++---------------------
>   1 file changed, 60 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fefcbdca4510..59e5a5588d85 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2394,6 +2394,54 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
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
> @@ -2466,34 +2514,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
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
> @@ -2799,6 +2822,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			cond_resched();
>   			mmap_read_lock(mm);
>   			mmap_locked = true;
> +			*lock_dropped = true;
>   			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>   							 cc);
>   			if (result  != SCAN_SUCCEED) {
> @@ -2809,17 +2833,17 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>   		}
>   		mmap_assert_locked(mm);
> -		if (!vma_is_anonymous(vma)) {
> -			struct file *file = get_file(vma->vm_file);
> -			pgoff_t pgoff = linear_page_index(vma, addr);
>   
> -			mmap_read_unlock(mm);
> -			mmap_locked = false;
> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> +
> +		if (!mmap_locked)
>   			*lock_dropped = true;
> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>   
> -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> -			    mapping_can_writeback(file->f_mapping)) {
> +		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> +			struct file *file = get_file(vma->vm_file);
> +			pgoff_t pgoff = linear_page_index(vma, addr);


After collapse_single_pmd() returns, mmap_lock might have been released. 
Between
that unlock and here, another thread could unmap/remap the VMA, making 
the vma
pointer stale when we access vma->vm_file?

Would it be safer to get the file reference before calling 
collapse_single_pmd()?
Or we need to revalidate the VMA after getting the lock back?


Thanks,
Lance

> +
> +			if (mapping_can_writeback(file->f_mapping)) {
>   				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>   				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>   
> @@ -2829,26 +2853,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   				goto retry;
>   			}
>   			fput(file);
> -		} else {
> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
>   		}
> -		if (!mmap_locked)
> -			*lock_dropped = true;
>   
> -handle_result:
>   		switch (result) {
>   		case SCAN_SUCCEED:
>   		case SCAN_PMD_MAPPED:
>   			++thps;
>   			break;
> -		case SCAN_PTE_MAPPED_HUGEPAGE:
> -			BUG_ON(mmap_locked);
> -			mmap_read_lock(mm);
> -			result = try_collapse_pte_mapped_thp(mm, addr, true);
> -			mmap_read_unlock(mm);
> -			goto handle_result;
>   		/* Whitelisted set of results where continuing OK */
>   		case SCAN_NO_PTE_TABLE:
> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>   		case SCAN_PTE_NON_PRESENT:
>   		case SCAN_PTE_UFFD_WP:
>   		case SCAN_LACK_REFERENCED_PAGE:


