Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B75AFF3ED5B
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539706B008A; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4963B6B0095; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E95C6B0092; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 148A06B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A844EC2B19
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:29 +0000 (UTC)
X-FDA: 84646860858.06.6B470D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECFBA180008
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DbCx7EU4;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926168; a=rsa-sha256;
	cv=none;
	b=pQWyQu2ohpLlPQqYEOBLvmqm1Irr6pZa9r6Zjzr8FzrM2sdeUCrmxs6CSAKeQ7atDhN4qk
	Ao3GW69nMLz003eR3XdmZXViW7f9RlOB52DtCfaUyI0MZCB84Q4UtqjltOxKNFqxHqDLMh
	Ckc1fnUDwWWUL6D+AWeGlXyslSTui0Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6j7TFmBTg9Y1LDj1OQWZ3x3f0H58BDhOvsUBmkiMnD0=;
	b=oYnVjcHhV73foFdLfgN9UjP+Un+lbd55YIsNFZgC1u+b3XHzDTq1KvEu1RoDIWk3B1n4Pf
	GjveOCG+dpQUmcCZAw1sglQDvJ4i9qZNkxzfYFm+MCHKZk7ckdqF20rftkJEm9EGjsYaTX
	gfIHdP1Tei/K632Hmi83oJ18AmL9ksk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DbCx7EU4;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 279A84450B;
	Sat, 11 Apr 2026 16:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6406C2BC9E;
	Sat, 11 Apr 2026 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926167;
	bh=npLjo+Ub0jfADcpNQiStOidPGi9YtKWTfRmpcD4bUVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbCx7EU4DkavFXcQNiXZ5mWvrXiQFA0F3pAsDJ/VLh0JgBFCxMb4Cl1wYoLswacdB
	 R1uuFsRfE/hVOyhyVJlXxRaBW93XyApy2sD17MudVmakjNGpNdIa8NfBd0MoDTm9wA
	 k2lJLIWvhzJIScOrHyeCrXAgPvFG0IYDPwFv6T+cjR9jwwqw2UGFeJqbajrPe+Djgm
	 ouMgaeiXCP/WcUntWXgbTctfhianWyKg+eLexprsZVlrt/W4mGo2nj+9STfWpdPjTK
	 HrhfTHqRO83wUcZzyA8fzwU0W+ZIc1zD418HY/RtGisa43S2L3g86eNfCaZxWitymY
	 r8KAVAi+duVwg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 01/11] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Sat, 11 Apr 2026 09:48:54 -0700
Message-ID: <20260411164908.77189-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECFBA180008
X-Stat-Signature: 3hz83e8hyjk4oz4xefs8iqcy6sqqz3g4
X-HE-Tag: 1775926167-410990
X-HE-Meta: U2FsdGVkX1/pitLTdXuYCMID1xAKRauQ2HdsQg5Udyn8Y29wKpstRttmBJ5Or+aW/1L1P89shrCaKuwGR2akv1mJmC7Xz4TJVTQREGI4zKJIQvbBd1thHZ3B298Q+3tveufoyH/3vTha57uXxN9xM/TelQMAzjVI9gutD1CTUsoq0Ja0jQlR1TFIhv1q+MQZANw6uZ9j8bce+s/JNFZDV9GtaEQ2baotknP3WzPJ+Pqms2pvrFyDP4a97UB4jlYMQ3/pXjIMNDeBLI1jbkrrdiGyharXtX538PdYecz4BtCir49QLBBKizvmD3tSwZSen4Sgo/lMAChz2TY5D9V1IeAH8HDbBnitme6o5Mj95VDfa3o4e/ebkqJJDmwZZEVeehYNGk5Q4tiqIIYUsYWBzztRlnzzq192zIgPBlsZbhXUlMiGajmm8xMJvrbUI3++1T+I11KGNURNsvvhZEQ4+IdWVKU3YtjxEVFdTN9kNh/4JZ9+0ia7DxmASsrGnmfYz2zubBCf5RklyD5FDVMGgMnxV1TD9+CDbBNH3799nCQKerYBtWDnLma28Vfjbuj6FEyYR/x585vOwSw4ApzR8Bl3fK9hEqhF4HqJAg0wz7O1zqaFyw9/LaVDESPwF+RPvfcwvWLAVTuCg6hhsuO4ntkeYd+HZPGo2KZkAmn7ZgRYw4nXGZ5CaAFT50n/gM5Z1hY8i3pb7wzmQmsiLxPkjMBHefsJNu7PdWkS2HmTkiYMMLE/XSKOeYGIdkX4XgfeODv3BSDkOLo/c+JmblmmVd+J8tgq/91xvALAYfNX/vN0I3iFtjJHpM3UumC2fyD/L19OH5SVLc101x5ZvAbsrGJZBukIIxGSrB6/gm3i0Wpjc5gUW1R7+fer1y9TBebEli2gzw39X4TJQMj4TYdP7+/bapEO0A+4rf3YxxHL+kRYVpYQzJypJTv94CZ6KStFfIKup6p8YXyPJcdtXfl
 +2MaX+rB
 bun4DnBI5UlHgnCsne1npNL0jH9DXlf4RPMFXBrZHILY/ft/sL7c5FT4GVAXYxMxH+k1j1xmizCIUN68uKlDOuQGCvl1e02DtA5xbr+IA28q0eHFKziH49jCrtyglJ4Zb3+bAH1agwC9z+6S1sfEAcEGgYdhJro5eduj9xsqxRkWYnnkJO0xl1PHgiJdTeqQS32tZrPJXesW9z/jWCoh7BDTVOm0cfvNIGf+BqntowqAPSAI8x5kg2BTakc1q60hapYD0PQMfS8pQWBmduOtyGAal/A==
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

