Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE1CCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 05:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5AFF6B0088; Wed, 24 Jun 2026 01:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5B56B008A; Wed, 24 Jun 2026 01:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE066B008C; Wed, 24 Jun 2026 01:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E336B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:15:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D42A18CAB8
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:15:03 +0000 (UTC)
X-FDA: 84913642086.16.2026A9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24BF1100014
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:15:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mkij4d+Z;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782278102;
	b=pfM+zRSnsWzOji1U+uCzKHAqMaeUwV4wI0Z0jrYmTp83AhqmycXm+dOBhj4ZKGMCLW8Kvc
	/etN5D4kwaw8OUHzQHRXe/U2TOx/J9xOq2dVVu4N3sVMcAhzU9oJAlPBXnr4MKdpBMQOLN
	DAYYXpWQZLKXfL7G/+qPVRFIy4lPWZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782278102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FcLlaFTZEEPTlBw3SFS4JJgAFhSBO4Tc1WKaDuAudU=;
	b=nZAe4k+iVAoyoltWxJa/AhNhZDMoIUlxPyd+ccGdzrmVY10pWyoqGMYep0rME7iL1j8GXj
	TwcJf+tYzkOxQbg9JIzc5yYV82Jx87HZj8l2y934q+3dNEMJAFvBB97ZxC2KL1lfbJuuAV
	YJTy7bRUUPayPPqUGf4M0OAPo6ovrFY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mkij4d+Z;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DE63431C9;
	Wed, 24 Jun 2026 05:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1A71F000E9;
	Wed, 24 Jun 2026 05:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782278101;
	bh=3FcLlaFTZEEPTlBw3SFS4JJgAFhSBO4Tc1WKaDuAudU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mkij4d+Zq5+2IUn2GsRASxBwcCppuKuM493YtzPPWtyeITZtX9XW7UkXa0y4j5cry
	 EQK2RBj1/PMUSlEz2hDwOzg1mxv8pfTRGFXP3MM9YRFgWjCtoHYKR6OcF7cPT0Ivuk
	 U/V0xcjHWNw6raUOamfINjiHygeCip8RxhILk4cP5S2xTQ3ubwHh+nvjOmRzLlMcdg
	 Z57bL2Doa3965ANLfi5I8Qw6VyQEuSJB77+wMD/p5ep0BMgATrL3dLuJI11lctkuz9
	 6OtMDzyXGUJyE7uFj8x5LvU1YL7PXTD8kqL5Ve8+050UyCrAzuSwtPcMnTVAFMig+u
	 ZxgMmXrR54rLQ==
Message-ID: <0c69b68d-7c67-4d3a-9f90-86a56bc229e7@kernel.org>
Date: Wed, 24 Jun 2026 14:14:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260623110952.411041-1-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260623110952.411041-1-hao.li@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qdHVbfu1bcJpbrMsGaKoPU9c"
X-Rspam-User: 
X-Stat-Signature: 1mgw6myo1sdiirghimifzrgdhze4i4du
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24BF1100014
X-HE-Tag: 1782278101-486502
X-HE-Meta: U2FsdGVkX1/LaFofOJsn8oTLDTynYMjrGKlQdN+dFXWt67LIMaWH187/sMLNy9g6NWF0GMOewGreavu+M+pb4DAkI1wUnIN66MSQoX1il685A2EMBfnV0yoH2kJtGBTfUU5tBeBbkHFWSeb5qc6RD5G3/6+BXAhpyqztvNAdv4WktoPWcev/5Z030nwu3c+qSc3NdP6VqAUuCj5AxH2p7RYOkasEJhu6LrDR4dM7WTSclE6Jm1Hp+0RlQZgibzR/o8FXmTYbzKZGglnWlbIicCSRF3jkWEdKEXhrGeKhWVqDnY0JNsvB+04rL4wbtU6jAYC0hp8GhMi9Z9j0MVK9sw03oO7SwQFoP9sFfplwYy4NvohN1/H8CtygfyQFmso0AXtLbPaAmedrJDw27WhQS11nhCHLbZzMNzvXL1yxa0vhMwgxZMjlrOe86biyguGWd8UAjN+wcv7QeuWZ2F9RqHwOBZK2rpzYN7xNCGIP37Hyi6zrWrLZVBuJ6SCUM4Tv56Hp/iWFS5X1jqKJ0SOJDaRY5a1PBcoU3YHFpSKazeSlhL3UeCPqrvm9gwb/YEeTpPpRDYem2qN7r3xfC+lspNYsiGWmhWGxP2y/gTnBxzLfWyOqyaQ+01VR1ln/13k+20ktAAXXiS4e5JIEmg8qR+bFahbN4gMKxB+VxedJppSL/E5jeEMjbeyGX/tKnSSWizkrTFh6LAzok3AL1VdBaONLs+oey1UNRhHAwduInX1XG7tgNT3+uffiDFcP3OxQeLKHKNgsEX9kOWpAMGxehO52AzXrZ2729j+MhQx5mJJVed29g9jge/u/Gtbsn7qow2M9R8qD3FQD3bFV4E3BCs0VPolN8T6hOwOfvrFBAcThlO5V+UYxqZBTglPeI7rVntZFJW52UWcTQtVgLc273UaayS88VKCa6obF9Mtes71YA1AGh4ic+5KlZSALzUHkKrc+7PDDnBNvlYObpPG
 uA1woXAi
 Cw8XgKZFl7Kj6IXoVFebouJbiU0OE96oWtMSJGwzT4ngAZ5d9GXG7NtederhRyH0CVT0csG0g8G/VlWumfl6WPzOjkWwaWgkvNejip7XY1uo7ax2PhGxbNlF58t7sFy9tr3zWhZV/xMYPgA8GYWn5vNK//XtIsh+MD3aQ7k9CATivVgyKCrfo/Y36JcNVUBSNUVOXBF+x5wsHhUOKvtpA137lMlitx2HHCW9Vv/J4gcCtGECOOmT2DF7W55/XN9b9iaX+wycPdsxuLAA2o+ljsWcWXKT095aAMdujuwR/YpW6M104K13LQWrBg33O3OiDisgAp3SrMrif5wwW5sEYwCGxulf5OZBc2234IrcHQbBhAKCo43cy+4zi+MhG9cPY7XXcMeShNoNvTm+Zcro5Cup18zlkMNlyIItN5qs6Ogqjs5/3J5k1My9krkq8iD47ODM4Ds6Vq407gDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------qdHVbfu1bcJpbrMsGaKoPU9c
Content-Type: multipart/mixed; boundary="------------M9sN5cFnIXP9sHzk0OxtVxgb";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <0c69b68d-7c67-4d3a-9f90-86a56bc229e7@kernel.org>
Subject: Re: [PATCH v2] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
References: <20260623110952.411041-1-hao.li@linux.dev>
In-Reply-To: <20260623110952.411041-1-hao.li@linux.dev>

--------------M9sN5cFnIXP9sHzk0OxtVxgb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 8:04 PM, Hao Li wrote:
> Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
> NUMA policy independently. Since they are called consecutively in paths=

> like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
> redundant code snippets.

Right.

> Introduce a helper function to resolve the NUMA policy once, eliminatin=
g
> the duplicated code and reducing execution overhead.

Nice.

> Also remove __slab_alloc_node() function because it is almost empty.

Nice!

> The callers of __slab_alloc_node now call ___slab_alloc() directly.
>=20
> Additional notes:
>=20
>   Previously, when slab_strict_numa was enabled, alloc_from_pcs() and
>   __slab_alloc_node() could each resolve the task mempolicy, so
>   MPOL_INTERLEAVE or MPOL_WEIGHTED_INTERLEAVE could advance the
>   interleave state twice for a single object allocation attempt.
>
>   With this change, the strict NUMA node is resolved once and reused by=

>   both alloc_from_pcs() and ___slab_alloc().

Nice catch!

>   This is a behavior change, but it better matches the intent of
>   selecting one policy node for one allocation attempt.

Right.

and I think backporting is unnecessary here.

> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
> Changes in v2:
>   * Use a better function name apply_strict_numa_policy() (Thanks Harry=
)
>   * Remove almost empty function __slab_alloc_node.
>   * Add a local variable, strict_node, so the retry path in
>     __kmalloc_nolock_noprof() computes the strict NUMA node from the or=
iginal
>     node parameter instead of a previously resolved node value.

What about overriding 'node' before retry label instead?

        node =3D apply_strict_numa_policy(node);
        [...]
retry:
        [...]

Otherwise LGTM.

--=20
Cheers,
Harry / Hyeonggon

--------------M9sN5cFnIXP9sHzk0OxtVxgb--

--------------qdHVbfu1bcJpbrMsGaKoPU9c
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajtnzwAKCRCGXBN6rc5S
1hmZAQCpMLa/7jH2nfIjHaVaIp+A/dL3F0oMT71XHDP4cIBelgD/RcmyWcJXXwlv
D7cR1bAO7V7rpmLHYB6fToK6qKE9ZAA=
=wN5r
-----END PGP SIGNATURE-----

--------------qdHVbfu1bcJpbrMsGaKoPU9c--

