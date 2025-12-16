Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E003D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909B06B0005; Tue, 16 Dec 2025 01:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0CC6B008A; Tue, 16 Dec 2025 01:34:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834B26B0093; Tue, 16 Dec 2025 01:34:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F65B6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:34:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05616140513
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:34:10 +0000 (UTC)
X-FDA: 84224369502.26.A97C062
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id DBEBAA0008
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:34:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765866849; a=rsa-sha256;
	cv=none;
	b=VmZxAojZQaYe4l9DFN78RRIssJZrRa+X3aMGiAuB6jkl4OHXBiTJ3XSzbKrSgM7qRazuJ3
	tVVjQU6HDm/QnQKydVImFUlymxzQ6/fEU1BbCvx5rzSV6BGmZp2dz7g6+Hd1X/oFnwWLhs
	wp3ygtxqVR4KODnk1N0nVedR1MZOshM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765866849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zF+yOXsenVVHxW/loxT7jxzjmDcF5Fhx9pt/nUPnldw=;
	b=LIKHszc1Q0qak0UZ9mDGzXG7Otl9lc35BVRSc5zGE3zHzJmJr8TtCfqS9WYG+9Hd3aVi7c
	9oCDxfQ3oGvmynN9+sewdlmf1jd7/YOD4/0l7sDUr0wHVuSyFZP/Z+vMohhdm940yEx3pW
	jQ/mzaNqV+r4CUjzMrWHcfyK8nZw9wA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2544FEC;
	Mon, 15 Dec 2025 22:34:00 -0800 (PST)
Received: from [10.163.80.100] (unknown [10.163.80.100])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AC313F762;
	Mon, 15 Dec 2025 22:34:05 -0800 (PST)
Message-ID: <3c86d612-aab7-4e80-bc6a-3ccf2bab9c34@arm.com>
Date: Tue, 16 Dec 2025 12:04:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: add mTHP swpout fallback statistics in
 shmem_writeout()
To: Weilin Tong <tongweilin@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251215024632.250149-1-tongweilin@linux.alibaba.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251215024632.250149-1-tongweilin@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DBEBAA0008
X-Rspamd-Server: rspam10
X-Stat-Signature: w336mhriggc4rka6dap33n8ofbrh1kjf
X-HE-Tag: 1765866848-485643
X-HE-Meta: U2FsdGVkX1+8kh+sf9CbZaye9zyZ8WQN5+PuJ8pX28HWRLi5vPwrX1oMurc3ejRU1ax80wPnREf3mnw5d/1MlvKZtfV2i5vfUpTKaW2TzbN/JJUY1KlbIfepueTfi6LOxVtN0zYmhbaGnmWkoSID0JP9gnI6FG+Qqohyp05kMyGpRqQ5Mev3y05GeicFysk5F+eAlcPaohOly2G/SSIQEPTcHDcJOnMjPDPyAK84Kiu00ArysYpIj4u8nkVeHUu87B7T9Y/X3Zz/WdAbgpJ9ezT+gN59eBr+dCBA+zTnU716E9fo3dJYT7cOFECRuQnq4Ej7jB0z+ZT57PqsDabGRkOJA5fxEShWfU+eDhk/unHtGekm0LwIx0Nd5eLAql3ZkerEJKlb58oROTcMUQqqU3khiexoJUuWCFvSVPrkVorLfSa8p3EMHvSeaEhc/swRm+c2jE9A2V0LgIDmliU/I5tWmy0cMtTiZ2X12CyVqWdpXq9KAf1KAsswfgKE8THsGCNzJ0w9HnZCYCVl5YIvBuL9d7Ag3q4FHiqTPI2cNKzw+rlR77QJtqdyEvryLZz7UeuO3HLhldwZfhYGpxODElyCW+PLcXpfiG22B3J+80inWuU4CFiIq+wKDqvbRyRlnUIguSA1ncu01+A3LD7+KNA0DtX50G+oMzTqBXvoJ1lr7vWAx+KnEVMrCZoapwpIOS/b31UHhD7VLNd24qMRnEajvpGvmAvdeOdbhW1fgwwsxwrjgic9FRP9PiD15vCUAl04UH9VwW+s8LKgxkd+TnCA58BefnuSbCT90rFuBjeng+WzEk/+VTc0+ClKI2np3iZIa84/IQIwf0N8KfHARcCDLwmjNyU8uztQvIYpOymlz2vNK7fFSwMBdStAMFyJsVgLew9cfOT8sWYf6CvX5o4/qlKY5AWPKfCN9p6E5KTGGX0aAcZUqZ6KJm03X+euNb4lSHPgUS2tszPHLuh
 QxRCWaJo
 egN9xwQ7+j8ceAQNy8Xj8x+ortXR2etl5kLQrUwE409M2B7DKv9sT6nA+cNbYzAneC/f/OVsxL+hribuwMoJFR/Cwhiy0wMGVZTSOC1HaDOA+CtWDzhKTJIDvHjnxhYRHrwSU8xWwvCax8ZMnnONIaO3JVpQUVyhDdOLLgGedUYtED71tE662TJMrEQxAWtuYzJ+i684lrbGByFpmZJCEH3rs7Do/z5BRA/1ZCwPfEpslpSEaCGdnWRscZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/12/25 8:16 AM, Weilin Tong wrote:
> Currently, when shmem mTHPs are split and swapped out via shmem_writeout(),
> there are no unified statistics to trace these mTHP swpout fallback events.
> This makes it difficult to analyze the prevalence of mTHP splitting and
> fallback during swap operations, which is important for memory diagnostics.
> 
> Here we add statistics counting for mTHP fallback to small pages
> when splitting and swapping out in shmem_writeout().
> 
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/shmem.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3f194c9842a8..aa624c447358 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1593,11 +1593,23 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  	}
>  
>  	if (split) {
> +		int order;
> +

Could this be moved up near the 'nr_pages' declaration instead ?

>  try_split:
> +		order = folio_order(folio);
>  		/* Ensure the subpages are still dirty */
>  		folio_test_set_dirty(folio);
>  		if (split_folio_to_list(folio, folio_list))
>  			goto redirty;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +		if (order >= HPAGE_PMD_ORDER) {
> +			count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
> +			count_vm_event(THP_SWPOUT_FALLBACK);
> +		}
> +#endif
> +		count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
> +
>  		folio_clear_dirty(folio);
>  	}
>  

Otherwise LGTM.

