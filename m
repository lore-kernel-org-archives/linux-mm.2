Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B64E5C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41556B00BA; Thu,  3 Sep 2026 07:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2176B00BD; Thu,  3 Sep 2026 07:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F606B00BE; Thu,  3 Sep 2026 07:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 794B06B00BA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 016ADA4581
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:54 +0000 (UTC)
X-FDA: 85172206350.24.CB6B238
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25726A0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3COOe4szmrJDcTCOQc/MM7UXEHDZV78xW5uS41sd3c=;
	b=gdl4xL+1sGeFqKRzeF74N70uCJSAnNEmSN4SLuQ2vuvcs0uAI34+kqvu4gsgDcC3N6kgw2
	f8bDlUUjFPzRCKolHSIYvYZPtXG8+CCL/ymeTWYIcaMKHlmgZkjWwGZAgPOf3cEBuOiEng
	i0eYBN/KIZ2SjjHiX61TzvSkIN9T91g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434393;
	b=vlmsyKkpcsImH5nDGpuLk8NFh1mpqEcSwMDc5lvlZN7XW795jQfDgeGT9WytfVKsBKgv77
	OivW9H/OFau8ZdIEqUC2UVy5FXWN06mJEWyVQ5v3nWhBGli0vJTw8R8TxY0XOaiHI2A+bc
	TGFzm02xFc9LJ6doXMHoejt4GK07qoE=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c7b7b7d9b31ed531;
	Thu, 03 Sep 2026 11:19:51 +0000
X-Mizu-Trace-ID: c7b7b7d9b31ed531
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	imx@lists.linux.dev
Subject: [PATCH 11/13] media: nxp: imx8-isi: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:34 +0800
Message-ID: <20260903111836.1777265-12-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4hbs3p41bpcgc8fqd7ru84xuac9ysskc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25726A0004
X-Rspam-User: 
X-HE-Tag: 1788434392-470495
X-HE-Meta: U2FsdGVkX1/ejcnKjyfpIzssYLEsp6bC35lU+L/ARXGnOWqYrj64zQKEDuuCUGqazvV7Ip10Lo3Y6ONSqzOukPWXpicHQthFgJlYaPl+8ZKn3zDYF9VX+Qm0fT3fFfS3nUJeJiCmWMGcvR8p0c6Z/32qMkBgqXEOy/steibe+bGtpZgxY1MvJ6TG7LscHzkLEM30DiUE/7K99vn4C3L4wh1HGufFdXHHkVam/WPn4SrMaMqDCprzYKHQgOqq3easnbDOOKnrxy96ev4uOQbIb/FkMuWnYwq96yVVaZbIC3bdVZjoDCmB03n9wbAUQwhx9TECgIsDSq98ZF3meVNG7h3QhWL/qQNZohcpJWZFcX5I4GGfdT2jhiGb1Y/X/Wz20NWBtaSZ+Bc8gJx5jfQ0olGe+n6sMXNRZuZAAP3dXHfXUk4GzZzR+qKd/bNXJjhN61lcjEaliLW9zlQ9/iLsWHBsVWoDvOycSbH4VNWi1nhzQvg5TEjRZ1aQTe92CzfHO2RoraFLMdwv+3rJ13Q85Pj1D8JVwPr5J+Idn7sUEH1CuyLIVm3y4bReJEJxUgwDZGMzbvrOehVn0QHh4O4dUu8NbrPUFgp6hMt1iYhtxdx9q6X281ZEvp97Feww8LXYRokiOTAoSWvx8GPC8wWcI7mFjR/oe8sZ4++NIKLW22sd2HSQpMdNulA+OqZjizcND8W6DUWcweWovh+37ROhCFOH1/Ni1oa5kRwYXvJwZe9kGTqQBDn1imdZwo2nI5zY+F1+Y3mo/R6Q+AbQiheCC6HB5DzcRZW/CTll/BDJ5BCilR41ZTWGWAchK0vdwi0NMQ2PDJzHRi3bxVZu3CORfPWHlCxRBjpmaZ3pQB6IM2ulDeoGoZb2vNcn8rGbpDYKCp0Hs7ZfAV9UMwa0uG23JqmCKWdwJFiJnx4YEus7wiXveX/Duc9jddsoZu/YmwPT4SyMEJaQS/ZTF8HPwsz
 OeFdZjEo
 YaWYImmdfQM9CwkgNQMBR5jzLIO0+7G4K9dvZhETNDrb/FAZvLAO7Xn5cfGv7dFLDe/zkykr2kXcqHncQNKJP2fHZVUJohSZqEHdVDVDmTkOg5TMUTtFo+bkLvBfpyU1iehFYwFvf0R8XZWgFXe4jJfKtn6e7wLEaAceJxMrIdE/9hQt/7io+V1baqGS++gncSGT3710Ow5yY26TuxzLBsx1xnqj8TXWZGjtFmlVshnT3LevLa/Sy6PF5TEuCKuMixRL1/Eju46TsTJA=
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
 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
index f45c2aae59ce..fc907d357149 100644
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
@@ -773,7 +773,7 @@ static int mxc_isi_video_alloc_discard_buffers(struct mxc_isi_video *video)
 
 		buf->size = PAGE_ALIGN(video->pix.plane_fmt[i].sizeimage);
 		buf->addr = dma_alloc_coherent(video->pipe->isi->dev, buf->size,
-					       &buf->dma, GFP_DMA | GFP_KERNEL);
+					       &buf->dma, GFP_KERNEL);
 		if (!buf->addr) {
 			mxc_isi_video_free_discard_buffers(video);
 			return -ENOMEM;
-- 
2.54.0


