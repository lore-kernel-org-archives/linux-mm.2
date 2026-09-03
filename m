Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B363C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA216B00A9; Thu,  3 Sep 2026 07:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1246B00AA; Thu,  3 Sep 2026 07:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61F96B00AB; Thu,  3 Sep 2026 07:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A83B06B00A9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39A671A04D2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:34 +0000 (UTC)
X-FDA: 85172205468.06.F0C0982
Received: from mta1.migadu.com (out-111.mta1.migadu.com [95.215.58.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4066F180004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.111 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USt3zBwhaZrZDmrFtIeP+NLPQVJlsmJu6Wi2PGlt4CQ=;
	b=l+DUS0u9IWvLuozLIj/E6m1keZiYXnR0zyvR/okHU4XPbpWj7YFCYLnL7RjbAT8cQbBuyC
	3aeu3MDGLfiqk8/E7dFT5PZh9ULJz/sjskiGmGnFy40FSmrMHrNZlmMUPl46q+5M0KwZVl
	mcav8S3B+WsQvPHEQTuFNoPuvLpZM/w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.111 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434372;
	b=hdBK3AWTW9tG00l6YRt7T+YEheuXTMtbBz3O7shrwM1bMcCkCop0h10tpKkhsorFieBHzk
	33zmqKEIyUnlsnkrtyTga46mGSiPeczqkUyvUfj/Dv21xKEYIGOx4+WGCGBmRq2CfkpA4b
	Y4aZYj3kv7QuJXIIdkHdyS2DKwMeLZc=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 23d713486fe96fd9;
	Thu, 03 Sep 2026 11:19:31 +0000
X-Mizu-Trace-ID: 23d713486fe96fd9
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	linux-staging@lists.linux.dev
Subject: [PATCH 08/13] media: staging: imx: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:31 +0800
Message-ID: <20260903111836.1777265-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zfufc51u9obzh65xirb47dfihe3qac5c
X-Rspamd-Queue-Id: 4066F180004
X-HE-Tag: 1788434372-219685
X-HE-Meta: U2FsdGVkX19l0llAfOmZ626DQerv+HyV9FjPdhbsaeV9sAteDQlrtgM/EAElAdxIOeFbEqWEf1NsGiwReq4cdhzCBSfowiekgckf26LfUY8nZZWCE1ExF76sLyQeg/i4XieTQd8NP7Xi4huAdILef/mWb/83X1BDSekQkfQUgbHboVd1JmUs/O+tnR2p5NCUV6VPm5hZx42e7DRNCItZxXT1Oioklmn/EIp4egzgDixinlnKnVvairoj40hpzQCIlkqrsf5wk+kFbi4aYTb+JgD2IAmlQEWn6fhTRS3bk1nyB8+3++3Dk7CpMlpiii2F4vXU3Re+4HAsK8p7suT7YpwQ3E0uyyKUV0e0YXTWqcdyFan2+jJKlO/gjyde8vMjXdb6ep2fNuYpR3LxTJNwVdUE9TTw3NGoYSB7lnOBRdI83a904AooVyaMCt1dQuMwwuZhuRJG3GuTYCg52P69VJjJNt8G6xeogu0Wa9VxqjOaSIpOMdXIsMro6yI7HpY4ljFPgHUE2uycpdSa9wgTb0msNwmJhILweUCSgm4MFAG068XFY1bawpy7zGxqUSn3ju263u3UqB07o0e9CIJJsaBphxFFVnEwEGRbaXkugS+R+6zEDD7+v1SnwQh29C1TMJv6cz9/hvL5cFFk51M3X316H+cy5HpUNH/VMp6TMXNZebXRob2QEbodD2SprOkSqMQnfZhkp6GkU1rcQCkwnur9OI2xZItKSJFnl7iVYhwH2SLhQc3/ndHePkp7l/kLSoo3HXTyB3EKxvMBh61NETySZS+2YCf2Rd91LUVrEqyqtKa85wIiZlNt6DjexQABxaOwPAgEdG/vg5V9+88f2ncKRXNkFelFkqfPa+1QwxuATk4PDU3dI0FEva/0EKAG+z4odALsPE2e+nCG4vlvDkGVYEgagmo5BHr1aHDQNQ0WB2J9z4IrLhLRLurALoDI5dUF++ScvlJ/H7obqkl
 wyPBiiFG
 8BwZl6TmfrQGbRL6G2PxwFMYR9x98nq2KBNGaBPXKeuj5Z6fLeEVpYNJQvMVWUQI85k+4YgWuBwxUZ+Yv6ZGUpvM+lrdHtzlKub4N39nzzRgU8MMGwCi+OtPsZv26DEYbljPV3HvXqNFR8F17UhNwXMn2j2t8SI1JaNf836KjLN3McKv6uFemJwuou8FRVyqneA0Obb0cHe/9A2kmiKVNIVNkr7sim95/uagz92D8DlmP34GWoqGYzG/PjgZ1gqrtv9vQjTHplFY7SAE=
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

Cc: linux-staging@lists.linux.dev
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/staging/media/imx/imx-media-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index f119477cac6b..7bdcb88a686b 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -588,7 +588,7 @@ int imx_media_alloc_dma_buf(struct device *dev,
 
 	buf->len = PAGE_ALIGN(size);
 	buf->virt = dma_alloc_coherent(dev, buf->len, &buf->phys,
-				       GFP_DMA | GFP_KERNEL);
+				       GFP_KERNEL);
 	if (!buf->virt)
 		return -ENOMEM;
 
-- 
2.54.0


