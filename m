Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 386B2CD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 23:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AE16B0005; Wed,  3 Jun 2026 19:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BB56B0088; Wed,  3 Jun 2026 19:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322046B008A; Wed,  3 Jun 2026 19:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 200AA6B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:43:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8F808BB53
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:43:18 +0000 (UTC)
X-FDA: 84840230076.02.4262145
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2711014000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:43:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b2SxwCAX;
	spf=pass (imf26.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780530197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJOCvVpZsw8l7bsR6W+LUIVzrEEh13iW9pGyOSTcxE4=;
	b=h4quwP2YtCzThYWp41z+Q/8TWdCMpV2LViUoA+Na4spKcPEtyrA4AchbX2FUnsi0BJQh/0
	SYUqJ4NkBZc/vWPJMTUV9AvJN2rmw9dZqb7pN7J6N/7NiCMciELVadOh+1AQ46EYSeRSgS
	S3VQLGgwpi6HymQqTrCiwXdsoSxDvzw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b2SxwCAX;
	spf=pass (imf26.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780530197;
	b=0OxFk+hQGT3+0VfPRw+TKDAgJaH0pIKGa0jSUxBz1Xq8+pE0FG3DlEKC45vsGiz+DasGvL
	7mEJySBYfCSyqsj7dL/1t68sbbZ6DqBKj1Sy8M8vbl3EiusEetOfKhUcYcstArvQ0CiFRM
	1Q+BV2+SOSRWwNTB5X5cePDeQRCMcd4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 743B0601DD;
	Wed,  3 Jun 2026 23:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169921F00898;
	Wed,  3 Jun 2026 23:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780530195;
	bh=tJOCvVpZsw8l7bsR6W+LUIVzrEEh13iW9pGyOSTcxE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b2SxwCAXl+z/vJnA046cxZ1amLOruSa9uLUMV8rOFXG4AqCX6R9OWmpTjrhsKEAia
	 DSlJYr5I6i9QkM74i0RYc4O/XY7yY4i4CNcJmSFwWy76yGcje4nFO9YQkE927v+DWb
	 11eMRvo98J8NMWSpEjydwsbkm56t6lTBlovhQxaSaNdhiXsaW4TOGtR3jwSSxQn1Kc
	 L9P8nXnB3Sc6ysfdguKsam3YGWz2LKvdEVt7KiZvU2WZlBPZaDerjUxUBcC/l0hp8p
	 cv+cyi5m7vYchI6w0W5UasLZ6lYaEnfi/rqyhpsrKi3xsFkyfBUAlh4PQmq8vvIiHG
	 Rq1Nb0mzF40EQ==
Date: Thu, 4 Jun 2026 01:43:12 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 4/6] UFFDIO_API.2const: Document
 UFFD_FEATURE_RWP{,_ASYNC} and 1 << _UFFDIO_SET_MODE
Message-ID: <aiC7-UNDrFjWt7oT@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-5-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wunyxer3z3xur6ve"
Content-Disposition: inline
In-Reply-To: <20260526134149.2831720-5-kirill@shutemov.name>
X-Rspamd-Queue-Id: 2711014000A
X-Stat-Signature: ubxfbabfkbocbnzyuau454q5sxk5sy57
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780530197-97983
X-HE-Meta: U2FsdGVkX19oneW2bNrbtMrIjelnJSUhEQlIpRjI0XxM3WuLD3ixlGKX43ttDzAfItJeIuNp4eRF4fMsgB5DL9go4EGwA+IPIAlg/wWURRIDn1UkZeJpAHY0JVVEooEZcX1Y5VXTc9u6d5HR8Iq5BnuLEHcNa6HJ98e5Qgk9YRXPnTRz00600Ls6dNxN1ymKlyLNnf697JMVVO984c+Kcu5vnE5bnhcFpcamtaUc8vL4vvgThTD/iP0y4wd615Yh/nW+f75zss0NjeabjsaJpCtoP+hpqIkxynHqfYG6/EQjryyFfxq3sH1ipT9sX1IRiOzWeHiqJA/2L3XG4XTXD3bYVZBIb6uBi/0LGELkUzewu0jqrzrUtJOWiXGQMR0NL8CXlWTpZrO9DWVJ3Sj9mUqYzuTiqC36iv+wR+AOqqBmyInjFsnAvQDIPwXhcMri0pUUxZ7T6annzJb82vM2HYIXgc2Fw7igg9abG3z/l8UTY2uXXLKFzqvyQvf2vVqtNjtCbMuCx7LnwI9qxTwkWzLZ64lKyWKt/KvrG3BiN410aedBevGnKGZuxwYegDASi/DM722GnCiYOc3bXgGPMseIbagfUnw6WnBJ58NUFK8AS4KtQFXOnwfwapPmh8yMno8VMH6ynAuMipDcU3nyo2wAMlujCo5TYcS3Co+veneD6+3j7JIQbAIW6uS9HBR5pvafzUdTzOPD0Sdzmxvxlj1vYg4eCpFYYbmDibAgjW+XFf68xLOB8qTSSJrPhrNYCdbeaKlALEV4HU9U/xgegmZKfg1vIOAfLfj0QfNfg0kSbIiXhsfjiimReP9qp49KLIZJpI2RKI96aOUbNMpZq+uRgam5fvmVS9zCXV5x9D5DVf1+W7iHAiWcKpTnHxbGMkRUGEH41KrK+2usvkzoosJ6BaGebLcaBy6D1GF7EQR5jFn2n4Nr/EAc2SVozQl0fw3Hju16HPbj/n5HoMJ
 7QqZSICU
 UJIS3nLzHev4Xkcd69Mdzhi2PpzBvGjI9pThME8ZCFZMkig5wtjuNV2EiC7PP0zieU7VPrAeDSvfg2D+HjCDw71g2E2WIh+SkQ/xOAEU99Wfg1uOYJPVRd0mLffKlMZilIUX5t9kW8V+25Rws2mAeHfUtfzs6wqqCu550HnjNfEnSeEhEsM8M2+QzNNXCtKOrA6VERG2JRYyFQkkWBgv2uVyJwdJpJdcacV3BnB5qER+VTYsSBtNYf7aDGPvbnl/ZDqmpzzWZcgwEYXXgkwYHM/+fjqk7e1eeAmB7YN1rBRxAL30U7F3GRPYuNGNXH1J/COSpPdFVRAcDq7KeRhc3qaESZeBnhKMXMFfiag5VTKLcKsIWznYvCi/qgQlQDsQAG9JtRL0QFmcX52oKp/IetbTmY6/Hrr4tze30lSxwgSinFMsr9VSPZEszTJ18L8TASpDmc6QIjmYVKOcYFl+M8nQBR9FRovSCUO7F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wunyxer3z3xur6ve
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 4/6] UFFDIO_API.2const: Document
 UFFD_FEATURE_RWP{,_ASYNC} and 1 << _UFFDIO_SET_MODE
Message-ID: <aiC7-UNDrFjWt7oT@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-5-kirill@shutemov.name>
MIME-Version: 1.0
In-Reply-To: <20260526134149.2831720-5-kirill@shutemov.name>

Hi Kiryl,

On 2026-05-26T14:41:47+0100, Kiryl Shutsemau wrote:
> Add the two RWP feature bits introduced in Linux 7.2:
>=20
>   UFFD_FEATURE_RWP        gates UFFDIO_REGISTER_MODE_RWP and the
>                           UFFDIO_RWPROTECT(2const) ioctl.
>   UFFD_FEATURE_RWP_ASYNC  in-kernel resolution of RWP faults without
>                           delivering a notification; requires
>                           UFFD_FEATURE_RWP to be set in the same
>                           UFFDIO_API call.
>=20
> Also document 1 << _UFFDIO_SET_MODE in argp->ioctls, the
> file-descriptor-level bit that advertises UFFDIO_SET_MODE(2const) for
> toggling UFFD_FEATURE_RWP_ASYNC at runtime; it is independent of any
> registered range.
>=20
> The existing page intro already describes UFFDIO_API returning EINVAL
> on unsupported feature bits and the temporary-uffd probe pattern, so
> the new TP entries do not re-state that.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!  I've applied the patch.


Have a lovely night!
Alex

> ---
>  man/man2const/UFFDIO_API.2const | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>=20
> diff --git a/man/man2const/UFFDIO_API.2const b/man/man2const/UFFDIO_API.2=
const
> index e894114bb8e2..46ee7e31fed9 100644
> --- a/man/man2const/UFFDIO_API.2const
> +++ b/man/man2const/UFFDIO_API.2const
> @@ -213,6 +213,30 @@ .SH DESCRIPTION
>  the kernel supports resolving faults with the
>  .B UFFDIO_MOVE
>  ioctl.
> +.TP
> +.BR UFFD_FEATURE_RWP " (since Linux 7.2)"
> +If this feature bit is set,
> +the kernel supports read-write-protection tracking,
> +and the
> +.B UFFDIO_REGISTER_MODE_RWP
> +registration mode and the
> +.B UFFDIO_RWPROTECT
> +ioctl become available.
> +.TP
> +.BR UFFD_FEATURE_RWP_ASYNC " (since Linux 7.2)"
> +If this feature bit is set,
> +the kernel will resolve read-write-protect faults in place
> +without delivering a notification,
> +automatically restoring page permissions
> +and letting the faulted thread continue.
> +This bit requires
> +.B UFFD_FEATURE_RWP
> +to be set in the same
> +.B UFFDIO_API
> +call.
> +The async mode can also be toggled at runtime using the
> +.BR UFFDIO_SET_MODE (2const)
> +ioctl.
>  .P
>  The returned
>  .I argp->ioctls
> @@ -234,6 +258,13 @@ .SH DESCRIPTION
>  The
>  .B UFFDIO_UNREGISTER
>  operation is supported.
> +.TP
> +.BR "1 << _UFFDIO_SET_MODE" " (since Linux 7.2)"
> +The
> +.B UFFDIO_SET_MODE
> +operation is supported.
> +This is a file-descriptor-level ioctl and is reported once per
> +userfaultfd, independent of any registered range.
>  .SH RETURN VALUE
>  On success,
>  0 is returned.
> --=20
> 2.54.0
>=20

--=20
<https://www.alejandro-colomar.es>

--wunyxer3z3xur6ve
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmogvA8ACgkQ64mZXMKQ
wqlarQ//eMAt6WsJqSanByepNV8+Cstsgy3LY20DPwoH0PdSVVLpFsXpDMSntB9r
76LADHa0ruwhClGSdIQ/K8aE0E4lbbfpdMF6DAVGcCiNV/tB7Ij8l5eZWraj+Ct2
KsT1p7K4qmO5RRsDP87qUgVRPgAcYB3AOn+DouJnTV3/8c26fkSyMH6ZQQK+VzLy
2ZYd7istnBhAuxAPNt7mUyz9OwtE8R0qqS/i8fkQJYv8BA1MPxFk2uPf7GVbHAmu
QX0bIXxCPHpPNfejwLsXNTONohQUROGihZyqHOzxeN2sd2CGiKhPv64A+HCOrLDA
CUrGdknPQSZAVR4tiGf42Jm3ym3gd577KCTiiZprklpzzr54gQg5y60NHHsW0Ifp
8btLf6YrDFDv4xfn6Q+z9HH+Jjr4nB5uejle6vkXjcFB1n30+w4FA9nr0IG+1WPY
yHTN+xgo3sTS7uQRzuY5woQGkuUvYpyzykVy+Ww0h4ObP3LGPye4SbrelJmTdoo2
SP3EQcU62qP5f3tcd8lRSbXkzAmM2RRSAqK8ge5jB7xwODbW7ED2RYjJSWNU9pVP
OBUbYgHGY4aX6HKZNxyUOjLldA53dfV2rgAJv4fPsz79djXQpNI2/jRoU1JwHZVK
OCCskVAkXClfLKzaLC+U5mTgDMoD0QnIBiUIG/lEv6fri6LdrP4=
=2JWI
-----END PGP SIGNATURE-----

--wunyxer3z3xur6ve--

