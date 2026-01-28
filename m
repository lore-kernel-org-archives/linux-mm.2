Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5407BD35692
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 08:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4282B6B0088; Wed, 28 Jan 2026 03:29:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5416B0089; Wed, 28 Jan 2026 03:29:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7F36B008A; Wed, 28 Jan 2026 03:29:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8CE6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:29:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6336759188
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:29:42 +0000 (UTC)
X-FDA: 84380699004.22.5A6B981
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3756240008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:29:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769588980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZiE3lgcnnLKUOYzheNLafiNZCIsZbJNSirGk0ukU9I=;
	b=UNbqjl1lVcOE4XZhoOYZItLD1HZ9WYkHMvLVY93PFhcFjfzy8XCj7B+CYhdMd2IigiT4vn
	YyAiI4M1fUoRsD5muymM8k9WgWWGyCzWs9lQEBmi+1droxz9hXRMEOrZDkfte247L2ojRO
	3ekZDGaZsNKz2XbORAeOM/bxgHOWB6Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769588980; a=rsa-sha256;
	cv=none;
	b=iPfu5c6N+xTCrFJmm2o6syi2Nws9H9RtfFAreOpgAHBwz3WZsjsZPhd0GI9y0gMwwV4gXs
	onPdXuWuemVRrwlUj06y6LpEqV8j4SnVphj2UoK/xFG5ncSBNo9JYAQGjX1TVLwnms1Fyh
	CBuSZm3BLN6u+HwhPrbnS2uQUa8LZew=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 875A11515;
	Wed, 28 Jan 2026 00:29:32 -0800 (PST)
Received: from [10.164.18.94] (unknown [10.164.18.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DECA3F5CA;
	Wed, 28 Jan 2026 00:29:36 -0800 (PST)
Message-ID: <72dfd11f-dca4-447e-89c5-7a87cb675bda@arm.com>
Date: Wed, 28 Jan 2026 13:59:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-3-vernon2gm@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260123082232.16413-3-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3756240008
X-Rspamd-Server: rspam07
X-Stat-Signature: iitcg3ju1z3mbf8gonyu3w9her7s1133
X-HE-Tag: 1769588980-215940
X-HE-Meta: U2FsdGVkX19vnK2pck1l+Mtb6LmjpZZ22CECUINl1H4ZJ/ye2iIopmn/OmEdlhtD6UnDjiKi+3FU3AqKikITSM20AOwITH2ds6BsUlHSOb9e+pkiuKa/fAjygn216w9PjY2SB4DfOZTGvnWJsgB/vf/QbwAfeSgi5lwCecKCMjWRCdQ7IANpf81F+R1X0HSMsEQYatiNzzMzG9jvBfqIe7ptE4tjindQ7jHq3MTIWmpnbrzCr/EadiFSfM56cNtwe2AqewVcdSh8wPstkVKFIdUNZ7e3NHoziKJG+jCeQpzkBumWp+Z6N2yMNEJGHgjfWkcieZmat+o/ADmYEmr6n8EjcpJGn+xx9uG+KYrD+JCwX1CL5P0iP/MnNCNLcrKtpCnQjcSY/oanzSoCJwnC/Cjd1MZiDD73h6fnuvTA3Xn9Vq+NmPaEkGMqIQikAiaG0/q35TNcO6qBewWslrzVGFuawceeiEt+5b2HD7FShSAa0ZeNQ3SO+iNbPVQuS8szboq4ysnMKQDGUZGT2IXQhDwsvcuxCHUGwgozGv63LltK1BBffs6iKPRAS85NT57GvYbM1FiKvgL29znvvny/+W+UL+XxW2BeznKJHmdGCsFjKLFJj3bJlRi4gNH7wCtZZQmthYnyuR2xF2dExO9tHwahvfGsGRUPVvmAf1LUukLJtUFgEnuSPpWXHkJ0+sm+ejtfeh7qYy3h7IwYHVpAJWQaVB0nDBiFA4sCb/5VB0NHv7f+T7xjI3ToMAn5eGuABV0JvGphbjRV4zfPVUiVgzDpCNsj4B07pEvxz86btiWVs65st5oyE9zPAFh6hiojuOP4TwSYqYFwLnO2vsJsO7ooLS7BYA1EfvTLsPP32qa0pWGNMCJklAvUseZ8JOVLZtHeXbV1Kls9zGYMGJpVPBSez86Xb+fUmBHXxdmgGHUbWcl8tlOhn1azzXIR3KaGHR8IRBlXidFbXTCruVZ
 SPrropWV
 hxNV7Om1d9e8RlGH/lmfZKbLC9fEuMmzuDybkYE/jEPtLolEFu3oirhnLpoUtEmfOytVtPi63H7ZhTGKBVBAXRoGqZvRkqL2Tnd+iDjcBzIPa+ZrFbzhrDgU0P7ATCuQDMiYQuR/eFqjsJrvxIK0Zp3hvyciOOlbiT5aKOZNPy89tBaYad1NFSK2mSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23/01/26 1:52 pm, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> even if only scanning a single PTE/PMD entry.
>
> - When only scanning a sigle PTE entry, let me provide a detailed
>   example:
>
> static int hpage_collapse_scan_pmd()
> {
> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> 	     _pte++, addr += PAGE_SIZE) {
> 		pte_t pteval = ptep_get(_pte);
> 		...
> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
> 			result = SCAN_PTE_UFFD_WP;
> 			goto out_unmap;
> 		}
> 	}
> }
>
> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> directly. In practice, only one PTE is scanned before termination.
> Here, "progress += 1" reflects the actual number of PTEs scanned, but
> previously "progress += HPAGE_PMD_NR" always.
>
> - When the memory has been collapsed to PMD, let me provide a detailed
>   example:
>
> The following data is traced by bpftrace on a desktop system. After
> the system has been left idle for 10 minutes upon booting, a lot of
> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> by khugepaged.
>
> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE

Could you elaborate what is [1], [6] etc and 1,2,142, etc?

> total progress size: 674 MB
> Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs
>
> The khugepaged_scan list save all task that support collapse into hugepage,
> as long as the task is not destroyed, khugepaged will not remove it from
> the khugepaged_scan list. This exist a phenomenon where task has already
> collapsed all memory regions into hugepage, but khugepaged continues to
> scan it, which wastes CPU time and invalid, and due to
> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> scanning a large number of invalid task, so scanning really valid task
> is later.
>
> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> SCAN_NO_PTE_TABLE, just skip it, as follow:
>
> @scan_pmd_status[6]: 2
> @scan_pmd_status[3]: 147
> @scan_pmd_status[2]: 173
> total progress size: 45 MB
> Total time         : 20 seconds
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  include/linux/xarray.h |  9 ++++++++
>  mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
>  2 files changed, 47 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index be850174e802..f77d97d7b957 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
>  	xas->xa_node = XAS_RESTART;
>  }
>  
> +/**
> + * xas_get_index() - Get XArray operation state for a different index.
> + * @xas: XArray operation state.
> + */
> +static inline unsigned long xas_get_index(struct xa_state *xas)
> +{
> +	return xas->xa_index;
> +}
> +
>  /**
>   * xas_advance() - Skip over sibling entries.
>   * @xas: XArray operation state.
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6f0f05148765..de95029e3763 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -68,7 +68,10 @@ enum scan_result {
>  static struct task_struct *khugepaged_thread __read_mostly;
>  static DEFINE_MUTEX(khugepaged_mutex);
>  
> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> +/*
> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> + * every 10 second.
> + */
>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>  static unsigned int khugepaged_pages_collapsed;
>  static unsigned int khugepaged_full_scans;
> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  }
>  
>  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
> +		struct vm_area_struct *vma, unsigned long start_addr,
> +		bool *mmap_locked, unsigned int *cur_progress,
>  		struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
> @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>  
> +	if (cur_progress)
> +		*cur_progress += 1;

Why not be a little more explicit, and do this addition if find_pmd_or_thp_or_none fails,
or pte_offset_map_lock fails? The way you do it right now is not readable - it gives no
idea as to why on function entry we do a +1 right away. Please do add some comments too.

> +
>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out;
> @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		result = SCAN_SUCCEED;
>  	}
>  out_unmap:
> +	if (cur_progress) {
> +		if (_pte >= pte + HPAGE_PMD_NR)
> +			*cur_progress += HPAGE_PMD_NR - 1;
> +		else
> +			*cur_progress += _pte - pte;
> +	}
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
>  		result = collapse_huge_page(mm, start_addr, referenced,
> @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>  
> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> -		struct file *file, pgoff_t start, struct collapse_control *cc)
> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> +		unsigned long addr, struct file *file, pgoff_t start,
> +		unsigned int *cur_progress, struct collapse_control *cc)
>  {
>  	struct folio *folio = NULL;
>  	struct address_space *mapping = file->f_mapping;
> @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>  			cond_resched_rcu();
>  		}
>  	}
> +	if (cur_progress) {
> +		unsigned long idx = xas_get_index(&xas) - start;
> +
> +		if (folio == NULL)
> +			*cur_progress += HPAGE_PMD_NR;

I think this whole block needs some comments. Can you explain, why you
do a particular increment in each case?

> +		else if (xa_is_value(folio))
> +			*cur_progress += idx + (1 << xas_get_order(&xas));
> +		else if (folio_order(folio) == HPAGE_PMD_ORDER)
> +			*cur_progress += idx + 1;
> +		else
> +			*cur_progress += idx + folio_nr_pages(folio);
> +	}
>  	rcu_read_unlock();
>  
>  	if (result == SCAN_SUCCEED) {
> @@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  
>  		while (khugepaged_scan.address < hend) {
>  			bool mmap_locked = true;
> +			unsigned int cur_progress = 0;
>  
>  			cond_resched();
>  			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> @@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  				mmap_read_unlock(mm);
>  				mmap_locked = false;
>  				*result = hpage_collapse_scan_file(mm,
> -					khugepaged_scan.address, file, pgoff, cc);
> +					khugepaged_scan.address, file, pgoff,
> +					&cur_progress, cc);
>  				fput(file);
>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>  					mmap_read_lock(mm);
> @@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  				}
>  			} else {
>  				*result = hpage_collapse_scan_pmd(mm, vma,
> -					khugepaged_scan.address, &mmap_locked, cc);
> +					khugepaged_scan.address, &mmap_locked,
> +					&cur_progress, cc);
>  			}
>  
>  			if (*result == SCAN_SUCCEED)
> @@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
> -			progress += HPAGE_PMD_NR;
> +			progress += cur_progress;
>  			if (!mmap_locked)
>  				/*
>  				 * We released mmap_lock so break loop.  Note
> @@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			mmap_locked = false;
>  			*lock_dropped = true;
>  			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> -							  cc);
> +							  NULL, cc);
>  
>  			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>  			    mapping_can_writeback(file->f_mapping)) {
> @@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			fput(file);
>  		} else {
>  			result = hpage_collapse_scan_pmd(mm, vma, addr,
> -							 &mmap_locked, cc);
> +							 &mmap_locked, NULL, cc);
>  		}
>  		if (!mmap_locked)
>  			*lock_dropped = true;

