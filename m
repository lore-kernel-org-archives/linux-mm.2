Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2EFCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 16:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A838E0006; Mon, 20 Oct 2025 12:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2748E0002; Mon, 20 Oct 2025 12:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F048E0006; Mon, 20 Oct 2025 12:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1125B8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:45:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5803140183
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:45:05 +0000 (UTC)
X-FDA: 84019067370.07.C9D3FF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 31D03160008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:45:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uwACY+gA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760978704; a=rsa-sha256;
	cv=none;
	b=V+sFLEb7HRbf7djqhAGC8KQ/F/dhWL/D9LQvhCFWGDMW5LFWa2iPQMCaZsnxZQpH4IuE5W
	qeRi7Vgn2hjnzNqCCuCjmUnAJM03GfZ/S7aYEq5w7D5/xvv8EipLel+oaZIXFh94kh3e65
	o17o75zhCTFBKotWEFZiBZ2JjFmlsE4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uwACY+gA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760978704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPV9japE8Q7i/VrM2EyftZIZ+EuUryIZ+nlJNHT4Xh4=;
	b=DUVS45Qxiywndb+SxYIQLETVNsK4nkgN0mPdBnqDJbkRmj7ecpim5ZfUKpk9UPCPGtXkB/
	xPOOLlinOUyzTUBIrUR7sDUV/fJX9iD6D5MAdVgTuvF5z3FOfp12UPNgCEPkjvJFN8C3bI
	PFcg8y8rsTvRebqRKpqGPOEh6DyJ+dw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DE5A62093;
	Mon, 20 Oct 2025 16:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E34C116B1;
	Mon, 20 Oct 2025 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760978703;
	bh=TIx5NRTP5K3pYgUiu6kQ2tFh50oiXo0JG1oS7oaLLgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uwACY+gAAHVeDRNLQa9LhoH9lcVFnZPzXatywkYG646bVhvuqsRPN14g1g/VNKLes
	 WYNJREIXrJtYT7QbloBWC3KAb3tT4a4woiFgInEG+Q1ETN0Ps+qgi6JaeRCyXnfGma
	 5sgxwKokkXII1oj9idvsCFH+xzxFf+ctHebO0Crf8NoevzUCnORlmsx2c38BzGnEu/
	 s3EFcu5YRpFtIlMTjRKfKi1EEzzIFI6u24tuPRov6TF1nceX6GqjYmDq7yRyORhFLg
	 hFkabH/anV7vAMpIABZ7pHq33jQbOvDbCcvoCX9x7Rpe/xWcFSBpnYpbbJKwrjEhRF
	 yB30+vyIw7ITg==
Date: Mon, 20 Oct 2025 19:44:57 +0300
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
Message-ID: <20251020164457.GQ6199@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251017130249.GA309181@nvidia.com>
 <20251017161358.GC6199@unreal>
 <20251020161516.GU316284@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020161516.GU316284@nvidia.com>
X-Stat-Signature: 81ak5qo9hi9ccs7wb7tjfi9hjfaoxwur
X-Rspamd-Queue-Id: 31D03160008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760978704-624678
X-HE-Meta: U2FsdGVkX1/1CjgkG9l6aWKMLLol3s9RHm41YRGPpZP3oOyUvnK1N6jcuzNAigofnrMn0WX+xPx3ZHzEFdF1cnaL+RK7ZaQHMDWJdv1yMnLDPe0rZST8lmx377+GNSyMEfa5+P4mU5SR/Jx41D189qEvAGzOLA9hyDZYefwpw/Krkj2C/lm6LMaZGNn+r3MgU6gGpp0Ty+HG4WqmOmBvwcFndJessHgQ87wdn5HXrIGTP/0RSZZQIkLR4AXOH8+8GAXhcypCPZArSCYBzjXANDyANijG4kYzmPl0LHAJl8rncd/sZaL5/LpZDqZvAteKSadzJORp3Lgy2UuWwM/q7Qxz9yMXAR5hwX6BmeoHfCh5Ge7pqmCK4PbRLiioSiywIdmowlug0CZ4q+3RDfASIAbaiOoS84J6lHsWdr6luX1gf5PE15UO+8hrB0wt1DqSBAG8jYu0wA7iPvjK8oPFGNppmfx+jfgGBVaTlSxzQyPxralLb0j0jFkNWhu3KxX3vmjTf1GimMiqRP89pvQ9kDoQ1oVr9B6Xh2XnlF7Xmzmso6ohtFkVMmnG5yo8LBCVd8X1aMC4WOGLLu+o0QauN450yl/O7Fgft3GN+ISzyk5om5CYH+LsJhjkJg5m/QJKfRj5cG4P4M9IHf7YACgspfwqs0IIoPgsupHQ/8+tyIIwiJsdPP6SR9gFAs+euL42YxJAkGjMqhtSrbfPfBw19gTRUc+3RXN92VdY07U/emL54bT7lYWp7CL0kpkqk3lyyE9rJ5v+5+5DdwoWl+B2q04gsSJ78j+QM8qgsLy7wGCqsuQoD/vR9h0XD+EN12Q54ojDCgRM3ab649JPOf8xsZopTBXwV5zJV9LKEZpl/isD+PGt+mt6sD7tu7bawh2V6UtvO0XsXuOGN3lv/FCru1m0md5YnJMmMOXKQKnnrEYkoof4SnZU8MQFYHmcPJkmIllbfo8plGFF1JjPEdN
 XhpSjwg0
 Mw7UA3KSedbDtybRJYecPT7d3AzLc6YMzCcxj7iqsMTQN+C86llccqvp+28U3iIjHn710luSMrBGMeb9LN/687RqTo5C6dO5+2kQu1+paYxsG5pZV1N7tGeqSCpPPBuxMuni/MoorTORwpq1fmV5aPJrVXiA0Jc/bxOkxoG1K2uZahpDmiaOpjopO3Fcy4/stbKW9et8b4ZGmt4r1zi1KuH4Gpq/WXlKK6xaAmQwVjZkkm/pYAXOu9Pv+JZTgHNMrNpg5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 01:15:16PM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 17, 2025 at 07:13:58PM +0300, Leon Romanovsky wrote:
> > > static int dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> > > 				  struct vfio_device_feature_dma_buf *dma_buf,
> > > 				  struct vfio_region_dma_range *dma_ranges,
> > > 				  struct p2pdma_provider *provider)
> > > {
> > > 	struct pci_dev *pdev = priv->vdev->pdev;
> > > 	phys_addr_t len = pci_resource_len(pdev, dma_buf->region_index);
> > > 	phys_addr_t pci_start;
> > > 	phys_addr_t pci_last;
> > > 	u32 i;
> > > 
> > > 	if (!len)
> > > 		return -EINVAL;
> > > 	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> > > 	pci_last = pci_start + len - 1;
> > > 	for (i = 0; i < dma_buf->nr_ranges; i++) {
> > > 		phys_addr_t last;
> > > 
> > > 		if (!dma_ranges[i].length)
> > > 			return -EINVAL;
> > > 
> > > 		if (check_add_overflow(pci_start, dma_ranges[i].offset,
> > > 				       &priv->phys_vec[i].paddr) ||
> > > 		    check_add_overflow(priv->phys_vec[i].paddr,
> > > 				       dma_ranges[i].length - 1, &last))
> > > 			return -EOVERFLOW;
> > > 		if (last > pci_last)
> > > 			return -EINVAL;
> > > 
> > > 		priv->phys_vec[i].len = dma_ranges[i].length;
> > > 		priv->size += priv->phys_vec[i].len;
> > > 	}
> > > 	priv->nr_ranges = dma_buf->nr_ranges;
> > > 	priv->provider = provider;
> > > 	return 0;
> > > }
> > 
> > I have these checks in validate_dmabuf_input(). 
> > Do you think that I need to add extra checks?
> 
> I think they work better in this function, so I'd move them here.

The main idea for validate_dmabuf_input() is to perform as much as
possible checks before allocating kernel memory.

Thanks

> 
> Jason

