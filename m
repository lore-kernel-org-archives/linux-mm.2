Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A14E9DE59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9816B0005; Thu,  9 Apr 2026 03:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A956B0088; Thu,  9 Apr 2026 03:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2703E6B008A; Thu,  9 Apr 2026 03:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09ADF6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:28:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9528C13AD02
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:28:27 +0000 (UTC)
X-FDA: 84638189454.08.EADBBD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E633540013
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:28:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="snl255t/";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775719705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3LG8Dz8gd9AHYIB4p8EuYclxKxuB54Y6HtUrUETz8U=;
	b=E3kjQe3YYExvkb887DCuO50Hc7neq9wB+vzydX5rnGQXGFZ81V6WMUXOLo9FBQtjyiXgqK
	gKl/aJNHgeJKilaQ9Aw0vvAagq7QGVkGMNO3BUkCKnVMI8i0OkLHcxooq42C6TthHwvmaP
	5rFENgmKqWoCVbFPUy6NiHCog4Pt+g4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="snl255t/";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775719705; a=rsa-sha256;
	cv=none;
	b=6UDsrkJrezBLyrke0VuOOyqp08FtAsbtM3y9lD6ECyvuQpiw0cPmGx3JDxxF01EDvpyZOt
	LvcjM1cJTuYqC4qZqXWXcOPpKxPEAd2hni72WdmQy7TkOtd4lRiTmhQoAZRM+XmlITqPTD
	bfWNEnNl9fA/5IfinaAnCXofsOKjqqE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52806600AD;
	Thu,  9 Apr 2026 07:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECB2C4CEF7;
	Thu,  9 Apr 2026 07:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775719705;
	bh=AFuuA2kCB0WPBJmWs5H/bbbfp3vCGHCkATOf0ZR5z9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=snl255t/ijvpw2tmon99P0lAzmqZktGYSNqXj8saf8pOUOiHC+uzvhCYZorST+wn6
	 Fp6CHfYF0mvg5/ifr+XSdFAelF7GKuSMtEiIcaO16BS7uaraJ9qEHKIWOGmz37NhP5
	 ULjT2tDHlrmtFXlhJzfArfl6ZQ6odmZp2eDoRHmlu2Sl/9nrJtFcOl4l4i927QIN3O
	 e8tiuqSUxQCCBAS2WRTqOHnq8O30WFOg5SSgxhWrJg0x1TV6o29pvY5SEWPJhOorLG
	 VeI/+My+OY7gbTBwIb/Xyy2nEljyJxrQjt6BDITKpFZk6ythIwhBr1wM3i17MHaVbQ
	 ToN6G9ZCqGCVQ==
Date: Thu, 9 Apr 2026 08:28:19 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
Message-ID: <addUV5LBEvBxMaIW@lucifer>
References: <20260409014323.2385982-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409014323.2385982-1-ye.liu@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: E633540013
X-Stat-Signature: 9665bszc7sj3czu3zyzp7bebs34axagm
X-Rspamd-Server: rspam06
X-HE-Tag: 1775719705-451688
X-HE-Meta: U2FsdGVkX197SZlbAd9LIIOHE1DfxXaV7n5b/8oj4qxHlgE4hYrjAj/mR4gRG6R7n9FGM7/vfiXATWwjvZ7wR++2WlU4S14nfkwCjREhaTkWdkRt1Ay6ns6jJgs5X25YXEOdiC7LI0540PLIiuxeFI1ZPg5X6at+OD6dAxtVqqMzX9DfO7Cf4GP+208WaZ4Gynmn5XWn7gLqgtb6KhbEmXsv0Z8+iHBD0Jzin1pjcy2HqnOQUhl7qLqsp6SekU709i8Hw5+62832HRS4u3PfBMzwm+p12el2hXsJrXuwXRe//WcAhBRBGu104UgCT77j6sxB2OiArHYAmOIOYjRPKSUeohpCe/44K3NEwtVF4dRoXXIYqtrGtUYRQA7r7joqXSpsz7ruARKhAdTHwAa+FGivdRR7sWxziIdEnMZSd/jZ9Hk2E/QkFxtGX4wOLwZU5UHqFFAy68vqHX58bV5SIPclhOXfogFk5mxZygl0982s4Aav+tNLud5XC4sECYRsrmBb8Bl3Dhp3uZVsnOEyakpjndzPKs20a4pmbm5pJ9xflsNGU5Nkg4zDSv1rejDIMJEfL8V/iK5eeyQ49/onAwWPjL6YTiId6wfzSU4FhR20J9JLF0iQ3RIlj80GM5OvukyHV7N751bXyc5xX1nryJOdDGqfT+Xd6ho1JX4tGJunZtLOAvjKyZjylsQ1TY+EUzgowCAzDUkdrbPH8wi2xYeNW8tt2cjgyzNA1v6FzseuCvMcDaf+49G8lZVJ6tRYd+q4tF9o5UI5ZSAmWcMo1uKv62pRjqPQLYlEJs0VyMiwLlbj54D8eSc/TIHNNYGnpeRkpaifEnMoDR88/VDnuMmm/qO1yJiqBpMapMY/r95h6iIyjszFYApObsDFCW91bjj39DGld5RC6HwYRAaAis9fgOpbD1osPU0Ai6SvAoWwWAUh0LDTlOzx2UA6n2lcx8q88QUNEsHdFT3e49W
 /A+V0ooj
 MHZHoPu1/p185SjsHCyfxX06wSLV7dvPxIFx/7H4kOQh25wE1P7miOe3zEaNe6tQdnzLr/RYhetf2vN3h6jZTxqY33HF4FelLVDfPxu/SqoyvKjjZps6S6obGsa+eskmQLwMeXHVpVIPhXYYvT7qvsdABhjqes7lkLS96QTyMF7jBMHxCt/5CVK0ZHzMCPV9z1rNtbwb5Gbeljm7iHY2DH8iGCVqLlZcj//w5J0pf7CkecWJIUE272SCoDXM9MSSoq7fUrrDJLRnaPqu4LP7ZxtdFZTc+GYHfvE0int3e5EWrJHEDh89HPrgXBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 09:43:22AM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> PMD alignment in khugepaged is currently implemented using a mix of
> rounding helpers and open-coded bitmask operations.
>
> Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
> alignment, matching the preferred style for address and size handling.
>
> No functional change intended.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

>
> Changes in v2:
> - Switch to ALIGN()/ALIGN_DOWN() per David's suggestion.
> - Also convert collapse_scan_mm_slot() to keep PMD alignment helpers
>   consistent within khugepaged.
> - Update the changelog accordingly.
> - Link to v1:https://lore.kernel.org/all/20260408093534.2373007-1-ye.liu@linux.dev/
> ---
>  mm/khugepaged.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1e2bff40d014..1b1d1a881ec3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2518,8 +2518,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  			cc->progress++;
>  			continue;
>  		}
> -		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
> -		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
> +		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
> +		hend = ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
>  		if (khugepaged_scan.address > hend) {
>  			cc->progress++;
>  			continue;
> @@ -2835,8 +2835,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	mmgrab(mm);
>  	lru_add_drain_all();
>
> -	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
> -	hend = end & HPAGE_PMD_MASK;
> +	hstart = ALIGN(start, HPAGE_PMD_SIZE);
> +	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
>
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>  		enum scan_result result = SCAN_FAIL;
> --
> 2.43.0
>

