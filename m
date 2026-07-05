Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC1B1C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B876B00A2; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5516B00A3; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD396B00A5; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70AB96B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D54751C0F32
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
X-FDA: 84955934952.10.E3EC3D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 54F2D40003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7T23N2r;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ea4i8Dv0CoJkmGdBeb8J00MLK5gjFTil2XSf1WpbBk=;
	b=GJupBxNGhG9COTP/JIK4A1NH263glwPhEKZn3OA9VZGsmAr2rKNf9rmGuSHg6gtN2ZZnvf
	U1az7AfsA93OaOnP8atla2+v7BwKo8k7+Lmd09RYIUwMvTsR/vS4ppUsgFwrQjqhzl+qXL
	2IQMyg/hxR7WLDxzDELQjXyDXJfihcU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7T23N2r;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285075;
	b=GfGuY0wn9nA5fBD2WhPrxFMDOgAz7qQLEuKe3SUxtkOPE64/c8DpEQsq+mWQIFSc+ikSPv
	GrwiNQVNpsEmz8i0+obKxRsIQo0l8aoO9+RIVXHFU6R+kjVAKS178BvPtZoE7l1Y0lhrpj
	mEqwofS5oivwA1csVvKpoJC0FyZRANg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECD41600DA;
	Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF341F00A3E;
	Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285074;
	bh=7ea4i8Dv0CoJkmGdBeb8J00MLK5gjFTil2XSf1WpbBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7T23N2r1WUdhw6SQgrU+YiIab7SEZgfNIAuf1MuNya6JXnVyZAULGYW6wYNuk14e
	 9b2M+08a6V9izNVw93MHqqL9Z8pbdQRYTdDrowDiOVCUtuB8Dtet0mCcPerCQBtBWc
	 2dFjQqhEtFbYDtmkJpeJ0rIrBkfQo6Tzmu+qIOa6TcWYLxma4m3KN2ncWxfXZTiWNx
	 4f+EBJv5wls0bdCTKKLPV/GwtxSG+Jali7Epik1aTWHrpXfi25DJdAYo1lqSbxxYOD
	 pRelZaXsVKDvLNncTLGUVcaFkdlN0bXn+xqxuqY+6IGkjUopldP0KmAvy6YebuFkWq
	 ND3uGTd5BQ3pA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/16] mm/damon/core: ask apply_probe() to return max probe hits weighted sum
Date: Sun,  5 Jul 2026 13:57:26 -0700
Message-ID: <20260705205743.98656-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 54F2D40003
X-Stat-Signature: siq6q6npob84bwg8t17um1xemy71wqyt
X-HE-Tag: 1783285075-367133
X-HE-Meta: U2FsdGVkX1860GyZ1QMsQUxfcofwOeEVmCy2lEhbUeMZHMUE35K41+Dicy6mQd4WdQAt/GSaNVUxJVUVzLpWWrbLx8tFKAsjRlmqpbapMgcEbf1B5OxeRu1hcsl6jCR8hKxlr9eL70daxenu4pjJzgosDNBaxM1PKJTtsYSkZ6S0MKJIMXy46L7WOINzy4mXFJe9XNNxkks+oaXwbch4pCwQIxugLFbi+5mIv7EmY55TrC6d/zjgpFqF4UTWWVWnT/LfGVqUdXQpPdM0n6nM3T9XMyUAkAde6N0ieET6tpdsIay61fdaCnBSj8B+QSDutT3QUMBz+hHUnObtEfvml3cO5AyyO2tbsO8MfJ5W7z63J7ri9jHR9vNv6uIFCqZ/rbr71yNw42g52lJVKs32ZLY8Ea/gat6LR3sXZlp0ID6bBBEcinmslNNzIyjs1kGtEVPSmoxPmCn4a8Hq97E3nL1Br8epG4ON/ee/FRX7N5YraXb308sGfbLE0dWplDmPPFCvXONPaEXlds3Kc42hGP7TAxvBG1yp9oIFjS1OZlxG99Gj3YwMB1AnWFn0LQccIeeHFAc/feStcAlSBcxhwXS0Y3bQb0hmvfWkTdRSXXw4IbPT32SljFXmiTGG8IhQb0a9sdnAzCHxrM7rYyahCX8041qPOy0mf8aZNr/MqWi6AzJfJ1MdXRLm3LzmXiMlHgQW2J9GiQZLUBhZ4gKD5W/lIdb+KDeDOW5NRtGKB6nGABX0Tjfs8qfVTTt7HektpP8QA5FbAmcx8Ps4N5CYpjRvX7mtF7UXGuNfAEjPGCVRJzhKUCPFKJjoCSNMXm9rQySGUrvF62D9ZpQo9k6GoFbSax3BnzO5Nl5CZL9R1HY51V2BuM0Og73qMvcuLgIM74+8ywi1hpztC5nQo1OOYu5YVMHDngPqckRYLEdAf8FXGRp5OIb/UzIfkHtftbTpPBOGLNjqreiouGb/mEo
 PeFXlxoX
 G+uCZp0x8OfBHoMPPD3ag9yujuZbbAYC+MjoJEJ/PyFv6/ZUYsHzIt+sEsf+E8ilm/8MGPVZVF5yio/lySI1EyYUV41EA20nf6Eszj8yB9NXvxufTANXeuK1BNTAsChEpiceljxnpay35zjH7xLYjEVMtXxBeMVANxq7YUhUoUfPMAfLsMisvI9L3VMNBhNbBqZlimU0/aGuybPqp8bLzozdWZyYExiHRhhkyaqY1s+foqXHPjOryKJpgUuITjgEUZ8CyP+2wvvqE3bomqbVIaj96Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_accesses() DAMON ops callback returns the maximum nr_accesses of
regions.  DAMON core uses it to calculate a reasonable region merge
threshold.  The core will need to adjust regions for not nr_accesses but
probe hits weighted sum in future.  For that, the core needs to know the
maximum weighted sum of the regions.  Update the protocol for the task.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 7 +++++--
 mm/damon/core.c       | 2 +-
 mm/damon/paddr.c      | 4 +++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4dec5d314c782..62caa67a3c40c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -648,7 +648,9 @@ enum damon_ops_id {
  * of its update.  The value will be used for regions adjustment threshold.
  * @apply_probes should apply the data attribute probes to each region and
  * accordingly update the probe hits counter of the region.  It should also
- * &set sampling_addr or each region if &set_samples is true.
+ * &set sampling_addr or each region if &set_samples is true.  It should also
+ * return maximum probe hits weighted sum of regions if &return_max_wsum is
+ * true.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -666,7 +668,8 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
-	void (*apply_probes)(struct damon_ctx *context, bool set_samples);
+	unsigned int (*apply_probes)(struct damon_ctx *context,
+			bool set_samples, bool return_max_wsum);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7c0184cb78a50..e42f512d87a11 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3675,7 +3675,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, false);
+			ctx->ops.apply_probes(ctx, false, false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index ff4fcca949660..3eba3564a31fc 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -166,7 +166,8 @@ static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
 	return pass;
 }
 
-static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
+static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
+		bool set_samples, bool return_max_wsum)
 {
 	struct damon_target *t;
 	struct damon_region *r;
@@ -194,6 +195,7 @@ static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 				folio_put(folio);
 		}
 	}
+	return 0;
 }
 
 /*
-- 
2.47.3

