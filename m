Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B094CCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3898E008E; Fri, 31 Oct 2025 02:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253BB8E0045; Fri, 31 Oct 2025 02:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F3D8E008E; Fri, 31 Oct 2025 02:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 087E88E0045
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:48:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99147C03D1
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:48:58 +0000 (UTC)
X-FDA: 84057481956.09.D3D2BC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DA5034000B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:48:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1h6FTwN;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761893337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDEm0IGdaO6SkHtvutLLhZyOmTlyHkhw4B27Mb+TS88=;
	b=oUlcaynTXfycvVMzSbl6EsHeLzB2pX+JfgvtvVtoPThCTFdFvwJ08WtxduBiCTUITJD7Ey
	TALZXNMBC2710mOSOzwZG2KZL+uFIK8rBWScTLLIzXd/IMjzNaT0e3Ag9MBv9mUHyNiyla
	4YdtozicJE7Pu1ISAJKKNMs9QtYZSPE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1h6FTwN;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761893337; a=rsa-sha256;
	cv=none;
	b=PXCiCaTSnRMrNQXASX1WgzLZ83sOGKpa3a8etRjAAayGQkLV2eZkmgUaKL5yvQLXsE2SDw
	LATup+6ucmf6/LVcaasgd0RjhpuAMXmYs0HR0irDNcC8ymdG8lY5F38jFPZcY9FXH6zIIJ
	LaX3K8J5FDANyNz3+aZHtJeggzRI3qA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAAB14386B;
	Fri, 31 Oct 2025 06:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30340C4CEF1;
	Fri, 31 Oct 2025 06:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761893335;
	bh=R5M/BZuEUeO6MNnujDu/RdiqPqOvxifgK+E/jWj/M64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a1h6FTwN+q+A4td6LvgwCZbm56rsVEOnHoTSFeQoA8kEIgslHwi8eKhmcAv9St0Ok
	 W80x4Wj8UXuXSY+0aKudJ5lih9rGfReoMhWTywfeghp1RUox6v4uqV5oNv5qbYEg56
	 QbNeAscqzR9+MyI87V97tP4x1PtA/rtR2xTBusZX/rYO0ZXMXvRQOdHykNpR4S0/F0
	 1WmfFbl2veaaeJ/gkMhFWNLbBDpTqt/7ZKw1BnTuN4+koJ6EwRipT90WVcZLqWqcZF
	 nn5bH+8Pi8nXwLiOrgVS7RmUROm+rQImaoV3BWpLLmivAW/zoQbjZp2iEz7zcV0W1P
	 XuCupc4+xACzg==
Date: Fri, 31 Oct 2025 08:48:51 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20251031064851.GA74544@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251030143836.66cdf116@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030143836.66cdf116@shazbot.org>
X-Stat-Signature: 7hefut7a7cgm9bm3acabmsqc7xnw98ur
X-Rspamd-Queue-Id: DA5034000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761893336-759913
X-HE-Meta: U2FsdGVkX186MSZ4mJh2OKX87dGjXCc4aIVoxdWF5/ZWdQ0YYmn4KXbNNC4zkikh/HhpSjtPKSffU+TaTDWWvKQ1fQMzhWTSIAwlU9LuhMeUEE1895eSBHPaIHbEkLykXYQzeBxnmHdnTzQK+4IDmABHOmPEuB5Bp6hV+70rENQVjRO7SZL1jxrl2mOFRN68eYZ50AewLrDlttRtwYgQaflQuHrt23YI7g17HKZkWoW2bQ+kqfP6Av1fOKrYucsdMNdqG85eyQ1Vz9/GrThvWmtXIwDhY/GmzztxvubM32h4Q+Rh/HVlTLotDdFr0VyrW2b5BL+BxRCxfcSgQnGVDFDw58xP57rhThacf89HZ2DkMYYZbpwu02Xdx7+q7sOp0GxOMWCkPVSCavKtNHLbnpNtKxFVZNCJSMWtXi+tqwn1lnKAn9tS4bUbRwgn7YitvrMRK9MQ08y5u5+Y+xLrEkgIXYSffFgql0BM2WXMYIh1zFrk7n7pZi49raqAmW3l4qMlsHw6NKfL07SMIDQgCm2HrNXUh0BQYWm/c+f4656Gkr46PRQrv/D02dB31I6cJc6JFiimdUmMRarkycFi1SZaeX7b+MxkXiiltkCh9qs7jdn7xn35y5OyDnF0OyxSZeSjJEP2ksHLurATiZ9yiBP/YKBBN1z5l43vk1Q7+so8Z01Ar51THt9n6VmA88yItNzaUlUgyQL+6W24ntCDkJ0yMI0AG9t7YZoLnPVfVAM35RifGcTEwIY2Mca1KXgguYJobmlUSmpjTxEW06MKdV3OsBzR4i/8m8naMBO/p6f09fHzBafPAD+E1rC3txYiXEnibM7BY2opuREnT1mY47xckoVFrwovsTzLh6lusiOuOz/HSryEweQ3Rc7p785GIeuiaPi6yfyBfn05U1jJvJ0geSHq6unG23iFhkcJvxRd4F011kY4G+zC1MvMA3Ca9DBrTvNQBM9Xt4s6Dgd
 Tk0rTLIz
 128xRvhIDGC3nH/CZZuseSjBunDeanHfL8NestzP0A+Ao2qhvLBPVNYuoMAbl5zOFN2Zt1ztzofgCTy6ihX0YjKEhUXgo6q70vAQCrqUK2LJf1dyOQIA8DIvEzUdU5/abv9SKGeq1Y++pBIW3kUb04m1dKe9c4CeSnAEBuN+YfjsqUrvI1A0LTNQx4gAshmFqdIB80MEg69NGhTKQfcoJauvOqHJ12EZ/9TM1Fyis6kJR57+kHDxFozMwwzwApGgofNj6ayerTvDQfK5YB/ac+gVUOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 02:38:36PM -0600, Alex Williamson wrote:
> On Mon, 13 Oct 2025 18:26:11 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index fe247d0e2831..56b1320238a9 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -1511,6 +1520,19 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
> >  		return vfio_pci_core_pm_exit(vdev, flags, arg, argsz);
> >  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
> >  		return vfio_pci_core_feature_token(vdev, flags, arg, argsz);
> > +	case VFIO_DEVICE_FEATURE_DMA_BUF:
> > +		if (device->ops->ioctl != vfio_pci_core_ioctl)
> > +			/*
> > +			 * Devices that overwrite general .ioctl() callback
> > +			 * usually do it to implement their own
> > +			 * VFIO_DEVICE_GET_REGION_INFO handlerm and they present
> 
> Typo, "handlerm"

Thanks, this part of code is going to be different in v6.

> 

<...>

> > @@ -2482,6 +2506,10 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  
> >  	ret = pci_reset_bus(pdev);
> >  
> > +	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> > +		if (__vfio_pci_memory_enabled(vdev))
> > +			vfio_pci_dma_buf_move(vdev, false);
> > +
> >  	vdev = list_last_entry(&dev_set->device_list,
> >  			       struct vfio_pci_core_device, vdev.dev_set_list);
> >  
> 
> This needs to be placed in the existing undo loop with the up_write(),
> otherwise it can be missed in the error case.

I'll move, but it caused me to wonder what did you want to achieve with
this "vdev = list_last_entry ..." line? vdev is overwritten immediately
after that line.

> 
> > diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > new file mode 100644
> > index 000000000000..eaba010777f3
> > --- /dev/null
> > +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > +static unsigned int calc_sg_nents(struct vfio_pci_dma_buf *priv,
> > +				  struct dma_iova_state *state)
> > +{
> > +	struct phys_vec *phys_vec = priv->phys_vec;
> > +	unsigned int nents = 0;
> > +	u32 i;
> > +
> > +	if (!state || !dma_use_iova(state))
> > +		for (i = 0; i < priv->nr_ranges; i++)
> > +			nents += DIV_ROUND_UP(phys_vec[i].len, UINT_MAX);
> > +	else
> > +		/*
> > +		 * In IOVA case, there is only one SG entry which spans
> > +		 * for whole IOVA address space, but we need to make sure
> > +		 * that it fits sg->length, maybe we need more.
> > +		 */
> > +		nents = DIV_ROUND_UP(priv->size, UINT_MAX);
> 
> I think we're arguably running afoul of the coding style standard here
> that this is not a single simple statement and should use braces.
> 

<...>

> > +err_unmap_dma:
> > +	if (!i || !state)
> > +		; /* Do nothing */
> > +	else if (dma_use_iova(state))
> > +		dma_iova_destroy(attachment->dev, state, mapped_len, dir,
> > +				 attrs);
> > +	else
> > +		for_each_sgtable_dma_sg(sgt, sgl, i)
> > +			dma_unmap_phys(attachment->dev, sg_dma_address(sgl),
> > +					sg_dma_len(sgl), dir, attrs);
> 
> Same, here for braces.
> 

<...>

> > +	if (!state)
> > +		; /* Do nothing */
> > +	else if (dma_use_iova(state))
> > +		dma_iova_destroy(attachment->dev, state, priv->size, dir,
> > +				 attrs);
> > +	else
> > +		for_each_sgtable_dma_sg(sgt, sgl, i)
> > +			dma_unmap_phys(attachment->dev, sg_dma_address(sgl),
> > +				       sg_dma_len(sgl), dir, attrs);
> > +
> 
> Here too.

I will change it, but it is worth to admit that I'm consistent in my
coding style.

> 
> > +	sg_free_table(sgt);
> > +	kfree(sgt);
> > +}
> ...
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 75100bf009ba..63214467c875 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -1478,6 +1478,31 @@ struct vfio_device_feature_bus_master {
> >  };
> >  #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
> >  
> > +/**
> > + * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
> > + * regions selected.
> > + *
> > + * open_flags are the typical flags passed to open(2), eg O_RDWR, O_CLOEXEC,
> > + * etc. offset/length specify a slice of the region to create the dmabuf from.
> > + * nr_ranges is the total number of (P2P DMA) ranges that comprise the dmabuf.
> > + *
> 
> Probably worth noting that .flags should be zero, I see we enforce
> that.  Thanks,

Added, thanks

> 
> Alex
> 

