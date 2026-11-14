Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082EA606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJOENWwj
Received: by kanga.kvack.org (Postfix)
	id 0BC9A6B05B5; Fri, 13 Nov 2026 21:20:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066B26B05B6; Fri, 13 Nov 2026 21:20:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBEA86B05B7; Fri, 13 Nov 2026 21:20:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8EBB6B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:20:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F98F1A0322
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:20:14 +0000 (UTC)
X-FDA: 85432119948.23.014CF16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 95E66140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:20:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJOENWwj;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794622812;
	b=n0o/CS77rNV0o28vWvDpMdtAUptOF6Uz6CVWh2D6ftl4d7ebsaipB52nXAO1yjDVE2f6s/
	MrvqEkWNDKSDrhtbhzUg77kpOhYRvUic5/apH7e3pJT97qUOrJzPWpOzKp/V0cprpiPp5v
	R9B/qaplvp4AzNpa7s2Fn+9R9Po63Lw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJOENWwj;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794622812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bGsd12+MFPupXLn2HJlax53WlKnxsLm64VvDIFikGQ=;
	b=4nZYALqAQBwKrtEv2yjJwIlefyjN9ObiQkVBj88n4t6xcYGFObk7pyvENMTFjcq74GIFcy
	IvyyS/XBcfRAkx3hOtZw/S3cYsrkCkIxCEkBH+t2Z9AHMTbBXPQcEJMGperiJciaWKJhX7
	PA28BqUMJCF3qKoAklUyY/lUf5Mc4ns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19D9C437BD;
	Sat, 14 Nov 2026 02:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C451F000C4;
	Sat, 14 Nov 2026 02:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622811;
	bh=6bGsd12+MFPupXLn2HJlax53WlKnxsLm64VvDIFikGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJOENWwjAMpzrTNkqG3+m3Ig8inmXTzAD5uRAYyUl+LECaWsrGECMtNxx/luhMuFL
	 m6IQtIL6qAO0wcEGSJhzoQN0cepbKlJcIWI0subP/xHH7WK4mAF915pvAq1YsPv7hk
	 x5yERpWNMAu3akcd8VEiI8W4KkTPuAtJt1MeB+if3nv7d8exY/SC+dreyZVc4NE5hj
	 4wEm38D8XbkFC9gHpx3fF0hok1BW4qnTpYxJpdFqdKQbQq9+4qlXy/e7Be0LoExMIG
	 Is6mE382MiI6oIX1Sj+OfbiMcL6Irc4SswevnLCYw7zUpJ+RK/Bo5K6cdPcw1muliY
	 6y/X4zzp8MQYg==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval changes
Date: Fri, 13 Nov 2026 18:20:03 -0800
Message-ID: <20261114022004.110044-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113-test-age-ms-filter-v1-3-b99eab2f71bb@ucla.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hmgxzyj1andwoo8998jcpjwxd4yepj86
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95E66140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794622812-498180
X-HE-Meta: U2FsdGVkX19xG6qjQrdolmP01HqcMcNyOn0yiDrhPY27bFRliTVqk24tKV3MrYjulE/rOgMiH8Goeq4W7j4i8I5zofUuTmL9njlUL0tpIAS+4uMCF4eGvNyizU4VvNykG2iYeeLahs3XQP4qP9B2EOeVWDM5vQDoud6BjHYlA06xjRI1b1cS/Y9H4i9FDFcBZ+vYruq37+uN5N0kBmaH1HfJgHYIFTRObqgECn2SwucITzsusA1eBLxRifarq9OKVWeABwMUvkID0ciZvzbympcNLng78O9bv05KWsZ/aHKrEaiZjkH886JRRfClAKvlFiTOlqJlY6Rr+3ou/aCLpApUVdqVctyhNBw15wpvjV6H2qPHJFRhJZ+d7TJos1+vKgZJPpxcP5TrUXbeGvfbNZFcESEI4Z34WAH3HBKfydcMKOC5cmikaSQeZu9yJXQL9gXC2EUmZ+Ybf6cQDm/skBZWPmgQfmSWtm/jaR3b3GeKJ4QlAffJ1vHTuWMvXoFxZeCYcfwkMA6Lxd+vpxVnv10DAsER0cnGaBtpHvPGmradpsId3R8TMNH87nel8dUx3yYqwGf7Gjj7uccV5eOpEddJs1Ka3i6y2lyZIuEMHZS2a7u8R1LwuRWNv1+eMa6tDx6j+yb835cKymck/K7W8PklOUWFx+HgqEaWCElJA4BprgCw9BTHhH7QCR+MLeV02RgG2B0OoefpVERy3yt0xMbozpZZCxXqCLzOXmDV3iDuyScE3QWLtvF4pqQDzludOLc5BoCa3l9/22q4AVaQp/Je8vGoMjbHdC9gxH0OyW4wDMu0tay1UHjcFCIJtPkVIMf1aXZ2HdZFpJmUaKFe0tncr6ntBgurOpRqcHgPEWxRlDxwrWQ+5u26HIg2yj7G+lWYtIDDNa04jkoZavKMHf+ySMEkHZxPsWQ+rEwEKY9uud+rikiyOXBOrzJsq6t/aZqnAefBsC4Wmr0slS+
 74tvwiIm
 LnsjCno/EtEWyjSH4Bb9ldxbIibTKDlFbZ0dUbVdaCGTXznypXmc2/ECd7rx2mW14bB27YJ9jhOCTUkCFR+2fid44JXasD5znTupZQPTi3T9ZBlDUlG+edgLfAa+hwMBxBffekGMqX7oik5o0lYdP4xcv8b+uwJqpNHOa65LaIzS9P/7eYEs9tL8+gjrzjGlwl0uAyzh6jPPKBtUAJjnrjxZ1ZI/1ac7nqpqkH78S/y90aHzg5XhKHdlYSbBhbJ7jlJZp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 07:58:57 -0800 Jason Angelov <jasonangelov@ucla.edu> wrote:

> DAMOS_FILTER_TYPE_AGE_MS defines an inclusive range for age in
> milliseconds to filter for target regions.
> Aggregation interval can be changed by users or intervals
> auto-tuning features.

Let's put the second sentence in the line of the end of the first sentence.  In
the way, we can save one line.

> 
> Add a kunit test for each:
> 
> - convert region age to milliseconds, correct behavior at boundaries
> for defined filter range

Let's add two spaces indentation, to make the bullet point lists easier to
read.

> - DAMOS_FILTER_TYPE_AGE_MS filter keeps correct behavior even when
> aggregation interval changes

Ditto.

> 
> Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
> ---
>  mm/damon/tests/core-kunit.h | 81 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index fb84d30a712d..6de7c2531702 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -1837,6 +1837,86 @@ static void damos_test_age_ms_filter_is_core(struct kunit *test)
>  	KUNIT_EXPECT_FALSE(test, damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
>  }
>  
> +static void damos_test_age_ms_filter_interval_changes(struct kunit *test)
> +{
> +	/* Filter window: 200-400 ms.  Start: 100 ms interval, age 0. */

This looks like not a complete sentence for readers but a personal note.
Please make the comment more human-readable or just drop.

> +	struct damos_filter filter = {
> +		.type = DAMOS_FILTER_TYPE_AGE_MS,
> +		.matching = true,
> +		.range_min = 200,
> +		.range_max = 400,
> +	};
> +	struct damon_attrs attrs = {
> +		.sample_interval = 5000,
> +		.aggr_interval = 100000,
> +		.min_nr_regions = 3,
> +		.max_nr_regions = 3,
> +	};
> +	struct damon_ctx *ctx;
> +	struct damon_target *t;
> +	struct damon_region *r;
> +	int err;
> +
> +	ctx = damon_new_ctx();
> +	if (!ctx)
> +		kunit_skip(test, "ctx alloc fail");
> +	t = damon_new_target();
> +	if (!t) {
> +		damon_destroy_ctx(ctx);
> +		kunit_skip(test, "target alloc fail");
> +	}
> +	damon_add_target(ctx, t);
> +	r = damon_new_region(0, DAMON_MIN_REGION_SZ);
> +	if (!r) {
> +		damon_destroy_ctx(ctx);
> +		kunit_skip(test, "region alloc fail");
> +	}
> +	damon_add_region(r, t);
> +	KUNIT_EXPECT_EQ(test, damon_set_attrs(ctx, &attrs), 0);

Why test damon_set_attrs() in this test?

> +
> +	/* below window: age 1 = 100 ms */

What the "window" means?  Filter's range_{min,max}?  This again feels like a
personal note rather than somewhat useful for other code readers.  Please make
the comment more human readable or just drop.

> +	r->age = 1;
> +	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
> +			ctx->min_region_sz, &err));
> +
> +	/* inside window: age 2 = 200 ms */

Ditto.  Same for all comments in this function.

> +	r->age = 2;
> +	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
> +			ctx->min_region_sz, &err));
> +
> +	/*
> +	 * change aggregation interval 100 -> 200 ms:
> +	 * inside window: age rescaled 2 -> 1, still 200 ms
> +	 */
> +	attrs.aggr_interval = 200000;
> +	KUNIT_EXPECT_EQ(test, damon_set_attrs(ctx, &attrs), 0);

Why test damon_set_attrs() in this test?

> +	KUNIT_EXPECT_EQ(test, r->age, 1u);
> +	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
> +			ctx->min_region_sz, &err));
> +
> +	/* inside window: age 2 = 400 ms. */
> +	r->age = 2;
> +	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
> +			ctx->min_region_sz, &err));
> +
> +	/*
> +	 * change aggregation interval 200 -> 50 ms:
> +	 * inside window: age rescaled 2 -> 8, still 400 ms.
> +	 */
> +	attrs.aggr_interval = 50000;
> +	KUNIT_EXPECT_EQ(test, damon_set_attrs(ctx, &attrs), 0);
> +	KUNIT_EXPECT_EQ(test, r->age, 8u);
> +	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
> +			ctx->min_region_sz, &err));
> +
> +	/* above window: age 9 = 450 ms. */
> +	r->age = 9;
> +	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
> +			ctx->min_region_sz, &err));
> +
> +	damon_destroy_ctx(ctx);
> +}
> +
>  static void damos_test_filter_out(struct kunit *test)
>  {
>  	struct damon_target *t;
> @@ -2599,6 +2679,7 @@ static struct kunit_case damon_test_cases[] = {
>  	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
>  	KUNIT_CASE(damon_test_valid_probe_params),
>  	KUNIT_CASE(damos_test_age_ms_filter_is_core),
> +	KUNIT_CASE(damos_test_age_ms_filter_interval_changes),
>  	KUNIT_CASE(damos_test_filter_out),
>  	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
>  	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),
> 
> -- 
> 2.53.0
> 
> 


Thanks,
SJ

