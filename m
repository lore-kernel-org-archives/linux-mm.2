Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13E7FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0BD56B008A; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1866B0093; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921BB6B0095; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7794B6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C0491403B1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
X-FDA: 84706244826.29.011F668
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B38340002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HfFQDI6Y;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5X28FgMVk0EfsRa1aRNHaTIksdPlwps60KtbA8o2uMY=;
	b=h3hs7y1MnVGVEyiwmN1aL/jkuz7ttbQexmm5bBuyD0ASiHUnjtq3FnaLcCKIA6lPQhhzPc
	IBRRbafTQRNWgPX8KZf98w3BLg3zoFAnYONELdvs5asCeoLQC9c30lF1mteFYY+/GO3NxV
	4I25GCBcXv6b1O7wCI9PzU5+ynpB2A4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HfFQDI6Y;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340071; a=rsa-sha256;
	cv=none;
	b=THZDANNCvTloSN6b9lMapeSvA75RKDlCxELlLMkRV29LPzzhzEISZeibLjXpR9BvjdOIRS
	H7i+grSqpwWwVIvvVHbvwftEQ4MfRzf53nHVarSKKSiWnVijb9N/zProjd7e9AIZTArPVD
	Tf7Tu6khfCo0YB/NlX63Vq15HE9bjXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 891074441D;
	Tue, 28 Apr 2026 01:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E8BC2BCB8;
	Tue, 28 Apr 2026 01:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340070;
	bh=pId4SoTQNM9qN5MUX4PnLv1gsuVQ5SK5VnLsAsG+C5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfFQDI6YTDzLPS/XP/FMb3x24PrEVecSxF9Rdf997bheRPoY/CqhmqbBuKnZsyOz2
	 hyDhsmyG+eeo+DLKpfQ5qBlMuWo/9d9HdortkC5O0vjJ/oDdYYHLqfuy5Pm19PT6Rz
	 lwcY1YlQWCtcn5CxTLvQcCOzpdygM5c9IpwbR2m22C3sLi19KIQzP+ziQXwE2gqSrO
	 SHrjTe+/ycFWPZ0HpMVTcP66dtQg7q2GOpw6JKJ7MWTb2vNwZ9PxJEYAJXzibsDRcR
	 ZPzGAQ3CNCgEB3Grj2Scdr0T/TcX8UbXG856YnI/FbnO513gt66a7HwmETNEOamu2T
	 FH4odM3OvoOmQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/11] mm/damon/core: merge regions after applying DAMOS schemes
Date: Mon, 27 Apr 2026 18:33:51 -0700
Message-ID: <20260428013402.115171-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B38340002
X-Rspam-User: 
X-Stat-Signature: i367yeygqfjsafqrxae3n8eo5nbhfq4r
X-HE-Tag: 1777340071-533634
X-HE-Meta: U2FsdGVkX19qm5wzjIQNyyaNmyrtW/nUUfqDNmIwmbY7omRDSTp7bzx1Tqq+i/FemUfJBOmR/oH+r7K+ygrhfTSd63mJb78hMb6kNYOSQ+GLXh4oToyJdlMb4h/d1k/BR3lfqUl0ciaEfL8TsEBQzDtTlPe9RLeD+SxXusM2EMDueBP2Y+gwe2aQgSDxtY/CjiZqV2SLxIVTRkQOSuC8C1l5THnv2V639yKMObfS5TmVcRcXkj1OiS27VkQh2NcHvi/ItDKELTUjr/eV3o/H2kDGGPNgam1Cl2B+bSrqdMs7zOTZvyD+rCNRkeJlFX/PctvpJdmmkvZ1AJrs2Jdtej/V0qZrItxzYPr+3imph9hz0AQ1eoCtC4qss+qC/YVEW/eJ4NRX5MF54Phb0bcKKYAzie2ok6o3YlpWMKSwrKf16mUDShV9Yvo2LuwtneV0SIwzTwIIZm1I6KCc0RyPjh13AlLqI8JiAd4nwt/FXOCTCzdsMiMSQduSDHeBrpa9b5kM++KHI8c2n6OgRScvLSip1HhC4yvcUd9M2NYb59rXSAceynQacPEwy2/whYND3f7dlvaXPrTxWSM4bRJUceiZkW0g7+I/xPnc35iZ1zPq1GY9JqbM43FBRxFjRem79GSUl871K+bJoBMQv0RvmS7iZ538GzKx4/GMyWU1aQkxKTcemV/AS/U++sxBmKThRTZ/OrPkfZQO20PDQ3QbqRwwXI7xEVBcnqNhfTh/cyYLQX/AFKG02s3b6gFciE+soIJuulG2mCagjWZ0XqxvSZQrtx61B67G1elDrY1EA0hrXndZ8xfk0RIh044HL68v1WwTXM3Z8YAI/HZ+AFdox3yAW/4HfuqSb/atm6MnlME8MFdksIBkUivrdTHg6EbdkTLniJ7WozGZLvXHzUY7xisz/DmP0ekOlxEwYYDY3mert4Ta+iUM5qoryt0CPeELBWp8Tuw9EKgAmejnmUW
 ZoKv/N6y
 CD8e3IcbcTGjM/a07lKtqTCRemcl6QiPjpB5Dvuj6S/hyBBu0SaijtSaCSboDf34OBVq3wIYm2qfRxOHG8oo1rfug19AFbWxJg7xk4+aQRV9F7aP8CQY9pNL6+RsK/WKCWyANaEej03/mxso06nD41Tu1pBcnNFn5BvRUv9FZhroijOuVMm3TaAHzT/uOQqnVlzDFzPNqeP+AdGjdbJa70Y15/AhdTfV9uA6atzST9KzAucs=
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
index 888b6ac29feff..8e1e19611c387 100644
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

