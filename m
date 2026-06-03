Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12C19CD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 23:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FEAE6B008A; Wed,  3 Jun 2026 19:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF596B008C; Wed,  3 Jun 2026 19:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C56D6B0092; Wed,  3 Jun 2026 19:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A44E6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:47:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B774D120188
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:47:48 +0000 (UTC)
X-FDA: 84840241416.03.8B8AB8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22F3C140003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:47:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aq4aQsmr;
	spf=pass (imf26.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780530467;
	b=vT6GFwqOsMXJB6Q/s+nf76jkcSCaW6wZA4/OCaY7omXRf+xtEt8ntCWUb+klakQrZzanQs
	FaDFuueHdaFBT8w3ukfEFpcpQ+5p6OGvvBuBQ6MskNhVlfBXa7Ku9zoJM21/pK+GPw8nBw
	WBU/WyrsXIy8wMVg1kGhvwojgmlYdFU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aq4aQsmr;
	spf=pass (imf26.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780530467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Al31tQmHYfz89s73gvBkOqI4OUWFQr3OxgdCFp9OgVY=;
	b=Obf0mTOZHL7TvSHjVkEhA9rUnRBa8eguLIdRy7fYSbQEfKhvFsxbUxjDbJeCvr5H1RuP12
	sxzXF2NVrVX38FaFDsvgllE+D0q1G6f7YlR0cYzyPMKyYeWGxhCFFbx/ePm+fqkmKeGS/B
	8cNH7w9Px0rnZajNe9ycLNVllYR16aE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B02B4601DD;
	Wed,  3 Jun 2026 23:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909B11F00893;
	Wed,  3 Jun 2026 23:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780530466;
	bh=Al31tQmHYfz89s73gvBkOqI4OUWFQr3OxgdCFp9OgVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aq4aQsmr+K+w73eDfeM7wShWS/mWTFdXpk6OD1iL7CP8L2bqoB80O8YcrG2eYLxJJ
	 N4G92lfyRPE/DM+oDYwHY+QUiC3dRKh88ESpMMdSwM8f0HZSBP50ddM936nkJqAafg
	 fs7V+MJszBuXGYYF79PF7Jp9ICmryfBivgSRAdWVA6EHyENizRrbL99e1fctePOsNI
	 7tlkIZ+SaDzP+QsGPuPK/2Dpetd200n9dBy14+OEDly/228k8OmSyeQlD6t2mNiejF
	 xhfK7N2lzPvpwv6Z3Fb91nkXfGMWhSas9IuQh3CdiOfUc4B1DMMph9C8xpRs8tHNKg
	 tZ7iKFf2SZR5w==
Date: Thu, 4 Jun 2026 01:47:42 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 6/6] ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT
 and UFFDIO_SET_MODE
Message-ID: <aiC9Be5oxT8u1Z6E@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-7-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uqu5y4nffyhbxest"
Content-Disposition: inline
In-Reply-To: <20260526134149.2831720-7-kirill@shutemov.name>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22F3C140003
X-Rspam-User: 
X-Stat-Signature: iq8pp7ukd1ndgi5oip77wp38dom4c7y4
X-HE-Tag: 1780530466-127154
X-HE-Meta: U2FsdGVkX1+VMJY/QLP/iV3ODCpEjrNoeW4bwNnwwTibxILfBuop+2JZ+cODAp6aKSPa4CgaQzH+Q2QW+YP1R2xRrS2a/8tW00Nl6a8tEw9MXf4eyGWR3midICHlTvtCYLiMe3Lcr8SOef61KMu23JAAfYgW5bS7Co2ZASrrfevmXn6Z2tl3umEamhUmnqNlQu0tFrVUG4vJQFQ3ZQb0M7Ga/O///WjniYPivNOH+VPTCCrKi1dYiNzcYnOzJw69beRiQEnRu8wJOHIkvy2pNec2onkbPEzZIBTYYD00Ae57AUXjBGX2f6HXnDCP6FdHAOR96UMh0Vn1tJGc1mSP/G/5mSru7TlZCuFO7Ch8zrR6yIwqccUZ1cuqTrmKiCgPTww4DBqY2foxVBoKGHnoCR/5jw34QSltbCTvAgYN9ReYdYk+T0nBtgVG/yrNeBkdSiN06VLNApuC4gCG8HL/wrLkXmEm+8Tm/MkScDpDfJF9l/sI3PJMbGPSd8Cf1cHaPisdBsnJrztFXmY7WwCntaZZGPo12lmUE0tg3IueASLL7HSW+UTG0zPy0VSE29Gsj1enFKCMLmRk/LP4pY57lxjh7PuDFU8+vUw/+iZaeNmqHTOyjWqM3DfQNdui5oJWvf/Y4eEhf8RGU3irjuVQmrJF+bdltw//bsVhp21tBj3YGIOlLRmDoxCfxH8N1Dfe663Jjr3rmpTto0U+Pmo2idqlDZihnKnnSEJw3HXPYgj5JR5pwTFJj5w/qinnMqo0v2krBVIyLJ9aK5171DbDXJJSteQtNUTGhdzeneWJ4mJMFZ0GvqLzPDZnBnJH2jMD77D+TA4kGi0UOLEN7r+pMqEN73hR63SkozT+TXNebVvNPa15oL8D3h2jrlFgBwdQ1WiDy2/6kwyRoNALzkeNkTbp6TN6C0394KkrqKEqt8yz6kpLxTsGkHQal6GApJg+6FB432fn19BKc8U/A2s
 xnzv1wsU
 QHF2QDPnk2EGzOwIWoekE0iUStjPSdSsGRWCUOUjGZ/RSAyxcMc6ZOyfxYt7Ogp3PajvYENRwtDX4Ex4kVpRStTIWaRlqrnB7ZY+sTYYcRyQspohHSRjW3nCXt/QW5njXmYYmK44Y5DKs4N80sA2ZymDfYVNfWbABmLhEsbPoJUQFaTwDfbLUV+4I5no064b2M+IzWR4WquB26bpp0SrWQwCCyJe9Vcf1XYsSn+hQfiG55VwH927mmBYuJaTQ1xcjc4lcJnxT1LOnZDBoK0xV0fzeKJyP+8cyuTIPKdLcsEIXOUAMZDfPfAANyJ6HTQd1njsRsjDTAYDynNo1Ohrqa80mX7dNunaOZ77YWuqsmVqSfwx+dMualeh1cPOx+DWED0teMxbwS59Ej61n1s3FgCOaPbUVTE+Ii9kQRz+0KTaM8Tud9mniqDruH0VXFOc9Z7ZNy9mr4xVEndI23hXPtD037nH2+1/20M9S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--uqu5y4nffyhbxest
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 6/6] ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT
 and UFFDIO_SET_MODE
Message-ID: <aiC9Be5oxT8u1Z6E@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-7-kirill@shutemov.name>
MIME-Version: 1.0
In-Reply-To: <20260526134149.2831720-7-kirill@shutemov.name>

Hi Kiryl,

On 2026-05-26T14:41:49+0100, Kiryl Shutsemau wrote:
> Add the two new ioctls introduced in Linux 7.2 to the list of
> operations supported on a userfaultfd file descriptor.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Patch applied; thanks!  With this one, the full set is applied.


Cheers,
Alex

> ---
>  man/man2/ioctl_userfaultfd.2 | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/man/man2/ioctl_userfaultfd.2 b/man/man2/ioctl_userfaultfd.2
> index 37553cd7a88f..fb57fe222979 100644
> --- a/man/man2/ioctl_userfaultfd.2
> +++ b/man/man2/ioctl_userfaultfd.2
> @@ -76,9 +76,13 @@ .SH DESCRIPTION
>  .TQ
>  .BR UFFDIO_WRITEPROTECT (2const)
>  .TQ
> +.BR UFFDIO_RWPROTECT (2const)
> +.TQ
>  .BR UFFDIO_CONTINUE (2const)
>  .TQ
>  .BR UFFDIO_POISON (2const)
> +.TQ
> +.BR UFFDIO_SET_MODE (2const)
>  .SH RETURN VALUE
>  On success,
>  0 is returned.
> --=20
> 2.54.0
>=20

--=20
<https://www.alejandro-colomar.es>

--uqu5y4nffyhbxest
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmogvR4ACgkQ64mZXMKQ
wqltoA/9HRJXOZMX/HzwQlJs1dxt2rhggVSUfrPAJ65C9/n1lLb0klEtRnRVBxi3
ksrQxS+638kREO5SXq3UvMUskPiG3X3oTwHcbcjKWP5sPsbG4FEPNroxumqRhRbV
DbAS9X32GyXD3h8jGUDRbqpfBzekdkEZDXCU/rVCw8TdSeNbcRiPPT1HNgAMzbY4
Bi9+cpxGStzs4ll183G1zPEhVgHvaRJnc+lPCv4/ZD5PHx7B1MgCOlcurtx+8Ejs
KgONuyRR8YF/1o/U5FAiO3pOQ6cHE9VNkypgblxuNFA6MyrCp5FQPXiaRon9hKtm
i4FYJtJzQ+ugWC/zUPp+pdwbkFzApEKWBxGlK59Wq2R3qDL74RRxNAwIVoE+Wsxz
oP501St//vEGL+7OjniNjpcCBW80vIlelrZXvLSGuLc/ieJUNBAEEH9/DhqXeShe
B8zM9vQ0bpkxjzhd/FntEkAufizfMTiH83BsovRwhwlQopuIyQgrxxnw8uB3AJIB
OKtPXLdiuD2Jy9lSrcDPNrZmt+Mp10STVa5JFDKZpj1M7lrW8Wvol87KiFBiCDJb
8K3QMenwJK/mWCJwhixzUNQrJSa9AaXJFM+/ae9syHhQ6sGyfw/kYcu29gkkN/gb
sUeUaOpEs39QzN5syNq/qcC9tMKkleFQTlaof0t9+OUBQJnBCEk=
=3X8V
-----END PGP SIGNATURE-----

--uqu5y4nffyhbxest--

