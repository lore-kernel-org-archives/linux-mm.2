Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378C0CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F446B009D; Sat, 20 Jun 2026 13:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13176B009E; Sat, 20 Jun 2026 13:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E015C6B009F; Sat, 20 Jun 2026 13:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC9CC6B009D
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BEA3A017B
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:05 +0000 (UTC)
X-FDA: 84900961530.04.8EDCB9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A1481A0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6wxCoYX;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sujpg8EOXMvmjbaw+/ZJc10siqtH9D9cGIEwTN+7yDA=;
	b=3HXa4A5HJNQowS9FF6JIQXnaTwvMBGi9kA3gHZNbQcBrRP63s+Lsy0AsAgo3DmX7bGHIQ/
	3hQDqtBBkcKZM4w2deAkju6zVpGi7b56waiTN22gtDeqbAI4iZHbvdUyjF/vxvMflxeszP
	BFSWmajtpktjMrH1XNPmDHd9csTst3A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6wxCoYX;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976183;
	b=17uDyygrq5VRDY7qsBr6uflc5uXmkTJBSlu6aKbN9rbHnjU+Lx06PSpCb+ZaOxGK+iDpCb
	zjVid+0LtZ75o9JmsN1yOrt1wtMKGs1/dXdLWN0IvvP4OSaDZhz0gr7h7hn4S0VjoLOJxU
	Co/VwtYMWb59/MXSC6KGcaA4LolKs30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A0C943E76;
	Sat, 20 Jun 2026 17:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AD51F000E9;
	Sat, 20 Jun 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976183;
	bh=Sujpg8EOXMvmjbaw+/ZJc10siqtH9D9cGIEwTN+7yDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6wxCoYXeaugNmXmBmuLBnsrFXDfDWeLHmywRaLuM/D+sPKdlx1OnYMKJK6onA9CB
	 c/GLyeh9IY4Cb+7HAHScmLVUaL2B2Sakh0mplCyc9+7Jd0vH0LNhTjUGAoR0bZ5bLl
	 Tt4vg58ZhTJ5eWgyf95uE15nomiYgUXbqyLpIuRDjd3GvZ87PERXCAyMr3P0sOisSo
	 KtNQIyKiBAwMP55iyCSF00unQTjsXrTCERVHaECOXZyfWnCd8WEopSYduMsECmtsSm
	 d5y6/jLKD+oWtpwOkXuauFlcsfY/m0qjNNmxmGAlzKx6mkuxh8P5OXzSXqJEkwqvsf
	 C+WCS7lXwYyPQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 07/13] mm/damon/core: remove damon_verify_reset_aggregated()
Date: Sat, 20 Jun 2026 10:22:37 -0700
Message-ID: <20260620172244.90953-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A1481A0005
X-Rspam-User: 
X-Stat-Signature: n4t5hu9hrgs6zic16xnxda95r8pta5kc
X-HE-Tag: 1781976183-436286
X-HE-Meta: U2FsdGVkX19clPszPDBgvukKSxC1po4NBZ3R4xpAHYlUkydHHLV9oMDfVZdu5Eb+a+KvYT1C1+IZGRS63QFUU/O3N+7Dgs/VZE9NwchDv2hjIWNnjD681BbXT9opQdT7vUCC6v3ZCrF3ib/BrsBlddhdQdTF+eDu3r+BiGhwg5yHoC0bDrCvTb7oN7nFCEiesTvxaCok2FvbUPGaiqgl2wLhEEiv3//iPmaskzaOzFHtLA/Zpg/mc8TiysfQCGCbxpcwTkzk1Ivnpx0x34nZFsoE8/lpSlzP6vG16WAiN3gU0+yRDU/515H+MrYriCCbYO4auPE2DY2vpRzKo+VJjLj9C0pm1AVZIYI46tPaBZX/bbQfBr4T0Jmg6Umg6lfuibws14pEBM1TacxRUKVT/7SdzkaTi50c+m1e6hKgM9rVUTuEEzWSYejZhHVxJL3yHc/jMFXSFIIYF5XJ0w7wYbsCJkCzJT1XCO7wEcvzkq6GqEVrlAUnvxbu/zGKDgkDtHaac6Oab13ne1lz/Uk9nFZoQddBy8Xqr2nfPStLPJ1U5XgagROiSF8iLFx0o2NMjGZTIQbnnCL0KypPXsxn3Hyl+LCwJ49A8yiD1VUH1idX41Vz4u7zArFTcvQx6qrOZv77IQFVH63WD91h0Q7RSbJ68nQVrGFinFST1TaHB0FO7/hPITn3oVVJmO1yimJDY44piCgyvs4QBbZwTIYqeniqEufeNSGAKxIzGEz7JdrBfQbwiF0Ao4RlifjGpa7AKX9aQCbDXMmYTbu+WbZZSvG2hvIm8pOO4yZIhxm2s0CUNu0yXfIhIOjbFo52hfI1lCjzozJPTkxAp/LO2JjrfwX1T0zcCRMllk+sqB4wZHzjrvgK0XWOFERxArAgKJ5R+I5EwGCh/lsUAOr3PqAw2eHi68E6yuxv/k+j3pQbP5KL8Cwyt5Co9EXlpMb27wLh93t97D6UGyDXMNrqA4L
 kRVmQfw2
 5XcjjKQqFEupOjUMzZF4nCrYwnIKrenPNfparCofxpqXKrcvsEHqU9qr2Ezbp56aezFAnJ6VEqPwS6el4v+2t0TiMfnUMI/sc9inJ4gsA9xaC4AB1Q9DGa8Wd7tAIz0jjZFOGtAcv/e+Cwl4rJkxtpyI4lbf4eu6ljKWE3vaMDMpA76JlHUjNqCm9sG5X9X0qD1z84ZkL4V/XXJDFuMsNU46F+pRLNZNZyXjn/wuztL/1JpGBT/JLsWrF8vmHHOoHr530G+GOh10qefr3Xyh+Vxgdeg==
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
index e144f0079322d..84d21d21ed6c9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1994,23 +1994,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
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
@@ -2039,7 +2022,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
 				r->probe_hits[i] = 0;
-			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
-- 
2.47.3

