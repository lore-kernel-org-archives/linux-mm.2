Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A996C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4BC6B0128; Thu, 22 Jan 2026 04:19:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7725D6B0129; Thu, 22 Jan 2026 04:19:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EC46B012A; Thu, 22 Jan 2026 04:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53D876B0128
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:19:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D1E3160182
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:19:27 +0000 (UTC)
X-FDA: 84359051574.23.9A4DADE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D5B0E40004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:19:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769073565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oDNFwaPGoX3waIMP5rZJNqCBjlJdC/yYu221+ARpHC8=;
	b=ZUP5Q59iHiA7ILlX338FoKMwwhwuuwV8b7nLqAFWoA+oJ1Oc6xR9UTjhWZLDQ8KJszpS44
	kIwckknutTN+fmt0ia1kWmrGfWdzlyNVvnVyVSPLeX8v2YcYpOshAUw4NmJApcxhKfEN47
	C/0LD6VmcTqcjWmYLs4xJG6urgvO2Cc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769073565; a=rsa-sha256;
	cv=none;
	b=0KDTYE0G8Ag2z1pEZQVB4TeOUaadP98OeBIBobSZTNtg3FT43M+cdyOAN0Dknu0yPige/0
	wHs/Qa25HzpYQspp/oeBiOUh9nKpWv1kpSBdVQjAlgEw9rXscKkKUtbrc4HYOrQCW9vz+9
	x7RlG+8k18n/eKCVb4r0uDy1AiJK5Qo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 238651476;
	Thu, 22 Jan 2026 01:19:17 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35CAB3F632;
	Thu, 22 Jan 2026 01:19:19 -0800 (PST)
Message-ID: <5639693a-a89a-47c8-978e-1aab59268413@arm.com>
Date: Thu, 22 Jan 2026 14:49:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/5] mm/khugepaged: use enum scan_result for result
 variables and return types
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-12-shivankg@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260118192253.9263-12-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D5B0E40004
X-Rspamd-Server: rspam07
X-Stat-Signature: ypsndpn66yojdgw9zo9qr1k8npz5ra81
X-HE-Tag: 1769073564-807355
X-HE-Meta: U2FsdGVkX19JdLhSbmL+o87eNFcZY5bMonQ02VD/T5yzr8jaNggdBR3FyyFlXS40X37o2lbc7EguTY0sdnp/zAnMBzA3ebGiWIYXluHkP0yjbBqTwYRDMbFo4Wfu2ESfT/Fl9pgUp9B9DOC0aAqsKCHZvVDdNb3pq9Chl1x+NF0lfMMpG9jpiM5UyZu/LV996w05cO6N7S6KpnlnmNndGHTz6K1uHRdamkRHqB5dxEm1Zn8FBQwKZ6qdZ1gXb207htljzyTinTER7PRB9DZOfR0qcBz6NH9/HumAjLQHlqpfyIGaB4/T94B9qz72rT7ucAyclicweW6NmZTQoKDgbe3HfiFEn625ZMimhVVamlfMVQK/xaESDTF4vqcvYtn+Uwtf1Y1fErDSNVNsgJai/NLgFJVFN9uSCHj6EkMz2FE3O7dJO8C8pWPbgQ/pzFeoSFxsymyoyDHpSyFh+auKDbdKE9ZsfvqrD9JiUTZyb533ID3jX23x5AL5hHVqTITrP2pW+xXRJ+3QW1ralv0cmcUmo7lDp6Rq1cj2TZBABvVD9G9L/qQ4MEYZa0pH/jRD9eO41Y25lRkfKUjrg0CspekgneQTreE9UvLT6aJWcSzgS/4S8HUKH+Gs15NhKS2p5JElblj+BzKvn+I9RePalxaCxZH1x9tC5i2OBaeTvARQn+dffDzWF2M0CMpDxuVpW5kjZz/l1hFen48ujCToPb4M2B4d07RpEUEZhcsFoO3X1VSrPEHHy+vAM2I7se5sgeyPMyqSGFetXVr66dVwwGmNviPm/LlvTaEHJ/XQ5p8eAqrJZXRZnVdldBPv5McVmG5tAFtBSHMQY/RyyAKCpmtWAzyiTf4ZFy9IQsTjZNggsjAcH4WULphHYE1X0LkmrCm4QuOSTZblDsLaWs6U9ZKmLHwk/QxElMpXDk8aJ83WxX6Dkc+62YKjdVLTLDEzBUJgYLI8si5srPrkFGU
 VDEUzSBv
 BoQpP3t/ZJ47GvAeffZuDxq/AyWWgIOK+CWGt1M9Y6aqDY/3V1k6dS1WAv6vK0gLWoVNCgvKJ2+tL7u0v5meOt0c7rEOmvye/EMmpNnFpYr4uReLsQKY2qpn8TVmXf5xWKShlZTpBmL0O12Uxjesrn3doudnYJxRl9oOIdxNRr0H6Lfs0BaIrbjHoCuxLRD0O3Oiu4oUz+FS5mTK7XhLjTjU0RDrf86oOBCcmfN+PhIKqGNW8Nkh14M/bjjIF+BguSqgLUWp4N5jZNxYkGYgyNYCdid0T+UkEWWZdxz/OEtuGw9bOByLUdeaWMlw8xYbtx0iNqIMzLjeburZZGALqHkcdlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/01/26 12:52 am, Shivank Garg wrote:
> Convert result variables and return types from int to enum scan_result
> throughout khugepaged code. This improves type safety and code clarity
> by making the intent explicit.
>
> No functional change.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Dev Jain <dev.jain@arm.com>

> ---
>  mm/khugepaged.c | 99 +++++++++++++++++++++++--------------------------
>  1 file changed, 46 insertions(+), 53 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 17f3f0043368..1667abae6d8d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -537,17 +537,16 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>  
> -static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> -					unsigned long start_addr,
> -					pte_t *pte,
> -					struct collapse_control *cc,
> -					struct list_head *compound_pagelist)
> +static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
> +		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
> +		struct list_head *compound_pagelist)
>  {
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr = start_addr;
>  	pte_t *_pte;
> -	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> +	int none_or_zero = 0, shared = 0, referenced = 0;
> +	enum scan_result result = SCAN_FAIL;
>  
>  	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
> @@ -780,13 +779,13 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>   * @ptl: lock on raw pages' PTEs
>   * @compound_pagelist: list that stores compound pages
>   */
> -static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
> +static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
>  		unsigned long address, spinlock_t *ptl,
>  		struct list_head *compound_pagelist)
>  {
>  	unsigned int i;
> -	int result = SCAN_SUCCEED;
> +	enum scan_result result = SCAN_SUCCEED;
>  
>  	/*
>  	 * Copying pages' contents is subject to memory poison at any iteration.
> @@ -898,10 +897,8 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
>   * Returns enum scan_result value.
>   */
>  
> -static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> -				   bool expect_anon,
> -				   struct vm_area_struct **vmap,
> -				   struct collapse_control *cc)
> +static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> +		bool expect_anon, struct vm_area_struct **vmap, struct collapse_control *cc)
>  {
>  	struct vm_area_struct *vma;
>  	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
> @@ -930,7 +927,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>  	return SCAN_SUCCEED;
>  }
>  
> -static inline int check_pmd_state(pmd_t *pmd)
> +static inline enum scan_result check_pmd_state(pmd_t *pmd)
>  {
>  	pmd_t pmde = pmdp_get_lockless(pmd);
>  
> @@ -953,9 +950,8 @@ static inline int check_pmd_state(pmd_t *pmd)
>  	return SCAN_SUCCEED;
>  }
>  
> -static int find_pmd_or_thp_or_none(struct mm_struct *mm,
> -				   unsigned long address,
> -				   pmd_t **pmd)
> +static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
> +		unsigned long address, pmd_t **pmd)
>  {
>  	*pmd = mm_find_pmd(mm, address);
>  	if (!*pmd)
> @@ -964,12 +960,11 @@ static int find_pmd_or_thp_or_none(struct mm_struct *mm,
>  	return check_pmd_state(*pmd);
>  }
>  
> -static int check_pmd_still_valid(struct mm_struct *mm,
> -				 unsigned long address,
> -				 pmd_t *pmd)
> +static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
> +		unsigned long address, pmd_t *pmd)
>  {
>  	pmd_t *new_pmd;
> -	int result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
> +	enum scan_result result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
>  
>  	if (result != SCAN_SUCCEED)
>  		return result;
> @@ -985,15 +980,14 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>   */
> -static int __collapse_huge_page_swapin(struct mm_struct *mm,
> -				       struct vm_area_struct *vma,
> -				       unsigned long start_addr, pmd_t *pmd,
> -				       int referenced)
> +static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
> +		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
> +		int referenced)
>  {
>  	int swapped_in = 0;
>  	vm_fault_t ret = 0;
>  	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
> -	int result;
> +	enum scan_result result;
>  	pte_t *pte = NULL;
>  	spinlock_t *ptl;
>  
> @@ -1062,8 +1056,8 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>  	return result;
>  }
>  
> -static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
> -			      struct collapse_control *cc)
> +static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
> +		struct collapse_control *cc)
>  {
>  	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>  		     GFP_TRANSHUGE);
> @@ -1090,9 +1084,8 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
>  	return SCAN_SUCCEED;
>  }
>  
> -static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -			      int referenced, int unmapped,
> -			      struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> +		int referenced, int unmapped, struct collapse_control *cc)
>  {
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> @@ -1100,7 +1093,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
> -	int result = SCAN_FAIL;
> +	enum scan_result result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
>  
> @@ -1246,15 +1239,14 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	return result;
>  }
>  
> -static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> -				   struct vm_area_struct *vma,
> -				   unsigned long start_addr, bool *mmap_locked,
> -				   struct collapse_control *cc)
> +static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> +		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
> +		struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> -	int result = SCAN_FAIL, referenced = 0;
> -	int none_or_zero = 0, shared = 0;
> +	int none_or_zero = 0, shared = 0, referenced = 0;
> +	enum scan_result result = SCAN_FAIL;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr;
> @@ -1441,8 +1433,8 @@ static void collect_mm_slot(struct mm_slot *slot)
>  }
>  
>  /* folio must be locked, and mmap_lock must be held */
> -static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
> -			pmd_t *pmdp, struct folio *folio, struct page *page)
> +static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
> +		pmd_t *pmdp, struct folio *folio, struct page *page)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct vm_fault vmf = {
> @@ -1477,10 +1469,11 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	return SCAN_SUCCEED;
>  }
>  
> -static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> +static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  		bool install_pmd)
>  {
> -	int nr_mapped_ptes = 0, result = SCAN_FAIL;
> +	enum scan_result result = SCAN_FAIL;
> +	int nr_mapped_ptes = 0;
>  	unsigned int nr_batch_ptes;
>  	struct mmu_notifier_range range;
>  	bool notified = false;
> @@ -1862,9 +1855,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   *    + unlock old pages
>   *    + unlock and free huge page;
>   */
> -static int collapse_file(struct mm_struct *mm, unsigned long addr,
> -			 struct file *file, pgoff_t start,
> -			 struct collapse_control *cc)
> +static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> +		struct file *file, pgoff_t start, struct collapse_control *cc)
>  {
>  	struct address_space *mapping = file->f_mapping;
>  	struct page *dst;
> @@ -1872,7 +1864,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
>  	LIST_HEAD(pagelist);
>  	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
> -	int nr_none = 0, result = SCAN_SUCCEED;
> +	enum scan_result result = SCAN_SUCCEED;
> +	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
>  
>  	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> @@ -2293,16 +2286,15 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>  
> -static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> -				    struct file *file, pgoff_t start,
> -				    struct collapse_control *cc)
> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> +		struct file *file, pgoff_t start, struct collapse_control *cc)
>  {
>  	struct folio *folio = NULL;
>  	struct address_space *mapping = file->f_mapping;
>  	XA_STATE(xas, &mapping->i_pages, start);
>  	int present, swap;
>  	int node = NUMA_NO_NODE;
> -	int result = SCAN_SUCCEED;
> +	enum scan_result result = SCAN_SUCCEED;
>  
>  	present = 0;
>  	swap = 0;
> @@ -2400,7 +2392,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>  
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> +static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
>  	__acquires(&khugepaged_mm_lock)
> @@ -2562,7 +2554,7 @@ static void khugepaged_do_scan(struct collapse_control *cc)
>  	unsigned int progress = 0, pass_through_head = 0;
>  	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
>  	bool wait = true;
> -	int result = SCAN_SUCCEED;
> +	enum scan_result result = SCAN_SUCCEED;
>  
>  	lru_add_drain_all();
>  
> @@ -2775,7 +2767,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	struct collapse_control *cc;
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long hstart, hend, addr;
> -	int thps = 0, last_fail = SCAN_FAIL;
> +	enum scan_result last_fail = SCAN_FAIL;
> +	int thps = 0;
>  	bool mmap_locked = true;
>  
>  	BUG_ON(vma->vm_start > start);
> @@ -2796,7 +2789,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	hend = end & HPAGE_PMD_MASK;
>  
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> -		int result = SCAN_FAIL;
> +		enum scan_result result = SCAN_FAIL;
>  		bool triggered_wb = false;
>  
>  retry:

