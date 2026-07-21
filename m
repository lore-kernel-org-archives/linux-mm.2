Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84EAFC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1016B008A; Tue, 21 Jul 2026 01:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662A56B008C; Tue, 21 Jul 2026 01:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5510A6B0092; Tue, 21 Jul 2026 01:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 249166B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:43:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A29AA1A03CE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:43:49 +0000 (UTC)
X-FDA: 85011692178.26.1F3C249
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E77714000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:43:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Foq28WPh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784612628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=meJhmwUfnjOSp8m4k+erl7xb2QjuGv1a7LosgCLMC3w=;
	b=QtpNdIF7lqqnP+8a0NKu+ENPuSxjQ/xBZKIPJbYaumNVE3Jzal98OH5EibA39KLAjXZkUJ
	TLK3tMP4eT23G4xnbhWhKngjlMMTfLx2S2Q1LlxiPg0A+2Jf1KdgjrVk+rHiBz7wUINKXu
	w8rYmIuPoRAJNXbrOPfbOIcS9xnkY1w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Foq28WPh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784612628;
	b=Lae29/FvZy5b2m3ht14iaZzBez6fxVlc6r5wZD/azGOwAMpedCelLBcEGpplSRwW8NTGxG
	91ou6IkEU0oYPd3ajOTgq+piAEpKJUGYoHnwYujy6JBiQ5nFB5l7cDbMpSy0cKC/XwW+RK
	qt0qAWpFrUJa948IfSo1A0gPXSf++EE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7719D60A61;
	Tue, 21 Jul 2026 05:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7678B1F000E9;
	Tue, 21 Jul 2026 05:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784612627;
	bh=meJhmwUfnjOSp8m4k+erl7xb2QjuGv1a7LosgCLMC3w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Foq28WPh8couwfB2Ljzyrr9Kv43HLtbC9JwcBZVDRIySK6OhX2CW8yIrUTFl0eomd
	 TKAbM0LDTW45qhdiUR5wblr62ZILUSI2rPc2ZROEnG1ep8GfXwd6d0+BQYwSpyksLt
	 b3GqPqfZZRA9eIjUDAX7m2uWCuTDZwNLGe5OB37hAkqKP5pBHstDkI/Mq8jY/ULPtz
	 2B84OsXGn5IbZ5XaRXR2islFFPAK6K5v6J5Lk7MMkMSvFOP+FkpBVYghJStorOGDgq
	 vot39Me7Gxt8+ZqY45mqWEDNAXQ2v1EnYgxNi/Vp9iwecX9YYYiHNrWPxgkoLBX6yb
	 M4L1mGMGOoI7A==
Message-ID: <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
Date: Tue, 21 Jul 2026 14:43:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BcYzxlX3VPSEK1j5AEJfPS35"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E77714000C
X-Rspam-User: 
X-Stat-Signature: opi1akzdjpc5dyssn67hbpt6quj7jm78
X-HE-Tag: 1784612627-53179
X-HE-Meta: U2FsdGVkX1/2r5fU9fijjOa/NrMtZXYIyEHs5G3hCRX18Mn6+d9DnHNBL/jXCzW/cDi4BuDrORFIRVzESAT/kB5a22COh2tPs99dhkEdHgkw/iG79IPMw2k+ALCfRou2MDWDDTMZL146Vr7XQNQSZV9kIDz/y1cQLjqS6iPbd6OjDyNao7+DIdkqbZVrxV9ryHHC9RgBlF4LoTonQBEdPmk+zAbIdZr84mlgPB6zpdtnmVJmG++jwemR/30d5h9DZvthhK/sl7ZEzEEavaLuLrPQZd+T2gEqlqEP2rKDDund2WBSiUpMgqp7UYjTccKJ+PsUOqQH1AwMaGwgZiuXIMNhjwURms2CqrKI8M+CMIe4IKwaBgOgHtR69R4MUOR7TyuASEhfagDVf1C7hbnpkaBa2dSUiJWsgo6MDYLckF5Bll6EqNvaUquS7eL5jUyK96lR5QI506fCGaQhsMzHl1ldsL3v3YyYA3vPG+XKM1B4VGpIACzR5ySlOaEli7V2XkIVgWkvAeikTET1ZwWipECrnCz6bl+sWQq7iYCRcVtfpOY+ukck3Wt3k5NhY012/k7NR5cjxFB2D3N0vkPgE8aWHIwP9GMnRI84pnI15NwqZlVNPvVjizPrA/KtmBOLhbKQM/RuUOuBmLTznrYrjJqXz3QWBCxl9L8icBCe4LwwT7KguchiyDiHnB0r2AWdiAUqT5IYF6S8vF+5uc/RBL9n75NBiBA3w8Ru2QjLHUNFHHw+ZnTpKOn6AGzy4TXUqMn09d10fEKxe0xBbL+uvXZbcnUNEFqUdnq54YeebYnEFHu+h8kAB+17yMNVkfdbSq0heCix43/J5qKguXslCFD0i3bTxAprvgnqzuGiW33mZ5vy1IvTmmc6/QSm+5Oge0wpO4Z8RsalPI93zgdI5DxkXyFfhwzUC1dtJf2FQ5FuKY2T5QtL5Ok1nXc0ra4wBnpi+uTwurBCNUh0YTi
 Xh0E8jiu
 krv3xAXyJsE8SnjWVLi2voLis7fY9mF5aoEgtq75hkQrqBIPgOIcWRSnh9tt5i4+bqRx+D3zaY8Jgxuh/yiidyifcY5ap2i0E/qZ91/t7u+tsQShnjPyGDIblu2VFPbs555JO2raDmo3be9M8o7V+J39ZZZTBCxwz8vRLQfammAqz3Ml1yU5qR0xYqb7D/M5pIX1JigFa2I80mM03YUuPM8IOuvivR2BVXHUDVng5zKFNtr3795wj9pEruDJ5tGxlAZylrcnYTVX88+UGjy86ltoJvPLosIire7yL03pIID0ehG3OC4UlIIcaxA1UrH5gQj834xyBetFLjPiaD5tESFqbF6LAAvLQ7mc6Rp6XSQwg248wiu3xEkZ3dols7H5pHpEqOfAw9lXuowpFkSbMFjj0yttwIuiKEmwzp4zLYvhLuKHkadZVEsVoqYzTOwBSmrFVSsi7RY/o72YVLs7bTpEm8sb2+pfog8gd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BcYzxlX3VPSEK1j5AEJfPS35
Content-Type: multipart/mixed; boundary="------------2Fwu9gZK7PiMF1w25tWuNnKl";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>

--------------2Fwu9gZK7PiMF1w25tWuNnKl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> struct kfence_metadata only contains struct slabobj_ext with
> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
> enabled, it will end up allocating its obj_exts via
> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab=
=2E
> These will probably then never be freed.
>=20
> So things sorta work, but not always in the intended and optimal way.
> The upcoming changes to slabobj_ext layout would additionally need a
> proper refactoring to keep working.
>=20
> However, there's little benefit in accounting KFENCE objects. KFENCE
> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
> (default to 255) outstanding ones at any time. For any callsite
> prominent enough in the memory allocation profiling stats, allocations
> served from KFENCE will be lost in the noise.

For a similar reason I wonder if we can drop obj_exts completely.
The idea that kfence objects might have different slabobj_ext layout
isn't really worth the extra complexity if we have very limited amount
of kfence objects. The amount of objects that escape memcg accounting
will be quite limited.

Any thoughts from KFENCE & MEMCG folks?

> Thus let's not complicate things and simply stop accounting KFENCE
> objects in allocation profiling and skip them in the related slab hooks=
=2E
>=20
> We also need to skip kfence objects in mark_obj_codetag_empty() in case=

> a sheaf is allocated from kfence, per earlier sashiko review.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  Documentation/mm/allocation-profiling.rst |  7 +++++++
>  mm/slub.c                                 | 11 +++++++++++
>  2 files changed, 18 insertions(+)
>=20
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/=
mm/allocation-profiling.rst
> index 5389d241176a..d02eb54ee8f2 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -112,3 +112,10 @@ break it out by rhashtable type.
> =20
>  - Then, use the following form for your allocations:
>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> +
> +Notes
> +=3D=3D=3D=3D=3D
> +
> +- When a slab object is allocated from KFENCE, its accounting is skipp=
ed.
> +  KFENCE allocations are rare and limited to a small number, so this o=
mission
> +  is negligible.
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ac..76acb78f2655 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const =
void *obj)
>  		struct slabobj_ext *ext =3D slab_obj_ext(obj_slab,
>  						       slab_exts, offs);
> =20
> +		if (is_kfence_address(obj)) {
> +			put_slab_obj_exts(slab_exts);
> +			return;
> +		}

I think we should check this before get_slab_obj_exts()?

Checking if the object is from kfence after slab_obj_ext_codetag_ref()
looks bit weird.

Otherwise LGTM.

> +
>  		if (unlikely(is_codetag_empty(&ext->ref))) {
>  			put_slab_obj_exts(slab_exts);
>  			return;
> @@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache=
 *s, void *object, gfp_t flags,
>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>  		return;
> =20
> +	if (is_kfence_address(object))
> +		return;
> +
>  	slab =3D virt_to_slab(object);
>  	obj_exts =3D prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, =
object);
>  	/*
> @@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache =
*s, struct slab *slab, void **p
>  	for (i =3D 0; i < objects; i++) {
>  		unsigned int off =3D obj_to_index(s, slab, p[i]);
> =20
> +		if (is_kfence_address(p[i]))
> +			continue;
> +
>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>  	}
>  	put_slab_obj_exts(obj_exts);
>=20

--=20
Cheers,
Harry / Hyeonggon

--------------2Fwu9gZK7PiMF1w25tWuNnKl--

--------------BcYzxlX3VPSEK1j5AEJfPS35
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8HDAAKCRCGXBN6rc5S
1inqAP9Xf5gpteIoCx+wRMSTfe3rUiOi1kgL0f7l+nIX7MTGvwEAoIuZmbTxNxGc
ptiFK2CT0FBb+0PUFF6oYZruDcKjsA4=
=QTRH
-----END PGP SIGNATURE-----

--------------BcYzxlX3VPSEK1j5AEJfPS35--

