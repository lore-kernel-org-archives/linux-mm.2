Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 531D0C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D776B0088; Sun,  2 Aug 2026 14:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A3D6B0093; Sun,  2 Aug 2026 14:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1D76B008A; Sun,  2 Aug 2026 14:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC2846B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:54:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61541C053D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:54:42 +0000 (UTC)
X-FDA: 85057230804.04.5B62952
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CCD5B1C0006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:54:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VGEesB9v;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785696880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ew/a4uW6pk7X4wPVJ5ylrhLZPDJztc2+7Q2+2wvo0Vc=;
	b=UB1qMLmtAYRYTXv6VWPXYxl6f7QzTMoGYA8xC7WGJ3ZIyq/gy989rCjZdRCOjXJiRIKdL7
	Ybcrg6uU9iGpXvmH0km3nlFNh9ekbPp/RwHNeSRsSHeV1WnsAfNG+gONxdbrYQwa49bojO
	Hysy7r0JVB/guIEsgcI8bva28wQ4uFw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VGEesB9v;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785696880;
	b=eoLNfy0yx2/TM/z3t/x9qVgLp3FUUP9NTfuhNSfrgAhKiTLR3RRJOAHq90Wbwy4+4ma+o6
	aarntVlpAM1Z7WK0wHR/+Jhkpy0Z0kpnGrtftTSPRL2rxVofh5wiYy+yN+RcbDsLTe0i1a
	KlaPehsJtYJ+avSgnhSmmmeOMjBfdMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60F6160A58;
	Sun,  2 Aug 2026 18:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C1C1F00A3D;
	Sun,  2 Aug 2026 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785696880;
	bh=ew/a4uW6pk7X4wPVJ5ylrhLZPDJztc2+7Q2+2wvo0Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGEesB9vu6VW1zZJApPXDAYtyn7jICQs0nToBK7mFRxVE5xAkmXxHdpx8y0fGFb/n
	 EZNIVQOiAhBtbDNaDEf9s3YJjX8CfxzFoLVzCFUxmJkfcxVtKulHiXqAX4R8hYw8iF
	 8xTOMazRTsizkcNMvnAv+cnBsV+pUEtHCzUNaok563hA0Gkyfzu+dh0WpPlX5LB8Q2
	 J32OO0Gtc811I9E/WYhalF3fyKzbA6AikVlkc0U4xiei+OLMVZguDwyhBKyIk/w1Te
	 4hi0/rYRN5VivhOC/LCoNMeDqCHG0vWvCpFkHtBoH8sFVy75PFx6TMrVuQa/vLFkgs
	 SW2eR9fQjSZBA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm/damon/reclaim: skip damon_call() if ctx has not started
Date: Sun,  2 Aug 2026 11:54:27 -0700
Message-ID: <20260802185430.9940-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802185430.9940-1-sj@kernel.org>
References: <20260802185430.9940-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCD5B1C0006
X-Rspam-User: 
X-Stat-Signature: e6c63kinuzz1dwyzpjwe77dxiij684f1
X-Rspamd-Server: rspam04
X-HE-Tag: 1785696880-522744
X-HE-Meta: U2FsdGVkX1/ZJrnBCsamH2uM+dMIJSJ1ehC9ARQr8F5ctKgv+cDLjBaxHJu5nemw/ZNCxk55casUj1h58gI+eNa/GkwUUeOuF1P5Ej5JCFypgf2qv3cNPpWo2zARMCFjbw1BTFJ6eVEE9XD+7FBvP7tUpB85SRWNxRdguqruhsb2KbgTnigaAU6nkYyVAynZ2llmthTw8ma9kL6k9xQuMkiP/Cy8eA46ZrHyaui1j1VrOsH2wn0i9XZ3UtaV4GCxW3aDFlamGfsgaIl76b8PypQv6QadV/9gbonsigFs4Ovtci76bXUHkDjOzYdZAH+B/7wf4umZeAPRYzK7bNk/dQlKjNo177iyvLhvj4pTDchLK6HmW/X/rrSb5HghxgzlPGbrJQOpFKhBnhIL8DZi2xKne4Pq6m+hNgQa1ieOXMp8YLwhv2IDnOVWgWF8mN+wuGqyQSTi54D/S99nprevg3i/J/GMIUuLGWGs+FptPvdlzyBmXr6GnDPVHhbdkTK8iQuIrT6CoN0kD6yuD3qBTabHN7a7v9SFPxtdcDrV7ADXm//M22CpMUCY3RC2W3TZOGu9IHFxrpCqg+ml5cooISz94zrLavug6J28sNEwCfBgBokPXLVjoen0ggh/kh2PYxwNRKShQkKbI7GXtVZecsBVOP8MaQ9S9h7HuEGVrizpd5RKN7KQLcizBakMkZmsb+GU4k6CvFoKn/JMDTlSwxnA5apgr4n7odZ2N0a2ffcBdTH91Sg87MoAN8gM9YHKr/pGVvyt7prSAzvI22gJQVwvdbQTNWArHonTwPLYqZpacehxbVFlFZLGY0U21JWkVe2G8jGWMrLJ08mOUnpD3gKsBKPXZq9GalX2c/HkYCEJcNEgjL4+LGAXgAu43hRCtlIVet/GDLxdOar/c/3w/sIlh9vHAPHt0WpUsIXCqIutq9v3yQuzRHIRO+Bm/KWZJlDU97LX3We68G8f1b7
 JQ8QTuWc
 aeYOWyTZg4uHdUnMR9Q6pZQo0C6YLvajicwf5RF4UEJ/SknLtGbzxRb9d3p6jtjvH9S9bDcEC7+13dqfg+N6rrc0KQO3Cw9xMZUEFfLkDyKRC909eCVKav9DZfendjyfcDsyQgoYs2k9VxNF9OrLtrVwpSCeVr9kaNzR25DS2B0lqRnFr013PLldPJsXTiA/nwGbS5kMgKRis2f31qxbFZNC7sGpJam4V8sUYS56L8kS2WqpxmPITSoFT1KUW1qSFbio5y9Q6x8dH8+WaoB+5CCQLmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM calls damon_call() for commit_inputs parameter user input
if the DAMON context is initialized.  The context could be initialized,
but not yet successfully started.  In the case, damon_call() could
indefinitely hang.  Read the comment on damon_call() for more detail.
Fix the problem by memorizing if the DAMON context has ever successfully
started, and skip damon_call() if it has not.

This issue can easily be reproduced by writing Y to commit_inputs on a
system that DAMON_RECLAIM was not turned on before.

Fixes: de3c60e1c831 ("mm/damon: add synchronous commit for commit_inputs")
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 09e941d75f67d..45d5557cc575a 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -271,6 +271,8 @@ static int damon_reclaim_commit_inputs_fn(void *arg)
 	return damon_reclaim_apply_parameters();
 }
 
+static bool damon_reclaim_damon_has_started;
+
 static int damon_reclaim_commit_inputs_store(const char *val,
 					     const struct kernel_param *kp)
 {
@@ -291,11 +293,8 @@ static int damon_reclaim_commit_inputs_store(const char *val,
 	if (!commit_inputs_request)
 		return 0;
 
-	/*
-	 * Skip damon_call() if ctx is not initialized to avoid
-	 * NULL pointer dereference.
-	 */
-	if (!ctx)
+	/* Skip damon_call() if ctx has not successfully started. */
+	if (!damon_reclaim_damon_has_started)
 		return -EINVAL;
 
 	err = damon_call(ctx, &control);
@@ -344,6 +343,8 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+	if (!damon_reclaim_damon_has_started)
+		damon_reclaim_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

