Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F7D9D58CAC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA12A6B008C; Sun, 22 Mar 2026 17:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B276A6B0095; Sun, 22 Mar 2026 17:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3AE06B008A; Sun, 22 Mar 2026 17:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 769596B008A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:36:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 307671B81BC
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:36:47 +0000 (UTC)
X-FDA: 84575008854.10.A8FFFA8
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5668510000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:36:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=AFThKKQX;
	spf=pass (imf14.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvXkdekkoCKye7mj9eb/H1RyQQk11r+xEZYMc+3T7us=;
	b=L6rny/NBRAaj21o4DxXLzh5hct9+R80NEwmFH+iqp9iSE6YgVt2WuWoFZqFfavZd4gy0/d
	2x6TPkFEhF8g8x3IZh71/C487gY3Oh05CwDroiRqf+9LGiTZzoE9SeTEXVbQdb26LG9j6R
	nWYll5WaYiUSuR2P4uyW/ZqiseLwGMM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=AFThKKQX;
	spf=pass (imf14.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774215405; a=rsa-sha256;
	cv=pass;
	b=pQ0RO8QZAasIMH3AoNDm9u22ErDDjFpfigHYrY32qHf8WLs4XerlMJD2boGqWKbtTNcAcW
	6VnETMVM5AGL08/zPJAPbA6BEmDkWo5qxot9BbWaE9eBBYI8ZzQeKt2q1vB3S3f+wmI0FY
	xp3KLf4/NVUPF0K10rPlo2TuRzYuYdg=
ARC-Seal: i=1; a=rsa-sha256; t=1774215395; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Bg+6s+QUK/mIlYYVa+pEfVGbxTNwLScwr4mjCcNPOzQZ/nwXhdGmHtiKYZ9qF0fF0X5P6lwN4g3UlWcCESqYWyemgxC5VELzU1DBf9vBeb07DyquBCY3SO/fCZRKW/uzcENY1fLEQoRZ4+4HvtLG54L+Ogb4P+b35ASUv+B3C/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774215395; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HvXkdekkoCKye7mj9eb/H1RyQQk11r+xEZYMc+3T7us=; 
	b=OWdJR5w7Mo51FYUjy4kJ+1TIXzZmepp5voCjL5t+kVR2sv2TRWvE8S11MKt8Oot+BLAQ+cPelv1oo2gINXiTQaS1iKDxx+1hCLu0hwkTMfAwQWqyw4RwG39NrE17vd55e2I7HvLFYzlCClvDVV+iw0XkCcyRxztcXtTeqbRyPSo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774215395;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=HvXkdekkoCKye7mj9eb/H1RyQQk11r+xEZYMc+3T7us=;
	b=AFThKKQXBtmARcSc/AFM8aeiZlC1Ys/8f/hV83hmr2RGTO9Fo9q9IVs7Q6kFZGF9
	a2+jPWdVkTsvns27UN36Oa0maEP9q14e6bGi7MDTXDi35bqhQfp5kI5gzHKd43Oueu6
	/Qz7UcBw87S0z3dKkMk8vHpzH7jR6orRmd5Aihyc=
Received: by mx.zoho.eu with SMTPS id 177421539290970.2907397850829;
	Sun, 22 Mar 2026 22:36:32 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v2 1/2] mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme and region loops
Date: Sun, 22 Mar 2026 21:36:30 +0000
Message-Id: <20260322213631.259212-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260322213631.259212-1-objecting@objecting.org>
References: <20260322213631.259212-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 5668510000A
X-Rspamd-Server: rspam07
X-Stat-Signature: obsticcg9szzdj48ju5kctgr47a6gits
X-Rspam-User: 
X-HE-Tag: 1774215405-31739
X-HE-Meta: U2FsdGVkX1/FqAUXIJ92jYuK/uoaCUxnotRegP7RIW4K9k7BIodcTxERQdlePGDOJYVvduvM7F+c0JhM57+KXarXGF4asDseTEZ5m0oA7uSAP1idzyp0yMucJtUVz8b8tcCT4TQdCoegKlqA2eE4G0rnoKL0HRkCuPM0h/1BlP0uDH6NaatssEW3ARZgIrZwMfLA33FYIj0tssB2TZQe2y+Yi1U8UdUZ3ZTJ0+MsaATC5X5AzTbEIvAOudsJghe5dpnswzr3bEa+toFid/XqHhQ10D539yPXDBJMTOwkSqb9Dbj8LNHrn8pALdUh5D5y3K2reond4Zk8OU3n1ibQhwo0hGANAzz0z10gXP9Wi/UgxS+iF9RbFBLMrGAd4fzq5TJYHGpV5/p01Imn0T7oHsRIxtSt25arijTb+QyR16CVG1HBZhVQbKO81SN/7CWVWAJhQPSB91ilocjT7QX8uC0vZkXgpvdr1oe5WqRIgnMOPkc+0eZD+nb/tavRwp5XoNYIkaY+/7IObR9E3kXDJoukZqBeQS+OgWtZdPMijzu6mO6Ix8FRHnhRbGuX1jgLeqstKsLpr75cBCRrjY+ob9Tf9HfS6gThpUWuCwZEgTwdumVBl1f07LJJC7re5GN2an06XjQIA2fyJefgvh7Op4vc1qUuYw61fwlGFJhBrliE/EgX6YK1OmSydU87gnitH65BHDWLU5UGXUeh3GBzLSmDp7QKB2f1XqgM++ISAY9DWIV/6aYAK4Jm0lMzHFkB/AAqGj6zidFXx9zSYd8yvxGgqNqPXSUL6t9/Bc1nx5zdzrrt0QU/MKluIGPZXjQInmka8oKljOHQcxd1jQ1XzXdyryKW/a7kEZEXEra1CuKSDS7kGEi57cPyOMK2EBVwIGTQ7d29qs1hLctuYjhv/xNa0ewNjHzTnhlAToCaBaEHQWLaDOmgWVZEFwXmBQvWNAuIBamvxpChFUTxVYY
 0jHh9CEV
 CgfbRoUXgbnh6EMJOmX4h/hHv46bQq8Aezg9hjDyGtoeUZa2AN0s1CGamKlB9uSCD8m0j8GijVgUE7fk2If0mI+OsuhVOB5tM9nTaFdHPtsGRICANqijGxMjbs6zO7MqJs1seRGMEgG1398+KZhK8D7z/yoKUtUBz9c3ex2IUaTHLboVmNVUoRUy6tk8feQqw02hnxqJzFVqbo1KIivTWlayYOCSsbxoctpimdd6yR7cffkwLpHXqiLJp/IzU7Jf+r/lwGXQiRHT67EuPW86mNZB1tfOyVOvKWCo2Qbd73EyVFEVGl9eFqgjeyZ+KtLDGBk1wL0FZvM6hx3Vl7HKz79iH2zgiE2yt7pkri9wwO1bhHkFCl1Qf2St28CymyC7DO38Rh3whdY/Xolg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kdamond_apply_schemes() iterates over all targets, then over all
regions, and finally calls damon_do_apply_schemes() which iterates over
all schemes. This nested structure causes scheme-level invariants (such as
time intervals, activation status, and quota limits) to be evaluated inside
the innermost loop for every single region.

If a scheme is inactive, has not reached its apply interval, or has already
fulfilled its quota (quota->charged_sz >= quota->esz), the kernel still
needlessly iterates through thousands of regions only to repeatedly
evaluate these same scheme-level conditions and continue.

This patch inlines damon_do_apply_schemes() into kdamond_apply_schemes()
and inverts the loop ordering. It now iterates over schemes on the outside,
and targets/regions on the inside.

This allows the code to evaluate scheme-level limits once per scheme.
If a scheme's quota is met or it is inactive, we completely bypass the
O(Targets * Regions) inner loop for that scheme. This drastically reduces
unnecessary branching, cache thrashing, and CPU overhead in the kdamond
hot path.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 72 +++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 42 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c884bb31c9b8..dece0da079c8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2112,40 +2112,6 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
 }
 
-static void damon_do_apply_schemes(struct damon_ctx *c,
-				   struct damon_target *t,
-				   struct damon_region *r)
-{
-	struct damos *s;
-
-	damon_for_each_scheme(s, c) {
-		struct damos_quota *quota = &s->quota;
-
-		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
-			continue;
-
-		if (!s->wmarks.activated)
-			continue;
-
-		/* Check the quota */
-		if (quota->esz && quota->charged_sz >= quota->esz)
-			continue;
-
-		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
-			continue;
-
-		if (s->max_nr_snapshots &&
-				s->max_nr_snapshots <= s->stat.nr_snapshots)
-			continue;
-
-		if (damos_valid_target(c, r, s))
-			damos_apply_scheme(c, t, r, s);
-
-		if (damon_is_last_region(r, t))
-			s->stat.nr_snapshots++;
-	}
-}
-
 /*
  * damon_feed_loop_next_input() - get next input to achieve a target score.
  * @last_input	The last input.
@@ -2494,17 +2460,39 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		return;
 
 	mutex_lock(&c->walk_control_lock);
-	damon_for_each_target(t, c) {
-		if (c->ops.target_valid && c->ops.target_valid(t) == false)
-			continue;
-
-		damon_for_each_region(r, t)
-			damon_do_apply_schemes(c, t, r);
-	}
-
 	damon_for_each_scheme(s, c) {
+		struct damos_quota *quota = &s->quota;
+
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
+
+		if (!s->wmarks.activated)
+			continue;
+
+		damon_for_each_target(t, c) {
+			if (c->ops.target_valid && c->ops.target_valid(t) == false)
+				continue;
+
+			damon_for_each_region(r, t) {
+				/* Check the quota */
+				if (quota->esz && quota->charged_sz >= quota->esz)
+					goto next_scheme;
+
+				if (s->max_nr_snapshots &&
+						s->max_nr_snapshots <= s->stat.nr_snapshots)
+					goto next_scheme;
+
+				if (damos_skip_charged_region(t, r, s, c->min_region_sz))
+					continue;
+
+				if (damos_valid_target(c, r, s))
+					damos_apply_scheme(c, t, r, s);
+
+				if (damon_is_last_region(r, t))
+					s->stat.nr_snapshots++;
+			}
+		}
+next_scheme:
 		damos_walk_complete(c, s);
 		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
-- 
2.34.1


