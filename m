Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A3BE937E9
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB126B0089; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05736B0095; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97EDA6B0092; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF5D6B0093
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AAE4E3EF7
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
X-FDA: 84650415570.08.77AD6CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87145C0012
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gTuuOB1g;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tmfrJm9vHLLOGfa+kYQxdCNz1vjPk0aHwwsE4fAZxw=;
	b=oTU2Asf6veNcNezSQAqIcDH3FNsgO3Vg89RDb5ZCtJjemEI2CygltgTIVlADJFkmHxe33s
	GABPp/dmVgnLhpYzqsLWY4MH8bWwa8nFikqBTEQYZumwHAaIzCRCZqezJaTBTTXwSjJ2aF
	Kam5G+qy9IKL7vgI+uRYxCTGIdRC6zk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gTuuOB1g;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010803; a=rsa-sha256;
	cv=none;
	b=Qv7+WOvCOWFgholxrGjcjf0ANscdp9DzoWLQXVAe1HiU28AisnfjZ5K47oMjl163YwZUQQ
	p8K8fb47Ca2G+4pw/GFdpgHQGNXDCOx6H27sHpoeFTasgLyKk59QE7zkHfJlYeLI4Hgq9C
	voB1m7wlhEoXtMZ7zOskpbiLHTSU+Pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E14044570;
	Sun, 12 Apr 2026 16:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D60BC19425;
	Sun, 12 Apr 2026 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010802;
	bh=LcC/dBv1K2/wmpl6p05Sv2infjL4OMvObv2PYe9dyWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTuuOB1g1wJBd2pe5soYlA4/PXz6I6DWXTU7ZPyQcPBxu83TuYXXVHu4AY5NNqHKI
	 vxH+ynQUr8JqSylEF6Joij/tsv5Pts/HV+gX4BwQ57CIszLJ9hhzabqLigh3NXoqVP
	 uDUYsHOo0TkskgWui3/3jN+4h/lWnlmW1JjoGC7BF7Xn4f0HIAt+0gZwVNOfn4yp/y
	 n0r7U3Ee+zCB1BOUWy1NEGYEFeiaL1gTWcb2r9Nz5r6qVqtnUDOgNXTeLJPcIUhhOh
	 0x2nJ0YSqI6DuQH7eFbhmZJ5KoVNXeQso6h1ESo6sMVTdchiZKZDvcpIIlu3tPawTY
	 0Ei2oMreIB/yw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.2 02/11] mm/damon/core: merge regions after applying DAMOS schemes
Date: Sun, 12 Apr 2026 09:19:45 -0700
Message-ID: <20260412161957.82835-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qq6e16unq6boe93q584oiq5b5tfzpaou
X-Rspamd-Queue-Id: 87145C0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1776010803-654678
X-HE-Meta: U2FsdGVkX1/R0h//SzjFMqL29oz2mH6dH3i7RhhZ8E5BfsSH0OByPPZIxBtdX6upl1k2BtXlYt9cBIhhyPaez7YfvHnsiFCMPUJvBtvOyi1Zmv8uV3276v4mLiXQ46tmIUaVoPoCt+x/WEVGi6ZVLX4Ts4NVztBpDbQ+XgB9inddiaqnWMCdSWEGvl0xAdCW7OOD/73HWcG9Aceb+IpC5sQTTHDJFa3uXfsCk9riXlwY9ESazKi9/axO7HIA/O3XxuwYUXRCquh2zTEFQscV26TPJLb8gLojQXjRDdBpHilEbv+UpBibUvSeJzbYwmsDMVwatrE5vfMp917qRN7gEE69TTz7QggTH2K0eipm1e8VcUJjBShz9VicJNhsmSL4a5pEVPjQ7GHKkSmXusPqIo1y5U5qKN016Xg27cauy3CqcU0KAzSz2DWtFQOKukBf7zkk2uerdtONKEaKmXddznhJkd1kh9ig2A6Fd1PUIFsUC6mgf57XG0Y9GLKXviPTDHCVoKilSmKW/LJCghiMT81/Rp513yzmCAHUI3DgSM1uv1UnMISDfZfQPQQY6ONnFAA9r6zEYFGykcFfJMJp0J9dk8e8UElti2gkM0nGWznfFfVzC9hGrNXY6lCVqrhyiksT77r87uUcAqlJ0Px8t0rA2/RKCqe2WvntjHAcy9JsRLHDmL0yvmUWnqF52cqSH+PSwS6pAQNCB6fmbLGRpe3iz0bgWF2SUh2mQl5xc2R3p58EkgPl2DGp4USKHCsiCw6O8U9eign3pD7r+S6nbaYfHgGpj4JE+76JtiPSz3LYZgmkCgMw8yUTcK7KJnlsAaLGEB3Hf+wbPsIPjq3tI0GOyD+31OXIEINixLyM7hxhj/EUauPyjpvqBHytmZQbq318+fLiyurp20V9Ck4EaIk7WgOG2abtdsJH8qdqY9Jid9q9EZMkEIHNejvjvDth9gQ5argz1kvwox2tD+f
 S+m5uj7q
 N0r2S0JKJojWiMTdIKyAZCsQKlSULRWZQoiWMgh6tUttzBD1qTMnMQXQdNhNVQ1ar6h7SeePemtSs5K6M1DIvI93PzMUMFD5PG+d6CgVi1rA0/jyrKr+NHgPEzNCPyCsGicV7v7X2As/sgmWkGaMhRERRwlTf+naQxBjconNWz1fx6+/OJkkQ8kewpGOIpt13QhWbkGNiYMADuQQw9BC4Q/qzmCH+/MNTylJZ5p+QUeBOThI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_apply_scheme() could split the given region if applying the
scheme's action to the entire region can result in violating the
quota-set upper limit.  Keeping regions that are created by such split
operations is unnecessary overhead.

The overhead would be negligible in the common case because such split
operations could happen only up to the number of installed schemes per
scheme apply interval.  The following commit could make the impact
larger, though.  The following commit will allow the action-failed
region to be charged in a different ratio.  If both the ratio and the
remaining quota is quite small while the region to apply the scheme is
quite large and the action is nearly always failing, a high number of
split operations could happen.

Remove the unnecessary overhead by merging regions after applying
schemes is done for each region.  The merge operation is made only if it
will not lose monitoring information and keep min_nr_regions constraint.
In the worst case, the max_nr_regions could still be violated until the
next per-aggregation interval merge operation is made.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 59 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e6add38e10910..0654caa904c8c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2164,6 +2164,58 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 	}
 }
 
+/*
+ * damos_apply_target() - Apply DAMOS schemes to a given target.
+ * @c:			monitoring context to apply its DAMOS schemes to..
+ * @t:			monitoring target to apply the schemes to.
+ * @max_region_sz:	maximum region size for @c.
+ *
+ * This function could split regions for keeping the quota.  To minimize
+ * overhead from the split operations increased number of regions, this
+ * function will also merge regions after the schemes applying attempt is done,
+ * for each region.  The merge operation is made only when it doesn't lose the
+ * monitoring information and not violating @max_region_sz.
+ *
+ * Hence, after this function is called, the total number of regions could
+ * be increased or reduced.  The increase could make max_nr_regions temporarily
+ * be violated, until the next per-aggregation interval regions merge operation
+ * is executed.  The decrease will not violate min_nr_regions though, since it
+ * keeps @max_region_sz.
+ */
+static void damos_apply_target(struct damon_ctx *c, struct damon_target *t,
+		unsigned long max_region_sz)
+{
+	struct damon_region *r;
+
+	damon_for_each_region(r, t) {
+		struct damon_region *prev_r;
+
+		damon_do_apply_schemes(c, t, r);
+		/*
+		 * damon_do_apply_scheems() could split the region for the
+		 * quota.  Keeping the new slices is an overhead.  Merge back
+		 * the slices into the previous region if it doesn't lose any
+		 * information and not violating the max_region_sz.
+		 */
+		if (damon_first_region(t) == r)
+			continue;
+		prev_r = damon_prev_region(r);
+		if (prev_r->ar.end != r->ar.start)
+			continue;
+		if (prev_r->age != r->age)
+			continue;
+		if (prev_r->last_nr_accesses != r->last_nr_accesses)
+			continue;
+		if (prev_r->nr_accesses != r->nr_accesses)
+			continue;
+		if (r->ar.end - prev_r->ar.start > max_region_sz)
+			continue;
+		prev_r->ar.end = r->ar.end;
+		damon_destroy_region(r, t);
+		r = prev_r;
+	}
+}
+
 /*
  * damon_feed_loop_next_input() - get next input to achieve a target score.
  * @last_input	The last input.
@@ -2533,9 +2585,9 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
+	unsigned long max_region_sz;
 
 	damon_for_each_scheme(s, c) {
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
@@ -2552,13 +2604,12 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	if (!has_schemes_to_apply)
 		return;
 
+	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
 		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
-
-		damon_for_each_region(r, t)
-			damon_do_apply_schemes(c, t, r);
+		damos_apply_target(c, t, max_region_sz);
 	}
 
 	damon_for_each_scheme(s, c) {
-- 
2.47.3

