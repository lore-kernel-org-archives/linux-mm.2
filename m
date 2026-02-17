Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEDC3E83847
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3594E6B0088; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344AD6B0089; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1C76B0093; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F31A56B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:04:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C6C3160F77
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:04:18 +0000 (UTC)
X-FDA: 84452001396.28.F1D9779
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E9B7640002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:04:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWfNZiS3;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771286657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gt3Q2vGDbt8ycJMT7wMLOlJ1Gtdnctvy83FV4byU0k0=;
	b=DV/8HLHTGX2xRoP3NVpxx4fC65DyRuWnkm4pftZdQGfBNnkVBxfQJ5PZoOPHPr7izSC67H
	daXzEIcSG0EceernaHRVD8GdZwj5aVkwlPhNAsQJ0cCt3T+KoLU8SkKpIgCN/do2zkzeiD
	jpGwHtpTVZzP/ywpw1MtmGiCECISF4w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWfNZiS3;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771286657; a=rsa-sha256;
	cv=none;
	b=rnH5+RxALcoCMvQKGBNG+ioWy1XStMC6hBCbizTF574cWeuvYd0CBqkHABo7HFMpSdfK+z
	VIw5NB5HCpVRDvgDz6wwtW8FLHc4CW0wPeyHnZ5izKziEgLJ0suzCAWZN0WgjLsru8FYWY
	6bUW6xTDci+weSSKTtSRfHUZyz6T8r8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6599444F9;
	Tue, 17 Feb 2026 00:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D63EC19425;
	Tue, 17 Feb 2026 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771286655;
	bh=W6nulmGrrmE7k9MEnSpX5twJqtrvmVNeuzTOrdWQozo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWfNZiS3gY9KlFzteZh2ELLL3hk0S3hE5o3vrCUgBfPuYzem+aAo/GjzMBrcfrW8n
	 pP8+kNhZcgF0xzqNG3JGhl47FQOpYLs88Yj7k6lf6C8Wfn2k+TP+mZrul8ZbSj0Fhz
	 m9XplAoaMk1orhNX0WUT/p5K+HSbkcjIdkc1zTiarQFpLCNpibHg6nwX1hYYSzgFSK
	 S3fbg4nD5zAZNlpEnpRYLHxX3Av39ja0ogAcckKLxdCDFf4N3UGOEAbhp82t8HG8TN
	 jRdi48vEzPB27Umh6/9XWrEM01pGxI/u2y7REeEnLIWaf08rG94KmoJL5pFa2GHXwe
	 Fc1lc+Bdos50g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/3] mm/damon/core: split regions for min_nr_regions at beginning
Date: Mon, 16 Feb 2026 16:03:56 -0800
Message-ID: <20260217000400.69056-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260217000400.69056-1-sj@kernel.org>
References: <20260217000400.69056-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: h57owupx67efdnfbnf4a7kgqaztabkju
X-Rspam-User: 
X-Rspamd-Queue-Id: E9B7640002
X-HE-Tag: 1771286656-668358
X-HE-Meta: U2FsdGVkX1/D+YF1mas5U2DGHwv+gEbVZqjGtnwYsRyQLhIKCt2NLysxTqoQBh9tpV+QFhcixVvohkNUTspGTuuxIqRUdl8CSIVDUASrIR5JbWSsU0uZOHrwH+CBWd8rAW8zwQqXJhWvNGxw7hx3PyTX3vKasjtpEP9OMu8UzR7I0oGUc9XH5nQuzlfah5Vkr7o/7j607+jbYSP33ER4pVqfryu4qWKfx0AwVJH8EbMqMtf5c6BS+rC6k6W5I7O1g3sHNjtKty4eB+8tIoL0op+qMUC+zxpsxdrb90lGo5SRCiYiFzu4US4PhzLPVPslkM2EI/8/xUPCyMWaLDCBIk4z17rSQhmW0H5koUEJqaOMS8B2dV0ET0UiAFksbXBFsuCDQDwLcrVc3IL6W+3NLFx0V0f5MNXVuPdwnL3yRI+go0ufOmX6bVI/xdasmz48jp6tJhidzGeYgha9fZVbE165opW0PQWbBECs4n4OGULOw2L+MyQfF99Io+0d3dd2FmxQDY230MVblQ0MW5r9SZUUTubqazdOguOvV3MiNRIUlMJsX+O66ipux4e/KRAiJ6HWi96wPWZrncCw5Hok/eFR4dDXldLTBgm9DJMFvsePX8Wj3mgilPhwhI2JRaVTbEqk6SDYJwtPeoZ/tVMjIsY6LIFx/wVA628sOOm5FuJXwn/CzmhiBrw2/KP9rh2yNnKKe3gn8MW6JBQcunVQoT59VE/PNJknQv3hQGIJwczwc2F2pXRRFoGHLjXPGGaLfaWsHtAKzeL1dJuEOrYoKtYo9AqA1lI455AhK93vsAz7+Mjx5iN2xUIUb+qIc7DYQdl7FQLL4WAQ+l4XHiSJgAhKBunQ5sj+ZmbOpGMGoyGXQ6GMCPLjfgtKEZS2H5lSVmjzcuhkEvSAO+AKPNGSiRyZRspMP1bQF+/pI89DBB2kE+mS+0I5vTtb/1h8pcAZSjcK5CAuDirbMIUneMI
 gbAZWc5N
 ASYZ2e5og4gUqrY6a+XocpBb3sniHzCDEl5wbjSZ7JtXWIxeYdDZgd4EGDbHgqdEsjcNvc8PD1DsJMws61oJLPDHxH/o9sSKGH0xMoia+BzMMTh8aaHnWT474M0ycC/RGZEkR6wc+fjvjHyXe2Hb+YMQpw8uiPdPTBq5odF90lbezNbAkpNR/u+itWQ+P1ctKsfmFuMTZlvuEXNKw1e+0u4V5Khaeue1ikrjA0o9jK/yhArmqoxIQyjkMDI6Uul05ZORLzEzAmJwEPaP2pR4U+gZ9Ido0KMpfZqOXBmoaAj9c1LU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core layer respects the min_nr_regions parameter by setting the
maximum size of each region as total monitoring region size divided by
the parameter value.  And the limit is applied by preventing merge of
regions that result in a region larger than the maximum size.

It does nothing for the beginning state.  That's because the users can
set the initial monitoring regions as they want.  That is, if the users
really care about the min_nr_regions, they are supposed to set the
initial monitoring regions to have more than min_nr_regions regions.

When 'min_nr_regions' is high, such initial setup is difficult.  Even in
the case, DAMON will eventually make more than min_nr_regions regions,
but it will take time.  If the aggregation interval is long, the delay
could be problematic.  There was actually a report [1] of the case.

Split regions larger than the size at the beginning of the kdamond main
loop, to fix the problem.  This means the behavior is slightly changed.
That is, the initial monitoring regions that the user set ain't be
strictly respected, in terms of the number of the regions.  It is
difficult to imagine a use case that actually depends on the behavior,
though, so this change should be fine.

Note that the size limit is aligned by damon_ctx->min_region_sz and
cannot be zero.  That is, if min_nr_region is larger than the total size
of monitoring regions divided by ->min_region_sz, that cannot be
respected.

[1] https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8e4cf71e2a3ed..fd1b2cbfe2c80 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1316,6 +1316,40 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 	return sz;
 }
 
+static void damon_split_region_at(struct damon_target *t,
+				  struct damon_region *r, unsigned long sz_r);
+
+/*
+ * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
+ * @ctx:	monitoring context.
+ *
+ * This function implement min_nr_regions (minimum number of damon_region
+ * objects in the given monitoring context) behavior.  It first calculates
+ * maximum size of each region for enforcing the min_nr_regions as total size
+ * of the regions divided by the min_nr_regions.  After that, this function
+ * splits regions to ensure all regions are equal to or smaller than the size
+ * limit.  Finally, this function returns the maximum size limit.
+ *
+ * Returns: maximum size of each region for convincing min_nr_regions.
+ */
+static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
+{
+	unsigned long max_region_sz = damon_region_sz_limit(ctx);
+	struct damon_target *t;
+	struct damon_region *r, *next;
+
+	max_region_sz = ALIGN(max_region_sz, ctx->min_region_sz);
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t) {
+			while (damon_sz_region(r) > max_region_sz) {
+				damon_split_region_at(t, r, max_region_sz);
+				r = damon_next_region(r);
+			}
+		}
+	}
+	return max_region_sz;
+}
+
 static int kdamond_fn(void *data);
 
 /*
@@ -1672,9 +1706,6 @@ static void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static void damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
-
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 {
 	unsigned long sz;
@@ -2778,7 +2809,7 @@ static int kdamond_fn(void *data)
 	if (!ctx->regions_score_histogram)
 		goto done;
 
-	sz_limit = damon_region_sz_limit(ctx);
+	sz_limit = damon_apply_min_nr_regions(ctx);
 
 	while (!kdamond_need_stop(ctx)) {
 		/*
-- 
2.47.3

