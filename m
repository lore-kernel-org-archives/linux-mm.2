Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8228ACD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046FA6B009B; Sat, 20 Jun 2026 13:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12E56B009D; Sat, 20 Jun 2026 13:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27E96B009E; Sat, 20 Jun 2026 13:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B09E26B009B
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B5DEC0426
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:04 +0000 (UTC)
X-FDA: 84900961488.23.D081316
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 82BB04000A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEV10JUy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVGel8Xthk94BnCmBjFUhK6aLAO3CRB18f6Lt1KpdKg=;
	b=wrERY0ZlUYLeOOmllaJsFS+Ctf/81XfowNJYLCd5+geCZvNA3ifQ1rgtvm0PrcrD0dgAzM
	g1c/fxHemgtr9uNeU1TompsHDAYgKV5D4DZ0fytj5shq7nDQHCQpru+LwfnJt7bsfzfuh1
	klkbUkARxfoxrX/z/c4bqykqZROexDU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976182;
	b=XY2FQXWnZshej7YMEMHfELe59ogz4OA2+yKI0xn+5MT1ldbSoiD/wwDoukKYdZB2Ch03Q9
	F+DfANcG10M9/46VDj916EJ3IWmojJuJqwJqDrHFAHbPcAd2ZECUL9fhOeiebFvi07mY5u
	6vhilr9yTl+i5vEbqbk5E/p0rTKAhFo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEV10JUy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E380444D0;
	Sat, 20 Jun 2026 17:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8277C1F00A3E;
	Sat, 20 Jun 2026 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976182;
	bh=rVGel8Xthk94BnCmBjFUhK6aLAO3CRB18f6Lt1KpdKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEV10JUy6FdPxIWX4PQwCvuclIdXPLxMB26RvQIZVL31yXPvflaDij92TmbrvHV3C
	 U+cjiaVIVw6HRs/J727yIKVAZhtnlILFR6V+1nSTsLM1iNm9UWIWhmUWDiCdasj1AJ
	 0lw5vVTMBusDbBm9aVaQF76ocThApg/zkmc7Ime0y8RwJnTqta5ch8+jroE9M6Tybk
	 GmfJ78/u9AW4MwMrooVBnX43VQuMq7UFWY6DicBaKJUOPdGI16u93S9ftfDZmSneNd
	 VCC4D5NsZ5j+fH1Mt+cD49meAEtWiVD2MwgMkCgeWOajrgWzmtvdPR1bdC0AwxG+QE
	 SwDbxC1DE9zTQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 06/13] mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
Date: Sat, 20 Jun 2026 10:22:36 -0700
Message-ID: <20260620172244.90953-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82BB04000A
X-Stat-Signature: niwuc65za6oof86nkhgaciagasgr9y4o
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781976182-636634
X-HE-Meta: U2FsdGVkX194bLFJFKONR+SkcCKL+SkgSmtVP2zltwfeKhR+WjIvN3zJa8z8Wu3lxdEcQGeksJqtNVzZ0Yl0FDgNrUJJ/45lVS0Xn2VD1PBTai7MCSL5E4+fk2s6Rjp1c57/lKRCsGtXtF1iC9gEpe+smSSkN0ExGcR/YmvjhKUT1ll+zo30L1AixDIzEpy8kPkXHdz8eLaktQ/Id6mJHnIb75a5DUBK4Wu+Z01sHv3MWY97+t4qVnF98mCDIT3Gki2ZcrvfsiwrDjZzkOac1NFg56pnV6p6mbCMQ17RbSq3RwHxGN8DPbjFErafuAUgBLbimPMKSi88u8OkB8f/FrZRLZ1x7qck/02NJf5/ov/sOiWV5h8C+hiLXCIbzrXJZvrCeYoNayKYhVqGvtAka5VJgbCp0zIHecJWoLZ1aa1/3jU1RVqqpXXLB4xeGOC254GmJY37DtpJCn5zhqLWJxzpLfENur2YB4Pg+Y2YkVjWQifjUi6Md1CfJNE5DUbHDJRt4rN1vlf2Dt060mgTqILo59OYMDxjg5zsKEUdf7JQYYeFXZMbCZokd+JqP663VJWugjUR5ZpG2mIQkr1fjwCs9intGoSTHia75WpvXy54ct9XWTZNyJBvkdE9gfSUbVAYzWbVHw7i18gyDNQLbbZ8e8o0umwd8159k09UNoWeNGsEHDxStvn1UockaYTvsQLaJKYlx9TMUSJkfbMQpsWrYVxPz5k5I+W6CG6P1+zwNenMz3EJWaT92fcUUwhceZ5OSjIoSGiVAdCOP/jD6Qy8fjIKwkQ8kpVsdpBWsRUDoAANGnUIZUEitpaRUh3whJewcKVry9hDZM1d6Pu40wlooib/gQqzNGojyJw4Cn5UgxKpKMJSp5rRKZx3qXAb1OTDaMqTYsHAh+vqetCKrKg4FCB5Xt+f9I5yP9kqEt1oxqtwc2yIP0A8hP4jYyujXA/+2qNAu4SBzH8mOOG
 aZjB0Fm6
 tpPjIQ3QE8ObN0RZgaPheAsX26W1fRfFSzbzRtkkT1cYNHU+oRGUzjw51OFHUySd3HEcCbX6/8AXXWBGr+efUJjaykZJBpwJsq9XsJigslIkUi1xcgZ42tytQfWICE8Wkg0dKTMY+A/6x1HP73rWX+YcYZxYzyjpnyPj5JgBdU/y8NnsgXLPgXzT1ikHjM/cyxzkdKRCF+SaJw4sufJAlGesysoLYymVK0tabh5NrlQlDA26ePgGaibaYlOwiQfk9dCtwB1iqcGCLXehrvfvnCE3/NA==
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

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 710ec13e98281..e144f0079322d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1994,19 +1994,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
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
@@ -2048,7 +2035,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			trace_damon_region_aggregated(ti, r,
 					damon_nr_regions(t), nr_probes);
-			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
-- 
2.47.3

