Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9F2C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0426B009B; Mon, 20 Jul 2026 11:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B71C6B00A0; Mon, 20 Jul 2026 11:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE626B00A1; Mon, 20 Jul 2026 11:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF746B009B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:25:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 842BA801D9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:25:15 +0000 (UTC)
X-FDA: 85009528590.25.B6FEA7F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id E0E348000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:25:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="oq/oQTDt";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784561113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEQ9hUpRdURqegaHoig/c4svS6qvm4546G9gvQSz9O0=;
	b=0SgNJJz8koc3zF5fTy6b0vgbabFgpk4Nacz/kYK8O0W+4OM8b96aGRiXEK5iHIz9uB3MsF
	dZozRQg+hueUsBXpOnXSxtuqiCytqAAVNdSpMeKetQrJ+2hmu3SkKz9tdPQHQ/iClq9aEd
	+S6Gv0/+zCpUQbScekKfKEqNLvlfQaI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784561113;
	b=2iSCToyTlbAwdXBVFji7Jjvp1Ast8xZb8PeIRxMOfJKrpJ70rp2w4iPhx+7qU99FuL3dbg
	S4vwqgAhyxg0fSk8ur5QgIAdah4g47d6lBP/ijw8cUwo5Za/HcxwzVj5sHsO7A2QkXVKV7
	jo6dXH4SyO5AXvXm0bBzimmE7UGjg8Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="oq/oQTDt";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hEQ9hUpRdURqegaHoig/c4svS6qvm4546G9gvQSz9O0=; b=oq/oQTDtoJjPI02uU1ZIe3VrEL
	k69uDO1QYL8yWuayI6i1JQfGxFRu9nnkVWIFNiqJ5XOroDmXEMgyNzTXAZql6SDsIi7G2f2JVfUO1
	+Cdjs7y0igm6Ux5qXkKVOWXX4ZlzqlUERGbdLzqy42uYcc5exOSnur2zEZOO33qEOiaGdLTsUanDs
	moQEKPk9/eRAKvMLw/PyA4yEaTOMTtjfNpkTH/6AWaWdsJBD/B0sXQWU/CLtQwjD4STwSaEfQB9fZ
	wAZT8n/bNuL7qxtf+99ETtG0KFP6AauoqMTEaSo+O8D/veSd3B+h0sXz7AIqqu1M6eoMhuFGw4Df2
	yP7/5dxQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wlprN-000000001d4-07Ri;
	Mon, 20 Jul 2026 11:24:49 -0400
Message-ID: <61d21f204aedae44b2b5cbe2e7ffb1d72fedc5c6.camel@surriel.com>
Subject: Re: [PATCH RFC v3 4/6] mm/gup: add get_user_page_vma() to fault in
 a page under a held lock
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 	kernel-team@meta.com, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes	 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Date: Mon, 20 Jul 2026 11:24:48 -0400
In-Reply-To: <20260720123505.1234897-1-usama.arif@linux.dev>
References: <20260720123505.1234897-1-usama.arif@linux.dev>
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
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0E348000C
X-Stat-Signature: innfiuoengsunrf5j4ecfpubqa69fcp3
X-Rspam-User: 
X-HE-Tag: 1784561112-317292
X-HE-Meta: U2FsdGVkX18hRAn3AbexJj+AxhLnciIj25MOyDKYW8DA8HgnVFQKFcZelviVDM+g7xLD94u2OWO1gq0/MnyVGBmpXxeVML9mxna+76WBiP7u2ceRovypHyEEhJqd9bBhRM5DjsrMioYxZEsnIik/wqm0zj0VmpPpnj4ilTu4ILLHj6Gm70lgw3Hi+96Vbry0GQ43tlRPsL4kXJ5A11Zqb5UvmREba0DZtIrM67E7F5kuVBSXxrR93f37vwsSFXV8FoIevYicUVtxLIILxP16u2ghjpNKO5B36kHmwRcMUyfyii+XTv0VqxHESGVnqcccmYTT5jkJZ90Xele0U9efHmpksCzY7WYBw22YPMzUUAesOq9UbD2uEOGLen2+nqxlD1Jryfpk/OifMlepebwtOVIn46FduKVLJxEhUcXbKDv+UFtZXF/6hG8uqvNbC5bc5z8Mz0kVYTFJWRZaOS9UxTydCPJ/DUrCEAgrQBZAM1iSHjaamO0JocFH8z2U9v8yIcoIW9mFOXZOhN9/LUxOYcVOR/Ne25qCdIA1YSlPIGFQ5u6BkN70jBkNJ1NlIh49S+5V4H7QdaTj7K/r9xYSOAC9rO8OlFo72JZt0+3J/8frI9nLnKS7NJg2iBkPWvKcyIKsYOWF9KryTWgohSUHTTXj6rFTVCyffk2TnOpmrMTPtJOA5bTOaEfu3gAZ/Vlm7240QgasJ5zg6U/pklQFBC7u/Q56vc6/WTpZi9nXGGjQfP02AC4j6HDhCoMjM7wFsLa2aVVd2r1CLwTxp6S1RMOc9FgZssouwgp7AL9I+KwOVIJYOmQPv+gw+hWpyuBghM74LoArQk1oZ8kcLPYTddKGZVw5K/ZSO7EoCk6R17+/Yl22RRLXCBTFxLrJeorx8E11Fb9c1V+OQXIKDQyvUhCGe3u024d76bjWzGV57YhBIeojppE95b8i8FTbzAFoMc/HTKZeOgQRxzxJ2Zq
 7KLQYHlQ
 agdX79arVjxhhxweHSeR5rHDlqoSYg1SgceEIR8EmKxKtpcVLYavuAs8o26KB91K8bpQfs7/hXu0HVeh1HEfjmTAB46XT4A1LQmqGMR3K78bGTeep+7htX+35bAWsrQqoU1BPAmZ9izFxA0jDXrz5W3ewxn49lQlZ9xTza5fx6O63Y9v5d0E56BHMJcDIfkVZbaRKEa2YE241hcCTEYQw3PtAt/nIkHZ1OwxN2mbL766QozdJ+tNyf7xulA41+xlq4jHhai9Y4fAwvLIEhc8cVJ7OljgpXPuQ01xaYOFMsEaZjgFkXlGRj1ZfNmzcLz4DD3aC4Peyq7t/aPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-07-20 at 05:35 -0700, Usama Arif wrote:
> On Fri, 17 Jul 2026 13:00:34 -0400 Rik van Riel <riel@surriel.com>
> wrote:
>=20
> >=20
> > +	/*
> > +	 * Validate the VMA up front, like __get_user_pages(). A
> > VM_IO/VM_PFNMAP
> > +	 * VMA is not rejected outright: it can hold COWed pages
> > that have a
> > +	 * struct page, so let follow_page_mask() look for one,
> > and treat only
> > +	 * its struct-page-less PFNs as unreachable. Any other
> > rejection
> > +	 * (secretmem, bad permissions, ...) is final.
> > +	 */
> > +	ret =3D check_vma_flags(vma, gup_flags);
> > +	if (ret && !(vma->vm_flags & (VM_IO | VM_PFNMAP)))
>=20
> Do you need to somehow restructure check_vma_flags()?
>=20
> The first thing that check_vma_flags() does is:
>=20
> 	if (vm_flags & (VM_IO | VM_PFNMAP))
> 		return -EFAULT;
>=20
> check_vma_flags() returns before evaluating VM_READ,
> FOLL_FORCE, FOLL_ANON or the architecture permission check.
>=20
> The code then ignores that early error and may return a COWed
> page through follow_page_mask(). A non-FOLL_FORCE caller
> can therefore read a COWed page from a PROT_NONE PFNMAP VMA.

In this code path, if we return an error to
__access_remote_vm(), we end up falling back
to the ->access() hook, and will end up reading
the memory that's "under" that COW, instead of
the COWed page that is currently in the process
we are accessing.

In other words, I think the behavior of this
code is the way we want, even though the
implementation should be cleaned up.

How about we change check_vma_flags() so it
ignores specified flags?

check_vma_flags(vma, gup_flags, ignore_flags)

Then this one call to check_vma_flags can have
it ignore VM_IO | VM_PFNMAP, since we want to
access the COWed pages in those VMAs in this
code path, but fall back to ->access when
there are no COW pages.

>=20
> > +		goto fail;
> > +	pfnmap =3D ret;
> > +
> > +	for (;;) {
> > +		if (fatal_signal_pending(current)) {
> > +			ret =3D -EINTR;
> > +			goto fail;
> > +		}
> > +		cond_resched();
> > +
> > +		page =3D follow_page_mask(vma, addr,
> > +					gup_flags | FOLL_TOUCH |
> > FOLL_GET,
> > +					&page_mask);
> > +		if (!IS_ERR_OR_NULL(page))
> > +			return page;
>=20
> __get_user_pages() does
>=20
> 	flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
> 	flush_dcache_page(subpage);
>=20
> before returning the page. Do you need to that here as well above?

I suppose on systems with virtually indexed caches
we do need that.

Thanks for spotting that!

Now I also wonder if I could restructure get_user_page_vma_remote()
to do the lookup before the get_user_pages_remote(), and have
it then use the new get_user_page_vma() function, to avoid
the double VMA lookup (why are we doing that, anyway?)
>=20

--=20
All Rights Reversed.

