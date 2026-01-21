Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE402C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2182C6B0095; Wed, 21 Jan 2026 12:47:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5896B009E; Wed, 21 Jan 2026 12:47:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC826B00CD; Wed, 21 Jan 2026 12:47:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 015F06B0095
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:47:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A38F91A0955
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:47:58 +0000 (UTC)
X-FDA: 84356704236.06.73547C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DEC471C0196
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:47:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qNVl0Pce;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769017677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bG3rA+RDI0i1SoIBjHHPIVO07dAZDMlWdpiEDxSqAQ4=;
	b=EwBRBAZHLxcHUXULdnouSmo4SGHeNaI7ccDMW6mNcZcrLAawsHskV+P2fRYm2W0IX3XlKg
	rLK5cFyOy2eFeRF4T21ykNniNlKB/1qbFnvT5g3YE5GWToNGce+x3bmF2BCaSkyOBTeS8r
	so9cEnM3PCbDUBFqQe1Uq5wAZtBF/ko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769017677; a=rsa-sha256;
	cv=none;
	b=rDv9E5G6unMaEJ8fWCEB3zsOa+3lpwFTq8WhRp/sifF8wEjupCit+EstVLFtSlcZ7aHWJe
	rhfKHsxXxtdyykoq0YmTmJAAYUk1NH9V83Pwo1FZZOvcXSiET2dvfsrLYPV16MjY4a1j6e
	wn3Vfym90r1ggX7UxzcG1nbXjzL6+u8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qNVl0Pce;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D9A4A4438E;
	Wed, 21 Jan 2026 17:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB6DC16AAE;
	Wed, 21 Jan 2026 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769017675;
	bh=rap4vjdO701PMJ0MSSHR1FJS63P4Y/x0kEK7INx+cP8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qNVl0PceI+avxBpsPvq7rcWBKYDLkrenJNoyNu/jSoKgkPWd7mU0nmGUhQFfaOF4Q
	 2jeMghqGIxLJDjJGlwlLg5/tHWYIUbrvoA/9FS2tXMgH9zffiK+Ntnq3NjtKARcA+u
	 XB0TAbDZgOKFuOM7uj6DyX6Cr37dIRS8C39rcUTA=
Date: Wed, 21 Jan 2026 09:47:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Wupeng Ma
 <mawupeng1@huawei.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/hugetlb: Restore failed global reservations to
 subpool
Message-Id: <20260121094754.8a30b7f7fcff34f579883e40@linux-foundation.org>
In-Reply-To: <20260116204037.2270096-1-joshua.hahnjy@gmail.com>
References: <20260116204037.2270096-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DEC471C0196
X-Stat-Signature: ro6bck3gi7w5w3ykwfiodtdtms9teqcu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769017676-530523
X-HE-Meta: U2FsdGVkX196VdFoZvZFFVxcOUIH98OohmRvp5TevQMCWF5NhI37YCc/2DoR2BdOaHwmz8q/pJxaejjwX2ztUa+ZOIwvaSw7JY5P4xCRQqIvEsn36sbrb7pX2KC4Dlq1Zang1L6VpxHC6dOd4hyc3BO3Erwx5W5qRxGB4xJHrKdZE22PsGuLoponRXyNbVlsuVD3W1/of2rFysEs73tJVNjkog1EDBc3C1nKOEmnL6yYCGHAlQXmNuWATZ5Pxwt1+ZNaWeFLjXD3yUhuNUW65y/h8qNj8b00KsoDY2dj8Us4l6dAWRGyqBtizRfWZVBJOtsUGd1h4rSbJKCHr+kHXb5fHt6YxhPwceTqsWoiomUZ0KrH4kSW1R2vtqICVw9OCCgzCWnshtTm49Q3x/TPwF22k88BuHjEsFo1DSucDvN3eKyakRjM/ZtrjFAxOJGeZEl7NwcksXNeeZNQCUH5vC9nMpYEM1RfDKoYQD2U/FVDq9LpwnfdXg8wUpC/bXR1O3E8F3Hi6YtUPVWo7TVuZHMs7dqIK2UFusoOuAvaHbVNZDt9OkoeeUFtVhf/e4cw+sMtvE+IaEX0/QrQmLMQ+z5XhwCZeTVmwJow3LbUATD/wLNchxFSd+1m68PX7expyKyZ7TPi6yS8x7rKTJYRZCd7lQcC2lmyILOZCDfyhff+8Pagr2MaIhparTcsGrBuGKUIxCYMKm/Hux9Tk2lKaDVO7xHZDEeefer0F5s7dHHQ2Bv3EdxmxRXpovwOdTdAkfmnnqpOxgbIqhIcclNfKOfXkVRJ3xgOPef21GAYsT7zzbgJfdoixlZ81mTjqzvVSgGNcfZ/kCoStViQmCkR7pfC4Ylz8YkYmU5PIeiPUV375Sf1GK4RzJzHG663YO0uS5lguvn2gMW9rfhBmTag/5bgQxK4VhAJ7R9eDPbfKy5vodni1ST36KFeqOv1AKV8kyKH8SdqQ7uApeyb/Lc
 gSoq1aR2
 AgBE81ocZ26rKaHznVV/gssaM1qLPEpg6G5k5K8FRJjgtQyTTWcJaN0TJGtYhTa+vYNL9BZNNRuZ1Fwu4UVEXAu9Kxs6XaaHCCCVSaz+9jaB/j4pAK/eXczuYFYMsoxFlnnycrSRbutety1weMfGgdcsPGb5UcgLaIOC/Qwl/FDBhMg2FNzDw8eytLeWRyRwMtq1UUuOD88v7UC/QcOfh7hdhCwtx/R2VfPT5bdsgSo5EggSuSPfEzpt0j8nKoJbf6gNtzNykjX7xHhMrp4vUKL2XS9pEn/fW/ymGKMottEkIdbwqqoGepgY+3JYnhApXXZf6fKv+UxADEA5tGPQh1kOOrqFIdmHlgKS/Syuv+ZkCeAQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 15:40:36 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> fixed an underflow error for hstate->resv_huge_pages caused by
> incorrectly attributing globally requested pages to the subpool's
> reservation.
> 
> Unfortunately, this fix also introduced the opposite problem, which would
> leave spool->used_hpages elevated if the globally requested pages could
> not be acquired. This is because while a subpool's reserve pages only
> accounts for what is requested and allocated from the subpool, its
> "used" counter keeps track of what is consumed in total, both from the
> subpool and globally. Thus, we need to adjust spool->used_hpages in the
> other direction, and make sure that globally requested pages are
> uncharged from the subpool's used counter.
> 
> ...
> 
> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: stable@vger.kernel.org

This (simple, cc:stable) patch presently has no reviews, if someone
could please be so kind.

> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6713,6 +6713,15 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		 */
>  		hugetlb_acct_memory(h, -gbl_resv);
>  	}
> +	/* Restore used_hpages for pages that failed global reservation */
> +	if (gbl_reserve && spool) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&spool->lock, flags);
> +		if (spool->max_hpages != -1)
> +			spool->used_hpages -= gbl_reserve;
> +		unlock_or_release_subpool(spool, flags);
> +	}
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>  					    chg * pages_per_huge_page(h), h_cg);
> 

