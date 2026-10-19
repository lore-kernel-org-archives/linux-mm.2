Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A35CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73C76B0260; Mon, 19 Oct 2026 09:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD966B0266; Mon, 19 Oct 2026 09:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECE86B0269; Mon, 19 Oct 2026 09:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5A786B0260
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:39:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 434B8A070D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:39:15 +0000 (UTC)
X-FDA: 85339482270.23.2E44838
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A7CAE40002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:39:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQl2eY5q;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792417153;
	b=jVbdOfYSz3W9GuSijSFq3jCiUo1EylqKyaKubxeHALA1g+PnpfHYUUrXGoGqIoQmAY5lJp
	8wVOHRRHtJQfANV7Ix6BMqpjhKS1fn54NjteZ9NVNywNgYbLHVX22odbh7gVZ3Wv227AzR
	Ycbi3aa7eUCm2lsKcyyRxWtgdrguPrE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQl2eY5q;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792417153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jFDkykTpCFq9YT8TT2xwNVz5rz5D5UYP/IyAQl0FhJU=;
	b=NtLUpX8dgp2BRwOmLzZo5MsdBpjhYOuoqJYuposYUT1HiqqbNRRv9OyxOYVX2UcvpKxkca
	eS4e/8fNx5e/PJ/ZuVCs6tTwd7dtQ5d4BO2Zw6TOzECwlyY7Ua6W1gmjCiALtKsNltTJoC
	rhrDX3qK/29PI2xD9zjWmWiijr/ZlU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E23CC407DA;
	Mon, 19 Oct 2026 13:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943531F000C4;
	Mon, 19 Oct 2026 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792417152;
	bh=jFDkykTpCFq9YT8TT2xwNVz5rz5D5UYP/IyAQl0FhJU=;
	h=From:To:Cc:Subject:Date;
	b=WQl2eY5qduO/ycVgT9nFECZAtwHY8BcuxkWXEtGaMyZcoWRr10cgdIql5DB6VQJ6v
	 pf/pzsioytZw2BC2C7loqHvXe20yFpfuGsIPAR2FeoFY+OZUhY/LR5HbRVbdbEhgyx
	 fiesFcMNxTnouwP+oaTnTBYvdbcUEwiL6Jw9Ecm4XI0pHukfzFD26HNQyyYDFeb4SY
	 TbcA7KpnDDkrgKaOU9QDiXAKlhUt3AQt6ZSTFUou72vo5ASNrkArSXOnCFbpyVyeAB
	 5CRq8pVppS7nSk3Yzg9HDrStqoYiAvxGsoK8d7sIzSpri3gTMVZU6zQygsZ66eFVFH
	 Rc5bJ2UfIXKdw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2] mm/damon/core: filter out damos address filter-split failed region
Date: Mon, 19 Oct 2026 06:38:55 -0700
Message-ID: <20261019133856.86835-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A7CAE40002
X-Stat-Signature: s5snkqqg3dp7x6txbt4z716cwfbiohyk
X-HE-Tag: 1792417153-330821
X-HE-Meta: U2FsdGVkX1+7CCwRWJ47tpWBDdKasl3/WOzcTsATrNDbCPPGn+150b2QWhqc7l1+lezwt8KLYCwMWBrOtkapNs/kpVqu+cU4mtCawFmXbt9VDnHwl0Id2VRWnCxn7m5dbkMyExoy2VZV9KUmsAH6AtnuFifKA9z+yktQeObLFdwOXksfNMQ//i0iqcRrjIjjsiyt7UUpzZAsn15IaGkml4gfeXLoIOD7xdQCzaXtmHd6821LYYeEAUD8sRBDpju4CHY4nPl06R/m5I75PCsUQl3evBss/PBfNLDKzAQV65JIHPKEIiHVARRssFt5m0XKudjDeoorpnD6nRg8OaHq/NG44sORRhcjLLKuCFVzL94bKSUt3os53DqKgwm7Gx8CVXMf+vGzvOZhd3AeQ4nJK+HHGgJgCJO3MUZZxsJUggKLUet6vt6lgl0SFhED8xpJWM+Wdejwq2URknK8jRkbiNgbEsy2VyBIYEBqyxbQalzjnXVIRdq3oinDqyG1gNxOXkDRQpNf1UiICB4teBhemNj++qCHkqSzWeiI78DRG6D9KRWZRRiB0PUCIiIgsVxMaDrwtOjaWCfgRux67mCLy2Qfjcr8EnNxzD/KVXOYIyZoZLCtweuKW/KXm0VHChY3rPeWLS3aLPmNo46/oSR61YbdVoxPHPirWg15bis5YSoSfT+ja709JeFmxYy9MAh/r045p1Ua06U+9J4n3hzCiRNeDQrXMFtWOrLkCF/hrLlx1xutWPJngmdrWHNo8kGUu5sG7o8jWlwxymCisUUQZfeG4fn9ZNnsyDsqIt3D6EjRnpCoJ50gWl3/2atk2b+4Ar4yv3i92C/aUp5PaJddtuzL/AKUlG7z4Ta+jVJoklAYyD5fQbqXKXVPrWAgGo3CzUAapImboAOjAnR4OJtXxQdGYvnX6i6xZsBiTxLxugYvMOXPn0sf8M6msZuL5bd/bZW1hi3Kj/MHr8w2S64
 AimYCdw8
 WSHR4iBl7lP+Y9v/CPPW+39LC/9Gwe1IKFYaKOiuo8Qb0y7et3sZrlGw+TnigxdLLcPXfL9Nro12TAPe1SX65chA1vs3sKpCYQj+hBFuMeX+REV3PsITPETXzKXoXHQm2ejiCl6u3FkeNnuVGcBiPPXzveYjGTcaw0P9TJXlOHUyozCPx9S45fYnro0rZO/99kqRyyiWdeIDcA7K94/GsdlpeHItmiMWL18N6kxZYZZA9DPLS5gNSnvloLd07l1YnmObIscLLQ9NhNLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an address type DAMOS filter is configured, DAMOS tries to split
the region for the filter range, and apply DAMOS action to the filter-in
region.  The split operation (damon_split_region_at()) could fail from
allocation failure under extreme memory pressure.  In the case, DAMOS
action could be applied more or less than expected, ignoring the address
filter.

The issue only rarely happens under extreme memory pressure.  No crash
or leak happens.  Occasionally not applying the action to a few regions
shouldn't be a real problem.  But applying the action to a region that
the user has excluded via address filter could be a surprise depending
on the use case.  It is only theoretical.  No such real case is found
yet.

Filter out the entire region if the split is failed.  Update
damos_filter_match() signature to receive the error from split.  Also
update kunit tests for the updated signature.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260801203121.117449-1-sj@kernel.org

Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20261018220253.158238-1-sj@kernel.org
- Handle failure in another split operation in damos_filter_match().

 mm/damon/core.c             | 16 ++++++++++++----
 mm/damon/tests/core-kunit.h | 11 ++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b63e60ef89901..479169dc9ac75 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2551,13 +2551,14 @@ static void damos_update_stat(struct damos *s,
 
 static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter,
-		unsigned long min_region_sz)
+		unsigned long min_region_sz, int *err)
 {
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
 	unsigned long start, end, wsum;
 
+	*err = 0;
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
 		damon_for_each_target(ti, ctx) {
@@ -2583,12 +2584,13 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		}
 		/* start before the range and overlap */
 		if (r->ar.start < start) {
-			damon_split_region_at(t, r, start - r->ar.start);
+			*err = damon_split_region_at(t, r,
+					start - r->ar.start);
 			matched = false;
 			break;
 		}
 		/* start inside the range */
-		damon_split_region_at(t, r, end - r->ar.start);
+		*err = damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
@@ -2607,10 +2609,16 @@ static bool damos_core_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
+	bool matching;
+	int err;
 
 	s->core_filters_allowed = false;
 	damos_for_each_core_filter(filter, s) {
-		if (damos_filter_match(ctx, t, r, filter, ctx->min_region_sz)) {
+		matching = damos_filter_match(ctx, t, r, filter,
+				ctx->min_region_sz, &err);
+		if (err)
+			return true;
+		if (matching) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
 			return !filter->allow;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 3fbb4e4e36fac..43e2f950f8ff4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1783,6 +1783,7 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	if (!f)
@@ -1803,27 +1804,27 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = 1;
 	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = 6;
 	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = 1;
 	r->ar.end = 4;
-	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
@@ -1839,7 +1840,7 @@ static void damos_test_filter_out(struct kunit *test)
 	r->ar.start = 2;
 	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);

base-commit: 7e7e74286672b8e164e60aec0e94f05f62eb357e
-- 
2.47.3

