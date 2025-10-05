Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A2CCAC5BB
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 01:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B568E0003; Sat,  4 Oct 2025 21:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C5A8E0002; Sat,  4 Oct 2025 21:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460BC8E0003; Sat,  4 Oct 2025 21:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 315978E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 21:48:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD06185C21
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 01:48:41 +0000 (UTC)
X-FDA: 83962376442.22.D7620DD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9067D140007
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 01:48:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b4Rtd+vD
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759628920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsvBcghcl1y7JJAXl+fpdoZVJZ+hOApewC8v1L8ApkY=;
	b=8i3oKsdLzM/Af+XFft3OhAudT0g8w6cEPSyHL99uQB2V9ylJRu7taYcjXoOYaGBS/flFQe
	1G7R/sYkHHbi+OYxrICQoQ3ndNInY8fOw1iGr8yYWDM0mh8xbH9WXjFKoUeQOMpwBomA6q
	kJflhkciCrZV9BsMEN6M+VuQ7Ec4qVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759628920; a=rsa-sha256;
	cv=none;
	b=srhHEHkgB9CHxhBOBCbnHNfBBOwfu92g6iToytZdeh1b8hw9ieNtmtx2kaELaext+jsfgX
	k6Rlc/rB5+o23Y3uJr4LstkRzaLnzFWAfZ4SIZQ4frcIt9Ov1EeLQW6DabdYulXboyKaUs
	ah1rkwDY0dHIwzVqsFFSRm3gMnNn3+s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b4Rtd+vD;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KsvBcghcl1y7JJAXl+fpdoZVJZ+hOApewC8v1L8ApkY=; b=b4Rtd+vDLQBZ4Yj0SsR6T1lYMl
	jzVd5EnSxqLc1wZ1OHHDhcFdZFWc4Z8fj3362L65yPthaUgJ4uICAJIYsE5ixB5VRd3qmrVpkjq9H
	QLKs9UolzChru2NMpcHCjzi7UHEcb1Zb6dFz4VNnL+PP/b2z/1fQlVn14nDLUSCl2I2J72e9Z2GvT
	VmCRElzHSPwBan65fbMzuNeE2n5KGiwA7Af7uezjMEo8ho+BHVzjzzzkZLGMiW8Bs8Ioj2zAH9iCe
	x91IJmwQw0kB/0a5FCkAD2wBJKqg28GuhAJpw9W7noUF5UZqRJI7muLkyzWQp2x91yym1wo4dam9s
	MGeDIzBw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v5DrO-0000000G5jk-0AT4;
	Sun, 05 Oct 2025 01:48:26 +0000
Date: Sun, 5 Oct 2025 02:48:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use map_anon_folio_pmd() in
 collapse_huge_page()
Message-ID: <aOHOaYG6gjnfrsmR@casper.infradead.org>
References: <20251004092523.28989-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251004092523.28989-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9067D140007
X-Stat-Signature: 7qyntrki58ng6gzf34i999udjgjfjt5q
X-Rspam-User: 
X-HE-Tag: 1759628919-625097
X-HE-Meta: U2FsdGVkX185Sxb/qZbxVNzMuAJwMmLHU1WnxGUUxmac1F6PjQrJX0wBZEWLHh9pHORh/vYmCNAkEz8Ocoq5/6oUndfwYBdfyAC41OcsTc6FtiqgaJXqQQevuFDhcR1PKWK73/kXZ4ZwbtEFvj1jOVlo5ZpTWS3W6BlastufCgreaoexXMUKOy086gzIRil6S4Q8s7CRobqnVKRu9nFkVxfk1bDjA09l0kf5P3wZz3SRjqSm1lwkJ+FhpqGyZB6+JlOBVo9FDt/kdMtrSXV9Pjlp0gm2TG4kCN7IdxDLL27zfX5RjMVe5gTbgIRhTZZFnv8c1zksvmDRdxZJuFNIDuLJQF5573n9oegGVCtYYG1v9ptDblggEriNAj7+Izdhd0y9B3eYhRIudjxXt6qF1iXqdicVOdyyhiqpQxUhJHUGL/lAW/kBWpVc//v9JIZO6ZDlXaviyjN7yd3mlFbu1JypC6GPeJlOjnOAGI4rjyDUWoiP6Y+x84QU8lDaUEueakBDsXI9P0YRy0Ud3zQnaxT9Ecxbs/xBs+K1y6oO+ZeBdxMPcUb53XWaAns2IId1zS/hCrT05cII/RJMIYNaRuTDSD1GVnWJxuDJhI0r4xymqfunklZOvZBLDKOR/jpOLXxMTcboX1FqUD/qiVxm+Jaj2V1HrR5bkff6wdS+9jblfzkceBuLpgafOm+13rVduD0YkAVdqaRzphfclc+WScdU4xanAoywQIGICyucafGmpGexBjnRgIQyhgmT2YzfDOiSr511pxNBHWs/f2Xsdf4nlZJiAOAm/j8rPTwWUV3sgB1meUSQf6cztn0Zbtyz7Uc93ASMsWfEyljqVl2+xVXSTF8P4JijTstzxCH4SErmHHZihVXt+HaLNnHFI+umcRb7zejkhlrRFpkCKhZvyVUKO21fDeslmP1odzLkqH3K1/VjvIbiNA7oA5Mor+ziY5WNTxVK+G0S2zHWMLP
 m0Ur+bH/
 Sdt8RtnLzR3vJL79gXGZ30zGaT8FyoN2eZxZiFGWS5Fyo1Ukd1gK3pcaggtPolPffhqAXqHWHkTjGedsRfuMULUi2wl++u+iakUV/oBKEiMopRCc7hM0IpKAx6VvbUhTcPxrod6C3ap0Esby4zZSAu8yo8vsY/1O4HwDEe6XncyVtgZA70uhkWpp/jHrMZHLGMwbWKlKjpSzIGTPs55593/tZsMO3zmSgUX/998tdFcnh2TXIOBpmNrDFxWicc3zFYiDiDP6LI63EInlcsn2AjYRQxkxe/nCdjY78zv1F3of6+C0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 04, 2025 at 09:25:23AM +0000, Wei Yang wrote:
> +void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr, bool in_pf);

It's generally a bad idea to have a 'bool' flag like this because it's
not immediately obvious in the callers what 'true' means.

> -static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
> -		struct vm_area_struct *vma, unsigned long haddr)
> +void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr, bool in_pf)
>  {
>  	pmd_t entry;
>  
> @@ -1228,11 +1228,13 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>  	folio_add_lru_vma(folio, vma);
>  	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
>  	update_mmu_cache_pmd(vma, haddr, pmd);
> -	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> -	count_vm_event(THP_FAULT_ALLOC);
> -	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
> -	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>  	deferred_split_folio(folio, false);
> +	if (in_pf) {
> +		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> +		count_vm_event(THP_FAULT_ALLOC);
> +		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
> +		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
> +	}
>  }

And it's really not necessary here.  There's probably better naming
available, but a good pattern to follow here would be:

void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
		struct vm_area_struct *vma, unsigned long haddr)
{
...
}

static void map_anon_folio_pmd_pf(struct folio *folio, pmd_t *pmd,
		struct vm_area_struct *vma, unsigned long haddr)
{
	map_anon_folio_pmd_nopf(folio, pmd, vma, haddr);
	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
	count_vm_event(THP_FAULT_ALLOC);
	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
}


