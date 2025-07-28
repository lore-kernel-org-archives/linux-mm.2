Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC99C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 16:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2B16B0088; Mon, 28 Jul 2025 12:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CACB6B008C; Mon, 28 Jul 2025 12:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207006B0092; Mon, 28 Jul 2025 12:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB5B6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:41:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C94585864C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:41:44 +0000 (UTC)
X-FDA: 83714239728.18.AE75A83
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id 25A8240006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:41:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B+keFTh/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753720903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSqnk/cMg/Q/8oEDZWleWovMUF84tWWuIvUviAtEk1c=;
	b=eu/a4Qp1hYQaPFHTAimjtqTkUW7oZCGS44wQlkY8zZyNddeYoVxNLcnYw6Ez5Pz3Ewb/YT
	UlG0tHEVDWEKzLEhoV7KlN6PduDfxCoRIO6FdclHoUJ0k3x4gXMZt7eSqXxOQglLXJh8dz
	bS/MbVvqPMQpwkgfXKflap2z0EMNc8w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753720903; a=rsa-sha256;
	cv=none;
	b=u516zprtazvCo5QuBAXLNEX6ULDQHnMdl48hjnA8aGfhYVfJYTkyy9oNg2AfYcZ9QlSLpe
	/Vw5Y9uQJ2HVGVFHPwpvj9Eqxr06qxsV/3VCJbIfr/ypoPnvlJUghb0ZS+NqFPtW7k+nnw
	KXNJpzs+uLch457Rx5gcHBbKOEcFQEY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B+keFTh/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 66B4CA53E34;
	Mon, 28 Jul 2025 16:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E4FC4CEE7;
	Mon, 28 Jul 2025 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753720902;
	bh=7x0ZgIgFMhmGblvNn1rp9l0J3jLs/NKo357QqFEU40c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+keFTh/H3uyJm+2CRXywKicPx1XFBBkxeKmrZZbdSdo7TbhwSKWM+9PVaAkV/Ggd
	 rdbs8jBkHbT/8OTgeGMPL4gfUOW2ABlcD8WUcg8AnFQUJTXwNmVXpc6MVeqX+1gX/B
	 Hl4YyyFNqJKjrMehvwoAGQununhgEiDlRgPJ4pHhRsT2e9nnS0dUD7g029zGYqMvz0
	 +n1X/yXScSmTwLjOGstVCV5NVXNowOdBanEpgP5gJZIZzUwp2PqhdbrI1ndD1ANzQ6
	 U3SK+z5/iiu7H8t8oy3Nyrh+r+SHqvFdQXzv1CHbtq87l4SZmHe8/P8OoUYzv0vSLF
	 T/9RjFtCR33XQ==
Date: Mon, 28 Jul 2025 19:41:36 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250728164136.GD402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250727190514.GG7551@nvidia.com>
 <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
X-Stat-Signature: g6g86g1opd1xrekwp36ri1x8tm3nrii5
X-Rspamd-Queue-Id: 25A8240006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753720902-533531
X-HE-Meta: U2FsdGVkX1+3G/CLXxH2Wwf7+MUepSiypIX4Zc64TjfZML3DSBOsIqUSxpM1Rmf853eLQYAfhEpmwsyACVh3r/1PWkqk3/qSj/iRY1y7XoRiRihH6lGew73l6tjlPzsWMNsH77RBWvj4JS6iS5RRktii31l0joc0lqWLDnyRg9B8EvL3ml3jy5/NnIwmYQocrAvOHKwRLC6cx7AvUgktRg+BGE1H/A9cKIN5vCXu4UQaApsArOzHSkIFQY3l81Viq5m8e6scprTDNS/ODcWRaMtofvXgXT6Vj3BGVz+kry2Y6qtAEsMsF+bhSEYl6bSQXtMh1iT2WW+MBrLu6UYlqjCx/cUl2QXhAh2OkXdcqBkWVxmLf0vtPq1bgdYCtFpgpGmGPdt0Sd083w1QUBO7l5wqi18snnRiEhECCAr2ZlPjubdbMM5uGqqoR16aYjpdpIh1+HwjXdB2uCdbeN+/WbEYAhJ+LwZYdVERKLZBYupIVdj7XCTF2mu6YPTLapIViAjSCuV5ikBIfm/oOM98G99YaKetlW9uP2yJT4IE/tgIY7GhS9J5nvWlwmQt/4YzFPdChOXI807q+Ds49F902qyk8n+uNwfF+ShsvLR3oZwgmuTnWBgzYkttq+Ch2S1DXOnopcMXUBGRx/WGbZghUVDO8aXwgYs4N4HskxtWGGxyIHerVjNctv/duKWEJlRlHPPu4oRj0DeYI6lAU6OGVe12cenZRTpZa18/RsElGXKorkKpxW5s/4EM5EC2gE+2732VweTsxV6vSHRhUQNXJ4U0jEJzcrnOi3Rk8uGeGfOQWpVXSSVMBRZd85gTDze2iIDjqZKVYDc2Mb2mlO0AXq06BXBRGe3DymsizKCIYPx3F7sLtS3ZpLvv5harzp8mBzztWPyYILQAuwCkX4s/uYLy+ziDIJnpdLPA/qwzumMOONDD/JyKNXFX8hxdxyZ/wNTESsMtLKrEU1E7UQ/
 dxBvRRJc
 Cr2Zj7e/I3ojGOdgY9+1P1zxyr6xWvwNwfw5GcfC2JZyPdGMcJLGv3heALJzcGXmryt4WkY5leOU+QaNoeAiiSOmudQdTXLL2HCLu5EsMnV8cIlMQc6azxnUn2utiLazG6jZrgyR6SlUzXjFtmiBryOcQ3FtvMwSi5kgT7ekuoEZF4ZM28Bw1+fQ/OCnSxSKzbu/jT62uol5kEQJMRI8ALO1pCceWrJA2nqLaAYFazOixMoMNU2eF7n7qiPhZJVTiOWFl2evNWTX51by0mpP0fg4+iPd8/Ykn0vrTF6FRNvlD8Tg6LVjtfE+PGlDOiKyFHPit
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:12:31AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-27 13:05, Jason Gunthorpe wrote:
> > On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
> >>
> >>
> >> On 2025-07-24 02:13, Leon Romanovsky wrote:
> >>> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> >>>> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> >>>>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>>>
> >>>>> Export the pci_p2pdma_map_type() function to allow external modules
> >>>>> and subsystems to determine the appropriate mapping type for P2PDMA
> >>>>> transfers between a provider and target device.
> >>>>
> >>>> External modules have no business doing this.
> >>>
> >>> VFIO PCI code is built as module. There is no way to access PCI p2p code
> >>> without exporting functions in it.
> >>
> >> The solution that would make more sense to me would be for either
> >> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
> >> P2PDMA case.
> > 
> > This has nothing to do with dma-iommu.c, the decisions here still need
> > to be made even if dma-iommu.c is not compiled in.
> 
> Doesn't it though? Every single call in patch 10 to the newly exported
> PCI functions calls into the the dma-iommu functions. If there were
> non-iommu paths then I would expect the code would use the regular DMA
> api directly which would then call in to dma-iommu.

If p2p type is PCI_P2PDMA_MAP_BUS_ADDR, there will no dma-iommu and DMA
at all.

+static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
+				   struct dma_buf_attachment *attachment)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+
+	if (!attachment->peer2peer)
+		return -EOPNOTSUPP;
+
+	if (priv->revoked)
+		return -ENODEV;
+
+	switch (pci_p2pdma_map_type(priv->vdev->provider, attachment->dev)) {
+	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+		break;
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		/*
+		 * There is no need in IOVA at all for this flow.
+		 * We rely on attachment->priv == NULL as a marker
+		 * for this mode.
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	attachment->priv = kzalloc(sizeof(struct dma_iova_state), GFP_KERNEL);
+	if (!attachment->priv)
+		return -ENOMEM;
+
+	dma_iova_try_alloc(attachment->dev, attachment->priv, 0, priv->phys_vec.len);
+	return 0;
+}

