Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C896C61DFD
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B046B009D; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5B26B009B; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3356B0093; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF3276B0093
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A91A58BEF7
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:39 +0000 (UTC)
X-FDA: 84469470918.09.7E26E4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0F50EC0007
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYxEcmN7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702598; a=rsa-sha256;
	cv=none;
	b=nNZl5NOqDETovxpGEpr4E71XwZxgzx2PWRQb0H9jzJrMMYRzkjTJcNFIBWy1+TyG+HfjQ5
	DJYoyLAz+0m9pJ+n8WGJAgYK8dT41KOzcM9KrSti7nres6ff84r+yo0Y1lABnSLsBVcsBJ
	u4ODgrEdZkUnpy9S6L7sBNA2bX0gvuo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYxEcmN7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juljmznNLZRE9oG0E81jvfBehhtXa6XwL6ji25A8l9M=;
	b=vrqT8SJz2S79VTpg6g16GuA0SKmMt5xy+3Wv8SDSMbdJYRbMrZrzmI4ZMtoYCg6E7lqqhq
	0hPpHDI5+aDZfOpD4lKdQSvC7M8wYFE+/UhWMLEvXj4I1bbe33zOOKryyWm5kN2/4c6aXF
	g5uLG6oZUJcIUDazsffiVQ+UMigqC2k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3121544506;
	Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F74C19422;
	Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702597;
	bh=h+yGkK1mUlydQHBhuSmFBiMNXZJ33nd1yZsz+jGXjHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYxEcmN7X9Ujj0uCpoyQ+P9KlPERhlBrT8vThzywUA+fvZazJSadEOpAf+Mx1YQqk
	 tLTyJvlbFeH6MMW3i6Y+hS2b7mR4ctodUZgKEz+VrHJREQbtwwfFoQ5lemocCmkabK
	 i/B7G38wQxpfe0fN/bBpxj8azjo6TSTWMlJ8LeOr6Y16LeyDpsNIrMRhKy1lawea+m
	 CbuLuK8r2KU1aKXx0uXERmHwbP1vyiDSe9UytRMgVTvumT8y6kr0gQJhzEx6tt9VAX
	 ELTT48NWJSiY2BqbxQQiNb/xXmfAIwiqn2GXS2fIUYxOAI9miNARy/yu3Owi8LHxOw
	 7doRlHA82ZnMg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/10] mm/damon/core: add damon_reset_aggregated() debug_sanity check
Date: Sat, 21 Feb 2026 11:36:25 -0800
Message-ID: <20260221193629.19332-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0F50EC0007
X-Stat-Signature: cpiu3stdutozz4cnizt8hjt5xmochxxs
X-HE-Tag: 1771702597-396204
X-HE-Meta: U2FsdGVkX1/+ZGM4CCfb7QC7QxhmQzGex5MInKcoR6BVNT5AznUaednmHCNuBL/exK3emJDlxQmnH6LEt1+6j37ogZ2SKiphlB3zDuPKKjLD2FMIEG9qNoKPP+dDl6er0P6gD+xHXkwIRRtlzZZFU1HKirOD3V8PblpVyndqC7OsrTztfxhAO4i/ObcDWH+Gn+zAh37auSe+YTNjxNOqDltakt92GqAuwoH2iV9VF1TlXcfe1lIJG7svNwOYFOCE2HJcIB6vGNBF12bhg8nu7tzpUcl3j/mKFFx090Crupx73HHJvc6QtWY8k/H83Pa8cvMPRv7HlNJGZPlPigENHEr6nXHZDQM/p6H2aFTRFjAoGGJxK89GAutA6z5n6ddKDkiF89pSX9iAgmc1QNc4GUeTxyOLqLodT9olZ8qFeASgQZiYy2c22jLH7ZalI6xTi9pWw7hTnoAYSGMpAUMXD88z60G2MLTNJEFihP601GaNz39W8ex54kfKw2rgrfWMr9ytFgdA9Kw5kRZ783I0jhwlCxYD4I5c4rLCcLQebQbJFE2n0SovFB+aDvpTvL5NqeQ7+bNzVxqJEmCdFUJQ/pwDoJZdMG1AiM6/mX2aw1q8C+rK3U1PMiFpUAraRukgIa6kJNwW3GE6rq/0LbHV+Vi8K9fAvq+aPNRvUyDZmVGWl92knX0VfwC8IaBx+WiqVQQPN7fduzTcvYo28vlV4K2hmLu04srAwc3XmEvVYl8F3IyB+0O7mgaQspNuF3gCWoZRwuHBL5A3XVTdaZH67b8SVLV65ENypM5SNrnC1SLjUu5QVVSXJk0dE+NLSjt5upmGtYqkJvUChBygquQrN71MHaqewq+pNmsWjrErYwsFwsGsRgzq1nPtr7Lj7HbJT3kSMjQtthp9zrc9rAtRini7LCZOEffhY7v1qMVhNwAQy5U5wdCZ0WPz+EOmwBV7BqwSEqS7QRIS7ghGwZn
 oxNSWROL
 wD0wqYdcG8OqpTC7ldFv8ZAH8rBqz/9i1qS0bw0ZK0BqZFj2cA5cTxQCXcI0MJZ1ZE00Z5wPxKUZiXbfE/mbq4/Pdbgmr3wQzJnd2I1pc4B+FNsOSdkllygR/07t7I68/O7j2tCfS4DFbA1qDMoqLSRM2A8rFyOWvuj13xWvPgAOvGwQ2UkJt3D5XENt4fBGk/ccKsfaAUZX5P6B8LgqA1tDLPPB/47sEFM4G523bzjVuku4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At time of damon_reset_aggregated(), aggregation of the interval should
be completed, and hence nr_accesses and nr_accesses_bp should match.  I
found a few bugs caused it to be broken in the past, from online
parameters update and complicated nr_accesses handling changes.  Add a
sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 16f7994903d6d..4efe732e76c69 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1681,6 +1681,28 @@ static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
 	r->nr_accesses_bp = r->nr_accesses * 10000;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_reset_aggregated(struct damon_region *r,
+		struct damon_ctx *c)
+{
+	if (r->nr_accesses_bp == r->last_nr_accesses * 10000)
+		return;
+	pr_err("reset time invalid region found!\n");
+	pr_err("nr_accesses_bp %u last_nr_acceses %u\n",
+			r->nr_accesses_bp, r->last_nr_accesses);
+	pr_err("passed_sis %lu next_aggregation_sis %lu\n",
+			c->passed_sample_intervals,
+			c->next_aggregation_sis);
+	WARN_ONCE();
+}
+#else
+static void damon_verify_reset_aggregated(struct damon_region *r,
+		struct damon_ctx *c)
+{
+}
+#endif
+
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -1697,6 +1719,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
-- 
2.47.3

