Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEB0C61DE3
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 18:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66B96B008A; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4B706B008C; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A136B008C; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B60CE6B0089
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7364C16056E
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:03:54 +0000 (UTC)
X-FDA: 84469237188.05.550FAB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DEF4AC0008
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:03:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o2QAHjuS;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771697032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clWkkdiMd2eDadDGSJUcKRXb5dHHtC8ssd2tPQHNpws=;
	b=RWINTD4bd1b0eubRj8fe80X4X/Z8FtlobJlmqq4dW331JRAXUEv7L7vy790j0MAflGx1jr
	yamdss16QSikYqDPEugg9XRp87Ryv0jwgBeHLjmCDYsv7JA29HOmyRmnvpRrbn2ny5FEyH
	GBxBvkcTjIOI3khMk0vcPr4xD5u3u0M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o2QAHjuS;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771697032; a=rsa-sha256;
	cv=none;
	b=K25zODrNOJIAZ89cej8wprzCSB2UJ4hNn9zrbHmBr9D1bVwRjSerNIgigf+jFFt5VqTaHr
	XsfBu5sDEuD+dhNFUKiIXDNbVm7ryoKjxpMku/E57U+NbD/7bUJkcVE0K4o2LIY2ussvnm
	+ALH6kLouk5EBOpnSnmG9R+I3lvQKU4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29F2A6001D;
	Sat, 21 Feb 2026 18:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838EEC19425;
	Sat, 21 Feb 2026 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771697031;
	bh=WQkR1kCn24B+rN14IssLOKwmMbLKRgmj7l4b9UR3+s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2QAHjuSXLYeKIxZfeF+YyRbSmIANMmGUmP+UyPLmmktprryPqVthm2rKxacCWiis
	 ASO6aUjqRAUquNQXGtldAMEwFuYntkjmjV3L1y3p9tFJSllDz58SiBnZcGKRKv9sLB
	 tzTLL+HbygNx3Jr+b2I9j5ZCnN0US0P9Cmq9JBry6yH80wi8dAUfY9mLpIZiprs6PD
	 R7cHnKlRA2X5oY9ImDLWCPLQHzjJN1vOUzIXAgt+n/cC04ENTZ3tWBznkB0qt4kBNK
	 CwDzmkhLRHPyizLuwv3ZgIaAVWrbNDXX2hHMjCmd1Bh8QolhXZpxOcJwxB/2ShwEDw
	 jliRF45mQDw3Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/3] mm/damon/core: split regions for min_nr_regions
Date: Sat, 21 Feb 2026 10:03:38 -0800
Message-ID: <20260221180341.10313-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221180341.10313-1-sj@kernel.org>
References: <20260221180341.10313-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k9o5yhht9mxw4kbfcmz3yyu4uogfecj3
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: DEF4AC0008
X-HE-Tag: 1771697032-2448
X-HE-Meta: U2FsdGVkX18z/LhjHBC74kVAAAoyrc/nSTwvt5zhKqHlsusAMIdG2EQ0wDwM6kX5Im6NaMIcWBM5uWMp2i0lDnmoQQbZE7d4vQMtS3nzD3BdC3+Hwnl6xWYKL/D4gXq6sfJnn2OKYCtWpobQcI6Qq+1GWr6ha/nT8IyMkfcajIOiFias8217TXr4cuVFCnrD+4oYarYaojUuC16/vd9yr0PYDyxd/gmO6GfeN35YcqYR3kOJdDg2BarcO4QsOwxNQa/yUeB12AYfO2lhPpI4AwHoF0vXeO5CoyGZPJ7F6lQiFkvW08iNUWlUqmyFb/5DdTH8oI4lqkTVrJe658jduogUFsAha+enHiial9tN3+FCNjvucPlYxk24To1ttPY0JLtVWSpuoEoQRk7ATOZSSEXjCrl4P9sqdWmIhSqv/qqOLwNsZKmB7zh3xJsOcgj4MdneZIEXPp2lRaFruSEXYk3WU0VUBL61kykmPI9FefBjI1j2im8XHjG8xxGsdDWeCqkNRhLuTuweuxbMktFD5GpTwu+QOgfxfKzCd87CsePVHaukVEkW53lJn1mU0eRNcGJXbZSfT2c9vfBuDM8k+xWh/Yd2PzsP7KyhIFhfFner+H+MXYvodpIFukIHE3k6J7CHEva1pXnhhylmV5PwatSTWEB5Ik3QTQ4fbNUzRA997bkGs2ixyjZ2fZHoEZLrvMkr0gBeJKoEp8G9p6u6OOl9BLlKucnuohmnbqDHYy2kqo/b+mB2bjc8+BjbL9e5wFs+2fRlTG1kJYrq2fzP4NT6Ya+Qb56aNdZfoiIQLXxU8+DLN99I08J+AoCd0Zfpt6O6LCDWxuI8IYVuJPdXL23KP9dKlMRbjA0l5frNZS9hs+sULKwjWiXkQHjG0N+1VNFwi9oOI8A/wMLaXT1jBt7aeV+INiMWj4XYygbLJuAgfUJH/FiU6QmQpQqQEkheKQCFXU3Kb0U0t9UUkWF
 SMIIIFwG
 ofLDpHRVhWYcoQZly9fKmiy73uAYRVQC150vMHpof379AxCadkEupUt/6ux+mtD8finkWL0NeBXKoA5pfJh0K+i35Oz5cPYc5ofYhfTuWNdD71EvMG8sE3i5QilME0yvMEYNAKrLBXAARKOV3PiSnh/jQrOFCt80+WUGAYmvwZx0Qe8OtH0W1t01P9gkL0O4lp9rj1okS6rvECbvyED9pu54faDOfjN5J6wCJt6AGeap1M6cxXtwvpeeSZYggPVssXdtAbXM81Zxm2XYjY6WUnh7oWzwkA3dJVg0QITrsV9SGu7fkgxrYz3ojBM+WvW0q9r9FzumQcBkRVYSy/Bgnw8A/XHmnSDrq6FaJJaRqvJkw2YApHjoWliAnZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core layer respects the min_nr_regions parameter by setting the
maximum size of each region as total monitoring region size divided by
the parameter value.  And the limit is applied by preventing merge of
regions that result in a region larger than the maximum size.  The limit
is updated per ops update interval, because vaddr updates the monitoring
regions on the ops update callback.

It does nothing for the beginning state.  That's because the users can
set the initial monitoring regions as they want.  That is, if the users
really care about the min_nr_regions, they are supposed to set the
initial monitoring regions to have more than min_nr_regions regions.
The virtual address space operation set, vaddr, has an exceptional case.
Users can ask the ops set to configure the initial regions on its own.
For the case, vaddr sets up the initial regions to meet the
min_nr_regions.  So, vaddr has exceptional support, but basically users
are required to set the regions on their own if they want min_nr_regions
to be respected.

When 'min_nr_regions' is high, such initial setup is difficult.  If
DAMON sysfs interface is used for that, the memory for saving the
initial setup is also a waste.

Even if the user forgives the setup, DAMON will eventually make more
than min_nr_regions regions by splitting operations.  But it will take
time.  If the aggregation interval is long, the delay could be
problematic.  There was actually a report [1] of the case.  The reporter
wanted to do page granular monitoring with a large aggregation interval.

Also, DAMON is doing nothing for online changes on monitoring regions
and min_nr_regions.  For example, the user can remove a monitoring
region or increase min_nr_regions while DAMON is running.

Split regions larger than the size at the beginning of the kdamond main
loop, to fix the initial setup issue.  Also do the split every
aggregation interval, for online changes.  This means the behavior is
slightly changed.  It is difficult to imagine a use case that actually
depends on the old behavior, though.  So this change is arguably fine.

Note that the size limit is aligned by damon_ctx->min_region_sz and
cannot be zero.  That is, if min_nr_region is larger than the total size
of monitoring regions divided by ->min_region_sz, that cannot be
respected.

[1] https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8e4cf71e2a3ed..602b85ef23597 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1316,6 +1316,40 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 	return sz;
 }
 
+static void damon_split_region_at(struct damon_target *t,
+				  struct damon_region *r, unsigned long sz_r);
+
+/*
+ * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
+ * @ctx:	monitoring context.
+ *
+ * This function implement min_nr_regions (minimum number of damon_region
+ * objects in the given monitoring context) behavior.  It first calculates
+ * maximum size of each region for enforcing the min_nr_regions as total size
+ * of the regions divided by the min_nr_regions.  After that, this function
+ * splits regions to ensure all regions are equal to or smaller than the size
+ * limit.  Finally, this function returns the maximum size limit.
+ *
+ * Returns: maximum size of each region for convincing min_nr_regions.
+ */
+static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
+{
+	unsigned long max_region_sz = damon_region_sz_limit(ctx);
+	struct damon_target *t;
+	struct damon_region *r, *next;
+
+	max_region_sz = ALIGN(max_region_sz, ctx->min_region_sz);
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t) {
+			while (damon_sz_region(r) > max_region_sz) {
+				damon_split_region_at(t, r, max_region_sz);
+				r = damon_next_region(r);
+			}
+		}
+	}
+	return max_region_sz;
+}
+
 static int kdamond_fn(void *data);
 
 /*
@@ -1672,9 +1706,6 @@ static void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static void damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
-
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 {
 	unsigned long sz;
@@ -2778,7 +2809,7 @@ static int kdamond_fn(void *data)
 	if (!ctx->regions_score_histogram)
 		goto done;
 
-	sz_limit = damon_region_sz_limit(ctx);
+	sz_limit = damon_apply_min_nr_regions(ctx);
 
 	while (!kdamond_need_stop(ctx)) {
 		/*
@@ -2803,10 +2834,13 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals >= next_aggregation_sis)
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
+			/* online updates might be made */
+			sz_limit = damon_apply_min_nr_regions(ctx);
+		}
 
 		/*
 		 * do kdamond_call() and kdamond_apply_schemes() after
@@ -2863,7 +2897,6 @@ static int kdamond_fn(void *data)
 				sample_interval;
 			if (ctx->ops.update)
 				ctx->ops.update(ctx);
-			sz_limit = damon_region_sz_limit(ctx);
 		}
 	}
 done:
-- 
2.47.3

