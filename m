Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFD9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BDD6B0099; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD386B009E; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128936B0099; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2E966B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17A89401D1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:09 +0000 (UTC)
X-FDA: 84969412458.01.281912F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5151C140007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQMEp2mF;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ywtTSlgg2gQ8bR9Osnueml1K534EMkMwLNfCemx+LA=;
	b=O1xFNyCJv3uYe6XlFpLiyz2ZvY9dYvSxPg3xIfzedRl7Ni9Iur5bIFS0Hkn83NOZfTwrkM
	dC92WMWu89ilYwEftzhy6HL58839RLdijOpzhtiXaFRF682h4olxg569/cxw7H1rOUCtdN
	tvtH+VNs300IuJPchVtkzjoiM8tzNtA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQMEp2mF;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605967;
	b=1EYUChDIOTKJgZQx5Se8x26g2hj6f7d4cC7JlAamy5a3zs0+5aJ5V8VvXTbDnnED8dVczA
	u0Ud5CuYXgZpwMkom2Dn3mSwAYzHrbwxD2X/Lcqzf/wQ7hByMlmb76bC2KdFs4+gEEJzOa
	Ddynmb9x61AE7/A9KA8EEtfIgiBg2yI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A77FB42DF4;
	Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625151F00A3E;
	Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605966;
	bh=7ywtTSlgg2gQ8bR9Osnueml1K534EMkMwLNfCemx+LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQMEp2mFw+fB4Jzx0eba1PvoTLks8pxc3hwhOW2pjDtuwx1MPsEY2RmjXgPsfe7iA
	 5dmGysHIcvdK8QTzzDbP1WtUSTt0nVlHWxpzIZr3A/uOu+HpOExGEWrYsSXC1vDFqW
	 VC6HlB1GU4B90CEur+L35zag7vA8c0Fmx7lCOT6HSgTcjEHuSdncu8+T57KY3fF/9t
	 Wj+0Vc2MWEX6C/NqE5A8svpJVkUO5ChO1HaPSNigUSYby0X56kiThmL1/pHClA34Bc
	 CM4bBPNJpwkuO49wGDi1AUPLhm/P7Xr/Vo9Jm9b6i8D2MVj7mSh3prw1cb+Tj8eY7r
	 GuOEwyMn2kevg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 08/19] mm/damon/core: extend merge function to work with probe hits
Date: Thu,  9 Jul 2026 07:05:46 -0700
Message-ID: <20260709140600.90950-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gtndp4n17gis1hkn3zk5ggieye96uxk6
X-Rspamd-Queue-Id: 5151C140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783605967-391880
X-HE-Meta: U2FsdGVkX18wFrAafVA8gTOLNWIBBS5BeUMuyARFyCpph5N2TnnU9ekd8jX1BLKoMFxImKjBS0atBj6bttvR0yMu4aoJF1lxwMgx2SikoCoKlozUz353BVHfB9BIBANgcypvc6P7BXyZ9372CK8HfGFsCVGBczY3D/Vykt+vGgoINF3+VgrniDsDqKSs13dvc9alDal/BOLyZx9hWD9qC+cp5IzwWVCLYKSS+wkVmh1mjMtjMHhxwQMeVkc2WITxd88zEzf1q/aZHBqyQvy/7w0DOik8NH9Tun6msg1zHwbnpvkGkl6W/yMZFgPCvnz/CIlZ6/3h+vlWdT/4LKE4FttOx868VpW7FXuTIHhKnml6BuFhNHTNbqMN9vW3IO0JMuB+aRDteX+WGeHW5kip7rBsje8IYK/wMMi30F6SJm4k9IEbY+m8iaNeYFw35IFJSOX0q+eK6/PceLPZ3kOBefwUl2+YzDxuU4Q500oddwPdyjw7Fjr0e9/Ffds0EdOhlTIi3oR7XDBTn45lc4VmI34fiXxKL4BD8uN73FP3m1Sq0nBReg+UCujBqBU15FNzk4nBAV4eTH+QIBo5NSgXLkX6P08AwsValV25LSTdVqrxMTynMIkW4m9eZJaQziTEHjU/jZ5Gp5UHy3gIUSSwvP3/QtAEjH0yLK4qoFJ3RNNIt/xgyUTeLVQsuCpXpnBllXDv2FCOXCVWkTqPhHJOWfbe7Y+ZRzDREpyvpKNJoCSYgbLC2APCHTC/eRfzZLwVqN7yFdF6nylZlRvMWCSqH7cZTAKtju320aNC+OmvL2S1LaShehioOqpkWhkgRIyUGUXo088pgwaqs5W4Rwqp1vRlZI1DG+4hQPKorQ9s/L71z0CXyCUXPckI9qYxQkwU8PQkIbwIhAih78q36iCbhlTVFAdQKBs0oFeJezE2jjEA5ivdLRiH/yYp9HjY6zZFu6Ef+wWskrv+dMZzbOL
 ld7unMkN
 +fy2hkBjzF1zMgNZDjjQCMs12TXp1GoabUZ3uBUyLhcxlBySeOIZF6lBTyKmQALUH0FcpO9/R0Q6HOPkeKNiAgctr4E1GkaPna+heyVzxbkrZOBsi6chn7B9ZRHKA7+jOFqR0D1ZojixQCmmahk/gjC2NM+5v7TbP3IWrmJ87oOLXkXaYQtcZClJRyxrtG40X/1W2ptwMGYMR7zeYiAv9RmEJFaiaFVYf0zYa0DIPHN2Fbr0=
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
 mm/damon/core.c             | 49 +++++++++++++++++++++++++++++--------
 mm/damon/tests/core-kunit.h | 13 ++++++++--
 2 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4c7e8a12a9b67..7d49420ea26c4 100644
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
@@ -3248,6 +3253,16 @@ static void damon_merge_two_regions(struct damon_target *t,
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
@@ -3256,24 +3271,38 @@ static void damon_merge_two_regions(struct damon_target *t,
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-				   unsigned long sz_limit)
+		unsigned long sz_limit, struct damon_ctx *ctx)
 {
 	struct damon_region *r, *prev = NULL, *next;
+	bool use_probe_hits = damon_has_probe_weights(ctx);
 
 	damon_for_each_region_safe(r, next, t) {
-		if (abs_diff(r->nr_accesses, r->last_nr_accesses) > thres)
+		unsigned int score, last_score, diff;
+
+		score = damon_merge_score(r, false, ctx, use_probe_hits);
+		last_score = damon_merge_score(r, true, ctx, use_probe_hits);
+
+		if (abs_diff(score, last_score) > thres)
 			r->age = 0;
-		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
+		else if ((score == 0) != (last_score == 0))
 			r->age = 0;
 		else
 			r->age++;
 
-		if (prev && prev->ar.end == r->ar.start &&
-		    abs_diff(prev->nr_accesses, r->nr_accesses) <= thres &&
-		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
-			damon_merge_two_regions(t, prev, r);
-		else
-			prev = r;
+		if (!prev)
+			goto set_prev_continue;
+		if (prev->ar.end != r->ar.start)
+			goto set_prev_continue;
+		diff = abs_diff(score, damon_merge_score(prev, false, ctx,
+					use_probe_hits));
+		if (diff > thres)
+			goto set_prev_continue;
+		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
+			goto set_prev_continue;
+		damon_merge_two_regions(t, prev, r);
+		continue;
+set_prev_continue:
+		prev = r;
 	}
 }
 
@@ -3306,7 +3335,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit);
+			damon_merge_regions_of(t, threshold, sz_limit, c);
 			nr_regions += damon_nr_regions(t);
 		}
 		threshold = max(1, threshold * 2);
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index d97280270c27b..6ad73559dd8ea 100644
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

