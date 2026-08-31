Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE010C624CE
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121756B0099; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0839B6B009D; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDAED6B009E; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBD246B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 506708013F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:27 +0000 (UTC)
X-FDA: 85161790014.14.6D7B5B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9B212A0013
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXISkcR2;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186385;
	b=4ejE8jvpMKImr9u+e8l+XAAYugNhiNTO/Chs0FD+RVYQtG7njDIHtrpGDzxVs4R9yBp3Dl
	O3UB5Ej/DXw/JJZuDAqdWyh/y6CqBIk3YJtIaHQr3fTf71rU0YMTwIfRNq77FwAsovZtv4
	dGNIrO3EvakAnUbpXW41jN0MsMdF7w4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXISkcR2;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxE82nkNHWov4YHh70ccGFi1HMEiweXojbw3QLwGVKs=;
	b=Tiayg057HOeCtX0Uoae/8OUyvRO/etcT1gD7LjzAx4pH7/YPeS6YvyrnZFpWNRJCOVKB+n
	/etuuiOdI/zoQlmAaqqw0NwEvbyLdxPypfbnJvTjDn2OazbSnFLAFwISyT4Mqbo2zq0BnB
	Ifm96BSm23FsoUOkhnZQtBUkdkqm5qw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D52440139;
	Mon, 31 Aug 2026 14:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C211F00ACA;
	Mon, 31 Aug 2026 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186384;
	bh=LxE82nkNHWov4YHh70ccGFi1HMEiweXojbw3QLwGVKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXISkcR21FUdW6a/GHUr4gjTlrQNC5SepoKIMDlA8PCrso0C3aUK0Y4Vc4twXVww6
	 mKIgxHAcMOhLn9V/ud5FTRgPbej+8aPVnwIx8jQyxbkNQXZHuQ636PFQkO4e9kNAKX
	 pAqtEDmhrRUmzod6BmtXnzcsPiGPeriWGM1P8TpqarpDXWk/r30UV/CC38i2iizggF
	 ot6ihp+foSRcxRccDiLAdTqp08QI7uWSKVOMYKuRY+JO9lpcTKuqK2ew6cBfFs9w/8
	 zUjl+p8JBTiX4iVOheHvGFfeYSgoCNa3JjmS188DObHYGqtAW7qwt+vtsqEcM2lNwM
	 S6UVL+CZp9Crg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH 2/7] mm/damon/core: introduce damon_set_target_pid()
Date: Mon, 31 Aug 2026 07:26:04 -0700
Message-ID: <20260831142611.77572-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831142611.77572-1-sj@kernel.org>
References: <20260831142611.77572-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ujacb9fygjja3z1nnbjhkh6hhug7qthx
X-Rspamd-Queue-Id: 9B212A0013
X-Rspamd-Server: rspam06
X-HE-Tag: 1788186385-542583
X-HE-Meta: U2FsdGVkX18+Sp83Q/V6vjVwTnzEXkGfS4sNl9VvrA0Mb/SQsjlGNGJyu10Ek8J7py/08rGGBs6av4+g156Oqy2fFJ3CYdM+RTEjSbmnSL2Xx+IN/zO3iU+JCaTpLDxvzh9fL+B7XEnHlClE61iXIh5g5Q6Lv2h7lPEXVcGywk/f5N0mzDzkd6mnNbGYassBsk3ho2hCnQa44XhwUy7LArY+xYbtlhLVUqUciwHkKLVkeWyNjzu7N7m/XIqWTkRptH53bAULB4JvOPwYpXKE5w0+MLdSV1/Q1xhe5mFXVWUsLXF+DlVd2fkaznOF8x9VH6ZJkxlv/XnYxgiUpR5tp6rNNZyk9UZ+K9gWREEb4H8jq4OugieMWmoTdY7oow9H8or9HDE9wiE65jIXoUvJ0PS+SEOE+94zQmX2gEohhNwURiWFGwmKtMwIv75E/Dq+uq/mihtfZIqoj2rTP6pt0uY4ANtGNcubKIQIsMjMYsAgKb6D6YDaGMTajTlWWUbVHaJD4+0foBASB6RqFvJa+AQShp/Sy1QwCZEKgvuYyICZZ+9evYlCh/AkobtZPIKSN/n7lkFDHNYfqycss7LN2LyrGAn8cY+W/KQkWVySCAV/L2M+t9xKY38meAL45Z1MIhv0iXv0dh3E0C7RClfKz4CA+ejPiXhwYcof5kRcHZTP2lc09rpkMzihoCvDkPXGYzQh0pvruppvI8jxkxgJaVjqCmgAU+acM8f3pVSVfX3zg0X1IavujoZ2w0Z8n1AKlNnOYIXtMY6Bkt5xb1MiqEPYjd07s1CplGDex+MSER6RtZA9RiO4C2F9AuSZHK445a3B1anGHxruF/bnZW8moT/0hzq594WkZMp95zbnUgrYCVBFunCipmK+Tu9yMgn6QL1uf8sevayBLr/mrEuuzaTD6sVc8dKLioEd8wKw+CTP2bTZTQJzPCsZtl6Vm+D+otLqJR/yyArcPvGOHU4
 BKC3Vp06
 cqTCfimJD5k02f1dEmQGpSRnq/O57jt8E4o8ylAMk6DbbTigfmsfeLtiJ6qjseKim9HUnicJ+aZVEbX6heAjv1V9clTU61qWzbYbyKdXof/V2InR++ZlxopeCa3D9g5q1288JMvCDLq6JAfI1+zyUZJxr7o5ILYUz2PVS36X617rFkrInB9d/Dp40WQ5zmEby6dsQWnAwhU8YtnGrU5cY3t02Fd2biGk5PQCGksnMF1p0fY2oIQhfJBzXCEV4NMKsGtajdy8Rqbu1UHk8J1SfHVznYDtDYx3mBGCliabHgSR7wH0rNnqkFG2dm6Ob4WVlIy3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The logic that finds the struct pid for a given pid number and assigns
it to a damon_target is duplicated in multiple places.  Including
damon_sysfs_add_target() of mm/damon/sysfs.c and the start functions
of the two sample modules, samples/damon/wsse.c and
samples/damon/prcl.c.  Add a function that does the work, and replace
the duplicated code in the places with calls to the function.

Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260817125319.888994-1-lienze@kylinos.cn
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 include/linux/damon.h |  1 +
 mm/damon/core.c       | 12 ++++++++++++
 mm/damon/sysfs.c      |  6 ++----
 samples/damon/prcl.c  |  5 +----
 samples/damon/wsse.c  |  5 +----
 5 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9abb..5607f98ec6306 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1055,6 +1055,7 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src);
 struct damon_target *damon_new_target(void);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
 bool damon_targets_empty(struct damon_ctx *ctx);
+int damon_set_target_pid(struct damon_target *t, int pid);
 void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
 unsigned int damon_nr_regions(struct damon_target *t);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 79515ef03fc2a..a5ea3e61e7f41 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -10,6 +10,7 @@
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
+#include <linux/pid.h>
 #include <linux/psi.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -802,6 +803,17 @@ bool damon_targets_empty(struct damon_ctx *ctx)
 	return list_empty(&ctx->adaptive_targets);
 }
 
+/*
+ * Assign the struct pid of the given pid number to the given target.
+ */
+int damon_set_target_pid(struct damon_target *t, int pid)
+{
+	t->pid = find_get_pid(pid);
+	if (!t->pid)
+		return -EINVAL;
+	return 0;
+}
+
 static void damon_del_target(struct damon_target *t)
 {
 	list_del(&t->list);
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index f05b256c90ee7..dcb739ce0a729 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -3,7 +3,6 @@
  * DAMON sysfs Interface
  */
 
-#include <linux/pid.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -2036,9 +2035,8 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 		return -ENOMEM;
 	damon_add_target(ctx, t);
 	if (damon_target_has_pid(ctx)) {
-		t->pid = find_get_pid(sys_target->pid);
-		if (!t->pid)
-			/* caller will destroy targets */
+		/* caller will destroy targets */
+		if (damon_set_target_pid(t, sys_target->pid))
 			return -EINVAL;
 	}
 	t->obsolete = sys_target->obsolete;
diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index 842099bd62286..83ddf12811d57 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -32,7 +32,6 @@ module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_PRCL");
 
 static struct damon_ctx *ctx;
-static struct pid *target_pidp;
 
 static int damon_sample_prcl_repeat_call_fn(void *data)
 {
@@ -79,12 +78,10 @@ static int damon_sample_prcl_start(void)
 		return -ENOMEM;
 	}
 	damon_add_target(ctx, target);
-	target_pidp = find_get_pid(target_pid);
-	if (!target_pidp) {
+	if (damon_set_target_pid(target, target_pid)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
-	target->pid = target_pidp;
 
 	scheme = damon_new_scheme(
 			&(struct damos_access_pattern) {
diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 37fd5da201588..53944aea8428e 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -33,7 +33,6 @@ module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_WSSE");
 
 static struct damon_ctx *ctx;
-static struct pid *target_pidp;
 
 static int damon_sample_wsse_repeat_call_fn(void *data)
 {
@@ -79,12 +78,10 @@ static int damon_sample_wsse_start(void)
 		return -ENOMEM;
 	}
 	damon_add_target(ctx, target);
-	target_pidp = find_get_pid(target_pid);
-	if (!target_pidp) {
+	if (damon_set_target_pid(target, target_pid)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
-	target->pid = target_pidp;
 
 	err = damon_start(&ctx, 1, true);
 	if (err) {
-- 
2.47.3

