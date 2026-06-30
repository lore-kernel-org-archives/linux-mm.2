Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40961C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395A96B00CE; Tue, 30 Jun 2026 00:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3458B6B00D0; Tue, 30 Jun 2026 00:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DD56B00D1; Tue, 30 Jun 2026 00:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFB2D6B00CE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:15:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74D9D12034A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:15:02 +0000 (UTC)
X-FDA: 84935263644.21.E5EDE33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D57BE40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:15:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fm2y7Hwt;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792900;
	b=uKoF9W6h/BUvV4pBlgJxopiO7mZ1Bsni46eSi5NhegOxLwb1own72Uwul71irCFP5677Zt
	G4BCg0oc/tZzgRi9mgJ7A5HWmzeQN+UawsTTLNNkLOX2/yML6etcH7HTCYQGoz/NNLwOO6
	ttuyfcQR2KA7NZwP05H95yYJq/GPwCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRvSVKzpIplr+7ltnBKnWzHgirAUrH+Vc8lkxFHCvIs=;
	b=Uwxj/5KmZzJmPRZoZ/OiECHC8TYtcJZrHV4wSerEv96bHyIrUC5EiMBBdi0zFicE6TfwYc
	gk43OJyAMEtYQAaPGd9RJWuKI18ZqGrNUyIUfCyoigE6AjBElXeFu7h218Ujn3ElCs12eB
	OjPzKDP4WUvLeBArzlcYEIF5OwDJVqw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fm2y7Hwt;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70BEC600BB;
	Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60F31F000E9;
	Tue, 30 Jun 2026 04:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792507;
	bh=JRvSVKzpIplr+7ltnBKnWzHgirAUrH+Vc8lkxFHCvIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fm2y7HwtO18BzMHkwfFDKSVlC5dpZMxOKTEHA5I1985RY6Oy9+pP9nqvNL8/MG64x
	 gUaoKYRzK3VuzgDWBahW8d7zFVMzT2LTc6gp8zY++mVQbja1eYqot10pMKJXo8R1rX
	 rpZ8X+ocAMS3ran0C0XciYPRDWn+Xyi+8CpiJSIGAO5mJstx322viR0EV3cJYl8+a/
	 fd9K46d0DYq5A71rPJVrbuxXKj71IRutKJiXTbvV9quWUWRsorUKgXm6HEFQ5eYOhw
	 OdHHo2pMQl3dMY1tcb3xa7CJOQBSv7eJ5Z3w2KUzHvvb9FpAiuWFiqN6pPKmz36FhY
	 cm+3pGIlnbmsw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/18] mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
Date: Mon, 29 Jun 2026 21:08:01 -0700
Message-ID: <20260630040812.149729-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D57BE40002
X-Rspam-User: 
X-Stat-Signature: 3sdcroyz3bsctr166cktiaem7btrbrsq
X-HE-Tag: 1782792900-141076
X-HE-Meta: U2FsdGVkX1+yyIdrQFT4crqA6IItF/inkZsCKl5WNe8XnqbSY50VEN7lwVWa2HtxHQxirKRJ7B6MU8ijKxaYBfTxAavDJ3lUecfn4xLbl+cECIzh7IrX2+zRlP7/gWMN7FTUvaBHPR7EnCsVuG5DxjTHWvqRx0JCemJHObV7kLWh9r8gsjalWmAtmRth2b9KyRpNhVdl6unkp+DWO8B3c+Frvh9Dfao3ehS7AZYYF5wAfcg7BSeAKh2DrtJBiJIxKXfpH85MFvFxPneHMPqOhQ+YliE5Os/LQCYYF02bg8PSS52elWl8GmtYG51JOQeEKiZwVaeshCVGi6tTSZhhRAlXg22ya/1QVRH3i/qgqANT1V7lMPmvlOH1N086eidTcSbVebOXUJelRd3XBQnI2Ea+rZwm9fNZ8v5Fuqq6lDEbTeQtwoSjgbKkadh/WWtlbuL+zIbhnEg8sIwVq6v+rLlV9Xt9zfUzTYhyYWMpg9NYxaUAzb3EsttCewWsjFFHdL2ryRoqTuBJzT2ivzvdVvh6eR/JXBcZco/C22a1QBxR52it9f/akf3s5FuEFK65kO8zqCsX8tzfIjx2vN5Jodk5vdgeIMw86JHk8bqa47y/OCqqVmTKiSeDZQ26M+/Rj8bMFJE2J/egDnPiDT8TlZX1RQwl1EicJ2d9qUFqIXNGLV7z+4CxZ3OIfzdzuLNStZ6aWg0xhGvUrWcRVY5HAEXB7t8ijgJ9yDZ89xIe0sE4qQud7Egnt3jnxAFgPQNLG7KSG/zJaNolGaMms+wE6Odnc1woIad9n0dG0uF9WPVl6k9XqOwHZHb6L+uaVoM3UfBBJFKPpdODNkaQd5SFoBYQZC1spREtmczsketUnlJSYGEge7IcxXOD160iKDd/8jPzaG0xNyrVjxYyNIpGhQ5X6gRY9iHAKyLEaWLuJ7K6oVz6IvjQst9po2VXwOMZPTB8Gk5FN7I5Z9qIq6m
 1kdaMqpG
 QrZvh+zKgF0jCjMGyTZUtDrzBU/ADmA/HUhQ4ZZPWifVPk2A2nHzIY3kj6h6n+20T2sMtOhlu6d6aigaaJV0RbkbseMyxSoC1UK2iXsU7qEyUzpIFfZ70SYFTfdMcJElDpigu0QbnUTbAZ1w9FTbmrdMzVm5SV1P0ysAy73P4EZyohmN7yhrRklg+/9AaMO5InUSU/7EmkxFcVM3GkdGf2tkFBZbPdOJT+qwDqPUjpGOxd6pTjGOwMZVM0fNb+0BobwegD56e3dIxk3i+BL1TsEbY+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_accesses_bp is delicate.  Once it is corrupted, the consequence is
the bad madness of DAMON monitoring results.  From developments of
features of size, we historically found nr_accesses_bp can be corrupted
by complicated bugs that are not easy to debug.  Hence we added a
function for finding the corruption and fixing it right away.

There are no more uses of nr_accesses_bp.  Hence the function for
corruption detection and fix is no more needed.  Rip it out.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6423e7417c24b..634708475c01b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2006,19 +2006,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
-/*
- * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
- * the problem being propagated.
- */
-static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
-{
-	if (r->nr_accesses_bp == r->nr_accesses * 10000)
-		return;
-	WARN_ONCE(true, "invalid nr_accesses_bp at reset: %u %u\n",
-			r->nr_accesses_bp, r->nr_accesses);
-	r->nr_accesses_bp = r->nr_accesses * 10000;
-}
-
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_reset_aggregated(struct damon_region *r,
 		struct damon_ctx *c)
@@ -2060,7 +2047,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			trace_damon_region_aggregated(ti, r,
 					damon_nr_regions(t), nr_probes);
-			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
-- 
2.47.3

