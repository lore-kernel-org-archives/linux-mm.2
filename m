Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3973FC5903
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2526B0088; Thu, 26 Feb 2026 02:58:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0586B0089; Thu, 26 Feb 2026 02:58:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCE36B008A; Thu, 26 Feb 2026 02:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB856B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:58:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AF3F140A24
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:58:13 +0000 (UTC)
X-FDA: 84485854866.29.4995EFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EFB2B1C0009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:58:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zc1/CqtJ";
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772092692; a=rsa-sha256;
	cv=none;
	b=zyyTng67VnV5qqoETbRCwxYnsX6k36K+rcjYcMp+b+xXAPgZH7cOiWN80Dlz0/cj7cc89e
	+9dgX/3iLVFsWaS3cwvvT2nIQxOA9hxN33KVwBGGVMNish9LpF8rsBxNmG7q6nkpozBieu
	/ytWP0taFTDgVVtZgO/HYB79goRekZQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zc1/CqtJ";
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772092692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fpUK4LfylAvkG0XeIRFeExbCCkS9TIdCEYEy7IZVNY=;
	b=esoUjGsu2ypSZrz6ofJyx7wYQAJqiKn0bSKYd1XfDv8rejb+F+OpJhTQn7MLKuwgEgiv+R
	LFm0mJkps5mMkyjSr9kjVigQRvAaKgn13MQbjapietxPBRMilOf6FSB+LXH0t+VnftCuQt
	pUTDdZM3dAx/YQwC6bhmGEMetzTDsng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADF9544297;
	Thu, 26 Feb 2026 07:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23668C19422;
	Thu, 26 Feb 2026 07:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772092690;
	bh=hwHQ4BRTp4F0JOLYb4176Dt2qXHf/97NMLc4rVMaBHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zc1/CqtJ2lX1ikU1tRuGiLCcSf+PJcmQp27jY1UVT8mEhBa0T7oK+fzCGVBeZsnTp
	 y57Hm4DKDShkuemMzKtTTD22AIzdkwAkI/Zh/EaCqzfKLjjTjMMwqeIKxG5MPinOyB
	 +Ua2UOxErR6UkS9HiaYRC8ewYWmTy69fEgQVMDp1XNvm+wbugf4un4dWktqraeOfuJ
	 bmFGDIk24OO+ugM8aNKQuQ1DFb6el5T2YXMfJrDaE8aGHS2my8BNOJmsZTvgdMk/04
	 F46UtHTWtsIjlkIKgoLOgYn0YWEPuXM0+VUczSP0rxBwQzQwkfPCYF3jEIEug39BTT
	 MU9wptbR55eFw==
Date: Thu, 26 Feb 2026 09:58:06 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Ashish Mhetre <amhetre@nvidia.com>, robin.murphy@arm.com,
	joro@8bytes.org, will@kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
Message-ID: <20260226075806.GE12611@unreal>
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal>
 <aZ4Q1HA9q1ojsVYY@google.com>
 <9d01b4e3-be5b-4c9c-8088-1d10f67f1fd8@nvidia.com>
 <20260225075609.GB9541@unreal>
 <aZ9Xccnn7JOikudb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ9Xccnn7JOikudb@google.com>
X-Rspamd-Queue-Id: EFB2B1C0009
X-Stat-Signature: 4u8krakonyandopro7po1n5chx7x43mx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772092691-20623
X-HE-Meta: U2FsdGVkX1+uglbMO5vYIEHlx6N8GrvtkauaOF3fYY4xk3ZZsz34ElJW30yV71C0lqPyKefC8VXO9SoO6ioB6VRXlaVYGKrfKC7+UbNFDUYdjbfRbFCieUEV2Utq7JC4HrLArbg1yHZgnf6WMn+xEXpqz9PGZT7IwbM8QVi9ATroZZaoPrPNzEQr/9BOI7/OaDJrONb274uM8Ll76fold5CMLCjraUL9NMNpLmhVyPtR45PaRYiQMbOtiZCSrkLa16ZY03nnIYRYc/mbb7kNxDLSvtIhTvx288+sNqldgl7553Uj+vjP9jHrXdjCrj2JlO2IUaAItbwgujqX+jDxUG7SEO0Dy2n5PBqUU/oWG823JELch1pESUI5q7DonSwENB0prWFaFL0Drf+2veL6XDaLo5Xlpp1pY/YAeLhBUeni7ME3p0O/IqIooCAPAX1SigbFEpWM4SXQUdY4EQse+paUTQIWu0JGvmL8lAg7arwBrVvDMRcTCVLAxufOASGCwJAMPX9Or76J/0rz1bCB8amxd0yfpY/HKwQVnH1HSIhscdBd31pxYlINGxVDGlcreKfrM1rrMEafVaDHqsrjXxDzShB5ffElxGQcdtVlct0exZWhQlig5H5llSzscSAyaXIpgLvgljYLSMtT/XjsblIizKALABc7vLCkU5GE9zD0t4B0Gq+xu0Ck0zKGxVHnZON2fU8qhRM+5qwL0bhWrJM+edQGL1rNUPpx5dnKv2EUuGoDh9I3P/aiCAzQeBM2rm0dx9n0D7pUkzFw+WfSI7QP6TicF5NMYvO+A+IOcEjo1wPVc0+jU9sQf3zpHWj+XUdgmzyT6FPFw34gevR5GPT6zPOC1Rinr/MMToEYQPpGWytKb9rwDkkaFxKOig/4xtDtZSND7VPnx7dTzJBloXaL4kAzePM/EEHjUjpSkNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:11:29PM +0000, Pranjal Shrivastava wrote:
> On Wed, Feb 25, 2026 at 09:56:09AM +0200, Leon Romanovsky wrote:
> > On Wed, Feb 25, 2026 at 10:19:41AM +0530, Ashish Mhetre wrote:
> > > 
> > > 
> > > On 2/25/2026 2:27 AM, Pranjal Shrivastava wrote:
> > > > External email: Use caution opening links or attachments
> > > > 
> > > > 
> > > > On Tue, Feb 24, 2026 at 02:32:21PM +0200, Leon Romanovsky wrote:
> > > > > On Tue, Feb 24, 2026 at 10:42:57AM +0000, Ashish Mhetre wrote:
> > > > > > When mapping scatter-gather entries that reference reserved
> > > > > > memory regions without struct page backing (e.g., bootloader created
> > > > > > carveouts), is_pci_p2pdma_page() dereferences the page pointer
> > > > > > returned by sg_page() without first verifying its validity.
> > > > > I believe this behavior started after commit 88df6ab2f34b
> > > > > ("mm: add folio_is_pci_p2pdma()"). Prior to that change, the
> > > > > is_zone_device_page(page) check would return false when given a
> > > > > non‑existent page pointer.
> > > > > 
> > > 
> > > Thanks Leon for the review. This crash started after commit 30280eee2db1
> > > ("iommu/dma: support PCI P2PDMA pages in dma-iommu map_sg").
> > > 
> > > > Doesn't folio_is_pci_p2pdma() also check for zone device?
> > > > I see[1] that it does:
> > > > 
> > > > static inline bool folio_is_pci_p2pdma(const struct folio *folio)
> > > > {
> > > >          return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > > >                  folio_is_zone_device(folio) &&
> > > >                  folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
> > > > }
> > > > 
> > > > I believe the problem arises due to the page_folio() call in
> > > > folio_is_pci_p2pdma(page_folio(page)); within is_pci_p2pdma_page().
> > > > page_folio() assumes it has a valid struct page to work with. For these
> > > > carveouts, that isn't true.
> > > > 
> > > > Potentially something like the following would stop the crash:
> > > > 
> > > > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > > > index e3c2ccf872a8..e47876021afa 100644
> > > > --- a/include/linux/memremap.h
> > > > +++ b/include/linux/memremap.h
> > > > @@ -197,7 +197,8 @@ static inline void folio_set_zone_device_data(struct folio *folio, void *data)
> > > > 
> > > >   static inline bool is_pci_p2pdma_page(const struct page *page)
> > > >   {
> > > > -       return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > > > +       return IS_ENABLED(CONFIG_PCI_P2PDMA) && page &&
> > > > +               pfn_valid(page_to_pfn(page)) &&
> > > >                  folio_is_pci_p2pdma(page_folio(page));
> > > >   }
> > > > 
> > > 
> > > Yes, this will also fix the crash.
> > > 
> > > > But my broader question is: why are we calling a page-based API like
> > > > is_pci_p2pdma_page() on non-struct-page memory in the first place?
> > > > Could we instead add a helper to verify if the sg_page() return value
> > > > is actually backed by a struct page? If it isn't, we should arguably
> > > > skip the P2PDMA logic entirely and fall back to a dma_map_phys style
> > > > path. Isn't handling these "pageless" physical ranges the primary reason
> > > > dma_map_phys exists?
> > > 
> > > Thanks for the feedback, Pranjal.
> > > 
> > > To clarify: are you suggesting we handle non-page-backed mappings inside
> > > iommu_dma_map_sg (within dma-iommu), or that callers should detect
> > > non-page-backed memory and use dma_map_phys instead of dma_map_sg?
> > 
> > The latter one.
> > 
> 
> Yup, I meant the latter.
> 
> > > Former approach sounds better so that existing iommu_dma_map_sg callers
> > > don't need changes, but I'd like to confirm your preference.
> > 
> > The bug is in callers which used wrong API, they need to be adapted.
> 
> Yes, the thing is, if the caller already knows that the region to be
> mapped is NOT struct page-backed, then why does it use dma_map_sg
> variants?

Before dma_map_phys() was added, there was no reliable way to DMA‑map
such memory, and using dma_map_sg() was a workaround that happened to
work. I'm not sure whether it worked by design or by accident, but the
correct approach now is to use dma_map_phys().

Thanks

> 
> Thanks
> Praan

