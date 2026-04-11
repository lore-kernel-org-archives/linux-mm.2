Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A248F3ED59
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3A76B0092; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC8C6B0093; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E11C6B0095; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 567F56B0092
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 267B013BCA2
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
X-FDA: 84646860900.18.78BD677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 664A1C000B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ha7+jjTM;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+u6/J4mCPQTT9pBWSxQfe/2h2K1WnOtHixcttUFDeQ=;
	b=He50RAN/4z0FRoFSKT1FkDSjMORZ4uAeqwCCTLijwh8hFTofOSD2tM6+9u4+OOjKvuQYAU
	frvRn4KpIvyVQuxzqo8EoAaOctXQSG4TrXtZBPuuwrFe1qWDKHGNGo55zHbuWdcShTvZfA
	CDP/YCYmMytRIc+qy9U+2FU19dczbQE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ha7+jjTM;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926168; a=rsa-sha256;
	cv=none;
	b=inuqL3Wm/Qagw0Z5sx6R/+Sdp5soTgOeQIV8GuJuMU7MlfmEp3ot/QWfFqbyq2KpKq4by+
	04kbCqNy8RJT1/1Cg5i0kDh74UUF6v6vIi52iBiKNlylay0CScZMB94+gNOjupQbgkcHNq
	iOajotU5pwrChyYKB05le2GdxAc6Oms=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CCC24380F;
	Sat, 11 Apr 2026 16:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34266C2BCB0;
	Sat, 11 Apr 2026 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926167;
	bh=1jMrLCVmYw2fM2r6kvEbSVD04BTkPY4xDIA5TY8Gmbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha7+jjTMT1s3LneksutlXeFJAp5DX6pt6iLwxi7+58OL/SyxTw14cYfvvDtStyK0R
	 yFnLEUBUPKgZa/UZE56KkujA8POrcMsJnoJ39Ouq80j6Xlu80R2DjON4YnBmOK6vrH
	 ciCvW9xOWcl+m8XZvBWjr7uEQFAu9YvLyksd0B4WAqwXg6a8HkPK7Y0TQpgAdDaqrq
	 QZzdWAnkt5cnk0BqyOQbY1Iy8zGRfwwhz5bClXXnCTbPRhqIL0JU7+WIWgwFM/jir/
	 HooFIlR45wZSsq4mjPEk9oXHSlr7QYrKPfBK5OJzI1gzFgjw2Z0Ws8jRwok9ugRsGo
	 JJWinaUy2BjvQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 02/11] mm/damon/core: merge regions after applying DAMOS schemes
Date: Sat, 11 Apr 2026 09:48:55 -0700
Message-ID: <20260411164908.77189-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 664A1C000B
X-Stat-Signature: ca1hcyikahi38r1y7ia4cx9b1opjgh3p
X-Rspam-User: 
X-HE-Tag: 1775926168-773778
X-HE-Meta: U2FsdGVkX18i7ydF4aKSDaLvBQSCfd9jwW2/Ez3/SKDWVPLn2QwDGKnTsJT+X+bys0bOEEtVLKLHK5cU7qw+7+UWXPYlI3WgWyLEWPvr8VP/0/GBFDc6M5sV8ZKITfhoTNNfSJxdloflyeFuEfjDsD71DPufz5PGmWTtvNgq18QuupJogfGumB2IMqp1qBvVhMBGj+7FEgtoiPi6TOTlrzSCk1TOb+996SbWWHVjdePbQuIRHLzeUaP4jhLgfJjJPIdgOauYMUIJK40A2vfuwRNV9Dh2ORVXY6OE9KpnRyVda1v92TyBd+iXycRqc6Q30c8oLD4GBKGJnhVVWQdmHyD2fLYH01aZ/ZO4AAs/slepmWS3vfotzzYO+SAUS3JllMPlPdkdcoTWR/Nw6V857e/DhoaKLyJNu3Nkm7B40QE6qDStQkEvLgW7YjuSKh1GN4eaPuMhYqzBzEwB1DqvrL4MggFSzFYO59bMP2pwfPmmafCrAWem0UzpWsYMzYcD5Mjb8mfHpehEqVkctmW1gRYX5oEJ07/QmYdqYtlLtOvTRnI9ZP87/26Ld5NXRA24QAm/PZyRKvoZoKK9PaqphAOS5IYPBUDhARD3usx61gOlAs1JSGmm92KPUTlBQsIPQjx7GD/EJTDg2e0cG1Ab/zhDi5jnKd+nQDqhDWtLuwCz7uL+amlw1ezb4RdOZS3cH/HExUHUUhO4npPKCfgFwNVCkbau/l2awU1LmDh8qhX6TwpoyNKy0M9k4ljmNkiOiLwaZacBm/YUrBuVy7qwVSmm/PuGtV+tJviR4i/0owTT5syKA/gm7u1697ubI2DrpHH6CKYIYrzfTOVKloowxA2YQEHPGwnC2u2J9kmmgeDEAUHyeYtHDcaJoJrsGQ/Npl+nIYQdglBiPUuAE/gOjGYoxYNVbWTxuMcRR9J1Wy/Kx34SczvglXH4U73Vx5LITIdyZRbrUPY/D4VVNtU
 cS5vHs3K
 vsL2lMqG3x9ZNlQX/62fzvm35vSjdY7D30skqsx2eWUVgjIFMpGEYPwl5khRL0NgpIHLbrTwhHoGnmr6TTpGS01E2m+fDWzQOq1ett+/u4E4w7v5LEqf4nmSADwaZEtvBA/u3Mt27sDLcQ3c1bnt+rX0nfPy9By9LAgJzIRCQZ+BubeGwRvOaTcCsh2aBa2FLLpeJ7V2fo33wWitfwr66ZVn2U8e6JF9GzaQWv8nHfUxsmXI=
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
 mm/damon/core.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c7d05d2385fe8..fea1b0722c6bf 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2159,6 +2159,37 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 	}
 }
 
+static void damos_apply_target(struct damon_ctx *c, struct damon_target *t)
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
+		 * information.
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
+		prev_r->ar.end = r->ar.end;
+		damon_destroy_region(r, t);
+		r = prev_r;
+	}
+}
+
 /*
  * damon_feed_loop_next_input() - get next input to achieve a target score.
  * @last_input	The last input.
@@ -2528,7 +2559,6 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
 
@@ -2551,9 +2581,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	damon_for_each_target(t, c) {
 		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
-
-		damon_for_each_region(r, t)
-			damon_do_apply_schemes(c, t, r);
+		damos_apply_target(c, t);
 	}
 
 	damon_for_each_scheme(s, c) {
-- 
2.47.3

