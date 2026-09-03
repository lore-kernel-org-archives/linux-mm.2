Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47930C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6FA6B00B7; Thu,  3 Sep 2026 07:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39EDF6B00B8; Thu,  3 Sep 2026 07:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4876B00B9; Thu,  3 Sep 2026 07:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 072926B00B7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 849BD1404C3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:43 +0000 (UTC)
X-FDA: 85172205846.20.14C5718
Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD18E1C0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pjw7NISYhaRkYFq6+mkftIGxcQCFY3tJ4VuKM3tu8jQ=;
	b=o1mU9MyCGTKEHFNkIZn/BpOEEvlz2r4eHOjTgA7Y3soWjLsttCEifMIMzi9xbyGFGeCq5s
	jHU+UBq5Bc6FLo9j74qxsF1Ua5t/dqD1wgjeWPESrOJDenDIy0lM+SR8A7mUV6LOhatDBw
	QDlaUyNJittFkoIbZ+w4H9gs8khs+u4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434381;
	b=DNWVi33uYjj4st8zttsUmhDzQ7bcqYWEhGz27SHt8obr1tPTc/gxa/WJDyyQfb8MY/5omg
	SkmzZKS1YbEwF5NUc/RsE5UkCzbnrR60Le6H2zFp0l3eBdwCsfh3fOBqOyrhAgDGSw66Ts
	ZmDk+HB/hgfr4dOfvOfh7ijIKE/2RWs=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f8566ddbe06af796;
	Thu, 03 Sep 2026 11:19:38 +0000
X-Mizu-Trace-ID: f8566ddbe06af796
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	linux-spi@vger.kernel.org
Subject: [PATCH 09/13] spi: atmel: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:32 +0800
Message-ID: <20260903111836.1777265-10-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kks4j9qtx55mrrb9s65gh7udhibxg1uy
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD18E1C0004
X-Rspam-User: 
X-HE-Tag: 1788434381-684827
X-HE-Meta: U2FsdGVkX18uoQeAMh5UFmDYCyala3WIqHpctwVvgcvVjjwNl+DWabpWOeSTFnjv/4R6udJPJWDYaPnRFEowQs5Bmuee9Y/BgrJR7GuJqp42ife/Q5hH0KH+mlRQei0JJjlszNDf+kt/AewX/KxZN4RZERoWX2ltyyTNYTfurNBhXXZOqUlGvXwMebIkz1g0Sfs8Luzhg92m2ThP2AzHd9r/nzJg4o6oXiDoHB+0jcNfwkXoHOLC5Le2UFix8scdkRUnCcTHVfXUgf82HW8xKD1byexOCnufNXoAOTE3e/z7p4LtRixTb/kcZO+fkD26p34mpVM/ZJgmXo+iywag0NoEO1mvHyNUb+1G1Mg4wxz0s8nP1aqlcxEk2vG2EZwans0m3cvU+bfmgaCfDbKs2uYLX7C7EeY5AllXhCrj229HQYudu5mcT79hc2vwTiuhkEWphFwJpaPa8LXwzdlDTXoKglNRYxhTrXa4INlHwrLHuQps/GXAbBmYoKObvzG8Kv8X0X0LBw604JW3mWi/RH5BtPkC8nbNNWeGW5WzKWnU1/jfLhTO8TITWh0AAI2mQJlOAF02LFO+JnTAZOum/Q1l1zKkKy4MZMkeiNZQTDP8cJXTlxlpC1U3PWDxTznwhbDatedprlxff22AER+BO7mpYbG/5Axz9T4vDPuLH2kUaNWsxpLSSXrvuFB5Jk54yShKnAa3zDu1SG94jgKWa+LfHxhU5ChfmnWaAro1NP7v6YgVr/NW5uzKNvUFH29wTohoDfAqzwEiIjWdUraGOM0uek9EkQZ/EJiUtrYlWCQdg542DHkAvjh90nH1hu/FcxoaP3tssDVjHd+0TvSBIVOzx0w7uZUH96qdNyDZjbaRmLHfSYlLSsH4lLQuk1krAhblahxV0oORN2NjdFGkAcZuCu38+z7XKksSg17p45CK4mt371lqDkidW0HA5mzi+dMGisW+hXYUxZLLzHv
 vclAW0qh
 /vuSphghtpgFh82RF2myZHvNVuzUNfWnQlnSVBrG4A2DcUqPCBqQ8pLjHxTHkIosBnKZZmEKhU4rPjELCsQVHC03Vzifh0qeyxz4t4TtzJsW5fWwn7rICgFwIwjwgn29GlktJxYU9NAClrgrCYjn8qKP6XRu+SVu+LnJWBVuPKaEW1fL/QX/x9FecysP/r0Ni5kULNkCnmzX7LSGhda+aK5Y1B6opvSiOS9hBmwvNFFDfTYNNsom5KyvzZpW9rAVEYYeBrLq9SQMqXdW9VzSgRWb62GM0bBr9c0G8
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
 drivers/spi/spi-atmel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index c8012c82c3a7..e91e84fdbe8f 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -624,7 +624,7 @@ static int atmel_spi_configure_dma(struct spi_controller *host,
 	if (IS_ENABLED(CONFIG_SOC_SAM_V4_V5)) {
 		as->addr_tx_bbuf = dma_alloc_coherent(dev, SPI_MAX_DMA_XFER,
 						      &as->dma_addr_tx_bbuf,
-						      GFP_KERNEL | GFP_DMA);
+						      GFP_KERNEL);
 		if (!as->addr_tx_bbuf) {
 			err = -ENOMEM;
 			goto err_release_dma;
@@ -632,7 +632,7 @@ static int atmel_spi_configure_dma(struct spi_controller *host,
 
 		as->addr_rx_bbuf = dma_alloc_coherent(dev, SPI_MAX_DMA_XFER,
 						      &as->dma_addr_rx_bbuf,
-						      GFP_KERNEL | GFP_DMA);
+						      GFP_KERNEL);
 		if (!as->addr_rx_bbuf) {
 			err = -ENOMEM;
 			goto err_release_dma;
-- 
2.54.0


