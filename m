Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A67CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73AA96B0005; Thu, 28 May 2026 07:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB7B6B0088; Thu, 28 May 2026 07:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC956B008A; Thu, 28 May 2026 07:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA756B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:48:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF741407D1
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:48:43 +0000 (UTC)
X-FDA: 84816656526.29.E25965C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5798F4000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:48:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e79SGiL4;
	spf=pass (imf11.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779968922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jtbdOj7dZrbjiLwjaaye4NR8UuAsQaAsdqw0x+wMVeM=;
	b=g66bEPbeV1m5Lp336810cp2yRsc2R7fFnUtdC10H1Pedn8K+WAuFA0c8kNHu/RkuOTPPTo
	75yYyNMdMA8/W0gWCJM0fFVljCByiPiR4AxtdZWIeYL+TfwVf0f6AReLSBZpyikjl2q7nS
	Aw4MDjkAyy5zEiQSOfM2q/TOZRAnkl4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779968922; a=rsa-sha256;
	cv=none;
	b=4eddj+wTXxqqbB/UhnwD5cM5Z2hLVdiXV8Jga0AjFmsHVppYwq11gUuLd7t4Ya79O3JDB9
	9Jbgpb2hNbAnB7JvMEkbfmMbjQP7hiVajh1VtS0etLbKLq2B3rwSKfy9FoQNAOMzJdBo6u
	uh2Q8vWxBwFQyRU5xkVLKkhLdkziOGU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e79SGiL4;
	spf=pass (imf11.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5536601DD;
	Thu, 28 May 2026 11:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B081F000E9;
	Thu, 28 May 2026 11:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779968921;
	bh=jtbdOj7dZrbjiLwjaaye4NR8UuAsQaAsdqw0x+wMVeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e79SGiL4GzTsOLjx4fZH6K3UfBGnomyIpw08Vpi+p61jwIX6Ru9LlRW7lfVQam9LB
	 UpFLHUlEFEMqZcmyRgtfXz91bWZRHzxyP/KUzpgeObI7d5HDvqpQlM2e/b7JS+Ti2f
	 t9KrpB/kWSoGrt01WMGXpi3W8JIB68rISoiEwLcviSgAs1xNc0DH8Eq8t+acQkDG8i
	 V+cz01xeZRtlxbWRLdWxO7ftWIQvjIiFVRCLL7gax6zNAkMQEhxuugMYFuu2P7WL8Y
	 VOhTGnPkWQWcZGE3gssp/5fD88dLK31DjT14nzHdGDrWaUxFrU6AKVnco6SEe1efrO
	 OqVsyUA8bf5Xw==
Date: Thu, 28 May 2026 13:48:37 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 3/6] UFFDIO_SET_MODE.2const: New page
Message-ID: <ahgricY0ShOw5wR_@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-4-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bsg7w76kuxswidxj"
Content-Disposition: inline
In-Reply-To: <20260526134149.2831720-4-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5798F4000A
X-Stat-Signature: awzwfgs4xigfhtf3qidc3cxtz69ai4ii
X-Rspamd-Server: rspam06
X-HE-Tag: 1779968922-624272
X-HE-Meta: U2FsdGVkX1/+mobEeNT3Tosss4YDBDo4KIzNVGYiJt2sA2Kp2g619n4NjOtmWRWIJtrmFJYTC5hfJdlVGx/MIeWTpPrDJJSRaxxv9hKDrr56cEbLvdka22mrnLf9zUvG2yDXNxWvltKcflfFxDY7IPAGAcjun2xC2Go6b0+fWk3Flu+EKt85u8edjgB8sbcIBFvBWuUgjKTZgKoBP3ZjBonOlB9CqSx+7fkMbwPWrcPDqsBZ9T3JYAY4PwuoaQ+xAgvFMFcw5+1RFcVo06rUmuwTggU5J+2+amZYLDygm8fXTMsVtynLvB7lhiYCTNF7+Rf4BJiOzkJywvVD8Xe/SrL3lECP5lUb6/uRq/YQ02pdgX+NbUOUNCUspmP7/EQxgoq0W3plQpsQb4Ajyfo9QN0+iXfw6U+ux6kU9bknpf19H6p+A3F9ht5ubFOuKZN3Z2dB6yW8SZlnvbxlhS140i3nL3DUj4wUD/CQok8FMLBaI47CaLMsO3Er5Qcz5zHePyRsniGO5RbgEswo5Alj9gmCRwGPtHT4m6zmMXvrQdQ1cQ9tTN8CqEvLouWpuISnmnB9PRRPxIwRUo7rhb3FJdWxVrDa+H8O8q+JuUsFxPmZDFbMMEcJ6OG/OQ0k8sEDdWp0eFC5CjEM1NyqU+t2UiHTN9HhkH4seOf8l6juwzlRujuKwevLUm1/xSZ20D+nbSocJL7/t9Vp3TxEvV1y14UPwxJueDWYVa1P3UNr9nlYm8rseT5JKCGe9jmercncVTsHq7FclBoOse9gDlHAyxxOfUp0fXyio9tisST14NxSLRR1581sb83T/ebYhiu+Lp1BSBPKZzkj5QZZMt8u0k2RdojEthN73b7MoQTQzDkzcZhTKVgtVf7HQyRlui717svgI1doRbl6YhSpZBbXLSjRjUxGmknrHbKkTK97ojFoUYNDPlHaeNMsVHfFOV2+0b2drKKG0uu4QjjpGZ2
 mAnvQHeL
 mSBYuYRqNyh9l4X5EbqIGFL4VERHcFObK2zRKbyLX1djsYAA6u4NipEv0OkzTf75z/rIBD44DxepOzM3SNfGRxdBqNCr6smBuWbrteiiOaJ4yoHiyxRLqOmcFcfAkVpEO0w2YeOKE76OB9evw8ndIq9B7BhYxr/XsqS+T7xf5G78J5n/E6q/I0tPUBtJXC8DH4XSuBlmHSRia4WBsDPX/XWOw/bUUDluW7SEMp4tx+9Phjom9wspi/q+3MvdA94Mv+qZCA7ozrrMnoACoGx6vwndYOPh88JEgQlrLjoe/F40ZMDTinRIaeQ7j763mC0xBXHsZl1yfcEtO3yFspWUBYHbYUZr6+OeqJZK+RnJQn+MDwzHMno6+B2gg/h0/TVJlKYRBE/wZzXeCKV5z6Kte7PtBisBydiNT5EUQsrjijJwpYP16IHqx0AZaaHLsdibYGyesCWtzGui1yHABWc1XEQNLCRFErpdf0vAi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--bsg7w76kuxswidxj
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 3/6] UFFDIO_SET_MODE.2const: New page
Message-ID: <ahgricY0ShOw5wR_@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-4-kirill@shutemov.name>
MIME-Version: 1.0
In-Reply-To: <20260526134149.2831720-4-kirill@shutemov.name>

On 2026-05-26T14:41:46+0100, Kiryl Shutsemau wrote:
> Document the UFFDIO_SET_MODE ioctl (since Linux 7.2). It toggles
> userfaultfd feature bits at runtime; currently only UFFD_FEATURE_RWP_ASYNC
> is toggleable, and enabling it requires UFFD_FEATURE_RWP to have been
> negotiated at UFFDIO_API time.
>=20
> Describe the uffdio_set_mode struct (enable/disable pair, must not
> overlap), the serialization against in-flight page faults that lets a
> single userfaultfd switch between async detection and synchronous
> eviction without re-registering its ranges, and the EINVAL/EFAULT
> errors returned by the kernel.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Patch applied; thanks!


Cheers,
Alex

> ---
>  man/man2const/UFFDIO_SET_MODE.2const | 98 ++++++++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 man/man2const/UFFDIO_SET_MODE.2const
>=20
> diff --git a/man/man2const/UFFDIO_SET_MODE.2const b/man/man2const/UFFDIO_=
SET_MODE.2const
> new file mode 100644
> index 000000000000..b71632011a4c
> --- /dev/null
> +++ b/man/man2const/UFFDIO_SET_MODE.2const
> @@ -0,0 +1,98 @@
> +.\" Copyright, the authors of the Linux man-pages project
> +.\"
> +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> +.\"
> +.TH UFFDIO_SET_MODE 2const (date) "Linux man-pages (unreleased)"
> +.SH NAME
> +UFFDIO_SET_MODE
> +\-
> +toggle userfaultfd runtime mode bits
> +.SH LIBRARY
> +Standard C library
> +.RI ( libc ,\~ \-lc )
> +.SH SYNOPSIS
> +.nf
> +.BR "#include <linux/userfaultfd.h>" "  /* Definition of " UFFD* " const=
ants */"
> +.B #include <sys/ioctl.h>
> +.P
> +.BI "int ioctl(int " fd ", UFFDIO_SET_MODE, struct uffdio_set_mode *" ar=
gp );
> +.P
> +.B #include <linux/userfaultfd.h>
> +.P
> +.fi
> +.EX
> +.B struct uffdio_set_mode {
> +.BR "    __u64  enable;" "   /* Feature bits to set */"
> +.BR "    __u64  disable;" "  /* Feature bits to clear */"
> +.B };
> +.EE
> +.SH DESCRIPTION
> +Toggle userfaultfd features that may be flipped at runtime.
> +.P
> +Bits set in
> +.I enable
> +turn the named features on;
> +bits set in
> +.I disable
> +turn them off.
> +The two fields must not overlap.
> +Today only
> +.B UFFD_FEATURE_RWP_ASYNC
> +is a valid bit in either field;
> +any other bit causes the ioctl to fail with
> +.BR EINVAL .
> +Enabling
> +.B UFFD_FEATURE_RWP_ASYNC
> +also requires
> +.B UFFD_FEATURE_RWP
> +to have been negotiated at
> +.BR UFFDIO_API (2const)
> +time.
> +.P
> +The operation is serialized against in-flight page faults,
> +so the new mode takes effect
> +only after every fault that started before the call has finished,
> +and any fault that starts after the call observes the new mode.
> +This allows a single userfaultfd
> +to switch between lightweight async detection
> +and synchronous eviction
> +without re-registering its ranges.
> +.SH RETURN VALUE
> +On success,
> +0 is returned.
> +On error, \-1 is returned and
> +.I errno
> +is set to indicate the error.
> +.SH ERRORS
> +.TP
> +.B EINVAL
> +A bit other than
> +.B UFFD_FEATURE_RWP_ASYNC
> +was specified in
> +.I enable
> +or
> +.IR disable ;
> +the two fields overlap;
> +or
> +.B UFFD_FEATURE_RWP_ASYNC
> +was requested without
> +.B UFFD_FEATURE_RWP
> +having been negotiated.
> +.TP
> +.B EFAULT
> +.I argp
> +refers to an address that is outside the calling process's
> +accessible address space.
> +.SH STANDARDS
> +Linux.
> +.SH HISTORY
> +Linux 7.2.
> +.SH EXAMPLES
> +See
> +.BR userfaultfd (2).
> +.SH SEE ALSO
> +.BR ioctl (2),
> +.BR ioctl_userfaultfd (2),
> +.BR userfaultfd (2)
> +.P
> +.I linux.git/\:Documentation/\:admin\-guide/\:mm/\:userfaultfd.rst
> --=20
> 2.54.0
>=20

--=20
<https://www.alejandro-colomar.es>

--bsg7w76kuxswidxj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmoYK5UACgkQ64mZXMKQ
wql/WQ//afWC0mC5rCJgq/i3ach2mS9uIDpeNT1GKSy/ZkRNFWr/wvf5R3m0bfAf
nYx6Tmfmv6TwAOAbihKy2aZNjaWLuRBjRP5mOMN8PgUzEGnHggIy/cynidr+xH2b
e6RlYHh3Wxr5fT35AoKV5JphZWNQ9zrS0bT+9vuJxIXCbxzPMPsFCXXP0cR4QWRN
7+Njq3bm8hu7xToOVc/gfA7JCyD5sk/r4OC0pJ0o/d5NUevd5NxIYDTldBCbLKi1
b62LwVkHR8hTWqEwsA6VxrPeDxlr60wi7Sn1RA5ithVR3cJd5Qn89dIP3nI1JBVV
qC9fyqURBnW0ueLBNH4rzOIrcKJ4M1/nwcS4cIZ2UgipjsTkI2xmcSqKubnZsFcN
LICIYr1iKlqYU95RKYY2VaSUXbG+OvUvWPX2xk2O3RGzk/2HsWzl8QzPiZ+KHQoJ
ofLfTiK0Vjan7P71l9pRtFWgMA7ixEEu0D2nm6aWv1iDfFrYwNu2tt3b/nGHlZRc
A33qtc8sKm1eqvehczgOLbYVTuCcF+XF/gZLPq8DESbqzLnZ/R00biE2xfzpBK5+
ajXR2usE6gqC9NRSEAQptkAhWtFG8Cs33NZOXHHzUnU0DyHRjaJpKf0rGCQgCl+b
BgiAAzrsIJNVTdsqmEo/zmNTUwZr2alQAIcp6/R1Fz2ogqLRKfM=
=nY/F
-----END PGP SIGNATURE-----

--bsg7w76kuxswidxj--

