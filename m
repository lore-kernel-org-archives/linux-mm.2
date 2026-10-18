Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3069CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 21:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7086B008C; Sun, 18 Oct 2026 17:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A256B0099; Sun, 18 Oct 2026 17:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38D96B009D; Sun, 18 Oct 2026 17:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE7836B008C
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:08:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 398F280206
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:08:40 +0000 (UTC)
X-FDA: 85336986000.09.73F86B0
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77BA9C0003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:08:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=mLhkdJ18;
	spf=pass (imf22.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792357718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3tcKlU8SvkUmQmBZi0BzH/KKWW601974k6exc9vqrU=;
	b=WSJobeEabIC43Zt35lja82upcEDc02nbubkzsR/Iu2bcD1UTD67JLX/uZfCxQMcH49q3TJ
	QSSQWln+Tt8r+HvX+pzV2ITDZEpgYf73uCLJ0ZtmFqVx+YDKBt9TKzk68pSga8pknzVKmA
	69EAKAqKTNcTNfwLZMlcS89IH8O7L3s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=mLhkdJ18;
	spf=pass (imf22.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792357718;
	b=UGFtrZdwdkrR77qcNjmI7AZ0NYaHma+rgAQw5Iy7HYtfQ9MDkFkTxa39aRagXfi2Enxy4L
	d/ExvwS7zA9Yo/qBVVplx9YbgDJ3bSA6lvieLoa4r/XEC4JJ1VQwiA/MCnCfSdhNBz/Dmj
	nRVFDIUcOu9J5B3gdneGzhezVDXRVss=
Message-ID: <d233287d5dcb6726403703a7b923b05a8134cb1a.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792357716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3tcKlU8SvkUmQmBZi0BzH/KKWW601974k6exc9vqrU=;
	b=mLhkdJ18WOX6JryQihTQGivO3zZpHqWO6fGMCj7cwaQpQzAr+GF+1NsuvEZZa5UztXzhj5
	x9nn7vGymEvD5XHin3fHlD2GDeqtw1eCnChcc+BoyjhfCrxx0oaYGE1uJ8b7C4UXlHi6gU
	EoHI39cbsaWcoTrhndVeYlhbpQrVPYE=
Subject: Re: [PATCH v2 0/3] sparc64: Randomize mmap base and PIE executables
From: Stian Halseth <stian@itx.no>
To: Magnus Lindholm <linmag7@gmail.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andreas
 Larsson <andreas@gaisler.com>, "David S . Miller" <davem@davemloft.net>,
 Kees Cook <kees@kernel.org>, Michel Lespinasse <michel@lespinasse.org>, Jan
 Engelhardt <jengelh@inai.de>, sparclinux@vger.kernel.org,
 linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Date: Sun, 18 Oct 2026 23:08:33 +0200
In-Reply-To: <CA+=Fv5R31wpXsm-7_H7ZR_U4ASubis+_zWKotpj2iNeWW_MTUg@mail.gmail.com>
References: <20261018122734.2594904-1-stian@itx.no>
	 <e3068b5c97884032e7cbd12c78f6b5534d75e30c.camel@physik.fu-berlin.de>
	 <6e2d2b2b7aa4029c261831016d8b6c40bc335341.camel@itx.no>
	 <4f7dacd9b4cf0a43209be84f2408e6f7e033fd3d.camel@itx.no>
	 <CA+=Fv5R31wpXsm-7_H7ZR_U4ASubis+_zWKotpj2iNeWW_MTUg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BufmEGetig0tO3gMlS8x"
MIME-Version: 1.0
X-Stat-Signature: bu4bw6tdfrzhnhewfp8d1xz1dpdg4qjp
X-Rspamd-Queue-Id: 77BA9C0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792357718-774924
X-HE-Meta: U2FsdGVkX19lCaM1dkeboudnYcB22xEinKKPJETEud9Tq/Kd61QNxpH9jZtwe+JybDWi9B4wYvp+SU/g5xYRFZLM8aL9v6szSWd8/loDcIUA4b0pI87sRlr7MfKezjsxN9MWw4SW5BgzCYGxfyB9tXsRZVUfis18fW2hfqA/G0EiAqpqpdrjhKa4LrJbnfs25DSyLOCjUXaXkS5BrjJC4BqlSGkZPVl0t0IsjigPNoQ13LkwEynYZFdjpWLBZP9BEoxSZ8YdeHka1yuO4NmNStiTnhi+/tiWC5kiP7/HoG3L0WdoNYVCMQCDPRAjOCXq8LZ/Eg5M48HsNoLbSeHJq6RJHzNk1nqyoB9ULZiddlJ2wpb6+uIP1GevT1QhDFf8bF7qyAeqU+eCQHPO2/Hn2B5hqjvPn/omj2krAN15rO/6xx37YqV8YPjGmlSNECpT8PZI7NgdBJ7WbL/EHrrSrj24dMmWzvHJX89GM8+JbSAvSYLQYZ3ZSBef/gKlCpF3IGygsZKbaEZdu7tDXQk7E0AeJXjPxxA8x8NpfsU7J1ww+fyWlCIiQgSvBSu7LZWPGp1nuGnCQDCYly6Ma5nfofTjgQG7hy2R26JPTqkkc5SHtDmy/X69uuOp8po9YwwEEc1p+3oVC1olke3Ww25mOGKfgfJllHpMMcoppQUOOcPuug/6xoln7CzKo+620Zj/e+1P+65lOIKe3IDE2LvtJ6VEhuuQ0Evlw8BO+TgB9jtGx3nemegyMx+/7pYOpEr35ejma0L3D7bQg9rAJEb60vL22cJsvbdaU0QPc+5w7p7LVc6eo62KOWh6BOJfGZ/lahK9FhktQkGo0pc2CxczpM6mbK4JVdim4crdbb7vGGGRcbsTuqdIIXVbT0vGoxxY27+TSKCnPRB/s5YWC1buTv3XYJ95QzpciF0beQYewSKxfo+qRQIOf6QZdihkWUSm3U+nhEbDB2x4GeaO9Tn
 qSriG8qL
 CfqkFLi3ngxus2P1LT+84B/KtFywm1LPi2jZf7HM5QyWhLK8wwP49Hk3hKatiivpydR2BKAxX1k2ZlUi9Pr6GVb/8DZHDjxG4gN3s87cVeUvaT3ISt3x8A0s4lVvdIVrCY2wRgQ6+tSg4Opj1JG7udzq5q9IjDPifW5pqflr465Rly/NZkbtOM+zc8Bk1Ph3QvydUiGzS8MSQPDNWYr7yDk5BIcY6+loxLMUktZ3qdHm0vfMDldR3FF1maw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-BufmEGetig0tO3gMlS8x
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Magnus,

On Sun, 2026-10-18 at 22:37 +0200, Magnus Lindholm wrote:
> >=20
> > Additionally, outside of qemu testing, I'm a bit worried about
> > sparc32
> > machines with virtually indexed caches. I've heard those can be
> > fun,
> > and I wouldn't feel confident about implementing it without testing
> > on
> > the "real thing".
> >=20
>=20
> Stian, following your exchange with Adrian, would you be willing to
> put
> together a native sparc32 version? I can test it=A0 on my Hypersparc
> SS-20.
>=20
Sure, I could do that.=A0

Ideally, I would like to get this sparc64 series through review before
I add anything else. Could be a follow up series based on this one.

/Stian


--=-BufmEGetig0tO3gMlS8x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCatU1UgAKCRDoeAEuJe36
VuVKAP0cSMBZ6SDTS0DWLSLchPoPvpTgLEqfXS7kPSPasheALAEAoQhUpdtgBPTz
CjTIY7tHgOlE9Q3FhIYspzMtpED0dwM=
=BgY2
-----END PGP SIGNATURE-----

--=-BufmEGetig0tO3gMlS8x--

