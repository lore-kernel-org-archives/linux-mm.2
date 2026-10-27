Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5076606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYEBO1zL
Received: by kanga.kvack.org (Postfix)
	id DDECC6B076E; Tue, 27 Oct 2026 10:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8196B076F; Tue, 27 Oct 2026 10:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF40B6B0770; Tue, 27 Oct 2026 10:03:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7CC06B076E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:03:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B08F1A09EC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:03:36 +0000 (UTC)
X-FDA: 85368574032.24.CD0AC00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98F9C140012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:03:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYEBO1zL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/a5Q8lUWBEd/9wSdAV9zhg3EG5K6dH/Wqad5vDppMa8=;
	b=acb81Ny7CNqWKU/7O57w4VaqTZY/QE3gFZHYMAeh43CLsY2AUlMOKUXk60+BpGKBHZxbId
	YJNGRgmaqzD/yhlHL1nV3i2jfyuIGsCDvsJPQRiGOxtsmQdfBUx6UZrwaiLcjfA6i2Ua+a
	aM/AQCVZvG02A4zRP4uNaClRvRCd02k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYEBO1zL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109814;
	b=h0kp1b7VEBM7yioJobMGpnl3DlYWiXhBdOR6axfef5TmomsmFk1Onzc+g8pVndvTpSFwul
	dJn37QNQBqUp8PuBwA8L2A8efp13NYfObBPWys/tTrzmdfHHDGFQT1ySixQisUiv3aX9Du
	8Mwmx5iVepjZz9cRX35zO0uiQ1h8AJE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD8DB40263;
	Tue, 27 Oct 2026 14:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8232B1F01828;
	Tue, 27 Oct 2026 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793109813;
	bh=/a5Q8lUWBEd/9wSdAV9zhg3EG5K6dH/Wqad5vDppMa8=;
	h=From:To:Cc:Subject:Date;
	b=SYEBO1zL5ZF15BWDdDdN9iXWFFoy1Sphreo+ZkNHF0l425741/n5Gb2MeJn3i375B
	 fO92W96b28BGlLA984Qh8udrJLq1+m5PiZ8qwelstttw8SYWUTVmKug7i8WOeQuEVZ
	 PZdkc/bN+b8Umaf7FTY+DKuebUcMl0/OzMDVAZDnHYKSqOAcNjtmUdsW6lw0UXFGM9
	 oJT82COi1DLQ6YPvPVcS9XFrKDKvJB4GDCABA/sqbhviFXMv9gFlwOtK7jJtVBWLxt
	 KM5jDL+YEgGIJ9vb23zF+XFFZdrCdetFSh9zcAvPd2u30z8QTUveaPkPOnATvO+hXQ
	 m6zZyyIsOG0eQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 6.12.y v3] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Tue, 27 Oct 2026 07:03:25 -0700
Message-ID: <20261027140326.153338-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98F9C140012
X-Stat-Signature: n6xsuxmx7atfdcp3ecqmms7rmswacs9o
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793109814-57226
X-HE-Meta: U2FsdGVkX1+941OstqSv6Ckyz5qU+Wy9yI2LzZBAq/Sppr8R4esykRch+Uy76hcJd3mW0Qw2QJoVkv3UfuDrpbJEznwCFsY00dRhYiqAV3oAlRloqvL3NA5gcPSOBhmwDB4nh0VoX6O/N7UVGZp9YVkROElXSQMF/x8FxwE2hJQziK50vctZ6/FGGGtsJ2c/HMiGRXFVCRl2iyqR0balJiCGA/1cfoXUj2gT5dpZZ51yjoXfTrKlbimTAWSiBT2SaRlcwgAeWfr4rWuuSTHnJsbP+F3DZkRDkOX0yE9c+KOgzrM7Hw+Vy9TC4bDTRaf6FTig76smwqWhVeKvPVsdgXZYrqmZC2SbatxokcwEK+RT6TnvEiw3rIiUGsOQ4A4MbrIs2zC6O5UYd4S0oBiCjkolHBMAw1GaNm3D2h71+CVCQqH15jWtukPbMqTLsSzjOm5YG99TI8rPYGEyf7AyaOJ0+EXDq5ws0T+WEE3TKCBuYqBOy53ovTmkNtdi2OLqfqif55Gfo444n55p6CBE3cSnRZRau6I7Q48gAY25x8o9LxAvdMtQO4X/4k/sztqHoE4IbnBb9cvFTgkG84JLRuGfQqaqBXbPelJW4a6oTTf+hExDJbq5aXjnjyBYJogM+8mCaVFPmevAg9zZZSHvnxqQpCR17Q7aMWdC6E4/XBW2CWIlHgBdgoXgHBjb671lSzMgE/Q9CH3UCyhr10OCp198HpMlT90g69eQl3iSHAWzHkzouEwUzJIL9D4pdNQUaC+LGMdInlyWRFHJpSxWF2wMc/iecLr+UZVXO56Hz/6UZGfTk516ftaiKm3JBHJDc0WnJSEZX+rIrgT8k8tEv0JIbc9i37wmXK2yndLMpu5UBpgp7yS7j2tVc6FNPn0UajoiSfQiCJfEr555+VzWMivHD3m/pCsNeqRttmYTurTVjYpK2ww8KvfHZhUF6m3gHKWjn6UCWeSugJ+VydI
 BtFx8+6K
 zhEwk1iVOOI/nZjbsju7DNBr4z0VhbYAdYMXCHkqSWwJ+BExh9YsXf7tKfofIr7WU/VphtTwo3PyT0s6ZAfESrivrA55f3BnXZWFJa9uYJdVuzKeJJ7Wj84gcj5ehTZtuG/rSUhy4oJsxSCwfb21mRjwpM+QcqHfy8AMx+SCck46fz/vva2/OB5GI3JZsvXvsC69ZrCzmwY8QzvT4HBnOtk8wuZXVHprsep5f/jVw5rXENoU0F3u94orX1y5C3Rd0J0YTlWYa2YwsXszIcDP5lPvvKq1EeqoSQYblrdYnKD6+srftLGAtWJdXpD123B02P4rFJyMPOKdaYDRRQED8jdhbcB7n9NIjrk6IFJnwgjfvrpR67M5KtGug3aCNL7Rfl+ongNaqN7Fchd0=
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

Also, the upstream commit on this stable kernel can fix the issue for
parameters commit paths but DAMON start path.  That's because DAMON
start path does not invoke damon_commit_quota_goals().  To fix the path
with minimum change, add a new small validation of quota goal target
value before damon_start() call.

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
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20261026135555.149244-1-sj@kernel.org
- Put target pid reference count in damon_start() path -EINVAL case.
Changes from RFC
- RFC: https://lore.kernel.org/20261025182326.178326-1-sj@kernel.org
- Fix a typo and macro expansion build error for quota goal iteration.
- Destroy ctx in the before-damon_start() error path.

 mm/damon/core.c  | 18 +++++++++++++-----
 mm/damon/sysfs.c | 19 +++++++++++++++++++
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 81d44e41de210..ed32855c16ed8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -698,14 +698,17 @@ static struct damos_quota_goal *damos_nth_quota_goal(
 	return NULL;
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
+	return 0;
 }
 
 /**
@@ -723,18 +726,23 @@ static void damos_commit_quota_goal(
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
 			continue;
+		if (!src_goal->target_value)
+			return -EINVAL;
 		new_goal = damos_new_quota_goal(
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5aa23c6545cb8..ad9fa8a86c9ef 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1497,6 +1497,20 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	return ctx;
 }
 
+static bool damon_sysfs_valid_start_ctx(struct damon_ctx *ctx)
+{
+	struct damos *s;
+	struct damos_quota_goal *g;
+
+	damon_for_each_scheme(s, ctx) {
+		damos_for_each_quota_goal(g, (&s->quota)) {
+			if (!g->target_value)
+				return false;
+		}
+	}
+	return true;
+}
+
 static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_ctx *ctx;
@@ -1517,6 +1531,11 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
+	if (!damon_sysfs_valid_start_ctx(ctx)) {
+		damon_sysfs_destroy_targets(ctx);
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
 	err = damon_start(&ctx, 1, false);
 	if (err) {
 		damon_destroy_ctx(ctx);

base-commit: 85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e
-- 
2.47.3

