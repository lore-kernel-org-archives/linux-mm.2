Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB378C87FCE
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 06:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27EFA6B007B; Sun, 27 Jul 2025 02:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2309C6B0088; Sun, 27 Jul 2025 02:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F296B0089; Sun, 27 Jul 2025 02:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01BA86B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 02:16:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FAAD133FC4
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 06:16:23 +0000 (UTC)
X-FDA: 83709035046.24.63372B4
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf21.hostedemail.com (Postfix) with ESMTP id C46761C0009
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 06:16:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0n3rAFd;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753596981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crRWcMHrThqtIM5bvime91DgGPA8ZpzR9jVHdWvhKh4=;
	b=03tAbDE5MHv7Y0dnzqcEN4C1r06pwQECsZw/CuFVgnWR2dxSZUtQMRKOBogRz8RMwMD03Z
	klPliPouUv8ckUYULjKGOYDWWmAC/wmk5eIhdjGvmzpe323hewmORd6PlAelcmfnixZHIJ
	GhZ/uRHHwQAOgVVEdu3HoPXxj4rvVFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753596981; a=rsa-sha256;
	cv=none;
	b=YC8Q+TMLArglkZT0QS4fVdKYghnHlsxmLmGElu0/7zclPsN64+Y7ljLSfrYlhiXjEG3euh
	LNzn9MbavaP3LmKZqFuc/pc6EfqB64qlB3foNi0oyH2JFzMpAYjX1sLIDZuA/9PrgGWQy+
	sqN3ZS7a5t76LFhqLHDNXEwXiNUHLYE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0n3rAFd;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id EC65FA5229C;
	Sun, 27 Jul 2025 06:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC05C4CEEB;
	Sun, 27 Jul 2025 06:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753596980;
	bh=uyb+7FyuIzMo0UI+mEQEGNm9qjuMtb30fpmryEwM5AA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p0n3rAFdvPX8SSmrmPGbM3OFcMaPV5tlPd6lSBHW0nfQvfLr5t05u9i0xY+PlQRlr
	 RYRm6L/3T+8Yzum1IOO6FuEwCg9bbaROc1fI3BeUrhEcwJTtjTLXnFoEogHoVbqEWr
	 n+53AqEFJ1sK6ggO0K644GUqZ8bAkBv9+wjSNvXCqhTOcgOBy3alEhY5GPckrM5VkG
	 mwgn4GAdZbM+j8wVP7nsOAB3eS+56hTYprqNgJDscfKHaMRs02RwpMr8LhZDxLDbH9
	 mWVU9OyNjSvCkRiurpDskSoZ4dWfvIoXZCW2ZJFAR+xqCkxl3ItEHmgpvoKuBPLlou
	 Yij/pATng8pAw==
Date: Sun, 27 Jul 2025 09:16:15 +0300
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
Message-ID: <20250727061615.GW402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com>
 <IA0PR11MB7185E487736B8B4CD70600DEF85EA@IA0PR11MB7185.namprd11.prod.outlook.com>
 <20250724054443.GP402218@unreal>
 <IA0PR11MB71855A080F43E4D657A70311F859A@IA0PR11MB7185.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA0PR11MB71855A080F43E4D657A70311F859A@IA0PR11MB7185.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C46761C0009
X-Stat-Signature: trwutb8h76fqm8p4k7rukfdux1zz897p
X-Rspam-User: 
X-HE-Tag: 1753596981-502401
X-HE-Meta: U2FsdGVkX1+PDOrVgPpmR3v1tBalA3+yqcWRvRAAW63UeiJnAozqXcAorpg2YnuyjltzCx6bcTVh2Nx+nFcsPrsYju7OBzG5yhdR5PlMFwhOs0iAp7PGUZoH4wK6xHjFn39a3yBCDcA38kx9LxcWrtRVieF0ziEAxb6plyVK6k7OX90i/S0Pixu2XOJMKhYc8osn/LD93T3IgdNRHOpEaDrxiNo9TYlrJMD98kAll9KSCc6BZG2dEOhyMziSD90afmz8kxzCA2AP4RY4iHkd8YT+25Gudol6W0djWo6EANl3PBLfFpnxZWV1ZBxN03wra6stTdjt+x5oBTdTo/IOoILKn7TAEyCgTfRUz27TcBHv2DPU602sXKaXEnN+Y7AHvOyXcwqy1bhXeqB4EV+am6cM3VboH7Fn6O1CpWZkbnxZinQMiKhZUQ8hvA73skQrNLV+e7e0bGOztx5Ba5N5YqLxyo2dTpRcmHSBcGQegpMMrFEUEInD63YVrBLTd3RvAWmF2ipnV4u5K9+3y885K3e2n/KOPsbk1NvrN0If2htEiUG3rMInxV2ssuVyAab4QyI9jdLxCER4TLjsqLf4Vo2uQjv8aXXs0hQokFFIHBoOfE+F5uUS3Q7D9hSk5Q18xX6mqduRjOQwnNCfHu/AhP8sf3Kw4vk5iD84IrDxYez4bwDVUDJ7THCQvE91CROpUYz1gmaqcXJyJjz59sm8D15nOPNEAsaQoKStQ3lMa5joiyB06jro/VmrF1R0vxL+oGLhEWOiOzMoIwvVTWuQG6C21QuIwKukFcUJq8NWZ4UwoFQm3eD9w5+1NUhTdCpiBGxBHtUO1uextlzNICdt4zdeUNriSDFILYnl/UWMXnY/P/gCAfg0FhK8xPGf1fSdGmvY+jVcTmAn0HLjshTGy+Rexi5WYBp+MslpVMCXb8D4GyL4f/P+qdzqQuRAiaTyOBwBeL3u/iIQfRnDF1j
 AAgKd6C9
 wOh2zNbygGj8bC/42vsay/9IVneZcU71VAb3ODLVg3EuEnCncgvuXHGx8btH2AFLr+ujdxO196ruv2Ey/TBI7muuYHyC5OGrovLwlovMlpeAr4OYBKBgVg7Wg5Zo43x1E4PeRCFrX+SasvMJjdz9OqV3JHbqZdWRXDZ72qbPBSXVf03sdSTK0CuPO4C0aoq2wM9meCIAw/7VZhv8ExB7sX8v/NXlfagiOQqmgPKsVSK+Rf7/Rr//IE7sqypUyIOm7sBfvXCXSQxuiVRwLOwNCgdwlzFoXYc/O8154xngzRTCRp8PEnc5RYrkv5E3JRpmxbskdMTkvZ/keLSRn9nbH+L8bx6abE0wQpymlcxFQV2O1JrOvdnN2Riy1U0MfjKTMe416n5HdnY1V7phANfvLYB0uxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 05:34:40AM +0000, Kasireddy, Vivek wrote:
> Hi Leon,
> 
> > Subject: Re: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
> > regions
> > 
> > > >
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Add support for exporting PCI device MMIO regions through dma-buf,
> > > > enabling safe sharing of non-struct page memory with controlled
> > > > lifetime management. This allows RDMA and other subsystems to
> > import
> > > > dma-buf FDs and build them into memory regions for PCI P2P
> > operations.
> > > >
> > > > The implementation provides a revocable attachment mechanism using
> > > > dma-buf move operations. MMIO regions are normally pinned as BARs
> > > > don't change physical addresses, but access is revoked when the VFIO
> > > > device is closed or a PCI reset is issued. This ensures kernel
> > > > self-defense against potentially hostile userspace.
> > > >
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > > >  drivers/vfio/pci/Kconfig           |  20 ++
> > > >  drivers/vfio/pci/Makefile          |   2 +
> > > >  drivers/vfio/pci/vfio_pci_config.c |  22 +-
> > > >  drivers/vfio/pci/vfio_pci_core.c   |  25 ++-
> > > >  drivers/vfio/pci/vfio_pci_dmabuf.c | 321
> > +++++++++++++++++++++++++++++
> > > >  drivers/vfio/pci/vfio_pci_priv.h   |  23 +++
> > > >  include/linux/dma-buf.h            |   1 +
> > > >  include/linux/vfio_pci_core.h      |   3 +
> > > >  include/uapi/linux/vfio.h          |  19 ++
> > > >  9 files changed, 431 insertions(+), 5 deletions(-)
> > > >  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c
> > 
> > <...>
> > 
> > > > +static int validate_dmabuf_input(struct vfio_pci_core_device *vdev,
> > > > +				 struct vfio_device_feature_dma_buf
> > *dma_buf)
> > > > +{
> > > > +	struct pci_dev *pdev = vdev->pdev;
> > > > +	u32 bar = dma_buf->region_index;
> > > > +	u64 offset = dma_buf->offset;
> > > > +	u64 len = dma_buf->length;
> > > > +	resource_size_t bar_size;
> > > > +	u64 sum;
> > > > +
> > > > +	/*
> > > > +	 * For PCI the region_index is the BAR number like  everything else.
> > > > +	 */
> > > > +	if (bar >= VFIO_PCI_ROM_REGION_INDEX)
> > > > +		return -ENODEV;
> > 
> > <...>
> > 
> > > > +/**
> > > > + * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
> > > > + * regions selected.
> > > > + *
> > > > + * open_flags are the typical flags passed to open(2), eg O_RDWR,
> > > > O_CLOEXEC,
> > > > + * etc. offset/length specify a slice of the region to create the dmabuf
> > from.
> > > > + * nr_ranges is the total number of (P2P DMA) ranges that comprise the
> > > > dmabuf.
> > > Any particular reason why you dropped the option (nr_ranges) of creating
> > a
> > > single dmabuf from multiple ranges of an MMIO region?
> > 
> > I did it for two reasons. First, I wanted to simplify the code in order
> > to speed-up discussion over the patchset itself. Second, I failed to
> > find justification for need of multiple ranges, as the number of BARs
> > are limited by VFIO_PCI_ROM_REGION_INDEX (6) and same functionality
> > can be achieved by multiple calls to DMABUF import.
> I don't think the same functionality can be achieved by multiple calls to
> dmabuf import. AFAIU, a dmabuf (as of today) is backed by a SGL that can
> have multiple entries because it represents a scattered buffer (multiple
> non-contiguous entries in System RAM or an MMIO region). 

I don't know all the reasons why SG was chosen, but one of the main
reasons is that DMA SG API was the only one possible way to handle p2p
transfers (peer2peer flag).


> But in this patch you are constraining it such that only one entry associated with a
> buffer would be included, which effectively means that we cannot create
> a dmabuf to represent scattered buffers (located in a single MMIO region
> such as VRAM or other device memory) anymore. 

Yes

> 
> > 
> > >
> > > Restricting the dmabuf to a single range (or having to create multiple
> > dmabufs
> > > to represent multiple regions/ranges associated with a single scattered
> > buffer)
> > > would be very limiting and may not work in all cases. For instance, in my
> > use-case,
> > > I am trying to share a large (4k mode) framebuffer (FB) located in GPU's
> > VRAM
> > > between two (p2p compatible) GPU devices. And, this would probably not
> > work
> > > given that allocating a large contiguous FB (nr_ranges = 1) in VRAM may
> > not be
> > > feasible when there is memory pressure.
> > 
> > Can you please help me and point to the place in the code where this can
> > fail?
> > I'm probably missing something basic as there are no large allocations
> > in the current patchset.
> Sorry, I was not very clear. What I meant is that it is not prudent to assume that
> there will only be one range associated with an MMIO region which we need to
> consider while creating a dmabuf. And, I was pointing out my use-case as an
> example where vfio-pci needs to create a dmabuf for a large buffer (FB) that
> would likely be scattered (and not contiguous) in an MMIO region (such as VRAM).
> 
> Let me further explain with my use-case. Here is a link to my Qemu-based test:
> https://gitlab.freedesktop.org/Vivek/qemu/-/commit/b2bdb16d9cfaf55384c95b1f060f175ad1c89e95#81dc845f0babf39649c4e086e173375614111b4a_29_46

Ohh, thanks. I'll add nr_ranges in next version. I see that you are
using same region_index for all ranges and this is how I would like to
keep it: "multiple nr_ranges, same region_index".

Thanks

