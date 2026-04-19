Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF116EA71A3
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 16:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1148D6B032A; Sun, 19 Apr 2026 12:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55466B0327; Sun, 19 Apr 2026 12:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32B46B0329; Sun, 19 Apr 2026 12:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A42F76B0327
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 12:10:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 633BD1A077E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 16:10:15 +0000 (UTC)
X-FDA: 84675792390.17.6E93438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE65D80008
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 16:10:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V/F6L+rD";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776615013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIZEeCECCM9Q4J4z+BRVGAtzkIdxDF8M2mtwGuAA3ls=;
	b=SeJKjsqNkgOLEJvOL/CpTdb7B3n/hS41aPze4XeWMf/kGwd5dx0hLlUw0lyEEsb5InzJjy
	m5UmVUiJ9BqRBclcuuXE72VQ+ZrNdyRZgiZZsYFwI05bnHuMym2BTiWa0FjPlIfYQNxYU/
	qjwRrmxkupXz8tMVJlO6/Es+O5kkPzc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V/F6L+rD";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776615013; a=rsa-sha256;
	cv=none;
	b=DMCLzQ3pibCVl8KLQNz2F7Akxz4PdpJ/rv6FcjVg26BlGqNCjZMwP01K8ubINkrXRMVuDf
	ONnD5nGIJLVtEIT2MD3CsMHEvhOlPf9u4R318GZ5KgYpLFVS3u38jfbHDCHgCigsBhbjA6
	2FcVMsPLVYYBH87DKPkP25rb3gmcl7U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C63954440C;
	Sun, 19 Apr 2026 16:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77892C2BCAF;
	Sun, 19 Apr 2026 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776615012;
	bh=rIOaDq/KHXQ6SzD1AFFL4LR91YKZhChannZeLdJ236k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/F6L+rDzvl2gUnTte2b1pXCBREgpl8MSm54iG5JOxUR3qhDYp4bkHkWohjIP26Bj
	 gSXNwAalq2hNRlHvoczkAPcqlnAag25yct3Iw6HNGwmO+DCvugOlhNHBJXNyG7mznt
	 EkOEYKjikzKIa8pruVhZ83xlrwezSNFEX6QBMqA58EwheInlFegTK67SZ4hlu1EV6e
	 XlAu5Wy8FR/PfGfp/1FCgtlcuqWuB8UegsnP/htRYLRNg6qu2iurV9pjqyzHBxQ13u
	 gicTsL+a6Eda6RLU2Xe770O28vHYBEj+nDDTt9GiLHXvjfNrM9AX6E1JRy8HXqzYZ1
	 ZfLPTuCFXFPlQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] mm/damon/stat: detect and use fresh enabled value
Date: Sun, 19 Apr 2026 09:10:02 -0700
Message-ID: <20260419161003.79176-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260419161003.79176-1-sj@kernel.org>
References: <20260419161003.79176-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AE65D80008
X-Stat-Signature: 5rudp8nsfdu7bb7zpd8g97g4teaeersy
X-Rspam-User: 
X-HE-Tag: 1776615013-746276
X-HE-Meta: U2FsdGVkX18JY457B+5hKyD/PljpD2p2Y7sKLuNLmh1RCLvCnZeE3ncf7Qvd8dH8XV6lzje15JThmAymiOb/BEfF4Wm3tgLJpxamFLpo2o7H66TAw/TGaoYNpLZg+hW9AJ4SphBXol/l4HQtNQEF2PbW+c7sSKK0gFr7RtYQxi5IsgS7i7PU27RMHfW+gU1d8fATZ/8PiZmDCga5H/JikixnHiRSuTJfIdObKw/QlwkzuRYtrWyxiUOtcz7h/+hdic7+8y78ED0EL56woO+6bAB8FMRXwaf8TomHgry1iEPAhqzn1vQHsSC99qyPz/6FHXijU+lI4S4QvFTMEUergsSrnECBm5WggkUud9jM8oVyh4/m6h9ac7iTgADzWcfd0tVUQNNnyxoZRMHMwQJvvxlfOcfaOdkI/QO7yolUo4Q5/uBP5xla76HnS3g2gKzWIFlKSFWPZf/BiAKRZ8xNICB7zVNvRkonmT1GbJF0/x9L+LahOIUkpy2OJpJ1v6iBuvHNiJmfXY64+z5kX0JJGscQ9z02KjIkjlOstQ33+TCQ2QovnCYZYCa/xTit/LSObxBEGLOC4yDN5duMc6i3GrpRNjr5ZO+RHSLB66eH2iTbxTd8TUnHte0LcnqdzAmB6oeBGmEFTq59NMZI98lTBSbgp0ez1fi/ptqxZbUu3Qu6KBn7tsJjPSdeB2cWD+Iw2q93gu4daVRZ56EC0ucF5Vdi/T4iHOV+mTlxphEaSsXdlhISYX8zXlhyKARkdW9dxM3ZrWottrigZy/L94PIhaZ9H27XNeWpuuyTcBVBiriquOoY1Jg8rTFbgf28Le8b2EkbNN+FlYJV0gfKIbEQFdACsvhwCmkNqC0U3YTeHJ8H2EcHoWCYbE0Uqt26w4VC9L8HYjiMU97M7YZBI8e9yehXH04s2lVlsvAd9EKV/X6nk0sOAq7V7FliMA1HhmEseeHVB5OmHNI7HefhT9e
 4J6MCMlI
 zPtbai3pxiM9wbZ8u3GKnN6vlztKbgHhbcFDgVVh4PKm52vIST0sbntkxeQUIOzWuIgzsHiY2m7g+lVFe1g0Usl+SJoOsAY9VGDJ4obPdcj24coH8raUAClE0jcW3gUtNeLVtg0kAohKu5rtupJUDZCK+yGCV91Yue/VbwaSo7cglijYaTlgadfApau0qRA8HPag+btV6/xKOm1lTgRIPC6eNr9TaTodaNrh8L7ilrw5pWck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT updates 'enabled' parameter value, which represents the
running status of its kdamond, when the user explicitly requests
start/stop of the kdamond.  The kdamond can, however, be stopped even if
the user explicitly requested the stop, if ctx->regions_score_histogram
allocation failure at beginning of the execution of the kdamond.  Hence,
if the kdamond is stopped by the allocation failure, the value of the
parameter can be stale.

Users could show the stale value and be confused.  The problem will only
rarely happen in real and common setups because the allocation is
arguably too small to fail.  Also, unlike the similar bugs that are now
fixed in DAMON_RECLAIM and DAMON_LRU_SORT, kdamond can be restarted in
this case, because DAMON_STAT force-updates the enabled parameter value
for user inputs.  The bug is a bug, though.

The issue stems from the fact that there are multiple events that can
change the status, and following all the events is challenging.
Dynamically detect and use the fresh status for the parameters when
those are requested.

The issue was dicovered [1] by Sashiko.

[1] https://lore.kernel.org/20260416040602.88665-1-sj@kernel.org

Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 99ba346f9e325..3951b762cbddf 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -19,14 +19,17 @@
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp);
 
+static int damon_stat_enabled_load(char *buffer,
+		const struct kernel_param *kp);
+
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_stat_enabled_store,
-	.get = param_get_bool,
+	.get = damon_stat_enabled_load,
 };
 
 static bool enabled __read_mostly = IS_ENABLED(
 	CONFIG_DAMON_STAT_ENABLED_DEFAULT);
-module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
 static unsigned long estimated_memory_bandwidth __read_mostly;
@@ -273,17 +276,23 @@ static void damon_stat_stop(void)
 	damon_stat_context = NULL;
 }
 
+static bool damon_stat_enabled(void)
+{
+	if (!damon_stat_context)
+		return false;
+	return damon_is_running(damon_stat_context);
+}
+
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp)
 {
-	bool is_enabled = enabled;
 	int err;
 
 	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (is_enabled == enabled)
+	if (damon_stat_enabled() == enabled)
 		return 0;
 
 	if (!damon_initialized())
@@ -293,16 +302,17 @@ static int damon_stat_enabled_store(
 		 */
 		return 0;
 
-	if (enabled) {
-		err = damon_stat_start();
-		if (err)
-			enabled = false;
-		return err;
-	}
+	if (enabled)
+		return damon_stat_start();
 	damon_stat_stop();
 	return 0;
 }
 
+static int damon_stat_enabled_load(char *buffer, const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_stat_enabled() ? 'Y' : 'N');
+}
+
 static int __init damon_stat_init(void)
 {
 	int err = 0;
-- 
2.47.3

