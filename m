Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B4BC44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B6F6B00B6; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309906B00B9; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A37F6B00B9; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7FBA6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:06:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B15E1A01EB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:06:13 +0000 (UTC)
X-FDA: 84948093426.21.03AEE4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E758320009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:06:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CY+P8mRk;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783098372;
	b=sJGPzQxRNCBaT3bpqXmIkU4f6p5Fctg+HBpYXO+ZM/SMHLAR6t5tAKbnBHSNReCnUHwh5L
	crg56yRXhsdX1Tm7z3bcjrGwsEn29TgpRKkhcuF9eyv8pBvtqWTlmDnVTCQbjle2SqkEWo
	42npq7EVR0oEpKfO/+q/izd1mc/Fmp8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783098372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gcy9SSkJ7cJu/6jz9kUdhF88DVRVIoJailmK3qTsD+c=;
	b=56KUxxJn5jJ7yk5EldKCz2gL1E7wakkc2Cx4LFYG3HjXKQvqgR+AQblNfIDjfyhNQiSloN
	aD/MQMZIGyfM20vwo71ebYFmaw9bLLLaapgllEcU7hyqJq5cj7kVzTPUcENTLYTWnbQ5WS
	OuPe1crHNCIQk8AWnKmE+4LEqfSOU9o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CY+P8mRk;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F3814399F;
	Fri,  3 Jul 2026 17:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C731F00ACF;
	Fri,  3 Jul 2026 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783098371;
	bh=Gcy9SSkJ7cJu/6jz9kUdhF88DVRVIoJailmK3qTsD+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CY+P8mRkXvwTm1h8+uEnZLKWUSGsJP+g7KFLKExw/zusH2OtmFWTcknvg3fr+MGqS
	 NT8f1io8Lt0RXDKEJ9GliUKcAEqA9CqP8uCGrtLWDZTXE59vLJaaMSS8BxTixYPCup
	 Ijn1uHrGzog/xVlADzoufRfPJYQczPGvx2No2NBttINLyDrwhBvZsdani0Z0+ANhtE
	 RmPhTU7BUvE26hOoEKU1lA/XvId1JudWq0iPE/CDJrpVoz3cBcSSku6VpzOOQANHxJ
	 ZAUlhS61sSv4wLUwqLNKFbE8bTVH/lKj0vJR9RbHKGXzUnBaM8y6BvzwvzbrPY9G5v
	 FwOzpkVpXcVJw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] mm/damon/core: introduce damon_probe_hits_mvsum()
Date: Fri,  3 Jul 2026 10:06:02 -0700
Message-ID: <20260703170605.94472-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260703170605.94472-1-sj@kernel.org>
References: <20260703170605.94472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: kjkmduc7bmp6ac6xn7zg99tcz7jdrx18
X-Rspamd-Queue-Id: E758320009
X-HE-Tag: 1783098371-351715
X-HE-Meta: U2FsdGVkX18+o6iVhKcNbpbO+k40d1rzzZL8axmCDOjdywT+iYkxVL+Lx5ue9Xar9zI7PzG3KC5eRlWHIXP2iJNY6q05UmNaYdeW1MxH/GRqZwvmye1+h6EbsgoB2WlzmOsK28Za1mwntfimPVq7Q0olmCEGiL0vj/kJMc527+vm08nyNroWuW8hlXaaCu4AlevnOoNiDBTvjKpSOmh1eNStgiotps0RuB9JOSJJn5zB6IVnRv+Pz/UeiQGLWxAlOJJJMs9feDAgrPEbSpQ+q0Yl0FsgBA162ebAzMf0S2qMoCuMbADVtTmN7A5MlePfU0DYY+jDfnBN9nW6Vf7CxioXWABDIGr6TNDaNcQ5sX4yOhwoysee1jFDj6hOuWEpn8x8TOe0IKCwO7BwvWPEgdSSe8u3rAUtufTlhYptEEA3pms/nZGHUZ86f6qYi57cg38mbeWC/wj1JUCl6p3Fstueibzawxmmvn1lxd9vIIpp9MoOZpZKe5GE2cAmSxdjXmLr04iSEZapkAOPnMIikm664mkrsZHAM10pkBpD6ChOoYtpU/zysiwT4Ws+7dQ/2lzqVFF24PNcrj+O3XxG1/GwnIYlm1b9l+eXYRzpwfXS/r0kJqVR5CdVmUVcMutcuRP8xMolac34w9RDK2369E06vbztXaWY87wDxHJhTLcALH6nUnZRktzSZ/rBpw7XuzAp6+QloXXqQwW0eoS1AHJmhJUBR/6EpyIwtCk9Lmhs0MPkY1HmA0DfLP/0hccW3n4vOhW91P7r2RAjMg0bg1g705eA1YDH9BCDoO4dA6ATsIdMjnkRACu5iRDpJfqmLhC3X6FyNd++LWP1UBfhfUYr9Z6eyU4Nn8UC6N2rPQFKKiGZsxg59cHf/C2kv9Slo07yg/RtlOSL2+YdbLRkBWXVRHSWCIMsIvvs0w3LYmun0gqWmndpcJVZuFPx6M+Or06i3CmXOVrl4NxApAO
 3FqMBe4O
 LQVykgPWDXLq/ruM2PCMbLIwa64eDHXhp7iBL/9Kzp8aOc/pCRaLp+k6hBv2WUD9wfXH/ptNXyxf3trbu3h4Qx6ROEGf/vttUzT8CpFEvOaDOJZprj5Ybcoaag9r45kX0m1PaQ4lm1gTCLvuWENfar2KtxD4ALnRyMxrqpxE/6WYqPWf1SpCByoS8+tC/8uKOzZwPq3EA0N1LD7FYqaQR0gUeGepO8UjGjFBt9b6mT6WnkhZPbWtArz0r8s0qu6zsNfMyeEWuACK+mDfgYeJNP6wRIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a function for getting a reasonable best effort quality pseudo
moving sums of probe_hits on demands.  It reuses the internal function
for the pseudo moving sum for data access frequency (nr_accesses).

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4f7e305b261c3..616bdf0954b52 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1003,6 +1003,8 @@ void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
+unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d45dc87fbbd9c..871c6f5257c9e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -273,6 +273,27 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 			left_window_bp);
 }
 
+unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
+		struct damon_ctx *ctx)
+{
+	unsigned long sample_interval, aggr_interval;
+	unsigned long window_len, left_window, left_window_bp;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	aggr_interval =  ctx->attrs.aggr_interval ? : 1;
+	window_len = aggr_interval / sample_interval;
+	if (time_after_eq(ctx->passed_sample_intervals,
+				ctx->next_aggregation_sis))
+		left_window = 0;
+	else
+		left_window = ctx->next_aggregation_sis -
+			ctx->passed_sample_intervals;
+	left_window_bp = mult_frac(left_window, 10000, window_len);
+
+	return damon_mvsum(r->probe_hits[probe_idx],
+			r->last_probe_hits[probe_idx], left_window_bp);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
-- 
2.47.3

