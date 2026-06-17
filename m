Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE47CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F56B6B00B1; Tue, 16 Jun 2026 23:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77ECB6B00B3; Tue, 16 Jun 2026 23:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6466A6B00B4; Tue, 16 Jun 2026 23:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 286FA6B00B1
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:25:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 831A7C159B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:25:39 +0000 (UTC)
X-FDA: 84887964798.03.DD24CD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EA9E840002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:25:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQeCZFo+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781666737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rG57W1MO2nHpbFzCuSNvonU1eaTHOfMztvUqA0ANsSo=;
	b=6gw/+orsZnuLWWemReMp2A4juK9+hra04yrrDvBhClZSl3xXEDBUUxIeKdjTcVcYlC3vkU
	17m4PbxlXyZ5FeyvAlbeXQUT4gwQo9UCAs52TsyvjK6DvagdigkpOin8JHuupHpacJHLuh
	p01nS/tlbKbcBb0P8TjNOZrYsiy9RUY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQeCZFo+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781666737;
	b=H4PvfU2Odde1xIglayfJI3wpXqqIWSAeZJJzThZ+FfpZwJtlDVaZ8j63kv/0q+oHrd5R1D
	r+JNyg7AahmhuVXz90J41P1pFd8RJ1PUhT++n2dMdppqxj1SjuvivaS9E3F5n/TMRZbl3D
	KIWZxremLCP6p7iTtJUw0H3CJ3Hr+D4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53355600AA;
	Wed, 17 Jun 2026 03:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C981F000E9;
	Wed, 17 Jun 2026 03:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781666737;
	bh=rG57W1MO2nHpbFzCuSNvonU1eaTHOfMztvUqA0ANsSo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iQeCZFo+FN3kbrZ3dPsZCE1pwroMOQAkWB7GbtiwiTdrd5VJhq5veJAw2CdWAtS3o
	 +8kcmpqpWkD/sXiN08bDrjIvPduNiNojOnaEoNmme1OA2bQq5ULF3uZPS/Se+Aw58p
	 XqJR2BJ55n8tZFm9xrd+vjIFmZlpo0qhDTW7GkB0q9tXgW0+HlHl/1SLmfb/6FDREY
	 b3bCTyN97o6v04ONsu8+4gYPt6hCODXiBOe1Xu9BYE682BXK8NsrNUUwFVGH4Qy1C3
	 +C09entxqDmMeYxL9kzq9LqhDhgRYglQv5nm3FZfo1aTksYphvOu+4gYmYYTEVgjs9
	 d2fM+aVxXHGLA==
Message-ID: <48840fb6-8c33-4e4a-9951-aa603576357e@kernel.org>
Date: Wed, 17 Jun 2026 12:25:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: recognize @GFP parameter as optional in kernel-doc
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 stable@vger.kernel.org, "kees@kernel.org" <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20260616193929.2394119-1-rdunlap@infradead.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260616193929.2394119-1-rdunlap@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------QpOL9oPbQYZGbrAD0iVZeOPy"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bcn7sdrrfkjejzietw9bgms13o5bqe1o
X-Rspamd-Queue-Id: EA9E840002
X-HE-Tag: 1781666737-832512
X-HE-Meta: U2FsdGVkX1/y83uyu8KR6YCMDYPpZm6uRGQYObZPybQ6OcIbhv+gtBJlcclb1pd9/Bcv+QmuVHbUgNN8ZooMmECrhcgJNuF+8yaAGptOIHjqaq0e/dzcwtdmOPFlRm/RzjLnZlxVSD45dIc4CZ7QQ3e+y82YuyhF05+m1BryuGjnkzLsJaW0RwRD0Zu+6c280si8RhL4+C8fOrWhQhvmyLzohwoI8UyIrcWCFZbSTo5LUO106VRi/9UeWbS+FE2ktygp2zFyUGMwUf2DIt3yglf2mRK5MyK2p2gzdMSkbVHkQOp4/6SVvwBGowMsLt7TEoKoaKI7ii5GGe0TEHo8zz+yD3Dceq9AtSBybLPLTeCxNIhDpalzIUsQnM07qT3xbMkb0e1TEAzgoZYa4kg4TV1uIBk2ARrSuXfQJCe8uSJsybai5LZX3rE/rjBjL12pEYHfolumvEh9+beGj3fjlgiirqtSlkYW/odE9GMUsw2GPmqy6d3fRj8P9P4ObLw6TsdYjj/7qdamrW27nTZLub4VwWs2Wd7hh8r5EztkfIi/PDHxpgCFnq3jNRwlpq8oY7+dt44wXR4dV7MGGKBni7xL38YBkQ00DHRF/leJL3UXigy8IutiMiSkjsmLzOWxaNmtw8SsDK3ecQfB/7kXInzEOOSFGmpiM7tgBvBbvLKK3ZU9rmqHGm/eRI/LyI01gP7pI4A1cjL4kUtBjnaPcLRuXcn3QTp96JI8d4349bzyIO02R0MwPz+qbLvV8JSBaQ6VSuHsOsp/KpksbAc4e2g6w/DWw0UzV0vjDqr39uOBeIa6XoEoqqdFk6hG6b1uTn//0EESVaLh1wbGKIHqCi1SxN5JIQRZMLhtX5uGfUhtQ4NTfpG5o8qpCOB5ERdxi1h+vJXM8LzWSr2gkyl0b+7tHdxOU34AXYhuUxR7p+tvRK/ptakUWwFjEjs7GeGqg1DJN2qkwB4JexbwaBp
 77N5VOoR
 B2rGxpsLtWp/lUTGoRHmPhWAQivkkDZhRyoVpAU8PT/Sb2EaHomR2C49fOdx2e63ZSE/JzWnddEzCldhpoOt+SefwNep0UyZ9H5Lhv/jgN559YvDwpPtMnFatOGhiXkvd621eFoxFVTLZyvgEFEadkNZee4P9dE9hWqtQOdhqIgBRbFlL4QPOkb2aeYSCt9oZLp7IsPdNZIKNsVIA7aVZ6eb9l6d+inLrX4soIC3pDaLBRZiWzuHTrl8vJ8oY/0jjNzrmxCmvxkn46Kgn3/tCMD3IUudCbQi/pLNaiLSztMePvWtI1I1TZxs7C/F7DFcn9TBmn7gePkKA/m9+EGVZdoymKBwypTjezNUuzzilv1gCyNuCWimTRy0/82nGjGjJIOv6eSI1FtADMJv+0bX0Csk7VaOaBXXx1BXJGOJwdhO3XNy6d0eUk5ib/JGQIbIiAjQaFPFV6ZePElQ4qoeqsrs0r5EAUlLaDv1eOl3T2/9KXr2kop0srITqEuZA2Y34UWtWJstiuOvc7kmmhFdwNpkhXcuzaTmQHRai+aFEdlsgcjXv+uc/rwEsovNBIGFp78TS0JsXH/lu0iEvUt5jjW3GCosNM0p6URLtKd1WcrJ4lO48p6UlyV6akxTQLLSQBYpW0HVcgw7dRhan5LSjeV4V6mJVoqO114h2Fz2OfcCPtXOVL1o8H15MwAkgLjBQS+1k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------QpOL9oPbQYZGbrAD0iVZeOPy
Content-Type: multipart/mixed; boundary="------------jONvN0C0jCddOYxZde3BKxJo";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 stable@vger.kernel.org, "kees@kernel.org" <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
Message-ID: <48840fb6-8c33-4e4a-9951-aa603576357e@kernel.org>
Subject: Re: [PATCH] slab: recognize @GFP parameter as optional in kernel-doc
References: <20260616193929.2394119-1-rdunlap@infradead.org>
In-Reply-To: <20260616193929.2394119-1-rdunlap@infradead.org>

--------------jONvN0C0jCddOYxZde3BKxJo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[+Cc Kees and Jonathan]

On 6/17/26 4:39 AM, Randy Dunlap wrote:
> Since the @GFP parameter in kmalloc_obj() etc. is now optional, change
> the kernel-doc to indicate that it is optional. This avoids kernel-doc
> warnings:
>=20
> WARNING: include/linux/slab.h:1101 Excess function parameter 'GFP' desc=
ription in 'kmalloc_obj'
> WARNING: include/linux/slab.h:1113 Excess function parameter 'GFP' desc=
ription in 'kmalloc_objs'
> WARNING: include/linux/slab.h:1128 Excess function parameter 'GFP' desc=
ription in 'kmalloc_flex'
>=20
> Fixes: e19e1b480ac7 ("add default_gfp() helper macro and use it in the =
new *alloc_obj() helpers")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---

I think there is no better way to specify an optional parameter, so:
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

By the way, the doc should probably say that it is GFP_KERNEL when it is
not specified?

> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
>=20
>  include/linux/slab.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> --- linux-next-20260615.orig/include/linux/slab.h
> +++ linux-next-20260615/include/linux/slab.h
> @@ -1094,7 +1094,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>  /**
>   * kmalloc_obj - Allocate a single instance of the given type
>   * @VAR_OR_TYPE: Variable or type to allocate.
> - * @GFP: GFP flags for the allocation.
> + * @...: GFP flags for the allocation.
>   *
>   * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or N=
ULL
>   * on failure.
> @@ -1106,7 +1106,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>   * kmalloc_objs - Allocate an array of the given type
>   * @VAR_OR_TYPE: Variable or type to allocate an array of.
>   * @COUNT: How many elements in the array.
> - * @GFP: GFP flags for the allocation.
> + * @...: GFP flags for the allocation.
>   *
>   * Returns: newly allocated pointer to array of @VAR_OR_TYPE on succes=
s,
>   * or NULL on failure.
> @@ -1119,7 +1119,7 @@ void *kmalloc_nolock(size_t size, gfp_t
>   * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
>   * @FAM: The name of the flexible array member of the structure.
>   * @COUNT: How many flexible array member elements are desired.
> - * @GFP: GFP flags for the allocation.
> + * @...: GFP flags for the allocation.
>   *
>   * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL o=
n
>   * failure. If @FAM has been annotated with __counted_by(), the alloca=
tion

--=20
Cheers,
Harry / Hyeonggon

--------------jONvN0C0jCddOYxZde3BKxJo--

--------------QpOL9oPbQYZGbrAD0iVZeOPy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajITpQAKCRCGXBN6rc5S
1lS0AQC3hp/oL8t9UoXUGcoyQT5XDRzDiaFWoy7VveAHQqbuvwD/S93XEIJXHccp
0NONbGxKhiry/w/7p/MXj5JCMx4sRg4=
=Rv36
-----END PGP SIGNATURE-----

--------------QpOL9oPbQYZGbrAD0iVZeOPy--

