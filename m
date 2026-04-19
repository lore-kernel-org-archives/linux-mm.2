Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6609DEA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 16:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E569C6B032B; Sun, 19 Apr 2026 12:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B966B0326; Sun, 19 Apr 2026 12:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48B66B032A; Sun, 19 Apr 2026 12:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 994CB6B0326
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 12:10:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B0941B89A7
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 16:10:15 +0000 (UTC)
X-FDA: 84675792390.18.7F10C96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A424340003
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 16:10:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Axj5Ib36;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776615013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLDkd9tqJBYc7dg03HyPlI7CynQ5Hb4OQFuBgIV9Pr8=;
	b=Zxq3ZZcPycQ5YzRvxyZlqnRh2N6boassIo5OKG4uaat4UBDrzlRdbZvRdS6ENNa5R/698R
	6Yeh86whHhLUrw4KrnLfv+2xPyoL9s5umnPb2EYFpinoYba+LPETlk5m1015mR3hMbKU8f
	jV6l+qa44YANN6L+gpEiw4dsq5jvp7M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Axj5Ib36;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776615013; a=rsa-sha256;
	cv=none;
	b=T6QbvHXxK2ngTPsM63UHtmVKvwimUNq3Z+d0/bTEY1BGXM1XGWf661z+9JeCoen5YmVcng
	wEEAQyuTXneggmvTYX40LSanrWUaPAwM5RNNNNePGqdH4wpAxUnMvNrcXrcjgv2leXzgV+
	6/KfHqZQsu3ZYGYQsngHqEwQEVtwJ3E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CC2844403;
	Sun, 19 Apr 2026 16:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FEFC2BCB7;
	Sun, 19 Apr 2026 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776615012;
	bh=XJiKgBwZzik0HajbjdzAq1QjDE73mSEjEwzICB3I8pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Axj5Ib36+otLm1b42ppZ/32J8NdpVd354VMQUq95cy4xqqUQuX6TTeQhSC4St9xDs
	 MgLOu3zBOTtxyHSWuwdYSuY25/L1agelBfrTQpjeeIyuhvPphf6G7kourOshwx7ZQp
	 Gjm4xr+4KUjmWa7RMRS//2K4WgfIn2plDHbucmIJmjI8TdsYAQzx18GBxSL92uP+0L
	 tQX6RDAGD6odVSj19JanvVzfGw24K/QzsNSgdd5cbxeW8k/7JxCXJARCuQ2X2/9cQx
	 xqY3YwLFGvEav335Pegm0vwlx4LYF8UHuLcL6lUXUiwlj7KycmcqiwXQ3LtTJlGiQe
	 RPDXmUDZc9DWA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v3 2/3] mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
Date: Sun, 19 Apr 2026 09:10:01 -0700
Message-ID: <20260419161003.79176-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260419161003.79176-1-sj@kernel.org>
References: <20260419161003.79176-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A424340003
X-Stat-Signature: 514chxhno7p8h3ghfhhiokt3pt59jsgx
X-HE-Tag: 1776615013-81561
X-HE-Meta: U2FsdGVkX1/Ivvx1r9T6BSCX/5ce4zHDckBev1vaocLbzoUib+gjX4hoOkPd9wtpqw5Nssi2Lr1LoAWadXxmPZi3I3OlQ647GxoNXIrNG5/j0z0G7a04nSNZk2z77pvQAvI5yPbGBW/6Jvp2DiUVv9EFKs/izVozl8jHL7XgzAAZwkr1n2YbROeun0wh0+sdyr4DMtzsXP6aDuRabv8Sw1KnfPbCIUFDqO1Lr1hEzXZEJPuQDNLAqDd7kfTgIkw6FHaWOaJMTZXIcXot31ihPuOstY4wQcV/H4aFzglnoPDjvzLShHCA5qnCd+Zd2uSmmC60q1ZKQFQW3LZgzlNstJiHBQVDGvx7u7OQ8kyqdsq+EgRJ8hxlx2XHAViDB71soucaBICEDws8pr4AGAh8PCgYNZmrfuNJF8KxQkneJS8Q1HYanfNJ48AKJasYMwg1sqfSUgU7xmTxjuekK1CC5vvpKaY5XoxFc0u3p6KhGxOD7G+aorHDQEBB6Owp9JOoAN0diDqg5nYaN5MUZMUFKSE4Q3wr+YasFP7IjRiK0pXK0+xZ3rATsx8pqtvwHN49XCNsgR/73KQIvqY3OQTE9PWsx/zhbaQRF8nziSgEijHDhxrMpZs2rEuzxq0EpfN3bwnENDwxykElIYkvWyTbdPsxI4QXqG+4KUPuXTfF0QNEp8YIYG3hjXkcuOH4YxQKQuFCRwvSw1LHZ9I1rW4wNhX+r+VDNumC0BAHuvK666HSoyZBEuJdW95lZnQbsp6VJ7bvFk4wC2DmlwADJ+bbsPLwBWtI7XHvPBD87YInIlij4ArE3HQQHdnVatEelGZbErH5PGn3X6PqnBY3EXQMwf1bbAo8kNLmSEtewiPVErLAqEDreZ9z+vFf8eccfAmQXUXTF4glm5QvYC1PCHu9mZFg+QMfq/tdEag1jr37nTY1m/mnvou+5Mxm13MVtj9dv2+3cvunBpJkmF28KzE
 mZcFW5Ic
 Z5+1sFlM0WrOTLJjZU60s6r4tzHhORjG7ARdWnwnGA+Q8bWJkRdmWomUudufEecf9W9VzaGcoiUcFZFj1T7uzM0cYPu2dC2f8Tzu4ILjpjaCUiAErssYqFjoYy91uPo/y8imuSmi2KbEj+LeqtWr4zNZn4drbEhhJRZSBxTj7NsFuYc98FIUbwSmcBT4LbUSSzFcoXJjMBV5Kqb/VMoWawyXMr03rI/ZTlSBio5DgmK7ZYcXAUcGH6D/ehOQNZ3FiytBq7s4NqXydYs5g+g5rdlUX6Ad//qGLxORsFaYlzxdr9Kc=
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

