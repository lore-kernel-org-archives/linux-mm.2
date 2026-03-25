Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C8C4106B506
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 12:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8ACF6B009F; Wed, 25 Mar 2026 08:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62656B00A1; Wed, 25 Mar 2026 08:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78C56B00A2; Wed, 25 Mar 2026 08:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5FEC6B009F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:08:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95802E0BC5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:08:15 +0000 (UTC)
X-FDA: 84584462550.05.84D0E8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id F2B8D40002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:08:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nWulLSob;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nWulLSob;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774440494; a=rsa-sha256;
	cv=none;
	b=fQ4uq408iB0+YnFbAoKOqT/EB3Py0JYDU0N89ZB7LwOYSPDbqfHQi/vSvA6nLMmZp8DLy6
	5GgncmgxAs3Ase5YW0UrrbIPONF57PLUfAiLuGUdAmDerKZgjmj08kV+nTuXXdH/3DBbmu
	nYIMOxOpBsFc0aq41U8TO3/YggRGdkE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774440494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTlxQ1O3YidaDJ5P70Fq9SGz5o5rwXo17iuGluKBrS0=;
	b=t5bUS/OwARbVNWc+zhG571luNc/LvowI3R7keEI4Mx+Eioj5RydZDnqOqiGRHken04MNm6
	CgSxstnwJhV2s2lHadGFXjlTEaM8H0lsNEmOLEo/aq/jOkfJQtn/HsdLufPxgsiTaTdaDg
	9QUCsv+JIkyCTH3wEJznA4BugWHCSIw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 460E860127;
	Wed, 25 Mar 2026 12:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6279FC4CEF7;
	Wed, 25 Mar 2026 12:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774440493;
	bh=1Wrf7sVkSxAuFASSfCFBH7/+Evt87JhXxB7F75QZKLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nWulLSobRfTMftgjAPKxABQwY/vQ9l34dZaBCkHITld+LgskUKw2B4gWwbyw49HmA
	 zpPlK3pPfNYYJROeRNL8tagyHfLbh0iBEKGr80QVWZzfOIuji9wT+VtWsAJftJ/3hh
	 wQXCIAE7RlIuRvXhsHtUWpvk1wg87lsXv/K7wvP7TAQ+IJXKTKV6VeWD/l0gWYW13O
	 r1kQZnKVclWThEvnZtwveA21WJB9P8XQLlD8cY/USybTBxRY2k5gWx3UXNmCHhm2G1
	 Ii3eYOAXo0h+88VyEpwt5Wh4Qr76mW2CogssCzK0RPn+lJ/1xj4rwRBGjJVmprARD5
	 3li8zpF9FHfLA==
Date: Wed, 25 Mar 2026 12:08:10 +0000
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
Subject: Re: [PATCH mm-unstable v4 4/5] mm/khugepaged: rename
 hpage_collapse_* to collapse_*
Message-ID: <0d9d8484-9fa3-461f-bc66-35a42d196ce1@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-5-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325114022.444081-5-npache@redhat.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F2B8D40002
X-Stat-Signature: pkye8r763sims8osfbgmaquuqgquw7fp
X-Rspam-User: 
X-HE-Tag: 1774440493-646235
X-HE-Meta: U2FsdGVkX19bgWD8awWJi6M6wJJFfv0ahFW5ClfCNNRTuEPyJq7oUMgnWQP9ex7fOYB0omS6ZvUDZopxPR4IWq4bE7tfwfuSaEU5CbjqdhS4DkAEXcvlkRjOYilr1Oe2Tzg05xhhIqiGYv+D5NEIi7Th6zg8PSAnNHu8OZi1Pk1TmiXrz/50HE7VKe1Kqn5+l+PSvrEg1a7Xba3WiXPMTzoJYNtnMrdfDCVNKrRmE93XBapWJ4K1WyPtrnhz5bSo4F41BpF2X0OpKqnjL/d1tmGvGweznCq4BaWsbGp93cD2JoMGu+5yi/yyIsawShKeeHp18h+lUbOWtLuVVXhuAb5GmO8CEdSti9+tbP1Eymvivtrr75+QnFlSE+d0mdq32G5eoF3730zHZY5mht9XnKZR2pTBJAoaXcL7Wb+zQ3qHxFcM+GcNttn7Ea5DhMs5USBPWrbz4uOJXTlSje6daWZND/9cikhPAs+IWEH0c0uO4JEaFJEf2w9HK73HfWkK1U4TVKmLM3iAXY8b5r2QzUGQcDwdyUTgr1yW4UpCW5FQMWuGeGh1xmftDw1UsA7hhz/zaZTBDdmcOglNkltvkRKG9jrzGMqZ8v9BI58tItSdNaMntOsWYwAKoXaAAGM6AO7Oh6IsjTUCs7hoLyJpjuoj7BGo/AIyP++ja/ZAd4ta+9cZZcGJS4+d55p9+QfBkjHd5jF2R+DRVpJTw2wAOMDLpOPE+SlLmH90ITy9c99xncAAFJ2FcP55GaaNO82N9pn/zdxy/kxr0BdoK5fK8lTWjT5fSLX4b6V15GEyVjWZc+Bo3n5MrOXaFjJGqyX/3QKvuqojCD49vojhTgtQgjD05vfuaR1Kl63gx+BFyn0ll+B9kKD0i/RgMQ+Q0/0T9t3DdQmUiEkr1JmMyRA5ISxUhfJYUEgSRIvDtCCxb+gHltBa6pmbm4b4qVC6amB9kcSSL1w1irLGYxhivH5
 v88FNFKz
 dwxP4+MhyOYyX7BIWGAG5tVBh7iw4D+2n+MgWaX7MNehkieXHwxrIS4p8kP6vsjuyqKJS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:40:21AM -0600, Nico Pache wrote:
> The hpage_collapse functions describe functions used by madvise_collapse
> and khugepaged. remove the unnecessary hpage prefix to shorten the
> function name.
>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Nit, but could we please update this to:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks, Lorenzo

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 60 ++++++++++++++++++++++++-------------------------
>  mm/mremap.c     |  2 +-
>  2 files changed, 30 insertions(+), 32 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c9c17bfccf0d..3728a2cf133c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -395,14 +395,14 @@ void __init khugepaged_destroy(void)
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
> @@ -436,7 +436,7 @@ void __khugepaged_enter(struct mm_struct *mm)
>  	int wakeup;
>
>  	/* __khugepaged_exit() must not run from under us */
> -	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> +	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>  	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>  		return;
>
> @@ -490,7 +490,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	} else if (slot) {
>  		/*
>  		 * This is required to serialize against
> -		 * hpage_collapse_test_exit() (which is guaranteed to run
> +		 * collapse_test_exit() (which is guaranteed to run
>  		 * under mmap sem read mode). Stop here (after we return all
>  		 * pagetables will be destroyed) until khugepaged has finished
>  		 * working on the pagetables under the mmap_lock.
> @@ -589,7 +589,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			goto out;
>  		}
>
> -		/* See hpage_collapse_scan_pmd(). */
> +		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
>  			++shared;
>  			if (cc->is_khugepaged &&
> @@ -840,7 +840,7 @@ static struct collapse_control khugepaged_collapse_control = {
>  	.is_khugepaged = true,
>  };
>
> -static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
> +static bool collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
>
> @@ -875,7 +875,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
>  }
>
>  #ifdef CONFIG_NUMA
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	int nid, target_node = 0, max_value = 0;
>
> @@ -894,7 +894,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
>  	return target_node;
>  }
>  #else
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	return 0;
>  }
> @@ -913,7 +913,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
>  	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
>  				 TVA_FORCED_COLLAPSE;
>
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		return SCAN_ANY_PROCESS;
>
>  	*vmap = vma = find_vma(mm, address);
> @@ -984,7 +984,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
>
>  /*
>   * Bring missing pages in from swap, to complete THP collapse.
> - * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
> + * Only done if khugepaged_scan_pmd believes it is worthwhile.
>   *
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> @@ -1070,7 +1070,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  {
>  	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>  		     GFP_TRANSHUGE);
> -	int node = hpage_collapse_find_target_node(cc);
> +	int node = collapse_find_target_node(cc);
>  	struct folio *folio;
>
>  	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
> @@ -1255,7 +1255,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	return result;
>  }
>
> -static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> +static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		struct vm_area_struct *vma, unsigned long start_addr,
>  		bool *mmap_locked, struct collapse_control *cc)
>  {
> @@ -1380,7 +1380,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		 * hit record.
>  		 */
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			goto out_unmap;
>  		}
> @@ -1446,7 +1446,7 @@ static void collect_mm_slot(struct mm_slot *slot)
>
>  	lockdep_assert_held(&khugepaged_mm_lock);
>
> -	if (hpage_collapse_test_exit(mm)) {
> +	if (collapse_test_exit(mm)) {
>  		/* free mm_slot */
>  		hash_del(&slot->hash);
>  		list_del(&slot->mm_node);
> @@ -1801,7 +1801,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
>  			continue;
>
> -		if (hpage_collapse_test_exit(mm))
> +		if (collapse_test_exit(mm))
>  			continue;
>
>  		if (!file_backed_vma_is_retractable(vma))
> @@ -2317,7 +2317,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> +static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  		unsigned long addr, struct file *file, pgoff_t start,
>  		struct collapse_control *cc)
>  {
> @@ -2370,7 +2370,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>  		}
>
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			folio_put(folio);
>  			break;
> @@ -2424,7 +2424,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>  	return result;
>  }
>
> -static void khugepaged_scan_mm_slot(unsigned int progress_max,
> +static void collapse_scan_mm_slot(unsigned int progress_max,
>  		enum scan_result *result, struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
>  	__acquires(&khugepaged_mm_lock)
> @@ -2458,7 +2458,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
>  		goto breakouterloop_mmap_lock;
>
>  	cc->progress++;
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		goto breakouterloop;
>
>  	vma_iter_init(&vmi, mm, khugepaged_scan.address);
> @@ -2466,7 +2466,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
>  		unsigned long hstart, hend;
>
>  		cond_resched();
> -		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> +		if (unlikely(collapse_test_exit_or_disable(mm))) {
>  			cc->progress++;
>  			break;
>  		}
> @@ -2488,7 +2488,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
>  			bool mmap_locked = true;
>
>  			cond_resched();
> -			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +			if (unlikely(collapse_test_exit_or_disable(mm)))
>  				goto breakouterloop;
>
>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
> @@ -2501,12 +2501,12 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
>
>  				mmap_read_unlock(mm);
>  				mmap_locked = false;
> -				*result = hpage_collapse_scan_file(mm,
> +				*result = collapse_scan_file(mm,
>  					khugepaged_scan.address, file, pgoff, cc);
>  				fput(file);
>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>  					mmap_read_lock(mm);
> -					if (hpage_collapse_test_exit_or_disable(mm))
> +					if (collapse_test_exit_or_disable(mm))
>  						goto breakouterloop;
>  					*result = try_collapse_pte_mapped_thp(mm,
>  						khugepaged_scan.address, false);
> @@ -2515,7 +2515,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
>  					mmap_read_unlock(mm);
>  				}
>  			} else {
> -				*result = hpage_collapse_scan_pmd(mm, vma,
> +				*result = collapse_scan_pmd(mm, vma,
>  					khugepaged_scan.address, &mmap_locked, cc);
>  			}
>
> @@ -2547,7 +2547,7 @@ static void khugepaged_scan_mm_slot(unsigned int progress_max,
>  	 * Release the current mm_slot if this mm is about to die, or
>  	 * if we scanned all vmas of this mm, or THP got disabled.
>  	 */
> -	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
> +	if (collapse_test_exit_or_disable(mm) || !vma) {
>  		/*
>  		 * Make sure that if mm_users is reaching zero while
>  		 * khugepaged runs here, khugepaged_exit will find
> @@ -2600,7 +2600,7 @@ static void khugepaged_do_scan(struct collapse_control *cc)
>  			pass_through_head++;
>  		if (khugepaged_has_work() &&
>  		    pass_through_head < 2)
> -			khugepaged_scan_mm_slot(progress_max, &result, cc);
> +			collapse_scan_mm_slot(progress_max, &result, cc);
>  		else
>  			cc->progress = progress_max;
>  		spin_unlock(&khugepaged_mm_lock);
> @@ -2845,8 +2845,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			mmap_read_unlock(mm);
>  			mmap_locked = false;
>  			*lock_dropped = true;
> -			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> -							  cc);
> +			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>
>  			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>  			    mapping_can_writeback(file->f_mapping)) {
> @@ -2860,8 +2859,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			}
>  			fput(file);
>  		} else {
> -			result = hpage_collapse_scan_pmd(mm, vma, addr,
> -							 &mmap_locked, cc);
> +			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
>  		}
>  		if (!mmap_locked)
>  			*lock_dropped = true;
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 8566e32d58d9..e9c8b1d05832 100644
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
> --
> 2.53.0
>

