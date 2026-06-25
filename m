Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EF1CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5A46B0005; Thu, 25 Jun 2026 00:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C206B009B; Thu, 25 Jun 2026 00:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8E26B009D; Thu, 25 Jun 2026 00:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 045DD6B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:36:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7926B1A056F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:36:02 +0000 (UTC)
X-FDA: 84917172564.06.4CF7936
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D7A74140004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:36:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NpN3EdnM;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782362160;
	b=zwgBBitzgK0HKkIvK/M3U5eBylrs1sNxPc/XFdZAdolvJNZeK/bfnR7uJNNcb3MI1Fuk5x
	10Hp/rphN886JcLZs4ADnFs+kko2keIAPCFTQoMqhHNw2fk3lHNio0e1XfFnCCapdvgU3j
	+SSUW0VxzA0VPVBF90bdLBmux8cTutU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782362160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7IZdmDL8MjAd2g3mKlIHlMmJKl2AOZ6ZSMg3dG01HY=;
	b=qAJVpSYe/P5pjQ/Vj8SmhbVlgshRd9jJ33DEGjhqm7l3JEHq9TdyPlJr2nkh6GIMf5NqSm
	tz7eCqdhs8vIcQlRi4Di6bakhOc1NJAkOOKccQbA/xh/QJnKGRYAxO4dDp2rncKrSBrPnH
	g2AqhkaElRDq85WSDrJC0RwTuOVVR7c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NpN3EdnM;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5402C60018;
	Thu, 25 Jun 2026 04:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C9C1F000E9;
	Thu, 25 Jun 2026 04:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782362160;
	bh=k7IZdmDL8MjAd2g3mKlIHlMmJKl2AOZ6ZSMg3dG01HY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NpN3EdnMq5COZ4pNqJntYNX6PYmDSVYTcI/jfeOOwEBn//AokXeym5IuuHSuTo9zZ
	 8uzSmUWq7bpXBfJBZxTNqXfCG3muRIe6h8dkxDVdqNNlxOxjpwqIuHhsTLtEXDnoz5
	 Y0JSJ69yyARQeJV1NIUVq+We4RAwEPYMgfdL9RmXHRjZL5xRZv6RTN5vmSuUVEDH8Z
	 dDmqAc8G2InagyKIncyRn3K33XCyYzb+NCayucF1vWnU7t01hvmEi96Wn/Vidq8pqd
	 q7/QwX7/skHyQPWb8zzCr84N7Zo6vwGwF4ld2P8rqbWxLA+JO0q29mn3rZxpew7DP2
	 e7Zk3Rltc2z3g==
Message-ID: <fca2f435-27af-491c-ae2a-c339c21e4438@kernel.org>
Date: Thu, 25 Jun 2026 13:35:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624100320.430115-1-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260624100320.430115-1-hao.li@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------p37cXN42t2U5Il8In8JASo8E"
X-Rspam-User: 
X-Stat-Signature: 8dekd79mebsj6o8y564jm1mcsaox4m6e
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D7A74140004
X-HE-Tag: 1782362160-569054
X-HE-Meta: U2FsdGVkX1/JedPL6q3f9Oh+9FfnilKUF0pt4/CetPuR2QpEmT4ZZuHijfXSA1jxlDHlzdDtmJB5okCj/ndPSjiP1IUHhb+gYUEQxrjyFW+0gAIJZ/Oj+cwJC6XOI1bVkxKFL8W+Qz3pGldwUJPMEs4tMo6sEygu69UdasMwZFFZ1Hn1jn7lLEpWxUEqgq2NgJk3PZ9HBaT/NlccmhNxUcQRvid7yWdRkyyjL0H0qa96h0pEwmbqfPW0xN9WawJHqghylMQjSuQA/u3QQQbonBL/g501f7JGbYC+wJC2BOebNdOc7k3n9ceQdSGzTbpBMDxowb+5O48jSW6GsRuixuVL5Ptt4NGioOkVUpaiTPoPT/ZYjFGLNh5IIp2/LYjMzFXEQE2QjPJ/JOSXwma0djz8xfwf6DqaU8NMdOk12CHqE2M7tQSSnP0vcOkZ6nVqYu/R4IuSykhgY+BNY4y7molwdIsik+qK3Fb9B14JEo/Q5zB8/mXPgn5trvprlIBz8m6i7wiztgSUChESkUkDVQvnwv447lQNp1YpSY7j/BHTEa0D3pOSZ+DF4Z9PDOCOKlYgPvoAfYZGq9tj3vxWBqATHX1Fy722fovb6SKUjgpB3f3OfGboASD9yITX/sx2nxsLYvVLuLe9bMOVeVNrw4tujW5ArqPkg8zUw3mNOgC7wkWZkGeb9QqU00cMdPn7q6zDlxGgC4QgTdqz9QLh0kpeeVg9yLYSlv/Y/hiVZDrGW6U0HE1W8k3bu2jpyAlwyRDlaujbwtAqqvRQl2KmbU2GV+iveafWwDSocpr5faoGujBF0h2Rx6233JX5YNIbPyJqb/FT3TKkn0UUvNJEfMXmf24fXVRLd7HdCeRo9O/JzoltCoDSV68fOLuQNcK/3lQhI7MWJTd+nzAv/BwuVveAB4j4HNuloPqVq+uWNcd8f4tcaSdQrAGtO3Ipt+Wl34giKREF4BSfHBhBuT2
 Vi2HX86x
 khfN48vKzuCHKkNCWLISKnln1bMZMcVUt5q1lReBPfOKiFGrzyJOf6igzT6BUsV4TX4nU9jvWnwLUXvIWnPQk4636abteyWnwtGaTgezkn4Z7HohS1NxCyzuJIzCYGeODCvEaYaPYcHUGFuUHuHwgRelDGTPmAOt7X++qaUYNlMhnr9e5pvm+3gJxNRH6CIOuFZgZ5PQDHmLUWVUTl+M/ocMgCvmYraozR8KZqVwvcxCSqXtrVh7uBWW7AVym9jmesMCJ/s2WQm2YpzinrsQqiKXt9cc4W6i9WS/XTR27zzgoSEZyfmvO1R/PG/pm+yVaIgWRgTt2Jzxb9hQmahT1heAdp0Ua0QvDW7YHiz29TQFpteGI337JPn/+qFRVG/1bmn8Z+l7tOwzMqvNXj6dYn3omppBLmSo8K448ClvexHlBORMp+rM7vaHHmkflXcO0yOogTMn9dnmqBDbURyYNMAgIWDsykPmwwc2/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------p37cXN42t2U5Il8In8JASo8E
Content-Type: multipart/mixed; boundary="------------lJ2RIDFhlc40Wbm0G9LQ5N86";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <fca2f435-27af-491c-ae2a-c339c21e4438@kernel.org>
Subject: Re: [PATCH v3] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
References: <20260624100320.430115-1-hao.li@linux.dev>
In-Reply-To: <20260624100320.430115-1-hao.li@linux.dev>

--------------lJ2RIDFhlc40Wbm0G9LQ5N86
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/24/26 7:00 PM, Hao Li wrote:
> Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
> NUMA policy independently. Since they are called consecutively in paths=

> like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
> redundant code snippets.
>=20
> Introduce a helper function to resolve the NUMA policy once, eliminatin=
g
> the duplicated code and reducing execution overhead.
>=20
> Also remove __slab_alloc_node() function because it is almost empty.
> The callers of __slab_alloc_node now call ___slab_alloc() directly.
>=20
> Additional notes:
>=20
>   Previously, when slab_strict_numa was enabled, alloc_from_pcs() and
>   __slab_alloc_node() could each resolve the task mempolicy, so
>   MPOL_INTERLEAVE or MPOL_WEIGHTED_INTERLEAVE could advance the
>   interleave state twice for a single object allocation attempt.
>   And each retry will also advance the interleave state.
>=20
>   With this change, the strict NUMA node is resolved once and reused by=

>   both alloc_from_pcs() and ___slab_alloc() in each retry.
>=20
>   This is a behavior change, but it better matches the intent of
>   selecting one policy node for one allocation attempt.
>=20
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
> Changes in v3:
>   * Move apply_strict_numa_policy before retry label to simplify code (=
Thanks
>     Harry)
>=20
> Changes in v2:
>   * Use a better function name apply_strict_numa_policy() (Thanks Harry=
)
>   * Remove almost empty function __slab_alloc_node.
>   * Add a local variable, strict_node, so the retry path in
>     __kmalloc_nolock_noprof() computes the strict NUMA node from the or=
iginal
>     node parameter instead of a previously resolved node value.
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------lJ2RIDFhlc40Wbm0G9LQ5N86--

--------------p37cXN42t2U5Il8In8JASo8E
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajywKAAKCRCGXBN6rc5S
1kXLAP9rlTI5Z/kvr5TTbZ+UigvqH3OPQen3L7fX5U8UfvA6eAD6A+XoXscA3A2S
zcNUfftGxIuMq+tozUeLItLqDJNXDww=
=nlzu
-----END PGP SIGNATURE-----

--------------p37cXN42t2U5Il8In8JASo8E--

