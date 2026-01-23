Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D562D7236E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 10:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9964E6B04A9; Fri, 23 Jan 2026 05:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DD56B04AA; Fri, 23 Jan 2026 05:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89ABD6B04AB; Fri, 23 Jan 2026 05:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 771B76B04A9
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:46:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE9D614011D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:46:25 +0000 (UTC)
X-FDA: 84362899530.18.5D46C9E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D38EA0006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:46:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769165184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kBumdW4G4rQUwPI9F/CAPY0hcf7TepnggMrILKZfPjQ=;
	b=Fo8yY+97xCB3erjZCXiSHlWgKuNS3bz0wQ61N6vu0HkfLee5XDCrP2z+OzNiLEz2MLfPcp
	BAsYdN5I8wOX/RNLyeEW7wTJPYnjW69FwuYMeFZYVgpVOGV7lAfLAahNeFGXtMtgn3DHqQ
	MjawhJ78t7Pbf2AZGuTMrPqBUMyvUrs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769165184; a=rsa-sha256;
	cv=none;
	b=TcHA45a8UIAklE584irZjWksxdVGYqA+sUHvMie/kqYNhOi8hqu7N1NJPdj1qkiZCNBWIC
	XPuctohAOTLCeH5CTE+koHQFU/GS1PZrs8dOxWKvHnn2EZW0iL7ykh/w/MBiBqvB2S13lo
	rjJuaf5Y1yn/eAmZJyE0Mvow59Iqdr0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AE211476;
	Fri, 23 Jan 2026 02:46:16 -0800 (PST)
Received: from [10.164.136.38] (unknown [10.164.136.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B12DB3F740;
	Fri, 23 Jan 2026 02:46:19 -0800 (PST)
Message-ID: <98bdfd16-cb50-47a8-999a-bbd9829c6350@arm.com>
Date: Fri, 23 Jan 2026 16:16:16 +0530
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
X-Stat-Signature: umyfxsc94jxrtzhrwomyezxo37zohzn9
X-Rspamd-Queue-Id: 0D38EA0006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769165183-695055
X-HE-Meta: U2FsdGVkX1/rckXtzuz16fF2sxytkQeqOEWNtm05V5xhb9UHfxPRxSwiCq6JNU3Dxqfrnc7F+4TPrsR+8kKWFdaiJi+9tHKxk56PagOeVeSLeAJHUCAShRbzoSBcZtLTh+ZSs6D3Z+5mGbDu2T+IY1geFdEa5tCqZq/+jwO+j+5CB461mkq6VtgcW8gip4MPgo9LVWgmg1WLTgHyE6y/2GtoBAWGLnH5KgsKwxacp6TU7D9W4rEi/xpWh/T6Qzg/Xw464fw5hXjM5+ydRt5g9KldQQ2FEczVAUwCRq/HJ0bkGk8OhKQmp6eqsvLEUAQtIxQXRlEY5jsrDvEPyMxfznizq0eTSYCb9dEYzMkb2ONIUGFwFSs7UT8uZuGLH0AT4bYKp06kW/6iUiRXZ8iO6MQfI91oMkt3sZUtztJ8la89k2Rbu1Mwm8xRWgtluS7wWB4FbMVcH9ehgaNi7JKoSnQqLnD3zndQo+4uzy6jfEX+xsRyeJYIQ/PM3YFs4XYT6cFXE/HoHlyQpwKf0vyCRV0S13p71bU39/Shgl/ZoaL+VWArIzXk76R6Ef5+FbATAcMhH8MJMvIeSbzgZXYA/DHpuCbj/5lL/WwJs2I6k2DSJZvRp/wqe8Ci/Y2KFSRsXu5FLrnfBmWctItk4+w2roMXfZoQk3hPRVBVQ/I9LuSEdQr+5wsV5JJfjbFMUpuX0lCCLuOOIFbFMu/1oAsraepZIvfpm3M842PeVXTcMd2gQUs2pOSSfK69ZPRSWrRRJJjZ0XmJxZk3N1IpRKZYF4T/PZARDHWpYcMxT2wO+zhbMjCdGjXzvott2yKtkW7nSa898Qr63imrCBaAsKBrZ0hJ7hliqrPoMDkvYbfc76DAYWb/iIJef4JI6dz6z+YrSobWYsOmXG75RiYBfCurYxlr6AOw0BAZGVhmOKGheqJ1mGBX8xjnrn+FySBtt4xuafAbyTWDyQZEKWM4ME8
 qLPIISQt
 R1jzFu1TBo7x71SxLVWIK1sACnfsMR/R8BVvqp7bxkQkprjx00hWflsPxGBoeNOcCa1/7FWvEVFnTE4mx4dwEInyKj8PU6yP3NfCENe0YvP1EYIWTvKuUMJHrRMGZ+GgQjEyPiGbFK5lWu8WIRwtgujcLdq99GK9j0D4sVxcVZmygd7l9LilXFAhDfQ==
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

Why is this needed?

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
> +

1. Why do we need to do if (cur_progress). Isn't it guaranteed that the pointer will never be NULL.
2. Why do we increment this on function entry?

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

Why are two cases required here - shouldn't it just be _pte - pte?

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

