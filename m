Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B61BCAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 05:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874B28E0003; Mon, 15 Sep 2025 01:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825348E0001; Mon, 15 Sep 2025 01:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762248E0003; Mon, 15 Sep 2025 01:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6293B8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:48:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB3A8B993D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:48:32 +0000 (UTC)
X-FDA: 83890404864.23.87E6620
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4E195C0003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:48:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHe7Ty6+;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757915311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYGxSKxIntCmmxlTkPQN7pDPF0lWTajFhOWCO8Yt19o=;
	b=ZnZF7yCtAaTAG90p+1/b/gZGz0z2w9MUv8mJq/sznLfmGd0CBClzGNOzY1YxRWjNJ8LDx/
	ppu7FeX45lsx72yn5t2hrMPGzarLz1F9SCSK5faSSrWPgSYf8bzCjEysaTQOP1Ld8MJ2et
	6bxmxfQknCCKhD4OYm9qI3O1SlT+3uM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757915311; a=rsa-sha256;
	cv=none;
	b=itK8T+jZcBVVaPQCBfC2TibQjReUbJWStFIbhbTp7kW7mqNwCRpQLZCY04fe2QLh5VQA6T
	GkFy/0LRD49o1L7o7+9cxBDlV5CnvrlCE7suf4jTkPxqNdbKGv03dtXMarrspsQj1AxGtV
	TROXpemEQ8MufkVTSzoNWG59saNK9rU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHe7Ty6+;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 664E643F68;
	Mon, 15 Sep 2025 05:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9696EC4CEF1;
	Mon, 15 Sep 2025 05:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757915310;
	bh=pNhpXvcF7LKn5UVncvyxPjpBkffgzOi8e5YEIYnOU1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nHe7Ty6+c/JGvDY+UydwDMZNts0Mvoe5CmZXEM3wRbXlJQZsiKQbiHX1dqED8BM6L
	 jhMyqCWP4HV33158JPyukMw9azmtNrGpkymRgEWzH8txAsk0rOblpfGqGH9ecTIJff
	 SsLxSOkvzP5SEsR+y+RlPv8/wUQ9v3p6CHq91exxQSTUKjsxYQ6lnV1GyfIF3fLnn7
	 aD6U1ucW6cOBHuGB2utJFKkQvvAjc/DWH2//axsYKrHMDRKhgk/Ut1ZqFbNUGkItPt
	 mky2sisAv2UghibJpCApHoRxj04wcBuUhqn0dWEmz2sHkq/6x1znCKDKs3Y1Qa1pZc
	 pNH0C9osgWH6A==
Date: Sat, 13 Sep 2025 13:19:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v1 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250913101933.GW341237@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
 <aMRsoUx/NH/Dspm9@devgpu015.cco6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRsoUx/NH/Dspm9@devgpu015.cco6.facebook.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4E195C0003
X-Stat-Signature: 3dwxpys3b5p7m4zhfgtesw6rtepdypgg
X-Rspam-User: 
X-HE-Tag: 1757915311-103123
X-HE-Meta: U2FsdGVkX1+a2HD+Q2DR1XNikZWHYF2VMyyu8yNj3MvWhMyDiQEbvuS3sttImqmhHwDOHinTVzQPtoU/L+maZUBlHhMamDSBJ29j0XwI+bP4m96BkkGw7A9OaDY9zkJJe6D225ArJaYQqZpTgLLavqJN6VkFzeHJjGzVQr/dG+Tk5ITcVYbeRWk2hGfMFOgOQ18g1nil56FfRbQ9VI+SMXyhhqXW+xqumuGVMHA4j33cgYkeYfDewQx4mRW5xHxD7hbK81Rlsa8wtlcCuN9j7+jLHjE6MOSuhBT1ZZcIGDxm+Yoqs9ct8CAMOtsberk5D8m2ZjlXptDvt41eOaWmgYHwc4GCaxg5rmWlBUGNVlRvzYDJws6XLSseDV3bZVqXk7pCAKtUSNXNJ19xQ/x98kGDOTfCCwLTD24SEu0PNfJC6BrVWFTmBJhOqRy+p1IX2cH+scnhE2L4gFcmKS93eoJ/mNkTKpKAfjE/ksKNz5VZNTwkXchI/ZtoYfttIpq6n2g3leKtjLhIQDXXXB9Mtq6WBbh05hkJ/qVFstj18g4ReStfMh5Tpq8D32QPx6+leKZw0T2TW3hwcwBcmWrTawfwVWQAFg1GAr4jd/hRrzbIE5yZkmMDU1LyTvj0BejQYWCX5YMV8jnChYPIiL5NxzK/dg8leUkSFqQpmmnhsQY/mqtvjcstsqCdBplxaAhAk2pYKezjheH2Cm8Z3TcVSyABeyV8eiJQsR7PFqKgyLulC2CA4AnpZzZxW+j09M/V0FMZDWwhxbTXv20P2b0D4KXa2SgpeXe72MezhMGo6s3MOxVCD3qEfWQPZcOQWc+HyUehQleepnzUphOq9bErVxc+UBnyiSjTungwei6Ic45+OlDPm6UOrhSNK6Kxd9MBV0S9FacgDjAHO3E77kgNr4uSg4YA8wWr+nU9T3c15fQ698ylqogXhbKEhwd8or2TpDY8Ydy8GLnTJoT/Ygq
 ZN1pp1/x
 jGDmZp1Cy3epL5w/k9LLrki9mGaAuwgUI2oxExyBdFurQG6cddXjZgOOclt60JpiObhSu5M2p1RhigNXSRAojq707aurYCAderQsvsXdfqHUIR0P/XGqsDXBlppiVzWkDTVa+9SygQussvlyFuPrmWo1PHDAj9LxZySLQDJk4dsjsUljCwxwUOu6sE04zH34+JxTpA8EpNJVY7axK+E89FsdeNvtQsGV6KSWrNNKRNUxiPVyGxdzL1ZGJYZzWLUsDd3roxZqBQS5WRyxTDkWPyKdGTIDOzXxZ63+S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 11:55:29AM -0700, Alex Mastro wrote:
> On Mon, Aug 04, 2025 at 04:00:45PM +0300, Leon Romanovsky wrote:
> > +static void dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> > +				   struct vfio_device_feature_dma_buf *dma_buf,
> > +				   struct vfio_region_dma_range *dma_ranges)
> > +{
> > +	struct pci_dev *pdev = priv->vdev->pdev;
> > +	phys_addr_t pci_start;
> > +	int i;
> > +
> > +	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> > +	for (i = 0; i < dma_buf->nr_ranges; i++) {
> > +		priv->phys_vec[i].len = dma_ranges[i].length;
> > +		priv->phys_vec[i].paddr += pci_start + dma_ranges[i].offset;
> 
> Is the intent really to += paddr? I would have expected a plain assignment.

In this specific case, there is no difference, because phys_vec is
initialized to 0, but It needs to be "=" and not "+=".

> 
> > +		priv->size += priv->phys_vec[i].len;
> > +	}
> > +	priv->nr_ranges = dma_buf->nr_ranges;
> > +}
> 
> ...
> 
> > +	priv->phys_vec = kcalloc(get_dma_buf.nr_ranges, sizeof(*priv->phys_vec),
> > +				 GFP_KERNEL);
> > +	if (!priv->phys_vec) {
> > +		ret = -ENOMEM;
> > +		goto err_free_priv;
> > +	}
> > +
> > +	priv->vdev = vdev;
> > +	dma_ranges_to_p2p_phys(priv, &get_dma_buf, dma_ranges);
> 

