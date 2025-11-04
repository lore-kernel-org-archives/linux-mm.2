Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B27ACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 07:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8335D8E00F0; Tue,  4 Nov 2025 02:00:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3C98E00E7; Tue,  4 Nov 2025 02:00:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2F68E00F0; Tue,  4 Nov 2025 02:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 588F98E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:00:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED9C5888E1
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:00:32 +0000 (UTC)
X-FDA: 84072026304.23.276DE70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B4B5140009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:00:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I1UEY/F8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762239631; a=rsa-sha256;
	cv=none;
	b=uUT599KxtDkDGgF6yWVs8HZHLM7K3yfEn6/MQnVdgruNEB0K2RaC5+SRiBlF889wNKzkVa
	UYUVNa6fW/y6jc3bBWjKNwpGRwRutVr11ZB6PBFjEPnHDXlSghQ+mCnoiYJOcHlkGJ9pC7
	CNVdDCVS2okrw3RDOml5hadbHBnnWek=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I1UEY/F8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762239631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVZBP+1TEb6s+S14NHo8ZefgFsL6be0T2qBcGKSJx28=;
	b=T1LLx1S/pXIlv+YTWDhdxsKrwZNmO7ntv+4BFpCyuNQIMnsXqWXIdSLsq+inWhDzwagaK2
	gI7YPAZIfLSRkesFrDKHv207hmxJcGiSysT1MN1wyvhG8KIeSoiWRMSQ52+5QbCmcwjPfN
	GlSONTYcTtzyINCiwxkJe4bJ7cn+CPc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EE2943791;
	Tue,  4 Nov 2025 07:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C40EC4CEF7;
	Tue,  4 Nov 2025 07:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762239630;
	bh=4X+6t70DXpoh2T+5EieuiIaGNQ+Nx/11qPV6DRFYJmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I1UEY/F8kb6rmfO1N8znpDwknPo+zoeYokqXc5isZjuBzW2kwNIyURNneL551ILHq
	 xB1qlT1GwIRyPrqploIY1BSnrb/M+gayul0auOGaYIzVZ5ipDhkzhnPwCHrtS0f6BC
	 z5t1VvB9oLCq/rFMCgCk9VhSiEJuSXID8okNRaVWmbtPOK+n28WqZyhoHpfWmronvf
	 FcGjEPq4VK6Yo+LBMfOfTVdislK0QSciIeNRcwvKA5aNqAeghvNKt/yYcDiNo2g9fQ
	 ijAwMsISbHre8xNCfIwmhQpHnPPoDWGxgBNbI3zl0/Lwh8StDazLf/AgskMUfBm9kx
	 ZlGWIVygzFi3w==
Date: Tue, 4 Nov 2025 09:00:21 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jens Axboe <axboe@kernel.dk>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251104070021.GC50752@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
X-Rspamd-Queue-Id: 3B4B5140009
X-Rspamd-Server: rspam07
X-Stat-Signature: qbcjhxo8g1ohdw6rotzj39oit8i53cma
X-Rspam-User: 
X-HE-Tag: 1762239631-721718
X-HE-Meta: U2FsdGVkX1/ms9Bou4YEc3sJcl3oronnaU9mArrfhvp51meP/H8Yl429OYqjNgnkcpR0y01mRu3uyXkSnP15pCE07RpW5dFmj/HduuRkESpLN535z7nOd+nU+wusJ4qK/k26NeZHOI3xU+ILxcU3EpBEciUmzz1gsB/iehv927fLiRs9vIthpUsuIolOQKT2QsCu2orpGmnYVTNz/Y90xiDTn7vT3Tgi04ASMKArZXIVZHOaoFI0qILkXTmAEdASx3dvJ0jzeHMkGLvSAYkKtehFQ9ND/3cBVvTliUvYbux9v/i+dI4nAN/LrAccovjzOBMLCOpfuU/vREtVjkV2xPACwDBq8PSJiHdis5jBqLTxCh1e4ohH963RNjIZuvhbaKwHga2/cMMg4DIcft1f6ovMfLWmx12Y5qlHaeoBuSFTrFL92GCJVxcSuUPfw5NjCeQUbVZxQHuonLWQXO3KSOMgBW6IQGtsTNyqm4I6a9M32qI9CBZky6CAJWpR0lEM4faU/XWmrZY+2WJ13CefL0dPM3lR5PEfUsS2+6VaWOoXANMeWqEYDKJ900BbXkCI0ju7xdCVg/XAzGu1d6WHIrMDIv8dc33yRQpqvf4lVCbX11xmIRzSzzewmdojQ1X9RD1opi3d6YZ34rlSH+7MqKudvhwWOdssbtOUraL5UqHGXbpOmyEOo+vC/JHsQNp/Js0xy8y3YjmpyG61wBOLJOlwm6zGGKsiis2Ed8ZUx38FDGeEjsrXGiWOp8vAJYb0UX0xxNOj54iEd5/QHsIG0PqjPU0qCsNbBZloEHqGTucmMeyjqYSIoqX4lGDbUNq39ZLdPg+hialc/GXaXVEgIPVg33ARcuphxBFYHhBuI9WTiRdpqiphPhSIIXALdiKntrI0z0ZzrpPwcD8QC7CrFRNbg8l1avOg/gTNJo0n0P5UhDqQyY2U2V7NOBydR21DyL9WGhbc0WlsvrbfY3u
 0DrmYeM/
 XmhApzjXDUE4W2tI9v7nAlMUmvIc2p0UHc9ng3oyNDFV+yi3Hmyvg0lsLBQNvzUq43qX8/b9gqkq8Yk3DmD661QmSOwXyGe9A7p+fmVJXc7xe2Vtoix2vSpZYIK7+xgbdHT+jNdLRbQqaKG6KR2anugyy8pLxqwTomAf2SnCGJpz07GiDFZsilOl0GhJqjt27kj9gZeNvQW914MjQa5FX4oJgRa9qzrXrUiios7LnsHwUgeKeyL4t1A+RCLE/ruPPONHD0CTND3EbsTUD+2IBNC1wOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:

<...>

> ---
> Jason Gunthorpe (2):
>       PCI/P2PDMA: Document DMABUF model
>       vfio/nvgrace: Support get_dmabuf_phys
> 
> Leon Romanovsky (7):
>       PCI/P2PDMA: Separate the mmap() support from the core logic
>       PCI/P2PDMA: Simplify bus address mapping API
>       PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
>       PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
>       dma-buf: provide phys_vec to scatter-gather mapping routine
>       vfio/pci: Enable peer-to-peer DMA transactions by default
>       vfio/pci: Add dma-buf export support for MMIO regions
> 
> Vivek Kasireddy (2):
>       vfio: Export vfio device get and put registration helpers
>       vfio/pci: Share the core device pointer while invoking feature functions


Hi,

Can we get Acked-by for p2pdma and DMABUF parts?

Thanks

> 
>  Documentation/driver-api/pci/p2pdma.rst |  95 +++++++---
>  block/blk-mq-dma.c                      |   2 +-
>  drivers/dma-buf/dma-buf.c               | 235 ++++++++++++++++++++++++
>  drivers/iommu/dma-iommu.c               |   4 +-
>  drivers/pci/p2pdma.c                    | 182 +++++++++++++-----
>  drivers/vfio/pci/Kconfig                |   3 +
>  drivers/vfio/pci/Makefile               |   1 +
>  drivers/vfio/pci/nvgrace-gpu/main.c     |  56 ++++++
>  drivers/vfio/pci/vfio_pci.c             |   5 +
>  drivers/vfio/pci/vfio_pci_config.c      |  22 ++-
>  drivers/vfio/pci/vfio_pci_core.c        |  56 ++++--
>  drivers/vfio/pci/vfio_pci_dmabuf.c      | 315 ++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_priv.h        |  23 +++
>  drivers/vfio/vfio_main.c                |   2 +
>  include/linux/dma-buf.h                 |  18 ++
>  include/linux/pci-p2pdma.h              | 120 +++++++-----
>  include/linux/vfio.h                    |   2 +
>  include/linux/vfio_pci_core.h           |  42 +++++
>  include/uapi/linux/vfio.h               |  27 +++
>  kernel/dma/direct.c                     |   4 +-
>  mm/hmm.c                                |   2 +-
>  21 files changed, 1077 insertions(+), 139 deletions(-)
> ---
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> change-id: 20251016-dmabuf-vfio-6cef732adf5a
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>
> 
> 

