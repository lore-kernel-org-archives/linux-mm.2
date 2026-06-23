Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A797CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 16:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665E56B008A; Tue, 23 Jun 2026 12:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617596B008C; Tue, 23 Jun 2026 12:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5569D6B0095; Tue, 23 Jun 2026 12:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB1D6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:47:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C083F14054C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:47:38 +0000 (UTC)
X-FDA: 84911758596.10.68B6824
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3374640015
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:47:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kfGK4fPV;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782233257;
	b=JKhmZeqsyRoZBcZykwxjrqPFUus/jEsSrqGIZIIG4eq+mxfO90G983EBwP1aeNxmTTp2rD
	aOUKJsvhWTohDx+d3eo+JctjxOPUL2nVZzSTbdbFQTDVnOwqMDOpPmJshGK0x1r866uKFT
	8IB8gqp8Y0O3QfUKR5S2YZLLdJGFJRI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782233257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eg9fwmGWBiInLZvznATwa3S6/VkytEOc0wcDvtX3mn4=;
	b=eCpP2ZDq3AUe2M3kYBx7h8rJHxkVE8zUk2KBvbVTiri8XRFuhSzXkp5Q6WZ8pAf/93cInF
	FiqlpKqXcTark4i+D4xR4J0670GtH8IK4PNF24xI/MNS4P4anz0eR5AeztX9l01gU4WCds
	LTzRVRiGmKPDlsq0OJzfwXQ8/O675Uo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kfGK4fPV;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40EB94415C;
	Tue, 23 Jun 2026 16:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFD21F00A3A;
	Tue, 23 Jun 2026 16:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782233256;
	bh=Eg9fwmGWBiInLZvznATwa3S6/VkytEOc0wcDvtX3mn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kfGK4fPVObU3c8XYpSAS4lf8gsRhzLRmgbOcHfgxApgvu55tyrCE8vJZT+R/Hpc0S
	 jW9GbBH+4TloDgnu8VWzAVwpeArVAxKZaQwhb3G3ZxeOxARio7D9h6FI4h6Wlp/48q
	 aEi8d+1j3T94AbFusHL2EO0JgR5JnQ46yaGWF+ZtYwNbAbBgCPQjFUrSmRjtkHl3m5
	 RkrQVqRUiuQCUtZjk+QaXvXou5beL2tiWXPrlsEVrqcz2/wW06fsx5VaDyLR2DVouq
	 w/cCMsNDigm8u1zZUPcGdZYsk080DkT6U4R8T7O6Wq3AwFhwbdr3scdCFr2RaMv3L6
	 OvklbHQ73tPAw==
Date: Tue, 23 Jun 2026 17:47:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	liam@infradead.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, david@kernel.org
Subject: Re: [PATCH 2/2] mm/mprotect: drop 'sub' from batching context
Message-ID: <ajq4hD3CGG_jM4w5@lucifer>
References: <20260623125723.2503832-1-dev.jain@arm.com>
 <20260623125723.2503832-3-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623125723.2503832-3-dev.jain@arm.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3374640015
X-Rspam-User: 
X-Stat-Signature: ysx6zubgf4xup3ku8ygwm6wfbzxo1eci
X-HE-Tag: 1782233257-453972
X-HE-Meta: U2FsdGVkX18afLAQIrp2Tf6l9L2JaWBmS5IgcW5gg9Xw5b7V8xA4TIUfakDaMKuvFj9cDtyZNzS2m58yjNlAwO8JZOJwDW37jbSxL7tUmZeL2ym//hanB5kP2hyDtJ3cnAvDGJTNRhFigGZ8M78gTv88ygI+4yHME50r8XT6zxUN0nyFNv1LTcbG19jOOVOKCqZ+jDhH4gmDRfRMrM48vc2l2Yax7xWz7+gmQ044ELzCMPenWyvwRRB1EPFO4SoGSG/CVHGXC6EQK2KtN8iBFKb3wVzqGWOQ24+QXNPbRAzgxfnbeMLSUMTg5X/ALhmxOfcRsTIDdvl4fQr3lE69Gtj3pQRldVgw8x7Cn0Ip82CsjdXvcfetH8EKu4ceV6uQqCRze7H7Tla3sqr/tcBXBsGsWpRle9bS2vkL2BVkBESZEubM+h7sciTZA6f0ikigzuyqsgthhStHvyPJixAJhR8sgJT6YaiNqBAAYs0FZN5iYHRLJJ10n4drp5MOO2bFhPNFEwwCS5+yCwqQsvYXVzCqZ12kiQqs6xp1JBNAZCUqvopR4Iv3SzTfvP3fih6lG8FkAfJTrpmVPK8a4dZG4v0NpBx0fnHoSVP0itwR+KUe75tCYdeDsEhuC3l6BHy9EGSR8W4WmYqVpjwHS9ubQ65HW9wMHow2NjcIBidMTymQAdcdPIZiAjILwnV1ErqyzMf4F1wLHQrR6OxpoLrI+qrGK6SZ+z34nrQbwomuyX8DeLezZM7H9fWGH+H3Zlxmdw4OWkmdK0WNfs+DkHdp3hFoCoJNvIw0WoNI/hgbVSW8pkq65QpB6qa04K3S/BD/URQDwcvB1wUcFEVIhk3FtZT5Ef9T1fYRROM7tZ2W4k9A6QNR69+aflYj4QnKLAAPz4njEtaxZkjY4zsTwf2fehuya0K8rqy5BxMgstDBD6Dt/TiEwN7XfSNWDC4F8SwnmTTIC/Ndxi62+1KwSa3
 I2syjH9t
 RcxR6kT+IQq5AfhFCZS11gjeq1xImCaR6YaSLstMyWlucuuBIuZkK3Pi+B8bcn3E8YW682ny/Qq4NJNIxjNQYzJmPLuz8inhvcldCstCF5ucKCJyh1QPL8REa3f3MEX15zashbPmXapFE24tNueRcuzKD79AGyhAUYLtrPokd07MTEPCqHzA655yMc+AEaZ/yr+CRCzU2nuT0DEfkI9JwhFWhRpQWk+iIsw7vOua8juSYqs3iWun13fmRKc4VJo42xh348NIebLcelJ/Ahb7x+uHu0yLU5syC1AEpPBTJXgXzQP0mDCg/MzwENjIdzcRO16A5ZALurlLfmSaPcSQLblWhrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 12:57:22PM +0000, Dev Jain wrote:
> Shorten the name of page_anon_exclusive_sub_batch by dropping the
> "sub-batch" context - the function itself doesn't need this context.
> Similarly, drop "sub" from sub_batch_idx, it is unnecessary and the
> usage is clear enough.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/mprotect.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028cf..c0f5ab74bee23 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -143,7 +143,7 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
>   * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
>   * that the ptes point to consecutive pages of the same anon large folio.
>   */
> -static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
> +static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
>  		struct page *first_page, bool expected_anon_exclusive)
>  {
>  	int idx;
> @@ -174,16 +174,16 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
>  	bool expected_anon_exclusive;
> -	int sub_batch_idx = 0;
> +	int batch_idx = 0;
>  	int len;
>
>  	while (nr_ptes) {
> -		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
> -		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
> +		expected_anon_exclusive = PageAnonExclusive(first_page + batch_idx);
> +		len = page_anon_exclusive_batch(batch_idx, nr_ptes,
>  					first_page, expected_anon_exclusive);
>  		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
> -				       sub_batch_idx, expected_anon_exclusive, tlb);
> -		sub_batch_idx += len;
> +				       batch_idx, expected_anon_exclusive, tlb);
> +		batch_idx += len;
>  		nr_ptes -= len;
>  	}
>  }
> --
> 2.43.0
>

