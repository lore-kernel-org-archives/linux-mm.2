Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42EE9C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B086B0206; Wed, 12 Aug 2026 09:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB916B0207; Wed, 12 Aug 2026 09:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA2C6B0208; Wed, 12 Aug 2026 09:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC8A26B0206
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:02:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BD03A0362
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:02:38 +0000 (UTC)
X-FDA: 85092631596.19.99C78B3
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id 66AD5140015
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:02:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=HgJdg8uu;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=none) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786539756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3afadaQWMy7CXc8uhs8r6Sfs6URxGbACL7mqS2X/ou8=;
	b=zY5uqaTL5caHBzJax7M/1/fPLJqzPUviVLFOWXcWTQ96OLmWuUiFylvoW5PGmAMKyzaySi
	UeS/dW6ZraXDincJbPngrOZeS56J5qhYbPFXq1BLECrQeXU8VpwndSV2URAqhMTVh7qXQW
	VCuL8fpTPyohVrihMXwl2zI79rD/90g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786539756;
	b=yO/T144mwbeNlL5bOdO8lcuZLSk2ke3BaFllVmZyUVVZz0MrVOz1kiB+wYgOVMo94XSLZb
	19ENmzdhdT29wXmPj69b0g/rYswpNTm1g8y2OC7qNVkf2N/Z3x1hWUaxJbJh6dHSNqJmkB
	mYMjlj2I435iAFYpgLGiKMXT0P1CwXU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=HgJdg8uu;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=none) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3afadaQWMy7CXc8uhs8r6Sfs6URxGbACL7mqS2X/ou8=; b=HgJdg8uuNv7b1rrcSdXBbj1MTK
	ZjMQbPpaREu1sUMqCaTcc0geR+tY7OMvF1cGa0I4zkFPHKkdSUjX6qCykS8fhoYNOWKM4zlB2nSHS
	kUNMkq2Ixw7wUtfN5wqBDeu5XcqC2wXRsxieXlOadYscpLROe0xNqBBy0u3rXu8Cw5xXU6TUQQhJy
	z9bi9odZn6NbFFXvfCfap8eEfZ75/Axhnzy45NnEl7pW6AhUlZkj1TNdfJENkN4Pt4+Tn4dmDtjCo
	e4WSLSWu6ERMeuCqdI32TDnkkXW2stmHYtQglwmeqzEPiwINC6+72yq3uoh7L41Ft4wq4Yd210pgy
	XNFoMp4Q==;
Received: from [96.67.55.146]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wu8ar-000000007WD-1KH1;
	Wed, 12 Aug 2026 13:02:05 +0000
Message-ID: <30b747de6202cd875b7669f8d76ad8ded5c0a4e7.camel@surriel.com>
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out
 of follow_page_pte()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, 	linux-mm@kvack.org
Date: Wed, 12 Aug 2026 09:02:05 -0400
In-Reply-To: <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <20260811025157.1632867-4-riel@surriel.com>
	 <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: 18txfntjdsob681de1fr9ryg8hrb1wrk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 66AD5140015
X-HE-Tag: 1786539755-190861
X-HE-Meta: U2FsdGVkX1+oGSN+frqXL7u1x/nF+u2q8slSxCyqBL4oRSx3N0HKWHTgxR8VLqimyeam0vp9eOdOpkyLc0iKEIiJM4mQC+fxmG/9H10+AJD4nndLqGOIp4gX/WH2ikJJZgItdiLuar7GxbM9WBBRQn6ER4cNTRhp3JwgMKn9+MQweb+C49tINiw5DgU0Ni7alVoSfD6sXbVYhdOXTnMhm7etd9+p6Nrcl2nN6ANejp/HiWhDjLSaIhYAvVWTC7e2uc2ys8eWM/MdvhlzPkIv4P/Edf3sbch3uqL9TsIOmvImhcGDpwxFxY9x7R9Pe93/+qWZckaovUJjcA9AbtKBijIr71lURyZWF7RBIQUPR+fsDZ5KlRJgMjyPGPXsq3QbeKw05iLXAX8/OeNypNgg0miKIeRYGvoef891CRavw4EFyA6I5IVPrjTZJ5P7kSAtQVIIRFUaYROQTEc3lCQt2dBj9zNQmJFAHsWF4Qd3yE2ihCOSTge7cmb/8S4d6If4n/R3ET8y6tzz5oBdP7f5lHfCblrHg6YBze+8ElRCKydedPIdXUzPt2F/9aT/cjjVAs9O8YrBgHUznVBJF18Fz+EjwGLaxoZiIQ+aPCK0DVcFlbRpN6dVhejPZZx+dwekv9aTGWYgVwczeEkkGjge6U6CTtQxp8jZfKx2ooNB00QiJ21VgufFnU6/1+8YcZmTlLGVauz4eGrYsp2+SuzJzRubRugEW2Fo7AefB9VRCUgW7hay23Wd6bGVU5RoJV+9I1p8fXHFq/w6p0nXoBDQ5YjAfOcKE3vOhgo7jcnkodSjOIuhrJXlg/EsEW/F+Hr3XC4fqs/U0jtbRkPuiLi8JqCJrdrygqFO6XYFoY9yPHwoV6S5sqFu+CQOXip+kdrD48dMKt1/gBabipqNwgRDTZfGFs3r0ib4chhK3oksqINBnnBnkLqAdnN93F3N75RVMMhn1W6QbeDAJAW1/+v
 krUjbiRd
 420Vkc5lYyFj7zmhapZs4cjEzb2dgPh9YcBIgaqsy9vA1kvttwo1JCiIWib/pRil7vFm2wzy5XHs/cb804BpHuorHflizvv4+ypsHs08rS4MNTdhM13HyUCgrKdfKLF6aCR4T3I+wPZoRIA/WPedrCrXsnbLaHO94lctSIV9le9uCs6mR4jXMWd33cK5ZYxNTZC4uQ/gP05NgYzVuP69IdctoC+ulSD2tpL+EnR6uUe1UxgEVTTbaPDSufhRr3XQg8MO1XNsvBhrIC4uklmFrenLnEfSjDjoxgVXS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-08-12 at 13:50 +0200, David Hildenbrand (Arm) wrote:
> On 8/11/26 04:51, Rik van Riel wrote:
> >=20
> > +/*
> > + * The caller has already run every per-PTE safety check (present,
> > + * write-fault, gup_must_unshare()) on the PTE, so this only does
> > the
> > + * per-folio work: the refcount grab, the FOLL_PIN accessibility
> > fault-in,
> > + * dirty/accessed marking, and the array fill with the cache
> > flush.
> > + */
>=20
> If a function needs 4 lines of internal doc to understand what it
> does, then
> maybe it's not the right function name or abstraction. :)
>=20
> I don't particularly enjoy the "commit" terminology, it looses the
> detail of the
> most important thing this function is supposed to to: grab a folio
> reference.
>=20

Should we rename it to gup_grab_folio() ?

> We're passing in the pte only to do a single pte_dirty(). If the
> helper is
> actually what we want, likely we just just pass in the pte_dirty()
> directly and
> remove all pte leftovers from the helper.
>=20
> I'd assume that we'd want a function where we can similarly punch in
> a PMD/PUD
> and have it do the same thing as well, instead of special-casing
> ptes.

Looking at the differences between the pte and pmd
code, there is another big thing that stands out.

The pte code will call mark_folio_dirty() when
needed, but the pmd and pud code do not.

For hugetlbfs we can get away with that, but for
huge folios coming from a filesystem, don't we
want to call mark_folio_dirty() somewhere?

I'm happy to do whatever cleanups we can do to
this code while we're here.

--=20
All Rights Reversed.

