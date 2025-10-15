Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55249CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921668E000D; Wed, 15 Oct 2025 03:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CFD28E0002; Wed, 15 Oct 2025 03:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF7A8E000D; Wed, 15 Oct 2025 03:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA008E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:30:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D6A411B30E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:30:52 +0000 (UTC)
X-FDA: 83999526744.12.A71C5C2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D546180006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:30:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760513450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rXmtuddX1kViWpW7IHGRRozRBMIOAO6Qt6r2lkBzNII=;
	b=PybpvmS/L7hJOis/WoWpNUPnLYR+OGYvLHw+b4vrPAjneq2BqVkM22FP2o03Y21LZxGDBB
	lEGmGL/JkKKLH5JOT2thBgjHo6JrcuGqu5DYtdq/EQ+3BYV4gZthUyXUHJ5wptPZl8eexz
	h4IVlQ04R0un7XhHyxAjpxp0sKHNGHI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760513450; a=rsa-sha256;
	cv=none;
	b=riAkcXGDOghV4W1dGxSIi9xOripYRvDC08+wiy3q0wRbWGg/sunyHSqXbkmp4MmnOvqa+Y
	/eHn28QpeWICZnXnl+svdtDe8GTqK6QqVKUwVWdb5bBsXhh1ZABOI9JuOyHRLdnqtmpv/C
	WQJ7Otfyj5FMvnwk4AMwYSsZgulbBlw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DD161A32;
	Wed, 15 Oct 2025 00:30:41 -0700 (PDT)
Received: from [10.163.67.182] (unknown [10.163.67.182])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F02243F6A8;
	Wed, 15 Oct 2025 00:30:44 -0700 (PDT)
Message-ID: <1c020f8f-4722-45e4-af1f-ee3d4a67068b@arm.com>
Date: Wed, 15 Oct 2025 13:00:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: huge_memory: use folio_skip_prot_numa() for
 pmd folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Liam.Howlett@oracle.com,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-4-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251014113349.2618158-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D546180006
X-Stat-Signature: bo8e1sxdx63uqgg45chkznj1irksxesk
X-Rspam-User: 
X-HE-Tag: 1760513450-197037
X-HE-Meta: U2FsdGVkX1+AbDmSfFKghuOVq76rJOCROHX9LkWloavZAwC/QXuJs9iiG6oN+bLPxeBPpXVTjkPuIt+FqipIJ7RBTm311us1XRZbjs6S5d5ccGgq/HWZjFCHtnHBidsLACQwxUGDSMKq507sWptmrRPRP0u1viykiH2Ffp4vlumDjC9yyqv02uNuzbg119Qe4e0VTcAjqXo0lcFfQZs26Ft1Z0eQdAtCKK4ABhKlz8inhAohs6qpXAup4FKsqcS/qX5R7fa6aNRgEx4muqvIceR3+9XFOHMO1khPfNX4f2xoTtSTG/BJINxqJZHQxwO+js/BEdRJhU4/RxQil3R2QzcrjpGUMjDubbaXPrO2ia526e3KwPLujQJSRhjUPXTbX1nb71SJrxxqE5XYruDN7uQNIME+2Fl5imMuTWJv2f5GgbleSavcQENkl05DqbM1Fn5dFYyFiFPTAzcPyEuLvoz+SVsm6n73MqJ8PPRSMgonzhPyWN3w6oS/spzd++Wwg3qkD/Ytp5YA844kwnaBMGlQGAXE9Kx4ZB62PjPJ+4XJqOXCIzSVBCAJsAxOXR90idMy0wnpICB3vTzEvQU1uG1IjP918wFi7MkcUXSSk4giHfyCZBiayu5iGnqNA6HW/yG4Nxxxhxu5bfMATk/Shq3PRRVuQdOMSnA0Nin4OwuVMhuNKFF1svCARAlGJ0lGd5N/eRya+cEd3aL9Sb3vslkttvCiv/pExA94jXNxJIeN1cjCJZ0/d80d5swEksbdULJfVUEKs874faHniLx13nJZhk2m0xVvoRo0Jo4KniRrbHNxYty6lLCQmMjAL5PjqUJlF1f09k4Onvnyyq6nX0RnMTXIrRRr1Uco012Vh1ckWDu38OCgkssu2ySQALKjYWxhK5vrdA1IFM5Jq94ItsDXLngZbFp2IfPC2tZ7LKXpNyKrt/a120CW/XJb1Kpe9Fa1scpnES2Y6Z1Zk3m
 j01GUTnx
 Paw28w/ERF4xew6c9kAuDJxUkjKvB3L2vU4HJWhGy+QR/RaKatk4981UR5LiQS6MDAhwpGB7SAn8vOCKUmAE/+teEYEZSMh4B2V56T50PUixf64HvweVLmmJnyfzltkHvmj6BZEjZz6KCeB9dXsXpZ59A6XMr4Uq8I5ILW/ZZ5fi2vuNmajTWvdAquqW8+hmlNjkFyVInq+2gajAvHvUExCWKWqhc8T9IABCuR5y+vBCRVLs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/10/25 5:03 pm, Kefeng Wang wrote:
> Rename prot_numa_skip() to folio_skip_prot_numa(), and remove
> ret by directly return value instead of goto style.
>
> The folio skip checks for prot numa should be suitable for pmd
> folio too, which helps to avoid unnecessary pmd change and folio
> migration attempts.
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

In the review of my mprotect pte batching series, reviewers had
noted that the branch "if (folio_use_access_time(folio))" in
folio_skip_prot_numa() did not belong there - it should be done
outside of the function. But I see that that would duplicate a line
now that this function has two users. So in light of that, would you
mind changing the name of this function to folio_skip_or_process_prot_numa()?

> ---
>   mm/huge_memory.c | 21 +++++++--------------
>   mm/internal.h    |  2 ++
>   mm/mprotect.c    | 35 ++++++++++++++---------------------
>   3 files changed, 23 insertions(+), 35 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1d1b74950332..8ae17e0aacb9 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2395,8 +2395,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   #endif
>   
>   	if (prot_numa) {
> -		struct folio *folio;
> -		bool toptier;
> +		int target_node = NUMA_NO_NODE;
>   		/*
>   		 * Avoid trapping faults against the zero page. The read-only
>   		 * data is likely to be read-cached on the local CPU and
> @@ -2408,19 +2407,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		if (pmd_protnone(*pmd))
>   			goto unlock;
>   
> -		folio = pmd_folio(*pmd);
> -		toptier = node_is_toptier(folio_nid(folio));
> -		/*
> -		 * Skip scanning top tier node if normal numa
> -		 * balancing is disabled
> -		 */
> -		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> -		    toptier)
> -			goto unlock;
> +		/* Get target node for single threaded private VMAs */
> +		if (!(vma->vm_flags & VM_SHARED) &&
> +		    atomic_read(&vma->vm_mm->mm_users) == 1)
> +			target_node = numa_node_id();
>   
> -		if (folio_use_access_time(folio))
> -			folio_xchg_access_time(folio,
> -					       jiffies_to_msecs(jiffies));
> +		if (folio_skip_prot_numa(pmd_folio(*pmd), vma, target_node))
> +			goto unlock;
>   	}
>   	/*
>   	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..55daceab3682 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1378,6 +1378,8 @@ void vunmap_range_noflush(unsigned long start, unsigned long end);
>   
>   void __vunmap_range_noflush(unsigned long start, unsigned long end);
>   
> +bool folio_skip_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> +		int target_node);
>   int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>   		      unsigned long addr, int *flags, bool writable,
>   		      int *last_cpupid);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 7affa88a6de7..cec4c80eb46d 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,26 +118,21 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>   }
>   
> -static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> -		struct folio *folio)
> +bool folio_skip_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> +		int target_node)
>   {
> -	bool ret = true;
> -	bool toptier;
>   	int nid;
>   
> -	if (!folio)
> -		goto skip;
> -
> -	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
> -		goto skip;
> +	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
> +		return true;
>   
>   	/* Also skip shared copy-on-write folios */
>   	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
> -		goto skip;
> +		return true;
>   
>   	/* Folios are pinned and can't be migrated */
>   	if (folio_maybe_dma_pinned(folio))
> -		goto skip;
> +		return true;
>   
>   	/*
>   	 * While migration can move some dirty pages,
> @@ -145,7 +140,7 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>   	 * context.
>   	 */
>   	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
> -		goto skip;
> +		return true;
>   
>   	/*
>   	 * Don't mess with PTEs if page is already on the node
> @@ -153,23 +148,20 @@ static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>   	 */
>   	nid = folio_nid(folio);
>   	if (target_node == nid)
> -		goto skip;
> -
> -	toptier = node_is_toptier(nid);
> +		return true;
>   
>   	/*
>   	 * Skip scanning top tier node if normal numa
>   	 * balancing is disabled
>   	 */
> -	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
> -		goto skip;
> +	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> +	    node_is_toptier(nid))
> +		return true;
>   
> -	ret = false;
>   	if (folio_use_access_time(folio))
>   		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
>   
> -skip:
> -	return ret;
> +	return false;
>   }
>   
>   /* Set nr_ptes number of ptes, starting from idx */
> @@ -314,7 +306,8 @@ static long change_pte_range(struct mmu_gather *tlb,
>   			 * Avoid trapping faults against the zero or KSM
>   			 * pages. See similar comment in change_huge_pmd.
>   			 */
> -			if (prot_numa & prot_numa_skip(vma, target_node, folio)) {
> +			if (prot_numa & folio_skip_prot_numa(folio, vma,
> +							     target_node)) {
>   				/* determine batch to skip */
>   				nr_ptes = mprotect_folio_pte_batch(folio,
>   					  pte, oldpte, max_nr_ptes, /* flags = */ 0);

