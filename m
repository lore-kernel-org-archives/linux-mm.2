Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D966ECA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 14:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDD76B0092; Mon,  5 Oct 2026 10:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE326B0093; Mon,  5 Oct 2026 10:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75FF6B0095; Mon,  5 Oct 2026 10:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADF56B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:55:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A168C140298
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:55:10 +0000 (UTC)
X-FDA: 85288870380.19.534618A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0836140005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:55:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ncLEgY d";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791212108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdA0MPXlmrMW8qmDhZYakrLXupIVdlGbkvA5AhosPlI=;
	b=Yg2mnBbiXvk7WjD4EJg9VWq1TKZqKGFfaN8FBSNYPacKIfGYCPdnFRWLR/RktXnGu22AnY
	z9tvduHRBDZoQ0prfHlNs4jvYXE8pzomPd+sBM5mkueY0tgK//pg/NhYYKvfvdrq8hkrcl
	udFDdkgdxp9NThWRP3aUWsqGCxd3tgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791212108;
	b=dUDorRDfKE5eIcmi3zIBIk0KODdEsan9wIPjeFQSP4gWdlyuJSTcGzqMgA4AdYqh3dIUp1
	ZTAwCYiNS3EchincWTmk6fnrAROAu5NMJH3k0NOSCaY8bDrP9oez25jOowp9nHkCuPHZd7
	meSGDilKVB3svhwUdUySr92RDLwzxvY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ncLEgY d";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=cdA0MPXlmrMW8qmDhZYakrLXupIVdlGbkvA5AhosPlI=; b=ncLEgY
	dm2mFssTazTR36s95ABc/6pMw+lm7+78Rvn2A/By4S77fOr+aEqmC1NbPRmG0TlxY1FsSLDv6Lrnh
	XfsL2awyxVQIySmECox9pqUTQpMNAeaZPBFojdkMbONz/NvGgHI6zV+S7elK/72OAxPGb22p6rQxS
	sOhtj4Z05vTlTRsxXCbMjDNkt5hIw92ZLpDsg6xnp6Qlx6wLHfOjr4fXBxRpsx9Qj0XCUhKw4Jju5
	9rppAfBevSgyfz8eRhcOYHVLM1ikmb4kpUGveU9hR3v0VZGusE7sNdYb0qwYyeakSSbVaEHaf8ZSn
	BPEr8uubFap0CpC0fSRHWJy0fp7Q==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xDk5D-00000006JUt-3Ld4;
	Mon, 05 Oct 2026 14:54:27 +0000
Message-ID: <6a5f92b4c152be946c3a8f238197d389b9e87f54.camel@surriel.com>
Subject: Re: [RFC PATCH 1/3] iommu/iova: convert from rbtree to maple tree
From: Rik van Riel <riel@surriel.com>
To: Robin Murphy <robin.murphy@arm.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, joro@8bytes.org, will@kernel.org,
 iommu@lists.linux.dev, 	liam@infradead.org, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, 	ashok.raj@oss.qualcomm.com, jgg@ziepe.ca,
 kyle@mcmartin.ca
Date: Mon, 05 Oct 2026 10:54:27 -0400
In-Reply-To: <9547761f-7688-4351-b172-9e9d5fa28b15@arm.com>
References: <20260818152505.1057922-1-riel@surriel.com>
	 <20260818152505.1057922-2-riel@surriel.com>
	 <9547761f-7688-4351-b172-9e9d5fa28b15@arm.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D0836140005
X-Rspam-User: 
X-Stat-Signature: iw376o78sk8yfu7qomf89g3pptg5j1jc
X-HE-Tag: 1791212108-878036
X-HE-Meta: U2FsdGVkX18rlLReq4DWvJj3Qae0o9TtMJRoGkqYXC7aKU3E60awhswcj7f/IFwgQdhAeN1j5Fz/rm3U0uS6nygh3kZBLxnRAQtmIokPHhqOwsreBfXToF8sw0jH8Ns7fKj8kq7nIbbnN67rhQrfSG3HtTAziwiCZL/KfOyF5Yr0AMXVWfW8BAfpjrL9jEho9C5mUODcNgMuk1Eruz4Z8a1ov/LAQlTNoRwMq//Bs43KZlzcOqF8F6JlyXRPkIE4aOeLgBI/qvnR/MNWcvhQs/Yl7YoOyxJ9fiUPClMx8ARlXgjLL8K0Rm75ncfFcY/kQP7uTC9v7y5ay5ahYb1ZpqwIoC0GfC2n92sa8T6jZOUAcvC2hxuulPbzbYwQ1u2FDrAhW9FMzQKtkSjpqVJLxgNt4GjTUtG8CaD5MuCUfPwsf0+in3sxOQiJAc5W5ky/7IlXlb1jnQeAWTDo8rdbD4goXn69uVdfjyfQrKPcJk5jBOmwOVvkNdJsoeIC1o0F4iC7WJINO1onTtN0St4tU9f5R2FGy6kEdjUpvL1f6q6OpvqVD6O9q8MMIQizitZNsxIuIIDsqqjMA/Dle706wNUG5HPE4BISLhFox5efx7xOwjOuD8TCh1L3LQKBerKFhctI6DALo0ywGPqYSOFn9J82bCYfO6RSsVfECiHeWnSBNJBmquDA7sTNWIwIc2B309gkBmLYxy0WHNuXp0PeiLazCmhA9lMu16FfteMPM3rokdZbyE2CgyOobdm1797gPtzG0y+Y5+sOITfcjgCMFFLbI2aJgQNYKoqWznrsGJmoSBbMJ4Q6qBNCI9w4OK1dJdmwhl2EKgTiDL7at4WyrPnAGdqkR3UBYMcEvpFspAXtZWSzpMsbrv5atRB+nYvVcH/3r0m/N02+FNvMd2f/ut6BN2v81aGHfCNf2xlHStH2mTSuTSPac9T1Nw6wok8yhjkYsKpCvk8OgpTMbr8
 SE56dhSd
 8dvzmom7rOO3gg7sk1igC7cFFzNX723+ngxbBuN5zSkT+ynv9MgaMYYhbRjZ5hhzpb5f6Zf09rAsL+84Oc0mgYD+Tl6CgQbIrNor/4qisoPMZcWjpxdjdgK0nu25E+UMSdPDUz3d66pvQRB9BwmciTP21YiOQHCwCPQmG6RWjLrJy3GuJVfGuv3iWnXd0gvI5/vN9jYrCH+btUK4WR6fMYzwIVazf/pe37748SZzxzaBJIoTd1rQTFK85MmFCEiLGre7h08lBqYz5pdeu2bt9IRqQCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-24 at 16:26 +0100, Robin Murphy wrote:
> On 18/08/2026 4:25 pm, Rik van Riel wrote:
> > alloc_iova() looks for free space by walking the rbtree linearly.
> > On production workloads at Meta, enough CPUs have ended up in that
> > walk
> > at the same time to trigger soft lockups.
> >=20
> > Index the iova ranges in a maple tree instead. Its gap search makes
> > alloc_iova() O(log n).
> >=20
> > __alloc_and_insert_iova_range() asks mas_empty_area_rev() for the
> > highest free range below limit_pfn. Alignment is handled by
> > rounding
> > up the allocation size, prioritizing speed over address space
> > waste,
> > with the thought that many iova requests on a system will be
> > similar
> > in size, and reuse the same holes.
> [...]
> > =C2=A0 static int __alloc_and_insert_iova_range(struct iova_domain
> > *iovad,
> > =C2=A0=C2=A0		unsigned long size, unsigned long limit_pfn,
> > =C2=A0=C2=A0			struct iova *new, bool size_aligned)
> > =C2=A0 {
> > -	struct rb_node *curr, *prev;
> > -	struct iova *curr_iova;
> > =C2=A0=C2=A0	unsigned long flags;
> > -	unsigned long new_pfn, retry_pfn;
> > +	unsigned long new_pfn;
> > =C2=A0=C2=A0	unsigned long align_mask =3D ~0UL;
> > -	unsigned long high_pfn =3D limit_pfn, low_pfn =3D iovad-
> > >start_pfn;
> > +	unsigned long search_size =3D size;
> > +	MA_STATE(mas, &iovad->mtree, 0, 0);
> > +
> > +	if (size_aligned) {
> > +		unsigned long align =3D 1UL << fls_long(size - 1);
> > =C2=A0=20
> > -	if (size_aligned)
> > =C2=A0=C2=A0		align_mask <<=3D fls_long(size - 1);
> > +		search_size =3D size + align - 1;
> > +	}
>=20
> Perhaps it's a bit too much of a cool trick, but I think technically
> we=20
> could just do "search_size =3D size + ~align_mask" unconditionally.
>=20
> However, either way I do worry somewhat about the increase in=20
> fragmentation and premature failures once the space starts to fill
> up.=20
>=20
For that use case, I am guessing what we really
want to propagate up the tree is not the maximum
size of a gap, but the maximum power of two size
gap that is also aligned to its own size.

In other words, if we have something like this,
aligned 8, we propagate up a gap size 4:

used used used used gap gap gap gap

But if the usage looks like this, at the same
alignment to the start, we propagate a gap size 2:

used used used gap gap gap gap used

That would allow us to easily find gaps aligned
to their own size. Once the size 2 gap is filled
in, we propagate up the remaining size 1 gaps.

That makes me wonder if we need to go back to
the augmented rbtree, instead of using the
maple tree?


Just let me know your preference.
>=20
> > -	/* Walk the tree backwards */
> > -	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
>=20
> FWIW I'm not much of a fan of the implicit scoped-cleanup stuff in=20
> general, but this seems like an instance where using guard() to
> simplify=20
> all the early returns might be worthwhile.

I'm happy to do that.

Are there any other changes I should be making
to get this code ready for merging?

--=20
All Rights Reversed.

