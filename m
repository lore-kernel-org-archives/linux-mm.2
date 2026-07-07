Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4B0C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C296B00AE; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 495176B00B0; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CF56B00B1; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2436B00AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70292A0424
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:53 +0000 (UTC)
X-FDA: 84962116386.05.1B5B5FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C954E20004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUve9Kny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTeI5Dbt+ALLrinCjjWwHybLZIRmQonrPoimOF6qJBY=;
	b=LVn5G1LoKWTuVGNmHVzfl7X2JI9kvp1QXUBX2AwFuUhkwBOLKO4TbeWoHBRg9uTUqStBNh
	e/HXSnHT7mla9z3X0d09cFdvQKIeIqp2/HtFDekCwghculbJQN1aiR+twgbjPKZbTbAZnJ
	xoXy/cWiluTFQNLLtS4zxY8j5PtO+V0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUve9Kny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432251;
	b=3kPb9in/MvQIJRk8tnm51ITAo2UhWtp87XJIEl0FyI6lIQD4EJ3E99r5E8RZuQ/fyRz4jx
	40CX4vWkv88lXgB/uvpE22KC3OJMkpKdKiNnAj1POO94nn0NChdm01LBk+v1jL0vjrpqHq
	Vx1diQqhWk3b38RMhkLhS0p1NIGOH+U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CFB943B74;
	Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB99E1F00A3A;
	Tue,  7 Jul 2026 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432251;
	bh=mTeI5Dbt+ALLrinCjjWwHybLZIRmQonrPoimOF6qJBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUve9KnyniQXo66JCMgX9UZKoWQdRueGvKYZUiM4EX0OhCuTgsZvODXR40C3QOIj5
	 EQYoH4CUIrkpU3ltudx4hdkytf58JOMDazJ+rc9rzViLKMlZtiveHNQKjHW9I4wHyK
	 ZJN0GuGawd5YQTFpf4ihDchH+om+U2wDEdvufd7xD19l/MbdigNe5JUYm725P1Pgho
	 PquS41pPuRN7E9x/9g4MrsKPMnh9+1juqFjSvDwTXRL59CeJq6BI+zM9Es5bF+6qUj
	 uuQCRvrtToDNzWWqRk7BwY+yYg+RoCE1Hl6RJwi8kkhziPWXDQDC7xIjQMukhieEWt
	 /wXUIAQSnV3Ag==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/7] mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
Date: Tue,  7 Jul 2026 06:50:31 -0700
Message-ID: <20260707135038.90068-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707135038.90068-1-sj@kernel.org>
References: <20260707135038.90068-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C954E20004
X-Stat-Signature: y4jx5harb59yt3otkrmufr7k86gu7d8q
X-Rspam-User: 
X-HE-Tag: 1783432251-652827
X-HE-Meta: U2FsdGVkX1+IcQ03qmCGpKIHQMA1ZeiMJs4TD+33cgsXquoqBsgRwY8nlWaFZ/9hm+NaaHH0+NfInbv4c6ysWNNdmuo2fmmIsmtu6ITdQyrO+LcSngsG5wE87t4GLvG6fWiwhBVcUdDFYAgOiSQyId6JqdSEs1y//d5cL9Ioqk31bdV2bs8zec6ZZHZcsroavYQ1fNCvNrntwXUidqSOfnECo+BNvvH6Sk2YI07cwAetz4baK2/Oo+I/K00V+gm4y0m0NXDjo58XmHc8rdesKWj69st6JlQw7CaXajo1CQUEgtkdd6nHwR2vTs4wTQaigJFSqjSr2oOZBqh7iYMhUBwxkQ5wH89pudNlnCiW6V+xU6pcMi11AVDaooQIMks1ZLcTkVp+y6+em67MK/RjQwOhouZH2z0iyb2DGFg9Ne6t9xSduC1B/9Ax8TOd/t2B+qxu1pSnNjNlhB3ZtbM0E5yOrr+33s3h1d10I3mdTArAeeBzeZBlm36HiMdWXIeC4HFG2tN66NL/20xtv3n1CmN4EtOPf3gfjauVROLnlGuvT2PyERfEs3I10IpqydMFxlalxWCMSVU8esG2tAuso1txS46jLbdBj/3JzyjwDkj9hcStKvk8N9Agkyjahi5OTZb5qFNRvfBipSD6NYTw/yZHXIvrbfjaySvgnPwulUQI7aJUdkT5HXQEWt0DIzVwlLx0ClakTh5NOuUsxncviRaITQvSvAPoLf1ew7eBbWei86NMCPqAIYq7fkmW+8Qe/yW42DA2/o1SkP2hT5qHg6tCMpeEduluZnB3nj/2wio/AtRbJh97TKMYoc7w2uuGIynV5mQKLQO76ZMz5r27ZhknQKKqaUcDbjeNwWS9kb2hsOGXjFroWYcI+gOsgBbUFGe90jvTWldvVysTit142zaLf2f9Z5Yy3RIK/Pz05t3ZfcD8jF3i8Tw78onlX2eyhC0SgKwIWCFUUK99tS8
 i/HTFIpy
 PS7t1zRk3pjRvydaP2BB8x0flD48+Q5HybZwbWS3jHL7IiIcRlOmYZApLn1R1RQzVlFdSmnvRMq44Jaudfrf0w8qC+MJjg8DH13W6ARylS6VJ/L36xZp03ZaRf+VqziZ7ST/F6gcPgS/t9+NVIertx/Q3Hq5+bRCSeBRZ5ycZl/MyN8tIJFnQtn+Y1dp7wJH6Xer+Oqhxx9Uighzcc8VfHkrd6lqqxeyVPwlWgVVS2TqKDDKR4yYnIIk2p/vU9xa1HfVoG6df0FxIs/1oCi2ujZO9xQ==
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

