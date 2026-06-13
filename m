Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07293CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE426B00A1; Sat, 13 Jun 2026 01:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5306B00A2; Sat, 13 Jun 2026 01:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2D46B00A3; Sat, 13 Jun 2026 01:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F27396B00A1
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:21:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3E9F1A02B2
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:21:30 +0000 (UTC)
X-FDA: 84873741540.01.D485D61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E8532100002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:21:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqKsaocu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781328089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cY4ulGls6JQt0yIjszAxVaniFh8xLiVdkDhW4rzHbcc=;
	b=aw70h7J9+DoYIGt4Cll7Q8pdPXAPtSGwrAdA6090WqqptYWKXDrf+mLia6h+ICXjUPfnZf
	JErX+H8G5tg6SWFycuS3vWua1woLAJTtjIgMT5wS/vIvZC3UWrtf2jzvr3DfAMTyxMrR1r
	qqOxI8bX1L1PgSzJSSyhm5fMnBwR2oc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqKsaocu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781328089;
	b=6/7Zxtyjtef/r8BxoNe6UT+gnUx+o9qpc+5ds/Vix3aG/tOJt1kghrlPKj70qxBz+yssC+
	j1PZo2pGb3XPNcUKybJSwtl+wCRRam7iAfwdzNJCakohIcJcz3v2a5tIhH2xh3cduRn131
	N2fuXKrdurkSaLM0mQ6BzvBnWiR23AM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0968E44271;
	Sat, 13 Jun 2026 05:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D8A1F000E9;
	Sat, 13 Jun 2026 05:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781328087;
	bh=cY4ulGls6JQt0yIjszAxVaniFh8xLiVdkDhW4rzHbcc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TqKsaocuMRNQYkmCNGvKzOjFOtNvuv/CVRH/AL+oEWHghWYzumjG9V43KL88eNKMo
	 WAOinHgXNmAKqt04ooIb6YHkoLNBgkp0raPj7TcReGgJpX9OFUBFrI8VOBAz2/JDsi
	 JMdZuRNvUx+wSzIxAfcrfrBMLU3QktZ4nb2Re6EnBRXCNC861h7k33xx+vW17YB6hH
	 qSgD8OwzmV6ZQc0CZwXQAafd5/Ds4SyvfMjTr27nn/R6KelRtoDJl8uXoGKrRyOMKG
	 O4DVTSOY6fFrx4rGmapcrO8iqyPwcEjRn64XMqsl4Pk869GvymUvDKWEFJRuHFdUww
	 ZR2qJJWxuClEA==
Message-ID: <951f3634-d9e6-44a5-85fe-666f6fdc8b72@kernel.org>
Date: Sat, 13 Jun 2026 14:21:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------hF9aylLo0tJ0Ntt9jCFGxhn0"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8532100002
X-Stat-Signature: jhrqm7nif4zmap9t56z3pzc8wy7o3g6e
X-Rspam-User: 
X-HE-Tag: 1781328088-66942
X-HE-Meta: U2FsdGVkX18EZffDHJC/hrA5RvxPQVgXGKIlm7EubDuJn3pUs68pMkLZev535eWhggn3HsqfAf7Q2ubrxReOpDveBAm/nskJchwYnS712MiDAM8pAKsmHWpZ9DShg017VmZB8c4fVCeB4DLuVgjxm10xVIA/wJD1ZrLxe2FvBW4DwCApmTTeB4Y53QGVsNHX9rXjR1jPzYmjxM9+RIH+nxX9N6ZzQxAq/Bvk6JdpGLRSlq0gTXLovhP/h8n3MHUX0HlobrZ9TEUnzOaSIw3mD/IICRs6e3X5gfOnmdX7BqOhinizvdg64tvbprOULN1RutwTY0bRaQzdE8ak+1ssRap8Eo2w/8CSVYR0cdj7UN+gShltFcYNovruEx8rHsFn7+fCPQzCUrE3YHDksb6EPzZUxB1BNJKi7h7+XA2wWpXT7dgwioz+/6inn77l3mCfX1zGvrXSWUeX+dmv8vDKXRHoWmYRav6qUXHa4YULmLJZhpjI0YKc+U0Pg05FZsprzVAh7wEgzLo7gG8gP08DSzjykdwOn7gC846eEqoMKlyBYH7P+kP+Tgm6acI9ThKpCiBYX5a0DIJMBjNxpDj56fFnoQusYXLuqywh3vBjtsTsCq2eWMwIntbyYKbNFYbfXZJPj8eOx/LbWYvO81SOBaSWkPBc59xtnJEV8lWJenVIhHu0O1a0fBhNd+uEIKRfemz/Zf54hgsPeUXjI4/HiHunuUMpbZ/j7HEyF8uZTmzclw3h+o7oHaabzUCebtRKUt3H+eIqfdS1uWcNQ2g2mAjKWJ9uVE9TLCM2qjnS54Hf+EKOQ8u7KcReCbQOa3dOhM/Z+ZgAPlHyCtx+v6qnjBz6tUvo1Ceau4JGVr2120IprBsmnCHehiGszXD0gaBLpC1K2a4qhhxs5+mkMMSzv7po75JvNzmxT5qQ/uxf768PAVVXdzMdYd2P+hXui/k/i0agDWauIpvP/mYiI2U
 jPx9kPrk
 vCXtLU0JiNN2qPuyBC4o4ROm4+6zFC2i1tu5A7L4AEdhlL1VhGPeyFRyhMht9gjM/GoOuPvEF90hJ1vFKiuBywajUnU/RVj8Kks4zAPUH5qIHac+geU3E5mrIepPMUNeliAawPDKS/6GI8JazcUmJ2kVQ9WSThNZrFljxUQNHVKQ7O079yYQLmAeMRzatAI4oeeO3SVdNdwKqzpY6Lds0oH5sBShTscV7voGiT7Gp+r6yu2gPRd0U4TsE2LJHtio0DHCUTsMUjBBdt66vH6sRPT8opr64m+GZqhxNGeFs1weO5eM8f9DLGq/5F1XbDcfk3zavYTkwCHQ6Vd8j2og1Fll+nB/ZzCoqAA7zYjwH41IvFbf2zZz1PS/grMf+eptuxH7F8avMdchtCSYFr5+ouL2C/tK0J7lPUyjYTFerOQ++EvkAWJYw1FG+N/MkqkZsUu1hUo1GpMi9teR7RUtimbVLcMekJ+btRBVK+89wDt7MPCs6ReFK1LxuJEiIzNyn8dPdZM6O5EveaJfIIBXoBeczdovensLFWxyxrfK9Ak8OV2Vzop3KuDvGxQ0wXRpyDm/+zO401FurM+r+FW4XD0mLy9EwLcrTHEHxMeDMJaoQCTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------hF9aylLo0tJ0Ntt9jCFGxhn0
Content-Type: multipart/mixed; boundary="------------pTYgLfOEc0GbcLNspxQa7E99";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <951f3634-d9e6-44a5-85fe-666f6fdc8b72@kernel.org>
Subject: Re: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
References: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
In-Reply-To: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>

--------------pTYgLfOEc0GbcLNspxQa7E99
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/12/26 11:15 PM, Brendan Jackman wrote:
> This code uses flag equivalences to try to optimise conversion from
> GFP_ to ALLOC_ but there's no clear reason to believe it makes things
> faster. Even if it gets rid of conditional branches, it just trades the=
m
> for a data dependency.
>=20
> CPUs are pretty good at conditional branches. But, in my GCC x86 build
> it doesn't look like there are any branches anyway, the compiler found
> some conditional instruction tricks. (Caveat: This was extracted &
> annotated by Gemini AI, I did not actually read the disasm myself)
>=20
> Old code:
>=20
>         ae50:    8b 04 24                 mov    (%rsp),%eax           =
# Load gfp_mask
>         ...
>         ae5d:    41 89 c4                 mov    %eax,%r12d
>         ae64:    41 81 e4 20 08 00 00     and    $0x820,%r12d          =
# Mask both flags at once
>         ...
>         ae6f:    44 89 e1                 mov    %r12d,%ecx
>         ae77:    83 c9 40                 or     $0x40,%ecx            =
# OR with ALLOC_CPUSET (0x40)
>         ae7a:    89 4c 24 60              mov    %ecx,0x60(%rsp)       =
# Store to alloc_flags
>=20
> New code:
>=20
>   For  __GFP_HIGH  ( 0x20 ):
>   It uses the Carry Flag (via  sbb ) to conditionally add  0x20  to the=
 base  0x40  ( ALLOC_CPUSET ) flag:
>=20
>         ae63:    83 e0 20                 and    $0x20,%eax            =
# Test __GFP_HIGH
>         ...
>         ae6a:    83 f8 01                 cmp    $0x1,%eax             =
# Set carry flag if 0
>         ae6f:    45 19 e4                 sbb    %r12d,%r12d           =
# %r12d =3D (gfp & 0x20) ? 0 : -1
>         ae80:    41 83 e4 e0              and    $0xffffffe0,%r12d     =
# %r12d =3D (gfp & 0x20) ? 0 : -32
>         ae87:    41 83 c4 60              add    $0x60,%r12d           =
# %r12d =3D (gfp & 0x20) ? 0x60 : 0x40
>=20
>   For  __GFP_KSWAPD_RECLAIM  ( 0x800 ):
>   It uses a conditional move ( cmov ) later in the function to set the =
 ALLOC_KSWAPD  ( 0x800 ) bit:
>=20
>         ae72:    25 00 08 00 00           and    $0x800,%eax           =
# Test __GFP_KSWAPD_RECLAIM
>         ae77:    89 44 24 30              mov    %eax,0x30(%rsp)       =
# Store result
>         ...
>         af2c:    80 cf 08                 or     $0x8,%bh              =
# Set ALLOC_KSWAPD (0x800) in temp reg
>         af2f:    45 85 c9                 test   %r9d,%r9d             =
# Check if __GFP_KSWAPD_RECLAIM was set
>         af32:    0f 44 d8                 cmove  %eax,%ebx             =
# If not, revert to flags without it
>=20
> Testing with a modified version[0] of lib/free_pages_test.c (adding
> printks with timing)...
>=20
> [0] https://github.com/bjackman/aethelred/blob/2ccdc84ef087c2a631914f58=
e106e99e19bd3b98/page-alloc-test/page-alloc-test.c
>=20
> Old results from a Sapphire Rapids consumer CPU:
>=20
> [   67.157118] page_alloc_test: Testing with GFP_KERNEL
> [   67.157122] page_alloc_test: Starting 1,000,000 allocations...
> [   70.704446] page_alloc_test: Completed. Time: 3543002 us (Avg: 3543.=
00 ns per alloc+free loop)
> [   70.704456] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
> [   70.704460] page_alloc_test: Starting 1,000,000 allocations...
> [   70.944672] page_alloc_test: Completed. Time: 239980 us (Avg: 239.98=
 ns per alloc+free loop)
> [   70.944675] page_alloc_test: Test completed
>=20
> New results:
>=20
> [   70.079015] page_alloc_test: Testing with GFP_KERNEL
> [   70.079020] page_alloc_test: Starting 1,000,000 allocations...
> [   73.669396] page_alloc_test: Completed. Time: 3586954 us (Avg: 3586.=
95 ns per alloc+free loop)
> [   73.669402] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
> [   73.669405] page_alloc_test: Starting 1,000,000 allocations...
> [   73.905084] page_alloc_test: Completed. Time: 235496 us (Avg: 235.49=
 ns per alloc+free loop)
> [   73.905086] page_alloc_test: Test completed
>=20
> Seems like a wash.
>=20
> So, drop the flag value coupling here and let the compiler and CPU do
> their job. Superscalar CPUs are pretty neat after all.
>=20
> (Used AI for the disasm but the rest is all manual).
>=20
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

With the alloc_flags_nofragment() adjustment,

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------pTYgLfOEc0GbcLNspxQa7E99--

--------------hF9aylLo0tJ0Ntt9jCFGxhn0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaizo0AAKCRCGXBN6rc5S
1kMkAP9bzvsGcbgKObEHIB7zwKaD9KDRDhVqacr4Y57Bgs8rpQEAg98esywp6jDi
pGg064E5KuAIpaUirNOoxQkip2fxCQI=
=R0yJ
-----END PGP SIGNATURE-----

--------------hF9aylLo0tJ0Ntt9jCFGxhn0--

