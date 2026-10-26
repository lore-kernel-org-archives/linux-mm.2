Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624C7606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8gwXBfE
Received: by kanga.kvack.org (Postfix)
	id 7FCCE6B05B5; Mon, 26 Oct 2026 09:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADEF6B05B6; Mon, 26 Oct 2026 09:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EABC6B05BF; Mon, 26 Oct 2026 09:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4564D6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:33:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFE391C3FF5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:33:31 +0000 (UTC)
X-FDA: 85364869422.20.A641566
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F7091C0011
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:33:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d8gwXBfE;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3QJjgBNhhMcU2h8ryMvyVAOJo+FmKjFcCzZY6PKW7M8=;
	b=gS+ePn1KzWfDEpy1LuzPnWGNDvk3WuujfwE7/XJzrdOUXNQ3diqzszOdPDD0zUomfMyYh8
	tiSalQPF7aSiiaGPApUUIP0VwosK4zsLF1i5xSUr1tQp+LBESDYXa9KQaYo+5mHb/JmCbv
	FitGGhvOwE8fHR/FZa9eGmRdeYl2l8Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d8gwXBfE;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021610;
	b=2IdAhXxCNURR+8z+gC6El+RFkQCUEADphcgzId7orChlCFbS0lzGv/Gmw1A6Vz6I8j7RmI
	7mLH1g26ToNTR9zTZdBHepOYd6sHaQynaO6ijMQlFEyU3NUe48K1lUSYj1HXMFJmdIlATT
	F/oz51We/eqHuFGX6c58R22ZZf98Buc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BEFD8601FB;
	Mon, 26 Oct 2026 13:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1CE1F01825;
	Mon, 26 Oct 2026 13:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793021609;
	bh=3QJjgBNhhMcU2h8ryMvyVAOJo+FmKjFcCzZY6PKW7M8=;
	h=From:To:Cc:Subject:Date;
	b=d8gwXBfEJjO1rmMFiYe3Ur+g7oPaJCfSXRVjqlORKGG4scOzcIY9NsU46uIErcxZP
	 nIXuqF7X/B78sTjJdf0FDC3r4xDSAp7rFeQsbBtQzCeToh74fGL2UHzvv/4uk3v5Fz
	 Ub0Pbei+dlTqQ0wNVDPmggdAPCto0QzjDesvuS5+rNk5mmgyMVTd8PbqAjBVOpe881
	 JCHNQvKyRtsz0/IMKprpdc9rVIJeU7Z8y/a2f0meIXaT6pDjYP9FK3ZtrXOwMKLHWm
	 k+LPldK9/bEqSHejvXSogwMO2m3PsAbAYtNNuRLYr0OUGJeB0hJSxKEd7aWIoFGSmt
	 A4Vxra7J4HCuQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7.3.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 06:33:16 -0700
Message-ID: <20261026133320.68445-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F7091C0011
X-Stat-Signature: 9ph7h7gzd1rqno6uugcm65eb56fe7hiw
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793021610-390757
X-HE-Meta: U2FsdGVkX1//b3dUUZnc69YLVVvDmBJmihIp6MlnMoWk2dKdiaxgcWF7n8+vr8lFFsEKnxqsd+D4EFygSs0rfEBFOMrxk9uSXXMCEw+Ba4wEInjOAsmkiiByWe2MZptbgSoFa3YJ2DFmXZAgCjXPVlDBtKszwRdB8Cf19oR3Uzf7kLHVW1LOxdOZyKpbmHmSbvSwpGhMyNRasqy2C3lvf48TJ9jU6BsLEfDvekGxNG3lL2pS5R27b3Yy8FGzTknsmyXeRIKlaQfBRTEtriyDQry5REo9MHkhqZevJ/t4KjuHUmQcScYTO3JnAi68nqKZKHemymA0xlAxEpauwT/ujmaqssR24hz8Sd1gbL503mAcS4sDtNMaaxmVJ+LwwPTMS3mWSnXR8nZdEN/CbMgWXarEVQaP9lqKuuyzOvnTR61Tg+exLWTFjSWtzWH8rZuZ3EGxYG+VnHTxCZMVJ8gMVLz1EmZ0XE8vxIiEUZZxCYGooNXuLNLHMOyPrCbhJYlcEz43NFhk7CQW+2qT545UF9L6TrZXb7Q98xiVy+3ip943VVaj4t1HdFj8GOCpbUOdq6ozr+oggFLlP8NgSHJHn8Gc+j8Vc2NzZpjSCwqQ1MsevemKSqdWAVQV07NgwPrZWTvwZkBkwvEteJ6ofYfoD6XdNtU/5ZQ/uxZfzeyLi7rdceu0Xo2d3hZqayKzJqjpr5a6pebqs/HpvQra4WNDySw7fXokGsmcyfzmQC8DIj8VscvSy3PuDwQYCEpbTRD6DsIfDrA3mKy8ekTzgt6ht8IgBCP8iIGzukQAPbR1qyFPN5hs6CcV1NqupQdFIj/jIgCcmqmJqDylBG2rq2V/+YRKP/d7ChOAprZAXH/aBgG7myboWBZeEo0lfw0HgqM3DLeOmX5VGMzD50asY848VfyNhwJnt3cyLeOxnpez4rHLB+pOYbh3BRBVnbLilgymq4IM72NLncPaCqgMA3w
 HJcQMxIg
 jjclWAC8+/xmRjCzJRdp56GEwb1gOD8EXheNC9kixR/AK4yP36TbSX9LB+uqUK+PY3RNkgTKimjLHsWSdpZ18+avpguwdXnWFpZc6Y+dLDW9WNyJ1S5rTsklW5Annk/3HGthYeg1FpDj+CDR3Gctw4zt1tX5HqA9FGwA4F++X02nC5SQV46HeKV1D9MmYcpiDIwLfGBUUzpR7JCH4DZvyxY2ZOxg8exgPx20vGEvHJDsztm8OALea2IF1iW50vGA4Z0fA8C/lw/jzSasDXo65QRaGLV0hTQwiIImewF8xvGX+00DvtrVISHcH1qHcUZNwYxL1JX/d27H/GkefWJ6Rf7s6kM7ydw2PVJiyHyWl+qKx2FhlJ49qI2z7prmcUnWZMN58GLuwHsX2HXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Patch series "mm/damon: move zero damos quota target_value handling to the
core layer".

Having zero DAMOS quota target value can cause division by zero.  DAMON
API callers are checking the target value parameters to avoid that.  It is
easy to make mistakes in some of the multiple API callers.  Move that to
the core layer.

Patch 1 adds the corner case handling into the core layer DAMON parameters
validation logic.  Patches 2 and 3 remove no more needed DAMON API callers
side handling of the corner case in DAMON_LRU_SORT and DMON_SAMPLIE_MTIER,
respectively.

This patch (of 3):

If a DAMOS scheme has a damos_quota_goal of zero target_value,
damos_quota_goal() could trigger division-by-zero error.  Hence each DAMON
API callers should do the zero target_value validation.  It is easy to
make mistakes.  Actually such bugs in DAMON_LRU_SORT and
DAMON_SAMPLE_MTIER were found and fixed [1].

It is better to handle the corner case only once in the core layer,
instead of multiple places in all DAMON API callers.  One straightforward
option is using an alternative denominator for the corner case in the
damos_quota_goal().  However, the zero target_value is meaningless.  In
this case, the quota goal is always evaluated as achieved or
over-achieved.  The quota will only keep being reduced.

Simply avoid using zero target_value by adding a check in the core layer
DAMOS quota goal parameters validation/commit path,
damos_commit_quota_goal().  Update it to return an error in the case.
Also update its caller to propagate the error.

Notes for stable kernel porting.  The upstream commit doesn't have
Fixes: and therefore not ported to stable kernels.  It turned out it
fixes commit 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota
goals user input to DAMOS") which was merged into v6.8.  The user impact
is a race condition that can result in divide-by-zero.  Hence backport.
Reproducing the issue requires sysfs write permission, certain DAMON ABI
usages that are supposed to be uncommon, and a rare race timing, though.
The issue was discovered [2] by Sashiko as a part [3] of its bug report.

[2] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
[3] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

Link: https://lore.kernel.org/20260903010722.94244-1-sj@kernel.org
Link: https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org
Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org [1]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 610c4438fb66e06d9e693c0ad3b2c1be54c0d61f)
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20261025171526.157414-1-sj@kernel.org
- Drop RFC tag.

 mm/damon/core.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ab3c4d7549644..74d22a596fc13 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1136,15 +1136,18 @@ static void damos_commit_quota_goal_union(
 	}
 }
 
-static void damos_commit_quota_goal(
+static int damos_commit_quota_goal(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
+	if (!src->target_value)
+		return  -EINVAL;
 	dst->metric = src->metric;
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
 	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
+	return 0;
 }
 
 /**
@@ -1162,14 +1165,17 @@ static void damos_commit_quota_goal(
 int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 {
 	struct damos_quota_goal *dst_goal, *next, *src_goal, *new_goal;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_quota_goal_safe(dst_goal, next, dst) {
 		src_goal = damos_nth_quota_goal(i++, src);
-		if (src_goal)
-			damos_commit_quota_goal(dst_goal, src_goal);
-		else
+		if (src_goal) {
+			err = damos_commit_quota_goal(dst_goal, src_goal);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_quota_goal(dst_goal);
+		}
 	}
 	damos_for_each_quota_goal_safe(src_goal, next, src) {
 		if (j++ < i)
@@ -1178,7 +1184,11 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
-		damos_commit_quota_goal(new_goal, src_goal);
+		err = damos_commit_quota_goal(new_goal, src_goal);
+		if (err) {
+			damos_free_quota_goal(new_goal);
+			return err;
+		}
 		damos_add_quota_goal(dst, new_goal);
 	}
 	return 0;

base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.47.3

