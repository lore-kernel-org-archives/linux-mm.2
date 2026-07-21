Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E970C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 06:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B7F6B008A; Tue, 21 Jul 2026 02:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34606B008C; Tue, 21 Jul 2026 02:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26856B0093; Tue, 21 Jul 2026 02:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3A7F6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:02:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24F1A1C00C8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:02:42 +0000 (UTC)
X-FDA: 85011739764.02.D26D052
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 844E2100003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:02:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngrGxcDE;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784613760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKkyegtZ304R/489xlRr5sH+Tyjz2ix8bm7f3RxMqJA=;
	b=6mWJEbR8en5IN4QhPguqTpEdV7ybnECPLHfcqpkINnioRysJlwvq0AdkxII++Mqz/+VkOV
	V9qAQZqenkZmwqwXjzJ906cY8rjEWaspO4F3Ak2kKRhR2NmBJedJtl6Dej7X8tEb/ZQm0i
	KrSQ/tyi5V2ufLi4P2+AZ/D4s+THrHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784613760;
	b=flU4X+Gri37bnXLuiBVCR/nymUs2ulkTNo2vhNp48tjjFgCOZ+vRweqBFgZ6UzatDdATr/
	MIz7ksQIk0m2RWi8Sxx+w8XdRIsPTgcVnS2+21xZO3s9WQjqegqw1qjDprCcqDlHlyTgrX
	iDxUDSaQePyCFxRVT6DJEGiHQ1RBJEg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngrGxcDE;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFB1560A61;
	Tue, 21 Jul 2026 06:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CD51F000E9;
	Tue, 21 Jul 2026 06:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784613759;
	bh=kKkyegtZ304R/489xlRr5sH+Tyjz2ix8bm7f3RxMqJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ngrGxcDEWmEPJC38OogpEeDM5ZcSy3kpbV/3+jpc20LHmFeBsssiuJOTK4Gvh1Is2
	 X9JR1JO6le4pUSGQXyyO2a7n+rwdoW5Vf4OfrrpMLK+Ix1WXPp1NlT76zQiW3jWRr4
	 5JB5xhmtU2txrqkvdCPPQIXTbE2xsINojTc5Hn//Fp8VeS4m18TjWcQ4NKjvkLyD2I
	 tY+QuxZY/mvkirqrs3vByaOQ2IFCOl+az+8RatTTf21fkkz2VjZ5Q7kk4FyUzeyklK
	 /zxAAScY84BY+aU2+4hrINVxEUnd/vuylmZg4MilqS+ZS8Xm3DflwQxji1KCS+th8m
	 orZsxscdWE47w==
Message-ID: <c6c64baa-9752-44c8-993b-20c9f9efe6fe@kernel.org>
Date: Tue, 21 Jul 2026 15:02:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] mm/slab: make slab_obj_ext() determine object
 index
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------KASFJLXWn905HKRADjHgEPsb"
X-Stat-Signature: trkuub8o15wi9mbr51jo69wgqj9gesye
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 844E2100003
X-HE-Tag: 1784613760-630048
X-HE-Meta: U2FsdGVkX1+pc7CgWMhEdIM1c6XzCLrUC/GIy7ca6Bm137veWVIwuHnxEVUHW+ntdWcJGD6kcBuUtCqjjLos3Rcb9hfGOP79oGqCCqT+EYfpge5DmLxh3T915H0k1zzed3Mmrtbk6Nyq45KftNWTKZo856UwQirnWgJeAkuTE3bCr/TFAPhMc7sh7nEHy2aGN30mOZvaWsLKhGNHHaLMKLH1T/sC3/p5jmf9P5NgnK28LtlrLnAtC1EpHp8VcY/JCe0L5SFM33x7N1xIHSjVFWM0Ltpb0vHrA3Mp0ELTB64zTZ6P8PNNOTrXlb0PLXhlhRIhyg8w10EmK3tR+Ew4KVwYRNZziSJHYWtzkjrElZRNGOY8kHwk/fv+05Fcm96b07YK+N7eW67NoHEemFHxdUebP/oSmmAxZ0gXIUm2hYu8E5fUaEKiMRklPOZvopXXt1knV2ONeLXy44KeCfuLZLfAZX7a26LnJZDpGt8zolMhbgSTGBu5RDnlbO/WnlS6aie2XBn/qqeM1Lu/s5SBkQqn0o1om1BK/RzMalsWn6jtAjFW50nZjTtB3L0MLlz5cv5pbxbVaL+4FfhUFmbAAd4/5PUecmbNwby/br3pyriTi9wHMHVODl3NCPltfIqCFCexQqymR0NrYBfnwWKhEyQb5Txa1j8X+PcETMesgIZSXNCWAD/dXFvu1m0v23hKiXJfaBvADVW/cAv1TzwrX9K409dnvsMwU5bdWHgSgO0tvDcy64cencOkE5rDK6SKTSWQNt5pF2kNUVbIiM/sZlVQ++6yPh4H62XeWfgRXUw+pAFzlVzVxISeY7z05tK3P/hWavXEg0hd3wrzj59LGeg5xmLWyfSc5/kB99nK/25SvYTRJJNFyyB4qaZIhzgRHGyz7NRo9hsQ3mGL4r690DcF+90sM45xQo2zyHNWsxwEqD0K7fUWq7yfAjGT3t9BuUMw99tMdlbgH0sS9MY
 7E6DsbZB
 3i1gcxr8GzGzTlQ1UfG6NtigmXn4tPLd8NouV8JLWvzf6Ixf7xG8rR/ZGptZrc5/IOYlRbhm7KA14qQZdjZKJJCqsDjQtJcZbjsz7c4Df8YCTrt3+HlkCboQO2Fzwh+RwEvgtSDAMoEktJlr4iE2iM8Uq+nvUzyC013XE9a5VxiP88P2zpm2lCl2edU1gOolhiB7BJmeHO+RFlokch3uzKf2sFbeuNogzGxORNwwkFjVIAKsFDa+0/ntO0dbAHF0WI0qK/jGP/Ig45xl0hWigkhWVIL/PejmkPSRbyiEQU4OfD0P0A9xRIc1VwLMIqRbMPVg17a7NCc7NJBjGH5O7LQEmNHve8jYnChJmhN/kChI/PZDciIM7Hk0Iz38N/EQvnPpVB4W6YoiPoHkjrTG7xxg4uUpOqelcFdLxrxYTddD8UYhlcc+uBGZj1O1uFqZTbEL6gw7GUBEpyIa1sRxuuKCGxe1FXAV3OZciD69aqGHpJZPKQROoKDsg+orAtGZ+UI1sQ3L1qjAfkD/iya835t562K0NmGwSYiTlUxgkVIHDvso=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------KASFJLXWn905HKRADjHgEPsb
Content-Type: multipart/mixed; boundary="------------njQytaQwmIPUB4zfsP886UIB";
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
Message-ID: <c6c64baa-9752-44c8-993b-20c9f9efe6fe@kernel.org>
Subject: Re: [PATCH v2 05/13] mm/slab: make slab_obj_ext() determine object
 index
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>

--------------njQytaQwmIPUB4zfsP886UIB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> All callers perform the same obj_to_index() calculation to pass the
> index. Simplify by passing object pointer instead and determining the
> index by slab_obj_ext().

Nice!

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

with a nit on typo below

>  mm/memcontrol.c | 12 +++---------
>  mm/slab.h       | 19 +++++++++++--------
>  mm/slub.c       | 22 +++++++---------------
>  3 files changed, 21 insertions(+), 32 deletions(-)
> diff --git a/mm/slab.h b/mm/slab.h
> index 7bd361447c54..64cec02b5016 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -579,7 +579,7 @@ struct slabobj_ext {
>   * obj_exts =3D slab_obj_exts(slab);
>   * if (obj_exts) {
>   *         get_slab_obj_exts(obj_exts);
> - *         obj_ext =3D slab_obj_ext(slab, obj_exts, obj_to_index(s, sl=
ab, obj));
> + *         obj_ext =3D slab_obj_ext(s, slab, obj_exts, obj);
>   *         // do something with obj_ext
>   *         put_slab_obj_exts(obj_exts);
>   * }
> @@ -639,21 +639,24 @@ static inline unsigned int slab_get_stride(struct=
 slab *slab)
>  /*
>   * slab_obj_ext - get the pointer to the slab object extension metadat=
a
>   * associated with an object in a slab.
> + * @s: cache that the slab blongs to

nit: blongs -> belongs

>   * @slab: a pointer to the slab struct
>   * @obj_exts: a pointer to the object extension vector
> - * @index: an index of the object
> + * @obj: a pointer to the object
>   *
>   * Returns a pointer to the object extension associated with the objec=
t.
>   * Must be called within a section covered by get/put_slab_obj_exts().=

>   */
> -static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
> -					       unsigned long obj_exts,
> -					       unsigned int index)




--=20
Cheers,
Harry / Hyeonggon

--------------njQytaQwmIPUB4zfsP886UIB--

--------------KASFJLXWn905HKRADjHgEPsb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8LdwAKCRCGXBN6rc5S
1saKAP0QWmanMNtSWcitc46wO43ObEN6jNyOb66yd+fWn/XwLgEAiqItNg9zJves
jTKoV6pgZPlag6PNzqn5WPPHs+gXrw8=
=GF5b
-----END PGP SIGNATURE-----

--------------KASFJLXWn905HKRADjHgEPsb--

