Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7BA3F99C6E
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 01:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0EF26B016A; Fri, 17 Apr 2026 21:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EDA6B016D; Fri, 17 Apr 2026 21:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6526B016B; Fri, 17 Apr 2026 21:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95CED6B016A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:44:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4AA01C192F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:44:46 +0000 (UTC)
X-FDA: 84669982572.11.B27D4D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id ABDC540006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:44:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKgBQ41+;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776476684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cH4j6CDvKW+qwLDkxOhoRQ7N3WP7IMDlxcQI4nRUvk0=;
	b=gYfw+/1On5ZssT+AOhuW0nQ20wPJ0AMudU0IgrL6JSHjZFE+0MNRFNJOtyeRha2YEf7CHy
	dHmds3xITnqeDmZQUwUBiXY5yORAOqoPgYSibv6Z6hwAsjgT8oNLWGCLp6XoG+emxMDCGp
	Hhbb9TephnzsztRJgFhTeQUxM5UTsro=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKgBQ41+;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776476684; a=rsa-sha256;
	cv=none;
	b=sAgMu2I8IPWm/LShSItAB2ZVIyBg5HuWe6ex1WsUVZo5JoX1QqTj6RmfHP2Yf5x6umLSVy
	REq9rDlnBWCHeRfgm18BRSXMdLcpIwkGEoz3yQHgacPyyreJbZdp615zOR7ngb1P1xG1CW
	+7ZttANf//sy6N1C1NMQmOuKqSdKSZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3346C60139;
	Sat, 18 Apr 2026 01:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2ECC2BCB3;
	Sat, 18 Apr 2026 01:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776476683;
	bh=5z4oVqUMMQVp6V2C1ze2m6XohEMFVXHMdzKYnWkK+p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKgBQ41+8haHLORu1fQvcVWZiuW125NGiGOjcpfJlXvaR9VyDG3g63t8KoI2VUgs/
	 9yr7XzOC5pAjBkCX+mM9viL0IDs5TKHVkP+e+/omIJ0FZMSFVQWCegCzSe28ut9kOK
	 MxcZhAr5Elak8fn1/9srbg0TGnNH0lWdoCh3KkV5sGLPzShJ8fcnZDikYfY2hjMsF2
	 GX+u0DNKGagtzttV+wWYBfqKBNqCO+xZmHYcTBaV7+fSU5tM0F1J+3zYxTagh+Wbra
	 ROPVWm7JSzRG/yo4oEBUQU2P5YznMw8SdVShIM9aBehctCcEWXoVh2vHaR+LCFI9Cf
	 nrZmeuXAzmVuQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH v2 1/3] mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
Date: Fri, 17 Apr 2026 18:44:35 -0700
Message-ID: <20260418014439.6353-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418014439.6353-1-sj@kernel.org>
References: <20260418014439.6353-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iz5gz1kzjpe3s65jxgqsxs34wc1g6wg6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ABDC540006
X-HE-Tag: 1776476684-334607
X-HE-Meta: U2FsdGVkX1/s9mMM6pViN3C04lS4Qak2L0M43wUWybWpW8VHxIoYyrW7ij2Xnn+5MBJPV0sAVDAH2ZmjVQhEFHPU5KyJlHmQv/vDWGgVtWoPFQVECZjYsBkerqxU855RtfzidlZQaXxMTPYKkba77BjhCYcOkLzfekwRDIx4pzmdE+p8Q24mg8i6S72AdNj6nUxpSLXivo7xHB5kTw8BGgdHxmwYtuN/ZZzqqJpZDndMdM8k+SYydYETacjIdyhbNREaJflAVVWV6P9fGg39Zf6toDQesy9wPorXcy5tH0qkiQ2urgWU3FFF70wQ071YMbFtTJC5AYrTNMKsaClECszfAJ6IdZJ3xuV/LfAHe0wJnW5Su0CTCErXBcqPpWDQIXys+E8CWfziFe76uRElIAcCZpoVGliqOOaB5oCT3kIVa1oPTos2lZ03YnK5wMQMDuBRdosQNcs21DXzn2cFVK+kH1Ozpb8B1lfJEJq+9ZJf1RG0VRTRx7ijEpQiamef8DV5+pksM6O775cCysU4aSx7zcCDbmXcrupDmVmGIJtJ28iSbClQu44beuTsYEXkXhUiBBGE4JshKEcMWJozerNv2LLHd5FAv5v2e1UaTAaMyg3whj8A95Uoox+vOMQLMvYpRZkqsRicZsBnt4knhUDhnAcpgdMg7tM04a8En92X11bH6NJp0o7TsZ+wOPVwblCaqSjidvhSiiBMEAPU/dzY7XT1K1Z75Kknlk0x/YD/ZaR93v+72Azk8xKClZ2SSXMZjdNjzD1EUWAvDkf5wQaUX4GdfkaNtqAJunylltRJio0gYTLHmSsg9wR0mpTQ75JFruTk5fiBLV1XrAAf3FzG2UEiYt9wntyYbdZMQgCQrTsYnXlpiyJjqvOg8dC+MPkMtdiYa1LwDmK5SI/cZoJn/l2SUix5+PpQa/c4TnZ0aXFVLslcKvIRlnV7KNCPQcYPn+8WjZrIaVmTjoC
 PdXo5VgL
 9kwUVoVCLSPsLTdDkhXToD8cbayjPGwoggvfVzhY/rgeHX4e5X/JsJX4lE4dcfdF6KlXzoPX1homiGVMyJBhqipSZ6d1EsqGwc5D7TgW5MRICFLKZMAS/ZyHRAO6IqalWgtF5UClIOFDgOz2hj+8+il/6ZXCdllrKMSzB9ZUtRBHKdtjhU5PEvsvLw5NOSHIgpyCUuU4KFfO46J93sRS2/jmuZL4znULbGtQvXo2RlZRnINFNDLXLyPsV9uSWiqlUtQmbWtben+XdQqaMiaHSgp0VMpCqPeyCUZNaiPgAe4Hvrpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM updates 'enabled' and 'kdamond_pid' parameter values,
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
is worse.  DAMON_RECLAIM avoids unnecessary damon_start() and
damon_stop() calls based on the 'enabled' parameter value.  And the
update of 'enabled' parameter value depends on the damon_start() and
damon_stop() call results.  Hence, once the kdamond has stopped by the
unintentional events, the user cannot restart the kdamond before the
system reboot.  For example, the issue can be reproduced via below
steps.

    # cd /sys/module/damon_reclaim/parameters
    #
    # # start DAMON_RECLAIM
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

Fixes: e035c280f6df ("mm/damon/reclaim: support online inputs update")
Cc: <stable@vger.kernel.org> # 5.19.x
Co-developed-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 63 ++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da147786583..46660c8d4d422 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -144,15 +144,6 @@ static unsigned long addr_unit __read_mostly = 1;
 static bool skip_anon __read_mostly;
 module_param(skip_anon, bool, 0600);
 
-/*
- * PID of the DAMON thread
- *
- * If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.
- * Else, -1.
- */
-static int kdamond_pid __read_mostly = -1;
-module_param(kdamond_pid, int, 0400);
-
 static struct damos_stat damon_reclaim_stat;
 DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
 		reclaim_tried_regions, reclaimed_regions, quota_exceeds);
@@ -288,12 +279,8 @@ static int damon_reclaim_turn(bool on)
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
 
 	err = damon_reclaim_apply_parameters();
 	if (err)
@@ -302,9 +289,6 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	kdamond_pid = damon_kdamond_pid(ctx);
-	if (kdamond_pid < 0)
-		return kdamond_pid;
 	return damon_call(ctx, &call_control);
 }
 
@@ -332,10 +316,16 @@ module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
 MODULE_PARM_DESC(addr_unit,
 	"Scale factor for DAMON_RECLAIM to ops address conversion (default: 1)");
 
+static bool damon_reclaim_enabled(void)
+{
+	if (!ctx)
+		return false;
+	return damon_is_running(ctx);
+}
+
 static int damon_reclaim_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
-	bool is_enabled = enabled;
 	bool enable;
 	int err;
 
@@ -343,7 +333,7 @@ static int damon_reclaim_enabled_store(const char *val,
 	if (err)
 		return err;
 
-	if (is_enabled == enable)
+	if (damon_reclaim_enabled() == enable)
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
@@ -359,15 +349,46 @@ static int damon_reclaim_enabled_store(const char *val,
 	return err;
 }
 
+static int damon_reclaim_enabled_load(char *buffer,
+		const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_reclaim_enabled() ? 'Y' : 'N');
+}
+
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_reclaim_enabled_store,
-	.get = param_get_bool,
+	.get = damon_reclaim_enabled_load,
 };
 
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_RECLAIM (default: disabled)");
 
+static int damon_reclaim_kdamond_pid_load(char *buffer,
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
+	.get = damon_reclaim_kdamond_pid_load,
+};
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_RECLAIM is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+module_param_cb(kdamond_pid, &kdamond_pid_param_ops, NULL, 0400);
+
 static int __init damon_reclaim_init(void)
 {
 	int err;
-- 
2.47.3

