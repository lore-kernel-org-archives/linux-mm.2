Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4DBF44868
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE166B00A3; Fri, 10 Apr 2026 10:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F826B00A7; Fri, 10 Apr 2026 10:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3086B00A9; Fri, 10 Apr 2026 10:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEB1B6B00A3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 925A6140470
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:47 +0000 (UTC)
X-FDA: 84642857334.03.2EC681D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 02CA44000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SDrBY6lO;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6j7TFmBTg9Y1LDj1OQWZ3x3f0H58BDhOvsUBmkiMnD0=;
	b=nSlvqYyk2El1OD3q/hYlNd2/zpTUiectUSTjrLg1y4GzWH/jRLkVvX2buXtvHIIDG+ZEPA
	hkzUGAyDy0NuicMuZnLvqXVdbetFFoCIdtqrwpmQi62QyAzQKZwVxzfy47icSSCzp6PNGV
	lfnr0UjinuR1LgELUkJa/4qLwnI+NEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830846; a=rsa-sha256;
	cv=none;
	b=PShEUuEpkzb7uyU+MtJGrBR340uo2KXZD0k2C0l6Ee8KPipe0YQbiWHodX2ZvThZB52wyM
	hoExkf3wl2eO9uPOLIZjYayKHVNqwa21TnCNn7ieS3c6FIZETc05HCqWZiNowsr3zLLGnw
	uaShJE5VhFMGMLs7ebUxH2oqDCeKOEE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SDrBY6lO;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E329B44516;
	Fri, 10 Apr 2026 14:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1137C2BCB0;
	Fri, 10 Apr 2026 14:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830844;
	bh=npLjo+Ub0jfADcpNQiStOidPGi9YtKWTfRmpcD4bUVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDrBY6lOoLv0eknGY/5lH/M+dAhl5dR7PLZ9iP3lwd7QKN1UqPn/aKWLblnDSRCUr
	 QQvNk3xVRS78algihfZ0I7CwtG5xL2DsT3fshLJNdqaoW+ynBJJx8ZlvNOuyPmCAuT
	 tVcCD8RqfDPBaXpkCcljnK/8UrAxVfVRHWCOYK1YatS+pB+OQKqQTIUJLaG0aYG2mK
	 h6QRGDGQJyPTG1y7Muo+uItkLOtqILvTl04kxAFBhIHj25QOXQGHN3blBOsG2OGQg0
	 9mTxZwrlzlxtseYUR0R4DsAecbVuBdd0If+utR5vVuG30BLKVb/hAl0n2LSHZB5n7H
	 Y8glsMn4WEDEQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 01/11] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Fri, 10 Apr 2026 07:20:22 -0700
Message-ID: <20260410142034.83798-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 02CA44000B
X-Stat-Signature: ojd5w8uswkotdycxwnd6ubxfef4pcgp7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775830845-930211
X-HE-Meta: U2FsdGVkX1+/rpNT3eA+YdPetHcX0N0X0OWEPeh38cyAfoVbRBdYp5oPNBOUMuBWOONnGMpAG6G3XBZXCb5Np8P1lz0cJlmsqUJa1M/k+JbSSxWxBOccWe7Z7pl2tl4BW1pbX33iajCsZByC642dwSyYdHkxO0rr4M1Eod6KNfEAkAGhYWLk1lafsJWbyQwhhYKT0Xtn91/QuY8+2fIho882l2/MxvzECc9iPXdHDLhs5pREOthvuFXmtscspqkzqh1qSyGl+zR5CSIqB6sR8qVnxv3bgm9Rrej+rMC31D+iu0jSqGrfLenhBytcmmC85QLPj/pxXFXq1ZKR2BHBbZGhXjPHoVoQP4wCyjuIPd/4iVvdEUx+GRh1Lk6h10Y4YpaWYFjCY9hDDg/0qD8Eo0dB9d8opqy07Q2698WIkq+KdCwtZ5j68PziDgo64ti3RrfXBpKpqUwfjzUb5tqrbLbyMM1X1/el8LtJ0BjWChv4lCINQINgaS0EJU5/MZNEl34JHJHk6tn2iKrfRcUdIhd0ojwzzXJs+7szVD3X5MGsDXG8szYoDORBzArZpv19SQuEmsVAb4AN6lMlhWTSGv1xu9AJmu26z9JLPedcKXtcC4BdZ1Sy1X2HTuDp8Jt4KsxDkCYx19C8pXN+hDdAHnioH5CSXSHVz9VR/ZfMrRvN+VCNsDMZO1kcgZSyDKfyECRli1u28mPNxMIXJcHmDV49hhRUYg0s5beSrzSCB6oVh3WZPTQpajpQJcGQIEOP7GDIcCTsXXNU5175boRGaUOGNCU21g8j19dIkfCNSvm3YdHG20ibJ1r1ySsLSE2NFwZW/QMTwOXh9slYzTmftT6DwoQu2AjyGwtUWyteHC8mgt943r5qL7GxJXqcv7+kqt3b0N+WtoTW/QICJjON29DUvKL7kkYGKj7A/5WkKQqVdziTkz4QOw4/u1j23i0hg6fnV8Ll5igePwRTCvB
 RCoI4URd
 v70BJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Less than min_region_sz remaining quota effectively means the quota is
fully charged.  In other words, no remaining quota.  This is because
DAMOS actions are applied in the region granularity, and each region
should have min_region_sz or larger size.  However the existing fully
charged quota check, which is also used for setting charge_target_from
and charge_addr_from of the quota, is not aware of the case.  For the
reason, charge_target_from and charge_addr_from of the quota will not be
updated in the case.  This can result in DAMOS action being applied more
frequently to a specific area of the memory.

The case is unreal because quota charging is also made in the region
granularity.  It could be changed in future, though.  Actually, the
following commit will make the change, by allowing users to set
arbitrary quota charging ratio for action-failed regions.  To be
prepared for the change, update the fully charged quota checks to treat
having less than min_region_sz remaining quota as fully charged.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e680716972506..c7d05d2385fe8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2042,6 +2042,20 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+static bool damos_quota_is_full(struct damos_quota *quota,
+		unsigned long min_region_sz)
+{
+	if (!damos_quota_is_set(quota))
+		return false;
+	if (quota->charged_sz >= quota->esz)
+		return true;
+	/*
+	 * DAMOS action is applied per region, so <min_region_sz remaining
+	 * quota means the quota is effectively full.
+	 */
+	return quota->esz - quota->charged_sz < min_region_sz;
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -2099,8 +2113,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2128,8 +2141,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 			continue;
 
 		/* Check the quota */
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2455,8 +2467,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!time_in_range_open(jiffies, quota->charged_from,
 				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
-- 
2.47.3

