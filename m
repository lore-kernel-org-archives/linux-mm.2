Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25057CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 16:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 683A48E005A; Fri, 17 Oct 2025 12:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634628E001F; Fri, 17 Oct 2025 12:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522FF8E005A; Fri, 17 Oct 2025 12:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A97A8E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:14:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D40E186230
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:14:05 +0000 (UTC)
X-FDA: 84008102850.11.2441215
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3ACD14000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:14:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jTCLpLij;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760717644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9NhWqbKGZBogivoOBH5lJ2b8WJa6vftnsNMPGk/oio=;
	b=4hLXs5wPHaudRHSxP2ceVHIcNXYKzD9DNYNPgyU7Q2HZCjiPLVhoyZFvVLPPFQyf5GJaAm
	bz5eauCCQyYoXH7QuPIrxI78AXKzTRXXigYusdQE5gayJFF5Y46yHbvlezz+JvmSCKiT6S
	yIEjeAz7+i8+AMOik4OXhYSw1cAL8L8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760717644; a=rsa-sha256;
	cv=none;
	b=HHJJ6/WNFdV5WE/CTSnYCwS+C3itpRI0byw9BQ3WFDWjBPU1eJPl6xe0HOkH3zP0GLpIu+
	s1GtJzVC0Cf1Hv/t1kB8rlMO1qHLoFfcBDbpUlEIeLGlkP7NEJEpUsHGWjgoYtr8ND6v1O
	fLdwwFUrDwo/8Gc2ILCFU8Pu4Th+Si8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jTCLpLij;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EC6764789;
	Fri, 17 Oct 2025 16:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A6CC4CEE7;
	Fri, 17 Oct 2025 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760717643;
	bh=CFcYtcEk7uP8GckKeqhWU4+P+5/c+ra0lxow6L4SUMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jTCLpLij/ghgEicXuXTN+FZWe2vozg4SlZDHShFYvfPIUqub9PEm0BZPbrfwhk5Y5
	 kHa3fBtd0I8PMX+AkKdag0U4BIzd+49ChSgph58nyWLMOvvlEkwLSjIU2QA34zc5nd
	 BpBoDkebgbg0pPisYn/W4PGMd45z0hbP0jVSgkM4MgKyCqfaMb/c3ml+HtbaZZruJK
	 9IAS1YwF8RfmI7S0ETdhisl70QdOy43W8iOfuHMtQEZdTi632zsoLdFP1Hd/l02tPB
	 yhqVnuCW1LoEbFlWHwImXvx1hZKb3X24VRl34jQQI9Hw9D2yq1wpOpB62Ntmkc5Aj7
	 qEnbZ7Op0le6g==
Date: Fri, 17 Oct 2025 19:13:58 +0300
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
Message-ID: <20251017161358.GC6199@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251017130249.GA309181@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017130249.GA309181@nvidia.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: qxnz67bjkwbwkk93nnc6y6x84aga5rwt
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ACD14000D
X-HE-Tag: 1760717644-107510
X-HE-Meta: U2FsdGVkX19B8Ztm3s5dc8xykRFvAay1NGHqVX3HWLMDk89XsLgHMQDaLWLdepMuhM02y6RepR7v3KQk1vpQbwBMJxMj/uBXxL75rS9VYSE1mCJ9kUIjW5C/3FSiaTU+CgEu+2gi09Bn8QUIO2uhKZ6rK7kAsDJ2YgdMYXNG2mCrhPU3Jg+/OVBfos9Qh4pVmP1vE7SUkj5ReCyY9rtI3HR76BAmfvxJHZBPtLRLgASfakQCgA1WaGK/R1a8TNWDiBoFRMGPBiw1e4MaprX3SchZWDF8cztJAv6gS6pIeUdr8vmEidZHNHuF+GusOIHulnWXbDTyUxf3NciyfiQ+Ks8WSlFbS/yf9gaJ9TRoNaceKzTdOudkn2AC9keBa8+qAAPGlYrt2ROCS4/zQmgSOOJaBjgf673Aw7/4tSxxw+m6j8ib2iprk47HQW27oKRSDvXqzt3FjTt8P+76yxUtT00/E048UykthQydUXzk5vynvU5MH1hmFfG6FS6+Rs3aQQsaGl0n65oTzoBqOMEExMn2yuPxLRvihBKfqOj/5R9b3PP20b03HUZAyxgLFK2OK6Pun/lZ28k2VifzxxEhbu8gMQcY35RXyUVIiZcE2pARsp9z5k/nLGS7h2HsWOZ8JlnepN4si/sJmBGBXhZGtXSqbhCxCxlDCya7DaBFsq6eAxiKX+YCEqZSX0i+Ip2izXAfnLqfAg+msJyC/XJ8J3Z7Ie/QpUnCQlZWWmKqo9jobXpq6+Ux95gYosYL9/Mb7nOIWA6QhdwZDdti29AxT/6slXjTze5u6DNt89P8jynQ6i+p4ffaoiBvMDSxMhzHugW2HdKNuw3lLdHsjGWNnie9ZxQckxBuJ+vuySZrAnaRfjgr/Nho7cU2dtLh/TVguZa6FK7iC3eDoEI5PA01My54Ek7KInpLFIrGRbuKdcqIFcrDe7BMc2BNZYaaGXT+QR7OEQtMhrePOrrV6M7
 RhOX/N1x
 k8hhSXsEpasZl51K4xmV7vkebcewXJq7JlpjrDYJtStb8ipoBDG0QZTCURBvi6aOrtKcPBkWpc88WrEuXrlxVGW0rMF3/Dd8Wx29tzaDxOEy5pam5M8d3ugvMaw2zjtzTKtxJ1N4kU69nD6Yu8ht0uCXpyEzvaLRgUX37uq985Zo1WmBn8d136MKKI1Kk9xznUE7vS15Kii+33XtCmlLEJJAM5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 10:02:49AM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
> > +static void dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> > +				   struct vfio_device_feature_dma_buf *dma_buf,
> > +				   struct vfio_region_dma_range *dma_ranges,
> > +				   struct p2pdma_provider *provider)
> > +{
> > +	struct pci_dev *pdev = priv->vdev->pdev;
> > +	phys_addr_t pci_start;
> > +	u32 i;
> > +
> > +	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> > +	for (i = 0; i < dma_buf->nr_ranges; i++) {
> > +		priv->phys_vec[i].len = dma_ranges[i].length;
> > +		priv->phys_vec[i].paddr = pci_start + dma_ranges[i].offset;
> > +		priv->size += priv->phys_vec[i].len;
> > +	}
> 
> This is missing validation, the userspace can pass in any
> length/offset but the resource is of limited size. Like this:
> 
> static int dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> 				  struct vfio_device_feature_dma_buf *dma_buf,
> 				  struct vfio_region_dma_range *dma_ranges,
> 				  struct p2pdma_provider *provider)
> {
> 	struct pci_dev *pdev = priv->vdev->pdev;
> 	phys_addr_t len = pci_resource_len(pdev, dma_buf->region_index);
> 	phys_addr_t pci_start;
> 	phys_addr_t pci_last;
> 	u32 i;
> 
> 	if (!len)
> 		return -EINVAL;
> 	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> 	pci_last = pci_start + len - 1;
> 	for (i = 0; i < dma_buf->nr_ranges; i++) {
> 		phys_addr_t last;
> 
> 		if (!dma_ranges[i].length)
> 			return -EINVAL;
> 
> 		if (check_add_overflow(pci_start, dma_ranges[i].offset,
> 				       &priv->phys_vec[i].paddr) ||
> 		    check_add_overflow(priv->phys_vec[i].paddr,
> 				       dma_ranges[i].length - 1, &last))
> 			return -EOVERFLOW;
> 		if (last > pci_last)
> 			return -EINVAL;
> 
> 		priv->phys_vec[i].len = dma_ranges[i].length;
> 		priv->size += priv->phys_vec[i].len;
> 	}
> 	priv->nr_ranges = dma_buf->nr_ranges;
> 	priv->provider = provider;
> 	return 0;
> }

I have these checks in validate_dmabuf_input(). Do you think that I need
to add extra checks?

Thanks

> 
> Jason

