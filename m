Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C6B3C61DFF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676FF6B0099; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AFEB6B009B; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389476B0098; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBBC6B0099
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5F86160569
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:39 +0000 (UTC)
X-FDA: 84469470918.08.018133B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E00BC0008
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GB4ZFNP8;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpnHw/jCjXPLJG89qp6qwoGPbaap6TrZUg9xRqvK4Vg=;
	b=H6G/9e/Rv59fFmHaDtc2pwXJi0xDyclnBN/o7eOXMa2uS/Y3qMldwbMF4T9Jw3MelxuHdc
	QGk0Kg8fW9gg1F39DhrN3aacMgL7z7bgySa3wVxb0LLBJnfbTyPeIgh0acz1m27EqpynUH
	OTlh4ybrbZ/WdAjcIno6OHii3Rfw+RI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702598; a=rsa-sha256;
	cv=none;
	b=f7UGz2RXs2xkkJaDWgth1HLVLKUKKR83mNTzb96Q32OEl38/FO/Mo77Tsj2QZbixvg/aok
	2djEoW+CBv93+CvYs7UAm09A2hARm5IggTAor3oIAKzxU/dWRfpj6qq2Lb7/DVyn3f7Bm9
	LRn+TQGXVmvk2G/wdMcW3V0CJyL1VXU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GB4ZFNP8;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03ED943A33;
	Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C15AC4CEF7;
	Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702596;
	bh=yfRhExNso4AJw0G3Gu/sbFcwdK0et66BbTZ7++AzIBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GB4ZFNP86ucw+3iCZiFXKFSKc+7g7gQXYBizUVaM6G8Pj5spY5ST9Ekt2IMMeJPSv
	 ujn4pxCagJ8hVsjzpmdB5AZwSv+BwpeYomGyngaJVAhKPUhDJd8kO9Ki1uLpkUDxmU
	 jgl3T2QbmIMMnMw4xG63UgEC6QJojN5Yp4J9vzqz5oR2FZuTREgMJy+sa4+Lq1V81D
	 gBAQD03RWTC+cT/HNkoiWnHNWyY2vmsi+oSCpTobkdBgmdM+q3o3A8r/A4dYmrLOl0
	 rHTj1f43HloJtzgTWOzPQc/ryMrkIP9wNBcf1HzwTyMTO6Y2fbGo5LqWaGMOFuIlcJ
	 1ESR5NKOJQC5g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/10] mm/damon/core: add damon_split_region_at() debug_sanity check
Date: Sat, 21 Feb 2026 11:36:24 -0800
Message-ID: <20260221193629.19332-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: d34q5zxxgbwa43yffkw417eqbugp7nnw
X-Rspamd-Queue-Id: 0E00BC0008
X-Rspam-User: 
X-HE-Tag: 1771702597-81966
X-HE-Meta: U2FsdGVkX1+FyoT6j4NqfAJIOdPAxYFEx7WqPXkTCRRU77yNwC7+Kk6QFWYv328s2C7SqZUul1cXCF8IkFVO75KRnVS7ejrOTFfx8mxXBcwlq8vrjZGl1nR+uvqUga35diHh17PJO5/ul4HSQNNjhCGshc6vOlx3JhP8XVqyzrgeDNBVgv0tpN3GLGghVqJwmbF/Y9rO0O2H3rHE4OeJg+hHElwelN+R1bUIp3Sa7+jJkqZZxvLhxg45jySRDyLSz99LEEHPb+65csDLbv5RUKPhxuuFExFp4mk1ogNBhe7laooaKQMetKzbVUjmqAcH6jjG/cM8BPhPZD9tDc4fAjsbvnolvNTFFzRByTLyEq1EsJl6OAa/Kt3zengkgNDPou1UHOxbtDlX5p86Hw985Pr1meyms8KWp52vHMEXUFiibO1Ah/ITHOa4iQnvc/yeK7NHoge2NguAB45mt42P/xbPDpLzQtG+WZZ7uMIJZp2gphLh4Nsaff3Uh6csntxwRKBNRgFW/Rem7UvYmRS54sVWbdX9F+I9NdLPLGpaJClLDYQxXSAfZDNipEtwC0VGyGDJr0ELNShwPnsXk3ilbYEfj4fl5FfqbEL5DOKb88WljrgWkNR5ezH9tcFlk5CLiEJd1LeaIJq1eTY+BWUAotuQM2kCcQSieIgk23w66YI2YigDbXDcxWoxrpptugcktWKRQZJCc9YPyDhGa5F+d9TeWDd1vcakSxlF5LRooJRwdgg79wNmjiiHzPGz691rNxRh0hbWDgPTPBDFv4PXWxCgMdNS2MMSGwEd3P7XkhOIJHHz8w7Q6DFwQ6+xqGOhqXQplHtvREbDBJzol9cYxaq0wAO8vnaBi2BYFszA4jCQ9Oi4/EsHRCJxgimP59kp2/3ApU1mjikDxPOIOnSIAk7XiDdaph75Hs2KMEijAf+deNJNzuUwV+kbOAjodh6dLc0pn6EfFCAW8p0ETPS
 nCJL26pq
 HZLPMOd1NQvprgk1KA2zhRohMOe67cN04CzAaU/5CRxYMEnYLOQV85lYrKEHX64AJbmHCq0+YnW3FbyBI7oiNw8c5XCqztC0aOssGf0szL920iO3NudGtQWuTnR67IGpP1MRIiwE8t5MvCzEBjYO/2UP8VyG1ZCe8M7Z+jvhNU2Jqy0YT/usqU+PWsDFw6dTrxWS/002+8mtZ+QSeDE9DsMVycrqJtpI7D1u34C2pIsMdEKfBlcTtSTZt8/gD2wnjte5XMwirBQcFrDjoVyjk3GLt6HPWqY0fsmXD3FKS+Yv4mSPnphYl/jMzWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_split_region_at() should be called with the correct address to
split on.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 94be598cafef1..16f7994903d6d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2629,6 +2629,23 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 			threshold / 2 < max_thres);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+	if (sz_r > 0 && sz_r < damon_sz_region(r))
+		return;
+	pr_err("damon_split_region() call with r %lu-%lu (%lu), sz_r %lu\n",
+			r->ar.start, r->ar.end, damon_sz_region(r), sz_r);
+	WARN_ONCE();
+}
+#else
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+}
+#endif
+
 /*
  * Split a region in two
  *
@@ -2640,6 +2657,8 @@ static void damon_split_region_at(struct damon_target *t,
 {
 	struct damon_region *new;
 
+	damon_verify_split_region_at(r, sz_r);
+
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
 		return;
-- 
2.47.3

