Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01083C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4CF56B00A4; Thu,  3 Sep 2026 07:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25816B00A5; Thu,  3 Sep 2026 07:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63506B00A6; Thu,  3 Sep 2026 07:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACA6E6B00A4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F61EC04D0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:17 +0000 (UTC)
X-FDA: 85172204754.28.422AD72
Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	by imf03.hostedemail.com (Postfix) with ESMTP id A49FE20008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=veAyMsRY/6sVNUZRMrr05idsiMtGw/+7aqsKxGsWOYg=;
	b=OfALpYDRe1h00mNJmL5HMDy0I8PQi2snpDye68qRU8uGn3bTmK9lrCoe6JiREgk6rhS09u
	3K/BaYsFDQN1ezgzwn6jm8Z/CQahdDiIdPBOC2XRcgVpJbEUqghUT9V8Oi2FOkBr9jECmb
	X35P6VCZprOwscSeep6HX6FJ04ldvUU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434355;
	b=7LIzXtMtzSFZ5A9G/60346g5uW1LDy5pvGPDwrCtbqxAMKA7NuTp5dF7QnM9tSVQ86E46i
	hTEhivResjnZjmtpTDqfsTEXF7rx4O1wyD5eeRG0N23POUp4bdhqIEf0FPlT7pkPMkbUG1
	iCW0ZsWxveF3jjF21WR8R9572iUySlc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 2ef24302bc664fd9;
	Thu, 03 Sep 2026 11:19:09 +0000
X-Mizu-Trace-ID: 2ef24302bc664fd9
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	linux-spi@vger.kernel.org
Subject: [PATCH 04/13] spi: spi-ti-qspi: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:27 +0800
Message-ID: <20260903111836.1777265-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A49FE20008
X-Stat-Signature: 4wfszeonr7u4kq5ez8q9de1zrj6yiinb
X-HE-Tag: 1788434353-775687
X-HE-Meta: U2FsdGVkX1/kB5aSOKG6QuXgaqZsenFmPUxPcOsQGeZcUgRfdGlWPRwT3Lo9srQkS6rsfby/sb3qkc/x3jAxi51ZMlNBLVWQZNDyxGG/Z+sDf+d8B93wNfUgagZxDUyrP1ylbFXbQMIBUq0ZEXi5yxPShaJDaKGJprW/hAqcsOrshoiCxrYWz/t2y2vDMouSVbE/pDwsqsd9ZmWlFA20A93V4scTT0lTWRBcnOAJh+kxZS4+ycyP4JrLwfOtxm4MFFIRyhfOZpybMpDR1focWmCH01nhexONjlxCQwxhWxsuB8zyRA02ZbjTgPVp2LjF4UiCiiKImrjs9h2FH5phjKhe/PxeiZWQKffv/Gr2Ithhft++Pm8RwWbhJ+dYQxLbLm1PB8Q7kIPR5oK8L5nfnwCOWTeiKGNC1IMnXwd9heO8Old++MBRCECoDUBglQSu+hAWihuWSbupt3QQr2QUID7wWTsOtEuXz2zfWwAv7a6P3qtCv2Tm68We9SHc4GEr/MkNbGgEb324Ua4hBhrmwH11FrlSOHTx5eU0FecjZdhw3uI8/07eeJOgHn1lRITDdIfO7Nxu5EwJdmW2LxSe2NqyaJO/8AOaEVhnfbguwAe9SCo6dH+o93gQv/wpQIih2919JbfvrkMhGuZMayvFP881aWzrBPGKcElD13n6E3HTfXpbPFIoa3lv8QSRPM7vQBfU7xYcomnZ06Kn4Hsd2Pd9okStLaYTq84r5jl9XJUymYE/DRtQ22wXPZUCpkEHMX/9zw7j+QYOa2NRPXblnje0tzhG9I9SHon/s/FoEo0V1/J/auqe7OnkXY0tR0rR0p+yxYbNSZcbv4IobnsZZfG/qHAkG1BGf918q6vacz55mbEcIYxEONkEUheYaC0rHsdPg7asCAdiHcy1hg2cZ6odxoqJv1PCcXfedT0xnStvtwPR5dwvMiQaYSUlZE37qEhX9uYc7BhzZt4wDiK
 ZEqQ6xdp
 Ad52OTRTIpyWZ5ZL59i8EMuDZeTPSyRGDq/v1MBwXSV2JDv5uxXsFjEN29V6Oq4L58DDVEOecjDI/G0O495aWWNpMsll8c4+efGmNAa5J70T4TgRXwLAeLhmYCEM2U3dNiRi4m8Dbc6H4LZ5fiaKJIfW+Zco6jTs7VHQ1sJGiBjIGCc0dNrM3Pt/tinwqQpWPcKPdEfM5SDvkC5izJuoVcc9x1rd8uDwGWFNUHMk3RJ2PhMv2f4LnS/Iq7Z9DEjhW9LHmYUYFZOIcHv3SoK3NhaQf8+ipHVL6DtCL
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

Cc: linux-spi@vger.kernel.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/spi/spi-ti-qspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index 34b154922ff2..fb0d940883fb 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -855,7 +855,7 @@ static int ti_qspi_probe(struct platform_device *pdev)
 	qspi->rx_bb_addr = dma_alloc_coherent(qspi->dev,
 					      QSPI_DMA_BUFFER_SIZE,
 					      &qspi->rx_bb_dma_addr,
-					      GFP_KERNEL | GFP_DMA);
+					      GFP_KERNEL);
 	if (!qspi->rx_bb_addr) {
 		dev_err(qspi->dev,
 			"dma_alloc_coherent failed, using PIO mode\n");
-- 
2.54.0


