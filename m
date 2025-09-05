Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2650CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51738E0015; Fri,  5 Sep 2025 12:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29798E0001; Fri,  5 Sep 2025 12:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66688E0015; Fri,  5 Sep 2025 12:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B29D18E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:51:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D70E119655
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:51:01 +0000 (UTC)
X-FDA: 83855786322.08.09DE65E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7A329A0009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:50:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hkj6jwvL;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757091059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPSEH+AzhLnejyJgvUoX+DOy/Gpz5ytBdInrHhyhk2g=;
	b=pVnYesQcrkur+eE1BlCpTV+eJ+ZrMrAnIXECG0+zCpTw8sK1QDowkLIeh/mZmicr4TYx0a
	xfLmR8q3AQ42oJT+DQNykqj6UomiTu9wBVK51CiTNn76YSI1ImI4TI/Nmy1ZuRXBN2KXYB
	p61O8T5o8w43aH6rNnypH0vOQPd2UvA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hkj6jwvL;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757091059; a=rsa-sha256;
	cv=none;
	b=qDc0B2XYkle9GwfGGfHG1EIv0/FMmp4Apsg4GWSL7bb8TKj9ISJVvcxFPzHd+0Vj+A2Ucy
	/dy8OXNYBBmL9r+B5QAekBOPZhIl0nVpkCKAwCzdaAFJP0OThXYT2x1KnTIumLNu/k2lvF
	5a3d84PadKRhX+fes3wiV+xxRoOvEf8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C43F43A6C;
	Fri,  5 Sep 2025 16:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291F0C4CEF1;
	Fri,  5 Sep 2025 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757091058;
	bh=ed7tjh37WUsiWKbFsXU4Fz4LWP9OYuSxI0T6PtehL5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hkj6jwvLxKggBm5BaYRmXNHFJSTzS4j//v2v297B9zbvAb6zaXk3ye+d7kJpzYt+i
	 pVjGPf+glYmCMY8ZXxKqFzfErZn5vYpuxstgE5z7K6bWjnB52Zu2pWhWX8YpcE0TZ3
	 wqpQ/atJ+vA0oyDRUVNRdo8I0NXlm4wfllQDaEaUhi9U9aEo4xqnHh2mcEuBjTyxog
	 A1t4vtOjJmcxMXWsrEs0iDeQq9drkmd4Whjs7cSHTOvVKn09EIzsL7m+VCMmXlxsZx
	 LFVA53bS5HpTQKBuuE67ybcB5j6vm/3A//si20RgKUC4Z6Fe/u+7Z/FKOCjsOXLxSF
	 Mdr++eBA7BRQw==
Date: Fri, 5 Sep 2025 19:50:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v5 07/16] dma-mapping: convert dma_direct_*map_page to be
 phys_addr_t based
Message-ID: <20250905165051.GA25881@unreal>
References: <cover.1756822782.git.leon@kernel.org>
 <CGME20250902144935eucas1p253de9e94315de54325cc61dea9c76490@eucas1p2.samsung.com>
 <6b2f4cb436c98d6342db69e965a5621707b9711f.1756822782.git.leon@kernel.org>
 <087e7f3d-1e0d-4efe-822f-72d16d161a60@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <087e7f3d-1e0d-4efe-822f-72d16d161a60@samsung.com>
X-Rspamd-Queue-Id: 7A329A0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e3rroorpnxfocr6m64washuc6dhbgdoo
X-HE-Tag: 1757091059-402234
X-HE-Meta: U2FsdGVkX1/DXScQwcx6tVADkbxy+Eud2E26ej8tXduhBG/T3oN8qhUhpkXcPLzCc0m1U1McHu4RHCyW9xGJZPWa55Omzex/zY1fgxRbcki1kEImQ+M4NNcRz1e637boF57y64pBpXShfG/BCD8DLaaGQY5xASHsdi4M8fZsCp/QFZRZXtYsKljpfK4ySCUb3o6AHSspoat8PcZc7ORwG0BFQD1GQc+vcnUSNYlCwXeUAe7oQdWDdzxGZX3zg9lWBqQvoylhqquV1r4SDERuYGpwe5akHTbvoINi0t5upwNuHbZn1LjrRqHqCEyemEO1ccKSgAuwYPQP9+4m42KmpUUoUb+BgqLXLgJDphkGxn4JU0XXPav2eNmSWou+FncaeoA1uvXMrkF9PctRENFGF5KgSkJGMAQ2/SGdVspCBRudsE7/wzZWGFBUiNJhvZ6RiOczpm4tCsCqqSMnNE1hl97LCOKCODOwRGPImvlhZHQOc1MtfdkHc/c+H5otMV0XUJuGWjMhv8/lJsoxM2yMuXm9/5HgeVXoZVD0tq3lkaJx/tav4f0X95s/TsTpYyOlWL8hOheCXyBVg1qzIuRaAykgoT07pkVyCWmA8E14HxiwdZ57rarDeZjTSnmoVqv8lq9NUd5LchKQFkJ4n9ArbqcdAPkgB336NMfseJ4i0l7busO6zkGQpig+h2sJJ6phD95Qwd4GOlo/YUct0t/SPPACLj5aujBp3AqDd7b4rhNKLDlrdTwkkk1kiPZe6ef7cK8YkFWJLfNLiASBS5xsqfWvu2VTtjE9ygYKKRBU8YqdlDUHfzKK1sAu60S2Iv+SqJ4H4axAegMOXJ9paszU5BoMZUcZ+e1JoVZVGk6wq/+WOuwK+g2Eu8FcA8u19oW2mjtm2t1qL+J6WnSPnZHO9SYotpdVaPINuE2WTqPh5rQyXw0+qOIpQ3plcuCDeFfM+T7N4Sstrmdatsu1An8
 tSHsWT8/
 MMs095urokp63xooXugviCubRQIBlG/8FPxU3zJfLGI4OY9EDEM8erq1sm04SxBDMEHEjuT/fHEqFiB6iwtHMiUyHggJ/1sqwtyGR0mayd/pEqpoq8YPYIvEyFKtp+1bGRuU9MlU4hb78BymMHuppbgY/9x6K6FOTIZItostWzrXFjJzelvps6Z68rYSc/Z8zzDCj218lmpoPzc4q7z+oN/nLcPq51otEMZGvbvpZ07OZ5qSsIy0XitTtwMOdlBOhQPYKV7ftbo9N80H2+f7ZAUgXxk8cXqzR+lquOLguqD4s9LqsknKMW9jtbyflxI2zb3f1bsLILTJ6SKZdSuhwXWDHcNV789dw/WsraoTOyddqHDBIz9I1w7fQw1LVV68luYegDIKmkzP1lV0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 06:21:44PM +0200, Marek Szyprowski wrote:
> On 02.09.2025 16:48, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Convert the DMA direct mapping functions to accept physical addresses
> > directly instead of page+offset parameters. The functions were already
> > operating on physical addresses internally, so this change eliminates
> > the redundant page-to-physical conversion at the API boundary.
> >
> > The functions dma_direct_map_page() and dma_direct_unmap_page() are
> > renamed to dma_direct_map_phys() and dma_direct_unmap_phys() respectively,
> > with their calling convention changed from (struct page *page,
> > unsigned long offset) to (phys_addr_t phys).
> >
> > Architecture-specific functions arch_dma_map_page_direct() and
> > arch_dma_unmap_page_direct() are similarly renamed to
> > arch_dma_map_phys_direct() and arch_dma_unmap_phys_direct().
> >
> > The is_pci_p2pdma_page() checks are replaced with DMA_ATTR_MMIO checks
> > to allow integration with dma_direct_map_resource and dma_direct_map_phys()
> > is extended to support MMIO path either.
> >
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   arch/powerpc/kernel/dma-iommu.c |  4 +--
> >   include/linux/dma-map-ops.h     |  8 ++---
> >   kernel/dma/direct.c             |  6 ++--
> >   kernel/dma/direct.h             | 57 +++++++++++++++++++++------------
> >   kernel/dma/mapping.c            |  8 ++---
> >   5 files changed, 49 insertions(+), 34 deletions(-)

<...>

> > -	if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
> > -	    dma_kmalloc_needs_bounce(dev, size, dir)) {
> > -		if (is_pci_p2pdma_page(page))
> > -			return DMA_MAPPING_ERROR;
> > -		if (is_swiotlb_active(dev))
> > -			return swiotlb_map(dev, phys, size, dir, attrs);
> > -
> > -		dev_WARN_ONCE(dev, 1,
> > -			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
> > -			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
> > -		return DMA_MAPPING_ERROR;
> > +	if (attrs & DMA_ATTR_MMIO) {
> > +		dma_addr = phys;
> > +		if (unlikely(dma_capable(dev, dma_addr, size, false)))
> 
> "!dma_capable(dev, dma_addr, size, false)" in the above line.
> 
> It took me a while to find this after noticing that this patchset breaks booting some of me test systems.

Ohh, sorry, I overlooked it. Do you expect from me v6?

Thanks

