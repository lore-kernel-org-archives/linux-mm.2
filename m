Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF879F8D754
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D1A6B008C; Thu, 16 Apr 2026 10:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE046B0092; Thu, 16 Apr 2026 10:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B606B0093; Thu, 16 Apr 2026 10:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 418C76B008C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:39:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDBFEC2A0F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:39:10 +0000 (UTC)
X-FDA: 84664676460.19.29FC50F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60B30A0006
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:39:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/nNbhC2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776350349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=x157wvB12bwOB7//C8zEXuk58Z95Q3/BpMPFdv0o9fE=;
	b=sm4gZmyN7ojAApnb7vPPjPvQ9dT7dFJunzOf/1J4M6vfb6rsAdWolpXbc2MpDeAJlqQXrX
	wckOmCj9BoCFq8Fmm/3m2wlh7gG1burisdKlqtx9SVv09/eMhjTCry7G2N9Wr2ov4WeYsC
	IwOkOuHjIAw9slIzpvVmauQKFebPVkU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/nNbhC2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776350349; a=rsa-sha256;
	cv=none;
	b=YhC8MvVp9XHxLzQL09VXKLhHGT7qqg+ekMZ1NjpFfjmBxv8j8Ztmcg7yn1e9vw8FJeYYjd
	KIOn8M0cfYa1MFPzIGq+PqqNYKQ8AyH62jUI6q7Mm3z0Qq2Qhj+prHh/fO5FmK/jABCsgv
	gHyt0WIqZhiClkucOI2itxKx9Pai8kw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D736160126;
	Thu, 16 Apr 2026 14:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5860EC2BCAF;
	Thu, 16 Apr 2026 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776350348;
	bh=ISIO6kAu45FSQY075H+uIGwTqhCGHuJ5pC1ocL3AuWs=;
	h=From:To:Cc:Subject:Date:From;
	b=X/nNbhC2pauFxgiFhETPbQlHRyiGdJzADwxmhq8c2pr/CCkvFtHICNfHc3lv6Th1J
	 4amfaFMuG+1ku42xVSvSjeQA/tKSCspS8C1ufIgzTKH5shodUpzpCh+C9WYwCdgza3
	 wFGF7NAHcVKBQRi4yMnQ72oN+UvEv6yC9kx/mCEhbS0xGinuxi60hAQXKr4dvLz9GP
	 Xeivm9TDGQjEUzYdZ1Q7LWTMllJgOYzoc84oZ1fXppqFV2jhkY5dWfNESSN9NnnNY7
	 a+j+t1rbkjiTYcIN8XhlFy2MryfsojSSzjRCv/erZ/zlhJYcGz9UcrGE5VrdUfT1zR
	 FXQzChbmuyGxA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/stat: detect and use fresh enabled status
Date: Thu, 16 Apr 2026 07:38:55 -0700
Message-ID: <20260416143857.76146-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 60B30A0006
X-Stat-Signature: nucy8c1fm4xhzq3dk9bnk1h16sn3uf5p
X-Rspam-User: 
X-HE-Tag: 1776350349-893293
X-HE-Meta: U2FsdGVkX1/NdPURG9iQ1J3rjKXdarMeziUFxSe1lGSIg7ub5rPLY8oVbkU5gskU8P4ipA2sz7xP2Q6XfhYDvcrBnxv51e8jZmdJXf58qxxgdbLuTmfkwa/gTqHQqVtht/9ztfw2rLvht0TZadHN+Q5WjqTRqCc8VPa28x8sel8IzGa3q4pFlWA7+sgs43s1IF4XMTYfH7IlnuBG/9uefXY+ebOyboEof/doGf0o/jsuc9bCeQV8Fl1XOmikfSamtunY1qPWvgyRNZoGWdCUyaRxxw7K03hkqH/XNNMAdz9ZwXca9l/y0Dp/m6lsBHyWDuThVzACkRmHDaCCtkbTFkAvsXRFfLUe8vLtc0LgdDJX3klSInQZSDDEZAwwks8YhpTeepDu5GVfXB/8XOr6UCjbVzOgkPwUFLeo1aitTl8OfxcqqX/ykptSG1vYqA6fm2m8eZvXAUCk2LVIddmWWKhH52n8zdRKYxv5bF0i6XaqPr5n+6HQ5UcO+yLLETkYwkXy8RDFdykJ7m+3D2foSg0m0n07gI79JLl+i6c/LILaLOr/iR/su3K9f83jx+A5p7ZeVXBpW2u7/2ZgfrEH69p0njYnzNGGmL8CFgLcAN9jhAPocZ4fVC02wv4ib92SXmCqYaO078xgl0blVXpeqI0JBWGJka5+3Q8v+C3BmW5RD/Yaw0Y1EgOMDbjs1HrTDc+t50vE8UTQl649kyXtgPWQTQB2Oyp6zxqIpW7E/qBMeNV+DRleW1ztvSNwvxnsdqaz7ISkRgCNlu+ofjCcKnNDlvR3D/WxPCKTQZeNpx1J9dr74nb9liS0NiFf5U32j7zoFkdOWuGnSLKEXkO/lyQ4bSS8iGno29rnvTcGCKCwDm2RIp48J/IeU+5nCn18dOqIdLCAjJNAowKrjqBllbVJY4mbLQ4WRV1W8CpRU0c6kAf+m3bwRTN6NcJ3U1xksygfnhFZjdFwd8YXJjD
 dxuPENyg
 UnZcFFnqsBq/NlbumOSSVUUpL2bYNMsI3l50fGXq1PVVhx+rgpFwbiaVrPktcrEYwGGDZsxTxoQ6f5NMdjwkjxWy+VHa5Jhh2GZZlNft4niaPVFYD3cETiSdeelKQG0J1JU88MzOXhMgLqM6fS3/4cvA2MOIR+UPP0AHDyJes1ZZMTNOXxCB5y5tFZPkViYr3ypOMR6ZZXUUp40nSn1YJCal0pSKKEsoo+Kbm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT assumes the kdamond will keep running once damon_stat_start()
succeeds, until it calls damon_stop() to stop it.  If the
regions_score_histogram allocation in kdamond_fn() is tried after
damon_stat_start() returns, however, and if the allocation fails, the
kdamond can stop before DAMON_STAT calls damon_stop().  In this case,
users will show the 'enabled' parameter value as 'true', while it is not
working.  This could make users confused.

The user impact should be mild, though.  First of all, the issue may
happen only quite rarely.  The allocation failure is arguably too small
to fail (100 unsigned long objects) in common setups.  The time window
for the race is also quite small.  Even if the race and the allocation
failure happen, users could find the fact that the kdamond is stopped
using 'ps' like commands.  By writing 'N' and 'Y' to the 'enabled'
parameter sequentially, the user can also easily restart DAMON_STAT.

That said, the bug is a bug that needs to be fixed.  Instead of managing
the complicated state in the variable, detect and use the real kdamond
running status when the user reads the parameter, via the parameter read
callback.  This will allow users to always read the correct 'enabled'
value.

Note that the 'enabled' variable is no longer the argument for the
'enabled' parameter.  But it is still used for two use case.  For
keeping the config/boot time user-set parameter value.  And for keeping
the user request to compare against the current state, to see if the
damon_start() or damon_stop() call are really needed.

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

base-commit: d8bf71b1ab52974349a5d58e40749f04daa339dc
-- 
2.47.3

