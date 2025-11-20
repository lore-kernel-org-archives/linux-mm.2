Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2364ECF8552
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 08:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2926B0010; Thu, 20 Nov 2025 03:06:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA4C6B0028; Thu, 20 Nov 2025 03:06:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0176B002D; Thu, 20 Nov 2025 03:06:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7EF6B0010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:06:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEE81BADC8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:06:42 +0000 (UTC)
X-FDA: 84130253844.06.08BA19C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E85F1A0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:06:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jyoe7Oe5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763626001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPew/5dF/9aL6hRV16pFiK1BiN7E3GcPs0gWhxCpVAk=;
	b=gJJ8TUDNVOJPrHZDUDW3W/BbIE7G0HPmgS8vWsnzj0b+tcWoFel+8phbnqLR2ZnM9f1M12
	GXB4EqYhm3nVitotzZXYXZKVE6OTGI2MU7cA1GD/HPB0VMF6XwgYVY3uU3fky15sDSftjr
	Goak2Ak2q6a8IJ41VKoya+8p8lDtQ7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763626001; a=rsa-sha256;
	cv=none;
	b=pnEYHIigMR+rUQJ99sHupy6ALB9mo2H2n82juQ6IqXy93lFFgpgbMEhLHDawnVyh4pJA6U
	IupuGQmVYlXXa/D2wdEcR7yxnBpjtjG4LRpQqSmnr0qfogDVbXC83SRItYOtrv3AxQCEyn
	CcbnO93cP1s3ndqbYVZUAyJJElSQezI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jyoe7Oe5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09247440EF;
	Thu, 20 Nov 2025 08:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124CEC4CEF1;
	Thu, 20 Nov 2025 08:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763625999;
	bh=mxT/rSlaqP+txsmWmS9/PssKwzGp7j3BhlaZuVwXZis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jyoe7Oe5fQPJ/c3G0Y3Le2MuwLeYij5ETlxaQsfHH0IeCeAp4SV8sma9/p4puBfJd
	 uSJLTrxHP3QFvgERIjsj/1tqk+X/okArVSEm8ZMhuoWrUm+nw49VGAhsvO+/F7roqB
	 earNWu4MD42Xdka7K6xqmgczk8orzPbhqOIDxQD+/aKHXhBiOGA4RplKw1T/I2rQ6a
	 ev9a2LBRLzTP1F+YYtsiwBQ2gNaHKtotSqd6c5JXDYnlHf0a974bbsQ8w3T/BC46cr
	 IlYGcGcRRMayKQVYgRTSLxtDvYEu5tk34YIf2hUPYoKt2aPFZV53WId4koKue3AXLS
	 Eq5b6O0Zpw2Lw==
Date: Thu, 20 Nov 2025 10:06:35 +0200
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
Message-ID: <20251120080635.GT18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
 <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
 <20251120074137.GR18335@unreal>
 <209499e2-6a06-4291-ad4c-77230926c665@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <209499e2-6a06-4291-ad4c-77230926c665@amd.com>
X-Stat-Signature: ax7wnxw11oakukgxjupr6hey9rzqfguy
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E85F1A0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763626001-620469
X-HE-Meta: U2FsdGVkX18TJVUXNiDQttIBhql7EsPxZUcg5RO/WNHGlVf0bFgpVLuo454yEwyTDj5u27CE6v0zF9Czz/zW5LyU2gQPcttnA3kHNTJjgJRfg0q4nfxwtXVPRA0W9yHPBoGysjvPhQUwhC62uIH2vUiOcu94FOWCYjwcu4kFGjyX+6Uhp9J3R1rPMU2YuMCXjUjNyzdveNyro3Xh/ivLAeJuFTqNwkjFzRA+yq9lppbilT3vVjnhNs0aBIvP1zN3La/MXzozviOR7n00DGf4q09JCtNw8hMelDGwQIV3NhjCdHDWK2WPP7CfqioNlzLHayYCA5Sktr4YKKEC9ih8lNBBg1JFGrNk1hYhxUSrFFzfjSxaojSvxEMlrl8UrW+VwkkMWE/H/s+ZnuB6n4nDF1oor1ShsPoW1xER24RhJ8LbmwYVjWFPxnncZ0W/iKe9VysrzLy86ykbvSMZ745E3+cndmx92j9QCi4MlhCIg8gkfmlytrb2Yxn6b08GlSz4H8bBuNniXxmct8IqLn3mZaYG15L8BQOX5H5jDVH34FjM9Bb//UaIMjLvzPaFoWQm7MSTtrXFoFRrFdCyz7XCmrf633EGdwRlD17UjIrVBTihmWcNMhJMbJZFaUETqL6prbcRo+74G2LPut7Hb4W5UmACY+CJ4xuzpLhYm4Gqp6CQ2urMkFzgz/QaowYf1Kj1EtP3SIBXHkAIQYjbQDx7Vm68g3wFm9cRxxb5p4hqgNlGU0x4HL6MC/sqXfeMd7iQL807fC25fJujRpTVFWKGGlRzu8ljvxT/+M1p4dLTMmlP99QjyUKVhck5Q4GJUIvzNVkmSjBcBVtMddIjAA0i3wdeBz+KgTW97NeYrsFuQmBRGuxkLDLagmc3S3WbfdPJojlmm8aKVPkCYtLOxh41lJ5lCPLKcYumuC6q01A705jwZ77S5l/Y6hrOOEtaA1OCVYSxLvxpqMv0jsxfavI
 tsTIrFXP
 Bmp7t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 08:54:37AM +0100, Christian König wrote:
> On 11/20/25 08:41, Leon Romanovsky wrote:
> > On Thu, Nov 20, 2025 at 08:08:27AM +0100, Christian König wrote:
> >> On 11/19/25 20:31, Jason Gunthorpe wrote:
> >>> On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:
> >>>
> >>>>>>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >>>>>>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> >>>>>>> +		if (!dma->state) {
> >>>>>>> +			ret = -ENOMEM;
> >>>>>>> +			goto err_free_dma;
> >>>>>>> +		}
> >>>>>>> +
> >>>>>>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> >>>>>>
> >>>>>> Oh, that is a clear no-go for the core DMA-buf code.
> >>>>>>
> >>>>>> It's intentionally up to the exporter how to create the DMA
> >>>>>> addresses the importer can work with.
> >>>>>
> >>>>> I can't fully understand this remark?
> >>>>
> >>>> The exporter should be able to decide if it actually wants to use
> >>>> P2P when the transfer has to go through the host bridge (e.g. when
> >>>> IOMMU/bridge routing bits are enabled).
> >>>
> >>> Sure, but this is a simplified helper for exporters that don't have
> >>> choices where the memory comes from.
> >>
> >> That is extremely questionable as justification to put that in common DMA-buf code.
> >>
> >>> I fully expet to see changes to this to support more use cases,
> >>> including the one above. We should do those changes along with users
> >>> making use of them so we can evaluate what works best.
> >>
> >> Yeah, exactly that's my concern.
> >>
> >>>> But only take that as Acked-by, I would need at least a day (or
> >>>> week) of free time to wrap my head around all the technical details
> >>>> again. And that is something I won't have before January or even
> >>>> later.
> >>>
> >>> Sure, it is alot, and I think DRM community in general should come up
> >>> to speed on the new DMA API and how we are pushing to see P2P work
> >>> within Linux.
> >>>
> >>> So thanks, we can take the Acked-by and progress here. Interested
> >>> parties can pick it up from this point when time allows.
> >>
> >> Wait a second. After sleeping a night over it I think my initial take that we really should not put that into common DMA-buf code seems to hold true.
> >>
> >> This is the use case for VFIO, but I absolutely want to avoid other drivers from re-using this code until be have more experience with that.
> >>
> >> So to move forward I now strongly think we should keep that in VFIO until somebody else comes along and needs that helper.
> > 
> > It was put in VFIO at the beginning, but Christoph objected to it,
> > because that will require exporting symbol for pci_p2pdma_map_type().
> > which was universally agreed as not good idea.
> 
> Yeah, that is exactly what I object here :)
> 
> We can have the helper in DMA-buf *if* pci_p2pdma_map_type() is called by drivers or at least accessible. That's what I pointed out in the other mail before as well.
> 
> The exporter must be able to make decisions based on if the transaction would go over the host bridge or not.
> 
> Background is that in a lot of use cases you rather want to move the backing store into system memory instead of keeping it in local memory if the driver doesn't have direct access over a common upstream bridge.
> 
> Currently drivers decide that based on if IOMMU is enabled or not (and a few other quirks), but essentially you absolutely want a function which gives this information to exporters. For the VFIO use case it doesn't matter because you can't switch the BAR for system memory.
> 
> To unblock you, please add a big fat comment in the kerneldoc of the mapping explaining this and that it might be necessary for exporters to call pci_p2pdma_map_type() as well.

Thanks,

What do you think about it?

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index a69bb73db86d..05ec84a0157b 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -84,6 +84,11 @@ struct dma_buf_dma {
  * PAGE_SIZE aligned.
  *
  * A mapping must be unmapped by using dma_buf_free_sgt().
+ *
+ * NOTE: While this function is intended for DMA-buf importers, it is critical
+ * that the DMA-buf exporter is capable of performing peer-to-peer (P2P) DMA
+ * directly between PCI devices, without routing transactions through the host
+ * bridge.
  */
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
                                         struct p2pdma_provider *provider,
(END)


> 
> Regards,
> Christian.
> 
> > 
> > https://lore.kernel.org/all/aPYrEroyWVOvAu-5@infradead.org/
> > 
> > Thanks
> > 
> >>
> >> Regards,
> >> Christian.
> >>
> >>>
> >>> We can also have a mini-community call to give a summary/etc on these
> >>> topics.
> >>>
> >>> Thanks,
> >>> Jason
> >>
> 

