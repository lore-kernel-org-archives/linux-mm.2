Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DE9C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDECD6B00B8; Thu,  2 Jul 2026 20:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7906B00B9; Thu,  2 Jul 2026 20:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF34C6B00BA; Thu,  2 Jul 2026 20:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 851C96B00B8
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:24:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC5A71401EF
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:17:31 +0000 (UTC)
X-FDA: 84944493102.06.28CF527
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 183FD1A0006
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:17:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPEK96h9;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783012650;
	b=CPt9sBZFpgelHr8QD1Et45dI4fsVNlGV2kcR+UeMfELld02TCnRX8D/SjlQi+Axwtmqe2k
	LThbj9okvQvrxO5CvRnpV3uzHCAao5Oh5ul69gRyBfW20Er3BZXLLu4FYxN/WEXCUgXVEL
	jBvqhJaAE3NYPUbsaTLYRcHijdd2iD0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783012650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gcy9SSkJ7cJu/6jz9kUdhF88DVRVIoJailmK3qTsD+c=;
	b=78fbxadM/gqfPaoT/yh3XvQ2HvniZ3eqMhMDSXB2IjpSZ3s5o5ofiYYWI95CV+xJDjfmh6
	yWtydtPcAbUr64L007N9pk09kHHqKsyMB2qQUqAyiaG5i9Ss3tDyihtQ5F3WO6W5uqCIrB
	tlS1qNP9yw4qQ3VxNdG2jnKgdrrlwyI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPEK96h9;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9E07601CA;
	Thu,  2 Jul 2026 17:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7831F000E9;
	Thu,  2 Jul 2026 17:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783012649;
	bh=Gcy9SSkJ7cJu/6jz9kUdhF88DVRVIoJailmK3qTsD+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPEK96h95RYUYAI9vrFwZVqQZnsmZiyedlttZzRkAI5rwigEJlcgFd2sT0uYShw3Z
	 3lKk7eSoSK6iQ3a4rGfhLz35SMAv2rUf2V3bhgNo+Bmagdb8PBK/4GRfdTkqyn0C6F
	 2CP2JPeEbUxOuBvGhneAVRcsC7NJUvHu/IhBJZrcHLcJ29r5VJeUGRKELORRXPOYlg
	 2ck8M1kXf8iWjvhRHT3/YzEOhWiu8Qr+xCQhmfER8/y55hLXgS4Lzyo6mOUfNKBpLc
	 AJZ6QcN8RfbvYT3G+ukKaC3P6XuVlrezx6yRWXDjyf0yQUeaUkwfXdOXdjwATcivcz
	 35gqKsVn0Osow==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/3] mm/damon/core: introduce damon_probe_hits_mvsum()
Date: Thu,  2 Jul 2026 10:17:10 -0700
Message-ID: <20260702171714.88278-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702171714.88278-1-sj@kernel.org>
References: <20260702171714.88278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: itam35q5zxpzszemw7cxmsuixbwt189w
X-Rspam-User: 
X-Rspamd-Queue-Id: 183FD1A0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1783012649-608943
X-HE-Meta: U2FsdGVkX18f0ND/P3ZIj7J+HCBOdYluVUKl+jvhIuZSlUzcEW6XepdoasGLgZUEDbnZmNiu3yCDuZGmUGoYZJMnlOw4tiQrnKe2vaWe7n5oESI1Jbk3ziH1UvHEz8x6U2vx7nPlsHI7beDxfEbN5nKg78H5IN7H1NUANGcS6RPqefEG864dDv8U7B2Djz++nGinTxCu3DJ1ab6VB7dmzmNcmVSjQ79PbKoLe9SNAcu5UBJym5PgGmdbGRULQeceVaIP32GOiNvE+FoIJdxWewmu3F9Brbks+UfGboJ4DD4WqdEiTSDjFXMSZluJXqI/Dlp818xwp6lwEp96NGriQqXR5HJvJR1WThht+EoHNaVUTjS9D3PJt8ra85XFLlJfMKZIGXeo+LdbsCRB2EoZ3tKvpxKxlrS+tIjelG4liTcBD5RoyLXppMGkoBdI1jax+6BNGp+unGurVvXfPuvxGSuYs1kE+hvQlWhbeUgRxOMtr2f26LpyS8ysOmcSOFuAaBnSRzarZVjrfGN9dNAp96fF2FzUnNwYiQLJyt7cbop6CZ0af8x4gi2J4bXtEtbGqCwrfVD3oJWiPgl1k/BB1Bqp94lKQQA4LR36k8/N8VCnm8x9E5ExM6aVUi5tWfp6d5pRKfYSeB8bPpa0Hws6vNMMETx6VRRCHlH2OP9wmVHUr0wfVXedbQzBCFNJBmyvGeIXfDxSswJeAd9dFbRSLLQFDQDbcb9dp1iQSct8AxAfLjGKQcvaH3xsKMKuwSTAJchZvMrVcRIXm0aWbm8LThxQfhT+Qx36FlnUIgjsgIH5eTucSrQJDD+J9SIaaXaS5bTqSzKVUuB5LmRRfUehUENAjF/Wo88ChTCtyRsttFlmz5fU+dhBPSm59LSFIKvurZCaEl8hUUITPUYs+A8a7HUXztrzG+c3kxIeAEKn68fvcySMuRGSPDyOxVbt+DGX54k/VDhM4IXcKUatIRG
 NSgNXE1T
 tnUAyzdHW+uiURbfaJHr4tiBpjfThIfATpZa13go31aYAPAFtNUTEX1i2S07hKNuTvigWOptD7Ub6pIB/x8swUobYMNuF9B5i8N+rakJD2deNN3vFtGFDgfAf027PFJk+Mzb9hgHZyI0SRKqB3sE06aMjW8U0vYWod2ky3kHvi/JL7XbAR7Nz/nGPM5bdVFI20Nv8aHYInWZHJ6Rq35Tg8FAJ2N+0PaWWUUStF1k+3ox9YLyvOs0ekl2i7s+w1uoNWr5/HdsUXyu6PtbCo6KgJMbhRg==
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

