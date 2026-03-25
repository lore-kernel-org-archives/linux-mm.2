Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374CDFEA82F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B866B0005; Wed, 25 Mar 2026 03:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB1B6B0093; Wed, 25 Mar 2026 03:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C626B008C; Wed, 25 Mar 2026 03:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4466B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:38:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 284985ADC4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:38:20 +0000 (UTC)
X-FDA: 84583782360.29.565C3B6
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16351160004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:38:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fvjLZYLl;
	spf=pass (imf08.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774424298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiDWbq+Vesxlf62C23Hm8indkustIaG2EimGmGm7dUo=;
	b=6XTaUfceg7/UKOF+j7rK8O0sIPqssS9e1r3kwSgSTts+cN2mgvuvAK+TfF+pFOZu9yAzQE
	8Au59N0u9AyURe8nHd/MB2GBV2QznoGaqFoY2e/nXaKfucvoj+iO71KCvvAhqpQFr62zKu
	rbAlQBf/nQdw+t+AiAQPdL0hLO14qAM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fvjLZYLl;
	spf=pass (imf08.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774424298; a=rsa-sha256;
	cv=pass;
	b=g2VZN8le8fzax7zvzLPEwK+lwCU+Zriz/nNi2OXx3cV4aoWRDD8nD0bEn/Q1XmfehtYL2C
	MuZkuA3Oe++OZMzjgTP6tAS8i/kTG9IysKH1YlSvAsqXRkdbM0B4dHfZl2VUxe2MJw5S5X
	QXWCoGGIBWlK4nx2k+g/ILOXi1cdSPI=
ARC-Seal: i=1; a=rsa-sha256; t=1774424285; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=YUzINS5O5bYJ12stM1hz4afv2mWnJwNouWzE9tsnTZwfsF/eo4twLFV1MLog0ODzKPR+tkmtHU8Eqdhjv9NLRcSkQL22vn66WmaAZsyVvHGANpVynkp+a9M6LyONtyW4WtKdjF7II08qVdSkqU7RBsSxVyZRl/nZG9oO4JPy6qg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774424285; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=UiDWbq+Vesxlf62C23Hm8indkustIaG2EimGmGm7dUo=; 
	b=NUMZ631GPwwuMUAfMzWO4/FTB8pp6rxMkVrU/dwxVIs6/RB9ipKwBYIa7GX9DREJbgtvN/2YL9P3GJ3Shgwd8ffiswCDVwJSCWmMTtni3WCgMpL/XkCQQ+grEB398DHEGvVfw+V+RVhDuvHGeAAC+WryF5wsMsqckVsowZSHmqw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774424285;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=UiDWbq+Vesxlf62C23Hm8indkustIaG2EimGmGm7dUo=;
	b=fvjLZYLlsfhzXVv87/zGnHVe1ANmLrP76ixhW6UGJ7FKpYKZyqll5IHXQKv8WypX
	U7liFT/wyr8BdcF0vqJU3AjvthuXoTCW0v0JhJ3cuR1T7i7C8VJiJb0RMmTCBQTAlsi
	ppRTPmPX6USpkm4QEjn3aAYUbGZLrM8N/UxTcA8A=
Received: by mx.zoho.eu with SMTPS id 1774424282494241.87438479042987;
	Wed, 25 Mar 2026 08:38:02 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 1/3] mm/damon/core: deduplicate scheme index lookup into helper
Date: Wed, 25 Mar 2026 07:37:58 +0000
Message-Id: <20260325073800.141756-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325073800.141756-1-objecting@objecting.org>
References: <20260325073800.141756-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 16351160004
X-Stat-Signature: 7drsfnbp7jccbb3pf5tuaqtxiajusmdp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774424297-793512
X-HE-Meta: U2FsdGVkX1/VJU54QOze3NgS8/VLqVOcM5YHpqkGhr4htJB91eLL5EFyVQjbRGw25msNeWDKszCxDT47AdGTFMPeDIIm0sx3EL3Q6p8NZZAZG5VOsqhEjU9krRo/UdhHLXT1Ac7AeycjwXDHDWymz3thwfLJ8/wSSt3Ugg6T6MJI9OlbZpWY9KkXP583fuCcj7PJ3ozwxv+YLsd1DKpZ393KPN8OsnFcuL9AKXZrzvGcLNaNDPLGodZHNdC+zV7wVE3Rv/E7795jPFzkvG09c1KoZEURc1feBlyBtdX617PK2zis/rShxhWp/RQ3HLBDuuqg2avkwJcTjBpnd7p8nJYZXL42+tK9zwRMhseaCmJzMJ2zwKIkVpspHsTmRCFn+3v1xp3MGPnzXRlvJL5ZWvuRjBXEFPRd6zdOHcoWlE/3RFjUOvA/wmKHRPRswT+8f+FxkaS2OWAIkMzGMKY0QsFZ0B+xUdB3JXLGiXsEylYMr633SMUna2hkS3hYiYQfLwU3eIRbyHOLIX+7k+ZH25cslhZK7zSI2FaSTr+leq1QZeRItyLt2LKtNgk9q9PM3QAP1B4t01CdrCDR+4mD0iW6AulPWditu9f33uzKOHjlPs0tjFbVsgycmc8pIv9pcRXsCNBGJmTpfTRPfXB/UZ0oBB+z7lwMHYPXMn/OZYv+J7FmYPlzaZUgphHMbDv02eEM/9VD7rE8t7Z2cuiUq4rmDwIppw1lyFbg8n24uA24GTsLyZiAum0YW5DBFS2R86azIFl6sHHZCgFO56Yl7ah0RZVWu6rlXdwXRN6Fs4/gp5xUl/yR5z5zggK3N1fWzrIKlNiooCcIwNTIVsP+A2F48VzXFo8zW+aqrLECLksI7nFZWvfvug25YOlrrYn0uPUVwI7d2ur2IjNeX0v/1jxgA5fYS3K3H6+GOFXs8mHjrOJ+cbTefvZbV90v9fDGgQmuAYodcg29lE/PTeU
 fd2rFbVw
 keFrs3pJTI4OoCXo4fy2VnQlGF+FifgSMPdAxjGj9pRE8mn9lJH3RFVPYr71TyiacRf2X+ByH4BGAaRN8+26Sc/+Et+tEuMPSsrJ57JRPXeqU0gW7ecKoWHUhqS3Tt7PCJMqqLjxTpRNPiqYBSl9Q9BvuW90nBueVW0xLTfYiUBKk9INZ2iJbnXfmGQ8rHAV0pOtJz3WwlJc9s6C6/cVZBxecCsaI4A6YHpxYe5FRlgvnv0C3eTNyMLggAI1lLzvFHueu+Op42j0EDG2Su3mcUdxa2FsarrhL6xVJsMaGKO+NgJS1d3UomEGhtp5kdd8O6f32hcSaf+uF2swJb3D+AVFbe0u0wyXiPhB0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three functions (damos_apply_scheme, damos_trace_esz, damos_trace_stat)
contain identical loops walking the schemes list to find a scheme's
index for tracing.  Extract the common pattern into damon_scheme_idx().

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6ee421141996..56372e577931 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2045,6 +2045,19 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+static unsigned int damon_scheme_idx(struct damon_ctx *c, struct damos *s)
+{
+	unsigned int idx = 0;
+	struct damos *siter;
+
+	damon_for_each_scheme(siter, c) {
+		if (siter == s)
+			break;
+		idx++;
+	}
+	return idx;
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -2060,7 +2073,6 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	 * index here.
 	 */
 	unsigned int cidx = 0;
-	struct damos *siter;		/* schemes iterator */
 	unsigned int sidx = 0;
 	struct damon_target *titer;	/* targets iterator */
 	unsigned int tidx = 0;
@@ -2068,11 +2080,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 
 	/* get indices for trace_damos_before_apply() */
 	if (trace_damos_before_apply_enabled()) {
-		damon_for_each_scheme(siter, c) {
-			if (siter == s)
-				break;
-			sidx++;
-		}
+		sidx = damon_scheme_idx(c, s);
 		damon_for_each_target(titer, c) {
 			if (titer == t)
 				break;
@@ -2394,15 +2402,7 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 		struct damos_quota *quota)
 {
-	unsigned int cidx = 0, sidx = 0;
-	struct damos *siter;
-
-	damon_for_each_scheme(siter, c) {
-		if (siter == s)
-			break;
-		sidx++;
-	}
-	trace_damos_esz(cidx, sidx, quota->esz);
+	trace_damos_esz(0, damon_scheme_idx(c, s), quota->esz);
 }
 
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
@@ -2469,18 +2469,11 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 
 static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 {
-	unsigned int cidx = 0, sidx = 0;
-	struct damos *siter;
-
 	if (!trace_damos_stat_after_apply_interval_enabled())
 		return;
 
-	damon_for_each_scheme(siter, c) {
-		if (siter == s)
-			break;
-		sidx++;
-	}
-	trace_damos_stat_after_apply_interval(cidx, sidx, &s->stat);
+	trace_damos_stat_after_apply_interval(0, damon_scheme_idx(c, s),
+					      &s->stat);
 }
 
 static void kdamond_apply_schemes(struct damon_ctx *c)
-- 
2.34.1


