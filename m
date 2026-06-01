Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71793CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501EC6B0334; Mon,  1 Jun 2026 07:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2B86B0335; Mon,  1 Jun 2026 07:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A09A6B0336; Mon,  1 Jun 2026 07:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2915A6B0334
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:28:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF1DD1C1C88
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:28:41 +0000 (UTC)
X-FDA: 84831121242.20.6360E50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 165AD2000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:28:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhI57ZVU;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780313320; a=rsa-sha256;
	cv=none;
	b=iEqSF27a+AVgkfxJWfvRHHuyAin+tPpzxV0uPWSin+yzUDEx9eOVUIR/bK6BzfD0DExyD0
	Qrqgu07u13fls1s3zjyVq4zFqW7QtnJJ4u1HyBohjSjL4w0QzuNQn/dsDPZLZ9FxcSQ0Mv
	VQ8zQBZtQUfgE8+fFCY3TjlqEUtkZ1s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhI57ZVU;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780313320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdxqPDkGONuSRMCAaVwsXelgusdJH6v/cM6qWrjIlXE=;
	b=MXmtpHboz56jy+Khci+oPA8sVC/Ga0I/nyy5VIba1rdGhSGwP9WQV6XDYkjZvCc6l5m+yB
	2Ds358bjj4pUqrHFy7CDmftrlhiKupvXYrY1mm20/S1CwRcoLxYLanANwE/XmYR/00KMt8
	F4gE9mPWCGJaYboXxCwBT8gF4TWRrEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D55543881;
	Mon,  1 Jun 2026 11:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A2D1F00893;
	Mon,  1 Jun 2026 11:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780313319;
	bh=OdxqPDkGONuSRMCAaVwsXelgusdJH6v/cM6qWrjIlXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BhI57ZVUoZcW7IuNj74YRyvJyWPFtbr7fKRPSavUCOxuGcqwjebxgJhVJalYzAHkN
	 ZDAm+IctEKBm7NNAqoYxGsRwIKl11I2lJc3kmewcCJsAV/sJHwRhr3rjzEjv9xQHv4
	 AKwduZyqWTZTj3oJj3jq5LGniqflkhOmivvg8AiBNp2HTIlwrcXBFqhJ3Zo1LvZnQz
	 bSTaIGL9Jdp5DorOICI1CxL8hPv4iDFDKwVd73qumbMZZ3ATonFvd/4n/nLIPstHN2
	 Ah5DEnlhJQ0E0pghVmRLoYLjvVxwyQ+POt/C9anJ11g6mU7GLtdMTi/F4uzhODtVjY
	 a84IeYDjsp/6g==
Message-ID: <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org>
Date: Mon, 1 Jun 2026 20:28:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260601095706.106551-1-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260601095706.106551-1-hao.li@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------gZR6oAjp607qvy5PQJZS0GJB"
X-Rspam-User: 
X-Rspamd-Queue-Id: 165AD2000D
X-Rspamd-Server: rspam03
X-Stat-Signature: rwphjozjq4j4bayyygnndc1xdub1bcht
X-HE-Tag: 1780313319-378555
X-HE-Meta: U2FsdGVkX1/EYBPTNymRDITMQGXqKJBXdFIM4qFWr4nSfkf3Lh964OUXyJujWuVNvSknBDbxA1A7MycmkM3WMH5IW8doTWDeXgTaDnMKwS181MZUUm9mTSgy1tyWu7njrUES+Q79P0e90vwDgi6PUNY+qkcmh3zVG8xmerBAfQLwitLZ1JPpIz5yvbx40FHb/PF+bVTwl+/CL1MKfXvafH54/erI1I7PPQ2Go8Om2xjwXfQWuOLobFO2XLd7rnzvwdF57OecMuaKlFE0StUYIqCd6d2V69o2AJ543ssTkvPc0kbX5rQXMPjPN8wN5LBxkwx8iwOXm2AHKLwOFakCScRQBSbGoP4eAsuj515TSKg8ZgDVyHccty38B9PA7kwHzfjGWCy/hL4gT5FQii5T9X+QFTNXh8y+qRjM97ExWTMIuTQtvvjHrbBgfOTMLvHOkRXNClU/0Bfnkpj/uZpe36EmTVBUh5tiDe7RqoqYbNLOdUUMzSFyJ5jW2oLRMPzBuhIOAu375CPb4I8VzXC3owdUcnVZy8d6/QTdMyNqbRVuQkD6mJz01mtBByHXnGLLl7VAEpW5/eYr3wg54bKA9+Im/3q0AY8SzEq7LSYmJuLShgjYtwJJFn3ZgMINMQEMag6A4tBIT8qnzHgOLiayzMTRtvO+EZWEMPoViL2j56AUOWi6sRuuv8Ec13K+Kba+9/T8epnGKt5bz2Px8Rt+U7ZmbaoFFQ6aK7JuV/ZPF10RR7wXrlSXor8slkyfZqdQHhE77YWQmA9MnXRpRyAXtol96TNXciegtFp1u2duS1h5tmaJDWJUJpxP+jw6OIG14HFn93gBMC7VUrSOv6RQ/LnbGl13nOHy8XwmXNESfI2i1nugv3E6erIbx9L4yNz9aB7QJui/z/vS4XcOMChpAi8uVip7khYkOXX+mfCvyHb5cBZ+MOGjNvbAT5GjoKhV9yRpwYiBv7M7JdHudqu
 j3Dtc5Pa
 Or0gKTb/4+3BajfLKzRO48ThT3Dwob8uvEhTB6rNcZeXrjwNInmcoh2ZdCbZn0WBtfltfxVg5c+J92Bew9oPhWHveU9Xy4KKPQKTDzzMqRBmHeOUYpANYvRPrsiRNeiYbztktvk2bbzNNbNhd4mSpCM8cNALyb/nkuMX6kxoDdT+n8B61Fhp2UElL4P1HQ43Sme6eBJkRW2fcb6IbaaWkE2fR94KW0bybGGhI+H0mNsHrfpHhYK2pbC1NygnEwLnq12g7YJiLM8CAghazvlWPS3uttuatP7lWCc7rMSdWUnisg3Aav8sauRCpOYuiLzHUhs75YeSkIoVMyvSti31X/829fboI5TdBgyTWjKOQMGkB48UKFXTTcE3Nig4gzPkgp37GomCilp0r5ziNvVggy9M6u8GhTrLl5qV/3KWioztFXZ63LD+anV0R6swYE0NtBhe+X1QboU7ecLZJzUdLsQyMHBD8E+54HPJb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------gZR6oAjp607qvy5PQJZS0GJB
Content-Type: multipart/mixed; boundary="------------wYzRs4T6OquX0f6LJe0JbpFA";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org>
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
References: <20260601095706.106551-1-hao.li@linux.dev>
In-Reply-To: <20260601095706.106551-1-hao.li@linux.dev>

--------------wYzRs4T6OquX0f6LJe0JbpFA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 6/1/26 6:56 PM, Hao Li wrote:
> Sheaf structs are exchanged through node-local barns. Since barn struct=
s
> are already allocated from their local NUMA node, this patch aims to
> allocate sheaf structs from their local memory nodes as well.
>=20
> To achieve this, the obvious choice would be using cpu_to_mem().
> However, init_percpu_sheaves() and bootstrap_cache_sheaves() iterate
> through possible CPUs, whereas cpu_to_mem() is only initialized for
> online CPUs. Therefore, we cannot use cpu_to_mem() and instead need to
> use local_memory_node(cpu_to_node(cpu)), similar to what
> __build_all_zonelists() does.
>=20
> The primary goal of this patch is to improve NUMA node locality.
> Although the actual performance impact is minor, it still yields a ~1%
> improvement on a 192-core, 8-NUMA-node system when testing with the
> will-it-scale mmap test case.

Oh, nice :)

I have a question though...

I wonder if would be better to handle this by e.g.) not returning empty
sheaves back to barn and freeing them if the node id doesn't match and
it's not a memoryless node.

init_percpu_sheaves() and bootstrap_cache_sheaves() are not the only
places that can allocate sheaves from remote nodes; sheaves allocation
could fall back to other nodes and then SLUB could keep reusing those
sheaves from remote nodes even after memory is reclaimed.

If this works well, we probably don't need to handle it in
init_percpu_sheaves() and bootstrap_cache_sheaves() at all as they will
eventually be freed, while covering the other case too?

> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
> Changes in v2:
> - Make init_percpu_sheaves() use a NUMA-aware sheaf struct allocation t=
oo.
>   (Thanks Harry)
> - Rebase on latest code.
>=20
> v1: https://lore.kernel.org/linux-mm/20260525082312.16012-1-hao.li@linu=
x.dev/


--=20
Cheers,
Harry / Hyeonggon


--------------wYzRs4T6OquX0f6LJe0JbpFA--

--------------gZR6oAjp607qvy5PQJZS0GJB
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah1s0AAKCRCGXBN6rc5S
1pYiAQC8Uw1BtxMqKzwMMtAlDU2HaGd9Jsqp71ILar6fE1WNjwD5AWcpRWU6LqFK
qQGFNs4d+y0k1XJbJcwpMPhueKqtEAo=
=RumH
-----END PGP SIGNATURE-----

--------------gZR6oAjp607qvy5PQJZS0GJB--

