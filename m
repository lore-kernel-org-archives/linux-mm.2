Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0445ECDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3126B008A; Mon, 22 Jun 2026 20:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7ADC6B0092; Mon, 22 Jun 2026 20:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D928B6B0093; Mon, 22 Jun 2026 20:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B07096B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:23:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23FE31C54A8
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:23:51 +0000 (UTC)
X-FDA: 84909279462.07.1402F4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6D4A91C0007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:23:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGcL9jYX;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782174229;
	b=pdZYIRLTE7mYke0erqjULEaRinQKZOjqGyUHlb3IvN7Msw7/WxqzcSCssEfsvayA+9KwKP
	SI75iPYVKpIGbajEyfwkphH+lUmTiG4WAOqGAG6a7yaxY6vWdBn7tzFehznPKBeCkGb08x
	yLliVJdjDEqU8YaKza5pV+sIjA06l1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782174229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHit9r0IoRMWbFlRiQsg1wNHzJglnuxwq3p+QyJDFZY=;
	b=SWkBvROp6M5QGT16QW9yXqJ3OQvFfIIHCYyntzOWoOuZEN49ZpDEBhn4/bpH4dZe7Yu3CA
	amQgff008oKI1M5vCJmzgFWAID+4Mg84BUuD5/UeDu5R1hv+Q6lWmHckIkK9aXdRcHc3jL
	Ou4sMgbb5M/OUYbM5WNRHZ+LZUvxW2I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGcL9jYX;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A337243ECC;
	Tue, 23 Jun 2026 00:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFFE1F000E9;
	Tue, 23 Jun 2026 00:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782174228;
	bh=YHit9r0IoRMWbFlRiQsg1wNHzJglnuxwq3p+QyJDFZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iGcL9jYXrRA14FgJKhdYXvQW/0W0QLe4XZcr0d0Qs59PcihXu+134azYTICi0lOlk
	 MRDU3duuHCQaMZOSZGdhdae8ywcybNLcB4seQOx6fIxF6Uzu5GfQ9Uu9Rg0QTXplPq
	 c3JB+C9wbNcH5tTYFEcMUa+FsR/zaV0KsNrgFvpXydh0kUMJNKl7uWQAWYp0522BDa
	 mRKpEK1t3NjGi9h+5SdKxtGdXUsOpNI//cetu+Fgr3sjbIb0yT2ghLqS9M+T5jqncQ
	 WTC9Z4GberOxNy0bYADldKqRDU4fs8FZl7kAo2fb0mg4VPBKuPR6P8eKZ2FUZsBgIP
	 wv0UOybOxFlFQ==
Date: Tue, 23 Jun 2026 00:23:46 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/7] mm, swap: support physical swap as a vswap
 backend
Message-ID: <ajnRulrxAKnZavOl@google.com>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
 <20260612193738.2183968-4-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612193738.2183968-4-nphamcs@gmail.com>
X-Stat-Signature: dchj6mzipb4q6o3qafw391ktjgdc9aoi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D4A91C0007
X-HE-Tag: 1782174229-786142
X-HE-Meta: U2FsdGVkX18mHyzTLIiwm11yFdyki088FVarkgnybq2Z50QmpF0CIgUyDJPJVYcCDsl0OnGYZa7JrwiB0bQgQTscIvBW8O2XeQpzpcrl3dNuqjcQbda4O8uIS4G3+89e0r/sBQQjFUHt9QavjgkdX1/R0KCwmJ3gtDu6Tv5pgypl3nU/+8JDfR8YNanFIIPF8WJ2MMyjHe8rqyI4SakdTsmA++z8s2uus0EbpGRJgrnyn0BFKLhp/28phVlBii1lRxUtAB2ecIWEdws9pHiLebnKQ+upV/vNxFSEpXNS89BF0RwEblcTvbIwnM9cPpDgHcR6W5KgZQbQNJWzDTTZPezRrcrD2fAauIJNmh7ClQ46oKWShxhUAbI1tqFyauFu/wwjNxDKCvlNj23zlD3A4qJL7/byFpmTJGP1bGnZjXoaEX0ve75au2jsSGzq6AyqntZk5BXCwhTHOx0fYmV+j9ihdFsc5nlU2JO0mb2J83poIeYZApZtuUhiY4WAlpwH1wdU4yefxmzko1MO7iS3UVognuZHje+oUK9oem+GJimNLQ2cHPfAmlHXvE31luXX8//dwZkYoSUTKtBPocKiH+m7R0XG50YF5m/+anOHErI9WzeNtHkwnxJhO/EoGl8JLGfn4bUV0QUbx/Tv/EJ+zZLjSukRneN3NYRM6g/M3lJsvOi2dd+v2vKrctNd1TKXiSs1zFCID1WSOZaRYkhcvqvUsmUmoNNf58h8fhPm5jcXbjzpWfYIktsSCNvpBK4CYNIQldIo6uT6sLpc+MnLARcLoUfHi583sIbmpD/ej2UERTUecr3ZDAWDcySnDXB43FUOxBANvWllVt4ZnHYAb4jW2Ytm1zUACjcEU3LCZq+MoAZFP60dwnEbeQ5Q0WMWgDhCQsoNDrIOHp/jozeG/zuLeX1Jj9MBgCbeDfdYlFQdBN5uW55nhDCrhJpsDw+MiXEoqxY1Hg0/f0HpUwD
 TZ4zqHHR
 PvPYAsFnqpuDj3ppyoWVgUyDtsYgCykyhEb1xvnoW1izniAYt/BJDw1HmOZfsig/d+Po7x7MmSuNZpaqKp2kM7hGdQgiu6rwgTkubvDHhyV1IBNbUGd3G7EHX5nMyzhcAaOZFJK98bj55mW6s3vRt593ferpVDBbj5Qf1u8Fn5RtxOXp6IEklU9WrTNaexE7CIXqcSmJwDTMDuAA1zfhFV9mViRdf5q49ER+KhWP5qgoqcFFLqmYzOdH1dXQEsffnO6F20QVTbb5GMA6X8qf/wm1HmIrEMXUt85bQEPxQydqovLzC01ndCMmCP+Z8yMfPupepj8BDVLD1x44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 12:37:34PM -0700, Nhat Pham wrote:
> Add physical swap as a backend for the virtual swap layer.
> 
> With physical swap backing, vswap can allocate a physical slot on
> demand when needed: as a fallback for zswap_store failures, or as
> the destination for zswap writeback.
> 
> Each vswap entry's physical slot is tracked via a Pointer-tagged
> swap_table entry on the physical cluster (rmap back to the vswap
> entry).
> 
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> ---
[..]
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 466f8a182716..5daff7a25f67 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -993,6 +993,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	struct folio *folio;
>  	struct mempolicy *mpol;
>  	struct swap_info_struct *si;
> +	swp_entry_t phys = {};
>  	int ret = 0;
>  
>  	/* try to allocate swap cache folio */
> @@ -1000,16 +1001,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	if (!si)
>  		return -EEXIST;
>  
> -	/*
> -	 * Vswap entries have no physical backing - writeback would fail
> -	 * and SIGBUS the caller. Bail before we waste a swap-cache folio
> -	 * allocation.
> -	 */
> -	if (si->flags & SWP_VSWAP) {
> -		put_swap_device(si);
> -		return -EINVAL;
> -	}
> -
>  	mpol = get_task_policy(current);
>  	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
>  				       NO_INTERLEAVE_INDEX);
> @@ -1028,40 +1019,78 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	/*
>  	 * folio is locked, and the swapcache is now secured against
>  	 * concurrent swapping to and from the slot, and concurrent
> -	 * swapoff so we can safely dereference the zswap tree here.
> -	 * Verify that the swap entry hasn't been invalidated and recycled
> -	 * behind our backs, to avoid overwriting a new swap folio with
> -	 * old compressed data. Only when this is successful can the entry
> -	 * be dereferenced.
> +	 * swapoff so we can safely dereference the zswap tree (or vswap
> +	 * vtable) here. Verify that the swap entry hasn't been
> +	 * invalidated and recycled behind our backs, to avoid overwriting
> +	 * a new swap folio with old compressed data. Only when this is
> +	 * successful can the entry be dereferenced.
>  	 */
> -	tree = swap_zswap_tree(swpentry);
> -	if (entry != xa_load(tree, offset)) {
> -		ret = -ENOMEM;
> -		goto out;
> +	if (swap_is_vswap(si)) {
> +		if (entry != vswap_zswap_load(swpentry)) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		/*
> +		 * Allocate physical backing BEFORE decompress - if it fails,
> +		 * no wasted work. folio_realloc_swap sets vtable to PHYS,
> +		 * overwriting ZSWAP - the old entry pointer is only held
> +		 * by the caller now.
> +		 */
> +		phys = folio_realloc_swap(folio);
> +		if (!phys.val) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}

I didn't look through the rest of the series, but are there use cases
for calling folio_realloc_swap() without calling vswap_zswap_load()
first? I wonder if the realloc_swap API should take the swpentry
directly and do the load within? Something like
vswap_alloc_phys(swpentry, folio)?

