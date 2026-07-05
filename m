Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F5AC44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074E06B009E; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0258B6B00A1; Sun,  5 Jul 2026 16:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D056B00A2; Sun,  5 Jul 2026 16:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9ECE6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22F66A01C5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
X-FDA: 84955934952.19.D590BD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 967DC40006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OXhq3WFR;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjZe6dIur8LZVZjUeSasJwM4Nl+6WBW38osA+tBK75g=;
	b=JkN6hVNDQefzwgkiZa9EK9p4gpJ+FkV50QIog5vb283P506OOIwPdsglt0y//mDDiJu5vJ
	NTdpCH2ck/hNdfHZwckXwgdgrAiDYVLzmxkk7Dob6bqbnPK4rd6CwsFpNToJhPDrw8Z+Qo
	AQN8nMFWXCOlnMSISojzxHjZ0Kn0ZjE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OXhq3WFR;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285074;
	b=IICM3AGKSXTQJ2z3Vb8ENnd5B4nEpw2IGyg2LfwsSZbgmDHocN8/t9T2GedcHZ6IcRhGQW
	Xk7MBzonwgs+LB9MDlsgWGIDxlX+O2Z3Y5Zgz3TLFNDD4ilHv+agNaUYSOUIGkABfs22Bm
	IrHevgU/Kz1RVk88eKwqE5B45U3R2sw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30D6A600C3;
	Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C131F00A3D;
	Sun,  5 Jul 2026 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285073;
	bh=fjZe6dIur8LZVZjUeSasJwM4Nl+6WBW38osA+tBK75g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXhq3WFRRD+Qdb9qlL/FM82fHPfIUAxYYDGKGQZPuie47BuaRnAQIokWGWDkGsihh
	 8WgnVL5VDsSWMyWhXQ0YLasBhtannrCMQDb435jiCgFJStA2X0eVJdqqUzyGLRuaiO
	 Dj7/m0JjJshctXLF7AYm244c20aYhnbq6MkQkYzxcgvpK+AkzoSugS1reFclCkocMy
	 IkOkeirD++q/SSLscqIiwUnWtA0M8EEVnu9gI4b1jYyjQnk6dK8+CbJwKzphlM2XzT
	 MbbYppdR6flIiV5xPoOPoKaQ78jP/XuLIF//wKFbFCH0KOmqqLDvfrfTpueZvdaCJH
	 YpAe+ElgyLP7g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/16] mm/damon/core: ask apply_probes() ops callback to set sampling address
Date: Sun,  5 Jul 2026 13:57:24 -0700
Message-ID: <20260705205743.98656-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 967DC40006
X-Stat-Signature: 8fxzrjbkq3fb93hyg4tpcttqtheqosd3
X-HE-Tag: 1783285074-597893
X-HE-Meta: U2FsdGVkX19HtHrHjkxifLN7g8k19Zaeq1HMQAzu89a2ls+U/MhNPRMTQhGiW0xECmvYmRzsRzqxoilKhOuh3yAJMw7/ATjaC2XZEJWOlOIviIb6AP3c7+O8QgSHsqH4H1jctnsfYJlCSB3WUELcHf7TaEdWIlotFZsZTpKYlVOELDA16Ki81cpaweyf/bKIRozyJEkI2hIBCtU/sBAiTRiAUn6CqPjEjobBTAfrjiNFr2YQbpdjbhvXKIGdEI+Z+THeRaGdN8s68pA40VdboMetJXj7wP9yATtX2RQRKx9iWpHT6jShM0x7ELLotFvMzsbpJpSSVYZOSzQyz9aQvG7RQgwWkrmuv7vdT9IoA04JJZMlJkitJ5JnubjHZcK9ULlWbX4Ueqm6wNEAUThiBMbyhG6/ohQdI8HaRD/aKwU8JQ1lgSuvG4iyvpGoSWgI2uBfb+09QoOA3A3scoWMbYQ7pbI8fa3vsNnZ3YMHaJPZI/DKkddVS56ySfAz1PhpIVESU2KZY7GDz9GJNlwlSGRVsT4CF1ZRu0fK8SPMo8WbphchjJlljRrf7CB2u41y6jTseGYwU+FEBS3w1GB99lEI7+zMP8RGq+iJr5bNVNtsDeXnejr0+GqH/nfVQrESFL2CeK/7RzgeIut17CqqTf8t9wp/UUs0XqViQiACKBpAgS6UA96bMWphPw7M6TJwSAcBUf43FyEzOL8ckF1m7yNOP+whZ1jr7pP8p4sGDbBY41Vm0K7o+2nCzLL535747D6CCY/oFBmWr2tpdRVOWkSMYOxFl4+4P+/35mEUwSDOasQ5Tpx0PnDeS5VyScRoZVgv6OyM35B4uyfHO+ivhtf3o+PhSMueXDda3FWPi4Lui6XIjplBDp4NL352DniXsukizic/qozzVln85jy/fLRgSZgoj8JdGmrKbnjs+BMcIdEvkViUssm2+lHBv0dUThlNQdPeHW3+qdd00xf
 ERC9HZUM
 S4P3Cli0t/A/6QPfLZ4oSdF0UuKnub1z7j9+TOqmUfnAiq7HknqOpiPN6NwTQjzLMdMepTrqcDfbRZrkiE+/bbsfSd0hvkXiEbGzzYAITlRDRUEYnuGGy2TqeA5xLh6tcF7pbudo1lszoQEHC/44QaivP4mlKPaxrLhfIk0t6g/x2GTDs6jIVHByIZbrIoUqljNjOBpYotEWh4kjzyqofqkCH7DUmDwr5kWmTIVpGQmSlSvxe9Z0ljWxvPUbvizpVmIgCTyHXwoc6Yb0IFIL/zHcz5g==
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
index c9c1de7ec0e7b..4dec5d314c782 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -647,7 +647,8 @@ enum damon_ops_id {
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
  * @apply_probes should apply the data attribute probes to each region and
- * accordingly update the probe hits counter of the region.
+ * accordingly update the probe hits counter of the region.  It should also
+ * &set sampling_addr or each region if &set_samples is true.
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
index ca5c3f3e45fc6..7c0184cb78a50 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3675,7 +3675,7 @@ static int kdamond_fn(void *data)
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

