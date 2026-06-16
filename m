Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10836CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061136B00A3; Tue, 16 Jun 2026 16:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0113E6B00A7; Tue, 16 Jun 2026 16:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C816B00A8; Tue, 16 Jun 2026 16:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABA9E6B00A3
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:43:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F89014025C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:42:57 +0000 (UTC)
X-FDA: 84886949994.27.CB74722
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1DDC94000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:42:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Pg/JNMRr";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4ajQemgFpmbOrhSeKWmphC3MKjX+akwoMtIIP/Joqc=;
	b=8CYRnlymaYy0IoOJINEm9uJ+H++isq1T1rptu8/1gxXuu64rNmVqs+9OzvFbuAWZdPkNLe
	NGLz5oULHd+ZjEyZti07zThn8l8UI110kPScJWUjTY/58Vk/qNAEZy1LqYbPyr6e2GNrel
	H63jxKUh+DLzQyft8yld7/Ss4TGFTBE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Pg/JNMRr";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642575;
	b=jo0xDBeka1DwhMlQCyrwhxY9mBV4+83atbSNZcDyl0SJE+7mbkH/E1OnbffA87Osqrlac2
	foQHhDxsJ+1qPNvU6z5rlKVnE03Xq7n70/HLofjc28eMSaXj+ncys/pVqmY4b7uqIt/uVS
	eFJIYhckxlC7mJA089DacVwKAUaZlSQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A4944507;
	Tue, 16 Jun 2026 11:17:37 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D7A63F905;
	Tue, 16 Jun 2026 11:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781633861; bh=K2IjKo4Wn3O01fRwrLGrTisY260F8ix0pXcab0mJkzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pg/JNMRruttP4uU2EfyTL6OzWBb0QGQPaB/o+z2ZnXsM0rK3NsYvRM0YpSnQvlfhU
	 S2iN3nhz5q8lT9uIhr8k0juyGOp/N82uBPy1aDqJmc1+9X1m5j8/gFL6/w1+vxp73K
	 hQK2hyrT8f5ie1L+K2o8m49Ph+5gArucV+q47T7g=
Date: Tue, 16 Jun 2026 19:17:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@infradead.org>,
	Kameron Carr <kameroncarr@linux.microsoft.com>,
	akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org, mhklinux@outlook.com,
	linux-coco@lists.linux.dev,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Message-ID: <ajGTPelKLhgFqh7F@arm.com>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
 <aibhnnDFQTHWMEFe@arm.com>
 <20260611114954.GC1066031@ziepe.ca>
 <aixGqCqKkQeDfUST@arm.com>
 <20260612181807.GP1066031@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612181807.GP1066031@ziepe.ca>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5djtqogcn1oythq6w513xysyrzcp341u
X-Rspamd-Queue-Id: 1DDC94000C
X-HE-Tag: 1781642574-534573
X-HE-Meta: U2FsdGVkX18qQlpfi5xnFEZrZPVA4HzndAF9qI3D6q5yScLSKVCUkdaJM2bbOz7ebvi2neskF1HHYPBaffLNG5YeqWnHCoK/a5gyNCo8Tu+1OoRyTzDpYmR8OybxdfeMSOEbA4uDW86UgK/ASTjV3JhziQGiizTuQRi5U9e8mQB5LG7zOax6zDpcS7K4D+VaHvyR/IJGf+E7Wf76T8kbU3nSe7ZfrltVm9Md10k6wAIlOYx/6Pj2/udMA8mMLe2haM5/AYBhkQtCJ3z+uzifbShxXvur7qUZ4/HKeZ3D2aGV/GK3TcyNSWjI9WCV85FVARYSnt3/DWHlJY2kZJ2wwdsEUljeN0qRWOxksayQoSjRlxxl43y0qvbQWmQhMuvz1h9yqG8e6sQrrTALLBjGwLaSN61N7IEBHXyC95HyTzRSSxt04Da0CzjkoSd87ddf4GkTqBRgFhw3+dYPoOQCU9R6nJ5RMagV0zziaBcyaqrKExQbGkYWLsuSBXxOLm89+OWCnKimoluO1FJRySnN4CjlPbTThpVe25b2oSO3vxOxXM7uYlrFJE4VNXFfQiz2UZnQ11PFZaDkr7HH3FBK+I0Z1pGylnFIJkV9ruIaRanZg+bN2AS6qXhkDe/KOXpccnDy6fhOMzH5a/oTz11O5UrMXfywbn8PvmuXeQEvgdBCCMkbupQO6Y+kLvhDb+yyFryk0o4WoB77t9JXKKO7Aom+0KQqffenGeg1cQQ7z4zclBbIYnnpWUTX/dzW/d6OgIVc773wvZdqtckWw7WChrAXydvZ83ksdo6qk8qND5lTWhibevMM00du6tPsuOTBYJznCqTmaXaDcHcNGKLMSgUUbKEH5Iec7gCmnTIc0wSjbK8ajwR4G7RtPgaaRVAUqWDX+kdfnzUH1en6yvSNbMQtcuT+PCzes+eZJowqaO0Bv8443v90Iaz4upHmkZHSxSM2igYa3HEdSx1CEx0
 7lVikEX2
 PO9iszNtbUYAhGHrCO34vMCwHuYAIZK53k6SkCai7RuQ1awt+a2b/sU1kMJxo+XYkxILE755sqT8Tiuk887eJpVfr8+QYGixDnQxNcSnPhF6zqgZ/X+BnPyFGhWcHKrQbHPkNIqnxlikIEVDW+GS/w1Z+SgQ8x4j/T9cEIIbMNiufzkEkowjSyB4DuPSlGmdJ5uolH1Lz5QbppQ9TtzamuNS8iyE1zgglhbCXkxnnIOlbyx5gApSMaxF7pEa2AuoztsnrMIdOy+nZKVH6x2AxU846mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 03:18:07PM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 12, 2026 at 06:49:28PM +0100, Catalin Marinas wrote:
> > On Thu, Jun 11, 2026 at 08:49:54AM -0300, Jason Gunthorpe wrote:
> > > On Mon, Jun 08, 2026 at 04:37:02PM +0100, Catalin Marinas wrote:
> > > > > +/**
> > > > > + * vzalloc_decrypted - allocate zeroed virtually contiguous decrypted memory
> > > > > + * @size:    allocation size
> > > > > + *
> > > > > + * Like vmalloc_decrypted(), but the memory is set to zero.
> > > > > + *
> > > > > + * Return: pointer to the allocated memory or %NULL on error
> > > > > + */
> > > > > +void *vzalloc_decrypted_noprof(unsigned long size)
> > > > > +{
> > > > > +	void *addr;
> > > > > +
> > > > > +	addr = __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
> > > > > +					   GFP_KERNEL,
> > > > > +					   pgprot_decrypted(PAGE_KERNEL),
> > > > > +					   VM_DECRYPTED, NUMA_NO_NODE,
> > > > > +					   __builtin_return_address(0));
> > > > > +	if (addr)
> > > > > +		memset(addr, 0, size);
[...]
> > > But what is the purpose of this? I guess some hyperv thing - but
> > > shouldn't we have a more structured way to "DMA map" things for the
> > > hypervisor instead of stuff like this? Why can't you use
> > > dma_alloc_coherent() which actually gives you an address that is
> > > sensible to pass to the hypervisor?
> > 
> > IIRC netvsc_init_buf() uses vzalloc() to allocate some memory and that
> > buffer ends up in set_memory_decrypted() via vmbus_establish_gpadl().
> > arm64 does not support changing the decrypted/shared attributed of
> > vmalloc mappings and I don't think we should add it. Better to just
> > allocate it properly upfront.
> 
> Sure
>  
> > We might be able to use the DMA API but we won't get something like
> > vmalloc() - physically non-contiguous. 
> 
> The entry point is dma_alloc_noncontiguous() and you get a scatterlist
> back.

Yes but not scattered pages unless there's an iommu behind. Anyway,
that's an implementation detail, something like
dma_alloc_noncontiguous_vmap() could allocate scattered pages as a
fallback.

> > I think dma_alloc_noncontiguous() just falls back to
> > dma_direct_alloc_pages() in the absence of an iommu.
> 
> In all cases you get a scatterlist with a CPU list and a DMA
> list. iommu gives a smaller DMA list.
> 
> If you want a vmap then you can feed that CPU page list from the sgl
> into vmap().
> 
> A dma_alloc_noncontiguous_vmap() helper would not be hard to make, and
> IMHO, would make alot more sense for hyperv to treat the memory access
> from the hypervisor as "DMA" instead of trying to re-invent the DMA
> API.. :\
> 
> HCH was already saying we should not be allowing drivers to use
> set_memory_decrypted() at all, and hyperv is the biggest non-core user
> right now...

That's a good aim longer term. I'm not familiar with hyper-v but I think
it needs a mix of private or shared allocations depending on whether a
paravisor is present. That's handled by the vmbus code and the
information is encoded in the vmbus_channel objects.

Currently, something like netvsc_init_buf() just does a vzalloc() and
passes it down to vmbus_establish_gpadl() which knows how to interpret
the channel encryption status. I assume with the vzalloc_decrypted()
API, that info needs to be interpreted at the netvsc_init_buf() level to
know which allocation to call.

If we move towards a dma_alloc_noncontiguous_vmap() API we need vmbus to
encode the encryption requirement in the hv_device::device somehow so
that force_dma_unencrypted() knows what do return. We have the
DMA_ATTR_CC_SHARED but that's not interpreted on the DMA alloc path, so
there's a bit more work needed on the DMA API I think (not sure whether
Aneesh's series covers any of this).

-- 
Catalin

