Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAFBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7766B0119; Mon, 29 Jun 2026 10:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8AA6B011B; Mon, 29 Jun 2026 10:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3CFC6B011C; Mon, 29 Jun 2026 10:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD4916B0119
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:55:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 337821C0391
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:47 +0000 (UTC)
X-FDA: 84933249534.21.D3302D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8ECD118000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMHGHv8A;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744945;
	b=gFV/im4+uANcoRB4lnRaUtXIh5fyJniruWfE8gsuEhL1N40XS8s4SxmX4/CTvUaDNEGQmn
	S/9PZog+EIEHnqsN+ChNrdk3yc7/+eGYP+qJA0VBrRlfzp8ay0OHIgmUEfgVtLtkG5hpR4
	rLrgTxGOfCo6gU1hO3um9WeRb2l8nyo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVhN2I9i6QpLRkVKkW1yI5yzs7NG5PgDPEhiMNWAM8U=;
	b=vtlFQRlxVofNkbLphRamr7hGAKchm8KLt7f6eTIZiP8JzCPauly27zAfx2QcyMPWcuyLDk
	TS3gUqzo7IRbZ7eBtxpf1qJBbBWsyn8aCKkwCp0hd2QTrzfnsT8cWGWur0+b919agDcBuI
	fXwnehwsR06cbpamE3ZL/tFtPwdlRIo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMHGHv8A;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E088841A53;
	Mon, 29 Jun 2026 14:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D4A1F00A3E;
	Mon, 29 Jun 2026 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744944;
	bh=ZVhN2I9i6QpLRkVKkW1yI5yzs7NG5PgDPEhiMNWAM8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMHGHv8A1MYROF6vPuTDwZviR+le8pe4sCB4aR6QW3CKon05YWmPUiV78+bUpqs82
	 y+CzIcn7dROAVEmlPM/i9LOM8+tsOxlZBw5GvmZ3Ppr0WZPdnmXj6Se0woYaBx/iEB
	 D879T5sWVZrYXm1zjZdzi65tillLHPSq5D9McygwAwJv18yi689aZcSByhZhc/8iAF
	 sJSgJ+GLlytguYm38pnp/qcio4yLqY8Lc4a6gNgCo8J5MX1OeRfKhvFCxw6Md19gEG
	 2UmyIuQA7rHYd3BH0xhlN+I59pmMih1IhRAW6Xq5z4UyCeVA2GBmvMSOZxKapZ5UuV
	 CmJOZdoJb2d1Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philippe Laferriere <plafer@proton.me>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/5] mm/damon/stat: use secs_to_jiffies() instead of msecs_to_jiffies()
Date: Mon, 29 Jun 2026 07:55:33 -0700
Message-ID: <20260629145538.134832-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629145538.134832-1-sj@kernel.org>
References: <20260629145538.134832-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bsgdborm5g66uixcky778q8rnptom1d4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8ECD118000F
X-HE-Tag: 1782744945-421682
X-HE-Meta: U2FsdGVkX1+mc/8E2kXdVTigJTRxeEpEkhKQMsTXConV0obsZKEfvgGLg9D5BFV+a0pmg5VShkOoNS+Qoypjj2nD0gCiDjqHM4R+nmSsob06z3NL39DI6qOllEmTZOWhEgWbyQ+zIo96qx3bMwnzV53cS9ilInXrMpWBk+omxQZjTtUqFOKYFLQFSN3FShDUVBC2CxSrkd0EV/XKiYBwn+IsqVs+epbkNvZ02L55/oxIUhNq46Q9kPtJ/CohlFMVBnwShgkZ+KeIXCOnDiOg6ziCwV3GSPCm/KQNxnvy1BioFnQUmsDbzlzgt56axTwAIUQ2S535p3YYLsy3A8y2n/Pa4LIXppCtbyYx6MvsUuuSZ8mOB5UKSc9p+SN7DQVIn4T5Vmr+9NC1iP0Yl0Ws7D1kTXohmk1ovK4BBG/gpGmvXB77OgWFqNZpLXH99TgVWfasT0jy5CjCWNbh5thjM/wi3x6dJj9uCaRBty/PlAMlGQOBaF+iU91pPVhEA4bv+Kf8DRnF+Ec9rQoVffAyrwwjpPRzff08np4kmzFTVack1IQ6YsPvT9wzfFhH8pP8DZ1jnJnfF6doRO0exA82kk3znmM0WttnoUyTOCRC4jKrEVvh34895j5ITh+vy0ZqDgtg1n494Dmp6DKdg5mbXBtq+L2QmO451s12AhUB2A11oBIE8ElgX6Zu6o7VALgO1yd0p+iP4YPiMUxFJkwdam8TG+zreIq7TsfFhjMNP4OKErJcOlh0yxBaevAD497DUhYsHBTbSTkvJjmOCQDKUlzimbZy9sCKd9KHbDAnyhfqP7bvK/d5X/OegDoOWnpM6Y6MpwNfdXZs4g7hapXwsr3UcBFvm3jdNntEWF8tBjJNUZMuOulkBqVdP2/whnSx+HTdKWNROkoorIA67PCU8/21SbRygVz4bALcTbK0kOtTNh6IqLj9p6jtdjDu6YOk5Ws7oSprAneQG/YeT9D
 dzC5ix4Z
 BhZ7ewFEEJ5qIRsY1HM9sgSslHFIrdiZLSXrYYV2lzwTBv2DBXj6yW8WRaQEy4vFR76Cwd8XZZsItu9y+7E56lhdttOu2MJ8lwcIn6tMvyiLHT/rmLf5gTzrOnAMp2KsBCmUiMpEidnyPiGa4H7Na/fiYXu9PekaohsY84koHJMSlficrBSvPETTJdnXTwAL2WxnXvOAPfktOJKYoLAJ+VBIgdlG+U6QT7SZBSdb3ImIowrqRgOobGtmrWZnxjOMdS/bKZe4PvNL4M3dWKCN45fnGSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Philippe Laferriere <plafer@proton.me>

The conversion of a duration expressed in seconds reads as
msecs_to_jiffies(5 * MSEC_PER_SEC), which obscures the intent and
needlessly goes through milliseconds. Use the dedicated
secs_to_jiffies() helper, which expresses the 5-second refresh
interval directly. No functional change.

Found using Coccinelle (scripts/coccinelle/misc/secs_to_jiffies.cocci).

Signed-off-by: Philippe Laferriere <plafer@proton.me>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260615214113.122923-1-plafer@proton.me
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 0e14f5bb8f75d..b05b68f73e10d 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -138,7 +138,7 @@ static int damon_stat_damon_call_fn(void *data)
 
 	/* avoid unnecessarily frequent stat update */
 	if (time_before_eq(jiffies, damon_stat_last_refresh_jiffies +
-				msecs_to_jiffies(5 * MSEC_PER_SEC)))
+				secs_to_jiffies(5)))
 		return 0;
 	damon_stat_last_refresh_jiffies = jiffies;
 
-- 
2.47.3

