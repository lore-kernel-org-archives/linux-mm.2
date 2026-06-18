Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10FFCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578C76B0095; Thu, 18 Jun 2026 11:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DBC26B0096; Thu, 18 Jun 2026 11:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1F26B0098; Thu, 18 Jun 2026 11:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9AE6B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:56:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68BD21C0068
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:56:15 +0000 (UTC)
X-FDA: 84893485110.11.A6E7F0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C21DB40015
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:56:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n5Ppr8oT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781798173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0IPDtr0E5+xfAyCrxjr92IdLXpNLF4y4zjRjFT4Sj10=;
	b=DkAoCdHTSv26PbzN4T2UQTACaqsY/heNAOv+kQWNRiU/pYR76WkHAFEQnE45Q8a+pVlXRC
	C8HvREDkmByTTj+rf1is/pxBfrENoRAEK0RTIzKjbFqmLO7zqN397+O91ckVXIDFjDtC1C
	FB96P2ArO+bbsRqMO3YO/o9tvgzMaLI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n5Ppr8oT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781798173;
	b=6Sgya6HH+aIWo4nzvlWIYbK+zsHhXifhulpJ1+3jdUKPh8v3AbWkcjWwjGAo9rTjHrslg/
	R8hLe1KgaxEiOBK8tpK/XlKiMGFBG8xc2CT4C4NJgIwL5pJxbXagkUfr6fUdVlh011SLxg
	WwD5h9IoTJvynVm4gqfdwoQ9Fkx+MSA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7EA040DC5;
	Thu, 18 Jun 2026 15:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9B01F000E9;
	Thu, 18 Jun 2026 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781798172;
	bh=0IPDtr0E5+xfAyCrxjr92IdLXpNLF4y4zjRjFT4Sj10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n5Ppr8oTbsOSG6YshsqBhUNoHlscayzOxfcTXj/PDj5/OnEbF0/qlDY6o7NZNha5m
	 HgjQSOS/r4R/SKtM82iyRJCAQPfrDYAnCU4z9PtxfI7+eBN932mRCKDXQNtZaAGIAx
	 UyRPSynU6cGlCR6F4R3o5pzmitLFpjFP3ZDn+cDIDqghlYynP2Y2psERaPm9qceNfy
	 4XdgjEMq/4X/fxKfNO1B2JaBSZ3+RFh40OMM4M2CB+NTaU8K68b8ic6+PxzjXsVsqb
	 NS7stYaETFJJGEWippfCuKv23o3Bnf2Mm4hOQ+uZz21mpSRU3I2Aj77ZZMQn9CtWrA
	 pGcw6v85wavEw==
Date: Thu, 18 Jun 2026 16:56:06 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex@shazbot.org>, Anthony Pighin <anthony.pighin@nokia.com>, 
	linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajQRY7tHShCEz8vg@lucifer>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <ajQI5jMJpxyNZCLN@casper.infradead.org>
 <20260618153049.GG231643@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618153049.GG231643@ziepe.ca>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C21DB40015
X-Stat-Signature: 7erxawdmzy4sjfa4g87j5wfhts9agd1g
X-Rspam-User: 
X-HE-Tag: 1781798173-202321
X-HE-Meta: U2FsdGVkX19Ht6mrrfqO1vr86VTc2LDvU6ApTtJUJUGY6Ix/+1aSShYTHVT0EibR4kgmrW54bWRo8PIqJtedvTavF/6M4TOFmnyL0oBYggdPwqrvAmHeyO39aJGaES1ojtRFkFyYBlTCpLxVlPHfcPh4j2zo//GprppuTbAAy5BH6HYN4CvOl4wsInv0DphbT35zAEFwZMX3njUvY4/TOz5HyiuEoPAmmoQJKKwR9mobC680atN3t7Xw3ElVHfVk5o40n4kQcc4HX+nIYruQRjctaYJvPN0qTOAYOpuoC1Y8yTA7woZTrEYJ27oM+p63lQU4DU4ZcE6axwPOzGfMPOnwcPyovtQAZRmC5ShuJvW71R/s1Em0ptIBsk+Xae2J63kIEXB2dUePiKAnXHJlxW0+9eTUQOjcO/loo1CawhCKD6yZh7KX7NroHAgkzGkrmllGYNaE9qf9ULd2dDs9he/v9XHpAnl7NFOrbMSJLF4ITBOGeYiZckT4VPRbaz6ntvB+/mj0yn9oKCPc4/hu5RnWp8iF9hVbKgMhwg3+6hbNuefkGaf1EmFixjchpNQI3PE2Zz6M8/6sZ/uswvFpTXbWdh/gy/aRAxwsL7VriD6FH0aFgcmZ/xQ4Bq3NdN7ovxRCa6lzYKgoKmlFW+/zFABNrr93mJPFnxEfL/dIsGKRslyB3UQPHatHxhWVHehhgMdc4Y3KCtu34zq8KyhzWEA4/q3m45xIhujh2gXzjfuvq6fbkS6nNhxvq9I0/TAD6Ssuidb7gOTZtNM0i5tVKkB50GN3W44qj4nGq7KmyzIOl+TK0mxQv4XsrquhFSiod9maotwpFJkgk9a4M4iXaMz5xGmLVsiqXtNopnIZStS/5O5frKDW1w2GjT6uGrCXuCxwUf0PL4JTkchIjjF86Xr/L6tAdDbifIvIKle8tjo252MFIjBAWH0JzNnq7G59Yy17KKpaiPo88O1x7NY
 f4skY0D6
 l778t1z9oXi2l9Jj4dAYGJa20I7b4xjXS+uXgMk5UB8S4KyAodH0ZOV1k+BJRPorhvZExgKZ3tcEyOI0BcV/xEEmk6zqkzkwB9svSEsXPG7TGWHIbBzMSQiXFAMwNWYab1fDf/MRgTq6BuYXJwJfBj87g7MNrl84pqNXFzEWUNObzr6/rJPq+N7CiwNThsAbrW+QrMJfQwxlWyt6DcwGId7Cv+cHSzPiU00UZlTjpYg7xcGT/MZTR9qSVbXnD/kWx4bzX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 12:30:49PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 18, 2026 at 04:04:06PM +0100, Matthew Wilcox wrote:
> > On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> > > On Wed, Jun 17, 2026 at 04:29:28PM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Jun 17, 2026 at 07:34:06PM +0100, Matthew Wilcox wrote:
> > > >
> > > > > I don't see this as being something that drivers should be involved with
> > > > > at all.  The MM should be able to get this right without any hints from
> > > > > the file-provider.  Yes, that means I also want to get rid of the setting
> > > > > of get_unmapped_area in ext4/xfs/other filesystems.
> > > > >
> > > > > Looking at generic_get_unmapped_area_topdown(), I think we can do this by
> > > > > making an additional call to vm_unmapped_area() before the existing two,
> > > > > setting info.align_mask and info.align_offset appropriately.
> > > > >
> > > > > Now, what's "appropriately"?  I think it's based on length (>= PMD_SIZE,
> > > > > then >= PUD_SIZE), but we should also take CONTPTE architectures into
> > > > > account.
> > > >
> > > > The info.align_mask and info.align_offset do need information from the
> > > > driver based on what it intends to map into the VMA that is being
> > > > created.
> >
> > What you're saying is that offset 0 of the opened file might correspond
> > to a PFN that is not aligned in any way?  I had assumed that when trying
> > to do the mapping of (2MB+4KiB to 64MB), that the offset specified to
> > mmap was 2MB+4KiB.  But you seem to be saying that the offset in that
> > case would be 0 and someone needs to know that it corresponds to a PFN
> > that is misaligned?
>
> I do expect that the pgoff space is usually aligned to the pfn space,
> most drivers do that or could be improved to do that. There will be
> some off cases, but maybe we don't care, and VFIO should be fine.

Some stuff has weird assumptions about pfn=0 at start of the range (DMA for
instance).

Presumably not applicable to VFIO but that's a thing we need to stop
doing... (I have some patches I deferred from a while back changing the DMA
stuff).

>
> That is certainly an easier place to start.
>
> Jason

Thanks, Lorenzo

