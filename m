Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4C6CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 13:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8E76B0164; Fri,  8 May 2026 09:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9EC6B0165; Fri,  8 May 2026 09:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF7B6B0166; Fri,  8 May 2026 09:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9196B0164
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:12:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0FB98DC22
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:12:07 +0000 (UTC)
X-FDA: 84744290694.14.220F929
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EE1820017
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:12:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CcNRnVik;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778245926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGwiUS5DJrEa1LnDEk+8NFByDIbwPsr2Uv1gGmLQjAs=;
	b=pA+UUflHoiml4KsGKGPnCEAavdgyjMCZJX1WG8wm/DMXFhj8DJ20D04MY92fimGL/uW8mT
	X6WxQR4S4JDecQFp04VW987r2/V5Mv38EohMYnqCvTXsKfJ+V9a0hJsHEyUZspRYMjlAzN
	BaUwTh5RQsnWM8CgPbjEVRCJcQ+7+Vg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CcNRnVik;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778245926; a=rsa-sha256;
	cv=none;
	b=KP534JTTKp/5z8Bo3X//DNW6Zai1B5uQJgkA4OFddmHSRfxSti0T/mMo05pO1achCuY5gD
	gk/i0dWG2RheVufKogjUpPk5kLKJDWksvqR0G7/OmxwtH3zxHBFMjKC+27KniVNHyhSBJV
	u1X1YeIB0X33RFhPrFgOPTjffXQP4cU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9B80418FF;
	Fri,  8 May 2026 13:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C8DC2BCB0;
	Fri,  8 May 2026 13:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778245924;
	bh=FYfQBWXoI2SOwhI3/+KF/bHfaoZ7TvjdrPVMKD3eI6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CcNRnVik7tStztA4YNvBkXhij8kBGCaTiuoqXL5vpPQLQ3oz/7w9AfrUle8OLzVdE
	 +p97tmYpulnTlzPcEmoYp9+HOL2NO7Vv/ZhwWSmOBrXfAajIIlRyXnnCEKzkq7oh7d
	 Xx1krynH20WqQkWtRHs338KuNlNggCMeBxN3eZlMlN6GHen807Ui9whzWsHBEE4ZrJ
	 C1PlYhaeXKQw44rz7QY86dvusS+T/a5e5VHyBFxWMxkrFqJPGiw2SToxB0LTTJx6uf
	 FK0OvmKE1E4OM83oIjD194EGWYwcsQvOy+k1oAEmQLMEo/fSE+za5KVymMZdI1wXyU
	 Pbr/+CPBEQT+w==
Date: Fri, 8 May 2026 14:12:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <af3gUBSl4UQ6NfVp@lucifer>
References: <cover.1778192416.git.mst@redhat.com>
 <96a2f5a938bf65315ac95e75b4e7741bae018cdd.1778192416.git.mst@redhat.com>
 <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1EE1820017
X-Rspam-User: 
X-Stat-Signature: 9ps96rupdzxa714uynxnz31acy9ypsed
X-HE-Tag: 1778245925-317598
X-HE-Meta: U2FsdGVkX19Ru3rpaVykQasCESlvIZe1bh63cAhAtlHIFUVdw/d0JLxuoeSkO8u1ne+u1Gd7s16sqXTbcA5k3vcr5AXPiZZA8mDRnBWbqZ4pxjc4VlBkVJor0irgYwcri93d2GUxl8LbMkZ68A14fhnhQqdiYLnnGO16qCYDICLT2P9SpW7QV5/a/ofnHCZJTpkuSRFPPqDKJqwzuHl6tXNpc9nmsKySn5YVlSB1kjaBAdMukltlwZBwU27zlBybiiKcFyvBkSk+HFI4P0EvEKukVhtUm7+ThB4H+qXBD7BhPirPNH8CuLECnUcsi+2ywep5kwx+ivdlLwkbEXOzLBmrfFuLi48tjKM1EUloW82XBA0I+TFhlBN/qte5ffaohKu4jkhaJlIeK4RSD9no/9iihx6PszRagNk0kZG1kQxC5y9IWyxIwrYUuFpFjher5PPfKlpRvWDK64p/VdneQQmaXoPBm9PdTaGiChnjx7TMr4bfW3AOoEE6COV5TK17r2Gei4KPh3DTGX64zwyJSP15tD1nPMQqP/j9pCYJpEgUnpVNvcYAUbf5P9FF+rdbfuqdyh9vYXpL/X/crY8QCDnoolGiUF/yo5R7HpOZFax8pbZ33bRmlpZvDSlV4Bipn3qQ6BuGcoJ0dxRtlgUFkB5M0Sr001nGt4I+eQOOjyHqB8mVM8EN0z72BzcM0fXVsHhAqCggUi9tq6fc3DcQ0CxN20nUy3/vW+kSaUYYN+M0sma4M8AC88CsR0aty3+A78aik9x2if3ouknruIKS5f/01LQyQ0JOg8GRdd3dymB7KdC+UyDULvU2Y39wab/s7oM6RQk9bMVHZtcJoDHyECldzFmejgVed3UMAaysj6Ydwy2OtwinTvENktN7m59CMl1TpW6QwrpdlaIC+NgZvKWGz5nS/xLMpYm1TfQNFkx431RXMciJP7d3WwDyLd4Z3A/2Cl777SXSqCHaTXl
 vcOAaIbA
 8OxBmzTKE0NwBff04WCH6q7QsZIap4dtkJMf0OFCqxluZpZhkFgvKV6DELyeB4ndlPXUKrbBSG+pGn5tWiBf0YaXNMAfhSEn0iS8I1NfmsUN6U83EZwPr7THjT4vT3CITj9AmQl/G1vE7OvAKzA+jOy4FTLdA1jdfGeK0FTltC/R066qXVw8MyI6cvGTRXxTROfRG+Ukdg3bZ1EigTYMLUFdU4MV5p9AHM/mxNm5NtjenOzoWYx9lMWm0cUpIxoijR/YqNF7+uO+XB0DdmB46W/BfWDaSUCvrSVNVULiJOBM4jWzVqSbEcm9hdK4E6CZfcDLr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc incorect email addresses

On Fri, May 08, 2026 at 09:06:22AM +0530, Dev Jain wrote:
>
>
> On 08/05/26 3:52 am, Michael S. Tsirkin wrote:
> > Now that vma_alloc_folio aligns the address internally, drop the
> > redundant HPAGE_PMD_MASK alignment at the callsite.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
>
> Hello Michael,
>
> Could you please send the whole patchset or at least the cover letter
> too, to everyone CCed on at least one patch? I only got two patches
> from the patchset in my inbox so I have no context :)

Please resend this with the right people cc'd on everything.

You're using an out of date email address for me and Liam (at the very least), I
mark all mail that ends up at the old address read without touching it, so saw
this by chance only.

It's been a couple of months now (predates this cycle) so I'm getting a little
less patient about it, people do change their email often enough that it's
something you should really be on top of for a non-RFC series especially.

I co-maintain THP so would prefer to see this in context please.

Thanks!

>
> >  mm/huge_memory.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 8e2746ea74ad..f51c0841ce91 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1260,7 +1260,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
> >  	const int order = HPAGE_PMD_ORDER;
> >  	struct folio *folio;
> >
> > -	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
> > +	folio = vma_alloc_folio(gfp, order, vma, addr);
> >
> >  	if (unlikely(!folio)) {
> >  		count_vm_event(THP_FAULT_FALLBACK);
>

