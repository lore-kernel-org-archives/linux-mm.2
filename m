Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD226C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67BA96B00B7; Sun,  5 Jul 2026 12:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651986B00BC; Sun,  5 Jul 2026 12:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CF76B00B7; Sun,  5 Jul 2026 12:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 129876B00B7
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AC7240110
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:58 +0000 (UTC)
X-FDA: 84955189116.24.7D6A3CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A8C531A000C
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TW3jYsUn;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/v/dE+FlmtwJgj5yRteS0MOxCozSQuxW5M8Uj1RzSo=;
	b=DpD6d+HCDDf5KM6glAWfAe7nQfZxfFVdKeOJ0XhKC+2cw6lgiJ7gBdIpAE/JLxuafD8Hhe
	99DEtvSA8OeWdzMLzJILTQbKD7iDPyZotLUiXpUMiaR8aRYC8lQKlN/j+jWwPo8gvk03vW
	yyWdML2oGh9YmeytkZaxDs3I1PQI/IA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TW3jYsUn;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267316;
	b=xlUSeOcyG49vasX3sIla3wbbJmBGpEDpurd02PVl/hv8Qw9sFVw21BNvc/rWj3AdURf7Fe
	dNVfT2FuVUoE7a6OxAxRUyX8cdI/cseXg0i/FfNTtKPjEJhtbXBe6NDNzjzAhBye7vo+yt
	qf0hxq/PH5LGeH2IzoY2riA8NltqipU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 032C543C67
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3F41F00A3D;
	Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267315;
	bh=d/v/dE+FlmtwJgj5yRteS0MOxCozSQuxW5M8Uj1RzSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TW3jYsUnmaIGxOT+B9VeJzZobrosiaK2eLvMXlwywcCygVzqc/gMMSTKxzwIN3ap/
	 oRVVZEPnGJNJX8fHf2cRL2F6Sz5vqP/6NycQonk3kUS/iAIoqvQcdr3M9x1eBsiWLZ
	 ORVfD85j2H0NKv1K4oc6wh0B55C3ZUQleqEfKNUZT1cT9eyiio9GgyAhOwvtddVJjb
	 PFc8eGzR/nWVr0LhGbLSU8tD7rZM/8fL4ICAwF4PbHZxL6a0eTB2M8m1ZooaGqus1e
	 x6Kh8IdkjnLbM9H7leZGgG7VTetv/iRNyF5TMceYsn2PayU0AQJaU4+o92rAx8Wpo7
	 50V3wD0vaod2A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 11/11] samples/damon/prcl: do not stop DAMON for damon_call() failure
Date: Sun,  5 Jul 2026 09:01:38 -0700
Message-ID: <20260705160142.97308-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qnkrky9wf8dke56qgfh1p84nooz1e5jt
X-Rspamd-Queue-Id: A8C531A000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783267316-623256
X-HE-Meta: U2FsdGVkX1/F6Wel8Il5tYy4nWNiIKxBiecZe7XmiBAoBHxnKnDhgzBwDrWDIVgGFSPmGhswoVYV5bGpqQ0LvRA4LH3jTCWmWF2e2ICsrnlr/XOz6UTOiop5Au1aYwIFhcTyspWjQu09WJ8aaysgCEmn5iQ3WSlZKk55Q/ws7iAMLQfV9oAgKyRW0HkZPPANA1+1rbtMTYg5jWUj3CroS4rHP+5mZ7HQ5ce52erW5by6U8MsOvR3PGqudvvcf0aN0X0eo7n88Xlg7h6OiP5Qz6IRqY5M4O9fYMQZPxnqE6/waiMzOE5V+IfkFF4QxhG8eijqSD4Jl7D9CH3VGSpgMsAFsNQL3pxY4dWmkqX8TC61tegg4e9ckwqfQ6U+t4gX1le4kt92Dp86d/nRin55Sj7il4lO7Vre1IoY1nxSG1l/rNZlpf0iWFRQCAag0qTuX9PkVXDiiewVftrOPZpwqniSqWx/dZOf+QaqwryFzxT9hC6k0UUSh8HKHkuqwzWmuUImy0tKZ6zWAtTayAGehAo2hO2ghUzVnVV17H0CdeYCBwwnUXemo+b2+rCVgXSqds2AhTyVoxGWP01yRgr9PFt82sIEkBTukXnbZVsHQ7zWUSeN1El5Sp8nQc1T9WSPFT4ekM5Wwt5m+V+8PctAYpIrBR+RA/nYqxrBBgo3rPwYuxxWz5f1B8AaF4oe3Wgztx+o3dZ8VIzpnu6DyV1mj/EI1vkvzTeM2YC+e52XChTAcyPciYcGRTvz7KRTsnq8s58JwM+cH5igNDHpV3VhXtIb7OQVGwX2A0EeCoRVhM8HKueHO+OgCv6dr+lni52CcsF+/wuzCUZVOt096ewJRAHvHv5OItQDNMwhwDSoFKhd5wAmQLl0U7xs931XBj3dza5Q93bCxbYjxK+UrqRl0/cZ4KqSHjhC4vA204rMju3O99aTryE4u9qOdERrJntfjCez6xr6ta+UhpMAWlq
 N1CYlSKC
 90DkXxdGfnmEWUUy8DAfifI4Sja/d3pYPfuvJeMa/Zrc4MmMJ6DzvUUw42t9mZ0CsQRb1iFV/OIytUAfOMBwrcJjL2mWvYZ/TgVJmzgTDIRN1J1hKCSy2Nk1x9W+Lj126nwzAIuac+KP5nSCZ4S5Bo9BGV4PfA8pCnC6ATqKcYbgaOpUGVweepnBevKl81AibjtNDCU4vuLItF3xsXE3TQo2fulqJvd9rmlLoakuV0INzsXGsQHPNXVPKNz4UKoqJrTuMVLKsxTcmyi2JKmbU9i83J4xS3agiO95PdR9wbh3yfbdqNCg2Mz5jI9MXK2x9dDtZNIAj9QFTsY11XRfLHFqVTH/NYs7yz6JM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() failure was causing the context to be stopped, but
asynchronously by the kdamond thread.  To handle the race,   the caller
had to stop the context.  damon_call() is updated to do the stop on its
own.  Remove the damon_stop() call from the damon_call() error handling.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/prcl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index edeae145c4a8a..842099bd62286 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -113,10 +113,8 @@ static int damon_sample_prcl_start(void)
 
 	repeat_call_control.data = ctx;
 	err = damon_call(ctx, &repeat_call_control);
-	if (err) {
-		damon_stop(&ctx, 1);
+	if (err)
 		damon_destroy_ctx(ctx);
-	}
 	return err;
 }
 
-- 
2.47.3

