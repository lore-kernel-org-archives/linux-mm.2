Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35936C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 17:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1756B0095; Sat, 11 Jul 2026 13:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162086B0096; Sat, 11 Jul 2026 13:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BB16B0098; Sat, 11 Jul 2026 13:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9EFB6B0095
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 13:15:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63B3B140728
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 17:15:47 +0000 (UTC)
X-FDA: 84977147934.27.6115CD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EAB571C0008
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 17:15:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VdAxMIiQ;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783790145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ck7cKutqom8FXqW9f3tKNdDyqqXs5y+HSAyjbPEnNkM=;
	b=P1C1lyE9ao0CX6fjJsoqE7pDQVQq4t6qPu49rCoZtksBjEWtcl4ue3j7tWh8aCkm6z3eQb
	ujNdufSBC3WVa2gVJVIDm/rU7BWs3bMpVG1FTi7G2/OAclmbOxUeUcLoBh5pzIXooDixz/
	ja+iXKg4Q1I2b3QzLovvk9xaEMc79es=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VdAxMIiQ;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783790145;
	b=4FVEhAY+Ui3UAjPSkQawiO12i2GYltdNw3u62Zd72rW+UCA9I5rX3ryOy6CtPG7YEOmE4O
	71oc26e5usVmgTfvu7XSctL2Q/+UsPmWqDZA4W17iYtz0oyyZUJkfly+YoHhOc2h/V/VvM
	z4eHjYs8XGP/Vmq+IuA4gBfYNE0BnBE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EA0C60052;
	Sat, 11 Jul 2026 17:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE50D1F000E9;
	Sat, 11 Jul 2026 17:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783790145;
	bh=ck7cKutqom8FXqW9f3tKNdDyqqXs5y+HSAyjbPEnNkM=;
	h=From:To:Cc:Subject:Date;
	b=VdAxMIiQOsU2Hag44ILU7hjjfQ/8/fT+1he5wGJSsqu6mApw3IemgvlhZPh06Egvi
	 xAVedD9/dEQb4C3CvgYyKK7LUWpmuvkogJdLdvBaWj9Dqlwx/NBFGGSqNBq1rpQrKr
	 euT4vsm2acyDmEUWCzst8NFaICV4+tmHZpkSG6ifrUlzHLbtsWd/ziBUhTnjfqHL3w
	 Lp/fW1qvv3zoTJd+qPyZ0af/3pLG4Tqv3jHdwXUxcGbJEuEMRBHsbCgVmi+Ux1ZedX
	 BfmX0VAtS/4wooMN1S5JGjGgL1fZ+cW8doop88oopGgCq64zbD9o9HkC81Mo6pMjDl
	 Gx6PjTtR5PrHQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 10" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: skip aging from repeated aggressive merging
Date: Sat, 11 Jul 2026 10:15:35 -0700
Message-ID: <20260711171537.75278-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EAB571C0008
X-Stat-Signature: d6mma6fsj8n6hz1948n74bf7sn4bi83g
X-HE-Tag: 1783790145-469244
X-HE-Meta: U2FsdGVkX181c8//khod3wwJWQcpZcWTnTVSAEOrMNZhR3Wt3gkK3yWRlj2gQRY0ZqDDwoUz9CYwHbbEN7Ir80oE/UOZnowW9zLihzCgp8fDaRmhCMGkTS3qivGBJZxfLd3BHPJqGNIj5uehczaC3mryNzGr66QZwPBuWfqGaBmjdRGTL0J7u/f1A3vW27034yfxinCQ/wtfYMtqzlPrmUIO07UqpDYXjF5c5JdN5I34HtIMnMA0oP0sFvQAOlV4Kgfs4lCBkzo7lYZWH9zv9TMhs6htWMRisRzwo9A9pFH72wY1C+08VpRVQ+Me6OiQHpCsva8guNQ9XoczTXtK+tN9beEHwwmYjkwQwRJCHNOrSVIeDvgBa3U7euG55VrfG4wAX4l5aVabwbOTwArU3TIRyZtpMzxXJ27Lc9+PJbkB8jeG3kRxHsTxq3xUhToC8qqsjK7diXBqUNHg/qiuILjZQfl8dV96ooKbUa9WFp7WWGUGgMKPsIFlFTH7Y0VAbL+beoE/bEJjmBCfQW3xslZ4BDMUjADpVeR2O6y8cHd1KvfnUpJBL3yWnYfAeulzhVB2UJuijro4qcGPzCX1xU7YiDA2jiHlYW8xfMpZgdoS+o0bRWGKWdFyeZgmxKzjmYHqr8AaKle905gaLOAA7IfMlgUsanPXdHq+z2Fcmf/ZT6sAWGzym10ADgLGArfp5vpR5RJenvLYrQ4lfpi8o8cGq3HvGPKg+FOdzzHDGPap1Sk7Rs79nUeuXR/RJ5qD9cMM7sRZYDk17BZ8apLPD+hQZAqQTMbYoaFl8kl/3xsuNa4OB+CEYoKoi65aNNEMfp5NVQVE01kzWi7kRWlh/I2fjdlrdGc6X1Re+5jWmeYZRKCMoQdg/lPmfTtFT7gpUsjc/AET7gZfrJ5kwoJmfjb8S55Pvx6ZjQGEcZ3OU/08tRgNu4zociT/cBc5WAYgq7kGjEoq6jVQDF+Q5Qd
 oBkpodYE
 qms4NO4ezCTDC4SMDQDCMWUjuvddNyFelGqUn91LxoV/DhEiRT9RSdX11vaUNPRhtT5T2qbTvenwSUoleAJcwVfktA2s2bU3aH1qC7I+QM58bCMn5n7bE+sCLbCDt2uamq9wI3q8fI0WLHAtRHcF493mCIWryBY12B749HxO/tAbMFoQZnvxWq4aFVOrXrQBIoycm5kf4r5LdJhx9+NUcKVmriSLx0DYGQ5TsHLLX1OPJC2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The number of DAMON regions could temporarily exceed the user-defined
maximum number of regions limit for corner cases.  For example, users
could lower the limit via runtime parameters update.  For such a case,
kdamond_merge_regions() repeats merging regions in the case doubling the
merge threshold.  The repeated merge operation could update the age of
regions multiple times.  This corrupts the monitoring results.  Fix the
issue by asking the merge operation to skip aging for the corner case.

The user impact is degradation of the monitoring quality.  The impact
should be mild, since the degradation is only temporal, and it is not
common to happen in realistic setups.

The issue was discovered [1,2] by Sashiko.

[1] https://lore.kernel.org/20260621203548.10718-1-sj@kernel.org
[2] https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org

Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Cc: <stable@vger.kernel.org> # 6.10
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 21 +++++++++++++--------
 mm/damon/tests/core-kunit.h |  2 +-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 806a67d02a6e9..6c4215cc809ec 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3308,7 +3308,7 @@ static unsigned int damon_merge_score(struct damon_region *r, bool last,
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-		unsigned long sz_limit, struct damon_ctx *ctx)
+		unsigned long sz_limit, struct damon_ctx *ctx, bool count_age)
 {
 	struct damon_region *r, *prev = NULL, *next;
 	bool use_probe_hits = damon_has_probe_weights(ctx);
@@ -3319,12 +3319,14 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 		score = damon_merge_score(r, false, ctx, use_probe_hits);
 		last_score = damon_merge_score(r, true, ctx, use_probe_hits);
 
-		if (abs_diff(score, last_score) > thres)
-			r->age = 0;
-		else if ((score == 0) != (last_score == 0))
-			r->age = 0;
-		else
-			r->age++;
+		if (count_age) {
+			if (abs_diff(score, last_score) > thres)
+				r->age = 0;
+			else if ((score == 0) != (last_score == 0))
+				r->age = 0;
+			else
+				r->age++;
+		}
 
 		if (!prev)
 			goto set_prev_continue;
@@ -3366,15 +3368,18 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	struct damon_target *t;
 	unsigned int nr_regions;
 	unsigned int max_thres;
+	bool count_age = true;
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit, c);
+			damon_merge_regions_of(t, threshold, sz_limit, c,
+					count_age);
 			nr_regions += damon_nr_regions(t);
 		}
+		count_age = false;
 		threshold = max(1, threshold * 2);
 	} while (nr_regions > c->attrs.max_nr_regions &&
 			threshold / 2 < max_thres);
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 6ad73559dd8ea..68d30648c612e 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -257,7 +257,7 @@ static void damon_test_merge_regions_of(struct kunit *test)
 		damon_add_region(r, t);
 	}
 
-	damon_merge_regions_of(t, 9, 9999, ctx);
+	damon_merge_regions_of(t, 9, 9999, ctx, true);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
 	for (i = 0; i < 6; i++) {

base-commit: 3700e40ed9161bcf1b76601fa50b2b0ff8972eb8
-- 
2.47.3

