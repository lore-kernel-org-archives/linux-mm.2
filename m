Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAECF31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5D56B0089; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2665C6B008A; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C986B008C; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 058F16B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA3B813BB35
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:00 +0000 (UTC)
X-FDA: 84639231600.10.059A379
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EF4F410000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:21:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NIxUwKtO;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6j7TFmBTg9Y1LDj1OQWZ3x3f0H58BDhOvsUBmkiMnD0=;
	b=AZbZsZFApleVUz+EHShRK1i7xaeik+xH8lYgmuuf9T5locoJi/oRI00QavSot7c2JNeTEU
	p2AXdjXVBLRubvXYEpXUJ97S1mtyZR6zfCZUuukxRl0pFAeSX+S3zq4PlxTtSQG9K7hE4C
	cNAekNwMKLkT3BRrDBzKLy210mo1zwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744519; a=rsa-sha256;
	cv=none;
	b=t/BNMXvpOfl1sb+sZf70yl5ChoP6nXsJVGrvfXccumGXjQstd+/ArhwStb9dCZBzk9pQX3
	9pqyYr+NYZEQHu6pHvIzgXLIfN9w1NIhwX8Pe6t6D5kbsIVfJBG+MnJWb5tskOcKa4/r4d
	v8gpEahd5C32hTmqaWjZi6ZzlGNUi4k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NIxUwKtO;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE8E543F6F;
	Thu,  9 Apr 2026 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91169C4AF0F;
	Thu,  9 Apr 2026 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744517;
	bh=npLjo+Ub0jfADcpNQiStOidPGi9YtKWTfRmpcD4bUVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIxUwKtOwG4ywbtgEW36oE5+pKMqXVhMcTVuPecSkbxd8ZbD7B6cdkpasYgCYWr9T
	 Ajx3KI+UCIrQIt2IOcu7Bg26hsRAwa44rVpX4OXAjAfQxv0VVqGnz/uOV83o5WONKw
	 oXMIOUB4i7PLiKIlWvIUoSk5vCqBzgr/PCF8qvhT8lhnF5zEuIHn+4fSARhUqhAEfq
	 pJ0rbqdLqGBlE2v32cN0nq3eR62f//CyVOVt98XHsnqv+/X4SEWh3dpxNKTvHcrpBs
	 Lsf7/ctPOZw1v7B9ucRqDo52tH0uVqdNhU4wv7SAqQ3XNv82edAFdglsRGevaNFR3x
	 wUDmpWKt/OWPg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 01/11] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Thu,  9 Apr 2026 07:21:36 -0700
Message-ID: <20260409142148.60652-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF4F410000A
X-Stat-Signature: ryhugkacqt11bxd5fz39wo754hg7pkwq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775744518-122214
X-HE-Meta: U2FsdGVkX18GKEf5xOueZoIt4Vzv2HyDNPZf/eF57xr5iFBgmnBS2Iebk9k2ruqayzoN67gkIYeOJCKhvi4a0fC70dsbUefalONwP4H8RWdVw/JsiPhJTkt/0Iz5kezLp3Ql8Bj3MSuwyFci1B2tfrXbiYUYYJufnMp89jU74Ox8Ey4SoOkltTAhBRFw6NFntnAYqyCYdS/bwcdMPxiRT8bhvbpBiBqTzTYjNv1ul7yUGIk1wxzKNBn4KEqfh/shy6+8jMQJAzaESlFneU9scAHypqKlpto2V38pAJZm3jxH/xT/YaDR6MRjnXJJ21as6IqcykYj8WXNGHHXwKh7r4e5oS6aDVjeNCv++ttD0XEMmyikTTQ1Msx8t6+rcS+ofMqzrwxayV8UOd63aAygBevLO0JIEzvXDa6z9nyTERh6jmjSzcMvm8D2bphD1r2OqVRXw+8ry3Z/s9aLCF/eJF+b+WBJKJOBeyiBskT4LWCZe3R9FsPXWjxDchWLUib2s32w8W1aI+ZmupdoKFchF4oGhvqlrvQsXDDEIb/Kw5H3jr27d3t+DYB+JJY3kmz/3dx3kDiFs/5oY6wWFx5WOSMkgHim51bsU5SjmHqSDu8upg/Xv1qZMl3v8pRL0Bg0zQR6e+bSvSmv0ohZ8Dydm22TDtrhG20xnOqQUtDq55oIiY3DkkjwwfGGc26RJhmkag7sr1fNeQdVFj13pM/sAyxf2hNXp/sOYUK4s07wb6OdwqlQ8OmbYHAWS3zk+XdcbSMNv9zazQ7eruskDKegSw3N0yu01Pt2/iMvYo1qtd6+XniLqUFvFfh+zNwAI0w3/6wLfu3MJiX3UHXmHw4uHi9tXTfxrkgdAnIa2G0jAxPWMpKXdLEFu4p+QvvMg4Rg8/Wsp2pj7zTspeqKmI7nek+PSCMeOWamwpvSitCfZE4tKw6nUifnCtUgA9DAMFeAmdgioKYP+iatY9agoqF
 rCrZOSyV
 DYQeai1BPH7PZSkOLMjMdPKcEZCkR6QZt3m6lRfNS6w4dwhvWkx7b4pqB9L5zgoliszjr6Rs6suJgYjr7y+5XoBF85dydzDgGUdyVY2j9gUkNmjhw4Dm9rOA4HlEBjqj1TCnG75FHuGyxJtCmXZCARaIGJKhy5fjHXMJu6ExFollQ8wYg7u3OtJKd1ySCkdcpITf0D+S2trVVgRF2ibu4LRATn4X1hpjog51NHn6lYOLGZBmFNIPcedyKRUNMRiqE29hjmVsaNjWpqXmtLs5U6mrmKA==
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

