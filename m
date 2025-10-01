Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9823ECCA472
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 11:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7A68E000B; Wed,  1 Oct 2025 07:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B2E8E0002; Wed,  1 Oct 2025 07:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12A58E000B; Wed,  1 Oct 2025 07:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9F68E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:39:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41CFFC0708
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:39:45 +0000 (UTC)
X-FDA: 83949350730.13.6D6439C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9ADBF1C0004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:39:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hyfhWXjK;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759318783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnqM7GmQND7QXgn1M6rdLry/ghqsJ3aWAxMWYo/a6wQ=;
	b=p7TbD02KFADjupD8ERo2hQdbtRwCvyVmSKVpYLtv3Gsy3CxI0OlK5v5i3vUbJD83P0tqHk
	qnMLFS/G+aMZlMFWRCmy+aO1TeX+mePFiRxFdVnqP8zD9lQFMzdxzOVQkS8+XV5Kjrt41d
	l2vRij5GHJvYzCtQFu1gJzywKNOwwAA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hyfhWXjK;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759318783; a=rsa-sha256;
	cv=none;
	b=sriZhq5+hRrFmKJrvzyfFc0vKCT93nP3xPYyMCUTls1tkRm9JcNYO+q4OcWf1cXBgqIH6W
	+eyRQUuLB/s60RjKhYS8nd+c0fKEmUbF2exfqBk57fEB6tUR7FVEXHK4MeEMWsvq8JLqzZ
	7xoZgIEwW8ITVP8EJMR+LwwTOj6VcFI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B93506062C;
	Wed,  1 Oct 2025 11:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4B8C4CEF4;
	Wed,  1 Oct 2025 11:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759318782;
	bh=Ezy7+mtT4eps9wTpBlbZkP1mFfCZBHTp5E+V6UHQD4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hyfhWXjKKeqTsPAKqst9VMRZTuHnr79Sn85JR9oApnhJZe1TO5oXMimv1OZ2K5t1Q
	 9MiMpANH+0eOS4bcbwboljFqvrlf7T7uAAqpI3hYX8SgDpEKW89XvVN/UZ5DYJEoku
	 FCsdu0jIgr5dBxYfu2TGJvAqsoQRkfMXMl/1F9lyU95/QyzDKaMdhpvL1V7Ya/B2mh
	 pfedbt0u93fTYkQVaxWkIHD9fK5BbrTidNe/CqVFgP1WMiwVDvBVcc7cf3aq3rnWzp
	 eISxrrXcYtNF0j6R+nLIOAcxLwM1v6bQ7c0J8gD109M3HZIzW3eQE3Urg+TrWFUG6k
	 2FEfVcfX3pxjQ==
Date: Wed, 1 Oct 2025 14:39:37 +0300
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
Message-ID: <20251001113937.GH324804@unreal>
References: <cover.1759070796.git.leon@kernel.org>
 <b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
 <20250929151740.21f001e3.alex.williamson@redhat.com>
 <20250930075748.GF324804@unreal>
 <20250930100758.1605d5a5.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930100758.1605d5a5.alex.williamson@redhat.com>
X-Stat-Signature: ojwrbuxyiy43b461s1ei9639xwee1jba
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ADBF1C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1759318783-393516
X-HE-Meta: U2FsdGVkX1+ZRZmSDXmQHmWYmGyv7CAgzaV5N7Ngj56PQfv+ePMRe3U81zaXGGweBLvlyFCd8Ctm7qaXZf27CdZaIAH4K0VpVeYuEr5H0NI3OddquS2LtHLKqBF4Prn5kblcUNlHJhFOvuvWD4Zc/OUNz2E4Oyc3aT/v0m3wiNmxagnC8w+0oJiambs3I9Gj773AowlFqRvPoc26iB2JtY1WfKd8siw5b7jJ2S9QSYUWP2pbdXu/lVFcQ0hohXeJtKT0GWrgPoOLrSQmNl2ZUO3DDeiooHAUXBDXC/G5wJ82q6bD3iNSpu1rjX+O4eXE2NNvy1S8p2MbNNQCFe1etvMR4how6h7r5tiZ7d3B3bBgeNcjo1Baw4eqdPSFU/aN0Uls7EWelcL/htAX4U9uzpuCiqgWeztRf0NvvMJvJIQEsD8TwBu0A51rP/rE4ayWQXhrmIt9b94vAqTYLVAPCYnDAK85sgzrymIb64HoYm5P9BlB9rhzR4EOwvtF6dPBawqRhR7qwM9t1rddjxG1ambT9mAWCuNeRe1fZBfQm5/jdfriOMj7rPdk3Prb7GA+m8GMPzdSm04xoZeJOH5O3A+KPlANxksnisCGWTP/ll0r4KQ4P0ThzcAg8/Ex/xyeXkDkA2DYRgEGYZ0agz/rNmRmCz10APOuggXI+coZh6JMDHG16Of4xcQ1kfcLzWdNcvXKp5DClz+Uhw/itaNYAUUR+DLIMndDj2TOOGNvTUwwq6J08xTmYWLvkV1Ok2jvWqYKy5wKYCj/nCJWVis6EVnFNOMCuaKB2H+uRMWxUIcUtVQFf/Zy/pPIF4+ZZOxQ2QOit/q3TKJYRHuJUFkgA4rcHmJAIhAmygB8f1P1v7wf2CBgy7tbaYxrmTTQQAv0viz+pN48SRUAyIb8awyYvDa4Kxo+5yK54vlbGXYL9EV97uL7TaRXlfPo68uABl1a2v9gsyJ6TpE3YltyrOd
 QjIkhuMr
 iLyjWG+FWiKqa7+DbviTe74xnpMwWl1O3JBL5Sb/i5K0n2+kxjLqFbIFJOz8XGfoHeOMczRJ9Huz+eQHphruUb85syYw0Fe8OU/lulct718XGvNG9y+9EUn2vZxQkSPgriL1vc+FKOZv3S89vzSfHzLH6Zv+0W9bN9W7e3l5uLL3aL5UGRis4+rrDbPoTRpFbYK5YEipEwbf8yztt9Y+LjTCF0i1l0Q3Sb5dWk7I3qzRqPwLk5sU+3CWcEDBdSrefb6monOAKi8SRsHq7YBZN6xdZ0gFZabNCk8F//97a4EYUdPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 10:07:58AM -0600, Alex Williamson wrote:
> On Tue, 30 Sep 2025 10:57:48 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > On Mon, Sep 29, 2025 at 03:17:40PM -0600, Alex Williamson wrote:
> > > On Sun, 28 Sep 2025 17:50:17 +0300
> > > Leon Romanovsky <leon@kernel.org> wrote:
> > >   
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Add new kernel config which indicates support for dma-buf export
> > > > of MMIO regions, which implementation is provided in next patches.
> > > > 
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > > >  drivers/vfio/pci/Kconfig | 20 ++++++++++++++++++++
> > > >  1 file changed, 20 insertions(+)
> > > > 
> > > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > > index 2b0172f54665..55ae888bf26a 100644
> > > > --- a/drivers/vfio/pci/Kconfig
> > > > +++ b/drivers/vfio/pci/Kconfig
> > > > @@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
> > > >  
> > > >  	  To enable s390x KVM vfio-pci extensions, say Y.
> > > >  
> > > > +config VFIO_PCI_DMABUF
> > > > +	bool "VFIO PCI extensions for DMA-BUF"
> > > > +	depends on VFIO_PCI_CORE
> > > > +	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
> > > > +	default y
> > > > +	help
> > > > +	  Enable support for VFIO PCI extensions that allow exporting
> > > > +	  device MMIO regions as DMA-BUFs for peer devices to access via
> > > > +	  peer-to-peer (P2P) DMA.
> > > > +
> > > > +	  This feature enables a VFIO-managed PCI device to export a portion
> > > > +	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
> > > > +	  to other userspace drivers or kernel subsystems capable of
> > > > +	  initiating DMA to that region.
> > > > +
> > > > +	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
> > > > +	  support for peer-to-peer DMA use cases.
> > > > +
> > > > +	  If unsure, say N.
> > > > +
> > > >  source "drivers/vfio/pci/mlx5/Kconfig"
> > > >  
> > > >  source "drivers/vfio/pci/hisilicon/Kconfig"  
> > > 
> > > This is only necessary if we think there's a need to build a kernel with
> > > P2PDMA and VFIO_PCI, but not VFIO_PCI_DMABUF.  Does that need really
> > > exist?  
> > 
> > It is used to filter build of vfio_pci_dmabuf.c - drivers/vfio/pci/Makefile:
> > vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o
> 
> Maybe my question of whether it needs to exist at all is too broad.
> Does it need to be a user visible Kconfig option?  Where do we see the
> need to preclude this feature from vfio-pci if the dependencies are
> enabled?

The dependencies are for the platform and not for the devices. For
example, hisilicon device mentioned in other email doesn't support
p2p, but the platform most likely support.

I don't have strong feelings about this config and at least for our use
case will always be enabled. I can hide it from the users.

> 
> > > I also find it unusual to create the Kconfig before adding the
> > > supporting code.  Maybe this could be popped to the end or rolled into
> > > the last patch if we decided to keep it.  Thanks,  
> > 
> > It is leftover from previous version, I can squash it, but first we need
> > to decide what to do with pcim_p2pdma_init() call, if it needs to be
> > guarded or not.
> 
> As in the other thread, I think it would be cleaner in an IS_ENABLED
> branch.  I'm tempted to suggest we filter out EOPNOTSUPP to allow it to
> be unconditional, but I understand your point with the list_head
> initialization.  Thanks,

We can add dmabuf list to struct unconditionally, as memory overhead is
negligible. It will allow us to drop IS_ENABLED() too.

Thanks

> 
> Alex
> 
> 

