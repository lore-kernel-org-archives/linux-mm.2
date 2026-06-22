Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93139CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B84C6B009D; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569246B00A0; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5E86B00A4; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF4A86B009D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:21:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E9681A01DD
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:50 +0000 (UTC)
X-FDA: 84907762380.02.B4CD76D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6922160017
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tdk2cCzB;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138108;
	b=XgI8jOPo8BLvQRpXLUJ9DespJUxGOWnWb2HXwGizII6ngWmAyf2mAvRZFn+MwggVDM+O6m
	oVZ0wS21kliaulAxjTxoD553Q+yTzsMNJ5SEcYYM5FfyOh2+TZc4OyEk4PWIQA3WbTnazZ
	iuAKcVi9iKrIUpKOo7QreIlrv9i42LI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tdk2cCzB;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PW3d+q8npWZrb3x06ugVhBqktV8pPfeMClJh66u1ZQw=;
	b=7StDZGLZZ36kUjv0k0apPaSMjZvyOrG6bK+0giduuxN2WIlTvaSTPF0d+aOWuVnruYcAvA
	XFY2OywFEL/CbifdoE+d/J7uvk4XacqF/oy7vJudfOc0dvuwE3KgWBr2R/nJCEpXAF+4DD
	lfYexZcnMrITTyjoKA6Kw4vQKKATuV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78B6F601F8;
	Mon, 22 Jun 2026 14:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1281F00A3A;
	Mon, 22 Jun 2026 14:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138108;
	bh=PW3d+q8npWZrb3x06ugVhBqktV8pPfeMClJh66u1ZQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tdk2cCzBg93P7oacSzLnkTDk1fq9ng/UXBC7wn9QkpKie1gvcIw0Tr+RF7b48llf1
	 KjjejimQ6snfZJ5aCQ9Bifd7DShpPkTvNQiCzfBJGogTkpYIwQ9byruYZ5DHybWskF
	 2oZsMkd+z3DH4TjUXGmZTbL4MBiF1U/AxFX21cY/s9vKAHEREsyG7MtcANzgRQv6C6
	 1TQqfyXVtSR0jXhfcRFfWGsTXfmmmomYn0ACESNBCXnAtpJihX7h5+ekQMNigXpml3
	 WQl/9Iaqp4a2rAHtSS3aEcJCi4k8R0RGXF4DsQhPFqKSrkAqrUGrAJy25NMYqkvrrf
	 HlrwZuXSOdkDA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 01/18] mm/damon: introduce damon_nr_accesses_mvsum()
Date: Mon, 22 Jun 2026 07:21:21 -0700
Message-ID: <20260622142139.30269-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fzr45d3uanacat3p81e6dc8hhsc6a9hc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D6922160017
X-HE-Tag: 1782138108-865202
X-HE-Meta: U2FsdGVkX1+D1JBpKnpbl5C9eu0V+CZJS+LeHPCrm7xYs/jWmD8V7GhnYL7Yp3T+zqLFK6x4WIH0SBoCgaaoPX4+DpBHLCwkaSnhW0fUALU07lIZ5ovqS1R2M1XioV1C5kWD7Ayajnq6oAuM+U2a0AR6DknYVPzcuQ5oB8LbhmtxvgFUuiCoYi+nWYl+5TsmxtNk68BfmfDicEcBhKxiNt3SNENkoGyZBwyLYjlavUEgnZNXK6sIqvGHJDlZIe+v8qkxWIbBibAEl1QCKQBgSceabmArHkH6xQDteNMtT5Chs3BO0jV3GO92MYMncrkfi1JkEpVmGWzokRDvRi9W7ubdV/019kboF3nHYxhkYIfvDWJGDvQcYaCwUYtW9BKT3Yt5yNI7HLJMC7YyO20XcO2DVCxizG7jNAOixjp4kGyYGddbOrIsxqzR7/HfygFCHvkAuaynIgy5Q4KYlV/BhfsisbYsLEvnEKOnHLSZDKhfRnxqvlFnpXPj8eOebthAJJCcgD8zqmd0ON1rRSOXoAZb7ovtkamZ4BSrNOi9woiotxZvxKcDBjErN1VHSGHJ3vdEe6xrGUoYVbn7Md59F311mb7QPg+OZZntK+S8h1e7VvRiCAfOCN4GTyz2x7nF5fwxSY02NwsVoN+pL2r6KTkBtQGxVNVy47hQjPRzPwUToWL7zrr+OVajR5XqQSin44yoDONBxFvSVf5NvJMgzL52i0WCSpFS8WPyTF5O8/fph8IxOumzBvZWKxIPjj+mCh5+GxoPpCgrPxAJtnd6PMvTuvJAkeDfMJQ8QkhPbWE3A1SlmXVyAZiQB7v0uz18jC1mmgECxE90X8mXkhKr8OAmPiUGh0NMwca6HzApLcGnffwGWoQSP2bY/ZyVDBgpridpQzDE8kRapIAwX9tfyqC91Xc2yojOgeu2jh9bs4a7tSJbi6kt7F9b67tS8gG6z8mOEcPUjU5Y3XZioUP
 mnqUI1od
 nRKxw4l1+N2djxRdKIfbbcCbRvpoYHmLeWPeGW7Rsi+Kt+v4P67LOpr3dR4gWqxF4lrqA4St5Btc0iQb2PjJi8gm3/KCMdmd4fVn1SDuihXYzK1/1fcz3wv4A7V/2R004VCFAVryM0Vvhxf1LLwqSabrtAkGVXDE3LmObe70LmVJ7k8UleAIcaq6PSCURgO0HPOM/yjnDkTOPckWmA4+F9jHJcDvSqvoPOeffuUd5mn0TzwhNtc2t9wuT9PJMnlGyWZDf8UlGpI+Lk5mfZ1DEkUGRlw==
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
 mm/damon/core.c       | 62 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

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
index 5b84b3ce3fcff..2cc911fa221aa 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -210,6 +210,68 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
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
+	if (time_after_eq(ctx->passed_sample_intervals,
+				ctx->next_aggregation_sis))
+		left_window = 0;
+	else
+		left_window = ctx->next_aggregation_sis -
+			ctx->passed_sample_intervals;
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

