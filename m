Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED01C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB056B0092; Tue, 21 Jul 2026 01:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C086B0093; Tue, 21 Jul 2026 01:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784686B0095; Tue, 21 Jul 2026 01:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 491576B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:51:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B96DFA0B32
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:51:40 +0000 (UTC)
X-FDA: 85011711960.26.E15D874
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0DF4B40003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:51:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFbDSuA3;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784613099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwulcQRBgE2x5+Ge7Rrj6k72618TpplVq03VxdALErs=;
	b=x1G+IEdPjyRLqbJnzMAXPef4Y+F/EpYWr3pthwBEueo6GnnpCmSQIdCxkn//7W72lpPtT5
	p9GFRcebapqWiMDqfJaqn8UkFxqPRJfp4yEoQXjuV71jHRDJBPp5Ofvt0SSHQFZI+qIuay
	U+lXV+xGbDZWB1DNxm7mgWSUOh6QPiw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784613099;
	b=c2Ksly4FATZzwUkhXFpRu4MdwYnPNipkOwsZIAMN7+rWNWQ21vwWTmo+nuOuzi1pbmuWg3
	CfNq+RUjiUIOUb0vV4jrBCD/K7MCwZxNYYnIwCClNc8TZeUPurs3SQ/Nq5dLdhOv2O8pmH
	/LvUcWzGsfi4emlW1h6jhtpvqr8IfOE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFbDSuA3;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 430FF406B3;
	Tue, 21 Jul 2026 05:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E971F000E9;
	Tue, 21 Jul 2026 05:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784613098;
	bh=DwulcQRBgE2x5+Ge7Rrj6k72618TpplVq03VxdALErs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZFbDSuA3uaYk3uYbZWB+iAEDwQbDjcdPa/SlQkVuZ41E3QHDPUT80k5y3Lqmsu6d/
	 /78ZNYUTTA0fOD3wV8WVbTSjDGMsPEj7h6kOSFv29l3S32Y6VxegVUX9G6Q6FQpIpH
	 0+iNL3Pfh8CuDF5EGoCIBj2DaHMi4VAngQhJIfUkd+ps5WK5Nza+4V0qKPwlnGtTZc
	 vY9mqSk9TooZ4efIgGygHZqgrRhYWWNdFtt4ak2/F8DPBUCNr7V1SLZa4fd/b8otaB
	 3PMJbW4R99lwWbpxx01wOCkiR1ZneY8viBwVy50CuvU3sa00Pcn2RtvpBCD8DCASAz
	 3vN+Gb6SUeXgw==
Message-ID: <d76d5e96-ccf7-44b1-9dc8-3246466f9640@kernel.org>
Date: Tue, 21 Jul 2026 14:51:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/13] mm/slub: skip handle_failed_objexts_alloc() with
 profiling disabled
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ol5zVscvDvmD5WVK7eNs0OQn"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DF4B40003
X-Stat-Signature: zuuw5w5q5ticu97n9gx5fdwchctuzc5m
X-HE-Tag: 1784613098-973325
X-HE-Meta: U2FsdGVkX1+8GjB1lyyR3+4qmmkSwG41w0N+/EP63gHcCLlIR4vBY8dc3s21XDMfqpVPCEVL3JKheBCverpuHEqy44FpVE0X4VGzjoPSzzdaf566CZYC4HnS4y+nJS5mrh2+zhvxTGVfhHnpVgbJU1KdC7ASIqEPJyoRSNUIovIOGOzhDOH1jvg6Trz5gID2WCBlRIy9J99Tn0PhQ1fm8ia5dDa6leJSOqS9h4Cc3434bNBrqtHgQD4k45ue3utYC5F/dkr05KYq7w8RFOeUHI8UNczmrjUJdLAr1qQz010brYfyoENLMPPVsi1HcqriFQTG6K7pc9bYdMsT8npVPmx9t6BjJ769PsWtQxSTtQ9ehwPsJJSWI6DQK8/6p4l/i+siEAHLPdtSc6HhlRd2m6DDiFGKpD7HlY2FxGeSimifMim9jJnrHUBcWeoz2XyNL30mLUePj+qV8X+NkVsVLQRF5Hvn+kjYobJlVHzQRm5ATFM0c/Ic+eScGvPx7pCspci9miPh/kObQwj4IRRdGh1Dk8QKL89eqNJI3tyJMt+2+NBBnzycaYp1vJhCz2ziMkuAHiGm6p2CYdcpfPcCly0kZdSxFoHHEqYptkMR4JKhqxEnwCOVgVDEvX8qtbU8TqvVSYIs1ZhUkZ5RivgTHpvXlJJXimnehFZo5Hza3Wiu5kwJCwQoTmogqm2XbyCy9lbdm0p6Y2WLyQTL2pcG/gBXpdEC6oDQCod9w1IyvN/dTfpjRj2l2ZGphCBPEnmtw45c17dQLT4rcgkZnC8LnxCioHRIEvqjoj9gnRJTuth/U699TP9KJshvFDC+LjKon7HKU1WevA9wIM9syQf2bXrdU4dRCb1cvy72wSS2/RMZcGHcmO/PCE9O67Dg/PvQI/qOwW3yRRf+lG0DkNiuURvV4a4BKUjfJTSL3GnnkXV65/rdMDNiHXn2NKfmAR3VzEWNDYBqAb7dfaJq4js
 kw2jZCIe
 yx/cbIFG5mL7Ajg2rYZWz3c5lG0AQTW8r6m3+tCKbxOLwweSnMFztJ31j1XD6wnVv/QOEeaKT+u2UhYJ6SaFmIfJtur+ko/5UIxLix1vQfof2cN4fASO58V0HXSTZNDKdhvhYU3NEYtul+PVGZsNAO3jp5bJoMqdTuUtchYEozbYwbjzt1cIgMeuq69+MygqQR/l2Xns6S3rHALUPmzy38Ekrkd8yhNSFfZZkF820ogUEnvs44JUyo4S1Dzz11VNtJK2e6UylzZiGoPDajyniKa5diZ8xywE2GzR/n/QFHekTqzrsWoRaSxOsbCq2zg6VB0UixaswHDWytquPxsCGqfR3sjI6KuFgIAjimuYju5pGz2emLgWOpG4I7fWi8WQIuTd61/7AZFmkj+0xRmS4tv7ui7pdpq9fdlHkbueHxGHQQvZ7Wwa/I9mDOdolCKFS4OXYDXKmvx8WDqln7F7mlcu+0VFo2IsYTmEQkBcZsMpXjJyIZ+a8i2Kq6YcO7LPwntxObPyWpQRx/j6Ggd2At1PNmDwH3Zng/iwvcmWWENXQTZSmq3Og9HMEaRtri0004HqvgB4e42LtjIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ol5zVscvDvmD5WVK7eNs0OQn
Content-Type: multipart/mixed; boundary="------------fP0ryuo4CzHsyjK4XS0b9LHe";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <d76d5e96-ccf7-44b1-9dc8-3246466f9640@kernel.org>
Subject: Re: [PATCH v2 02/13] mm/slub: skip handle_failed_objexts_alloc() with
 profiling disabled
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>

--------------fP0ryuo4CzHsyjK4XS0b9LHe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> The function might get called with memory allocation profiling disabled=
,
> when the obj_ext array is allocated for objcg pointers only. The
> handling is however unnecessary in that case, so skip it.
>=20
> This would otherwise become a real bug later, as pointed out by sashiko=
=2E
> For now it's just an optimization.
>=20
> Link: https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49=
c4ccf4c3@kernel.org?part=3D10
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 76acb78f2655..95fa6fbad11a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2101,15 +2101,16 @@ static inline bool mark_failed_objexts_alloc(st=
ruct slab *slab)
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,=

>  			struct slabobj_ext *vec, unsigned int objects)
>  {
> +	if (!mem_alloc_profiling_enabled())
> +		return;

This looks racy.

Can we instead do this later in the series depending on
slab_obj_ext_has_codetag_key's value?

>  	/*
>  	 * If vector previously failed to allocate then we have live
>  	 * objects with no tag reference. Mark all references in this
>  	 * vector as empty to avoid warnings later on.
>  	 */
>  	if (obj_exts =3D=3D OBJEXTS_ALLOC_FAIL) {
> -		unsigned int i;
> -
> -		for (i =3D 0; i < objects; i++)
> +		for (unsigned int i =3D 0; i < objects; i++)
>  			set_codetag_empty(&vec[i].ref);
>  	}
>  }
>=20

--=20
Cheers,
Harry / Hyeonggon


--------------fP0ryuo4CzHsyjK4XS0b9LHe--

--------------ol5zVscvDvmD5WVK7eNs0OQn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8I4wAKCRCGXBN6rc5S
1uOkAP9JyWOEjPrnydpu0m5kMCD3Jg/w8yVhPqbOK9JF7RPdDAD+IA96fpIdRg7l
Iwl53sgc1cby3TLJcQjYVOaHX6xsSQY=
=FTDG
-----END PGP SIGNATURE-----

--------------ol5zVscvDvmD5WVK7eNs0OQn--

