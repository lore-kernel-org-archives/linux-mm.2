Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73301CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 13:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC396B0092; Sun, 18 Oct 2026 09:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09BCD6B0093; Sun, 18 Oct 2026 09:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2D06B0095; Sun, 18 Oct 2026 09:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D33516B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 09:38:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C62B4A054A
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:38:14 +0000 (UTC)
X-FDA: 85335850908.29.BB926F8
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4939BC0003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:38:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=QQaIQZeZ;
	spf=pass (imf22.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792330693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3PNJs4NiGtilEQpWdRqiG+quBu7ASA7JyGTHSsV4qc=;
	b=c6ccuw/1gqRsPLXqy+bK2nTqSSHxeleWr9IuC2fAgVFg9CUhXFC8YY5aPjqMm6Vb+3YCnV
	xFFg0lS9G/H2WREY1KCRZK0moPXugcU8untfrO5xZSBAdAtUW9rwj4Bvu42WO0qU2R3tLf
	7C5AUU734cfYgRTCF67JucSDbXsQUic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792330693;
	b=DVVnsbWQvzfmU+EmWKhswmrZU/H2z8nZ7UTgqrPzm8IFfUyVjqqz9oS3Iw39mSUrBF2oCy
	Zpv7UppCcddDCyYY7tYZTF/ahhMyzKxXZjBW2hFVctgFhsL5qMLTBob64MS3Ym0+dhfDU2
	qh7DPLpVuzBxG2YM9y6nRRRGfkBnny4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=QQaIQZeZ;
	spf=pass (imf22.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
Message-ID: <4f7dacd9b4cf0a43209be84f2408e6f7e033fd3d.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792330692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3PNJs4NiGtilEQpWdRqiG+quBu7ASA7JyGTHSsV4qc=;
	b=QQaIQZeZxo16u7UdAOq4kPy1bHh5wCdCBH3QZYCg5PimPB58GI9wTdfFUotn+h0Z6v2BVp
	u1poagQVYS3BGkVyq/Md3JtwjPxUGO4tWjKXdDBlmhiq53uFEsv4XbrV1lGHtHYHOXUfLl
	cIxyUDqNWLy862uBUKeV5H2v+UifeUU=
Subject: Re: [PATCH v2 0/3] sparc64: Randomize mmap base and PIE executables
From: Stian Halseth <stian@itx.no>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andreas
 Larsson <andreas@gaisler.com>, "David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>, Michel Lespinasse <michel@lespinasse.org>, 
 Jan Engelhardt
	 <jengelh@inai.de>, sparclinux@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Date: Sun, 18 Oct 2026 15:38:11 +0200
In-Reply-To: <6e2d2b2b7aa4029c261831016d8b6c40bc335341.camel@itx.no>
References: <20261018122734.2594904-1-stian@itx.no>
	 <e3068b5c97884032e7cbd12c78f6b5534d75e30c.camel@physik.fu-berlin.de>
	 <6e2d2b2b7aa4029c261831016d8b6c40bc335341.camel@itx.no>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PHAaQr8Laoy3OBzen5hN"
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 4939BC0003
X-Stat-Signature: 58bjb7hxw93xy3xem7ni1oxxoauz79iq
X-Rspamd-Server: rspam05
X-HE-Tag: 1792330693-228575
X-HE-Meta: U2FsdGVkX18CLHvZQckfzM66XRQpxHfF3l1KqDa1t2YgSk2iSZuwFNv2TLieEYE7rEVshF5hge/6lAMwQCgRtaPjajCat8Jr8ShWDSaZfS4sHcyuITQYVO70gaa/gZTbGsp9xBYr+OjYkoCDObf0wuETfRnlPXxnzEwZhoWRgcUlfloXkTh0i/B/qx+q3M/jXRginhg+KREZy1OMtC07qVLn4LDB519GvKeNKh+qoqSZvteRjyam8CD0ggXp4OfMQNkhQ4MA6buuS/0hnnCfqP8wJw7QZdKeZT1TUPavNwNnFLsF/y75NIO1joOJhflLjkoMKJOGkVqHEPTrsDJI+t6+L4QeMTZcrbo4ND6i4LxMTZQeieUuPf6RpH/woXhV/kmWIN+PckYKDW/uKMUHpbGtj3SH81MLXdjSe0jMEKIMq/B3CC4SUXXNebRQcZYYMurN/J4xQGSzfaokLZxNjV65iNxsozOhawA5n1xGTKrTFpwZs+ptQButbQuDx+Tk7QI9PjLcBpJ66pOU2Cg3fXFIm1vypn3KIy4VAk8Mp+K36wUix/m1xtJRngVKZugT0qa84L74GI3AAhE6MjqH+TXR7o8p2xOC4vOLnAPtW0InMfSS3UtOsRYYt7o2n/KvolBcQoaVgY3W3j/UdDBBj0bKQU/KnNBSpXC/qRBb+MaSBiU2cNyTVZ33k85bvhSWNPHTMmZdZzpb8PsWbRvBaRVXH99SZAGmjbVVDKS09BTzaLZrRM0dF+MILxsZ90g7zqpd1V/E7gaDS3RKSN5DmMITW1HabjTeh9xoUaSlkfuKC3+Ic/5xoZgMwHt5UyiegmkK1bwSDS7g3knOIXHuNFcGHVkgbIgKT5n01CDWX2qTGwRuFjUQgRZa5nNjt214514/wFt8zH+vUbevek+AhRdl8iQga/LZ0vngKIT2A7wLsQ4LfEtzJrzHZXEkqpmErVpH2tmSw+iuTj93exZ
 +oeJ3Ts+
 dcY5M6s0izgq7O0PHILXmZflRAUImNcC8kqih/1U/ep96GVJCzekgyghB0mWhW61Fcl9mcaWdvJgJFAT4MkNkhvSUQy3tAsVBo49beQbLbkct8K3b7yzc44JERBbV0W7vLOz24U8Ucl5GYWVbpTTi61J0bVr6+jLHDhrS6fl0UwJ7Z8rR5FFZwKEGC7t//2mW+ADPnwJJsV3F47xXy7uU5Evo9DC56M4hmNgEhOqT0F9X0BBFBtIaBO0iLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-PHAaQr8Laoy3OBzen5hN
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable


On Sun, 2026-10-18 at 15:33 +0200, Stian Halseth wrote:
> Hi Adrian,
>=20
> On Sun, 2026-10-18 at 15:09 +0200, John Paul Adrian Glaubitz wrote:
> >=20
> > What about sparc32? Does it use address base randomization at all?
> >=20
>=20
> sparc32 is at the same state as sparc64 was before this series. Only
> the stack moves.
>=20
> I've only tested 32-bit programs on sparc64. The same approach will
> probably work, but needs testing on real sparc32. Could be possibly
> be
> added as a follow up, if someone with sparc32 hardware can test it.
>=20
> /Stian
>=20

Additionally, outside of qemu testing, I'm a bit worried about sparc32
machines with virtually indexed caches. I've heard those can be fun,
and I wouldn't feel confident about implementing it without testing on
the "real thing".

/Stian

--=-PHAaQr8Laoy3OBzen5hN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCatTLwwAKCRDoeAEuJe36
Vl7RAP48VGMJlbwWIQ7VHqi25QkjzG+Eh44RA0bTgOXyVfzwmgEA8nOr9l4i+AbW
Ux5a921hTL1xjAjla4+mWeEC5nU7dwY=
=2Xlx
-----END PGP SIGNATURE-----

--=-PHAaQr8Laoy3OBzen5hN--

