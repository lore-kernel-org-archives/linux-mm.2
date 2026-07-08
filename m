Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15978C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2EE6B0092; Tue,  7 Jul 2026 21:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14456B0095; Tue,  7 Jul 2026 21:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60446B0093; Tue,  7 Jul 2026 21:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6770D6B008C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1F0A4062E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:01 +0000 (UTC)
X-FDA: 84963885762.07.5A394DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DC8E620003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:32:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ocAmMehE;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTeI5Dbt+ALLrinCjjWwHybLZIRmQonrPoimOF6qJBY=;
	b=4f2WlOfoI2OIGVvB6xC81uz2qKS3XbbWXDSDw+pq1b/8jz+cJDM7pwbOT4usE2Lnz9hTHA
	wfMNKYQ0YM7E3fuSpjsJ6B0DTo8WXckr4iHteJk2tY3BANGs3y0MJdwOLZvAXrna4C2+Dl
	RtwiGtD/+kWiZmHJpKIA+IT6XRyefOs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ocAmMehE;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474380;
	b=ZIHutJEjvfU+gdLszWN0nRkY9YjituEhKMo/FxIr8HAgHGY3He0ULpd5BVLGT9gy9I2+Sg
	v83g63F6jvhSuHFfN9LfeokYG/cjGa/UkxufBQTuSbJHHsvC0gvXc/OKXcqsGB5iXbh6oF
	d3g5G7Fpr2evkNW35pPPeNaJRC8fWp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 221D843DA8;
	Wed,  8 Jul 2026 01:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30AE1F00A3E;
	Wed,  8 Jul 2026 01:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783474379;
	bh=mTeI5Dbt+ALLrinCjjWwHybLZIRmQonrPoimOF6qJBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocAmMehE82ttLjyKWmD4yCcIjIYevUZ6SoykC48pCNcw8OjJOv+3leHr6poDDvRWg
	 Ys3XfgMke92Da0ZOB2WBgWoUMacBcrbYsOa6RuBpSENF+siZcb/qhOiPpCa6JHzXP8
	 ZUrw26R40/Ow0LagpZA8szKA7B+2fqMCaIAJrpsBgusp6UclFzKcpeMGY3uuwmWdZx
	 EoBzy1+TXy+PwkruFkfmcaJBHB6H+ceyEDsR2/0Ei10XOpdbUPbVewCejKTauuOrb7
	 JPqiZjsmPfvALciCqksctaPLRn/HWyjDOGSSn/4qknBnIGXt858kjhVHk9rfJyr8Ma
	 NDucoJpOOilUA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 2/7] mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
Date: Tue,  7 Jul 2026 18:32:45 -0700
Message-ID: <20260708013252.95888-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708013252.95888-1-sj@kernel.org>
References: <20260708013252.95888-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC8E620003
X-Stat-Signature: ye7qwzjowj9xj3dhp69b1rrusccpff4i
X-HE-Tag: 1783474379-55100
X-HE-Meta: U2FsdGVkX186exmxMMB9Sl5+eJV3T3jnezpt9qqwt8uyAGlAgWoP6S80LEsd0uHlg+Qsk2WfF0F9yHCICH5eI7WLNE6XKisrcVoLW+DbQCCGRdtTOLnTze0k14rpG31RGG+Q7HfK3tXyBl0oazJ2zTSbs/Q4al72j+sAppAGosWF+kaYTiJdqR4YaqxWfnONQgCZ2ysUcBz2F12D8Wo8MlFEnVaz3+jeq9ZZWuXwEDoXluEN+i4vIyMOYvLIcS/gNtWr9dVd5yKQq3xGqlQjtru2QQIgA2pinnmS0MkGHY0lwFFsG44DTJg03qU1V8Rab74BFnzM1879ogxErfR5IGLi5ohhkJA/rhl3j+tv86Gvr78Jjr4Qop2LpP5P++gb+UzoBV5oMIpVDS9goIRYa5jzXPFEtP3syOlXerj/6+Two2etDxqN6ikG+Y+0XQ+t9f6E1kBeB/3KubVrm9nA1gH3+4Fsf9oUSg93Jvo+GQErZk0X3LqRq7xEz53ewtHRACVbqzQIVE+7VRp05+JGcfdyUL0wdY22HlRqpSWk0EVLVpYYCvywJhbmX1nDcVWWP04C+zTX9eJSVHsuxHMkkRHomrkvCJbvhHV7E+eKimBRb0+KiREz4sMUEsMUPvqEpCyXSBDyaY3HldBZ09Y0gDQKqDrLV2JEDWbF/Tx01GnViR00rKXPAVjLa4OY4PZO5q4WE4FtDcmo2YvgTJm0sMv/cmIsJRw7LL5vrPv4Urpn3bZduRB9rvvmNymT7TjfRGQMkh1NdgkkD2hTML8UY1rPeIVoTzYCkITyOogir8VqJft/NMpIeU+0TlK7UTFPgopxJ19KZJzqNfh6pbkKJHH+bZsVkXyZLShvmdbl5DmvqMK/IkVdnnwBZgkqONjuVApWReKIAv5pahAk5CGo1kPGtKiClPpG/E2pVvrVwRhdrCqeIGtunGYwwC1kr17ED9Ea7lCv4dZQLjFvkME
 FxiTOufq
 kTmCjb1s1QKLCxB9jldf+blaV5LtzzGooeaJkdZwovXVU7Mg/fbMVXHHmj4oe0YCaRvVbRTARxBHiKieFL3AstusJbMFleidL7ygLVGDYaiYMzJHwP6Mk0RhNiit3kfOZI5I2W5pKGxZTNAK5EEVhEyS7sjc9e0Ht6cUMnxaEqtur0DWkZcd1TVn6/VwNayUfV5tLX0834zPNpG8RitwPBB+j7yYBRqEvAPR9bBrh7LHcCWf29pmCr17z3dYez3yZG5ODcsP2aGzedwS1ur6qwa8qTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_max_nr_accesses() actually returns the number of samples DAMON
checks for each region per each aggregation interval.  Rename it to
better describe what it really does and not confusing for more general
uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ++++++----
 mm/damon/core.c       |  4 ++--
 mm/damon/lru_sort.c   |  2 +-
 mm/damon/ops-common.c |  2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 19b7e839bde0b..63f596957c1f1 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1056,15 +1056,17 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 	return ctx->ops.id == DAMON_OPS_VADDR || ctx->ops.id == DAMON_OPS_FVADDR;
 }
 
-static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
+/* Returns number of samples per aggregation interval */
+static inline unsigned int damon_nr_samples_per_aggr(
+		const struct damon_attrs *attrs)
 {
 	unsigned long sample_interval;
-	unsigned long max_nr_accesses;
+	unsigned long nr_samples;
 
 	sample_interval = attrs->sample_interval ? : 1;
-	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
+	nr_samples = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
-	return max_nr_accesses ? : 1;
+	return nr_samples ? : 1;
 }
 
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index a15005db82899..177e5abc981ef 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -880,14 +880,14 @@ static unsigned int damon_age_for_new_attrs(unsigned int age,
 static unsigned int damon_accesses_bp_to_nr_accesses(
 		unsigned int accesses_bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
+	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_max_nr_accesses(attrs));
+	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index e8c389ad3226f..7e077084cb03a 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -303,7 +303,7 @@ static int damon_lru_sort_apply_parameters(void)
 		goto out;
 
 	err = -ENOMEM;
-	hot_thres = damon_max_nr_accesses(&attrs) *
+	hot_thres = damon_nr_samples_per_aggr(&attrs) *
 		hot_thres_access_freq / 1000;
 	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!hot_scheme)
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 6bdd1cfd3863a..89c694f6e4fa8 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -112,7 +112,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	int hotness;
 
 	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_max_nr_accesses(&c->attrs);
+		damon_nr_samples_per_aggr(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)
-- 
2.47.3

