Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D07CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB4E6B0099; Sun, 21 Jun 2026 11:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C596B009B; Sun, 21 Jun 2026 11:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978136B009D; Sun, 21 Jun 2026 11:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66A0F6B0099
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD5171A0271
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:35 +0000 (UTC)
X-FDA: 84904374870.20.921448E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 55DBBC0004
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKWiK91Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/R/pq+g2xJuXFKABLKe9iXG6iO9DKEbOOAgRIn0eX/g=;
	b=dieTRHfxiq+HM01RkXrqcjAblnSVMRwijeaRBBJd1xbJwAHR5rcAvuCwHRvsjyDD+5wFqI
	9w5h82uBIwLRX68ksTCEHKi3BByNJxmNBMw+7hAU6ehbrGyr7pTT2Arsrr80n9pmIZVYmG
	qUN8wkTr7V1kfs0bF7KmdQNiDiIyjz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057454;
	b=TecvyM9cUekgdnYYkSBLvewTU9AzW+FT21ii0QaHtvtDYCm3CXQJvVH5wQkWmmXOvZuyA5
	fT37jI8Roea2WqN3FZjuCQJmyVbRP1LGH9WX5PTKWZb9ooX0SwyIYhA94B1Q5DNlfKPr4w
	HOL1Nk4Zm+HuCBZaOr8dKk8zQo+FhM8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKWiK91Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A16F54430C;
	Sun, 21 Jun 2026 15:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BABF1F000E9;
	Sun, 21 Jun 2026 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057453;
	bh=/R/pq+g2xJuXFKABLKe9iXG6iO9DKEbOOAgRIn0eX/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKWiK91QfC7/8cLbBlQbo4JQLVIxl7WbduoJ9nVsRJ/y89pm5BNzTeHKj/f7MClzl
	 HepNdwgwaBiY0QTABhqTd9+vP1TBeRDS08hYbu3mUPwLrnOovXbsSGX7wDRNhIOZSF
	 wJ9mHEobp1fa9feiC4L7yfnJostMEkp3hxI0RfNkV9SQdCsF/yHDgCa0TFAbPEJL2L
	 zcgB7W4zfPaS6TMh3++YeTLNfqLYzdxm+fegcMSydqpVLrNfOPoEc1kEGamZmk541x
	 5tWfWzUKCc0jE+jvVgUUvwTgEbJQudvdQcreyaELtGLK0KL50lxKoTbxVfkXoFR0r0
	 sPocYqpuH85rg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 07/17] mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
Date: Sun, 21 Jun 2026 08:57:03 -0700
Message-ID: <20260621155715.87932-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: ff9tqjpk6n5pmee3jdibgonwwpmuzyqy
X-Rspamd-Queue-Id: 55DBBC0004
X-Rspam-User: 
X-HE-Tag: 1782057454-124855
X-HE-Meta: U2FsdGVkX18Ygi4I4LEZscZFpwtILkVPTjxvIqrMerj5araa2gOshRntu+8amUicZ0xbgqczfRdz707VL9CloRxgUdEZKzjBFhg3M+SyINK2VXyhrOR3z5naAZeOJ0TOyvEza7LbqPwBMfZZoDEOVYzrHiKxhFxL+3iCEr32OLz6ZulJP8UqOEM3UpwQM9xu+udsufzAR7ExCSlPJ2WNsRqqI6FE4t1L5DdejfFJt6GcbSYF1YFNzkQE4SDdZ5dK2I+iynvTI3/NLZRDQJJOvKUj27QTH9W8qwVmiXjnjogT9/S9Bumabe1zsan9UYoJiHgKW+rZW4Q/cqVxCzd5hqLVykdzTuKU/mm2trMLdBsdm+ViChNWWQyPsNMY/1UX2am0BcokmwXZao2I9B9QZ5FBES7WPHRuQcs9ExICw3b3wJ5f4gkuusH3URz4trUE/0TznWfCuFsV6yU/lNkmkt1nsLUdr2UKZhTti/5UL0luiQzQBOwoQrP58vxvhZBn3I/9mtSeuyhfcvcd4xj4wrX6ma4EE204zJQQwMUxJRaDKvPAC2WSlo/f62csp4rH85fQKj2E0Bm0UDboQb7eW0ynocsYgvQYJS8v+cI2BvruEZLm4BgVUJnzlk223kpp1r4p4vafb9JD303lGYUI8A4Gtxr2xNzYrituQqgNQefp1T+WbgKy3KlEd8TqK006tQnym1C498gXHdB19zCBAcCFa8czBA/0Kls8uS5As+sUuKWSPF43HMbQ4EaSAXgOEiT0fs3TJl4821+Qe+4nPCmjySxi2LrVZvw2Uxr7Z0VDo2YwCgYfelAJGe1jDCOBok/x191VY6Pm9htk3MI7vpN7l8Dsj41wevhS/29yqN13pmbNnqrCVSvokGFrGoZOtVXFLZgxmwGTclJiyrC1ZSgfmuFx/ijUPj4A6FhEZg+WbQfh7KgY5ly9pjpqz7eF71cMmwoovgx7xBxQmQG
 RRNJONwQ
 OFUOdzoh4lcbusQIFLVEX98zEp6Hx8bH9EM2TLZdAVsAx0EzWYELzXsozhK3dE0SzYXAkCY7/NOffhkYbcdQYVNzNjW5DmKEWks6MC8xz3XDqG/VpGi/pjhJlYmh1SA5VZyD6YRldh7D0wrciHYebdHxofztxU+VmYLfNbLIBDD1r6fsdVygAEMvo4IFgotzvRm9a9odh+THhhi0uu6/bMY3+rYCtOEnBcC8oLNtRDZ8BjYkV357Bbze5A6Ba2o2Fv57jtKaYAepkOf9DnOGuptWSBA==
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
index 91f137901e726..1a10eb0694aca 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1999,19 +1999,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
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
@@ -2053,7 +2040,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			trace_damon_region_aggregated(ti, r,
 					damon_nr_regions(t), nr_probes);
-			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
-- 
2.47.3

