Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5501EC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4BE6B00BA; Mon, 17 Aug 2026 07:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABCD6B00BB; Mon, 17 Aug 2026 07:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B7F6B00BC; Mon, 17 Aug 2026 07:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 168286B00BA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:35:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF90E1603AF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:34:59 +0000 (UTC)
X-FDA: 85110554718.22.2D7F4CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 288CBC0008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:34:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNfLwRIf;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhUYJ0ZuwJek6vTA3gaMgg4QsB61Vmg04/nAHXi8Jj8=;
	b=TOo2Kblvq1A+vji19kzXcV59GFdKIDlLla4a72LPWwrvu0vrpjeY8RG2ee+qJ+2NXQPDd6
	s+jGvF/7AAw4+H1ZtfQpXLSYYDAWoo9FAAmyMn1yUPj7ShXaILca6Hi7dw0uh74G3Se4l8
	ZlufvTI8MytgmPjnaXsaEiV4YOJAEqE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966498;
	b=R/MsnF45Qsk6ALq8GTmWQKa+mVt82ChRsLVks5D5OP8W1bzcfI5OIxPkWPDVa3fQsfCyMd
	Id2zvustilwze5Rt7EL4dhmljhNJnFuzFu7gk94ptJ1xcKEACvSw1YAFTnxC8TPLEluUVF
	78jAJiD5O+99cgWdCgKBXBuO9K1PQjU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JNfLwRIf;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92C13601DE;
	Mon, 17 Aug 2026 11:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91351F000E9;
	Mon, 17 Aug 2026 11:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786966497;
	bh=ZhUYJ0ZuwJek6vTA3gaMgg4QsB61Vmg04/nAHXi8Jj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JNfLwRIfVaBYgaBoNkym1UWIbh/mCvBOZXQeFxobpoFb8TQKZ0rD4diFy6IjGtjih
	 0J77bz+08aLdAQ5M47GBPHjs+f92By9fcMZ+cL2UMsSpCMGX7ECHS0jk5d/5B8ZBvS
	 BvkJHFcD3cSbDvCtwTgsJPH0VZdyTAPz8AxPrm9D26CAVuRvA65Sj9TzEHSD6ev593
	 5+E5Wo49JnNuLKPTNHEnfdGXYSJX7Jla3ORwcMjQephwZOSvosdrmUO7U6QASJEi4O
	 WxNZ3xdQPB8m+unAI8PesxXM0OpACbxw/HaSRbL/DwVJnz4GsFyENQ2xCM1Kdvmmzj
	 bai02Jy5m6VrA==
Date: Mon, 17 Aug 2026 12:34:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 3/7] mm/khugepaged: introduce a count_collapse_event()
 helper
Message-ID: <aoLxhe1-eZ-G-_sF@lucifer>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
X-Rspam-User: 
X-Stat-Signature: rr1rnrtyqysoomt5nrcq9zht5j8hdfsq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 288CBC0008
X-HE-Tag: 1786966497-795090
X-HE-Meta: U2FsdGVkX18Gdz0JhGT9TJ+GGRKuJ28Sk3dbNGruzs/TQC52X+1SMx9kUgT1M/NvKDF0f+onBN3EYZ6LSJ7FhsGW75DCphsBl8YHCzJqj5tCriKnZ7CmpBR+NcuhhuM3iks/VD3br2MSS5tvG+LDZZpKMFUpsUQzBRnS+brWktQC5UnnN72iaG4JbsK3q7k6x4SgfcHrewX+k2nRYYKeywIs6/jYoWTpRC/HPwxCgPNnqA8NvvXjQBrMUUqGxWO1kD0H2bRVSW05p/DxDaNdaMHsotMZX7adB9potJSgwS5hUMwDJBogrQjAp6A2jgH6bgIQJjprHW0nSHEDgdiaWAABTnsPDQK/gvYkgCRQPJVpUdqoKFhh2xo/ELdJv9Y2mESavH7c2cJlaD+Rgc97L2fhCzlymKPA7xR1fnjXVzFjKdqZM3Ep3x+lFcX3MdWhBcjpFPVr/AABKOz6wgqdw2jHrcjsFZR/GFt4s6QG0BG6w8zHivtnYIsN9Zsw2FWHrtIpY3aOtUy0niBLYyuTYQSjL/ttsK2PJI71/X6HOdxeX3RSgggy0seKeg+I56cMCJlzvqp4vpiTCQ5qincsCwOAPdmvGEEy4yEbUT4ONWQIuBzmDSgrzIC9pTVtXw/NfoSC5X+VG1r+JD8CRdW0kqjM/aQkGaI1xFRKT/XdmFRMVTGbnASmr0xpO786GLte6RQztdU0yzh4iMn76PS9ixBB9mSXXUm6juCYEQJ9byDChPahcB8xHe676OLm5MQzoCowYm5JHdigMdyRwp4F07R7TxMiKBoTVwRR00ThNDOfJSZNIVSAOD4MnuhhoSY/eQAUp0TGoCW9/rhs1a+CcAxLZdeCSmxn2Ri16YVw5fLtK6+7h68g2nsUbeTgGwZYJgh738AAjAVsYOw9KFpSHghB+YUT+tvElRcpVtg37m3fBCVv4ntfDkc35jc96CwEfLi66rPZSoOVj3rFLtT
 M6FOIetS
 bFNpuZRzeDsgYN90//byo+ui4LQgTpnR0cyTExa8MKAV062fDUnno4t867crhceH5VEyMWRt2FATqbyUdvXOzgJZzS0M3fiVADMLaQMX5sTfqn9+chszJ8YLl/C5IOCtmlcd8XNxOv9Lu45ir8GsT7IeH+2mpHQkD8YtK6BjANQbtLOd8D19HSaXvxo22mniHwTM4pRYckNK5HjW8RViyKV0gZXGq1hlcC+i56K7igKtSdIsj/LxJ/WrnuYqWk6i34+DPmZ6ltHxu4971uzxOWTL6p7x4Q11fe5lDCDiW7gbMx7VkHHczt07dFVzgJGxKmq6X5++f1LHsjiKwZf62gJEAUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:35AM -0600, Nico Pache (Red Hat) wrote:
> Provide a simple helper function to help reduce a often used, and
> duplicate pattern across the khugepaged code.
>
> When collapsing to a PMD we need to record a vm_event and the mTHP_stat
> event. When doing mTHP collapse we only update the mTHP stat.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8babd4c97db6..cae510aa2914 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -688,6 +688,14 @@ static inline bool folio_pte_referenced(struct folio *folio,
>  	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
>  }
>
> +static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
> +		enum mthp_stat_item mthp_event)

Add a comment! Lol no only joking ;)

> +{
> +	if (is_pmd_order(order))
> +		count_vm_event(vm_event);
> +	count_mthp_stat(order, mthp_event);
> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		unsigned int order, struct list_head *compound_pagelist)
> @@ -708,9 +716,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		if (pte_none_or_zero(pteval)) {
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				if (is_pmd_order(order))
> -					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
> +						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
>  				goto out;
>  			}
>  			continue;
> @@ -752,9 +759,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			 */
>  			if (++shared > max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
> -				if (is_pmd_order(order))
> -					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> -				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +				count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
> +						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out;
>  			}
>  		}
> @@ -1264,15 +1270,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
>  	if (!folio) {
>  		*foliop = NULL;
> -		if (is_pmd_order(order))
> -			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> -		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
> +		count_collapse_event(order, THP_COLLAPSE_ALLOC_FAILED,
> +				     MTHP_STAT_COLLAPSE_ALLOC_FAILED);
>  		return SCAN_ALLOC_HUGE_PAGE_FAIL;
>  	}
>
> -	if (is_pmd_order(order))
> -		count_vm_event(THP_COLLAPSE_ALLOC);
> -	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
> +	count_collapse_event(order, THP_COLLAPSE_ALLOC, MTHP_STAT_COLLAPSE_ALLOC);
>
>  	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
>  		folio_put(folio);
> @@ -1662,9 +1665,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		if (pte_none_or_zero(pteval)) {
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				count_mthp_stat(HPAGE_PMD_ORDER,
> -						MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
> +						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
>  				goto out_unmap;
>  			}
>  			continue;
> @@ -1672,9 +1674,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		if (!pte_present(pteval)) {
>  			if (++unmapped > max_ptes_swap) {
>  				result = SCAN_EXCEED_SWAP_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> -				count_mthp_stat(HPAGE_PMD_ORDER,
> -						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
> +						     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
>  				goto out_unmap;
>  			}
>  			/*
> @@ -1731,9 +1732,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		if (folio_maybe_mapped_shared(folio)) {
>  			if (++shared > max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> -				count_mthp_stat(HPAGE_PMD_ORDER,
> -						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
> +						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out_unmap;
>  			}
>  		}
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

