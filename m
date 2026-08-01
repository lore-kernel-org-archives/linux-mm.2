Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FAD6C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1726B007B; Sat,  1 Aug 2026 13:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C635B6B0092; Sat,  1 Aug 2026 13:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4076B007B; Sat,  1 Aug 2026 13:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC4B6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36464120332
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
X-FDA: 85053403974.13.D8421BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B17CB160008
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LIlnGYbl;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3Yai1oWYsB5IJ1T8UFXb8F9ZG0QK/4CFjudJQO8wtI=;
	b=S7qw+qW9earG7BPKOLDtNQPZPaWALqdjuHZDcdFA0284mq4QDNmeS0FPcvkgmefkU2Iwc5
	sLpTtYmMgb14HGWAlx4Zd+lDTPSKMVzLMJiCjEfgC3eVid8AqceyoK5kTiOzPjO/lkF+Hv
	pP6j0DOvQ1Uo/m06VXtVzFszw126pZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605765;
	b=AOan1DBeHSvxpDHV8BVSiUZsrhpniMsRm6Sr5t9tMQrVfJPMF8dzAur6hl8vf58wlzpZuE
	9a7hKMFKl1hwVMiSwBqyjh+n31xf5GZ6Gmh5//AZP4u5qcLsQkYumPb+EHlkrPyyYcVqor
	KJ261nAk0d9P0hoL51nVj++BQnlZQ44=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LIlnGYbl;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48F2C60AA9;
	Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E491F00ACF;
	Sat,  1 Aug 2026 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605765;
	bh=u3Yai1oWYsB5IJ1T8UFXb8F9ZG0QK/4CFjudJQO8wtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIlnGYblIdAJF2L9ANrF/LWWjqlMRNw0pyblGdwP+H0Y0oNSeuaXfWqnRatJ1P8jP
	 3V7rmoYiqRnGONnpuCaK0KT2FVuVPlEnwCSTGHZtDwkDiP9i2efZAZorGcPskdfVvC
	 vcTwwzppVg6859yhqMlgowY8ZzTeL6KEB8RctiOy3yxsvPExbA5AF/dEWIGObwl33v
	 nA5qztxHlIASYkZGam7SLdh44jv8LmnGPDugdf22fRA6SSZq9fOcrGR5Gp4mWtYi+L
	 cTDaolvHBd80EjG7lBftVS5gpN/l0YZk2v5Hnr/woUVfGnd/FWWZCVGkJvLyFvDeqf
	 NhbnPy6Qa21lQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/9] mm/damon/core: initialize damos_quota_goal->last_psi_total
Date: Sat,  1 Aug 2026 10:35:45 -0700
Message-ID: <20260801173554.94710-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B17CB160008
X-Stat-Signature: o3y6a7adpfcw48paaxacnr46kebbq5em
X-Rspam-User: 
X-HE-Tag: 1785605765-354905
X-HE-Meta: U2FsdGVkX1+sEz0OXw3DlUBSc3f2A0vHb0qW4HViuk7ffM4ks1RiUuvS+r2zMdgFFk86CLfUAV1dDHG6KsU1wkeJny7LnQgsUr8yyKdHa1pOvyK5YVZ2UWiPYCZaLNQdlTWa+UOktVdtSke799iVcmpQAgqjhFoZhpOOTrQrITZ3o/VAvg6qjselLy5Mzbmh7J4kUqXh0Nu/k9PaepUwqa3qcPTOezLd2q7dpm2n+cNV3sTJwR00VMoKBuHloUniZ+QtyDwNb9wSVoIaDQd7A2lDMjDIsuL+s709X/FEsEW3q8phsqygSPtWlfqYXKxsVRRfOfpHywf7enc7oJLQBgmJrczb2G+mRDS0aCnYeSCBK53lilB1eDZgp6Rj+ZvRuSV7Cmwze7T/8jq90JGbBpn6nKzxS6VY7ENHpWIBeoYFltd2uBKwCDVSLB/KWE18lshOvwzpWZWAjU+Xl88kO3yzrD/jiu+PWus96HC0K/7Oqy4zAIWO9aIttCyjoVosJqpb9Jqb8Rm8kRQ06gr48e/nxljgxhSuejrZt1Z+gdJEa0UHgV+l2DzSVbovL6BF8KgtQMbEpq1lvcAhHgmRKIafikw7TXSrMDO/nUtHg0wH4UVE5lmpknRGPBLp5L0hFPQdgNPMCfQI1xQYbMYwboT0ysAVKOIYVIovsgzTn/tZygwdqzO13GzwDVXftRoDfACuIYdN/6HxzpvBZ+xtETCfmbgC24ebiLXpe7+oAJdJRZPlIHltGK9Irg7TQK7lHidh+S8N23dRP7PR3WqVTyTy7+yMgfGb/0G/GuWmO6eFfLjWv3C9VxGnYLV+RCZSXJMFuvT8jUIJtS2Xcr1RqYe84hp/pFsMJH+RnumP2BQ3EPb6l4O+HyM1zrDQF8ImnNDkfiSo9fUVl+Gybs3Un0YgFEOCC/JYxGb3VBRvfinrufwlrcB+gbFN4OkPRV+8JxVegCzcuQ5FyCiXerO
 fWzW/Gw5
 bEqmKksY71vIVPeYsz1AZrszn/ilSNgsODFp/BATRz+i4/ZJHEye9QdnUFyNl00xLX3STyNbADVDQHaP7qB3r+Fkv1L7y5M+g9PSegIcg1XvoPNcn/R3CBKnH7LSpS971679QYlsTohUR7dqmwmf8K+Sa5ksvBgQ7Ym7gxfeMlqW2eO8HatHS67SCgRYiqDqvKvsnpgkcAK/jNHWjwxHwKNVBh5dFvroGB7micOwkqIv4xmrgiijE7W96wcZ0p+iRFcL1/MxkNmAaSoMIR+fc3i6czQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  It is not initialized at the
beginning.  So the first iteration of the feedback loop uses the
uninitialized value and makes an unexpected starting point quota.
Initialize the value at the beginning of kdamond.

The user impact would be trivial because the issue impacts only the
initial iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org

Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e2900d0c984c9..3bdbf4fbf7147 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3728,6 +3728,17 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
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
@@ -3744,6 +3755,7 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	damon_for_each_scheme(scheme, ctx) {
 		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
+		damos_init_quota_goal_last_psi(scheme);
 	}
 }
 
-- 
2.47.3

