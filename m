Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1563C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FE26B00A6; Thu,  3 Sep 2026 07:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17F26B00A7; Thu,  3 Sep 2026 07:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2DA46B00A9; Thu,  3 Sep 2026 07:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8F66B00A6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3E06404E5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:24 +0000 (UTC)
X-FDA: 85172205048.05.F0300C5
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	by imf29.hostedemail.com (Postfix) with ESMTP id 029B612000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434363;
	b=fBhOBLV2nCoU4YXm6kTGlcBwtaehjegqsSdMisj1gGwtRJIONwAzvWdX63TyJVWxZdSGDJ
	iTxmbsMwyZmIW9K3Vpcy74OwBOLyQg6Xc21UC+Gsw6ln+PfIaWvo0Vg26qWMquWtnLUPyT
	4gpHSSIlwJ8M5iHRVilIC/ZxyzsYacQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0b5dq4/TDMEnlxc7LFez3G7cGdRpm5KSz6mdMPa9Reo=;
	b=M3qhW9CjQP7Aa2mOYZ1KkmCwzH4N76LoOpRf02QaYSJ2XlQq/7qMKQTcPFxPe/PwczyBX/
	oplv3SXcBoJ8QBq9otSqF5BhcDM9BX7cQOTnsKZgJbpsKtnU4ChlPclNhOfcsltfQSBnTA
	9BBaK3C7kqhitRXzqysZBCK1mQWaE+o=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id a19d86fc6d1e4889;
	Thu, 03 Sep 2026 11:19:21 +0000
X-Mizu-Trace-ID: a19d86fc6d1e4889
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	linux-usb@vger.kernel.org
Subject: [PATCH 06/13] usb: gadget: lpc32xx_udc: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:29 +0800
Message-ID: <20260903111836.1777265-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 029B612000A
X-Stat-Signature: 44s5xakz33ft51wh4shkxi1bwmygudbb
X-Rspam-User: 
X-HE-Tag: 1788434362-540678
X-HE-Meta: U2FsdGVkX18qgDdYWs1GmW3eQqLdXyGYHuMxV3FsfRAYkn/wIwOPMmS8KwDdl9SE7pgnhWbgV1limeKj7fdBKtyVdeXNwBcI4u/C/zmsBmZc1H3tSmMWpUsN0nWJDjI75fQGiTighoSoRilaVAGt7+LmZgP13+uq4zKPlh5uMF0vChI5We37Zo5qbmicjdCrc6RmsH3Nm2Qt8EtYtbmZ0EAGsTY3W0wX5SF9HmIHmvcXSoWyp/Wad6SpgmfOVmwfjsyaJOaiQIcTTRaXLeQSU/ABIFTgFBIM+3SIOaqBPBSvrH6fGXB96ZbSvYLDK+Lzx218lHhrOGB9046/oT5aTJ/zZwz82GC5GEy//KY1mSBtrAXBLF5lVsrAupxxaO2/LV7tWVCdwOYGC1khWDcGpX0Ridm/X5Uenaes2ysqYFJvdLFt1ioCklUix16KUz/YppqCdcaUiZfM0s3YmEEAniF4snO00AAk5kWuQZuuGf1kJsYGczOBn+RMUGZQJev9jUOMivo/j7JqWGb2oo3ztYG36tzbzLrFOvzGWQQahUIfao7mrmXUeMKdeOl1npI9KX9wGLh0ckcV62m8sPWwTliA02cV0HHA82Qsrf5gpxWbMVjiUl3IBHZ56cMOUOWs38JwFh3pyCxIUIzzZTv8Gn08sOy47BB/FRhtGrxdxdoLdJ3OOhWZ1TOsollbYweUd7TSADEF6Rwof5rTkF3TqoCBbmqlT14snX/XGjdMgYHyz8NP32SL+jI0vFezHgmotoeoNY4Y5+yNnynBBnUJVy1nEwDpVTrJ/ChqSIV39y5eXDiF8yEfTTed6Oul9x+XLwdwxDgUOUCt4AIcTVFBA4Z4z/TyBbYl9SbTMRBVWTwf4PCV/yQlbl9KLP+v3OVlWAimop2aRz9GjrffLgZ43CuYdkciX5P4uC2y3Xw9f+Kpq8ZwqAR/9uH1h5lqzwP9CLinX46P6/ZodESXZTU
 hcSiLq2L
 dsLvbcO/H1m5EjyHr6vqcwEcINFk1rXt745YZ8s74Pvoc9tntVBjMva02UZuVeXwGxQ3vM5MDZ9lWwCVsMjYYbSdYdvKMWDxU/qA9VrH/OqzkKV2uRkPWY3uG+k/4u7lVjrpSM2E8WKXnfaQ0xdgkFfZqmXUBVby9rgIo2OJPv6UhJKcnr7LJ2/UW7VKEfujUOOoepXpGgfS9mc0ZMY+h+155KAmEgU9hSpjUfcp7qVMrLwTLPewSp2cg/E/2SwLOl9wotFKlKGrlUbTRy1ecRY6n0XXNB++r6FvK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dma_alloc_coherent() allocates the DMA buffer with the device's
addressing limitation in mind; the DMA core picks the zone from the
device's coherent DMA mask and ignores GFP_DMA passed by the caller.
Remove the redundant GFP_DMA flag.

Cc: linux-usb@vger.kernel.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index 044c31869cfb..90d1eef52877 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3080,7 +3080,7 @@ static int lpc32xx_udc_probe(struct platform_device *pdev)
 	/* Allocate memory for the UDCA */
 	udc->udca_v_base = dma_alloc_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 					      &dma_handle,
-					      (GFP_KERNEL | GFP_DMA));
+					      GFP_KERNEL);
 	if (!udc->udca_v_base) {
 		dev_err(udc->dev, "error getting UDCA region\n");
 		retval = -ENOMEM;
-- 
2.54.0


