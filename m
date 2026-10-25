Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCFA606A333
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LKbdKhtl
Received: by kanga.kvack.org (Postfix)
	id AFE3C6B05B2; Sun, 25 Oct 2026 13:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE566B05B3; Sun, 25 Oct 2026 13:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3716B05B4; Sun, 25 Oct 2026 13:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70CE16B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:27:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02E7F805D8
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:27:21 +0000 (UTC)
X-FDA: 85361829924.11.E40D5C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8169640004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:27:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKbdKhtl;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792949240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uOoKQ2PnkH09Vk1jw7K1oh5n4BU041veL5ZwyfeSI9g=;
	b=XISWs/fA9PwX8bo3GMnbPpK1lNKz/NJ8Vxb4sP7mtWUl2rP1KvvAfI9Rqyho68byBFVNsA
	0L3idyfbsK/ZwID6l1nzjn8b0eXZUiBmqnayC1CZvNbbfXcpLrjIyltl3z+LAyjzEka1Wv
	eek8WHdouI/AiM6SXShYptyZBaUYn90=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKbdKhtl;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792949240;
	b=It2XJhpgR5eg/1G0WQfw4aN8+oHtO4kOjQgdZS6eah1YVNWVkd1RWoWmrn0FshWFuFFEoG
	hvvzYwh/98zriM90q5So0bJWnA45d/pOtQtZW6AgCnkP8SV0iT4a9VzNBM2e3LBMeshcbU
	RIyf9eF4leHAy815hHRxODeeUsCjh8E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 124BC600AA;
	Sun, 25 Oct 2026 17:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC121F01825;
	Sun, 25 Oct 2026 17:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792949239;
	bh=uOoKQ2PnkH09Vk1jw7K1oh5n4BU041veL5ZwyfeSI9g=;
	h=From:To:Cc:Subject:Date;
	b=LKbdKhtlyoXURqlHoGmzBroiGrBMDMwQO1Q9HBle3p+cQ765zXSLB2jNShjsJ5ykb
	 N10s504jTVCUf4j+0yDuodsW8/2mDeb7BAzowMIQcOo7lCzbVhf5VBSKelePNmpO+p
	 5Rs16+C1rzGZ50gNvBXCwwHzeZBWKnmYEZctC5hF/0CJUf7lL/e6GBS3no8v5VxUs2
	 EBC9QhmAPQHktZ/2ASugUX9625olkz8QfRHdWMAFVZFsdSxhXQfNLp3k8iFswsOjSL
	 HF0oxKb2vyt2QN1VsBNaidu+ax5pfO7ZNVnJh6ha2A47FpgMdRbC8pvOLXBiZgV/CF
	 kYfb5EgoFAAAQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 6.18.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 10:27:10 -0700
Message-ID: <20261025172712.164385-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8169640004
X-Stat-Signature: 3dem1ptw56tjhoeyh7zs5hyidc8zqtyo
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792949240-264693
X-HE-Meta: U2FsdGVkX18U/RnLzMmgfHaqLAB7kYz3EVBtqVUDuRDOpFGwZyTvLvnt7v/gji/JVIW15AUSLVrVO03LvGQa5Nefiqu78nRgmj3LV1UKKgih5nRFc30msEafm8SUHKat2H8ck0XltCoA78hqoDQOsOOQTPHQQNzmOMnvKlzV5geq3s1jf5vpDgxxn7ZRazhA7OIW2a9/qIlyGbFNBIutgl4NchbnS6RCljTqgQ7TNL+jeNQWERhny7KuRm0PCrC69J0UraRNsFLJay+Rx4i2PbR0kmhZEgbckb8h0ymC8JsVJ2mw1T3q15/banV7DHHG4Gr+c/tqMrTbf7GwvR6bPyTXV8DTF9P0rx6aQD2h2HySQPUgnMMicTDrdLdBvr1OqRAX5Zn2sl0EJ1yotzCw1VGEplO3WWLAjrH67g9+JUc8njczGFJUdxSXrCAZTCdKpVWWUTw5qcyZAkGNxY4ajFF9ZWxtLTa355qoq5ARu1eskT+TLFHrNadHXd1YO/sIKY/QD0zivkWy+tieP2XBzD9miZAPZ45c+uyDuy/fOGgvRiqkl8B7BvgHBg6srAUqiidHNxa7UdjmBcO2hr1FM+NvycnjSLxfAcbXFiyckDcZBTH0rfo4V7kg2tdMdgOXKlxu5VxKUo7Hu4H3dW3uTdDSKAVjJS2irquoSnAyxGa0dUbefZiXdUgEET34P0oWRAo9fziMdfbHJpflSl1UEA57nvq1zFh7Qyca3+WK4CYwcStqFcDr15qlhZkoTkbc/Odf1voc32Dgm8v8pXBMqBHFN9zUQU84te+HZ93UJGMIpCAGP5ZXd1jszZrjBXuXH+UHBkrfk39ETfMFsC3l7zP5TSE4DMql+TmVetUiXUv04Izz+3IWW3yDtyHqSKkVQGiHjXnor4ow5a2TiyTsS/AJcjtBEq6Uy0m6FH87RuPPO18BiA290NfcKIlYJd8cNRKBUD3D0Cjd0FJmg3k
 mRu7aq2T
 sPCub2BJHdo39GOXqKOpOwGLXNeChj9WXDdgX4QFYEly9xaXfOkOA0ZJJ/qqhmcAvDZx7v6r88kpus+2BuhXZb5/MEn8fD/HS4Yca6C9gRISwsGK3UhckZc65cLPO/dd84wU1Kzg2OS25aqo0oCVhFRUb9whgbV8xmrzhrV6sBfirU7tUSGUsoikc2+kJFhDpYVrlFpdCTPMRtVIHu/Q7U+isG2Io80MSz7GPPrLDigM9VWEzpm/P+N1uuBSDFs25UncuL2UiX7NR0y8KVwhqNRKBr3QfVhjIR5HVGVJT4Ex/1fBP++SWqLD3UUkSyreFA2CRig5Dk+opbuWogAldIM5hmMTUyEsPr/9GiB97HTo1K39p8//2L2fwKhB4YbGmpiMjmFXD5HHjNxQ=
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
index 4e6e3d7d0a5c0..8fa788b0d709c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -807,15 +807,18 @@ static void damos_commit_quota_goal_union(
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
@@ -833,14 +836,17 @@ static void damos_commit_quota_goal(
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
@@ -849,7 +855,11 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
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

base-commit: 2926d88bb7fc4608fd942453d929c39e4e5ec006
-- 
2.47.3

