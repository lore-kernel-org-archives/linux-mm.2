Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE765109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B596B0096; Wed, 25 Mar 2026 10:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103886B0098; Wed, 25 Mar 2026 10:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040526B0099; Wed, 25 Mar 2026 10:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA9A36B0096
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:54:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A494B8C4EE
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:54:51 +0000 (UTC)
X-FDA: 84584882382.19.EC980A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E68F8A0012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:54:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UoRIgOhn;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjBdcSNUkBqsKpbWQqMLgJ9XSoufYNKd3JUxfHFa5s4=;
	b=u+4PcLnc4CE/9QVkevZ7nGry1+x9XLaUlZQMMZIGm5JVRG468cywGKCr9Zv6IOxNX97MXo
	cWDbPMd0mNl8T3c0U5otk/gcrpvEQNqFl8nUFuOJRK4T4d3jnTZIvHDmRIg8c0UUvIeV3X
	fYBqtkXm3ivEC0gYUr566eLNEOhsbMk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UoRIgOhn;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450490; a=rsa-sha256;
	cv=none;
	b=06xO/xS26YcsQCIuTxUZOAv8E/tgd+oS8ATz3OtFCrwADTZdnsqu1KETra2MdjLsQgEptr
	Jrk+oR5quDYzG70ZTfbzHBUWQGmXbglTR9UBBLw8Q0wDG8h6hm+hFrbm+NfO7YNPfr//zO
	AX8P0Rq0X22RubMGHleOe/VOsA1KsbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F37D9415F6;
	Wed, 25 Mar 2026 14:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65F5C4CEF7;
	Wed, 25 Mar 2026 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450488;
	bh=lrf0z5bvG1v0mlYr6634sLmsiqfSBpG+1b5Vled0Cqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoRIgOhnJFqGaS7j+ghb1dkb5nBHqB93nT2V1uvZ6BzWeKCMa3bUReXKdSdN5OEzj
	 AQ2dIYCQ33Vl1zhAqMRd7T+hMgpSGyJt0s9V/K9EnpW7CA7ALUnLMtZdL1ga8jVKvQ
	 PE/GaWQooBNL6ppUWDIWCUckuGlJ76nT1ZbPg6hV8h8amymC9bCQPJWpKjlt9iQT+y
	 S6BHOQRZ6Lh9riaV6w3hPFP11w44m9iM9Us//MbdcZToaNAILGx9rDNkm+CD6KhzRn
	 zMW9yeGZlpxKptas8zxOfu96Y4GEPvl70muQ0Npx3kgaYacRpTbNI4cRTI0MmC64vz
	 CoKBcIGlUnIug==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Wed, 25 Mar 2026 07:54:46 -0700
Message-ID: <20260325145447.87994-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324154005.83651-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E68F8A0012
X-Stat-Signature: rbibzc44dan8qpi7qu984tnqdktbcpnh
X-Rspamd-Server: rspam06
X-HE-Tag: 1774450489-292156
X-HE-Meta: U2FsdGVkX1+oSslSeVCvGbc+zZk3JjM8PLKCu5RhTbSGe1NxbQFkdGwSpsh5L8V6M0VgPdJlITYgEobnNbqgD3J4vUtVYnUduhShCLIiS31HfS6uO3KEBWbNLbncRssWqHZqnH/vUmv5ctVg9Mu+x32BcV4tj/Pzn/S8Q6WpG2Wv3mR27sktavpZ7TCuFPCcf+ofRM4DoLso0XRqywk4hHWwYe7E6YdSUGsNsYPkbK8Gcrh181bztdVzMoMQFUrBEQQqKt2emTDbBVZTSSwFGiFTrCHDnZaFTeNTXJsTIceWMd4wjhgH2/ZjKSukmO9j9Qitoeo+ts48713svHH47RU8dzMHBxp6jDY8J34YFG3j4TeqGxZZINqvwjDmAxE9AqFzue+lOemmX2e6Lw9cjkq/kvQ1w13ZgEuBLXpu8Lt+QDxFxNVFaHrq6VQqFFcWPAMEILyc77VXlEXzrWBgFR+ShSHXxvEP5OIqeTWNYe1Ej227BLEa3/yIaDqut7knuDX/mWk+cWp+45LxfCReV64kTmboRVuF9cRksKQA15LBh7Rj8W4ieev7UztiL0A7Te7GVpzWsp/uwflBrEqYb5iKf3Ypf7V2kB6PWZtnepE9uWTziK/yrBCv16eVVJ6ZW/tY1AE7btr5qJKs3lr1FMJV/eCekXtCBHmLcS9xzIECl5Bd3u4kSd0tT/extpT83bNY/sz1EZ1XdoiWz4EMom60gupzpP7Nv3WrO38DvbMMAcEpGzkBIMp4wFysSCmlUGBZIuCn5QWE3IVOxh9vc5dPp9B7fdbiExCWmcOnVG6spVtyWtqScU/B3t+lgJCcSLODr41/Gve/MF42t8kiFlvKyjNLfn443jEPeSZ80cy/VRNnhP3lcjpDr+g/t48Xv+0N/B7qY8hNJzo5AptyAPJRXM9g4cZJ2IBpCprAe+TwAUvw9iAj5kQsMo0bsksbeEIJT4Lu7zhzvLSFzD/
 U2CyeNhj
 HMDsJG2PmnBeBgBRgm6QZLR74Z7/USVBf7yg1Q2jZPl5Q+ics6w/5STAceKOg1mFUo1V9WZEjXoUGoLeJL8YJRMomY2WSInE6zjs2rb9LK4YfhVuN8V/PDMmpp8OYUauDFKjl+YQjJUco7JsLq9n40qKlNNb4bB5o5AUWvI8Cg1gerRST63HN5LO+A3bl5P3QZb6OzCgWZSzHF9/UfQZHECrIPWph8/g5CoXrXx4LF9K7FahUmWazn4r8StQ4sOo1fo2RJDOpzbJ3MfQeLE7uT7fnBz0ZBy7+CWEALlfwFbVwg6eBiLh7k2v2lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 15:40:05 +0000 Josh Law <objecting@objecting.org> wrote:

> Hardware integer division is slow. The function damon_max_nr_accesses(),
> which is called very frequently, performs an integer division.
> However, the struct damon_attrs already caches this exact ratio in the
> internal field aggr_samples. We can eliminate the hardware division in
> the hot path by simply returning aggr_samples.
> 
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  include/linux/damon.h       |  3 +--
>  mm/damon/core.c             |  1 +
>  mm/damon/tests/core-kunit.h | 16 ++++++++++++----
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 6bd71546f7b2..438fe6f3eab4 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -960,8 +960,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
>  static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
>  {
>  	/* {aggr,sample}_interval are unsigned long, hence could overflow */
> -	return min(attrs->aggr_interval / attrs->sample_interval,
> -			(unsigned long)UINT_MAX);
> +	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
>  }
>  
>  
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b0ab0ee6eab9..59b709f04975 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -582,6 +582,7 @@ struct damon_ctx *damon_new_ctx(void)
>  	ctx->attrs.sample_interval = 5 * 1000;
>  	ctx->attrs.aggr_interval = 100 * 1000;
>  	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
> +	ctx->attrs.aggr_samples = 20;
>  
>  	ctx->passed_sample_intervals = 0;
>  	/* These will be set from kdamond_init_ctx() */
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index e86d4f4fe261..56d03ef6a5a4 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -416,6 +416,8 @@ static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
>  		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
>  	};
>  
> +	attrs.aggr_samples = attrs.aggr_interval / attrs.sample_interval;
> +
>  	/*
>  	 * In some cases such as 32bit architectures where UINT_MAX is
>  	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
> @@ -434,7 +436,8 @@ static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
>  static void damon_test_update_monitoring_result(struct kunit *test)
>  {
>  	struct damon_attrs old_attrs = {
> -		.sample_interval = 10, .aggr_interval = 1000,};
> +		.sample_interval = 10, .aggr_interval = 1000,
> +		.aggr_samples = 100,};
>  	struct damon_attrs new_attrs;
>  	struct damon_region *r = damon_new_region(3, 7);
>  
> @@ -446,19 +449,24 @@ static void damon_test_update_monitoring_result(struct kunit *test)
>  	r->age = 20;
>  
>  	new_attrs = (struct damon_attrs){
> -		.sample_interval = 100, .aggr_interval = 10000,};
> +		.sample_interval = 100, .aggr_interval = 10000,
> +		.aggr_samples = 100,};
>  	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses, 15);
>  	KUNIT_EXPECT_EQ(test, r->age, 2);
>  
>  	new_attrs = (struct damon_attrs){
> -		.sample_interval = 1, .aggr_interval = 1000};
> +		.sample_interval = 1, .aggr_interval = 1000,
> +		.aggr_samples = 1000,
> +	};
>  	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
>  	KUNIT_EXPECT_EQ(test, r->age, 2);
>  
>  	new_attrs = (struct damon_attrs){
> -		.sample_interval = 1, .aggr_interval = 100};
> +		.sample_interval = 1, .aggr_interval = 100,
> +		.aggr_samples = 100,
> +	};
>  	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
>  	KUNIT_EXPECT_EQ(test, r->age, 20);
> -- 
> 2.34.1

I think this amount of change is somewhat too much maintenance burden for the
simple optimization.  Apparently aggr_samples was not designed for this use
case.  I think another way should be used, but failing at finding a good
alternative.  And I'm not very sure damon_max_nr_accesses() deserves that much
time to optimize.

So, if you find a better way for optimizing damon_max_nr_accesses()
without adding maintenance burden or evidence of benefit that justifies this
amount of maintenance burden, please feel free to repost a new version.  But,
in my humble and frank opinion, I don't see that much worth in the
optimization.


Thanks,
SJ

[...]

