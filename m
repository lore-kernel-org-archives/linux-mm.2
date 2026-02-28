Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C30FD0045
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 22:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1C86B008C; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71A36B0092; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87396B0093; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 969406B008C
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44EAB8B372
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:28:43 +0000 (UTC)
X-FDA: 84495306126.21.7CF181A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 93BCFC0002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:28:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CnkMZ/I+";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772317721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbA5IqWFtTBKgQnS5gR7cy2GgzeqhkdRKdEOzmxXJIE=;
	b=4p7iftfT8JpEJFg4/2zfJGO1BvrJOQBpIEFHrE//CRID2tArUXOZooSWlNAlZQo9lgloAk
	41/1wE+7/VaLN8rYmaMI/p3MLOEyfVKKiZYPqa2Si0ahrefds6KpUybWBObGjXyrosuU/8
	dsSg4ldMVtjf4iL4oWArTsAKVEsr8Po=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772317721; a=rsa-sha256;
	cv=none;
	b=Pyv5FkNOD+dlVCwh+0B52DH+2GvVSUlHg+ERftuSCztXZbpbgGw4ONz+PlxsAJc56q8OMQ
	FsNG3AH5Km9I435uGXaF0m2zODALFx7b1JKHvVj5aK7f89Wodh+ZppnQdsUf8deoIeFr+9
	QRm0X+WgUmq/ABYo+uPTWMjuwgmOmsM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CnkMZ/I+";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B19F8441FD;
	Sat, 28 Feb 2026 22:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EBBC2BCB0;
	Sat, 28 Feb 2026 22:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772317720;
	bh=4L+Cdqj56W1rAMk9bb2m53VgY9gTD5qLF9/nWjkq5hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnkMZ/I+DQzkpIvEWkyYi/X/+ixNqN/8hcPutPaMfkOy/PTp3SFn1EJ8rt7upP49F
	 b2I4p2KHDDt6wsn3r8sPiM1jDVNBF9vB5p6Kfrr3I7vA6K8QooTKrD78B37nv4B39t
	 IIUHc9uFEj9b29HpnLwMVi7oKz/1y8DjIwKMnUhLm4pD+z/si9b79a3+Gm/qFZ7tnW
	 Hk+fOGnlVZ//Aq16rv+zRc9WJ5PWd1IF8063K5ToM+FquEeeHVoWUX7bIIoM4oBIdO
	 DPtSY1xYhnxekFy+G6OcQJmi3rGLxrfZeYJsUd7fkHgaVDiWiLfy7cTvNZPZjF0Dfy
	 nPwC6/fjhv2Ww==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test
Date: Sat, 28 Feb 2026 14:28:27 -0800
Message-ID: <20260228222831.7232-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260228222831.7232-1-sj@kernel.org>
References: <20260228222831.7232-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 93BCFC0002
X-Stat-Signature: kda6cqwyc1c8ea6qs4dmd1h8a8dis6ew
X-Rspam-User: 
X-HE-Tag: 1772317721-377620
X-HE-Meta: U2FsdGVkX1+jqjD0rDJIouhRBCWHj9lKE2WOZtIRbo+tNypwkgRrOf9S+4nfN0pBGbM433FE/K+MZNugZkorpTjL85+AFINmuWog9ws7oByLDylMuEWr64kh2LOYy/fH0CwMI4usRQwHeFKZXE5+9YTwnBTTeAqOfjnrB8bDHwBo6DDYPTubcn3MuKAi/5JB+nxNNl1lMTNjMRkXjLJ80txhez8s7Ee/aw9uNQjRgQ062XNni5CMs9v+ob3O0YJ/KRxrY0aLQ1CoL+GkJ7SbFpVwBkSymD6n+q0QGIv0vfb7dPBM4fsFd4va1U3ofxAp4LLvj5adImFv59RoyAUCP/+3a7Pr4Zk53rVNm/g1m5UIsdlm8fZFgTwbzq3DciaTRH5Ew4MWm1L1jDghu2jpvOa/4riw5c4AD5wcrCqWAhvajmYy4LIwmJNIp2THL6vaHkGG+1TaHowokkM3HO2n2wMNj7elkT5C1Nd+VttW/FgKowBfGXsDDkyERX0cuS7ERqz7IyJnv/dH2gTGWUhzadiYaCV4Rx74uSb+DwPcoCwHpL0B9+Gk/+wZuGJ4vhXzWkxDtSUekbmaFfTGZFQk0ul4uMTDUp3ALxIdfN+b2FqW6zcUhRyYAmJF7qCKbgEOLsTKGEcAY/XlVk1mbQps1D6A6rQmMv4trtCWCNt//syjBXMv0X5rw3rEolwFyvkI1+7W1g8fJD/UqTwaFGkDJjkP4X3Sk2c51K8nSLeyaV7/7DWM5w3PhQeJOocgivIaXdntH9JSqUNaxepbOKl2wprhFnIxTfZ+vxefqFbasv6oX0/XNBsHbTY18dCSGpcQ367MPRrJlNWGyuNSZlWJ+iTeneSrM9jURaH9lOA00rVtRx/Y02r0WuYM/vJJ9IG2sYzPhNigFqYps1A8R8potgueaXa4IGr2sSEvtMseGTeeh5u3XJtT8yYt2diEHqOq/IcP1684cl3zEZWTWrV
 ITI5YrrQ
 BHPlT9t25LHzz6AhyNpKOyGG2uF6A46MS91JVH16WmmfyW0BOcfAVrpQZOpTEVHq9/C43blq6eWD2uTUJF74qQYAAzpFpTaQtF4UXAxffcn2tWX5/ZjCthGRVu9y3XjdnDKjYt3EbU06VElSUcM0EONMS4jftU5Gtu1nQ1tyKpS69Wuim5/yz+ivjl8+0W8eR4fYwQ01HoSdSq0TNVFfbGWG5zbSCL2cGvKNcH1t7Zv19nW87JgHfYCG1Kw2ZfYq0rbkD6uPHFgUJgx3wd1GXn/8hsgVWFoY8ayzaaiqE98NidVvjDs/2hB2CMyr2MIGXTVx90yhOHxVYTRnIt++odVuBdeHNKETrybe1RRgcrVlYuG0gBEzPsZRM2v8EhQwz0Dmo92tTa+YKDME=
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
index 596f33ec2d810..fcc1336b234c0 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1239,6 +1239,57 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
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
@@ -1265,6 +1316,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
+	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	{},
 };
 
-- 
2.47.3

