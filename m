Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8922AFCC9B0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F58E6B0089; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38F26B0095; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35526B0098; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC5A6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30C43C1ABE
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:34 +0000 (UTC)
X-FDA: 84532654668.24.9F8FC52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF8E0140008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9jXiOPm;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773206972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUyzlPOPA721Z/oUWCbbo6SHT9Z0W6a3h0jjP9ky4nQ=;
	b=XWKKQmnZ55lj8ZO7kXbw20dAUmpyHS1jzM74pHDaLTXGX2BCoWzU5RwzOk4lAvnk7dZgA3
	C4k2ldadiaW0ctbMHELdH6qNK9xi2kcegz7quUs5PRGLmcfotvhseOQoJdSd8t2S2DxF20
	Ztdo8ZcmgXrRTw0DJhZ91+t1AIEA/Jo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9jXiOPm;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773206972; a=rsa-sha256;
	cv=none;
	b=GaADd1rv6UFVUxxP36ppOBH+foMPyd7ZwUwi9XZDkBYut3gzFUUkbP1O3Z/6Osd5FA6/5G
	tkd0gcWbQmXM2szbGdHEG4/FQ8IY7/wsrDqLDPmg5Ah9ABRBMTW7QlAd0jWSKH46K1iDZ8
	OAUd+MQK1U+a3yVg3KP+DS48WPTInrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AD4B6012A;
	Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC00AC2BC9E;
	Wed, 11 Mar 2026 05:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773206972;
	bh=N3PMziG0nx7W5Sw5jivaZWpK/XVFOxMsVgwXy8jopsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9jXiOPmvvWD9+75USBmaiUljjf15lswFDs+RYX2I5WR6ie15weaESToBTDnYeynM
	 twPYsp0Q6NacG2pgCIDbVMDJp4xG2WO5ixUgiNK6K0x4IIgY0g4ThG7RkIdJVT3Eeq
	 l81dkg9efoFCzT2i68P9sbwPbWDKyRE6xrrvrixq8CcdxMUYgQRVFPLkiv8GC3nNu9
	 Ex7FQOuyI5sPLUwu2hLKN0wsoUnkT9tnnWaIJSFHrbFJiArOVumWbgM2AL5AbgOWrT
	 cwVdKEZeXV2yxPVC/tKiI9guFeGLIxGMuN8c8F2k2tgJJdNh+5lcVyRqpOjxrj4if7
	 eRUNkd4Q6ua9w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] mm/damon/reclaim: respect addr_unit on default monitoring region setup
Date: Tue, 10 Mar 2026 22:29:25 -0700
Message-ID: <20260311052927.93921-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311052927.93921-1-sj@kernel.org>
References: <20260311052927.93921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF8E0140008
X-Stat-Signature: hyti9y9hrs3zezpe67bqk33e9td344aq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773206972-428120
X-HE-Meta: U2FsdGVkX1+kfWG/INQ45MYJA6ZcbvFv7BOGhv2bJoE12VkXaV3AR6DwQPkHYUz5abDGP1/FoHAgloerzIK6ANpJVG/aYRTrYTSNIGI48lUxTHBvDy8Ds0CAxfcxy3ZxveOmPIQhrH9XElUEqlElTYXSDsAwNbeLa8GZ5/xpJzVIwSdsu6Kr+I4HQODGIiqQMg+dCCBO2Kv30hvbbFgIuiCOF8dOBo606ivnvuEe/RYKKQP6BqUJkApBCaCfExpGT1kEP+atmh5wK02/HvVPH+IFHekZAqoRfPdDHBAus28c9AQt3YbgWwtkdc6Zpb9HKrfvNXsxoh+MbyJDGUzv4oKHfAi9rx4sg+/XFVxZtDOF85W543yq4hSpvO0ROi7sBWJfP2s6fs5qwnAVhBzGiL+RJ8DlKSWm1ktRGbQYzTHutWohCbvCyvMcf979icwzUGxzAEmq2zlcKWF5yfRDd7AIayYQd0wshDznnV9LiCHKcMS7v7vJoPmC9AB4Wi7J+cGRMK7lwr5CnHad4EYIzoPqVHxbeq/iI/cD0CWh9z5ydGS6Bvhmbt2yAn85cmQtBH7r5eM/bShkvAManuXiV5EImsvKAfOkexht09BZD84s1ogCyfqfwHcCSZOOwGg+t5WTnqp3pW1r5/CuqARCGc+xYbzhC94NLaWomA9rmirl2EQn6iriHzIfQHMrdwM19pG3fCFtRP/qTVyB1w5/22X9BFUmAfr95h9tdTqQh7Gb74c7bGc5YjPCmy4rwJWhsTrvA4TiGlFFgUHdrYzjcT582rq1nw0CfHrOdiig/DKoNlfCe8Nl+EuGMUWMobjoYSp1kqg1QX7IhVY30OHMMmkwlnyio8KzvXrBzPccW9qgnTDuBu6LPGVHukI+RhQ8dQ6NTP87WTWFtj0/03JMidqMZ073ru9iOb21s/c4wzG0Mykn42uHgG/j2Wp4n+GfLGRqpqYAOb8kyMxsNJT
 VWc28WBP
 a8J2m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, damon_set_region_biggest_system_ram_default(), which is the
core function for setting the default monitoring target region of
DAMON_RECLAIM, didn't support addr_unit.  Hence DAMON_RECLAIM was
silently ignoring the user input for addr_unit when the user doesn't
explicitly set the monitoring target regions, and therefore the default
target region is being used.  No real problem from that ignorance was
reported so far.  But, the implicit rule is only making things
confusing.  Also, the default target region setup function is updated to
support addr_unit.  Hence there is no reason to keep ignoring it.
Respect the user-passed addr_unit for the default target monitoring
region use case.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 01f2f6cdbcdfe..86da147786583 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -201,12 +201,6 @@ static int damon_reclaim_apply_parameters(void)
 	if (err)
 		return err;
 
-	/*
-	 * If monitor_region_start/end are unset, always silently
-	 * reset addr_unit to 1.
-	 */
-	if (!monitor_region_start && !monitor_region_end)
-		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-- 
2.47.3

