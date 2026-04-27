Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44F2FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CB26B0092; Mon, 27 Apr 2026 16:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDAA6B0093; Mon, 27 Apr 2026 16:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D38C6B0095; Mon, 27 Apr 2026 16:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A61C6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:13:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7261120175
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:13:51 +0000 (UTC)
X-FDA: 84705436662.22.0E2EA32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 034D980009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:13:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cyos5hQ7;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777320830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nVPulLLHBOmYP4xyFRWKW8trAsWAjAkOu9N85tk5Mc=;
	b=L8WBkRVYCE04aeLS6kFPEKs2ft9UrOyHslqkNfhT7nz2vsv+GcUSUaU6cVp6RYX7gU1tcy
	qTpD0B/uW5d8xpwoax5ktc6RO4G1BW7DBiJpvvPXRztH9QGQT3joIkWRpZP1hycj8FnDjg
	31Tl/Pl0u/iwTcmCYluN241xagAQ9N4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777320830; a=rsa-sha256;
	cv=none;
	b=wnTF2ukT7GI83wcf6QjLxAbqM+8wPtyzZJFBI8SCfBos9ut8wOWtP6Q6fi34EYyrunsjtv
	9bLeJc+ADFjbNFWYqwZzRd/EPMykaT6NabZhdIJYbZWm6AUpnOdAOE0rM4yI4G53ELJFZ4
	ReaWzRCYyIpbaC8tLpVTAtGqdKHKcVg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cyos5hQ7;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E89B143236;
	Mon, 27 Apr 2026 20:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5433AC19425;
	Mon, 27 Apr 2026 20:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777320828;
	bh=xRwli7GW6thWpU6EobkQOMk6t9ZJU2wEmi/d4jlIFl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cyos5hQ7hZFe9Z2mkBILoxF+VUCYkf2nLEB1NHVkFWDBTNAcK5xef1Iq/xLiKSXIO
	 jLfo6+LpHwn3NqCk316tOl/kynQgFx/CqR4oEeviuRq/+ITyiBAgj9FqmFJ6rA3saw
	 movh6YS789KqwkB/L5JqwzGF9NRcBMHnEXfJDzVsTUivXWqcXRHvLB+27ZUdQcrSNC
	 e0EGwegRgyTOcPyEkyQBTQ9R0RK7r4yMRgH+UrY117rVaHYMhKPCERBrB0bVxPnRTr
	 oICm0dq4m/O7XjgBLSBZGor4R0hD17ZMrfvyxfoU8nvOjvICk2b0UBbZf5mC3vPStQ
	 ItnxEIRqHHo7Q==
Message-ID: <6025c087-378b-4754-b1f2-3c5448b49d6c@kernel.org>
Date: Mon, 27 Apr 2026 22:13:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v16 05/13] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260419185750.260784-1-npache@redhat.com>
 <20260419185750.260784-6-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260419185750.260784-6-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 034D980009
X-Stat-Signature: rntecoyg9gdw5zq3xcm6bec7qaxpxnnh
X-Rspam-User: 
X-HE-Tag: 1777320829-890420
X-HE-Meta: U2FsdGVkX1+2or3qlcBZke9KFgR3nuTfaE++vAglekPnUSBlteFFnpoY2VdQSkODWlPEV+zMgrQjjBmeDYa+H318OYUm6ES0ilx/V1ZvPeCNtgtfHjuHYc2xh75UMm8INmj0Z2YZ16msCyPu+dzj7MsIBEZ8ZSWEQF+2K9GoNl0tJ0ncQlg4eIALUb4moBcARCKEorksHYAXjUK6ndlX+J/34eq8nZ6JR1aV/uaHvLv0oCqX0aGjmRgk7rzXYRTtMHbcOHYu87tGJYE4KF7vpdRo63Ok+4dLXgJXylm27AzQwmuIsOU1Dui/wv5ctkuxcamk9whnkQIWTz3ebjqfs0siuwT/2YRpfUnnGK3ODGzKCcoH4O5YvRes/f1RKS036d8hEpyDUJfcXQDOkCkQHnNqJZ5Y2ev21pRAZouDVP+OlcbtU6x3TQD7hWpi+YMB58zPU5ysxJ38FXEoCVYvpL5ft4RzUfX5LkyFGM2DWfpxcEjk2K5UrNeE1fqc+9Frn2iopXl3ByR7q4RP/wJIEGjTV3rWz/FMFBR7wmpqVv95oDXBfe5lx+3vMwVo7vW1tytUMZiUqS82iOaO6X0zN4TlcWdchZ+RlxER2Nm6QkLpIJiYwR9mc4PaaNielRMbCGZMvpdlMDO2k5FgEuhOhmBKDrVN+Jclru66UU0VZbCd206IW1viF6H8TpREgn1o8wnarlpWIS5BcppIMQ0DSrNtd72xRdQrMvUJdmUAna37j9HLQVL3RY6fBnN2Xt1egaJwWeeniJnBcWc4QSKNaEK72BQIXExf+dtZVnMRSjEE25yCmuG76K3PCO/ZLCEJpRKZzuNWjwpEZbLm+M7brQCESe2zf8sKHInOsyfvP1khV5p/MUKZOFUFnnn1Om5sNOs8/HbnRz+WjLQTooCSbRjiXcteDrjww6uOe5kQLuUoNl4AFLYK+01Q7oZ0i6quAf8PBUTeCLCKM1/qxtu
 Qh0VshVM
 ynK7d0iLvFEK+59JLUj6bUAUygNDIxNVgPmkXEjaEbjeosc0zSgvbdzFx7w6qvLH9BiBtTHENt9qggn7WiAKrJHEGnXarAehs9PVed2DyZ1kDSu2ABltAZt8IjXBrRJnw3rsgv1BUZnVpk/+kgUD2Zpt/XnejPhjsMTIRtRjBYGViIKRO3gtvsNMjMeLZz7qQD617W4fWcLCCsZcYKhdTUQwGySTCkGhz0pRsd9UzPpXCBMYauc2hFkNgtSmVlcQE6OaT46u7ziGhg24jWGxa3UM+i6x9uF07Sz0pOJpyT1giM2p/oehyq8Nf4YYpbPucWl1Qc4F4Lz9YdIQi9qobAphgOuXgEUnorQP+FKHUl2/lfk/GRPSEQztePr2fwqxPNeWY6PjmasAtCwpCL8yiVfM+Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/19/26 20:57, Nico Pache wrote:
> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
> 
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the mTHP case this is not true, and we must keep the lock to prevent
> access/changes to the page tables. This can happen if the rmap walkers hit
> a pmd_none while the PMD entry is currently unavailable due to being
> temporarily removed during the collapse phase.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 103 +++++++++++++++++++++++++++---------------------
>  1 file changed, 57 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 283bb63854a5..ff6f9f1883ed 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1198,42 +1198,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	return SCAN_SUCCEED;
>  }
>  
> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -		int referenced, int unmapped, struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		unsigned int order)
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
> +	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
> +	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);

In general, const read better when they are at the very top of this list.

>  
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> -
> -	/*
> -	 * Before allocating the hugepage, release the mmap_lock read lock.
> -	 * The allocation can take potentially a long time if it involves
> -	 * sync compaction, and we do not need to hold the mmap_lock during
> -	 * that. We will recheck the vma after taking it again in write mode.
> -	 */
> -	mmap_read_unlock(mm);
> -

You should spell out that locking change (moving it to the caller), and why it
is required, in the patch description.

I'd even have put this into a separate patch, as it's independent to the
order-passing changes.
[...]

>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> -
>  	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> +	WARN_ON_ONCE(!pmd_none(*pmd));
> +	if (is_pmd_order(order)) { /* PMD collapse */
> +		pgtable = pmd_pgtable(_pmd);
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> +	} else { /* mTHP collapse */

Do both these comments (PMD collapse ...) really add any value? I'd say it's
pretty self-documenting code already.

> +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
> +		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> +	}
>  	spin_unlock(pmd_ptl);
>  
>  	folio = NULL;
>  
>  	result = SCAN_SUCCEED;
>  out_up_write:
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
> +	if (pte)
> +		pte_unmap(pte);

-- 
Cheers,

David

