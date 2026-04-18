Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3B19F99C70
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 01:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9101F6B016D; Fri, 17 Apr 2026 21:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA7D6B0170; Fri, 17 Apr 2026 21:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEDC6B0171; Fri, 17 Apr 2026 21:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 482CF6B016D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:44:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E32713AC3D
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:44:47 +0000 (UTC)
X-FDA: 84669982614.01.72B948C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7505140008
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:44:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PL4dJZHW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776476685; a=rsa-sha256;
	cv=none;
	b=FpUygYDsKIoAPm8vjwFo6ne7DjsciByEirbps1eXrRCRUTgMILYCp4oGyUr9zXjoIS3HuA
	PNIDhYypkDeQEIhLZ2EA6cE3c0nWVWcu2sQKWuW1MOmuZNEjPhyPJBnlytzNRr4wuSyL9d
	mvZ6WEhOpxJZ4/RgoM6IxgVUbfNNeBc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PL4dJZHW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776476685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uz3J5gAns6CYsSv8nmWTlUOvxHeceZMbBLlJ7vxfzYg=;
	b=GvPvuuzIaiQju8L7HFQYuR0FxyvysfQpJaKsIXfatAsPy/1eT/qPtNDWlt5pL4h7aoNnoF
	eXmZ4ZCemCO98aZW48qT2vVrqzuJlvOUPl6M0HoeAyKQ8Pyeqvdqw8K4mytrgHgMmrFgzF
	pg04twJGMS0hfnOk5IF72TuWCpF9RmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00F126014B;
	Sat, 18 Apr 2026 01:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7476FC2BCB6;
	Sat, 18 Apr 2026 01:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776476684;
	bh=0iCEuf4xaBjkDEPNFCoYP43FOqLdY44ONYxZIt6nScU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL4dJZHWM60YVmlVra4uongRn4GagzsfxPKOjXLdLvyyG3mGaukrxjvWQ5UVJxvIu
	 VzJDf9sMIgcFQ3y52WO9r6Lz/gNkzYriurTXpHBAmx94AbZz3e4t7pO2uUlsxY3lsf
	 V/8SsnCdDKt0IPNw25W4C0eOVZ+oJaPACRpBv/h3hYWd3VjfGC5xTHjexXHI3VJSEX
	 gf5wQbYBgviS1wvPdmSsB4fs1Fg5UU+uwTGjR0A+mXuubiTU3O49GmK70tTwmGsWSM
	 eY4N/+4zmPI2x5qvUyAIe+e4DK8iNp5g3DmcA+Biv3NRG6sjZHVKGu2nmJT2GCPAym
	 bnuPRCV35G8Ew==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 3/3] mm/damon/stat: detect and use fresh enabled value
Date: Fri, 17 Apr 2026 18:44:37 -0700
Message-ID: <20260418014439.6353-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418014439.6353-1-sj@kernel.org>
References: <20260418014439.6353-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7505140008
X-Rspamd-Server: rspam12
X-Stat-Signature: ah1tuqcp9no9ykuab8ezuuyexff4obei
X-Rspam-User: 
X-HE-Tag: 1776476685-327473
X-HE-Meta: U2FsdGVkX1/wGuGPz7Np2Qf80IXUwXKd5RN8Zvruc9AvORAg5v/Vb+941a9NQRCD4N6dxUsTGOyMcVUY5EupQ0RHLoIoBeBwlR2Q0mgamnBp2U2VYjE/nz/EfHQn42FRsaIHyxdUQxBxx4zrubdzSQN1RJeP3l/tx94Sog7dSeKKebKjvVlya/IP/mC6jlsCetSMNO+CWVyooNnZy0YXLY1ILlMNvGJ/NRuNRpQmk3FdZfScV36fAwrxQaNzAu6SWbtdmiUpbPyb5WnfTOs09QHaxFFY1DajKaB51ivS9L2Pamtrhuet78UMhDjFX2YOvhYkQ7EMKJIrA7MfDfyZ8lzxL1h7yziwJocRAFJEy4MLoB3ngPc5mBxsbmVeLpBVwZDwo1iK1ppIeIVrYzWKZ+ZutycVKgLizfim7j4MtIqVO6bt/2DujX+6qAskpLVJZ0buCyZrG1+ex/VUYjFHpcaUSMgUzv/kvH7ymPhObz50RD5LyOLu8HSni0tr05YyIFRIS/ldoSlJKKdvzkXcF/VXaj6Ri/ZW1bIv72B0GHXxdi9s619+ZD5vOPQ+aUANbXgFMKxIS3rD6CUPgo9CERQx1jGfYpS0chj7KQ1UFaj9bttQQgvlK3QYlpQLlchnmW3ud73jSbsucKnTpM2fGpA/8LdRhLkSd5lRNHPF5JGiB6/i7zywEXNP8UogGDDgrWs7h9LOZKjTu1ig+MR8Oy63lrm1x7Dy9nkIYJwj/kr6BnenLZhYmTUuY0/p1hsxWXSEaPtf/PXFhfibBTDlNGwwpKLz973HVpnfcUG2CZrugVQihR9vXjOVQEYZri6QY6awoPGIKcHOeYkl6AQOh+Wvm3G43IcuelLy5/ZgtotwNV0mWC2GoFAKz4z+m4FjinxjEmAxXtHFN2LHxJHtOi9s1V9wv/eugZIuasKoqWCj9gfUcs7B+KE5Ajlj0GCVIvplprBQ/5sH/+zl0Lu
 nwJL0Jn6
 OiRN3H90pH0mDaF/79biA8Z3HWJ0JUFBSppXzVCX/4WE20CKaC5+gzlZMRRpuBwQInaUknKNFd5+Jd0gSX+J7PtfRwyNwITicVx9eoueKJCEMGPCBNQc5mJy8+Dk8pCGOHmFD91BU2oBBFrDM+e/k6FtFuJinuyB34Hbvn7uP2CLb3QZwYrgRikzXrkDLvij+HzHNnx07lNbBvddbQLVsWGppPdfDIgDlA4XtZalBAZv71sI=
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

