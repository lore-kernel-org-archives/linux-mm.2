Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D5CFC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 04:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A35E6B0088; Fri, 31 Jul 2026 00:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5545B6B008A; Fri, 31 Jul 2026 00:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46ADD6B008C; Fri, 31 Jul 2026 00:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 285A56B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:21:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97DB212032C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:21:26 +0000 (UTC)
X-FDA: 85047772572.19.A1804ED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8C5CB120007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:21:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gKb4AXwL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785471685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TeS+OZem7szIEzfzLaf2vjkrcLmvEnVzrq5OpBjIDU8=;
	b=55ThlggXtzjVfhaUFXfXGfALWXnqR6J1yfvUHtk02bRm1HAmUwO+0jcLZaIK/vAqwlCLw7
	wxBnAhFPaYKK3RZFrsIMPt7tSHFDIZhilpGFay0tZe26yNOk6P8M3wxjjk8BtAINVMLJtz
	Ak9/VgoSduKEKwawjhYOCfkwxLo8yNM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gKb4AXwL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785471685;
	b=rvPnTTKRSqPgDptkKmSHKXciJvgzW3JLhx+k6XyGtuQzSxcgkiYqQi1AuSRVj84yV65X5J
	KbWVr+tcEsPzwiHQQgvEARnSum+ZkX8VHZAsw48I4+3A6B+EfH9kDTWofpb1DeF6oVmgLR
	iqm7m6exYq4jYXFxp3j1rY3oCuvvKYo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54613204C;
	Thu, 30 Jul 2026 21:21:19 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B20183F86F;
	Thu, 30 Jul 2026 21:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785471683; bh=c7rChpsB+5DYPdIZHlwvb2jD62nm1r5MJzx2SvoiIJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gKb4AXwLblePR65NS8GYJhZwOxdxoeOOyAKRuEM0VhsIllPjQpzKZg+IwxfU+pe8t
	 vFdzDHPVaf6u2tR3paWmnb57FefddON2pR+AiwF6a3AZQpsyTNTBK1ueoRYCEZSLdY
	 S2MKK3viD1MUm9CZh4/uNbRJymouQ/f/r8n9ou2c=
Date: Fri, 31 Jul 2026 09:51:19 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	muchun.song@linux.dev, osalvador@suse.de, riel@surriel.com,
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com
Subject: Re: [PATCH v4 1/5] mm/rmap: convert page -> folio for hwpoison checks
Message-ID: <amwiv6tDhctggCv8@a085714.arm.com>
References: <20260730094559.418003-1-dev.jain@arm.com>
 <20260730094559.418003-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730094559.418003-2-dev.jain@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C5CB120007
X-Rspam-User: 
X-Stat-Signature: xkeimupxcp34waado5z1hsd9nwi1c4ad
X-HE-Tag: 1785471684-6975
X-HE-Meta: U2FsdGVkX18nv6TBha3KFTTcpHvbWgyouRy146K6ns4TeetSH0fOkqqmTCxYb1QSJwBPQAHy2jmUdEfLS8G6cwKf3Mmdy6lIeoRx+pHMiWWO8EZv8z+5rHcB9bWS2zrNk62SAp3JWQME1I5KSJvBZOlPJHegbsavlBxYcsQ490HrrrYKKgFB01N7XDMUVdpWgGxw0Kmn7kJl6FLGJSD4EgecuX8Ju66VV7mu/onvY1/UMm6BoI0t8JiebElqM43pEv+f0AINOyqdfQyDAunDoWofXR7xT50/fKDMVF/OdmRfLeBpXaVVqpLoCKlXpNTit2vUMYh3TD5RdVaaV9YEsIX/Z+P5GZUFGcJ1sCQn6FTxsWrFaYrVHRmpbcpgytC4/on2AbsWkUeAEPH7dYx4qO+h/Y91Z1qx++6vvp36azxYDrXRHhFNmCoxCoNhJ2n7Muqgakb7X6rvXhWYHcAgLXnZwEXz7NiKSGcQyFuX3o8b1jeDUVe5GTCuIpQXsLJzzUgyaCZjOlw1m9Kms7EJSn2K+G7Yj7qOxEhZVamxStuqer7f4WakcUYeBVMbMbWozdrTX94FG3Q7XpT1LnQxgZKkRABkn1a/tLawEqp0Vt8dTtbTvvDMs3kXngxAvg4gUfZdrDG54wW7po2YjqVOIBgYqrVke7O8xi3JyyK7iNcypfJK68Ub/o1q1Wpxk9bWLNmAHuOeLEuwDEE8VAP4kpBaCVv5cyHKuFa8itjGnFM+FF3MNYaxSSDJzX95eqMm1Hp6RFeCZOefPg0gHWh6vxwMeLHG/owVYXEbzz0xBTaQ86JTDIWe6+yclt8HpEe3bPSFU8JqUn76IjBf/ohs5dCuus1NsXPu29dF3Bqm0PN+Mq8XI7uAR22Q8z35/5vxL0IFqSWNY0o33wX2yK6XCFj91RliNlnuSEj2BQalNDEfYzV/c9jrOOFcDoO9oujQ8VCxSNDE1aE3GwXf7Xy
 MYQKozWM
 XTBt3UlfOCcgY1o/FUSdeTUm1VqamJH+pLVGHThgwUNe7oeFn6mg69k7KYubuPZAV/hWmIoBZjUw7fDevmLsJyQPLKcSeXLmnKMUKu+1TuLl0dPTyCVBDjxg1o5O3wzUh7bcVakly+2MOlhT8UVMJP0u7cGw2EpfgoHEEOCRMjkxReXEHxccGf3cZren2kCDQIq+qtZXG8aXSSS7e60x4S0AjthI7S2AexGteZOBzaEq0aW5LEPD4UpivSLx47M0ARMVYkFWcXh/vLGx08m5kjhBmPBq1VbPNrs9/HuGYtd0xrKBf0rkoz5uwe4Qidzqug4SQqCxRMuHYzVZkWWHj4GLE1bpFt41Jr5MBlQoJjOa03UqDj3KYCWHMSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 09:45:52AM +0000, Dev Jain wrote:
> try_to_unmap() receives hugetlb folios only from the hwpoison path.
> hugetlb_update_hwpoison() sets the hugetlb folio's head-page
> hwpoison bit, and page_vma_mapped_walk() reports the hugetlb mapping at
> the head PFN, so the previous PageHWPoison(subpage) check happened to
> work for hugetlb.
> 
> For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
> folios before calling try_to_unmap(). Hence it is always the case that
> if try_to_unmap_one() handles an hwpoisoned folio, then the head page is
> marked with the poison bit.
> 
> Therefore, convert the poisoned subpage checks to folio_test_hwpoison().
> 
> No functional change intended, except that, while at it,
> convert VM_BUG_* to VM_WARN_*.
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/rmap.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index e854679553b9..77be9fcffa99 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			bool anon = folio_test_anon(folio);
>  
>  			/*
> -			 * The try_to_unmap() is only passed a hugetlb page
> -			 * in the case where the hugetlb page is poisoned.
> +			 * The try_to_unmap() is only passed a hugetlb folio
> +			 * in the case where the hugetlb folio contains a
> +			 * poisoned page.
>  			 */
> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
> +			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
>  			/*
>  			 * huge_pmd_unshare may unmap an entire PMD page.
>  			 * There is no way of knowing exactly which PMDs may
> @@ -2204,7 +2205,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);
>  
> -		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
> +		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */
> +		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>  			if (folio_test_hugetlb(folio)) {
>  				hugetlb_count_sub(folio_nr_pages(folio), mm);
> -- 
> 2.43.0
> 

