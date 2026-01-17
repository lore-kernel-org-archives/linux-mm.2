Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8366DC9832F
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9561F6B0099; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7D26B009B; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6500D6B009D; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 48F256B009B
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF6B1D1DBF
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:09 +0000 (UTC)
X-FDA: 84342202098.04.F040937
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E6A580006
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XboQCrWp;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BneBL/lGUczmC6wVckULqUpFmhE2k6Wutdljf9V0Dmg=;
	b=jVrV9k3VIxr95mr4Xs+rKSoZMPqDSV57HzRWAx09qCoM+zjrTFB9rA9eOybf2qXBB9wGiD
	+5IC6LZ5uY5onJb8IsqV0ByVDwnlgT6fjlf+KomuXJIOoAOGM+sruG9DfivQ+oZVhR6gGA
	coFl6XziYTo4x31ibRIMTkCkXd7iKkE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XboQCrWp;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672388; a=rsa-sha256;
	cv=none;
	b=ZRCPE/nrAzhFJic5MsSqYhoqn8x/nT55AHYlPoFzw7JrNBRgW60hdv+RYuy+C9VlKtPyUC
	lPNs2zu+p1wQaIKetJaOtupSVeADR7n4QXW8wcuvKsq65tjW7ye5641KYP9ORRlIDesO9f
	Y5hoBIoRcq0yaGCnNlVNoBrYAzeWDMY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E369F40703;
	Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5BCC4CEF7;
	Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672386;
	bh=euB34KBwMNH0Wmqe09qNX0ZCrnsNrl1erm4orWgN94Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XboQCrWpygsXWUjCYZVHfl5v6h5r9fiD6ifKt80zLkTMGFDUSmCGP5PYKYDhHFTgM
	 Tt/u0qYPIMoD+UclftBK5uQdkLia/RsRXVgGT9nS1fqqL2pWnqNKhVmB2tCMQPUXxx
	 OHsj9gfoZnPkc84FvGPlNg4gcIOvFUA9Y0MSuIGZ4r2oDPBhgiEwHq0zANajbp+RLN
	 3Ex1lNfEyplsnndPlWjavIo2BNqiOo3L5d6eLZ3bgrlQyY9VwogwMFowiI8eyS2XA5
	 Pje3NQ5m2nDj9V5cv5xVaUUmzrZ977ne5oN+COC1hWjwiHVRsosiuJYL8xF5DJYAEX
	 SqlZ4IPbsCEyg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] mm/damon: rename DAMON_MIN_REGION to DAMON_MIN_REGION_SZ
Date: Sat, 17 Jan 2026 09:52:54 -0800
Message-ID: <20260117175256.82826-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117175256.82826-1-sj@kernel.org>
References: <20260117175256.82826-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4E6A580006
X-Stat-Signature: 4nfm7k8gawthiotypaeijm7sudtza6yf
X-HE-Tag: 1768672388-413442
X-HE-Meta: U2FsdGVkX1/U+vJmqfRjHnSgnbRBS5gPlmbt2ey813g85lKscw15E7teF+G/mb05etTT80JSsjeZ+5kEsF/FxLw21p8xU3hGsuVAmShWVJFgQGE/t4SyHBYoPIHLSoKSOzRXgavF48qi4Vziween1UHe21dmszM0LIJntonzSIy9bBytQWK+PUOuzez3PNBVQ0Qmni7FpzUWsoWL5hprSnLWV81DTsK0Yl7Eb3khCeeM+wZfW2C4P28HWFQgrJ8z9D+bXmu3/h5a4BCv0MC/RDtaxVmPVa2ejns1ubrkIgK1eWYQl5ORALTUfRUaw/DOHrRYdO/VlgVLMTbrBrPWmnjfYM/XUD5xBXYoCgPFIaYj2NADdTKeGM7+7GIyiGVldnZaTeGRJ/yNUF8n+4kI/G2FauqBlUFCRZvf3lJ0ObSfOX/RWraG15rY5QjQ1+ci6K6UpdwmFVesMVi5CDbU29/+ux6zRflO+1LL9T25G8D8pl/x2aXSfPmfy/SxzIz4yFyrWMiuFcK/21VwWPEAeMdM0Qml0vWHHxRSNvmUYGZeCbZNaQNT1SRWd08k1g8m+OdU8JmwNAGscnrXdF/a0u+tKcwD29rQXJRgZky874vxRfNpPnMP9rNdTID0Z9PwekEQdh+Frj+vjrEa7VGNVaA/xXB6OxPbL9w+QMsbQcL8eYAQ6gEfaSPXXOOXfzjN6e/TQ9CaO/hdBCgRDNsrYRQZFKljQ1owN6QVH5UWEJ/koA90JvZ4Scv7qQvLQSGh5OHTgR4yiflkNrAU9AB4bt8A1XqjfWtO37n07tPqCiHep44Rjfznay0h6iBgCIwUrYqDR2rj+Mnlm07K53GM/SuV8SMx4kEgJV/v4i7t+Ts3V5yvCbtkZiXJepcQ4yxwh79GDRK7x40TkfWPzTL59Y8DomjOJdSkY1QDTmXWvFohFV8fo6pMt4CietXWHW8ALUrFL65C/1mhri+z27N
 FNfC30xV
 +6j71Q9XFDLZDfXnYDbJnCcHcdZw+NDpKmafy4O8yR6tkIkUgW1108q6n71B4uJAU0msHD/IMCjakb9T7qHzWsksp/um8OOasdYIHNlWO0xC/Nk8h+JkZlSC8gZ4+nZ+si8juqkjY89e/ef8TDPVULMgZ+p1BD9j3sx755YoC2Y5xcUCaBsd9X/PWW0NTICJNwe9G2ehi+OTQMEDnUrOVvYVTJRXNPtImrpwn9RcFBNfdT1c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The macro is for the default minimum size of each DAMON region.  There
was a case that a reader was confused if it is the minimum number of
total DAMON regions, which is set on damon_attrs->min_nr_regions.  Make
the name more explicit.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h        |  2 +-
 mm/damon/core.c              |  2 +-
 mm/damon/lru_sort.c          |  2 +-
 mm/damon/reclaim.c           |  2 +-
 mm/damon/sysfs.c             |  2 +-
 mm/damon/tests/vaddr-kunit.h |  2 +-
 mm/damon/vaddr.c             | 24 ++++++++++++------------
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index bdca28e15e40..5bf8db1d78fe 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -15,7 +15,7 @@
 #include <linux/random.h>
 
 /* Minimal region size.  Every damon_region is aligned by this. */
-#define DAMON_MIN_REGION	PAGE_SIZE
+#define DAMON_MIN_REGION_SZ	PAGE_SIZE
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index ae5b772ceffb..5508bc794172 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -553,7 +553,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.max_nr_regions = 1000;
 
 	ctx->addr_unit = 1;
-	ctx->min_sz_region = DAMON_MIN_REGION;
+	ctx->min_sz_region = DAMON_MIN_REGION_SZ;
 
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index bedb9134d286..9dde096a9064 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -298,7 +298,7 @@ static int damon_lru_sort_apply_parameters(void)
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION / addr_unit, 1);
+	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 55df43e241c5..c343622a2f52 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -208,7 +208,7 @@ static int damon_reclaim_apply_parameters(void)
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION / addr_unit, 1);
+	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 4de25708b05a..57d36d60f329 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1470,7 +1470,7 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_sz_region = max(
-				DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
+				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 30dc5459f1d2..cfae870178bf 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -147,7 +147,7 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 		damon_add_region(r, t);
 	}
 
-	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
+	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 40c73adf1946..83ab3d8c3792 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -19,8 +19,8 @@
 #include "ops-common.h"
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
-#undef DAMON_MIN_REGION
-#define DAMON_MIN_REGION 1
+#undef DAMON_MIN_REGION_SZ
+#define DAMON_MIN_REGION_SZ 1
 #endif
 
 /*
@@ -78,7 +78,7 @@ static int damon_va_evenly_split_region(struct damon_target *t,
 
 	orig_end = r->ar.end;
 	sz_orig = damon_sz_region(r);
-	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);
+	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION_SZ);
 
 	if (!sz_piece)
 		return -EINVAL;
@@ -161,12 +161,12 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 		swap(first_gap, second_gap);
 
 	/* Store the result */
-	regions[0].start = ALIGN(start, DAMON_MIN_REGION);
-	regions[0].end = ALIGN(first_gap.start, DAMON_MIN_REGION);
-	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION);
-	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION);
-	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION);
-	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION);
+	regions[0].start = ALIGN(start, DAMON_MIN_REGION_SZ);
+	regions[0].end = ALIGN(first_gap.start, DAMON_MIN_REGION_SZ);
+	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION_SZ);
+	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION_SZ);
+	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION_SZ);
+	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION_SZ);
 
 	return 0;
 }
@@ -259,8 +259,8 @@ static void __damon_va_init_regions(struct damon_ctx *ctx,
 		sz += regions[i].end - regions[i].start;
 	if (ctx->attrs.min_nr_regions)
 		sz /= ctx->attrs.min_nr_regions;
-	if (sz < DAMON_MIN_REGION)
-		sz = DAMON_MIN_REGION;
+	if (sz < DAMON_MIN_REGION_SZ)
+		sz = DAMON_MIN_REGION_SZ;
 
 	/* Set the initial three regions of the target */
 	for (i = 0; i < 3; i++) {
@@ -299,7 +299,7 @@ static void damon_va_update(struct damon_ctx *ctx)
 	damon_for_each_target(t, ctx) {
 		if (damon_va_three_regions(t, three_regions))
 			continue;
-		damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
+		damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
 	}
 }
 
-- 
2.47.3

