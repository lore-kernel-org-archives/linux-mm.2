Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC5B0F46122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34EAE6B0088; Mon, 23 Mar 2026 10:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326226B0089; Mon, 23 Mar 2026 10:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263476B008C; Mon, 23 Mar 2026 10:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 148446B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:20:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B919C1EDC4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:20:55 +0000 (UTC)
X-FDA: 84577539270.20.805177E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2599640010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:20:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b9vvI0tK;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774275654; a=rsa-sha256;
	cv=none;
	b=0h4c8YrTfPVWmAu4Tuhi05yP9g1flxYgMNeijfbvXCHvMKZx142kraH56aszOLbYV4PRDR
	DoqLBlKkFrE3Du9i76cK4jd9E4EdHReasqX+BtZ5EenLEdNKKhIsy6LrakE4JO9wVVOQSB
	GZwyFEFEGDCHep/tqI6o5uHHzdIbCTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774275654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCDJSgOTg5OkTQv6WaDAG/zi0Puz0+xoJLiZyEt4gZQ=;
	b=gi/N0r/17XeDUJ9WyUDzmQMxe6yHiRUo2GnNPBsvdn90eyi9phK67Yr+SRHj6DSRLhiEOc
	io4m/FVScG2kQaFb96UBZeduE9hBnxz8LHdC2/R3iChZNm1Ue57oA7ETlSPZHcwKFThO9k
	OkduI9bbS50HIjOwXa3SsTQfY/gYYpA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b9vvI0tK;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94C4B600C4;
	Mon, 23 Mar 2026 14:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAC5C2BCB1;
	Mon, 23 Mar 2026 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774275653;
	bh=np7GJeZ0jLioNC9C95zZxpcbkD3f0U2gmsKmzHDihrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9vvI0tKLWmkNCkn4S4AWjUSeFwUR9rM5pWcBZfnmjvukAEgO3a0g/9uztS9Mie+t
	 TbeR2eyzy2LFzOl3htMehCtUtp2ZnJ0E1vdv5Bcn6lqM9WJyW+OH4JYVJsy+FSOWjP
	 Gwxo+3u15Noo6oLOV/htC5qADytjHECCxmceHlpaK/H3/ELs3ni3OmBy7VkEJ58d6n
	 3dy/jXUSpcHDvCudF6tm+NIpQZ7THgXxLe1OSAsVEOPlNIiKyvcnoadQknsY8mmcyn
	 pL2yWQdfzJXZ+2fCVYqvi4gwpXM4c7sDHxEMN6zVdn/fi8pL93KtspvrzAF/G2cwq7
	 elZBP5aCuRqow==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: optimize kdamond_apply_schemes() with pre-filtered scheme list
Date: Mon, 23 Mar 2026 07:20:51 -0700
Message-ID: <20260323142051.80436-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322225627.263202-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2599640010
X-Stat-Signature: znyxs7acx4qr5ro4hee9mk6ai1bidadf
X-HE-Tag: 1774275653-574499
X-HE-Meta: U2FsdGVkX180JIIASnwF+rpPeNrV9/yzk1teHarfQ3eeW6j8FHzEIIhug+YMV6RT9NESh+2N4mYMHmW/Pv+7pB6VKvxID6VrXdOrg/TVhLmw2k2HlrpENvdWOzd2J9yOt2RF7/M/hDHM5VdNjD9McDkbEPcj1u0DegYLk9qcCE/b58mV7pksJ6zhTTE83M/uq7lYIOg7zl9RZ4JZHe/dLF/1NE/UG3ezDd/5d995la5s8swf0LL/biqczfx1ovqXbnpSoL1fZ5sxPnBxw9tcakoq95ePW3h48IFmMV9QFz+VG2f2LgBTs3Y7l28q2naJ0o30IxrX3p61XRnrqF5EE3qts/EdkflsE01WSqjlNpfQiJbPv91PuP0Otao8X8gsuK/7HGfhRzasjKjOu1EalrqH3HIU2C2uugklsqaRLl62qnchXJzSZEzJe7DgRXiBzsYJ17Gjry0vTocXh+g9BiOfRuC9EtaNBToH01CFBaXMdPELd/yE2K3srobCVl7Y0nLPYeUPrjkg4wL1kZahaQBvYnt3lnKgnIhxrnMsB9gXfo3Abc9ek6JrUwTy5pkgjPqz0iHF0Qzk9Aa97XzU1pGIpLRc1r3WVnQBftZO0lEQe798Agju0Ma77rLViuhV5NUk7pi2MB7R5I13wgSZpl1eDhCg/dLuC3AaV4SIYGeHidWqz++e6IQI+Xfk4Vqam+s3N2S78eXg6JJdS+IaUj/k8D3cmjxSxC4ccv6YMSGmiDBwHJUor4WzHVL+VjaZ9hNxlUm1u42RvOnW18p0x6HGUJp+KivKsHQyUcsjkxcU6nrF4YlYlbe4CuP70H95uxJEHl9Y567SxjyDolcugEfxsV4K//O3WLyWFy73VCA3UM5dXT0heO3yP/sTWEFvgay1DGMxbnGog43gE0vVXI3izuB2btGYguFv6A3k/aJg/ggTxpsHH8g7J+KbHcidy8HSZ3pXSHFtdNZRHec
 C40uNlaW
 UqaFxAyZ+h+8gllZquK7IutCX4UguOhSK+42Ww+dKgMXEi5RfoHUNlN021XTN91wmh1SXBYE/QatfD+MF9gvfQ7i08o80b5GM5vKh7yCQ7Yn+HHifAq/BR43N6XA6L4pC83fKDfSYaeXq2CqJdM5y84DyZo3vV3uszW/cwJNtIu9gCLLnP/FF/JQnzF06bIXU4T48YzvxZLmc5l1u0imDWJqP4Wdyg29VYESFygREKPdjNI0u4icExjtGXL8qitvnt+Zm6cjLLRDq7DyAUyLo00wBI7IdemfVdOmddPpc9HNUgyF66k5gZYmy0tLZ9bWK+gNijxYLPJ+gXueCGUHE9pYTrFlTXSVCRTGf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 22:56:27 +0000 Josh Law <objecting@objecting.org> wrote:

> Currently, kdamond_apply_schemes() iterates over all targets and regions
> for every scheme in the context, even if the scheme is inactive due to
> watermarks or hasn't reached its next apply interval.
> 
> This patch introduces a pre-filtered list of active schemes at the start
> of kdamond_apply_schemes(). By only iterating over schemes that actually
> need to be applied in the current interval, we significantly reduce the
> overhead of the nested target/region loops.
> 
> This optimization maintains the original Target -> Region -> Scheme
> behavior while providing substantial performance gains, especially when
> many schemes are inactive.
> 
> Performance Benchmarks (Filtered Array vs Original):
> | Scenario Description      | Speedup |
> |---------------------------|---------|
> | Mostly Inactive (2/10)    |  7.5x   |
> | Half Active (5/10)        |  2.9x   |
> | All Active (10/10)        |  1.3x   |
> 
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  mm/damon/core.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index c884bb31c9b8..3b59e72defd4 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2114,19 +2114,16 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
>  
>  static void damon_do_apply_schemes(struct damon_ctx *c,
>  				   struct damon_target *t,
> -				   struct damon_region *r)
> +				   struct damon_region *r,
> +				   struct damos **active_schemes,
> +				   int nr_active_schemes)
>  {
> -	struct damos *s;
> +	int i;
>  
> -	damon_for_each_scheme(s, c) {
> +	for (i = 0; i < nr_active_schemes; i++) {
> +		struct damos *s = active_schemes[i];
>  		struct damos_quota *quota = &s->quota;
>  
> -		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
> -			continue;
> -
> -		if (!s->wmarks.activated)
> -			continue;
> -
>  		/* Check the quota */
>  		if (quota->esz && quota->charged_sz >= quota->esz)
>  			continue;
> @@ -2476,7 +2473,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
>  	struct damon_target *t;
>  	struct damon_region *r;
>  	struct damos *s;
> -	bool has_schemes_to_apply = false;
> +	struct damos *active_schemes[32];
> +	int nr_active_schemes = 0;
>  
>  	damon_for_each_scheme(s, c) {
>  		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
> @@ -2485,12 +2483,15 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
>  		if (!s->wmarks.activated)
>  			continue;
>  
> -		has_schemes_to_apply = true;
> +		if (nr_active_schemes < ARRAY_SIZE(active_schemes))
> +			active_schemes[nr_active_schemes++] = s;
> +		else
> +			WARN_ONCE(1, "too many schemes to apply");

We may need to increase the size of the array insted of just warning.  That
will make this code little bit more complicated.  I'm worried at maintenance
burden from such a complicated code more than the benefit of the optimized
performance here.

If this is real bottleneck that bothers real users, we should optimize this
even if it makes code dirty and more difficult to maintain.  But, at the moment
it is unclear if this is a real bottleneck.

I'd suggest to hold this for now, and revisit if this becomes clearly a
bottleneck of a real use case, e.g., a user claims so.


Thanks,
SJ

[...]

