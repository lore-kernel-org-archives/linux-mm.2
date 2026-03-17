Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD1BFED9EC
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77586B0005; Tue, 17 Mar 2026 13:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F566B0088; Tue, 17 Mar 2026 13:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65946B0099; Tue, 17 Mar 2026 13:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B523C6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:05:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47D9A1602BA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:05:45 +0000 (UTC)
X-FDA: 84556181850.04.FC0574F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A070140013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:05:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ebClFaVM;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773767143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysQ4VswjfRcEeiuFNAj0ItJBv+2+nnqbC1PAyMUueW8=;
	b=lOTOoiAoMNlBFMzTGg0WY0SP7Nf7CWsmOW22njJx/YI22YRWdZ28gTMnKWiT50ll493rQe
	Kbxj5sfYISuEDf1rTHYC5+CE8eQSdC3xF1V8ZuCBGFY16sQ9g3K2lgJSU7UvHNlHbmqDoO
	GUYn7HY8kCTAodg8Jh8jlIsyWk5BUEA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ebClFaVM;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773767143; a=rsa-sha256;
	cv=none;
	b=KKzmSXOATVMh6EmYDBP/2XGXfDVsxto1WcLvAyo0b4BjqPPHcqnFbaSa7leduOwWFVRNtM
	Iu4w+ZtKqZSpOpMLvnX05pb8ukJuBDmcH17sIgREcUjk61DPaX2W/ATHAoD3st1tBcwyWr
	UEI482fxzAuvVjuw4jMw/I0sU6zaAc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4ACF60008;
	Tue, 17 Mar 2026 17:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67F4C4CEF7;
	Tue, 17 Mar 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773767142;
	bh=ZP3HMEHUzi4atDgmrvVHmp93FHNmI+cfz5qg5zy80B0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ebClFaVMzooBcPtbo04v+c2iW8qVnDLMoSLssgsGRbP+lvvi3eEsUIoA1bpWdaKE6
	 bt0BnW6KMl3/+ln5YSMxUeCWZNMdmke+PqUMWZYAW+EO9+c+Fvobw/LGuXkwx54Zh6
	 8BhkF37g1OKFH8zBznJW4zTNYkrJSJdOTf5v2kLbSoytTcqBkWExoj1hGordONksk5
	 4jS1pJsBSU/0JnEsoCSWj3ljxANhZnfTJ4ysCVx8VbqI3L600siJV+LU+fKEXJGaDi
	 tQIN4AV23McEOpvB3Jz5qBW3hNtBJfGQMdZ5WIUiTS9/dP4tpksQxzlWJ1fjpmpX/P
	 4qUi7dTufrF0g==
Date: Tue, 17 Mar 2026 17:05:40 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 07/13] mm/khugepaged: add per-order mTHP
 collapse failure statistics
Message-ID: <c832d503-8b8c-487a-b61a-df74a3057308@lucifer.local>
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032504.233594-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226032504.233594-1-npache@redhat.com>
X-Rspamd-Queue-Id: A070140013
X-Stat-Signature: fdydqq57yzb19cfrbxwcwaxfp9zpemgt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773767143-953820
X-HE-Meta: U2FsdGVkX1/y6NfjiiBNmaA9BqVpVs/oGx3Ok8VIoRteLWrBax6eatyPxyPBfDCSDso1QDrNVkcvl6esrJGsoPqyFa5tY8A2uF225Eu2rIPn/1SBgrMekZgzXZLvRO1xpY5qzrAR0UE2wK0r1lHYmcG2SxAJOSFrXyuWNgEeuSGLbN9DE39ievkBjtMbfFjIWri3kCsr+xtRrDoinKARB1FAKfLRY6fx6mnszbCwONJQDD2zq/cpJo1zsrvDeVSKJXxmA9oeolHrFGim6zxuSbHSyxv2R870PSm7dbPsCRvTiKFmrihqncIY26E3/4ziSGl1W4xGKjK6CwcMeYurNvqI7mxP9a9RrnF53WID95WU7plhk5uTDBdWMJDE4CX5Qqq87HlatGY9tI2e06kYwESwZiolz2wsjDqWpWbJ0rnek/6mCLuf/1R++zzhsMW0wQe3TGAGbanyVt1pTTKjgCK2otB5fj03hXtFasliwqhg2RcYZQcb94esE0N4hDZeYha/AETuYQlnrwKdOVmVJWev874xTxw/FhG+Ih0cXH6B6OW2JdCjzd6GWemPYPevvXSvna/na7m6OvfZLOHgBPso/BL1uxPSnsjFIpjHcZSzpAAaX/CfmPBdI6Regpb8EivS4S9iT29AJAKJmlROISpTXSnJ9jQPSYGoOeyNkefnM2XVRQNlS0vREK4n871IAymAk2qzYJGitaed6C8x07fs2R2v4bzCDwtzdM541wS4zF5OvmJRvtPogX7pE2g8zHDkgDLW4qcx1bnCzt5U9xNfUuhP21RI83DYQas3KPwPgNGRPht1AfzY5KhrqJxJCF6v471+zVdYI8JmIMiyEccWg2Tnllk0czFhAn2z6Zqkg0GJICjiKGw8eQkRiEzpiwKdrW34PzoaCFkvs1jemUTTDeZ1HTWDOwC9BGxKScXuWrGRh9f7pIE96ce/Thcwh89xlub7Zsfk11vOeGr
 3cj3Rz5l
 /zITTdRXMN8xb7buz8Kfs5Nl+WBZmd/YupDFM65SOAXO77rB31L7xVxbM9uuhtkXFFNmxbZxlqHdcoKHgaF34auy/w00nqmQFGKy+htD1M86FUwke5NsGI8Ll62fqWspN/pc+USEYRIseosGP8SoyAesk2QWrYqpPjSf01Afv24FJf+RtFVRCyvwJ/m7TI3XK26Jt2MWQf+v0qZtcsppWsmSA0lO2EF00jOmHsJYScGSfCpQ+SOYe4UXBbEVs6IMhqKROdscJepGzkzZxg/udOumB9zAOFv9RnbbjnZuaon668yc4ZfMiL0s1Rertf/zjH6ioz1sMuZSO1HM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:25:04PM -0700, Nico Pache wrote:
> Add three new mTHP statistics to track collapse failures for different
> orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
>
> - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
> 	PTEs
>
> - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>   	exceeding the none PTE threshold for the given order
>
> - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
>   	PTEs
>
> These statistics complement the existing THP_SCAN_EXCEED_* events by
> providing per-order granularity for mTHP collapse attempts. The stats are
> exposed via sysfs under
> `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
> supported hugepage size.
>
> As we currently dont support collapsing mTHPs that contain a swap or
> shared entry, those statistics keep track of how often we are
> encountering failed mTHP collapses due to these restrictions.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 24 ++++++++++++++++++++++
>  include/linux/huge_mm.h                    |  3 +++
>  mm/huge_memory.c                           |  7 +++++++
>  mm/khugepaged.c                            | 16 ++++++++++++---
>  4 files changed, 47 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index c51932e6275d..eebb1f6bbc6c 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -714,6 +714,30 @@ nr_anon_partially_mapped
>         an anonymous THP as "partially mapped" and count it here, even though it
>         is not actually partially mapped anymore.
>
> +collapse_exceed_none_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_none threshold. For mTHP collapse, Currently only max_ptes_none
> +       values of 0 and (HPAGE_PMD_NR - 1) are supported. Any other value will
> +       emit a warning and no mTHP collapse will be attempted. khugepaged will

It's weird to document this here but not elsewhere in the document? I mean I
made this comment on the documentation patch also.

Not sure if I missed you adding it to another bit of the docs? :)

> +       try to collapse to the largest enabled (m)THP size; if it fails, it will
> +       try the next lower enabled mTHP size. This counter records the number of
> +       times a collapse attempt was skipped for exceeding the max_ptes_none
> +       threshold, and khugepaged will move on to the next available mTHP size.
> +
> +collapse_exceed_swap_pte
> +       The number of anonymous mTHP PTE ranges which were unable to collapse due
> +       to containing at least one swap PTE. Currently khugepaged does not
> +       support collapsing mTHP regions that contain a swap PTE. This counter can
> +       be used to monitor the number of khugepaged mTHP collapses that failed
> +       due to the presence of a swap PTE.
> +
> +collapse_exceed_shared_pte
> +       The number of anonymous mTHP PTE ranges which were unable to collapse due
> +       to containing at least one shared PTE. Currently khugepaged does not
> +       support collapsing mTHP PTE ranges that contain a shared PTE. This
> +       counter can be used to monitor the number of khugepaged mTHP collapses
> +       that failed due to the presence of a shared PTE.

All of these talk about 'ranges' that could be of any size. Are these useful
metrics? Counting a bunch of failures and not knowing if they are 256 KB
failures or 16 KB failures or whatever is maybe not so useful information?

Also, from the code, aren't you treating PMD events the same as mTHP ones from
the point of view of these counters? Maybe worth documenting that?

> +
>  As the system ages, allocating huge pages may be expensive as the
>  system uses memory compaction to copy data around memory to free a
>  huge page for use. There are some counters in ``/proc/vmstat`` to help
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 9941fc6d7bd8..e8777bb2347d 100644
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
> index 228f35e962b9..1049a207a257 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -642,6 +642,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
>  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
>  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
>  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);

Is there a reason there's such a difference between the names and the actual
enum names?

> +
>
>  static struct attribute *anon_stats_attrs[] = {
>  	&anon_fault_alloc_attr.attr,
> @@ -658,6 +662,9 @@ static struct attribute *anon_stats_attrs[] = {
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
> index c739f26dd61e..a6cf90e09e4a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -595,7 +595,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				if (is_pmd_order(order))
> +					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);

It's a bit gross to have separate stats for both thp and mthp but maybe
unavoidable from a legacy stand point.

Why are we dropping the _PTE suffix?

>  				goto out;
>  			}
>  		}
> @@ -631,10 +633,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			 * shared may cause a future higher order collapse on a
>  			 * rescan of the same range.
>  			 */
> -			if (!is_pmd_order(order) || (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared)) {

OK losing track here :) as the series sadly doesn't currently apply so can't
browser file as is.

In the code I'm looking at, there's also a ++shared here that I guess another
patch removed?

Is this in the folio_maybe_mapped_shared() branch?

> +			if (!is_pmd_order(order)) {
> +				result = SCAN_EXCEED_SHARED_PTE;
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +				goto out;
> +			}
> +
> +			if (cc->is_khugepaged &&
> +			    shared > khugepaged_max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out;

Anyway I'm a bit lost on this logic until a respin but this looks like a LOT of
code duplication. I see David alluded to a refactoring so maybe what he suggests
will help (not had a chance to check what it is specifically :P)

>  			}
>  		}
> @@ -1081,6 +1090,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>  		 * range.
>  		 */
>  		if (!is_pmd_order(order)) {
> +			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);

Hmm I thought we were incrementing mthp stats for pmd sized also?

>  			pte_unmap(pte);
>  			mmap_read_unlock(mm);
>  			result = SCAN_EXCEED_SWAP_PTE;
> --
> 2.53.0
>

Cheers, Lorenzo

