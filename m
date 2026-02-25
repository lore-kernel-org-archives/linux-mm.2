Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED44AEFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341FF6B008C; Wed, 25 Feb 2026 02:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF616B0092; Wed, 25 Feb 2026 02:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205506B0093; Wed, 25 Feb 2026 02:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2BA6B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:50:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82EEE58A59
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:06 +0000 (UTC)
X-FDA: 84482205612.03.2D96F09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C2C9E4000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fECYUl98;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ygkx0dWswHQoNOKvgrNi90Aw2OYzClFA1ZHEX6h5mFk=;
	b=qnbIMR9UG2znwLxwaWB4DDFt2KvpJrxSkPlmoW3VVT7mDdeihf1UXfl1JdGC8htRvL16Ge
	xXxfTzvkfAW/MSajURPEFfq0TFSNQhywHQhneflzWZB9820Udd1ZslQYSECgjodxz+GxL5
	5AV5yyEOFLmcjEO/WbBqqJ+p5VD3T0c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fECYUl98;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005804; a=rsa-sha256;
	cv=none;
	b=WDgXQAOWlZjeVCUcvYx0TVoKo2/9ySshYOCqXvMWSicwKlm8UEbqdATrVVm1u5vJO/0lAa
	dU0XX/EOPJLE9I5o2OTLWnobmqs4EGa/MB1zgJOyg4KWyhGnMb8XR9dsgSJh883tAuLsbY
	eZZXNa/kT4q2oKegr1fnTzQwoMcVQwk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9965419B0;
	Wed, 25 Feb 2026 07:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E1C19422;
	Wed, 25 Feb 2026 07:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772005803;
	bh=HvGkE+KfnO1/uKHBtgvhjWCUGZzE6KTtQGJZAUqruSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fECYUl984LeA3A2bhWgQE1lfBxon8xIufqg3QpJ5LB7FeVeJ8jWoyNxxeJnjRPa+2
	 7KVZxytSu4S03dc56kH2QD1bfPMdzlVY/V+5/diI/+WHJg85NCQrxzqDG9vdwREu9W
	 zWCZqivmboa20fuEtYY1kSMGfg3XiSy6nQCUAdbiPszJQ/KX7NJukb+7UYiyhLJ3c1
	 /Rd5OsbvT6kruxobHW1o9Ohn82W+slK7Va1y2d+EIEueAh9fu5Umbbnc9bySeLxvqh
	 8uQAbhYfWkO91t2xAYipJrEdKmh4sgmsZkpzUn0uGQxlCyeIw5u2xKwQUnbvkC5Jh3
	 cNycjbyFyusWg==
Date: Wed, 25 Feb 2026 09:50:00 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Ashish Mhetre <amhetre@nvidia.com>, robin.murphy@arm.com,
	joro@8bytes.org, will@kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
Message-ID: <20260225075000.GA9541@unreal>
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal>
 <aZ4Q1HA9q1ojsVYY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ4Q1HA9q1ojsVYY@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2C9E4000E
X-Stat-Signature: 5kk6bxefae9xj68qnoh366hjnhddag7w
X-Rspam-User: 
X-HE-Tag: 1772005804-128258
X-HE-Meta: U2FsdGVkX1+37I/raj++hxYpOeBsoIyUoTYS56ecsIGLE/vSHx3YfVap7ojIakXcZBOC8EIgzfRXrEK+CWPB3ZrqXFKRKstjUIFsvNtk8Ih3Socr70G063BdQzhlmez8zjMLDhovNUropw9mc09S4qcvOJw3iivrY92Wv0RdXx1aJ6DC3lmWKuHJMEygsI6hPsunrP3Msmc6Iq6b2M3+0gIiUgBOC/r22lTBUDk/1YhL43Sv/9mrTTdz1q0pQ3Tq+2y9+0HtlYQ3y6HFVDZ718QH83gcoFCuTNRoIClpbPqlZHhkKD0fzfiqASxXVJrEAue5oE/ZeQuLE2Io2MryYo+zbj7TI6AbR0gxpi3NSFyi8uhbz4fF/mgmZg3LBJAqIt9J7fgXxlQQIQ5upajdal/zlqiHV0uJ/ozMBWxxGE4J3Yro2Ntynm83/3Jo0B5TIj4iOy8iZXRvgmkm8+tYOHgEmY5JWxQCCRl1cqg2/I1aRYr0G0UT2NUwv3YtVtNxNM7LoTTGUQT3laKhwt5aN/Bke4g9mHtTAeZOIsO9qj65qIwp8xCSwW3e0djgzrtHtksjZO2XMPusKA3y/E+t9BTnbYxQN75IKR8yEndgInLYm0hSjhtl8uIAeXLs2INaWSPaBUrRa0dn5tbERhXvcM87V8kcf/jOtgIuAbWI/fYzLDwqjlZDpMfrw37c9XdC48ijhqFt7hYSLdwibczeXP5gtTXBoamfqUXpgBbPa6YfM2rKiDJU/5tai754sl1BrCW2bqsdJVojCIbcNInUzeRwlhfwZd67NQwF31GXIPc9T/lI4jJoxFsaoEJRm/ieeiieY5Z/a6elTdnTQMUrpY1hWLnaMUPZmXrIKfwCSx/d4ojdA4oHcVlkHlEqlmASwW9df+EO6GBLpu4VCMvwQX2uWDJIZOiacUZVHzbxVLrx0mhdYZxKW9bBpKa8WbjuljhdRQDPzSQ/440VMjJ
 GBJc1EQP
 I4bcPpqD0JyAFINb1g4d8wKNyBmXw9pR3RKIrXcAJyg5hjm3dIcnGr85eW6pUEj4GAVNa9LMJchqSqlHBBjXzV85fIdHkQRF2IM9jpBhAxIbI8KBGV6ESWByWz+Wukx/bQatecCXbcFAr9Fc3br/pGY7eA5zr9aDpiUZHNY+ZwXhy0u9AZ7CW9EGpNqdFk6bMpmcc9KWjXTzxMi76YR39sza5eL4Ub1mPdfR/wC8tn5qzKkQ3bCUAfi7jCWzk7m78ykBHOBggMnqyRsn9Q1eYQZm97OFaVmuA9gRfVuFfGUpA293TSrB+yC/Otf+UdOhzTKOuxBZorB6zG/zyMNHOzMhKgnFlTenG3iaqxKQAF88nUwqbI3SWW4FygMJfQfknpDjU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 08:57:56PM +0000, Pranjal Shrivastava wrote:
> On Tue, Feb 24, 2026 at 02:32:21PM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 24, 2026 at 10:42:57AM +0000, Ashish Mhetre wrote:
> > > When mapping scatter-gather entries that reference reserved
> > > memory regions without struct page backing (e.g., bootloader created
> > > carveouts), is_pci_p2pdma_page() dereferences the page pointer
> > > returned by sg_page() without first verifying its validity.
> > 
> > I believe this behavior started after commit 88df6ab2f34b  
> > ("mm: add folio_is_pci_p2pdma()"). Prior to that change, the
> > is_zone_device_page(page) check would return false when given a
> > non‑existent page pointer.
> > 
> 
> Doesn't folio_is_pci_p2pdma() also check for zone device?
> I see[1] that it does:
> 
> static inline bool folio_is_pci_p2pdma(const struct folio *folio)
> {
> 	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> 		folio_is_zone_device(folio) &&
> 		folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
> }
> 
> I believe the problem arises due to the page_folio() call in
> folio_is_pci_p2pdma(page_folio(page)); within is_pci_p2pdma_page().
> page_folio() assumes it has a valid struct page to work with. For these
> carveouts, that isn't true.

Yes, i came to the same conclusion, just explained why it worked before.

> 
> Potentially something like the following would stop the crash:
> 
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index e3c2ccf872a8..e47876021afa 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -197,7 +197,8 @@ static inline void folio_set_zone_device_data(struct folio *folio, void *data)
> 
>  static inline bool is_pci_p2pdma_page(const struct page *page)
>  {
> -       return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> +       return IS_ENABLED(CONFIG_PCI_P2PDMA) && page &&
> +               pfn_valid(page_to_pfn(page)) &&

pfn_valid() is a relatively expensive function [1] to invoke in the data path,
and is_pci_p2pdma_page() ends up being called in these execution flows.

[1] https://elixir.bootlin.com/linux/v6.19.3/source/include/linux/mmzone.h#L2167

>                 folio_is_pci_p2pdma(page_folio(page));
>  }
> 
> 
> But my broader question is: why are we calling a page-based API like 
> is_pci_p2pdma_page() on non-struct-page memory in the first place?

+1

> Could we instead add a helper to verify if the sg_page() return value
> is actually backed by a struct page?

According to the SG design, callers should store only struct page pointers.
There is one known user that violates this requirement: dmabuf, which is
gradually being migrated away from this behavior [2].

[2] https://lore.kernel.org/all/0-v1-b5cab63049c0+191af-dmabuf_map_type_jgg@nvidia.com/

> If it isn't, we should arguably skip the P2PDMA logic entirely and fall
> back to a dma_map_phys style path. Isn't handling these "pageless" physical
> ranges the primary reason dma_map_phys exists?

Right. dma_map_sg() is indeed the wrong API to use for memory that is not
backed by struct page pointers.

Thanks

> 
> +mm list
> 
> Thanks,
> Praan
> 
> [1] https://elixir.bootlin.com/linux/v6.19.3/source/include/linux/memremap.h#L179
> 
> 
> > If any fix is needed, the is_pci_p2pdma_page() must be changed and not iommu.
> > 
> > Thanks
> > 
> > > 
> > > This causes a kernel paging fault when CONFIG_PCI_P2PDMA is enabled
> > > and dma_map_sg_attrs() is called for memory regions that have no
> > > associated struct page:
> > > 
> > > Unable to handle kernel paging request at virtual address fffffc007d100000
> > >   ...
> > >   Call trace:
> > >    iommu_dma_map_sg+0x118/0x414
> > >    dma_map_sg_attrs+0x38/0x44
> > > 
> > > Fix this by adding a pfn_valid() check before calling
> > > is_pci_p2pdma_page(). If the page frame number is invalid, skip the
> > > P2PDMA check entirely as such memory cannot be P2PDMA memory anyway.
> > > 
> > > Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
> > > ---
> > >  drivers/iommu/dma-iommu.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> > > index 5dac64be61bb..5f45f33b23c2 100644
> > > --- a/drivers/iommu/dma-iommu.c
> > > +++ b/drivers/iommu/dma-iommu.c
> > > @@ -1423,6 +1423,9 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> > >  		size_t s_length = s->length;
> > >  		size_t pad_len = (mask - iova_len + 1) & mask;
> > >  
> > > +		if (!pfn_valid(page_to_pfn(sg_page(s))))
> > > +			goto post_pci_p2pdma;
> > > +
> > >  		switch (pci_p2pdma_state(&p2pdma_state, dev, sg_page(s))) {
> > >  		case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> > >  			/*
> > > @@ -1449,6 +1452,7 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> > >  			goto out_restore_sg;
> > >  		}
> > >  
> > > +post_pci_p2pdma:
> > >  		sg_dma_address(s) = s_iova_off;
> > >  		sg_dma_len(s) = s_length;
> > >  		s->offset -= s_iova_off;
> > > -- 
> > > 2.25.1
> > > 
> > > 
> > 

