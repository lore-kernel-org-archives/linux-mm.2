Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 149C2CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980706B009D; Wed, 24 Jun 2026 10:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931616B009E; Wed, 24 Jun 2026 10:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9066B009F; Wed, 24 Jun 2026 10:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FDC96B009D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C63AD1671D3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:29 +0000 (UTC)
X-FDA: 84915016578.09.24C3A51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3561B40012
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BnR1B/g5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310828;
	b=agwMZ7IsOO4i6A3xk+RweddvJd6y4kTh5B6bBB308lu49AugJ4SL6ha7VO5YiKilsEt3XX
	bMJSPYcHTWbHVlWHzbXMgJM30UvT+tJfo4uwKpy0pRCiGnkB2K8ou2J0YEGb+jlMOwkxqO
	U5eX23q00cG4h4KYTPo6mi+yBI4gv6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r93tCIhwYTvoKawcFrjLmwPxR1Kntzh6Ey6FCsL943Q=;
	b=uDAqzwAQtLlp6QcB/H0RApWhcKrMMomfsPuVcR2QdAGeaU9bCRcdV07Iu15WkTn5DAPfnD
	Fu8qU4pjZj5kf6OookB1/miXsafFExsVCa12nH3Q4gIozZpLy0xjlS6rbWk9p3krxMWo+o
	lujsQJwoEaNn7pca6i++j1QTGpCwjLk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BnR1B/g5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9F6E60215;
	Wed, 24 Jun 2026 14:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980811F000E9;
	Wed, 24 Jun 2026 14:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310827;
	bh=r93tCIhwYTvoKawcFrjLmwPxR1Kntzh6Ey6FCsL943Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnR1B/g5Cfc26bM4njpw6UNzV5hrILh0j3rSX4S5TxEZXDgF9eDpYuYgp0xhpP+ML
	 BccNFa88UwLxfcwR+7nmpH/M9ps0xVmIdaHpmA669+MgSKd+T7045ZgZkcCph/0i5f
	 cDtkicGsbJvpSaoXJgGuI2Pami+EwLYDCJ0ZvSsFii8yuLjGImZSfyw97helfbsPap
	 URtFInac9pI6r8rh74DyKoaycBDEWrYN4ipzRFOv3KfN+PWZz84WYfMczIMQ62d23L
	 3BNtjFGjAVrLrE5akn3X9RWD8pDfMWstXva23vOCfbPS2d0QeCbAXZrdveib6Q86V8
	 iuJOmEjAzQ6TQ==
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
Subject: [RFC PATCH 03/11] mm/damon/tests/core-kunit: test damon_rand()
Date: Wed, 24 Jun 2026 07:19:59 -0700
Message-ID: <20260624142008.87180-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3561B40012
X-Rspam-User: 
X-Stat-Signature: qdhybr9jb1beczod9d4ertwfjzttugrx
X-HE-Tag: 1782310828-891924
X-HE-Meta: U2FsdGVkX18XtRYdO0FkMjCtmlIPP58vjk3TqvFwt/FEHg47PUQL9VtYrucT2dYgGZMnZj2yW7SrFrR6H6SNcPq9o33Ru1MZAD5HN4IPS5V8SNPevKbv04RVF0vSqmmM7CtOalCrVcc8dfr9vfbK7+PP/HsoL3ZhZ8lncFNysSA5wQGLxfm+NG146GUaklBaHxU1gD0/po1h4rIxAAU0tCw3uQfWAzNcLvuChHa8chA8SKGxizbxruR+ha8TnJwRCLjdvbVOA8EZmCSX9sQLC5hkgDbd92IBypksn7oW06OHCh4idL5WKRpxcjchZ5S4lOw8COa3LiVVGvzEInKQZUGepGnYUzxEj2pmF+DNtFr1QqgKhJdlgzAySNl0coLqTwZtMC/CylbtrH0XedFemphawHfkSyZgOn1y13UqLUx72ZBK2CQyT15nG2Vw0+Q5fL9IVF2wzgES9WL3lPX0tWgwS/P08p4V8l1wzaC/rluY8p3p/itLbuUvwVQ5k3FK38C9jiUputmSl2F0nMVaysA+s1T/Y7SrDbUUMTT5FsAqDyVUzMDh64zHfXXML3sQfXXmUWxIeewdA41oDs3gjmsW50L3yp107iXcxct0PMbuj4ry80mvspFDg1V1kr+IAhn8ozmIURd4U7Zw9o4RXTTApFboYOvlQ6khdBQc7ioKySPdSG+rly499zIIEVd+CaVOuULpUwNI7sqxw56umYVCZSOadpGcWksoASh0AP8QySCS7TNeubAbG1b39gcOArGeEGGAI9Ox4mqtJdHZi4E+QeVB5iYS1w6+vWIJNZCduZ6F0/wSPvKFu6dizVoaGpHkgkwmUPRfRwbYmyf79o9vGAyD7CkZDUIlzAAydCX3/U8a1PqHqMUvHVBY1wzvYpLwWPHiPNLVJpqctnrZKeNErVaP5AeX3wtOE+ooEsL4lOQb/BtRXd8zMIVqTZsLnuLIyTBgNdSdIWirEJZ
 jXT9PiFE
 acaFzKBk4Xdt2VlsJeEyAtESd90QLO9xKU+SG4sxE2xB08+brBRx5vlk141yYoLgMykfsruM6ox8YLTcks3ZWX/C5VEWQnpz+jtNlRSxhz6QBnYdfuxX2QuXFIejkFAMgW4Ir6KGlYLtGFmV83C4rrOklvhccCAP9+9sANQbwBn8lY82ejN/c3322/pEYGHoEBXutyqLKYf1XPHEoxOA4NXc3/QNnWombqBoVQd5e59LugsEMaID6igYiNMY4ykr6cbJBelPWWHRmf9Se3tRbIfiZtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9012c4e647df ("mm/damon: replace damon_rand() with a per-ctx
lockless PRNG") optimized DAMON for better performance.  Add a kunit
test for ensuring the pseudo randomness quality.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index df16cc070eeb0..a1ba807d59a13 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1488,6 +1488,26 @@ static void damon_test_walk_control_obsolete(struct kunit *test)
 	damon_destroy_ctx(ctx);
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
+	for (i = 0; i < 10; i++) {
+		KUNIT_EXPECT_GE(test, counts[i], 900);
+		KUNIT_EXPECT_LE(test, counts[i], 1100);
+	}
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1518,6 +1538,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
+	KUNIT_CASE(damon_test_rand),
 	{},
 };
 
-- 
2.47.3

