Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82984CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50368E0010; Tue,  2 Sep 2025 07:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27A08E0001; Tue,  2 Sep 2025 07:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9169E8E0010; Tue,  2 Sep 2025 07:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC3E8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:07:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 255EF140C02
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:07:00 +0000 (UTC)
X-FDA: 83844033000.14.69D7317
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85853140003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:06:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=luXQtemq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756811218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyRABlDv/T9upda1w/wHJxGWLnV+kWdSwU9weCJgSwk=;
	b=jKzlkPvT9fyvkbLGVbuBCjO6/ZWKoKIb0pxxaaU8G74xwzgjdgaCHvnR5GgtCPFlAwCNrC
	BsnpOuGTnAU5CGhSPNb4iNfLBDEzaAIUvgdr4fzZ9W2YnOYPQZXEY7IMdaT/XT4rFUma6N
	G9hSzFwFhzGMUOAzkzyDntw12NABz+Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=luXQtemq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756811218; a=rsa-sha256;
	cv=none;
	b=LIBuiHrMU8xQtjS8kQt+jr5VWFtygj/eJS4MJuDHrGsLiSBTL1puZ8aOKYx2Vx70dLQU3/
	7ArKasRqJT8aGUdewz4tN7M+g8qNBKOITqM4yDlWek6QMa1o0r+qk6AfLqypC7mB+N+3NT
	v6EQ52z1t4lEDzTfnsKiHsHXV7nFXOI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B389260206;
	Tue,  2 Sep 2025 11:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D67BC4CEED;
	Tue,  2 Sep 2025 11:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756811217;
	bh=hCa1C3d5MBR18h+mVpk4RAM474rjo1/g4TQSzEy0Gzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=luXQtemqwauDCW1OGofW7KOn0Ed3TXz+7wSyh4Rq/4C4pBNfrCav73O7nhlQqKsu9
	 pJwS6fgD10XM5MWzc2V32cauwX2xcs5uKtg2Bn+xWgyC8SmOfVZ8jKdythn+ZO4vAa
	 0h7EOGiI+UMeKypfX8GCyk9wrCAP4tCX2z8kMskVDMEaLSOSdX6db0uWHaJchKjybu
	 MaLbWwVqK1itWBWz4FOiOlTEHChtIjiBEjBS0WHuFG4wArCchdxmDkRdChfk7RgGoF
	 PbQcn5XJw0e6Ezn8C5XZTAc61l/+qt/LvKdGUrn6ovVC7JKrzqR3GHSc85H+bG5dhG
	 nrqyYFGPfwuJg==
Date: Tue, 2 Sep 2025 14:06:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
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
Subject: Re: [PATCH v1 01/10] PCI/P2PDMA: Remove redundant bus_offset from
 map state
Message-ID: <20250902110651.GF10073@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <c9b6237964b9606418af400bb6bec5178fcffff2.1754311439.git.leon@kernel.org>
 <20250806145825.2654ee59.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250806145825.2654ee59.alex.williamson@redhat.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 85853140003
X-Stat-Signature: 4zyw6uziztisuj8qp7mumzcpxemnry9s
X-Rspam-User: 
X-HE-Tag: 1756811218-892322
X-HE-Meta: U2FsdGVkX18Tl5MsbPYnRfsk2D75elpYajoOXOR8xr5Pe6VPP6LZ/FhVQbfarXCGIb91vnMsZVFfwieDyIA8+K52QafNgnXxHYiZfhJKZWruf7Et9kD99VbGzRDm/NG67XoZ2KIWK0BzzOp6+4bmXFG4+yny5MiAyAR3tHw3vUzvZCDYjdHi9BPV0jbaewv+hDmTLjNPyzI6YTaw8CV4tjNECkfpk6Lx2BxnF3pOtzCp9AtPFDck1GMI2oJWzIRMM1weNBGN3iOGO2yflwPOoMiTrtECve9U0Fl/pjs2KGa9AbLG4aE4r4hNFr0FJvAh5/EIY3TiwV7glqVng2UxKCaQMUCW7QizoE8aF+E/9/h7UMH1okNxq79ynaixI4j6xPa+7Nlh2gIqXz8G2APUdaL72+TXvz2VS0eJoLJDFlPrXDL6No4g/k2KnlZs1Z1uPzia1nr30eDMsWPtkLp8dofg/7B0YhVC40JJpmyYmQQrE6igBmMYrq80TEQLFl+hyRDWw5mhAIkQReyPn8c4DrPs69bt55g+olfiC2CuaHU4YPL92W7sX7rutG5BUyKQ983qdZ8NyPvYmRr3/jCBhISQccz6v7GLVuq+/21zp4UQzEC/KpeuEK5EqTqAXVPRcp91Q1c6UyJ3VmMSu+bH73IkKrrAJbJ8K6SQlu28pvxaNfZWlFNsJSxjz6XQ+r/vxpmwQKdJZUcmI0/1yeRNRo5HhwO+CAgGDCZBdK5fTUTm6qLjQDM6SsEFjqosZQw51R913fu0gpVZdV+qqcMZO6zuxaTVyuX4aNnwIPRYQwt0byDY/5Vs9j7qVFCso5bapEPWTwUXU6KFROgMNCx1pEPJ3sC1tBMqEkHmcAq0itn+Snr1PDUrcQkKDlIkLG+Tde2RZtro7iFu3pPlbBgi2dnIVjoBKM6vkPEWhfK/hwIyTBgtyz3jTK8bPPeF+ZGrts+Xd288nQUI554fjYa
 0Q+YMatt
 RnTdMZfk4Lx+t0L84IagcV1h6SRONWaSvqd1G0aL8MiYhhosmsTsVNxJbHuyw7GGE8MyqAcPYorrfGstvGurevhlml04I3XummRT34xuCVNLTg5mWbZ6iBdB3unvj0gGeLfiX8z953Z+fiwi0U8XYvWqkO4keqLXrJCXEXyE90DcnWN8ohiJy+xNrZ/XG0d4yzQAaH6nNBfsr7qB5yQbWq9PuDJmiW0k3KVTlU/yeha1qmYAkwf7Jj0HJ7w22k7TWygoSDEWSHwyYPs71CQoawefMFp0a2JclerqcmPNI0IvIxHAlnIhQ/02VAoFVkLR42k4XMfmPL0CYicaiCR/1nh8OaN5t/ZRooweuY9LccATH9HGQyLrr/cCqNf4rk9X55OIUqShwxo+4TaMJ5OVc+HMjZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 02:58:25PM -0600, Alex Williamson wrote:
> On Mon,  4 Aug 2025 16:00:36 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Remove the bus_off field from pci_p2pdma_map_state since it duplicates
> > information already available in the pgmap structure. The bus_offset
> > is only used in one location (pci_p2pdma_bus_addr_map) and is always
> > identical to pgmap->bus_offset.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/pci/p2pdma.c       | 1 -
> >  include/linux/pci-p2pdma.h | 3 +--
> >  2 files changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index da5657a020074..274bb7bcc0bc5 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> > @@ -1009,7 +1009,6 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
> >  {
> >  	state->pgmap = page_pgmap(page);
> >  	state->map = pci_p2pdma_map_type(state->pgmap, dev);
> > -	state->bus_off = to_p2p_pgmap(state->pgmap)->bus_offset;
> >  }
> >  
> >  /**
> > diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> > index 075c20b161d98..b502fc8b49bf9 100644
> > --- a/include/linux/pci-p2pdma.h
> > +++ b/include/linux/pci-p2pdma.h
> > @@ -146,7 +146,6 @@ enum pci_p2pdma_map_type {
> >  struct pci_p2pdma_map_state {
> >  	struct dev_pagemap *pgmap;
> >  	enum pci_p2pdma_map_type map;
> > -	u64 bus_off;
> >  };
> >  
> >  /* helper for pci_p2pdma_state(), do not use directly */
> > @@ -186,7 +185,7 @@ static inline dma_addr_t
> >  pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
> >  {
> >  	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
> > -	return paddr + state->bus_off;
> > +	return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
> >  }
> >  
> >  #endif /* _LINUX_PCI_P2P_H */

Sorry for long time to reply, I waited to see what is going on with DMA
phys_vec basic series and together with my summer vacation, it took a
while.

> 
> Looks like you're relying on this bogus code getting resolved in the
> next patch...
> 
> In file included from kernel/dma/direct.c:16:
> ./include/linux/pci-p2pdma.h: In function ‘pci_p2pdma_bus_addr_map’:
> ./include/linux/pci-p2pdma.h:188:24: error: implicit declaration of function ‘to_p2p_pgmap’ [-Wimplicit-function-declaration]
>   188 |         return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
>       |                        ^~~~~~~~~~~~
> ./include/linux/pci-p2pdma.h:188:50: error: invalid type argument of ‘->’ (have ‘int’)
>   188 |         return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
>       |                                                  ^~
> ./include/linux/pci-p2pdma.h:189:1: error: control reaches end of non-void function [-Werror=return-type]
>   189 | }
>       | ^
> 
> to_p2p_pgmap() is a static function and struct pci_p2pdma_pagemap
> doesn't have a bus_offsetf member.  Thanks,

You are right, probably the best way to fix the error is simply squash
this change into the next patch.

Thanks



> 
> Alex
> 

