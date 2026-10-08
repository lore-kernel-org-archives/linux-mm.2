Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B31CA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 10:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757326B008C; Thu,  8 Oct 2026 06:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708686B0095; Thu,  8 Oct 2026 06:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E4A6B0096; Thu,  8 Oct 2026 06:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 483B36B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:44:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFC7EA70C5
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:44:20 +0000 (UTC)
X-FDA: 85299124680.29.113BC35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C3F6C0003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:44:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3Yn78FL;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791456259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALgWdXYbn+bZ4rwwXsWrPzPXW9ZDmpWl0lnnVBOFCg8=;
	b=5+FD7LbxntS2EiH7OUT6zkXXJFtd8YN81lv+PTu2uew8F55Svt7Ti+cTyXzdF8M7YALH8n
	CxyC2yb4v//ztHbUx4tmvq58JFNB/5LR0ZyJbZnGFb6GtHs+aFJ3itKvxT1rV4C7C2y2Kf
	oqE57KhoUyl9QM6ZLubRLGe6dcF/TXI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791456259;
	b=TgvMcAZ2DMCsC2m7INdCAATwWLs15DR4mydcwhBV0DO7F6gePDDfbgvsd7otfNF2uq8APK
	rJUx2+mo8QoJqOLUjqMA+Iy8MdDXoC9mXFMIjBOpQvWgGst4yhV0HjsjNuJT/oFEJBapOb
	IvWoV9k1RYxO4VGfawwn/dEaGBY8Qwg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3Yn78FL;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 684C340D8C;
	Thu,  8 Oct 2026 10:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EC21F000FF;
	Thu,  8 Oct 2026 10:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791456258;
	bh=ALgWdXYbn+bZ4rwwXsWrPzPXW9ZDmpWl0lnnVBOFCg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3Yn78FL9rXGtclLkP1KF5t89BIGXiOUwbOXsJclfRipe2zZck+tUTcBm6UHB4ttb
	 p0mKlWUfbx44yq4vo0dmSnlkmThwinA0atzbkQ3bt9CJSxOHxpEMr8MZLFqe3NTG4d
	 HrMv7xhjpqzN1p8olqNhfy/t4cU1p/Ak8j/fmTyuxxdF9LpY6glZdRwrU6n86BWu9G
	 mw071u56P/es6RDG1HX643YmLUcbwD5PZWH3WghjM/nuZvBZlZUwNlDGpr89aZT4ni
	 PKGUuedBqQ76WUW1e/2jaVEE36cW7dPgB1wIAfkSSgYiiQbo0fKNhvjYRKJC/mLDuW
	 2joSes8u6WlMA==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: Use only installed probe in damon_merge_two_regions()
Date: Thu,  8 Oct 2026 03:44:13 -0700
Message-ID: <20261008104414.40641-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007154851.45368-2-suhaas@s-joshi.in>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C3F6C0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1smyoceb4isr4xo3o8a95d19zc4dh4ke
X-HE-Tag: 1791456259-209047
X-HE-Meta: U2FsdGVkX1/J0ow7nWnzBC9+8eAY5nbFDFu5/sksjNBTM3SWQd74k2FPVFkq/w1NihRAz6LROYz7ZRtjrfHeh7NNDKvQq/SwgjnCgUg1isbmO1ViCvq/RJMSdt2cvuPyqvsfyv3ojHsANZ7LVSiicW+OMvCFC/+rk6OaNwoTON6CxC97+Uzt1GQNAhZ8mz5CUnu5gulXJNLpS2K+Ir2QGYFdZOkxkwQh76gr+0P/w/zWECeAaQ8Eur0lUELoPZec1b3MkcgH18+VbErz0hZQDJU3U8DOLtqsX0dIgljhq8sC5tnav3zKuylc/A14zKLOjrCDFVgKr5kN6dEOOGKenFYPxG834uEV7jMfaA4E3T3Q728vTAUcxlYxxLTvnkL0m1nfFTQxEhHzM+msVzRMYkJes0z2Gu+Xnom3IL3BWmlexAdWd6KtfKik4QPZNFHJXg34xyPxTP7/msbB8M0sLij0ARAWIU+QbpoyW8BtzqPM84cyLilFvPiAZXhOxk8BeNWAbu/Hca1pDKP10yEkK99a80bsb5IqQB8+WGGBv3ncqXS7WDFMmAU6pYh5j6uf0hnU9D48tu2jc3mDsmdnl6Yi5TIJ7Ub6lsWMugvocDglYqHZXdOrcCjtKse0q1uREYkELLtzCQoV8COlnPhDraawvOq/cfcEr7xFDi5MRsohFgmwPggr5DcvyJJCQnBa7yHjNXe5uMoKou431PWuQsxgkja8B9Wm1IIJgr4gemgpqZP3nOPGR85a06KunxEYCBC2dtO7do5zx63bwBpQQowngwQH0U1zx3inUNs+j6t0mmdYD8Es8n/k5GhP0sUkdE/o1w0iMXNL3ymg23Ux4uyNWTrbLevIu+UpFzSWuQ1ZWNuWJxziPNQfZcrpnMIM1eGwphdnFhhU/caKSiTLk/O05MUe6CVcOdA/l+8ZDmH+r04Zci4dUa8FO1MLD5ox9GQ0IQCUQpw3rj8UHX9
 IQ0yJKUR
 ylKzQEkMLMrAmqbhPt/9qDJEuVswDQK2zWrbtngcIivzhPBsaCPCgDNOjMc+t5NaWji3Nhh2heeoDDKgNz7IoE4dyb6S5r0tLgTCSmGwAMVAqKmasfWYs4Hij+sKOCtwp7X9VfGCX7c5jY3EdmcwWbcyt0syYwr6tMLo/5Gi7jUOP+bbZ7Xcbwh4o9ZmnxaERvL1fuJCi/1K340YhC84zPPgPIS/LrxcbYqARmwEgDDPNcBRO3pH6C5wxHig/ilW8lBcZObuqocQV7Pl/TPKuafrhPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Suhaas,

On Wed,  7 Oct 2026 21:18:45 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> While merging 2 regions, we iterate over the entire probe_hits[] array,
> whose size is determined by the DAMON_MAX_PROBES macro. It is possible,
> however, that we have fewer probes installed than DAMON_MAX_PROBES. In such
> cases, we end up making redundant iterations. Therefore, to remedy this,
> iterate over the list of installed probes instead of iterating over the
> entire array. For doing this, start accepting a struct damon_ctx in
> damon_merge_two_regions(), and update calling functions to pass this
> argument.
> 
> Update the damon_test_merge_two() test to use this new signature for
> damon_merge_two_regions() as well.

Thank you for this patch.

[...]
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -182,13 +182,27 @@ static void damon_test_merge_two(struct kunit *test)
>  {
>  	struct damon_target *t;
>  	struct damon_region *r, *r2, *r3;
> +	struct damon_probe *p;
> +	struct damon_ctx *ctx;
>  	int i;
>  
> +	p = damon_new_probe();
> +	if (!p)
> +		kunit_skip(test, "probe alloc fail");
> +	ctx = damon_new_ctx();
> +	if (!ctx) {
> +		damon_destroy_probe(p);
> +		kunit_skip(test, "context alloc fail");
> +	}
> +	damon_add_probe(ctx, p);
>  	t = damon_new_target();
> -	if (!t)
> +	if (!t) {
> +		damon_destroy_ctx(ctx);
>  		kunit_skip(test, "target alloc fail");
> +	}
>  	r = damon_new_region(0, 100);
>  	if (!r) {
> +		damon_destroy_ctx(ctx);
>  		damon_free_target(t);
>  		kunit_skip(test, "region alloc fail");
>  	}
> @@ -206,7 +220,7 @@ static void damon_test_merge_two(struct kunit *test)
>  	r2->age = 21;
>  	damon_add_region(r2, t);

As also found [1] by Sashiko, seems this patch mistakenly not calling
damon_destroy_ctx() for r2 allocation failure.  Could you please add that?

[1] https://lore.kernel.org/sashiko-outbox-163177@kernel.org


Thanks,
SJ

