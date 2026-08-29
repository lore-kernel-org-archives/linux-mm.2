Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3BAEC61DD3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 02:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269AA6B0088; Fri, 28 Aug 2026 22:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219A16B008A; Fri, 28 Aug 2026 22:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1ED6B008C; Fri, 28 Aug 2026 22:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2D656B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:11:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0786A0612
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:11:32 +0000 (UTC)
X-FDA: 85152680424.14.CB14FE2
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5297180004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:11:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Ln+WBa 5";
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787969491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4m7Aj7MKnysLygN8jaeO6jA5O3Nx7oGEa8ywJ1zsCEo=;
	b=1OD+V7QqnlYVlRzEMuzYPUIspBmMg+mDTBR8bWAqhns0BZF4xq9iEmeBxNZmwHH8Zr9mI3
	qLduYIOGjFYlDKUAzGmiF3EUOjeiv5J8h7l9IX06deWc6VdkeFBsauNfFPy97UkEcsxQxO
	ENnmOvgq4Xeh9DO4CI0+yYdu8gLcqrg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Ln+WBa 5";
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787969491;
	b=qvbo9Y4QfQfqU6eNYzUx3STsmJ1KZi7oKn+E+L1vcmvRgK2Be3oqpxtWNS043oKlXPNW+S
	YuZVKPAjNJGF53aF3OIK1p0F8gCB7Ziv5UImVQ0WZVCRoGsszJClprw/wAPVgyp1Fe9mjH
	bv/x44/qIfCmcsa0QBfOsCFfM6148ZM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=4m7Aj7MKnysLygN8jaeO6jA5O3Nx7oGEa8ywJ1zsCEo=; b=Ln+WBa
	5/G2COsBtXJF9hqXRknoFtSR7DzeCepjI15pNgy+JikmwXDbPzQiWPJABunIEVxC419xO5lXwIi5F
	m1Flna3ngJvaRHeOklW7XRX1NmrW702Em0BBnDL6zVce1FNCl8Mi/BqXdAYT39c8a9wAX7HbcJEUV
	WQj9+ZipzkdsSumIydqMkFm+2fwVwHHjrJbWSsSwY3eofJsJ7kYPB2pYpXm1/XYz5BJ1jhG6lhn5a
	FJYnqWIGVRiAkva2JhclfsPXZdjKGn2Ak/wQnJDD3xp5ZEdtXukHyUbtNYs1kTOAdC5qWcXDIQAhu
	aZ3E8f9NG5b6KF9CgKmHSH8iFFRQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x08XD-00000009CGN-3aTV;
	Sat, 29 Aug 2026 02:11:07 +0000
Message-ID: <7ba9d2e6370d6134ad34cdffcff5cc79b9192df1.camel@surriel.com>
Subject: Re: [RFC PATCH v3 4/8] mm/gup: break out follow_one_pte() helper
From: Rik van Riel <riel@surriel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, Andrew Morton	
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, 	linux-mm@kvack.org
Date: Fri, 28 Aug 2026 22:11:07 -0400
In-Reply-To: <CAJuCfpF47Mpi40=8yujBNruCDvY-Ezk0WFEacCqxcdRjmUqt4g@mail.gmail.com>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <20260811025157.1632867-5-riel@surriel.com>
	 <CAJuCfpF47Mpi40=8yujBNruCDvY-Ezk0WFEacCqxcdRjmUqt4g@mail.gmail.com>
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
X-Stat-Signature: uufj3p7t5x89bj74edc5g5dsin79n5dk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5297180004
X-Rspam-User: 
X-HE-Tag: 1787969488-285981
X-HE-Meta: U2FsdGVkX1+yi2mOXpAiapLoJS25ZLyJ3gz6U3FiIYtZdQaHebs/9dAVvYNO+UIXwDdGOzLZbo+f6L9lR6sJqTphg9wlb/iNgKidHNUqdmFD4jUYSsARKQSqs3LCT2eTMjUYq4A3ZeIfLYudH2HUqZBkELrtrifK+4nZmSB8bg+0PNyPWLO8oPDbU0K1nMGJDTFOzCbsUd/YYCw4lE5mjSS95hNOkHfgXA7DpUYD+LeoiEDymUmepF9uwNE2t64r4oiumEPpU+70+m+wixzYLUELG8O9twtsiSDGuSyGdf96q8wP8fMm1BazY7c1Ir4NoATIjZAZ2Lq89AozwM2VzDbsyw0ikjTbUet3Kx31p1qkHXyIyn74IyhRalGweS2PqiTlxrqc7q1Sq1mr9zjnyd7VHoQjyGm8LRnBOgXYt89EScUK+Wc19gn1lWW9lxBO+50oaIhSFGyCvOtkbH7xRgkSrh1sWCBj5Z1aBPEvdrV4/j60tumVSbRtvZnpKd2wHlOHPrEchzN7KbN35bJgguYpJv6uwiBMzcYtXwgrC1qH0Wa+VrOZ9ptjrKog4QDyTjXEqud8EcBzxfZYYG75IlZQWJK/n/YBztra+LBKt4qu7VrhinRTttCk2gHfRMWA9Fu+TMABQnZFJavA7qGr2nSBtMhmDrwu5/vseOgB28hkkxI/sBmTgqxHLSWRpXRBZQT3WaoVa1mEDlFv1UTK/19LRdxSbn/DtP44s4PaCWEgOaVFN3P0Enhrhh0GvgXOkANgtwEKhG4C1AFSsqT8JXjx7/lMuA7zRvtAFB53YLvftaveMDDH+M42j1Z9clW/rXYmNt42Buvr5F96lJ8jCZWYhydUKdQt0klOUpqgzI6Xeu3uTD6TyldF4ZeSweOZ530kysNot/8J/gTxBeTyrCiSsx0q0VW1oIlpupK/KFRiQK/awBa9cEYqyZHrFZQKvT7rAzPwZ18ny86jsZq
 Srz724Of
 EDRGNS+5yObZbbgHOPmYhFjwHxDN3x5KqByeJ4sMVZUkyPo4BhQ/8wowrm8QmuCTv9mayDDAbpgE30c98h2LiCVRIfJJaIC2/yl3IozibaAQ/XkMJpP57OqpSFOC+7x49Q+6bvxm1zMXIIidkWkSH53Kk7/lLVIz8MuAH4BSRU6JrSBFaq98WHuaPmFae6g8HqnwSEMA3JjJnxomCgZb1e0AtBXITUdBrhVt9mtv8vvWO1mCey2c6U7wkRqTnefCNTpOiHZEa3u/utJselGL0h3+zY4I3HK3FHyziNqbZH5Y3nCktgHeVkNR2U59s0o1bGjPK1OhqWlobPCEbSipnfZ+8L0bMk0zdGgdUVO0EejNIcm1mOEpB0W4AOiIKwVlAj37P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-08-28 at 16:47 -0700, Suren Baghdasaryan wrote:
> On Mon, Aug 10, 2026 at 8:07=E2=80=AFPM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We only care about a=
non pages in can_follow_write_pte().
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((flags & FOLL_WRITE) &&
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !can_foll=
ow_write_pte(pte, page, vma, flags)) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ret =3D 0;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 goto out;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((flags & FOLL_WRITE) && !can_=
follow_write_pte(pte,
> > page, vma, flags))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return 0;
>=20
> Before refactoring in the above case we would "goto out" and
> no_page_table() would not be called even if pte_none(pte). Now I
> think
> you will call it if pte_none(pte). I'm not sure if this does not
> matter but this seems like a functional change.

Good catch, now we may end up calling no_page_table()
on a VMA where we are not allowed to write, for a
FOLL_WRITE access, while before we did not.

That might turn 0 into -EFAULT in some corner cases.

I don't know if we can actually hit any of those
corner cases, or whether they matter in practice,
but the fix seems easy enough, so I'll fix it for v4.

--=20
All Rights Reversed.

