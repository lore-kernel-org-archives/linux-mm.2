Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65746C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 14:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA3A6B0099; Sat,  9 Aug 2025 10:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1F56B009B; Sat,  9 Aug 2025 10:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE8A6B009D; Sat,  9 Aug 2025 10:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 705D66B0099
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 10:25:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20852140217
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 14:25:31 +0000 (UTC)
X-FDA: 83757442062.04.AF24E74
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5AA1040005
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 14:25:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhPiH1Jl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754749529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32DhQrFt/hngoROswc7KNboedmkff/cIdzZcWhIU/nI=;
	b=0qAnBbEB9OKF+zC1jbs/ZCro0MPn7ZUyB3Dv+dlSKYbqgkOMpLXAeawJ+tUYFrj+bOkWzC
	6C5inn3LCT29WgI6qbpQT7VjCFjbnRSQ3XbsmazFQbiaFQpHa36bIXbOfzdp4jxrB8sdNc
	yt5q4VjidG4ESt96uag/fNSb/XJhEBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754749529; a=rsa-sha256;
	cv=none;
	b=kMWDVO0obXG/j/4QpBF7LWlJGSs7ihvHcracaUxe2ROI6jguatihNdIt5nnYRVXUFHjWlU
	Gkv8clZHCWlrlXE5KdQW0Zv55KmdYJr3ir0o9hi4f0q2vx75P/ofSoMUlDvATl2WNGoY1H
	oKP4QFpIgrbksS9AtOp41ze0rKmseVA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhPiH1Jl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 1CBCD5C53EE;
	Sat,  9 Aug 2025 14:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81FCC4CEE7;
	Sat,  9 Aug 2025 14:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754749527;
	bh=oITAnnL4pXbTCRefVuC52zFet+7k9cZryAFVCd68ykQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lhPiH1JlOayaV8jMajfbPXRp+PJT0K/tDMTHVy9FlsjaNitJUKSthITV+aMSgYQ7Y
	 Cm4vBNyRSPvvlbsEnkFIT0XabcKcbSexsKdVA8fXH0Q3pmHeiS+xWHV/tVPtC1wDzq
	 b4FAHduYiEb083Q8qAIKcLacAdSmSpMUQH4njEd3m9wArAA9tngZcQbmj74hwKYiau
	 U9caVv1ZEwjE5U2CWoMJ9pWiqzN6AcQXgFfynGOmOIrnXjxyZslWo9Tm56nsBV2kyX
	 XaHV10+Q8M7jQt2LfxnHEjw31K//sCZzjfDL5DFMQHdPy1eSYe19MN29u5l4nyLoEN
	 CQth0XyUDiU1A==
Date: Sat, 9 Aug 2025 16:25:18 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 1/2] man/man2/mremap.2: describe multiple mapping move
Message-ID: <ekjakm6zburrawhk34smm3fd43zufzguisfean4hmv7vyjp7fq@uvy6n47qbydl>
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <53e4284ffe80a63260c957369ccacea8f5c16adc.1754414738.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5xmbayfvgezef2h2"
Content-Disposition: inline
In-Reply-To: <53e4284ffe80a63260c957369ccacea8f5c16adc.1754414738.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 5AA1040005
X-Stat-Signature: rduafc5neab8kehhx3jcfmrr7dtu9uin
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754749529-189530
X-HE-Meta: U2FsdGVkX1+gIcS+WGahGHvTXHmD8Rp8QPwOcTjkTKLFo8P98JwCIYISmdzw5kt/MtpNjOCqwqtZ8NAkhaauZN3v6UNWbIV9ugluMpR6mLy/dWD4qr+m0TjFh6kgpZYjOMG+G1k6zEU52rpxMxAAkwhT+CQJDw14O8MFoKgbL29bsMWo6IpyTAo9v+7fgg4yyOscuDJgsun297NOOZDQ4JfCXQrN5KVI2n5oq045JAlKsWHMDIc5qT2Uv7JH5pHjJXMyuoZUMn1iKamkcCquASpY/6oe2iNgvjjrgdIXXR9WX1a98PwyXuqwh9SjxrFAgOxWtDe2EW+CojTfSmem1ThuT1Bn5HqecNmT+z0+zrHnoYuOTh9LzSpiu0tKSwc7sR0Q05S0GlP4LVawbazupNqsNgxTBVduT0kL9AFAXqxhnzxGpWKNh7JBWP2fbECbq3iiEtJEXUsO/EnLRti13vxE7Py3L+mfMUlTgSvAE+U5zR12CHLiocHgrEPa7bHPSyCedyCMj9fD1FFEjcqVvI0W1oqpiwrXiYlh8d3O7z6WQNa2Ly4rdC9s2c9EA7m4QhqQEK4oaTuMP9cHsBEIrGybDWK47ic+30NMzkcOjs80AteLle+V6Lj55lRS1snA9aLxa9934YrMVvvFhRP3K2Tf4NwulzU174TxFMNkeFAFwb7AyW+pjSAb7iHV+M6nQiVtV2Nk+dXJ1kVM7mClBm02DJMZ/dWzXX5TrjEnU4BZB7Nfwv7HNeKkYI4MK9CHclIR6+aVC6NbVDrPpEdcqzwV7cyX/oQzYau9dIuslyBfkUmyWTucgx0ruLwUKu406mCzGBAmccveMzGOD7sU6nApov+KjA4bf9tbZHuJjI758U6kjxqbnrtL/godUwIBNZL7B9v8YXecRwfSFoqT8/GiNoF/zFnSB9bcKqJ6IGZM5CqfMGXQcdWFSvMvmhu4rtOs1MDxHBjzgtATKaC
 JM/5a4s5
 FtuF64JAblNTGk5VjB3hZclF9lEmKbefmgLmHN/Z5BKzROfbLUncGPhFSICOtRNrkzHBR9BKNtMqMNvuZ9FhvyOdpWF/WHnOCS8HEPJQB2uNxs+dEasaorFV7QSqbDGY+h0QGquYVVrxEBAqg3lnz+l6iJRGqAhG7UFIxF0dWceuQOwU6jb0tqq2ui4dyG9Iw7uycI7kG8lhsNBz92gpPa1KoNUQg2IohMh8Kg7dbinQZ1oxz4Bo+LYbFwapV77IjhIkDeHBvHyiVj2VVgak2lJXvPBVlBfjweHwyWVDvqjjvia3R2hmgA6crxnQRYU+UtdBKuoe2No4TzS7tKLMSna1iTUdBHlWo40oSd/yUZwoJgR40s7SIFmMwzNlVAsGguuHPqFD9DTcgHkicdywCvPc/zVvwD+SgCaGvAhPwWJAo34Iprk0Cjg1pxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--5xmbayfvgezef2h2
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 1/2] man/man2/mremap.2: describe multiple mapping move
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <53e4284ffe80a63260c957369ccacea8f5c16adc.1754414738.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
In-Reply-To: <53e4284ffe80a63260c957369ccacea8f5c16adc.1754414738.git.lorenzo.stoakes@oracle.com>

Hi Lorenzo,

On Tue, Aug 05, 2025 at 06:31:55PM +0100, Lorenzo Stoakes wrote:
> Document the new behaviour introduced in Linux 6.17 whereby it is now
> possible to move multiple mappings in a single operation, as long as the
> operation is purely a move, that is old_size is equal to new_size and
> MREMAP_FIXED is specified.
>=20
> To make things clearer, also describe this 'pure move' operation, before
> expanding upon it to describe the newly introduced behaviour.

Can we split this further into two commits?

>=20
> This change also explains the limitations of of this method and the
> possibility of partial failure.
>=20
> Finally, we pluralise language where it makes sense to so the documentati=
on
> does not contradict either this new capability nor the pre-existing edge
> case.
>=20
> Example code is enclosed below demonstrating the behaviour which is now
> possible:
>=20
> int main(void)
> {
> 	unsigned long page_size =3D sysconf(_SC_PAGESIZE);
> 	void *ptr =3D mmap(NULL, 10 * page_size, PROT_READ | PROT_WRITE,
> 			 MAP_ANON | MAP_PRIVATE, -1, 0);
> 	void *tgt_ptr =3D mmap(NULL, 10 * page_size, PROT_NONE,
> 			     MAP_ANON | MAP_PRIVATE, -1, 0);
> 	int i;
>=20
> 	if (ptr =3D=3D MAP_FAILED || tgt_ptr =3D=3D MAP_FAILED) {
> 		perror("mmap");
> 		return EXIT_FAILURE;
> 	}
>=20
> 	/* Unmap every other page. */
> 	for (i =3D 1; i < 10; i +=3D 2)
> 		munmap(ptr + i * page_size, page_size);
>=20
> 	/* Now move all 5 distinct mappings to tgt_ptr. */
> 	ptr =3D mremap(ptr, 10 * page_size, 10 * page_size,
> 		     MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
> 	if (ptr =3D=3D MAP_FAILED) {
> 		perror("mremap");
> 		return EXIT_FAILURE;
> 	}
>=20
> 	return EXIT_SUCCESS;
> }
>=20
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  man/man2/mremap.2 | 84 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 73 insertions(+), 11 deletions(-)
>=20
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 2168ca728..6ba51310c 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -25,18 +25,47 @@ moving it at the same time (controlled by the
>  argument and
>  the available virtual address space).
>  .P
> +Mappings can also simply be moved
> +(without any resizing)
> +by specifying equal
> +.I old_size
> +and
> +.I new_size
> +and using the
> +.B MREMAP_FIXED
> +flag
> +(see below).
> +Since Linux 6.17,
> +while
> +.I old_address
> +must reside within a mapping,

I don't understand this.  What does it mean that old_address must reside
within a mapping?  It's a point, not a size, so I'm not sure I
understand it.

> +.I old_size
> +may span multiple mappings
> +which do not have to be
> +adjacent to one another when
> +performing a move like this.
> +The
> +.B MREMAP_DONTUNMAP
> +flag may be specified.
> +.P
> +If the operation is not
> +simply moving mappings,
> +then
> +.I old_size
> +must span only a single mapping.
> +.P
>  .I old_address
> -is the old address of the virtual memory block that you
> -want to expand (or shrink).
> +is the old address of the first virtual memory block that you
> +want to expand, shrink, and/or move.
>  Note that
>  .I old_address
>  has to be page aligned.
>  .I old_size
> -is the old size of the
> -virtual memory block.
> +is the size of the range containing
> +virtual memory blocks to be manipulated.
>  .I new_size
>  is the requested size of the
> -virtual memory block after the resize.
> +virtual memory blocks after the resize.
>  An optional fifth argument,
>  .IR new_address ,
>  may be provided; see the description of
> @@ -105,13 +134,43 @@ If
>  is specified, then
>  .B MREMAP_MAYMOVE
>  must also be specified.
> +.IP
> +Since Linux 6.17,
> +if
> +.I old_size
> +is equal to
> +.I new_size
> +and
> +.B MREMAP_FIXED
> +is specified, then
> +.I old_size
> +may span beyond the mapping in which
> +.I old_address
> +resides.
> +In this case,
> +gaps between mappings in the original range
> +are maintained in the new range.
> +The whole operation is performed atomically
> +unless an error arises,
> +in which case the operation may be partially
> +completed,
> +that is,
> +some mappings may be moved and others not.
> +.IP
> +

Why this blank?


Cheers,
Alex

> +Moving multiple mappings is not permitted if
> +any of those mappings have either
> +been registered with
> +.BR userfaultfd (2) ,
> +or map drivers that
> +specify their own custom address mapping logic.
>  .TP
>  .BR MREMAP_DONTUNMAP " (since Linux 5.7)"
>  .\" commit e346b3813067d4b17383f975f197a9aa28a3b077
>  This flag, which must be used in conjunction with
>  .BR MREMAP_MAYMOVE ,
> -remaps a mapping to a new address but does not unmap the mapping at
> -.IR old_address .
> +remaps mappings to a new address but does not unmap them
> +from their original address.
>  .IP
>  The
>  .B MREMAP_DONTUNMAP
> @@ -149,13 +208,13 @@ mapped.
>  See NOTES for some possible applications of
>  .BR MREMAP_DONTUNMAP .
>  .P
> -If the memory segment specified by
> +If the memory segments specified by
>  .I old_address
>  and
>  .I old_size
> -is locked (using
> +are locked (using
>  .BR mlock (2)
> -or similar), then this lock is maintained when the segment is
> +or similar), then this lock is maintained when the segments are
>  resized and/or relocated.
>  As a consequence, the amount of memory locked by the process may change.
>  .SH RETURN VALUE
> @@ -188,7 +247,10 @@ virtual memory address for this process.
>  You can also get
>  .B EFAULT
>  even if there exist mappings that cover the
> -whole address space requested, but those mappings are of different types.
> +whole address space requested, but those mappings are of different types,
> +and the
> +.BR mremap ()
> +operation being performed does not support this.
>  .TP
>  .B EINVAL
>  An invalid argument was given.
> --=20
> 2.50.1
>=20

--=20
<https://www.alejandro-colomar.es/>

--5xmbayfvgezef2h2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmiXWjcACgkQ64mZXMKQ
wqklGg//SF0JLJ2EiiXam+d6ODgH9lopFyhItyfqL3G5G4HQc19RtfHsy4v2T2MD
ewK8cwOkg2e/u/ejOUi2L+/AGO8hc4ykHSxM74eivyf4O8AJs9mSB1ywZ4CJ18S1
GU/ZApYIFSExfIgY6PAywvn/Dv3PQdPfO8gG2tK9FflCfsmbSJbpN7ADVfCrA9pW
ZfeqA949CLLAiGoDTMx3K309dJeT7qTr7IQqlSJQzvrVCnukaqmoUowCvlwJdr/0
ffjCt7aTU/JCoafEg5gJOrPvunUKwd6mRbj6+wCdfe215Lw/s1MWtGURJp1qGl1T
XoNkSBO0z2+noPkEoD9N1mU7tlZRf7QLRSf3nZX8fXiIrPBk2lhhfhwoEKXGDI2F
PkFIas97LQ3XXauEmM85GGGl420Jl62VnS0lRiVHNp2c6Y71ADGi5QhbhlWIl78x
eQPmjkJJxCgCi+OeSCyUFgvrvA7VFOIaS/U2aC95yu00V+B1i3X+61z6I3snAkTI
JLV7pTNtrrY92U1f4LRHcO7d8xF1F6vL4nuH+mb97bLyWzuLIEbC1sBhtJiDNxbT
n7XMQA1v4g68Dcc0IQEgx9YlbewR14KZSm6p43kILDjM5z3CtvoORAi3wgYs+dw6
+UEfBqtc989H3Vg6QrYhdNslpgv7HIZGEEItTWHs1JGW+PEBEHQ=
=oKUk
-----END PGP SIGNATURE-----

--5xmbayfvgezef2h2--

