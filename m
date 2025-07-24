Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B4FC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB40C6B01F6; Thu, 24 Jul 2025 01:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5DE86B01F7; Thu, 24 Jul 2025 01:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C726B01F8; Thu, 24 Jul 2025 01:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEBC76B01F6
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:44:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51CE8160257
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:44:51 +0000 (UTC)
X-FDA: 83698069182.25.429C5C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 91ACB160002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:44:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C6jGoMhe;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753335889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWwIrjr8oLOcsM5a+NL45qc2mC5fuxGwy7bWSwmB7L0=;
	b=5Vd22gYnzlenZ7c7tEov5h9WoMbn62vsojrZLIgjgOG0FDIV79C3ndOtq1q0PdxA0O9J+i
	+8aFEUuTnmHsaaClPIHtosFymxcA63vYW8CRQJGHbb7WkXNMiflDdP+ukuTV4TK5jBOeAU
	w5p0a+CsGgLsB/Q1y+ebZPTme7gfCUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753335889; a=rsa-sha256;
	cv=none;
	b=wfdRvc0Bq5DFbfY7sN0KLm10plcS7eFO42Ptt5d81/jXWuIXyGbKZWQxYFCGG+T/t3SnoM
	aMUXVobr+1hdxxW65xcb01S1UyR3xfzifN36sGdCYqh4MKBa0d1KXqed4uQ3ySYWQ+75TS
	GpvsQwLmrL7nH9PIVEurkIrVwcHGeK4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C6jGoMhe;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63A384456A;
	Thu, 24 Jul 2025 05:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9B6C4CEED;
	Thu, 24 Jul 2025 05:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753335888;
	bh=U4I+CEURF422p0sGN26ha9HaOt720UUk24J+vl+6mjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C6jGoMhePxWs2G1RnhF59gG3AXap97mUUE40SE0Rm0zZuH4EkRp+dPag/rTKFTJtk
	 aIH8UT5BEZzz8AS2s95p9XeW+qVBOtlMdJU9OcofPSwraKN+wgvSIt7eeHshgWCTsT
	 z/pst5aWEXs8QqfceKtXDCpdgWnxSY7hlyYDAOq+nTfBlhT9pT/3LCgyEKtkwCcEYG
	 Qc+p/WDMbD1kDL3Wqi3br3L11qZxkfSyOQLi2R2Bu3EOjG1wVamcR4BfC5KFfACpsJ
	 9GcKqEIPKMc7PjakSUojQydViLJlolHSBB2JOKHxDcIAki1C99B8uS3kEZjWAxtRnX
	 jtT9QAxe4rLNA==
Date: Thu, 24 Jul 2025 08:44:43 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250724054443.GP402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com>
 <IA0PR11MB7185E487736B8B4CD70600DEF85EA@IA0PR11MB7185.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA0PR11MB7185E487736B8B4CD70600DEF85EA@IA0PR11MB7185.namprd11.prod.outlook.com>
X-Rspamd-Queue-Id: 91ACB160002
X-Stat-Signature: awnsar8pj6phsp8hm7tusuktwqkfpe9f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753335889-880132
X-HE-Meta: U2FsdGVkX18hUVb9Lq2INlu2CqHcHsqSVC92r3zSXX2YFPSzDD75odZ7V+V2M7TD6ypABHuVLJTbbMplNuPWfxBQZ4PXsr+oCW+HiaPo2G1qgFXoGA4eAnH7Aeg9ILZbdNDtsW8kibHK8dzzLsIuyQG2e8ONYlDPMSDSNbO4diRJrLr/UjKXLE0pgsERWtz7Wxlie3rksqs1h1IEo72FaO/L/ARnzKfIZJHfE35iKKb/9YEjHFLe2y3aZ5avsdqMbSBt5MKkc/Cyx//BLa+58TNpbq8xQjBMGhvfDazoMhF65n9QHU7m1XMpGRz6Dh8pxBtlXMVYV3HV/LVAeNM9+vMJVZsuVGdJa//xi/erSpZfdIRt+7ZkmbYFO8+k/VgYqrNTWfniYWJG5WwTf0VCZL2/BCssydh2O/efECeYgVrDvNTy/46pEh7Zh2GullpIDfHNbrZgs8cLAYHPy742M3xk/EjXk8opxEFA8CO6gPx29sMcmh2sYkG4I9hQ7rlsdt45hDpGxtC3z2nrFQQ7aUvGxqfIyb4EvZRI7cX/Z4P3oBLUemzaY8utZ6wS3koyF3GLxHsQfS2UlmFfRsJzXeMYLCSiNpRg36hgsN2JoB7HFuQl1jzYziOrcETVmVqCn1wsVeKnM/ZbjYMLs+EuQE9bKWx3OcvHmesWx2SBOSQv9ZaJZxHB67H6wWbSBLiBbH/3goxbyb1SDwSt/hVeOEj4dRhz8+94Hp2CNjqJppEuWxbUIK/noNbwuexoJLAr0KXsSRCf39MryJlG0SfnWGH6EClkHzSv/SYlpUScV3IvxFy/b/YGv+Yjm4oDsafiRx6BTyFBsPvQUIYg7cpKRQne2uZmkebdf2YQn9XZCwliCYHhbLc10xJsdnuG36Qdb9uliGHlDs0jgqojqf1jHBroMbdUMk7SxsFrtIxHgzs61IaB1KDKDPjM++3LkOVc8k1lkyCy1GTzs+All+Y
 ZC1jg6NX
 FdNsYDk6YAzM7SHBMqoEYADAuc+VKld5KoMLuBLorxg/62ZCewMcnecdaffK+sczbKen1JN8kpzJ0N0gvZXZz7r+gXTBavOFaA0Rfr+7DdcEixtqleJCMOZZoqeHWhQY47m1k4Ym3AjrBDnL6eYll0LdM36+75ML2DVLxKGd5hcAAC2EXicpl05qxjXRRnl4eIG3Rm2IRoUeGDhWBMv1Z6qgoyZnXkuIbJDv4OGhFxhBcqT/8VcnbDIARRuXVs0C7EHgGHk0jjg0DyjzuJNNc37tpGmK/fG4asgG5XiFtBYzVtC+gm0T8SUb695HN7lX46wnBvD84EmnrijxLWGhI7qCp/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 05:13:49AM +0000, Kasireddy, Vivek wrote:
> Hi Leon,
> 
> > Subject: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
> > regions
> > 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add support for exporting PCI device MMIO regions through dma-buf,
> > enabling safe sharing of non-struct page memory with controlled
> > lifetime management. This allows RDMA and other subsystems to import
> > dma-buf FDs and build them into memory regions for PCI P2P operations.
> > 
> > The implementation provides a revocable attachment mechanism using
> > dma-buf move operations. MMIO regions are normally pinned as BARs
> > don't change physical addresses, but access is revoked when the VFIO
> > device is closed or a PCI reset is issued. This ensures kernel
> > self-defense against potentially hostile userspace.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/Kconfig           |  20 ++
> >  drivers/vfio/pci/Makefile          |   2 +
> >  drivers/vfio/pci/vfio_pci_config.c |  22 +-
> >  drivers/vfio/pci/vfio_pci_core.c   |  25 ++-
> >  drivers/vfio/pci/vfio_pci_dmabuf.c | 321 +++++++++++++++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_priv.h   |  23 +++
> >  include/linux/dma-buf.h            |   1 +
> >  include/linux/vfio_pci_core.h      |   3 +
> >  include/uapi/linux/vfio.h          |  19 ++
> >  9 files changed, 431 insertions(+), 5 deletions(-)
> >  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

<...>

> > +static int validate_dmabuf_input(struct vfio_pci_core_device *vdev,
> > +				 struct vfio_device_feature_dma_buf *dma_buf)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	u32 bar = dma_buf->region_index;
> > +	u64 offset = dma_buf->offset;
> > +	u64 len = dma_buf->length;
> > +	resource_size_t bar_size;
> > +	u64 sum;
> > +
> > +	/*
> > +	 * For PCI the region_index is the BAR number like  everything else.
> > +	 */
> > +	if (bar >= VFIO_PCI_ROM_REGION_INDEX)
> > +		return -ENODEV;

<...>

> > +/**
> > + * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
> > + * regions selected.
> > + *
> > + * open_flags are the typical flags passed to open(2), eg O_RDWR,
> > O_CLOEXEC,
> > + * etc. offset/length specify a slice of the region to create the dmabuf from.
> > + * nr_ranges is the total number of (P2P DMA) ranges that comprise the
> > dmabuf.
> Any particular reason why you dropped the option (nr_ranges) of creating a
> single dmabuf from multiple ranges of an MMIO region?

I did it for two reasons. First, I wanted to simplify the code in order
to speed-up discussion over the patchset itself. Second, I failed to
find justification for need of multiple ranges, as the number of BARs
are limited by VFIO_PCI_ROM_REGION_INDEX (6) and same functionality
can be achieved by multiple calls to DMABUF import.

> 
> Restricting the dmabuf to a single range (or having to create multiple dmabufs
> to represent multiple regions/ranges associated with a single scattered buffer)
> would be very limiting and may not work in all cases. For instance, in my use-case,
> I am trying to share a large (4k mode) framebuffer (FB) located in GPU's VRAM
> between two (p2p compatible) GPU devices. And, this would probably not work
> given that allocating a large contiguous FB (nr_ranges = 1) in VRAM may not be
> feasible when there is memory pressure.

Can you please help me and point to the place in the code where this can fail?
I'm probably missing something basic as there are no large allocations
in the current patchset.

> 
> Furthermore, since you are adding a new UAPI with this patch/feature, as you know,
> we cannot go back and tweak it (to add support for nr_ranges > 1) should there
> be a need in the future, but you can always use nr_ranges = 1 anytime. Therefore,
> I think it makes sense to be flexible in terms of the number of ranges to include
> while creating a dmabuf instead of restricting ourselves to one range.

I'm not a big fan of over-engineering. Let's first understand if this
case is needed.

Thanks

> 
> Thanks,
> Vivek
> 
> > + *
> > + * Return: The fd number on success, -1 and errno is set on failure.
> > + */
> > +#define VFIO_DEVICE_FEATURE_DMA_BUF 11
> > +
> > +struct vfio_device_feature_dma_buf {
> > +	__u32	region_index;
> > +	__u32	open_flags;
> > +	__u64	offset;
> > +	__u64	length;
> > +};
> > +
> >  /* -------- API for Type1 VFIO IOMMU -------- */
> > 
> >  /**
> > --
> > 2.50.1
> 

