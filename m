Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA78D49C6F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 08:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358746B0005; Fri, 30 Jan 2026 03:11:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305DF6B0089; Fri, 30 Jan 2026 03:11:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212046B008A; Fri, 30 Jan 2026 03:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D36C6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:11:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A01813B2B4
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:11:06 +0000 (UTC)
X-FDA: 84387909732.11.357180C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id C165740003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:11:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769760664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1sEMTqbHNBpsjkGlerGB0JojRJguMGsIzibvy/jee6Y=;
	b=j7StcWiIJY9yUHwXHyxNiQRJFXqVoU0dGC+ajMLn2uQwtGho7kpDhX+v+gzNZaGaYyCEME
	xnDViBkZskWv6vRvUfvgxC6Zt2tgVVhWesXrZcaxl/KI9rIXS8HXBBp8QaJEQfBi01FjT4
	2Yk2Ktg7OjuBB7tg04nivwAu8ZlCrdo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769760664; a=rsa-sha256;
	cv=none;
	b=CIejoWrgC5Drk4ZTBVmn0HO+t+lk5ILvFk8SjWnY7gv14DWoEtZsosHQkJCBAtHIB47TRs
	CxT2ovhuVK0Vp4O/Sf4tPa84grWTw6JJ3WzIUL4ytPsHYt181gxVK7hM8kXSiNfAMXTQfU
	XXmBj2rVc67rfddaamxYNt+fpHUWQHI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 343F1153B;
	Fri, 30 Jan 2026 00:10:56 -0800 (PST)
Received: from [10.164.18.94] (unknown [10.164.18.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20D8D3F632;
	Fri, 30 Jan 2026 00:10:56 -0800 (PST)
Message-ID: <1a33fe3e-b0dd-4553-95b4-89619b9229d2@arm.com>
Date: Fri, 30 Jan 2026 13:40:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>,
 Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260130042925.2797946-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C165740003
X-Stat-Signature: zxci34ws8prakkbrpqxniktc7fmah6x5
X-Rspam-User: 
X-HE-Tag: 1769760663-99544
X-HE-Meta: U2FsdGVkX19D42f7c14Sw5nRWQzN3LveZYscopnsYkqh04i0qF1+4fFMv42HihXQu+JIPFrgJihr6b4pnRXMHxflmH9mF13nugzKPlCqN+XDklwatkhroom2go7oj/sj8Mxvoke7NzvCTX/YrsCet3wLdoFOruPo4prxSSxTaQpBqi1/iGyUA765FKRRrWg/PlI6AnOHYxE/Gzq4tALp6L8dnZbvDCa9DSD/XJLXbA6Eg88vVATqGnW+BcCiDg3xXiGqkVwQ/vni0scbX+/jBV5m7FVF0rDFMDBLQcYR+ZXMbZd8bWq0oCBZt8bl3DYM4NpsP6ewpVQ4O+sbTSqEYAwOjoW7Gwt752j7BOV7NBAjm5DfITzb88iTEgrkYqwaR2JEiuw7LAfE5faNLXnCA/IuiohKdBNH4s+WRyfql75S1FByQdLued3eBFWv2CirZkVAJ+RHbNwZt2wp6DLR9Lv7woODDX5NN/jzr+Lj/uTKwVhMD/QeeGYxfXNxs/2bUApOosuzfaMyOesEvBezbAmf/pF9E1yEZeHCnA6eB2Bcj4rfw97aBnpKK2aRpLRGpqnTmdEuR9clgmc1H0QWlDk+Ms4iWD3RSlgv4W9Fh3+zd7lK2KY1GqvHkVjGapjsjcvgs9A0Bs8Mdp9OrMUEY5XX4Jg8N4DoargweWx+aGLvkaGJ5O5/yccxS/jRMRbsb1TS6j21uloe1DYf/X0JI65Ks9WI1Ywe6PXTX+b9A6WesOYS6K9R0MqAcFbSO+r8qQ5jhV2cNKx5v2qbcx5JTuLULJrEPiOCfWmQ0TKl2LOD/V7kS59jdGG1RlWNfHIHotitrTk8WlSEmL1a+Nkzqq55uIbXZG6WvZgC6MMkYEcTRgRoCt4HXfIQEnnGjAqBACzqXcziwUgU8xaBoJ8jcMtkUW0ub5qHWEIpU4XQRWUAh1aK3nubr0CaXr8kehcM3IOsNffM7Zja2PPF0Cb
 +8OEogJs
 iJ1q7gSsnJ9Gm2QnX2QQKCqzwOXF+9ayx0vEvGIpHXl5aWEaUjRjHi3tKlV5vIomOlr2fMXq8w5hFuPKzmaf2BK0mEkACkvQN00aas8L828y2SpDyh8RQVeGkBVlvBfkBAlpQgFS+OoqArNawuAbSWPF4a7XQdalFL2RqMLePViXDJd/n6CPT6ftvSib/p2gBxjo+qt5qW6DjD87fWv1hD5Craw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/01/26 9:59 am, Shakeel Butt wrote:
> In META's fleet, we observed high-level cgroups showing zero file memcg
> stats while their descendants had non-zero values. Investigation using
> drgn revealed that these parent cgroups actually had negative file stats,
> aggregated from their children.
>
> This issue became more frequent after deploying thp-always more widely,
> pointing to a correlation with THP file collapsing. The root cause is
> that collapse_file() assumes old folios and the new THP belong to the
> same node and memcg. When this assumption breaks, stats become skewed.
> The bug affects not just memcg stats but also per-numa stats, and not
> just NR_FILE_PAGES but also NR_SHMEM.
>
> The assumption breaks in scenarios such as:
>
> 1. Small folios allocated on one node while the THP gets allocated on a
>    different node.
>
> 2. A package downloader running in one cgroup populates the page cache,
>    while a job in a different cgroup executes the downloaded binary.
>
> 3. A file shared between processes in different cgroups, where one
>    process faults in the pages and khugepaged (or madvise(COLLAPSE))
>    collapses them on behalf of the other.
>
> Fix the accounting by explicitly incrementing stats for the new THP and
> decrementing stats for the old folios being replaced.
>
> Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Thanks.

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  mm/khugepaged.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1d994b6c58c6..fa1e57fd2c46 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2195,16 +2195,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		xas_lock_irq(&xas);
>  	}
>  
> -	if (is_shmem)
> +	if (is_shmem) {
> +		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
>  		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
> -	else
> +	} else {
>  		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
> -
> -	if (nr_none) {
> -		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
> -		/* nr_none is always 0 for non-shmem. */
> -		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
>  	}
> +	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
>  
>  	/*
>  	 * Mark new_folio as uptodate before inserting it into the
> @@ -2238,6 +2235,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	 */
>  	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
>  		list_del(&folio->lru);
> +		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
> +				      -folio_nr_pages(folio));
> +		if (is_shmem)
> +			lruvec_stat_mod_folio(folio, NR_SHMEM,
> +					      -folio_nr_pages(folio));

I notice here that we don't need to do accounting for NR_SHMEM_THPS or NR_FILE_THPS -
but the following bit:

if (folio_order(folio) == HPAGE_PMD_ORDER && folio->index == start)

in the khugepaged code, seems to suggest that we can reach this stat accounting path
with a PMD order old folio, if folio->index != start. But this condition should not be possible;
a folio is always order-aligned within the file, which means the folio->index here
is PMD-aligned. The entry of collapse_file() asserts that start is also PMD-aligned (guaranteed
by thp_vma_allowable_order in khugepaged_scan_mm_slot). Therefore start must equal folio->index.

If I am not missing something here, I'll send a patch to convert this to a VM_WARN_ON.
 

>  		folio->mapping = NULL;
>  		folio_clear_active(folio);
>  		folio_clear_unevictable(folio);

