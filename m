Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B04FCCD1A4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65ABA8E001F; Mon, 20 Oct 2025 11:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B5E8E0002; Mon, 20 Oct 2025 11:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA798E001F; Mon, 20 Oct 2025 11:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5E78E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:04:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5F3DB6D76
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:04:19 +0000 (UTC)
X-FDA: 84018813438.23.B45982F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E61A160017
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:04:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iRT5USF1;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpvQemVrdaAOlVxGvQIl+22pquHrwRWeRF5Ih8nczDg=;
	b=ui1dijr3hChh4swiVr1g0M1eDeGHcBbTKhwnvq08roZ1D9vlhz/FaL5O3MoibvgcE0W3pA
	czY6AQuwWWe/xnPSGGZJoaKmU/8nNC56IRVKZti51gBTSZVJfD8ciOCisqBiZPBfk/vLwx
	j6cS4oJYidUalDrRY96pkl5Y0nYJCzo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iRT5USF1;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972658; a=rsa-sha256;
	cv=none;
	b=tx8fSdd+HYJSRmcYMdS06VEfsnMA+K3xcfwp4bjr7H0fT9tGcmX4OS5m6qOunhipNaE8/p
	v7HthK3lO/qQ80Zzk6InDBDBe4vAZefonqQ6nkaI6AU8sw7Vd4d2U4Kktmcf05VYmXFAlu
	PNplr3wmiyhzKjrUkfP1x+7iA+o6lmg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A31BE60271;
	Mon, 20 Oct 2025 15:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DD1C4CEF9;
	Mon, 20 Oct 2025 15:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760972657;
	bh=opgDUacvsAEAblCjRwc/cnZnXjDHKNzApka9lSwmFm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iRT5USF1c9hlxYuIAOhCLi5vAK5WR7rom9xRkIU3R7gF7myd/1e5DMMfNCS0kUZkY
	 3iRkzX0tjSk5Oi94wjBXhi3wnlTtnIwsAvgfAKJFuquBcdXjW7d9WDWrPNIf5J0bU5
	 zVOo4RRrxdwbFsBukm+Rj6kIqO8vqJWtwlc9Wep5HFp36crF5d7piD0ABkB0lYukcY
	 occ87bgOGiq4SFUOt5aNiFNgE39VrrMYCKAhg7FXj21tnyeBL4evlgZwZyr9LIYUQF
	 TbY2GnPoLUsXHvGaif5VObAw2oxejIFZ08On78dvTXugRYsJ65uWf5lD//iEs7lnk9
	 fxqi91aJMPONw==
Date: Mon, 20 Oct 2025 18:04:12 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the
 core logic
Message-ID: <20251020150412.GP6199@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
 <aPHibioUFZV8Wnd1@infradead.org>
 <20251017115320.GF3901471@nvidia.com>
 <aPYqliGwJTcZznSX@infradead.org>
 <20251020125854.GL316284@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020125854.GL316284@nvidia.com>
X-Stat-Signature: dous5n3z8b1nw7ka16zzusmgut9347uu
X-Rspamd-Queue-Id: 5E61A160017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760972658-301742
X-HE-Meta: U2FsdGVkX1/mJnouLpn4Ni1eFMijWWbNi/tgbekoVznR+L/oRF1tLJX9STNyWx9BVfZhPcJg3vfriXMd3i3mSiJwGWlO64MupavZ4rCHKyljlmx1mE25fYnp56PjahEDC9T3kNDaGFcs/NBT1lnOEn0MnpbRNVoe/I+YNz/kDadbx+VLRedmPoEo32+bHPD8tiFa1XWTgvrDzJ9lK4M7Cr6fiTtf7WJPHjsdCyvYqte7oNguGIgQYWhaZxoP19a1ALXCS/DL50nZGVMmRdgs9zqdDJPw6ZxL5f2Z6iCuGVDAzUQUD62RHBx+uG1zELuGlA78ug7WnSDdwwidFIFHnFAbdUaM/uRkf/GbbdLrVWKoeE4mOMMCj8QKK6w/OG2mSdrzFcUzEaEYT44G3tiDbhJXjN//rYGD7E800jVNNvbHgF64H53cWKkdUPYBWR0zpWDD/E15ASwLirIXl+vie0r3dbS8hJCV9FLs3MN5Cq+YGJOMoDXrVY74po9ZGkWp31YQMfaUMG6ab75Xzyhl//F1XtFj0C2/cKvvBPWLD8AKA/y2mV2SbizEMxUtUPzjCMBrJgl8AgiyZnYljV8UrMzqpR3kKnzcY2ByLRrXRzoiS8l0S69E2ZnrKTvXXKfngci1U3GjD21eAlSNfCz+rGAcWsHPCibL1eHS+WeJ9lqrOTDKn06vu30CjM1fPj5ngedkzK7oYut0szPZwM7QO6K/u5nZE12H1YiapEMV9MCNPkrHdOIBRcxk+pBN/KFul+CDCeen43ITwFRHrB0pQi7hWlnW7O9Njc7yvkpbmq4y48PPPynouLYeqMubQVCNaGbh5F75VOan5avhgjL51MlcWy27yjR2mrnhqHTCxCPZjdlJP35l7sh1ULUAxAVG9e3E9NgRjTYgaKL2FwB2++Uu07fdkyOB6Z7d2cj8WUtsmHdMr6wWcuuWqKMTm2Csrq23QZ254wEEW6mpzyD
 PPcwM8S9
 a1d/u7oaFoT8B9WGMvyVXFZeRIkNFwqImHeX3/zSZpWVySL/YLwlDLoRRvIm1sH+5ZLd2SFFD8Hj+GY6Cu9XtoyGThlIdekG2bS68upGVoQOdwB/7RC7ertnf3VUSanfYJGueO56HRaBzIsaTS7AAoj7azZUlPxArFjRvMTudLcBqbsT5ERc0hORyvn1IYsjYbSkSk29fcmK+xExlnVVmyrp2Qaf6u5xuX2Xf8UqVL/Cqg7WCyak/hGRW/4T2Wgf8uXp+IN6aeWBe1INoRexEl3wQSCYAvOo1d310sCYaclKk1nk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 09:58:54AM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 20, 2025 at 05:27:02AM -0700, Christoph Hellwig wrote:
> > On Fri, Oct 17, 2025 at 08:53:20AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Oct 16, 2025 at 11:30:06PM -0700, Christoph Hellwig wrote:
> > > > On Mon, Oct 13, 2025 at 06:26:03PM +0300, Leon Romanovsky wrote:
> > > > > The DMA API now has a new flow, and has gained phys_addr_t support, so
> > > > > it no longer needs struct pages to perform P2P mapping.
> > > > 
> > > > That's news to me.  All the pci_p2pdma_map_state machinery is still
> > > > based on pgmaps and thus pages.
> > > 
> > > We had this discussion already three months ago:
> > > 
> > > https://lore.kernel.org/all/20250729131502.GJ36037@nvidia.com/
> > > 
> > > These couple patches make the core pci_p2pdma_map_state machinery work
> > > on struct p2pdma_provider, and pgmap is just one way to get a
> > > p2pdma_provider *
> > > 
> > > The struct page paths through pgmap go page->pgmap->mem to get
> > > p2pdma_provider.
> > > 
> > > The non-struct page paths just have a p2pdma_provider * without a
> > > pgmap. In this series VFIO uses
> > > 
> > > +	*provider = pcim_p2pdma_provider(pdev, bar);
> > > 
> > > To get the provider for a specific BAR.
> > 
> > And what protects that life time?  I've not seen anyone actually
> > building the proper lifetime management.  And if someone did the patches
> > need to clearly point to that.
> 
> It is this series!
> 
> The above API gives a lifetime that is driver bound. The calling
> driver must ensure it stops using provider and stops doing DMA with it
> before remove() completes.
> 
> This VFIO series does that through the move_notify callchain I showed
> in the previous email. This callchain is always triggered before
> remove() of the VFIO PCI driver is completed.
> 
> > > I think I've answered this three times now - for DMABUF the DMABUF
> > > invalidation scheme is used to control the lifetime and no DMA mapping
> > > outlives the provider, and the provider doesn't outlive the driver.
> > 
> > How?
> 
> I explained it in detail in the message you are repling to. If
> something is not clear can you please be more specific??
> 
> Is it the mmap in VFIO perhaps that is causing these questions?
> 
> VFIO uses a PFNMAP VMA, so you can't pin_user_page() it. It uses
> unmap_mapping_range() during its remove() path to get rid of the VMA
> PTEs.
> 
> The DMA activity doesn't use the mmap *at all*. It isn't like NVMe
> which relies on the ZONE_DEVICE pages and VMAs to link drivers
> togther.
> 
> Instead the DMABUF FD is used to pass the MMIO pages between VFIO and
> another driver. DMABUF has a built in invalidation mechanism that VFIO
> triggers before remove(). The invalidation removes access from the
> other driver.
> 
> This is different than NVMe which has no invalidation. NVMe does
> unmap_mapping_range() on the VMA and waits for all the short lived
> pgmap references to clear. We don't need anything like that because
> DMABUF invalidation is synchronous.
> 
> The full picture for VFIO is something like:
> 
> [startup]
>   MMIO is acquired from the pci_resource
>   p2p_providers are setup
> 
> [runtime]
>   MMIO is mapped into PFNMAP VMAs
>   MMIO is linked to a DMABUF FD
>   DMABUF FD gets DMA mapped using the p2p_provider
> 
> [unplug]
>   unmap_mapping_range() is called so all VMAs are emptied out and the
>   fault handler prevents new PTEs 
>     ** No access to the MMIO through VMAs is possible**
> 
>   vfio_pci_dma_buf_cleanup() is called which prevents new DMABUF
>   mappings from starting, and does dma_buf_move_notify() on all the
>   open DMABUF FDs to invalidate other drivers. Other drivers stop
>   doing DMA and we need to free the IOVA from the IOMMU/etc.
>     ** No DMA access from other drivers is possible now**
> 
>   Any still open DMABUF FD will fail inside VFIO immediately due to
>   the priv->revoked checks.
>     **No code touches the p2p_provider anymore**
> 
>   The p2p_provider is destroyed by devm.
> 
> > > Obviously you cannot use the new p2provider mechanism without some
> > > kind of protection against use after hot unplug, but it doesn't have
> > > to be struct page based.
> > 
> > And how does this interact with everyone else expecting pgmap based
> > lifetime management.
> 
> They continue to use pgmap and nothing changes for them.
> 
> The pgmap path always waited until nothing was using the pgmap and
> thus provider before allowing device driver remove() to complete.
> 
> The refactoring doesn't change the lifecycle model, it just provides
> entry points to access the driver bound lifetime model directly
> instead of being forced to use pgmap.
> 
> Leon, can you add some remarks to the comments about what the rules
> are to call pcim_p2pdma_provider() ?

Yes, sure.

Thanks

> 
> Jason

