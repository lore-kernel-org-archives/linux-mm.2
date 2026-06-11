Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A088CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C506B0093; Thu, 11 Jun 2026 03:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A735E6B0096; Thu, 11 Jun 2026 03:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5ED6B0093; Thu, 11 Jun 2026 03:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 893416B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:52:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C46840360
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:52:46 +0000 (UTC)
X-FDA: 84866865132.07.561D911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BF7BA0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:52:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cuHWA9uR;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781164364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xijNDdKPHv1jokABJ/KJ4UCI30y34c5TQzlLjkdoZMU=;
	b=n+GeM5l02BfOGNFH1KiHAqBlsxHzk57Fn/dawj6d9XPa4WZ1EU6Oa8JNqaFZlFbv6fjhYl
	KDWli69DhVwnVa4H7GEdDo7cHR+aMRA9lhqyRvzNX2b6hu5sjRReXbi/hUXE/wTf+W0y+E
	7CLuyzGn+iY0YN74Y0IT+UPtn+keccU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781164364;
	b=jutpXi3cm/xBXO6Jsk1d7e78U/0ru0vun+mnYREGlLvCFFQF75O0+Fd2MJRXBqvJOBTZ8E
	NN1wX8BQ3uC/rT6xRWwMFLXW7vy4BqKqMUWEHX0tkm0TbxBWnvd5e5l6segh959tDIDMib
	SsRf7pgaZSOVfn6nH+NQio8o3GPz81A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cuHWA9uR;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57A7A40ABE;
	Thu, 11 Jun 2026 07:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5D21F00893;
	Thu, 11 Jun 2026 07:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781164363;
	bh=xijNDdKPHv1jokABJ/KJ4UCI30y34c5TQzlLjkdoZMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cuHWA9uRu0xicoIbUbVAW5BaFPsqNLc/45roEzdVUouxzUOPf5BBWNRR+7WBZmwNX
	 WN5xVEkq3jOWwSHFNktNsKOCsvvgQJKzhB+Azy/snZxkFydWBlqOhofwJI+84TQ1ui
	 BPK6xXyy42L1bIagjFwuQH2g+t5W8FcFXnGaW/D7CvgtmyRHXix8PY+bBVTkbSMcYm
	 i1NQpit5I8a4LCLppcGOd76APYY1/dgsFjD+ySBztXkLDZuX9qGDo/pV6q3yfHpfwF
	 +Mq5PqIZJpXV5+bTLyUdBEP8k2/uF+bacz1+6xU1BDwV1MGvr0JnPxiS7MdSWcJ8zd
	 ozRnuwapIYjEw==
Message-ID: <49ca905a-0303-4fad-8257-485b0ed47c8d@kernel.org>
Date: Thu, 11 Jun 2026 16:52:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/16] mm/slab: pass alloc_flags to new slab allocation
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YrjDV9X0pifSc8pX0GjzraWe"
X-Rspamd-Queue-Id: 4BF7BA0005
X-Rspam-User: 
X-Stat-Signature: r9cku1j87z58w15fem6ky5nd7jxsx1xr
X-Rspamd-Server: rspam08
X-HE-Tag: 1781164364-320898
X-HE-Meta: U2FsdGVkX1/j+iu7ZkduZbYaG8THOBMVE5Rjhza/tFB9FKqW68De/tfjK0a5PYn8jXjFrbQ0HEof/O8YmB5d5gNV/jn6C/hL+odlacJ7MouVNxn/quxiLRGwl+yQBmNGho1bMBEFGMDKNz6IOpJ6z0OWD8lvpOVjuzMHpbqO5TwbUvem1Xs2eS8E0d2Ei5QkXSVm/8VfKuMK9+jMBentDd8pJ6f9C3dzLw5JMkdQiM5dK+tj0/NYu8qvGhjrpTpZkILi5fI+yNKFGtkb7vvqPmHFJUmJ+47rKkXzWbtwd1fxikxs4YkhkM5qEOiwCMnduAma7Bnls6AN+XCGct3xHUd+FOOGjWp0GwHwuX/cDuhqYArX8Fep2nxwolC+J7yECv+1EBUSIQhQ+MJpbE4LpPlZ29pV3sEpWdbveYLrstHYlxo0CSXhcq0qy3H73+ClybQu4KZ80tMx2wr8MYmzOsl/Q3tHEFSJHnVWF1vNaeQpcrmBn836RMV1dGf5b4mW59WeZL6ci/pKCJ5AByTJpKMoj3qWDrXGh0v41DOii9Udz2QUCQTg8Qtxr07mEbpgQU45cdHtZ/wsB5NwBh22c+5HGHS449baO5tR2T/lvhHmHwN3Z86jilKKVWDtH+W3eZ+iK6wvm3PRg8q89lfQicaxCToIWOE3XJISxfXkuBTIjEpR4kjVU7FMwBTeVzOZiUnqmmTRI+VWY632WIi7oKExS2WwHHCmuhR3G4XSEfBqxwA/MTjS39a36DaORLqofCNVolmcQ4vTp+teBAFmhMFIAyjGcVdWy9qT2+uN7rc18K/yrZl78MTCIr2GNws/HrECZAKKB4ODSEu1Jit5NvjNKmuyl7FIw7anboKh8BidZfkAXhJ29sk504JgxOtd75dEDE4Dgw+/ARKBFeSENnB/Q062s3M6wy332JpePMv5etS6M3o9j9Xr2SBky9lB+RJ7T31+ricdDVKUGNd
 SL8ZaS2g
 Io+s38tSeiIohFFT/xMYvXG6M0zKGQ7vMCOnrpIOBSG4yCQqRL9rESLwfRvbmdmuKCALkCNiR0I4jwBKRvcTdXXRTw69OlWLyEW2fQzxKxH/yegcxrgrYsMbURD3TXIi7cpprh/MdGeC5MA6PbaSjZ7Aap9Z94AZ9TTQDZ8aBHnDaOpmWOSMx6yOOzpXypP5RN5fmX3pZ3yF3ql1lKvZjAekg7opFEebADANNQMpt3utTsJoQbW6t9io/ucuhGHfxiR+KaKEIvUPybM12M0LR0/hC3JH7N/IbGBpZEJNVVZsalZzgkZPujio5/RRz4TdkGA9GsXZpVtZXVg7vxOlZk8LhpoFH37Jao+8ASKvZhcwt/tiCn5FOKnIC3Lfe7wZ4FVwkNtW0Hdmr+vB0baLB7Sm2yopv7Beu+c/bDYEfQiPRJC3UIgGBfJvWXYgvOkm4s3k9ZuZUBATOmm9EFCaHc/nO7ksQoU52iYKOFqidkesBzX4pd4/5zJJHoSoIRdBpKkfc/7MiMh++XW0X/Th8I/IBKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YrjDV9X0pifSc8pX0GjzraWe
Content-Type: multipart/mixed; boundary="------------6OoaCLw56CPWa63NRnaF50aC";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <49ca905a-0303-4fad-8257-485b0ed47c8d@kernel.org>
Subject: Re: [PATCH v2 08/16] mm/slab: pass alloc_flags to new slab allocation
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>

--------------6OoaCLw56CPWa63NRnaF50aC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> Add the alloc_flags parameter to allocate_slab() and new_slab()
> so it can be used to determine if spinning is allowed, independently
> from gfp flags.
>=20
> refill_objects() passes SLAB_ALLOC_DEFAULT because it can only be
> reached from contexts that allow spinning.
>=20
> Also change how trynode_flags are constructed in ___slab_alloc() to
> achieve the same "do not upgrade to GFP_NOWAIT" by using masking instea=
d
> of a branch. It will now also not upgrade in cases where gfp is weaker
> than GFP_NOWAIT (i.e. lacks __GFP_KSWAPD_RECLAIM) but doesn't come from=

> kmalloc_nolock() - which is more correct anyway.

Wait, debugobjects intentionally avoids __GFP_KSWAPD_RECLAIM,
but we have been upgrading it to GFP_NOWAIT?

> During the masking keep also existing __GFP_NOMEMALLOC (pointed out by
> Sashiko) and __GFP_ACCOUNT. Previously the hardcoded GFP_NOWAIT would
> eliminate them, but it's not a big problem that would need a separate
> fix.

Ack.

> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 98b79e5e7679..8f6ca3d5fdfa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4467,25 +4470,22 @@ static void *___slab_alloc(struct kmem_cache *s=
, gfp_t gfpflags, int node,
>  	 * 1) try to get a partial slab from target node only by having
>  	 *    __GFP_THISNODE in pc.flags for get_from_partial()
>  	 * 2) if 1) failed, try to allocate a new slab from target node with
> -	 *    GPF_NOWAIT | __GFP_THISNODE opportunistically
> +	 *    (at most) GFP_NOWAIT | __GFP_THISNODE opportunistically
>  	 * 3) if 2) failed, retry with original gfpflags which will allow
>  	 *    get_from_partial() try partial lists of other nodes before
>  	 *    potentially allocating new page from other nodes
>  	 */
>  	if (unlikely(node !=3D NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
>  		     && try_thisnode)) {
> -		if (unlikely(!allow_spin))
> -			/* Do not upgrade gfp to NOWAIT from more restrictive mode */
> -			trynode_flags =3D gfpflags | __GFP_THISNODE;
> -		else
> -			trynode_flags =3D GFP_NOWAIT | __GFP_THISNODE;
> +		trynode_flags &=3D GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_ACCOUNT;
> +		trynode_flags |=3D __GFP_NOWARN | __GFP_THISNODE;
>  	}

--=20
Cheers,
Harry / Hyeonggon

--------------6OoaCLw56CPWa63NRnaF50aC--

--------------YrjDV9X0pifSc8pX0GjzraWe
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaippRgAKCRCGXBN6rc5S
1mN5AP4tMVF5FXhfn3M1bOH0zcppauyBP0EZheCoVRoD/P0knwD/S22l7s4G+UN+
i+T+KAlgVhbzLZ9juSKgV6kPwZV7/wY=
=x6rW
-----END PGP SIGNATURE-----

--------------YrjDV9X0pifSc8pX0GjzraWe--

