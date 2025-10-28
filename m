Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93CF6CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 12:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47958013C; Tue, 28 Oct 2025 08:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EA580131; Tue, 28 Oct 2025 08:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C9A8013C; Tue, 28 Oct 2025 08:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C389580131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 08:02:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E3FB1A0450
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:02:16 +0000 (UTC)
X-FDA: 84047385072.06.FE94CC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A79B62001B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:02:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwZX30kq;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761652934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfMsea7TQrE0ohU/AUK+mCK7z9z1HMJ9p7hWvfgND/Q=;
	b=e/Dt5N7y9hpUb1C7+tQvKS+0+JQRFL7q9HYSiIqfutloZBvHqSVrDVTMTerPqhioBomaX6
	MB7cVzGiiKFawcduZdBg6BFaMjHqNIJwL0DUNP0wTLS8ZQKxVf1ePjAqV626l8WfAQAQxt
	aZfoTiHQK2HK1/uUSD7fzgo3V8xPJ6s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwZX30kq;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761652934; a=rsa-sha256;
	cv=none;
	b=8XL3ptBK6B+ThMUnSfL7K+UawgLQqx9zYiMl/Pu8Y9ge6SluWvt1VoNByQbgyvPDB5ELbQ
	os2VN4618k0yIY8mURUWdTm52AR6hvokqipolnJMKk3o5d5C7gE22QnGrVt0BDJkyHusKg
	BoCktpf7UX471k6N8lmfko/UUt5RS+g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71695432BF;
	Tue, 28 Oct 2025 12:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F27C4CEE7;
	Tue, 28 Oct 2025 12:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761652933;
	bh=mZf/YKmsAob1fECJczEmiCct9PI3ELB+8/2Zjo1x01o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwZX30kqTRxKywW3JAgQpZq9YEFkCs4mbYnsls8E10OCO8sCik7skaC6kTTCKlfog
	 IAGPeflZVG4EU9joGw/E4TiGl7RA8FEFNbJr5eZDvYRVR5AqDOAKiVBJ3RW9NglqMt
	 YrKtMpdU8ZM7ej9CU2ASIMTiUtmkgbi/4YlElhPAm8ukENsd2Q5yb9qGC57bQdTv87
	 kSyfTWb41F+rhshf2CL1q0957AOwBmoHWs/npuXlrXKWFgxS/IeSKCP1J/gK/MKvkJ
	 lcPBPR7SnFgSuuCKpUntaxB+uWX3d7haPhR2st8URjXBigR+NbHjYiQJL0WRxmtmiQ
	 /cOOFozsC/eiA==
Date: Tue, 28 Oct 2025 14:02:07 +0200
From: Leon Romanovsky <leon@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <20251028120207.GQ12554@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <CALzav=cj_g8ndvbWdm=dukW+37cDh04k1n7ssFrDG+dN3D+cbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=cj_g8ndvbWdm=dukW+37cDh04k1n7ssFrDG+dN3D+cbw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A79B62001B
X-Stat-Signature: ensfet89d4ksbmuzbsntijgeahgfcuje
X-Rspam-User: 
X-HE-Tag: 1761652934-342017
X-HE-Meta: U2FsdGVkX1/hsJmiE2pBaXm9FYyGw8auh3F6Q9NF9v2veu3vUqxGetLK0hHbBwP64V6dOllAY6vkpqPZGRvrpND7UqAddurpTZwr51unED3qWGPtM4RBTg5yqAlsLR50UqPiKqny0NyBOvAKa8S7mpU3+BEXa4R6tVIn1Cf2gpPPwiz3EybhuIIWt8icIXqXCmGcO+jz+oofxUyXv25zvfnDTulH8cUKHL0zGVioGv8PdTrlY7SEmj+t3VoDTp0vPxHIURI6FXgJz7vNUhY2a+Dw4fzo4NraykJ/tNgRxtJF4l2KtyAVpYZ4F/+QoU13o89FyUA/8u9o8GVIxb31SH5R4tJicZmZC2pITD3c+pzTwFis6zatRMmetDT0uHOEf4dkUIc3xPm8V6KrN9NjK0Z2fAHOU1O4bh2eRp9ywyKwMUqF25dmOeqj1+Xuyym2mJlw6f+47TOq3hWW6psXwLONUmZjhgMUghXDbxe/3AEx22/EDNQ+ReZfWQ7QlCOaB+/+Pc+0Rx4zsnekCLqMVV8NoFz6NnrmNUX061wDp8SJROpJ3Ycz8THoMTHuPoTFpXcxVQDab/aEeaMuqtTm6RBC6Lyif8aadzUDC6HjdC5yvPdj+dIsPgLbPEiqhDqUp3hKY+ICAcDRHs8b05504eEA0VcWVEmmqmEQFH7Rxm080Q3JcoCWSBm2z6eb8Q63vV1qqS5uA5MLgkW/y8EDv9rt0TnSqGbPeXCXi7fR4kDMorKR/hQXMxGEbAvjmKtYQxUeBl8/oe0dtIYQ0/ur6Is8++rezATdQexDv0rp9CtmiGacHx/3itpx2iE9rlcfHbq0+047QKvsDXgTlFJvDkrbhEZZBvC1d6z7W1g9hjAoxmGkzfZr/QiOACDdhoFzvZ5+RZh9lWbS4sruO7G6KgzWpMEcXnA2qLJrdeVUMUi1q/A7oyawEon6YBHydfrFqlOvvRc+I1fThlKE1rh
 imoMDW0l
 lu6+yhUrsynrUkMa00MCEzCTWdsA5bHNIAQ9zXjcK6iTZiyQrUrIkjJRYO8I+C6gkUA1ej9MF8Ys5JnBNSMn3B3Xej/ET/6v2Mf2gZOBJylisqbgGrLP6oYuHCkUUzJ3zi77wM7wxPaTQo5UZ2xpX+B6ZaAlH7fiOsGPNvB58Ky8IV9r/HYTtPkZOGDy17CB/XVzeggemdQEnQ79s2yZ2ccYkZTDi7dB3SsN7FoSyxKlDD6Q1Pk8xZPzlZ8E949nRz5S1sZMgUEvp5KlsEEwoWekzW+3tai28tTSYmMT8x4O2GVVYHyy+Xx9taTC1KH0beQrRt00BZ6ZYyKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:13:05PM -0700, David Matlack wrote:
> On Mon, Oct 13, 2025 at 8:44 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Add support for exporting PCI device MMIO regions through dma-buf,
> > enabling safe sharing of non-struct page memory with controlled
> > lifetime management. This allows RDMA and other subsystems to import
> > dma-buf FDs and build them into memory regions for PCI P2P operations.
> 
> > +/**
> > + * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
> > + * regions selected.
> > + *
> > + * open_flags are the typical flags passed to open(2), eg O_RDWR, O_CLOEXEC,
> > + * etc. offset/length specify a slice of the region to create the dmabuf from.
> > + * nr_ranges is the total number of (P2P DMA) ranges that comprise the dmabuf.
> > + *
> > + * Return: The fd number on success, -1 and errno is set on failure.
> > + */
> > +#define VFIO_DEVICE_FEATURE_DMA_BUF 11
> > +
> > +struct vfio_region_dma_range {
> > +       __u64 offset;
> > +       __u64 length;
> > +};
> > +
> > +struct vfio_device_feature_dma_buf {
> > +       __u32   region_index;
> > +       __u32   open_flags;
> > +       __u32   flags;
> > +       __u32   nr_ranges;
> > +       struct vfio_region_dma_range dma_ranges[];
> > +};
> 
> This uAPI would be a good candidate for a VFIO selftest. You can test
> that it returns an error when it's supposed to, and a valid fd when
> it's supposed to. And once the iommufd importer side is ready, we can
> extend the test and verify that the fd can be mapped into iommufd.

No problem, I'll add such test, but let's focus on making sure that this
series is accepted first.

Thanks

