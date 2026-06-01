Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3960FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B2E6B03BD; Mon,  1 Jun 2026 10:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2A46B03BF; Mon,  1 Jun 2026 10:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620316B03C0; Mon,  1 Jun 2026 10:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD366B03BD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:13:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF54E40535
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:13:45 +0000 (UTC)
X-FDA: 84831537210.22.C87ADD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5B45D14001A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:13:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HGujj4tD;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780323224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiMUoPQVbAq+0Xavfk3WxTvqOCU0qayiHbRRU+6Geak=;
	b=TVynIuob1h8lYh/1usg7HFHajCJxu8xlF8695b4rD2xgcbHwdTXwRC2J+hZTZ7VZwjYjVh
	bERGsGrBx73HvdNuFlwcfTq/1hIDJ6jXEY5+3zl44i4YFDwlONPUlaiFkxytuqXpZ1zEbD
	H3bMHcPGO90XGKFDbX5zUN5zKfQ6uoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780323224; a=rsa-sha256;
	cv=none;
	b=IVOWigfqX+GiAlvUuyBt7cUd3Tmz+Gfi1lD51Tbm0BvdNlwYjUcO1jwnhr6P3R4Rh5PopD
	O7fddxBxz1rUwHIHbA9+sL6PJWlUpXpjRxrIxRdsYgqQL2re/kDF+4JFbbG/f413lCw1Il
	7ZHagNCiTwW1NdPBet+RqdYm3bNKczc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HGujj4tD;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA47E600AA;
	Mon,  1 Jun 2026 14:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA7E1F00893;
	Mon,  1 Jun 2026 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780323223;
	bh=MiMUoPQVbAq+0Xavfk3WxTvqOCU0qayiHbRRU+6Geak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HGujj4tDkadqTA9Q8vNWga74uKYF9W9ayMskIVPbIn5pPH6oxITdEMT2GhUPh1k+n
	 sqDs5jEwPtLZnq1QYz/22DN4VB5+zAWkYvZs30wRNPprt3r82UM/HuoWyfPpsye9kW
	 b9D/JXZ5pztZrfUd2YLKeOWywci2An1XYFTmdO9kpksI3SMlbGT3ZeQpZU5+l6Y7ed
	 3ClUukjPJTkQJtxZ9N4hREXHZTTqGNQzeNlWJLr4+75uUDnwo1Rp3cBiTwm6n6S2EH
	 4Agp83sUSHwwN6a2Q1i8nFlUgKXAdZR+4l4N+/p0C6aWUDoUwfL8BvInhzGZG4wfka
	 am9uNQNtvTgng==
Date: Mon, 1 Jun 2026 15:13:28 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 08/14] mm/khugepaged: add per-order mTHP
 collapse failure statistics
Message-ID: <ah2TDTIrpw0dd2zg@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-9-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522150009.121603-9-npache@redhat.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: p9yje4cpuig7tri83ftebbwb4cnf8mbj
X-Rspamd-Queue-Id: 5B45D14001A
X-Rspam-User: 
X-HE-Tag: 1780323224-87450
X-HE-Meta: U2FsdGVkX1+VTb2FTKCIIswNdzY0mNhimswL6bfH4ZDDosiiO4fc45TewoXITeecVMPGWeXbjdU4SdyczQJ730AkE6zJIs0IUuEzw4vw8nMC5xRcgaOtBDGDA22Gmrv+fE9XlY8PnF/q64ueFOTpWsW0viiCrmYUWyf5HgFqJfho+6bz1daPA22nsRxnWts0/D/lIvjbVpCqiECF0zTBCgbGuitwdlcpjH5EchR4/NwQlnU7jABge0OdmYRNv7M12uTTEn3owYODsM4Kduqo8gWiolfAzR3TPpHUg5HxI3jibiUZy/ucFi77k9SphdRFOk7q5D+57S9skskjVsQNuO9NdEmnMdD3jqMhpip0N6qcIOXF0OQuu0TEuz1o+f6vhTY7C5wdVnqdMztj/PFD3OT/2JAwtdjT73cmlat9TqErIbsCzDmT+dMnYaEFE1PXBxKJRSWg25ueQzI/3ygZGM3gN+sptU4KOBVmdw3ORsNqRqn7dsLIKVFWx0OZQpWc5ZVutjfMtaDk9BHbieP6I6Tt8FfLH9Qf/GByt4mdmKP5rDnXXok320N33A34j9ACcFKZ7fvydlyjFQH7A6d79ntlleYMyUj3YLPHt6qnhBmIQH9CveMBxmmvuxMofq0ats8v41X35F93u/LyePxvj39pWV1xj481rRmCifWfTaDtN8yYEN5Ahq2V3F5+ql+sDYlViS7epvGJEG9y2wzQZPlY1yZweW8rPkNFB0zNHDjjN5Hd67Y6YQ2RYkmAqMTUfK9SDlGHlAmNMgoP5QOgqDkEPX9kDU5aW5WxxPpGVp1efQigMnGwWG1fa7QBQpzVLiUdB7gZXeSvG+4BihNKLWVJhMfGKTGNuIyjE+VOyjcKqkX/M9Lko+kl4B0+Yvc6ykn4saPPVb50MRsOxpBTKDLmZMaZR+o82jz4Alb5FGdLGNe7JOytwOgEUg2ixF+g1gZFY9jEWLj/1tnox+K
 FeROv2rz
 tUHKlXS5hXotKBQ3A9gS92Bwo/Cy1tUok2qD11S/xhftmnwAzsqGQwzf259sLNCy5LV1bqGw+VOWftusl85/tBA4bzRBK0rmVYRAOEUclAanrZeu40gySGSLwjmmBpXMRHqffb/iUl/sT10aza3pPx14o7PHAIOHYcCBFCF5TEDBnn0Ir5W+LTxFB52D+SoA0W4b+JhW2Ws8TE0lGWwVaOefa1H5cn1Csp/TLPisIWXKHcuzuGPJnrzuDHpaDLYBDkO4e5G+J7RP7etCJUhDXFK9g6oxSOZwWrr29nJk3hBM0FyaOq6/pLLutzkLuT11Cin30fgUFB1Tqz8wn8hKKhYxjDQIy0ZGrp1EZ4SADo6jeM5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 09:00:03AM -0600, Nico Pache wrote:
> Add three new mTHP statistics to track collapse failures for different
> orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
>
> - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to
> 	encountering a swap PTE.
>
> - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>   	exceeding the none PTE threshold for the given order
>
> - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to
> 	encountering a shared PTE.
>
> These statistics complement the existing THP_SCAN_EXCEED_* events by
> providing per-order granularity for mTHP collapse attempts. The stats are
> exposed via sysfs under
> `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
> supported hugepage size.
>
> As we currently do not support collapsing mTHPs that contain a swap or
> shared entry, those statistics keep track of how often we are
> encountering failed mTHP collapses due to these restrictions.
>
> We will add support for mTHP collapse for anonymous pages next; lets also
> track when this happens at the PMD level within the per-mTHP stats.
>
> Signed-off-by: Nico Pache <npache@redhat.com>

Logic LGTM, small comment below, but otherwise:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  Documentation/admin-guide/mm/transhuge.rst | 14 ++++++++++++++
>  include/linux/huge_mm.h                    |  3 +++
>  mm/huge_memory.c                           |  7 +++++++
>  mm/khugepaged.c                            | 21 +++++++++++++++++++--
>  4 files changed, 43 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index c51932e6275d..80a4d0bed70b 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -714,6 +714,20 @@ nr_anon_partially_mapped
>         an anonymous THP as "partially mapped" and count it here, even though it
>         is not actually partially mapped anymore.
>
> +collapse_exceed_none_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_none threshold.
> +
> +collapse_exceed_swap_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_swap threshold. For non-PMD orders this occurs if a mTHP range
> +       contains at least one swap PTE.
> +
> +collapse_exceed_shared_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_shared threshold. For non-PMD orders this occurs if a mTHP range
> +       contains at least one shared PTE.
> +
>  As the system ages, allocating huge pages may be expensive as the
>  system uses memory compaction to copy data around memory to free a
>  huge page for use. There are some counters in ``/proc/vmstat`` to help
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index ba7ae6808544..48496f09909b 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -144,6 +144,9 @@ enum mthp_stat_item {
>  	MTHP_STAT_SPLIT_DEFERRED,
>  	MTHP_STAT_NR_ANON,
>  	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> +	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> +	MTHP_STAT_COLLAPSE_EXCEED_NONE,
> +	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
>  	__MTHP_STAT_COUNT
>  };
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 345c54133c83..5c128cdec810 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -703,6 +703,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
>  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
>  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
>  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +
>
>  static struct attribute *anon_stats_attrs[] = {
>  	&anon_fault_alloc_attr.attr,
> @@ -719,6 +723,9 @@ static struct attribute *anon_stats_attrs[] = {
>  	&split_deferred_attr.attr,
>  	&nr_anon_attr.attr,
>  	&nr_anon_partially_mapped_attr.attr,
> +	&collapse_exceed_swap_pte_attr.attr,
> +	&collapse_exceed_none_pte_attr.attr,
> +	&collapse_exceed_shared_pte_attr.attr,
>  	NULL,
>  };
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 928e32a0d4d7..fff6a8fbf1d4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -649,7 +649,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		if (pte_none_or_zero(pteval)) {
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				if (is_pmd_order(order))
> +					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
>  				goto out;
>  			}
>  			continue;
> @@ -683,9 +685,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>
>  		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
> +			/*
> +			 * TODO: Support shared pages without leading to further
> +			 * mTHP collapses. Currently bringing in new pages via
> +			 * shared may cause a future higher order collapse on a
> +			 * rescan of the same range.
> +			 */

Seems weird to add this comment in a stats update patch?

Not a massively big deal but maybe worth moving to the relevant commit.

>  			if (++shared > max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				if (is_pmd_order(order))
> +					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out;
>  			}
>  		}
> @@ -1138,6 +1148,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>  		 * range.
>  		 */
>  		if (!is_pmd_order(order)) {
> +			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
>  			pte_unmap(pte);
>  			mmap_read_unlock(mm);
>  			result = SCAN_EXCEED_SWAP_PTE;
> @@ -1433,6 +1444,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				count_mthp_stat(HPAGE_PMD_ORDER,
> +						MTHP_STAT_COLLAPSE_EXCEED_NONE);
>  				goto out_unmap;
>  			}
>  			continue;
> @@ -1441,6 +1454,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			if (++unmapped > max_ptes_swap) {
>  				result = SCAN_EXCEED_SWAP_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> +				count_mthp_stat(HPAGE_PMD_ORDER,
> +						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
>  				goto out_unmap;
>  			}
>  			/*
> @@ -1498,6 +1513,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  			if (++shared > max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				count_mthp_stat(HPAGE_PMD_ORDER,
> +						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out_unmap;
>  			}
>  		}
> --
> 2.54.0
>

