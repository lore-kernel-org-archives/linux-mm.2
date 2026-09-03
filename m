Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B07DC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D206B008A; Thu,  3 Sep 2026 07:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DD916B00A1; Thu,  3 Sep 2026 07:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36566B00A2; Thu,  3 Sep 2026 07:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D25556B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:18:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D82FC04DF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:18:47 +0000 (UTC)
X-FDA: 85172203494.01.F1F267C
Received: from mta1.migadu.com (out-57.mta1.migadu.com [95.215.58.57])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2449B180004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:18:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.57 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434325;
	b=s405/NtwJuzmNNpijQOE0glr4INaWEzQxXpwyL040EDckxT94kmo/Xlggc4jzoTnwHrtWa
	DKW3tY2Et9NRvaFDUyahE4vHRom4meKBcQWZcnDfIOwUEJbGyrApA9YhPn8UB1609fAohP
	J64fONHE0JdeoB1SOxIv6frDEBsCIyE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.57 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=xCghnVPoFxx89RZNNA5adprtEWnTIFn/XBN17qrOXTM=;
	b=Zh8Bbsghf78xgGeH6Tn0uM1leoAlHZEK4WqUDWdY4BWqJz9UHE7ugSAiWhfo7C30AUGo+R
	RPFPTR4TDwVu8LfoMC0GhiGhobXCHS+OnKGIGrbapJmbhx0xgKkeJapTxn5OyLgnWE9JB0
	FbPzxmUTgt8GhmEzzuCC+qrjlaTmZgM=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2e531fa6291cf84b;
	Thu, 03 Sep 2026 11:18:43 +0000
X-Mizu-Trace-ID: 2e531fa6291cf84b
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 00/13] Don't use GFP_DMA when calling dma_alloc_coherent
Date: Thu,  3 Sep 2026 19:18:23 +0800
Message-ID: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2449B180004
X-Stat-Signature: zswxo4cybcyciz9nfyjucwk1joz74cuq
X-Rspam-User: 
X-HE-Tag: 1788434324-133649
X-HE-Meta: U2FsdGVkX18zuwThKc91st3kYO5TO4UdGtq0UZw9Pf4YzUwoeZnmdBADIw/tjbOzR+E8l50rbnWEoVMRH4Kj98MahonqinOS2ka4BCBVifdzPwDm2Ehi/0AtpRs1g1dVXVIDhEZFVFYKroZRYRrzv8nBLKM4zpca2q/d0J+XR9umlaeugnCuOmd1C0+rkW6tbtpcbeB9+ZIitCJ+QmxAiyGctM5ZXYn5GUPoL2GjfzoCxI3aUNEAooK9Wje3/6STvpZcxf/dCLBxCwFnKa+Xng6ffYL6gdKWdLBqclHdx+LHXftJ/Ty51hP+Q7vzKC2jBlcJ92xbz05zXPz48fOJGpmN1DDXcEWHv6EaOO34cIbg9YLYkv8y0OSOqwK6chNefXNMZAAPTIQ5RT8wSNlTfqeHLcrloRdWkfs8xrii0bJ1+56iXFqYNI36TYcmYCuGg0LdylVQNYoJ9Tw+nw8oApKyUqJ9fFjuczXqQMmK2xmGtnAYXFiQy46K5D8ubEwGR4AQdSrj4updbGN5M9obWZmeDrroFWbVF4756HHLJeUina0A4A6/auyJEFMvR/vbU76LpcbEU16AN85oLMueCmvRrv/89iyrXvaAgmp+OCSYBenXMxJxy1oAyOVejmDI5es4kSIaGzX2+LrztmUKxbPhzwHiYpTLipd3D0l8ehdubrGJFmmZ43tI6KwD7MqLnbkmkvwnQbVHckaDIzSeuoAfpuxZL/Mi+tDznBAP401fMrRJcVlLb6jWQFrbYmiHQieaQBGrdLRm/kHnNsIFe3ZuYuaiMsutXev0rl5f2YnXyDx3QhG4Eb34sZQpeM2Dnfw6S9hkdGMc6JrctUzw45mFY9MfGJ6EIlnU/+X7Yq0Wsk0NvbV+pojMbpnkoPMJNQjVv8ciEFtnJ4exTeRW7yJrTwRVR+6xYoo1e3wLSJdCGD8ce4t3eUNntFMOjvNTIyBJRl0CIdHWQ5+ElLE
 rbJ/ZAW4
 JuviY7sFswuEYHJtuzB4FpJggOvQXM4pTophYZ+vV6K5GuKBQqZLhGF2xB6gW01upYbO+n6uqs6pxMTxFyGKQxTFIYKZfiI6bO5//gdqLzSvRWyv9NIlCa3mio7anoZIRE9Z2kIAvueJvT+hqHBmbi2iIe1FxXyLa9pu5zkghEpJfX6m28jVUhTi2Tha695SpWd3DF3St4AyqE42rcAwtbGhcfZqZtCSqUrNFcL530VSjrsauWhqv2sqfONw2ocVxDy9W0lxRT1wXpDK7D5rYGx8UOqjK4uWNC/ePyPQ8w9v9NBgNf52MA+93wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series picks up the first part of an earlier cleanup series [1] that
was prepared back in the year of 2022, but for various reasons never made
it merged and has been sitting in a local tree since then. This subset
only touches the call sites where GFP_DMA is passed to dma_alloc_coherent()
(and its dma_alloc_wc()/dmam_alloc_coherent() variants), which is the most
self-contained and least risky slice of that work.

That GFP_DMA is simply redundant here: the DMA API derives the allocation
zone from the device's coherent_dma_mask (together with bus_dma_limit) and
ignores the GFP_DMA flag passed by the caller. 

Removing the redundant GFP_DMA won't harm anything, while keeps it from
being blindly copied into new code.

[1]
[PATCH 00/22] Don't use kmalloc() with GFP_DMA
https://lore.kernel.org/all/20220219005221.634-1-bhe@redhat.com/T/#u


Baoquan He (13):
  gpu: ipu-v3: Don't use GFP_DMA when calling dma_alloc_coherent()
  drm/sti: Don't use GFP_DMA when calling dma_alloc_wc()
  ALSA: n64: Don't use GFP_DMA when calling dma_alloc_coherent()
  spi: spi-ti-qspi: Don't use GFP_DMA when calling dma_alloc_coherent()
  fbdev: fsl-diu-fb: Don't use GFP_DMA when calling
    dmam_alloc_coherent()
  usb: gadget: lpc32xx_udc: Don't use GFP_DMA when calling
    dma_alloc_coherent()
  usb: cdns3: Don't use GFP_DMA when calling dma_alloc_coherent()
  media: staging: imx: Don't use GFP_DMA when calling
    dma_alloc_coherent()
  spi: atmel: Don't use GFP_DMA when calling dma_alloc_coherent()
  media: imx7-media-csi: Don't use GFP_DMA when calling
    dma_alloc_coherent()
  media: nxp: imx8-isi: Don't use GFP_DMA when calling
    dma_alloc_coherent()
  mtd: rawnand: gpmi: Don't use GFP_DMA when calling
    dma_alloc_coherent()
  usb: cdns2: Don't use GFP_DMA when calling dma_alloc_coherent()

 drivers/gpu/drm/sti/sti_cursor.c                     | 4 ++--
 drivers/gpu/drm/sti/sti_hqvdp.c                      | 2 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c               | 2 +-
 drivers/media/platform/nxp/imx7-media-csi.c          | 2 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c | 2 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c           | 2 +-
 drivers/spi/spi-atmel.c                              | 4 ++--
 drivers/spi/spi-ti-qspi.c                            | 2 +-
 drivers/staging/media/imx/imx-media-utils.c          | 2 +-
 drivers/usb/cdns3/cdns3-gadget.c                     | 2 +-
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.c          | 2 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c                 | 2 +-
 drivers/video/fbdev/fsl-diu-fb.c                     | 2 +-
 sound/mips/snd-n64.c                                 | 2 +-
 14 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.54.0


