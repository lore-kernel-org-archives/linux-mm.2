Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 745AFCD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DAFA6B0005; Thu,  4 Jun 2026 01:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B8F6B0088; Thu,  4 Jun 2026 01:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A446B008A; Thu,  4 Jun 2026 01:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63F616B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:30:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9170C18CB
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:30:44 +0000 (UTC)
X-FDA: 84841105608.26.8747A9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5747740016
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:30:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BRneAZeV;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780551043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sJyfXerJU9iiEPT8ZT0fAwQWe3UJ8yZ+Wj6Yp6I/XM=;
	b=BWTzia0akYLFST6OMTQUNEpxGeNRvJZDqo1eT2benPzA9Tri7uNgCyd0m0cg6Bk0xYJDCi
	nQgJak8dJvsiBCXg4N+I1wOEVV5Yj+EKaA9mBSyaM8n06YiHim7/6dzjwF9Ri2qgiBIw+o
	qhiaYolQgKAKobE2kmYQ0Rzn2KeE2r8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BRneAZeV;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780551043;
	b=H3y4PQp4BD0y+hJQTCGU4Ccm73VhNjSnf6z3XRv8dpPFT6sa6uHrNOsLuEEe+3HM+P/ZKU
	gHAK/fHTxI/JoRfnrI36Tzs1pnUOlbtXP43spEog+6Yn9PELzhnzZorfrN012HGK65t2wR
	628dX9GDE6+ci25iKf1B/b1OYvwUXDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAD6E601DD;
	Thu,  4 Jun 2026 05:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524671F00893;
	Thu,  4 Jun 2026 05:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780551042;
	bh=8sJyfXerJU9iiEPT8ZT0fAwQWe3UJ8yZ+Wj6Yp6I/XM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BRneAZeVwpgn7kmaxaAgWt7ghltBXKLdOIt48MhO+V2jMeTdvfrbhJUJaUF30tK3c
	 jfyYncISAoFB740uCW92U5qld8AJZvXgOOySRWQIox3dti/zyfIAqizY5mCkUsV+ui
	 ueVmRxQG1X07meMyw+x7VDyfrM6ejNPDPOwvivSRqpRaMIgPfr8NN0x0JdSOXEyGAY
	 XfSCCnJ3TO7zdpxt3oWh0EfLbD7zS0mz7np/Gn8DdB5/np4m/zqWkcxjjeZSbtQHrl
	 hbWLrF9rIzOtikYYZGlIi8p9zF13KWyZtdPIGN/tUkjZRxj3QaV6rYdulbPytI6oUI
	 VrmZLIUr+3gIA==
Message-ID: <6d70757a-a849-4828-89e7-f3d51bf8c9f8@kernel.org>
Date: Thu, 4 Jun 2026 14:30:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] net: skb: isolate skb data area allocations into a
 separate bucket
To: Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>,
 Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-3-pfalcato@suse.de>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260602183122.747759-3-pfalcato@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------58iuvSQkp47XgPodjS4574QO"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5747740016
X-Stat-Signature: m4byezkfauuyjnu3f6s7kt1ara1opkwd
X-Rspam-User: 
X-HE-Tag: 1780551043-966597
X-HE-Meta: U2FsdGVkX19uZIUsjFcu+VURq9dAPpkZlkzhv2kiTnPUf92pnzm8mBJ3pozKkG8VP+5s9Vs9tavI6tQGPUs3OLEyAfDXmXOhCDOIxfiajK2S/TirjSVXFJpOYtGqQnNhNn/wMdVN0auoRzoajwS/Mia3+Rlk9Fei6cdOTd9K5y7u6gspYfA+xvVPh0y7ogJVx0XcmiDsP2feBZO+/piPiI+iLitY3e8M++n2iOuo9jqhYbBnOTxV0WuM1bSh+T6MgkG/lomRXX8ehJj74O1YlQS5Q08jWe49iAHPkNUkzwqNjWUiHSm3P+Rxp00NIqrEH+fOcVcDooE9NzPCD/F0SeLYRCSAHN/zEPGHstbObqz9ZVUFkgV/2w681K//n1t457A3oQ9tYqFx+CGwveB+zTQiWpzBa2JOQogGWeSvYf2/fQskUZvc33TDMmNWB2wnQ+gA+bnkkIsDzd/aCxs0w/SgO7gN6KzSyyhiIKEIrBOKVkcsPlYwYfbRtQ7FurofKbQ7nEIkLPel74bsoUPjeBHULLOAPTHLptRfMaV7/IjSQLgUZgQUsaXV7Z7rhFBfhlkI/B6tDDiQgzGXgply1N3dnLdRFlE7aiQPp6QfWF1t9NwN9t3TTactqwZYRTJ6WxI5Pr/ekpHZLijNddmSNLA1I6/ei0ZZR+QwU2fwC7QG3+C6j9kDU6PwzStEbGyvL7oj49i6O7ktvWkdC4zV9MRlxNU8BWXDLju0TyNP5fW7k9bctfaYWdeZVtYc3Ftarw2CXooJJd6HfoNzHHyBGNJPyU8AT7HwZZXG+45K7cVsZdbq/BytzRj3rbl2JfCtyRipAlNmB2crVInz+0l9pkicSJ+xpRe+F1F6W9lo721exobHJubwM6BHOYJUWkt6F96AN99XNFSNtDmXNvQXVrLWqhEnJQaXAvVfYVLJKgMakGLB1tTrWs1NVOzfO0Rz58+emYfCEYB1ry2oQ3K
 4uV5Sn4P
 L9VRgISQlnpqbVpjNt4MkpfrhwkBqhAz2nA1z8Y8wbpJ+6ftWmB+FYWFituZJQ4osnt/JjqJZaI/s6hyXv+rRyR/rxWPDy4PFxkNL/a1OBAibtFvP0h4ykYI+iz7j67jE/5lr910ieXvugZWMdFsQvF/WeO59896rmfaKKQb+ay8AHIp+kuC/gvK43WkA9REz/4g/+/nNVIrCywvvepIz6ZZ5EbAAIve4r32ngmqbtrwz6q46+LZu+MwWgfnBOsgPDWjXH+2HN9FJ/PigPM/xcSxNsP90Y0utbaBiN6waUsEYsiJRau3BVCbwlN3XS7ttOpSy5qdervUdVmDgM+MW3qOnAqt9pOdMI8maLBHdy74BTvp/CbxZZJbq1MzOo2Izbxup3lGTUx0eLSJfWg08c9GN9aIRxq/ja3rtPG1AoNKMg0qzVIjSYos3dpe6JBcqf6HfPxEekxrMWJbHq1iVDMedHeOkEB06fpygoROw+tf5m6btzjZj15WdaIdh3/qLvSkB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------58iuvSQkp47XgPodjS4574QO
Content-Type: multipart/mixed; boundary="------------axTL8uth9J2LpeygQTj3by2S";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>,
 Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
Message-ID: <6d70757a-a849-4828-89e7-f3d51bf8c9f8@kernel.org>
Subject: Re: [PATCH 2/2] net: skb: isolate skb data area allocations into a
 separate bucket
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-3-pfalcato@suse.de>
In-Reply-To: <20260602183122.747759-3-pfalcato@suse.de>

--------------axTL8uth9J2LpeygQTj3by2S
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/3/26 3:31 AM, Pedro Falcato wrote:
> SKB data area allocations (as done from alloc_skb()) use kmalloc().
> These allocations can be variably sized and their contents can be more
> or less controlled from userspace, which makes them useful for attacker=
s
> that want to overwrite a use-after-free'd object from the same kmalloc =
slab
> (which often just requires the sizes to roughly match into the same kma=
lloc
> bucket). [0] is an easy example of an exploit that uses netlink skb
> allocation to target another similarly-sized accidentally freed object.=

>=20
> While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these =
are
> probabilistic. Use the existing kmem buckets API to further isolate the=
se
> allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=3Dy.
>=20
> Link: https://github.com/google/security-research/blob/master/pocs/linu=
x/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  net/core/skbuff.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 44a7f8401468..1f6c6b531ece 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -594,6 +594,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gf=
p_t flags, int node)
>  	return kmalloc_node_track_caller(obj_size, flags, node);
>  }
> =20
> +static kmem_buckets *skb_data_buckets __ro_after_init;
> +
>  /*
>   * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that =
tells
>   * the caller if emergency pfmemalloc reserves are being used. If it i=
s and
> @@ -632,7 +634,7 @@ static void *kmalloc_reserve(unsigned int *size, gf=
p_t flags, int node,
>  	 * Try a regular allocation, when that fails and we're not entitled
>  	 * to the reserves, fail.
>  	 */
> -	obj =3D kmalloc_node_track_caller(obj_size,
> +	obj =3D kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_si=
ze,
>  					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
>  					node);
>  	if (likely(obj))

What about kmalloc_pfmemalloc()?

> @@ -5213,6 +5215,7 @@ void __init skb_init(void)
>  						0,
>  						SKB_SMALL_HEAD_HEADROOM,
>  						NULL);
> +	skb_data_buckets =3D kmem_buckets_create("skb_data", SLAB_PANIC, 0, I=
NT_MAX, NULL);
>  	skb_extensions_init();
>  }
> =20

--=20
Cheers,
Harry / Hyeonggon


--------------axTL8uth9J2LpeygQTj3by2S--

--------------58iuvSQkp47XgPodjS4574QO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiENegAKCRCGXBN6rc5S
1iLnAQCiHXHsoLVAPzu2eqLSBL/0qUnsHH8Rl1w8PYVRFrUQZAEAjAmcp39Ue/7d
KAD/ZxX4pGdrNWb8HUTS2rQYIoNNkg8=
=NWSc
-----END PGP SIGNATURE-----

--------------58iuvSQkp47XgPodjS4574QO--

