Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C234CFEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923D76B0089; Fri, 27 Feb 2026 12:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8405A6B0088; Fri, 27 Feb 2026 12:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516006B0088; Fri, 27 Feb 2026 12:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5BD6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:06:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE2865B660
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:06:28 +0000 (UTC)
X-FDA: 84490865256.05.CBBE95C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 77CCC80007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:06:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgptjBRm;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772211987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vs/ujzgLq2IkT5d6D0uQvmDms7yWOcXm7tF/3bZY/0U=;
	b=R5LWvs7vH1Xt+346QeHhNeKfnTe2AgSwQGCKG6Z+/SzKgMFSteNULlD9L/RR/mvRf5IzP6
	jpfBSALrZoSsXC52ONzIIe/Z9EEaS2r/ecDtQ6Lp9bbKaeuJjFEZkNKDbqPgcAkFfzbbD5
	snzhD2il/KG4HUdhKwgHCxOP3UAJ4wI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772211987; a=rsa-sha256;
	cv=none;
	b=wegCn5le2FHWyw1J6zobD6Qt+dFxJd5Z37W1VlakftDYQHpBeHcGS6f1HoLyTCZh10bfb7
	D6ZPu2bt60kNBR3t7I2EJKpVy4my7vd6777Z3ZxCQdJOCWwkO8TGHZU0eqsb1M75AC0CXA
	feJ2R2YAsuwavImkq5OmE44dMCbxXJw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgptjBRm;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0C2C60008;
	Fri, 27 Feb 2026 17:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72172C19423;
	Fri, 27 Feb 2026 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772211986;
	bh=EeZ+QAmF0j4P/k4LQPdqDuMHHoYstNMm27xxHRcBl/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgptjBRm4ELmKVqbod2XvHf1gYBZCs5fClM/pLy1A/EUAPKghBJC27tEuwq2Vb6if
	 BMPy5BBpHEOWjK0061UZGSNAiUdtBQNPdJLot6SI1GR7ltT0OnDnsyNUXFpoQodlNR
	 ZYqCiktpzVdzIzTDY1rLV2hspvAzKNSOAHWO1oftCqJzdPxZSRMtI3lKCmmEGFeQJA
	 VDua+i6UZ1ce+SlvhgZ2/E1uv8boXuQESZ848R4nDMS4ZlHqGrdHjcoVry4KN94ee8
	 pZOgT63rOXfsqYAdV+R+0ur+QBeDI3cYSY+qG6yS/GrnubY0u/+U3PkvUCRTKOcOpE
	 E6Jg6N8a05CtQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
Date: Fri, 27 Feb 2026 09:06:21 -0800
Message-ID: <20260227170623.95384-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260227170623.95384-1-sj@kernel.org>
References: <20260227170623.95384-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d6j6858ndhmguind4db7tnsxss8jhw6w
X-Rspamd-Queue-Id: 77CCC80007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772211987-799417
X-HE-Meta: U2FsdGVkX1+pWsxABZ3GI1ZLrDjVotMyI1By7X4FO53Jy+e+Cqd9vWrxIt6uu4Yzyfj6WHA5gD0fGB2gVwKinzVQe8I8FwdkeKQdcSANiix3TOZgH13CBgjEy66Z/AzMurlOYM29Ich8wXmGCUf6sVNcgKLxf9kbd2uMf2hpmV/o9vf64tZhRAK+n0MpvivPUrBbzA0L3qNjkV2ju/w4ALugfC8gxLGIUlMNgSmcqPCcYdrUZ3tI6WpHE28gwZ0J6o4w43hnfxNaf52mzWmalGKDoOwVEMbVda1bjXVl9ewRDCwj9lUp9BkvtnRFdsRPx4tm9T7wQpSgGWi/T+K5FJqCIh2CzA54iW7vLq9JQvXpOVUahdaKr8TttlwLsSYdSUalZD0wK5vPH1z0bWAdLJnJyl6uPD/qKmdrLGOybnD+gi9C0RDiOuMb3QJ3BbHoVyQQg4X3ZNi7LvWorTL8SWhUc0WfomRLU3NhjMjjjd8DMewV145jKFHa6tvjs2w3zfuV22eH2JTOFdgTWOuyz00TRuEncLx+6op+g8N4TOzXnq8yGVVWRy3kl4y+ijdi5tF1Qy5ctXP8OjjU3e+saKt6V8zUkU6LPZZK2nNsJq3de6w+Ss1SHikFmDCnwMp8E3qdKa+FS/U9bP6brr2jWlVQeHYAit42BA2oS8Qj9QtW/yjKVvpWMyZ14zJkHnUJd9DRfNf+IPtxkFpomXV5qS+mzjtiDReQTntepAaq2OR/gcLwVHU9+LT8blropNc64Xp791dXnppDxKHDE8uyWGLBAAIiJNZqXSvw8AL/g18Q3ueeH7baHIuKet+ugMa9ToM8DagyENoP1Ul6d6ZCwSWg9n1BoNa1bKjfoOqXRyYgHFkTWYbe2URMiF7n3SXJk9q+3Ftv/M6yqaa6Ylj7dwkmAkNwm6j7KnogRhZcrxJOiBbYJmkIH5FaxqjhD+DC9P4MIgeY6sK5GTwN8mF
 9rmeNUd0
 dfRYw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_apply_schemes() is using damon_for_each_region_safe(), which is
safe for deallocation of the region inside the loop.  However, the loop
internal logic does not deallocate regions.  Hence it is only wasting
the next pointer.  Also, it causes a problem.

When an address filter is applied, and there is a region that intersects
with the filter, the filter splits the region on the filter boundary.
The intention is to let DAMOS apply action to only filtered-in address
ranges.  However, it is using damon_for_each_region_safe(), which sets
the next region before the execution of the iteration.  Hence, the
region that split and now will be next to the previous region, is simply
ignored.  As a result, DAMOS applies the action to target regions
bit slower than expected, when the address filter is used.  Shouldn't be
a big problem but definitely better to be fixed.
damos_skip_charged_region() was working around the issue using a double
pointer hack.

Use damon_for_each_region(), which is safe for this use case.  And drop
the work around in damos_skip_charged_region().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 419d6953783e5..dcf7027637550 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1715,17 +1715,18 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow and saves the second
- * region in *rp and returns false, so that the caller can apply DAMON action
- * to the second one.
+ * area that not charged in the previous charge widnow, and return true.  The
+ * caller can see the second one on the next iteration of the region walk.
+ * Note that this means the caller should use damon_for_each_region() instead
+ * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
+ * the second region will just be ignored.
  *
- * Return: true if the region should be entirely skipped, false otherwise.
+ * Return: true if the region should be skipped, false otherwise.
  */
 static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region **rp, struct damos *s,
+		struct damon_region *r, struct damos *s,
 		unsigned long min_region_sz)
 {
-	struct damon_region *r = *rp;
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
 
@@ -1752,8 +1753,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
 				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			r = damon_next_region(r);
-			*rp = r;
+			return true;
 		}
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
@@ -2012,7 +2012,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		if (damos_skip_charged_region(t, &r, s, c->min_region_sz))
+		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -2355,7 +2355,7 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r, *next_r;
+	struct damon_region *r;
 	struct damos *s;
 	unsigned long sample_interval = c->attrs.sample_interval ?
 		c->attrs.sample_interval : 1;
@@ -2381,7 +2381,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
 
-		damon_for_each_region_safe(r, next_r, t)
+		damon_for_each_region(r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
 
-- 
2.47.3

