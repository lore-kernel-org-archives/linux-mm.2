Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33923CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 04:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D86F6B0005; Thu, 11 Jun 2026 00:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489176B0088; Thu, 11 Jun 2026 00:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F0A6B008C; Thu, 11 Jun 2026 00:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0F16B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:57:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C95AE1C309F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:57:43 +0000 (UTC)
X-FDA: 84866424006.09.459F69E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 23DED100003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:57:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ovoH7RXY;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781153862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPXbXmseReDxlfFLMEq1wKW5R0sBDfdHAGp/dzQ6skg=;
	b=KrUl04Y8lC+d71jYXi27d0xGiYFfGCrSWpi1r4zILVRI+tIf04Vv4SClgQ1FjnnK7eZ9Qr
	X1D9J3IIR8KOW8sWykKVyWmWo3hqOdTY+R2m436Xa2C2eP3wNlQgUNK3o3oYMVpT+Ep9Hs
	vIB+uqQcXvXHH/KaMmkr09QkthNNbts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781153862;
	b=CoHvsRj23AYHO58BuqWyg3mxWpZbP4BiEfyYmweX8xtLQ4qDJaY92bC2ngIJdLpeV5Xn5D
	uRubFhGQwGmG7U7mdw0IG5kGn4Kv5nSEOquQHpd+oit+XFhzPGXPifwftWwyFfff7hchD0
	i4jKTUHZKH2a1rkuv7pDDLsUWS/CSVw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ovoH7RXY;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7775860208;
	Thu, 11 Jun 2026 04:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9780A1F00893;
	Thu, 11 Jun 2026 04:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781153861;
	bh=rPXbXmseReDxlfFLMEq1wKW5R0sBDfdHAGp/dzQ6skg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ovoH7RXYEpV1zAeJEinykeprmqVgXdFWDCWcpQLn6fgXzXhY3UlUqtf4JtXqz2cLS
	 FJo4v0tTeZSl3vT990E1U7UFovkIirYQ91CSoD03B/BMvpc4AmrLiOd69kN7d9oYcY
	 q7PCes77Wwa/1snwRzYun4Ui4XCOGC7hNu4UnjqgXFiAbQxhMUCPgPfemHYbm0Ebix
	 jIWqIYNM/4KH8zIc8aLMZ70l55Nk2PlSmlrx9/u3GL25Z5EORRnyKUOLQKfObPmhZw
	 rw54uozu9lDajgan0qRSkHYZzpAXoKR7+M4Dp7fahnMc87fpr91QBFuaxx5/g5XiQz
	 Np+FVrD/wtYIQ==
Message-ID: <80afa9ac-ed48-438e-a18d-87aa8dff23c4@kernel.org>
Date: Thu, 11 Jun 2026 13:57:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/16] mm/slab: introduce alloc_flags and
 SLAB_ALLOC_TRYLOCK
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
 <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------zrehXDAjlbhFhdK5H063TW73"
X-Rspamd-Queue-Id: 23DED100003
X-Rspam-User: 
X-Stat-Signature: znoui34y8h9rpksm519xsqw4dsx6aye7
X-Rspamd-Server: rspam08
X-HE-Tag: 1781153861-910182
X-HE-Meta: U2FsdGVkX1/ElZ3wRWPkvUao2axmzfXjbOlUJkjNuGouDrnhMflNnEaHrfpHeTj1vDAGvqBpf0jguNwqnVgofoKE8/wS4lelifFgCsuW10YArmXgmAPekWboQI/RyE2fa1FsXRx25VXmW897URh1XyVzzZCVYTLX4c5dikx+lnHUmuZfcTXrNjGkuMgw6ImCdpbNJ5C1YHWyoo5vJjmH/yI8lteetOEQmOWh7BtRpcfWuGKkvk89lfaUo2lJAx8JEpzOAox7REanwzvIFm6c+7tcXXmJluphfuDQaFZdsXNYKT2dn55lBbQVse+zEQ8vXS/SzY3TN+aKuVPl57WajkbdoIcU7E9pDBGlYg7Ye3SVbuAQMzwZpqZ/QyYSz/jLwLbIZ6YDcY+ZTXFd/r/RLZt/y5ydpR1WUJ1BeLGifnn7OD40a+/Vsj72SrORhD04y3jOJgNmEdNY/fTxaeZxBTrt2h46avoNkWlqg27i8C4fxpffY20yS4ZaR8UpBB/p6s8zlMXL/TGP/fVKWJKzu75+ImfLrxmHTw42Qg6EfEu5+zd+jxL85MTE43V0bMXMkFJdS5490M/TYbRMYlJpOfw+PtouxXWO2o4ijAQoUzkudzmmNjLBaXd2E5+bqQRoSC9mv9f2Yy2rSv6TfI4+fwq0ogO7hUVHxkAsCxBLq+sKVKJ1LR6GRAu+0mlEVP3PkuPQbcxOLPCs2A5ektRlNfz2X13LARvE6mg+obevyTlzoH3lHUlDupS8WPKuHoaPV2VEGFm0wubyLE78eNjlBUBSfQrz7HgqcxXG9rZSPDqQNIT/ZdzGcVxt66LKIBDM6syn+LU6K0d48VGQZ0DmGTpZQWfCroEFUjXbr4rEtV5I5MWmo6+vBIjQtx77X6NYReUcv9ti1iVun4V5FW3wB6P7/AMfZn5E+rsFWkzHO0jifsP9sfpfFXS0P34Rbl/ujiLgbEMIJFHvyfbt/XS
 Ky/RXUMg
 HSc7FEFkTQQ+E26YyOW41rs3DAfAyIvvAzLmxvtwZiUgaM8d6o043SDU1isim/rperB3sZJWJfprPd5e18xx42leo5+H4QR1nxBU2yu1f3IIpUP2sNiS2cIE9D1pU26SVGjW4/z05AKI0K/4lto2DwySd4Vcw11EpYFZKkVBP067uwXmnjkI9gFKQvP8G5cL2vXKI5ynOHHvjAGYF++2coldmko+jFCyf7mNbehtff26MAZdYJaaz7pySsgoRJvyhNg26JI8zXWnk3TEIofzZrNRwr20Uu6Lvn2pg4Zch4547CEXSlCdfn2nhSTpeJOuPF+h1ytJ3VXGNBORMkYnsLHdYYAsLYUx1eEbWYM4GiHBlpTAeUo/UUC1PlabzzwpnoAY3ljzZYf++Ys20U94B34cheAjgdtZpqWw/SI6Vf/pt7EGQ41bETTjk+D1CTk+Vt63ySaUNX0PMLLgYk7DlgtBkM8cBSkvDI0bN1wm8F2W6kqV0TmQwUKGDIksAp/kIXCN+7pa2YkgqZ7BkQe7fsz+zrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------zrehXDAjlbhFhdK5H063TW73
Content-Type: multipart/mixed; boundary="------------lp6v3Rt10tV79iXTePM8CevI";
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
Message-ID: <80afa9ac-ed48-438e-a18d-87aa8dff23c4@kernel.org>
Subject: Re: [PATCH v2 05/16] mm/slab: introduce alloc_flags and
 SLAB_ALLOC_TRYLOCK
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>

--------------lp6v3Rt10tV79iXTePM8CevI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> Similarly to the page allocators, introduce slab-allocator specific
> alloc flags that internally control allocation behavior in addition to
> gfp_flags, without occupying the limited gfp flags space.
>=20
> Introduce the first flag SLAB_ALLOC_TRYLOCK that behaves similarly to
> page allocator's ALLOC_TRYLOCK and will be used to reimplement
> kmalloc_nolock()'s "!allow_spin" behavior. That currently relies on
> gfpflags_allow_spinning() and thus the lack of both __GFP_RECLAIM flags=
,
> importantly __GFP_KSWAPD_RECLAIM. This can give false-positive results
> e.g. in early boot with a restricted gfp_allowed_mask.
>=20
> Also introduce alloc_flags_allow_spinning() to replace the usage of
> gfpflags_allow_spinning().
>=20
> Start using alloc_flags and the new check first in alloc_from_pcs() and=

> __pcs_replace_empty_main(). This means some slab allocations that were
> falsely treated as kmalloc_nolock() due to their gfp flags will now hav=
e
> higher chances of succeed, and this will further increase with followup=

> changes.
>=20
> Remove a WARN_ON_ONCE() from refill_objects() as it's now legitimate to=

> reach it from a slab allocation that's not _nolock() and yet lacks
> __GFP_KSWAPD_RECLAIM for other reasons.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------lp6v3Rt10tV79iXTePM8CevI--

--------------zrehXDAjlbhFhdK5H063TW73
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaipAQAAKCRCGXBN6rc5S
1liHAP93IfCcefH4oC5NqVaMFx2nH2a1RYl/VCXiuzTBFVHwygEAzw865aRaoheL
3Yd7pXejrNcoaV9GzniJGj0nDB+/Xgk=
=IIMK
-----END PGP SIGNATURE-----

--------------zrehXDAjlbhFhdK5H063TW73--

