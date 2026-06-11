Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ADE0CD8CB2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566396B0005; Thu, 11 Jun 2026 02:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517756B0088; Thu, 11 Jun 2026 02:05:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42CEF6B008C; Thu, 11 Jun 2026 02:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 346AE6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:05:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B48A1A048C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:05:39 +0000 (UTC)
X-FDA: 84866595198.08.AAB9D36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E562320005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:05:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2XT4r8o;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781157938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCobAk1v9fNVAoJf0iITbOT1BGY69Eo1RWAE+L3IdP0=;
	b=8Afvxuu1M4yU9zSU+Cr8UhLGRENpPGmn8DhOo6CSThPyaGgyi5dyB2FCwFedgWJDn7t6Pe
	z2bkt1FJIKXA7Ol02J/jCPHVZWFRKMEf6cPjYnD2FQCPw3gCjaI+ChmI5KFyVhjlkmTTCh
	A6A7ObMwHUpyBGfm2h0TZgu7HNOoGVM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781157938;
	b=YocXKljlQ1EVzb44FXHDN/v5BRXl8wxUW5mZLPQnkU6+wCmSr9AgSVjV2A/9dhm/UV1iyT
	3NN0jz/1uuVSHq9HJDkT47NTTzPsupLZDAFyIy3mJ62dJeK+LzRyHk3H9+QYc8WXXI9HrI
	RaD4JY51Ij87w8gOnXl7bw0+IT1mriU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2XT4r8o;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1C4244519;
	Thu, 11 Jun 2026 06:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9681F00893;
	Thu, 11 Jun 2026 06:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781157936;
	bh=KCobAk1v9fNVAoJf0iITbOT1BGY69Eo1RWAE+L3IdP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a2XT4r8oIoL31aBcHxAtMHleb4Gc/zG6F4q9xprFGdnrduVq98kVvFMSv+Npbmeru
	 lCjdn1z/FvGPf+yMUK4O8Lu8LO6kx/7IJIIBHN3nh+OFgTif71AH35fhp8ToKRDWzi
	 lT0nQXzfLinRd3g9h+96+JvJuSiyomGpXiDDqi8Jjln1E57A1aUyHcmGqX5q8EH7W8
	 PWldc39RNmMOi6agX9cx2SjouHHEYZatOyJB9jusa1Rt99Hav1l4dlNPLS+wD83DAB
	 +S6AOkwLbizkluJanjzk6P+cMVRoUgW09PPbD0iTzWTzAgih1pk1eQDJJAWhzEuaQq
	 Ltyl3flw0ND7Q==
Message-ID: <f9b7935c-f5f0-496c-b55e-1f3feee5c87a@kernel.org>
Date: Thu, 11 Jun 2026 15:05:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/16] mm/slab: replace struct partial_context with
 slab_alloc_context
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
 <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------1O40a5juCIbpxLZ5dsBsgvqk"
X-Rspamd-Queue-Id: E562320005
X-Rspam-User: 
X-Stat-Signature: fyzi7wbc7ac8qr4eb874tbhn4peiqbi6
X-Rspamd-Server: rspam08
X-HE-Tag: 1781157937-163782
X-HE-Meta: U2FsdGVkX19fUuvgKjF1rGjlD6ho3Fb11Tei8isf4AyyUGZDi2JFnruqMaAdJRf9hKsqTmDBffWZA8WTYkwqKPhYrZOe1SyWRgcoLC0+n8JtvWZgkykGd6Hn5mStbXXrDFkQ2UViYpGF7x96+Xd2KPxjqvQR6n/R7XEtUAUVr7QqUEEM6nUbITp8tQxRXC5UWY3SHSlMtxJJ6uF6pj1v5MD3rjZp8S2s4X22PBGHVyL3bYt9R6dkPzBAJ2w5wK0lTjPta11HPv622bSN0eyeDmVVR+rM1WDMyH0eMrpY80Ccx8BxIJUREs7S/ARMINueoXFZWf3PxiC4GdtGhoFu1CZptAUw+y0XZa8GSDF27pxIf9W4X0oJc1xnkY8a8vB8z9G++uNZT4oQKz1HAyO6RQnaMaeDIlI3YbjxN4Ds3ZUfV0MhFBEqD0adR2IkX8ZGMNWxQkMu7SX2T4NbbAfZwVkb4hTEsR2xcaOX53LdR0RJj8WGAf85VpQLUe1KwaiqlWjpwYApaZRgJinDSunMnjpN3ZLVo7ROclhQGFsjEafoiQMuNk3IhTkR61JY76hx/xMLN/O1459IaSCwfDuKlVw6mKPFgmkgGoAyz0qFV1bEu617AatHAs+upRYoWD6XF+AgyeJxgd/Lbu4tQcOJyfFwmsHj2FiUq6Ns/r98EX+8CyC1YPqQXr1+dIl0cLGKYvjVHAPt0AaJyZIMHFQGbPEUshhmJC8yXILOQ5VjHa8ClLP/LNfi2i0EBShzUVDr2PCA74PrYtlDdX6PtMk8sW2Z7CXbAIEbg7lAneHgple6dTZYyD+yaDfvasnSJi1cOc3NI8uxkzYKAHwYwUWA9ZbRPC7L8NChZ4l+4neg/gJJKpDQmlaAzjsd3zi56W6AUZLGxPz2poQftIAHJsHAS4Cq4znOm6wwqZDG4tUtNd1bhBcJkX42m9u7ZTq6Y6Ph5IJJ4wdzK4BsmRVDNXv
 mf7oC6+i
 NafwOAXKYIXJ4fhFa9eWQxsv7Y/ZxbRUBedmB7Ki3qo6xFg6xk2ZwCZWKD0ESgqabucgnedjMDwF53hClbjAn5TDS21ePf8vuR37WE08VpVRsI9FkmSJiPQBCRzL1L2Tzhj5vKjsvzv2Jietr3Ah+QGlDdljUK0/c4b8v2j/y/l9piKCleOQwQoEOGk8X2JXG6YJQF3E8TIqTd0Ywjd83L+31RwV+o6CA1Oj/fErtn8qjfe5H2rKhneXvRv4dndn9ZfRzSn9+f7kKeCvOx22VkeGcdL7m8GgdANVbvIwdKmqz4YbWslHbdVSEkWfTCgWAqJHEYZAMrQhsasI8IQMSm/2klineFNF+2YDRK6/DyMi8DRFwoFyELCILVYYuWSQOmutk3sig2tZhUlm3htFEKcEv2XIW5/SJEKPlDWCaXCx7T3NAo0dk8jqw9n+qnJdZ63gcKozL9r2zBm4r//MJjvstPYMREC/qyQE1w+tK0pdj1pNC3J8m/9ICIQbnjJHgCYl11j0JSzl+3faDcDbW25ePOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------1O40a5juCIbpxLZ5dsBsgvqk
Content-Type: multipart/mixed; boundary="------------7WEiTOn02pyYbf3OU7fSBKOd";
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
Message-ID: <f9b7935c-f5f0-496c-b55e-1f3feee5c87a@kernel.org>
Subject: Re: [PATCH v2 07/16] mm/slab: replace struct partial_context with
 slab_alloc_context
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>

--------------7WEiTOn02pyYbf3OU7fSBKOd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> Refactor get_from_partial_node(), get_from_any_partial(),
> get_from_partial() and ___slab_alloc().
>=20
> Remove struct partial_context, which used to be more substantial but
> shrank as part of the sheaves conversion. Instead pass gfp_flags and
> pointer to the new slab_alloc_context, which together is a superset of
> partial_context.
>=20
> This means alloc_flags are now available and we can use them to
> determine if spinning is allowed, further reducing false positive "not
> allowed" in the slow path due to gfp flags lacking __GFP_RECLAIM.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------7WEiTOn02pyYbf3OU7fSBKOd--

--------------1O40a5juCIbpxLZ5dsBsgvqk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaipQKwAKCRCGXBN6rc5S
1hN2AQDWJkWZRiTjIEVAqbOLRNnR7yDNdfBWX6DI98H+AvJzHQEAqj6jWeaKqi19
xu+cPt/SkA9DOj9yVbTLCWbf+IbJeQA=
=a3Ad
-----END PGP SIGNATURE-----

--------------1O40a5juCIbpxLZ5dsBsgvqk--

