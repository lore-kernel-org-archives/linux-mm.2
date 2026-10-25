Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B28606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Om0gVv64
Received: by kanga.kvack.org (Postfix)
	id 6F0316B05B0; Sun, 25 Oct 2026 13:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0B36B05B1; Sun, 25 Oct 2026 13:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6306B05B2; Sun, 25 Oct 2026 13:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 341546B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:15:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8970A80573
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:15:36 +0000 (UTC)
X-FDA: 85361800272.13.DDAA217
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DAA46A000C
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:15:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Om0gVv64;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792948535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DAENk+cctPe93c75V7p9sIsmyuSg6UDiR9dUUMQ5Phs=;
	b=xErclclHLCL45QUNGNgM2pqNN+6O/dawrhMuuPYmT3/4XzbWuH8JbIYgWIlPPbhPpn2TJw
	4J/5i60xR4K00JS8dLn9BaMPEPe3WLlyhWlA37+wZ5fUc2XoUv9Kc/85PjpQWChM2YsngO
	ijcB7p5NpVnAZZJf0xqW76Z/iOrUOWs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Om0gVv64;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792948535;
	b=WLwTx/vmrtLWsXA6EMcLeeaWxeXSn8W2MLRcEfmsvxDzPRqS2HgduPB4QdxUkgMbIt/pC0
	tpnrO9c7kVY9btkZRdJq8cctYwmSoj+87x/KGZVBRt35a5XLCCn+MiDj+dAZjTWayDFlud
	f3FVD1WNvHS/uqLE8Mswbeug+X4YTD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 054EA41232;
	Sun, 25 Oct 2026 17:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD02B1F01825;
	Sun, 25 Oct 2026 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792948533;
	bh=DAENk+cctPe93c75V7p9sIsmyuSg6UDiR9dUUMQ5Phs=;
	h=From:To:Cc:Subject:Date;
	b=Om0gVv64HOumU1N1ER+f2HJvdZV0lCn0JRKPEOIP+1IQOo0UeiQmqUD8Mjl2pRelz
	 CkrGFIoXOIZdKKV/88tLEji6ZFWSDyBiF2id7AyEqg/WEVkj1lOmILnz0fOApi6y+e
	 lNS/QcDesWoWg5w+877A4O88K9Trtpw86nXHEf0LigmOlwF526qOlrnTLtjIvv2fJf
	 82OV9+gBwT5sqGGV0EKg7AHX4ANPfAB3JjmtLFPAf4fTA/u051P/V2B1fIwooRAvzp
	 svI/j+pYPYQ0MRIrMR0qM4KT285f6VeYXemULvHZH416QcwjTKCBtQBQjBejRzpiX6
	 tVOpdA5qld8Bg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 7.3.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 10:15:25 -0700
Message-ID: <20261025171526.157414-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DAA46A000C
X-Rspam-User: 
X-Stat-Signature: j4d5nrxy7d6sx1tgmqg6uai6qhszy9qo
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792948534-78399
X-HE-Meta: U2FsdGVkX18v/uWmldIrje5+5A06o0WpV3bwHEMhnvuJUcq2PVi66gwcLqwQrne5ol6M6oBjy2dVbGqeykSTncm1e0wm0OKxdXHsPvg5X1aCF44HbQUVcJpIcQZfilx11OpAJsqJy55opB9eJZ/VbMb1W+GrDcJKXNz/Y7FV5LS22xxRz7cp5DIy+UllAFgyurEAEkdVlJHkXPyLUqNqD9CHYHqdQLjLSdML3ivE4jqabDIXZw4smuvO8FcIMGy00eSdqrx31uoOn7MimHLwxD/bOppLy0dL5VnJcW0ab0xG3RI7JvAoV1diL0RKuyW+CdMZ4eADJWqU35dhzMa59kaB7LnZ2EGtXiOh6nA/y8itSCqnZ/XO49FHVaN7w/JeKvsO5mofIw9cGmsqqGKEgfcj/8WkI0nLdu+5XivqUBtjEyaLsYiGiER1paGHG0LzAr6AnsHTvH6aO5bz9NSMKDSJ9iQPBWjiBBxyRGY48y69UmjDPMoUzvIN2KMGGpv0JN8NS+UCDSGQsgwMHUulbJ9s3YNJwZ3hxpeCBBRszWBSACeUSgHRxQguZpULntQ7xn97SeOPIluKW/R71XKC22i7fJyWu5d7H/XwJ8JHi9wt3w1nlowbos8ODzbsF54QpeopkZNhxnQvl+ZpnZWljXMQxR6ePrIXcV/PJFC4FzSrxn/bgYGRxrqfue1LEL/Z936ARvWlHDe8m+ZJ28e7pex72vuE9bW82DgehfSI1NBK4nIUuRlJ/MaXIbR5bfBTckyvpC5VOs4N1W0G/926eLghKd9Gb6ns5x8wVZwT8N2jZTudgG2yaewFIyqhbhTauQPnoq+tcNQIl9MY8pWMN65zzBMXOq663P/ZsJPCrVIy3onUf75tRkWv3ooSqP06uyjLZWHh724kRamGizQmMiZ5NO1gVlmf6pz2yQsAQPyuNtOf3nVV1ohFYCdcDsjVQt6k9DCkZ1QqXHW+Dch
 /SUNW3JS
 ULTRPCmyFZq2Wa4ZUr0J5bFuHetMu/ymu7BBiC1ggtjANPHGl9VjlQsmmqRbyDT72cubWvt/PyJCygS63bvxR8u/Wwct42jMzdGw81jklYCj1LOZNt5cIPFWYmMmUujRn82+6VvZ25jtj17sT531tDy0G56YEiMWLVNmMiZqBxGgTmtSIdUBaqHNYqH7tgmTOupAfGm0UxLXY0g1mFhvzg7bJOqwc/XZW9kZ25dFCRkrFDJA0G8AiFiRP3TBU9A1w25FGnF3NEvIIdLLB9Xex8/G2fyZo8lRt+XGyKgXfSZmj8q1OeusBev0fUFl0Eb0vmooXAgdA+RKaD61+B71jUEC9X6ZsIa/RQoU/KybGMKrWd8gvg4xkz1MZ6G7tNz3f0B61bM7Om8AulH8=
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

