Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90416F55107
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FB46B008C; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048256B0095; Sat,  7 Mar 2026 14:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67CF6B0092; Sat,  7 Mar 2026 14:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA5156B008C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:49:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7859A1A00FB
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:49:25 +0000 (UTC)
X-FDA: 84520306290.08.631E0FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E722240004
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=emdN8l1G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772912963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFXesOo/zbdxpEDx8ygpS2nuP3FKlH+FucyYhvhi8VM=;
	b=z+Xuq7o+/4nXkax/pH6IJw7s2gP1A6m6qjXjoRO09LeyxdsqlnVsFpj7omXWlUej+Lzvkj
	dPk2tueU+B7yU4yLcI/gVSIyk/LyM9lyIZYg+GoL1++DXfFHwwq1oOViFdUiENndtFI1Gs
	vAJ6pzxxg0Pcmc3zvkj/n4F7NvCYEbc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=emdN8l1G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772912963; a=rsa-sha256;
	cv=none;
	b=Jd9U29H1cZk7rv28oy5hHGMBluR6+K7qRvtVLUQPUWEkE4ZVFoc923m1jiiLP5+RHSEIWz
	Vs8BwM5cnh1i+CwN1nnTYm48E0jEJlbnKPCc+UPMN2yYiqGcazpXxkoq+mLnsocS/gXd+s
	j2ObtSCNIn5WPD3+qVJou+zdODM0uA4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73D2D60053;
	Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4B9C19423;
	Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772912963;
	bh=AJMBL1nNdjGC0+4eccv0L3v64yl/CaBJKvNB19kiMwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emdN8l1GafabJYJm9JIqEG+XGtuLJmZKKmtcfgcPtSLlJwl65IknEczw+BGHKkE/i
	 gNKs0q8kTJbvvKKfgQ2VHnrurATgBPeQ9Ys//vKQ532fgcAcXBmdmxWLGmvcs5kJeN
	 PTLCyp0A/gVhqjpQ/mPNgPzNM0PpGZm+cl5G+mPa/Kw29iM/nrB/xwYKjwZJNXG6Ns
	 vfduOaGcQsNkVXYH9EHqDiRgoJHt5Tq05LJzhSv4X62Gv+65AdUKVwf1q78S1zhqTM
	 fdUjhx+9llwZ3aBJshEaW0b/tlrixr77+w2e1Ais95/95ovQP6Zvq03tZV4n6FdBDT
	 d/3lAanMSBL9Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm/damon/core: remove damos_set_next_apply_sis() duplicates
Date: Sat,  7 Mar 2026 11:49:12 -0800
Message-ID: <20260307194915.203169-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307194915.203169-1-sj@kernel.org>
References: <20260307194915.203169-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E722240004
X-Stat-Signature: io6to81ajrmma45jof8ao6ptt34yxwb1
X-Rspam-User: 
X-HE-Tag: 1772912963-74994
X-HE-Meta: U2FsdGVkX1/lZvkrb/B1xNnBkQjA/Ru6PVNy/4WUlgPsFUrFEv0TyAMp5X11DJ6R3qlQoBv/TEW2gCy/U8yi4YwSgL6l5mwCmeNNEDbQBV3aHV1RuHdY7LBLlaQv/hkpHxG1ORLdpd+uE23WNDBJ3CiGBP64/KEqSBn5zL5ZPy8yb+IhOF6AxYH5H6Ysbqz08c/6SCUbMIaI5SwiW9KG8bUa9zQlvCmb7bplNkOJyZHzDVGGrCFfm7vzuUS2wqlFaMPXZ3NBm9qr8A+ZQWFlyb+pffPyTfELIfiCkceuv6vF2A79w7KwwJaO8ewNWA48MVrh5oBZvDhayLqWrGNhNVQGG0tMUiC9cyEB8tp/kD6w+RNW8CUed46mnrqWGiNxG+eT3T7AQTbjCutDIaoTFS8Crk5a+rXnYFrKFdaZWTMZZwHIaNFO6i3zu0Gad3BNMLVijPNrZiJ9fcmiKKYUVBfuv8zJ+ZLOkrFPTgh1ve7sHVu12zFXT8KYF38wARupiIqPIWsnkgICKA6d2CPGzSizz4tRXqHxuJ2/jItD4S9ugbu8ahEtrwKu+yxr0XuAl8zcEwQKo1uCGFMz60VTDJ2RVPtcL8sy7VuSzdyZ35bBCSBUgFLUv8kYDYbZhsQUgk7XqhG5p4MpofOjcOshKNuDSHY4scpPTkS1Iy5qoaqu5X2r5dmLDqqHomEHe3TeeBROmfJ0YTGxPobtBPLALKGEP20XBbdhb3NgYoWCEY2ac7p9d0w/a1g1a06VZRX0IbrE3fbk+1VvibYRZRyaqDF3QWUayH4i0NPK8WVA52mdwwPGxOeFO/rd29KHcI0VntR3QfFBk0+QikAE91ZonZ2W+Bp44FHowWXHuS1KowLCpplDwjeF+JIsX4uB0f+kY9qeJaY5qh8NSHdKY1BUYeEjOEIa3heiMty1ARUwLKwBWOYD5A2L9mw/gYcbQIzQNINBP6THQKyvAs5Yctk
 HsabZtf4
 jlEFYT6OCImkKu4A7ThEMdI754jpGaqn4l2DX3deZ4yBeOgcCG7VbIe1+Ms6PDh3y9ma40uk4tovVKlspdaN92YKo295t6Lt13alKRpFr4HFZNLv1TWTjqLvk4KEiGNWbWPlKXgvukorwrrDZoUhI4P59IAwzNF7EZN8JXRCWfpmb/kV69ayE0a2xQRhq5EZK8n82jPxmrWHcN2aTW5lrHUcA/AF1wKg12gwEX+9Q7XWPQLv7vLmFepfj7PP4BLQ4v0gjFSEqDWugtztA2gqLJ7CYjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is a function for damos->next_apply_sis setup.  But some places
are open-coding it.  Consistently use the helper.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e8c44541754f7..c4c30824465ee 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2450,8 +2450,6 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damos *s;
-	unsigned long sample_interval = c->attrs.sample_interval ?
-		c->attrs.sample_interval : 1;
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
@@ -2482,9 +2480,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 		damos_walk_complete(c, s);
-		s->next_apply_sis = c->passed_sample_intervals +
-			(s->apply_interval_us ? s->apply_interval_us :
-			 c->attrs.aggr_interval) / sample_interval;
+		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
 		damos_trace_stat(c, s);
 	}
@@ -2858,7 +2854,6 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
 		ctx->attrs.sample_interval : 1;
-	unsigned long apply_interval;
 	struct damos *scheme;
 
 	ctx->passed_sample_intervals = 0;
@@ -2869,9 +2864,7 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 		ctx->attrs.intervals_goal.aggrs;
 
 	damon_for_each_scheme(scheme, ctx) {
-		apply_interval = scheme->apply_interval_us ?
-			scheme->apply_interval_us : ctx->attrs.aggr_interval;
-		scheme->next_apply_sis = apply_interval / sample_interval;
+		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
 	}
 }
-- 
2.47.3

