Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E7DFEE4E6
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 09:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A134E6B0005; Sat, 28 Feb 2026 04:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4DB6B0088; Sat, 28 Feb 2026 04:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD5D6B008C; Sat, 28 Feb 2026 04:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C42B6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:36:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24760160B38
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:36:48 +0000 (UTC)
X-FDA: 84493360896.19.99A0F56
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 62EB51C0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:36:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772271406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e2n/SXvsK9yCGnJzKJ6e85dlbiudKsfJzVBuQxpcQVU=;
	b=d8oO1IXi5wAd7c3aBfDaPP+GXUUK+MuyXMk6TWDXsHIaKdZy+ge47am74S4sQXD7TrArhq
	MT+9mClMsxQlW/ini4FXnmEbkGopt3Y0/fMmGh4Lo6fsZkx3oLMO0yxtEECemmQWaF3rxS
	ioAH/1LvK6sJnqzmaIqVPKRsSA/aECc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772271406; a=rsa-sha256;
	cv=none;
	b=KTxtwNJCnNfWmR06ifzkgg/dDX+ngckMXEmC+90iMWdEb8HHxxp0Jwukg5iGYKlqyVbSlM
	ROZtXFIfSFoelt+xZP+xDxHpPNkUz/xACrGOjoHLNDZirQzJvl1pgKMqQlPV39E1K8IodM
	LlcfrSAkGTo7QVK2B6oP3q3JOjX1ESo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 325EC19F6;
	Sat, 28 Feb 2026 01:36:39 -0800 (PST)
Received: from [10.163.135.253] (unknown [10.163.135.253])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 604293F73B;
	Sat, 28 Feb 2026 01:36:25 -0800 (PST)
Message-ID: <2ecab533-0220-4a47-9d55-40826e16cf56@arm.com>
Date: Sat, 28 Feb 2026 15:06:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 4/5] mm/khugepaged: rename hpage_collapse_*
 to collapse_*
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
 <20260226012929.169479-5-npache@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260226012929.169479-5-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 62EB51C0005
X-Stat-Signature: 8yikcn4eif8xaxj7aenbptan8ntqxz87
X-Rspam-User: 
X-HE-Tag: 1772271406-371519
X-HE-Meta: U2FsdGVkX18l3Ahnb3387211ruyz7yZs9JTzGr0BqYBR534dtX4a2wp4MuSyCujm5nB84dUPOc3BWOsRU4afv9tqokB/P7l/PdoFIJP5y7uNiVjIlhxT7oFWNOJpwdaqLWrJmD4oiS9UlA+uyrm8nVt31knsEKhJZn7cJimytdBin8STtJLYv9AsppD2duyvyfzRBZAJXOXZQUmYWTgOK16onhBs0+pYsxTTmjXwOCMJ/lJLIUX7mSv5G7l2cYv/oK/GA46ssuA5Zq/C17o5VNEAFfDx8bA5WuD6KPHHLyC2x92RZCx5iQ2qqbsOC2GwE+vXrKSCs+4Bw/gMr/mdgh7LLiGCRI6NpDt42LCtBcl1LeBaM1shzm9xCcRD26W5j2lHSx4PCygn2Iv+ZKuVgqu44+9aF1cl9Y4CeI+JSKte0KOcHHvL/FiMQZAD8ucFdCmEOkB7j+9aybK9db1y65vofEyoxH7ICy5994vW8dMutLk1DEJrJPFa4dWnyIEHroxiJR81QSyJfuXGncN8IadDlQ0coMubH1CL4h6E/oU06GWO0EaQ0XyeoDBmYnqJg7DF31y21rcx6Qq1E/jmlA+odwO/q0cC9JtrSXFPiF/yD9VHJY3jQTT3P3Un0THBVhJO33lVH9q5nHYYcvr3rOkeFzjnEesWO2XH46Mx5cQFwiHLKs6s+2yHlILrSC9zdTUWMUqh20MlgmQQhNJfoaJ1tx7wREymtCUNICWi6nNI0CEZauqnlKmvgLbkgHR+9s8tOKUahqh8J+metQtGvFpvoUwg2Df5mCVDExIxaE5+hCZXB7uiTjK2v9fNWJ0GgBJlo41JpTLGzxVKN79f4ukfntaMtPtYymLJoms9r/HL/GIaPazaqK2lx4MVXOpQhfYB77wwoEhnE/0mIzDKxIgnH7ver0Xpul9fMH1jKPhgsAtvsdHed4ujPEyTL8V9yrL5kV3N334nyqcm/UV
 F3J8q7jz
 fafBk1/14x/qAekcRgTDD+2kOasSarMJa3XKDVX8BGaEuJIZSE0PYtSxKBeM9Sy++buJO6qEZg3IGniJi9wE9uy+F5JA8Ys43dvqQ3qFza2i5ktwkeofvuRZARxw7LPBWFyntG3zibF/P2ZcpAODXUMC83OYpzAvmBp9USkbVCoDDMU318G2pnCAHpwQhUExVJTII2eJk3YyMbGGKDK7OIpcA7Z/YUx3Lns15QbZnw6RX+oYDTwZXGBeThWzwV6Ea3cC8hM22dmZdjAkVEkseNBf5a8dQNDBLhV7dCQvZiGqq2ae+Ak7bOa6DqLcOAb3plVd16+sEYC+SRJMiuEv2TgzzwtetcZEW4/Ad+T6l0fFaJoI/8u1iWGHUFi46DK9tHpVrR87EPvddSbTSqkvF/RKkZeQgLVK+aLB02wfrpKqbrnD0NC42O0V0EmI3aJdrqUM00OzTIXtKvOLxFxW1VRIwbTdlMmuYlrh+5i+Q3X5is4vLVQLqx3QCyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/26 6:59 am, Nico Pache wrote:
> The hpage_collapse functions describe functions used by madvise_collapse
> and khugepaged. remove the unnecessary hpage prefix to shorten the
> function name.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  mm/khugepaged.c | 71 +++++++++++++++++++++++--------------------------
>  mm/mremap.c     |  2 +-
>  2 files changed, 35 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4615f34911d1..64086488ca01 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -392,14 +392,14 @@ void __init khugepaged_destroy(void)
>  	kmem_cache_destroy(mm_slot_cache);
>  }
>  
> -static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> +static inline int collapse_test_exit(struct mm_struct *mm)
>  {
>  	return atomic_read(&mm->mm_users) == 0;
>  }
>  
> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> +static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  {
> -	return hpage_collapse_test_exit(mm) ||
> +	return collapse_test_exit(mm) ||
>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
>  
> @@ -433,7 +433,7 @@ void __khugepaged_enter(struct mm_struct *mm)
>  	int wakeup;
>  
>  	/* __khugepaged_exit() must not run from under us */
> -	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> +	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>  	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>  		return;
>  
> @@ -487,7 +487,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	} else if (slot) {
>  		/*
>  		 * This is required to serialize against
> -		 * hpage_collapse_test_exit() (which is guaranteed to run
> +		 * collapse_test_exit() (which is guaranteed to run
>  		 * under mmap sem read mode). Stop here (after we return all
>  		 * pagetables will be destroyed) until khugepaged has finished
>  		 * working on the pagetables under the mmap_lock.
> @@ -582,7 +582,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			goto out;
>  		}
>  
> -		/* See hpage_collapse_scan_pmd(). */
> +		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
>  			++shared;
>  			if (cc->is_khugepaged &&
> @@ -833,7 +833,7 @@ static struct collapse_control khugepaged_collapse_control = {
>  	.is_khugepaged = true,
>  };
>  
> -static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
> +static bool collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
>  
> @@ -868,7 +868,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
>  }
>  
>  #ifdef CONFIG_NUMA
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	int nid, target_node = 0, max_value = 0;
>  
> @@ -887,7 +887,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
>  	return target_node;
>  }
>  #else
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	return 0;
>  }
> @@ -906,7 +906,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
>  	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
>  				 TVA_FORCED_COLLAPSE;
>  
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		return SCAN_ANY_PROCESS;
>  
>  	*vmap = vma = find_vma(mm, address);
> @@ -977,7 +977,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
>  
>  /*
>   * Bring missing pages in from swap, to complete THP collapse.
> - * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
> + * Only done if khugepaged_scan_pmd believes it is worthwhile.
>   *
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> @@ -1063,7 +1063,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  {
>  	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>  		     GFP_TRANSHUGE);
> -	int node = hpage_collapse_find_target_node(cc);
> +	int node = collapse_find_target_node(cc);
>  	struct folio *folio;
>  
>  	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
> @@ -1241,10 +1241,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	return result;
>  }
>  
> -static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> -		struct vm_area_struct *vma, unsigned long start_addr,
> -		bool *mmap_locked, unsigned int *cur_progress,
> -		struct collapse_control *cc)
> +static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> +		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
> +		unsigned int *cur_progress, struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> @@ -1366,7 +1365,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		 * hit record.
>  		 */
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			goto out_unmap;
>  		}
> @@ -1432,7 +1431,7 @@ static void collect_mm_slot(struct mm_slot *slot)
>  
>  	lockdep_assert_held(&khugepaged_mm_lock);
>  
> -	if (hpage_collapse_test_exit(mm)) {
> +	if (collapse_test_exit(mm)) {
>  		/* free mm_slot */
>  		hash_del(&slot->hash);
>  		list_del(&slot->mm_node);
> @@ -1787,7 +1786,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
>  			continue;
>  
> -		if (hpage_collapse_test_exit(mm))
> +		if (collapse_test_exit(mm))
>  			continue;
>  
>  		if (!file_backed_vma_is_retractable(vma))
> @@ -2305,9 +2304,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>  
> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> -		unsigned long addr, struct file *file, pgoff_t start,
> -		unsigned int *cur_progress, struct collapse_control *cc)
> +static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> +		struct file *file, pgoff_t start, unsigned int *cur_progress,
> +		struct collapse_control *cc)
>  {
>  	struct folio *folio = NULL;
>  	struct address_space *mapping = file->f_mapping;
> @@ -2362,7 +2361,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>  		}
>  
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			folio_put(folio);
>  			break;
> @@ -2418,7 +2417,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>  	return result;
>  }
>  
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
> +static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
>  	__acquires(&khugepaged_mm_lock)
> @@ -2453,7 +2452,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  		goto breakouterloop_mmap_lock;
>  
>  	progress++;
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		goto breakouterloop;
>  
>  	vma_iter_init(&vmi, mm, khugepaged_scan.address);
> @@ -2461,7 +2460,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  		unsigned long hstart, hend;
>  
>  		cond_resched();
> -		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> +		if (unlikely(collapse_test_exit_or_disable(mm))) {
>  			progress++;
>  			break;
>  		}
> @@ -2484,7 +2483,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  			unsigned int cur_progress = 0;
>  
>  			cond_resched();
> -			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +			if (unlikely(collapse_test_exit_or_disable(mm)))
>  				goto breakouterloop;
>  
>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
> @@ -2497,13 +2496,13 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  
>  				mmap_read_unlock(mm);
>  				mmap_locked = false;
> -				*result = hpage_collapse_scan_file(mm,
> +				*result = collapse_scan_file(mm,
>  					khugepaged_scan.address, file, pgoff,
>  					&cur_progress, cc);
>  				fput(file);
>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>  					mmap_read_lock(mm);
> -					if (hpage_collapse_test_exit_or_disable(mm))
> +					if (collapse_test_exit_or_disable(mm))
>  						goto breakouterloop;
>  					*result = try_collapse_pte_mapped_thp(mm,
>  						khugepaged_scan.address, false);
> @@ -2512,7 +2511,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  					mmap_read_unlock(mm);
>  				}
>  			} else {
> -				*result = hpage_collapse_scan_pmd(mm, vma,
> +				*result = collapse_scan_pmd(mm, vma,
>  					khugepaged_scan.address, &mmap_locked,
>  					&cur_progress, cc);
>  			}
> @@ -2546,7 +2545,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  	 * Release the current mm_slot if this mm is about to die, or
>  	 * if we scanned all vmas of this mm, or THP got disabled.
>  	 */
> -	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
> +	if (collapse_test_exit_or_disable(mm) || !vma) {
>  		/*
>  		 * Make sure that if mm_users is reaching zero while
>  		 * khugepaged runs here, khugepaged_exit will find
> @@ -2599,8 +2598,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
>  			pass_through_head++;
>  		if (khugepaged_has_work() &&
>  		    pass_through_head < 2)
> -			progress += khugepaged_scan_mm_slot(pages - progress,
> -							    &result, cc);
> +			progress += collapse_scan_mm_slot(pages - progress,
> +							  &result, cc);
>  		else
>  			progress = pages;
>  		spin_unlock(&khugepaged_mm_lock);
> @@ -2844,8 +2843,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			mmap_read_unlock(mm);
>  			mmap_locked = false;
>  			*lock_dropped = true;
> -			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> -							  NULL, cc);
> +			result = collapse_scan_file(mm, addr, file, pgoff, NULL, cc);
>  
>  			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>  			    mapping_can_writeback(file->f_mapping)) {
> @@ -2859,8 +2857,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			}
>  			fput(file);
>  		} else {
> -			result = hpage_collapse_scan_pmd(mm, vma, addr,
> -							 &mmap_locked, NULL, cc);
> +			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, NULL, cc);
>  		}
>  		if (!mmap_locked)
>  			*lock_dropped = true;
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 2be876a70cc0..eb222af91c2d 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -244,7 +244,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  		goto out;
>  	}
>  	/*
> -	 * Now new_pte is none, so hpage_collapse_scan_file() path can not find
> +	 * Now new_pte is none, so collapse_scan_file() path can not find
>  	 * this by traversing file->f_mapping, so there is no concurrency with
>  	 * retract_page_tables(). In addition, we already hold the exclusive
>  	 * mmap_lock, so this new_pte page is stable, so there is no need to get


