Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E624DD73EBB
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 19:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CA476B0088; Sat, 31 Jan 2026 14:41:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144216B008A; Sat, 31 Jan 2026 14:41:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F306B008C; Sat, 31 Jan 2026 14:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D59796B0088
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:41:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0C90D4E42
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:41:53 +0000 (UTC)
X-FDA: 84393279306.09.3992FE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20AC6120007
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:41:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oCCZXr3y;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769888512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcixyPBpHEDGq+FCaTbw1A5y/SwxHbictGqdPrmjIyk=;
	b=DZpdvxPGCgsGZSLGioqvJUGJzJ5E+SD24Rd+c7vnx5edDnWFi7VbBiJJz0TkJTG33ilqeg
	EQgbDpRuSyvpKkmg2wwggfPmW4M0WJnmUM3OthfoER7FSHjz6/dxm1Bzz4iCdRYuZOWJGn
	NBI+yFCycVSr+ykWXbY76LBOT7c7bkk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oCCZXr3y;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769888512; a=rsa-sha256;
	cv=none;
	b=DRGbRkHVIN2zCuSxEet15kJuVdX/sfJ81Q0Us2pkb3Ib8D3ZaLvwEM6HCujDCQzQwwo1O8
	18bzlqRySfJQPPxaIt2icZN5r5EDhH2xuDmaHG9c3mBjCVY07H757z4Z49RNIXpEWDySPK
	pU8pLsQIVIeSIdM3xyUFAbDrcX1Izkc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 502E06020C;
	Sat, 31 Jan 2026 19:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82F3C16AAE;
	Sat, 31 Jan 2026 19:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769888511;
	bh=lnT/lb6HZwlGefgSd8TpInNfP/02SBCdqDCFlsJ7D/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCCZXr3yWA3gjPRkQLWbix16ivBKTW8bl+WFDFagnAMFyAyqdd9tdQc+jOISZt3jZ
	 Er8w33YJNdydGoqtTydTJivcymssb8BtdcBeNpmfjG2TTNZFICeGX0/nKxa94cxyqm
	 krYWgJ5ylX/ujXDJKmQCnsTF1cpDsALAiq1UOw9v7m3UNjmUdB6HnkzjoaBjDoHfZH
	 kWXaECxsSiCf0UtsdHR6xAwpoG9s5ypsnbBXHR8Hc7WkTbvnwrByj4g74yMzSeoZfj
	 v03JrPWOkATnuly61D+P8/DLeb+PM87E4BmMHowAvCOMO/o5ScIBnJCeNjlwm+/Q/+
	 sBgT0vPpgl9xw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/2] mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
Date: Sat, 31 Jan 2026 11:41:43 -0800
Message-ID: <20260131194145.66286-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260131194145.66286-1-sj@kernel.org>
References: <20260131194145.66286-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20AC6120007
X-Stat-Signature: 1sr7xwj9e7yufu17m4ayaydxa5tt61k8
X-Rspam-User: 
X-HE-Tag: 1769888512-199168
X-HE-Meta: U2FsdGVkX1/bxzTKmBazMu8g/4wK4plrb+VZEG2J9fO/x7hzefUiH6xF2i2CJjGpYBOUOX2I5zmu16bDebdeyjNpznpxb4jUEinfdcG7EzDe+U2SmbVZU54G2QFQl5dc+jrylDCY2Tfihw2SS3E2iZCkPqmLdyIP0xtGMG6tm8A3gpdzqpC4EGJU5cVwjiSE/3xSQV2qRyvddAF80nTq8Nhzpjbrig7z08jrLlRAhdjba4rZe8MfIrbNUJ0OBJCTUmL1QOeoTfjTNZgwUsgFZwNrm5XL+6wp76FALxCnmAoSOw3IdE8MBM8h5n8lpqz4iApHEacG2vn0m++2EFCirEp1xALs322ADoE3Lg6G6ehMt1draKysnQgtMasYhfDNSwIqFJAKLBHjauGd35qhPLxNu4AYFxw6kdr5pP3PMoUDVUMY38k3XZvoEw4gcILc9det6SacsxuEy3x3bs9OCjK5yht4+y4NydOBPQvxST4k4wH39tTLSA7qOtLdcy/uTv68TttsX6V0DgLZ05zorCuTdlVWiOD76Goi4KGOpDdblR7HuORtfHZ1Va8v+nHfAbqf1iGrU3ypaVvt0/3fkNqB9n35FVCjC8c+MSdh2+43jbvo0yrfN2aGl+th63ItO+w93vT8V/uX954ywMViOUB3lrCCGUI/T87CUb8+q8CHvQDwfB9euW2tcayxgTJh4Dt3pUS9+/7ACGZQYKF356rfPOIipVsK3clCnp/Y7/uAq0oAbEdu3bA9nVOI9pjg7jIirW/amDOJLUB9Pk3gd6BnB0sVJORxr3G/0eGL/JfXO3ZhW9SemesfisysdDyfVNott7OJBoWMVoCPQgzAAe0bqpUh67bL/mC38NW/0YH+AypmECIwNlF59FszBYXtX+SbCdSYocbcUBH2FCEVOY8C7cM2t51yzhur/lO1QLGXLGbp8oLmFh8lJ8Ept8OG2EtGt6dBSE8E/vSHyhS
 +qC1iVES
 U078G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_apply_schemes() is using safe regions walk
(damon_for_each_region_safe()), which is safe for deallocation of the
region inside the loop.  Actually the code does not only read, but also
write of the regions.  Specifically, regions can be split inside the
loop.  But, splitting a region doesn't deallocate a region, or corrupt
the list.  There is hence no reason to use the safe walk.  Rather, it is
wasting the next pointer and causing a problem.

When an address filter is applied, and there is a region that intersects
with the filter, the filter splits the region on the filter boundary.
The intention is to let DAMOS apply action to only filtered address
ranges.  However, because DAMOS is doing the safe walk, in the next
iteration, the region that split and now will be next to the previous
region, is simply ignored.

Use the non-safe version of the walk, which is safe for this use case.

damos_skip_charged_region() was working around the issue using a pointer
of pointer hack.  Remove that together.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index bda4218188314..0ff190ed8a599 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1707,17 +1707,18 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow and saves the second
- * region in *rp and returns false, so that the caller can apply DAMON action
- * to the second one.
+ * area that not charged in the previous charge widnow, and return true.  The
+ * caller can see the second one on the next iteration of the region walk.
+ * Note that this means the caller should use damon_for_each_region() instead
+ * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
+ * the second region will just be ignored.
  *
- * Return: true if the region should be entirely skipped, false otherwise.
+ * Return: true if the region should be skipped, false otherwise.
  */
 static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region **rp, struct damos *s,
+		struct damon_region *r, struct damos *s,
 		unsigned long min_region_sz)
 {
-	struct damon_region *r = *rp;
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
 
@@ -1744,8 +1745,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
 				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			r = damon_next_region(r);
-			*rp = r;
+			return true;
 		}
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
@@ -2004,7 +2004,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		if (damos_skip_charged_region(t, &r, s, c->min_region_sz))
+		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -2347,7 +2347,7 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r, *next_r;
+	struct damon_region *r;
 	struct damos *s;
 	unsigned long sample_interval = c->attrs.sample_interval ?
 		c->attrs.sample_interval : 1;
@@ -2373,7 +2373,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
 
-		damon_for_each_region_safe(r, next_r, t)
+		damon_for_each_region(r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
 
-- 
2.47.3

