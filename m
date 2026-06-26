Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EA8CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 03:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4AE6B00C3; Thu, 25 Jun 2026 23:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD056B00C4; Thu, 25 Jun 2026 23:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195166B00C5; Thu, 25 Jun 2026 23:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E30F36B00C3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:18:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6300C1C148B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:18:10 +0000 (UTC)
X-FDA: 84920605140.24.8901B3A
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8C31440007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:18:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oeeeVHxT;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782443888;
	b=wlXUK68KOav8s0aWiRZxxrb+XigQ0p9j50tuCY3T4RVgw8mNkm/F9PN+b5EzUa3a/lXkmh
	ShnLTeJcv2I8H0Bjfy/0D+zjVNx1eTEEny/H2Bg99anksuxcFXD/l8l9vtlXt/WR+QwhbN
	AzWV4XyfCg+eATyCoqS15PjfRNGfQV4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782443888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZJmc3takRDK7jQCyQNoqz4XYBQ54vYpzBE2NdGeia8=;
	b=DqkVVlxFs77Z0b0gR1tbkei+CDDpJFPVr20gjfr7SCOylstQ/wdkFMqkXdTpTpN+FzhlPH
	+eqtOH9xgy+YHAkN1W1r7Jk1+pDKYOCd2bNXmc7YhTQMszU7JPFFEeh/lKrs8RFEVW6u07
	fNcJvRdlVp9UMsfTGndifsQ9PMMbV+Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oeeeVHxT;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f8516534-3b18-4988-b384-251225755285@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782443886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OZJmc3takRDK7jQCyQNoqz4XYBQ54vYpzBE2NdGeia8=;
	b=oeeeVHxTM1sDNbDtkvWfeWlWL81Q3QugP8nzSEd8pZBSgXF1GGvz6loEWo07SGCgjDI1dn
	zvkkgZVmV6zYGwHGOd53ypDtk5qJPYupHaWIx+YDFcl2/mIZyVDBjyKowQNpbf/CCz7YP6
	VfhfTscE5s4qRXV3XgaRUnsRxJx/L4c=
Date: Fri, 26 Jun 2026 11:17:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Dev Jain <dev.jain@arm.com>
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, mel@csn.ul.ie, nao.horiguchi@gmail.com,
 ak@linux.intel.com, j-nomura@ce.jp.nec.com, pfalcato@suse.de,
 dave.hansen@intel.com, tglx@kernel.org, jpoimboe@kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, stable@vger.kernel.org,
 osalvador@suse.de, akpm@linux-foundation.org, ljs@kernel.org,
 david@kernel.org, liam@infradead.org
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-2-dev.jain@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260625112955.3254283-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xapat6tkxm4cku76my6kyrq96fs4fe6n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8C31440007
X-HE-Tag: 1782443888-917323
X-HE-Meta: U2FsdGVkX1+GhZeGHFRrMoSQfkmPY32MjljVkYPS8Uf+0UwPB0Wz600LB9jcCFEYBgPBc0Z7Vj74pR69/VblDSCjymZgj0WKDhrtjAn44Mz3VBKjPkyv2TIYYRwngHYkLaIC0FaYu03eTNDIELXkaf5jO0B1d9pmV9pChSB8fMfnTIBn2ctJtG+rJmP+3e/UCH2LT6ybliI61QPD4MKrTE7Il8Eb7SdIPts22qV1dGxWj0MMzFIVWpRelpyIIR+voTOgy5G2C36wCmjtr9LN9Sfe8XqKILmVgwvz20hWfJupYi7iRZhwW8HT4UgQCyhD9giprKHkzqkwi85qv8fEeSoDK4j6lSW81WlEyi+L7P9D1DJlkUXcbnDOty17Qwcr0Kiqh92MvJ116yavJ9V0OU+jZykajJtBEd/dIUI+a1Z93JJKc84dvteY2P7S+tKiR+JeiGxC5rzOprw/N+MtFAYh0rP9Whm0ryNwIJhRVm3jpVDVQMqU5+4EELaVmnfYqnzn9Xm4qDUyzFlLeJh2PLPL5HlCOdyFvg1O3XQZls4ThiK9fxUwgEGGM7HRVlRS3hpZUi1guKe55Rl3HUVpsvR/5/O9L+rkf3JdvIKp91ej9LnKu+ogEZK0j5XGL1wOvBNriovBI18YbUI1sHVsaerFwx4g+h0PO2kixqMEHqt28ZXF6hC7GZfgrDMrPfgczTclnNGllDV1GdJLY3SqWRmJBlnfQAiakAZlNk68Y13cN7EfW3XLMvTjbrJ8C5zzZ4v/um9j3gCZ0OROBHTtQ0RvLjJPyxjPSVoVQNxwpyx03dJHhVR3uGNsrbWwFEuGNAiHfaDnWVBkUGiSDWfLZHPA5w4iKmPoDFMedNWCe2T4wkEpa+uZztaR7/IR5mxsxQUAE8etFvShITnOO7fIGTM6W+Zn14jPREOL1mtw0/pkUtGuz2Aqjd9zTcP0/akIlsSeUH7yK/R/woEqueT
 cGTat6FE
 2UTOtXsHGMzjcKJFHRVHeIqY4BJGFLMiviaqzbNcSsnySwaqzuIiy5FUr8VScdmziRL+pMBEjo7CPmKB2/ypDFEaJwHYuBC9s/qzwZPJ7ETb2ke6/DhuN2/Kia4pRZri002yzwDWneu/ZGK5NY0QWqP1kznZAz3bWi+43d5cmWJhOsXRHkeENV9En305pZ4Vk6NzSNNAwP0jsSQfNLYi9eWv76DvM8MQXsVpE9pg9ofn1OG7WTiC6MT08z3Qgeadv3UihnnpQplf5wAd+jy0R+o/lj0qlm1CM+1xVoS1hmGGQFubN5js44i4VH+H18klaBxO7KF6VfICWxNTmM1PcHDFcMqCcLQyj/s5sEvMeKvkJ+25mrBqj/+r6bQ4eOwr2sm8wIt7cx+XIYGDxvWq4mKCcdcWanPTd1JXh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/25 19:29, Dev Jain wrote:
> try_to_unmap_one() handles hugetlb folios when memory failure needs
> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
> case page_vma_mapped_walk() returns the pte pointer to the hugetlb folio
> in pvmw.pte, but the code reads it with ptep_get().
>
> On arches which provide their own huge_ptep_get() to dereference a huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
> etc to misbehave.
>
> It is not clear whether this has a trivially visible effect to userspace.
>
> Just use huge_ptep_get() for dereferencing a huge pte pointer.
>
> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>   include/linux/hugetlb.h |  3 +++
>   mm/rmap.c               | 16 ++++++++++------
>   2 files changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 2abaf99321e90..fdb7bdf7645c5 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1261,6 +1261,9 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>   {
>   }
>   
> +pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
> +		    pte_t *ptep);

Thanks so much for the fix! I'm curious, though: why do we
need to add a separate declaration for this function here?

Thanks,
Muchun

> +
>   static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>   					  unsigned long addr, pte_t *ptep)
>   {
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c77d5dc06e9f..aa8a254efaecc 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>   		/* Unexpected PMD-mapped THP? */
>   		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>   
> -		/*
> -		 * Handle PFN swap PTEs, such as device-exclusive ones, that
> -		 * actually map pages.
> -		 */
> -		pteval = ptep_get(pvmw.pte);
> +		address = pvmw.address;
> +		if (folio_test_hugetlb(folio)) {
> +			pteval = huge_ptep_get(mm, address, pvmw.pte);
> +		} else {
> +			/*
> +			 * Handle PFN swap PTEs, such as device-exclusive ones,
> +			 * that actually map pages.
> +			 */
> +			pteval = ptep_get(pvmw.pte);
> +		}
>   		if (likely(pte_present(pteval))) {
>   			pfn = pte_pfn(pteval);
>   		} else {
> @@ -2110,7 +2115,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>   		}
>   
>   		subpage = folio_page(folio, pfn - folio_pfn(folio));
> -		address = pvmw.address;
>   		anon_exclusive = folio_test_anon(folio) &&
>   				 PageAnonExclusive(subpage);
>   


