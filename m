Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ECA4CF34A1
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6AD6B00BD; Wed, 19 Nov 2025 08:48:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DD26B00CB; Wed, 19 Nov 2025 08:48:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB466B00D0; Wed, 19 Nov 2025 08:48:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE9296B00BD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:48:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AFA3895FC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:48:44 +0000 (UTC)
X-FDA: 84127486968.28.E713EFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A7DB216000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:48:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KA20TCoH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763560122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BeuXovBni7+sG9dL/vAQiqMT1Z6f2OI4qumf/l0t4PU=;
	b=BBxfjJ+Bd/gmF0CNeTIHqagwdWK9V4yZaMy+89j9Y6Yz5OUyeOjyDeNr7Xqft2sb9ObpvF
	tHMI87DHDESRD83OpoljFW7aibIHkd0S/mz9hc7CuNvKD22ypOa34YUcc4l5SfP3FCheyx
	WdePAsOS2JqJcJVpP5f8kRvv4VreU+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763560122; a=rsa-sha256;
	cv=none;
	b=Eu05yuNJI4MySVNsmQlIrWowo8ZYkaIWpZF9REVcDStfuK2w1e9FlKaXlasupJxaC5wc4n
	hvHCJjNqC1HOZ3jFKEtdnT84Nzgt4ETlwbwHZ5E8s9hoPmibRNVhsAzIaB9J6zTPip2v5V
	R+pJX5DpI41ZaFiCLXh/EFlDhXYS9O0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KA20TCoH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A17B64064E;
	Wed, 19 Nov 2025 13:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F90C2BCB3;
	Wed, 19 Nov 2025 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763560121;
	bh=WBVxdPHFlyOgnD3YarukkHOdXbptm0KrfxkS3OxiyOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KA20TCoHh4xBpJsET+frUdvFAC1/PD10QEHBCIMaao0WAnseVamH90obusp+eQ5o2
	 JrhR8HX77yzaqJbG7RbbqAQs3awsq4Yvi7P4lQEZ99DLZaMLoKH1/O5e8/LLveXrkv
	 HCKoHyda54qc27+KsHvuXB6+0wPcCgAO6rsNtdaEMFdpPZjPGtqLRxBnqe3Arlb9EG
	 osGef8+spXexQcAOPEgMRnoYG//AXXDg2MNWYqsnZOs0wHsYLRrmAJ/9zE8Pdo+dbS
	 CMLK4jt8qhrjL3QY8uNgMZwKArml4umHyJINrVhyQzJ9qdxF59lBOeH32HAdcfhxrX
	 lBCpSzaidWhXw==
Date: Wed, 19 Nov 2025 15:48:36 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119134836.GF18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
X-Stat-Signature: qpa3om8n3e8uim8jjo9nrc9gwz75jswj
X-Rspam-User: 
X-Rspamd-Queue-Id: A7DB216000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763560122-667027
X-HE-Meta: U2FsdGVkX18JWHGyh/MFf7LFnQsVULrOM1q+l76dR7xamFmgoy8igKEYvRFneaOHQ3gjGs40H/nhoEcOKcW8YI2NV2xJRV2PxZrKxm2+rkWm44AU9JEq25qCsyrzzKoNyyHTafvdsmNCoWlRAqRmqEqBbao+MlK+syO8Q/OrJsutXyq/ZK+b6t8yX4RrowEQ1jK4XkYl1Ca1sfetvUTyDNgnbmjhuefhGoGKLbrVQ8eZcbvd6jx2wcU2GDScnI5GY22awuHWviPUXTY8HGOJAFJeDubbCRwOvuceulEHCx/TyVfU8FkftccT0Dq2eAhn69QGQ0RC/Cgva+6wLQcr6WVUm/yh8g3oFqPoUERqJThy81NW8GQLtED0xSMTxNQacv16khNaf8aWHqaDACmyIXcjuxI66s2EioCOyfpgcqId36qJi0FjQ7gJrENf5oo5W00KN9Y+pdNLWa7lej7URSfOzY3ZR5Ie0AHZHB9zOflebkz0Tf+4USCK2NoXaqqIh+TiqTRHp36UiBblS7lMMRhRjMpntszT6NTc+hL4s1eZCXr/jOqiz86ivUVKSLH8VkCJlOqVVuIMzwwBLBm+ZjLxefGgZu8eKS6eKbVBmbgElWvrNWRf3hv0fgXuGKPB8C+ysda3uSQ6SNTpF9vx2ix2nw/HK66wA4efCgCJzsuuYoqEA6SVmb0g5RVD7gaxtyH0h+4oaYQBvoP75J7SX3rSih2PPzPrNDHAYw6OMa8wexmfGcjAxju4/CCnFUT3P5NznKW9ldd0Jb7bKn3yaqv870aYFvXsfAILG5w7gRWH5nxIadbsuWopd6bwBhjcMTbdI/8sn9p1WuocjYskt+l6ksfvpjWo61ZeEV3p7UnzJRSCtJS8t2E8UTRoFyYSD+FTOvLUPQnuX+IGyanu9GSSt/n5QCEF6ysxBnht73js8RssEcoQLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:
> On 11/19/25 14:25, Jason Gunthorpe wrote:
> > On Wed, Nov 19, 2025 at 02:16:57PM +0100, Christian König wrote:
> >>> +/**
> >>> + * dma_buf_map - Returns the scatterlist table of the attachment from arrays
> >>> + * of physical vectors. This funciton is intended for MMIO memory only.
> >>> + * @attach:	[in]	attachment whose scatterlist is to be returned
> >>> + * @provider:	[in]	p2pdma provider
> >>> + * @phys_vec:	[in]	array of physical vectors
> >>> + * @nr_ranges:	[in]	number of entries in phys_vec array
> >>> + * @size:	[in]	total size of phys_vec
> >>> + * @dir:	[in]	direction of DMA transfer
> >>> + *
> >>> + * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
> >>> + * on error. May return -EINTR if it is interrupted by a signal.
> >>> + *
> >>> + * On success, the DMA addresses and lengths in the returned scatterlist are
> >>> + * PAGE_SIZE aligned.
> >>> + *
> >>> + * A mapping must be unmapped by using dma_buf_unmap().
> >>> + */
> >>> +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
> >>
> >> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.
> >>
> >>> +			     struct p2pdma_provider *provider,
> >>> +			     struct dma_buf_phys_vec *phys_vec,
> >>> +			     size_t nr_ranges, size_t size,
> >>> +			     enum dma_data_direction dir)
> >>> +{
> >>> +	unsigned int nents, mapped_len = 0;
> >>> +	struct dma_buf_dma *dma;
> >>> +	struct scatterlist *sgl;
> >>> +	dma_addr_t addr;
> >>> +	size_t i;
> >>> +	int ret;
> >>> +
> >>> +	dma_resv_assert_held(attach->dmabuf->resv);
> >>> +
> >>> +	if (WARN_ON(!attach || !attach->dmabuf || !provider))
> >>> +		/* This function is supposed to work on MMIO memory only */
> >>> +		return ERR_PTR(-EINVAL);
> >>> +
> >>> +	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
> >>> +	if (!dma)
> >>> +		return ERR_PTR(-ENOMEM);
> >>> +
> >>> +	switch (pci_p2pdma_map_type(provider, attach->dev)) {
> >>> +	case PCI_P2PDMA_MAP_BUS_ADDR:
> >>> +		/*
> >>> +		 * There is no need in IOVA at all for this flow.
> >>> +		 */
> >>> +		break;
> >>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> >>> +		if (!dma->state) {
> >>> +			ret = -ENOMEM;
> >>> +			goto err_free_dma;
> >>> +		}
> >>> +
> >>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> >>
> >> Oh, that is a clear no-go for the core DMA-buf code.
> >>
> >> It's intentionally up to the exporter how to create the DMA
> >> addresses the importer can work with.
> > 
> > I can't fully understand this remark?
> 
> The exporter should be able to decide if it actually wants to use P2P when the transfer has to go through the host bridge (e.g. when IOMMU/bridge routing bits are enabled).
> 
> Thinking more about it exporters can now probably call pci_p2pdma_map_type(provider, attach->dev) before calling this function so that is probably ok.
> 
> >> We could add something like a dma_buf_sg_helper.c or similar and put it in there.
> > 
> > Yes, the intention is this function is an "exporter helper" that an
> > exporter can call if it wants to help generate the scatterlist.
> > 
> > So your "no-go" is just about what file it is in, not anything about
> > how it works?
> 
> Yes, exactly that. Just move it into a separate file somewhere and it's probably good to go as far as I can see.
> 
> But only take that as Acked-by, I would need at least a day (or week) of free time to wrap my head around all the technical details again. And that is something I won't have before January or even later.

If it helps, we can meet at LPC. Jason and/or I will be happy to assist.

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > Thanks,
> > Jason
> 

