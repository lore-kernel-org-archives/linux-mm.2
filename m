Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB4D7CF34C0
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114EC6B00BF; Wed, 19 Nov 2025 09:50:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED266B00C2; Wed, 19 Nov 2025 09:50:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0026E6B00C3; Wed, 19 Nov 2025 09:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E26F16B00BF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:50:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85E0012F982
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:50:16 +0000 (UTC)
X-FDA: 84127642032.10.7009434
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0D3EF1C0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:50:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LcrsNEP/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763563815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHZMxCwy3S5+R7WK8XNoM3gCN4/qDIKh++0xFe9C1Lk=;
	b=T+xGI8vQDQdcaEN9kuRyTflYwYYJ9OhYyupS5WJcXtGeZLHyciXjUTxg6zseDiEWKAitm8
	VYnq0nMutcFh2NrUGnP/ISpdlAsyzGe8ZWPecjtkByuYIGrBgacVNsJJ/d98gAJ0/bA0NC
	UNqH/YNcgyZ/8FIGM/bBUZPrm+bBq5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763563815; a=rsa-sha256;
	cv=none;
	b=G7GTSAq6L7h8UF0qyOhEb/ddLMdqTTihpfhMZfrizQhFKfN9wLnXedd9etAH9XjrfbQbrp
	5lrLIVvhdCNum/8/gJ6IOz2rvTFM/uNSHiii4r/njP49Cy9LFCYYCOoLTfyU86w7xXnr4t
	4DC8yaUUL6IXB8T+I2b2gzbBsF0idng=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LcrsNEP/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 62CD860172;
	Wed, 19 Nov 2025 14:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3938C4AF10;
	Wed, 19 Nov 2025 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763563813;
	bh=pmpKDnH2uKvstiaClRjE20PveVTzDLqcJ5J5KfQb6S8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LcrsNEP/cYavn31vXsC8q8kxUgGv+46Et2MVwTZ8gF77SMbTjkF4nB2wQBaMxNKGU
	 i+/2o+bM64GJu+BLuW6zLkjUKBtHHlYMzXlzM4pjSA67NNU6s8zYkBNJUnTexK17Bp
	 6Lp7os/5KlQKtqIhtjEsdU8wY04+SUaC7u9XgDC4zc+2soLqxFspe2w73PrOMeKxNt
	 AUg0MlRp4Bmlt8WgpdK3oISI5amq2WLKRQY3kuFLVW4pYtnU4Msh1vXWt5/EM/PsUq
	 aa9jiHbd1oaJWuoqBo+qGbB2tVoKiV6ppNZF0P5h52bxUi4hyZv7/jqxC0VtZW9jWG
	 EHx9C2fLK2a/w==
Date: Wed, 19 Nov 2025 16:50:07 +0200
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
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119145007.GJ18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119134245.GD18335@unreal>
 <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
X-Stat-Signature: uo3e4r5hhtohmsh6hhm1pn3yzod5m8j7
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D3EF1C0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763563814-664157
X-HE-Meta: U2FsdGVkX18yYkg9JLZZkfV54V6QjDaE30S9B8rtY8/FQhCdQlOwDxEhWBMm4z+kuC4eLtraDdNDIcvHAsvrUV4DRd8Gv9e1AuBxtzdY6lV549yBbsGXIBI5O0Rxv3nhKKL2ZYPgoCY+ADhrU6aZSohfrTrgRKowyhSaCmfN2fdOplLFfQN+QUK5n5gOW3eM7KuTZmKow7rNku/lw+vWpKOYMbO2PoF3+OE87IaYQ0a/VElpwfbLy/UxURauTW35F2grEJzjykMDwDmCc6az3mbPJnzhZ8QZAQbFR1dHBAL5pM4Mp/Vm/Fi5CPKSFFk1XgTAOtG0coboTdLCse4Up896w5r0hMkkBPLCPu3mUSuUZN9uFJ0TXVDZLUum9amCvpXm7v9rPQGHjJgoUZt5OKb41BFkm5zurbwQLjYEF4xsJRgklsx3xDtfb4zSmK4ntk5leMHWOdB/kPm9PkqI1sxBNEeHuMIzbL8Gtqm8HuF05Fuzo694hdg5DEvCefDe2mSqm1pnw1XjAiX9KYGRYc27rfctukgWylH5UF9iXyolyHJ6igxcksrISB6ssJyOXVQCuFiIydTFAaYVs16WE1TERUM8DSn5PjQD5Iww2hStDI5R4DagfYsGTr2qctloR736DD5Xz3IjepK9CN5j7yEWGNNt0vN9cX/MUP0f6ElTW7fHfutYyA3upgF4oqfO1LhV3am5RI81mOdTyR54dn/Fddd74OmtU5wKTIJGR+jSKhcW0bT4Yqx8blpVErhIFkQH7MzpbvUw5Pg3KCq4g4ZRfKbMEtGchAF1Viyleuq2zIzGmmOD6oFpQ5f+/CjYoOF1457vwsI0xNGcmiCFOwIdl4gkzN8t8+euvQC7r4UC5a1+og1zUNHOdZ9ytvbZSy11NiptE1wkSiUrqcGOKsIDCqmKwUf6DfYbkVFhlRIJu3xyzas0COVRBpTAfbJoiEx7w2IqU/XRPzNS7n/
 U92WFHCA
 I9pmS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:11:01PM +0100, Christian König wrote:
> On 11/19/25 14:42, Leon Romanovsky wrote:
> > On Wed, Nov 19, 2025 at 02:16:57PM +0100, Christian König wrote:
> >>
> >>
> >> On 11/11/25 10:57, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>
> >>> Add dma_buf_map() and dma_buf_unmap() helpers to convert an array of
> >>> MMIO physical address ranges into scatter-gather tables with proper
> >>> DMA mapping.
> >>>
> >>> These common functions are a starting point and support any PCI
> >>> drivers creating mappings from their BAR's MMIO addresses. VFIO is one
> >>> case, as shortly will be RDMA. We can review existing DRM drivers to
> >>> refactor them separately. We hope this will evolve into routines to
> >>> help common DRM that include mixed CPU and MMIO mappings.
> >>>
> >>> Compared to the dma_map_resource() abuse this implementation handles
> >>> the complicated PCI P2P scenarios properly, especially when an IOMMU
> >>> is enabled:
> >>>
> >>>  - Direct bus address mapping without IOVA allocation for
> >>>    PCI_P2PDMA_MAP_BUS_ADDR, using pci_p2pdma_bus_addr_map(). This
> >>>    happens if the IOMMU is enabled but the PCIe switch ACS flags allow
> >>>    transactions to avoid the host bridge.
> >>>
> >>>    Further, this handles the slightly obscure, case of MMIO with a
> >>>    phys_addr_t that is different from the physical BAR programming
> >>>    (bus offset). The phys_addr_t is converted to a dma_addr_t and
> >>>    accommodates this effect. This enables certain real systems to
> >>>    work, especially on ARM platforms.
> >>>
> >>>  - Mapping through host bridge with IOVA allocation and DMA_ATTR_MMIO
> >>>    attribute for MMIO memory regions (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE).
> >>>    This happens when the IOMMU is enabled and the ACS flags are forcing
> >>>    all traffic to the IOMMU - ie for virtualization systems.
> >>>
> >>>  - Cases where P2P is not supported through the host bridge/CPU. The
> >>>    P2P subsystem is the proper place to detect this and block it.
> >>>
> >>> Helper functions fill_sg_entry() and calc_sg_nents() handle the
> >>> scatter-gather table construction, splitting large regions into
> >>> UINT_MAX-sized chunks to fit within sg->length field limits.
> >>>
> >>> Since the physical address based DMA API forbids use of the CPU list
> >>> of the scatterlist this will produce a mangled scatterlist that has
> >>> a fully zero-length and NULL'd CPU list. The list is 0 length,
> >>> all the struct page pointers are NULL and zero sized. This is stronger
> >>> and more robust than the existing mangle_sg_table() technique. It is
> >>> a future project to migrate DMABUF as a subsystem away from using
> >>> scatterlist for this data structure.
> >>>
> >>> Tested-by: Alex Mastro <amastro@fb.com>
> >>> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> >>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >>> ---
> >>>  drivers/dma-buf/dma-buf.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++
> >>>  include/linux/dma-buf.h   |  18 ++++
> >>>  2 files changed, 253 insertions(+)
> >>>
> >>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> >>> index 2bcf9ceca997..cb55dff1dad5 100644
> >>> --- a/drivers/dma-buf/dma-buf.c
> >>> +++ b/drivers/dma-buf/dma-buf.c
> >>> @@ -1254,6 +1254,241 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
> >>>  }
> >>>  EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
> >>>  
> >>> +static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
> >>> +					 dma_addr_t addr)
> >>> +{
> >>> +	unsigned int len, nents;
> >>> +	int i;
> >>> +
> >>> +	nents = DIV_ROUND_UP(length, UINT_MAX);
> >>> +	for (i = 0; i < nents; i++) {
> >>> +		len = min_t(size_t, length, UINT_MAX);
> >>> +		length -= len;
> >>> +		/*
> >>> +		 * DMABUF abuses scatterlist to create a scatterlist
> >>> +		 * that does not have any CPU list, only the DMA list.
> >>> +		 * Always set the page related values to NULL to ensure
> >>> +		 * importers can't use it. The phys_addr based DMA API
> >>> +		 * does not require the CPU list for mapping or unmapping.
> >>> +		 */
> >>> +		sg_set_page(sgl, NULL, 0, 0);
> >>> +		sg_dma_address(sgl) = addr + i * UINT_MAX;
> >>> +		sg_dma_len(sgl) = len;
> >>> +		sgl = sg_next(sgl);
> >>> +	}
> >>> +
> >>> +	return sgl;
> >>> +}
> >>> +
> >>> +static unsigned int calc_sg_nents(struct dma_iova_state *state,
> >>> +				  struct dma_buf_phys_vec *phys_vec,
> >>> +				  size_t nr_ranges, size_t size)
> >>> +{
> >>> +	unsigned int nents = 0;
> >>> +	size_t i;
> >>> +
> >>> +	if (!state || !dma_use_iova(state)) {
> >>> +		for (i = 0; i < nr_ranges; i++)
> >>> +			nents += DIV_ROUND_UP(phys_vec[i].len, UINT_MAX);
> >>> +	} else {
> >>> +		/*
> >>> +		 * In IOVA case, there is only one SG entry which spans
> >>> +		 * for whole IOVA address space, but we need to make sure
> >>> +		 * that it fits sg->length, maybe we need more.
> >>> +		 */
> >>> +		nents = DIV_ROUND_UP(size, UINT_MAX);
> >>> +	}
> >>> +
> >>> +	return nents;
> >>> +}
> >>> +
> >>> +/**
> >>> + * struct dma_buf_dma - holds DMA mapping information
> >>> + * @sgt:    Scatter-gather table
> >>> + * @state:  DMA IOVA state relevant in IOMMU-based DMA
> >>> + * @size:   Total size of DMA transfer
> >>> + */
> >>> +struct dma_buf_dma {
> >>> +	struct sg_table sgt;
> >>> +	struct dma_iova_state *state;
> >>> +	size_t size;
> >>> +};
> >>> +
> >>> +/**
> >>> + * dma_buf_map - Returns the scatterlist table of the attachment from arrays
> >>> + * of physical vectors. This funciton is intended for MMIO memory only.
> >>> + * @attach:	[in]	attachment whose scatterlist is to be returned
> >>> + * @provider:	[in]	p2pdma provider
> >>> + * @phys_vec:	[in]	array of physical vectors
> >>> + * @nr_ranges:	[in]	number of entries in phys_vec array
> >>> + * @size:	[in]	total size of phys_vec
> >>> + * @dir:	[in]	direction of DMA transfer
> >>> + *
> >>> + * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
> >>> + * on error. May return -EINTR if it is interrupted by a signal.
> >>> + *
> >>> + * On success, the DMA addresses and lengths in the returned scatterlist are
> >>> + * PAGE_SIZE aligned.
> >>> + *
> >>> + * A mapping must be unmapped by using dma_buf_unmap().
> >>> + */
> >>> +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
> >>
> >> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.
> > 
> > This function performs DMA mapping, so what name do you suggest instead of dma_buf_map()?
> 
> Something like dma_buf_phys_vec_to_sg_table(). I'm not good at naming either.

Can I call it simply dma_buf_mapping() as I plan to put that function in dma_buf_mapping.c
file per-your request.

Regarding SG, the long term plan is to remove SG table completely, so at
least external users of DMABUF shouldn't be exposed to internal implementation
details (SG table).

Thanks

