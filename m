Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D0B606A320
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HRuk66ln
Received: by kanga.kvack.org (Postfix)
	id 5A16B6B05B0; Sun, 25 Oct 2026 13:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552CC6B05B1; Sun, 25 Oct 2026 13:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467FF6B05B2; Sun, 25 Oct 2026 13:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 170DF6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:24:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97F7C1C3AC1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:24:44 +0000 (UTC)
X-FDA: 85361823288.27.B1E2CB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF36620008
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:24:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRuk66ln;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792949083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nkyq5l5Ghq356yzBoCQoLTfgpUWLS8pHN4Yf4mmGPPY=;
	b=xYO7721NdOSCHT2iZBnrSs0Sr20zusw/n9WEyQ1QdMPVYeUo9P2DeEuZOKxArZ/r6eeefa
	MbtOTqMo8mQCDC5stCLOY/G+HbWzKpwGKFefmYWUefQKACzMPadxTD7izREGVa+HHoi09/
	SEAO8mu+NJuMYmcdcJKXwLjQ7dcZNSg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRuk66ln;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792949083;
	b=f2HUPLGHjf3jLctBnhegYz5oTFLeNZTa7EaGEq9sjb1B4XMIWbh0rLLdrlMNYubZNwdCJj
	7owFakmXQUn+qse4gPtbZxGO+2nKeS1+gyYqFArdalLWfqj8FFV4GjDiMXS9BcsQWpUAwe
	/pNApjZK1QB1aF1lG57DsUZlrMO0o+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D83543C17;
	Sun, 25 Oct 2026 17:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D951F01825;
	Sun, 25 Oct 2026 17:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792949082;
	bh=Nkyq5l5Ghq356yzBoCQoLTfgpUWLS8pHN4Yf4mmGPPY=;
	h=From:To:Cc:Subject:Date;
	b=HRuk66lnQ323DJ5rahzb6qhwxDGn6mSnG/OoMieII1aNcbThS8GTGdhLTWrMRwnHE
	 jyNNoBGOE67u6yYAPu6VzYdJLoOlkJG/GkCT21fg0Bt5bV/XcZq8Sx3bhmXa6+oGMD
	 kDzVMGAhpkkIj9e1nKkws1Lz1Gk+LEz9z0GRDh/lEvNybeG8VQ+r3CbijM0ZhKppYH
	 P9Cdd0dhVEgRz1hsmzXhwo2kNh8xhyDBcbM+EIZpiYTau95GgtpIjAdqp3Wpb3WC9b
	 2zAXuHxg80A09TjU+nt/ThqpAZwveIpWQjb/xKZVq5B/U3WnpTz+FVXDUpAr6SS+N8
	 oitVY8v1hQbSg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 7.2.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 10:24:33 -0700
Message-ID: <20261025172434.161597-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF36620008
X-Stat-Signature: no7u4k8c47dmjyzsjwrdc811mqttnyyo
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792949082-143160
X-HE-Meta: U2FsdGVkX1/QCCsCesTNn0ULFUi9/pLzK1wgSYiCIRRE71D4jEuL3HGPTxG+X5lEh9jK/hy1Q+yJrNPlghtazYlrpMKvZ1Z25hiK5TvFCVNcAgtVuqaPyzAHmT4cUI5FRd3G5GrPz2KZpf9ANG1Nd9X6Hp6Rth28ZWxkuezArikZNaVpgUinGTEkG4l6HbjAFKyHqlPD9ZXPsMGeYpkWE1HjuFi7B+NgcfsbEAhdry+Wt7dgRMUQFgTEFP+DbNbdyGTpejWHpn/jAYbMIS5ykwNakf6+hXWRrnTH2klC6gP09mtrkPLDrCRWmWrF98nUGxX+UezMsBQviaGfbpQuM1uxTeJyoOo2CAMYatDQXfcQHsVy+6FceGGbwaB/j4E0zSyom2PIlcKHxVxKCkQy7pEs6/r2wUofNFl5DCmWfmcNbxmUpe0QGRWUzgZotcADh+VQBsyc6ooZnLkDhNQ5rcAqvF/pk923m56MTNJfefMjSfumzKwNWf2Q4RoxsyK2+zRlBnmP1C2R8LA7CPz/myuAxeCjeVOBJVn7mG+JjUhh+0uepV/qr7FGc2sopZc9zgova3Ue5i77hq/RXSrUQDRC3yfoBFZ1WlBynF8bONKRvNJG3ijYncOAwIUdol1bXID7GxSomi3CQ2CjMQqWKvSAhOqt/Ix1/ciZseT6UPfRemhYLb2IgYijNzW8TNJ9TB9LLOkq0ZRQrKJpvucGHKi6uGHr8xPXYBD7wQHCG1OVoaWEdkfSEhtdJXCD/WH2IZfkKD0GhAoaANE0qPm8jMx1KmygdIjm6hqXcFLyHlN65kPkR3vzpfWehtktr3vQS+1X9bnH9ks0ec3h3i6jARINXjvH3s5IZ3QE96jdW1r41c6YmR+BuoRuLMTxA2RocodTVXPnYYV3/ucSO00SZc9QJ/pPx7GxogET2s1p1mRiT0OKcb9htEjIfa41WApuWPAOzVsugCbUxROMKIO
 aWHjdIHb
 Fo2sA5Pb5HriQGZAFlb+lwUMvK9K5Xsep68ZyeGfheoxw4vocwBvhOEJUGJecGiOYWaVJ44HXFfh8u80NDkPSAvd5njGequZgbk3/YTeEjttGk2v4b9ypW2JDcrozNdiXvE9r85eoFsbS/mD2qhf1WC7VS3VizVviRp66PmSd1qnnn7ltTD7wNFghUy7Vm81MTPyUwuOs3ml7WUlPfdhiz8Iub8MXyb5vWzTlI8X9hbg/rNMqI4roKpBFRD2yZ5b18V4JvluhH8HOZfPFHWiy9q+ZpXxKgA5pdzDSzh0qGtY1fnKFinzojDOV7RPrK7qTD8jRz8awSdzkh5IIMqQ+Lzw7FYQOIZrXx8KVhnoN7YuXR5danbjGbULYNNmeIUommc+DsNdHK0xx4JA=
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
index 40714c69d1b18..0aefaef46d655 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -999,15 +999,18 @@ static void damos_commit_quota_goal_union(
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
@@ -1025,14 +1028,17 @@ static void damos_commit_quota_goal(
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
@@ -1041,7 +1047,11 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
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

base-commit: cc9de5d4b5ab6459f5774946aa3195ad51236fa8
-- 
2.47.3

