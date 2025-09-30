Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD55CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA538E000B; Tue, 30 Sep 2025 03:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2739C8E0002; Tue, 30 Sep 2025 03:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163208E000B; Tue, 30 Sep 2025 03:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 015658E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:57:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 919AB58CC3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:57:56 +0000 (UTC)
X-FDA: 83945162952.02.85995E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CBAEDC000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:57:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKEnQkLh;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759219075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiswHypUZntmb89QNMZaL7LC5QoG3dfXzM7bhyOwVuY=;
	b=7ZFYf30nck27csgTHSHbC5AkoKXCH0wHPGlA1rI+/B4LU/wPQk8Kt2FIlqbm692JjXOIm1
	WXWSGOu79/hXHOUn2xeKERv3Uab5YZCvTMco+HBKFDy8h+RvUofQNkvxUgJZyowONzR5E4
	l5vvzRmpCz9e/gSw/LO+4UQTq4wS8/M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKEnQkLh;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759219075; a=rsa-sha256;
	cv=none;
	b=r57KH6aKjD3HrkD+LFTeE/H2bLRPM2q9LvsyFp44G+P3QPhHMJMwGE3RpGTPHtrVR76qeZ
	K48JJqsXz851080Nelnf+qNO968SDLYPZCqUTG3TDENgDANKoMKTnqSfeEdMU3Q3rSfvjG
	W/ngX6V+6SUQq5eP2n8x+WLORiLPzmQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F41843B90;
	Tue, 30 Sep 2025 07:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879DEC4CEF0;
	Tue, 30 Sep 2025 07:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759219073;
	bh=i3BtTTr7nZIJz33RyVUpfLlfxu4epWOssHy+VLrcscQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lKEnQkLh/7QlrpMJsb5yRxE5AbBpzJMJNRvLELIbdmZqsMudIfJkl5IIjVlvWd45t
	 9CdHZPBwdsFyTXltr7C+E/ikvBD8M3GKILT1uJbM/dqVtkzxxeI95NEbtW/zrd+Ep5
	 UJKj7ByQ5cHM7iDUE5YdLldljkvDneKjj7T0/Jl4BAwLIv6rMPS82rffMeFvtqMlii
	 rJtHqvVmDH+CUonBV/bnseaOumQHFjDS8yuzzqj15+2YNU8QWaz2EfS70aqZHG3yUz
	 GrVG3wKTr88ok96rH2QGVO9OvriGTC+fSkO/DeP0k5odor2Iw88fzatiG+tDDQkt+a
	 OH7f8EY3JlCxQ==
Date: Tue, 30 Sep 2025 10:57:48 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v4 07/10] vfio/pci: Add dma-buf export config for MMIO
 regions
Message-ID: <20250930075748.GF324804@unreal>
References: <cover.1759070796.git.leon@kernel.org>
 <b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
 <20250929151740.21f001e3.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929151740.21f001e3.alex.williamson@redhat.com>
X-Rspamd-Queue-Id: CBAEDC000A
X-Rspamd-Server: rspam05
X-Stat-Signature: qpg13yjito31638p7u61estz5a13r1me
X-Rspam-User: 
X-HE-Tag: 1759219074-138478
X-HE-Meta: U2FsdGVkX19q2+7RHm+4N6KlCEjJlb4+T5f8lKpj8/VeBAIjEkIadAupW9aJOwa1sqyMxrvPe3wug7COfqRsyzb/jDqgArCQCNOr7KkBRqP/Hri7jnCSurdPoXgcNUk2hzJN6bhM+d0ihxP+AQxtn2UBeO/V5LUtNfOTlJwVJ6xytodgKpJS8BgdPaeGr77hbM2Py/w20ldJc6VScr7qdoAPjSe9MmEcMmMN8m0fIdhZuQwDrIQz/BVTtfceiHDZaa3aTd017VKd0jctp/BHIe7kYklJv9G5FGt2GPtl93GSjL4IeBgeAwcBsffvEHSY6M7BD42cSdG7BwIw2VrPzvyIWNJHF/CLiX8U4B9IehIfAp/2tYBUhRYgUnDueDOKZanHbd4xx7mKmY1AsxsM1MasnAT0cyX1SIqxf+icpGx8MtOLZA7NAdEAjtXi4Vsw2nrsG/3Hv828+beQXMq99tnjzqnx6oOzvoIxBWUAZo1IeZXjVlIB+AG530e3nbHt1bkEcQqRG5MpguMruyBboz4ULPq8HqsAKZQaLo1u2H7oehmXX1TJ7UwJRUlEBl9OBAkUpkkmzZnGBgI6D18eTqV9d5wtq4jAekKT6gjEWdVybFgG54TMTZf8kMTVxUC1HHykkdEfHi+0xlPRWVDIVW5UhoUX8/w8fwQ5kqB1AUdIubs7wRPXJgxoim5c3B54Rj8YHiibZnDjpGlbNe2wlMDCtbBiL9sGrnTPRJ/OP24wnEyoKDU8xorKBMgJMnY//HXH9i+rR6Bz1bY+X4YcgbBIr++yIMpeQTDRxcDL2zl5jsXfx2QbMx886kKLmqbfp0SpnKkMn5g26a/qtvAfXx5W1rNTfsq3yHWMMfS63XNy07cYn2HS2fegD8BDmL3xtDizRzVIt8MHAuIX3b5wT/AcSgs+2Bxk8xTSwWBjR3cAZf3zPieyhftHHSXckYLtxJBgL7KfrXjoVYCDkrK
 Z6+225WE
 vmX5BMrR/xhdFQH7ge9VgiZIbTQ/hUk+GDp+T7GNSdB6EPvWB9qELG0XJwq9ypNh4gfPrpKEvf99oJmNuwnuxl6Iah4SHbIFcNnJQ3Sh+rESWPtHO9+CGfTkAaVAthlPP5BHbUTpo+1habrqclm7zmZokjyfGpZxvDwj/92FYH7CpwBht5wMeioETQvLfN6+r6H+YJOgnb//0zKWpUVxAQJrMXYABfIzeuZk5xbXOj9M5qrEw+oYvDDbS9xacVQDFSEbVxBlMvcWu7Lpg5x16lSFbaW6IvgvbCaV76pppcG8A2JU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 03:17:40PM -0600, Alex Williamson wrote:
> On Sun, 28 Sep 2025 17:50:17 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add new kernel config which indicates support for dma-buf export
> > of MMIO regions, which implementation is provided in next patches.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/Kconfig | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index 2b0172f54665..55ae888bf26a 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
> >  
> >  	  To enable s390x KVM vfio-pci extensions, say Y.
> >  
> > +config VFIO_PCI_DMABUF
> > +	bool "VFIO PCI extensions for DMA-BUF"
> > +	depends on VFIO_PCI_CORE
> > +	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
> > +	default y
> > +	help
> > +	  Enable support for VFIO PCI extensions that allow exporting
> > +	  device MMIO regions as DMA-BUFs for peer devices to access via
> > +	  peer-to-peer (P2P) DMA.
> > +
> > +	  This feature enables a VFIO-managed PCI device to export a portion
> > +	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
> > +	  to other userspace drivers or kernel subsystems capable of
> > +	  initiating DMA to that region.
> > +
> > +	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
> > +	  support for peer-to-peer DMA use cases.
> > +
> > +	  If unsure, say N.
> > +
> >  source "drivers/vfio/pci/mlx5/Kconfig"
> >  
> >  source "drivers/vfio/pci/hisilicon/Kconfig"
> 
> This is only necessary if we think there's a need to build a kernel with
> P2PDMA and VFIO_PCI, but not VFIO_PCI_DMABUF.  Does that need really
> exist?

It is used to filter build of vfio_pci_dmabuf.c - drivers/vfio/pci/Makefile:
vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o

> 
> I also find it unusual to create the Kconfig before adding the
> supporting code.  Maybe this could be popped to the end or rolled into
> the last patch if we decided to keep it.  Thanks,

It is leftover from previous version, I can squash it, but first we need
to decide what to do with pcim_p2pdma_init() call, if it needs to be
guarded or not.

Thanks

> 
> Alex
> 
> 

