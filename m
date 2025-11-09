Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6345BCCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 19:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A683F8E0005; Sun,  9 Nov 2025 14:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18C38E0002; Sun,  9 Nov 2025 14:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E868E0005; Sun,  9 Nov 2025 14:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8558E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:18:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29CAE160A34
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:18:50 +0000 (UTC)
X-FDA: 84092030820.19.1C8F72F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6FEFF40002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:18:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J45COeLS;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762715928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6k1wxnNPVq6vKcrImObaKCvUAiOssPA0aelIExbpVaE=;
	b=w0HFS7uOabLYCfyGN/vFv46N6xB2Ct3u+FWiVwatqSWGbZnJ/t/zSJIOhV+jNdWzmrVWyH
	anGhv4eqWhHMVzO/qR9GtXRhChcbmCUJ2zwnqKC3Jagt1uzk8tKHUyZEBVBDE0KTo966Ke
	X2q1ISzN67wm9iwBf0rRcMYUS1zGbIA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J45COeLS;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762715928; a=rsa-sha256;
	cv=none;
	b=5sVI6BJfNoS8mCYLbk8voZ7sLtIrk1KiaqXu2rMFAtXlf8eqDXAx1Ho6+EV38LdlDgcVyD
	ovZ6YzF8e3GD0pvNZIkTWtJCVgN7j9XGzcBQD3dozpVmUCEoy3bpCJCnPfLxbuUEQokoyV
	pClTcx6xC5EcZ+i55ev6VpmVUbZlTj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 394EE407A6;
	Sun,  9 Nov 2025 19:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC68C4AF09;
	Sun,  9 Nov 2025 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762715927;
	bh=mGFvQbV410JR8d38Ezb4gyjc5nTCZrcnscZyJrRogmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J45COeLS4iiRx2lGH1UmcAlTVXtMps6JMUVjoumd0oykEBxIGguvdKu886OnkWZpj
	 IfL8axmWB3ZPtmdF2LXn2HJLlAstacUjMSujpNlHBuFUtfR7SU55W1i0UYKEi/Yi8+
	 qYOEUZDTrVKHwOf64cXcCDNcEOdcv6kFzQZfZBo8ggDjyo9M72bSJFBkTgLYC/CYyO
	 XeuHhkK861vtA6Ll4jA3H42vuXzVB66Yx5joPMQ9eBAyG+yNEq6GagFHhIWbjTZWDS
	 brgNwp1jqifaHGmotw/4+GpFI7okxfqph31kBH2dtBGZx8bduPYUbvEsVwlJrGFXr2
	 KvLt00G2ojF2w==
Date: Sun, 9 Nov 2025 20:18:41 +0100
From: Alejandro Colomar <alx@kernel.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kees Cook <kees@kernel.org>, Christopher Bazley <chris.bazley.wg14@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/4] array_size.h: Add ARRAY_END()
Message-ID: <amjs73mcxeq2zcni5rkbbugm7jgboejrtk6qxfov76hr2fca6m@zjdljyhkkaqs>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1762711279.git.alx@kernel.org>
 <2cb4ddff93b3d3037ef8d094de94227982117f87.1762711279.git.alx@kernel.org>
 <alpine.DEB.2.21.2511091903580.25436@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2mnclewibysqbpeg"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2511091903580.25436@angie.orcam.me.uk>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FEFF40002
X-Stat-Signature: uhchg7yrctejgzckjsyg74keiskmajw4
X-Rspam-User: 
X-HE-Tag: 1762715928-514236
X-HE-Meta: U2FsdGVkX18ZzinX9N6rV5YwA9xePgJ2c3qrPB/D+5WjrgQMkG77LUouImKlaHxneZrO025WIGc/tDIKvWJO/56BVs7I0x/5QJEemCMeGV0ceFrANXgYpPtqT4gNALe4PX+TLjgzz98/qXDTmMfkfv8s8c6OXGcwjFzcDI8gsZbHn9+WtOlbd9nGwlfn+k0JVySzkNxRhC3hkR5TFX17nTiy+iXjFmVxebNHfNhQxRjk1dH/6jVW02nEYdPdalXoK1CNHJFk9DhB+ZH3cPjjX9TNOckjmN5i3a1gNGDBWEiAg2ZpCDCZ8U3UIYZnDtIVLwpbKGTRnCwoJGbeoJvtQQYG9T8RlfZ1JcUjgxFBaQiY33osAXxR7feCJR8Wx/6RHUMUShQSQMBTi+AQaK8471eLiU4y8elFvpyeYxw/eOJSoK17tubqzatGSRbi7P0lSwnQS8A3JLAghKy4B9sb7iMhGlFsqoqT+eUodVNgzTxVVUDVP+V9d+Cu9XYnzOqHDrCUn2cjFXnc+VSLgs2UVMLfPk9H3v6zZf6MXJQgZFGY96vuuM1c7lIGyE3bE+/oemhEKvoF/T3MhifcpcRD7WrjYL8U0jHdBSKV7/M+1R4/urucdPs7yP+d3j0DU3a/sgziF6309AKhskgFvpUUGnDm0MJdbURe6F9O0RqSZ9vGLLFhf3vs5nEYh24chrlK0EVC7SJDc2AGqOi+zR+GZEHqgQhPyzChwGnto3JA7y8FIZBVREZCwsPItUhazlHdm72Ry2Frpsi8BELILm1JgtnGa0tcLEgXAIkjntm6eDIsVZgY8zWJOGov/ckTNnwkrzdYzaJdcgJHm3r8x5yjtMvJqL+vfbjofIaagnBu7cshEq84AL5hmQq+SPzYw89R6srb/uWzEv80itysS9c/YKj2NbB4fiyr/i9UPMff+Tl1Vhr7FeZNc6xs7yWC/bwgJPPgX0iCInIgiiOzgZu
 ma9XBiE8
 /jz5GqfXNsKqs4+5puMMCw8GC3j7m4y4vLfv1iREfjh/p25xP0lTRMDkBhhsxGF5l4p2zOMOyuu7Jahf8K1oxclEyu1CJelUHmt2ouDqOa10mJ/MkkxlIJjGyMNz4fVNQXjAG12UDvyiHFyEcVkszmbQSy138a4+MFIyGKyaTxkipGaUH3H5QskdnEfWvhcJeMInxkUZOVSODbm9F0t96Nu6HsPwqFFjL+p0BrYvX6ENAn5+MjF9Qru7c0F1vhvTf9zR0fDH2Br0goNzJVeHFOqqDHIRuyDPQDskhU32gGs5bPhjwgwEHUjhLU171nqTIhVb+LrUE4EIvuIG/jukH9KLfDtWxhlCyMbUJunGGdJqHFk9/y0ukMYKEe0tzoQm1+EYOXERC13np2u0Z+i3oY4XRhwO5DsdXMxrRLBDKiopEhn+PfVjaWrob8eqoEiP4o73gnpPohr1jdVnRrHpj/Dbakg6LALwwEglBPSg1PX2rxMkFORI+ndUTtKv6nwuLdpgIjL1lMjQBPwH7WxNAPupetw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--2mnclewibysqbpeg
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kees Cook <kees@kernel.org>, Christopher Bazley <chris.bazley.wg14@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/4] array_size.h: Add ARRAY_END()
Message-ID: <amjs73mcxeq2zcni5rkbbugm7jgboejrtk6qxfov76hr2fca6m@zjdljyhkkaqs>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1762711279.git.alx@kernel.org>
 <2cb4ddff93b3d3037ef8d094de94227982117f87.1762711279.git.alx@kernel.org>
 <alpine.DEB.2.21.2511091903580.25436@angie.orcam.me.uk>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2511091903580.25436@angie.orcam.me.uk>

Hi Maciej,

On Sun, Nov 09, 2025 at 07:05:40PM +0000, Maciej W. Rozycki wrote:
> On Sun, 9 Nov 2025, Alejandro Colomar wrote:
>=20
> > diff --git a/include/linux/array_size.h b/include/linux/array_size.h
> > index 06d7d83196ca..b5775b8f13de 100644
> > --- a/include/linux/array_size.h
> > +++ b/include/linux/array_size.h
> > @@ -10,4 +10,10 @@
> >   */
> >  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_ar=
ray(arr))
> > =20
> > +/**
> > + * ARRAY_END - get a pointer to one past the last element in array @a
> > + * @a: array
> > + */
> > +#define ARRAY_END(a)  (&(a)[ARRAY_SIZE(a)])
>=20
>  Why `a' rather than `arr' as with the other macro?

It's simpler, and equally informative.  I wish ARRAY_SIZE() would have
also used 'a'.  On the other hand, consistency is important.  I'll make
it 'arr'.

Thanks!


Have a lovely night!
Alex


>=20
>   Maciej

--=20
<https://www.alejandro-colomar.es>
Use port 80 (that is, <...:80/>).

--2mnclewibysqbpeg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmkQ6REACgkQ64mZXMKQ
wqlxpg/8DCZ43s63Y4S4kHX7NRY5OVoa64fFe+SDhiM+Aq3FGWYWusa8kZIHgo86
/lLSLyZwQciCGXCENn4yiKkCYv76FEiCZY29kelAF4sEf4perL4IbX4MrChkWSLO
LcFvRC6qs52Qzp3Rd3c3sImkcz2Cbogeku+w3W1n2G5K7DL8O8qrcLtFYAZTMn1u
lQMCyBfh/izbE0ymjYnlFk20VansUxSWb7V534tSK6cezHfHCvmoimAB5pe1psPC
e1H4uSP9wiXoG9Td/WylTu2JGp7WF/c/3vwEfYYYD24QvgW9nvBiP/WsSqBx8I/E
tihbCcT3oiL7rhcXcebnJ25Yea+tPMbaYIvq6UT+8exXWRwf37j+763w4lfrxIiz
1ux+b11LsQ1gMKidaGMdfz6IMJvVX+f2mkuTQxARS9f7tqIiHSKU4TDKntReDsiV
gjh4yjNrX2kDnj4Ss7hkPbRNzyh048TKgk4fnH2MUDRTyR0rI2yGqZ9HbqsAMo31
+y+07K/VjAQLSNeE/P8a73QjZFm7SR0kU5crpuTjonCNGjQZkw+EcZsCvZcTFV4R
hvzJC4S/v5rkfPOguAGOM1CvJXGrYiKH91JnVavvy8toezhEmO16Pyge8aOralaH
YlX1X+n1yY4VKuxDfZxd+cwzMzIvns8du+xNCOrJvUy49YkQPMo=
=e0eB
-----END PGP SIGNATURE-----

--2mnclewibysqbpeg--

