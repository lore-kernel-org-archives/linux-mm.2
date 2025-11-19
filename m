Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E4BCF34AD
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AEA46B0031; Wed, 19 Nov 2025 08:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9866D6B00A8; Wed, 19 Nov 2025 08:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2FD6B00B0; Wed, 19 Nov 2025 08:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3B36B0031
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:13:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37A1258336
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:13:22 +0000 (UTC)
X-FDA: 84127397844.03.4EC7B01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A0DD8001A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:13:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GHF1Aqwk;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDmnt2ylN68mKfJ6D+yIzUhJY8ou9retC5vQgYySZIA=;
	b=qkA80qHZn+KMfw3m5xYyGkvrlx8qDdH5m5wAERPw1zpNqvZUQ9iIQ8qGNsGZ32977FYled
	hadLqchp4etOx25i9eMZXaLIzAgIZwiNjcJRJe2MOcrvbEpaNW2ONFDuC/hEOM7J5lquat
	JwgDDZQlWY44zyJDxdiKiDsv89kpc3s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GHF1Aqwk;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558000; a=rsa-sha256;
	cv=none;
	b=S5Yv4bcRR+INuu9+omB5aEppxYmZpKX/VCrEL0srkXHqniBQ81MJmv4jrjjcAxiZnekdqM
	lgJuMYXL2su7TVMvzIRervx0VG743iRp/iW1X4Syx+lq7Wytew7r13dmziyponlI/NBPid
	5Ot7qv9yphBTdakLuYKM8EBiz7QYAEM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29B3B43352;
	Wed, 19 Nov 2025 13:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4F4C113D0;
	Wed, 19 Nov 2025 13:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763557998;
	bh=0Xx39uDqzjZbL4y1fEwlUfWXemPTGRgOd4dvOT2DUMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GHF1Aqwk7stwCyykVPT1YGqLL0q2EFkbo6kN9EUrvLJCQ171txGNyAbhz/88FHaZv
	 9Rhg1BgJ1o6pwk5sbN0PfEDJwC3hklbr2bavfyxMzT01HhF0wF93D31LJijcoJ6gLx
	 RRFCtGxIX1DwUcuBAwzEstv8DSzzM37P+t2zpedyyLBnUf7WSsyc8s20B6dfTtZtYP
	 n3SeovgFnfzZ6hZLrcxPGnzG7gO49j5G0yZ+xF76uYa69LzleVp3n0yOevVQXsxKub
	 cmKcRZl2oO6LkMOz/QRS9gfCL6+6UFT9W06hc6fG68egCXsf1a6inlsq6trLGvRe00
	 zTHjfAjfnTUJQ==
Date: Wed, 19 Nov 2025 15:13:13 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251119131313.GA18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-5-fd9aa5df478f@nvidia.com>
 <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5A0DD8001A
X-Stat-Signature: 3nyfp8kkxrdnorfyxoixfgs97ssi76gf
X-Rspam-User: 
X-HE-Tag: 1763558000-227244
X-HE-Meta: U2FsdGVkX1+lgtDpR6bLa0EFO4WQ1UvQMhYtyhC8RgR0kU3f0yIZtrIgxv8Ma+ddtTs4PBF4K2V7XZWkGCL9/xOCN1XFDrNH4W8pkiipm1A3gi1uV1HGB2XanHomqLZdm6aczye8P3novhuLEO2+v0yeNa2biW1Aq/NL6TfJIHWN1qPacPcoGKrm70TXJDqWrsNYXapBRui61NFRoXIijmAUPXA3c7RY3IZ1jQl+id2IzWyuYO5G5I5fQs0HDJELkD7IKpA+aMxgupbqFoVAupV4qpFueqeyjrk7tdVZvYUYmy+ZgV+H21kMLtT71NT7Bmo3D4XJe+tBGjvH+2aeHnRM5CYv9Oi9HnmcG/q6OgbF69/71yxKSy0q9UHSBYY1dBLXARMA4OlzfvHrH24zcKLvdvliU3NZ03OuPpUilTdVlmJWcOInFXDmniHeguOLs2nBpY4cx/F5yEpyDjjRbT1IFir8vzyYeDwbcmiWF+YCeQzJabZwlcRykB0pkukGatDdx1RUE1YZpzh5USOcTKjvixbMcfCHhChZr6qhZG62CBTU5/oTUH7x048R7zWL/VBq4y9l6W4A29yAY1L+u5hN4nnEgJVc5Sb9O1CF0KyVme3G1+rzXQtJW8N0uYp3iB9dJeQAPGgK+Eg4S/6NF7uQvF1FtKSoauHkZJ6uHWcp94Dmp61I+UCBDKKTa1ob5bPwpE7jDLPt632SBeUCLLyEFAaxKruF1NWsTGED7lGlLoSUFgKaclEvhhws4Za/0+D7oBENb14slhBk1zU3hLKwgB4vC40mqmPYUAIezjsmoA0tPIUcNvTmyyXPcBmvYdNxSBteRHfgzng90JH3d/DGgu8l2IcPdrxP/KevdfiCiAALHkIUIYKCv5Iowj/3XxiyRIFv/LniB07jXIdRK6gIS2ot3lXnnqZlsyM7B9k4Pcr7XOJC7yjA8iJUX+WJXotlP2pJ6dZPn8D+N6w
 RrkPUJYX
 iwCeJ2/2j300poHhtF6SqsN9fmp6tYe3AJZgIP+H6jVLO1lYV7O7D5YWXedRWiSG1R7HC9sipxavXLS6eYCSKGTFwIWjTZ2j2iIk4VWlJW9pGx+SSzYJMVZ8g+kH81NeFI5o/6VfSfbl7mqgt2fWo1BweTr2gx1H+93c4zGSKWZ3XG8ZdEwlixl7ogonQud79WgAi5pZwnYQxwRQ8jNYx0usI2Sx8UTH+wrvxLajGJYTollKV9m2OlWzbn96j5FK5eIkv8VXvw3CXDR2PTAJA/+rfjwrX0mu+uWbxueDxN26/G0I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 10:18:08AM +0100, Christian König wrote:
> 
> 
> On 11/11/25 10:57, Leon Romanovsky wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
> >  1 file changed, 72 insertions(+), 23 deletions(-)

<...>

> > These MMIO pages have no struct page, and
> 
> Well please drop "pages" here. Just say MMIO addresses.
> 
> > +if used with mmap() must create special PTEs. As such there are very few
> > +kernel uAPIs that can accept pointers to them; in particular they cannot be used
> > +with read()/write(), including O_DIRECT.

<...>

> > +DMABUF provides an alternative to the above struct page-based
> > +client/provider/orchestrator system. In this mode the exporting driver will wrap
> > +some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
> > +
> > +Userspace can then pass the FD to an importing driver which will ask the
> > +exporting driver to map it.
> 
> "to map it to the importer".

No problem, changed.

> 
> Regards,
> Christian.
> 
> > +
> > +In this case the initiator and target pci_devices are known and the P2P subsystem
> > +is used to determine the mapping type. The phys_addr_t-based DMA API is used to
> > +establish the dma_addr_t.
> > +
> > +Lifecycle is controlled by DMABUF move_notify(). When the exporting driver wants
> > +to remove() it must deliver an invalidation shutdown to all DMABUF importing
> > +drivers through move_notify() and synchronously DMA unmap all the MMIO.
> > +
> > +No importing driver can continue to have a DMA map to the MMIO after the
> > +exporting driver has destroyed its p2p_provider.
> >  
> >  
> >  P2P DMA Support Library
> > 
> 

