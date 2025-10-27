Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EBBBCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583FF80025; Mon, 27 Oct 2025 05:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5348A8000A; Mon, 27 Oct 2025 05:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422C280025; Mon, 27 Oct 2025 05:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE2E8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:01:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CBA8312A78B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:01:06 +0000 (UTC)
X-FDA: 84043299732.07.08C20EA
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id C56C9180007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:01:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R2MI8qFP;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761555665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZIxJuwgOmBP+ZkdSSAjjhDddv46eR2/PMPkqFr0INA=;
	b=W8y9sXzzL3TKvcAEODJQ0VNCeVQn0ZlsL/8Bd44+SBu8qaQFHRNVr/uqyK9LUWL0a3DYGa
	D/Jg6oo4+sfsiUyKnxRNii48EZqMDemJ6sJ81Tw9/exQaAxMK8VcSbXNscR6lgHy8V3RaZ
	qyCGbvKXoa51epiYi9LOUCcQtZdFmv4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R2MI8qFP;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761555665; a=rsa-sha256;
	cv=none;
	b=4SF3prFhGAAFyFzjS7COTjYgsVyBRnX15V1V2yScXc1f8PQMwVYRp2TcXWWQd4h0pBCaeC
	uE/nTRBU8EZ45dcUbCofGr8PSu1FspgEbTsCiCuSjbqTRsRGfnIyRvVQYA5SKHRS/6LAxo
	ffEM6t8ZXU2THi/Yb6jqbhU9FjLMD+U=
Message-ID: <3aca400f-2fbf-4249-89bc-d683a4e0618d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761555662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZIxJuwgOmBP+ZkdSSAjjhDddv46eR2/PMPkqFr0INA=;
	b=R2MI8qFPQ6pU7XLsjr2EjSK0mrr2oa8WAxDi7OPjOOAdBPMpW0J9EDxQakGCniq7rcF56/
	bbPsAP4TAva0QsNYON1Rg/bEHR36dhrNLVgkH4N11ECbAs79UWe51AIC9WDoPqIJyvwaIn
	Lg3+8rp3TWZo+4zu0GmV7LT5N4sf1w0=
Date: Mon, 27 Oct 2025 17:00:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v12 mm-new 02/15] introduce collapse_single_pmd to unify
 khugepaged and madvise_collapse
To: Nico Pache <npache@redhat.com>
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com,
 usamaarif642@gmail.com, sunnanyong@huawei.com, linux-kernel@vger.kernel.org,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 linux-doc@vger.kernel.org, yang@os.amperecomputing.com, kas@kernel.org,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 vbabka@suse.cz, rppt@kernel.org, jannh@google.com, pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-3-npache@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251022183717.70829-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C56C9180007
X-Stat-Signature: zgt6hn88fgj9apxsir3czcxr95s78gmm
X-Rspam-User: 
X-HE-Tag: 1761555664-780890
X-HE-Meta: U2FsdGVkX19fkNXCtlnjviN6zjBe0UTSrHSloW+TkBXgo33i3DaZnRs1OeYUUrA1NtCfAjl+nCcpj/V1ffIyyXJgP0+Mrt9vbOjsoTofPo/Dyrac3cUjtOQV9XQFP3kEfSta0DWDtuJYiGkDpZMmIIkGFEnkF0HS+/FqvQO3rPkVuhnDXQbm2H+hMT8T5ztPVhah+/97XgxCD5GTX46YAIteZrhnVsqLz24krth2+nXT87T05aoJn03txntzEPzn0bFGE3JROn/fUg5KP7PQJBBa+ecRyYskvIVzOnJ7x8IVyGdtoy7FEaP5nK5XQHcZUks+VNeii4j7XFud7giXouhd+it1l1QYwtuZXgjEdxjB9rLG32R0aVwwmU6MtsOqIomaOOT8p38o9E1RJK/0b+lRYHGfR5HOnjMJIuRSYrm+aLBpxP44od1gKXCSlEKkaMTpafJb9xt29q5n1BrJTkieqZ6gprNH17A9k/qcVe1/oZ/RXaoxY/xZeW3h9ZbCaT0j6FaAQg3r+VQreWeF9Yoarg3tZWgii+7VVXzybedcmpFEZojoxlaafnEUZmzThianM8eLxEcxoFtZH9QaRjblRp6qpQfpRWw8mXEGe74Xa3cKVIs6hfQF2sNffdwL3KlNLhR5mwmlxHMWK0D+34Gn4mTRgAv+PyNta5HkKsKOjrx3tdejxrf7+jPGtffBG3UTDlrWjMHD3XXYiCip81/5aKZ/jGy7xZEsXBO2unGc92jPvwllmVvJ0TTYrvdc7vvF+KKtkfKJ4Umi6ta080B+OswvX3AtWnW6V5jJxb+a4EFuqjaeHymzrdQ7UZwjgSYALUo/7Q8wCqdStY8z4PbWS0qzbABQh6AuXkhCZzLGWYEPOK3fINQWO+HAY+mQnG+yvpP31Zc+TUyPlGfNkj+5eCcp0mvRqROrutBMPaaAA+/tnhYj9dUBxuj3V0ejNV/UildGhxc4nZo7MCu
 zUlg7NvH
 hUm4JUxtTUhstvpwjJliXAgMqjEFLVPsctzdGvUqUW4ufDZ8mjebQOvqC1fakv6hvuSbo1ui0dHkYj8GIr2nUeUgN7WRmmNkAhrZz40P7ryD+vw5aLf4dJvPAfFTiUwVer/XmSVk+0+BUUmx3q8fA/YswYeAOHiX3ZylO/X6Tk8VQ8YqGpTa8Ug3quV8uyPk/lk02PNf1yCFWaSZBBwCYTIvZNFTsVDce406pJc6Z050AEHySkt0zcsYV7w0ZNUvhhpnNezqi1Xo9KPVH2X8MQAFZt8yg3AyKiWD5rxFpO7gfHWv321+zGDA7AWz7Hh6q5ocHomqqFPCMfeCiV5FS6DPFzBUS/C+t6LgtXfbw7H4lNlWAaLi0cOqcBtjXQhNuxRWmcgcOaQTxF/JnRW3AD8D2WQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/23 02:37, Nico Pache wrote:
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
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Nice cleanup! LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/khugepaged.c | 97 ++++++++++++++++++++++++++-----------------------
>   1 file changed, 52 insertions(+), 45 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6c4abc7f45cf..36e31d99e507 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2370,6 +2370,53 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>   	return result;
>   }
>   
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> + * the results.
> + */
> +static int collapse_single_pmd(unsigned long addr,
> +		struct vm_area_struct *vma, bool *mmap_locked,
> +		struct collapse_control *cc)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	int result;
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
> +	result = collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
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
>   static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>   					    struct collapse_control *cc)
>   	__releases(&khugepaged_mm_lock)
> @@ -2440,34 +2487,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
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
> -					*result = collapse_pte_mapped_thp(mm,
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
> @@ -2781,34 +2803,19 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   		mmap_assert_locked(mm);
>   		memset(cc->node_load, 0, sizeof(cc->node_load));
>   		nodes_clear(cc->alloc_nmask);
> -		if (!vma_is_anonymous(vma)) {
> -			struct file *file = get_file(vma->vm_file);
> -			pgoff_t pgoff = linear_page_index(vma, addr);
>   
> -			mmap_read_unlock(mm);
> -			mmap_locked = false;
> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
> -			fput(file);
> -		} else {
> -			result = collapse_scan_pmd(mm, vma, addr,
> -						   &mmap_locked, cc);
> -		}
> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> +
>   		if (!mmap_locked)
>   			*lock_dropped = true;
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
> -			result = collapse_pte_mapped_thp(mm, addr, true);
> -			mmap_read_unlock(mm);
> -			goto handle_result;
>   		/* Whitelisted set of results where continuing OK */
> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>   		case SCAN_PMD_NULL:
>   		case SCAN_PTE_NON_PRESENT:
>   		case SCAN_PTE_UFFD_WP:


