Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518B0C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39316B008C; Sun, 27 Sep 2026 08:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C166B0092; Sun, 27 Sep 2026 08:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989DD6B0093; Sun, 27 Sep 2026 08:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 701056B008C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:05:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D985680A0C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:50 +0000 (UTC)
X-FDA: 85259413260.17.6CFB58B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 431C420009
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8A9eRIi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790510749;
	b=okpbbCLkFYd2StVKhPaqhCC+fE/x+rJg1ATKuaclSyWzgi8PGcTi3WKMZ2/61qeYVFYXMC
	CdtIFeEkldTBDT61GNcmKYD9eLsaUMUwMVYS0Rm1/ViyVtXOia+fQdfyJHKIKtzxeDXHal
	aLsXooJulU7jS66Bu5zCfmPaawd5qbw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8A9eRIi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790510749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dzrsb3n+B4Tz+bjF5YDlvt2CWIkFx3K+2+8jCDkVyMU=;
	b=PG2LBuBBvOtriaAjyCMhyIpNxNITCa+1scnR83yFsgvLuek8jzsVv66hI8NZTCN94orvef
	sM8w9/6v1gImYbACyYCTZZj4jfFFqoIvYyXyzhkbiyMe/LlmYD1EejeD/jwXUE96Facfav
	LvC2suAPcKJDHCM1N3FqiH1PNPV6x8s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2BD460D78;
	Sun, 27 Sep 2026 12:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F091F000FF;
	Sun, 27 Sep 2026 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510748;
	bh=Dzrsb3n+B4Tz+bjF5YDlvt2CWIkFx3K+2+8jCDkVyMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8A9eRIiRbTLkj3jBrprKUE03IjjI1K23wmk1K8NiliFE8dBRRJF8HIN19LKUZksK
	 QcL87TpT7PPNnLgOI2mQevlIUihJ9xz+11vzhKcjRB+ENnodaAI60i3141+ndacft6
	 uJaKzAvt6Qi+5E/w9mEOy93SAANykRMrpMtFC0ycR9g5B5zk8rJ/83hOnmIQzQuDzD
	 XmjzFOJfsmGoL//UbPBObgNVhlEFO8BYD1k0TKvJrgWAHstQHA31Z0b6xKQmwgUO5W
	 uw642Q9IeytalUmn+/QNwF6tgDSEnZ2/VMVE3VfIPbNZt3+dAoqChju+KOsbRh3KMd
	 7UxZJ2czaf1/Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 2/7] mm/damon/core: add complement argument to damos_new_quota_goal()
Date: Sun, 27 Sep 2026 05:05:26 -0700
Message-ID: <20260927120533.50484-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927120533.50484-1-sj@kernel.org>
References: <20260927120533.50484-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zdoea98aygj4r3rcow1y3af5ctc717og
X-Rspam-User: 
X-Rspamd-Queue-Id: 431C420009
X-HE-Tag: 1790510749-397016
X-HE-Meta: U2FsdGVkX18BEyLiYFO6+bp/suBvDjO1eOIEJNJiRy3Mh3rd7VrB+COho1T96b+lGWliW5CuHALtV0yBIhLsB4J4NHQ+2ugsXpBlNgq47PgeJbI9I63U0prGvmwL/gTnlGIH96Vb7vUw0FPrF+7L1ojfIEe/IZFyRO+QqE/u9lyBrxlD7dbLuO5iBK4hiqu/vu3VYSR86jfb6Ir7xkg7XWxYHKTgmlAg+4zZbTcz1MhjwW+APecnfIJXyfyYhj0ZIgGpkeF4ru2nlKWKv8if/o7oDwOxEdPDjceYdrZM690vRv49o6DEFj3ouhMEsrjvqv/6cDOg4NXLduR3WxG/7JYN25sqDhiUU/UHg+bjUOLhoJHWydafmEO3CYamz9N4VBgAMtgu3mpxcrWihoE4c5X0zvEO2qJU34sJIFjTlbB2kl9vz/0joGNrg8b0geoi3XkG67qGHAY+MSDnehl0COrjt4Mp5AMCLPaP5v7ylIHLOQ6iqlW6gHc79CPOgouKgCKUU1UPxk+rREYZ/bTbOhRk1zXTCygCWW5KXABwpc1nNIAu9rJHNrMYKoGmpTMkVgrwF95xYSpI0/XO5LKwIeuynzR6wZPglDd9xuasmp4Su1/FQ11wUktY23nIH4rZlQegT311OtPJqkBoJcguqP9a3rsBpEiTRX2mHvZS7wLtRmIJNa+GDZbAxVRZb/b0D0/lW9CoAgW6rb0L/2Pq49Vg4VYCLfI62a43DQzdA0gFp6drcqNwqS8DmLIWbM0j7gzLxpDIXkKiOpL6oQp6ohOsrjAiJjcmaGMMYiYrVWgVpfMmND/aBX0v6HXNsrF3s7DBPt5qliJ1gwUdakN2AQDIbNYCNwM03e5FClNJvoXMfgqmZ7rWKsIqSWRcqRqsA69by5yl/njqMDdPrWwRNKIJld4K/ALOP8teeYse1hoR4quC8YHh9aJUzujOY57sscMoSjsCNq4spm+1/jt
 CjPzQK0w
 KgeK3ZXswOSlKdu420aqkWJevr2nCR/N9p2thDGYeXHDN/rIM51C2ts0DLc+KLoIL1x7ZGxN4+kajSgTp9UfG2wqvkl8dFEaanpTUKtpWDHMCHCWDo52XJNOK8OH6sSrh61Xdrmdv/PqpvoFqUgClz0sq3rNOjP1bFTb254poV6N2z0tNyED5c+Cnjy115jUZs8BcdZIRRCdTMN90uzVs0+AcVhgXGbYMPyQKpvmQ6ks72WPBagGww7nw80sbiPHzdcwjTWD8DBJo/upE+99Tw9LEfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_goal->complement needs to be manually set by each API
callers.  It is easy to make mistakes.  Extend the quota goal
constructor, damos_new_quota_goal() to receive and set the complement
flag value. Also update all callers to use the new signature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h       | 2 +-
 mm/damon/core.c             | 7 ++++---
 mm/damon/lru_sort.c         | 5 +++--
 mm/damon/reclaim.c          | 5 +++--
 mm/damon/sysfs-schemes.c    | 2 +-
 mm/damon/tests/core-kunit.h | 1 +
 samples/damon/mtier.c       | 2 +-
 7 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 78b227875287..b310c40d6ceb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1098,7 +1098,7 @@ bool damos_filter_for_ops(enum damos_filter_type type);
 void damos_destroy_filter(struct damos_filter *f);
 
 struct damos_quota_goal *damos_new_quota_goal(
-		enum damos_quota_goal_metric metric,
+		enum damos_quota_goal_metric metric, bool complement,
 		unsigned long target_value);
 void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
 void damos_destroy_quota_goal(struct damos_quota_goal *goal);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 270ce9c85a2c..86f13411b91f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -691,7 +691,7 @@ void damos_destroy_filter(struct damos_filter *f)
 }
 
 struct damos_quota_goal *damos_new_quota_goal(
-		enum damos_quota_goal_metric metric,
+		enum damos_quota_goal_metric metric, bool complement,
 		unsigned long target_value)
 {
 	struct damos_quota_goal *goal;
@@ -700,6 +700,7 @@ struct damos_quota_goal *damos_new_quota_goal(
 	if (!goal)
 		return NULL;
 	goal->metric = metric;
+	goal->complement = complement;
 	goal->target_value = target_value;
 	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
 		goal->last_psi_total = U64_MAX;
@@ -1262,8 +1263,8 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 	damos_for_each_quota_goal_safe(src_goal, next, src) {
 		if (j++ < i)
 			continue;
-		new_goal = damos_new_quota_goal(
-				src_goal->metric, src_goal->target_value);
+		new_goal = damos_new_quota_goal(src_goal->metric,
+				src_goal->complement, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
 		err = damos_commit_quota_goal(new_goal, src_goal);
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 273efa3c913e..64e086985eb5 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -233,12 +233,13 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
 
 	if (!active_mem_bp)
 		return 0;
-	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
+	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, false,
+			active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
 	damos_add_quota_goal(&hot_scheme->quota, goal);
 	/* aim 0.2 % goal conflict, to keep little ping pong */
-	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP,
+	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP, false,
 			10000 - active_mem_bp + 2);
 	if (!goal)
 		return -ENOMEM;
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 42a2c9cb1343..014b0779ea6d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -233,7 +233,7 @@ static int damon_reclaim_apply_parameters(void)
 	damon_set_schemes(param_ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
-		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
+		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US, false,
 				quota_mem_pressure_us);
 		if (!goal)
 			goto out;
@@ -241,7 +241,8 @@ static int damon_reclaim_apply_parameters(void)
 	}
 
 	if (quota_autotune_feedback) {
-		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, false,
+				10000);
 		if (!goal)
 			goto out;
 		goal->current_value = quota_autotune_feedback;
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index bfb6f0bc3f21..06af417bc9a2 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2869,7 +2869,7 @@ static int damos_sysfs_add_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(sysfs_goal->metric,
+		goal = damos_new_quota_goal(sysfs_goal->metric, false,
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index df84d9cc7d20..20bba7421a40 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -930,6 +930,7 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 		 * Make it kfree()-able.
 		 */
 		goal = damos_new_quota_goal(dst_goals[i].metric,
+				dst_goals[i].complementfalse,
 				dst_goals[i].target_value);
 		if (!goal)
 			goto out;
diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 27dc88bdf7a0..a2e311082cd4 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -163,7 +163,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	damon_set_schemes(ctx, &scheme, 1);
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
-			DAMOS_QUOTA_NODE_MEM_FREE_BP,
+			DAMOS_QUOTA_NODE_MEM_FREE_BP, false,
 			promote ? node0_mem_used_bp : node0_mem_free_bp);
 	if (!quota_goal)
 		goto free_out;
-- 
2.47.3

