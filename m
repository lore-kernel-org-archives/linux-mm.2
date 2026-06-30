Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE9AC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B18D6B00A4; Tue, 30 Jun 2026 00:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13AF26B00A6; Tue, 30 Jun 2026 00:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002FB6B00A8; Tue, 30 Jun 2026 00:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF7D56B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E89F167895
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:26 +0000 (UTC)
X-FDA: 84935247012.22.886BC3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 99D52120005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daSBI9Hr;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792504;
	b=R7wWrjkFWMNwOdzrfqUiOJAe9JevOtGu9w9GgG+1A8ZJwNOdqfjDckJpnfj+/dvDg8qurK
	YtaSoxNApt3NXX1JkCt5KYZDdrCYxKen1S32i4O9lfdAyBpskHfkKR05SH2NY2ngJquQ/t
	lg1NO0nzvk+E1fDR8dTeK05bedXwYVE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/qJVmkjnHPk0hozesPjKLZL3BJIw61bUZ5bJBqe7d4=;
	b=7leyuQgGdn98cYz4X5l/Wzrmh2hGKLnjlKzJ6FpANt60dArTFYDxLYu4tyopYa3qnFcy9r
	2sL7G3irIIZbf9wZNEWAW0cdPptXwkJ9odmXZpUaY1NHFU3CKL9X99/+o/zXvkiswf1DEO
	+9FPNKuYhFDPrN6K9MwQLZRGJwo9fVA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daSBI9Hr;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31A09600C3;
	Tue, 30 Jun 2026 04:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B164F1F00A3A;
	Tue, 30 Jun 2026 04:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792503;
	bh=d/qJVmkjnHPk0hozesPjKLZL3BJIw61bUZ5bJBqe7d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=daSBI9HrmyqkDwzZBeMKIn0SiydZ//+l5bANvKsMwAahTNNQThsCKwWIRZr56UAfh
	 0ffWQr++O/IQOCoI/P6umplCSR5xRBN50OaHpJOxOf59okKUCr7klz2IiVoiFuxIPw
	 1z+n6Uw4oP9GS7tVjWn0YhmjJCxZMkYkeJrGBzZhD0+XOEfo6/sod9p3wLDmwLPCZ3
	 9h4xPECmR0I9GisBhI5NGJWFq3ZlBdNU5sCyOOQ4Q2Umx5AVIsGkthEcfP8moHMJPm
	 JO+eXwEF6R8ZkcTpkBwoQjK7r07u5OgFgVwbFCeYtfCAGIrwOPhOLRfq5cs4yfPMAD
	 28COhHE4yat4w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/18] mm/damon/core: introduce damon_nr_accesses_mvsum()
Date: Mon, 29 Jun 2026 21:07:54 -0700
Message-ID: <20260630040812.149729-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: omktxqxdemka6nnk17q8adqrjkkx64jc
X-Rspamd-Queue-Id: 99D52120005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782792504-453283
X-HE-Meta: U2FsdGVkX1+fzjO+rPFLsh6FFb1nd8Y5fkVZIKfu9DnvyL2/vnvQ/irH7WJEu8lLYQp/dMvSaEbBUWGlUNr6zI6DL2WV9PH4sI6U5F5XPBuWeWSO7MLC4hGDRxELOA874tAEFSfPi/Fw9fCxVzy1kHv5kjUggpNkbUzOCv8LbFDBIyoayXm/VThHJfKym5ugUcwCuZcUJZlj4dZmqfCWnZWK2RgZiFAb087zJYrlhTM36vk2rRHWCEGYnXmBzVdR73bvw3EVknPnpX9qGilBJmI7Sx2mT6hodUTjyPkkAmV9D4pq/tbZXIItJbk47Ro73gYcjJJidwUpJtRpeLI9G6lpcIMd/B7fTrH6CMKCVAWA7swTMBPbMxUOwDhPuVg8/y506XOMqFBjukjOUHwrqQXY2s18XI5WuoalSN8kqSymmoJTlX4hNOtuIv9lr+BNICkY+A7y23EtYRkKYeMSGWaAsGtV16cfyeMj4UZig/3fgfy/cRpL/DBTWu6s3jOrHo7zx+sioXaqEGM4rAMUr2j+oyQXMn4IIsy4eGLCj0T7dHD+EWquJUoOM3+oendrBg7aK1uj9Sw4LjSBCgaFf1S1a6/JH8MWAAXTRWV4EfAs2h/9xyvoAYJoHMzHunnFJp+M32qkZk+eXqou900GD2BF2Mo4bEpuGTddImkT4AY2itGSf0YrrB8WZ5W/dG2gdafHaMmd1RHRroziwp6JGhdCbZHl8Khs+NMN5awgJyyJSyCpeVmSEE0EG4H0Rs5U53xRYjNQthPNR0sm7vLAryIoYw8o6HezMY8Zr6o647DzY/efI2ozUbUjDVIyChcgUkBN+Aah+9n02fSmKlhzkxNlBK6bLBYXXQRjuaI6YFAYyZW+fOCMTtl9DqHTrG3AFurI54V5QzvuBL1wBf4CrE1uSzy/+aQ5IA81chAxpI3BO+vBtlTsF2b5mSWRV7AUV6i0+T/wb6VgLpAgttD
 CgAKYYwB
 IUGVWcOvf4UNkBCU0fljgdALRu3PFU4Zl+cs2aOocK0/uLIBd+I4XfF3FxB7WTLzf0NefeuQ7sgFQsnkAVPawnZDdEWOp22RWAT3woHFDwvpXiSIc4+shlxBUtJ0auTppMMeM1GGuxMmLRDdTUCn5x42mx66SELn7DpOLw2XHJjd50nvGqX0e7RN/pocEES9wxt+2Mia3whZH7YI+ziSgm0LlW0EovJrguzCoET/SvMOigy/KK6ZeeCWVs+YArgiE95WW/HqYKF3j4X9GHD7asMGj3g==
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

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 62 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cfbbf8ba28f63..87c1ff479da82 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1011,6 +1011,8 @@ struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
+unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 972a19fcee3ec..c588f943080f9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -208,6 +208,68 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
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

