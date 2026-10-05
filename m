Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 388CCCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 11:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10986B0092; Mon,  5 Oct 2026 07:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1096B0093; Mon,  5 Oct 2026 07:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFC86B0095; Mon,  5 Oct 2026 07:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92B946B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:25:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 596DDA64E6
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:25:53 +0000 (UTC)
X-FDA: 85288342986.16.917AD62
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9ACA780007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:25:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="AX5sdA V";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791199550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGz+zDfvrEqcuYJJt7frz3VKayhJ6cscOwEJS8/IB9Y=;
	b=Ue0oO9kQUujxSBfk4ezumRTDnuMGlZqt+wFYiQGSqG4bQS+Dq5pCQDlYYwdSZGUu4HW3Gv
	BHTG2Pwsu76bd4IzeXHidTzMWsPoUlPg9mzDTlIjRA35datU6fOMO8GXzW3KG8SdU9KluY
	sFSiw/ZAO0+uoMXMLIp1KbHrocjkwGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791199550;
	b=B+XIRum96c1wr1w8cnzg12OaakTJnzh6sEyUyEe0fZVbDj3+ew98OPS0rNHWJwSRs4ZKzm
	gKlT2V75lyrIJAX+M76UGF1FN2zVMsg9LBbs7Tnq4Ybwcbbtd3i9vt/PwGc7KMB1Gh7nT7
	s0MgTCvNaSUq2rCIVLpKcPRk1DNI2Dw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="AX5sdA V";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=jGz+zDfvrEqcuYJJt7frz3VKayhJ6cscOwEJS8/IB9Y=; b=AX5sdA
	V8hSFC2YwdUWzQjkBonxKt5VrVOmxLSmoc4VoaDT7eJNR9wmG2gTv+PtgbunvXImHmo0FIYmCIapv
	SoFg+wElMK6YCHX6RrgxIr3xKH+WXEB7DezoDB2fJlTIpeHn1rGTM9e4gDVzdjZVmktShAQn3yiy3
	kD0MwfzIJ2svgaaldBy2borveeekSicFYlcia6Bw0LBunxyXjpxPXAtvUIuk40RInWsmccipjc2cm
	Yc+lgGLpoKJ0yXdE02ENyuSnZCrIeP4O6OIrO0FZdM3zBLcnOrnDp9wCTXNizF2s9bwBhNdDoUbne
	ZrFcBHHYcvYR0ag7Cf/IfMKMsVIg==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xDgp9-00000006F0B-3hR6;
	Mon, 05 Oct 2026 11:25:39 +0000
Message-ID: <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
Subject: Re: hunting memory corruption bug in 6.18.x
From: Rik van Riel <riel@surriel.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, "Lorenzo Stoakes (ARM)"
	 <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, 	david@kernel.org, Mike Rapoport
 <rppt@kernel.org>, Dave Hansen	 <dave.hansen@linux.intel.com>, Pedro
 Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
 luizcap@redhat.com, pbonzini@redhat.com, Borislav Petkov <bp@alien8.de>, 
 Tal Zussman <tz2294@columbia.edu>, Matt Fleming <matt@readmodwrite.com>
Date: Mon, 05 Oct 2026 07:25:38 -0400
In-Reply-To: <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
References: <arde/t0zQNEkWqi5@pcnci.linuxbox.cz> <areOeRwZOez0eHm7@gremlin>
	 <arotyz5g6LozSjb1@pcnci.linuxbox.cz> <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
	 <arzRBv9ceJsxJppI@gremlin> <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
	 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz> <ar9yRqq6cBxHDWKA@gremlin>
	 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz> <asAE3kLFDUx5v0Nw@gremlin>
	 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
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
X-Rspamd-Queue-Id: 9ACA780007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4bwwnwyqhpfucnomi84gfgpzxs5updan
X-HE-Tag: 1791199550-458741
X-HE-Meta: U2FsdGVkX1+m7qWxMVsZ8OaqYceq+ksYSJ7Fxpu9jwkj868DozYbXaQVsUVL4Zi7M1GlzCWnOtuVX4QbfiJjvY0l7dWwIBSbqLZmd/CI8qHKKsGgMurfpw8uCr0NKbYs9ZlLDCGBJ+9rj2aTg/IkhWrNv13CjWFdpz0fWqKAY/6HktLzcsGhpvpqHe393EcV1MaJ1UzqcZdYXVsnwd+KwMpymEqoQ0rj8UQ4rz17Bcr1rxqyPPDuVvAidLYpqXPXhzJRE+Aju4tKrZfLCVuDULppTnR/7wLe3AwjzLz1HUhdJlFiamwDyzFl0OoGdxmnjAOVi0PIs7laE3C9+2oMbPY3wUbaA44cVTncWqU8BGP5aA2feGaooe9pu2BZw5/5l0DpwoF4o9Iqgt8mFV4fnaGMrYrSMk34gz+/m7W/yCak0N7AJvazWMCvzuCAEHzSB2YWMKyozfeLb24A6tTqMEX1UZPIaYA2i4Ww2XtYqUUAeIEp2EmOgso4GxUwRr6j1Y/3AH1ZrXTdQCeZCc7MncPqrpavMrGxctSdBuHbK60sdAeba+UeVCOZ5lp7yo1GxhhQaLVym/+JJMYALV+wdxrHVqhpUabQTyQsN6eVnOCHT8QfrzrdS4VRGLAyz/oBXjAK2gpquhZ/ocNT8+HpH106VAR/QRDUwh+bsRCLBjxevpYm7Dcrm06N3nqgduoW3rx5PxVBxG9rccTIaG3bg6czXsctSkkj0tWs2JnpRaDot8FW10Bb46d/JAunWUu/EynO+rNfHwcJCY5Qi0RJySuhUq/Fv/kQn9YrOoY4Mxq4IPz1wwy40mTZ91CQvRigOW/WHS0hgm/fDQTezTA7D2XY0cBxlKlaNzV6x3Y4a4HWDiRADSTSltT1iQST+4GW4XL+BsxTZ62Ig7q2zkwfpBsJ4ibzhHIAN/g8YswAuh+VLfqwS1u/V9CRJ0fGOn3EzM3nc8YAaBYnsm1CicK
 Cl4b91Ul
 OVyQP5TiyCcODd6saeW+tEw3gHmSWbnjfUp7pI3xmueUsBrclSZG7YGbg6Izm35FfK1uEhHyq1WVqbIEae3xg6qPGor9YVdhmYYX6WEJgx2ufYVxqDLEd6vHAvGBYfmohhkAN/Ie0OOK2122E3ym5motdNZElXpkc2C13TexiA1fLqs9BHy2W/m0R2+4cVsPuBjT2F9LfxXyaexC+0L6NuEzyrTq2glki6BcoVnworMeUmL37D/NLfIzw03OcCsP7pgm2vPv2IpoGnU1obhA0wJd23g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-10-04 at 20:40 +0200, Nikola Ciprich wrote:
> >=20
>=20
> crash> rd -64 0xffffb18905f60000 512
>=20
> ffffb18905f60430:=C2=A0 0000000000000000 0000000000000000=C2=A0=C2=A0
> ................
> ffffb18905f60440:=C2=A0 0fffffff0c930020 0000000000000000=C2=A0=C2=A0=C2=
=A0
> ...............
> ffffb18905f60450:=C2=A0 0fffffff0c930020 fffff86eb0c30000=C2=A0=C2=A0=C2=
=A0
> ...........n...

Two copies of the exact address you crashed on,
in a vmalloc area, presumably the dentry_hashtable?

Can you use vtop to check that the different occurrences
of the 0fffffff0c930020 address in the same vmalloc
area map to the pages you found in this crash dump?

>=20
> crash> rd -p 0x103360000 512
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 103360440:=C2=A0 0fffffff0c930020 00=
00000000000000=C2=A0=C2=A0=C2=A0
> ...............
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 103360450:=C2=A0 0fffffff0c930020 ff=
fff86eb0c30000=C2=A0=C2=A0=C2=A0
> ...........n...
>=20
The same thing when reading the page directly.

So the invalid value the CPU reads is being read from
memory, and not hallucinated by the CPU.

> crash> search -p 0x0fffffff0c930020
> 103360440: fffffff0c930020
> 103360450: fffffff0c930020
> 114c32440: fffffff0c930020
> 114c32450: fffffff0c930020
> 1ae234400: fffffff0c930020
> 1ae234420: fffffff0c930020
> 1ae234430: fffffff0c930020
> 1ae234450: fffffff0c930020
> 24f0e2400: fffffff0c930020
> 24f0e2420: fffffff0c930020
> 24f0e2430: fffffff0c930020
> 24f0e2450: fffffff0c930020
> 342c40400: fffffff0c930020
> 342c40420: fffffff0c930020
> 342c40430: fffffff0c930020
> 342c40450: fffffff0c930020
> 77475b400: fffffff0c930020
> 77475b420: fffffff0c930020
> 77475b430: fffffff0c930020
> 77475b450: fffffff0c930020
> b2fabe400: fffffff0c930020
> b2fabe420: fffffff0c930020
> b2fabe430: fffffff0c930020
> b2fabe450: fffffff0c930020
> ea2d7c400: fffffff0c930020
> ea2d7c420: fffffff0c930020
> ea2d7c430: fffffff0c930020
> ea2d7c450: fffffff0c930020
> ef7a2d400: fffffff0c930020
> ef7a2d420: fffffff0c930020
> ef7a2d430: fffffff0c930020
> ef7a2d450: fffffff0c930020
> ef7a90400: fffffff0c930020
> ef7a90420: fffffff0c930020
> ef7a90430: fffffff0c930020
> ef7a90450: fffffff0c930020
> 10371fa400: fffffff0c930020
> 10371fa420: fffffff0c930020
> 10371fa430: fffffff0c930020
> 10371fa450: fffffff0c930020

These are not random offsets in the page,
either.

These all seem to be at offsets 0, 0x20,
0x30, 0x40, or 0x50 into the page.

If you look at the other addresses, are
there any that are not at one of these
offsets?

If this is a case of "system writes
fffffff0c930020 into one of 6 slots",
there could be some at offset 0x10
too.

I'm having AI comb the kernel now for
places where we could conceivably
construct this value, and write it
into one out of 6 slots.

>=20
--=20
All Rights Reversed.

