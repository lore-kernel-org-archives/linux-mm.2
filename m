Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E7CCF855D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 08:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7E16B0023; Thu, 20 Nov 2025 03:43:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98A16B0024; Thu, 20 Nov 2025 03:43:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD56E6B0030; Thu, 20 Nov 2025 03:43:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF9E6B0023
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:43:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B5F0C0789
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:43:05 +0000 (UTC)
X-FDA: 84130345530.11.D0B33A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5CB9A140005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:43:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XwM9VF0/";
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763628183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLSIsGuDqSSRwMlGGbVShbt0/NbvTqPCqMTMVTe0E0k=;
	b=im1RRcke9XOlChlssxk4sAELJE9+2WYkvy5xdvaf4V80nLA9qagsk5xgDrRQRe5ekJ+I+O
	hYmOyf/3/JqFZUtmqXWoqwgFusCSSxTZvxnGaBgHWFzvMORN0oBB3FueYQbniWvi4IRnbe
	R9Kbx4j+u22ChQpU7QKJguVpeYeVH8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763628183; a=rsa-sha256;
	cv=none;
	b=h+si4V94JaVV5B3T35kivap7luU21rI9rskYQK4rsmjsK3cQkgvtnNbG4KKk3fFnZVuDzE
	tECGc6LRrOGZT3rflPhk9QpvWIoLs4QhQjYAXHLzCy60NZeIeoVW1upXVfP2KLeah6res2
	T9El4cgmTGmiyC8bg7ebhCN5Q6Xok/M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XwM9VF0/";
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E49743EDD;
	Thu, 20 Nov 2025 08:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FADBC4CEF1;
	Thu, 20 Nov 2025 08:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763628182;
	bh=P5XvCfo2kL1FT8lQd/duz2IZNp+Bc6vjBcFoBDexpxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XwM9VF0/MdzjJFRWGcTU+as96VZEq0Zb/fyLDF58ZfSH35uzQmxfr4TmytcS6mL88
	 d1t0Wx0u0jj7fsdr5rg1/N1bGUYv7dvnAc1Es+H74RFvNwnWfKaQ53LvyByCAGFAAh
	 I7jNUZW/ydTTb1ZZicgEeQDolVmPtWGgW50zR3zu9NFkWMcO7PFAgTiTBGYnctFDzH
	 v2CUO+Rk+ConUzbB/bRLLrMZJhBmYdtxZm/7TcQa12wKM5gP+hl5DNE9M+GLA4aAZ+
	 uB36oeBHPnhbuuXsBWdkmnKZN9coakgPW2EmMZJTa1WNpabXyaPUyQmy381pCUWWJD
	 qzDxtYKxcztcQ==
Date: Thu, 20 Nov 2025 10:42:57 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
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
Message-ID: <20251120084257.GU18335@unreal>
References: <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
 <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
 <20251120074137.GR18335@unreal>
 <209499e2-6a06-4291-ad4c-77230926c665@amd.com>
 <20251120080635.GT18335@unreal>
 <1e238415-1080-40b3-abb4-7fd31033d6de@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e238415-1080-40b3-abb4-7fd31033d6de@amd.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CB9A140005
X-Stat-Signature: 1nk3riymzgwx857kcadqkagbdiudsbrr
X-Rspam-User: 
X-HE-Tag: 1763628183-131568
X-HE-Meta: U2FsdGVkX19yNPRysp5qGjFXa4h8MnSB/1+RZCxbW/um+u2R3p8Wmh5VdaFRZKOvS7Yeo964enTagYt8cKK+E/hEk6U3sICGfaw4ev2y/eRQczEXRJ2dqeiDMmokI9xQ0Erw+siEK9AJ340tLgedeEHCJOaIzukmR/e+E3UFSf+pAZzcI8BSmipEuyS9rqDEIrN7EptE4rkHOGibglhGLlZZgSIJG2u7taYIEGTayqsioy34dGPMGGIscazRBmNcRe6BIrIxAa/SrDFkAZJ5p6BYfhcYht6YyC0VqfcbBD6MvWKW0aGiem6m3VsOI8ex5u4TdkWEXLLj9jR3K3FUYg2csk58+Y+/WT/WGfC7bb1kyieI+fXPYoXPZ1ptYsxpYs3nWSIOprdB/OmRcLQIQ/6yG1xvgrtooCmcOlH56XZSswCIzhsxwv2kAT5XgzERYuDx9wKagU4XGqtGLBsqD+CbzAIYloJ83Rk6+dRXEUmXkm1gtAp9+ZPD/2NWuJNfdbwMkvavsr6zV+cpS5xPxRW7JaWcbT5weWKnMbC7TUsetbS6wg2M58+TgRU2iZ4vuwKLBaVXpC1goPixRWJRc9iV1cUjNXZuC+U1+fp27T7P4Rhjw3CyT4M1MXogxevxb/EO4RJ2z0AP8tNje0TLdhcnbUYu+E0a36quUCerrC8Yak0SuUZHGAKfwUlDoXZiVNQ0uuCkaLeHhQp+YQi54fo67XCXW0tTyoq1FicWuZgGzGwGCgQ5IQ10LR4ACeHmLreuDNOj9YxIqZzpA8QaJ/htf0Uuq9UExWwj/s1YtNmWJ1Wc5U5kaYy5U+Ayej1IdOddDseZO/eKM8zTumFYCT0EYpD7zCteNZgFoTDELnJ2bnqPCE2AG19up0LjM5zGeeIbFxSJoqNelOXbNVVUuAKUjgHsmW9Y2UTyrILvb73fg8yMwjKjb7MzKfAFWuOFjHuQb8X9FlDEzWeWv0L
 z7NPcujd
 Skq//lYkOBG6ugbQIXx9+ilwow7hl/pF4W6E4HMR002GYZD62i7oD9Rl0DIUS1KgF2HdY53P/Bx01QDFFUDNmhPHkVoxXqT+E+1WZsoAn2fZZcVj+cDc7ArzkaBT+OFE1F8+NZgi0MvgWeUJ0RkAhjgT2JFO0oTKAAwsrn6lbnsjiVA2lIBR8TAO6HjOcNElKJb2VkVzlkCxqJUMTyOGDWI0/cNUTbxjRlHS0pAp/S9+UGrOhYsQsfmVPYaCDEEInvMDbIxCUxruCURSL6Qumf/XhDXW8b66S5UygPpoaNnDtGkrHG5pHoKC2/iS19fj/du2pzoj/NXSw8bIN9QG/cBXDWOrCShwV17hSB2W4YLtVgoZ0nOhpSBHMlsVxiJ5nPteV6epkM5J42chnVLgCviv4hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 09:32:22AM +0100, Christian König wrote:
> On 11/20/25 09:06, Leon Romanovsky wrote:
> > On Thu, Nov 20, 2025 at 08:54:37AM +0100, Christian König wrote:
> >> On 11/20/25 08:41, Leon Romanovsky wrote:
> >>> On Thu, Nov 20, 2025 at 08:08:27AM +0100, Christian König wrote:
> >>>> On 11/19/25 20:31, Jason Gunthorpe wrote:
> >>>>> On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:
> >>>>>
> >>>>>>>>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >>>>>>>>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> >>>>>>>>> +		if (!dma->state) {
> >>>>>>>>> +			ret = -ENOMEM;
> >>>>>>>>> +			goto err_free_dma;
> >>>>>>>>> +		}
> >>>>>>>>> +
> >>>>>>>>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> >>>>>>>>
> >>>>>>>> Oh, that is a clear no-go for the core DMA-buf code.
> >>>>>>>>
> >>>>>>>> It's intentionally up to the exporter how to create the DMA
> >>>>>>>> addresses the importer can work with.
> >>>>>>>
> >>>>>>> I can't fully understand this remark?
> >>>>>>
> >>>>>> The exporter should be able to decide if it actually wants to use
> >>>>>> P2P when the transfer has to go through the host bridge (e.g. when
> >>>>>> IOMMU/bridge routing bits are enabled).
> >>>>>
> >>>>> Sure, but this is a simplified helper for exporters that don't have
> >>>>> choices where the memory comes from.
> >>>>
> >>>> That is extremely questionable as justification to put that in common DMA-buf code.
> >>>>
> >>>>> I fully expet to see changes to this to support more use cases,
> >>>>> including the one above. We should do those changes along with users
> >>>>> making use of them so we can evaluate what works best.
> >>>>
> >>>> Yeah, exactly that's my concern.
> >>>>
> >>>>>> But only take that as Acked-by, I would need at least a day (or
> >>>>>> week) of free time to wrap my head around all the technical details
> >>>>>> again. And that is something I won't have before January or even
> >>>>>> later.
> >>>>>
> >>>>> Sure, it is alot, and I think DRM community in general should come up
> >>>>> to speed on the new DMA API and how we are pushing to see P2P work
> >>>>> within Linux.
> >>>>>
> >>>>> So thanks, we can take the Acked-by and progress here. Interested
> >>>>> parties can pick it up from this point when time allows.
> >>>>
> >>>> Wait a second. After sleeping a night over it I think my initial take that we really should not put that into common DMA-buf code seems to hold true.
> >>>>
> >>>> This is the use case for VFIO, but I absolutely want to avoid other drivers from re-using this code until be have more experience with that.
> >>>>
> >>>> So to move forward I now strongly think we should keep that in VFIO until somebody else comes along and needs that helper.
> >>>
> >>> It was put in VFIO at the beginning, but Christoph objected to it,
> >>> because that will require exporting symbol for pci_p2pdma_map_type().
> >>> which was universally agreed as not good idea.
> >>
> >> Yeah, that is exactly what I object here :)
> >>
> >> We can have the helper in DMA-buf *if* pci_p2pdma_map_type() is called by drivers or at least accessible. That's what I pointed out in the other mail before as well.
> >>
> >> The exporter must be able to make decisions based on if the transaction would go over the host bridge or not.
> >>
> >> Background is that in a lot of use cases you rather want to move the backing store into system memory instead of keeping it in local memory if the driver doesn't have direct access over a common upstream bridge.
> >>
> >> Currently drivers decide that based on if IOMMU is enabled or not (and a few other quirks), but essentially you absolutely want a function which gives this information to exporters. For the VFIO use case it doesn't matter because you can't switch the BAR for system memory.
> >>
> >> To unblock you, please add a big fat comment in the kerneldoc of the mapping explaining this and that it might be necessary for exporters to call pci_p2pdma_map_type() as well.
> > 
> > Thanks,
> > 
> > What do you think about it?
> > 
> > diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
> > index a69bb73db86d..05ec84a0157b 100644
> > --- a/drivers/dma-buf/dma-buf-mapping.c
> > +++ b/drivers/dma-buf/dma-buf-mapping.c
> > @@ -84,6 +84,11 @@ struct dma_buf_dma {
> >   * PAGE_SIZE aligned.
> >   *
> >   * A mapping must be unmapped by using dma_buf_free_sgt().
> > + *
> > + * NOTE: While this function is intended for DMA-buf importers, it is critical
> > + * that the DMA-buf exporter is capable of performing peer-to-peer (P2P) DMA
> > + * directly between PCI devices, without routing transactions through the host
> > + * bridge.
> 
> Well first of all this function is intended for exporters not importers.
> 
> Maybe write something like "This function is intended for exporters. If direct traffic routing is mandatory exporter should call routing pci_p2pdma_map_type() before calling this function.".

Sure, no problem.

Thanks

> 
> Regards,
> Christian.
> 
> >   */
> >  struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
> >                                          struct p2pdma_provider *provider,
> > (END)
> > 
> > 
> >>
> >> Regards,
> >> Christian.
> >>
> >>>
> >>> https://lore.kernel.org/all/aPYrEroyWVOvAu-5@infradead.org/
> >>>
> >>> Thanks
> >>>
> >>>>
> >>>> Regards,
> >>>> Christian.
> >>>>
> >>>>>
> >>>>> We can also have a mini-community call to give a summary/etc on these
> >>>>> topics.
> >>>>>
> >>>>> Thanks,
> >>>>> Jason
> >>>>
> >>
> 

