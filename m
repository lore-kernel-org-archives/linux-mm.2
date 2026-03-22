Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57E6D58CAC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74556B0088; Sun, 22 Mar 2026 17:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47FA6B008A; Sun, 22 Mar 2026 17:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983946B0092; Sun, 22 Mar 2026 17:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE766B0088
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:43:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4076C8C6C9
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:43:41 +0000 (UTC)
X-FDA: 84575026242.24.F44A581
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id 576FB160007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:43:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=K5up9Nu5;
	spf=pass (imf08.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvZxrK6HT4hT8z9a/s0ePK0Xc63KHmmHo3QU5RxikeY=;
	b=eugn6bTwNDs7EKkH/R/1z8YLPTEbG2+YUKEXkbNu576qwQdrY1MGwGO/YHX0Z5TOmsRR+G
	fwE3oUWfFyp4RFJloXeVjKz3EZCGdtz/rfdQb+Ebh+pw0EHpJe7ccpizI0Hmwam3XKjZOJ
	llvW4kRWC56GOsYhi9Sj94pGc1VsqKc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=K5up9Nu5;
	spf=pass (imf08.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774215819; a=rsa-sha256;
	cv=pass;
	b=eoh/CdJbwWPOmkY7jtygZpy4a3uwf6CDc7RIR7PQEJmPfT0DhpxL95ghME6SGRpjrfnV49
	XF3SotrL8asniX6Tn61Lg7C4orJJR6bMvv7j8XIj6yjiLb9f6TJ8AVWz9XzSP9vfMSLF3P
	r2WgcD6CCu9rQLO3WqSFJu5HfuRdcE0=
ARC-Seal: i=1; a=rsa-sha256; t=1774215808; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=RtEyUM7kF1Wres3ENYxupv8/htOW0w+G2jklTqUcs5ofUO8fTba5/ugxUEXWGPL6FgPGZTxThnyv3H8/IhFNysEZW64ZmUgFDMar+PG7QOZ2e83wWGAddM9huQBr22YqzmJ4GFFQRQmm9Df49NumTFiPVy4D7RzvVB2+cIaRXb4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774215808; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=QvZxrK6HT4hT8z9a/s0ePK0Xc63KHmmHo3QU5RxikeY=; 
	b=gYNnPMSf36jAt+aB0lYRkhbj/VWet/o3d2augd3LcEiyfPxMcQcRasdBjuxlu/sfnsdiBoirEUjJ0ST7J0Npt/82K2xFdH8XEyNiIzBlH46pEuSCLF4pejREoIM7WH4N1FLieo/xlPgbAJuPJuDBkJF38Jk8hNNirwi3uI2cezs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774215808;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=QvZxrK6HT4hT8z9a/s0ePK0Xc63KHmmHo3QU5RxikeY=;
	b=K5up9Nu5/BjQc185idVXkOc9WLuNbJk+gE058sNkDN3qyW6lqYQHurMxU8QbkWZi
	5srI8Njq68sT7B4tqzB91ZHz5Z8UqFbpH0gL+6wrC9MylM6gTBZxNlFIv8lY8mKTYEv
	dHH/jAiSXNER+qZSFcyEgldq8AfO4+wFO2YR2fEA=
Received: by mx.zoho.eu with SMTPS id 1774215806413678.0718747966108;
	Sun, 22 Mar 2026 22:43:26 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v3 1/2] mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme and region loops
Date: Sun, 22 Mar 2026 21:43:24 +0000
Message-Id: <20260322214325.260007-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260322214325.260007-1-objecting@objecting.org>
References: <20260322214325.260007-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 576FB160007
X-Rspamd-Server: rspam07
X-Stat-Signature: aw5a6qpoyxz7fzuqd7h1mbq38tz99pgo
X-Rspam-User: 
X-HE-Tag: 1774215819-172289
X-HE-Meta: U2FsdGVkX1+WmGyHnaF/K19WhabD5+dzR1fCtnYSrqSxa9gVt9/z3tgNpy49kcwZgXPZUWDmAv269278dliNgta5i7UGN0O8BDmMaRRhPO8R8twumG5crf3bGplgI8AARlyGw/vZgP0uC9JSRBJO1GTy01SgrM5DrbwEnuwNqGwtrIB3ZDCCrWu/r9b6s0dA+DLcCMaOgm9Qe+Z9eYDjL0PoJ/ikV8r9WxilcRODRQlBDWkDd74n0npa+1FcBUM2S11LCkayA+ZjcxK04hCntcs0sdU+ws7LUSJAeYX9TjOWHpACBfo9xewjF+n9TDVFkyLrAiirdR+fHXFjdtNgkbiaF13p8MnTfR2iITeAMTf3PG9uzRTGR58N2nz+luUQCBb2jVSKZcfsVlVH41omBOilfSQpjndLIpCOKy0RfV5eUNg0cslknJU9HVo8MmxbH8UVtaZo14DjnqcALXi751KwSJDvnNYtuklbKQO3j2ByQSEs6T/Ae1rPfMYKZQSzuM3O3tqsMm1PZWz8UQBEhIj9dMRnIYR/Pzx6lOJetHd6itzh5C45ftzv85RKIMsYCB4iZFBLPQ1sfMtdJkqxppUx/OGaMEmJElJjH3iMcE9pplNnNdyLWsJwoQryyxLnDkiDDJEiKEKm3733bN7ea0C0P+S2LteADe9fYVVGwTVTyJjgjT89pGlDYAqY4Gay2nXj6TbAnRmymnVg4wJ8aVewf3pEz1dXoYqzWwZMTR+uwkwhvrWyK88LdAJgGRorBuUPzQnX1AI0NJ7ra6G+l2Yua9V2kKQq5nS1Vl4UMvLwUzeZp/UohQ4JKWTTv/c9L218kBKxZlkR8W+PtUxEiWalZsUfGIowVDvGt7L+aCcUp4GsLhSX8X0YVkiyOH6zh5iGNawdzkbYQzSotus5aBwIoM+OscZJt9te6aeX6fsCFp07Y2/pLiHiChYA9umugY91OuGa4YKn3XIBlS1
 HnGQcbiz
 dwsrZmusmeZKPtAYQ+e8QRXWoq/uWhQz1bMcCEMjYeThmW0ZdaBb3h03lqf7UQcRBR0olw8Ajicp7caQKc1SXaofa2swU1iI3mxIujFuj6NN3PF7N6tOsp59GXNjjBVZWpy3Hyy/vzsITvFF4A+KWefMKvv6LuV/pRqBTOhfQGaUduvvRHUMzwLP6jztiewh8E2OwuoyhAj4LNBTyFc1vPuqnFFrowcCW+r5MMy5kdEROFRHE5tAf+vhu/ByvtemINXOyNEQwUP+HJHupq+G4FD7Vwp7GWhWPD4261K9nV5THR26phRWf/5ynVKDfBv8AfI35oYM3BhOGTQ1JLiJZa6T3yIAUA2Po3TlSlenQkqJ74sxPaWQr3nRF7NnO/yXxxPjq41sJpyV3/+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kdamond_apply_schemes() iterates over all targets, then over all
regions, and finally calls damon_do_apply_schemes() which iterates over
all schemes. This nested structure causes scheme-level invariants (such as
time intervals, activation status, and quota limits) to be evaluated inside
the innermost loop for every single region.

If a scheme is inactive, has not reached its apply interval, or has already
fulfilled its quota (quota->charged_sz >= quota->esz), the kernel still
needlessly iterates through thousands of regions only to repeatedly
evaluate these same scheme-level conditions and continue.

This patch inlines damon_do_apply_schemes() into kdamond_apply_schemes()
and inverts the loop ordering. It now iterates over schemes on the outside,
and targets/regions on the inside.

This allows the code to evaluate scheme-level limits once per scheme.
If a scheme's quota is met or it is inactive, we completely bypass the
O(Targets * Regions) inner loop for that scheme. This drastically reduces
unnecessary branching, cache thrashing, and CPU overhead in the kdamond
hot path.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 72 +++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 42 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c884bb31c9b8..a9cfbd6ce3d4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2112,40 +2112,6 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
 }
 
-static void damon_do_apply_schemes(struct damon_ctx *c,
-				   struct damon_target *t,
-				   struct damon_region *r)
-{
-	struct damos *s;
-
-	damon_for_each_scheme(s, c) {
-		struct damos_quota *quota = &s->quota;
-
-		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
-			continue;
-
-		if (!s->wmarks.activated)
-			continue;
-
-		/* Check the quota */
-		if (quota->esz && quota->charged_sz >= quota->esz)
-			continue;
-
-		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
-			continue;
-
-		if (s->max_nr_snapshots &&
-				s->max_nr_snapshots <= s->stat.nr_snapshots)
-			continue;
-
-		if (damos_valid_target(c, r, s))
-			damos_apply_scheme(c, t, r, s);
-
-		if (damon_is_last_region(r, t))
-			s->stat.nr_snapshots++;
-	}
-}
-
 /*
  * damon_feed_loop_next_input() - get next input to achieve a target score.
  * @last_input	The last input.
@@ -2494,17 +2460,39 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		return;
 
 	mutex_lock(&c->walk_control_lock);
-	damon_for_each_target(t, c) {
-		if (c->ops.target_valid && c->ops.target_valid(t) == false)
-			continue;
-
-		damon_for_each_region(r, t)
-			damon_do_apply_schemes(c, t, r);
-	}
-
 	damon_for_each_scheme(s, c) {
+		struct damos_quota *quota = &s->quota;
+
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
+
+		if (!s->wmarks.activated)
+			continue;
+
+		damon_for_each_target(t, c) {
+			if (c->ops.target_valid && c->ops.target_valid(t) == false)
+				continue;
+
+			damon_for_each_region(r, t) {
+				/* Check the quota */
+				if (quota->esz && quota->charged_sz >= quota->esz)
+					goto next_scheme;
+
+				if (s->max_nr_snapshots &&
+				    s->max_nr_snapshots <= s->stat.nr_snapshots)
+					goto next_scheme;
+
+				if (damos_skip_charged_region(t, r, s, c->min_region_sz))
+					continue;
+
+				if (damos_valid_target(c, r, s))
+					damos_apply_scheme(c, t, r, s);
+
+				if (damon_is_last_region(r, t))
+					s->stat.nr_snapshots++;
+			}
+		}
+next_scheme:
 		damos_walk_complete(c, s);
 		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
-- 
2.34.1


