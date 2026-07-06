Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D73C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238CC6B00C8; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F926B00DD; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1257F6B00D9; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2B6D6B00DD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BB451C7D9E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
X-FDA: 84958559406.20.855293F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C194240010
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SAIdS8hT;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVcZ8SuySZKn8FngCh9i7p2glWkwmhUsyKwlO1n0BtE=;
	b=lQ+SpkioUKhQFRZeVU7CHlBv3Qirlkbywgco8u9asHaxzWOyiZjRkzWozeiRpRrUOoROgV
	22q1XVMCPAW+W0aBAqZyS8WHrgx3L0P3AcAbIF87WaycKi7x2lnHgYe9MpDs1bYEau18SY
	zEGRyrZMGxAKrOY3zFZoEcprxN7rmlo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SAIdS8hT;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347561;
	b=yhe9z4GU/TkYOgtHzCJ2x2clqMOv0S6jUd4qnG28Tng4a9GBgCK7s2oNhkyPPauG64D3HK
	u9bDeVYgaUfMtFBtXRTh4Psv5bkX9dzFBMdJ+C2g8DGogl2blykuLnMg9OyhFyQWrX4HI+
	+M+e52eNuJhy635pHCc2vy8NAhanos4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F7A76138B;
	Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39811F00A3E;
	Mon,  6 Jul 2026 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347561;
	bh=MVcZ8SuySZKn8FngCh9i7p2glWkwmhUsyKwlO1n0BtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAIdS8hTssa89JMZV7IQawnF9hbg/k0YUk20mV/wVERdNlsMEk6/MeH9UMI2RPnwx
	 BRRP9n/9EzQSAdD96+HTSicVA60PYABIEnlxD42tPu1Zp7U2RvJEbLMN1YKt66Yvu4
	 MIL6iD6p5OWF1uF05R7YmsSfu+BRGUsDzFvueWMXgvTk9wcsLq0zAKexzZP8ormfo8
	 HVmDvxF4qY6mfS+CFs2MZxF34wm8kUNwMYDXo02nmLORCrAhE3CIALU3jT9KXejS2e
	 gkQRYAU3xgXZZQyjID4gCR+/lMGvHeSZ9/ktVjPttub+MRkDVknwdfqrB+eSy+4mza
	 PEHLgZ8dBSQtg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 02/16] mm/damon/core: ask apply_probes() ops callback to set sampling address
Date: Mon,  6 Jul 2026 07:18:56 -0700
Message-ID: <20260706141912.88445-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C194240010
X-Stat-Signature: xiq9e1ijkx98nth3xh1yr5fhmyckcz8p
X-HE-Tag: 1783347561-235728
X-HE-Meta: U2FsdGVkX19xnvxu/Pr2iI9cIoKHuGC7CFQ/wCIMfs7RMyaAvGmQRJqXIgdEUf7Y1hUpY8uaETaFR88+P0COYS+1/uIrLYfkRr1BogFAVRJZce+ryzpQ0nfaSCIy6UfxAHUwiyrgaW9yprUPzkvCgh1T9Exp1pVGTwXRBzAGP/WfctwqUYh0kU6VAv0hFa6ct+hpLk2JzX7Rbm++cwjgauCr5jGbQhhqeQ4D4ww3RQFqtV7LU49HDWg2YEIN5tfFIUa10FTPdGPr5egAk+9KSfYv+zjdGRHcbuKr+ckpcTXlA1aVe0mLLYEVoQK1TJpHr+BZRlnhL/xI4EGspUnxBvoaIC1HvCp4w32AZAWJpsfdCNFNefxDaaMnTGVYlJgf1jKN7A4UMGIoa5KE+8VQEW+fFcyBCnDVTGqV0duCWNYXH6CTYxZ3PlHuOsqGk9wVp6vTya9T1v53+P+OG7WoaLKgg6gyPurLXdbel2gYntgMUqpH20f0S59Dw7IR4eekIJDitMN2BRmv0lxuTWAf+OY1mMiQloT8PsytlsJpGX/TC+0xsQV6w8U+nO78SUpHARqEP+ObjuxBm4WrQMZUJt/OO37yg40ije5r7VcFfsLqpHDTyVXa/AkJ5HfrBB1wr8UyOEv/Jhv+a3aBcYorOFCmubtB2FnrcJcyi3wvfKoljIcOjkyPPxeKPYgbckb1ycNaiLW2stbkWYTeFarA/IpxXhXT6cluXOSTfmvRw0i31ZOKlZfaFwwJ5uJgSB+Vjf+IxnAnFx5o0EM7msHVHOWN6cTvxE4CqSFrFj5Jh3RnwK/9LQzbfddEZ/KTdWwU5pzXRNijOdHvI4hboO46g/Y/9HGGubn7njlxzpJqcVNQOj+ye2hcqBhcgk9SDMVXP24K1bAEtVg1WwkrMi3gACwQGqSbfe7NpuBb8Ch5gd4HYzDbQ9E87/gmdNaJXDZ/Wy7RuqQVqBQkaDLhDGR
 Q4pXRfM0
 yXucRbk7eRC+w/CbtEAXnaycoCtHjkHj7RkgawKDhFB4yYwplWkug296Ycx60rNHR5ru3XrxrnpL8nZBnhN9jjyMHB7ML8+JnwkLlWQE7QzLrMyb6RdGDbB09GzGLOO5UtclF5NdfzlbRNdylUSna5M5mwKas0yf5CWt6ffuFmQeZMR1lz4ekFCUCFlW2ZpZDKR+0x6b2gruLWPMMO2OViLul2G4/MplN4J7w7qOl3cEG5SFH0J1toW0G3ifv+qTqcTz8wsvIosFQnfdChQxZR9paRw==
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
index 7d0a920fe4b83..4aa606f691f28 100644
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

