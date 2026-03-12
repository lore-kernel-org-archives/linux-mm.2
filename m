Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B36106ACD0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383196B0089; Thu, 12 Mar 2026 12:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330026B008A; Thu, 12 Mar 2026 12:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211536B008C; Thu, 12 Mar 2026 12:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11AD66B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:46:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0F26139D95
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:46:28 +0000 (UTC)
X-FDA: 84537989256.27.B73E462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 07A171A0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:46:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AZmu8XZn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773333987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29oqf5KVgFdF/aOJVVVofvCsqM/zUxBmhbUZyRVKZ4M=;
	b=QS13Ra6USlZPi4Sj9NAOSV0fJANDKVyLwlJziyiRJxBQeOqO4yemFIC20zvla1cjoOG5ec
	bKHGz7z6cUeEf8xrgSHpiRhyziFzMfv/BDVCaJ7xaC03Lhl6R8YHevhNivlIG+SOdmjSV1
	H6YcQ4KKCt7deVtUmZli7LLE/kxHjAw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AZmu8XZn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773333987; a=rsa-sha256;
	cv=none;
	b=A3aiBZefzyp0pvY2ixVz+84GViPlCXMPzu0s87vhL6c8Yy4a8umvKI2EtEqHbAyiWQrwRH
	c2hoXEyjo9mypxAC2iJubfw1pmWVSkacpZ16DlXcTQ8RRP+DAkHKPpB3qsDlSvXS7mO76n
	TxrERekJCDPEQFXCLfjnFp1WweaKVEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 026FD405BD;
	Thu, 12 Mar 2026 16:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E9EC4CEF7;
	Thu, 12 Mar 2026 16:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773333985;
	bh=g4W57IAgppszhhmuom1c6GdIWffwgLTuE6LrTOJwXps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AZmu8XZnuXQA+Zlr+DGheTwhpLckrEO2t6JNHpcxW0vx7U575iAJy32RP6EXBhWw6
	 eBEt4hHQC6MmOaapPF0E0vmRmScasxsxx+W1xSJCpjsIJb5Rxt9yi+poJlX1dA9KHR
	 doFbcFgH+JNRk8+fY7aFKcFVBKHMLTKw8lW75K7b2L8zlLxtABKvR0f2TNL7Fc7kuM
	 n5diM3RZ+ujPHLJoj6PqBRojByoKgqXep+yXPg2a5K8Eb8QXHhr7WqRwTdcaLIbzx8
	 7hiitACIX5AqL902Vp5+AQyG4SquimpfkKuxsVAi/vLG5ezGXH0PJvYL+F3BkyVjOk
	 BbhQwqQ69ra8A==
Date: Thu, 12 Mar 2026 18:46:22 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/8] dma-mapping: Introduce DMA require coherency
 attribute
Message-ID: <20260312164622.GZ12611@unreal>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-4-e00bc2ca346d@nvidia.com>
 <20260312121937.GD1469476@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312121937.GD1469476@ziepe.ca>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 07A171A0005
X-Stat-Signature: dnazw3kbixtq7se3yezwhg3qp86ier89
X-Rspam-User: 
X-HE-Tag: 1773333986-79323
X-HE-Meta: U2FsdGVkX1/n4AIxaznetw6of6jDbFHVAE40S+K56hGKNrfksSwenWDE9rWIDNbUJNrbn0iPtwUvF1QPxF8HJehjn1wghHrNyiyFruzKYzhSgGUqh6hYMc/gMZnfMAL+B1FnG3PgEPMQjoiRZ3nTnKGnunmz3gZcWnN9AZb2ZwyD4l9bLoN55Tbno5nUgVgArIpzGRrYhQLUdT1oyi5Z6B4cFjCSMKqvDbC3MLNxugvNf3OeAm+AhhERsomA2p77vavgEuautGoVAxrMwQ99v3h7X5pmTNATzTGm55jYLd3U+V1iT8yUfOm3u0ixxJgZ5k3Bcbv335V6NBcCplf2jP3uAXjCgtfLXd8mmjTFKl8NEU1issvSTIax36dFV0izWVKH2SLVzHpyDQfWg9uAQYv6kdn5CdLLtarh9XeJF/eDkDtEBvhLdnLqWf8TT1i4XDW12X7HkpXSiZTl9X7cjNSdUBW0oT5P5VECb2i3EcoW4oOBXGcgbUJ3hJn5+U6Z78Wut0SmN/1P3JruhkO8ahgheXDv7CLAEhXmT3Ds4PLztLBWYXR8+tAFhqtIx4OA8i12/pm4j80yNGhzuYnfpFI39nVExICYFvaQzdcrUo3Cn50ZGEBqcHGKgaOR3Jus8q8N3uYw7EPrla0j+OwUrN3qWy0J/JalmrE4Ofq/qzbChVaQosRTZ/yN5hH4IzpbS6GILi0yZjv+x4yLByV+nHW/18AXN8canhSLHQUvhtB1y6IfFg6V2XOQnDiH8Dl/VBmaKrdIcs0oxlUpi5oWo3nkNcjQNh1XUFZyvCABJ2o1wfCMpD/AULwGzOqq4boWGLfKsZrwOo4XoXOroc9NhREFG8BS5Tv3w31MjtKEiYhxnQP4Rps7f9GT5nGeKpc4Kk2XeJICmfXlzgp3vAiGlJV7tsymeJQEFbOAshhFaaR4tuL0yd/D8AdQRa0sMk7j53IOzhNCyeEMQLblBu8
 xGIEjMo0
 xokrCQOfZgvoE7MFQzxOOVUWs9PpDXVzYrskCwOqYVacQvVjuDWcj+Zrnm7CIx3G57g6/XrTGBPD7trssm46C05L9DMz7imaXap4e8b/Boft/eSr1fcv+/N9rf+QyhO2JfCBWErzeiiWJvop7A7mOvONzyLKvIg+NNaelA9q53YlPg0fjvF4LhYW1VhAU3C5zmsCaAJ5ypLpBCdI2zmlvyYHe6uPQUk7zmpYkS54VgvOMIfywxPG0Zd3WJoBSoNod9gMbm06kwh7ftLUkzxal+/ariw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 09:19:37AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 11, 2026 at 09:08:47PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The mapping buffers which carry this attribute require DMA coherent system.
> > This means that they can't take SWIOTLB path, can perform CPU cache overlap
> > and doesn't perform cache flushing.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/core-api/dma-attributes.rst | 12 ++++++++++++
> >  include/linux/dma-mapping.h               |  7 +++++++
> >  include/trace/events/dma.h                |  3 ++-
> >  kernel/dma/debug.c                        |  3 ++-
> >  kernel/dma/mapping.c                      |  6 ++++++
> >  5 files changed, 29 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
> > index 48cfe86cc06d7..69d094f144c70 100644
> > --- a/Documentation/core-api/dma-attributes.rst
> > +++ b/Documentation/core-api/dma-attributes.rst
> > @@ -163,3 +163,15 @@ data corruption.
> >  
> >  All mappings that share a cache line must set this attribute to suppress DMA
> >  debug warnings about overlapping mappings.
> > +
> > +DMA_ATTR_REQUIRE_COHERENT
> > +-------------------------
> > +
> > +The mapping buffers which carry this attribute require DMA coherent system. This means
> > +that they can't take SWIOTLB path, can perform CPU cache overlap and doesn't perform
> > +cache flushing.
> 
> DMA mapping requests with the DMA_ATTR_REQUIRE_COHERENT fail on any
> system where SWIOTLB or cache management is required. This should only
> be used to support uAPI designs that require continuous HW DMA
> coherence with userspace processes, for example RDMA and DRM. At a
> minimum the memory being mapped must be userspace memory from
> pin_user_pages() or similar.
> 
> Drivers should consider using dma_mmap_pages() instead of this
> interface when building their uAPIs, when possible.
> 
> It must never be used in an in-kernel driver that only works with
> kernal memory.
> 
> > @@ -164,6 +164,9 @@ dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
> >  	if (WARN_ON_ONCE(!dev->dma_mask))
> >  		return DMA_MAPPING_ERROR;
> >  
> > +	if (!dev_is_dma_coherent(dev) && (attrs & DMA_ATTR_REQUIRE_COHERENT))
> > +		return DMA_MAPPING_ERROR;
> 
> This doesn't capture enough conditions.. is_swiotlb_force_bounce(),
> dma_kmalloc_needs_bounce(), dma_capable(), etc all need to be blocked
> too

These checks exist in dma_direct_map_phys() and here is the common check
between direct and IOMMU modes.

Thanks

> 
> So check it inside swiotlb_map() too, and maybe shift the above
> into the existing branches:
> 
>         if (!dev_is_dma_coherent(dev) &&
>             !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
>                 arch_sync_dma_for_device(phys, size, dir);
> 
> Jason

