Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF85FEE4E6
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 09:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC4F6B008A; Sat, 28 Feb 2026 04:35:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A286B008C; Sat, 28 Feb 2026 04:35:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E5C6B0092; Sat, 28 Feb 2026 04:35:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50DF36B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:35:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E62191D0C3
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:35:32 +0000 (UTC)
X-FDA: 84493357704.21.65388A6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4A98280010
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:35:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772271331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=chaMSsYXQ+Rm708L+53XMyyvagxCt/LrwTB7Mjpghe0=;
	b=nQQ5j4OGyIl3fIj4AL4qlNFrmapYNG/XBlw3bUzzsoM8iUfr0BBl0I5Q/FBVk2Sudaifc9
	lmohtUaS0pbsS2z79HUEfwTMkEYKSvAG6/URydK1tNlN1t9ejT07u1fKfRVX/AotZEtJUG
	mQm+EcLjBZOwCJqSWdcMmvug6mjGbjA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772271331; a=rsa-sha256;
	cv=none;
	b=INBFGyl7HyIqejttEJdFpVwUXIkuuwdGX3zsGXiGCGXnJtbZa6PyIUb5aQPnTTVD/zoduU
	xReh1G4M6WhvtXD+EN38SQWi3FwbJa4npMyuzinhOKg/tzsfQsINq0hDmrKa8tRARCkwOZ
	XxktqGl2HCqmVW+GqR443OmgT7WteMk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC77D1516;
	Sat, 28 Feb 2026 01:35:23 -0800 (PST)
Received: from [10.163.135.253] (unknown [10.163.135.253])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5409D3F73B;
	Sat, 28 Feb 2026 01:35:13 -0800 (PST)
Message-ID: <34ffaa1b-5812-47fe-ac35-491bd2f94b8f@arm.com>
Date: Sat, 28 Feb 2026 15:05:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 2/5] mm: introduce is_pmd_order helper
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
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
 <20260226012929.169479-3-npache@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260226012929.169479-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4A98280010
X-Stat-Signature: anntf7wxrb6serjyh45odes5cn84f1gw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772271331-37170
X-HE-Meta: U2FsdGVkX1/2f7g/KqAWP2wUTrOtXgJeMXGtjwa/QVv5KSM9JIVdHVP/0dWiQLYKPX3Kz31c+2rTiu7fvzYtEkr5SE/mlf6DLuFJoVHrMLhcj51Ldb72H+/YV26H/foncAH3Albd4DMXkvUEMKvfSxYkAHAafbaHGiM/qVdQ4wJtFoclvXVWK0XFtLdqIj+cSZTpnir1Rab9GvtlfPi7Itjyec2tWK2ngKME6fqUzkl17Cp84p3uF+GiJ53peRjkN0PxBLFp2p30EyQ/A85CePFIhbA7/NhR5m1CPVJ0SwDdQkO2wwD3wqp5yU7kMZEmgPdgmhsIZa07pGggSEygwRmfiRKRp4k0oAvtk3nFuf3XBmyl3Sv+Ua501BmCG7CYpUPF6xMoMV9j8fjGB3HWnYUjeyBaJFbNpKyzOv14ObdUAKH7yaozcwbYaXEyNAjVsAXetGAQwivNsQvCSKwD76DOjWV2gI2bE4XWKE1iOFjRHGigQB0iTUCX+t6fYlZCk7XxQ32hY+7PjoNIsqTJa0f2sAg/ydfLGSmA/2BrRt95E5s6044+GLEnUTqTgTahbOLRk+rtLez/hCFEdjaVb7Nh0GX8sH2/b9p5zHMmh6pZKNfp8VxKHYsuHMUyVePZK0Y16++TWUxwtpfuFy3J2cJ7bmorVLkGZvtxj3BZ7G/gjwIXSCajc66gNyGR2NL6LL9qFerNSxo7FtLY/ERxo4bdAIn5cNcB3PhClz9peF6/bkwdTJrLjfyAFvvLfgvK+llAiIPcWxzc9pOU1KcWJob+YHK3JEND9hPjWJUvxIrXLPe2ID0II3fo2ba7WDUjVVlAzBLXxaGicPkx73HhKhLFHE/e7RGM6IwNYWhdjuktLhmtIRTslU3sWaKXhf3gdgx85LA4gS79hu+dHK83h/gI8lwgDNiWK1RR7zXQjqIcppl+0lyEAKX2enVm7TKSiJ378kTwFjwaoRqYSAG
 tGozAnDF
 dVuy5QbN+J95MREfg5BJTZ26gww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/26 6:59 am, Nico Pache wrote:
> In order to add mTHP support to khugepaged, we will often be checking if a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

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
> index a4d9f964dfde..bd7f0e1d8094 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -771,6 +771,11 @@ static inline bool pmd_is_huge(pmd_t pmd)
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
> index 8003d3a49822..a688d5ff806e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4100,7 +4100,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		i_mmap_unlock_read(mapping);
>  out:
>  	xas_destroy(&xas);
> -	if (old_order == HPAGE_PMD_ORDER)
> +	if (is_pmd_order(old_order))
>  		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
>  	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
>  	return ret;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c85d7381adb5..2ef4b972470b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1533,7 +1533,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>  	if (IS_ERR(folio))
>  		return SCAN_PAGE_NULL;
>  
> -	if (folio_order(folio) != HPAGE_PMD_ORDER) {
> +	if (!is_pmd_order(folio_order(folio))) {
>  		result = SCAN_PAGE_COMPOUND;
>  		goto drop_folio;
>  	}
> @@ -2016,7 +2016,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		 * we locked the first folio, then a THP might be there already.
>  		 * This will be discovered on the first iteration.
>  		 */
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> +		if (is_pmd_order(folio_order(folio)) &&
>  		    folio->index == start) {
>  			/* Maybe PMD-mapped */
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
> @@ -2346,7 +2346,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>  			continue;
>  		}
>  
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> +		if (is_pmd_order(folio_order(folio)) &&
>  		    folio->index == start) {
>  			/* Maybe PMD-mapped */
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
> diff --git a/mm/memory.c b/mm/memory.c
> index a1a364e1fdcd..cb76fa182eab 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5427,7 +5427,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>  	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>  		return ret;
>  
> -	if (folio_order(folio) != HPAGE_PMD_ORDER)
> +	if (!is_pmd_order(folio_order(folio)))
>  		return ret;
>  	page = &folio->page;
>  
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 0e5175f1c767..e5528c35bbb8 100644
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
> index d88c8c67ac0b..96ffb47bcfee 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -687,7 +687,7 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	bool movable;
>  	if (order > PAGE_ALLOC_COSTLY_ORDER) {
> -		VM_BUG_ON(order != HPAGE_PMD_ORDER);
> +		VM_BUG_ON(!is_pmd_order(order));
>  
>  		movable = migratetype == MIGRATE_MOVABLE;
>  
> @@ -719,7 +719,7 @@ static inline bool pcp_allowed_order(unsigned int order)
>  	if (order <= PAGE_ALLOC_COSTLY_ORDER)
>  		return true;
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (order == HPAGE_PMD_ORDER)
> +	if (is_pmd_order(order))
>  		return true;
>  #endif
>  	return false;
> diff --git a/mm/shmem.c b/mm/shmem.c
> index cfed6c3ff853..ba74803c7518 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5558,8 +5558,7 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>  		spin_unlock(&huge_shmem_orders_lock);
>  	} else if (sysfs_streq(buf, "inherit")) {
>  		/* Do not override huge allocation policy with non-PMD sized mTHP */
> -		if (shmem_huge == SHMEM_HUGE_FORCE &&
> -		    order != HPAGE_PMD_ORDER)
> +		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
>  			return -EINVAL;
>  
>  		spin_lock(&huge_shmem_orders_lock);


