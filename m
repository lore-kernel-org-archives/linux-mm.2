Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A497ECD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8576B009B; Sun, 21 Jun 2026 11:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EBDC6B009D; Sun, 21 Jun 2026 11:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A3E6B009E; Sun, 21 Jun 2026 11:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC5366B009B
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DA83A02E7
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:37 +0000 (UTC)
X-FDA: 84904374954.06.39C4C86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8C6D9C000A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cW2GoLyI;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057455;
	b=ToERyqUQj+yVQKhimJtHTaQ3zBjoDR/8h133qI/nUSdcsrPbobo0N38PQFI4jSjLKv+Lxy
	oFJS0aPK9Hfs4CnoK/uDrUL4ROjA4MtRxIP3qx9R4VqMQhvY2gzX9sahLCFN0nEmAKGFO4
	IyvRD7iUaX4qMzegTpY94WonT5IRg5M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cW2GoLyI;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/pl2bi5tI7QFS3HurXX2t06T9A2H6ZIRc1GLfHuo8E=;
	b=MIpyrGRrEMUIkIk5gHDzI1k6390VhmWukxgzO4Bieso/WKZmcIYb2Vzn7Hz1yE8tsY4xT4
	uP9eyVIZw4g6JfA8Rv/hjqAz8hCOlGIEZbhL4Z7IeXbAJGZIVNhotXczJFlGLNwKCkBpOn
	0XQRf4oY76jxvuifsuV2U51M/gLmQxY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2485A60051;
	Sun, 21 Jun 2026 15:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89E81F00A3A;
	Sun, 21 Jun 2026 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057454;
	bh=R/pl2bi5tI7QFS3HurXX2t06T9A2H6ZIRc1GLfHuo8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cW2GoLyIwZhzSxBjM55UKe8LNQBbiM6mjjKGIS5BgZbuLVKbyAhzyKvs2HebegsTZ
	 Ch8xWIjjJl+BQI4gqQEV1ENiC5Deq//NlPLugx8jIQn69gZBcWfiHqxPfOnYecDD/N
	 AqE7R5btOOxRZ30u2z8Lg7obzt1s1AN0IY+jmKtf+Kz8EC97Ppz+739WVDYAfjjk/w
	 OKN2rUVkoH/A98Qfv72+EW4RJd+Z8j7GzP4U/vbIAS19dq0Zlb3yA/Ds5p3S7uOmB9
	 ZDJZKcDwY4y3sxzg7dNPeqS/d147Y6d0lsN6Z1l5V4NNo9Fph56avb4lWlY22pp1cA
	 L2ziKBy+93NTg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 08/17] mm/damon/core: remove damon_verify_reset_aggregated()
Date: Sun, 21 Jun 2026 08:57:04 -0700
Message-ID: <20260621155715.87932-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C6D9C000A
X-Stat-Signature: iuhco9j4378d8rw53rzhrhswfobejxca
X-Rspam-User: 
X-HE-Tag: 1782057455-159371
X-HE-Meta: U2FsdGVkX19e+nBkqQEkpJ+9a8yL8ImSoYMEgpWCTWUYKXU5hzZ65Z+6PvGKlxnV69fBtX6az1Vck3Zhs9WwlGyGCHI6OcSZHCBgQGs+SeYYDEAEslQl5vnyPANiAKOSmAecSCwAgKLgL0TY7FM6/CdK7sqMZj4H4gJ4ozUKhRf0NZeSLl/CEWi11AfGWENOpCynxfZ5CSimq7ePttlVXkRDdmw3+KX20Mll7AtFiN2awiNC3voNR+4V+smKD+yySEdOuRIe5SxobiQ465Z6e8PpgnwqKoZSI+qvu+v+c2k3Wd/lVK20kYvvodz9VBVEAwhmKI+6MMINy6Yfhv++K5uNJvNocTMsyA79jNoeAcOEJovJjnA+1Y9COM0NxuLbGRPNRWHCzLLdloWVbXwps1sH6uhYR6VnkIEmyoXnkjLDawpbBSGhDmJf7UyIXM9Ta7WINgY1XBB2CXnchNt6DRMOe/VK0fKB0uhK90nQNQo5c+eO8icCmattQX/obHFX5lkvwR4uJoGifbxNbs0MGk7SAQwjF1vCzDPxjM8RqceV8ndjOkvmzysor/QDFE6WuVi9jTlWdEM5sPZB6TCG3rfhADWzkIKt7Ez3nApkkukngJCs6Xvi53mq6CC4OcjESf0ujA9hVN/yxwkt0SJ9UxNYxNl9Li0vayeLIxYQeN9nIc2WWFhWcehKYGI9d4NtxujvgkptxMAIumulm88g8hHfQTsVKgM6I1ZuOszRmCdd1wjZWDM/XD9oqlXsyXTJheybOdEbBosK26ePTURi0zHUwZo7Iwp/Mg5bRNUivCUK4sHui1F1u1rtFLD+jc8nkW6V2deJdEBzZYEDDDiaN0WF3Cb2S5jsIWukpeItVJU6BAO24kdQtKXaLG4hJrWVRAjgxea4lF8oRGDqwYMm2xd/5SQ0OXTz7K+68fSy0W0DuiugCdWmAPJEHwYxB0uiMv5/lbvXxTpcmpiIyB3
 ovYoGG5Z
 +k6wr4rJJhwqgWSp1RvRWLMp2oZbHcKhYQ4zRibokNvd3Uk/hIJvpKl0fubjJj1VPpEZr4SEzwR6EEF6YmqDbuNwvtQLGKCbPRWl7qhJpiLPUB3RE6EXAa22kDrGYynqoRBMKUICO4nWPV4swg8fPHEWSwUhfZzANwQOi2vG0HuPeCFItgBiZW76JcXKrKfDq+yi2IsuTYXKXlIR4YlRSTKOfq0hPSlPIyzASw1+fQGzFS7or0EnYSF5YMu+ZXGsR/u42WMV/wU++mkJjrNdKBYw07g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_accesse_bp is no longer being used in real use cases.  Remove its
validation function.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1a10eb0694aca..7bb9b3c32d6fc 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1999,23 +1999,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-	WARN_ONCE(r->nr_accesses_bp != r->last_nr_accesses * 10000,
-			"nr_accesses_bp %u last_nr_accesses %u sis %lu %lu\n",
-			r->nr_accesses_bp, r->last_nr_accesses,
-			c->passed_sample_intervals, c->next_aggregation_sis);
-}
-#else
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-}
-#endif
-
-
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -2044,7 +2027,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
 				r->probe_hits[i] = 0;
-			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
-- 
2.47.3

