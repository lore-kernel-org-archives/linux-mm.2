Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85603EF06E3
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 09:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7D86B0089; Sun,  8 Feb 2026 04:17:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355CE6B0092; Sun,  8 Feb 2026 04:17:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2613A6B0093; Sun,  8 Feb 2026 04:17:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15D5D6B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 04:17:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B80AB9D75
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:17:27 +0000 (UTC)
X-FDA: 84420736134.05.30359A1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id D08B1140004
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:17:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770542246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kUa0WTWBkooySK0DjhAIFuTNRyC8/S0DvABWnExttbU=;
	b=WPpWz3/ZBf2qlesq3j0J6GAZj+eE0SOs4+yHJO8OW4rlSbWN2r2PYAtG7njpnPIBdMAiIw
	MxBjW3X0dshdd0vFjo8hwanqKKnH+aFNXgY094XmAtY0lwLJDQk3DZc4iEefJZxe9C14nV
	1sy6Xq7FiS10RtAeU6Mw23R0DVcItnM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770542246; a=rsa-sha256;
	cv=none;
	b=t9IE3eN1LzF+4FlXthudt7+AwzRTU0qkjpTxfTjYgxQd2AbPC5IGURpFquo7sXxppxz+4X
	DR5OSheQ6KV2XB1pG2rfzP/SdFWyd4d9mVRVJ3Dv2UAEHW32t3dMy1oK0NrcqML9a7mX86
	QToOXXry8NewI5ezU1IM6n+7dpiSiWg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83694339;
	Sun,  8 Feb 2026 01:17:18 -0800 (PST)
Received: from [10.164.10.250] (unknown [10.164.10.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D86AC3F740;
	Sun,  8 Feb 2026 01:17:21 -0800 (PST)
Message-ID: <53527839-e918-47d3-9442-cd5e8975ab22@arm.com>
Date: Sun, 8 Feb 2026 14:47:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v7 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
 <20260207081613.588598-3-vernon2gm@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260207081613.588598-3-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D08B1140004
X-Stat-Signature: r64us683qgm37x43e1u6fnku6w1bteyd
X-Rspam-User: 
X-HE-Tag: 1770542245-594840
X-HE-Meta: U2FsdGVkX18j/4W+3PvlHaUmMY7KiBR+Bh2iDuiZX+yadzqhQSpC/keMSw4LKmd0ueV/on5Yu42zzx1hA+CB+TJKaKEC0xsdJHkzGL6YUvNxXCrkkeqSUWBbip9gmlFb7fTtA05Juw6MPz5DIuKptwKtqEROwq0ntsewaYBWJ4ZOk01eRN9K1gMvFYCbOdrdkkjfmpgsF+m8dg4DqdtBvI4wHjIdjInpCBCuaPiArncme4C+DXteiqV1wMc4a+5FmvTuVClivvuThZyz13EuTyKbmPW2P6ZovZ/tzEBXjSmevPnhEkE4bLAdNUsuAiKPIZg6TKjVhB56cizKio7KNOvnj9kgswMTWt/Z4EVumrZzRd/0o0tKW0WqYfIO0e1st99BjSC5MX1k3cCTM7UrcAPW5rR+tDul6+ewa4FtaRVK36lFYLd5Ga+HHi4QtmdkFe43z2nxPUVEmsRosQnzsl+XvYR+kGBbjv3mhW3rVN/q1KWJ/cARFfg44Ug9yAg2qlZ9Acq70PLDfVJK9+hs3idEd//5QYjUoaBdLu6XrRDUV9QG0ueVk2jfoDgvqqvtu5Kbpjn1a6ktx+Kq881mymGy7yx/KvNppmeQrBZstsPfj4208KZpnQh2ZX8GALLFtDlStr1kpu71imUKQmhAp1soED12gQZBcEGuH/IkEbHsGOXZz+ttqDH+2dTT5rrtimP8QxdYbg7ABKPB3vfcqf8VqxmUhvzvJeH/jMzOZwoenr1v898wRK8rE0cWdTvwIsAajGx95nPThE4SVOr4AGaYi8X/d+uFA/DryVVK1JH1FuFjGPN7d5XSTbEzKkNYJlJ8zmvMERyVLSOWvAHIAbTJn+emYXhZQE2t/Xpq4BNylTR9yboLrcb/3Q11mAYWRN+hMT26Dt4fSSsulLo1G6U8Hqo/vTe1MGmmpUE2hR1R9jXOx72VTTGMNuAOchzr05ctZDQsiSlUYOzUkYF
 H7PS+JN0
 JWJFkAA6XC49zKS91K1aqbKmCEbTZBzgx76Zd5PuLI2xy/rr+lyAFrTPewEeoolG7jFLDKUi5GcSNJwDmWhpuQ9gHx2BFgNcLzHjYWgWu5uqZWKcVeYl1kqlwL4UU87eNzOzcGPYaUqQcXs4b9+IPBGYalx53sElYPbGHVbSBn4nrLQ5iH+JXCUpII3Qm1hYeDKOjeQHj4NbClimvz9plYJ7KKofNgVlf7qhB40mYO66tpd5O5iZGdaKsGT2dfPPC0+DbgRov7GAvrTaz02TDLF624Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/02/26 1:46 pm, Vernon Yang wrote:
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
> From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
> following statuses were observed, with frequency mentioned next to them:
>
> SCAN_SUCCEED          : 1
> SCAN_EXCEED_SHARED_PTE: 2
> SCAN_PMD_MAPPED       : 142
> SCAN_NO_PTE_TABLE     : 178
> total progress size   : 674 MB
> Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs
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
> SCAN_EXCEED_SHARED_PTE: 2
> SCAN_PMD_MAPPED       : 147
> SCAN_NO_PTE_TABLE     : 173
> total progress size   : 45 MB
> Total time            : 20 seconds
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  mm/khugepaged.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4049234e1c8b..8b68ae3bc2c5 100644
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
> @@ -1256,19 +1260,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>  
>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> -	if (result != SCAN_SUCCEED)
> +	if (result != SCAN_SUCCEED) {
> +		if (cur_progress)
> +			*cur_progress = 1;
>  		goto out;
> +	}
>  
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
> +		if (cur_progress)
> +			*cur_progress = 1;
>  		result = SCAN_NO_PTE_TABLE;
>  		goto out;
>  	}
>  
>  	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
> +		if (cur_progress)
> +			*cur_progress += 1;
> +
>  		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
> @@ -2288,8 +2300,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
> @@ -2378,6 +2391,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>  			cond_resched_rcu();
>  		}
>  	}
> +	if (cur_progress)
> +		*cur_progress = HPAGE_PMD_NR;
>  	rcu_read_unlock();
>  
>  

Nit: Could move this at the end of the function. Looks weird before the
rcu_read_unlock.

Reviewed-by: Dev Jain <dev.jain@arm.com>


