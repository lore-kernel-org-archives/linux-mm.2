Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9BFC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500306B0092; Thu, 27 Aug 2026 09:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D70C6B0095; Thu, 27 Aug 2026 09:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6A96B0096; Thu, 27 Aug 2026 09:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 206FB6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:44:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A381F14014B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:44:39 +0000 (UTC)
X-FDA: 85147169478.03.5AB52D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1D600C0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:44:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jX5woQMX;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787838278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6N7NhpJ1BNkiL5rB15BJSeHfYTylJVAOauFDB7Ic14=;
	b=np0KKLQ+GT2nymV74hrYy4Rd3FNHN9qxDf9iMTZxRPHGSbIs5WOInpuBj6LzqW1QKv7fvj
	WF722Tekp5q8Lvaf2SI4nLNVXVKRiq0oteLjoWUIJlALhzGarDG6uvC26f+g0QzUP6QFjt
	/LwYmcOyADeFONMLp/PfzXVgUI5nR4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787838278;
	b=emTeDPKpFKDV1AFT2vjeq7alz5Pj2Muq8VleXMngN7EhMi5jd/Fg1orHsVD61ItqEheh5V
	U8h0gFyS/8oSWBjEqH8/t+o4aXCT6lDMGn6TRclxbyFE53IunFfOxnQwi/qcVKeztB5QKs
	GmsfINghl1y3emk7LlJM6fDj5SNa1yQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jX5woQMX;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C056600D3;
	Thu, 27 Aug 2026 13:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC931F00A3E;
	Thu, 27 Aug 2026 13:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787838277;
	bh=R6N7NhpJ1BNkiL5rB15BJSeHfYTylJVAOauFDB7Ic14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jX5woQMXyglCLMJmWu7VohkJQfCZyylp4B4oKtWyfmvnMhZ6bdPickxD8wmutLsre
	 QpdS/6ucicxyye6iCqYjDlSQVu4RBu1TAWf2ecxjESh8wgB/a8BDKAuq447Xu4qcK2
	 H6GFY6ohRj05L4fFRM0tSVhqd4n5TTg3aDowOOuflhA+6vKUdf3Pjlo3B26z/gepbJ
	 71dUFx4rjnY3CiF2X44WQWz0OoU4ucAS3GmLDhT4sgzLEh5PB8ZOaBuRQL5xMOVQJk
	 Rjgg4DdLufmlKIx31ul+MKsQapuKPAgcMRhGujDiVK4kwiGwiBw4FIhytkCxvDyvbQ
	 6Wd/JTQ9B+pWA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/3] mm/damon/core: initialize damos_quota_goal->last_psi_total
Date: Thu, 27 Aug 2026 06:44:26 -0700
Message-ID: <20260827134429.123023-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827134429.123023-1-sj@kernel.org>
References: <20260827134429.123023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1f8zor675em4mwuuge8qsa7q5bbny15f
X-Rspamd-Queue-Id: 1D600C0009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787838277-646619
X-HE-Meta: U2FsdGVkX1+HwS0JW/ldHO9PY8SckQYO65G8hOCsJfN5Y8uEIXxMaG/2u2/8Tw4CZCuDS9vGeJeblpNIYcbIV3Wi4Mtf2ZYve5g4SMsAtHru9hTFkh1MrMpaMUe6iEhC9nNt70pAMNSIFhNOtGyKJ+/Vf9xsJA051qws1FY2xISrzUSlzImW/FLMkBTblEXLT3n0KUHOWY4lhz0lIzOveoWq9oEZiYImn3Ih9UHKnwWoou6Y+Z0mreLQyi2dB9JZqr4JxwaFTgGaWTMgdPyWFWRqiOiDKtBJrKKMaB4bWy9erj/gIDoktRRt4mTqmrxd/dKNTFb4HiMNfBFH7h9eGwtiWt6+cHhecodTCARLG73XS6ATI+55HKuru9VO3xyI2S8YJiDF9fHl5KJPSJyEgtRIDqLbXqah426Cko9rRDXyY8/0twUiMvHgm2s2KGKvzmMomOWTanmFj+1IoRYNuAUc0a6yqVRY6dan7K7F8+IuPmTwvp9wq1lduwcoYY0YyD6Vy5JrlS9lusxy+DcuMqpd2cxINIrUNs7i8B/cZcwp/8ECU68WYI8HgVrp6g3YgW13eJJgFbL59yEj42af5MyZDKflbgR+sCV7gdLkS6EiUmi1MwCUWR4agdZjrYS4faUaW/MC49J+nB5x+rpxr4A4gFbfwasZEXkYoc/kmgsGiX76ns3q+z8GqZtHFPciRf9sKqs0C5hgsf/rrr072tYwFx3WwGYqAGG/dm4Cyi2OjX5PNgpgd+M/uswelLfj4G98FNulSzZKb/TSMF8WYFUe/RiVsNWkAu8d9MHgzgKxGeEyYuXYcb1VHW7SyaY2em2O7VhqY+xERzVdI+D4CUIubJWiRMa205e27l7ZlXwsu3AX6yN2Cr2J28Yn7j8Jh1i5XA4lsJoyqEfqpdhMlGRaBNEkjTUErvvnwUEDWOeWA4ySWk9B3lRmYDFFmzOsrieoet4gAObzE/s1vYS
 x+DZAZ3M
 9gPwL/fwT4SOFzIoS08rJk/TA/NI0sNeNlQZdW2AdGYRn+jxPQoMq0hXBSHWS/hkT6pGdiwkZObg33qZ8htlM8i3jYJD/WQeI2AxbGBVoweVP6s8LX3AsUcd/MubTrH5wCFYKIJAEwOeWNLaiTgJsDrBiirPtd90vLKXvYCb7Y2Y48aOc9lGo0Q+ShGSUv5I5krsdx4WW1Ik+OBiekoyBYCNpk5rKedfL4KE4PmTwVe7zf+slTm3RIg76yFQrax4iwi/Iz6nSq0G9aSspbrREKNELhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no
initialization at commit time was intentional.  It is also explicitly
commented.  That said, nobody likes behaviors that are unexpected or
difficult to be expected.  Fixing it is also simple and not expensive.

Initialize the field at the beginning of kdamond and each commit of
SOME_MEM_PSI_US type quota goals.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org

Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f8dddbff74a77..e5b6b1c6bb7b2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1118,10 +1118,15 @@ static struct damos_quota_goal *damos_nth_quota_goal(
 	return NULL;
 }
 
+static u64 damos_get_some_mem_psi_total(void);
+
 static void damos_commit_quota_goal_union(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = damos_get_some_mem_psi_total();
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -1143,7 +1148,6 @@ static void damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 }
 
@@ -3741,6 +3745,17 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 	return -EBUSY;
 }
 
+static void damos_init_quota_goal_last_psi(struct damos *s)
+{
+	struct damos_quota_goal *goal;
+
+	damos_for_each_quota_goal(goal, &s->quota) {
+		if (goal->metric != DAMOS_QUOTA_SOME_MEM_PSI_US)
+			continue;
+		goal->last_psi_total = damos_get_some_mem_psi_total();
+	}
+}
+
 static void kdamond_init_ctx(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
@@ -3757,6 +3772,7 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	damon_for_each_scheme(scheme, ctx) {
 		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
+		damos_init_quota_goal_last_psi(scheme);
 	}
 }
 
-- 
2.47.3

