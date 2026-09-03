Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C20ABC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C5F6B00CB; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E146E6B00CC; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28D66B00D0; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA4F16B00CB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:03:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30452160108
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:45 +0000 (UTC)
X-FDA: 85170653610.24.0CA9F86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 95F6116000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nn7Rv6iv;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJD5ZHvDFQYZJci1lPr3K8KnFdwPjoFcLlwtAdnyK30=;
	b=mFFNaX9Jt4xLisAzpi/5DAYEWs7V5ioVs06vykVjOcGgQpleXHJsOLcDKFKJ5usxkku2uo
	eBioZsp3S6CBuvphUWvGsfw53lURhb9b67rfUnWrcLHs8kN5NGLGiCvqmoVwd2Owo9BFkk
	5am1vVyT9sA7M13V8qrYapyHb9g8m/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397423;
	b=ZG+EPZ7HgdUrnbEuBMnY1Bv+QB7PU0VuYpE9lYKr4TKhJqq14hMxBLb6ozEt+c4YW3OJ6A
	uTrDPCElo5SpYs47BqrfpWrI2qisUquERYReObWr8xL8H8RDretfrfwCXUw/GhhVihG87+
	FqYiDu84mwFrctobUcPJkuGtsJGZGpQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nn7Rv6iv;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A6E3600C8;
	Thu,  3 Sep 2026 01:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA3B1F00A3D;
	Thu,  3 Sep 2026 01:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397422;
	bh=HJD5ZHvDFQYZJci1lPr3K8KnFdwPjoFcLlwtAdnyK30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nn7Rv6ivC7Qq3N9Q2O4N+b11S4V40oQFQ1DMEUSOc/E3rrnbSK2u4VNh6NhBmDPbJ
	 10Ukb3Lr8fBfgKaWUKILYwqQM2xEtwj+SXDP67kxC8hzc3zbqD3/4VSn81ZZjJRLrZ
	 Cg8UWDcIFvnQvHzeDr3NRAxkhCur9GAkwDSf+jvuKvuI23a0nQ6M+4PCJDags8pRss
	 G2bG6mEdeZboujbyG+BAjbPvX/AlPm3V6ATtCQ0zhBLQ5lE/BJ6dT+D575csVvzD1w
	 JL2pDlVCrXMyWoHhdoCJCvucgWP4w0Q6jIhN/vArJy/0JN4Qult420Z7OgKRbdNpk8
	 jUH2cCJd61QaA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()
Date: Wed,  2 Sep 2026 18:03:31 -0700
Message-ID: <20260903010334.93622-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903010334.93622-1-sj@kernel.org>
References: <20260903010334.93622-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95F6116000E
X-Stat-Signature: 5zur689cnfrcuxwze3msc7jten5snn9n
X-HE-Tag: 1788397423-579260
X-HE-Meta: U2FsdGVkX18VC8eMpWwULFPZdZjoB9uIsbKBxG9DRC1eok9Jdyj+10G419rKSOmORb/N+iE3pym6IZDrAF57tEqyWNS16Xxt739UTu32QhANtpKSdv0TOf6RgrGuMmtr5S9RtsKxSKWznh2LNhPIaife6VnXEH4ABpDCUdjq8sbaOYBlavlBROBV6lAlLIXTbN47QOoDqSZSsYkwXPE5HzAZfPvRlPZDuJnwVzSuB/MHw5bs1Qm2yn2smlmNr9PKHipMgtE47p8JgEJRaceqkZ3cUxfllrVQgQEj6EdiwluD1L1vPUkUFKHZaDvluIiLql3J4BRXfqRIRgmWbbBAwdluJJSVLCKSpnStn41sMIvuH1qg1qFigUdBkKmX1+V9XGzc6QBZx9eswFdhr/35RIXxeVEaIFdHzdUZjEgpzqnLRTMhDIWtUuDegegYaLlwOL6FaumEojdIyO2hU5DUYJIWsFQvZhUXikDs/pWhATtf1fHGkMgBFQYelwrxiNknT9Kj/B2HJDUCDMXANQPtOEjhB1HMGI6k5zCiW9xB/ONuPQ9ClkzYwzCqHLmxC2/vzKoxjnpA5DhcN9JfjbYhUQ5vJCTxPy9xsH5y76Sa+PqkJ/kEBIv96CQT+r/VsogFFC3RlUdxSGSE54PKW9V9Rh71NUK5R5PUUCg0PWLs5dLcXpNOg7NVpbFUdruzxhUf4rxuVNN40XCM///kyA4ZhhHDuOdPBSy/wPpLIDVEAW27SZlbj413I02SToo3QiZgDjfCMyrHRdW46/HUkIlKOXxvDLMWjSx7WEO78ZispNeAvv1rxfOMwYglpQygxJD75gt7gehdXlFJ1akzPxON8i+KSVEX+RcTVbiMidf98Tl4j0WZ1XDFx0fXAMxo+BPrbs6d51QJ1UM9scS/nN9pPUZBrPXV9kDnoY+FpytOes6mmAyABGC1U/tW/JwYu6+l0benUtJzifQ8LT5NOdX
 bBSmRk61
 L5U25vsbeUmwFCjROpBSPvEQIzg62Yd8S6WDQ8d4Qmpakf7v/faHauKbPB/0X8YQ/FjAZSozYTvjGlEhMXGardZ/zfPhTZ5dL4oeAZh9zICFQ1O6QTZwUNvk/QHtOqM1mN+w10luyMK5ycBdYC/PPKM+yirNsyHzxt0oLF0ZWOCs+Kx8Cgh3G96EAo8p7DJVjMmdpvyU4CyM8TMJhtQxyaKhlI5bHffbROlcHEQvbDplxhdypjtrhzDineanucLhEdLyVAZEwHijpfFu9iMWlNk7R/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_ctx->call_controls_obsolete is used to disallow damon_call()
requests when the request cannot be served.  The field is unset and set
when the context execution is started and terminated, respectively.  The
intention is to allow damon_call() requests only while the context is
actively being executed.

damon_ctx constructor, damon_new_ctx() unsets the field, though.  As a
result, passing the damon_ctx parameter that never successfully
damon_start()-ed to damon_call() can indefinitely hang.  The callers
should ensure to avoid the case.  Such parameter validation is not
always simple.  Actually such bugs in DAMON_RECLAIM and DAMON_LRU_SORT
have been found and fixed [1].

Set the field in damon_new_ctx(), so that DAMON API callers can pass the
context parameter to damon_call() without the additional check.

[1] https://lore.kernel.org/20260803134646.16640-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 03407cf7f9646..56ec6f616fa9a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -933,6 +933,7 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
+	ctx->call_controls_obsolete = true;
 	prandom_seed_state(&ctx->rnd_state, get_random_u64());
 
 	return ctx;
@@ -2196,10 +2197,6 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  * synchronization.  The return value of the function will be saved in
  * &damon_call_control->return_code.
  *
- * Note that this function should be called only after damon_start() with the
- * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
- * wait.
- *
  * When this function is failed, the @ctx is guaranteed to be stopped.
  *
  * Return: 0 on success, negative error code otherwise.
-- 
2.47.3

