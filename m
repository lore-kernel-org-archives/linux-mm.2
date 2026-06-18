Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53ABCD98F8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852BB6B008C; Thu, 18 Jun 2026 09:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803A96B0092; Thu, 18 Jun 2026 09:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71ABB6B0093; Thu, 18 Jun 2026 09:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DEBB6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:35:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D63831C30D6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:35:33 +0000 (UTC)
X-FDA: 84893130546.10.5C12EFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B58F12000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:35:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLS8wM+7;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781789732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rk6LmjIbCHsYPNdyORQTlWLED3QFUIZxJF66Poqak0U=;
	b=OqzaKB+nZgBzlf0yyJy/bPd8eLp8NcbKqmL5w4z58WU4k9dWttjfRXICGQc2LThCQpygN3
	xwiwyOzW0zIe4Ca+oVIbY5Wo68l/wuAwP7Vb4pd/3taN+kFvncbav8yqvInHdI8vexAVeO
	hDXZ3Mi7xUo0OOfnxpP4NsSY1Bj7CSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781789732;
	b=YbcQKBVPyfOGf2Psc8K8lBBkIaUq3qNiAGHmMz/7BC2Sqi85/0yJmunK/Vlc7utxYG6G1Q
	UxvlAj2kF6rvxxM04kz1ToIWPllx7JUN59Lsds4gqPhKLZW1/zqdBGkFv0uBW6UtD5rMsl
	adl6sfwreXHZgAx7ikPutm+26QwV3P8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BLS8wM+7;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45ABA40594;
	Thu, 18 Jun 2026 13:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1D81F000E9;
	Thu, 18 Jun 2026 13:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781789731;
	bh=Rk6LmjIbCHsYPNdyORQTlWLED3QFUIZxJF66Poqak0U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BLS8wM+7lNGipicaKQI08fr6BvpoZb8eQFBGEtcAz6VB81AbZ8KRuoXZm/Aq6wj6g
	 xYRyXinasz+XrelPwmme8HY0hJ0ltYqS7UnTdHA7izE6XGuxihVc1nWVx+fKC1kmql
	 GXJK3FKZnkS6zs2PST4qZc8YbPG8DmkHqC3xOi6R3Wz3pH9kxCBrsegUncuDz7o5ck
	 StCGUVzgPGABGUhAiUQlubgvBqSbcV7T1IBtE9Mb+0+1jKP2o33viI4bIXnP2NWDEX
	 qOD5DMWfmOGGGmSnmwPlRl8aptuhu4ojY5/eMHNHNAs7LYYDoADnvEBTngkwFmCdZ3
	 Qx/OQO3CyEb6Q==
Message-ID: <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
Date: Thu, 18 Jun 2026 22:35:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
To: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org, catalin.marinas@arm.com
References: <20260612044425.763060-1-dev.jain@arm.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260612044425.763060-1-dev.jain@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------RrLQl9DO89jp5rWKR4YTMpyy"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B58F12000D
X-Stat-Signature: fi7dwsm3qijn3pd43448p8g5caz8u5yg
X-HE-Tag: 1781789732-2375
X-HE-Meta: U2FsdGVkX1/SvJLlfyNCD7ZSqU8ysIlpHjOdYxYe4Cv9HlNKkNGKeX3Asmxc+/2EuwhmGq0QlTh9lDkQfimb6XFCygvPvVIEDPxxD5D+p32Eb8Ks1IaZhOCgPsfI0DYOlsXYRvas8Hrb1lQ0Okt1dUthEqkyUMWw+M7I7K6RhJUBnF0JG3s3VACjMcOz3wfiigC4e0MsTbQ7M0NCMcE3DogRJHeMAfkGASkNELRNvSkfVs8AZNiRtx606qu+goFgUo1TnZ+KM5mvGegcTTXD5KkbHnX+P4cI9StESPtHh8dL1weQQP+q3dKUrQ/vrm1J2CWU+im9QWzHLQbBaQQL2AlJVPGWCmB3GWJLG/cjmpXAnRfumaCjXL0qfE4BxO2ZjeNl9jSHd+rh+rt60uSbcg4ojuiA4qYs5mHz2vX0XjoWu0Sny0jCEz+jYn0RNGL8EqNKCVLyh5EFDpvSOFgo0q/ITl/Pn6G5vMJFR+v3ZHzYjVzA2sjafDuAWVSpDlNL+nXliwM4W4faLli+unPdLGNZ7L/CDZ4uLzvkuD51m67O9SvnAmsk201Y5/+Ud1lsffJhJsDUAuiMfAp+ZTQm7O8Y4Pb+HhFGP9TTKrptAQHa8ogwqxp9AAPHvLh5Kk5g6R7QlUs8MH0euiOUIqkNMON1HCSiC+y7c2AYSW0kWGzM16zKsVxo5VzO858hY6/9ZuB0rSquTIbjGicMc+gxIOY45OQFfprZxPicHuoyeTC7MaBP3NpqfznhneroFcQ/QxsNDlUD0pcCHWy/OfRpejxtTttYtd0Zo+ObIimLbQsoVCzfPU1r+TrNdXLuQp/533S1hZp0JN8IFKEbvibrdqNh24RZiIqlv8eU2bDIfLpZGbs11Jbz1OxwvpcVG7uDsTlsfiD2NdvboyHK/NfCKoXklKcXyWb3LpUR1rIaSmwdG784zi1kDiJJX14I3WtI3kfE5NnlkXup24YlRLW
 YXzt0ldK
 zSNnmR1QxZawfYTvYySbBNDPkMJeLTYbuFsmPfwe28cHe6FDn++0Z2v7oIvMsarjRHPQLa1Fj8LJx+E6zBWR0pXQw7t3CriTcm8m9q2eXNBsOp2G15qnJqCY9JHY0jqgVzjKuo0WbJxebt62BxDH4pcQfWXDOenWTgfblIwHJpKIbMlBMcUWzrDn0pK73onbGYNti7f43kbWegiEHtS2vvnlcHz5sn9C1OZdSRMTKJ4lr1TRxFwoSfzFZT5U72fdcHIhU+V6jTxAcqRfskeTM7CtZZ3LZwa7YR+3U8vdk9R6nBImRukVth5mk5b5JflhdXaILcT4oRh1+SDz6GU1QUoCbFnoGaCsfQfRl+wqckzWFBY7cYdBR32gEcyscTxry/rOO6796w/TW8NUa/QHN5r4vcuGxbwrNMk/dVLYd7xPlCI7L5lkvI1EkZWHRopZSk1iEAfqXvF+NI2nVbVQtWY6lHVb57sUFd8hZ8y5nf05tvFEnbShjhcAKxFmpjpbVGkUVOJMNWVfHNp/U07wDafPKquOnEVS2wUJOIv2hm6pr48LyTYBtZRwWl2x74jqVy8MQ+vW/a1hLObo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------RrLQl9DO89jp5rWKR4YTMpyy
Content-Type: multipart/mixed; boundary="------------y0w8N2KinVP4PMHfeQRfXe6b";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org, catalin.marinas@arm.com
Message-ID: <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
References: <20260612044425.763060-1-dev.jain@arm.com>
In-Reply-To: <20260612044425.763060-1-dev.jain@arm.com>

--------------y0w8N2KinVP4PMHfeQRfXe6b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Hi Dev,

On 6/12/26 1:44 PM, Dev Jain wrote:
> Introduce a boot option to tag only at allocation time of the objects. =
This
> reduces KASAN MTE overhead, the tradeoff being reduced ability of
> catching bugs.

I think most of overhead when enabling MTE comes from loading and
validing tags for every memory access (either in SYNC or ASYNC mode),
rather than from storing tags.

> Now, when a memory object will be freed, it will retain the random tag =
it
> had at allocation time. This compromises on catching UAF bugs, till the=

> time the object is not reallocated, at which point it will have a new
> random tag.
>=20
> Hence, not catching "use-after-free-before-reallocation" and not catchi=
ng
> "double-free" will be the compromise for reduced KASAN overhead.

I doubt users who care about security enough to enable HW_TAGS KASAN
are willing to compromise on security just to save a few instructions
to store tags in the free path.

To me, it looks like too much of a compromise on security for little
performance gain.

> This is an RFC because we are not clear about the performance benefit.
>
> Android folks, please help with testing!
>=20
> ---
> Applies on Linus master (9716c086c8e8).
>=20
> Dev Jain (2):
>   kasan: hw_tags: Use KASAN_PAGE_REDZONE for vmalloc redzoning
>   kasan: hw_tags: Add boot option to elide free time poisoning
>=20
>  Documentation/dev-tools/kasan.rst |  4 +++
>  mm/kasan/hw_tags.c                | 45 +++++++++++++++++++++++++++++--=

>  mm/kasan/kasan.h                  | 23 +++++++++++++++-
>  3 files changed, 69 insertions(+), 3 deletions(-)
>=20

--=20
Cheers,
Harry / Hyeonggon

--------------y0w8N2KinVP4PMHfeQRfXe6b--

--------------RrLQl9DO89jp5rWKR4YTMpyy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajP0EwAKCRCGXBN6rc5S
1jNWAQDzVUDBUPeyt5upXL1mOoO9vGDvDLtilfxpmlxg7GO2qAD/YQLyoBRsQlGb
zVC6FeFHHk+biv6lxpZCj6qBEzmyqwY=
=XQEH
-----END PGP SIGNATURE-----

--------------RrLQl9DO89jp5rWKR4YTMpyy--

