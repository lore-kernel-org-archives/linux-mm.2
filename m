Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC91E606A7B6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=g-ucla-edu.20260707.gappssmtp.com header.i=@g-ucla-edu.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=o3IC5gqK
Received: by kanga.kvack.org (Postfix)
	id B65686B05DF; Mon, 16 Nov 2026 06:07:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17396B05E0; Mon, 16 Nov 2026 06:07:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7436B05E1; Mon, 16 Nov 2026 06:07:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9C56B05DF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BCC340949
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:05 +0000 (UTC)
X-FDA: 85440705210.26.74D9ABB
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 524E84000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	none
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1ae58d17cd9so2307899c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20260707.gappssmtp.com; s=20260707; t=1794827214; x=1795432014; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=++HRlb3lmLPEyFHs8o+X0oq76Kzwdkq3LTMbh5HSJ6Y=;
        b=o3IC5gqKpTpRD8AGMdgN6Qr6oA6yufgL8zhdM8JJaeAvESUUipoqWH3oE8U2aHKyXg
         gzEMpQr6CfpRG+iqVqNAdB8fsk492B99twp7WYbNQrfy47eW2L8yr8RwJMpf3qTef0nc
         RgEv7ZkjS2e8n5Wtl/DSVSlPga71YtVYwsOU9M5KAnDB+p+016Hq6ltD/DF6reYqpAbk
         Kr67hPvB51KOzJ7PSNaE3i+ZHDg0n+ffT/dkawHmpqMibAh72FHaHz5FDU4dVhKW424E
         GCHOeIpDUU4zU/j08E9fBVDJj7ELd0PHOXcAKfEwA5UUaNv+GWQLyttzvPq2rUPrzlzP
         sXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827214; x=1795432014;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=++HRlb3lmLPEyFHs8o+X0oq76Kzwdkq3LTMbh5HSJ6Y=;
        b=CiwCrRj6zpYX8FPvArZIXGWmsubNolKdE5kcjkk0mcW/o/J4OyX0UAatxPPL9xx/6W
         TdespyIPbAcm1KZ4C2bpW6Yz6e8TFYieNXe6OpX7MBFEDJU+e0w8Y9LRvxq0RLImZM0I
         SNcE7CFwww+XzpufDurjJ5TjtQbna0pNJmYHOnneHmedEClvWuNcn7+g5zR8SRrIPm9u
         pQ3QwwR6MYpMkK7Ro7cbBnkp421/ADTKnXX5katIaTE/kYLCahcZDr9BjVud5FpCovOh
         MLtNprnqhGNJx59o/Xbo1av25YqEH461YoFGwZVK/64H+YaaMpJAi93VHNNTh+seIq87
         5TPQ==
X-Forwarded-Encrypted: i=1; AL+hErFRcXqFEyJ5W3YxkCeRDxgX3OfphVX7Zl9I7zl1gSBAc3j0gSe3jgBw6ubtS8g+XjQBggpk9z7UgA==@kvack.org
X-Gm-Message-State: APuU4Z/cvfm4NzEQcS16m8kFfQ9zDSlnYETFJA340cSh1AZsJQzGrbSp
	kvVY2RSfYN0HoxqlE5D8MsrTPPBj1Qc1OW2QGU5DZ7FE2CTcO+RFaWw0dl1M1GiCs1M=
X-Gm-Gg: AYBFou32tka+ohjfyBzVfjkrTJtBiT7EMkgHiFOMv3z5PcSfLi3RAq/ku7gu4qc0Wdx
	Ga14AIAb6adosaPyQlmmR9zt9nY6BaUANNUpfd9ah7m+NJmddUE1BscTV2ptec7YsJ0oP7MWUj+
	t3tVWNHJyiLzpK5M8RfmGQQF7nGZOxzVzSs7smKXfwmXO0AuFhy0TsZWfPjn15e/zFh5IcTATcW
	PkVJRng/ikdHVIE4Cj/L9X+43SYPsqxpNt71UsF9lSUAugtdRBVgr00zm8MvUMuTL11LCiJr/+m
	FW4aTCSB3bSK8xuIvC4c5WasdMwxE9uen/i+lKTjQTmkVnKaEwVeKFRk4gezhcf47/1j3aXEKwA
	a0oSxXVDB/G3OQf8zw6DdipO/NR4OZfz+CZBYTIVmb1oMzE53RgnAfqku5wuCtihWHR3fKm+FeH
	DzKIi8OwPrLBnMl99Ati8nlqcuWRancdpPe2SWRjU/aU+kIL7w6DZfpI+YqSeG6YystLWgdhxge
	SZnc/m86pDklxfBoEKddK0ubeoNGBl6UhZZOEqLUTINgnsFmnJa8sAiW9zR2Y1muS83ppKeXATy
	lcnV8GsgF2PdNGy01fJ57CM8bLLQzNuersR7Hm4XR2OptpjFIbE=
X-Received: by 2002:a05:7022:ea8b:b0:15e:9126:c60f with SMTP id a92af1059eb24-1b5030e2ef6mr9036471c88.29.1794827214001;
        Mon, 16 Nov 2026 03:06:54 -0800 (PST)
Received: from [127.0.1.1] ([131.179.95.34])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b524049e0asm12522103c88.4.2026.11.16.03.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:06:52 -0800 (PST)
From: Jason Angelov <jasonangelov@ucla.edu>
Date: Mon, 16 Nov 2026 03:06:23 -0800
Subject: [PATCH v2 3/3] mm/damon/tests/core-kunit: test
 DAMOS_FILTER_TYPE_AGE_MS interval changes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-test-age-ms-filter-v2-3-3b265d59ec98@ucla.edu>
References: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
In-Reply-To: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jason Angelov <jasonangelov@ucla.edu>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 524E84000C
X-Rspamd-Server: rspam12
X-Stat-Signature: ynz15te4itibyg1b445wxq9315trai4k
X-Rspam-User:
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827215-186668
X-HE-Meta: U2FsdGVkX19hin1W3uPJ2l+AqfPQp4vm6yFpnlW3PZaSR5WT1CEn8W1V8Ap6ZT/1+YfscbcH+A0fIeTCOqJTcV2pkg1HAbNMasn5MMUAtIJiWxaLhWpisFP9ok0sUorCl0M7fUo644DkKN0w6isHY7OuMtpp3PsLp6PPwg7oQ/IvhrvU2Xb4QLcg/E0xruSSudSohEzG/qFqdz6/j3oDGZJI3m+82mtigyrqeokejHUvaAAm+3q/V9NNuqUiaid9QcShgXiFe33X7hkBWDz6rppkA6H8AP8St98dlKgvdqUHP5BeC5ckfFwRubfu9x7vXEEb72tk09RMADPkFjRTxWtKxfgcTvtrCAjF9e3AxtRPrSmQcjBgkj/FVkgowxpM3c2D2aGDuVtdWzWsuharnFmLB1QabKNRnDCD7j4wh8IqOUZsgqP2q0wlb4zB+Z3zBABWeyptsBTPa/i72TaDWKmXekw6E3xxLauAWZtRSnOCmBSavNnhtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS_FILTER_TYPE_AGE_MS defines an inclusive range for age in
milliseconds to filter for target regions. Aggregation interval can be
changed by users or intervals auto-tuning features.

Add a kunit test for each:

- convert region age to milliseconds, correct behavior at boundaries
  for defined filter range
- DAMOS_FILTER_TYPE_AGE_MS filter keeps correct behavior even when
  aggregation interval changes

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
 mm/damon/tests/core-kunit.h | 66 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 156f74832c40..3b2b745b8546 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1838,6 +1838,71 @@ static void damos_test_age_ms_filter_is_core(struct kunit *test)
 			damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
 }
 
+static void damos_test_age_ms_filter_interval_changes(struct kunit *test)
+{
+	struct damos_filter filter = {
+		.type = DAMOS_FILTER_TYPE_AGE_MS,
+		.matching = true,
+		.range_min = 200,
+		.range_max = 400,
+	};
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	int err;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(ctx, t);
+	r = damon_new_region(0, DAMON_MIN_REGION_SZ);
+	if (!r) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+	ctx->attrs.aggr_interval = 100000;
+
+	/* An age of 100 ms is below the 200 ms lower bound. */
+	r->age = 1;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 200 ms matches the inclusive lower bound. */
+	r->age = 2;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* At a 200 ms interval, age 1 matches the lower bound. */
+	ctx->attrs.aggr_interval = 200000;
+	r->age = 1;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 400 ms matches the inclusive upper bound. */
+	r->age = 2;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* At a 50 ms interval, age 8 matches the upper bound. */
+	ctx->attrs.aggr_interval = 50000;
+	r->age = 8;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 450 ms exceeds the 400 ms upper bound. */
+	r->age = 9;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	damon_destroy_ctx(ctx);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -2600,6 +2665,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_age_ms_filter_is_core),
+	KUNIT_CASE(damos_test_age_ms_filter_interval_changes),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
 	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),

-- 
2.53.0


