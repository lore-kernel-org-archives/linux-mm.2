Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B23F2C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB6A6B00B5; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55436B00B7; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C4A6B00B8; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 870666B00B5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE386140140
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
X-FDA: 84955189032.19.09C5AE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 67284100016
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJJvjOw+;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267315;
	b=Rls7s3GhOzmS8R8rPv16knfuljPcABEYRrG2VlqIbBar7t4OfZDSRwki0hLOhOoxBK29zS
	balQDlosoJ7eA5Qk3o3G7MmhpVX5Y8EGJ7FPlZEi+R2jVfO/pRTYD0EWECFl/M8oQjbhAV
	0IxDUr48MldYX8xhAL+yV1//+jui0Go=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJJvjOw+;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS4CO1+OYp8+pSPAS3NbVTVyYCl94ZecPiNEYxC3hmA=;
	b=2SBlWwGpn8qhM32hnLwQhavXQ6pYJTI3Yf3rrFXEtwJXeWijwyE3k747KtKkJqg/A8btV9
	KzL1MFAKzV0uCmvllC/iPDsDH4sIX9paW+Dalv8ZjMUTHgLuh21ZzshFfu7Z8sl8dKone3
	cE0A5At4CqlSywpPjScd+WASRHIhs/o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0519C61389
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810E41F000E9;
	Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267314;
	bh=LS4CO1+OYp8+pSPAS3NbVTVyYCl94ZecPiNEYxC3hmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJJvjOw+X6UtTg/lqL8ZVRUh/RVGx5PxK8snE+ZqCeomdOQujflFk2FFHiNvl/ZU1
	 XCTYp0V5Rb+fDuKcpVCgjaW4mQHjo90kKMw7DYWgETVIOnPptF998uTG9ZVl4jS4J4
	 4aa4ROrn8scaihdX1hzjiincl9U4+xjFLpR1zYLc0g6hzrTUn/nayP7tuEkKRPgE0D
	 xTNiqNiAJoirtyFYLFT06snKihTDgdYVWpNLB0xU5RQmAtrJcRy1d8fwA6kZW+GPSe
	 Ur6QkN/Ki7SFOMBfR/InNxVACrwyMdyC1SDzMgbtrODZYUPRA49OgW4u/eAV5QBwL0
	 ylQc/V+mVDeog==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 08/11] samples/damon/mtier: stop all contexts with single damon_stop() call
Date: Sun,  5 Jul 2026 09:01:35 -0700
Message-ID: <20260705160142.97308-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67284100016
X-Stat-Signature: t6ugp1njxcoiqa73iepuid7nykaf5ff7
X-HE-Tag: 1783267315-198234
X-HE-Meta: U2FsdGVkX1/B43eyKO1AoffOg+bJsPWdw0rvuBuZOGPMNpY+MWO6O8xVyk4mM94yos7DOa0E3xt3tXhrsSFi9l+NbzzrQuB+M5yzgctq8EAccT7pBx4i3Ng5tr2ekIo8epUGpTiZWBW8IUGnH9PKkPZEJHu6suu+lE+frvQU50p1VYwSWNwYRdTHuNfk1I10aNaDyZKOz9xJNtRfbnNO7iB8bfe22KDz/8eWsdeUuBfLoW0Mnz5eRINyKY6qUil5Vg4shqhPFpEJy9N5As4UcL1gPbHmgWCs3qAcRli3aUOHEyRbmSldLrJtN+47WIpdpR6ZaWJpGmtNIl+pWyxOdIFQA399I/GcIHSMdZqRwd6rODtYOnT8nmeLbFj1HeXrCfVnAF+ZCxGPWhnAN6fpVxIVwWfvMO7tO6Om/iHHRRnnNnPmx4kkyzNX1k6uaIdSm02GtNx4rN/SPsWH1OLqJBRMi8N7ng5cbe4xFyxHjR+Y00qyBxM0fJu1MCecwEzRSCGTsI+Sr8MeDsgBP0x96xUBBcyXVoAYM9wueU42fRiL6qWcs//6kGcVoSL/62+Qq5guHoaaFmNhBe1F31dW6M/fTNkWziRy8bICUp58CMBwMQnN94o4UluflO63biKhbAIYjkNGUWMR44SDfvRYSLqNXHSGwVDoMR8FMZTt1M+t5bQjJkRmpVaxf01Eel1W2QGG9dpMf9kvtpRr+OP7K9IPHC1xLjjl+9mVnRUBGjrAxusu82Fd2o1tZLDKmW7zTzj6kFOEXDV89iMrdXP1wngzakloZOeabNFnZm2fFfaasTn/SPUy0/zyU5fahNYlPz6n5V8bpn/cAvYNU0oTNus/yHvH4jvg4G1O1vTwFRe43t5CqztMWskrtgk8yF+S7GkH/9SCWKQTY2CFnBh+KWXs9U8Zc+XeIzdFY86TGpy6q8npQTkInAFS5wc/uueTyNpnixJQTu2CsKLmk8w
 XC4RtdHE
 ROGksUUP5jS4/wJ57FccfHZzHjeqCiGlXHI3HotzU8rmYFWSC+be7o5X4CiWJOzWr2GjFtaTv2Pa/2Uu1wVYC0pXqw7TO7NonEViYmLBeE4Zmok6Mz0LUlrUyiM0vnlhzrLZjBCtbc5o3O1ZnB+V4fbTT4ZauRkmfnKQeezwsyMdW8agEjiBx622w/BLAiNgJtn5/jCL8+gu0yZZ3wIHJbEquzKps6I1R9TXWop1Lw652yj+BgN9F3H5zqQ8hixLLkhk4LRxZTSySVi4VUDF1pGeYHgluYrRR/PV68Dcvdm8hWO24PfDSJk4qPjHgqZ3RbE5fbPA6w1vJ895TQW0KutyivWXqP1o2/3euT74HwB2DtYZPeObii0idwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() was theoretically able to return failure while keeping the
second context for mtier running.  mtier stops its contexts one by one
with two damon_stop() call for the reason.  damon_stop() is refactored
to always successfully stop all requested DAMON contexts.  The two calls
are unnecessary.  Use only single damon_stop() call for all contexts.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 90881e8bd441f..ac9c24b92ead8 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -200,8 +200,7 @@ static int damon_sample_mtier_start(void)
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 1);
-	damon_stop(&ctxs[1], 1);
+	damon_stop(ctxs, 2);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }
-- 
2.47.3

