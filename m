Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136E8CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 04:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB91E6B0005; Thu, 11 Jun 2026 00:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E690B6B0088; Thu, 11 Jun 2026 00:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA59B6B008C; Thu, 11 Jun 2026 00:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA1996B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:49:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DA241A04AD
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:49:58 +0000 (UTC)
X-FDA: 84866404476.30.A3C1DCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D69C0180006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:49:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N5CpSLPp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781153396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNQdVwOEOxeCyvRTasmqrIIyEOikW/27X0E0Tz9+AWY=;
	b=wPpq/3OztvU0vhHwrDdFwvgnRHDCsML5YwF1aPKHmYCLR0WyKMuR0mW56QPcLj3J6wszlH
	Rm0rRHMRB8m+qwu1aTy7JDg+Neu9MLExzsjEhHRkaiwq1k1nlVZi7ker74V0fjP/yuR48C
	W7QC7WMIMvdAY8XH6uGjRdFFC2A8Ppc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N5CpSLPp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781153396;
	b=c/IKtQoB/SG77e57sYVyksqvIpFAQf+ddwB0SwojbTjZnU3qILPq/wM+0mn3qZOIGt5fdt
	w6DvNgsfhH7WiiM/cL0eBs5GhGFpn44/TFqRzbdze3iIxC5+Av/UkypOwmQoDpO4kFS4TB
	HDZraYOL1nwjmjCLy/ygKYIt1emN8fQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 303386020C;
	Thu, 11 Jun 2026 04:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509F11F00893;
	Thu, 11 Jun 2026 04:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781153395;
	bh=WNQdVwOEOxeCyvRTasmqrIIyEOikW/27X0E0Tz9+AWY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N5CpSLPpw35rjgyCRj5g3Idik/9lkQPRLsBBrkJdY+yNG8r6KCnB+VtI4cGHIVw9F
	 q+4fhjsda4gJuPbp5UJsyriDv9ESO62GadS2+MRzVYfD1/eKJuOApBaB0lnDoHziMv
	 rlCUbWTXIMqDyiRWIf2tCuq4TXZuIiGSAADu5K+M1SJhWpGOEHKGRz4nj47U1Sl50P
	 tWsWIn2b92e/EYQChSyuRCScQ6VlgrzXMett2OdUvxz90gfqpeNk5SU8VkEUSrz9vB
	 jybrIjxn6fGlGdoCAt9YvXjm2BEWxhEbn4cTGeIBs6PEnffTwsleFuQj+rtKkLIG0e
	 H3XFaAsHfYtOg==
Message-ID: <81e13eed-2029-42a3-8e1c-4e92249a26d4@kernel.org>
Date: Thu, 11 Jun 2026 13:49:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/16] mm/slab: introduce slab_alloc_context
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
 <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------c4VlE0FE0HgTrGzQd9oZjEzB"
X-Rspamd-Queue-Id: D69C0180006
X-Rspam-User: 
X-Stat-Signature: 7mrusq7nstxijzudqnptm69fi784m94h
X-Rspamd-Server: rspam09
X-HE-Tag: 1781153396-405481
X-HE-Meta: U2FsdGVkX19vBZzJTQpOwNnpisc91UrZSh5oyEgwkXw7MKOXkOfGIs9xQJBpeP+sL9cEKMYeELFXRiIcTWAUJdionoB5GyEc1GsAvCJlsekGM9wJvYjRZTyWQEHHsdB0qT5KyhoJAwf8Rud37ucJ651tDFX5YqRgTzjMxH/cve9DIYKPKsqciYleSKEQk1Uj0V4kwfZ8qWDb7q2ntX1hjgWTXqEu55FB90LeLQsPWYcWsKdpL35LpKzx9xyz9jCm7PPivCPtddNm7qbEbBqurPy3cdpE1U+cwzq0kvwtG+s7vyX6/QVAFHgp3haP/vAP2Tobbw1tvBqkEOJXC2mSkwoTNLbMhja5kpTfxxgRqSWekisq+YohHa2DfBIWBZ64Wv5tQLglCLS/2s0QO3AeG6sFOIMNQA8X6Z7ytiEnfVohKqsp/bljMtvx6LoXEqc7x1WZGBP05XB0WW+7xBUZ1XGn++4egQRoXdcNE0f3fJAfItuZlOsZ3DRqzJUKzRUr+K1wdKi3VqK7AlPVp25UZbS96IBgfE3h+XoqcWLiFvKvJjbskTauqzuXRF8JKJ7MlVQGi5TmijmVP15G1f1IPJyz6wP45f8hLMHJJFMLT91klUhWPz7TB2aZ0Yl7V7Mzp5pUd4gbnB67hr7cNloNrihAM2huLiY6tKeCyqhxiB81vHJhJN9VjIWrt9g9jEJeofwHIrTh6EZiu/GkaiWYwJKvJDtjcNqiSCvAC+537BEL/+z6E1YosDq5e1968hk8Pqb+Bf6RGRI9AAhAIfRpHhgMgS6RtQ1yVLYZKJeFJCWxelfPHRR/GaQJnCciOhRI4IbuxUu+DIwtOiJZFULLdesPqWC2GphB2DnsmxzaTzQ1noHyCVwdWWOPNL62wlQi5ZeKKJk86XEuuEEwuP8sGBTlObwk6IYrXL+C9s2eczQRAk3Uf6ipBj+EYUrhltYDjj2TAozyQvNYpyvAfjl
 fzSoExEh
 JUrCyL9eBwpinRulWXGsl1g8tC5knaR/xCuoNc4lZhQwXw+L+KT84gi7Bk18hIu0M+5iCygZisw5A8EGUShDm1OkNqDp3XC+4Y9omZuD/fchr4+ww6/NszE//HChH6TK0rzY+7vYstZ3flSUwKrdkjsoS7BL++q09hhT+U/Wm8oR1z82G/nvMxJhDcSxQRhLMMd/gMkKK+e0LuZxymvLFQ8fQdztQbBfwcvQQ+XMDB0mtpVtyBcGPz3i++BirvrI/IdbxlAmo3coA3zinfvdmnX3Yo6d5HGffcchnqhZ8l2YvZu1lMBG63/WHwDwmZldHbcKZWavwEtOwi0b+ssAhgxHDXMtcpmQ84DL55oegJSCYWBkIxF3hbeXTncA8qJ16sxH+d0WRXF9FG0SBf+6L3Ut3oSQLqMN0ZXNTIa8lYlyZsgkBa+uvhxXmOm61wAOISenEu/DmF6LKriGGpHtg3LUT0TCWUHATaA/QkNCNoHELjFIxHELiqPvS09srtmJYx5u/qjZg4wQeBXjPm2ZTgRxNCceq8D3yx5kRoDCTdy9isjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------c4VlE0FE0HgTrGzQd9oZjEzB
Content-Type: multipart/mixed; boundary="------------YSxo34ALkfgVy406qadRCbTw";
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
Message-ID: <81e13eed-2029-42a3-8e1c-4e92249a26d4@kernel.org>
Subject: Re: [PATCH v2 04/16] mm/slab: introduce slab_alloc_context
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org>

--------------YSxo34ALkfgVy406qadRCbTw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> Similarly to page allocator's struct alloc_context, introduce a helper
> struct to hold a part of the allocation arguments. This will allow
> reducing the number of parameters in many functions of the
> implementation, and extend them easily if needed.
>=20
> For now, make it hold the caller address and the originally requested
> allocation size.
>=20
> Convert alloc_single_from_new_slab(), __slab_alloc_node() and
> ___slab_alloc(). No functional change intended.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------YSxo34ALkfgVy406qadRCbTw--

--------------c4VlE0FE0HgTrGzQd9oZjEzB
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaio+bgAKCRCGXBN6rc5S
1oRGAQD1EG3lihk4VxLBIfWhXMef3vycxH4hVNES5+D1LcnTRQD+K6suBBuTPviO
6IhThfc/STOwiw4VJWaHaH39OQDDxAA=
=ZBkf
-----END PGP SIGNATURE-----

--------------c4VlE0FE0HgTrGzQd9oZjEzB--

