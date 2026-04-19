Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E508EA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 16:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFBE6B0323; Sun, 19 Apr 2026 12:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70036B0327; Sun, 19 Apr 2026 12:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2146B0325; Sun, 19 Apr 2026 12:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4CF6B0324
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 12:10:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 333D61B89A9
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 16:10:14 +0000 (UTC)
X-FDA: 84675792348.17.5001563
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 925C7160011
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 16:10:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cEQHdz9y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776615012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiZZ+Ylst+iOqdIt72/1ekfzK4vjUJXYCwasLVdVRRI=;
	b=PZCJ69qAVVJd+Y1Gdk1Nv/hnNOpnQkfFy8sWXMK0ur8uXRUkl+rjIWqtqr/ua35P31U3U9
	BYhodrmoavmKYs88FX8NgKgIx8TU7K0jlx6XIVqZCs10eY5YC0VGmF86zHEmucwGV4d/Jw
	O9I9zUCWvR5Rh4xlGs5wgK2cnx5cK54=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cEQHdz9y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776615012; a=rsa-sha256;
	cv=none;
	b=xl1Yd4WgnYVXVfXn+O6aD+XI219wnmKxLwPd8w5SoODVpLDqgCPureZ2DkQjq/mkdU6ddq
	dTxRLKUWOTS0ZJ3zWu2bcMD7LMI72/ue1Yrra17HC1KSjdFN1enVACaPH49pbjEihzT1WR
	GGioDqRQOmnJuEWJxFATJvsA91Tqfbw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A69060103;
	Sun, 19 Apr 2026 16:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68AEC2BCB5;
	Sun, 19 Apr 2026 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776615011;
	bh=xmi8JFCfIfNv/dt7D/wNwu1xStprbRBK6+QIpOf/ZP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEQHdz9yFHUkvlr7/KsFf6M+pbGECZ/iKEqFDDOAaHfqSaQNq+4Hyt+Cq7WoMAJwL
	 ecdqFZNh0PdBBYKo3Pov0FYSlnbMxTR1ZERGczd0aqvCwmv0t7X4muw/EZ+BG22KUe
	 2BPlXbDXteX7zaW+ekYM65OsYvYQEiFDc734oMoQwuf6Y7VCqZEjkBCqU3/YCcylEj
	 Fw+uihOxv5cTkx1/hVZVLcPiId0cKr0C8+Cpd3SUOZ2XMt30I3UwPlpNgNHCWABeGX
	 dE9jjeCg+5YjzPxVFWOcf3Gw6r11VMd31oAF6XsbrrRDk8S+NDcmSAhsi/2J+p9L+a
	 2Nohd9dDD9LZg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v3 1/3] mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
Date: Sun, 19 Apr 2026 09:10:00 -0700
Message-ID: <20260419161003.79176-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260419161003.79176-1-sj@kernel.org>
References: <20260419161003.79176-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 925C7160011
X-Stat-Signature: u85ig7w8ab1ortwx6r3ctdqbynw993cn
X-Rspam-User: 
X-HE-Tag: 1776615012-572829
X-HE-Meta: U2FsdGVkX19vUVN33/+Wohd+cwGiGP5jtml8YG1tu3TRXGnRVktfoB4I58l/hjx7yjOOXl4VC1IFYMPDrbQqOYeDbujVHX1Ak6zGkmDHzV2N9Z1rby0lWupth14Np5y/T74lIw63OhIP258B1LUsj1vDAxIcuJ/gnLpazRaQo4VutJ4Ahm5C1YdMSCXWi9Ded/QaZJXQbnOJmY47aWQEJawzSTHpecvlQI1GGujNk5Ro8wyvjddtqBCYjJWxQxH612bseLwOybNS0AtyIn5khvnaZmffsyhVM2onHAbjA2H6eHHxO4pvy1qGgMePdj7wlUYXUKoUIGo72cDfzy4/4fej8x+h/zGV8azGp+9ekAmOETd2q545224JEsZ4cO8U9tJOOYGAaK0nZsiONkDtJsHbqIkB1OKuKODtVKhY4W/w1ediiNJVSViRi1SKegwREFFCB24s259Zz453i4wL+F/7G06EndAsT0/B/udurRKCmI6YnlYVcX+EB/tTm04GeV1Cngut9ujb6ZLvLFdrpzLKJ24T6qEitPJXmGFLfMu2JmXdXlj9YAs6Uc+5e/VPCAn5zNxqXf8gdX8YWNEsv8gr4eiDYBjah+RYEcbhb7RX7d9LQ2O2PjtcrF5J7N3wA72WmTzMQfdMLuImaAKpt3sQ32KB2xJ+QLIFN7l/oEh+ZeAwblW8FNY8/UXLWjOmGh2zNqkBHQ4pgv/pZB6euvieEeBYGpWrMg0pqs+YuaQOdwVgR1Bb7m/sm9LxynNRC4gk2qIoobeChb12eJDppJEfLgDov6jmP5iUAIJ0fG0jK8CdSSDya61NkrGRKCnCxj4BO9gGXwUKu+lbTU5OVGON6bO51Nnr7RotzTY4I8Fh448PUUTYavLznUjlHA4N60kM4INlEPwRKd9Z6jhifdQOxFbtRK3sK1HEkdO86+2qpn5EHku+H2/56LWoaxW0PaH2GR1oPHS9VsLjtMt
 2zed90Yx
 vFXetJk84TvWbprZyHhre2X0W17GCXRVXN9OUnAnDzh8jhKhXm0Qe/h2c4Wq35B91Qi8RXLX2Qaa+Pexwkp2PVa4QuThEYgAMYsv4BLF5Avr2OlT66ki6+Ft2sDfVn851WHlwaitq1GYFiuexj/+MpEHUkeSb0srKiPnig6zVjsklguPKreFD7ic573rFW1yXp57toiaOUTQEVILrEfntE/5NQA6lJIZdeSCJu8PWUbv/ni2COmHR5jxQfGDT+aWB+5H38zArpRiG+mYUXgq6LF6ToKvn9a6c7Ty00csO20P7k6Q=
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

