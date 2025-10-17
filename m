Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BE0CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 06:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90A888E0032; Fri, 17 Oct 2025 02:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E20F8E0002; Fri, 17 Oct 2025 02:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F83F8E0032; Fri, 17 Oct 2025 02:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6E28E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:33:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31A6E13B3E9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:33:59 +0000 (UTC)
X-FDA: 84006640998.25.DAFC86D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8813A1C0005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:33:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kgXwThbl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760682837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ML0ZgsQwKly9k9OLN9ariPKzCdeQwaMi+RURL/74y5o=;
	b=SGTb3ANS4v1CmMmecRG+7HtGzuNhQT0yP5lQb2qtnbnHhu97yc7suIaeBDiqdJAaw6HhQ1
	ie1muDKkScrAT9c6yoRCc7U/hZgS8F3sip3cfAalPl28gMBmh33v/k9QCxeaiYatSMfubG
	HjU7cIMnnEX8aNtxdbpxPgVfDPmX/fQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kgXwThbl;
	spf=none (imf18.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760682837; a=rsa-sha256;
	cv=none;
	b=dWe9OiwtwTjGC3/aWOuf4sliWftHOQGoGcDSfyFGjKqe2h/DMTOF5QRlpeby2Yo6hJQTOG
	lX82J1QIYKLHXFmD2vCDkUWE/9IN69GzrwGvyrTzpirhjk5qf7jZSoT9Isi3w2SgbzHQmW
	2rJKzPn8RSUPshnCHapetZKDDHbjuns=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ML0ZgsQwKly9k9OLN9ariPKzCdeQwaMi+RURL/74y5o=; b=kgXwThblotIMu/PlIEfFDKXZfo
	K95mDhvWqtDdyERtA/kL/z+tdlffM6N8LIh88s49u3HkUN//18g2gwifMWr/9OLicGxqj94QKXQby
	zKeSAFtwAkReclA4mMI8OZwxnOHpbXdSYVqBf38EmZy5+KdM5Y8/88abcL2lfrknINoN2BCEYl4Ko
	y36VGJpN+dporTSjGe3LQGDS+0xxuWxfrZMUdS1l8dp24dR6D932C8DCnVv0AoDH1j0E1YF/VdNL9
	pnoI2wt49ziVh6Wkfy872ZsRyFO2x/UTllIrX8rgdnhy1QTt8qP8o9PCeO2YkNmnYBMv137O+AE5L
	gBDRqq8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9e2D-00000006nxh-02Mg;
	Fri, 17 Oct 2025 06:33:53 +0000
Date: Thu, 16 Oct 2025 23:33:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <aPHjUP7pdIXuEPIq@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: pmoh9fg936u94iedykz5jusprkhsir9r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8813A1C0005
X-HE-Tag: 1760682837-722248
X-HE-Meta: U2FsdGVkX182IrH9VJ8A0JAauomKSFSL1Ivd04P05pdRHYjBTa7mlglY6af6X3fwgQS6ykorWCzoD3dFu5Yu2A9sYedCaD8syrwRXh086mTHg3qtWowc38u7WITRmBJYGWf4AH2LCOgZ4dFyN/8fgfyid19zyDKnOCbxK4vBDsrb3QHtYd3i5DZIkf6vqtoWQsuZlFGBmIN6rnIIXWQPhuxPqBd3rQ2a+fiDyl9NXGsK7PUlt8ulGVgvC9OgC9ONDjB2J0El+cto5lQAxKQs+rQYsCL1VEWUoGTGd34biNE4hAOMosdwvpphw7k9Gf/jo60q5/NLcd6rnuvfSbbuEcP6R6oQDwlq1M854i1ACJ3MhKE7tMWdABlyu1coYFz772enBPV/2gD3AkT7+44kiLKdzIgXUa5b8CnkWqNYp97mplIbttvBaBBu7xYkEoBrGZ5mDPbq14s0dTGZg/h8NWHq8S4kE3xe6GlEiIwyxW75q/s7Yr7G+hcMRTRBM3LhCAaDbkpo3kSExw4XDCHWl2NixBkHzcTF6oUek4d60LvLC0rTEhlFlaSFyyLOzNDWtog0LWThL3lOAGNw5oG+1R4LUBCwbdzekTEBcduxyGDnYVse8oGVIOgAxRnF0Pss6eN1U1f+acS6vAyDykq2gh/PbQNpu7RiqQWCm5fnny5GaPrW8pQrD0SINfeDX1Af2vnaP5FKVNOqYaFGlIM9G6OGNB3PNTFTgasBC60UdB177fLGRx1adTc3VQya9DFs7vfxwBiBTvtrM/WRqJuGkB8hoZhKcYK3rYKmgcrfhI3h987GomJ4upHCIHyMKJ1tWy/Q1JoiRNtvKwG3Xgrqr86wE3TSIcBLXE2KT364kFST3FtcZpU8cxc/bjBt+ekbLtfpTEM3saeNxDuukjmyX+k6NZy8IRXSf9r0biZOip+EcQfdmR+N6EBFmhGuAZCBCfUYAX84aXOvEuUXr4x
 G3L+sG1v
 x12MZuEw+roylsZ5Eb1y0FJBFtrUHqX4rzGVgK6m+slXIKHezAjN69yrc1RRfMitEsGYFkHLcQ50cXXDrkOv2QoPEGZQIwsQoAvUTYnc9OT7bF5m4Xi0UarWX142NAdDpzw23HwFcReOYcofTAmeQBdfyH0rxcDiljYGYXCYE9iewbhZ7zK1XP0coREhpKvai/0Ps6lEMHI1k33sqNR3jfN/5yNjnm5Ahx0zcIWbcli00AFBsgoaezOEwtEMGJelDIhMVvm3YdDX43ZjbbPja7l1bR3G7zW0z+3DY+kLD46usFPWPkc3eq9UGGQm8SnC5uf/EE6iU8I6w5SEarUZEHrfTdPVkelmPcBd7IJGi2ppLRnJMJj1ZYKWTP/np7Qdwb6V1feLxxPT3+f86OoznCQHd0w5wnThfs2g1huWqfwexExWaeJZMinMmGitsMyG0CbE6dJeL5PtMs9x2jDeqoz1N5mCd3FEsYMm3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add support for exporting PCI device MMIO regions through dma-buf,
> enabling safe sharing of non-struct page memory with controlled
> lifetime management. This allows RDMA and other subsystems to import
> dma-buf FDs and build them into memory regions for PCI P2P operations.
> 
> The implementation provides a revocable attachment mechanism using
> dma-buf move operations. MMIO regions are normally pinned as BARs
> don't change physical addresses, but access is revoked when the VFIO
> device is closed or a PCI reset is issued. This ensures kernel
> self-defense against potentially hostile userspace.

This still completely fails to explain why you think that it actually
is safe without the proper pgmap handling.


