Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDCDAF99C95
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 22:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7540A6B02EC; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704006B02EA; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557AA6B02EE; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9B16B02EA
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D15B31405D2
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:28:12 +0000 (UTC)
X-FDA: 84673116024.10.9A1D761
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 105EC180006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:28:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RgJulB/Q";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776551291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiZZ+Ylst+iOqdIt72/1ekfzK4vjUJXYCwasLVdVRRI=;
	b=YmmHdxmofVm2XQ2yMJfEc1E0bll0lPhY7Wb3QZax5XsHlLNxBo6WkhDs3ACyE1EnzqDJQk
	AwyqlqB/wQFyvh/Au8hoIK7r809nI6MoVHE49M5cDHiEFog/TyoyvmmXLdDmjJ20GBiZPy
	QGRBfpu3MBrNzWQfLJJtNW+yJ6qhqU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776551291; a=rsa-sha256;
	cv=none;
	b=F2tx69PrhTQV6Kuqcn3nVtacAxk2Sy0T5G6cZ35A5TpK5OJcA4gzuUCwlHdpMxwDSwQfVN
	3fEyZP0292++Pe9L9t0h8+WlGxK2aU777xrwBNNPFMaGx+CHn65qQ94IGCpzi4eqZel4Eb
	mwC0sog45eyM1Rfvq8FAzZcT0IrPNiQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RgJulB/Q";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 924EA4362C;
	Sat, 18 Apr 2026 22:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C27C2BCB4;
	Sat, 18 Apr 2026 22:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776551289;
	bh=xmi8JFCfIfNv/dt7D/wNwu1xStprbRBK6+QIpOf/ZP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgJulB/QlVPZkbcLBOsOt8Gm/b/BJl4fPldMonDkzGJyPtRLCjznipVXYgjA7rafp
	 WTAh25UctVfgM56yDu3RseKl5rv3IUHbZdIfOf9zlcKqJNU3VklpplXBkeE2XkZhjR
	 13fgU/opF9piYEEAgfAaWcPis4U1r8oJKX8uclVXa4ttFUkT1TqD5KHJQ/UG9wRcnC
	 Iw+BAdj8P/y7idK1zFeJLz1TTGKz5ZjJ3XaSVlxtsCUNm0346BlJIuB4Af3h3XllgZ
	 U52mH2rZZLQ7bKVdTU8fJfELQSnXR2b0MAeUkj3IBaQYyHy0EQppORbmzLu+ywYoUy
	 NiDJS87qrW8nQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH v2.1 1/3] mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
Date: Sat, 18 Apr 2026 15:27:54 -0700
Message-ID: <20260418222758.39795-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418222758.39795-1-sj@kernel.org>
References: <20260418222758.39795-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u5a9irc1zzta3wcnnfnrc73inu865a8m
X-Rspam-User: 
X-Rspamd-Queue-Id: 105EC180006
X-Rspamd-Server: rspam05
X-HE-Tag: 1776551290-377161
X-HE-Meta: U2FsdGVkX1/TiGBQ420Ff3Rurzc9DZbQVkWwyjhad7U9Uhzat+Eay1UfxvnruaCpS8KboFgW3Gax/8zcnSx79LmGdAZZZp1vP8KI5bC/FzFOvAKv3aEULjYFaHLVRRYqoDqSK7ZuG4Q2iGY5HDAebbh8C+8FCnkVSBaWCdxjxTNznPwq90EsDFLWSg9WOLhBcCZzkMxMlBaqbfhIAK/DHIbF07OglS2S91S6XmQKrxH1o6UWnbjaUuoIdpmPA8CryWUBfLaqBlZsK4NtgR4jMdnzGUDypceoT/iaL5rxSiMAnwX05tI7dOoz0kpgGZMZtwshwdnXeaOWofv1NjgvCneTjsJIGXExliK4DSvw7OQh4KVm+OZKSzr5lPKN46AGpjHUt+a2og5RqfH3b0O0/VpHpLDhWPKjLVSdCY5eXA9JZNhSZ1iEoSJtyrnwyR9ZK46Eo1EuHU/ka26m5Hzy/peyUPiRlzwySjnDoVHy5nNDiCzpmloFwVfUrMNuOm1aGy/0yRX++ZCJX71x47dRenL9gZj2PKsLMIYF2hJG9JYqhpY1nFzwH0R0BNBX7pBIIKUbhlGEIXwIG0RzDOafbOM8LVz2VHRFWR+s/LD8a1LX5qLQ731pMlh32WykUvkVmpbmXquvDhJl6KmuE6La2eizROGDAtwn9cQChawAbQjPFLFueZTXSEjZI0MH/P8W1pX4pttLzYmo+nEawNqWmtJCU/aT0erkLX51bIVxXxWXIhGK1qkz8/up2uB3VXudjJbcu3iV46znm3vNkrDcR39phoNs921OGe3G2h7dlPOxPo/9Qcl4Ireg99tdbxpaemtAtKtRzWYUARzlWIzfY0+l3lqdLY4LXBW2cGZFDqvdxvECUfEuOOQoNmarCOz2BC9RdhEUcN88h5ggKAw3PHnhORW1Y1u1lRqKvZihIXTJG7GTCU/zov65IY1LLOhYEzGW3yNNWmZ41l3YTmi
 0seWE4ft
 ucsxW2z7mrxnY/rXX9nJBYPKeTqnXcj2aUTpceSqLNjDtroTjDYjz37kGmftm0M5EQxsGfyIjCp0hJtM8pOXEPpyb5BciWvEyY/DWyhFCii1Bg6fcDZI2Y+oCOqoB+6iz8qE3dXBXIXIkaD13U/Qb+t0kdzMmWw8cKccHWb3YnaZE6bAMZs13VnuMdFTl6U9SZG0OvDrEkJ6H8/hfHLaCccBs+kAScsfjMsK97fCb418poYzXPfiGVob44ZdCnNuLOr1fjqQEzmLQh5DKtWqy6XO5pgmLBuEetmdbmpserXNGN+s=
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
 mm/damon/reclaim.c | 85 ++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 30 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da147786583..fe7fce26cf6ce 100644
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
 
@@ -332,42 +316,83 @@ module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
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
-	bool enable;
 	int err;
 
-	err = kstrtobool(val, &enable);
+	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (is_enabled == enable)
+	if (damon_reclaim_enabled() == enabled)
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
 	if (!damon_initialized())
-		goto set_param_out;
+		return 0;
 
-	err = damon_reclaim_turn(enable);
-	if (err)
-		return err;
+	return damon_reclaim_turn(enabled);
+}
 
-set_param_out:
-	enabled = enable;
-	return err;
+static int damon_reclaim_enabled_load(char *buffer,
+		const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_reclaim_enabled() ? 'Y' : 'N');
 }
 
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_reclaim_enabled_store,
-	.get = param_get_bool,
+	.get = damon_reclaim_enabled_load,
 };
 
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_RECLAIM (default: disabled)");
 
+static int damon_reclaim_kdamond_pid_store(const char *val,
+		const struct kernel_param *kp)
+{
+	/*
+	 * kdamond_pid is read-only, but kernel command line could write it.
+	 * Do nothing here.
+	 */
+	return 0;
+}
+
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
+	.set = damon_reclaim_kdamond_pid_store,
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

