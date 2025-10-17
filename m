Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8B6CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 05:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B47A8E001B; Fri, 17 Oct 2025 01:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BD48E0002; Fri, 17 Oct 2025 01:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2328E001B; Fri, 17 Oct 2025 01:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68C8D8E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:40:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E45DF11A48F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:40:13 +0000 (UTC)
X-FDA: 84006505506.05.441D798
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 75A81140005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:40:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JpP2Mu5B;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760679612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lPCD5J2fr5LvFbc+8RdCzY0jqZXL1tZs7sFdnj1uXA=;
	b=cf1o/1vPkSJf5xl8lg5A1ONVxOrp6GuU/BMYnEHLuj9D5hqSz9x+g2FA2NiWpmUi82F/zk
	paWx+S+ZcKNwb7g5wILcUzZhYNIq/pTqGiRjpsWAtmEXdU5JOOVBSRLQy2jI+9gfGU70jw
	H+zanoiFmB7qvI6Y4L50+LDRj5ceKsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760679612; a=rsa-sha256;
	cv=none;
	b=hpAFcelMwmbZvEDeFdJPzKIbKQEuHH14kTrmp6O6iXbqV5LtI2fQWMZ2BsAFAfV+mGO7b+
	EVmoRNKWIe9X2JXm4kkQpvkjPrB6CHc6mtyidy3n0EVdPvJrCl+td/tK+bqCuxBzKw22uy
	bbfzVT/UbokrJulaUh7fYyM+qa+RU/A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JpP2Mu5B;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D083A641DD;
	Fri, 17 Oct 2025 05:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD16DC4CEE7;
	Fri, 17 Oct 2025 05:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760679611;
	bh=QatSK3vs5GP8c8e8mP/n3Zh7cEbbQ3Zbp2cyGT+36CI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JpP2Mu5B3aLEq2tithF2l4ekoWI7PQCF+VFS8MQGgHf4eBvOc+yXOj+6j3SF1JJGp
	 pEWPTs1ub7jCDFoztpJusE1SvuXOPIOS3EDzNJKolsvP7ynn443SDWb6+4ru7KM3Ik
	 4j+XYNWMaoFpTvU03u3ve6ByEq+Ss1Fm2ijL//zmgS/KjrczzYtQkY9DonD8sLZBjR
	 wAsx5V7EeXmlXZROMgB5Yk8A5L2w8KdUAli094vKeMAxXL3wpcyYeEh7KW2U9dbVP1
	 B/DzVQ/2C+MLErckpLFiu2Jq3uo28qrca2pT6QzZpBpkxmTwNhHCgEXgkTF1WRW82g
	 apdepzvlnSlOA==
Date: Fri, 17 Oct 2025 08:40:07 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20251017054007.GB6199@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251016235332.GA265079@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016235332.GA265079@nvidia.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 9ojopzdwpe4sswd8bhx3e9z3ww5dmncz
X-Rspam-User: 
X-Rspamd-Queue-Id: 75A81140005
X-HE-Tag: 1760679612-286590
X-HE-Meta: U2FsdGVkX18jdKg5RbNq6ME9rZ+iyt2HAo034tt6pby6fXeeu3YIuUm1RWbO9WdzaKaNaY3MJdJ/rmpItO46HxrqWJ8B7K9ihVLIAQ/IQbQdxn5AI4MUtK1IPYT+iuCMh1WI2XxIdrwbgsfitB+0yifwkapvLQ2S1WphzViNGugCSIJxqmadk1DV7erBdH0OQI8sXbwrzdPlZohepgEHoS9NCkszITv4XlbtBlEy6j59DFlo9XRdZLmAm1crGtxXbHYUBxvD/jXTF9Ccji+RCYJxcmvuralLYdtBCAVm34mbPFxPFM1gNh1cv/JYDs6wjuVcklOAELHSFZ79zsZmfabwiFjHwF3wW2ZcT17iWBGO39hi4c6OB6NlUeuJ92PCfMVg+Mi0xA4p+kakK/rl9u8W3CYydcSQCDo40m4W+nCCVKcB7n+FJbnwrkg8lAvmT2d8bePz4gRYprx9aIaEJYY8REY8YbrbRVifgctYs4MNB+SxYLgGwwPaLc27BlxwJpZErD2j0bEh+mLd7dLZusmEAl5+laDMVWdjHbcdss3/WQVSpdso0bmfC+/L8telz/mOOajDW+ScP6ZyMPRfO4fLQbYqVgoCdeo//eESgF/6lmsdlO9Llc8JFkNRrA5HRmbMZUKbti5nj2Y4W7t0yv8kiibTbdXV7GOd8HUIgC+SoR/Z4Rkzyzy+n3Spj4IH7cQNJfXWjTrEHpBmn9KlkQRpZQMLqKlBaApqQ6w19IYO4I+izQenJOWxDIC6r+9SAVLuNlJPoYbwFQGwCXso+BEYdjS/guoW9Bk3H4zwCFg3b/AJH4u2IEQ/esKU2kbLed9xROlqDWhlOgw3HXdJwDu7Ge0IC69YpW4bZ1N/l21bmv6rzVseemq56lr74At1LX+Gj89mfD0rDNFGg9wO6yM8Vxnk4NwXLZoZw0qjq8E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 08:53:32PM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
> > +
> > +static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
> > +				   struct dma_buf_attachment *attachment)
> > +{
> > +	struct vfio_pci_dma_buf *priv = dmabuf->priv;
> > +
> > +	if (!attachment->peer2peer)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (priv->revoked)
> > +		return -ENODEV;
> > +
> > +	switch (pci_p2pdma_map_type(priv->provider, attachment->dev)) {
> > +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> > +		break;
> > +	case PCI_P2PDMA_MAP_BUS_ADDR:
> > +		/*
> > +		 * There is no need in IOVA at all for this flow.
> > +		 * We rely on attachment->priv == NULL as a marker
> > +		 * for this mode.
> > +		 */
> > +		return 0;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	attachment->priv = kzalloc(sizeof(struct dma_iova_state), GFP_KERNEL);
> > +	if (!attachment->priv)
> > +		return -ENOMEM;
> > +
> > +	dma_iova_try_alloc(attachment->dev, attachment->priv, 0, priv->size);
> 
> The lifetime of this isn't good..
> 
> > +	return 0;
> > +}
> > +
> > +static void vfio_pci_dma_buf_detach(struct dma_buf *dmabuf,
> > +				    struct dma_buf_attachment *attachment)
> > +{
> > +	kfree(attachment->priv);
> > +}
> 
> If the caller fails to call map then it leaks the iova.

I'm relying on dmabuf code and documentation:

   926 /**
   927  * dma_buf_dynamic_attach - Add the device to dma_buf's attachments list
...   
   932  *
   933  * Returns struct dma_buf_attachment pointer for this attachment. Attachments
   934  * must be cleaned up by calling dma_buf_detach().

Successful call to vfio_pci_dma_buf_attach() MUST be accompanied by call
to vfio_pci_dma_buf_detach(), so as far as dmabuf implementation follows
it, there is no leak.

> 
> > +static struct sg_table *
> > +vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
> > +		     enum dma_data_direction dir)
> > +{
> [..]
> 
> 
> > +err_unmap_dma:
> > +	if (!i || !state)
> > +		; /* Do nothing */
> > +	else if (dma_use_iova(state))
> > +		dma_iova_destroy(attachment->dev, state, mapped_len, dir,
> > +				 attrs);
> 
> If we hit this error path then it is freed..
> 
> > +static void vfio_pci_dma_buf_unmap(struct dma_buf_attachment *attachment,
> > +				   struct sg_table *sgt,
> > +				   enum dma_data_direction dir)
> > +{
> > +	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
> > +	struct dma_iova_state *state = attachment->priv;
> > +	unsigned long attrs = DMA_ATTR_MMIO;
> > +	struct scatterlist *sgl;
> > +	int i;
> > +
> > +	if (!state)
> > +		; /* Do nothing */
> > +	else if (dma_use_iova(state))
> > +		dma_iova_destroy(attachment->dev, state, priv->size, dir,
> > +				 attrs);
> 
> It is freed here too, but we can call map multiple times. Every time a
> move_notify happens can trigger another call to map.
> 
> I think just call unlink in those two and put dma_iova_free in detach

Yes, it can work.

Thanks

> 
> Jason

