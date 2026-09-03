Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96EF7C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF1826B00A1; Thu,  3 Sep 2026 07:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9276B00A2; Thu,  3 Sep 2026 07:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06016B00A3; Thu,  3 Sep 2026 07:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 859DE6B00A1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:18:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EACDE1A04C2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:18:51 +0000 (UTC)
X-FDA: 85172203662.04.F821FB3
Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id BF3EB20002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:18:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.45 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FB9/wxZZ6153YhY9J3E50YOpN9xHZBigpN2+WBJqJrM=;
	b=OfeRoHh5JRgY2q19MwdyRgDFVFFvXxu2ZZy8W+9Rw+hRm767X0YbFpKNKXvMQNR8ppt1mM
	eZH7BNTHNZ7b/5W26ulrq2x8hIf59tGEZZ7KEhUfvDO2iHrtZNJOMgpThjgVK5ydol3rge
	MWMo4pPqqei7FmSokguY00YHqufCBRw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.45 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434330;
	b=DeSL0N694VPGlCCUk3FRA8SU9lAfnDcLsEYduAQDGHUxsVUFq1vHiruWV/axpgkbWHSIUh
	LQDQqf0Fh9en76C8gnUNftkzKeF0ZH6Qfv1oMK9OdYrEO5olGTi4mCjoUSSgmCj/UKoC0s
	JPJSd9xt8Ef7Cz5JhNfR8dFz99pITic=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id db39fdad40467b0f;
	Thu, 03 Sep 2026 11:18:48 +0000
X-Mizu-Trace-ID: db39fdad40467b0f
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 01/13] gpu: ipu-v3: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:24 +0800
Message-ID: <20260903111836.1777265-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4graaikb89tbnysf4f1xckwyughdbcey
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BF3EB20002
X-Rspam-User: 
X-HE-Tag: 1788434329-702417
X-HE-Meta: U2FsdGVkX18g6+ErOmxbd6Fd6Ft4vwczzs6j7NlW0QIksXS0LjpDfb4yFvpATG6o0+mWkApxVTTCGNXif4dgRvLpp9gh1wKSltE8BRUOfy+iM0J79SNZpcMtD9N4E0pLUwhSv7rc3KMvTBRdSYcgFGHtQgNcXOVLnn4X8P+s+LyWzql4I3TYhZAO8VXVd4AF1BsUaK+4dZK6w5lpBeW4J1X2KUke/zp4evzvA7BFtT97rEldbfPY1DNwe334WQS7Gn/BCqMznnhgAYFM21ol4pPcQXLAE+9gipRS3XQvJzoxR7XGgu/KfPX0Xs6nqjl3keCSYHWYFAjc+YxdApQEbwKNge+LqWB9Bg2dOqvWKl1RNoUucOwxH7Tqp7TJOO7wFv77sZGj9rW+IGMjb/jqW7a3BP3E/KgMcJMAgbPgcx0hIkiDvM6OWuqIw3tZKDDH+Dx6bsgS2Aba8JK4M8Ur0Y5jpG4R/TqnoPlYGHIfMR1rMSVLU6VOpYbqDEheMSUaOBInJZUdlxpo/9CtP4pbVFhq/JZe/QIGfr2QHCEJbgumC3nKq5+eKWb2yN02BfMBL7pN551Me88pTJh1HTm2ijyqXlzGZmA9Xku0rMVRnr6hYEYf8j7sJaS7cdAWpO8wYXXzv+ObcvJAEx59TTYe6xM8SPIbATXySUgJQICtbKg5IdZkymA2HIRVRzKCljOyfXqHDTaAbDR4dlk5Sge0DYy8mCFyJMnQK276VAsclflV77E6AkwsEaD0VHHjYPfHDxFtL7kk2LYlJA7NtGYbVACQ4efHKZ2btYIcARXXp/oIDkh2T1QF2LSuS1kd+7Enfoo0IMv4y6p+cQ+n2ju6eqeZIecN8pCKUSUI9sB1HW0jwp5/5R5G1giSCvsmscA/348afFSGWGAMbmBVPj2K8osW9hObV3wc+sgIIZxHWChBFJxR3Qjn+JTVMtZTcaMhl5rc+xNkvWkESYgBg9A
 JKMma8pT
 H8aLiMPvsJ22aaztK80Ajb5JXuYDy81qL7uOXoJdpZOunYjgR+7dMV+SAWt543FnSZ1YmUOT/ylpga/RbdRM2iq59pFUy1U/vjkh5QPC5fbnloFpenf3D6hsCCear/gdIdNbv+qujQEuwQyh8jB9cR24OTUlwVm7ej2OUdMjDxOic8sMBw8aoy+IaWtYgmGrrwkaIBksxSqXuLoSRsxS7IebxxjFMLCZOHOg3lHoEL7usfZbTQqd6fBI4MDTCbnuiPvTDy3T5giwUXdQxkYCRhkpk8Udh6vol40Fv1ZPxhYhrFoqnuu1iXbrZgcW8pjSeEN1tW+S+GZm5ydo=
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

Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 29b6d36c9bb6..493be4d4b091 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -371,7 +371,7 @@ static int alloc_dma_buf(struct ipu_image_convert_priv *priv,
 {
 	buf->len = PAGE_ALIGN(size);
 	buf->virt = dma_alloc_coherent(priv->ipu->dev, buf->len, &buf->phys,
-				       GFP_DMA | GFP_KERNEL);
+				       GFP_KERNEL);
 	if (!buf->virt) {
 		dev_err(priv->ipu->dev, "failed to alloc dma buffer\n");
 		return -ENOMEM;
-- 
2.54.0


