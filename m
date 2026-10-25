Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3DC606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 18:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hpooGz8m
Received: by kanga.kvack.org (Postfix)
	id B16B26B05B0; Sun, 25 Oct 2026 14:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA03D6B05B1; Sun, 25 Oct 2026 14:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968976B05B2; Sun, 25 Oct 2026 14:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68A866B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:23:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E084E160603
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:23:36 +0000 (UTC)
X-FDA: 85361971632.09.4851423
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id ECDD220003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:23:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpooGz8m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792952615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Aiq+VkJ1bKei0HRd+y60jGfMrXiYAQCM2kSm5AYlbis=;
	b=ZC14Rp6eDOqpKb8fBzgvrBDAWatYxf9O+12BpDZyMT+q2bJ/8eQkfGOQwO5IbtlYKK1VNS
	Cst7UIKGjPjNiz7L23zHugWmkOj2KVtJiAORLEqVUtA8FjQKMAkpiNOeKeJMrtF7HDkN9V
	b8c4lKRmZPofFv6hIWknbKODufJYAuY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpooGz8m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792952615;
	b=b+Gfvl25BdRNe1VbVniombaCGCHtEuLMRgJMy4wfwWcp4z901ggNzrIdWOqLPO0gqgU7Ur
	z7XqqGmgKc9RJGd0CccmIYZpiMmBXh/+lS0ZtU85uVLbinxo4/8nHTsAU4tBsuo+jpjC7H
	Ddnce+k7MwB4m33BZfMq0zoCtqGF6bU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84B2141A3B;
	Sun, 25 Oct 2026 18:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331C31F01825;
	Sun, 25 Oct 2026 18:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792952614;
	bh=Aiq+VkJ1bKei0HRd+y60jGfMrXiYAQCM2kSm5AYlbis=;
	h=From:To:Cc:Subject:Date;
	b=hpooGz8m9Tgo5CDnxiy0f1E6f6l4s4bQTGgI2jn56t/YGYYUdh8Gpd+HUgwVXrFNz
	 vnPIzO1zjbb4voRaK3ij/6KOoWkq5TxgsNtfyITQ9t6Uqiv0bQZx8ykTMfsS7L3xl8
	 QWgrM9fWhoe5ksmm2n02DXm+QR+8Hf0NyQw7AjIiVTI6v1lS/pTwMl8ksIfv9ExR9n
	 tEs+D8H2O97uVEddghxI5xzR08PysHIuGUWt6vKrdJRdkRKIJ84ywugGarZLwyqsG/
	 E6yLNsnVdBfyNJxeKeBQxwydSmgPjOdji2uZUyssyea5Fp/u8BhY1ocJs2H0DAzLyX
	 ZCsQ/DAEQbVHQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 6.12.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 11:23:25 -0700
Message-ID: <20261025182326.178326-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ECDD220003
X-Rspam-User: 
X-Stat-Signature: hsy8cw9ug7hbpgkfdyad8iis966hagej
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792952615-167128
X-HE-Meta: U2FsdGVkX1+/Jmso07uBn2H3glRjo6kNQ/8gzN/j58oMTvbCTd555oDbuMcV6kPDMIeKh8uBaC/+RyoGdrX6PPPnq4uXNM3F6GjoMa/veSN0Zk4HrMWrKa63I/RFAKMeB5xq/rOMM/Jp+5xteiVjKU8bB3vK4VGRGKxZrKoALOFgYdTRYgygsC73XeI4VkWmrdOmf+rO4IA8eJRzdWUAFwFhwtZyKDoMrThCAUmQmNe1cO5odAjsj5Jq9Uq4WRl8+ENgl5XWRbMCnrKwTRmXxu8TLHWiZnQI98pyM374Ck4Zm5GI0yJxv111gsgcOh51y33ZUACNV1B5oeh5A8xfp8Ryxd0A2mTL14xYLxyzgXZM0K/DiiQUX/6hbMpGOeb4x7V1gYPpb+8Ze4/ZjgVlzvb2IFPULDrTRSsWNJcgFDmPTgIFnmidYq+KQsA1pfI7YdwcGsk6y55vg1d2xKXP1gEK8Xcad6ZhvBzU3NipnZ0tIxRTZifW0tKkxfYkGE1Quc5Q5c6R0EAZUswskWzd8gsQyIqT27ByC3DXj2L21G5DdwXeJR16sFlhuV2VIruVYC18jP7VeBpWJ5N58h5B+5y7IKFUCbhorbLZPwFQx+ef5d7Luxa4cYSMmnsE9g3LUVsBmuYyq380CjK9ZzDamHIRV2xOhCsGoCAB6SGJJazragflwFC21YJFCTShzfe9d0CRGmKQyM2RrtNIWPcQgQwyW1zw+vZvFXzHFX+zUzjuHbZ/YtAb4cMbv5tCzBkKTUcNTPtbHnhmcVnpdDlOxnkNQt+hxNfRki4w5tev0cVAAt5ewygFVOR4avr5w8KWV/Tt/gDB5Lt8+edgooR0NjcoAemeoxyYJNKm47TbGkon7NnU8ZSkknKt9uBeta6FdZcD7FfAl8/tJFhT67x11ewMEs7weM7g1pUEW4qfIKBrfcuiuYIn4llQKQn2UosV338T8lX1iEPUWnKOdqM
 sR/2Tfwv
 Yn/utfcc2txsrnAxz2Mfl7Xb5oApYMgN3RgeuiPkyckpwDuYEvchIlKiPJVoMnkloQW3BijpuGkMJvrpEKVlVH0ksc+pFXKB95baB2WyNI5WQW87yZCwIxxC/7JIHH7piw7vgG13a7Hajbjc1CaSCtHb2OAXaPnQayzoOcJvv2vtiBhF8jJaBF89l/h5qhMIdTeIXYUhHq6HJT1k7/6MDWwj/h53kliMTehBWOYPGnFMdQAZQYfL9qL+2H+wn8uOtVeXkH4DRDthHTBXkmb4FyfWjb7Fdc5WBdismWVZwyBTxQemdEn60Y6LSeQeyCM8kood931EA0j+cINploAK0eRpYZMkVKntAcT5r69ZKrD3pXJDbR4MVo+r7BxPLw6k7TjNQQQMLIfqMAgA=
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
 mm/damon/core.c  | 18 +++++++++++++-----
 mm/damon/sysfs.c | 16 ++++++++++++++++
 2 files changed, 29 insertions(+), 5 deletions(-)

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
index 5aa23c6545cb8..7895b11555d06 100644
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
+		damos_for_each_quota_goal(g, &s->quota) {
+			if (!g->targe_value)
+				return false;
+		}
+	}
+	return true;
+}
+
 static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_ctx *ctx;
@@ -1517,6 +1531,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
+	if (!damon_sysfs_valid_start_ctx(ctx))
+		return -EINVAL;
 	err = damon_start(&ctx, 1, false);
 	if (err) {
 		damon_destroy_ctx(ctx);

base-commit: 85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e
-- 
2.47.3

