Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56987C87FCC
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 19:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3D46B007B; Tue, 29 Jul 2025 15:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C366B0089; Tue, 29 Jul 2025 15:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8A26B008A; Tue, 29 Jul 2025 15:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA16D6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:44:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 147C11336E4
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:44:51 +0000 (UTC)
X-FDA: 83718329982.03.9E62945
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id DFA3EC0004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:44:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753818289; a=rsa-sha256;
	cv=none;
	b=FeRGNramKzWPdy9AtMnfBBje6Q6ffXIel3fy//82fzZL81SOgMfSFPTrZaTHhPwEEAyVzd
	XzkRrGqz06DkENVuRl90uldUKIRQjUQqtAG1Wjrg7gbWLsvf4xLFeWlivbs2IJeWjnrPw8
	wSlHZO20rFELOBBMdZl3oW4N3n9VmsA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753818289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SqeBcz2J/jm0Yq9dFG13AgVzU72MDPwRgQecrD3fw80=;
	b=WVwymPNq2L4GKu51WsrgM71B8yTrjfvKFfqHSvhysHpmGFN26A8td73rpkXk4oIYVFuCYf
	hRd0E7iwu/sJI8AMx7n8CgReEb/kqv/I1GHHEC5Nzj7idOxcro6BKM6oAUEF4k2fTTkvOm
	vV3r+HpBVXGfd4wSxumFA1OXqYXqc8w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA8F71516;
	Tue, 29 Jul 2025 12:44:39 -0700 (PDT)
Received: from [10.57.1.109] (unknown [10.57.1.109])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2D313F66E;
	Tue, 29 Jul 2025 12:44:43 -0700 (PDT)
Message-ID: <8f912671-f1d9-4f73-9c1d-e39938bfc09f@arm.com>
Date: Tue, 29 Jul 2025 20:44:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
To: Leon Romanovsky <leon@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
References: <cover.1753274085.git.leonro@nvidia.com>
 <aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wcssbo5w63y3yhhxwnrua9px34kfhsxu
X-Rspam-User: 
X-Rspamd-Queue-Id: DFA3EC0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1753818288-874801
X-HE-Meta: U2FsdGVkX1/q2upBGka37RLWibxmXYh6ZLJvsca6wUs1a2Otu6dwurFYwkFgXEgSVP6hIAJBUqsIvQ7WAEo+mm+DeQw7PJ4mli5SYnJGIgPo7LMKDPRny5oMEV5olBZLGiPPYTKMr5wXdjFUReZtuKsQXKanK7Y4ttycP0kyGLzrWV6CptaQYQ1QNY4Cu5EHdIZA3Gp8PXxXjnMkXF2hhgoJo8AnpdkKWD0uLapZKKCVM5qs3E5wfjLnrDaJkc5Y7cIenXQIgG8Gjwx4UG76CV+DLENziKPeNl60ijig0jouqHi8//JN5TZIYMnLl1dhgcfUCHlI+ipH0Vv8tRjywRpyuPRFYQA/HG/gzeMrrzuv0weo2lIk1p8KN6nrwHR2PcTVdzafzz9SaWBUyPYx2Ia58sUgLWQ1uJ3yCCsvVBr6+Q3jG/d2I4xceok6BotQHwxgTC28HMKIu2I5Gafs3Q1kgkAbQb4jzExOYOKtlW2tYLosKdlPJsmKGP/DGHw50+oC6Li0CgWNKEwV75r2dlcfMQz4Vk0on1wd6J9cdvjsOfdkHoNa8Iv/pkWFkpBV2L+vjupDdhYCUCMbRFq/GhWRZyPmRBmOjzMdXqW4PYYjsLeVu9uFm/qhfycq1gmGaYuDGvqdH7Y8WFJJZW5TeSsCR8ef54iWI6Lp9bShN8Ru0vDfv5BYxEGHrG9/Qe0hT1xCkmfFYFvvs5xhEJsnidxQRoXbyZ8PEKgv+i3g9GMzeuafzmm7qCwkYwcU7WMZ1Lz3QxPyFuQQlgC1HEtXSwx+rBclFJzgksdi7nH6Seu24lbCPn/C/oTs4MvRRlB53DBou9UGgfQ2vGGDQsSWPe/tg3iSTyGM961CyI/FOeS/UfFf/JJ1BcHyoFb4vo0AMpo69EFwojfGr09qlv38naNQZLWqd382uqn3214OsCc3evbwAovJldu0N2nbrNTcnkE+LcSl7vNwF1fbYHG
 I8EoMl2N
 VeQ3dP1v5bHA1RR1ZxohYNyvcvE72Xg0O8BIrLRNEkt43qh4ZE0zd6ZpLFfe8zbMzUuDcqkIQSP0/cYUpAXkhqFttikL3ncynQl1lXmOdgfxcjGN3WTAIok4IBFcFB16u2Ov/Ph4Hc4TRvx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-07-23 2:00 pm, Leon Romanovsky wrote:
[...]
> +static struct sg_table *
> +vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
> +		     enum dma_data_direction dir)
> +{
> +	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
> +	struct p2pdma_provider *provider = priv->vdev->provider;
> +	struct dma_iova_state *state = attachment->priv;
> +	struct phys_vec *phys_vec = &priv->phys_vec;
> +	struct scatterlist *sgl;
> +	struct sg_table *sgt;
> +	dma_addr_t addr;
> +	int ret;
> +
> +	dma_resv_assert_held(priv->dmabuf->resv);
> +
> +	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
> +	if (!sgt)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = sg_alloc_table(sgt, 1, GFP_KERNEL | __GFP_ZERO);
> +	if (ret)
> +		goto err_kfree_sgt;
> +
> +	sgl = sgt->sgl;
> +
> +	if (!state) {
> +		addr = pci_p2pdma_bus_addr_map(provider, phys_vec->paddr);
> +	} else if (dma_use_iova(state)) {
> +		ret = dma_iova_link(attachment->dev, state, phys_vec->paddr, 0,
> +				    phys_vec->len, dir, DMA_ATTR_SKIP_CPU_SYNC);

The supposed benefits of this API are only for replacing scatterlists 
where multiple disjoint pages are being mapped. In this case with just 
one single contiguous mapping, it is clearly objectively worse to have 
to bounce in and out of the IOMMU layer 3 separate times and store a 
dma_map_state, to achieve the exact same operations that a single call 
to iommu_dma_map_resource() will perform more efficiently and with no 
external state required.

Oh yeah, and mapping MMIO with regular memory attributes (IOMMU_CACHE) 
rather than appropriate ones (IOMMU_MMIO), as this will end up doing, 
isn't guaranteed not to end badly either (e.g. if the system 
interconnect ends up merging consecutive write bursts and exceeding the 
target root port's MPS.)

> +		if (ret)
> +			goto err_free_table;
> +
> +		ret = dma_iova_sync(attachment->dev, state, 0, phys_vec->len);
> +		if (ret)
> +			goto err_unmap_dma;
> +
> +		addr = state->addr;
> +	} else {
> +		addr = dma_map_phys(attachment->dev, phys_vec->paddr,
> +				    phys_vec->len, dir, DMA_ATTR_SKIP_CPU_SYNC);

And again, if the IOMMU is in bypass (the idea of P2P with vfio-noiommu 
simply isn't worth entertaining) then what purpose do you imagine this 
call serves at all, other than to hilariously crash under 
"swiotlb=force"? Even in the case that phys_to_dma(phys_vec->paddr) != 
phys_vec->paddr, in almost all circumstances (both hardware offsets and 
CoCo environments with address-based aliasing), it is more likely than 
not that the latter is still the address you want and the former is 
wrong (and liable to lead to corruption or fatal system errors), because 
MMIO and memory remain fundamentally different things.

AFAICS you're *depending* on this call being an effective no-op, and 
thus only demonstrating that the dma_map_phys() idea is still entirely 
unnecessary.

> +		ret = dma_mapping_error(attachment->dev, addr);
> +		if (ret)
> +			goto err_free_table;
> +	}
> +
> +	fill_sg_entry(sgl, phys_vec->len, addr);
> +	return sgt;
> +
> +err_unmap_dma:
> +	dma_iova_destroy(attachment->dev, state, phys_vec->len, dir,
> +			 DMA_ATTR_SKIP_CPU_SYNC);
> +err_free_table:
> +	sg_free_table(sgt);
> +err_kfree_sgt:
> +	kfree(sgt);
> +	return ERR_PTR(ret);
> +}
> +
> +static void vfio_pci_dma_buf_unmap(struct dma_buf_attachment *attachment,
> +				   struct sg_table *sgt,
> +				   enum dma_data_direction dir)
> +{
> +	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
> +	struct dma_iova_state *state = attachment->priv;
> +	struct scatterlist *sgl;
> +	int i;
> +
> +	if (!state)
> +		; /* Do nothing */
> +	else if (dma_use_iova(state))
> +		dma_iova_destroy(attachment->dev, state, priv->phys_vec.len,
> +				 dir, DMA_ATTR_SKIP_CPU_SYNC);
> +	else
> +		for_each_sgtable_dma_sg(sgt, sgl, i)

The table always has exactly one entry...

Thanks,
Robin.

> +			dma_unmap_phys(attachment->dev, sg_dma_address(sgl),
> +				       sg_dma_len(sgl), dir,
> +				       DMA_ATTR_SKIP_CPU_SYNC);
> +
> +	sg_free_table(sgt);
> +	kfree(sgt);
> +}

