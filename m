Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458BCCD8C9D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8820E6B0092; Mon,  8 Jun 2026 20:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85EA96B0093; Mon,  8 Jun 2026 20:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795DE6B0095; Mon,  8 Jun 2026 20:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9506B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:54:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39A361C21A5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:54:48 +0000 (UTC)
X-FDA: 84858554256.03.8274265
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ACDDE1C0009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:54:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T0IlKExM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780966486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Jo6v5LwZ9ZiVMHZVW1HuuvAQB6tY4B2I58Ij6xQSkaM=;
	b=7xEAnkXmtsaiF+YBxjHjKuT3kwjc4IhC3nxaZ9URABq+Wo0lCUUqYXyzcEHzc675hskvRQ
	8CJ+HICx6p+39/X2yaULngGt+i8S0tuXzeneB3usphd4esbGNIwDD1l5Y9226HlrPhG00c
	aJsO863vQgXt+J4Okap4lIN9lu0AuoQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T0IlKExM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780966486;
	b=fCWqDST2VPEPaNpgLVIPMDsmOEWP8YDiS//ZwHDcaNSpHE5j1ACh5rdcZ/WSptvs5SSq/z
	zAS4j2fUKRhW3YRHtfzGtTyGaxS5nbLvNGfZ6zEg9sasAgf6KVRjeQpU/12NtnDeTc1Kc1
	0EPzEgMOzb9sG0LXSha9WZsJ50RzNFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1339C601E1;
	Tue,  9 Jun 2026 00:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814E71F00899;
	Tue,  9 Jun 2026 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780966485;
	bh=Jo6v5LwZ9ZiVMHZVW1HuuvAQB6tY4B2I58Ij6xQSkaM=;
	h=From:To:Cc:Subject:Date;
	b=T0IlKExMhP67Am9Ab1dPAxhi38p2Vua+v4TKu3QPQfHGzA8IHzar1Y5jk2fDSmNtM
	 PvUclIhidEI+NxyHipSY/tYmzKtQGSKF+tzkba2pJiMUuS3eMGgXUmOoOEft3SbcnC
	 6PohtZry+ysT3rdCbEkCM6yrvWoQmnBcgnDaqV5zAyLjuiROanwrZ0mQqVQRtY5aEt
	 lohzX6dcvd4nS63QrGw5NSGpNxRIaAhy71vASE2ytg2dzMY4R7wze4bPcmN9B7HvYV
	 Ibvym0crZS2p+N8yfedo7ztg1rafTOGRRWI03QRSu+hrODc96ovoRj0PttrXOcM26M
	 SarjuB4DjXbyQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] samples/damon/mtier: handle damon_start() failure
Date: Mon,  8 Jun 2026 17:54:41 -0700
Message-ID: <20260609005443.2122-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ACDDE1C0009
X-Stat-Signature: f9ynipfnkmm4y1wh8ddg51hmrmop4agd
X-Rspam-User: 
X-HE-Tag: 1780966486-570688
X-HE-Meta: U2FsdGVkX1/3zuuHtW61QnnG1GDdONn7Mu9a0gU9F29ydS5HVSlb/R1Ci3Q9SGajfIOfwwxA6zPKTi4xNUPMOLZcFwv2NPr5fmSj2T10YpPyEdMs+pDQBLleRxzz1JFU8cr2Jvj3VaYOnNx0KpF6121qMhv9Jxm/prSXV1d1XpjHP0dRK9qkuuGrXC9FR7fNJef3FdyOE78iU7xQROWKys76+ocfx/JUmqezpJqSzcmRfoQT3ASA9r7mPmnEwagNXIpx5HbP8j9zewVL+QEPN8qUfyeMF1s34KZ3QD72kajU7NsWftDBcYHzhjlYDbQyfko9qCOQ/06/sYEspf43O4TJLW69LLSgJ1nUupGqS7yLm1sS+X3tXoMJTYEiHhzdWWH2g3k78qJeXCvaXqw5kSal3hCfGQq32lxzUl/tjXWSYXbicvQKoz7Rl5fAMRXOsY7m3zfic5C0gNPU3TYqXfzxDeVcRwbeVm3Il8UvxvIqda1zTjrTftR85Ae186e2bI58mzb9EqkiW2p4HKyeWH2tS9NiR+YQhNe3B2g7aXyqaXfSzldfdrBxvqsw+x45zmgPUMnNRl/dtH6Gml03bufiQIaTAReH0fkQ9a+uW+wmkPY1qgBH0WowNdujU3XvFhK/gvZPmfM4wxenWiewmoEryc0X1JmUqmi6xTQWooJCbmVHk4rhdQSUjwSbr+cVHQintWv/g9ai0gPzq0V8S2UuQ7zCNiVFmaTyJUlRhmVOo9XXb0IUBUrwpCP8PcFy+uLLfbQGe/YrWq9MkNvwg+fSlPCgZWB0nvKEpPjIVarHT6tynn0evcHvOvFQsyInCgm7igYEsvuJS3AYi1keVfQPGID4yiNrTWMOcrTdoFNpvx1KMU5B4k21maI46Q/MEcZIwg3IvNz5/2gjbE+6WIQGeOZ4SYJ25sRww/B2Vu4UyI78RmTboCYpkUuMabkFUANZe9Neg5UZ6OarMZA
 BrUGYEIL
 RDbK+jMVqMNlkMgvbc5Drp41Lk4rE1g1Mu1y8eg+WL1816xtAxmH4bGaj+gfZIDsFDSfV0C+yAxQwAh6ex/nFtQNju1zSnkbEtJm76nbUR+U0u/UQrDfPY50J+kDs7hBn5/hIAbwQMR0CgoJT6gOQ/tzsVVrgCxoHhc8KLCLuCT5nhmVPLETuBIwz0hk/4ItCfUl8sR85yYAPSvazgcsBsX9vcypY9TesaYF1hCPKGxt4Nm87X3qeunh/nZwtKIiD1AgqZ8aFkhiSoPVSgl45/PROgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier_start() callers assume it will clean up resources
when it fails.  And the function does the cleanup for context buildup
failures.  However, it is not doing the cleanup for damon_start()
failure.

As a result, when damon_start() fails, it could leak the memory for
DAMON context.  Also, if damon_start() fails for only the second
context, the first context will indefinitely run, and avoid starting
other DAMON contexts since it is running in the exclusive mode.  Stop
possibly started DAMON context and free the contexts in case of the
failure to fix the issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo Y | sudo tee /sys/module/damon_sample_mtier/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the second
command fails the damon_start() call because the new DAMON instance
cannot exclusively run.  And without this fix, by repeating the second
and the third commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260608112455.274231F00893@smtp.kernel.org

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index eb1143de8df17..66b591f2180fa 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -174,6 +174,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 static int damon_sample_mtier_start(void)
 {
 	struct damon_ctx *ctx;
+	int err;
 
 	ctx = damon_sample_mtier_build_ctx(true);
 	if (!ctx)
@@ -185,7 +186,15 @@ static int damon_sample_mtier_start(void)
 		return -ENOMEM;
 	}
 	ctxs[1] = ctx;
-	return damon_start(ctxs, 2, true);
+	err = damon_start(ctxs, 2, true);
+	if (!err)
+		return 0;
+
+	if (damon_is_running(ctxs[0]))
+		damon_stop(ctxs, 1);
+	damon_destroy_ctx(ctxs[0]);
+	damon_destroy_ctx(ctxs[1]);
+	return err;
 }
 
 static void damon_sample_mtier_stop(void)

base-commit: 947b8ee1c1735e548454493da9999a2647621bb0
-- 
2.47.3

