Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA1FCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1BC56B009F; Fri, 26 Jun 2026 00:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2EA6B00A2; Fri, 26 Jun 2026 00:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FB06B00A3; Fri, 26 Jun 2026 00:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B201A6B009F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:22:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25044C1B96
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:22:21 +0000 (UTC)
X-FDA: 84920766882.26.5191AEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6662F40002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:22:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0amm3Fn;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782447739;
	b=fAuuZt32MZmYQx9sQ4riyLtwwwQ+dBPMeALP3INfrnRY7TuoXNr0i5loLi/liw0vY8S16O
	D78CsqpaZrO2+olJ65cPNNieycYJies5p6E7ODl0qnUb+Buu6Huc11j/u5iDhRZvzxstHH
	Lu7k+gwn9wupIcF3jaEUN415OUfonFU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782447739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CreF09zsseqG1KqS3MGVF4hVYNf0WAFIeh6kL8u7eDw=;
	b=2Pv4ZkcqNknshFS7siq9TSEvd51RJf1n279wf/+0tm3R1Sr7b/8+QTRaUgTIl/BvUuYtSp
	EUo0FTnpLHiv3k9S3Rkq7WusU40doSh6CF4TUFHMQ1dxUnCF/3/AsK9IM9coedTH50k075
	WXW8qyMA7Y45MZy+gtNRKUd0UaXc6Zw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0amm3Fn;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5204040558;
	Fri, 26 Jun 2026 04:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C8B1F000E9;
	Fri, 26 Jun 2026 04:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782447738;
	bh=CreF09zsseqG1KqS3MGVF4hVYNf0WAFIeh6kL8u7eDw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M0amm3FnZCP52MGG+c868lxtvYBFok+9dsCpP+awjR4HDs8z1wJM7sN3rWJEORAT3
	 xYkpVw6nzqoNSpZjtEu8f1aItyXzUaULZpCWrHmKE64Q200+MKS5cgK1v3CEesp4bk
	 PTbYeCOxY/NbiEkjqnjFh0vlD6o2BiGZXYw7P4esth8LG8ishA9mg+KAZ4beOWl1bh
	 K/dTKHeDUCIcECDKNUiUqw1arDafWCmvXukFyEvg9FanDSk9vq/6bQIHss8OuyduPo
	 i80kattdA4Oi+ri2KfTgpEaPlQTkerA15dFu4gRM8RgyLBmwWutj2R+R53RWsWv7YW
	 EHeeItb1IZESg==
Message-ID: <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
Date: Fri, 26 Jun 2026 13:22:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260625230029.703750-1-shakeel.butt@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wL0bb3VBv8atswQ8JRXKJEY4"
X-Rspam-User: 
X-Stat-Signature: nbgmbn46zq649w5y8adzcqxd78n97uct
X-Rspamd-Queue-Id: 6662F40002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782447739-76899
X-HE-Meta: U2FsdGVkX1+JVlqtkDbSqtNrcW4fV6f/MuPqdAc1i3AJbSO0hSjd1UzQrNhEoe9KTFOKsjQO1BC+YhfG3Oj3SR1uUbxRVBgfttDV+BY57yhHakyWDeKYkbl8HaGDeoZ88MIc1FO1V5GZ/dQjnBALarGg+iA1aYBq9UevsZRFUxplNteFQhCDhfZNOWrC94MTSufmc22UwDeiXkpHKQ2mFUb1L8W99A6DOyfTAThdTy67zgV43ImCVqOhIMUDhA2DE5yvc+HHTOIlyJaIiCq1Mi4LsxyLBVoa3Q3PrDntulgohF8e0q7eu/mdGzkydF3sl9r3VZjvQNwuCXR+uY0etuMDgsEznAcu7qNUHgGkht3KRyfMIjhuR25Hc1mWWdjwmWYwd04nmS5ewXlVlwazJYNjylm3re5WHP93BShAUyO3Uhh1ONwvLBCC0BJKo/WOL48if8NMgneLi9Yi/G++v/X5GqzpGZR67GpY862dvXvQJGW+l5Wj1hS3zqOOIehg+Mva1vyD2cU07Jnjs0p7fcVLrToOOkjaFFM0f6OcRLR81CUvZvbl8Zg71CDrmfrufgI8WSCmywbWptFeg1zD324hMawGllWVn5kB5phFc18toZY5P0q3p9eJd2g6PyZx1qVy7CEGriD4CdGSVyThS+UfAlzb0DhVexwYqqdsWA+iEYZtHEBgdMvHS7hP0662azylmdr2h7epnrCsqT/Tka31M0YTTZopdPiGRFGlaKU4xdZzh/H+Iov83lWbW9tZQwJFxpIYnnNQSVdldx3OY78wQdTHShiXxJuCZfDzC/+kUuPgGNX0Ga2B8Tfu3XN/Oz0r8/gi4i/coyTdkYBdqQPubCqeA+z9Oc3RmX9ItT9qVxaE0qst1YSdKdRQ16Cky7nZRahh8NZbJeaw7bddnCEGW4zEz8QF4SDFApzZ8zwes5FpszDJwifIWsAe9oXgeR3JZ7YMgjy5e3PGH20
 ZgOtww6v
 wEZNjhJACmf9Zzf24/KkkOINMUIvGtptaDaQUoCNN5xU9lfiL4+vtpHcjMFy/8xQoGtdlJvAKOFOEkBzLpr19COD3lJ/YZa+ilpjD5R+Rwi7ny3iwSjymZk0Df+o5BVaPvWW8R0GKWxLUXwJiqlyXP9o420MAg71ZV+vPiVYY93WSAUoVvoq5HYH/UQVyXdCaTa812Y/NzJ9WWBO9xDBp1aL938/4YcbWLmF385tBFMBi5S08PqIq7nekUO+Qkq4/953hwjYtDLw6QpuBp5KZHX3f1b6JhLvVtr9QVXT1BTKEDbGylM6xjghNxEUNnD0iAy0qWsAByRQMfi+UpqeAjKp/+02fVzM0GA24aBocmioj6e6tCUGphm5LNSgzc3DMgoktMkSn5h/59/sXg/7/w24ecKhVSV1tuHdnMV2iNXvAps6yP6wU4AYLoOvYEqH1z22m7iqG/s6jhmEzEKBMUu7qvsMniXpo3UqgT0dYe1zCrFcLuhlkphVancHjjIwh3jz6G4CF6Kl0X5j4z2l+IVf68DIo9gkPVJNWYRK+e8j86k76gfuv+8p9zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wL0bb3VBv8atswQ8JRXKJEY4
Content-Type: multipart/mixed; boundary="------------OFsuQRSRGmFoObXVY94Bu0ce";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
Message-ID: <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
In-Reply-To: <20260625230029.703750-1-shakeel.butt@linux.dev>

--------------OFsuQRSRGmFoObXVY94Bu0ce
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Hi Shakeel,

On 6/26/26 8:00 AM, Shakeel Butt wrote:
> A production host in the Meta fleet (6.16 kernel, memory allocation
> profiling enabled) panicked with a kernel stack overflow while a kernel=

> driver was freeing a resource:
>=20
>   BUG: TASK stack guard page was hit
>   Oops: stack guard page
>   RIP: 0010:kfree+0x8/0x5d0
>   Call Trace:
>    __free_slab+0x66/0xc0
>    kfree+0x3f0/0x5d0
>    ... ( ~125x __free_slab <-> kfree ) ...
>    <kernel driver freeing a resource>
>    do_syscall_64
>=20
> The crash dump shows a 125-deep __free_slab<->kfree recursion that
> overflowed the 16 KiB kernel stack.

Ouch!

> What happened: a KMALLOC_NORMAL slab's obj_exts array (used by allocati=
on
> profiling / memcg accounting) is itself kmalloc()'d from a KMALLOC_NORM=
AL
> cache,

Usually KMALLOC_NORMAL caches don't need obj_exts array, but yes,
this could happen if memory allocation profiling is enabled.

> so the "slab holds another slab's obj_exts array" relation can form
> cycles.  With sizeof(struct slabobj_ext) =3D=3D 16 and the host's geome=
try:
>
>   - kmalloc-512 has 64 objects/slab -> array is 64*16 =3D=3D 1024 bytes=
,
>     served from kmalloc-1k;
>   - kmalloc-1k  has 32 objects/slab -> array is 32*16 =3D=3D  512 bytes=
,
>     served from kmalloc-512.

Right.

> A kmalloc-512 slab and a kmalloc-1k slab therefore hold each other's
> obj_exts array.  Discarding one frees the other's array, which empties =
and
> discards that slab, which frees the first's array, and so on:
> __free_slab() -> free_slab_obj_exts() -> kfree() -> discard_slab() ->
> __free_slab() recurses along the cycle until the stack is exhausted.

Right.

> The
> dump confirms it: the recursion's slabs strictly alternate kmalloc-512
> (obj_exts in kmalloc-1k) and kmalloc-1k (obj_exts in kmalloc-512), and
> mem_alloc_profiling_key was enabled.
>=20
> Commit 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from
> its own slab") is not sufficient: it bumps the allocation size only whe=
n
> the array would come from the *same* cache (object_size =3D=3D).  At th=
e
> geometry above neither cache is self-referential (512 !=3D 1024 and
> 1024 !=3D 512), so the bump never triggers and the kmalloc-512 <-> kmal=
loc-1k
> cross cycle remains.

Right.

> Fix it structurally by removing cycles of every shape: serve the array
> from a cache strictly larger than the one it describes whenever it woul=
d
> otherwise come from the same or a smaller cache.  Every reference edge
> then points from a smaller to a larger cache (here kmalloc-1k's array
> moves to kmalloc-2k), so the relation is a DAG and cannot contain a cyc=
le.

This will fix the problem.

But this will waste memory as we need smaller obj_exts array
as the size gets larger.

We should probably create a new kmalloc type to avoid cycles instead?
(needed only when memory profiling is enabled, though)

That would also prevent recursion even further.

> No slab can be self- or cross-pinned, the tear-down recursion is bounde=
d
> by the number of kmalloc size classes (it terminates at the large-kmall=
oc
> path, which carries no obj_exts), and profiling/accounting coverage is
> unchanged - the array is still allocated, only relocated.
>=20
> Reproduced on next-20260623 at the same geometry: churning
> kmalloc-512/kmalloc-1k under vm.mem_profiling and then shrinking leaves=

> kmalloc-512 with thousands of unreclaimable objects without this patch
> (8056) and at baseline with it (847).
>=20
> Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allo=
cation and free paths")

Perhaps Cc: stable? v6.12 and v6.18 are affected.

> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Danielle Costantino <dcostantino@meta.com>
> ---
>  mm/slub.c | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 9ec774dc7009..48e54d340865 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2124,15 +2124,14 @@ static inline void init_slab_obj_exts(struct sl=
ab *slab)
>  }
> =20
>  /*
> - * Calculate the allocation size for slabobj_ext array.
> + * Size of the slabobj_ext array for @slab.
>   *
> - * When memory allocation profiling is enabled, the obj_exts array
> - * could be allocated from the same slab cache it's being allocated fo=
r.
> - * This would prevent the slab from ever being freed because it would
> - * always contain at least one allocated object (its own obj_exts arra=
y).
> - *
> - * To avoid this, increase the allocation size when we detect the arra=
y
> - * may come from the same cache, forcing it to use a different cache.
> + * The array is itself kmalloc()'d. If it came from the same or a smal=
ler
> + * kmalloc cache than @s, the "slab holds another slab's array" relati=
on could
> + * form a cycle (self, or e.g. kmalloc-512 <-> kmalloc-1k) that pins t=
he slabs
> + * forever and recurses via free_slab_obj_exts() -> kfree() -> discard=
_slab()
> + * at teardown. Force it into a strictly larger cache to keep that rel=
ation a
> + * DAG (acyclic).
>   */
>  static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
>  					 struct slab *slab, gfp_t gfp)
> @@ -2147,14 +2146,9 @@ static inline size_t obj_exts_alloc_size(struct =
kmem_cache *s,
>  		return sz;
> =20
>  	obj_exts_cache =3D kmalloc_slab(sz, NULL, gfp, __kmalloc_token(0));
> -	/*
> -	 * We can't simply compare s with obj_exts_cache, because partitioned=
 kmalloc
> -	 * caches have multiple caches per size, selected by caller address o=
r type.
> -	 * Since caller address or type may differ between kmalloc_slab() and=
 actual
> -	 * allocation, bump size when sizes are equal.
> -	 */
> -	if (s->object_size =3D=3D obj_exts_cache->object_size)
> -		return obj_exts_cache->object_size + 1;
> +	/* compare object_size, not the cache pointer (partitioned kmalloc ca=
ches) */

This comment is no longer relevant, by the way.

"compare object_size instead of cache pointers because there can be
 multiple caches of the same size" doesn't apply anymore.

> +	if (obj_exts_cache->object_size <=3D s->object_size)
> +		return s->object_size + 1;
> =20
>  	return sz;
>  }

--=20
Cheers,
Harry / Hyeonggon

--------------OFsuQRSRGmFoObXVY94Bu0ce--

--------------wL0bb3VBv8atswQ8JRXKJEY4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaj3+cQAKCRCGXBN6rc5S
1vFCAP408P+shdyG+3rBPdecFSLmZ0GTZWItn30MBm+FK5kioAEAvexxEMUOs+Jf
wR7TnHaFUNthkLRlk7E63fdzjD6bUQ8=
=MqPD
-----END PGP SIGNATURE-----

--------------wL0bb3VBv8atswQ8JRXKJEY4--

