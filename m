Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06EC3C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C366B007B; Wed, 22 Jul 2026 03:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD866B0088; Wed, 22 Jul 2026 03:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBA26B008A; Wed, 22 Jul 2026 03:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 535BF6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:08:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C640414036F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:08:19 +0000 (UTC)
X-FDA: 85015533918.04.8F24064
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 25E9B180004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:08:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5aVet97;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784704098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffKA3v8JXhual6MJp3NZTppdmwPwKkpdeSEyJ3K/MqY=;
	b=6jiey2e3kPTpQDQXffndI0Atpx6vpb3LzDAprEwKzTffPcgyXEhpbVlxemqPdVH4ZBmKBl
	zGtR8LA83t6rHSsT2oVCPgThhKZzXB7S7a4twAPv/fq5wr3VVwfunJqIJ2HRTXvtz1Mqnr
	N7T1HNw645/wQIjIypwqSzZXTUhzidc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784704098;
	b=u0c9ZNZwtzUfD8H/RahFisZrNYlUU3psOTTudP5ux8rni6A0JrZ177WjCtYQVzp+uaj0fG
	5fmZnEBuLE8kGLsyO0A1R8pONAm/FFaraVEhiGNKYO+AOsGfXCxwTXqCyCXRXTPFsBsDzC
	fSBjwIKuRTH+IYZz+G0/dNoaq4wS2ic=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5aVet97;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01D20407AD;
	Wed, 22 Jul 2026 07:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE8E1F000E9;
	Wed, 22 Jul 2026 07:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784704096;
	bh=ffKA3v8JXhual6MJp3NZTppdmwPwKkpdeSEyJ3K/MqY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D5aVet97eXazbrvprI2QQmqdPDlsIBtvqVq0N6A1dpIb8YhN2eOilNC+OGsrtITZm
	 u9b4iw2oqG63lnSGswUs3R2WWxRH12rKCRJlT1GmDBnJt4pGOqgaERfXMuSa7rBwwW
	 OCVBWnGpGb64cxIJ73biwK/EJk+4J1ZABtj/39sonprHRn7hEqdpUyJ2KbtE0jHvin
	 y1CTrk5SQ8BSCYxN6Rsrj4uKSwweCGRwaViCMCvqaij1zfSsD1P9l4ISlGHhvKcIgm
	 zdpCvelViIEAz2tBMKXwlKPR6moduVJN+lNvB67DsN9nd9ONljbek1a1qnvgRuRiFF
	 S/PIXA0YHvDkw==
Message-ID: <9e65f398-5576-48df-85fa-3d993b9e163b@kernel.org>
Date: Wed, 22 Jul 2026 16:08:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: silence sparse warning with type-based partitioning
To: Marco Elver <elver@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <lkp@intel.com>
References: <20260721092005.1986693-1-elver@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260721092005.1986693-1-elver@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------6m9D5WkPAdlH0TQWgJq33p0J"
X-Stat-Signature: f4jfq1a9w45z3yxwproabc7ksmwua7d6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25E9B180004
X-HE-Tag: 1784704098-517053
X-HE-Meta: U2FsdGVkX19ogf/eXdUSotNXJr8sh2Vp4KUL2hzyanwkmrVT9JC4du2X+7GN5yX+WBKtOU7CxDgaDHkcUuMGI9UApDiBv7aIV9+bmj11I7oVK86I/5YTkCp/uG/QpAbP8d2JTGphOrc4rTsu2exlDFsv/4lfDDdH8aDqe23L58CYmfNngtPBMpM7c0m4EHwQAsA+jBeuNYAvzagqsmHPdvSq94K1Bl09XieuLUhQUcWF0lxPXhi30qXDAN6+GmSImwOMy04Kzvq1SKU2f//x9NnevePBoR2TEslvPd5pGJpUwORc37q/ZVh5c12PRXV6hDcqZBIiXVqhocD+if/XoiF2EJBYAb7kwC4Q3xI6pf/uyky4CTVf36On0+cK/YcPh3FgfVYijMIYq0fDImDq/cxjKmKZLjvlBx/jLAzxkqQiWtIxPA0jTIkXPxdv4ol2/7Gs2bLfOYIkHAu555+ukzTgQPeuo1Ax1dBQuQGRTcBYhCNxJEVcUV5Ucz4Uf07jmtYFYN5c//Au/FrIhEqWBRrvdq1RBqEeIbZL9C6oW78Ye19RmlMyS1IX05l6j0NJHsORo7feaeUPQd7o/QNacCoDXeOQsECFh98I73oxI5NerugxPiQfXB6h1BHxaGNYcwDCpqD9fLIrzuWJC3HpdgBQ0zku+0ZlhGEwiFBeMGUfqFDbM/JNtTSaNK/GMPH7fkvvMmAcJrX8FL2Ujuzsq9gV+U2kMw1LE3Ybqk53LyNdMk+7kHfFRGtq84FhDzMKNjZfolyk21rxdpLF/Z7CI3zt+685f9iCzsmPIPgh3tUkcBUQL0sD8zQU3WJBOmBTc5RIwgfv/JpRtJeH5QIUWljyAOuTb31SrsrqoEEQJgwiLXUCKunOUlS2+3Quhx+9Xo+/Z/IgyNxktfbtpAZyU8bwtPU39ZNCdGNucH6QD+aNACjWKmwoEGk8Lqpp4KO1+43QRaH3jUbzp7NpmsL
 mQ1h8HwK
 REVGQZkiw/O2SUWRWbrHJUmsy0eoWOCSsSeqbPBzhO256dwNJsIRifNL/DhcYoo3TJNCb4Dp2Ts5U+8bOqvJ8aPJnDZ+I5s1q1ZkAi6IMC89Nt5pkMIPfldm8DbTbwtPv3pgnn/MugD+UUpAe9pvsYCJdCw5ZoGDMrGghHlOySDptqzrwQKweZKoZKo57NM30frTuKyNnkftTaxV34H6mrdiRbz1jnNIKxWxxWjJH6ILXllRwzSyJGXprsKra5z0MlDI/lQg3dkZMJVyG1CA1EPSQY2m2pvk8W1W0S20iQHisfeyWK1SjSzpxrrG43zRvJyCBc5gySz2DlhxRIzpVvcFV5PVOMKeZaQwar86AleWPXhlHCnUscfOsxeiEVdgzKhiyM92RMFjU6dey9TlaKEYLE7VYEKHpizCOtuMXql6qvLfBUoWNOkAI246M0PAU11lQz5K5aYmHcx0WdlbloayNbtZh3fjb21SGCzQSPGF9YnllpbQoJJbMS66SvTO4g+5JsRH2huK1Vj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------6m9D5WkPAdlH0TQWgJq33p0J
Content-Type: multipart/mixed; boundary="------------w3q0NO5NRlwkt4rlkq1vNAGu";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Marco Elver <elver@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <lkp@intel.com>
Message-ID: <9e65f398-5576-48df-85fa-3d993b9e163b@kernel.org>
Subject: Re: [PATCH] slab: silence sparse warning with type-based partitioning
References: <20260721092005.1986693-1-elver@google.com>
In-Reply-To: <20260721092005.1986693-1-elver@google.com>

--------------w3q0NO5NRlwkt4rlkq1vNAGu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/21/26 6:19 PM, Marco Elver wrote:
> Sparse does not know __builtin_infer_alloc_token() and complains:
>=20
> 	sparse: sparse: undefined identifier '__builtin_infer_alloc_token'
>=20
> Fix it by using a dummy variant of __kmalloc_token() if __CHECKER__ is
> defined.
>=20
> Fixes: feb662d9168b ("slab: support for compiler-assisted type-based sl=
ab cache partitioning")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202607110912.nZTqfCrH-lkp=
@intel.com/
> Signed-off-by: Marco Elver <elver@google.com>
> ---

FWIW,
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

>  include/linux/slab.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 51f03f18c9a7..7ffe152ce483 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -505,8 +505,12 @@ typedef struct { unsigned long v; } kmalloc_token_=
t;
>  extern unsigned long random_kmalloc_seed;
>  #define __kmalloc_token(...) ((kmalloc_token_t){ .v =3D _CODE_LOCATION=
_ })
>  #elif defined(CONFIG_KMALLOC_PARTITION_TYPED)
> +#ifdef __CHECKER__
> +#define __kmalloc_token(...) ((kmalloc_token_t){ .v =3D 0 })
> +#else /* !__CHECKER__ */
>  #define __kmalloc_token(...) ((kmalloc_token_t){ .v =3D __builtin_infe=
r_alloc_token(__VA_ARGS__) })
> -#endif
> +#endif /* __CHECKER__ */
> +#endif /* CONFIG_KMALLOC_PARTITION_TYPED */
>  #define DECL_TOKEN_PARAM(_token)	, kmalloc_token_t (_token)
>  #define _PASS_TOKEN_PARAM(_token)	, (_token)
>  #define PASS_TOKEN_PARAM(_token)	(_token)

--=20
Cheers,
Harry / Hyeonggon

--------------w3q0NO5NRlwkt4rlkq1vNAGu--

--------------6m9D5WkPAdlH0TQWgJq33p0J
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamBsVgAKCRCGXBN6rc5S
1l5EAP9V49DkdzS2HLB3lWDL05UG0KOMuz2kHVDNeGNzlpHfmAD/T5fLEfNPnmVy
eAlw6dbWs92E1AhoN5NmO3k3+D8i0wE=
=/o29
-----END PGP SIGNATURE-----

--------------6m9D5WkPAdlH0TQWgJq33p0J--

