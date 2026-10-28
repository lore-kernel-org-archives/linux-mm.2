Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6625C606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 01:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=osPbykrT
Received: by kanga.kvack.org (Postfix)
	id 826256B05F2; Tue, 27 Oct 2026 21:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7976B0932; Tue, 27 Oct 2026 21:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDC96B0933; Tue, 27 Oct 2026 21:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC9C6B05F2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:02:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D34C7C0B7A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:02:57 +0000 (UTC)
X-FDA: 85370235594.07.D9A50BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 566E31C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:02:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osPbykrT;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793149376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DghfiaBdf/xA9KjJXYbrUOwM3RhxyYwfA+auXLEm6v8=;
	b=qDqewB0LJ1DvtVsMikq85fq7/ZAg/SthJ0KPp9kZHvJmSGhTpUCn8MwSRUCX+U8QDqkmwk
	+6kbJF12XhftrNFtku4j1++Y4Vr+nrQszLHG5MrFa5+xkjajq4SJ3bDrWiHzKSuqzGXNMj
	dZid3tNhsU8BosqWti8Uti49XEGgsQw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osPbykrT;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793149376;
	b=DrlyqoWH9h9ZCTaCVSt/9APMyB1zWiAK7p7M6er8lbHq0d0+JU3N6gxqwJJHLRbgRRBZND
	uKbQ6bCZ7TxQ40rphgWFmxZ7EyLZ157Md4eEot82ZzWgJLF9JO6prxvsCMrb4JDtgISXXr
	HigfLWkAYmxvPz6Nn9OtOL5Uyl/S9ic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C97DF600C8;
	Wed, 28 Oct 2026 01:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A041F01825;
	Wed, 28 Oct 2026 01:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793149375;
	bh=DghfiaBdf/xA9KjJXYbrUOwM3RhxyYwfA+auXLEm6v8=;
	h=From:To:Cc:Subject:Date;
	b=osPbykrTuV6YPRYTYBEjjlc1YeUhNYgvA/gFeq2ZIAFZBgFj9ZMwdgjnTlcL2pWzt
	 0gPzlGVpuhoms3FUh0RRTZQuYZY/8PREKz40P+RghmWK1o9CfJWZTRFQVCnMDO9ZiB
	 oRKazBR96zNeKZbUvPOUEftf8DsDAdmQzWqNZi+xi0823MLkC7YCu/6BA6mZOFn0hU
	 K9b7r6c9NjqJzsnS1JyUBbVOAgUVARVI3n0VOLF2x+ihWaIUjc6Woq0HS/exsfD6Ky
	 Eivz/DWJ+T2gI6/Alj0EqIFb+l/xWVd2y6gxu0uNekR+t+IaogxcA6C29+Hb9fy+LJ
	 vCOk84EjVG9hQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Tue, 27 Oct 2026 18:02:46 -0700
Message-ID: <20261028010247.158237-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 566E31C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nhax3ngx7sq9rpkujnb8gp6xi18wupbs
X-HE-Tag: 1793149376-438233
X-HE-Meta: U2FsdGVkX1/ipgsjVYliuZdTlf/gcnloZlSNFKkpF+UIPc8EfqDXnAYyHSMXZUK2R1ttbx1JdR0fSn2bywiQWulbkSvEKQbSpmlrx6VqlLE5yJDoNFlQPENtV1+L7bhT1GtCVd71MABaXIDfmgB2SoiJyDu7+8iHClM2nJ19M2AN+ojG3rkJ//VgsX1rC3GoQ9jINM8Qx3hynd+GGYHfAtPbOc/vmc+ltCEusizmnHPlkKQXCEDyqJsjVnt36Ga7Is/aVOIzQ+ibBpLm54hSD7AR1m8U7vkG40TAdCAnKb8TiffHTAeyZsQsDwKi1L8HCDArvfp+D43CK1AD7+axK7dcjJbxZcrr1wDBRLuax8axhXph84ETQ0ooz/B2070811nqHkaQh7TnpTilWEEjWSXGtyZAA0Lj8ZXcixUIR6avPv99TlhIp8QhJxF7zH0MMb5Y/ay1iL+jVlo7kR3Mqe/asNBHy1Q5t1QlqEujQNHi8Tk5X/Kr/xpCocGJNzY/ocuiWUI4hCXE6gdiyPhi+6cdg4jrkfwZPVsObHxDypuiSl22vBW9abhAoZAXc9dwq8FEOXyENv3TgRZj7fFMroDcXG7UkznMKH/Zv//GMapmBKsfARDJh1d/fzsSVAbSwxboMK7K+1fQhPCbrNc9E0U9B+duxKV4FTayNIDIdvS2XJkdmZJTzaFCxUET2i83gQ/28TVUYVuWBNHPMutPjPCEBoeOI4rDwMB3fpFWTCXWaFYJMB5k1P88XQTWLb1UwlFk/gnNaOsWEfXOEhvowncf5EIIy8QG/7XNLLRFSrp5MSo9Y6mdRXfpQzE0REukhGE0g6AiIFDWhE33Ho7nGThISAD7606Gcqn4zQeYq7GSomR7g+SiPAqdvGm6BBUb3i6dZ/79TDG1Yu3sMhVg2nC2q2iPgKN78QUF2Ql5O3KjFZ4N4GserQAr7qRnXzwKNWAPI9AVnu2f1t7ZGcA
 Ca3PYfI4
 C6+Ey+CQNF3dNOhAWoqtuF7pp7WGhnxGJnfliTUfle3P+sb/NfjE7zs0VPpZwCRFduuXIhPlqSAxfodQKCBCRMB6qWeja9YOLPYLSAyc847SWNRfPnFZcmjdIJVthqr52lJdmEkjD1ns8oMjTIwvQTmpa5dlYV9eegTyHvFHqNqcI9ha6xZuApuQ7nxVQ0LY31ZyhmO6Cajf17ew0oN20/RHxNSjfXyiU/UY5pQXy2YnRIU9TplPc4Xpw+crkazPkVK8gZ5nmZCmnNW/IkiRinh352ROOUs7s5bERIYKKBNqJLF1XtHU6Ue7tarlxJyLHcTPjTUkmRRZZR+1JUc3mjLhP0D93VrOMbWgWeWQCKRqFZ3ZTlbbWrhzv2priYIXurKYBoIuQFuIO1Tw=
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
Changes from RFC v3
- RFC v3: https://lore.kernel.org/20261027140326.153338-1-sj@kernel.org
- Drop RFC tag.
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

