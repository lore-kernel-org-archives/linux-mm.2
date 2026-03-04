Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E84EDEC09
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBBF66B0095; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D512B6B0089; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB5E6B0095; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 956C86B008C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DB8D140290
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:31 +0000 (UTC)
X-FDA: 84507131982.13.71EF3A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 77B0F120003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u3ep8KwJ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cflitFAVWuv42FJKKMhx2p9MbrL5Hz1owt1TPlrFwS8=;
	b=SUVBCTxYF9V/SVz8cPRse4hWAzkV2fBmHm76TIpBZSEDQ41Ebf2owejTrHYRtXz6lbphTT
	LssC8ELSoaKjI13jeiq6B/Q8+dzT3H72SF/ZQtAwRemSsNxp4Y4AYkCYGqKpBBvicOQ4qo
	r0CfHVNkGCaE1WU0JZVATDFtcfGSoPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599289; a=rsa-sha256;
	cv=none;
	b=MrAMrGmC8sDFrO2sa8kax8kzlLjnr4ECu42YjArpoH5/s7vYhin7rQGHt5D49fsGUeaXKA
	VoGH29fwMVqubonmPOGHGLNwwdHxTswyJGm0r2a3zeDYzuahzYmCRT6W08hFaMvhOFI/rr
	/dNu6CanHKpwjhQ/++U53IRGO6yoeV8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u3ep8KwJ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E89C4438A;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B473C2BCB4;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599288;
	bh=FSeP1l4raWSiTzOnRD3+mpl3eioMh5Ef7ZEq1X1JgZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3ep8KwJcHwF+wcxjnesOCYJHluM81kV9IESbDiVACHnoP/1vN/7revdp1jrXupSL
	 IXD2vIgFe+xnhLsU/0exnuEVJuOwkxWCK/wiQPxYoeJMKvYle9XBJ/9O/G5w5qSdnY
	 Z2SqdIVlDKGqEwfr6V2XcJsyN2cNrrXsopyAycqdaQ7vjs28flwVP48nY/iTeS34+j
	 cj+7/1SdDdkFae2S6szZcsj7bGK/tbHw9Si4BcEAXGAu9XVRjZ+Gu447DuVO3iuYSS
	 j2Jev7XRN7xc/R8LCQup2APC2B4PP7XpGqfRHmNhc2eRFR1nzir17GAofvPlRRmEpj
	 R1eNG/e8mYXlA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 02/10] mm/damon/core: allow quota goals set zero effective size quota
Date: Tue,  3 Mar 2026 20:41:11 -0800
Message-ID: <20260304044122.79394-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: onx3x81s7sk6cb5fsns6hzbuey7ec15t
X-Rspamd-Queue-Id: 77B0F120003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772599289-956398
X-HE-Meta: U2FsdGVkX1+OXwFgXUYK251dtF20H+vGPv9e/6tpKbslpjs5JGF0DWJR+n6JRB3a4NSsTr7MOBeSycYyPmH/xQ+WY2uGHV4+b25SbxptqyxaxzLCW86Chg7bptbdJ6RdMJO0QdPKJYFKbiU1PloJqw65f2BEbSfGNA59n/i86B1iGgcpCfcNEE+CP3Nbw4zdiSWuQ7gw16qCN8SYTE2wEO3+jpV2EK20NIaZYg/Y0dX2jqSAUR+25FyS5ii0Yc2fpBdlr5MBIYTepcRcz1tbLdp4919GOk/cyTWXBzp6YREzTQYpatny8dQFxuPB4ue5Uk8udEDDST2C3GbawtONtpzNtVd9c2eXPWxPE9EbBZ7I0doCPuYYDETU4HwWNAOVWoqkL2O+3PQjukOV7CHXJXnDVltNK+3nSClVZQdWvsNYGDRSw0X7oNJJnMfvRP/NUYB57LP4gFTkfG7nEtVBlrUh6VjOGwkwen1SAnIT736bl7mBWPr7CPYZDj9Ke4tMk3BVTN29O14B+xPQ1AeQNg0MTncaA0scizkvtLRTWK6+S8OIWmIBXMKEUi3wawrfW6tr0uuX35dZmgacIKPy09Wo4A2h8Zea9Urw4koINLwKrZHO4yBSoK3yUam6hT4lOz/Vw7BaDX4keJO35edpoyd7aPiuJrVPoDSouD7cjmiC3mhCe/9on+eEyDG75XokshOgVqTX/6LcZkD2UFFzdX7Lke593f9YfRvu1ivxYROdpwWeKa2i+csE4kB8riyNO+L0xFOvKJAowVwZFu5eSHddA5XUtqbqExjqFUJ17MjBM8vJv5l1RtcDosIpYIieMgi7B4iWYrfQX4uNVe0ZP3dVcCqQHKFhNn04JEN5xgykjhB4QYJqGBKN2BPxx4YSncPszshUeYbqGfM1BvTGZJp/eq9qbDrQxye6pC6CRgw4P03G0AGaTPmfYpx899GpbZKUVJIZgImZgV1bL4G
 VzhNCR+e
 8udS9La0pxfnZmJ253iDHEIEKkMDp7UIxdOM9M9B5O0j3s1+MnP7vXXgtqb6Z+C/+sfdSNzZPm6qL+YZ9GpZVdRiQtGWQ2+nyyBh9Rkmvq2OOtPZRlgmifY8si95EAPG6dI4S/qO3H03k8ehHu+MYQuUt3Woo07unHme71iR4sQuSNMTAy8nHJwSCFrd2sR4hbcLwamh5OOOjzYce3YV2xAzoMRcW6hB9Pe8RlaPja9c0XkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

User-explicit quotas (size and time quotas) having zero value means the
quotas are unset.  And, effective size quota is set as the minimum value
of the explicit quotas.  When quota goals are set, the goal-based quota
tuner can make it lower.  But the existing only single tuner never sets
the effective size quota zero.  Because of the fact, DAMON core assumes
zero effective quota means the user has set no quota.

Multiple tuners are now allowed, though.  In the future, some tuners
might want to set a zero effective size quota.  There is no reason to
restrict that.  Meanwhile, because of the current implementation, it
will only deactivate all quotas and make the scheme work at its full
speed.

Introduce a dedicated function for checking if no quota is set.  The
function checks the fact by showing if the user-set explicit quotas are
zero and no goal is installed.  It is decoupled from zero effective
quota, and hence allows future tuners set zero effective quota for
intentionally deactivating the scheme by a purpose.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c5503fdb10bb7..d657b87dd99e8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -387,6 +387,11 @@ void damos_destroy_quota_goal(struct damos_quota_goal *g)
 	damos_free_quota_goal(g);
 }
 
+static bool damos_quota_goals_empty(struct damos_quota *q)
+{
+	return list_empty(&q->goals);
+}
+
 /* initialize fields of @quota that normally API users wouldn't set */
 static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 {
@@ -1782,12 +1787,24 @@ static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 		r->age <= s->pattern.max_age_region;
 }
 
+/*
+ * damos_quota_set() - Return if the given quota is actually set.
+ * @quota:	The quota to check.
+ *
+ * Returns true if the quota is set, false otherwise.
+ */
+static bool damos_quota_set(struct damos_quota *quota)
+{
+	return quota->esz || quota->sz || quota->ms ||
+		!damos_quota_goals_empty(quota);
+}
+
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
 	bool ret = __damos_valid_target(r, s);
 
-	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
+	if (!ret || !damos_quota_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
 
 	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
@@ -2057,7 +2074,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	}
 
 	if (c->ops.apply_scheme) {
-		if (quota->esz && quota->charged_sz + sz > quota->esz) {
+		if (damos_quota_set(quota) &&
+				quota->charged_sz + sz > quota->esz) {
 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
 					c->min_region_sz);
 			if (!sz)
@@ -2076,7 +2094,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (quota->esz && quota->charged_sz >= quota->esz) {
+		if (damos_quota_set(quota) &&
+				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2104,7 +2123,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 			continue;
 
 		/* Check the quota */
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		if (damos_quota_set(quota) && quota->charged_sz >= quota->esz)
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2389,7 +2408,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		if (damos_quota_set(quota) && quota->charged_sz >= quota->esz)
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
-- 
2.47.3

