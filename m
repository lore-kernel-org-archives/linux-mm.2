Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEB21112259
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCBF86B0088; Wed,  1 Apr 2026 22:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D326B0089; Wed,  1 Apr 2026 22:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93336B008A; Wed,  1 Apr 2026 22:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB2426B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:29:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4808FB819F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:29:28 +0000 (UTC)
X-FDA: 84612034416.16.30612BA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2049580008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:29:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mMxnb0PN;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775096966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmnqoq7XLaeqt8PJvJDnQ8Shu5xBBzwbtKsYJ5s3QfY=;
	b=2bjGcClHS7zhI1p40VwCqssMpKaoO794EVB0nJj7/UKCLZESTM4EYRIECj1+EFeo529mKy
	PzEtF84m0EBmzLuzqAAS8nCFofYKhqDW6rWt6By4Cp8qL3o6pnG863fxJUMEQxUxdRqAlr
	8LgxRxMyEXDE6H8rC+yyh9Lc7BAr1Dc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775096966; a=rsa-sha256;
	cv=none;
	b=OjVCNATVPpMZflJEj2oC/9Y893ZV5QdVdA+2F1oz/qLCRmMM4paa9jr0uAtjbDWb9MUoHl
	rMklycmB9q9Tr0KBVC1JDvy7mfrecBEGgpo21bBRHgL10Vx4Cb7QWnl5a5n3kQcTfK2km5
	OYNRMCH+H5CgdwqKk3qkaV+elmG4l4k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mMxnb0PN;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 046031C14;
	Wed,  1 Apr 2026 19:29:19 -0700 (PDT)
Received: from [10.164.18.48] (J09HK2D2RT.blr.arm.com [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB36F3F7D8;
	Wed,  1 Apr 2026 19:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775096964; bh=nGSbM6iWNi54IURbVCZil/MROs/YoY4WcW5y3ipipU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mMxnb0PN+5JHowx4quU5bYmHMjpVXMzynlXHrEmgDoIIX/TbQNMvcmrGa76T5AesX
	 ilGG7tqqffCV+tINYeGIA1qANdhTxsWdyXKzzA22uMUyfcWl+2gH2nFMPJB2RCLgTc
	 qnnN/SpUEGFmWY4FB3gtH/J3h+t2gLQENg+Nw8ts=
Message-ID: <a766efa7-90e9-4867-b908-1f2073e59735@arm.com>
Date: Thu, 2 Apr 2026 07:59:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: cleanup flag vars in
 alloc_pages_bulk_noprof()
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9qexd3pjsoq5jyi6mdhkfjuff8p7h36y
X-Rspamd-Queue-Id: 2049580008
X-Rspam-User: 
X-HE-Tag: 1775096965-829946
X-HE-Meta: U2FsdGVkX1/ktcrDuDoPoMr0zfyQH1KauOCygCQUDJozAOA8X0n5DWXQbvzre3LFCeeKN/hm8LX6qjxAtRJVD+0S8YaHfFn1CdRgbqeEuw9/i8o6xRiNCRM9llQjbtsMKW1q+n6W4UPQ485tfnCjYVVtUT8/8SWkzPXi4MnfIPvVdjyhkbUrgJXmRQmHLgI9S6nD0NTaVH2EKa5mJaYnAkpmGhARTrQgiKcUuhmkbBJLiMLc7sWo1NPfl2JgT3TQaY2COum0+fucjPZfULKL2x48TczT3XTNtxHcaVopU2xglk7Y2nUZRkPluA/FndBd81A+vkR7ifop0xK88gyXBwr0O42lcR0jU+emcJ5vZ5LIiXYtDP16BtUFHYxb8HwxrTMBbRt/pPPVB9j1m7FjagS1XCTgiy+lVAi99A1MkBfq71vhy7zyBKbBXCjlQ3/E5UXw1qa3JIWXN/PdZeECPUWBQSmr6RxkptorNb+5oUSsHr9jVLZSydRufx2wEnoOLaZyPSk+BMAHYIwaZ25qIylEi0vkT+q0eBbxsctS6Py/u7RNc0jdQ+AOm6izHeDmFadStpFVxbmzX00aRI9ExKoNRYoBCaCDcBtf+e2CstyQrX7es3EeuYYSHjOOL80fTG+c3h/Jk/9dOJg8xrSVlIIRvSonDp04bczXt0jJ6Vu/ITtRhr8FcxXFgMa3erRr0OjBdbso8NwN5anfXAjAgqv91DFqXIiC7e7nN2/HtFaE5qsLogVi4ucVbcDT/zZ/ttRVqX8g6l4S2EUs4nWwVispNNBEXF7SU2SP4QskyFZ3oAk/KyQO4DFNga8W1huL7G+cOJqreYo/JyWk3osuI/HRYPR+QjSynG3CiXp1dmFdH23n78tqzvuLop/hr2zoo2Lb+8pFLT78bWeIxS2GsqRtn8E45GB3fPBYPelkkFYIKkKCC9VCfLMQ3NoosIvcqBX75ggp2rvSiFfAUxh
 mDOU1QFY
 qRrEZj4GvE/7gUg54RSd7c4vS6fyoXoIrSh5o8ECSuG1NxT5SMZI4Hq4W43GBC1sVMcOAOWgT6ZMH7OpBrTaYkLY3QQwqdpoxBz/G3IEFrq8N1rKLRMVqsdpzDP/ATwZyG4vz0AP8/sRZTSOEZv3iXLWuRvfcFXDIht6hixb7TlbNcCbrQHKITQAhy+3+I+ogN4dABDtVQwRJHaHDA9wFwks6aS86+RxEPQyWJsCV/V1ydvGWgJ1JNoMdKFHKPkmVU08cKk98nuHfd9DIAMKiRPeEUHRyYWOX4DNDdZ/iUKYzrUEVRkRInSQuMys2Rac8ozPthvSoANM/F849vYjzISfhENDTeOoO/hVhrfKznXK4CqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/03/26 4:22 PM, Brendan Jackman wrote:
> These two variables are redundant, squash them to align
> alloc_pages_bulk_noprof() with the style used in
> alloc_frozen_pages_nolock_noprof().
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 111b54df8a3cb..5e280ded6e7ac 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5051,7 +5051,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	struct per_cpu_pages *pcp;
>  	struct list_head *pcp_list;
>  	struct alloc_context ac;
> -	gfp_t alloc_gfp;
>  	unsigned int alloc_flags = ALLOC_WMARK_LOW;
>  	int nr_populated = 0, nr_account = 0;
>  
> @@ -5092,10 +5091,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
>  	gfp &= gfp_allowed_mask;
> -	alloc_gfp = gfp;
> -	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
> +	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
>  		goto out;
> -	gfp = alloc_gfp;
>  
>  	/* Find an allowed local zone that meets the low watermark. */
>  	z = ac.preferred_zoneref;
> 

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

