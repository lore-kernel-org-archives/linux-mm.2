Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BCECAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 03:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736088E0005; Mon, 29 Sep 2025 23:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E49D8E0002; Mon, 29 Sep 2025 23:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA378E0005; Mon, 29 Sep 2025 23:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3308E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:18:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E681F87827
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:18:28 +0000 (UTC)
X-FDA: 83944458696.05.E498352
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2BFED1A0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:18:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZUDOBY5K;
	spf=pass (imf19.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759202307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGNLCKGJrXLWa6eAFuG7oNqbsQrVZxx3Sl0hu9yULUc=;
	b=NhN7BS5EqLis8yT4Sz1i+P27Ph/VGf0QyDwLYxLjalKTJRRkoUJ74c+91bqOw1K4aJepSX
	6jHSbjNHCNUZaFSIGtgKVLyrPQacA7a0EfRjtdw+YEdYIRHfa0iSxdUNNcgHN925lyETmH
	SjMmVYyvoOL2WNdNXcQ8YiFndgIys5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759202307; a=rsa-sha256;
	cv=none;
	b=S+5+R+3PTCIVmbwwdd8E/4V7VrE+SPiuF9IWRvxHbzd8v7+JQaafeO11hv+52pyZooEPQf
	8uJjCq+0PuSbQwsFhO8TvBJwhC62usEjFzDx0Tw3uttiEQsFqi5c1pRZh3q3txV+VIOElK
	WcG8Fr+Y5mbmWR4CDr26OQSTH73mq34=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZUDOBY5K;
	spf=pass (imf19.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-72e565bf2feso57689127b3.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759202306; x=1759807106; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PGNLCKGJrXLWa6eAFuG7oNqbsQrVZxx3Sl0hu9yULUc=;
        b=ZUDOBY5KSXMY8TB5F6jVjTr1LW5//fi0AL+7lc1NcvtRqCIzi1iW7321N3xR76em1T
         capjVcbfhaV9+ofcuZBoITI4GBM1F8ZuElzNJhkVgKt6vuUCmRVbKQ/gHXS4qsKZ1P9l
         rLV+Gp8qYl1nMkJkXPI1OHJBf/bT6BF1RdiKMHZYNvVCbdiictcU1BfHeGEMzIZ51WOG
         JzDMIXi9QHHaZBe4lQQF0h/i2vko2cpqBIA0Zp/JDdQnHiMP4teVcov9ZDjoByLJR6uy
         cFmGOiYO9h128iLtfyJPfxlBnS9G4afh1/CpIQakVT+ez98oONmn82cgFLf8/b715niz
         HIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759202306; x=1759807106;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PGNLCKGJrXLWa6eAFuG7oNqbsQrVZxx3Sl0hu9yULUc=;
        b=J6mWRzym7DNS7DC5lX7Q5rvMven2Jv7JyR64txOaqV76VboUGgQGDZQya9n5Pgo3e0
         pCSFJJhnSgbONqkd7KXFcb0UtUBg08RcpSWXwp9NC7gVPCGMiUl+6HTh+rn+fLw1n1UH
         o1dj0k9/C+XqHOILfwys5oqgCX2Yd3771OaFXNgP3yH1kCqvF+wdML4D4xIWit12v9Zq
         SVKPWLtk33XBIkB4XgCNioHNVienX3pYMAZi0jj+XRhIe9S/4VXTvHHuK53tqsBkxFIn
         pQPZ2IW4pkpI+mzaIOoLAoCy9wUD6lSRyMYiMlvhXfWtE6QQKVWN5IAkffl37utLUw8d
         ZB1w==
X-Forwarded-Encrypted: i=1; AJvYcCVuAyHrWI+VD+vTQzq0/PDhNPf40ZUI0JrhYmPsPK6BHdzYPpMbbsXQredgK+7NvhjmDQCwuP4ufA==@kvack.org
X-Gm-Message-State: AOJu0Yztd5ad1Xf3NvToPZIuz0th01ubm66KkmkkliA5zR2BGGi58Qqn
	Hpfo686oqyGqIzC4NDkAqR01tk+rzBE3PHx04yF/HCmJGDqFw9WKjqkF7A/ZigHajw==
X-Gm-Gg: ASbGnctPL83xGaLh41RRGeM6EiWyGkVbaXfkYibvtbvWVWf9fyMM7lcTYqLAS6TdYgX
	SxcdDFlKNe20TdpZ684j+nfZyFd41J4H+061fNqRW4KZBBlyIYtfMXyE8kFt3zrVCAmGmy/l/ed
	XuolN/2pXr9gSOMbMTp5XUl80aETI7XpNd5psVsL+8QIpXlGo06njuYm6kOA2RfORoWOi1E2pgi
	s/OOAIveT/WRuZVLu1wXD+Cw/QBC/nFKp6XEa5Kwxe70zjV4bB2yskp2jT52/Pu6zXVR3NVLIoP
	xb+/Ha+S6CqoPzsLbOezZzw7RmxpFa/39yxM4V0INkVdPISixvvRMNVRuvbZKpI6GBuRK5FnmWQ
	IgLcYHFS/72hyjZFHg6M2e2GNoKpo8F9t1KkItg+yPAgqs5CyvYv0NVVTHcPLopETyAWgrPBacz
	F9i1+Wxq3M9X8iMAZ9uDBqtuB1UYuLjvO6HQOk
X-Google-Smtp-Source: AGHT+IFcZqYas2wBQmI9BbRmqml9F+2QA9spZ9yKoBd8FyOombPucba4gtkHHMksFeRZI+3E7DFoZg==
X-Received: by 2002:a05:690c:7302:b0:734:ee:200b with SMTP id 00721157ae682-764052014damr237888467b3.51.1759202305941;
        Mon, 29 Sep 2025 20:18:25 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-765c77e72d0sm34142987b3.49.2025.09.29.20.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 20:18:24 -0700 (PDT)
Date: Mon, 29 Sep 2025 20:18:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: SeongJae Park <sj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
    damon@lists.linux.dev, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org, Xinyu Zheng <zhengxinyu6@huawei.com>
Subject: Re: [PATCH] mm/damon/vaddr: do not repeat pte_offset_map_lock()
 until success
In-Reply-To: <20250930004410.55228-1-sj@kernel.org>
Message-ID: <07267988-1736-1372-8994-76892c5cc804@google.com>
References: <20250930004410.55228-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 5o8d858cbq8tuq8zdi3tyd4akogobgfr
X-Rspamd-Queue-Id: 2BFED1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759202307-768785
X-HE-Meta: U2FsdGVkX19SE/QzSjEpw9GkYh9x/bTgT7uR+ZKOndJzgI4XiYfEiC0PuItOVUysmDLrDjnvx4KYNw3q1eTAtZYKImimU+0vzAMaGc/6WQ9sLGpBTydGv+HqpVBYyJF3hvv5RBBi8rCD7VnGb0dj17bCNzXurDTB4ZRkSElyS89q1tE353wg8YtrxKTjNDv2j88b+xgm5u6bM+n++DzPzYvXlm2zRrMkUeXFItbk5CS+wTmQUuS13iEqM/h6anJgKOlBSiamA7QPsM+XayPcmxavWx9POr8gCxrP3VgZ/NqusBYV3A0A0DVSo9Sh/mnS3w056wilb9npa4+1Rpq4V9cQpniQP0hJnDx4F5kmbnuxAxnTXxHJl+ICswvwLeDCNa3UwVPNHT6C9GiVtZBg0g4iw7GiYYI+AtSJ3RWT8MyjZLfRklexg3D1LiOnOa/kBi9O9MePdTBgApx+jr4fgTzo6Y/dSCOYU25SI5LvbTb/oO4oYydALPpnKDHQp7PvIGHnM0JQa1ci+cPgot+rtJJ/9z5Xh8biD6eRJGw5+QrHInUeY5CVEQO0E87E8nIMzH1rsHhdfKq4gCuMixhTjZrMx84PmMgnShROM7A+KzDjIeUnuvVRn17PnrgHD+aaOhJZco5xi0wZJDryme7EHx2UpnzuOtiDew2+LOUf3W+YXKFivQijvMWu6etskMx24paby/hngY7A+DhG9m3U+pkTE3nSHD+Vy9Se1g+2YCYf24RoXSpWC5Iqg69lhhJO3NHPT84hnnEvNt8mb6RuPZ36eYFicL+sfcaUGEHX03WAtVuEdtrzKYL9rfMtkvZQLmt9fdYsPY9v+kXdJhNjRQrX9532yyBel9wLZq0rwOydNm8Lz0g1LQ/YdqxpUf+26zbhygriYuQSwgfNERB6jf8rMsXvvvOl3ZALILGxa6//DMWDM3Ks2QnSGsKXVZnFi1VcibaFPEHffNpNebt
 fK7Nvs8k
 9zal+J1SI25Tx0fXAqHi0g5UeF8mScIql4wpV/XNiugbUynd9S1HY3PcjpuOUSNVkECrQl2zoaUzh7mSLFgeLapw0ees1ENLhxP8MAXCTyEOlp/uvGKcOfHGVCPpPBDpfYbiEcI+6mi+uPNdLFwGqfxroqynar47db6uo47SyllcLN2FtIdxcIeoHXZTWyUtfzjmd+bSJICzSBCqNpWFY0Mdp4uCsb6HnnixMBzMTg+y/YT9fCpTtRcaGcNrDhNl3g3dXEfSY9g8V+Jy3fUSdsmar65VHMmrMi+BVa4oHVYH01j3H9bELzgPUPuqflFS6nEK8in4lCxTVTRAn57eMEgv5BaYsHssa3eGRf/OxDR1B8VXM9jUjNpBfUjSB7VkAmE5qa0f8dILp8+b7//T3FwLZ3GIj3NzSvHJYtHYVX0WnFGhS9I2aFgE1H7j64w0PbTsr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Sep 2025, SeongJae Park wrote:

> DAMON's virtual address space operation set implementation (vaddr) calls
> pte_offset_map_lock() inside the page table walk callback function.
> This is for reading and writing page table accessed bits.  If
> pte_offset_map_lock() fails, it retries by returning the page table walk
> callback function with ACTION_AGAIN.
> 
> pte_offset_map_lock() can continuously fail if the target is a pmd
> migration entry, though.  Hence it could cause an infinite page table
> walk if the migration cannot be done until the page table walk is
> finished.  This indeed caused a soft lockup when CPU hotplugging and
> DAMON were running in parallel.
> 
> Avoid the infinite loop by simply not retrying the page table walk.
> DAMON is promising only a best-effort accuracy, so missing access to
> such pages is no problem.
> 
> Reported-by: Xinyu Zheng <zhengxinyu6@huawei.com>
> Closes: https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com
> Fixes: 7780d04046a2 ("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails")
> Cc: <stable@vger.kernel.org> # 6.5.x
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: SeongJae Park <sj@kernel.org>

Thanks,
Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  mm/damon/vaddr.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 8c048f9b129e..7e834467b2d8 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -328,10 +328,8 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	}
>  
>  	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> -	if (!pte) {
> -		walk->action = ACTION_AGAIN;
> +	if (!pte)
>  		return 0;
> -	}
>  	if (!pte_present(ptep_get(pte)))
>  		goto out;
>  	damon_ptep_mkold(pte, walk->vma, addr);
> @@ -481,10 +479,8 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
>  #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
>  
>  	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> -	if (!pte) {
> -		walk->action = ACTION_AGAIN;
> +	if (!pte)
>  		return 0;
> -	}
>  	ptent = ptep_get(pte);
>  	if (!pte_present(ptent))
>  		goto out;
> 
> base-commit: 3169a901e935bc1f2d2eec0171abcf524b7747e4
> -- 
> 2.39.5

