Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2879ACF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3E86B00CC; Wed, 19 Nov 2025 08:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793DA6B00CD; Wed, 19 Nov 2025 08:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6830D6B00CE; Wed, 19 Nov 2025 08:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55F936B00CC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:32:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F04C61404E6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:32:56 +0000 (UTC)
X-FDA: 84127447152.29.5909899
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 41D4A1C0002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:32:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fugn6SXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763559175; a=rsa-sha256;
	cv=none;
	b=MME105IaJMUbdLPRxUef8T57vILmZ/2OLhIZiT0QtPJvPTDgUMdRzrl87bR3lp605/Gmzb
	3FFfeJqcyuCWJmKx1J91bNYw3hEQqmxrG/FqUC6xaNSO0GuP1wdy9H905PQPJ9v8bDnbXb
	w+I27F1Fjxz1lzO+LSYS+V1Zk1JYwik=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fugn6SXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763559175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrv0hQ0rvR7EUwFuONf+rEAq03sQ52H2Rv0qkeMPtMk=;
	b=kV16PCZF7r6/T0PjkfWvwdFgFYiuIBiKsG0RUiNO8Ar49QKb0ntmAsfImzL0hXQYM36XsI
	rxfOztVv6amlK0QtIr1siccaQE8gSVvxoKB/WFCN+QaHnpkG5Vd1mgRHWMNAFAMMOYHJPv
	3Zj4WTNFN/xQxMMtq4XtylwKROZP1lM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FCD8433F7;
	Wed, 19 Nov 2025 13:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F49C116D0;
	Wed, 19 Nov 2025 13:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763559173;
	bh=xSg1qo4eywYavdQS8dmG/E50BvlEVMWFbME3wXOYqAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fugn6SXe3G4/lghJftzverkKri5Zm6llziGFELpjSdO5rFXibaH9e3wtAHC8eYq0A
	 UHDxjWoty5cjHUhouVKrIOhuKM9z7mexk/F5r4cf7BxkwPnbErmXBmxpeleMMNnVNp
	 Zn2bBiJcVDshc8OQL4VrNwTENPVUYBtgD3PYJarKK+WMN7WiwzSdhiNC8St3ekVG9T
	 MppaNiyGtAujQGVj62oii6C8Mlzol4XrwMJkNVyNsz6rtOtPKYXJ1wwf8GpAxLr+PZ
	 rp7GRTmkkKYO75+nzC3UJyt0A8Qyuha45HbfXhXuCmDdddQ4ykA2clId10wnbfNPl0
	 6tfxCzsiPdxfQ==
Date: Wed, 19 Nov 2025 15:32:48 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
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
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>
Subject: Re: [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <20251119133248.GC18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <aR0J8zHtfe/j4ajU@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR0J8zHtfe/j4ajU@Asurada-Nvidia>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41D4A1C0002
X-Stat-Signature: febm39sy4areeciyucac6nhkip8zdsi4
X-HE-Tag: 1763559175-468502
X-HE-Meta: U2FsdGVkX1/CteC9EuT4X+x0JA7hbqdK3H4o/GEmGDTBJ9ak0zOYjcrHnyUQv8F5j+ThA5CpYbsd+fajyAtCJwcWR2qzyNpubiffOSVSJCSZjK321JVn186sDRa4M76Qi/mwMvjM/sQk+NSMaR0UbH4uIXSxClj7FIZrpPs4puk5lL33AyY2E2uKGPv59QpjVQV+gEJc0feWuT61zz/PWWrgsCHBp903VyCbls9YlgE8lBPgpCmPsYr67rzIZ6hawlYFefQ6QatndZ2AQ35LNmJHIpA5Jc3kNFbbr10CkbBDb4mCzzG5tHYJJWI9vIGtWRLplKX64UO/65vITumodEwq4nE9OFOOqmnR2QStJFhHM1PWej2aFE0FLRFnBczwoeurR8Sqjjx4ApLEoaI0AxiZWpIoxU2bznLYTE123sHTFOcR8ZNg66NT7JEW4Pa1IB0UOfINZY2CqQpGcJTg01nLGB2kFFyeHAXrddEtou1kR/2G5gjv6E/h3CkHQJLfdXmAvFtvuWtKTnEkLrHAGsZ9pp0R2esGMezijm9yE4pKomeOBsdBAZzgJKHE2Nq+t2zvb2UrcOQ0U502DE++ycRMyIlZ5XHVfGHwe7fjlZtiXVsEkyFVclLjV1JvOjO+YoLzgxkv/tG7oAdWYJSekVYphVAN1Ry3dZ43FFm3ZMvfrDbriSq/szp0zf2hlsPgha1Kxy971a7Gud7VTlBzXysshWuUmYSsrjKcbO+OScyNbczXM49yyfc+TGMzdLQG1QzmUhRUyORuz5k0vBIRIZUP0xTrb0OkZxJMhuhAhXefvsfiCL26BIiwsAXpl30D/8UJAa/y/FNWr1QU+ZW7frGT5lo5pbV41LGNbxlA8Uk+aqF8nTt1iKzdcxVHDaKW/UIi9/oq0vn20u3Vc2YhyF34jGx3mqrgyFOF7jAOB3UhyIPTdaiFsNkASTjUb/A1VG7A2px/OmaQRQyUePB
 6EaCvi68
 UU4JEm1EZdkGx9jXbkmZfhwRmLvnWplZVvTsKEkXqdblVOXld/9SbbEe6naErdXd7QHDavfWvcLEKRNYLYdincgV0pDPdOKc81hgzAQm/RMIuybTlevTAJ5Aig3hPRhJg/KGoFmX2GJTNCryAsXXIyJ9OWlLE14Mdj5VvSPoEL7aW9KQjJA5j2K9OMGrx4HBbF4fQ4qY9bY3XHMhXG8D3FMT8AVs52UVf9UvqiVzP/NvqbXIMpIiJIXhsn7sCc4hI3jkgdtqHHyLv7opw43T4evXORcAZ7gzFwRsDaYLYhz63/PF8B2bJ4n68FGmHC5O259R0wuFu9mdnwuSU9WINeY2z1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 04:06:11PM -0800, Nicolin Chen wrote:
> On Tue, Nov 11, 2025 at 11:57:48AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add dma_buf_map() and dma_buf_unmap() helpers to convert an array of
> > MMIO physical address ranges into scatter-gather tables with proper
> > DMA mapping.
> > 
> > These common functions are a starting point and support any PCI
> > drivers creating mappings from their BAR's MMIO addresses. VFIO is one
> > case, as shortly will be RDMA. We can review existing DRM drivers to
> > refactor them separately. We hope this will evolve into routines to
> > help common DRM that include mixed CPU and MMIO mappings.
> > 
> > Compared to the dma_map_resource() abuse this implementation handles
> > the complicated PCI P2P scenarios properly, especially when an IOMMU
> > is enabled:
> > 
> >  - Direct bus address mapping without IOVA allocation for
> >    PCI_P2PDMA_MAP_BUS_ADDR, using pci_p2pdma_bus_addr_map(). This
> >    happens if the IOMMU is enabled but the PCIe switch ACS flags allow
> >    transactions to avoid the host bridge.
> > 
> >    Further, this handles the slightly obscure, case of MMIO with a
> >    phys_addr_t that is different from the physical BAR programming
> >    (bus offset). The phys_addr_t is converted to a dma_addr_t and
> >    accommodates this effect. This enables certain real systems to
> >    work, especially on ARM platforms.
> > 
> >  - Mapping through host bridge with IOVA allocation and DMA_ATTR_MMIO
> >    attribute for MMIO memory regions (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE).
> >    This happens when the IOMMU is enabled and the ACS flags are forcing
> >    all traffic to the IOMMU - ie for virtualization systems.
> > 
> >  - Cases where P2P is not supported through the host bridge/CPU. The
> >    P2P subsystem is the proper place to detect this and block it.
> > 
> > Helper functions fill_sg_entry() and calc_sg_nents() handle the
> > scatter-gather table construction, splitting large regions into
> > UINT_MAX-sized chunks to fit within sg->length field limits.
> > 
> > Since the physical address based DMA API forbids use of the CPU list
> > of the scatterlist this will produce a mangled scatterlist that has
> > a fully zero-length and NULL'd CPU list. The list is 0 length,
> > all the struct page pointers are NULL and zero sized. This is stronger
> > and more robust than the existing mangle_sg_table() technique. It is
> > a future project to migrate DMABUF as a subsystem away from using
> > scatterlist for this data structure.
> > 
> > Tested-by: Alex Mastro <amastro@fb.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> With a nit:
> 
> > +err_unmap_dma:
> > +	if (!i || !dma->state) {
> > +		; /* Do nothing */
> > +	} else if (dma_use_iova(dma->state)) {
> > +		dma_iova_destroy(attach->dev, dma->state, mapped_len, dir,
> > +				 DMA_ATTR_MMIO);
> > +	} else {
> > +		for_each_sgtable_dma_sg(&dma->sgt, sgl, i)
> > +			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
> > +				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
> 
> Would it be safer to skip dma_unmap_phys() the range [i, nents)?

[i, nents) is not supposed to be in SG list which we are iterating.

Thanks

