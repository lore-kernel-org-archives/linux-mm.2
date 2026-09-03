Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6993DC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA216B00BF; Thu,  3 Sep 2026 07:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A8A6B00C1; Thu,  3 Sep 2026 07:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489E36B00C2; Thu,  3 Sep 2026 07:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2663B6B00BF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:20:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A81C61C2260
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:20:13 +0000 (UTC)
X-FDA: 85172207106.14.32C8603
Received: from mta1.migadu.com (out-158.mta1.migadu.com [95.215.58.158])
	by imf18.hostedemail.com (Postfix) with ESMTP id C7E9F1C0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:20:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.158 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434412;
	b=KDOYPpGby+krhdCrDUHueXg3gFsQzYSCbknF4KhQvhmKdI/1A9fRghJ4GyRHXTAIykVXP9
	9wRrUuH28PBgq/+A5MzKI0vJXJ0eXMxFoBy90H+2taRUa2VQMe2y0jPQT1rpYdxhYdzGd6
	2xlKomr4QYplcWAvVbS90TC8QSlU0Ts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JUVWWOh4QvdkUrqOYSt5QPGbTigYwzXDyFa0EN5xW7o=;
	b=zKBBlrLslA4otFFiHEODpZg32lgD+BoLRWpUmNZzjMl4/arfJQpVvaGf0aGBhMqSDrbZve
	+2sXPRpuGG0Uc7TJV6rAyg8rB8t/yzVPZievfl3I8TTBfwzvQk6+Cd4Lov93hh5Fq8jYSm
	uj5L1oO1KFEz1QmEOPnuQ8Zv8G5NQOc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.158 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 4d44642c917c58e5;
	Thu, 03 Sep 2026 11:20:03 +0000
X-Mizu-Trace-ID: 4d44642c917c58e5
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	linux-usb@vger.kernel.org
Subject: [PATCH 13/13] usb: cdns2: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:36 +0800
Message-ID: <20260903111836.1777265-14-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7E9F1C0002
X-Stat-Signature: eyd7qi5f8zuxgurxohdwan15u6jbqpcx
X-HE-Tag: 1788434411-834537
X-HE-Meta: U2FsdGVkX19UOItkmlHq5tlcfSYlNKkNlBMwRWvsKXc2zKtq6sL+9SV8CTtegzNQYu0fpmxPCMZYBSwzQE24T/iURKJLFyDVH1gSxn9lP/Yuc2hpyqkhzm2fQn2nDoLni2VbQwsHFM7Pf8mOC2iNZUKmeMb4Z6gnKT5LCmYBtiaIayj5801TUBND7LlvU9yfA8JqK6BAJ1PUa0dEXZWYWKCKrOdsTUw/5bVH333IodNBP+g4b1685zn/cuGqJQvjfD9nXAcGsC1GZlreWJ2IAmPeQBJf6HFB6t68LkP6zrUDpkhCjiPZISYoiAluNqcFbpQTDhWgXDmRGC/svozV+uVta1FErlH8jheoHCkairgwDcLdn5A7mTGjPEDyAcmlAqnSHA1pOJiZAJeR82vwpMWrnDHqcoctMbtlvqWQe/nhtlBY+CVoNAfoH5of+bwzUzvgpWDnhjIpPgfZshVAgYNmqLMsNnkigYXz39235Df7uiBI6lWEuJgWZKn1lZ7aqm1+FHD4a78isbNTM1vlhMBKaupE3Gj0cbBnpwvYGeQxokPMURAQWaBPqnwmhgzvHBWUBiDkiCreIFCzzrUasxPEngvf9f3/8C46rYoSD9Avpf6Qr72nXMhQAhIzRdW5ZvJ6fzPWok/bntQ3SFkNy6DuYegobkVHTUdXjeFQkaG6Xy2V+S+2ng7/hSz4/RS5smrCQtRTZOsTvHpfQX/HuFd0qg5e2mESk4xpTIBWJGPs1o720hPHNw9RTVw6OFd5JrX3IOklcEq58/Uz9ShFeJb94vDQIsZTTJJ6AeWd+mEPERcA4j2R2yH4/H60cCHIR7f80R5pkE1Web9m5lSLGut76AC+L2Rhsn+LsS6V4O07wrRXftd52el/rWL1uqUJgX2h3Mf0YzJEhUIE5uM7wB4yUfIau2cacC4fWtFv3ataLDQxZZdPjqx3iSCM5/oPBEXxCQQH//M5Cpjx2xh
 vNCTSkdv
 F35f/xExyjyGqGLkXFDgqraVayi8eJiCgVY+95Bg8DsYItIHwOmIQj2393smNMHvaRLe6pwBRmt6D3Ku7FXeZ412Gt2piaEtYmyNaMIeE2nVvWCv2nWGl1IdIyL2tdx75+FBAc03j5/cqs1ts19gETBqMBFHGRKUhmzELF4Mb8iw6OO7vJJSVKfL0LduZYduD3uz3iIZlw5KFBMiDdg/3RyAEH1LPbyEaeZ/fiJ6A/qX5OQ9QBx6XNfyhYB1Ky4tJ/NXobvK0JhSgyhRqeOdoNkcxiWZaPyZcSKyL+ES5YswKvt7tzUdJsJL4jGDt+I7tHqKTibmNDDnISK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dma_alloc_coherent() allocates the DMA buffer with the device's
addressing limitation in mind; the DMA core picks the zone from the
device's coherent DMA mask and ignores GFP_DMA passed by the caller.
Use GFP_KERNEL instead so the allocation may reclaim as usual for
probe-time allocations.

Cc: linux-usb@vger.kernel.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c b/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c
index 308d3c468ab1..8719f1f86e61 100644
--- a/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c
+++ b/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c
@@ -2341,7 +2341,7 @@ static int cdns2_gadget_start(struct cdns2_device *pdev)
 
 	/* Allocate memory for setup packet buffer. */
 	buf = dma_alloc_coherent(pdev->dev, 8, &pdev->ep0_preq.request.dma,
-				 GFP_DMA);
+				 GFP_KERNEL);
 	pdev->ep0_preq.request.buf = buf;
 
 	if (!pdev->ep0_preq.request.buf) {
-- 
2.54.0


