Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8462BCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE63F8E000D; Tue,  2 Sep 2025 08:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96C18E0001; Tue,  2 Sep 2025 08:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B748E000D; Tue,  2 Sep 2025 08:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3A938E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:58:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69B85138AAB
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:58:32 +0000 (UTC)
X-FDA: 83844314064.08.AB95DAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D21B910000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:58:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y03rLipQ;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0gJxSB8XWTrVKmtvWsr6MEfNQMybJ3AZkFJpGUht/g=;
	b=AB1O2hbiRNt/koCEBVTKNsw70szOJEnYrjGPufUco0LK1CHFAz5vdVYNuNkRb/4bZKwKat
	wTmfXD+q1ENRToAi9PHbVB7ml/k8NumA46PI44ZKoBJfkP8hYz39ZxtQZGi4DNmeAfY67K
	q6VK0vL94uivQ3KM0CPbvQ/D7zpWRsU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y03rLipQ;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817911; a=rsa-sha256;
	cv=none;
	b=f1iOLIrYNjjLPkai5w3zQq3RJR5KLarqV890HW/DYpfSkI6x1xAZX30cCiMUbVG66eqwTb
	X4L9aE2g29xU21Ypmm3U0OOhmfiMP1QhgVbmaERJ+pwHVDazVTMd/ualBZyY1JTm11kwt8
	IoPd1dQXp6cFczxdLbHw34WhexxEOQk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD99743995;
	Tue,  2 Sep 2025 12:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08555C4CEED;
	Tue,  2 Sep 2025 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756817909;
	bh=CM1gzdTND9tJKwW5aJTGTYza7PZbOeFeI+0kiHDsfk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y03rLipQ172HNCWdzae1SvWeUKEZCuyy4iT/sxqmRUG2Mk9XAm0JD2Cf43Q4ccXI4
	 vJ3zCW+7bhV2I/8W3AQ/zj+cPA9rZhBtVccOf2Syvu2xP3GZZOcRUzTwD1l9Dszm61
	 coTmrjtssASLghJ0YobZBbn3b5yvo1gmHUuMYKl3N+eOUDvW9dLkEd42uz6ExoscbL
	 AN9nGwSWGJAg2aXnrk/T8mIOnh8SJFTLZoRnFwoAw9p/ZVbj1um54ETkG1UmVJ0yaX
	 k1mi0ufFXvprbr0GmTrnZJZPMNtSonfXc/UWWvtDhkzWmzN/ZJ+J57M3aRwqpyvkrT
	 ePb8jIU/SceyA==
Date: Tue, 2 Sep 2025 15:58:24 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 08/10] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20250902125824.GH10073@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <edb2ec654fc27ba8f73695382ab0a029f18422b5.1754311439.git.leon@kernel.org>
 <20250806160201.2b72e7a0.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806160201.2b72e7a0.alex.williamson@redhat.com>
X-Rspamd-Queue-Id: D21B910000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4tfftib31iu7a1gjxqff391a69x9u6ew
X-HE-Tag: 1756817910-28248
X-HE-Meta: U2FsdGVkX189aTE2tYQ+kNTOCRYEp63ETNHmYy6fIJUxU+OGmGuVpBobYhhwVbesw/i72AhdrwifejEFFf4cRwzNmNnNCmBM9giVSKQ2IOxpdXITpJ03VvgkLJhWta/E4fMGMrWIntDVICb41+MjtTI4/nTLOCIYu4xhG9dm4pq06bxx28MRNbS0LEUMQKLrOd1dWAAo5iCZwMvSgdhP1qwJJIgd8kcuiH1cKtN/zK/98+89tPAlR0eUe1OOpRFMc631C5yaH4iWjUNGIFqv3nlITjVudqA9lZTSrRc/Kox9dqrTOCfX6nQmbg5i9p/8ZKUzui1oAWMgu21LlR07MKPBUWCZCLNWfB/+fvnuin3PcyH677Wty6GTtvXd4988wvRSYUQ2Kr5IngPkwWGphvwjUXdwit0TPlt4MFR4wKfDYEiRZKrz6ushUjA7JBIQz3bInf7iAnjyAWZV+zEu56uUCF6l/oVJd11Zw7RuVsr0D9yNcLcQd8+NXdfCkJtVs+UL51zyDeUsdKAUTk/mUeIlGFD5xD619qBWYm8BTYjCKCVqEPJ/EI/SJoXHxDlksQbIIlGGPOGqLGi0NF5iuWAQwpff79kEwKLylUClKowg3lqV9gMBm3pS25eLdmzEU6eGSl4y2lMnwYBVj72jgvG3BA1Vv/yz6PQfKc/lF+glzOEyqCbegrdv5gFPwRhNVwpq7pYb0fUbOYISRb/pyrjtTU82V5WIcu0DMpaoErRKbdRYV1JGGMpGCW7IP/nCsi1aVbLwtxkN8ranNMJh0AcUtzSc7L2BNOw+848EV6UhX+60NzdPuwi7GryKTEdbYVQCnsUE+NnSbt6PmFhRSpFPT7AbWWQJ3AHvQVYugE+OalZi+qEYA0VNnrxurFVcpzEJ/gQ/EBtsoMaFOX8o64EVMktcMMRunufG43vfXlCfT/tnY1n0/YfpVjuN50LbS6QnWDLsuZ4oyMGLuFO
 fRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 04:02:01PM -0600, Alex Williamson wrote:
> On Mon,  4 Aug 2025 16:00:43 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Make sure that all VFIO PCI devices have peer-to-peer capabilities
> > enables, so we would be able to export their MMIO memory through DMABUF,
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 4 ++++
> >  include/linux/vfio_pci_core.h    | 1 +
> >  2 files changed, 5 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 31bdb9110cc0f..df9a32d3deac9 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -28,6 +28,7 @@
> >  #include <linux/nospec.h>
> >  #include <linux/sched/mm.h>
> >  #include <linux/iommufd.h>
> > +#include <linux/pci-p2pdma.h>
> >  #if IS_ENABLED(CONFIG_EEH)
> >  #include <asm/eeh.h>
> >  #endif
> > @@ -2088,6 +2089,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > +	vdev->provider = pci_p2pdma_enable(vdev->pdev);
> > +	if (IS_ERR(vdev->provider))
> > +		return PTR_ERR(vdev->provider);
> 
> I think this just made all vfio-pci drivers functionally dependent on
> CONFIG_PCI_P2PDMA.  Seems at best exporting a dma-buf should be
> restricted if this fails.  Thanks,

It is temporary solution in next patch "vfio/pci: Add dma-buf export
support for MMIO regions", the strict ifdef is added.

  2107 #ifdef CONFIG_VFIO_PCI_DMABUF
  2108         vdev->provider = pci_p2pdma_enable(vdev->pdev);
  2109         if (IS_ERR(vdev->provider))
  2110                 return PTR_ERR(vdev->provider);
  2111
  2112         INIT_LIST_HEAD(&vdev->dmabufs);
  2113 #endif

I will split "vfio/pci: Add dma-buf export ..." patch to introduce CONFIG_VFIO_PCI_DMABUF
before this "vfio/pci: Enable peer-to-peer ..." patch.

Thanks

> 
> Alex
> 
> >  	init_rwsem(&vdev->memory_lock);
> >  	xa_init(&vdev->ctx);
> >  
> > diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> > index fbb472dd99b36..b017fae251811 100644
> > --- a/include/linux/vfio_pci_core.h
> > +++ b/include/linux/vfio_pci_core.h
> > @@ -94,6 +94,7 @@ struct vfio_pci_core_device {
> >  	struct vfio_pci_core_device	*sriov_pf_core_dev;
> >  	struct notifier_block	nb;
> >  	struct rw_semaphore	memory_lock;
> > +	struct p2pdma_provider  *provider;
> >  };
> >  
> >  /* Will be exported for vfio pci drivers usage */
> 

