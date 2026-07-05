Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19D3C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2B46B00A6; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0966B00A9; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF536B00AA; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFB3E6B00A6
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D4C2C0A89
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:58 +0000 (UTC)
X-FDA: 84955935036.07.5F9C969
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B6E7F140006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mjv1oc/p";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285076;
	b=eUL80I1fHpjIri3YGznUuT0snt+QB6h85zTiWQ/nwCXHCzRgI2stOfcyzJic+okGAPMplG
	Cfqxlp2GIJVRoi1FBU1g8d0kF+IycryGJLPu/oeV7MmGpF0o0LjsdFB2KszEX0Zc4xe1MI
	QX/kjTCcPYbJi383Pr17NHL7JuD6HbE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mjv1oc/p";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htrax+YEkIpwzkVsZ772n3CN6MFRqmzSggoIknmGl8o=;
	b=cYXMXGNZHCDHAYSBIjF+ZAgawyvxT68LpJzVrysosqBe74MZCqwcyr3+1CPWAyLTuluzjr
	rOIq8L/E5W+SMWnd65DHryYWXGsoXdLC56UZEk/bAaqlCe+UCXcxSFrjBF5HRh3G2OXdem
	L9l6h9I4vbjYrUFpgOh3xcZ5goVK0WI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0523843C57;
	Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71E41F00A3A;
	Sun,  5 Jul 2026 20:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285075;
	bh=htrax+YEkIpwzkVsZ772n3CN6MFRqmzSggoIknmGl8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mjv1oc/pY7TfEO0YiU0zPERP+Mcq0Z/w0USJfgQy9jPMz3AO59Dah6TbwUa8zgVvw
	 6hLFaaQyIoGwXxj/Tbk4HImIUBsetghMUNnk+Ppx/eRHGH6/PNo12oheUcQFfdGMz9
	 3mXDYvpZ+0k7I631PZgtOiX9615szMMmS6aYONAQXMZfyFqpBfpdWJbjyO2EPXwLzO
	 xmPb3Wb2Fz0Sj7ZpQV7e6Rep1nOOXZbayToaf+i9gHHKvHirRH9BCMqEfrG9yEeNUh
	 lJ2HTW+bSwmeV9drH0h0FKlExQL0mP2gWtZcRNGtU5wcBxlaZUd7S3ig2pHe+uuElb
	 ACqRxrkzOxroA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/16] mm/damon/core: extend merge function to work with probe hits
Date: Sun,  5 Jul 2026 13:57:29 -0700
Message-ID: <20260705205743.98656-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6E7F140006
X-Stat-Signature: jmjequqqmkb1nh439zipi7odufcdzitg
X-HE-Tag: 1783285076-143527
X-HE-Meta: U2FsdGVkX181VMkVVhmqYFvf/xggq9HKp+hHxTjw1B2DeomO5kqp2yEADs96+STODKJ78AQDPEI9c+6lbCYecGbTXq8DEzV1vvH5AVc2LfzVe6/12C79jDwAPW78enbAQt4N2hewFJC9IyJGvaudoJ6RTVFzUA79Vj/XAXSJLfiViY2LusfcCsGs+v89r2VRNYCv+a8U60clxzzlF3IjIt8/uCkYWH37vubVPv81L3EmF6iII60YBJ1bkgNolhozaxeKpO4WAMdagloE8Mlg7UCO9wJAV7HGV8RcmBbKGeCza2GNtI+iAr5sz1lnh0QSnvZHD2IAUFikWWtF1NjCA1IAgrDDg9tC4bS1hFpRfpUHBULeDJgWsaKQeVO3hbRgSOpuy2pniBMLRHYmQtgSguUTvH93BBfHYrw5IuiwnIuER3d25IwHtaxexMKVxe+7okUBG4HyLA+YGqTHnLGe/zI7537BZgMhLPKmTTFQR+Wjtm0/hqiwQ+JSELkgqyETHv4QJewKn4OfO5rB69k9ive4GXTdHpgCZy4hiYDVRaHBef75zFbw4R7oqA/6zxZD8hMofNN3Q5lGmaGxR80OYqPHvPGHK8PyYHEbSyYEIbV5sPcKtplfbsubOZHqTVGV1NMIHLqeEcO5EetCtXM60ulHFxdXKDn7Fekjm+IELmkzoBARdThpuXISQlPqxyZk/pOZgelsbSNrzMecWb8YLhN9NM9efYlA1JKUIsPm2gHaq4/8W7QmABZgsdDujuAvA9xnD3jC/Yp2hufAgzywUVmHOs1MrYR/UtWJeS/Jf8ueq352LIhUsOPp0KG2zvYu40KyvWOgx5cln9udqfHoNXFAZ64F3LPOARIWPIf4SK9aKXnXV7B1kdTMMGFIqhX/yvfwLUeRHiuER6evVnfkc0p6XzCfZS0jgDR2oVy29Mme7OiK5d9VWVeQQTNVI97q+DX0hEqZKxFH7/L1dSa
 9buGwTM6
 h2WPITn4xNotdarJL5CtKenf4Ny+PV86TnFgitJOn/3xgFOFpeqsD7LNmWP1sHjrA/lOrWTwuZ+dZueWFrmFUOjugQAY5ocbOr/ASUWRW52VfUht9SkC3z+SXwc+VSnpCkeiadpnu9Sub4wAcz0zf5P3SyD2UQ3JwGDZ5uLYvxFj3oBSiLRl0TrtpIPE63uX1prc3TX6Pzp3IdTBMubKuA/gCNJ8oBrVxzVSi1/4le8sXWFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, users may want DAMON monitoring results to
be optimized for the weights.  For that, regions adjustment should work
for the weighted sum of probe hits.  Extend damon_merge_regions_of() to
detect if the weights are set, and work with probe hits in the case.

The weights setup detection function is incomplete.  It always returns
false.  It is intentional, so that more changes to completely support
weights can be made in an incremental but safe way.  Until the function
is completed, all changes depend on it is no-op, so DAMON works in the
current mode.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 48 +++++++++++++++++++++++++++++--------
 mm/damon/tests/core-kunit.h | 13 ++++++++--
 2 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d7d1e27d767eb..9bb884ab135ec 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -209,6 +209,11 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 	return NULL;
 }
 
+static bool damon_has_probe_weights(struct damon_ctx *c)
+{
+	return false;
+}
+
 /*
  * damon_mvsum() - Returns pseudo moving sum value for a time window.
  * @current_nr:		The value of the current aggregation window.
@@ -3231,6 +3236,16 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
+static unsigned int damon_merge_score(struct damon_region *r, bool last,
+		struct damon_ctx *ctx, bool use_probe_hits)
+{
+	if (use_probe_hits)
+		return damon_probe_hits_wsum(r, last, ctx);
+	if (last)
+		return r->last_nr_accesses;
+	return r->nr_accesses;
+}
+
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -3239,24 +3254,37 @@ static void damon_merge_two_regions(struct damon_target *t,
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-				   unsigned long sz_limit)
+		unsigned long sz_limit, struct damon_ctx *ctx)
 {
 	struct damon_region *r, *prev = NULL, *next;
+	bool use_probe_hits = damon_has_probe_weights(ctx);
 
 	damon_for_each_region_safe(r, next, t) {
-		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
+		unsigned int score, last_score;
+
+		score = damon_merge_score(r, false, ctx, use_probe_hits);
+		last_score = damon_merge_score(r, true, ctx, use_probe_hits);
+
+		if (abs(score - last_score) > thres)
 			r->age = 0;
-		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
+		else if ((score == 0) != (last_score == 0))
 			r->age = 0;
 		else
 			r->age++;
 
-		if (prev && prev->ar.end == r->ar.start &&
-		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
-		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
-			damon_merge_two_regions(t, prev, r);
-		else
-			prev = r;
+		if (!prev)
+			goto set_prev_continue;
+		if (prev->ar.end != r->ar.start)
+			goto set_prev_continue;
+		if (abs(damon_merge_score(prev, false, ctx, use_probe_hits) -
+					score) > thres)
+			goto set_prev_continue;
+		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
+			goto set_prev_continue;
+		damon_merge_two_regions(t, prev, r);
+		continue;
+set_prev_continue:
+		prev = r;
 	}
 }
 
@@ -3289,7 +3317,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit);
+			damon_merge_regions_of(t, threshold, sz_limit, c);
 			nr_regions += damon_nr_regions(t);
 		}
 		threshold = max(1, threshold * 2);
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b83..fe948000b72cf 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -226,6 +226,7 @@ static struct damon_region *__nth_region_of(struct damon_target *t, int idx)
 
 static void damon_test_merge_regions_of(struct kunit *test)
 {
+	struct damon_ctx *ctx;
 	struct damon_target *t;
 	struct damon_region *r;
 	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 230};
@@ -236,20 +237,27 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 10170};
 	int i;
 
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(ctx);
 		kunit_skip(test, "target alloc fail");
+	}
 	for (i = 0; i < ARRAY_SIZE(sa); i++) {
 		r = damon_new_region(sa[i], ea[i]);
 		if (!r) {
 			damon_free_target(t);
+			damon_destroy_ctx(ctx);
 			kunit_skip(test, "region alloc fail");
 		}
 		r->nr_accesses = nrs[i];
 		damon_add_region(r, t);
 	}
 
-	damon_merge_regions_of(t, 9, 9999);
+	damon_merge_regions_of(t, 9, 9999, ctx);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
 	for (i = 0; i < 6; i++) {
@@ -258,6 +266,7 @@ static void damon_test_merge_regions_of(struct kunit *test)
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
 	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static void damon_test_split_regions_of(struct kunit *test)
-- 
2.47.3

