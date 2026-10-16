Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EFB8CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 00:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCD36B0095; Thu, 15 Oct 2026 20:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A55B6B0096; Thu, 15 Oct 2026 20:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BC266B0098; Thu, 15 Oct 2026 20:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658056B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:21:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF5A480254
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:21:39 +0000 (UTC)
X-FDA: 85326585918.30.9B57D99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5DD9F1C0007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:21:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eOf9YA9n;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792110098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9N4EN6ZvO3a8sKtIt1Gi15YCcaB7qMrfMy0PcLy9QgU=;
	b=W/IQgAxw76caUWwMxYzHIfy4LcapYC6GU9TgqLzTVosJmjlD1ahnXWFbt3svVyJpLpuan3
	r2LaOSxVbe/MKPNhRJCnJxr4IgREOl7q1i1oTnwJgIzQ/XCRu0OnrEm/+sKJ1CmdX5TOUy
	e7ppgjOiXGgeHxGwOhQQesxLcRJeS34=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eOf9YA9n;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792110098;
	b=wudA3oQ72dB0ofio0H+2+xuChl0P/ckf4QinC5B+tTXjiWdrltAeqbLQV2MrwgvgIkets5
	luO7Cn281XezCnTYhsM7fxUO+CVovnvYKpl93xTWURULbeH7liWibJXfTDIMEBGs5FTlHR
	TDZuRBI1K11P/mNr+e/rPMqq2lxLXmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFCFD60A74;
	Fri, 16 Oct 2026 00:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B2C1F000C5;
	Fri, 16 Oct 2026 00:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792110097;
	bh=9N4EN6ZvO3a8sKtIt1Gi15YCcaB7qMrfMy0PcLy9QgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOf9YA9nhtK2H+psZ+z21uyPW8H2c8MJseLVkbscqczuYzGIWACbY7HHHKSrpn6F7
	 k3NysYP9IIPV5MJ4Ig2ytACBT8lSMnaeVx52RxK4fz28xyKrOG9fivE5i91gmmIu+l
	 fi0gbNz5bimbzZwojC+Tf5y1PTZ7slGz25YTd2YS0dI7yWNi4Vgvv75f2fUQhdwGWc
	 j+N7h6qpFQ5kNIsHYRb+kJx/ROqZe1Fu0Xg+WNL0V+DyewIuiukcU+sqbi5kndyP9L
	 p5wfFiFcFAMhEaiNU5TNzQ7MdzA70IHm8Qwoicg3KGlMfewyj+SgOC0n5ZDrbeWgc8
	 6DYuAuzhTODyA==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: avoid 32-bit overflow in idle percentiles
Date: Thu, 15 Oct 2026 17:21:29 -0700
Message-ID: <20261016002130.113813-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179207592479.3.11595453180868898703@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DD9F1C0007
X-Rspam-User: 
X-Stat-Signature: 5gb5i7mjsq7ddofpptge8857tbn89994
X-HE-Tag: 1792110098-250907
X-HE-Meta: U2FsdGVkX18l+3JeZXOXL7fRhIMwbqQGZdOXjhVLj3oMBSHk57O0ykmhG3rTFyHdh+zR9x3uiKtVLBxYqUjHXD4IUWbShhCkCbQWpjen9JBFIMcqcjOf6kORrQcHJRok+8isJPWfreW1BCkY2xw58pvWJ0WGQRmWtjGWpkFHm3IUTJiaY3NsAU+xLPhE/LuI9zWHpsp1mUvcot79kDiwf0ZtweGrlXMFoZN5PsEQywTQHOJ8aqrB0PhF265LTdvCC3HmqKGX9xJ+lCxtss6WKW/MDrUCkXxKbP2YSLPLrtxxEyIJGr486qqnM0s9797EudpbDMM0qv2a2DKe5Tf23uRgRKQzORXZ6WVjsvSdcn/BfOoQeQ5iNgczV6UV7jeydiGH23gCQ/PPkZd/yoBVwsvFeKKC170yZ6gUCQ7hmRWsdT0q3ObZx9LpD2dmEocQTE3+XfNr46CiMjxvaWd7mGiUPNmg3CstHIwV0+H4vlT5b1APQBESndVcQ3+jnfdKT+2oo5c/5B/mD7Nq3Ij2fJ/PG3YX+NRpXXEg+MnGWTgZ9v0PfrCahLwZxpstSJhZNK+8XlmDf7nOZ59dJxq7yFpR/rSc5ywpcwelckKy6C7yN9e9tvM7IL8b7JYbtVvfsWAEn44Ivc+DjkeGJbA3l5n5kdktZF/+Nlia6HWbl2CwJ4NEsdwr5k0sbLwbHpDYhfcdQkFm/IJLc8rUJ0cvZqEnNwD9asaBQDfGIW7e9x+eSju1Xu6z3wRVVoQpzXkhGsqEEGMEyyrapg3/VXzJq+Bl4sBKj/IPQfIrx+coAcSFXjL3dD8rWg8sD4/xQ59JDY0d33D/RvD4r8C9J/nndA39bhkLPi4fyM/e2JgiB45KgdtdxT+sT969qu1Y3fPtgaWcQLD7BjRP1tWZnE/n9lv5I+/2hj9EKVLNyxg4Pz/pqXRMXWXIV10K3P8o0YAnVq2gn/+PeUlBIsbiD8O
 Vy59J7bR
 RBufcSQQ2LN3IARLSw8I16UMRMK55/xkEV+yOGqVM1TnEgeKLZJpov37nKMLtTQSg0xt67SUQ3n+Ng/I9nNmcdu7Yu4+JfQDM8XfzPzyPxXUxD+R5B4xL60Hby03cwJtbluIgyeNlIw7fuqTx+uMO0rSr5yHJrWe1QGUrp6hHd1bmDEcuAWcXsWJru6SY9YuSEkehkQOgxLcFzJMo/yFTB8xGdkz/uqwCSCPWFYmhA9SEXGQ7Pa1BAd+qF/rpNZui06Ka
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Aveline,


This patch is sent as a followup of your previous bug report, right?  Unless it
is very urgent, please make sure the previous discussion is completed before
making a followup action like sending this patch.  As a rule of thumb for
DAMON, I'd suggest waiting for ~10 hours after the last comment on the thread.

On Thu, 15 Oct 2026 22:52:04 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> On 32-bit, accounted_bytes * 100 can wrap before division by total_sz.
> Some entries in memory_idle_ms_percentiles then keep their old values
> instead of being updated.
> 
> For example, a 256 MiB i386 QEMU guest reported p0=19200 ms, but p50 and
> p100 were both zero.
> 
> Cast accounted_bytes to u64 before multiplying and use div64_ul() for
> the division. Compute the percentage once per region.
> 
> Link: https://lore.kernel.org/r/CANOyQmHad1vamnZT12M5yPrJ69==Pt1U0+MGw6u0MuNtr-DRCw@mail.gmail.com
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
> This is against mm-new ad9f2d463666. With the fix, the original test
> reports p0=p50=p100=19200 ms. The i386 kernel build, x86_64 W=1 stat.o
> build and external arithmetic checks passed.
> 
> I also ran 38 before/after VM tests and 20 same-image controls. Throughput

What is 38?

> was close overall, but median kdamond CPU rose by 0.0053 and 0.0221
> percentage points of one guest CPU for stream and sparse, respectively.
> Some pairs had 5.91% lower throughput or 15.49% higher scan P99. So I can't
> yet tell whether these differences come from the patch.

Do you have a plan to run more tests to be able to tell that?

> 
> 
>  mm/damon/stat.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> index b05b68f73e10..eccd372810d0 100644
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -114,7 +114,7 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
>  {
>  	struct damon_region **sorted_regions, *region;
>  	int nr_regions;
> -	unsigned long total_sz, accounted_bytes = 0;
> +	unsigned long total_sz, accounted_bytes = 0, percentile;
>  	int err, i, next_percentile = 0;
>  
>  	err = damon_stat_sort_regions(c, &sorted_regions, &nr_regions,
> @@ -124,7 +124,8 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
>  	for (i = 0; i < nr_regions; i++) {
>  		region = sorted_regions[i];
>  		accounted_bytes += region->ar.end - region->ar.start;
> -		while (next_percentile <= accounted_bytes * 100 / total_sz)
> +		percentile = div64_ul((u64)accounted_bytes * 100, total_sz);
> +		while (next_percentile <= percentile)

Any reason to use div64_ul() instead of div_u64()?


Thanks,
SJ

[...]

