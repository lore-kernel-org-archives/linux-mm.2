Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E9FE606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 13:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PlLgBA7l
Received: by kanga.kvack.org (Postfix)
	id 4231B6B093A; Thu, 22 Oct 2026 09:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D34A6B093B; Thu, 22 Oct 2026 09:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA036B093C; Thu, 22 Oct 2026 09:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07CC86B093A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:37:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53C6F1A0825
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:37:31 +0000 (UTC)
X-FDA: 85350364302.25.0B869CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 80BE314000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:37:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PlLgBA7l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792676249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tk4zyMEQWH6Q2aZ7pIorKlxfeX7K1kl3T6clieYYnG8=;
	b=66F9C+hvc6G48dbhiByS8LSQcoikrvQ1qgaVxkscPz8sJQgRQ62Yp8FGJ7FCoVKp0T6PNC
	BmHxICsrPjsNJfGf0ZnZm3Hvq/pLlVUDeZX383Spf/VbrTGT0J1nboiu5bpKunIzSFDHQq
	U+UM77DgZWxqCQ8JnioZ/VLncooK1Lw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PlLgBA7l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792676249;
	b=nCcz6CDw/eiC3OFPVI86F5PE11KoblLVm6iOyGjVu5yBhFoIMWS5U5kO45ljQKueImNAJl
	+2OX9TmZ6iA8hWBT4KJZMn1FJdL3o2RNONQGTOItuE2v9iKvbDL3rlFYFYmzfJp0UI1YiX
	XdwLZypLX8FXGSu1hhbVis5s81LqDsM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C753F437CA;
	Thu, 22 Oct 2026 13:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81AF1F000C1;
	Thu, 22 Oct 2026 13:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792676248;
	bh=Tk4zyMEQWH6Q2aZ7pIorKlxfeX7K1kl3T6clieYYnG8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PlLgBA7lXB8mrN6XbOKjFpmdIH34GPuaWYUUGhZTDKmT/kt7Hvv6Usu4TU3zQZpYV
	 HvW2THzlErvyXbpeDqynWqhZmsCnQrnTkthKFKIscD2nbR2cb3EHtJxrQvsNmNF8BE
	 HwMllQIUPOiNENLS+wlsi9BKEc1y8QckPkxTQFL0/Z2HhlQv8t4+RqbAJ6rYvbHS2G
	 n9KoCGpsZUQkGLxF1yS9sMjy0rFpvR2sT0c/M8WtvifnfbxpNP385qKXeJsAxaufZr
	 AfHpskOEX+XrCkV6qtmh224lz3sc42yOuebtImdF9l7enJPtvh6BpY8qiCuglDGWHy
	 mAMtaSrFfABUQ==
Message-ID: <d5fe8a82-8195-4e18-94e8-2980e8c83674@kernel.org>
Date: Thu, 22 Oct 2026 15:37:19 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] slab updates for 7.4
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 LKML <linux-kernel@vger.kernel.org>, Imre Kaloz <kaloz@kernel.org>,
 Karl Mehltretter <kmehltretter@gmail.com>, Kees Cook <kees@kernel.org>,
 Longlong Xia <xialonglong@kylinos.cn>, Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>
References: <atoJsKNb5KiE44jl@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <atoJsKNb5KiE44jl@thinkstation>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0YX70DoARKhiZ4Z2hKZFVJXw"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80BE314000A
X-Stat-Signature: p56j3jk6wbhag3hda6ockcgpjrd4kq8n
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792676249-106754
X-HE-Meta: U2FsdGVkX18i0aX+GYrM/EVEjohYfiUVgh3VDt6DJbIv1kGnBKK6mPCQozqskLQDAO2GytXeZjq67DCdexSs2J2soTVJwNyQGzDiuoPmDRPbq2RRkhtKa8qngZgnAPnfQUAmIzAzI/KHthqgpBX1fq2TXJiKq1O/5+qQ6PMswIMyHZwURGAee5cfDHk2Eavv5Z1whUlurPHW3L/7rRLTnRpolcAsV0RmvGB2UgIHAeDNUGek9obxBPZ8nGKyPal1GWGTkJjeciD+eJszz7KgdlG1xI6YAzbPaSfOdHj55jNr5slsaD4VZA6DnzEC53EoGVnL7vcx71CfWIxyGcfCj9/4Do0pxDTUtbgtV/6E9yAlmaQMaQMqJS9nmKicRnmUxqlo1btb4MqqsJyoGcfDRSs2XMqFS6w0cIZqE0rKQkWxDpHRfgc1p0zHmlvJzRO7ZraMA+I8JwWA/+RCOJb4O8Hc03mt6Ufdu1v+xvisqO6ncbScCGFOHqxsfvQeHAByVDmSroU0Dt7a3tI3EQd1JZnx2ftKL9MHDih/IAOrO8+W3XXf5qqycxVpDAd5RdryOI1pkjYUfuihtSv9DG2ZYOW3bn7i2THlfDYJddj1C7N83URHerNcE/Fhw35QDsh/VmhaR6q92MewacP1d6sH/hE7mUS7PaNahAidO/6ifzTxu/dcqNhDRkt7soG8hdXrkUKxMgUOccidK/NvF1o7X/CUVyKmHU1IYSSEe+zV+ykidvtXqHmvCZes3wKwNNgUxBCOyAgwRcg00PcAA7HHQGnAbxH5uCMoDICouDAW/lkezdLmaoznb+yqmrRX3YKLkkCYli6AbsjUrqC660Rk6G2brG9n3mh2H8ohLpbmKKJqeztRRomFa+DX7175X077/+xYldi2L9ARVNiUP6mQIE2Ru4q7LYTNu4DbzPeCbO2JHd/M01+5zy45dC/d88kL+jRLHFlB/cZuABqS3Pp
 Xo2SE5ub
 OCRcUYC3EefZyPdU96posUzl9VHme3O0JvHEV+hnyNRO2G+KiZj+TjFxnIdiIxtWoAR8wRxSsk6XgrJM/+FZt0/zhxZ4C/jiq/pEooZ9nO5WypG4kUTKjeJIIGn2/3Ox4Oo1MDmx+b9pH6imcM1CedTxjk2wfvmINoMQLjm92P4tm9kU//Ki2+kTMvevYEf3kPQYkXLLUWalaOEOn57/AwF66OgFNrcskWZEd4sY2kC7m5sY18EIFx1Ywwp5Wio5mxd+mIT0GIwIlqa/SH7VTP5Kbj89+oTdw4W3FXfd7r2M8FERqaS+EB2HxoOel59n4ChdC1SLauVR9iuNh8KDKGe7muflqT40M83LJFNNwhUVOBDUCPa5ZzjiwTyl55WJ8ZkMUpyP9x9DxlcHryQTilTw2nBCcTjU8Zx8+Rw2BDTxvt7sCd+KQvTIIH5baJIIkP1GFPZxs1ROQ6MzwFXFzEO4Xp5c3CfqD8jK5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0YX70DoARKhiZ4Z2hKZFVJXw
Content-Type: multipart/mixed; boundary="------------bJb65ceDpZ0FggE6pTGtP9S7";
 protected-headers="v1"; hp="clear"
Message-ID: <d5fe8a82-8195-4e18-94e8-2980e8c83674@kernel.org>
Date: Thu, 22 Oct 2026 15:37:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] slab updates for 7.4
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 LKML <linux-kernel@vger.kernel.org>, Imre Kaloz <kaloz@kernel.org>,
 Karl Mehltretter <kmehltretter@gmail.com>, Kees Cook <kees@kernel.org>,
 Longlong Xia <xialonglong@kylinos.cn>, Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>
References: <atoJsKNb5KiE44jl@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <atoJsKNb5KiE44jl@thinkstation>

--------------bJb65ceDpZ0FggE6pTGtP9S7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/22/26 15:10, Harry Yoo wrote:
> Hi Linus,
>=20
> please pull the latest slab updates from:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-f=
or-7.4
>=20
> There are no known conflicts with other trees.

Thanks, Harry!

I felt I should endorse this as it's the first time Harry sends the PR as=

the co-maintainer and not myself.
I looked into cross-signing the tag but seems like git doesn't support th=
at.

Vlastimil

> Thanks,
> Harry
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> - Performance improvement of the sheaf prefill API, by allowing the
>   barn to hold a partial sheaf and refilling sheaves from the barn.
>   This improves will-it-scale mmap1 throughput by 24% on the
>   maple_node cache. (Hao Li)
>=20
> - Restore memcg accounting of ipc msg_msg allocations, lost with
>   e.g. CONFIG_SLAB_BUCKETS=3Dn where the allocations fall back to the
>   general kmalloc caches. (Kees Cook)
>=20
> - Fix an old race between kmem_cache_destroy() and slab_late_init(),
>   where a cache destroyed late in the boot process tries to release a
>   kobject that was never initialized. (Imre Kaloz)
>=20
> - Remove slab_folio(), the last use of struct folio in slab code.
>   (Matthew Wilcox)
>=20
> - Reject kmalloc() requests above KMALLOC_MAX_SIZE explicitly with a
>   warning and NULL return instead of relying on the page allocator's
>   order check. (Zi Yan)
>=20
> - Various minor fixes and cleanups. (Hao Li, Karl Mehltretter,
>   Kees Cook, Longlong Xia)
>=20
> ----------------------------------------------------------------
> The following changes since commit cee9395acd8043be0644b25c34bfa86623f2=
b935:
>=20
>   Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)
>=20
> are available in the Git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-f=
or-7.4
>=20
> for you to fetch changes up to d15d7703166daf7bd62c844a3cb1b3a6279adb4c=
:
>=20
>   mm/slub: initialize the free pointer of the bootstrap kmem_cache_node=
 (2026-10-19 11:57:03 +0100)
>=20
> ----------------------------------------------------------------
> slab changes for 7.4
>=20
> ----------------------------------------------------------------
> Hao Li (3):
>       mm/slub: unify slub stat definitions to simplify metric additions=

>       mm/slub: make the case handling in __slab_free() easier to follow=

>       mm/slub: refill prefilled sheaves from the barn
>=20
> Imre Kaloz (1):
>       mm/slab: sample slab_state once in kmem_cache_destroy()
>=20
> Karl Mehltretter (1):
>       mm/slub: initialize the free pointer of the bootstrap kmem_cache_=
node
>=20
> Kees Cook (2):
>       mm/slab: Mark the kmem_buckets_create() context as a Context: sec=
tion
>       ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT aga=
in
>=20
> Longlong Xia (1):
>       mm/slab_common: reject zero object_size before calculate_alignmen=
t
>=20
> Matthew Wilcox (Oracle) (1):
>       slab: Remove slab_folio()
>=20
> Zi Yan (1):
>       mm/slab: reject unsupported kmalloc() sizes
>=20
>  ipc/msgutil.c    |   3 +-
>  mm/slab.h        |  28 ++---
>  mm/slab_common.c |  23 ++--
>  mm/slub.c        | 329 ++++++++++++++++++++++++++++++++++-------------=
--------
>  4 files changed, 228 insertions(+), 155 deletions(-)
>=20


--------------bJb65ceDpZ0FggE6pTGtP9S7--

--------------0YX70DoARKhiZ4Z2hKZFVJXw
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFPBAEBCAA5FiEEe7vIQRWZI0iWSE3xu+CwddJFiJoFAmraEY8bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyAAoJELvgsHXSRYiaDDsH/i6U1bY9jE9pHQjiN6dd
8fvSRXFAkDSP8hGJD/04Oyt0faYYACYh78xU0XRSVYSp6+oWLCEv6jpKESGgEbXK
Q9Sp1IQAz3WyEhmbZ/fjaL2Bj+4unwyftAhL8yg3ZR88mhqKvdvSNRP90vGQGzM3
w1oWfEGQf1Ibwn08J/s2n1rOs5TzXDH7Owcjv8zCphfXsLtWToNYO78Rw34ZSEM9
TmNkpO0kxV63HcbBmBBqnlg90EOZ5JkMpVOYRH9k2/v3qlx7hVGUnNjqDbVKcGpy
9qceOorDJe3sROITTlGkamlkplmHOT2IlT1rntRWCCsglIGUhh8v9KAB8T/ib4RE
k3Y=
=ynRm
-----END PGP SIGNATURE-----

--------------0YX70DoARKhiZ4Z2hKZFVJXw--

