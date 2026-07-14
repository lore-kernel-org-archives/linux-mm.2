Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4308C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22876B009D; Tue, 14 Jul 2026 01:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9A66B00A1; Tue, 14 Jul 2026 01:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937396B00A2; Tue, 14 Jul 2026 01:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661AF6B009D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:17:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEC13A0233
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:17:25 +0000 (UTC)
X-FDA: 84986224050.10.0F7DA96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C1DE160006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:17:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5msADjj;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784006244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OjuiN05GbYsLwmaFUSOWemRKGb9XaF2IwNnXtFq2YA=;
	b=lWaCTrepuXaQx8W24UJGJ/A0mIikk5oLpa9897B4EvrCZgCpTQGvLPsH/ryrwJgceJDKZ3
	k93EyTUleaCdCnRTnPjXkuSq8K5keR3vwiheLnmuN7QoIfgYK6LiNk04I3AYcOsWZCMjjf
	1kjsS9S2TR1biIR508BqhiTq6uBVUGA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5msADjj;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784006244;
	b=3wJnesvSs9pzilapB2KlLxpEoPwpmzCd6agSQvr7qFgzjisL1sGt5drOjaka0TeKcOIibR
	chPWELDeLrQVO5PF2CVSlxfQBGZEXs6QIYCnx8VrZvL3C+zNATm6gJy4Wh6ICIr8VdkmdW
	mL+un/zhyr/PASIE0wF+V8WYpQGYeRk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB58A60120;
	Tue, 14 Jul 2026 05:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093F91F000E9;
	Tue, 14 Jul 2026 05:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784006243;
	bh=/OjuiN05GbYsLwmaFUSOWemRKGb9XaF2IwNnXtFq2YA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g5msADjjydhlG2el855oH79NnH+/3tMuni1u9RR13v2aIZi6wnMeMHHWc2FhpkLBi
	 /kmp5xaAiczsTmhFeS2OaknKNyKYuGPVeCKJ5JfoqpXuKPawx6QLYDsybPtt4oyQ/x
	 PRx0qc5goakUGEGPWJ9NG4LDSb39rBL7Vjz1oBS2SU4WVr2orbey03ww5qiil2u7k9
	 qY7n/rOU0rC06hthkqjKf6v3V7wEKssUQxkRgcYJR0KR962FGB2QVrPQq/ApFSqnI2
	 2eT1zzGlHwU92BXucG4H9DDj5VUoy+KIPMy1zfo+/RFMKhqagZ8G4vBmh6O+qwYdZQ
	 +MGD7hiqaNrqA==
Message-ID: <121dda1a-f050-4035-93c0-6a36278e50b7@kernel.org>
Date: Tue, 14 Jul 2026 14:17:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 4/4] mm/slab: prevent unbounded
 recursion in free path with new kmalloc type
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-4-47c7bd138de7@kernel.org>
 <CAJuCfpFda=dEfW5Cr6ZPfOEq4nwgX-zox=QNTHc_hum07mFH2g@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAJuCfpFda=dEfW5Cr6ZPfOEq4nwgX-zox=QNTHc_hum07mFH2g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------UVBlYSA9X76uRpIL4AKv05mR"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C1DE160006
X-Stat-Signature: muewrrickmae9wxtg5xg51m1zxbkdirc
X-HE-Tag: 1784006244-221242
X-HE-Meta: U2FsdGVkX1+t7iE9HitcHxp1qnx+DBcHcQ4XGY2tBDCW0pbVozXLtNRhqFac0J/jdm4lQP+OKtKKoEkeTv18/5jkVzqUCPHKixHC4jR2Ld/ntCJAQgvRGrhEHvESuw/jw8fkyxjSLHC/I7Nf4Jtv7ZeuX/bKTrY+4mzvLBR7TuiuhdmoJD5XlYp/ScmKcBu+MUGufaDkd+GJWCZbXnV/4lN0R2vxuLVoEt6Wvwv8KN2La8DNzEQY3ZOHqPvZwqEL4ihuU2QStgtTrCGjUKgrvNY8CnGCu9QKWvQEtg0w2mJypLem4zRfxWbfJMkNDwbbA73Z/3NxpcwHKLNZw+REJl/EIFNgnRVNQ/ost8URCsDJDPxL0MVEg6Tr5fSoMMdSnch2Z9wHDfx0qPHRmN5KZqibDI4kahl0P4RI0xeomfxY1Z6uAnlGf9upUMu/kEr+T9mkvim9aX+vsqDIY+wzaFt7PCiY3uaypvo2J5P0IfFUAC2/slQC6TkvDHabGebLWLSUcm/z+rOcU+zlCbfQ61KW58CDd3V+W/nXJvpIvopPCuq8DrKrumqB1AWhzWQoh03NdnynZALmuSDRk08gXzsB3FBslaItkpKYpFDs2hILGuUObXhR36VYCAJehbcq+WZca//vBa2elfgSg0S8gtm7dyNwnPvtxPO0QOrA7jFsy0zG01U/BckuypUCr4rrZoUhesy2PbgogiceBD6YHVXYQ+9TlmU+Y93K/7U0bUdSocMgEOECYSmKWUhqyArRUXw9+qK/Ca5+TaQ/Kr99XvAHxBWxFcVBe4FoIceTLEmXp9bmkdwT6jbEJYRJLn0cqpgzmybm3THZ9Pr7oxMyi0wJMRHf5tR3727nMW2MgL30j1u1P9yZZoc+CoWzldk+DzRwJJsG6vugPy9rEG6QEVAZh/f+xE2DvTTG2m1cPoLKDbm0jt3Uf2xyRDixbHB33aXc9qkt7GQerokBvT7
 TJJjo8Nq
 uz+/KN7QxqO169sT7Z65fDP8xsmZUn8Bd+V/5BtAsxvBrstg3E61BllRFGi1aOxCmUYZE3xqWr6kL5ouxw+QI+kimY6u5ctE4pcBwhSXSC1LyJ2vx7KwiDZosDdasVcy6BJgTQuMYTvFoGuqh3b3kKF7Qz7UXwXx/Vh0WsCdsfSpsnvBb2UDVRLFIPyW96N9o7SCanhqmHxpBlUVEF6c0hDyY/hVQN+iBrfforwsarift0x1qyJe1zMmUWyWclAj6ZKvPajlLnO21YKekMg+r05IvEQSxbElFapAnCSBRrrZZB702vaQqYlCJycfsV+kXnzfVSk+GtkAJV/t97URHoMIGuYw7cgpyMvuYjXQzSCne2cDS8pB4jIu2/kmJGuh/FQjO76rObE6eOStxOFkidQFUt2M5t1kA+rc7s6IVqureGIz0R3Pfm/3v2POsbqA1c2I3NpJo+HJL31eZQA1x1+rgFg0LJ51/LWQM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------UVBlYSA9X76uRpIL4AKv05mR
Content-Type: multipart/mixed; boundary="------------2Cw0wARP2YgVbWWTJx8Rq53F";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <121dda1a-f050-4035-93c0-6a36278e50b7@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes v3 4/4] mm/slab: prevent unbounded
 recursion in free path with new kmalloc type
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-4-47c7bd138de7@kernel.org>
 <CAJuCfpFda=dEfW5Cr6ZPfOEq4nwgX-zox=QNTHc_hum07mFH2g@mail.gmail.com>
In-Reply-To: <CAJuCfpFda=dEfW5Cr6ZPfOEq4nwgX-zox=QNTHc_hum07mFH2g@mail.gmail.com>

--------------2Cw0wARP2YgVbWWTJx8Rq53F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On 7/14/26 2:08 AM, Suren Baghdasaryan wrote:
> On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@kerne=
l.org> wrote:
>> @@ -386,12 +387,17 @@ static inline unsigned int size_index_elem(unsig=
ned int bytes)
>>   * KMALLOC_MAX_CACHE_SIZE and the caller must check that.
>>   */
>>  static inline struct kmem_cache *
>> -kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token=
_t token)
>> +kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token=
_t token,
>> +            unsigned int alloc_flags)
>>  {
>>         unsigned int index;
>> +       enum kmalloc_cache_type type =3D kmalloc_type(flags, token);
>> +
>> +       if (alloc_flags & SLAB_ALLOC_NO_OBJ_EXT)
>> +               type =3D KMALLOC_NO_OBJ_EXT;

Hi Suren, thanks for the reviews.
It's indeed helpful to have an eye for those bugfixes.

> Why not let kmalloc_type() handle alloc_flags?

Good point!

> Other users (there are
> only 4 of them) can pass SLAB_ALLOC_DEFAULT. That seems cleaner to me
> and more robust.

Hmm, there was a reason... *checks notes*, oh, there is no note.
IIRC I was afraid of exposing SLAB_ALLOC_* flags to arbitrary users.

should probably fine as long as it's not used in
kmalloc/kmem_cache_alloc() APIs, not sure.

>>         if (!b)
>> -               b =3D &kmalloc_caches[kmalloc_type(flags, token)];
>> +               b =3D &kmalloc_caches[type];
>>         if (size <=3D 192)
>>                 index =3D kmalloc_size_index[size_index_elem(size)];
>>         else
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index b6426d7ceec9..03ecac12cd86 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -957,6 +968,12 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_typ=
e type)
>>                         return;
>>                 }
>>                 flags |=3D SLAB_ACCOUNT;
>> +       } else if (IS_ENABLED(CONFIG_SLAB_OBJ_EXT) && type =3D=3D KMAL=
LOC_NO_OBJ_EXT) {
>=20
> Hmm, you have to check IS_ENABLED(CONFIG_SLAB_OBJ_EXT) here because
> KMALLOC_NO_OBJ_EXT can be aliased with KMALLOC_NORMAL... Could we
> instead have a helper function like this (maybe with a better name):

Hmm that's fine, but I think that bit should not be part of -stable
fixes at least. Here I tried to make it consistent with KMALLOC_RECLAIM
and KMALLOC_DMA :)

> #ifdef CONFIG_SLAB_OBJ_EXT
> bool is_kmalloc_no_obj_ext_type(type) { return type =3D=3D KMALLOC_NO_O=
BJ_EXT; }
> #else
> bool is_kmalloc_no_obj_ext_type(type) { return false; }
> #endif
> ?

is_kmalloc_no_obj_ext_type(),
kmalloc_type_is_no_obj_ext(),
is_kmalloc_type_no_obj_ext(),
=2E..

naming is hard, ugh :)

>=20
>> +               if (!need_kmalloc_no_objext()) {
>> +                       kmalloc_caches[type][idx] =3D kmalloc_caches[K=
MALLOC_NORMAL][idx];
>=20
> Could kmalloc_caches[KMALLOC_NORMAL][idx] be NULL here?

No. KMALLOC_NORMAL caches are created before all other kmalloc
caches.

IIRC checking if kmalloc_caches[KMALLOC_NORMAL][idx] is NULL was added
by commit 963e84b0f262 ("mm/slab: limit kmalloc() minimum alignment
to dma_get_cache_alignment()") to avoid creating kmalloc caches of same
type and size due to minimum alignment.

> In general why do we special-case and do an early exit here?
>
> Can we do instead:
>=20
> if (need_kmalloc_no_objext())
>     flags |=3D SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;
>=20
> and use the common path?

Hmm, but even without SLAB_NO_MERGE, we often end up not merging
kmalloc caches e.g.) because of non-zero s->usersize.

I think that's why we do special-case and an early exit?

We could probably do some refactoring to change that, but in general
I'm afraid of backporting refactoring work to -stable because I fear
introducing very subtle behavioral changes that nobody would notice.

>> +                       return;
>> +               }
>> +               flags |=3D SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;
>>         } else if (IS_ENABLED(CONFIG_ZONE_DMA) && (type =3D=3D KMALLOC=
_DMA)) {
>>                 flags |=3D SLAB_CACHE_DMA;
>>         }
>> diff --git a/mm/slub.c b/mm/slub.c
>> index abe748b7dddb..a34f9b8770dc 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2168,14 +2132,20 @@ int alloc_slab_obj_exts(struct slab *slab, str=
uct kmem_cache *s,
>>         unsigned long new_exts;
>>         unsigned long old_exts;
>>         struct slabobj_ext *vec;
>> -       size_t sz;
>> +       size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
>>
>>         gfp &=3D ~OBJCGS_CLEAR_MASK;
>> -       /* Prevent recursive extension vector allocation */
>> -       alloc_flags |=3D SLAB_ALLOC_NO_RECURSE;
>> -       alloc_flags &=3D ~SLAB_ALLOC_NEW_SLAB;
>> +       /*
>> +        * In most cases, obj_exts arrays are allocated from normal km=
alloc.
>> +        * However, normal kmalloc caches must allocate them from
>> +        * KMALLOC_NO_OBJ_EXT caches to prevent recursion.
>=20
> For debugging it would have been convenient to allocate all obj_ext
> vectors from dedicated caches... Maybe we can do that for
> CONFIG_DEBUG_VM or someday when we add CONFIG_OBJ_EXT_DEBUG? Anyway,
> not really a complaint but a wish.

Vlastimil and I had a conversation on always (even w/o debug options)
having dedicated caches (primarily to separate lifetime and for
simplicity), it would be interesting to explore.

https://lore.kernel.org/all/2436707a-b6ab-45ec-98e5-538e18589462@kernel.o=
rg

--=20
Cheers,
Harry / Hyeonggon

--------------2Cw0wARP2YgVbWWTJx8Rq53F--

--------------UVBlYSA9X76uRpIL4AKv05mR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalXGXAAKCRCGXBN6rc5S
1l8cAQC3kFEYeg3gH7846Wi5C2cKWOq9FC9HqLfR6CZBYttsbAEAmXMstvPLhZ1q
FZRL7Vh4QgPoHbC5DYcp6+ZX0kuNlAw=
=ZxKB
-----END PGP SIGNATURE-----

--------------UVBlYSA9X76uRpIL4AKv05mR--

