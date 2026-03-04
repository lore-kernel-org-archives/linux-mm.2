Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5035FEB7EB2
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30F46B0089; Wed,  4 Mar 2026 04:22:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00F46B008A; Wed,  4 Mar 2026 04:22:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A936B008C; Wed,  4 Mar 2026 04:22:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3686B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:22:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 308451A04DC
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:22:52 +0000 (UTC)
X-FDA: 84507840984.18.682F1DC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5EA9580003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:22:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772616170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M+mHhI4gDc3H7z2Us0+E+GhRWYdqBuMRg81mbY1CCCk=;
	b=vSNeIi8nhzpG3eIWpDCk+QsqGVIA5T4mITj0w5EpH6DleK3mw77F2NP8lFH32gkIk0M76V
	hLkkq4wHzfcscNTkVqTZgO0S4+O77X3VltshwTKU4eN3D2qCVmog7G3E6kGtanegZlOqWT
	T24LeiCRtIaCyh4Kq7bdZMgpYTNns1k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772616170; a=rsa-sha256;
	cv=none;
	b=G2VnQdOCZdnSsdinwqwdKsMaB73I+sfC8yAgxcSnSz/QnSZT3N9E1WE5ZUlPd9ux56QN2q
	YzwgT3bA4XXdxXzXL7vaS678/p+mHaR/mSD1xj3LcVzacHCNXFk992dhWdNOE2gGPO7lk+
	6lKw7zVwY1aKGfsU/2TOXBHvwx0hHGs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 019F3339;
	Wed,  4 Mar 2026 01:22:43 -0800 (PST)
Received: from [10.163.173.252] (unknown [10.163.173.252])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA8673F694;
	Wed,  4 Mar 2026 01:22:43 -0800 (PST)
Message-ID: <346a421b-5b8e-41b7-b92e-a5a679030f1f@arm.com>
Date: Wed, 4 Mar 2026 14:52:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] khugepaged: remove redundant index check for
 pmd-folios
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260227143501.1488110-1-dev.jain@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260227143501.1488110-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: szjouemwoeu944p6tpbu1zk3c1pore4o
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EA9580003
X-HE-Tag: 1772616170-626881
X-HE-Meta: U2FsdGVkX19D2a2t8AGsfcTv77NserCV4FudKna81vNFDhIfAUixFucko5k2XaEHXMIcVRZNsgDVJL2Z/auOURN+M/vxBLkg354nKeVBqQULawjGM5vXTXlAz0R34NXPG29dft2ATGa6DS+MwK4Vzv0q6yrNO5v1wUGP4k+MjZCWjqEyX51eNHCELc/PGQOIUYzM9sg4ExgXjGzdHL9+FUqyKRGxmD30HJZMFWv/I+lRRAGMxtmotmcJbiN6W8xKTpiIpD0ObNj8kOwwtJcTMBxuKdTXYOE7+3rk12zdDnvMMCRcGavJQwQOg9S+KKDWN5llXmjIyr93BKcxjk1f+eEyJjHX7AJNONjpQO1HFGc3sMfCk2z8mTn89nASfYSe4jv/jMNq/uTukolHxuUnUEnjUn2zcfnkfLZVnVU9wZeQ3Mot42iJxEaTj6C2xeBl9n3yqon2rTa676D9PEVwDBWcm8tELZdEARrYwjjwXs2Xzccg92jwNHebuD/i2UxpKBQ1EW8Oj/eA8VzTnSCANhjhIWJktAxscOZiOapvamsp5uGuhlcqlvhwlBec2MZ5yWfBl254Gp7IA/GK4ux13KOLPYGoZ/Q6Laqu/9E79zJY5auh2SVVhfWOTX+syFXnHrljkhSCZLgeCYOs3IJ6sW32LsilXadcCpxDrSvJPFgLJmgj0P+2+31nbNv/nLy6sBlDUAgFC2yA7NRCRajvlxa/XrekVPnHJeDxQQ5RgSG9229LbCW0CUiezcvFZ+50S+Naee8IK3oQf5ce7EX5fAXisDTB8Xfwm7V+pToZOiibGMrFyfq+RirTEC85+YbAmzwk3R0QwbaUsfx0m5+QhRwZ9f+gNORnr+T/yJbzbqAVtA4Z54ebBxZFMfOsL0Oc7PWsIx/Zm2YgEByE3IHPDQqlGh29AZNTWtOAVqkvTMEwe7cv9ahRH+ns8hlwVvgvSmoo0L2VEkOGO35qdMT
 jzIIkuGX
 JC+Tk9UXy5OhzpLzBqHrqVFWDASl78l3nK7viMafJ9FJ3VIJGPK+Sb7G6AMol5sR405CZ2pB4h3x1Yf4hddLBJFb6YUbmXCv/mh9fYOW2ReHeJMA4Xewxv6oZFWUt94fX+cpiZZuzD9AOI2+WQfYS52N/xiQnuBnlh5PPamAOR0LKJTdHYw9O3IvzETiA0EbFwFryWlZBijUqdsPc9E0F2fNeKJyflZuMoC3BPrsZaR57vlqCkdSbBYmOm7vr7Q2FHt/x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/02/26 8:05 PM, Dev Jain wrote:
> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
> 
> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
> iterate on the xarray, have the invariant that
> start <= folio->index < start + HPAGE_PMD_NR ... (i)
> 
> A folio is always naturally aligned in the pagecache, therefore
> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
> 
> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
> offsets in the VMA are aligned to the order,
> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
> 
> Combining (i), (ii) and (iii), the claim is proven.
> 
> Therefore, remove this check.
> While at it, simplify the comments.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> v1->v2:
>  - Remove the check instead of converting to VM_WARN_ON
>  - While at it, simplify the comments
> 
> Based on mm-new (8982358e1c87).
> 
>  mm/khugepaged.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5f668c1dd0fe4..b7b4680d27ab1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2015,9 +2015,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		 * we locked the first folio, then a THP might be there already.
>  		 * This will be discovered on the first iteration.
>  		 */
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> -			/* Maybe PMD-mapped */
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
>  			goto out_unlock;
>  		}
> @@ -2345,15 +2343,11 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>  			continue;
>  		}
>  
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> -			/* Maybe PMD-mapped */
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
>  			/*
> -			 * For SCAN_PTE_MAPPED_HUGEPAGE, further processing
> -			 * by the caller won't touch the page cache, and so
> -			 * it's safe to skip LRU and refcount checks before
> -			 * returning.
> +			 * PMD-sized THP implies that we can only try
> +			 * retracting the PTE table.
>  			 */
>  			folio_put(folio);
>  			break;


