Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD758F53D9A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 20:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A136B0379; Mon, 16 Mar 2026 16:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCD7D6B037A; Mon, 16 Mar 2026 16:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9C76B037B; Mon, 16 Mar 2026 16:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA23D6B0379
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:39:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4CC5E13B2FC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:39:37 +0000 (UTC)
X-FDA: 84553091994.08.814346B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8029540008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:39:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGDr2I5J;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773693575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JL773fp+7I86uFbRtLVl4GoNmlIPg6mffgatF7aX898=;
	b=4MLMcqkBj5X/2cF/gt58BhHpRzwKEYDIJoKrTWywygxjTAAr/7NR6IlUexhEk2llX0S37r
	ccy9gY8c561sjb8dhydbdo3LZQ5wFRCsthAO673xu6ujlq5nwuIkU7H7qbPwQdE+aIHDQL
	mladZiflLmW4lvoWVg2tD5N8z8+UAMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773693575; a=rsa-sha256;
	cv=none;
	b=xjltZVWydQwuXJzzPYdbrCKm8PHNt0B8xykk14pBFkWbiueludZS6a2OtWXDdHhdHTgCLV
	L7Lvb/0TTRHgm8N0iVShp1FJRNHDED/jm0oiBXvp6OfoWYSUOK70La6qlmHLPHaUmvrwhH
	PVZfYbNOqu78NMRdEHhPL6I3IgxGNaM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGDr2I5J;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4137843B6D;
	Mon, 16 Mar 2026 20:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22662C19421;
	Mon, 16 Mar 2026 20:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773693574;
	bh=e3RhwnNiwK1x/eHOGy59Ae3i6XSohKUkLWxBcoMgZBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eGDr2I5JcvQ6vJ3DIMejIHnlwRwdvsorfSEnknaKSiitD38CtJ6sFxept3ygj/Q7N
	 yAHSy9gmn+44EX68ntr5N7Hr8WQ2uFLRO51rUpGyqrMdxu/Fe06F6gFaFDj/J5gVPD
	 QlxnPuZEhN38bbayFCrU9R8lYGXqH4g8vuJoMzQaxmbWIRSldzdam8TNyC7EY61gKX
	 /h4z5PoRxc3DjADAzngUsqiWDjBq3d754JXL4IcedLvxbST9Jh8bftxXsnWoVqPBfC
	 eMpyvvZ+k4OpKkJ98UuclDiF9VFYue2g6aB34fIZRnu2iZFGKN+7STsAmFTQPQBORG
	 PPVv6vlTlCocw==
Date: Mon, 16 Mar 2026 22:39:28 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 4/8] dma-mapping: Introduce DMA require coherency
 attribute
Message-ID: <20260316203928.GN61385@unreal>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
 <20260316-dma-debug-overlap-v3-4-1dde90a7f08b@nvidia.com>
 <659bd750-c67a-4290-8c2d-58bc13c9e2a6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <659bd750-c67a-4290-8c2d-58bc13c9e2a6@infradead.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8029540008
X-Stat-Signature: y9z759i7nbsxiermo7doujuyfzn35xbd
X-Rspam-User: 
X-HE-Tag: 1773693575-668815
X-HE-Meta: U2FsdGVkX18wFZXJXW4MGRAm6iI2pKwsgypIwSKhpph20C64Hn2xr1nwceiLph1XUBugCmXPPlAZrdiC55VUsoEi4dQknuZZgdUIiOc4eqhDQfJ+62M8o1Y0gUawdy+FsM7rdNentIAgC+ldSs3QhR6GnAwhm9nfFNgUGJqO3mwGm6r28oswHjVm8nY6+Wl8NKAhAKpxJ+30b6HQgoudnG5z0XnmMyrMODOUMezuI5fin/0ZXXkBxXWEM9dHO7J9iIecaiqypO4FWQ+/eXjnTkz8RiWfxzJR7psHMxyvnaPItkDwAgPczmjla9dEyLsZxcNf1lWeVNfH+LN0nOh6/4LWHV6GpHHNIs4+CJXv+TeugatgMoRPx58TPbzPYet5HOay9czy4tOC5vMxI3goKYTDtM2VaVdm8kHvIynBK3IgojwTSDyXR5hw/cF7Y1gctF9mztmHt0kL4TLYQEh/IoP10N5QBRFXLuxvrver/MOKWRXrNaiZdBlHGKP9bAtFNGQFIE0iJEBDQ55GlSjkk3fFQiz1v3lZXpDjxF8j3fkPkIoAg57TW93gNMyCl7h0VUaka1Zucz8k64Xd9cVP7dBSwv8vzxxbTvnkkqIJuSHLsr5SLLVVLL0MsH6Yoc3H8fTRbOW26t8zKdQRUUUcZy2/0n/JCnGBBRfADYZeTLQKxfY5Z1K/CRQwjNJjNuIVW6fva9fUHxrrAbIk8bwE1fZQqkWI1R2AKwIYTpaT3jWPJdCUCc+k+un8riOYmyAgro4QkpFlvy4q134hmXuimTdUp34s0EOygOcCi02Abj5bJA+8O5uJGcqIWz3SVIPw/xG10IwhqLh+7LloOJABTDi/Cbo2H2huqhbS1RE12XY6F7ugKn+2T1N3wj6DRo0f6g5LYFwDFmhmxVm23yiQVDWjt/D5dvtU4wyxDK2VNFXX/ICUZt2B1NDqQ/DoeZslPWd45ZRDXjXDr+J8ONE
 FwY6CiKr
 ilCWtrkbRgjUMLnHBQEE46WmLA8kkaWjzLvBoMN0tEKW4ujgLPmBCil+35g57aYPmCgpGYVGhxpbnuYt8VlHMvrLdClnsWRm6uCD+5adYosO7xMXxTdosFhs29xL9IzLP48K6v32IoSOynFWp0dBnfc65+rEJ/IMi4paLm0yh/VEcSP2wHPEmiwGILLR6jW04cNZzelZJlL0xpq1sV5A7gAuOHB/LShep0vZKHjQsSglGkamJjKI0khL1J3v2BmdF2mYB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:17:39PM -0700, Randy Dunlap wrote:
> 
> 
> On 3/16/26 12:06 PM, Leon Romanovsky wrote:
> > diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
> > index 48cfe86cc06d7..441bdc9d08318 100644
> > --- a/Documentation/core-api/dma-attributes.rst
> > +++ b/Documentation/core-api/dma-attributes.rst
> > @@ -163,3 +163,19 @@ data corruption.
> >  
> >  All mappings that share a cache line must set this attribute to suppress DMA
> >  debug warnings about overlapping mappings.
> > +
> > +DMA_ATTR_REQUIRE_COHERENT
> > +-------------------------
> > +
> > +DMA mapping requests with the DMA_ATTR_REQUIRE_COHERENT fail on any
> > +system where SWIOTLB or cache management is required. This should only
> > +be used to support uAPI designs that require continuous HW DMA
> > +coherence with userspace processes, for example RDMA and DRM. At a
> > +minimum the memory being mapped must be userspace memory from
> > +pin_user_pages() or similar.
> > +
> > +Drivers should consider using dma_mmap_pages() instead of this
> > +interface when building their uAPIs, when possible.
> > +
> > +It must never be used in an in-kernel driver that only works with
> > +kernal memory.
> 
>    kernel

Thanks, let's hope that it is the only one comment :).

> 
> -- 
> ~Randy
> 

