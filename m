Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A78BECA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9F86B008C; Fri,  9 Oct 2026 03:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2926B0093; Fri,  9 Oct 2026 03:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF666B0095; Fri,  9 Oct 2026 03:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26D556B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:43:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7765A798D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:43:58 +0000 (UTC)
X-FDA: 85302298956.17.5B22B10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2F893180009
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:43:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gwklBata;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791531837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrj+nhypUG08L0LQQg/weWxoS5B/DorI7msAivdz5r4=;
	b=28+0gRhd8hm3Skp3FwDj0ias3We2Zq3O/r4XvafdMnRcNvkMPmwhi78vrP131+l0snPAqr
	RawT8XlAiacxRxmCyxYmizntNeSMpWA5KTKY/AgpfgX2/lugEE1TPTnqvV17rDOFGdNGrT
	UU9bV73FNLUlr+8EraL4ybns9avbDxQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791531837;
	b=l35RP1Rz2zfrJWUhU8/yHx/WQtKmtqzbS9mctHq4x4IFdeayGYxAVVEWP+2eC0bLLpzoOC
	XjDNDziyDT57UmnwmrbImoNKAbsjZz916m1UudC+mLTozQSaLgNh+QJhWF33i/+HOwGOjP
	FUqveA14ehNT9dedyTI8v5NCucAWMU0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gwklBata;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03781602C3;
	Fri,  9 Oct 2026 07:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3101F00893;
	Fri,  9 Oct 2026 07:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791531835;
	bh=vrj+nhypUG08L0LQQg/weWxoS5B/DorI7msAivdz5r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gwklBata4izVqdnVUPTJdgYIIsv8m03v60Hc+bMKD8+zpMaEnf8Yh8YDnirz6DcnS
	 L/+gLFuj1V1AQSivhZN/XcFQkIJlA7VweNG1lchxo0slVwPTtkhHlcKKwCj2pxSf1B
	 w5eLrgV2SK/isxSwfgEyYXEDeaXK0EMaPeguxTCYGPh+x4orL86omnezAdibluxnzZ
	 0/eIHOmCJYta0REGuZ54YSkc26p7OVIWdEK/3U8lY1txZXIvADbR+Eam7vnVuYK7P+
	 hM53XYqQzBD43q0DgRgeVSkSu4wrs4tWgEWrrscS7pVK6ZwmLPf7gO87jtiYekszij
	 u2/FKsV2OMNtw==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon/core: Use only installed probe in damon_merge_two_regions()
Date: Fri,  9 Oct 2026 00:43:49 -0700
Message-ID: <20261009074349.40812-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261008151944.113714-2-suhaas@s-joshi.in>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2F893180009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: uiowzrp4eyityhzjth8eyhhfpcqzocd5
X-HE-Tag: 1791531837-130117
X-HE-Meta: U2FsdGVkX1+P30ZWX4tUPwvi0pNKHSZiLnJadUGqY4u9LpVj5U/dM8icW3YsI/pabbqnBqu0MHicTNiB50dHpPXleVMlH6AX3mVYDKnu8B+eXPmIQa9pwPnIT7wDRhhrMySHuUmjIUHRbsZ817QycfPLNd2hNhnEo5aHlKtdPTlY4DbhvzFNPkU8SHmdxlgJti4zo68sdkxloYVYb2Duzb0g6ro+ezhvXaHHqz+HkO817ZWB0e2RNXD6YPv5j1ZLQuubni6bkn45k3hqa080kHZmA7fR1aLF53plggTa3fmfzpcaeZNOIvo2n45kjwDEx2ihZzFwGLrww3ST35Y/EaujxJrV+/UQmLcavgRdycjh3KLZEuO//gJmyCNz4ZitpI9HPL7syXpB+lfoN/9UtTtM0wBFgWiJ/noPR7Nj2YwxAqfxJLd5F9dUVjinfFlPyYRq6v+k3906CocMCjwbNdSs4fBoCKQ2gm7NdtAGWMgL8x0heyR+DN5BqNuN/xkbv+6BYdE3agJG1DaOO/9GlMyKMIjUyfQI4rn/buZpPw+NR4RXwKtjirrQLtcsVOqdKk2syxEAxpFblZL/H7knQRr8nMOWzyec5FBqnOOQKk9+HGa4VHKA2ky0PuLSHyMOUNcC0TpPIRzBJSS6ztEuXLJ4ggxeSP+T/qYkr+xaApqXqy8ICfXNCDzhAuxMPLVvx9TFjORvl898IgntOX2ijwp3cuK9UA7HeFAY8pnfyDTVZT+8Evsq7Zc53SFKL7rh0ieFL3AtRumru4BTJ5NUw1ptW79S2klaqsc8Tm/pG9dLnmPrwNysOIQHTYG4EoylMCBtAU/JqpFdcTu2BgyjMw4utSJ79wvErDdlUpHF1c5ybcJ6QSYryQsNosG7nU0EEMWso/N4OM7hgwRupz2H/8hfeEld3+ZOhK9/oZduigi4HTY1JXx5UE2/YM3EaAOKq5aB7eohnVDkm9eTGij
 fqI14nrZ
 tUcabdeHFjvdu/FzgtHjtY09JgWpvHyAMBlEZwQx4tzsK2aPRvCZt44vSWV051X858GoteITAyBNGmNcvuSTCA2muwbB7r0+51P7qqriXZkVjGzpIowcNc4GxcUVEgVTKpWICSOSAf2fuSXsz05Lt+k0tiynsrqAaCjZExtF8Tf7tQo7c3Z5k3ZcsXIPlowNVZq6+aY6alwe+5UMKtN0pjTLXanXzRMAziCFCVwxHeh++ojA5YW+HSif0D3m3TUNTvSrA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Suhaas,

On Thu,  8 Oct 2026 20:49:25 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> While merging 2 regions, we iterate over the entire probe_hits[] array,
> whose size is determined by the DAMON_MAX_PROBES macro. However, it is
> possible that we have fewer probes installed than DAMON_MAX_PROBES. In such
> cases, we end up making redundant iterations. Therefore, to remedy this,
> iterate over the list of installed probes instead of iterating over the
> entire array. For doing this, start accepting a struct damon_ctx in
> damon_merge_two_regions(), and update calling functions to pass this
> argument.
> 
> Update the damon_test_merge_two() test to use this new signature for
> damon_merge_two_regions() as well.
> 
> Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
> ---
>  mm/damon/core.c             | 16 +++++++++++-----
>  mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++--
>  2 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b63e60ef8990..fc202f90991b 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3524,20 +3524,26 @@ static void damon_verify_merge_two_regions(
>  /*
>   * Merge two adjacent regions into one region
>   */
> -static void damon_merge_two_regions(struct damon_target *t,
> -		struct damon_region *l, struct damon_region *r)
> +static void damon_merge_two_regions(struct damon_ctx *ctx,
> +				    struct damon_target *t,
> +				    struct damon_region *l,
> +				    struct damon_region *r)

Please use two tabs for indentation of the second and next lines of function
parameters.  For example:

'''
@@ -3739,8 +3739,9 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 }

 #ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_merge_two_regions(
-               struct damon_region *l, struct damon_region *r)
+static void damon_verify_merge_two_regions(struct damon_ctx *ctx,
+               struct damon_target *t, struct damon_region *l,
+               struct damon_region *r)
 {
        /* damon_merge_two_regions() may created incorrect left region */
        WARN_ONCE(l->ar.start >= l->ar.end, "l: %lu-%lu, r: %lu-%lu\n",
'''

>  {
>  	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
>  	int i;
> +	struct damon_probe *p;
>  
>  	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
>  			(sz_l + sz_r);
>  	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
>  	l->ar.end = r->ar.end;
> -	/* todo: do this for only installed probes */
> -	for (i = 0; i < DAMON_MAX_PROBES; i++)
> +
> +	i = 0;
> +	damon_for_each_probe(p, ctx) {
>  		l->probe_hits[i] = (l->probe_hits[i] * sz_l + r->probe_hits[i]
>  				* sz_r) / (sz_l + sz_r);
> +		++i;
> +	}
>  	damon_verify_merge_two_regions(l, r);
>  	damon_destroy_region(r, t);
>  }
> @@ -3590,7 +3596,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
>  			goto set_prev_continue;
>  		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
>  			goto set_prev_continue;
> -		damon_merge_two_regions(t, prev, r);
> +		damon_merge_two_regions(ctx, t, prev, r);
>  		continue;
>  set_prev_continue:
>  		prev = r;
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index ef146ca2ae8a..4e380c6c5eb2 100644
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
> @@ -198,6 +212,7 @@ static void damon_test_merge_two(struct kunit *test)
>  	damon_add_region(r, t);
>  	r2 = damon_new_region(100, 300);
>  	if (!r2) {
> +		damon_destroy_ctx(ctx);
>  		damon_free_target(t);
>  		kunit_skip(test, "second region alloc fail");
>  	}
> @@ -206,7 +221,7 @@ static void damon_test_merge_two(struct kunit *test)
>  	r2->age = 21;
>  	damon_add_region(r2, t);

Let's allocate and setup 'ctx' and 'p' here.  That will reduce alloc failure
handling code.  Also add 't' to 'ctx'.  That will let us to remove
damon_free_target() call from the final cleanup.

>  
> -	damon_merge_two_regions(t, r, r2);
> +	damon_merge_two_regions(ctx, t, r, r2);
>  	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
>  	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
> @@ -220,6 +235,7 @@ static void damon_test_merge_two(struct kunit *test)
>  	}
>  	KUNIT_EXPECT_EQ(test, i, 1);
>  
> +	damon_destroy_ctx(ctx);
>  	damon_free_target(t);
>  }
>  
> -- 
> 2.55.0

Thanks,
SJ

