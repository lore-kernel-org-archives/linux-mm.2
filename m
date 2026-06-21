Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFD6CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F25D6B0095; Sun, 21 Jun 2026 11:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA2F6B0096; Sun, 21 Jun 2026 11:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0166B0098; Sun, 21 Jun 2026 11:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 408B96B0095
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5A8A8E1EA
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:32 +0000 (UTC)
X-FDA: 84904374744.30.FA72659
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2D4ED10000A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q3daSta9;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057451;
	b=nIFw9S9BO2tb0inD0YZeGzQwejuWPtOkXMSWTDVk8TOlDf6t/T188PhtjqzIeKVkHJx1k/
	EA89xS/ZYHW8gyDtQMHdiXDRp63loDOG5mbtpl/zpPLPFo8gcu+yb2zZfb9kJ1Cm+wRCYf
	2dOkmviNpN1JTg7bR7E7V6cvS22I3Ys=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q3daSta9;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9E1resee4yOjiPcdC+iBIVYYZYyLgqakgCWxq9ujB0=;
	b=7EMVHOzmfwkUM4T7qsXmG8aObV1zm3I4+DeGXc2lTLVkZjhOF2ld68uOG/zASlBYGeIolr
	FJDnrh0vBtI3D+E2768RHcd1FLFS7GeAtwdzRVxD1lPfyS22ZL+DFnKLziCqez8IMEz6pr
	4JNK2bD9naFoIce6tEI7pDi4X+kWZw8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B937E601F9;
	Sun, 21 Jun 2026 15:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2361F00A3A;
	Sun, 21 Jun 2026 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057450;
	bh=S9E1resee4yOjiPcdC+iBIVYYZYyLgqakgCWxq9ujB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3daSta9Gvsqg27Bg7drqaNWnxtu9fvMQ/DYJOrnkXVtYoikBNcljPpv7qHFQxuqA
	 D052+zoys0obym5LqyxqvwV83D5IluzUqI3yNNWF9JAKEajQufPCe0mVebhgSF3fFw
	 KM9iD6IQ7mAAbJDWE1FpKSNtckZ9uC/Uh6X7PX240b0PTEaUx0xwSh/YFjgF+SnGqO
	 YKMUhQwBr28s7U3MbKtVqxckQ5nGk4BenJoIFQpTKXqSYxFpY8VmoOPJGjQ48X4oZy
	 KPvmL3cmzXM5l3UoD04SYkKMSxB5eLatCw2xYGrEsdN4riHuSvcVD/beW76Expkw7D
	 6NMBwRF6oc2Bg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 04/17] mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()
Date: Sun, 21 Jun 2026 08:57:00 -0700
Message-ID: <20260621155715.87932-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D4ED10000A
X-Stat-Signature: 6g3t6w4j6ggmiz61xgdb9uf333ys1uwf
X-HE-Tag: 1782057451-199177
X-HE-Meta: U2FsdGVkX18K+MD9qWUKq2r6mLmXHJ6/Lm+FDkln+lCVk/TCkBhlKYovATEcC7ocbYBbw6g733vf1UXF5sHWVplfvP8H4SHs3JsqF4qZVxFn1jHAjMHvoWZQY2uMQDsEDlRWMuDJY4zUlprYCqH+ia43/oVW42sMO6bhH0xPkr8dyJBuLQrLM0Yyou81y8BsbT6CikoNAlS/Tl1NE27k3iI/1Js7OzwbGYEmVgdgYIatXVr0vT3GUZAUDWR19bYgbmycRMDwsCncP668X9WHNe/K9Hrt+ysjGrkwlnN65at/ISmykjyPCDz8A389t5zhyr52Wvrqt5IZKGI0kE77dSVuL+KV9BTRzUBxkg6FbCyDUOgbmxQFhEQyZZ0Oz1ddB/HGQWfjOq92QhDAywyfzTjpA0PfO1yS6/DyzKZvjNYdu9B+k6Lyelj8/DcHX2WFci3vOW/GQaCOurVD57jTcP7yuHR+BiNbToUgMF51wJxmfggarCcVAoFC/Qx0UvsGNujXIxDvdcpN00DF4E6IZd94pW10rpf3MOENobFGkXjbJ2QDEj13ssfrW7MzaG6jpbuv6G8xIlys/XArCBSyhQRK9Iwh9a3+yeePKZsIcmELmDuuEF0Zq4/Ze4AQcUG+9kTeZocFICX2rZM+ECKDGLvauIAUBT0W7GpuM1TxvESAi4z5X2D/DKozMXuIoBwAnb85NbsT0xhW2+Haf9VsIqnj46BcT8JvDnTs4nWhoJjCf62lwMGp3tfOxN9u6dzeU83GF48yUNsXrwedel6l5ftanCuFSgD+zaJSYHqyVt6fmsjnP5p4D6c4yebROogC/uEbkbRQ/SYLA6dnnrLaM9Y9n6XzTpA0xuJGX9nWnce0npBHhEdidyVlwx6m+98/y5gsk3DDmND1brs3V7qzxuPLZXhaNzb6oOcl1JPjgo2P9fWn85RKeblzeVPzJ7IieyIkyaOFKiY7rR8EQ4t
 dOoBTA8H
 QL+rX9hgAEpD0kAWjSlTDHyaWRQHEv0L2+ExqN7L8HGC8x6wBlb7fV8uPFOjB84jd3UkvPUmX8dHJfF4kiJlKRmDKcCBEMLiupyKP87O5exLTrNGGn3bGDJKmjbCgDof1iOJGjSHEXLySJtazQsCFlHBeQhcvXJvSh241ykIAqSRCB9TNGgMTZtmq19oHdKoCQ9IyIRNcIKrNwdqO2/ouhlR4GwiA2rSvsrwib7/60mb69qgjOYD3XzbB3tM/RkLf1M4iyMDBpkP1BvAxw7uuxYTLUA==
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
index 191533685cf2f..8f845bf698b2d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2125,10 +2125,11 @@ static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
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
@@ -2154,7 +2155,7 @@ static bool damos_quota_is_set(struct damos_quota *quota)
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
-	bool ret = __damos_valid_target(r, s);
+	bool ret = __damos_valid_target(r, s, c);
 
 	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
@@ -2740,7 +2741,7 @@ static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
 		damon_for_each_region(r, t) {
 			phys_addr_t addr, end_addr;
 
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 
 			/* Convert from core address units to physical bytes */
@@ -3029,7 +3030,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
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

