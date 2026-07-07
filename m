Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A29C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D6D6B00B1; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0286E6B00B2; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96496B00B3; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A26326B00B0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 161E2C20A9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:54 +0000 (UTC)
X-FDA: 84962116428.05.B13A2DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 75E322000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y9Tf7/yB";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/D30WRyajzihkx6UMd0lfcRCqBtxjpc8QkxY/qucOA=;
	b=UF+k5ZfZMiAAoYsYwruQURJp1nSqQ7gyS01/W87K+E7740apdSo4amF9c44dfc0IQcJRiE
	vMVCF/hKnFG6Keo5jLDsa9qnrdMeZll8mZ3lEtLrUY/YT4jJ+RemFUibK/vYqxFTYNAaPh
	VoRgcdOX5HQbXrHB6AecbfOwh5ylZq8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y9Tf7/yB";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432252;
	b=jkxBAU5POZlKZm+FNHg7FGhrHd96M0Znrg68hZWx6qSZaJniB1b8rAbrJZLE4hMDE5Lh3w
	8GBqxTU0YjlhTnQZeDP+DInUE2f34e9ru1+7MI0BdGjNuGBUf6WvnEGBhcLz9xv/coZ2Kz
	Wj7w4uZ/Gxgg20d2aJb6aiGNvJrv3zw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFEAA42AFC;
	Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890081F00A3E;
	Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432251;
	bh=w/D30WRyajzihkx6UMd0lfcRCqBtxjpc8QkxY/qucOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9Tf7/yBeO28xHQCxCotHHbEpoiXFv7yBcd4ooCGXX4LEA6y/RTSBxiWNxyTyUoZB
	 tNAyodklm1kEWSBB9wjAO4VJye7LTvcK267MiQyJckY0dGfJfbo6fDEgWJOOLprZub
	 MGpYZZIQXOteLFWVwUyVcoqafjhbWeFsE2PpXqdYIwN74r3hVOkN7Cxhfu4idhS9ax
	 Re4aDDBlAMR3jgttRSjwQVjJ3V6f7mavwA/XFVIH4T/gSXbVDOZlgmZOa3QcVmlJvI
	 Zv5+GKrzYV6y+SFxLxm7oxwVTSdm0plJKeXNjoen3Ft3SwzRtUK7/gQ+8Pk+DbFT++
	 WfYCqcBSfgd/A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 4/7] mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
Date: Tue,  7 Jul 2026 06:50:33 -0700
Message-ID: <20260707135038.90068-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707135038.90068-1-sj@kernel.org>
References: <20260707135038.90068-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9zyzxidjhq5tihz8x3s4ubytidxjwmru
X-Rspamd-Queue-Id: 75E322000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783432252-709306
X-HE-Meta: U2FsdGVkX1+PHQmrAkc/bY1/BVnCgKbcfDFxf3N5kArMxo5R4j85syNss9ljPgxE1oXHiHcGea1HlqqqjwYpRjN7EhkwEFYme0h0w/eCIDzWf8Ug8Bc0J8PL0eNzv3MW2NdZsJqUisRKe+aI/nEjbCYOOEy8ONl+2hdAyFIgWB9xTNP4sSmdYacbE/a8+IxxK0dFFhI2eM964WVQxhkm08vLDnOA7/VCUWYAcDiSm6jvtI40d6VXAkXT09kP6LXSCvaCFgaZb7lqh7NqaNla8KQOeqlV+woSThNOGchkmPMKO1YSjhUebpqghWkwSK5N306rmLitiiPU+uHKTQEU+IENq0y8twPDLJrFBjWI2Vqr/lZ8eFwjZ4/cEWkaZtMy6mLwUlgTavDYb/UQVDwAgsN8IrrKbP9DTEMrrzExsH42sggoBS4kmtM7dGX3uoKKlcZ9Z3qMqLBS+3Z68qO6kg5XFMS/nkX/FkVTsl+2PNsLHuxY8QYXz0QpHTiHkFPUeiROKzCUMhrOaeCkvJuqCdfvegyNumRjVInKT+wY5eTG0EataSAkopeFW4/CshZGbSt9qsOls6GCS5vqZgw7qVJdO1eemk2yxYetINx8jxtF5l8dnPQ715qauaoAnz7CKKBt6xfcZCIVo/Tc5y6Ho6ZFu7qhKCYVgtVsYcSRW4YWAbwKJb5o1+7YscgbGSRb6KZ6TsDDBgrt2wW9q8Q0zyRFBoJc2wzZlIcedD4mnKbcT2L+RkJ28j7mLp5+3oIhyHeJVfcsEfk/AqU/u70TITtuIn1431Qm7aUKPWey6hLTJ/1nePDjnxZTP8zHkeOtZPntHI5/hmPnlbv9aVhKKozw+NQbex9RotjJGirRuk+bG/JoEzywBaJj8t9HE7CJmTrh2JYdsA2W09VnaLPQqlp/mCv0KCaGB19bIXfamo+TE1Gg8Mn2GmMSUg/QRxU8a06EAQiw0fCindadX5o
 wsPuY6Eh
 XbUSOuJidIMpU2vlk4Dq6EIyOI8sadm0F/+4smAommtK0gMYxSIiu3R7kYV/9PRsKbD9PUyIsU27qOrWn6paivCwFw2Iz/9ZvCDW4GaJuZ/+cPTp7/mLl2w4YyEWnp6nbLhY+ecLV+Q+sTRH//Px1gjunXilA5JW/E6lVDRftLHIM0EFNPKW5HT3oHyxmQpHar+3ekMlQGcph9MxOTQN2MaRObXXyILjI6yqml9zgqw4/ME3DQfUHdJcdkMejpeENJ+o2kD2p+mYAkcQT4jwpjS+I0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_to_accesses_bp() actually converts a positive sample
count to the ratio.  Rename it to better describe what it really does
and not confusing for more general uses.

Also remove the obsolete comment about division-by-zero.  Commit
35d4a3cf70a8 ("mm/damon/ops-common: handle extreme intervals in
damon_hot_score()") modified damon_nr_samples_per_aggr() to always
return non-zero.  Hence no division-by-zero of the note can happen.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 11 +++++------
 mm/damon/tests/core-kunit.h |  6 +++---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dea63083917b0..718268df27fa7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,19 +883,18 @@ static unsigned int damon_sample_bp_to_count(
 	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
-/* Convert nr_accesses to access ratio in bp (per 10,000) */
-static unsigned int damon_nr_accesses_to_accesses_bp(
-		unsigned int nr_accesses, struct damon_attrs *attrs)
+/* convert sample count to ratio in bp (per 10,000) */
+static unsigned int damon_sample_count_to_bp(
+		unsigned int count, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
+	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_nr_accesses_to_accesses_bp(
-				nr_accesses, old_attrs),
+			damon_sample_count_to_bp(nr_accesses, old_attrs),
 			new_attrs);
 }
 
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 224a3ecaa0701..9e631b19b184a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -575,14 +575,14 @@ static void damon_test_set_regions(struct kunit *test)
 			}, 3);
 }
 
-static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
+static void damon_test_sample_count_to_bp(struct kunit *test)
 {
 	struct damon_attrs attrs = {
 		.sample_interval = 10,
 		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
 	};
 
-	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
+	KUNIT_EXPECT_EQ(test, damon_sample_count_to_bp(123, &attrs), 0);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
@@ -1560,7 +1560,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
-	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
+	KUNIT_CASE(damon_test_sample_count_to_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

