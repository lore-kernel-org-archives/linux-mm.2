Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62E0C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4679D6B0099; Wed,  6 Aug 2025 15:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4185D6B009A; Wed,  6 Aug 2025 15:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3552E6B009D; Wed,  6 Aug 2025 15:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 281EC6B0099
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:09:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D77C61605C7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:09:16 +0000 (UTC)
X-FDA: 83747270712.03.4780562
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1CC2140006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:09:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FhlIJ6sW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754507355; a=rsa-sha256;
	cv=none;
	b=FpUn11bbaIYV0u5kgXJBNawQmpzxHKlT3LcO3nO/YWI1nuzuBwv/VrPZOtuIlh8uQhOWHX
	N03cQrFu2rAFE4TnUcQti0UDZ/mJzEG+V2WRsHCZS4hsjJOqW/+adYfdzXjCA94qbLICmd
	drzchJ9aGEUHs5PMTQvv6/gNnmv0M9U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FhlIJ6sW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754507355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63eNjk9Vetf2teryJZKtr18Ly2dXmnP2M/BHPl2bI04=;
	b=10aW83yqX0EyZQXRRe7NpYp8pS1pJGiXi3Ac49cFPY4wN61HHZ9wKwjw2crZHdTn3Owxo0
	kRj13Wunrb2SoQppooWIrgPzjhiRfE0Q1eFEYOhTT0Sv1mPOo6lZj1zaaDPjK08IbFQC+a
	r42rhyhCFI3ewn/FgmqKMtdsY/UeKJo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 116E544AC0;
	Wed,  6 Aug 2025 19:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA30C4CEE7;
	Wed,  6 Aug 2025 19:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754507353;
	bh=7N8Q4W4P+6iSheRgtygd3ecelGl8Z6De2VbO2stv2v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhlIJ6sWU67KGuHY4kg17vJ/xHLHncT5RcqKqgfAAe4wgP59od2t0gwdpxQumJOoq
	 9FLbkdA0zzJGKjl/NSUua4bMyJ2vlRBzXGWP9iJr3FUEx7JJBzkJYgxIRV9SA2QI1G
	 I1cpET67sPVAjwOcOAKzdVYFez0zluQNS8G/x/f7MYajF8en2fyD4whBiYXse9C7Aj
	 Rs1CNnkUaqX6eJIIrBIcyYtCFTgM0bmtyYHYHQ1ugpoexU1dyGSOzbA0Mbi2UVUE4Y
	 lqECCF46lRHcG9QgxkRQ4YS6W624J7vb0CwvixlUS+Vw7Cd5lzooPLUCfpR8dHmatx
	 gFp5NnkXjDd8g==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH] mm/damon/core: skip needless update of next_{aggregation,ops_update}_sis
Date: Wed,  6 Aug 2025 12:09:10 -0700
Message-Id: <20250806190911.49728-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250806164316.5728-1-bijan311@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hzddfbrjmzta91unjj96kikns4yzhpcb
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CC2140006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754507354-182374
X-HE-Meta: U2FsdGVkX18Wn4mqLP25NAvM1oyC2lvHhbNfwLbmHFhgKafEus7HpRjhIJ//tRsNgMxFn6Bo40D7sgAhPMPYob7gwosZ9mB64hVgp5NqGRf8wbXO+jk0HPxIKcO/SRQ1qhACek/J6H3YEXqOIbq/WtdM+LUz/ilMNzUBsAcNvZMrj92X+CvLsU2bq5SiqCHlVfB133nqmzOmhQip2ko4r5xUuUO8lG5wEXnqmPhbzVb8OMFAY1IjQvnHbWu5frcgpTmVu/TRUa5+qqvWM8e6i8hFwNvIzKXTkRGF0xf5Hd35J69LuNd2YpbBahp0hX0aO/O0PbkSk8r9NNnz4k3Dk6diYXrve+QZNyYIn9hIskGuunW/o+X0ECcujaDsy38stsM6iKCVu7p0Yz0e1iKze6VqcSzc90it0V+TqVXvmAa7ZAzlCcjnyv1gJFDidDFfcpRLgxa/5rz189NXVRDPwQeaavR1E/i0CZqxTDB9eA+mLP0Qelbhd1fyIbHgNVkjuLZf5RdP8lN3Sxsjp8zVqkD9kuRpFV3/Ir6oto6zYJUOg6TLaMbbVnMbm/P4a5bdPPAh1sW1iZwTAZkBX1qKcnFRtxMG3jsM33bbXfLBGeEEIjaJpuOmJeGAkURGEgeMJksPeyWq9jxOyFv+5L6+z9Whzzc8k6xGTaTWKmTWU6Pz8pRs0gcZBtNBRxEaSss+tphSXvViAPdvczNloXnfrsSwRUpEe+lTFPAlZPIrESr/H4spn9bJXEyT29Ff06m2GFDcYFl5FOTIggscL1huOeb8k+pU8XT9C6lkYOikPEIg8dkOIhvrcXYgnF0jf1NVhGL+l8ot3l/0Dan2kg2E7mQ7JbmudKD7cWAn10YYG40L+JaDeZrYD3OaEQAjcHQLGXEC873pWGQsI2YGmA65Vv9YR2orErrGYJLQo7+evDPQoiEQicgEzZCZsFib3hBsBsPJT3FNVvPx4JSJsPq
 NMJcJwkG
 Z1UCrrdlPn++U4QM7xS8MUSzygP74yQSeDpoFlqEpdpto2RSoHrdP4TrfL8aYVconkrG7XlttCFu9htrxoepr/iWc1e6kJn2YtfHZlirN2pVXcNBujvgqeJg8m44t07UOUoO/OYGvhPDti4apQaONVxcUIdbpRXnvo1WjBlUE0eVrSVgH2H1dGrn6FRHjG6IE5O4fEPGcLGd5sxGNo+EdlIO3VipHrrfm09mEHAgtXoH1M6qJ+rj3iz4pCdmK9Bg/XDPLIm1pC4l0hVorZIL7Z8AE2Dfy8gdfJlxKzEWGva4E30bMtV/00WulF/y7UP00cXIiyDyy8/P/7H4Zcka5YZYogAunQC9LRdLlt+V6+D4HqTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bijan,

On Wed,  6 Aug 2025 11:43:16 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> From: Bijan Tabatabai <bijantabatab@micron.com>
> 
> In damon_set_attrs(), ctx->next_{aggregation,ops_update}_sis would be
> reset, even if the sample interval, aggregation interval, or ops update
> interval were not changed. If damon_set_attrs() is called relatively
> frequently, such as by frequent "commit" operations, aggregation and ops
> update operations could be needlessly delayed.
> 
> This patch avoids this by only updating next_{aggregation,ops_update}_sis
> if the relevant intervals were changed.
> 
> Cc: Bijan Tabatabai <bijan311@gmail.com>
> Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
> ---
> This patch came from discussions in [1].
> 
> [1] https://lore.kernel.org/all/20250805162022.4920-1-bijan311@gmail.com/

Thank you for sending this patch as we discussed on the thread!

> ---
>  mm/damon/core.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 6a2fe1f2c952..1c3d8b92257c 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -693,6 +693,12 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
>  	unsigned long sample_interval = attrs->sample_interval ?
>  		attrs->sample_interval : 1;
>  	struct damos *s;
> +	bool sample_interval_changed = ctx->attrs.sample_interval !=
> +		attrs->sample_interval;
> +	bool aggr_interval_changed = ctx->attrs.aggr_interval !=
> +		attrs->aggr_interval;
> +	bool ops_update_interval_changed = ctx->attrs.ops_update_interval !=
> +		attrs->ops_update_interval;
>  	bool aggregating = ctx->passed_sample_intervals <
>  		ctx->next_aggregation_sis;
>  
> @@ -710,10 +716,12 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
>  	if (!attrs->aggr_samples)
>  		attrs->aggr_samples = attrs->aggr_interval / sample_interval;
>  
> -	ctx->next_aggregation_sis = ctx->passed_sample_intervals +
> -		attrs->aggr_interval / sample_interval;
> -	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
> -		attrs->ops_update_interval / sample_interval;
> +	if (sample_interval_changed || aggr_interval_changed)
> +		ctx->next_aggregation_sis = ctx->passed_sample_intervals +
> +			attrs->aggr_interval / sample_interval;
> +	if (sample_interval_changed || ops_update_interval_changed)
> +		ctx->next_ops_update_sis = ctx->passed_sample_intervals +
> +			attrs->ops_update_interval / sample_interval;
>  
>  	damon_update_monitoring_results(ctx, attrs, aggregating);
>  	ctx->attrs = *attrs;

Long story short, this (original) code is bit complicated and hence I suggest
to make this change less optimum but simpler.

damon_update_monitoring_results() assumes it is called only just after
next_{aggr,ops_update}_sis are  updated.  And the assumption is important for
the pseudo-moving-sum access frequency maintenance.  As a result, this can make
the monitoring results temporarily corrupted, and splat warning once.  Please
refer to commit 591c4c78be063 ("mm/damon/core: warn and fix nr_accesses[_bp]
corruption") or the patch thread[1] if you want more details.

Also damon_set_attrs() is called not only from commit situation.  So I think
this maybe not an ideal part to modify.

What about modifying damon_commit_ctx() to check if new and old
damon_ctx->attrs are entirely same, and skip calling damon_set_attrs() in the
case?  Doing the entire damon_attrs comparison might be suboptimum, but would
make the change simpler.  I assume the suboptimum comparison is not a real
problem for your use case, so I think that could be a good tradeoff?

Also, I realize the moving sum access frequencies maintenance and
damon_set_attrs() are not well documented and organized.  I will try to make
those better cleaned up and documented.

[1] https://lkml.kernel.org/r/20250513002715.40126-2-sj@kernel.org


Thanks,
SJ

> -- 
> 2.43.0

