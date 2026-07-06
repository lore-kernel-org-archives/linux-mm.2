Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7953C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45056B00D4; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCD926B00D5; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95386B00D7; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2326B00D5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFA68168B59
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
X-FDA: 84958527444.01.D79DEE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 636C8160015
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nP8jNnzr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+1wlgb4/vhq8hic6IHVay1RAoaGPrWWDyvHtZVfeMM=;
	b=As1I3j5py4OJPdbRM/F5PnaYKvtG5UPi8qfJJPWcYVXeefzbJPB4qpupx9hrYfYf4N+gk5
	RznewhDp4BvCKijXv5OqU9mTXoSSsY6wiEde/beVA2/C9PBIblPWIpnW/bdjJ7VmrS1zlK
	RDcQyOmHy5ZgchsA4+Lj6xPtN2l3uBs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nP8jNnzr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346801;
	b=ADhrK0+p1zN5rcDYAT5PS6dUDfOI2yohJ+xU4DRX12XkH9nj9EyJuTRNLgpOFZjS75OXDn
	NUjbtSLdfOoxr7e+9Wwk5n/zlSsvUqlO0VH4xQhFEu9mx+ZSYsAWiwiolvy7DlCsi4f6xc
	zJFigq55YYqK8bL5mtFaQqjAaTowbXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECB776138D;
	Mon,  6 Jul 2026 14:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553B11F00A3A;
	Mon,  6 Jul 2026 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346800;
	bh=h+1wlgb4/vhq8hic6IHVay1RAoaGPrWWDyvHtZVfeMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nP8jNnzrHQhO/Sl4txrZ8a8G2rUVHvePdgstAuB23HFpv2D4bFikH4S7qCc90yVSF
	 y2yvzD4XdYqotlnODfTDIIjPgP4E9BMqbZLehKJUotDaYcC6dBaAZZUoBVqtypgzp4
	 aacA/K5pO1Gq2qgTu9lw+IO9lGN8eqnhYqutPyzc3NWft4uWvciRQehh2VvS6Jb7LT
	 8m56rff6My4FdWzUg/LB0iTBUvNfezd7RRmGT0FXVCPqxzaEk5Q+OC+DBXI3h2LJ7b
	 9jAynr5pHpRq8ua6h7Fun5wFVBaBe3DK7pgbiDmZVgjeWsjanT1nvptrbJdgvR8vWj
	 DJPBnYCdBwiyw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/11] mm/damon/core: change damon_stop() return type to void
Date: Mon,  6 Jul 2026 07:06:22 -0700
Message-ID: <20260706140628.87414-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 636C8160015
X-Stat-Signature: i1kexxgc7zddwuxnyok71idk3qpk4adn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783346801-997147
X-HE-Meta: U2FsdGVkX18IrpY4Bh/LPKwwZkoC1M/VuQy0XzptQc6uDI6O6K8XdyzbZccMeuXRLopbZUNc3r7nlscP0boYXaN4K8TLuUIq3kXycKqCe8D0eIiKWX8n+bbjh22eNye7xjp7M8GP2MOrTSOEIP4AhHZAY02ydGwHqTHiJxAsa17Xacn+jvKf2GNHqr72bjw6lcCjmvGTX5rjs+gRJ9d3czEcHvWZVsY2PS38PpXYEwcitWo5Nz7rlTrcRVtBslBXlj7/4bm6UKMjr76Wxw79U4yu8yeE1/DjiCgcwO4LzYM5mDmYrJ67vfUoFEpkn1NwNRGEVNBxZqJ6abzQ9fyg25GIsr5z9Fbrg04FWU5FtQKspyftfvLLqeqcD3qbxj5PGs+zStRTuP15YZzWjbwul3EGQUzu6Msrt/+c2b6z8Br83yQb/BzRvrVUXiEDRZlTQaMJd1n2HY3m6qKaDeuzSVJ/q062nGYT7eMfS7DK/LLFziY2gj/tFfirmZOVJFdpKBq+3bDZrm8yupAszcj31/XT90s9AZGceovHUQZiZiJ0sSbxb09O2sdrSuJDE5G7UGHfKvR0fNhEiXWa79ehOqMe3YU3CZ71oOjO4W41aNs3nANYWgEL1IyyVbpZ5w3TpQFRF0SiR6KDc64789qH2JQ65EzIYARUbk3fUVp46yRAKlOOhRuLGLiEbzLyjmCWYwTroYjgSSx868feqNEBEYY0ke8mZIhhGVZKXbVgw1SjEmww0A8cwsKb7NVNJPVm3LN4gVPOJPKIMUd4l2+VhNzy0aNhC1+b7VTJOn4SZAj9O3bPAhmKhksXdEAAscaYbKOT1zPWADqCN2Kh/K7iRrHRfFIaPlq/5CysP6evfs7Pak7cQgMR5xhQxlJmUlj7LTpH5MJdVGHNan/yepPe65iGtSL5YycqVXwf6WnJyKp1lBvL6Ci5OB1ZUiC8zmDE//0cpzRr08AW4Q6yCwI
 LWFjUJb/
 AI3MQgkDZWJKTQEZRWwKfF93uJXZk4lKmdYzedMZCW2icRtohG0OjOuReRDM0fZHYE9zYtA/zbL1tBr9KHbsUq+uiqfO0dJJrItvZi4dX9s9s38++MerNjFchaH1SW51wASB1GAqpP+22RD7fo+BAQWOnJXntojXU/sUz6t+OIx0pQ/s7mzm8LswG+d6XQN0hi3sgmonqpDRnIOeMBOzP5XkPJsfqTZNk804Rv1Q7akJW343drYLZJcho04Ba8ADwZiOkD5PA3WrPLEpL2Ks7hK9Raw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() always returns 0, and nobody cares.  Change the return type
to void.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 mm/damon/core.c       | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 2661231c0ae82..19b7e839bde0b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1070,7 +1070,7 @@ static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs
 
 bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
-int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+void damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
 int damon_kdamond_pid(struct damon_ctx *ctx);
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 84e400aa4e823..08510bf9b38da 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1947,14 +1947,13 @@ static void __damon_stop(struct damon_ctx *ctx)
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
  */
-int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
+void damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
 	int i;
 
 	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
 		__damon_stop(ctxs[i]);
-	return 0;
 }
 
 /**
-- 
2.47.3

