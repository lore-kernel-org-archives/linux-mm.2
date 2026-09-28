Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619AFC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E3B6B0088; Mon, 28 Sep 2026 03:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE3E6B0093; Mon, 28 Sep 2026 03:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504806B0095; Mon, 28 Sep 2026 03:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3180F6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:36:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBED21C0170
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:36:55 +0000 (UTC)
X-FDA: 85262364390.29.27ED612
Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	by imf27.hostedemail.com (Postfix) with ESMTP id B911640005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:36:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fvrofUx8;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.57 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790581014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gi+W71iHEAlreIXgft1E9q5/pSVjDWIoAcMbNl/XfrM=;
	b=8joHHr34d5hLwAyxEyPamtEizhpjNDiXRPEZ+SpiXIYqc2j8GQJBkskGUCsWaYGHFSidc+
	LE3EduISYbjM+0OWXrtHHW8HG5a2uVqwX8OoabJ/V2ffG5Uj+n2s7y+qfR/QEthtdTx6cW
	5V9r+qTKQiZZehXBuLA1LH0nPEQHlF0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fvrofUx8;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.57 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790581014;
	b=OrP8v8UZWk397Yqv7/8Sq2nTsI5tyjEkOdNjHIOF71aCtXEaVmm5E4Bt/svHoUSaZtA9xR
	9ykL74GUejVJdHz/+bsDW5Radc51Z0KC+5ombK7a5JNkM51z+FVt30dXqEuxprpfSfaCmi
	9QTIUMh1g3b1lNQNSe6RxH8x9F0uYjY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iby2xEQRX3opF/gvV/AKhgu7g08sreTCdoHrJEFsvxc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790581012; v=1; x=1791185812;
 b=fvrofUx88l6rqMyKuuVaKntIIolf2sUONkgZ5+eCj3cRsr3sT965610Wc8AKI8Pj8JLCGU7j
 hZ9HYnQpoXns33F/2ZSWU5OpesxvQ1cvjYgYuCTxhs7fXTftdfU99wVc3dx91/T2d7AsE8s3GJ6
 6cFuNzdskgGFUDfPAKsC5Sw4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 44c8f45e8d3b3b77;
	Mon, 28 Sep 2026 07:36:52 +0000
X-Mizu-Trace-ID: 44c8f45e8d3b3b77
X-Migadu-Flow: FLOW_OUT
Date: Mon, 28 Sep 2026 15:36:47 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baoquan He <hebaoquan@kylinos.cn>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, hch@lst.de, harry@kernel.org
Subject: Re: [PATCH 00/13] Don't use GFP_DMA when calling dma_alloc_coherent
Message-ID: <aroZD9TBlOKoprQm@MiWiFi-R3L-srv>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B911640005
X-Stat-Signature: qeswamwfhg83e1hskabu3ud94sc18ge8
X-Rspam-User: 
X-HE-Tag: 1790581013-938417
X-HE-Meta: U2FsdGVkX1/ZSU3e6MQeUbixix4t7GvcxfW3M5De/oMzvLGDRu4jvBfGLM1MCimtC60zz4dZ4NbV1qhT4dABVVAaHIpHJjkU2akxN6vsnI1GQn+QtWbu4mG0ZgOBvbvwmWC74wCwQCNxNYyeoCz+qBTaSKEOeIKqokWI0d5NxQvGJcWKc8EeyuWtOhPCfXaGalRpuAhaamsLJdesyBWOt8UjDnbClI4klUjh6U8KrtPl6fI1bfMsbxH/0k3JfudaKbwmzXJoqMp9JJnutoYFR3W6WPn4c1go526DZvIslsCpug2njWQpHolJa152mrD1i5uwBT9EF2qzxCm555piiydHF6G1gAYPDKaZOql8WBAaVfVP6IGjVVnrfAdriZKm7tHqVs+Rs6G8raAFgXqoIudiCzcOGVrOHl6J1XI8AzIfJwC19FOMJ6Xr9bJK74mrMMyqO4nasMQ9NJxh5TPD6md9ljaI3TpN1ELcQTw4DeQ2fhvnbm1TvQtnnDO3X69cdmqZFGtpSjBec0Z+7WCI8ynz234Qsf0ODfNkrLBIU4JMZV1cpfo7e1BfzZzJS7wS7YSSRm54LrsErDlfVdLgRlMXzKUI95KHaqva6HtGvzizTanovEF7NNMaD5xKGetOsiG0tp1ucUO1Sy7jr9ICoERT/bvc2nWDIKzWY39G1NqCSW/235bh4sX8ec0TUiDu7Fj9Iu64zhNaivoq8bFSUPdo6fw1ZQdBxDD57MQW2+p/+YQou4E0bWOGSH1Bz5186/kOdrN1w1js+e+Q68Cvom7gyuz38ghRSR1WYNXqh42c02FOdGrHtxd7Y02mfaK3XGEzVKJgqTbz00ExK2aou4ueME1mPicCS3Nqu3IQFd2pMtFH0tCrA1IZAvZ5hJiXRVIqVuVMaRmZs/c2FCiug9Q7OTkiBVRvZY+tlG58qjqAr1U1WU8WTP/2unVtiqV/jcc7mgJBigLJykt1C/H
 fFGUCYZi
 R+hwaD63EL8U0P8Co9VEpfrZQMqZSCE8NIcwUz7rUujdZ/TI7vVrS0fGNPjNw0nFpflBJ4s36qGD03odMzqEEwq1CiqSh/DK2GP/j9pKFhEGvj7OmyuJO21Wd5oGyfDCGjdAcFvvJWx5x/lE4d/sme9SDA8nM/eflcJRP8QRsB0+ZqT9l6H1Rfx7ClKDqJmDLbWlp9STSueBCkhU48T81vnEBAd/luhJSMhMP/vllrPYZS/hxjn5zGHBdWHMBtcjVSvrQg3EhNK7SrBGggM3nJ/w5eRV0Af+VHqRpyZKwrm2VLkkfR4030GMnQClif6QPOaxcRm+/7uzJwq6gIVwiiv8t1xqvlNQhHx8MdT6Kee84OkBsw87qVVbeQUGTOXE0LhLIuoD/e4F1ofMBJM9qoYXZ/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 09/03/26 at 07:18pm, Baoquan He wrote:
> This series picks up the first part of an earlier cleanup series [1] that
> was prepared back in the year of 2022, but for various reasons never made
> it merged and has been sitting in a local tree since then. This subset
> only touches the call sites where GFP_DMA is passed to dma_alloc_coherent()
> (and its dma_alloc_wc()/dmam_alloc_coherent() variants), which is the most
> self-contained and least risky slice of that work.
> 
> That GFP_DMA is simply redundant here: the DMA API derives the allocation
> zone from the device's coherent_dma_mask (together with bus_dma_limit) and
> ignores the GFP_DMA flag passed by the caller. 
> 
> Removing the redundant GFP_DMA won't harm anything, while keeps it from
> being blindly copied into new code.

Gentle ping!

Wondering if Andrew can help take this, or anyone else I can add this to
ask for help.

Thanks
Baoquan

> 
> [1]
> [PATCH 00/22] Don't use kmalloc() with GFP_DMA
> https://lore.kernel.org/all/20220219005221.634-1-bhe@redhat.com/T/#u
> 
> 
> Baoquan He (13):
>   gpu: ipu-v3: Don't use GFP_DMA when calling dma_alloc_coherent()
>   drm/sti: Don't use GFP_DMA when calling dma_alloc_wc()
>   ALSA: n64: Don't use GFP_DMA when calling dma_alloc_coherent()
>   spi: spi-ti-qspi: Don't use GFP_DMA when calling dma_alloc_coherent()
>   fbdev: fsl-diu-fb: Don't use GFP_DMA when calling
>     dmam_alloc_coherent()
>   usb: gadget: lpc32xx_udc: Don't use GFP_DMA when calling
>     dma_alloc_coherent()
>   usb: cdns3: Don't use GFP_DMA when calling dma_alloc_coherent()
>   media: staging: imx: Don't use GFP_DMA when calling
>     dma_alloc_coherent()
>   spi: atmel: Don't use GFP_DMA when calling dma_alloc_coherent()
>   media: imx7-media-csi: Don't use GFP_DMA when calling
>     dma_alloc_coherent()
>   media: nxp: imx8-isi: Don't use GFP_DMA when calling
>     dma_alloc_coherent()
>   mtd: rawnand: gpmi: Don't use GFP_DMA when calling
>     dma_alloc_coherent()
>   usb: cdns2: Don't use GFP_DMA when calling dma_alloc_coherent()
> 
>  drivers/gpu/drm/sti/sti_cursor.c                     | 4 ++--
>  drivers/gpu/drm/sti/sti_hqvdp.c                      | 2 +-
>  drivers/gpu/ipu-v3/ipu-image-convert.c               | 2 +-
>  drivers/media/platform/nxp/imx7-media-csi.c          | 2 +-
>  drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c | 2 +-
>  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c           | 2 +-
>  drivers/spi/spi-atmel.c                              | 4 ++--
>  drivers/spi/spi-ti-qspi.c                            | 2 +-
>  drivers/staging/media/imx/imx-media-utils.c          | 2 +-
>  drivers/usb/cdns3/cdns3-gadget.c                     | 2 +-
>  drivers/usb/gadget/udc/cdns2/cdns2-gadget.c          | 2 +-
>  drivers/usb/gadget/udc/lpc32xx_udc.c                 | 2 +-
>  drivers/video/fbdev/fsl-diu-fb.c                     | 2 +-
>  sound/mips/snd-n64.c                                 | 2 +-
>  14 files changed, 16 insertions(+), 16 deletions(-)
> 
> -- 
> 2.54.0
> 
> 

