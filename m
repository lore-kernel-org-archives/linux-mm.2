Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D851ACCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 13:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5282D6B0088; Sun, 18 Oct 2026 09:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8D26B008C; Sun, 18 Oct 2026 09:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEDB6B0092; Sun, 18 Oct 2026 09:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA3E6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 09:33:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EF99A0546
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:33:39 +0000 (UTC)
X-FDA: 85335839358.07.C993B85
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C730140003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:33:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=BiS4kDin;
	spf=pass (imf26.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792330418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQQHc8mqQwzEWaZJKjdUsWnAkv2Pj7ElJzu+1c/Y+0s=;
	b=cFQhvySvmSGZRbbQzu3FDGeWggtfmVoJGzMwmuSj/uZ6Wer7eB/TqdPXX5NEb9erJjkTW/
	OGaPAi/GhT4AwxXmXbPY7xH3zS3zd4ICK/HNWth4MemnwUULhoyg7hW/1Veb1Ez+kQfPuk
	aMIg+9ehnPNOYx/zFaAwv4tlbmEb4HI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792330418;
	b=ims6+vrPgj5+z/VuktDU+MhSTs7NZPf4w3Nnqmr8+LX430g4ZGlaI4dG60ZyZQ9eiezP9v
	TqFS+drqPNQjxpKR9yhf6PLRUjn3SK74eIOfxLmqYuRark0/5snQslrhZKF9r7fEyAFpQm
	Mce0VlLIcTH4Xh0n4i2jPWN0/31ba6A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=BiS4kDin;
	spf=pass (imf26.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
Message-ID: <6e2d2b2b7aa4029c261831016d8b6c40bc335341.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792330416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQQHc8mqQwzEWaZJKjdUsWnAkv2Pj7ElJzu+1c/Y+0s=;
	b=BiS4kDin0j8DjT8+hG7vAf4x5wPII63Po2he4KcBSryhUiXa5G20MxsgjOMRqulB3rq9yW
	vcx3yVrlzrFOkx2P5nqG+ihL/r30eWeGeZ9TV0ajYl6ANaQcheFjI/8ImujmrA1EoRbK1K
	aHDUXh2nSuCmdFKIcyhkDiMquf4tQgw=
Subject: Re: [PATCH v2 0/3] sparc64: Randomize mmap base and PIE executables
From: Stian Halseth <stian@itx.no>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Andreas
 Larsson <andreas@gaisler.com>, "David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>, Michel Lespinasse <michel@lespinasse.org>, 
 Jan Engelhardt
	 <jengelh@inai.de>, sparclinux@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Date: Sun, 18 Oct 2026 15:33:34 +0200
In-Reply-To: <e3068b5c97884032e7cbd12c78f6b5534d75e30c.camel@physik.fu-berlin.de>
References: <20261018122734.2594904-1-stian@itx.no>
	 <e3068b5c97884032e7cbd12c78f6b5534d75e30c.camel@physik.fu-berlin.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bIu7sUj6+qWNPVLdLyj3"
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C730140003
X-Stat-Signature: 4dhcc5ic1o51nf59idz5by4ki6zfx4wt
X-Rspamd-Server: rspam05
X-HE-Tag: 1792330417-432732
X-HE-Meta: U2FsdGVkX182xFYaUv3JuZp0fY4+OgwIf50M+YKoFzsVfUaNg68y/txbZi3I1VfRTBS0Bk0j5lKB8Fo/+kg/uliCwaY5IliaeOMghYFw9WyzIHD1zm3/C/0e5p6GWMQcJ4cse3ztP3Izw3CvsmgKQoI7ZB1AkAhPiVEQtDqVcvvxGteTqvQcO7bwDxFglpRv3e8SfpTpp95Gm4P8UH2G/RU4tuJM8PmnMdVg4iWqGYLuejCSk1QOn9XZpIJQ8I/cuxtZAGpxiwObehvzeT54ClNMg2Wpx/NwOu/j8Y2CsGlj1cEM6L+eC5KsQ4rwxAQPiBzKgYvsWFdRb10l894apeP7fAj2BTF8Fe+l0WA8jTRDdoiYHmemXkgqxrod7XEQ5255hJ08drzvs8ayh4187FkUQk/V050v78W5seeMd492Uk0nIIRR4x2LUZLgkSSZLC9kSqwITIoRIUtctzErRWX7L2AfYzafx3BbfieibJljeHMHvR8cBXaYKCuDIj1lAOofLhUjE9MOJOH6W9PDz8UFyQYDMaA70F16CHg75B3xmtsa4sAFW4yY6NNLe2Ku+IcaSC+JLH9AFpgHBWW3Xx/RCM/k+PQZ+sRnIybIpmY2azJbjUJCQ3kn2iLO+eCs/GYnIQX8x6azDn5HhlYpmTsB7g7T5d9LxCMrmQzYCfSABHgU4Tp2scpMqf3Eg8OXwVMeIp6oU/dpAjP3YtsC0wJvDHNxxoiBXiyH0wzIl/CND0Bm81yiwBB6ocFxOLeb3g+iZmBwnwa22MO18lEqGTEXcBHM1et8awyJz/40JFcpIIR+f5uAw6uE25dcrGiOEetzVeQQNnsqzNWNeOeuq2PK3jDtbPpeJAoJciUeAtCL+KVrqugI8wTmpCPIa2K9QIQ6EXulAslkgIjjA2TFAsSQeALPyowO5NsZurzW5WlAhXaB+bnpc79PzTfxykogxIxgbFKefzGz86YbCOn
 4VA066XO
 yHN6eRS4gyrOL9gYU2XwltJH/zf4y4D1qYzZHRSdnx8Gk1Auu5Hf8yeYarKxvox9oshuN4lUREecCt8eIWiTmi5DQp+E0SPsJnKIJQJnqGD/z0NLoecvEx6te0QiyUOTFFybZZLw16UKIZMoD5m99uMpc7z3+JGsui2vKDn21iC0C6hh8JRuaUGwNhT76Iztf//GAsYx0pehjCdfoxwXSrFDs57PmzGL58aipjcyCqeRWINUiRrx1nL3JnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-bIu7sUj6+qWNPVLdLyj3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Adrian,

On Sun, 2026-10-18 at 15:09 +0200, John Paul Adrian Glaubitz wrote:
>=20
> What about sparc32? Does it use address base randomization at all?
>=20

sparc32 is at the same state as sparc64 was before this series. Only
the stack moves.

I've only tested 32-bit programs on sparc64. The same approach will
probably work, but needs testing on real sparc32. Could be possibly be
added as a follow up, if someone with sparc32 hardware can test it.

/Stian


--=-bIu7sUj6+qWNPVLdLyj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCatTKrgAKCRDoeAEuJe36
ViR/AP9tapuPdb5PXwlCO57ZKvq0FZAci5TKBLwYZdBFllCb5AEAj6ZOxLutAtOH
qbE2uywIGrfhHh3lY+nx1C7LstUqPwI=
=x5yr
-----END PGP SIGNATURE-----

--=-bIu7sUj6+qWNPVLdLyj3--

