Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253D8C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E456B0093; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344A06B0095; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5726B0096; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDFDC6B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B17A1A04EB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
X-FDA: 85040405646.04.6418C09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BD0DA40005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAZzZK77;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsKOoYzf/dRz4aZ57YQorCEYYMXi515YQmVG5cvaY7Y=;
	b=twoUJPZacjTI7shlxT80+j7vTSC9hqNTfzDGCbWrZEC+65+Puqh6lcGcY7bijPEvmad8SN
	jIWZEfkREXWk+4EJIHgERwWk6VeTODsAKblizFyCCPiCKFdewbjFHoHzTUaM5AI+V0X9NQ
	/WSzISBPBWID97kvMNrgi6bE2M+h5F4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAZzZK77;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296281;
	b=Vku58DjoieY/HmoWRYd4qnwF+15rE6E42fmh1nqWh/1yZDcZ094KY8v6w0ree1PUIw8OVP
	EPBosQCy3wGwWILM/AzuIOQ6+22QkfEVnJpseiiVY0+Y0qAGk9hULjFR07LBHT9JaQ7c50
	jqZlMsoX6gt55PEdyRafP1QNPTy+KY8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02B3460AA1;
	Wed, 29 Jul 2026 03:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BA51F00A3A;
	Wed, 29 Jul 2026 03:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296280;
	bh=rsKOoYzf/dRz4aZ57YQorCEYYMXi515YQmVG5cvaY7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAZzZK77x+nswa64wnXDcpK+n2mCKX1j8XHH9KUc90NQAIuMpbCdKLNaxyPg5rIBF
	 P+uWdSbPwIzkChgEuNESgryIpJwv23n7Vd2nscDtfgSiW5etj3MKKIXkZOhPZmGK13
	 cXzAqIJ7tT/8VdS2s7OGxrPQrmto9J+ke5eTMocRl0THfcqiopaZoNOV51vCF3YOKQ
	 DFzZ//axiUpwqDTQPHMe1Yt6VI9WTp7rlq+Omfrw9FT7LaUZN0RjOFvT8uYnGqIPTk
	 Afen4/9GEtDivIEs8xfzzmJaFvovph+XhwF91qUfODKskHJOEAIbS+pSy+zLu9buLe
	 DqF7jn08Zkrrw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 02/10] mm/damon/core: remove debug messages
Date: Tue, 28 Jul 2026 20:37:42 -0700
Message-ID: <20260729033751.131213-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD0DA40005
X-Stat-Signature: u1ab415947cyntpz1ars4xoker5g8jsn
X-HE-Tag: 1785296281-179423
X-HE-Meta: U2FsdGVkX19nAwZYIyNkkdwxIAu+goByMqFasUIClj94zCrHlCUn1y3bSLAFbj+GSXARS9cljcyTT85Zig6C0W2pFV0c8Mf9dosAGrz2T2Hu8+4ifIueHzuHqg93zADgH18cYbTklA02qYe4Kv109ydRfzPijkHssXkgyRoTbrDWJkxZ1rTwfG3FbWKtUpagIhwK9oPijDyt9iZRtZaKY0oaGhWS+PbluXj7nbRgXWmwyuehow2FQpmC8Io51pRuQkQ1hOtZgbqNi+Uy3JtPkW4mcZdOyEEg9+hy4vcHrMLHlJ/cpzU6hSY2qlnYU7JzJMBlrOsi+fiQIkj7J+mesiFC94PVbfmvDq+50kJqJeavWhlImK0jOngYPJXdh2DUslVuLlFu/xJFicBAg2MoM9ynUq472vcFQqwgfxj6CafdJKyFUZV21rlK6HRXaqg2ekLjylDnU6u14DKg/HBUOxNCDscVPcbyM8CPFqbP4rvbzTjbW/w9lnE6yqADC1XrApQ+zoks3f3Zr+WowIGHOuj4vCmZisl9XpZqjfE1JCd/jpn/LY2CimlFWQoHcWFgaP5AraF9pSkvADlwIV2R9ZaFJWsdLo2p6j4cBjr/j+HeU9BmooW4uibJlAaNHWsW0WHsVKMalUGg8b3MQuEPxgxLtRshwmIf9+rH0fmEuG53A6AQ50jHAlXpzLISVxkpYX8OPOGciHP3GbIqCDdSq0amUCz8+bQPPjfRD01cWRastqrZF5JyvYGlkyuvgN0FN3TEvr3Th54KtC4/O7ipjBm8fe/C9m5Y01GyG6HasEV76pbdfDjRUC8JubgT9omAX2SKbNWkBiwzwI0gJI3MAIPkQSFyd0wv+6/D+d4aYSLoHyXakYk8AWpMX6tilQfnRcvn/h7MM3xvHiUVMwLJ1E2Pl3ASSioLGLL1KRsNoWDeSI8BpxkmsGeYjtYjnxcQImKtvAs36tO2SP7CJNh
 xd5zzhrK
 q08IZ1iGTqQwlZy3Qkn6W2ZAQcAiQ8kifoW2ZTXNo1oSf/QdJca+3z503H4RFjV1T/TSlCeLDoaCV+kjbc1tI8uojrLSZ1tIJwUBQ8y5JzL5rZOyoCla+rf3VYxUhtAM7bYQDi1F7engfdxedIrIDF236ggThVMm6vPttjoK6gQJD47vNyFjZrp48S8AVaioxiTaS+WgQAyHqx0e5n2GEJQrhVa5FTVcTY08yhcUXnTWVROA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are a few debug messages in DAMON core.  Those have not really
been used in a meaningful way for the last few years, though.  Remove
those.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4169268d94416..1b0f12d17de3a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3693,10 +3693,6 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 
 	/* higher than high watermark or lower than low watermark */
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
-		if (scheme->wmarks.activated)
-			pr_debug("deactivate a scheme (%d) for %s wmark\n",
-				 scheme->action,
-				 str_high_low(metric > scheme->wmarks.high));
 		scheme->wmarks.activated = false;
 		return scheme->wmarks.interval;
 	}
@@ -3706,8 +3702,6 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 			!scheme->wmarks.activated)
 		return scheme->wmarks.interval;
 
-	if (!scheme->wmarks.activated)
-		pr_debug("activate a scheme (%d)\n", scheme->action);
 	scheme->wmarks.activated = true;
 	return 0;
 }
@@ -3850,8 +3844,6 @@ static int kdamond_fn(void *data)
 	struct damon_ctx *ctx = data;
 	unsigned long sz_limit = 0;
 
-	pr_debug("kdamond (%d) starts\n", current->pid);
-
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
@@ -4005,7 +3997,6 @@ static int kdamond_fn(void *data)
 	mutex_unlock(&ctx->walk_control_lock);
 	damos_walk_cancel(ctx);
 
-	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
-- 
2.47.3

