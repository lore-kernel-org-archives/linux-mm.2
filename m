Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59690C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD486B00A3; Thu,  3 Sep 2026 07:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5376B00A5; Thu,  3 Sep 2026 07:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0B96B00A3; Thu,  3 Sep 2026 07:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4616B00A3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E3E4A43F5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:04 +0000 (UTC)
X-FDA: 85172204208.27.7CBB93E
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC6A38000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434342;
	b=XSRhGvhEKIzWs/6YjSz8wLfXekVXWj9vtVi5ewPcodp6h7ZNfW6bD2PhOdXzDiUAuZUh1U
	idkHtX5MYUBZjGHOmGiLvXCUP2QZ+72eMgf3UD9HQSySlYidJFNIhcrJ0rX1kdbSUUGWIo
	Dge/63znLE10/ZqvuH/WhCD3ePK1wFA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FCI97cvcRjFBTVsXeIiaKtx2eOAXyUg1r7RteMM4GwM=;
	b=fHkA48yb2j/XG1hFbZFlDXfu1qJj7bkDEnPFl18MfDVYTCkgFyyOvFkhtYtqOUc09eq77X
	XcW6l/UORf9zFcmJAO+2oTl91QLRO4fEEYnRBXs4l1efdba/nhXBcmy/YWnzglrZz8yPL6
	FJPR0Xf9PFeNvuPY0VcRcHL+9/GXL8I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c5d2fd294c07e24a;
	Thu, 03 Sep 2026 11:19:01 +0000
X-Mizu-Trace-ID: c5d2fd294c07e24a
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	linux-sound@vger.kernel.org
Subject: [PATCH 03/13] ALSA: n64: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:26 +0800
Message-ID: <20260903111836.1777265-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC6A38000A
X-Stat-Signature: 39z38ax8wjtykqcg1apgfjy6xmjp4u7y
X-HE-Tag: 1788434342-522788
X-HE-Meta: U2FsdGVkX18uX3xoknXutIcMYJDkIVIN85rTT4pp5gpKJOq7Nia+gBcmYGcUs4hu8IE0D/kSmF4QtsBeunWO2E7pY2aDam+bvYYaLBKVHbiBpNoxjHi9dg8wzx5MoDz2eMeoRtK39ZHkilPdQGVObYnMsY6DBESh/+RovfJEeWeZWAwfhJRFHw0nPS48AdvgRYGnIJa/efV5g+qlNYXPquMqgcaUb4haxGPQUUF07z7aI8GxxiU3gn3yUzLC7o0tvMS5rBGt0GaAaF1KGjCKzcNbYKPVxy9UX4g3M8x/Pm8Sp1TPDZUE0XuQkI42oV3PWrz2x/Gfly0a0aYLZjvnh/kTVadXg4zcjWULCDoT6DX2p3wIJKNbgsIqLpDOE7U+ylu1JYEJti0Zy6cpSL+Q89mRQu9j+m2N4j/gXUhNVpgJGEL9NSZkPIs82QxDpkG3MhwvCC0+HtfzpDS91XSLgKcpiTMdn0jS00/3uXTPPXbDkdMcdFDcLqjHSeExjs9hhcvCNTpOl5cuLb6Hvr3DrHye2uFQNZV4wh9kN6yS5pI2WapfnvojR6/DbLUoF0kyBxNmhtz0AjWXQfcQRmS9g0pu8KmecKtRKVr4zMV1yu+xcnCxWQOhO1tJTqOsk1tpD66LOgsu5aCWhW1JkmY7UwsoIWzonXupwDc2CosEHd5A1NIc+CJAQtM1lLfXVNxM/fPDjDmhkrY8t2MRMzgm5DY7UHucs0PVYyipBmdqncCOJ2dM2Jm/BpLQy6qXaHHKRbX2781Q33LtyYgX7OSHqRfeETIa3bQcbWbOC57/OVMtWGbPpWc0U2DQIc1K2K1w0aMJ8ug8dM2SqVtW1y+NsN1zE7J1T2sWcJfHbfJ9hT6VyIJpIMz+Vkk4AQDMrVNT/arcXcX2r5UvNxdlr2AcmaVxuhiNSLpOY0ElnDh8BaBNHaG3ZV0l+9x3Fbub1zLNbVsElgq4pd3mx5T2gI7
 95burTJY
 ahXD24sOlre+wgczVpdKgINjqO6GRGfoBUgnQRIAHWrveGJ6Xw9EY3yydy2SkLCGexizq5y2Q7GMxz7cdXkRynlaEXYW4D3HbG56f/k+fwNaPkea19ZQlb/Kc/P6bWxmgjP9GHpb2YhKzYuPi4j9Ufe2t5bTWm9nPW0lcC5FMfsXCm5vjVChtZ1rAPvnc1KRcoCe6oPdg9BQhfjPCzea5jVa7w4Jow/CKrbCCdyRIasgDBRWAgIIaO6mWVQ4mEdXTixK+cEuI6gWJ8+TgG2FdNl51NBCNO3gYjHxNiEqFEw5hwQGxo5/c/fOQlg==
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

Cc: linux-sound@vger.kernel.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 sound/mips/snd-n64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/mips/snd-n64.c b/sound/mips/snd-n64.c
index f17e63f2ff5a..e2cf9df15d48 100644
--- a/sound/mips/snd-n64.c
+++ b/sound/mips/snd-n64.c
@@ -298,7 +298,7 @@ static int __init n64audio_probe(struct platform_device *pdev)
 	priv->card = card;
 
 	priv->ring_base = dma_alloc_coherent(card->dev, 32 * 1024, &priv->ring_base_dma,
-					     GFP_DMA|GFP_KERNEL);
+					     GFP_KERNEL);
 	if (!priv->ring_base) {
 		err = -ENOMEM;
 		goto fail_card;
-- 
2.54.0


