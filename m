Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95C5CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DAEE6B0095; Thu, 25 Jun 2026 10:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2636B0096; Thu, 25 Jun 2026 10:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1646B0098; Thu, 25 Jun 2026 10:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35EE86B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B319D1C0961
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:44 +0000 (UTC)
X-FDA: 84918656088.04.2F30CCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 22CD9160012
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmhtcTjn;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397483;
	b=FKnPJ/w0rTmZFwG0VxQXXSOQjtyXlhNVIRRklw68bcnNmirTSiQXDyRyF6Zs/OX6kK2u4s
	2n2V0fallUUJWRKLXETR1pLGWEIb6WM8EsMN8mbVf0KyYPY6i2r+fIylFKEHwgRR7Is7KP
	XH4seLU7YgVxL+hFlgOmjepq1iIc/jE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tg2jmDMliQWq/p4UiCF6FYRtQk7AyMDI0guNB97ZZdQ=;
	b=t/nJ2JeaSxa2Zb2ChDD/dQ7zDmhlCUu8biT5/ugbBgFTDPHTpBWSq5dBT3/K88KgBnChLI
	JdzVC6oPyP2CJOjWVMVpoY/LLic7F/0LAp0JqhrBObQLANMUhsljQs/73u177hVl8ZX4GP
	7I3vgTV+3Uzz9TwKDZzqqbDMRy1fLZI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmhtcTjn;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64EEA41633;
	Thu, 25 Jun 2026 14:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AE61F00A3F;
	Thu, 25 Jun 2026 14:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397482;
	bh=Tg2jmDMliQWq/p4UiCF6FYRtQk7AyMDI0guNB97ZZdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmhtcTjntOUk+GVd/GfKi40OpFXwJThGcv2dCmao/FoMUpdHYTbjgQuae+KDJgvsA
	 77ud0y9bYni6U61DzFx18SC7GA8e/ky8Oh5UxIKc3BxAIkCmrJNm7dlubHHrhngVih
	 s9IlZ3GcPv765b5zQTMU9rWRamkTWFsc5/RE+EmiVfRhJoT44W+10eqhIPw8z4AQLa
	 GKyHDB8CgjWrlLnto5JKzpONAw/WOI+v2SZ7oCa2pXEIVjStFMS644HFtrQzUVCtZk
	 DVMRxlQ9DRh79hiqK4sA4/R9D/dMBiBjgNJhiY556tKOw8JZYjIKyTQDmtc82fCdKd
	 luiK0uUG7Rgyw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 03/11] mm/damon/tests/core-kunit: test damon_rand()
Date: Thu, 25 Jun 2026 07:23:48 -0700
Message-ID: <20260625142357.103500-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cagaobj6wmyifqz5cc3rz99x5ahhhu4g
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22CD9160012
X-HE-Tag: 1782397482-838168
X-HE-Meta: U2FsdGVkX18UcbspPqgwFBhcPOqC8pbapBXoeo28yihxRfLn0aShh7sQRcmVvHBafZ3lXhWKVUTCxqomZ/EJ5wZK8pmI2zaskAdd3QUW2t2g07Ly2h7Dr0Gd+7fFdAnGyGOrAsIl5iINj6U/Bx55mXpMEQ/yV2f7FM3JIj4wtEjt7hjNAKZgxHb6P4xIM+CH+kS4JMlW12pSXjwBJxQAgsjEAhNd0+eC0PVUzNoIXGWaFZi9Szx+w2GDNCZup4iPQI4XZ2zDUc092IPbMUbQiN0/Ghcpb8B2pk959MNx309ayVJjdK02kUn/+lUjZdxh/e+hNgubOweUPHdSCi11SoRl3Bvyb0jur47FDythrMjVFF7jtQQqw0cAE0YUh/MKJroZAxUm6PglA6ICl/hMBtnf952MFNRTUQ/WNEW1Hh/yXH9D4dRJpoC/eUBv+Nh5WxfCsW1dG49PV3SN4XSQ5/FUany9XcvOnTFTBEDqwMyzZ+hb6EtS+2TK2/6aYkJsKF1NJpRRmtscmHHvt2rVT8KhBQRgtw6bPHXFzBga57fNCMqs8gem8d7p0IHK3EwD00rK18SFOUPUfjOCqS7n9Do3XTKQ31bIAmW46cGwgTx7DO8t/zJVMJXxNZOTHmoV5O65awk1wD0gFMnRJtQZj2rdWi9ddclHz1l1RD5R8BjBPmcpb1F1qU5ME3QXJkLHDBptBlhHx/VYjQzIzNjA6pUpX/7pJx3SM5/xBJFXNCqXbUZEfP0sQUM1lrKp9zL+UQg/GyXfX/GGhUvRMbMiJp8333fZl4tMhDhwxqdJroyk8GYZUGD2oloknLwxhhimXoSoYVrowUnByx0wU1ZS6Gv7zIUHmc7AIcCYhpDOPG5HwPC+GB3S2JjTc//dxhcSrlvvfI2VkY/4rxuQlNrGYidv8MvVGCRNtlX7idhI3lL2GlWCkvAZBSnNd/GcrzqQhmZoMQRIYmvsQiZSFW2
 UyHYhelv
 AJmVPSYGAncUOos8ps80fRw9ZXjkCyp+qcejD8gWdhEHH4Jy7U6MQXVs/wNaD8+QJx0fX1gyslt3VVjdgxMp4cW4u63lvC0ZIv1vBFaVqdKPuc9jonUU2oW6OK8cvny+sZbJr3yPbxk8qyhm1bpPyBcbM+kvIiNcMik4B6tXvHhc2hk+miz1gnG/v/WzWzSYt/r9gtQSVCezsfGfyGPhfvO6zZruEoZBqtyS4GG1NLMJM3Mef0aikKA/m93lSARrn7nUUyGY3fNODy/mrai6RQD9+7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9012c4e647df ("mm/damon: replace damon_rand() with a per-ctx
lockless PRNG") optimized DAMON for better performance.  Add a kunit
test for ensuring the bounds of the output.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 1cfb8c176b873..eec7cb325a431 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1460,6 +1460,22 @@ static void damon_test_is_last_region(struct kunit *test)
 	damon_free_target(t);
 }
 
+static void damon_test_rand(struct kunit *test)
+{
+	struct damon_ctx ctx;
+	int counts[10] = {};
+	int i;
+
+	prandom_seed_state(&ctx.rnd_state, get_random_u64());
+	for (i = 0; i < 10000; i++) {
+		unsigned long rnd = damon_rand(&ctx, 0, 10);
+
+		KUNIT_EXPECT_GE(test, rnd, 0);
+		KUNIT_EXPECT_LE(test, rnd, 9);
+		counts[rnd]++;
+	}
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1489,6 +1505,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	KUNIT_CASE(damon_test_is_last_region),
+	KUNIT_CASE(damon_test_rand),
 	{},
 };
 
-- 
2.47.3

