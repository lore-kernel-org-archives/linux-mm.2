Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 257FFCA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8059A8E0013; Wed, 17 Sep 2025 06:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD268E0001; Wed, 17 Sep 2025 06:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC9D8E0013; Wed, 17 Sep 2025 06:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 566638E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:52:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEF78C0497
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:52:40 +0000 (UTC)
X-FDA: 83898428880.14.FF2D6E3
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf14.hostedemail.com (Postfix) with ESMTP id EF08410000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:52:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M xSUImw";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BK4HU+yh;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758106359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuT1HrKV0CHpGc0kdRXUpXx/IGQAnMRz3CF881BaPOk=;
	b=F1uEhcRNPowS4xCxocCqrcQeKxgqFiAock2kQ3PkJwMvSq1XA6RPLa5t0PrAbZa7m2ypaD
	mlT/iVre/MOgdp50YV8LLug/B6lbKQDzmjUKLm0Ycn5upZ/sq4giA174UY0dJFZBT0v7K4
	hqzAK6V+qZYvpNDfqkmbMF44RgmTpaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758106359; a=rsa-sha256;
	cv=none;
	b=153p8q3kt0LtcgbPUxrdb/3PKlnPcjgGYoeMsjHjw+Hn9vxvzcUxg0joQX0pD6enf1Gsra
	LoRDstheAhqBcq2OSDD0vdBeoIWGM3KNImUx3XtcbFMPPJRkx5hvlxVD4IsXfc07au6wFZ
	sbtFfaei1fQ5EORVALyXiUENb1dVa1s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M xSUImw";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BK4HU+yh;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 43DBB14001E4;
	Wed, 17 Sep 2025 06:52:38 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 17 Sep 2025 06:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758106358; x=
	1758192758; bh=YuT1HrKV0CHpGc0kdRXUpXx/IGQAnMRz3CF881BaPOk=; b=M
	xSUImwOgerRqD7q0HpqWJb+BsKpsErRDlVA+hznG+y2DZso/dLo8MvRw9y4PFEL2
	RgYd8RbqjLka+CevfiB/uEqDOmG/BRgWYP0fnNFGKl+2xM7WXTwFT793Ohs8INHe
	hfNBkaDSpfs38T6v5W9i9J4GeZ5YF8wJjcCq4ad4lrUOk2rt9uXX781nc5ZwuVN9
	LOuIHyp/Af9tKa6d9EyS1EyOUyRl5A/3am+fwsgtZCE4ccyTOQwIZXezKt+pSq/b
	UQ+chYUPaxVI3phR2Zid0f6kPlFcafGAb+2/NHtvx0ZsCjmmpvxcT6Kia9u/2/hg
	drOIKKdAYjP8JP08yW4Kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758106358; x=1758192758; bh=YuT1HrKV0CHpGc0kdRXUpXx/IGQAnMRz3CF
	881BaPOk=; b=BK4HU+yhkUtEByUJVOss8GPApInhcClbyBm5ild0hLIvAZoD0wW
	FRaJUyyTuc7n7roqyzfQy2bL0P1O3zYt2E7g46rtbMe97/fjoHTrqKpkEjQCWept
	BZE0Z1yhmfa6YvRGGTe65eTKcgiwq2LTuhYRuqr+f5IeUm+EKeDV3Mrq4hUafvTA
	9c5qKg8r+mvJ7Rwp+IyKwKDsEBl/Nx9vYlIIpgutXyQnOifJ86I0ijVlUfgqji9R
	6ZbQrNSrnsVgMFyNwCtmXC2S7H6URky6NCMYMaZhy4N15zYkwIXGmNLfONFYEkM/
	GCJJMtJMH5q3llAHlXgZfXj6qzCept0wzXA==
X-ME-Sender: <xms:9JLKaB-24Pd6ExhgxTc3fgErBlQKNXCfF49C2wryNbNiQQk-Oq8E6A>
    <xme:9JLKaBNsuYu39MJDlVv3PT_Rhkd7HhaKkxgCgCp3tqlj2zRZlS9GE1EhzV2SixWgP
    Qy8j7dn3Vz9xh3_7B0>
X-ME-Received: <xmr:9JLKaFDNQBgj-9Pv7rZaQ9Bl427XnCnRPalym7hxh2urzEl5w4WByFLqh0PpCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegfedvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeiiohhkvggvfhgvsehgohhoghhlvg
    drtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepiihi
    hiesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsggrohhlihhnrdifrghngheslhhinh
    hugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthes
    ohhrrggtlhgvrdgtohhmpdhrtghpthhtohepnhhprggthhgvsehrvgguhhgrthdrtghomh
    dprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomh
X-ME-Proxy: <xmx:9JLKaDMgVWjjHMj4ydXii4HjOLe6Mgyd_Ud90lUiTActOCsxhhyeuw>
    <xmx:9JLKaLbNCiNKsbuHCI3PnAVAUQfT3Sp4_nx9zUNJJjk1czNxI7Hy9g>
    <xmx:9JLKaCPWgzZtZtcRuuzctIYMOk8oJRAPfdnCw7Fb7nsG8k2UQXb4-A>
    <xmx:9JLKaJU3DtUdU5tO6_-cm80Fi49QE8FCoNEFUcY7YBRe6Zh6l-Vbqw>
    <xmx:9pLKaBLufn2pT4kQCyiLZfHX8hqjNJbkw2nzuXoxw-tHqK9xGEEO3Xcy>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Sep 2025 06:52:36 -0400 (EDT)
Date: Wed, 17 Sep 2025 11:52:34 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zach O'Keefe <zokeefe@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp()
 on SCAN_PMD_NULL
Message-ID: <j5pf6l745hp4r56fndlshzcjpyi3nttgywouowhmfiewx6p56j@b64l6tmupykt>
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
 <ecac1e7f-1709-4348-b8ff-fa1c0f087548@lucifer.local>
 <CAAa6QmRaiKB2OOpZYjRx3EAQ+d8_G=MsVmV=9cc_MmHOYsikow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAa6QmRaiKB2OOpZYjRx3EAQ+d8_G=MsVmV=9cc_MmHOYsikow@mail.gmail.com>
X-Rspamd-Queue-Id: EF08410000B
X-Stat-Signature: 39hyb1i3qq6jnd5gkrg3z8o1qb3azfhe
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758106358-843157
X-HE-Meta: U2FsdGVkX18olAvfmDWA+J2rgJWHGXOR3Gv4kRgDaajeY3xY8J9QCYnuOi/dd5UAIqaNbkI7qxCFAB+SMyzv2nW87JA0PG5/YHegXyVNFUyAVD0oAjYOsmsuYOWdTJvCxwbOFsWH+0wwBGjtHva6Tszks98QvJcN+/vg9hlRi1K0uCMryIbbuLG/3aFoDlWSyswN2VLjQH4G02YvSnQknQc1oSddlaRASnMmCkf/iQ+UsVMNbUHN77i2lDmfBDimkHvJ6b4jWZ8zMYcyjDKwFmIXjpeMeoZQOmbafeJts9O8cHcXUow2Bozkl+8YeMBt1g3jzpaOqnf168opG1xkpGFAdsY3tcetYKoX+euhzjBuoTTFAIWpnjZdCWzmKjTUi61NcSSKg5c5wRL+lSs7x6pdFSlnpqYwV0zh3A8eqDI1zdilLeHyzhm4Mr2wUVJe1EHhV/OQzpu6LB60v24L5OYUJrc7mwhpbWpihDa5qxa+C8tLPMJ4hfFwFifVenVHt/kwuJ/5VlgSeqIIK1Hu3SNcvrjgsZUH/GYoPlqvXd5g/52XOkJKLjZkzXuAS3NSE+0isoaehVWLsu7SGxS7J5CYzKkAqHG+KwfOKRVB67s6PH8M/bZCV2UQ6ar9e4YcOi5ZqnvJxzd0JJMOxiANv8g+DiZ/+CUyCqsckq786NFNC8KC51rNHqPDNhFkxR+nkrDe0gnX13FWuHtojwR+nA3A8W6hlxnbbiWxMLMYCmOmYI0KonBZlNhxZUPkir9MVodYJnUTK1sfW/cdsmQqdHsYwamB+Fgup4vZHLk+1cWxTC/eq+3IsTFXYXiadl0Yg+2QXYfrN4NJ5dwfkbAhYFKuPRqEG+wS9ZCpLHObQR+D+Ot60cG9H1Cxcf4F50cbzlpiURmLhy7w1k1G+Mg8TOzIlhGW68UHmw6Fhed6ODIcZQ9lQ/NTplKVQPl2u/PoHrmVbewNWxEbyUIYH+0
 fkprv8mY
 eIaBQoPsNuroWWDvwVw2FnvmwneqldcJOCdchdvlRb/ymsIlBBmwwo7+4rdPDQ2Z8MNbf1Mfnypd1SxunlbX4zXNbnGcGbT61OoJZijnYbQQs6s08aKGIPv23YETaIqq6sTuVj/exHhCNIqnYnAKlx6mWyMmHjBz1VhOO7xeR8c3qmVgRDTrVvEmAW2YqvUQ0a0JwbmaJrM2ceMq+296Agmw36MrEFWCmlRkOlZDaQF9wlkrpiUGHv82Ctsmr7vGBJ3STaY+wSASxm/mRFVQlVl/u9tc/VOx9pnCnWx/qiBpb7GOLuaYUmHVKUIiaR+0IOV8GgQatAcdF3DEJzstv7C2Xj1m0RONrS7otK/PcdTM0i+vpPT5AN1/byUdSJkt1BiexPRqDdn4+ms3lhXcq67NwyXrkQ8Zv34mw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:06:30AM -0700, Zach O'Keefe wrote:
> So, since we are trying to aim for consistency here, I think we ought
> to also support the anonymous case.
> 
> I don't have a patch, but can spot at least two things we'd need to adjust:
> 
> First, we are defeated by the check in __thp_vma_allowable_orders();
> 
>         /*
>          * THPeligible bit of smaps should show 1 for proper VMAs even
>          * though anon_vma is not initialized yet.
>          *
>          * Allow page fault since anon_vma may be not initialized until
>          * the first page fault.
>          */
>         if (!vma->anon_vma)
>                 return (smaps || in_pf) ? orders : 0;
> 
> I think we can probably just delete that check, but would need to confirm.

Do you want MADV_COLLAPSE to work on VMAs that never got a page fault?

I think it should be fine as long as we agree that MADV_COLLAPSE implies
memory population. I think it should, but I want to be sure we are on
the same page.

I also brings a question on holes in the files on MADV_COLLAPSE. We
might want to populate them too. But it means the logic between
MADV_COLLAPSE and khugepaged will diverge. It requires larger
refactoring.

> And second, madvise_collapse() doesn't route SCAN_PMD_NULL to
> collapse_pte_mapped_thp(). I think we just need to audit places where
> we return this code, to make sure it's faithfully describing a
> situation where we can go ahead and install a new pmd. As a hasty
> check, the return codes in check_pmd_state() don't look to follow
> that, with !present and pmd_bad() returning SCAN_PMD_NULL. Likewise,
> there are many underlying failure reasons for
> pte_offset_map_ro_nolock()=>___pte_offset_map() that aren't "no PMD
> entry".

Sounds like a plan :)

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

