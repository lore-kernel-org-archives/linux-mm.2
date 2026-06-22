Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8585CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93BA26B00AB; Mon, 22 Jun 2026 10:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912896B00AC; Mon, 22 Jun 2026 10:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828BD6B00AE; Mon, 22 Jun 2026 10:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 132DE6B00AB
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C85E61C43DE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:55 +0000 (UTC)
X-FDA: 84907762590.19.9FBF6FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 340861A000F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jB57kba0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lm5wAGpq0Z6XqmRl7W0q3ZWgQYc9A8QPdxb8BfmfLMs=;
	b=gIE9KnNUIqj9k9SVNPSknL75ZzL/8KjBtTB3/e25yr42VnYkyenNHx2pdCl/ALl5FFBl+6
	Q1SKUoBjFfna2yZWtd5e6hM50fhajge4mwRTuYWm5XB0y4qamsb9dj5oQbsiPlsmI4ZjlO
	e85CZblSQtDJL7xwaw65bwzCjq9CcU8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jB57kba0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138114;
	b=B1CtpvSAcKpvUk4BxJmWJMSEanxaazKImTWTRUKxVzr0Jqmxwk4p7WqyqsuKHD2ilpJMbo
	i8KWffGt2Y0Cj84wsNekYf7YgMnBP6QHFGLkbhpGvgPQjKfHWTBw838vwkhktwN/LsVhZr
	6GktUWyzM8tCelwWJdlCfuI7u94bXpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8597A44529;
	Mon, 22 Jun 2026 14:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209351F00A3A;
	Mon, 22 Jun 2026 14:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138113;
	bh=Lm5wAGpq0Z6XqmRl7W0q3ZWgQYc9A8QPdxb8BfmfLMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jB57kba0tQlnTJ+K7ehKkjFZIsdwynDN/cquhdjTv5jVlaGZv9U2NAOLXJboLhoGh
	 jt2kjttE7McYNWnmbXurNuOFJEG1xP/sFf5QP6PPxrcXG/iLgRGmw4c3dIGqGHcejW
	 vW6qZtdUrlsn/Pt+DZNRWYHHb6K2AkcOksjj2ycG7hkOuI0bRWj3VRfUe+jnLP2p0l
	 prFhfvbxx91IAIcra+5oj6g8Ai/pwWCmkleXZnbu6MgRuMXNbki4lR67q5xvoqK6la
	 oDQ5SXPxTTGTKqMxGMCCnHOH08UUCHrj65HXejbXTZk7pVNYLUS+lEdaGUb84qvyu3
	 79FNoJsBVY4nQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 05/18] mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()
Date: Mon, 22 Jun 2026 07:21:25 -0700
Message-ID: <20260622142139.30269-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 340861A000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6zskj3g18gxkr9d1b161a4d9mdez6dek
X-HE-Tag: 1782138114-304240
X-HE-Meta: U2FsdGVkX1+GQzi7LNi65mZia2ihmEm22HlFH6aKeszwcjzkQWPV+iwrJTHRyMhoP8MHXMsufImv5Ga8MFbkWdvqpGSywPdDDCIJ/XTqNrVgB3gOsnajjTV/P2nJCM0KsA/RL+/e6zz3qFbYDLB67EONbr4kv9hAT7YSVlubjWpXwYrjXb82vcUxJR8wVYAZh2jErivBriofzkKDPbX0BZ9Lw+/qqRxdDUiU53Ox1ppn+8G7brDchR/q5WJ8vX98gd74c4Af1EIxDqoo510NC9i0GUtgjuxkxdSk2DjxJ4tE3vRTFDVSLuvqEhrWMzSLP9hdxG4ZYYSs3TIKcz1FImEcl+xscpVpTOPktM3mTUkSrj23oKvx7h8vuiZ32iSUJR2Qu7S0+D2iemM7sZTPsWhVL+wAKfPu6L8e7Ei3KRsDxSyqYnR6vc3HKoMLxPf7KBADQ61I58mrV0iuebbdDNSONYEtTIQ6RADSm4EP51u8or/GpErCb0dnry8kmbvrBjjfK7JyCxTFImmIw2c+vPdZmGBnmZ1hklhSZjHW93yyPymcpsIwf4w2Lb17xUod0/y6j7kVB0w6N5F4zSBf4kSTC9IhkUtGP3xGeSaGwz9Eva8yV5djiQwl2vl9bOvXX+uQ54nlFcuUajRCbqGe1qwtdhzopvWrPl0xgHGnNSgEAdSZz/ssEQ2Nl3sdWbxaDRjxxfiMS4C9fIq/R5Ig8xdHSQGTQRHOtCtI1fSOaO09BAV9ldVhIlZnmk78OrWD/gcAHS3cPzmBRVUZpKcvpO44DtClyis0OFX9M88QneqwtHRW6nfUKUeTliCA4BLrIww8E84BWuUWux/9FEYAXPcAGSPISeC3AeT6ty3ksNi5e2t+LiBSL7FHCb7Z0yJXEFnEzofAF/wg3XDmJJWcicVIIywRpHmcCplNMM5AVqnsY13ElknY16o1rnLDYYOOoLrsIAcgYB4dzC5Xh6w
 Q/9AR166
 JpnGMQlGGiTNVhbqlYIa0hcT0IFYQ2MiGPPcTtyswMyCI01ix9VzrKX9No+dIBJVNEFtFyyBLjDOF/X4g4JnOGtuKOcZFKSaPnwrAAhRIJfAE5OGiJFes2/N3y71Geryl8nf8DiJoY4d6rBYwtXlFdbRZiHr3xFUZYC0RMJ+Z1AMaoEjGAOa1WFu9s2WNEIz/FlX0WZzJ0kEFggUnRwko7Ju1L6gfJERHWVn5MCirIcRf9KzuDAGWbFyjzMwb1FgUOWoNLDdE9vwFp/OiK6ed8Y6HLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors.
Execution of the function would be more expensive than the simple read
of the field, but because the function is quite simple, the overhead
should be negligible.  Use it in __damos_valid_target() instead of the
nr_accesses_bp.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9d501ad34f44c..d6cc538172b40 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2128,10 +2128,11 @@ static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static bool __damos_valid_target(struct damon_region *r, struct damos *s)
+static bool __damos_valid_target(struct damon_region *r, struct damos *s,
+		struct damon_ctx *c)
 {
 	unsigned long sz;
-	unsigned int nr_accesses = r->nr_accesses_bp / 10000;
+	unsigned int nr_accesses = damon_nr_accesses_mvsum(r, c);
 
 	sz = damon_sz_region(r);
 	return s->pattern.min_sz_region <= sz &&
@@ -2157,7 +2158,7 @@ static bool damos_quota_is_set(struct damos_quota *quota)
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
-	bool ret = __damos_valid_target(r, s);
+	bool ret = __damos_valid_target(r, s, c);
 
 	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
@@ -2743,7 +2744,7 @@ static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
 		damon_for_each_region(r, t) {
 			phys_addr_t addr, end_addr;
 
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 
 			/* Convert from core address units to physical bytes */
@@ -3032,7 +3033,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			(DAMOS_MAX_SCORE + 1));
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t) {
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 			if (damos_core_filter_out(c, t, r, s))
 				continue;
-- 
2.47.3

