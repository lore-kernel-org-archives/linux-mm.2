Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C698C87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 11:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC426B0089; Tue, 29 Jul 2025 07:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4026B0098; Tue, 29 Jul 2025 07:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9646B0099; Tue, 29 Jul 2025 07:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A04A16B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:39:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2016F13414E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:39:51 +0000 (UTC)
X-FDA: 83717107782.08.23A0C4F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7821FC0006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:39:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qpcxA/u9";
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753789189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+zfqBhrGyYtWEX791A2TBxVLYyGOFfzMaosSzQXc4Q=;
	b=kyIRNPweh9VATv43Hub9GiCgLUHfRk2aQyi7JBhcjKtR4Xi9BfgfGBz3WZMBIJg0N1wvWE
	CapJivtCDTOcwhdWOvlkY2uKiAj8REY2a3PndHtN22yo2zoc3ja83m4LR0WgXhfdGDxGqE
	X/KyXYPxB82V7FjTb1d+IiheDSk7de8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753789189; a=rsa-sha256;
	cv=none;
	b=oKDpVXFzLmfL/GD8wzB52CnB6KDnz77nVaxAnJpbSVgC/XaDAJ48T4Qcc0l0kgZlGj61Lv
	KGuR7U+ha2y2kPck4Ikx+TSOr9ir+DTdGfm1sK8nIgz0r3AXAzvKWn97Rgm+8b9o1gK7FM
	/QXjE+kSzrK6tbdh4AXlWTIKmF/irgQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qpcxA/u9";
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 5F36F5C0F2E;
	Tue, 29 Jul 2025 11:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D158C4CEEF;
	Tue, 29 Jul 2025 11:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753789188;
	bh=RPpvSK/8qiFnebjIGVvl4LqDX43VTor4nmtafMFjlfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpcxA/u9Tznj7llG4bq8FgGR6n8loB2QOxor+6SdCBhDOlGqqCbPcbo6ut4+3zXzL
	 O5B+31lN4CYNt7zw8YTEfSBOXxZFWo+0AsNmp1TdE0XL16apisn11dsrtPqTtYAHln
	 VCS+YdU5DPkiycpCq/fSNmsqkqr8kFs7KFT5s5fsNGA/S8X9xcFgGaDoBgAo4DoPRF
	 aMN7RJsq0IlBv4/1hktW6Ljb6F9jYory7s2E+kTM/3t3aXsuUFLKZRJBPZxHTdv1oc
	 KuceSjXps91R6vKXxveoKFcrxBdr11X2quBjbA9AraUBemCTyZvSzA7Y7ok9Ir4LiX
	 qadsSroZsSBiw==
Date: Tue, 29 Jul 2025 14:39:43 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
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
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure
 for cleaner abstraction
Message-ID: <20250729113943.GJ402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
 <20250724075145.GB30590@lst.de>
 <20250724075533.GR402218@unreal>
 <20250724075922.GD30590@lst.de>
 <20250727185158.GE7551@nvidia.com>
 <20250729075209.GA23823@lst.de>
 <20250729085336.GG402218@unreal>
 <20250729104100.GA29053@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729104100.GA29053@lst.de>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7821FC0006
X-Stat-Signature: adeqj3eirdnm7gi5j9sn19db6xoe4g3z
X-Rspam-User: 
X-HE-Tag: 1753789189-647845
X-HE-Meta: U2FsdGVkX18b9mVckEVq5nnFpP3J4TGculco3AOTRU1KWhQwN9boNFB1h7ng7R2ky0zcsvdcUPnhpWeXp7z03+bQimUKRJ+BEvil8e3KldXBnwN6Z1EQWmmnJ/4Nt3NQVW4gMKZ8xXOQEUEQUKLKOHV6mlfqfpDdLF3laeGhCKeIxn1lyBCQdqMut2jLwVPwmd+c35PUXhko2rrwuUpx3QYNHoB6T+JMfCTuye/en+FCP7iw2vjW4+kEgjtlIIgdUa1U4gE4qNESZ/3PnREtWFfM/K0IhM4Af2Zq9VRYxLx55KbiXO2rA36amAhOlGjkxzPmbCOIZvLfkrvW+ZpTzA1+Ckqm4HH+zlrqI5xaAw6wed0IgUZrXOGUMV0fZkbvxGlIO+M+90TpnULemFL1pMtCnBNvX509waTQWHqwNT5R2Q8+RHTL9MQAOD2iflM/HRunKtlF4TpnxjcvQGfzbkRAdSRKXJah62DPf0KGiJiIoKE8wg4E48YQQV2uqJjrMer7yZgTMtCR7FnWMQCklDhnCHs0uy73VtPDeGaSddhmc71Oo7eVbRfJNTYdvIJTIVkC+63jWcv50YH3ABFb3bPmR7Vda52mmCF3jdRnOp8gsJdgKyd89ck3GQd+zYDRiLiqX4Ap0vdXRcQjeE4eaM3XkvePjnoHcOKavvgYwjxK+8IUjSKnkjeCzH1whTSrEiPdiD7Nt0t9DuGbd+a13bUB4vUioBA2YfESUcW8/0Eiedm1FZNq5Ka/EsIqWFpU0Hm/wqMxy9hDMjXA77L4YK1Q8Zvr26xzvzyjlul0tQsevngy6Nh6/jqsDyzZly/LeRbEEPlLXoLyyQadEiVifv6xysWnbkMsuNRXnMu/U7QRGbbdnOOIPEtVLppqvA89gWppS5P6k7b31pctsMblyc+tP+MDIEulNJP1sI/KgylHW+XrflUiPp1MyZ/W/CPczqYInRm+zWekeqQVnRH
 6x/BcmwV
 3gh2wp36RRpJNtIjcUte085xdJ4KkEcay+NAWsEaWJDxM+mBVyMb0SgRN/JJhdOLFx7Vi/YbtxnbLImEe0+zz/uwfyDVnV53PGOoIcelPvlsxtLMvSWdTorq2PpHMzrImUhZGuM/w9k52uOoYwK/xhN1tyVoOuffNzIPzL7FZfQwidesrWgU7VHYNXbTo6dZ8QJ6xQyQupDZJn21HsumlBINoFbTi60EG7LSBNa8Da0jq0IQj9JaeDIhzk6AROITr3dGM2TL7V6wNEYXV+gPslbzgM6j0DXWuDAGo9bMLvNSH0sA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 12:41:00PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 29, 2025 at 11:53:36AM +0300, Leon Romanovsky wrote:
> > > Because the struct page is the only thing that:
> > > 
> > >  a) dma-mapping works on
> > >  b) is the only place we can discover the routing information, but also
> > >     more importantly ensure that the underlying page is still present
> > >     and the device is not hot unplugged, or in a very theoretical worst
> > >     case replaced by something else.
> > 
> > It is correct in general case, but here we are talking about MMIO
> > memory, which is "connected" to device X and routing information is
> > stable.
> 
> MMIO is literally the only thing we support to P2P to/from as that is
> how PCIe P2P is defined.  And not, it's not stable - devices can be
> unplugged, and BARs can be reenumerated.

I have a feeling that we are drifting from the current patchset to more
general discussion.

The whole idea of new DMA API is to provide flexibility to the callers
(subsystems) who are perfectly aware of their data and limitations to
implement direct addressing natively.

In this series, device is controlled by VFIO and DMABUF. It is not
possible to unplug it without VFIO notices it. In such case, p2pdma_provider
and related routing information (DMABUF) will be reevaluated.

So for VFIO + DMABUF, the pointer is very stable.

For other cases (general case), the flow is not changed.
Users  will continue to call to old and well-known pci_p2pdma_state()
to calculate p2p type.

Thanks

> 

