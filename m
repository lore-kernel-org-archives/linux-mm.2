Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7895C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBAD6B00A2; Tue, 14 Jul 2026 09:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68DAA6B00A5; Tue, 14 Jul 2026 09:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C556B00A6; Tue, 14 Jul 2026 09:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26F2A6B00A2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:52:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93A3C403F0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:44 +0000 (UTC)
X-FDA: 84987522648.22.A2235F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 09CF520006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d0KLQDgD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037163;
	b=jj9AGZURGTuu8AIgZUydZ5SLxMJunRiqGgRoHuDCwAUXHhc/0HA3nKi/f8SiR+qNeX8crY
	ryeuxmTs3vfA/0F6IQndk3C+9R1RGdlO3/rxR8gi3c8RcueV4tVUvy1c2634qP6y6myMgQ
	oCM1paWJHP/yaaHDxAXh3NxlAu0znQ0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d0KLQDgD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhmDCI+ot7IL3VsT3pLzYBJmbk4njLZd345nGTc/fNs=;
	b=GoE9rIhz3xPPC0VqIIwOtSMyPwUpFASLtcfqWKhaU402A2t3KyDcyCYMgPXrxzpiEQEZl/
	qz4NHoS6ngi1s0zjp0aTdiAzOelqwvuhu0fcYa3M2G9avndGYtt+lg3AZ4jOtZYkhUgoyC
	sThY0r8UaPcyDKW90OCZ0uu3RCvYvqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A627561377;
	Tue, 14 Jul 2026 13:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374B31F00A3F;
	Tue, 14 Jul 2026 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037162;
	bh=hhmDCI+ot7IL3VsT3pLzYBJmbk4njLZd345nGTc/fNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0KLQDgDpLeerstVYPZQr9U6UvUxQHOZeA3gGp96M0sHUHYIQvTLsOQu8j9ZkZjOD
	 Lovnt/dNpVbutyl7O51WD5VJYBEOgKrYFJjtMEoncELZe33ehRqbD+sSZiWgKYb4m2
	 wP5jZhnfLWN9umI+1wMHvD58d0IzCHJfg9r+nPLg2wTwZrhkecb7VwubPiq22IzErr
	 YAjwXNS1SmHclM456MNnuIKt8whSfSxja5+wfsMKqTzdQ6vqfb+pxXQ7/MXaNzlIOT
	 MUZUt7TAAI3Yos/2cya6zodYFjT0hf0O8Hr8wPKBDsmv9Q6RL6Q1YygDFB+cld3LSr
	 XAASuxfuqLPhg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] mm/damon/sysfs: read ops_id only once
Date: Tue, 14 Jul 2026 06:52:33 -0700
Message-ID: <20260714135236.92699-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714135236.92699-1-sj@kernel.org>
References: <20260714135236.92699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 09CF520006
X-Rspam-User: 
X-Stat-Signature: c8gesxc49mfqauf889poo19ftgjno34h
X-Rspamd-Server: rspam03
X-HE-Tag: 1784037162-468070
X-HE-Meta: U2FsdGVkX1/I94GqqnG08GLZChhAQTwK0bac1rLvKY4kY+lp8jWhc3Nkyc5iEMpnDQ7+VpSaaFFPDPCfaeNE4sWHePPDdBfrcx7N+SeRrTyy4J0Q1eugE9V+U5mktE4O0GzBnFh9++KRvg+ghNcVEzpv2yZE3DwsD4M73vCcAFDZfo28fWGdgmYcNBsqYzGp+xrrNeSRu8ww9AbZhREhEexyNbB+33wkCQ0pdKn2yzwiTyX50TJCCJ5ETntcwXbpEa+JwthIfR9l2mSB3CqqBtcqf+CIoVMLMFo9FLyEn3wlzIz4RRlQ6f2mniPc8m6YIYx6mBue893u8YC5t7uF94vwRt7fXKiI/0Lzq956FQG/HhBPO56BJgvol+I9cadeBgWG0VmiRkA1ER1A8cdSiiWmZir5cRIL7CjiYmF1oyUs+Na0xJ7Ez6qZrPKu7SlWSf8W9GVdJ/LV6x80ZuQygGhxnNAn4gH6Ghofj1k3ssxujNAuDn0qUeVmRwbHcbIMlRm5OhCtON+eSXy2oLtg1HzyFSOm5DVCByemtDg7xxSGMYC2U5r6Hh/EQWzjDRDrk2YEPl905pbGDJRwM+8d3Ji+YIW1M03vAry0kZc5acafNWYTE1EbJGd0g2BL/DvZrOfjBaKAP2Fsoaxq76KvxahA5sZZDdsgm5E/jsy3WlfyI0uxlR4iiEkp3WIJ6O7wADewr/Gxa4A0EncNTT9l748N/twWkP9TnlDz0sjm2HbmMzx+tgVJ5v0VagyWZjMR3sBiMFJ3sXywWoqfvWKAN3ztRLIRZbft+3RB94cBzzazlhWC6v/8SAdOx0kZeENxcLLVmMpeLXTVzOe0gIwcpZBoVG1XHIIm07DvTiM+h1y00TsCrjxpeDSbj1k4Rk9xiUod0VFCOMT3SoS1m4B6c+T4c56vsZtGMBVFOKMxApPfaAaU+k8i/W4tA/FUQ8dOeyC0C22ImbNib7Yw0dF
 9vnmhDuG
 TkP7HK+J+ZLK8HadJfH5RPL2uvk1r0cc9mf6T/xVwnpWaYPcOJ+toR8qZgmHJtpO4il6Gd2Kzn7Nxs3jER+ZKlsSWQXcIOYBLpj0NqlAqWNEaQYGRGhMYCIQiFZyr4/hAoZik+FvDOrzb80CXzVuQFKWCPJmP98HnrJmXyI+MvtEFWzBg73wqDmKo8pczpy2ZT9hca8vzJGh0W2eMlyI/MgK0Rqc8Jqqd141nAL8OWUf8wdeirJweJ1W9huq+/IV+vVRo5lCsFaewKI5oUmditNnmmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_apply_inputs() reads ops_id twice.  It could race with
ops_id_store().  As a result, the min_region_sz could wrongly be set up.
Read it once.

The user impact is trivial.  Sane users ain't update the parameter in
parallel.  Even if it happens, only monitoring itself runs differently
than expected.  No critical consequences like kernel panic or memory
corruption happen.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260703172417.95426-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b5fe036f78015..60a1a9e4ada34 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2094,14 +2094,16 @@ static inline bool damon_sysfs_kdamond_running(
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		struct damon_sysfs_context *sys_ctx)
 {
+	enum damon_ops_id ops_id;
 	int err;
 
-	err = damon_select_ops(ctx, sys_ctx->ops_id);
+	ops_id = READ_ONCE(sys_ctx->ops_id);
+	err = damon_select_ops(ctx, ops_id);
 	if (err)
 		return err;
 	ctx->addr_unit = sys_ctx->addr_unit;
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
-	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+	if (ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
-- 
2.47.3

