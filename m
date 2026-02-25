Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BAEBEFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7CB6B00CA; Wed, 25 Feb 2026 02:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93456B00CC; Wed, 25 Feb 2026 02:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C5E6B00CD; Wed, 25 Feb 2026 02:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A46756B00CA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:56:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 637168B749
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:15 +0000 (UTC)
X-FDA: 84482221110.30.7782393
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B82F7140007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jfqiLdX+;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1e/WslVpKxNq+OO+cYj8QXbC11DYZb5ICkCTqzPgH2E=;
	b=dGPs/baHkbOBALSdNySp/BAAt9MzqyBCXcyHTEJ6KEDiD4N+Fm5FyJ2EtR48nSRSpS+qOt
	cq8VAbfTHnHkjQ0QQp9vD7JqQgZnK2UihY+uRCkaEqPc7Zgow/MKhEgdnrpFYaXlLdiuDs
	1gDaxkPoNVAbFEljkiQPkuOtRwwhG3U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jfqiLdX+;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006173; a=rsa-sha256;
	cv=none;
	b=q4Zfx4Rxn0672GS+Cyl9xeZP8IlrrKdcNxRPISTPhE5d9XoJlqI+e7EqO7kQ94tsimdsip
	pfEENh9bOn7AH2eQbFkp/LChwoVDYXS4RIRrHR1eK3KIEEijFyIzqz2geUK2wAiaKKBtTa
	kKLwUdAVejim3MGW6DyXIs41+M3rFLE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EDE8D60097;
	Wed, 25 Feb 2026 07:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F4DC4AF09;
	Wed, 25 Feb 2026 07:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772006172;
	bh=JqFR4U/I4MB+SKLFl9OdO6R2LAzf+H3aHpw6oWSGOSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jfqiLdX+BCpABsbWe3Of/Ix1OstPBdj3NaP2fSQoptwGjcCv92DCb4bZNJpkWAbrB
	 GdByBXHvlt3lsF9GnscNYZmYGViRi1UTL+6MJaoTUsTeJxpK8yhXYZda4si1PIf01f
	 +gq6VibJdxGU0azGnJCqmiVSPtMEsb5IvgV8MU4zat+Ee+UiSb+CbRHa2UdsUlJBPG
	 pe5CLE1sb1k0PpDsH54Y+4AIOLN9cPnBlI//Q8vkZ+PTvIulR7AERM4leQLrQG3D7r
	 gfJQXnBOK/9bVEuzILpbV4uyPiS9uue5gLCuKIJmJAdJs0tx0mBcWDe/J/wqh9moMy
	 zIQ3VRCVdJqww==
Date: Wed, 25 Feb 2026 09:56:09 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Ashish Mhetre <amhetre@nvidia.com>
Cc: Pranjal Shrivastava <praan@google.com>, robin.murphy@arm.com,
	joro@8bytes.org, will@kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] iommu/dma: Validate page before accessing P2PDMA
 state
Message-ID: <20260225075609.GB9541@unreal>
References: <20260224104257.1641429-1-amhetre@nvidia.com>
 <20260224123221.GM10607@unreal>
 <aZ4Q1HA9q1ojsVYY@google.com>
 <9d01b4e3-be5b-4c9c-8088-1d10f67f1fd8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d01b4e3-be5b-4c9c-8088-1d10f67f1fd8@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B82F7140007
X-Stat-Signature: j8z9tqwctrf9i93m9xf3a3wrtxzgptpw
X-Rspam-User: 
X-HE-Tag: 1772006173-347958
X-HE-Meta: U2FsdGVkX1+M2m97R3uTOUIG8DYw8Atjuq4wmhWkSHoM7ZyLKyXt1G5Exr7AONFxMR+4psbnYv5e3rBCD4fsAvKYBKGr1BECGVef2kTMCwr2/jDc33T4WE/KCNqceraXUtb4tpfx70qvS/mlHJzjgon/rchxBRfBDbFvIifZbDs4/eH+2OBcVOsRaYtQaSTqXO+uRhU1VPLYiIOLoxmbLOpyyJiJm4oC89WQWrDKcblbbzeLH/OiaJshQSbrEnkoqrIcMcBrnOLjKIlUAhQgUBarwZ6vGI1HA/TOFqXrD3CADuujlaErrbSZlBizyA4QA6J5BmW5IlwfjgahxOul0S9kmNeApop3N56QNcXLdpVVvUMrjWRCeJL/7ehxAB2HRxwGDaEEGhWcS0ilqiUpB+F9mzbRZAoI6QHvEMSSBS1lR3eiK1356nAp26QoLI2q5vO2HXK1vChlg47MWttVXGlpUgjAn00rfezvIeLqey1nID3ypY3eit+zSAz28oXjRTO5DVtcAygb+iXh74jiOsaXHggzjbtCqFx4lLeiqUe5FLj/my9PR08lfqUdKjTBf/OVVR+MTtD3REB5t3N8AKTzpcifnWO9QuExJMGULEBKEf1U9oMMQfsq0wUQlSpL2AgGJ0ujezyTydTk2Drs/Ng/IWExFZMaG5GlEAA1CDtgUeakZJyXH1fTUSVvBQma35TJwlxZlA8dam5IcL+38UZP0v0Yeptong84sW8vKWOuXyuyR4Cuj/HeAdrw0Y2WvdMUll68lvwj8ZFCSpwKz6hRCLmi43Sc+qTacuXkx258NfbsCMRka9+eCEMEqXjDsNirnjXuxWeaqPA6qaG2d2DfepdnWlksL7LefgjStDk8SHaDJ+0uuhCD/19aKId0Te7SYzOF96SndEGsQBMdA9hHvgMgrRhBWxCOPyAUMbiNEz279XH+5KAh4PkDVIxAxTHgyQfuM4047d+kXI0
 0sV5h4B5
 OMsKV5GzyPU2ZzrcKyRy1y0OiE+OlVrqNw5ob2iIm+Y4HW6BcvUbWrMrqn0oRW1Paagnv8TfXIK9GrF1QQiMHvFRSIr3NRThyAb0wR1ZYhScbI5xdpcLElJhvrq8gk35So00mzdUcry8ajIVGKSl8wLFkfaXrgOVFLbLiEbH7OmXmfPxweGqGowMUH1y4caCh47Siro/6bJOE7q96SD6ysXZAbl+0i3ZVRxGUTIo2WI2dc+tAIFpLGgU0ax+ySS2Uojv3u0lUJDViQX+xyQyqczUxKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 10:19:41AM +0530, Ashish Mhetre wrote:
> 
> 
> On 2/25/2026 2:27 AM, Pranjal Shrivastava wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Tue, Feb 24, 2026 at 02:32:21PM +0200, Leon Romanovsky wrote:
> > > On Tue, Feb 24, 2026 at 10:42:57AM +0000, Ashish Mhetre wrote:
> > > > When mapping scatter-gather entries that reference reserved
> > > > memory regions without struct page backing (e.g., bootloader created
> > > > carveouts), is_pci_p2pdma_page() dereferences the page pointer
> > > > returned by sg_page() without first verifying its validity.
> > > I believe this behavior started after commit 88df6ab2f34b
> > > ("mm: add folio_is_pci_p2pdma()"). Prior to that change, the
> > > is_zone_device_page(page) check would return false when given a
> > > non‑existent page pointer.
> > > 
> 
> Thanks Leon for the review. This crash started after commit 30280eee2db1
> ("iommu/dma: support PCI P2PDMA pages in dma-iommu map_sg").
> 
> > Doesn't folio_is_pci_p2pdma() also check for zone device?
> > I see[1] that it does:
> > 
> > static inline bool folio_is_pci_p2pdma(const struct folio *folio)
> > {
> >          return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> >                  folio_is_zone_device(folio) &&
> >                  folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
> > }
> > 
> > I believe the problem arises due to the page_folio() call in
> > folio_is_pci_p2pdma(page_folio(page)); within is_pci_p2pdma_page().
> > page_folio() assumes it has a valid struct page to work with. For these
> > carveouts, that isn't true.
> > 
> > Potentially something like the following would stop the crash:
> > 
> > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > index e3c2ccf872a8..e47876021afa 100644
> > --- a/include/linux/memremap.h
> > +++ b/include/linux/memremap.h
> > @@ -197,7 +197,8 @@ static inline void folio_set_zone_device_data(struct folio *folio, void *data)
> > 
> >   static inline bool is_pci_p2pdma_page(const struct page *page)
> >   {
> > -       return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
> > +       return IS_ENABLED(CONFIG_PCI_P2PDMA) && page &&
> > +               pfn_valid(page_to_pfn(page)) &&
> >                  folio_is_pci_p2pdma(page_folio(page));
> >   }
> > 
> 
> Yes, this will also fix the crash.
> 
> > But my broader question is: why are we calling a page-based API like
> > is_pci_p2pdma_page() on non-struct-page memory in the first place?
> > Could we instead add a helper to verify if the sg_page() return value
> > is actually backed by a struct page? If it isn't, we should arguably
> > skip the P2PDMA logic entirely and fall back to a dma_map_phys style
> > path. Isn't handling these "pageless" physical ranges the primary reason
> > dma_map_phys exists?
> 
> Thanks for the feedback, Pranjal.
> 
> To clarify: are you suggesting we handle non-page-backed mappings inside
> iommu_dma_map_sg (within dma-iommu), or that callers should detect
> non-page-backed memory and use dma_map_phys instead of dma_map_sg?

The latter one.

> Former approach sounds better so that existing iommu_dma_map_sg callers
> don't need changes, but I'd like to confirm your preference.

The bug is in callers which used wrong API, they need to be adapted.

Thanks

