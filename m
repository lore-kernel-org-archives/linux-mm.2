Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5B4CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D816B0005; Wed, 17 Jun 2026 07:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744296B0088; Wed, 17 Jun 2026 07:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684226B0092; Wed, 17 Jun 2026 07:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7696B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:16:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3806C1482
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:16:34 +0000 (UTC)
X-FDA: 84889151508.27.2E362D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6E4FA0011
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:16:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gOoZArdh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781694993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rnPd2MSt1vwOoN5rRd8/PQGwWGmqtToaNtSJ9AESsw=;
	b=FvuXj0PmKBjMEdOHRbzDNRHTvJCMEZbn/Z0bM9KE/1bT7z5JdxJTa47MtgV0B1ZHUYe3kO
	s9Ptjcb0ZnYZMYY6gzbJJY3oRBHBsQGxCAdI9JUTbKm4SicfbwFCJNfN7OLMXyrwnMlLXY
	XY/rv0335fQzOm7hB+EM89OxkMbvQL0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gOoZArdh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781694993;
	b=tKPA7eObwoEb1qwh2XJXgLJMJOjx3bM6eWenjuXaE7GJTPF8ugzsZ+52cU7R7H8PaRVIuO
	P6C0ZVWArt+tydteEhzDRTozr9w14G9YdwmVsel61IZYl0lroRrH6X6lFsOZNMAYhpkHfb
	TCldDDjmG7eTnxQZM2meUY26MVp9NY8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 289DE43CA6;
	Wed, 17 Jun 2026 11:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF641F000E9;
	Wed, 17 Jun 2026 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781694992;
	bh=2rnPd2MSt1vwOoN5rRd8/PQGwWGmqtToaNtSJ9AESsw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gOoZArdhBL5WquhQUqQhY90uMk+cX0ytq2vILPFsG04Kcu7pbgM+rJlgZGYKmAV+Z
	 EeDMupv5/vAOrRL6BHCjH/aZiBD4lwt8Fywe4QNYbU38ljKy/62HpEdz4L2uhDw+He
	 oPedq2y1GqHboyOLFSU8/J+FznBem5XaepHdcIF0u1uk1dG4cOAokcIeY9pfcOyqee
	 J6PtH9dOvJPxNZT61rXHn9IPaXYdsEtZpighL7/LkZyd5pukIsJZSBTN39pVwOy2zB
	 yT3f9aw3wxyKNmPccs60UW1AminTZTAhbuH3yiD6FsSDgfZfI+PHFzyyPx1TTRZNkO
	 FkAzeejkhaf+Q==
Message-ID: <22d6cf47-b8cd-4495-8b33-2e9d645fac3d@kernel.org>
Date: Wed, 17 Jun 2026 20:16:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/15] mm/slab: introduce kmalloc_flags()
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
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------h0Nqf9c0wfHouf0LoBxkrjqk"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E6E4FA0011
X-Stat-Signature: oo63tzq5pxe8psere4zrtt5iqpfzgzc6
X-HE-Tag: 1781694992-846491
X-HE-Meta: U2FsdGVkX19piKIkXAYHipYg/9+s8p/85nHJXUNIt39tS3y7yhkJNxliXgUNCvowb4cyfS7p/sUU2WFwkdgwf2zOtnMhaK4jVNLSYqILXmOqRkQOeo32G0XdQlAc87pKEHqQp8eBdrIqb3aLkawTjTyoc0yeKu1Kffe3YFKP8hSlI0b72UyJ/Mhjzc8USX0akPHTBlfuintcXwLcrCR4o4oGFWadHldKy25frsUn8mb+yt8kly7tnkRNPwidr0h114oockPBqoeVE7bseHoLhJRiWQr9rLegDmfUuNj8BWqNHVFBNd3q//NlmMI8xXe1Xx3NVzCaawjQq7Dk21lm6aQEwUeebBsAnTY570vO0kp5N/INxO8gUodDPpnN/76Bq/bfhZspVNOJnVuEqFrMY1WMnBst1ex3fq2SWWcogecz0c9E1gqzlhBm5aCkgEtnU7856YnG3eUHgyyOFVe8CuQlrDkk5+Af2VFMAsqeBS/c/wJLLNUJEYKIpXZ//viarcsk1ubkAetZG9nqcQ67uI35kVJqNK7HRhg8xJ+9ABe+lRSFhcj74gb6nZmj/BKhYUTNbPHs6G/vJXP3NeGD6bmCmDzpelOYgmWkGPjBPoOun9LvxcBdi7h9LJKSJaCA7RVK3YxkAy4ozsBYr3x5hYJrKA2gsteiaCrzVKOeGvnYWIHYcWK8bUQ9Be6UUDmaRvAm+A1wkte8e93M+fspiq4fbZVjoXM5ExpqnNCzylZxyV49Xj1W2sLS9XYnVVyqrvBwDGw/Hnq7bXbZUhQHm/veXD6qSdhUHkAjMn++8mCjnbxg/gc0ddiFpfpxHhzg0a3P/mx+h1N1GXHGc26IhVCHMmPfe7KxDnRB4efjLh2Y9Dp5po3a+nojrsmi7HnmP3ky3zCZ3CDNNpHBeOxrCOkKKkvKtwFHqIQrkfMdfwmTZyAT4FcwbDnnDpM+IdCrhIXRmsgrHdPlqUS9LMo
 E7a/7Cfx
 HD1DQgfSZEDsRumf861aFIWcXTj7L4QNBf63NKzY8Zc2PXSaPotHCzg+nt+9n1vWrmXIvw/BxrZqfe1nxK4i4Pg9tZ+InQdYg05rw7QmBxn8Nuyr75HcIcTSE6oJQFHc/zUdsEq8V8y1OakJSXUfUn7wQJedMvQPQJAhASXtjMfjLyMIryett3FW+2m2Ugplikty6n7174rVwkMXMm8He+GuKmGAde/Dxp0pukWpCVKWKvB/dbzzlKJYmQdCJZfdLxSECaKrCXQz0Ou84W30m3APUB56omfPA9lGXTZrFgGIixiuwYaqQbezYfNwit/MYRGBejqgleCwtQhBzH+bFcW5W7fP+ZLflYrFJ0qcii7M1Xuy+x4K1V4T97sAII1x/sQxza2AedXbJ2XqXFRinQxfiMCal7Je5ybu+/nt5NoI/k9HLUeuz32B5TWhWNYKc0/8rOGq/ijL2eucphPffcWsLu9YBgpadW6aDzSgqoYU4fyxF612Ku7AFRo/icKwmjpsUu3zcd+i9BDyfrpKic5wZTpK5zVqKdlFzs4+LYFb71h1AyfhtHn/tkM5FiLnHxvzyiyGvUXYbYXw2kpBBh8iCvKLLlbr/f7pHbOdIGkQEKjfFcKVliGrihgEOBgo9g10q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------h0Nqf9c0wfHouf0LoBxkrjqk
Content-Type: multipart/mixed; boundary="------------2QCMyJtDnYVZ8sn4T36zDC4w";
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
Message-ID: <22d6cf47-b8cd-4495-8b33-2e9d645fac3d@kernel.org>
Subject: Re: [PATCH v3 13/15] mm/slab: introduce kmalloc_flags()
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>

--------------2QCMyJtDnYVZ8sn4T36zDC4w
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an=

> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
>=20
> Add this function, named kmalloc_flags(). Right now it's only useful fo=
r
> these nested allocations, so it doesn't need to optimize build-time
> constant sizes like kmalloc() or kmalloc_buckets.
>=20
> Since we need it to support both normal and non-spinning
> kmalloc_nolock() context through the SLAB_ALLOC_NOLOCK flag, split out
> most of the special _kmalloc_nolock_noprof() implementation to
> __kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
> _kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
> context.
>=20
> kmalloc_flags() can thus determine whether to call
> __kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
> given alloc_flags.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-14-7190909d=
b118@kernel.org
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------2QCMyJtDnYVZ8sn4T36zDC4w--

--------------h0Nqf9c0wfHouf0LoBxkrjqk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajKCBwAKCRCGXBN6rc5S
1iFIAP0XkxFaf0DXeb833MFb+xoznKV7cfz9DIc3UD2ItuB5IwD9Gh1fUPp8WVuw
KG12x0NvvlNEQNDeaqbaj9R9mbmYCgg=
=04dK
-----END PGP SIGNATURE-----

--------------h0Nqf9c0wfHouf0LoBxkrjqk--

