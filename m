Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F8BBFC5910
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC976B0089; Thu, 26 Feb 2026 04:41:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0EE6B008A; Thu, 26 Feb 2026 04:41:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3286B008C; Thu, 26 Feb 2026 04:41:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1833C6B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:41:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B90681A0A9C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:41:13 +0000 (UTC)
X-FDA: 84486114426.28.A1B6EEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D805B1A0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:41:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lSt1GlQ4;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772098872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuiBV7FId3KGiYTLS+sqjo+b6E0wvKqPGvvay3NAN+4=;
	b=GCz0wv+vr3AUOp33nLFVbwe/z2Nc0Fld/6I7kq/N052hsj4oa9OVDg4ZWlZ2XGsi71aVeN
	ZcW+7/X/ur8WoXbVDY0YdmlPETw5bIwgFQI8hLloMK6JIsWg7uYjiytAT/mYei+qao2MPb
	vsng/RLBKzjehNciNQ/ULAQ7vEwv/sA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lSt1GlQ4;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772098872; a=rsa-sha256;
	cv=none;
	b=pVHpJ/eux94kUNZVrlk/vqYaCzdrcbOEUwA542RnwBCYBtJWhhkwA+32pwehFQe6BNMStP
	236/jxZfyjXdwBAZzkAwxTDH3Sva2ihOEpvHKH2FRDH7hJWZMe5JFwceNS75Sols9KiU0A
	IdkGGfLvHcLu9vu5lSUGS8rP1iQ3loQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0307A43ACD;
	Thu, 26 Feb 2026 09:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC78C19422;
	Thu, 26 Feb 2026 09:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772098870;
	bh=Dc0s6Mi2e8Xn/gEVPXoLAr6L7NjfwDgvM+cJP9IDvXc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lSt1GlQ4liXpsZDHhaZWgURXXlZ5Z6t15x5uQx+s1UQxKmOZwdr8NSB1UiUpxi1Jc
	 jgcWAgPCNDQln879JmTM8atfTpBTbY7s83G0WUPi2RnABmOsHCS3874Uwdm/1Mmf9d
	 IvDptIkvfYcE8LozrUrIQjDsjN+wXOcepFZIyBw0dFHR6KS1WUe0/h4RFW2bW4U+0u
	 mo4ROTN02Huy4sxYYD0PZMPJM3gHNv9N7VJcCjUpzO5EaDOrq4tNoU1eBgno94GgWc
	 c3txEr4HGsOSFyXj+VnW6kEvjRx4Smd8cgGoqDNvzZwZ8zTCdDSLPViAHkalqJhIp3
	 2SZK+tjq29KXw==
Message-ID: <81ff9caa-50f2-4951-8d82-2c8dcdf3db91@kernel.org>
Date: Thu, 26 Feb 2026 10:40:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 5/5] mm/khugepaged: unify khugepaged and
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
References: <20260226012929.169479-1-npache@redhat.com>
 <20260226012929.169479-6-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226012929.169479-6-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: D805B1A0002
X-Stat-Signature: czij5gujek6omu3y1t4ic3d61w8gyj3x
X-HE-Tag: 1772098871-311332
X-HE-Meta: U2FsdGVkX18Di20W1WIQxTNwq56uc9ysne33ngzTm77tK1zoA91gVI1VupIHGCXh4nS03ceAj4k8VJwVOxeqwv+uAgEdwfUDdzFaIEZSNDN5fbxzdPj3fcMN4ZmZGZZTLX0veeFON7fqhlI68wnwsmNnID39odcaHk6slFp2mtXw6o4W9bb16ANdlBl9kYue2tJIUNZ08fVpihXphMu94A0RqU7D7QMxwlwtxF2E597VyOo9PRL5tj4JY5d6GU4T6R1aQAZ8bb4CvwNn4kbMSLto/QbH7dtxv3Qgoek7ncNsSytOlpjI+mRhLcf5bM7u6Bm+uz2BEKFRXd+/cNSdrorYcg6hxsy2BvkMCNEtkL8ot1YIdoxZIJMq5x2M4s7OgIKttXl8ataQt6fmVUjFhETxvUel2b6xzXpqwvI5TNDtxhQMJIw9or9jbPqEmQ5YJb1aZb5Nr0Lqi5EzRhZll0pM/1Mj1Mqx9ZSEWc3VBLcDGaoq9QOdCDoEjpxeobGPohsBAW8uUx8Ae80aUj4ppGU5DI8dAPZr7T9KF+2zZTqo57Afa34yE6rNvvCSweKLe2Xu2YD95QUopsX2xa9uLoQR5ISUv3VLU+pFgyHN2YxcvpaRe+G45+Bq3CLehdR7LCC1yq8V2jESyQsx5PYV9qQ8aRhyVa+sDRQmTMvf7zQQwlJsOqxkMLApZmgGkNbU9s72VvWVtiGXbFcEf7/kcJDZX5Uz3Oj+m/8uCc407UovcZto+RE0iSqgnURxawIwNVJHYuspk53KDLlfbmccQ59yzKHyLpqMeQnCz0U8u1PjTpeeeJ0+SZnkZ3scJzdNuWQttxyCHtK++SyHkB11KdyBzo/f5vSUbv2Vc7ME2kZLNsKcFSSUwn0GnlPocirGpwxIYW9hM0rdCom7AKeStgLh5dG/0ONL6vntBJKp8zICanlpxw5XA1ybFV6TXMWZSTt9Dvu2xv6rQZK8LMR
 UN+GWhIH
 AowJQENv66eKOSk2ZsypjDWHE2G/QEUISSNJQ8fTgfQgMqBc4kGARMlyh0BoaPfZWCTo9g0xtXNygfdjXFspW4G8W+6Sr7qrYdjKwpjky/7AmedUB0JuGWnAnhaoJDgvpNO5grkZCNWvakZXqzPxSTMrRCky0f9EoW4S8NQw3nybZhdJSmQdPUYqKygkQDoMs7qxN5a1VHWm3q4k4FNXNIGcx7iPCcbrCEge2d4CD6fJvvMLMAqlx5AYhMtrLxSgPwTWtnrUM6Oa+5YQMTx3qWMrrapDp4FccvypzGt6HgyOr3Ggu1Tq5KAyqrh2RBDmAf/xyd+eZiEMO+dGhPop6dQ8RQMh/2jqz87Gj429rWCc7LJA3QmUVJwCxPbDJuIy7cI3W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 02:29, Nico Pache wrote:
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

Probably best to drop Lorenzo's RB after bigger changes.

> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 128 ++++++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 59 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 64086488ca01..0058970d4579 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2417,6 +2417,70 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
>  	return result;
>  }
>  
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> + * the results.
> + */
> +static enum scan_result collapse_single_pmd(unsigned long addr,
> +		struct vm_area_struct *vma, bool *mmap_locked,
> +		unsigned int *cur_progress, struct collapse_control *cc)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	bool triggered_wb = false;
> +	enum scan_result result;
> +	struct file *file;
> +	pgoff_t pgoff;
> +
> +	if (vma_is_anonymous(vma)) {
> +		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cur_progress, cc);
> +		goto end;
> +	}
> +
> +	file = get_file(vma->vm_file);
> +	pgoff = linear_page_index(vma, addr);
> +
> +	mmap_read_unlock(mm);
> +	*mmap_locked = false;
> +retry:
> +	result = collapse_scan_file(mm, addr, file, pgoff, cur_progress, cc);
> +
> +	/*
> +	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
> +	 * then retry the collapse one time.
> +	 */
> +	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> +	    triggered_wb && mapping_can_writeback(file->f_mapping)) {

!triggered_wb, right?


> +		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +
> +		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> +		triggered_wb = true;
> +		goto retry;
> +	}
> +	fput(file);
> +
> +	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> +		goto end;
> +
> +	mmap_read_lock(mm);
> +	*mmap_locked = true;

On all paths below, you set "*mmap_locked = false". Why even bother about setting the variable?

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

This might all read nicer without the goto and without the early return.

/* If we have a THP in the pagecache, try to retract the pagetable. */
if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
	mmap_read_lock(mm);
	if (collapse_test_exit_or_disable(mm))
		result = SCAN_ANY_PROCESS;
	else
		result = try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
	if (result == SCAN_PMD_MAPPED)
		result = SCAN_SUCCEED
	}
	mmap_read_unlock(mm);
}

> +
> +end:
> +	if (cc->is_khugepaged && result == SCAN_SUCCEED)
> +		++khugepaged_pages_collapsed;
> +	return result;
> +}
> +
>  static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
> @@ -2489,36 +2553,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
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
> -					khugepaged_scan.address, file, pgoff,
> -					&cur_progress, cc);
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
> -					khugepaged_scan.address, &mmap_locked,
> -					&cur_progress, cc);
> -			}
> -
> -			if (*result == SCAN_SUCCEED)
> -				++khugepaged_pages_collapsed;
>  
> +			*result = collapse_single_pmd(khugepaged_scan.address,
> +						      vma, &mmap_locked, &cur_progress, cc);
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
>  			progress += cur_progress;
> @@ -2819,13 +2856,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>  		enum scan_result result = SCAN_FAIL;
> -		bool triggered_wb = false;
>  
> -retry:
>  		if (!mmap_locked) {
>  			cond_resched();
>  			mmap_read_lock(mm);
>  			mmap_locked = true;
> +			*lock_dropped = true;

Hm, is this change here required at all? Shouldn't we instead need to know from
collapse_single_pmd() whether it dropped the lock?


-- 
Cheers,

David

