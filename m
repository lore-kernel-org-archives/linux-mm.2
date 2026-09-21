Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE64C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 00:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B08F6B00C9; Sun, 20 Sep 2026 20:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667536B00CD; Sun, 20 Sep 2026 20:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBA76B00DD; Sun, 20 Sep 2026 20:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18EF76B00C9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:30:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 449421604B5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:30:57 +0000 (UTC)
X-FDA: 85235889354.19.6B7E00F
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf06.hostedemail.com (Postfix) with ESMTP id 72DF818000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:30:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="XD6/TEuQ";
	spf=pass (imf06.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789950655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dpGtqMcJeHhOEzV/bkAAFY9Zr0/SXcgfjA47TvgATw=;
	b=fUvWTLKZS2gJwBaBCMhsRZTFjJaOwx8K5nlPEVb/lvX9FhX1R63NN0SxxNPgV6TB19Dcnn
	ziCCFwVp1l86LfLb9zHhxExGfokcprty0dlngRD4QmLWGLXfq6n6TxAA6XOFtExiELRiW+
	qW1mfjVd0QMj8oRhbwOWY5y6OauGFRQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="XD6/TEuQ";
	spf=pass (imf06.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789950655;
	b=t6Jzjdbs8aguRr0FeD1q571tpcuoq2+24r8twK6Y1AaOPBLWigXbb0olgJcXIgCx4uJhoP
	r6Ifjb+u02QOSGQJUVjNWodTGYk1pvFvGHDzJRz5wdscmENxw4/rvvbRimPoizZu/Wi/HJ
	XS1c6I3rdusUr9rv40yk/8K7HIGGPqM=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843c3ea1f6so912291f8f.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789950654; x=1790555454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6dpGtqMcJeHhOEzV/bkAAFY9Zr0/SXcgfjA47TvgATw=;
        b=XD6/TEuQ4SpFt943K0eS4ejxJoLLL4usLXPses3nX197rXFsW1NcHRS4tKq254VUeB
         SLS/yYs6BdHAUrzzKX68BtilZqp0kIXZjDZCNcPpbwch/e1mU0cE2JliGaeBS03ch+pt
         2+Y0DhlWOG4k0eH0kL9I0qBPK4iygRaoeDsI8EKnxaeW5n6xLCfgSsNx97uN1eqHrnaK
         CazayW3JUIqOpRxmxOqa7557KJeEGrpVHcnyIjLUrtcRudTMgnZiuo4kxPTbkn+fM1MA
         0V9xUN50GMLhEC8x8XdLJ/KsVAMwFWgNeZraMO0M3TCll0dNJwqy1vwBBDhCp4Wfu+gZ
         ixAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789950654; x=1790555454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6dpGtqMcJeHhOEzV/bkAAFY9Zr0/SXcgfjA47TvgATw=;
        b=ZDAMHiEa6YeAptn5DJvA2/o+2318MYAsje9BNtlVjv3Yedf8NcqFgQQxqTAZOOOeDF
         RICpzjg/PiRAFAnd8gIILXfnohyOwEq9MgqEI+97fIIfW/dmdKK9ONCeZUtfLNaMaSRz
         aPnlJjmukMjsvv4O7MYS+YvS9CcRke5IeQhmdat0NbYfExd0t3Rgi993dX7m8jjsATyh
         f4vdj2BY0lE2Bn1P5y076MHu55BFo1N+4Lj459mfbjssmPrA6rJAblmPNclZD2BTSnMB
         SU0DNyMQ0al787/GpyAIqHD4WODJX9TsXk86E1On0vH57JtN4nrhdsiy2nEjc4mWzR2n
         4++Q==
X-Forwarded-Encrypted: i=1; AKwUvBxxKJqA4OyDVp3PWoWwot/PM84mJfRfyHtWLUtyUy/eT3J+IfNKhRpw+cpMksILXG0iva1LquzvPw==@kvack.org
X-Gm-Message-State: AFuF++lLk2A9uBkwnK9IfEd+G7XuSBQ798U7GcT+RUIs8nUnYLzOj8lD
	VRBTbPqm+BMshk78aKnMVBZregOtPmUvnOV6SGGHC/SBqBvQRFTNMjpA
X-Gm-Gg: AYBFou3RzF0B/Qr1Lq4Qic45T420MFohYm7Abc5vy7t65Nz6hqf/AOVpXjtFFl32oz3
	GI9l0DiUHnl+DjMVKyeblRpkDV/Msyem9ZyP+GV0Cwa7K6vpwzLaD0Q5f1qPGAQEEITlLtvxs6I
	bTuwLgarZRceZr1fDCzjIeafXfnIgnbcYJzYpubH0Q0XGUtJPYYid6UStdFgK4OU5Iexp6W+s6X
	Q+tgLAujZxcqvurUsXoLC995ovHA70ZoFmI8Fa6vGsZf8CVj9jLhjuhB74oB09+V6qkOeqEzBLF
	YVN6MbrJnGEyaikjLdyUx6gAbw2hqYpxwmuzucNhL8WkX2iOclhXeLgEx/SUaxXJbsME9vmymXT
	xkaLj5rbkSwXNfJV5zSHkQdBzWSMNigFhoVzO5mEqmF1vRD2EsB94yEO3ORtQy0sY5FH9KQ4CqV
	ae7AQhzWrtGVQjNNNoGZbDxuJD6RzZNyChkof3uHp9PAnqLetiBnQ0HwQ5SkLuAENvNzsb7Jw6+
	gkC8okpxyWP1P73GioLbiirouf5cupBNs9kiZwaKGZ/kQiFC/K/QwedJTqAiylcUDLqxpnmcN8u
	iikelKTa8cb2aJTRg9izqUf7w3WJ1wO3Rp9Qe5Xy1vMEh7Ntd3lBHX/Z/Tt9af7D9tybZY+0xHq
	95A==
X-Received: by 2002:a05:6000:610:b0:487:afe:c154 with SMTP id ffacd0b85a97d-4871e36bf11mr15086090f8f.40.1789950653979;
        Sun, 20 Sep 2026 17:30:53 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a012-6c01-e0c2-ccc1-7acc-3570.310.pool.telefonica.de. [2a02:3100:a012:6c01:e0c2:ccc1:7acc:3570])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48724583fffsm17515695f8f.23.2026.09.20.17.30.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 17:30:52 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/damon/tests/core-kunit: test preservation of caller quota state
Date: Mon, 21 Sep 2026 02:30:47 +0200
Message-Id: <20260921003047.12041-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260921003047.12041-1-kmehltretter@gmail.com>
References: <20260921003047.12041-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72DF818000F
X-Stat-Signature: d5dkexkeiqbyqhyqondbwxeabnpynre6
X-Rspam-User: 
X-HE-Tag: 1789950655-866479
X-HE-Meta: U2FsdGVkX19jV/u92N07ZEKnL81xxbylIjMUUKeXWstbHUdLGo/hUADMiIOpFEo6ne0XWxhhU7N818zZfq3oU/ieqmHDfpdZqMfvRDXVxGNfVIKIari9oa524dmmeVVwY+gE++n6ERcpauK2YzyIibt/9Z/qbnrRUdUJpiX7+LW1UEiGVmb6yANAmeC5j84CS5oG9sKXQ5THOjPKXDiGBZ4peTf5x9/zaEexFwegshzJ99s4GDffoigy4svtiuyh2VoPL7X0ODaH3kUhFIbj4PCj2o21wzZSOW+lpC6MVcWxPsJVaaTBbWDmQ1c50WXu8iw+ERR/MSSsHYSjrJ2KjlseO3XNkM5Ov4KTEioOiaxVvMFZdezNEu/dIZYDaUs3BkTVjmN1daoS2/uh0Ur3O0G/l5UqzI8BHV2t1XoSY4nCiyUPTuFWD7f+WJN6idZagBIB7vGvHP+poKbaEr+NDn5qpUEPnn5Y+lQfu1B4cNSSlkKutESXeMQMOcAN/7PyvjB7D7nvHsFyJZWn1JXbnjRoISWazq+g99fZQG+36YZvTxkuA/wDSyDRaDb93++s7Iekout50iejp5JlMGNT1VPZeQvFyxsRFoFbD9G3QEm79Gi7UlgFjpqSw84Ga2csiWhqey1gtvnXvS6Z2AnmheqX3HYhSyJ8zgLVmejghpB+pepWntQUUQgOQKgtt5drgyvtiETN6otkfTRFN9Ra7dNjPwtAW4bnr+diu/Xk3k4In+hi+X0leUpbU8lib85s3Hestf8ATBwrl5lkqDfR3DI1w+gEvIxc9VXKfRzAHaRogGTFelSYQvr5POVi2io8UeP/0Kacf2dK3+5qgFEvf6UKrelYzqlrqa06Q7mhLhoQW09QzqXwkzeKmUwv/4TaPK7jz7jDM3eGg2C6dwUdATRPBBUPsXHa73HfBxzerYpZTmZOehevgx8mGSaBRBoFCktH0Ktk37dcse+lg9a
 ABYRiuNO
 gINEvCadTpFBgF6A8W59Kh6Ha2Vz2KDGHVejzFdOUSKlUnEMnKDMnngXpq0L9iJzotSnQCyyJSfBNt9G/9FDiPf/rsTA79BB+y2YeoT3OnJnNuJMYi0virinFZ3zvHU9YctoV6GJ1ceEGVWwkMCvdxoSpwOKDl4KJlDvTjxsocN/ExS8hM2TqhhSPTHvPtA/rDIxWeG7aFP/EZInRl/mdd1xwXdRjtrUQL6pd54wbTN5530zQ7WVhPO44oel6fc1wxL5LRSR4uctI5p9S7trd2/DSo92pkioH384ds/RhpJgydWTBqT+cV+s1XKmnxGYdSVXKGTXGXafDKM0PGoDrM7m/cBffUx4z2jQ2I7RSQjZui4BV1axFm8/3iRlb05T/OsryiHGV8Qzuou+DwdrcwddoF5hgLsXiB+if
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check that damon_new_scheme() initializes the new scheme's quota without
changing the caller's quota. Cover all eight fields initialized by
damos_quota_init().

Also check that damon_commit_ctx() preserves those fields in the
destination scheme for both accepted and rejected parameter updates.
Use an invalid min_region_sz for the rejected update and confirm that
returning -EINVAL leaves the running quota state unchanged.

Without the preceding fix, all eight fields are cleared in the
constructor test and in both context update cases.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Please feel free to take the fix on its own. I can also fold the
context-update checks into damon_test_commit_ctx() if that would fit
better.

 mm/damon/tests/core-kunit.h | 107 ++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5ff0436c58441..811fd668e2482 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -812,6 +812,48 @@ static void damos_test_new_filter(struct kunit *test)
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_new_scheme_keeps_src_quota(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {};
+	struct damon_target target = {};
+	struct damos_quota quota = {
+		.sz = SZ_64K,
+		.esz = 123,
+		.esz_bp = 456,
+		.total_charged_sz = 789,
+		.total_charged_ns = 1011,
+		.charged_sz = 12,
+		.charged_from = 13,
+		.charge_target_from = &target,
+		.charge_addr_from = 14,
+	};
+	struct damos_watermarks wmarks = {};
+	struct damos *s;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s)
+		kunit_skip(test, "scheme alloc fail");
+	KUNIT_EXPECT_EQ(test, s->quota.sz, (unsigned long)SZ_64K);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.esz_bp, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_sz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_ns, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_sz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_from, 0ul);
+	KUNIT_EXPECT_PTR_EQ(test, s->quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s->quota.charge_addr_from, 0ul);
+	KUNIT_EXPECT_EQ(test, quota.esz, 123ul);
+	KUNIT_EXPECT_EQ(test, quota.esz_bp, 456ul);
+	KUNIT_EXPECT_EQ(test, quota.total_charged_sz, 789ul);
+	KUNIT_EXPECT_EQ(test, quota.total_charged_ns, 1011ul);
+	KUNIT_EXPECT_EQ(test, quota.charged_sz, 12ul);
+	KUNIT_EXPECT_EQ(test, quota.charged_from, 13ul);
+	KUNIT_EXPECT_PTR_EQ(test, quota.charge_target_from, &target);
+	KUNIT_EXPECT_EQ(test, quota.charge_addr_from, 14ul);
+	damon_destroy_scheme(s);
+}
+
 static void damos_test_commit_quota_goal_for(struct kunit *test,
 		struct damos_quota_goal *dst,
 		struct damos_quota_goal *src)
@@ -1572,6 +1614,69 @@ static void damon_test_commit_ctx(struct kunit *test)
 	damon_destroy_ctx(dst);
 }
 
+static void damon_test_commit_ctx_keeps_quota_for(struct kunit *test,
+		unsigned long min_region_sz, int expected_err)
+{
+	struct damos_access_pattern pattern = {};
+	struct damos_quota quota = {.sz = SZ_64K};
+	struct damos_watermarks wmarks = {};
+	struct damon_ctx *src, *dst;
+	struct damon_target *target;
+	struct damos *s;
+
+	dst = damon_new_ctx();
+	if (!dst)
+		kunit_skip(test, "dst alloc fail");
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(dst, target);
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(dst, s);
+
+	/* Copy the parameters before populating dst's runtime quota state. */
+	src = damon_new_test_ctx(dst);
+	if (!src) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "src alloc fail");
+	}
+	src->min_region_sz = min_region_sz;
+	s->quota.esz = 123;
+	s->quota.esz_bp = 456;
+	s->quota.total_charged_sz = 789;
+	s->quota.total_charged_ns = 1011;
+	s->quota.charged_sz = 12;
+	s->quota.charged_from = 13;
+	s->quota.charge_target_from = target;
+	s->quota.charge_addr_from = 14;
+
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), expected_err);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 123ul);
+	KUNIT_EXPECT_EQ(test, s->quota.esz_bp, 456ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_sz, 789ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_ns, 1011ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_sz, 12ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_from, 13ul);
+	KUNIT_EXPECT_PTR_EQ(test, s->quota.charge_target_from, target);
+	KUNIT_EXPECT_EQ(test, s->quota.charge_addr_from, 14ul);
+	damon_destroy_ctx(src);
+	damon_destroy_ctx(dst);
+}
+
+static void damon_test_commit_ctx_keeps_quota(struct kunit *test)
+{
+	/* Only power of two min_region_sz is allowed. */
+	damon_test_commit_ctx_keeps_quota_for(test, 4096, 0);
+	damon_test_commit_ctx_keeps_quota_for(test, 4095, -EINVAL);
+}
+
 static void damon_test_valid_probe_params(struct kunit *test)
 {
 	struct damon_ctx *ctx;
@@ -1946,6 +2051,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damon_test_nr_accesses_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_new_scheme_keeps_src_quota),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
@@ -1957,6 +2063,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_filter),
 	KUNIT_CASE(damon_test_commit_probes),
 	KUNIT_CASE(damon_test_commit_ctx),
+	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.53.0


