Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95679CDB46D
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189556B008A; Sun, 21 Jun 2026 11:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A3B6B008C; Sun, 21 Jun 2026 11:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0295F6B0092; Sun, 21 Jun 2026 11:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C39D56B008A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A7308E4A4
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:30 +0000 (UTC)
X-FDA: 84904374660.16.5D8CB1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6BB0A1C0006
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AK8xjqxz;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PW3d+q8npWZrb3x06ugVhBqktV8pPfeMClJh66u1ZQw=;
	b=LbeUFicFhVIdpfk+bnABgqMYblS6sUQ5B3a5u83D4QgpGWU59AjXeR12wsbyJ59twyiZwR
	jjH4xDqSP86mr/uZSoxb6N272xTM4ihgz43EXl5br9BcLPOYvOFSBAkY2XiylLeUQnk7lY
	onkes54B6O5maUrX/Q5PyMkoEEYP8E4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057448;
	b=XifJT5ZAjx3FxdKSSAj51MliLBuBnt5a38OAd773dSIcPVhjxI6+Rtzg+7HzF6GtAUsJ8s
	dbZg8iIbeeCe/rpOZi8RryXp5iuOZLIknQJvUf7/9QVC2rrGcJ8EbfjhutcVXrfPCWNWYP
	FZ041yK0lmh/ZSnvie64acxSCClt7zo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AK8xjqxz;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C1B5442DE;
	Sun, 21 Jun 2026 15:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E811F1F00A3A;
	Sun, 21 Jun 2026 15:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057447;
	bh=PW3d+q8npWZrb3x06ugVhBqktV8pPfeMClJh66u1ZQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AK8xjqxzwnpWyHCFAsOlwp2UMKXeTlfDqKVjoh2Viwy42tMrCO1jRWAriUcZQN72C
	 q8UEFudMqf1RL75lplh2527iVLfrouDUb2T1fve6+wKC9Oi9RrOKOctHMUc7LSAjcW
	 d9UF+EsjwTfCEYlQNIlH0Nr/SvIBRI5gkAIuxFbzxLNTFl00n5RXrt+F+eWdU2J4HW
	 HT7+tmoSTMtiY0zAt710yZl6ayMuKc7BvHY443irpRRl/WHoPQ19uPVMRugaJIXjIZ
	 ubjUKICwcvU+N4FfgOAeTrFShByYUhzQ41LpFmTLN+R+qiNCzJlaaipTEOCtJX/+Nm
	 zOaZDEzlG5HOg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 01/17] mm/damon: introduce damon_nr_accesses_mvsum()
Date: Sun, 21 Jun 2026 08:56:57 -0700
Message-ID: <20260621155715.87932-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aoamj3egsu48nrxtp46pez79ysey31ea
X-Rspamd-Queue-Id: 6BB0A1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782057448-294143
X-HE-Meta: U2FsdGVkX18M/ZsUUranfZGW11YbAB23buqdZ9UEvfcfaLCSD4QDMBHokS1O2byl0oYeV3jxHhf+r0J7EiGI2SYUzDMauL53xxVt2yEB8LqK0H4tw2vl3qW/2yjMsWX+dCfmQTyefsYVmqf9WNWjp2wUivJk3E2ciZeuH/6a+p7v8qg/W22tHzaZvGeSTJKM5x4TKO8WbBWEAG6Ox2jpKR9RclzPcGLKINeIZvVjAfvi5CldPv5TuiT4V11faNU81jyFpeU3L8HPoM/5ezZaXp/fCSFjQ9onpm4J4v1V/NRdIe1JPleWy6SRiNfUdCkNJMrwXcbscX5C+3EangjHfS5JJFmLDFYTj2wt1bFWXS3ax9Cde6E38NARy/lOSzVbieCtNBHHZZUq5HBnHx7ck7WreAtw1yWsgBiPdKjBvyu2dz8luQoA9eHrgpzbwhpcAcYSoBKPVncWbyxw6TN73NQ6S4XmE9n3AWJDg8lPo7z3Yq4hTA4LPQ7qyyqADB3YyfLSR8QVieb2AoNNwqxVHsruUBkwbEMLVaFzr4geuMt7V/kF+pWQ3kP14lPa4Q+08YaX8L7QfCx8XR11/XNs4v35+LqUZj+swQiVNg1kBbqLhROmCETxjSoiuMT3C5KdW1/ZxB+qDOla930p07UEvKEqrfqKcYxhB3pFsyvHzMZ1rc4uJHoRKCpj+SAq771tgnNF6fgAFt6AK0ODyY2oH/hXXtCNNZ00gPZuIX4PTXID6K6ME+rpOoJEv3skTNPrxXEaJzTdLfh6rnuACq96Da7ksrgDQWJ4s5gNp9U5qjaFNPk9mH+PgGat5ZIjlW4QDTiwe7bnsgXepFLpokh1lwHKxHDvI2XU99G8Ue65h7axIB/0bqbGyLSCQpeKWJd4LBcI+X7JbM69n2NeOYXe1yiw8dT89Z+UJsFq7Mivt6D5QRgofcQDMUdvI7JfH8jeJnKdCG2GZDpQypV3nwe
 6kPVqVoD
 z72SOOMkeKJoP5yWTa1TReyTpC6ue1DUn4ogBJk9y5jiwtBwJUWEB+JLqU6tHqJHD7MWAi46Rzy/pzir4z9jcQKsK0qW2XIyz7Bg0l8SyVu9akpZDPjsdVWPukD6JylT85PyRukKiC6jiekSC3kByHEbb2z6IfvbGRzKPQm3m+hLYP2+qLG1yd3i6dvymcpZmlUUrwxTWUWeGwquMxPP79oA9AEgPyn0hbbbRIfxXgoxFZj0xyNJfbI/lU4VReojie5oWV5mEddMo+CFXkdMTBlJ3AQ==
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

