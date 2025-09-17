Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791EACA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F0A8E000A; Wed, 17 Sep 2025 06:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46E78E0001; Wed, 17 Sep 2025 06:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C848E000A; Wed, 17 Sep 2025 06:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B36118E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:43:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69CBD1404EA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:43:16 +0000 (UTC)
X-FDA: 83898405192.20.C553BBB
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf14.hostedemail.com (Postfix) with ESMTP id 375F7100008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:43:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="h Fl85Ne";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JdN24G+t;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758105793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74X70xzEhBM0tW2lzuA0ESFpEqnjRQx9KPWr7O/CNbQ=;
	b=x4GLmXR+6v7CLZeZnsZEF3WnLF1M7eTU1eLpWUwhBN2HalCOuFKBE6JAvwBs2bPC+7iYhj
	vcm2+qOgCVeRfUyVTrL8csxSAZWXN9C72m5I90VjmPYWIV68Dn5miW9w89Le0/rGAfwxz4
	O8qNo6Jj8kNuTmkHdq7PnlvCmRkHk/M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="h Fl85Ne";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JdN24G+t;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758105793; a=rsa-sha256;
	cv=none;
	b=8YGjb8BkuCKQkAPavN8CpvEAOioNWPKSdSSnE0BN+MO2zFpU1LxjlnHw7NqgyMkipUONND
	dKuvNleSM1NfcSfuWYpZZR7QaDCuQLxy02y0mVvGAOZxvODaE0wuOs+VyEZe7GziBq/5qX
	RI24t8r9uiYTWdVW8KwiNS5Kn9xJxh8=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7F16C14001DE;
	Wed, 17 Sep 2025 06:43:12 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 17 Sep 2025 06:43:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758105792; x=
	1758192192; bh=74X70xzEhBM0tW2lzuA0ESFpEqnjRQx9KPWr7O/CNbQ=; b=h
	Fl85Ne2Dxf0+e1Zeyn7iSeFwbs1zURwloVh9+uV8sDF5i1ken+c3N4OhSMEE4fQg
	Rk73PcExtwPGu218/Bbyf4cmiYoD18pMdXqedlDABkGssmJ25oAEZutDusHh3cd3
	E70xlH9tnyS/RfTocqX1vNRl1qyvU+Yo/0o6ln4GwEZLstIPDTO2pavC5/kusANU
	xmRNJIutJ5xqpqXfENe6L+5llIO1dQfXBUQS+iPBiBeW83Q24RZ3sTWP6iHBWGDg
	Q4Z9fIv2mOejCKC3w7mjmAQnk5b8voSGGciJRpicNECWi/sgrtmHOsKNZkLuqS68
	29uBu41oNwNM7SHHE9kVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758105792; x=1758192192; bh=74X70xzEhBM0tW2lzuA0ESFpEqnjRQx9KPW
	r7O/CNbQ=; b=JdN24G+t3tAtKEaF3xy9/usv8GaFHeYOqrUsOtCLEG6H2AVjKO/
	z/ppztjGiIb2oTuLYhiWs+2ju8J1UsnTxCuiQbv9++JILxhJT7qoqX4OvGRKdCb5
	Y/x5WMYXYfptlZ4UZqJZmavoaPQUTghqltZ1eJ7Z05RxKczDbWUmy+O2UmTscZf/
	cemk+T/thmz/ZDwEygZ0gVZSVF9fWeC42+dv7O02TIlE7m5xdGmNmGuLP0AumUJu
	zI8cie3GJqgZ8AZ4daWsLEjU70a6WzrXYPOypYn8SScKkXCmbzhHw6Hu7VVFoWyS
	BFHPfaAgeYkkDxZQDF6SqlFVAC0zNDvbyRQ==
X-ME-Sender: <xms:v5DKaBRX0yS8FD8qt-AC-V9tRJXQSOqPMmBBXmawkd6AGirEwgFPOw>
    <xme:v5DKaGpLZXUvscnwH8ZoLoYQu60UwnreKcKWMpLjuSyhpIZUoznDQP5YKSEwe0M2I
    2plbZmz-0lK9T1uQCA>
X-ME-Received: <xmr:v5DKaPpoduEQ_2ZSaPZQhsv35CIYWOQYDw7kUpOzkkw_8FNKShG1wLRys9Qjjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegfedvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlohhrvghniihordhsthhorghkvg
    hssehorhgrtghlvgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhn
    uggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpd
    hrtghpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsggrohhlihhn
    rdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopehlihgrmh
    drhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepnhhprggthhgvsehr
    vgguhhgrthdrtghomhdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtg
    homhdprhgtphhtthhopeguvghvrdhjrghinhesrghrmhdrtghomh
X-ME-Proxy: <xmx:v5DKaB2h-8I5FINeZ6DBBIlYuR_mhdfk2nOhP7ciKrwWZxmBlZRgdw>
    <xmx:v5DKaDi56MNn6yD1nQTgCCscQozH7ovo2yNCKXIqJT2yUCfn6qO_Dw>
    <xmx:v5DKaAlTECDEQqK1XmSv90WalG12KPOQqFTlbRQzWHt-_cfNQyqAvA>
    <xmx:v5DKaL-fewQ-QpdswZuFxLosxSXD-E6n6etTZSaSiz37hzJuDd1vog>
    <xmx:wJDKaDk6zs0RS8-cvQBQ7seUyblylVYSAniu0Q5CbRWqR30Q8LGNwC2i>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Sep 2025 06:43:10 -0400 (EDT)
Date: Wed, 17 Sep 2025 11:43:08 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp()
 on SCAN_PMD_NULL
Message-ID: <l6yjv4b2xvcwgpq5q3esyat56jdfj7flcokbqptsxlzgesrwe2@sxxzcp477ldi>
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
 <ecac1e7f-1709-4348-b8ff-fa1c0f087548@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecac1e7f-1709-4348-b8ff-fa1c0f087548@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 375F7100008
X-Stat-Signature: uqrsw7aczu7ahgq9qdb51ino6t31e85i
X-HE-Tag: 1758105793-643431
X-HE-Meta: U2FsdGVkX1/7nDqBXtO0iTv/rATXLjjdP5r77cEMbVxQu//MX0xQFu5AiZ3LlKroY3Mtr+f0tCarm/K7HzD4nVkO31enBJOUI2jENfd9LeR2iEtN5Ib8iuHtLQhzlz5cfPDDhDDlbuX4X2XILK8uSF2NFFT2v4Z+RKArLJZlr2gExX7srhUdwvFwZn1dGjqiSFHr3YNlfAWy6R2Rp795dk5HMU5pj096/1r9tnrc6DMnvIW5LA/V7Ek5f3dIP6mGwtHTaCIVV5qvl0rlUuru2ihPZgz3YFseY5lTG3Vpe6vyhhR1g8wy1rs3hruMnTckZepHRmh+35lkZVFqZIAYi2yfVDnpZPcBz6apAUumb/Ut6XB3lGZzvcmkHHgEpwotZGEKpLXmIBGfSD78NaUCGYI3ndn8Yd1+r8ZFMohj+O1xLj9Yo9a0OdRqPeB3hxGn+zp/8MWQ1k8ddifHV6vwGalutN9T634vHIIAgDMIh/i5MRwtKKk1+67swxvcq9lYdrIQDUIZ590adoE2kztFxmk3VSDV2O7O8ilC2cFD3ZQS7yk5WU14gjvuXcajU/jtyEoTVavgfJ0l2DQtUFlBRuQ2ncG4TrZ1mvZ+dYANahMptmU5I70RLiF1Kf0xBzEAZiYrfBKpscVYYn+PZkBdeG4WWwXR59oMc471UWsHthrIE3lI/EksoaUj9A2DFAEIdm9w7gd9Fq5cXmuQTyRzrOcf1Ik0RR+Pm85Doal3il4Otm89s31+naUBiI9qjfneOucZwi2QaSvNZMEsnSsg8yiOOHfbGcLdq/GJshypMudBBR2IOYBRgQAO7HZSoEyyrwteEBp5eZOhXOXTOQ+22oLOjCy35BpID7AGKNwyUR1/wIe42qgNgOfGtDnlQO48W535ERkUc0ItHAO8a0h07yXJ+t9RkwP2RZAa2pLeq80LCfsPVB6FBfFUr021UA7O6MWN+RklUkeDgF1Q1qc
 fvcQxld+
 GVdDM95IMY3EWlv95idPZW09hDNo4ALpYNHEbr9B2fpaN481x13nNDZl1Px7pM9YMmEe2QjoARQYsJqLG24Io887PBEU9XvUw90fttkSn/phoH4V5O0ZFVIkYMmbzxbRAGLxDHfln/OhHdsYEzMC4RVUX3cDF64HxRHSR3XKtIxiupwrCfmmYyXwcjL9/FTGcv8CSSr2mRcTQpCT0kTFetY2STVmBMUNFk0IApjY1SRx4HH8QTgrtovk6T7t8qVqGrKg3d28FIcCtNHJnFdkVDxzgw9uSlKtkIXJWdwkCO+FQ8IdzeGTIzMDWSHcac9gBajzMd5MAkikIEHe3LOSwNp6sV2Wt3RCMpttBd8PeavQcSbkKZRkTX5IvqTaAJawiF2dWFUCXxOxnSYGrYIcmIsZ68R3gUbj1zAwjo9qxD9gmYrQImczKHSsMwnKpN1vA+7roIcxyrkTFWagYgvPigQvk1DYmWwnREX8dbIpRD5BBMGt7j0GhcPOTDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:54:12AM +0100, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 02:52:53PM +0100, Kiryl Shutsemau wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> >
> > MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> > PMD page table is installed or not.
> >
> > Consider following example:
> >
> > 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> > 		 MAP_SHARED, fd, 0);
> > 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
> >
> > fd is a populated tmpfs file.
> >
> > The result depends on the address that the kernel returns on mmap().
> > If it is located in an existing PMD table, the madvise() will succeed.
> > However, if the table does not exist, it will fail with -EINVAL.
> >
> > This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> > a page table is missing, which causes collapse_pte_mapped_thp() to fail.
> >
> > SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> > collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> > tables as needed.
> >
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> 
> There was a v1 with tags, you've not propagated any of them? Did you feel
> the change was enough to remove them?

I moved code around and was not comfortable to carry tags over.

> Anyway, LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> > ---
> >
> > v2:
> >  - Modify set_huge_pmd() instead of introducing install_huge_pmd();
> >
> > ---
> >  mm/khugepaged.c | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b486c1d19b2d..986718599355 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1472,15 +1472,32 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
> >  static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
> >  			pmd_t *pmdp, struct folio *folio, struct page *page)
> >  {
> > +	struct mm_struct *mm = vma->vm_mm;
> >  	struct vm_fault vmf = {
> >  		.vma = vma,
> >  		.address = addr,
> >  		.flags = 0,
> > -		.pmd = pmdp,
> >  	};
> > +	pgd_t *pgdp;
> > +	p4d_t *p4dp;
> > +	pud_t *pudp;
> >
> >  	mmap_assert_locked(vma->vm_mm);
> 
> NIT: you have mm as a local var should use here too. Not a big deal though
> obviously...

Do you want v3 for this?

> >
> > +	if (!pmdp) {
> > +		pgdp = pgd_offset(mm, addr);
> > +		p4dp = p4d_alloc(mm, pgdp, addr);
> > +		if (!p4dp)
> > +			return SCAN_FAIL;
> > +		pudp = pud_alloc(mm, p4dp, addr);
> > +		if (!pudp)
> > +			return SCAN_FAIL;
> > +		pmdp = pmd_alloc(mm, pudp, addr);
> > +		if (!pmdp)
> > +			return SCAN_FAIL;
> > +	}
> > +
> > +	vmf.pmd = pmdp;
> >  	if (do_set_pmd(&vmf, folio, page))
> >  		return SCAN_FAIL;
> >
> > @@ -1556,6 +1573,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> >  	switch (result) {
> >  	case SCAN_SUCCEED:
> >  		break;
> > +	case SCAN_PMD_NULL:
> >  	case SCAN_PMD_NONE:
> >  		/*
> >  		 * All pte entries have been removed and pmd cleared.
> > --
> > 2.50.1
> >

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

