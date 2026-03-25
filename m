Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD58C106B50D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 12:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E3E6B00A1; Wed, 25 Mar 2026 08:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56BF6B00A2; Wed, 25 Mar 2026 08:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92F16B00A3; Wed, 25 Mar 2026 08:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B787F6B00A1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:11:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 708831A0897
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:11:49 +0000 (UTC)
X-FDA: 84584471538.06.8B6AD11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB27A4000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:11:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhPR4fk3;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774440707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eB0BlTSe/ux9Qkw60lE+9xUBl+FeYGqnIbpHzU77nr8=;
	b=8etehoCHw/TMxm4mRGMqnE/RDIgGacL8Lb2hi/qk+Zn/CbZDWwOVapn+0wyMaSwB5OfrGk
	4mVD0iPV2Um1muORJpYWiYQ1FzLxXG4lJ99XujBrB6POiD9/hQH7O8KP8qiocuF31jdCar
	oiBYqEw+6NvlLWBcmABdTWgVUjPZsFE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhPR4fk3;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774440707; a=rsa-sha256;
	cv=none;
	b=KlzljB7avw5VTLpCK1QX6QKmvy1Iedn6Iv+fGsXs1V1TeUPIxPoMOZAHR/De8jYMXgkZ3T
	8vjxIdwwy47hNkcvdlP6TX0rLBtmD47MSVmpG+rD/XjsM3KMo4S1lpBk+kpzQuDftlshXq
	EE6dRRKbgwTrPnG1a3+JIU34Ugjf7ro=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AAFC43470;
	Wed, 25 Mar 2026 12:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9539C4CEF7;
	Wed, 25 Mar 2026 12:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774440706;
	bh=8STzoEXzyx9Fi49+q2aeLFvhtyOHdcAQVOK8OCAmkVE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LhPR4fk3/hyEmzOq0YPkSoH+87jSt1fykkwvk8TodG4ARv5SCnb/Ud6iHz0KIhNJa
	 +DiTealuLI4qVmYmQlUJX0W2X9O+7HbV3+DCRFhJFFmXhO9hll5K6KIC9VM4Ox6pvZ
	 I1OEU/WrJjvEu2DgtEjbu5kh9ydcqBDgjKMrWP+ttHhnXZo8t352g3ErUOFBEVMp9J
	 2fz8ZgMtMFywN/An3S8d6IVLQqyAxeLl2EODKHImtW2diEy+E5epOu9uUZSe3bUrdS
	 orcWhDWeBn/Y85ePjsn8Ixqxvdx5ETQkk4X78GASyzIEZyc2NPmfwr3/6IK8rleCyS
	 Ln8CmL73qvZ1w==
Date: Wed, 25 Mar 2026 12:11:43 +0000
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
Subject: Re: [PATCH mm-unstable v4 2/5] mm: introduce is_pmd_order helper
Message-ID: <eed250c8-7a31-4ace-b5e2-9f2898599ec8@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-3-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325114022.444081-3-npache@redhat.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB27A4000A
X-Stat-Signature: z5id4skgacgn8ttjbit8817xm3n11fxm
X-Rspam-User: 
X-HE-Tag: 1774440707-731288
X-HE-Meta: U2FsdGVkX1/eEg2onTmbQXIz8GEia6nlx7zNjPWlbggJRHv8XVBgtfhcv6qcGmZgw814I0yKOtnR0USAJhcdS3sO8fgMvfWdfaLjaCPl1zI3d7d/NZ8WyuYkNC5zvExxavVMzxRzeOI1G8ibbAUAH11KNyvcHYRlR4tgxQDkwqODorxR4h7N6C7WYJA9unBQSIkSr/ZnjHj5Cm1bbJCZD+wJ0DHnyQPWH7mZfcBMxmLcUG6/m0en7U7G6jBxTaleeC83OaeNFBy3CudEdlNG4C/WYh/tlYAT5Vl9j62iR2ac4dj0pbgHxqA/v+h2wvWEjHyI7ec4zUzXnPzaJaO/CkYVXIV9MtT9T8yno+QZvrDeUHDR8XSgpRGFwbDGSLm1GWZTvnkXTLWs51N9/hYx6ExBMip0KLX9WXhtUwCSmsNEF3Bclb5BBZHuzo4KqN3+o+TwMgzKvXVhPXYQjtcT3dfjr4flB7FBNLeBfBjEvi2NCPxlCD7UK0LzikqAY96lancXq7ao6Gr3l3ZJQ3Y+7/uF38AlNDsO782wE2x8iRH5D/VByNrYtcEFuDyaa8As10D4h1ltTtW1wqfQDGWcpMTrjJXFQHpBdoDHY+IGViuW9QjNFSkRuZ6OVNYTz/QkBi+a1oBFnEBg+RMBv8whgmjtzpNd9RhRYauLuh+HF7uxYuLqyEJDGjrmf7M2zB+VCcpvBYXA8oS6OTaZCJv5+yft/ElVPq/bbkEplPguFxKaKOUmEGV9xxnZ4SDhZcW4o4CBW1/7J5DnUz+3Erxl5K39NfgZ+toAXXOVWzn0GrEBFI0ceHSllFMuxohmOrYE39hrgVTq5rYB5gQOvshLeU1HqciXAr2hdIhVwwt00+c1cZWawgD6aRteF49cy/I7s+qZSDfrITau8mXj06DsQpaaWSPKnzOSxFsNudyQicasoAx1PsRTtXbytTffAUQEZkeRsbKn5e+qbK8NpBV
 rlnAC6Qk
 HnJ1qtYwu5pf/0IqW14GDiJYiElpBN0RWbdLCSpnIoRpe46sO/QSkZkztDISKc7vZOU91VHPwpKalKFOk1oxj0cG2IOauz91HN6Xsq4l0Vpttu4IO18WdDIOEhHtG6tbyhX4EHjg1UPMHZA5fGKIxUo0nk7CPsyKp5nyoOQXkNMvjmiD8FRK2c0gB28oov+dsadr7GmBUpaPPWZUYBlBAeWdMIA30fCmTM9YXKME7X+aKNTQWMJlx6rQEvQ3ljsy702jm9VvHaYcOVBWRl/QcuxzXf7GVIMFQEEwzfMgoL1TGEPl73+ukcCECPw0WFNurdllROJLUIN8OQRFKNelmDZtaHo4lmPIth9iwoaP8I6ddjn+KAZvudpInUxHx+tMwjuZtiLUyaQQljfKMGuFbLYenh6maH37bA8YeAM/vujq1m4QC7v+77jYbWzYJM3prbGdiNM/zXxNPkpJyFWU4PqhBeN/BDuvz6Cfv6qiiPzW+NbfTUb6Z55tpT36GdH60mpxzgtXAT6NHEB65o1uxQQnxe0JoLIkkrSMjQM20mrcVEPfEwjhTVOKCaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:40:19AM -0600, Nico Pache wrote:
> In order to add mTHP support to khugepaged, we will often be checking if a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Nit, but could we please update both to:

Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks :), Lorenzo

> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  include/linux/huge_mm.h | 5 +++++
>  mm/huge_memory.c        | 2 +-
>  mm/khugepaged.c         | 6 +++---
>  mm/memory.c             | 2 +-
>  mm/mempolicy.c          | 2 +-
>  mm/page_alloc.c         | 4 ++--
>  mm/shmem.c              | 3 +--
>  7 files changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index c8799dca3b60..1258fa37e85b 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -769,6 +769,11 @@ static inline bool pmd_is_huge(pmd_t pmd)
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>
> +static inline bool is_pmd_order(unsigned int order)
> +{
> +	return order == HPAGE_PMD_ORDER;
> +}
> +
>  static inline int split_folio_to_list_to_order(struct folio *folio,
>  		struct list_head *list, int new_order)
>  {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2833b06d7498..b2a6060b3c20 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4118,7 +4118,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		i_mmap_unlock_read(mapping);
>  out:
>  	xas_destroy(&xas);
> -	if (old_order == HPAGE_PMD_ORDER)
> +	if (is_pmd_order(old_order))
>  		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
>  	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
>  	return ret;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6bd7a7c0632a..1f4609761294 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1547,7 +1547,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>  	if (IS_ERR(folio))
>  		return SCAN_PAGE_NULL;
>
> -	if (folio_order(folio) != HPAGE_PMD_ORDER) {
> +	if (!is_pmd_order(folio_order(folio))) {
>  		result = SCAN_PAGE_COMPOUND;
>  		goto drop_folio;
>  	}
> @@ -2030,7 +2030,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		 * we locked the first folio, then a THP might be there already.
>  		 * This will be discovered on the first iteration.
>  		 */
> -		if (folio_order(folio) == HPAGE_PMD_ORDER) {
> +		if (is_pmd_order(folio_order(folio))) {
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
>  			goto out_unlock;
>  		}
> @@ -2358,7 +2358,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>  			continue;
>  		}
>
> -		if (folio_order(folio) == HPAGE_PMD_ORDER) {
> +		if (is_pmd_order(folio_order(folio))) {
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
>  			/*
>  			 * PMD-sized THP implies that we can only try
> diff --git a/mm/memory.c b/mm/memory.c
> index 6396d32c348a..e44469f9cf65 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5573,7 +5573,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>  	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>  		return ret;
>
> -	if (folio_order(folio) != HPAGE_PMD_ORDER)
> +	if (!is_pmd_order(folio_order(folio)))
>  		return ret;
>  	page = &folio->page;
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index ff52fb94ff27..fd08771e2057 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2449,7 +2449,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>  	    /* filter "hugepage" allocation, unless from alloc_pages() */
> -	    order == HPAGE_PMD_ORDER && ilx != NO_INTERLEAVE_INDEX) {
> +	    is_pmd_order(order) && ilx != NO_INTERLEAVE_INDEX) {
>  		/*
>  		 * For hugepage allocation and non-interleave policy which
>  		 * allows the current node (or other explicitly preferred
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 915b6aef55d0..ee81f5c67c18 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -652,7 +652,7 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	bool movable;
>  	if (order > PAGE_ALLOC_COSTLY_ORDER) {
> -		VM_BUG_ON(order != HPAGE_PMD_ORDER);
> +		VM_BUG_ON(!is_pmd_order(order));
>
>  		movable = migratetype == MIGRATE_MOVABLE;
>
> @@ -684,7 +684,7 @@ static inline bool pcp_allowed_order(unsigned int order)
>  	if (order <= PAGE_ALLOC_COSTLY_ORDER)
>  		return true;
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (order == HPAGE_PMD_ORDER)
> +	if (is_pmd_order(order))
>  		return true;
>  #endif
>  	return false;
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d00044257401..4ecefe02881d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5532,8 +5532,7 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>  		spin_unlock(&huge_shmem_orders_lock);
>  	} else if (sysfs_streq(buf, "inherit")) {
>  		/* Do not override huge allocation policy with non-PMD sized mTHP */
> -		if (shmem_huge == SHMEM_HUGE_FORCE &&
> -		    order != HPAGE_PMD_ORDER)
> +		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
>  			return -EINVAL;
>
>  		spin_lock(&huge_shmem_orders_lock);
> --
> 2.53.0
>

