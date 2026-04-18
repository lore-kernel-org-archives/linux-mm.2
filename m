Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC52AF99C95
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 22:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497946B02E8; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4432B6B02ED; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187BB6B02EB; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04E016B02E8
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 979BBB9DFC
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:28:12 +0000 (UTC)
X-FDA: 84673116024.17.10CB916
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EEE90C0006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:28:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMigrX91;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776551291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLDkd9tqJBYc7dg03HyPlI7CynQ5Hb4OQFuBgIV9Pr8=;
	b=K1BpYDGj0J1QW6PJnHekyL05w26GwqKEf5oC5GpxRjC02SbtA/HRV/2evrc3Uestl39z3K
	B6Xlwh1uvH6ihfzcWLWBlI9Pcbd2de4k1mPlQbPhx3zlKAhdd4vIKpLJnl5Gjj2PE1FBiW
	2yfkX4o0c5tDzsJco+e/ybqR5UelFj4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776551291; a=rsa-sha256;
	cv=none;
	b=QLMwalPn0VEQo7z6sbYDc/dZdlQwAYIQZ4MeKMlRezuzTXoodt4xFqkr1dAFrYck3IcJom
	cHnz3QIRadbSXCTcRHIHqqXWAsdyRD5eBAU6oJomH+nxOk83gy+Kn5ZiOQKes9r0kKgPvf
	OPy7t1kWZLm0Iyl7eQ3IE8huCU8k3hk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMigrX91;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05B11416F8;
	Sat, 18 Apr 2026 22:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993ECC2BCB7;
	Sat, 18 Apr 2026 22:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776551289;
	bh=XJiKgBwZzik0HajbjdzAq1QjDE73mSEjEwzICB3I8pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMigrX91xhjmcOjZhLtHX01ErlAI212fH3bUjd0Nhtonn3pEWCSfOGZFQWFe5L18e
	 379/S5E3V1kV6nupnKzIbVRdif6vwHjM1/2USMRTf3BX6RbN1vhQVt+0Zc2GrC8YxM
	 2cDjuY94lhGJiD1YRJOb8MTCQV3UMXwX5409V2jJwwm6Z3BUh9+W1WhTAIauUWme9z
	 g0G6k1tWL+6WDTFPg2GC+Dx0rqC4LtzrgrPNLCYSF2B/Q9ZBFT1sKFahVxIGeF/9jc
	 wNOLKH+edH56WvvB4L7d1HrbxUQkEM3I1+n5sPJ+0YnBE/EnLs4SMWeMIQFvkU1jb9
	 Iu54s9XsBUuYQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH v2.1 2/3] mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
Date: Sat, 18 Apr 2026 15:27:55 -0700
Message-ID: <20260418222758.39795-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418222758.39795-1-sj@kernel.org>
References: <20260418222758.39795-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EEE90C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: q34kyhkfdkkagwhezgxq47ux64o1ugy9
X-Rspam-User: 
X-HE-Tag: 1776551290-621723
X-HE-Meta: U2FsdGVkX1/iCg9dwTwC+ylYp8UAo0QLaua0MWzqbfG1aKl9sh8+syBGl3C4CltbH/znFJxprbHg8ug/nR+4r+mGhRguPTPx9ae+fOxeEuDKFITIhForQgKN5A9F3NBM6xkOlkdGMZ3pmRm9K4jOVnItRmhoCiQo3PmiyQ2YxKmD+0gezAySRxPNxy0DWzDo/81MMFAcBoUtcCannMucABhMC5dRGw2KTNJGjiAyAk5bdpNjDCM7rcu/ZHtpDuQk3L2ZwNo+jvdvmUIy/MhBTL0MpGUGDSuMiQc5ylYRCriDxdzNurpZqhQM+6Pjsgjzj9bJzMsArRHpO+pFQXSlkvZvKExzTp2yviwInVf5Es2lxy/gy+mOV9nU+A1/EylEn2CDGyW6VTWyGxpodm6YgbHMh44QfCGrK/E6wYTwkVlBuFzoTP2yMaygkAp4atwuh8k498FWa/14ZmHOFrueHWed3DyTttn7X8Rc0WDTd/Hw0LEVorbXLMJ+Hvc08Wx6kRJNiSFNVdB1eWRKUIuiNtp5iJjdx0Awzbh3y1Gz+b9L4IFLCw+B9DKdlMTPLlRx80fCFLziCWDLWdYhK/WKpuNeLl18BKc0qAFjVQACPJvjxYtlU5AuAaFFvsMkN0QfruUN7VtvN7vszFsodpWH0caiWQCNlThbgKnS/nxu5gFLIi6WZ2W/b8gw+xmvWmUtFeiuPK5/PRAyLZS4H4JHPK5A75qh4A0hvgGVNI+Fb7kCN8hCeDr0n0e1a9O9c9sizOIuaBE+JkF+ZtPqOeCAAwcSHqjdrPQG840wXRsf4pQO6ln6KMLdgWBmYEZFOY1cqplT1t/QaGlI1dxS5RSX4L1LFZR3vjDK3D7Sjcsop15MiBwnyQgycojLpsxYExQKyOAasyF7OgOmSFXxr7nOkJ9gjmpI3R5r1k0ljkZRTWhZynBtDiHFxJgxzGeiWDQ4JArF2MGThlOg0jSs2o7
 xbYQxZEH
 KY4ictCFn3zUxvFEonPTLpEttZXRWwhvxNd6f1Ok+GirpUlNKC2WJ6eI7p7dkaWLOT2sr5+QlBgtmjX8ngBZj1O8T6H6GoTSjJVGfphSCG30NPPNyJPIlB8eAsBqjJ6uMYPL3hK9RvRMx1p4SFAdDUvkk9q+XIuxow6A9whY0fJnUuu8vIO+TF4D+6nn6RGKjrx6ClCxwxhwxNndb0Q4K3/HrX3FkEZLbhGX6NDEaOymeEeaCK3HoG25v93iJNafefiZKMvKMZS7pVPOBKiWC2aPI92tkamBCagJz5iOQOI8Ais0=
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
 mm/damon/lru_sort.c | 85 +++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 30 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d729760..8494040b1ee48 100644
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
 
@@ -430,42 +414,83 @@ module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
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
-	bool enable;
 	int err;
 
-	err = kstrtobool(val, &enable);
+	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (is_enabled == enable)
+	if (damon_lru_sort_enabled() == enabled)
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
 	if (!damon_initialized())
-		goto set_param_out;
+		return 0;
 
-	err = damon_lru_sort_turn(enable);
-	if (err)
-		return err;
+	return damon_lru_sort_turn(enabled);
+}
 
-set_param_out:
-	enabled = enable;
-	return err;
+static int damon_lru_sort_enabled_load(char *buffer,
+		const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_lru_sort_enabled() ? 'Y' : 'N');
 }
 
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_lru_sort_enabled_store,
-	.get = param_get_bool,
+	.get = damon_lru_sort_enabled_load,
 };
 
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_LRU_SORT (default: disabled)");
 
+static int damon_lru_sort_kdamond_pid_store(const char *val,
+		const struct kernel_param *kp)
+{
+	/*
+	 * kdamond_pid is read-only, but kernel command line could write it.
+	 * Do nothing here.
+	 */
+	return 0;
+}
+
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
+	.set = damon_lru_sort_kdamond_pid_store,
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

