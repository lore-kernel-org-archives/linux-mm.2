Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D0ECDB46B
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42FB6B0092; Sat, 20 Jun 2026 13:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A5C6B0093; Sat, 20 Jun 2026 13:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57306B0095; Sat, 20 Jun 2026 13:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 767946B0092
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:22:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD9B5A017B
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:22:58 +0000 (UTC)
X-FDA: 84900961236.16.1535F09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4DCFE100010
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:22:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJGVboc4;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLCAfBHDChwPdrWPfXNspXQv9mabG8os1lau8ZVdRzE=;
	b=khu3diJ9cJ/MYtahIcaD0fhFsdG1Dg4btAY1UOuVhb/Nu0cnTov88/HD1kdSgjoOidNRJQ
	EZd3C20CWhT13ZnLYXitXFliUs7W3R7UHNH01b7d1qyVepflstuoU8Ql8iAm3flvxaSpMD
	seWf1hRCqx2m3N01TvaSXSGTfAh/qek=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJGVboc4;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976177;
	b=0LyPotXT6i6QU5xngljKYYCvvhUmJ31y3b4t6faNbIAa/7j8UGYqIQt/L2I6iW41dvk0zV
	mscyxYmkGii4bl1hBlq+H5aQTiOoS5rB+XBfilOKorsus0nDsPaMoClmfiouCsc4QzZWv0
	17hzD365vpI18kHN3QzqCWKzdpxFoJ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFF9F601E1;
	Sat, 20 Jun 2026 17:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EBE1F00A3A;
	Sat, 20 Jun 2026 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976176;
	bh=dLCAfBHDChwPdrWPfXNspXQv9mabG8os1lau8ZVdRzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJGVboc4eLqvEwRRd7VH1UikCMPDDiqQ/Q3H8jvrsgSx9z/5uBL4oTLBg+Bd5UYdM
	 0pBE3j8Fwbw8D7WGZ/gmWpaGxmY/kKjF4zr4lcvie4d/9iuGccdLBxpk3H+rvOo9Dg
	 oPZw8kUoY7RCCJfYviLsK1zd7lWAbiPGkxxNiWMbDTSjqRByRG+x4+TCqTPv+/h29d
	 BpbvSAm8MzwTGrC4Vb+RCVZwOEsdiRGVp3Rh+ZyN1HGKLZF0C8JSM5rs9bD/SHzu0t
	 l6g6cnsEQNkqO/euuD/jBnQgHaG6LrN0srIoFOPMYAZsqrUq5Fi41AlrctzdZGRtEZ
	 YT8cO8Wm7v1bA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 01/13] mm/damon: introduce damon_nr_accesses_mvsum()
Date: Sat, 20 Jun 2026 10:22:31 -0700
Message-ID: <20260620172244.90953-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4DCFE100010
X-Stat-Signature: d7hqmdt13jzy34p5g8bm7p7djwwcu6e7
X-Rspam-User: 
X-HE-Tag: 1781976177-31161
X-HE-Meta: U2FsdGVkX1+L10oiVFGIdwQlrrkAbHCPy8e8J8jrB2Iqv1Wspa+LFs9SpHRHuqTSyMfCh60SKwa79HcBBxF3ZO7vWhJ6vVexnD/47k1C9NCD6I9OLEHOsoO2LkLFuT1JZOAES/VVRJNMlp2ColKOXmyxz/YDbdGFvqXFRoqDaCHHZZWrerNhCoDoe0qxe4Qy6T5QU+lBMcT6Cbp+/KzGiUSF7HScP87qI5AermcfuR9WdxCPPxWSVm5lwQUpSEqXSWz8qvVApqpG/kZCtAtc26peA5t26FYUPYTmSAboCJ01+WHnr7TLMvFWIx+pbRT3192o5dZ1uZXxT9fU5eNKUNi8fLfORrlPFRuIyDgmabpzu1UyDKc/52agr+yqkORbe3ORSyyK7bhgSS4jWIDTLCge5JP0D+0fetFlQ5xMCdU5Es2aOdPclMCp0Y4OQQtexXcomuRtYMq3KMr9rRjGXwk9wIjib7Z6fFMm5ttQVgdHSd26wLq/xf7Jsvc6gkQ8gl1AEtO+5liuKeurK9BJPvpBYI18waeJBJq7i4+oaxvVhxkCH5btL+o395goQciG1ANe7HjyZeO6VkQO3Oc4IHLHeRV6iU2B/E7EBgUmKPbO+Q8JwHNlfFx+2onZS2622fjLMwNVJ+CBWFXLhtXIbecztFWNnSyZzb1M/d5wzN8VeFhIV2nQAcHhAzyboxMrL6yRtxB6E0H8/GsWzAu4TqYtAVIp4F++uSPO4qRaU2oJcO9kS4XnSAEzsEMyiZZEmQCH14CRdtd+hSi6svUqHuD6KP863ths4vaitfX87vm9GghWiEsDKTEeoxRAmUUQi+AuPvD0Fsq9eP2U8D0z8QRx1pBSUPRFrGjsFA3x3grT5pC/PZ0eBiNeADn0p02f6dJht9NeV/jYnkk/6GBmwogNKwd+1cWfqpQXTS8EssbJppCmz5sls98KxdfGeFsRyrCVOEiISSv4e6qBV8J
 s2iJ8NYl
 KYkQ/WY2wJl7jEH9YtTd9rsYkpAeJrRp3F/yjOELM5NMTEeqx8+nqNs2BXsAsNTs4saxRg07vz811dcPTpC/owxMYyRxBUfpNScon/+FKvhEIEczoc++hLOLdQKGA4m0ZeIhRll6tdfFu/mZVWwKX89yjl9RVbZ9WTT6GDjQ43e/FXxCuZGAGKAAkosLRFnn7CWWgK5YdQ1zZuLvIyJBuETxQAgAEnDci2TaQCVUvgXVp9WpU1MnApOYM1AupxDaLldkAFJMOPPgiXth7wzGo/GzCzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON core function, damon_nr_accesses_mvsum().  It
returns a pseudo moving sum value of a given region's nr_accesses for
the last aggregation interval.  The internal logic is the same to
nr_accesses_bp.  The difference is that nr_accesses_bp is updated for
each sampling interval, while the new function needs to be executed only
when requested.  Hence the function's return value is the same as the
value of nr_accesses_bp.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 57 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 02ac34537df9a..55a743d99b567 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1013,6 +1013,8 @@ struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
+unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5b84b3ce3fcff..687aa2ea1d013 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -210,6 +210,63 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 	return NULL;
 }
 
+/*
+ * damon_mvsum() - Returns pseudo moving sum value for a time window.
+ * @current_nr:		The value of the current aggregation window.
+ * @last_nr:		The value of the last aggregation window.
+ * @left_window_bp:	Left time of the current aggregation window.
+ *
+ * This function calculates a pseudo moving sum value of a counter that is
+ * aggregated for each time window.  @current_nr is the value of the counter
+ * that aggregated so far (maybe not yet complete), from the beginning of the
+ * current aggregation time window.  @last_nr is the value of the counter that
+ * has completely aggregated in the last aggregation time window.
+ * @left_window_bp represents how much time is left for the current aggregation
+ * time window in bp (1/10,000).  For example, the aggregation time window is
+ * for every 10 seconds and 7 seconds has passed since the beginning of the
+ * current window, this parameter will be 3000 ((10 - 7) / 10 * 10000).
+ *
+ * The logic assumes the aggregation in the last phase was made in a single
+ * speed.  Based on the assumption, the value from the last window that needs
+ * to be added to the current value is calculated as a portion of the last
+ * value based on the remaining time window.
+ */
+static unsigned long damon_mvsum(unsigned long current_nr,
+		unsigned long last_nr, unsigned long left_window_bp)
+{
+	return current_nr + mult_frac(last_nr, left_window_bp, 10000);
+}
+
+/**
+ * damon_nr_accesses_mvsum() - Returns moving sum access frequency score.
+ * @r:		Region to get the access frequency of.
+ * @ctx:	DAMON context of @r.
+ *
+ * This function returns for how many sampling iterations in the last
+ * aggregation interval (&damon_attrs->aggr_interval) the region was found to
+ * be accessed.  Hence the value can be interpreted as the relative access
+ * frequency score of the region (@r).  The value is calculated as a pseudo
+ * moving sum, and hence it is not an exact value but just a best-effort
+ * reasonable estimation.
+ *
+ * Return: the pseudo moving sum access frequency score.
+ */
+unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
+		struct damon_ctx *ctx)
+{
+	unsigned long sample_interval, aggr_interval;
+	unsigned long window_len, left_window, left_window_bp;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	aggr_interval = ctx->attrs.aggr_interval ? : 1;
+	window_len = aggr_interval / sample_interval;
+	left_window = ctx->next_aggregation_sis - ctx->passed_sample_intervals;
+	left_window_bp = mult_frac(left_window, 10000, window_len);
+
+	return damon_mvsum(r->nr_accesses, r->last_nr_accesses,
+			left_window_bp);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
-- 
2.47.3

