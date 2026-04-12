Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C2DE937E9
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97EFA6B0093; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB1F6B0095; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698566B0089; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC8C6B008A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9C59BCF15
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:04 +0000 (UTC)
X-FDA: 84650415528.29.BB963C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2FD2F12000B
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtxpeDjZ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nizd2JDWHPz0INwDrV3zjTVejBgLcVO8wlaRF94S24=;
	b=78TjfX92MK3fMzuRAhTG2wVgyh95LZK5MHb8W07lg6ZxYlhxYiTk7yI5qQU7SdQ20x0OGS
	vKMS33OOWzk2lO0NcJFHJRHsdxOfKIWhjRGBd9dX0CsfXTWC1Ua9F4lhQvsWX3urk3EFsQ
	K7hnA3vA5wT1AlGNnmFheQ8nVGU6S1A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtxpeDjZ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010803; a=rsa-sha256;
	cv=none;
	b=jF0INYDuArAYS+2NxmdnZ5wtV11YvWc9nHp7Tq4Q7v444cJV2pVa1mh82aL63QMBLxyILB
	HwMwYrylVl+hM7Sz+mFaE8jX2X1XJ72E592sEF9AWDqka+thd7Szcu+US2SLyWxw3MVm0j
	Gwb2HHE9AsMGWqJtBRYZjVS0GMiUyIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3372F44564;
	Sun, 12 Apr 2026 16:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E108FC2BCB0;
	Sun, 12 Apr 2026 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010802;
	bh=W9Vy1W3vBVeqguIJu3bjj9rtcI+jfN71tbju0b2uI9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtxpeDjZw4HqSgjjpahq2DhS+2YQNXFsGCEtpJkEij14DWFlR6N1R4lvqLkoSvuH0
	 glJG09qAiZcC+CcmNjU7cWR/6iYtJaSM7lG/cssHFZiTKE8jE7cWmhaYYwIcdyfjcX
	 nVuVWX7ELKR/CBj2/dP9+67+ZgKvre34aLYNpPGjxyRPgibnH3lw/wmtzIvwxI4X0J
	 Q6a80TneaCOA8tbQS7FK5yzPmonA/6PaRm4UG4I82cSn6bEJQAFFvVLhAx/hFqW3Xx
	 uh06ICw46NqDII6Gg7p3QxpfuwXr5MVohnJxghin4uD3uLMiWpcIJ3geL33iwwBiaP
	 Ky1puH48j3W4A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.2 01/11] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Sun, 12 Apr 2026 09:19:44 -0700
Message-ID: <20260412161957.82835-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2FD2F12000B
X-Stat-Signature: axpfdhibkghqhr4kuhmbhgqtzdsb5p3q
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776010803-33569
X-HE-Meta: U2FsdGVkX1/NX5m0G46Mc8E/0DNrNJzMoCFPoH2MZvQd6TgD833fkmNgngvKmhDQGlmCxtqlhwdZNs8yJEZGZyqQTn7hfRsWwMtEaYy1DqDw0Wrj1w3pOgJ18ZKyqBUel0K5BTH8JcE6RABwzFTvtndMEsGDC5lDvOETjuLABflqWq1EBCxZyaiCgcqftob3mde6qnmKtxqnGxqZGvnaRiPT6rHwskTmW3S70A9DrDhNBW0+PGwZ50PI/hQZCjIGL4v/BzV35VKbedus+kAmL+GDHYomrX8o4cI+WuvW6d+Nza1CifDh5VDt2eyG8YodkO7z7UuPWQVecHp8YgXLpOK9N+Uzx58vDHHEG76Bmi28RZkLx5WO07M8jvyrgyG8o3WVzdaCacRVJRX8UOhKtppXFmViUcSc3JF5LHxhc0YQA9I+NIhwmu1pudClIRmarbWIfWlumgtdnVqkN5V/RaGT8VtH9qLmx40dJgasY1t7RsyNp6cJW0EQAh3dbfu9zE7LGI5ZHlLW+S9pnQvJCVPcykCbzBuZcwXlOh4r3SUSSM9o7HxXc19mxqRMZJhHlAYfoNeW63dMjcwoyKDrFv0uZlK63N2BVqr/V5d89FlYrKgESsLTbAql1ZkMB/+/TSFtZJWB9pkeuh5foqkXXoOdrHYQ3WZhuwF2z2tp+a/0QFYO//Dhb0sLOSqlXrtGtBLU7WzdLywtfa5D6JD0vG1XY1MkwKWCnywokXRcCTrnn4wg3y1fdw2nM0TDYrCEzxLi1edOBgCE7Pk35voPZt4tJlwM6INAa+y6QPgJroUNw9sxFM98HzxRmdaJNYLsv7DPDtylD7Dswjt4dxP5SrYj6ajNL5tjhfo8T2pSf1WodoAm0knspjUmgK7d8uFP60biac44+PUfQnJAfvqHZx0ClYVsdwxo9+npvAhw+M0fYE6Lp4yWxXPgpCIBQA0saAe2nbYBDpPggjiUJyC
 +4w6UJDA
 mchekhLkbQrmKLqlZg2ccLLfaKT6FR9ZMmo1L+pVB3n5flMlAUJxSpXnJalyd1foFVbVVf7X31dD+ft0/cjVITzG+atsjtG7Ik+9HsMot+aUTWMnTbpPV0A0eF/mY+WRHmudthIKOH5Go3YDA/OW7/zhHr7YmZsM5ceQF048sSsB2EWYPuvpSt8eccfqHuNy12BVphrexljiknfjtHQHhBJ/as/EmI1z+6P4oYNgdDn9yp6sScLgxXiVzasGYWSTDDT0kkLaL5W8fJoomChmAVJKkPg==
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
index a884df98c207a..e6add38e10910 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2047,6 +2047,20 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
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
@@ -2104,8 +2118,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2133,8 +2146,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 			continue;
 
 		/* Check the quota */
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2460,8 +2472,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
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

