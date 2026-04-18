Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643ABF99C95
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 22:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB216B02EA; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE186B02EF; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6866B02ED; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41E786B02EC
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 18:28:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD49D59551
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:28:12 +0000 (UTC)
X-FDA: 84673116024.07.C3744BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 355CB160008
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:28:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgzeQhsg;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776551291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIZEeCECCM9Q4J4z+BRVGAtzkIdxDF8M2mtwGuAA3ls=;
	b=jdJOY2pBmXqY0/kFy3V46Rl6Jd1TdbKcYXGnjmRFGujF2Fx7tLr/QafEsRJ/q57e+dzy7O
	sMwhq3/mkmZpZxsJbmy+Ay0vcuGrqnI2vAznU6QNZO6Pag2EuvIMSgzFSsobL3dzXI7fpC
	MT7Wf/TGFRW9FTE9wZ9spj9tqtGOYtA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgzeQhsg;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776551291; a=rsa-sha256;
	cv=none;
	b=Czsrs2pfFS4p2TvocYtoQKRgysr/pFNx/+mTXZSiKe3Kgqg0B1CVdNYIE6Rsva1zt8OhWx
	ftt+Oh2zcJxgVV8JxbedfhGbEe8+t7Bc/r/LiKZnvbXXMCxsOdR6YRFH+GYX9EHm3V0pgt
	aNinmSRvtoAogOnVf6hSn/e+QeFY70k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5618844572;
	Sat, 18 Apr 2026 22:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F1CC2BCB4;
	Sat, 18 Apr 2026 22:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776551290;
	bh=rIOaDq/KHXQ6SzD1AFFL4LR91YKZhChannZeLdJ236k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgzeQhsgwKIuFRBvvHZolXJF/06P/JDgwT3aJST88LE7fcVv1eKQYKncqNr42bhml
	 BzOIp00zv3NQHb210ksIQY/TPGaI24eFwHZ32uV3AHjUk1wK/D5Lm24Z89IM1SRAs/
	 /Brp8h71+ItRBHnFgTikuflLqQq9EahrkX3n8lYWwKSsU5yJ25gNTkf/Y1zqD5Q4Tf
	 1YSk5fPdFKOgdIrD5GlvrEGzFaKS+goYxdhxKY7kryG0f6csSaFV8ikL7Uu1WTul9Z
	 6CDnHzdqd4FNNk2truBk0SZ51xS8k76kxVde4aA8WRPvAGqOCvRduXoeNr6CuyagBW
	 adXiCi1qWjpTQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 3/3] mm/damon/stat: detect and use fresh enabled value
Date: Sat, 18 Apr 2026 15:27:56 -0700
Message-ID: <20260418222758.39795-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418222758.39795-1-sj@kernel.org>
References: <20260418222758.39795-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 355CB160008
X-Stat-Signature: mjrzowzh4oy9ipq3fs8y43ya47s6jb69
X-Rspam-User: 
X-HE-Tag: 1776551291-903924
X-HE-Meta: U2FsdGVkX1+d2kz0EgLM4Jhcl8eQZ+8bLk/7XFTO2x/ym53KXmcXTXWyaOZQ5yrmNjql2H0jtuRWruRgPGmcgjcwvhEKawmEQBUJD2JXhskerLDGaPwsgQdjZAoyZ07htyip3qHwMeVWgofpm6CzJQIleJ10+NR21i07vO/ZrSjqSMPTaP+V+O21hIvcRJXjPlUgrBNkiIOAUTLkgqSH+A3nsdsaL1dCjALp7Dt+qFpbN8CG6ccVfUyAfIPg+TX1ItxZw4U40l2cOW5KPdl9uStWQ9fYKUftkp+IisTmeD5/d7Ah5JWqy6KCAfaSfPuJdbfLj7M4NYuQR0PbBqDPcDIDwOCUJL7FmgYzKv2QDmSOzC3L4HQmN3hWo7E+pABeC+Ln4QeQ/OI2BhiMNjRi+h9Pqi5UBEEmqBado+o+g4vhjGczTMkKvsVlS6YWp5+7nXGwzgJT3RQ+fxeqDPRqBCImoc7iNk9+35ApCNvBSqssaSrorBwsC5wfN9PLCG3P9WiBPfJ3v1BF85aHnu4lMapNYco+nncWPPCIa5X7XvxMDUiswfwLzM8TGl3aGObUzLAJnCHKMvZ7ev5nFw5wpPbjCEdmTYa3daq0EwjO1i4IOUXMT9br9YYvu+FHz8SFm1OdFK6UatxXkvFw2FDQ/GkndwRxHgVHhvLXaiXw6NHiPVb59U7tiACGKQtLICM3wlEPVeP2G38srB5Lt4QB+zf8h2zfOC5lHFmVi4yoZ1ii5tLwfD6G8ZrPBfpi2OkV6oPHPI+qvaU5KMnm24N4BZ+yXuSgNPFnNE88TTsgWSxLxszwHXGfjw7oiHS4Gm8/td1SAeWz3sOZshzEyZ50kNYm1Zt3EzMF1nYmnO+tYcYmyRWLdYdX9uENvMr7BB5wbniJz29HhNOo3lPTHCVbYauEfYuL+srAzUNFulBrkA9PM9/7V01rgVDYkYFNhc87M+KBkhZL2Bg4ZMFw0Kj
 xGnKee07
 DeBoXh02waNe2YG+4J8Kms6LFm74ntPsuZ0vBpPSAxj9CguLVE3S3c/kgofNqXg0aKXMIMg+/ux2BHaKlVRhFn2V89rJGVMgewAUTjuIiawPT/2oe1v64VKhyxxZeso8mEDqP9Ij1hplwXLziX74ZAlzdAoztdkOiR6ZPcaJFsungDm+asutHQliQUQyaJLmDN4FrLr+spQ0PxTEZCPmxRmEZvko3Vi5JgL36l4tWNIsIzhY=
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

