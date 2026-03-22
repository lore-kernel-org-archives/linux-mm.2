Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC33FC72D4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 18:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76976B0089; Sun, 22 Mar 2026 14:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EEA6B008A; Sun, 22 Mar 2026 14:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BD06B008C; Sun, 22 Mar 2026 14:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A25D06B0089
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:47:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F0D1BB8E3
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:47:12 +0000 (UTC)
X-FDA: 84574581504.18.E743809
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id 32304160004
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:47:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=iVrJsWuT;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf08.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774205230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvXkdekkoCKye7mj9eb/H1RyQQk11r+xEZYMc+3T7us=;
	b=qF0vlGNW8vp+NUFvig7JIsNuf8C4KkfVdmv/niGdvMUauf9rO0Pm4Kam8EtPwOsGeWp+oy
	X6ahdG46NQJDNCMTF0ow6Rqiey1+NJhA24chde+Eu1fZdXstIYXmTg9TkaFwkBV0orkpDE
	5pZsCRny66AE6jNjQLlIsR3y/LFcaFU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774205230; a=rsa-sha256;
	cv=pass;
	b=xAIlycyoZ6J8ia8ch4Xjp/WaK7/gON8vm4FglDcqdVHZnU8dcPhfv/ZS6TtIxqr1S4AlVj
	Ats3L3Z/bcLM/c+9zR4MvZDVWFAsTDSAwax93ObAk6twTYPkUxtihD8uwGA4EPs1+83yJ0
	zIWWJrYUMvrYp/aCVR6GSJ8DIlGFgyA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=iVrJsWuT;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf08.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774205205; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Q7Gzmh/ifcY/OF8N/GJ5KKRWThZQmfsD9UqNRGNfrOd4GwthxfjJ6I0p5rWsL+0dHvrbgIm6Wfxu9hNxdfeZUJvg6ZLT9lLy0GS0Bbj1cHULXGSA0nJ4SwVcl/BFx3+GlI5V7iQIH4H1H3mRbnTCVErC0IV17HUkbXaz9c7tsaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774205205; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HvXkdekkoCKye7mj9eb/H1RyQQk11r+xEZYMc+3T7us=; 
	b=Z1bFu9JMKcytFKPllcHmQvZueX6RwzFSMs4eazwBV0wCQmkDv+SQXlTyQPglLGdO7hjd4lgLDUTgpBQMFtwy4pQ4L/eknAbip8mfTfTt2ZDrTFVBPETN7Iak+5iFkOw717fQ3aGglz/PYdk6LFFYj/e/M6+IixQgiESD7B8JGX4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774205205;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=HvXkdekkoCKye7mj9eb/H1RyQQk11r+xEZYMc+3T7us=;
	b=iVrJsWuTDkuvPjkKL/QTPYLcerO8uYe9Bgd+qDsLUYXVbSsfJ7WpDropvTaWhJ4s
	bc/yWS5lfAO7mTh9lRwQokFqr5sQbc4v5FJcnpz67L4cgcZRbPa9PEuQkOka5A6K+zV
	sX8MzPmYvg8rX7WcF+AjySmiKq0qHxgQcfoAnqWw=
Received: by mx.zoho.eu with SMTPS id 1774205203626774.6951372831195;
	Sun, 22 Mar 2026 19:46:43 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme and region loops
Date: Sun, 22 Mar 2026 18:46:40 +0000
Message-Id: <20260322184641.251966-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260322184641.251966-1-objecting@objecting.org>
References: <20260322184641.251966-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Stat-Signature: zo3oa9apex3zpp76km8jr4h31fgu99we
X-Rspamd-Queue-Id: 32304160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1774205229-903435
X-HE-Meta: U2FsdGVkX19P2g+G47okvzjKqltM+W044KDHOwv6LS5chAr+9PF6ngYfgCdx781plSvt6Au37Rppsi4+eW8qAgJeegk/XY+943w5CXdikej+nzlP3Ri5Q+jLu2koUDkqfF5haItJm96UC2bStUfc8FnxKep0Au++P1p+YHwQb6H40hIAWmTf4tlTZd+nN9MX+DGSW2dU1KxubGjwT3/trrtAMJbiiHiOl2Z9L2Xf6Q+VdwAQlfYFydF7+6W0f8v5y/izLxaUwlMq3c0SlMIKTXlZhnt87ReM6BXTZraepHhvYU2ponpigpTb8JYU39+5JtOQYkYKRy6F12eQC/m2KIzfdwkSxRzD/JfjU1Tr5GpbMnlMg/gOtqun7i2YgNMijT98ptmyrnCN0ydz5LJ9/iSyte4FXkw3O1GWc1xbV41KnQKAIDnGd+Zh5N+12UJ77CejW7eboxaoXD1pU4meFI5CqiO6/vTECehQunO9L76jpV3NmbctxjqYG0roJIp67APR7TQBaLB56H9Fif8V944ZjlT8TYO7waT+V9x+mh0CksAb9azq5evNKryppOyw0RFw3iTY8Y+UQg5SXToilXk9AYvee+k0XuXD9dIllDwKSCgBHjRJLYRzKa//dj552ZJ/lFGlLnjAV67PT0G5qzdPygLg5ORS348/wskVr0S3HVXOXr+QAKO/rByk60OgdgNqlWOdIHtIz8j1BdF0r7n7UNjtMHdpI9mCYbZbr/OBVJ/mXKTSIPFm5Wgc5CScbSxaylYkDwFqU/DCaCC1h2It5GTFRuivu9U5sUS0MPFv/hRhjDZ1QWdN9gcLBxOEYqErMNq4k04SSMTA0Tktmqq6dP8nxYwoFI8/OHTSoph/MsMkgYsZjBxtBzJ308V9wxpQrMLGQDWb8mb/vnrNq7gq7jxwEdpRRCOiH1bvZq7spQZwIml9hb9FHQoT3TY+exRU6zmtwQK4yThAveS
 quw5SboL
 vCxUM3QKtlF/KUlZm9QHRNEuFqt9LH0QsLXhqRP1V8/SxJIjwWUxO6zAtBUpQOZT4PE+TcKd7nPfAI7EY1ZlHhXJN07xecPWlCKyh2hxgcAhdaXvkFu520P1O3sEL3Jx7O9yefABkILq+3WBCo4yhg6Kumu5ZgRMuvoTqug8pCnapX+LICuoJCLqIPbtAT9JNBHeUYPuzd/sKWTRp4mHgfIAb8j20ZQ/3VGAhv1+KF/0y0ZLs+U5H9U/5OZD8Qxw0iT122U2J4ai6TrA/Npz0Mm5ua6hLTpD283f+7rfuoZ0GcvDEfIBBYN2rc/19WPQ1+TK9oKwG0ylLBdX9hNE5/66IHeyrkOnj1LumsUWCQXc5L+65MDGj1OjLnovGIpJd2uF8dcKePXvPkwk=
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


