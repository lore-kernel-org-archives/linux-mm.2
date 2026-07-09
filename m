Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA806C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02C56B008A; Thu,  9 Jul 2026 10:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3326B008C; Thu,  9 Jul 2026 10:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9146B0092; Thu,  9 Jul 2026 10:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68C7C6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F18691C7A13
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
X-FDA: 84969412332.24.7D07FED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DBBDC0007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBsgvH0E;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJNYExS7CnlzY009dkSGfruSxfsJLZfZ15sXl05bwnI=;
	b=lE7YWooULZ8nhmhSLSB0RbwMweRxmJeWyMBBCWLUJ0TahiLn4bRN0fqyTOSNbOo5s4yZzb
	l9oa0uiY6CWY1988DNhUkvI8PgC5PjwtiUjUmypbkKKUXe4BSDxvWLwms8ZDL+a88SgpiK
	xufbljLnZof+Px4rPRxsbZcqKD6gf7M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605965;
	b=Rxoj0/qYiqzcp1qpZAkKIB9CVEzXfW98ApMPGFYuiYH1VUBoV7fs3srb7RomS+aOjRcJT7
	aOqSqEpUX2eW3Ugmj0YHcJ8BDLh72XeKs1tiZmlDfx6iTQrbsPYpOVqRf4DrHvePeAHCSf
	TKTQ/WCalK3sqKYLSYyHFv8Bl+IT1Sk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBsgvH0E;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB44B61380;
	Thu,  9 Jul 2026 14:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCC71F00A3A;
	Thu,  9 Jul 2026 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605964;
	bh=jJNYExS7CnlzY009dkSGfruSxfsJLZfZ15sXl05bwnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBsgvH0EWMMjf9mbnDY1TkxSj6Yc5IvgBOeP6z2tDe0akHiqMKPt4R/5kh7QYTd8H
	 nHvVSzwRJ160hNmD9i4x9kMEalX7KimkFX3jv/4gEO6bq7XzwaOcdR89S9DWSx2Q5Z
	 QbYXdTJWLmPhUssnB668gR74pahm7gGjteN4GjOUH77ngXv5fki4u1H0wD5zLb9BBf
	 hl0IteuyWdDpjEi7w0EGVtKlNK6/mS+7tu2PBzDBsW2YzIB/EfID6Xmd7ONJPs4qtj
	 tgwmA3Q0pYrKdFEWTyUKe4y5hmdC/43g6iB3CwmmOQ0pjcx0+nt8MUnt6W8liH9hWi
	 TDRSZPQqe5orw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 02/19] mm/damon/core: ask apply_probes() ops callback to set sampling address
Date: Thu,  9 Jul 2026 07:05:40 -0700
Message-ID: <20260709140600.90950-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5DBBDC0007
X-Stat-Signature: k79jtz5acdhpe5ihbb58osegox34qziy
X-HE-Tag: 1783605965-369179
X-HE-Meta: U2FsdGVkX19pa5rxZL749zZ5ndPRJ0bEVEbwqGr3kZE5fHAhH4rfe+NgG6DVXqKH7fCLfiWMpBfsVfU9iFDsjn61SxUctidp7//KGXMsRS3AFCrTSqj9iASzbNTl82bUiEY986Bs4FPGEH2yrZsAVIQeE/ne3AGUiOJLx52kSMf38+y7goonaamZ/zs3QYOMJU4Vs1smA83SoJVYipwQGEyhWIfE6ilES9DdOAOylYhEs7D1zBQlGONeNQ2epPNQ7lQwg/VHizfJEPFWK+EVE/2zqMu8Y1zA1xaQYGsfLr9q+HubV59ol8VlOkeuIWMxxKiTSHkbxQocS6k9xCAXVjG2b7xkaqVT2bQxDdT+yA9A1zK9lsmkEUjxLxHqfOFVRkBXqAmO7IIQ+0vdvNnYvGL7mXkvLos+ljNZRPmCUM/yMgrERNrCQNLjBe1BF7VNAN9AarvcVam0goXDEZ/PuGRXJISVMF6hwWH4feCJ0vrTx+uXWLpaziJQDhAROrLZ41Vmooh49KhbNrdK1wCCn3VXAGmmiIsUL9ST/osbOD8pu7X0LDu+R8n8yaj9b4GJDEdiZeYkFBToXdX3YNVfDM+waPIRN5idZZLqnzhYdlcfYejTNwm0x/beIZRgrpzT6aXM1WzxG5U51g4yzTzrUzl7/UF4VRnHi6n1r+AJWj3mdMOnZ39cToZeKso7tDDb0sZCRE3C406hKaHS2FqgxHDjsKabouffpyCy39L6yS6rvaZ3ptW2NC1e4u9uyLDlUbMvl4wqnGQPhDHnyvt6pwoMgGxWBLEw/1kjcKgvnCKlC4yJhOHStYoREqxjeg6qEs8VNvoKS0PgivymNWoJtef5wAKTooovvpJCvwN0xe7k93n+9jd5TmAk47wEXLFJAdNmrZeHvr4jjl2thD9mDBMpYeVWyHIf3SHbGQBQzz0cCv+ETw0Ez0aX3zi9OcQhVgQ3YMRjZUJrL8h7pLy
 iecNjWoG
 MmBjjDc2evbNsvjWMDuBJme8aMQcxLbmH1Gx4LQN17tl/jJM2rN+zaCvnFgyvcXuFQMlF9Y5IykSJNbVN0n0KgI6nYc6R5PEAlGaKls9ZAuFuugkkmpCZqRczNL1hRXwgnAAaF0/XUEego85NPeMGgGRokpDrORxjt45o8VN5AH5EqvDNuy4aTmimZlG5R/kslw2Cs9YrImusBp30TU5Gp85dZORrQMLr0jZW3Clj7Yf1pXf0tMd+V2NItz98o0afIv/b2VZpjgp4sECT1H2l76obNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

prepare_access_checks() DAMON ops callback sets the monitoring sampling
address per region.  In future, DAMON will be able to call only
apply_probes().  In this case, applyy_probes() may need to do the
sampling address setup, to minimize unnecessary regions iteration.
Update the protocol for the request.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++--
 mm/damon/core.c       | 2 +-
 mm/damon/paddr.c      | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d8251c83e6e55..3c2a4d673bf62 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -647,7 +647,8 @@ enum damon_ops_id {
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
  * @apply_probes should apply the data attribute probes to each region and
- * accordingly update the probe hits counter of the region.
+ * accordingly update the probe hits counter of the region.  It should also
+ * &set sampling_addr of each region if ``set_samples`` is true.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -665,7 +666,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
-	void (*apply_probes)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context, bool set_samples);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 327398fa4ee56..9fbea6204520b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3692,7 +3692,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx);
+			ctx->ops.apply_probes(ctx, false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 6172464981730..b13bf7c6eade3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -166,7 +166,7 @@ static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
 	return pass;
 }
 
-static void damon_pa_apply_probes(struct damon_ctx *ctx)
+static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-- 
2.47.3

