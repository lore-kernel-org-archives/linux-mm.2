Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666B8F99C6E
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 01:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF3B6B016E; Fri, 17 Apr 2026 21:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5D66B0170; Fri, 17 Apr 2026 21:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9766B016F; Fri, 17 Apr 2026 21:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 156D26B016D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:44:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C76811B70B4
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:44:46 +0000 (UTC)
X-FDA: 84669982572.19.DDB5F72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F928A0004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:44:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e1/jPzAI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776476685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqylHVEnv6IINJVCYDRJPyvV5dkI9f5rao0aDOMuNyM=;
	b=212DyuNIUREjnGc4aVbxGYzICeVIfeA2Aus9cHFBAtSiiIxDGOrDXWDO7BndCb0M8YVoLm
	apYUWKh802xTSsd2NWfwowPzQRms69J9ynDCpwDXxny2A8VcORbkiKRZ0Hiy/m1ISSi+b+
	PgYIFDXK+YiJHilZjpjrVSYiWERPCTk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e1/jPzAI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776476685; a=rsa-sha256;
	cv=none;
	b=VHB8Qb7rl4eRA6GxyFvj76VuoYq66OqyCGEUbc62B52w//icwUrUtpr65jVn+z7vZBXByo
	R/Ag+XhuvP1qS/goWLRa3du228EtiSHwh3JUdqvAjbg2RIeuqEAKOsBl8doDKXWHlOxA4a
	RMBkz3xALeTSLqovzwsnsPIFQlPY/Rw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9871C6013B;
	Sat, 18 Apr 2026 01:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1270EC2BCB5;
	Sat, 18 Apr 2026 01:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776476684;
	bh=VwmRBwu2NpsDame3NYgCfeOejXdVJkUdY686E9TRD8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1/jPzAIC4i1MizLB1jTf9vtSgeNp2dYB3L9qJL0zo7Tkp2gpwjeWV150YfPe0KHc
	 mJ1f8dDDdDIxwt8eXcCdAM0sRSN30I+WHp0likkg6SIW/1+3YU9pn1S5TgWuf1YKOm
	 x5j1r7EobUuyhgTn0nnr4iuB0aIS6sAmeJoAoajNTPLgXLpL5x+F1W2wB6kDJ+E0YD
	 644vtnv7nGXyJEQRqE5K9ntYfNVVAg1PIhn9qyr3+l/JB/mdW5q31Kf2w3157KVxAB
	 qGk3zi0Ku1UTDJUULHlvc8tE+pPFwaz8LqG0VBGdkFEituRP62zzAIQYWp8aQWvnbA
	 QP8pyXhpblBEQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH v2 2/3] mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
Date: Fri, 17 Apr 2026 18:44:36 -0700
Message-ID: <20260418014439.6353-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418014439.6353-1-sj@kernel.org>
References: <20260418014439.6353-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F928A0004
X-Stat-Signature: xpg3jqez3cniiou8zsk7d3ztreocndzk
X-HE-Tag: 1776476685-182034
X-HE-Meta: U2FsdGVkX19c3J4ZUofRVppCEVBgvzY4ZhUkjGB+fXwyj+ARv+q8legeu9dmhh3p/x3n8pxzd7FoGMTUNt6MSH/3+DILI+lMEwWQZWuZ5uk/Dl9YH0Pz9CIaBgoJgcRwZfvkVie/JS8eeJOy36SHnjPjs8UGl5a5OuuGa2mvOx9qPriK+3gvhW1eIZ03QIyK96ZZZgYg7tFHD94nKDy/UrHlS7WvqnN23Izrc+3aGiTgot8o5E+UicjHjLPMxuiVvP4B5RECft74gGISPmDBNsLUfXd3Yz8snb0QEolGzq2prOH3jhsj3JIFdNvFGJqPXQLrFrwrTxi0sTFAeMkOZ9xzF6A2i64k620QlJoDoh2yXpKW/dtJtgdQJ6AfKVCnBExQE5VfxKSWY/LFbbjYS02hnOUaa1h04titYB1tuT6QlGkoi4WfQDVYGVJBjCOL5Y9r3DWPvNU7Tu6yj9pN5ghF0QRjSXM7kPAtTdCYGVlTJ0j2B/KANt2XUzeRd8IqvGVWDRBAr4LCYS6QaCgs8ZO7wqgqTqyW+z0hdiKLp8fsYwUuN3+iWp5e/Bck+rdJFRiT7OfVzCOGNmmrR5coj02ijCPz4h4HTAJ3SDyihp+I1q/IA1TujJ7r1uBqVs8drSoSqnSsZ3szzzUuBQhTLrymAc8YwiwfiigPUPY+gNi7hA8GVQuL+saUVOpZrdX19y8SJJ5ItjaOk0la1W+ZsVBYayrn1lbTlwjKdvj6yOhGXxYxZAAeN0Sj/6eTYl8+3aGBuQYZuTI7I1qw5M274g2gh/HNAa06A8Jld2symvtrnakUR8+yf+ygolNXMo46wv2d2TVHhztdNoyAJQLpcXHpOs9aPCMsJImwdefhLG2bUlcgVws43YNWdh+Nlb22Vvo0/t2WqXnt1AWhnE82IWCitu1FrFzicSnRAz/cC0IwTeVGRvxFXKGG/Af0sqsb0mklooSw/wDLtnV8wTt
 71FaZTq4
 j99xhhqYtmc4oG4/W4nyWza4v5RlZBgPH3n4P5NHjg4VLOvDJm0pMoGhYb2LDo4dbmU9a5ZAkNBCyP8WUPnd/yBDXtBDfDkDOIff2RO8pPTPzwltzgeuh31j51yjxLsKGSCSunbWV715twmIOhC2qUVdz0WZRAZEq3umyvpQBM0dwQsndZdqfNvDilUVf9XuuZAyM2RX6so5Xi88C9TKrIug7Ya/hS8Z/eL983yGoGixdp6fmy0a6SJUYE+UZXcCB4Xtr8DKc8PFcIL+RpXwKiroekGiLuU0xxzUQ81z8xoVeRK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT updates 'enabled' and 'kdamond_pid' parameter values,
which represents the running status of its kdamond, when the user
explicitly requests start/stop of the kdamond.  The kdamond can,
however, be stopped in events other than the explicit user request in
the following three events.

1. ctx->regions_score_histogram allocation failure at beginning of the
   execution,
2. damon_commit_ctx() failure due to invalid user input, and
3. damon_commit_ctx() failure due to its internal allocation failures.

Hence, if the kdamond is stopped by the above three events, the values
of the status parameters can be stale.  Users could show the stale
values and be confused.  This is already bad, but the real consequence
is worse.  DAMON_LRU_SORT avoids unnecessary damon_start() and
damon_stop() calls based on the 'enabled' parameter value.  And the
update of 'enabled' parameter value depends on the damon_start() and
damon_stop() call results.  Hence, once the kdamond has stopped by the
unintentional events, the user cannot restart the kdamond before the
system reboot.  For example, the issue can be reproduced via below
steps.

    # cd /sys/module/damon_lru_sort/parameters
    #
    # # start DAMON_LRU_SORT
    # echo Y > enabled
    # ps -ef | grep kdamond
    root         806       2  0 17:53 ?        00:00:00 [kdamond.0]
    root         808     803  0 17:53 pts/4    00:00:00 grep kdamond
    #
    # # commit wrong input to stop kdamond withou explicit stop request
    # echo 3 > addr_unit
    # echo Y > commit_inputs
    bash: echo: write error: Invalid argument
    #
    # # confirm kdamond is stopped
    # ps -ef | grep kdamond
    root         811     803  0 17:53 pts/4    00:00:00 grep kdamond
    #
    # # users casn now show stable status
    # cat enabled
    Y
    # cat kdamond_pid
    806
    #
    # # even after fixing the wrong parameter,
    # # kdamond cannot be restarted.
    # echo 1 > addr_unit
    # echo Y > enabled
    # ps -ef | grep kdamond
    root         815     803  0 17:54 pts/4    00:00:00 grep kdamond

The problem will only rarely happen in real and common setups for the
following reasons.  The allocation failures are unlikely in such setups
since those allocations are arguably too small to fail.  Also sane users
on real production environments may not commit wrong input parameters.
But once it happens, the consequence is quite bad.  And the bug is a
bug.

The issue stems from the fact that there are multiple events that can
change the status, and following all the events is challenging.
Dynamically detect and use the fresh status for the parameters when
those are requested.

Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Cc: <stable@vger.kernel.org> # 6.0.x
Co-developed-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 63 ++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d729760..d284cb336b662 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -161,15 +161,6 @@ module_param(monitor_region_end, ulong, 0600);
  */
 static unsigned long addr_unit __read_mostly = 1;
 
-/*
- * PID of the DAMON thread
- *
- * If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.
- * Else, -1.
- */
-static int kdamond_pid __read_mostly = -1;
-module_param(kdamond_pid, int, 0400);
-
 static struct damos_stat damon_lru_sort_hot_stat;
 DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_lru_sort_hot_stat,
 		lru_sort_tried_hot_regions, lru_sorted_hot_regions,
@@ -386,12 +377,8 @@ static int damon_lru_sort_turn(bool on)
 {
 	int err;
 
-	if (!on) {
-		err = damon_stop(&ctx, 1);
-		if (!err)
-			kdamond_pid = -1;
-		return err;
-	}
+	if (!on)
+		return damon_stop(&ctx, 1);
 
 	err = damon_lru_sort_apply_parameters();
 	if (err)
@@ -400,9 +387,6 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	kdamond_pid = damon_kdamond_pid(ctx);
-	if (kdamond_pid < 0)
-		return kdamond_pid;
 	return damon_call(ctx, &call_control);
 }
 
@@ -430,10 +414,16 @@ module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
 MODULE_PARM_DESC(addr_unit,
 	"Scale factor for DAMON_LRU_SORT to ops address conversion (default: 1)");
 
+static bool damon_lru_sort_enabled(void)
+{
+	if (!ctx)
+		return false;
+	return damon_is_running(ctx);
+}
+
 static int damon_lru_sort_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
-	bool is_enabled = enabled;
 	bool enable;
 	int err;
 
@@ -441,7 +431,7 @@ static int damon_lru_sort_enabled_store(const char *val,
 	if (err)
 		return err;
 
-	if (is_enabled == enable)
+	if (damon_lru_sort_enabled() == enable)
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
@@ -457,15 +447,46 @@ static int damon_lru_sort_enabled_store(const char *val,
 	return err;
 }
 
+static int damon_lru_sort_enabled_load(char *buffer,
+		const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_lru_sort_enabled() ? 'Y' : 'N');
+}
+
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_lru_sort_enabled_store,
-	.get = param_get_bool,
+	.get = damon_lru_sort_enabled_load,
 };
 
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_LRU_SORT (default: disabled)");
 
+static int damon_lru_sort_kdamond_pid_load(char *buffer,
+		const struct kernel_param *kp)
+{
+	int kdamond_pid = -1;
+
+	if (ctx) {
+		kdamond_pid = damon_kdamond_pid(ctx);
+		if (kdamond_pid < 0)
+			kdamond_pid = -1;
+	}
+	return sprintf(buffer, "%d\n", kdamond_pid);
+}
+
+static const struct kernel_param_ops kdamond_pid_param_ops = {
+	.get = damon_lru_sort_kdamond_pid_load,
+};
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+module_param_cb(kdamond_pid, &kdamond_pid_param_ops, NULL, 0400);
+
 static int __init damon_lru_sort_init(void)
 {
 	int err;
-- 
2.47.3

