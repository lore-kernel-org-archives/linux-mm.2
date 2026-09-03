Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A43DC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EDB76B00B8; Thu,  3 Sep 2026 07:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DD56B00BA; Thu,  3 Sep 2026 07:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB696B00BC; Thu,  3 Sep 2026 07:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DDC06B00B8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81E86C04C8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:48 +0000 (UTC)
X-FDA: 85172206056.14.FD80414
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	by imf17.hostedemail.com (Postfix) with ESMTP id A5C5D4000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=89DM6wkW7/MJWKKLGv7OjLPKq+mmLEM+9NbRLki1KmY=;
	b=syM0NfxXi3fGfhRrbFz8pHFY1daWEsPHsifqvhm1KpbMcSkpDCa2FJnLfxtAOX8CBBEeIz
	mNh49wXJOMnRLfkHMVEmoiea/4wwQc44ABemdPHxQ0WUY5ausXdihnuEHSwjS1L9rK3rrI
	prIjI5PgPMXK2j6DqR8uqNQXphiha7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434386;
	b=LtWdKBeC6XY5IBWAQMCzACCOdeVaaSyq7JXUU2DjtoUZmTD40puLVvNeilHXPS0w9Zizve
	wwBMDzDX2njOdJlDD/6/JDS/VJhFgRG38Go1rjRtGer4xAvihpxGAdocp8MEUyrAgLvm85
	jtD9fEvo60eoXErk0hQ3AJgSEmppySg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c1913d8d0fec3ae8;
	Thu, 03 Sep 2026 11:19:43 +0000
X-Mizu-Trace-ID: c1913d8d0fec3ae8
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	imx@lists.linux.dev
Subject: [PATCH 10/13] media: imx7-media-csi: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:33 +0800
Message-ID: <20260903111836.1777265-11-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A5C5D4000A
X-Stat-Signature: ysdhsrnzg6q1noe1q7ptjy3dz45dn38w
X-HE-Tag: 1788434386-150742
X-HE-Meta: U2FsdGVkX1+CbvY8wzeJI/Ud6N/CcBDVn2C5nTIZdlsAY3a5eCtmOxk0dZLr4c9XfrlGNwqmcCQMuL5jtd+KYNAUvAQEAvGeZUe9IRjrxbygrA3THrVVKX1MyuguXkvXZ0CulWehsLb6uFU2L8wMS2PmVF56yAW0Pzflobo8GkFx2vySZZXGKF/E/K5gM9wVkMQAo2+i96Bv5QRATGezmIKfRgNi3ezmkEdVb98+ml4qN5wLck41pS/4RdzGi3YvpX7kT4UVCAZ1Ps1XVAR1nCVEFWIqagt/omiHrwKvWn1p3j4zFRRem1X/MFAZtxPvkoz0XzjHlP3BnW35LujUsA+ULHWWMj1izPKzBRXL4LPCx3UjLkPI0HVUU83Yqhg5XCb/YkewTY6XMlnR7MxSJjP95cBLsTClOi9XrF9BkAK6SDDDB+YepjAe+FfnZCn33isIOzRHTt6uah7EAzTPNNLO2EulpskAyAv+pSWs4deMBrKMbI16TVi8MKL7irIaGRsIjQycXL2fUIO3kwpVm1At87jIQ4ZzVVgjQXPbTP2DuJ/0TI5SL47eSQ1AiHKQY1VYouzfYU4KZHYbz9Y9Qr/SCGoER/UjNy0cyTsqWnhY8qd4/2lTy+Zf+KUg45Q19hnYBtFqkpLsb9DGHCN1z5n66rbKhRoYSEZxk4D4yL7VO/poWYQg0j0EDidRtOLDxBSjvbRpHABUly65NJNdGOysnqPjZqmyPk+yzQzgsAcraluqh9UnPfbd6aGZ8aIRIfX/PIsF8KEJHG1KhXYtoLHdi90AvS91/ep+dq9VBPCthT3ulDXIYMduK4l5GTNQNRYhJmb5X/TbjIKvF9f3XTfgtlnM9QOsTxfxsZnSyD2VJAykY0GbNWxpjZIQzTJmNTZteuO6Vjjc42kaKgBK5Ep0DcBjE0bM0Vx21LHbvIZM8YkhCZ8p36cClWBJg3ViZbxFToHLO4zT5M45pmo
 7rH8IU9K
 wTTA4SDCyIMuTCH9OvcGw1SW2HjPJqN6nk7WuyVa2jFmyIKc2yQqvtJtLxVdLWTJzp/NuCy0/7M+zo6+NV1M1jwHFcHPbRIOXpMMyjO7STQKVUqJn270psIH1VwTvdPVbNSwtZ5kPA5rjem/Y2ZKSs1j2tO5BdmBkyCPluWPOhiov/kaMCeHLS+b7oxaY5RExQB3+3TkvV1s9tTlZRrFPH5XI3N3niRpRA29k1rCTW2t8NgOUzMevQsvDyFAiC84YIfkBdY0cnRcZUZ4=
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

Cc: imx@lists.linux.dev
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/media/platform/nxp/imx7-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx7-media-csi.c b/drivers/media/platform/nxp/imx7-media-csi.c
index 7ddc7ba06e3d..22c0cbdc92bf 100644
--- a/drivers/media/platform/nxp/imx7-media-csi.c
+++ b/drivers/media/platform/nxp/imx7-media-csi.c
@@ -466,7 +466,7 @@ static int imx7_csi_alloc_dma_buf(struct imx7_csi *csi,
 
 	buf->len = PAGE_ALIGN(size);
 	buf->virt = dma_alloc_coherent(csi->dev, buf->len, &buf->dma_addr,
-				       GFP_DMA | GFP_KERNEL);
+				       GFP_KERNEL);
 	if (!buf->virt)
 		return -ENOMEM;
 
-- 
2.54.0


