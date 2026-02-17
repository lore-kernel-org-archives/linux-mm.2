Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E93E83844
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E696B0089; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC296B008C; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BAF6B0093; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19AD66B008C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC359160FAD
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:04:18 +0000 (UTC)
X-FDA: 84452001396.11.F051512
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 49DF710000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:04:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=csbwqWtg;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771286657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Am6TeYowM0pmbKXfm+LsyOSt8lxz98RGQ0YAOKcwFAY=;
	b=VntyhnPlFkyzyvIglWt5WJRYMU1M+ThKl3AuaWtHMuiGGGfdlVoBJRVxBvsznhv4PtMChH
	v00IqrOXKBKchjyMIrwBB1dGT/ytC9/bP084iwcXm27FAFDbYmyukg0ClnatwMV5gqw6k+
	Mc95D4e1m/snlhewmvZjF6LWWKtYgNU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=csbwqWtg;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771286657; a=rsa-sha256;
	cv=none;
	b=ZSicwmZpdR/aW1yIEd1Z5tuplvC8yHzw5zqGmzEropscQC4Grl2Ze+rDnLieV/f+5uWNfE
	KU3Sx6F3sO8xgU6XjTwlEETW+v/5ECaDiSgYtXoL5TI0PXbm3vnu2pNqrOx0LVGAUVMYFi
	boxK+2xltDh9qGkocruHy/Cg8RmekhY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78F356013F;
	Tue, 17 Feb 2026 00:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ED1C2BCAF;
	Tue, 17 Feb 2026 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771286656;
	bh=bCw9hVCbQXONIXZgAbBvfEk2u6XzT2XAiGuqMrqAhNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csbwqWtgktX3/5Ys0Xd+IVS3AX2fp0Rfu/Zwwz2X3M+PCCWuq/0yd5BEHiFSH+S8i
	 WcLOdNS1zwLkWFVmFM/wV66KcW/y7aRLsImRz9uHOa53xGlBpQaYibPfW93Dv0YSjw
	 u+P7jg5SPhpRfM1XU4MYiGIafXF7YuTJq9zX6IYK8aR3BGJ94z27p7PQSi/9/Y3GjY
	 ywGwSbECaFRr5BagHAZLskBHLsAm4D3BnJHgTlYlNLPnFnP6Clfcin+1q0+QQfU1Fe
	 OR4MwUPHlyE7fsuR1+OY7LSPkAumgkGjgdArUiFpmdsjkV1HHEc7d1ntGhRnCRCftZ
	 X3Fp5MjVIJuIw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/3] mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test
Date: Mon, 16 Feb 2026 16:03:58 -0800
Message-ID: <20260217000400.69056-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260217000400.69056-1-sj@kernel.org>
References: <20260217000400.69056-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49DF710000C
X-Stat-Signature: b3jne4rcupium9y6nng3d3jq6n9e95eq
X-Rspam-User: 
X-HE-Tag: 1771286657-309073
X-HE-Meta: U2FsdGVkX18HX0p7AhuPDWxXzRxEVOecUJpCASmdf71pDmVZht20OjANrXEFxhRAkTZAGhjxdYAoSc60jHcet8KBIRgv6zAlOVcDps9XZJnJ7/ILaxuVKk8S5/Q5PxIvDidqIvy9dbkNHcaG7OwkPTYGjRKhy4IyNeqSpZTwb0Ebxk83CKdDJrm99Mnt2o0l9Xe7mTxx/FskVkHgJ0w+Sa/hdECKl2xu6iFXwSSCGd5RurMdX0cMsMJb5DCh8SlIw2alWIfHe/RADSQOBJooJmbOjIwrSRtcTqd5HN78dmvzQMgb07VBqfTHxdTR4cqoJ7rFAV1Dvk7ntupMy56TgDgS8bx5JHpnrPqKCJnJrhoxBxdp7L0SGlbx80ZlLRHnbpLGiUDpX29yUWDenN65cjsiNT49pmYaUPpg1HIwf/IMBn85HbQvp17jox3ijmMr5NeSNF2BwZHM0OzHhtkTtUBGLjrkwqjI3sLahBK9pDo7s8x9Mj+iaj8t+hode0xT2UPZCknl03h2n3qhMoKs0hxPJLR+oZ1f8CEPzPTbeagURMyNJ4G36YQnijdtv0ne5qadiOoXmJGZ/bU3PWvO++2TJO4W6+DkqET4jnn95ypfAUDg5p3b7TBp6iJ+cXtVUvtRr10q0CT3AqaUQizOmQ3mErJ5WwM84g070Ef2vpm6iQfdxA9W7pX0RQOKll9Nt972zmT7brDxrQmqg+fr4r6mZgy+8EiiX4vxn77MzE+JB2PDTKJ/f/7GN0WOB5FVJwARaXRe3yyJe90/hRBteCdGeTaWD9141Way/MKg7fC6XvubvOOETSk3WvJQtWSHBUYKgdoKcD9lZ/9EVbqvwhu8VhYWVp7S1/7bRxZfht1gQgItYlMi6KR2QYcQKxsJ+H3VlQFNml4YAlEkSkdWoo/XW0TisthTl7JZSepMQAZ1QyxoENX3xXpXg07wjsFsSxMCLgPmUNvXNgCT55j
 nPtTCLw0
 Q7rsI3nhcV1kckWjbj5zKY1A5RGtCGhsZPFQnkfeLdizVeaAky0Gm4AwIFKfSZYq/hYkKqCv5cakDAKmQTf0kAm07zLe/LagS2ju42VPd2Jtlk9DKSd8eMrvtUZ8V18JxFdpCvGLLigWgMPpwo7iXQ2IYdTlMj+fE/YF8M5UwMagWm7V2oCeLKCeJBArtlWql472KFXRQ/MfUKXmlALsz0mXRjKS0LfMtjELv6Vx3xQRIEdx5fdR1/Thjt59FrA4PbIoWYdqFJkrBotF2JuPohuMAlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kunit test for the functionality of damon_apply_min_nr_regions().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 52 +++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 92ea25e2dc9e3..4c19ccac5a2ee 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1241,6 +1241,57 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	damos_free_filter(target_filter);
 }
 
+static void damon_test_apply_min_nr_regions_for(struct kunit *test,
+		unsigned long sz_regions, unsigned long min_region_sz,
+		unsigned long min_nr_regions,
+		unsigned long max_region_sz_expect,
+		unsigned long nr_regions_expect)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long max_region_size;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail\n");
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail\n");
+	}
+	damon_add_target(ctx, t);
+	r = damon_new_region(0, sz_regions);
+	if (!r) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc fail\n");
+	}
+	damon_add_region(r, t);
+
+	ctx->min_region_sz = min_region_sz;
+	ctx->attrs.min_nr_regions = min_nr_regions;
+	max_region_size = damon_apply_min_nr_regions(ctx);
+
+	KUNIT_EXPECT_EQ(test, max_region_size, max_region_sz_expect);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_regions_expect);
+
+	damon_destroy_ctx(ctx);
+}
+
+static void damon_test_apply_min_nr_regions(struct kunit *test)
+{
+	/* common, expected setup */
+	damon_test_apply_min_nr_regions_for(test, 10, 1, 10, 1, 10);
+	/* no zero size limit */
+	damon_test_apply_min_nr_regions_for(test, 10, 1, 15, 1, 10);
+	/* max size should be aligned by min_region_sz */
+	damon_test_apply_min_nr_regions_for(test, 10, 2, 2, 6, 2);
+	/*
+	 * when min_nr_regions and min_region_sz conflicts, min_region_sz wins.
+	 */
+	damon_test_apply_min_nr_regions_for(test, 10, 2, 10, 2, 5);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1267,6 +1318,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
+	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	{},
 };
 
-- 
2.47.3

