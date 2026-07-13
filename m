Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32D1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BA36B008A; Mon, 13 Jul 2026 02:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621726B008C; Mon, 13 Jul 2026 02:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538B66B0092; Mon, 13 Jul 2026 02:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 170C26B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:27:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8209412079A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:27:46 +0000 (UTC)
X-FDA: 84982772532.15.3FA6673
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E08F1140005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:27:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOHfHY1f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783924064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/ZjpSgYQZbcZJdFjobOIEANC6srZwvAyCb3zK/ZK1w=;
	b=ykJ0jlb/c2/5rgHZ/M8Nw3bVThbZVb9Sl8QKxD961GW+Si7oJneuPGFBcSPQBdG9kG4EMD
	8/PDZtzNgz9Gsd9e9rTKqY2ybN3h5jC8ADKwGMzEDIKu5jZVpqSb4jRzphOblcER5oYS35
	obNfrgw2nbx/j8GUffZhucfdV6wT8+M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOHfHY1f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783924064;
	b=n/4Xlv07Qdx6eNpvUFfO0sv+aI3armEKKpUlBt0mOk+OEgZQ63Budcf8AwFMsmXTgjmiLB
	l+wYzIkKwyjMiixazOTbReWcuj/7pmilV3ePTtL7p8Ztqstx4vr9huqYhWYGuCBjv8dQtj
	4GIPP5bPc7lUhyQxWHjfrVVCXoEATi4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 401C46004E;
	Mon, 13 Jul 2026 06:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE481F000E9;
	Mon, 13 Jul 2026 06:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783924064;
	bh=U/ZjpSgYQZbcZJdFjobOIEANC6srZwvAyCb3zK/ZK1w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aOHfHY1f5MF8mN3mAVQNx8AYlcBCK4m3TDXtoT73JZL+t93c5Kq7PjRq+8aYzY9B/
	 AAXhsChF2QdEVEVoqUf1reLfhBW0GR/udZUtxQXgZ8dtelVQ7NaD4mBNj8Pa+rbuq+
	 1Q8v/DXokNs0hf+NSLQV0dXdCHMgX3lt9skvhktWAMuoWG9EaMoi2A+xmHU/rMe1G3
	 39CusoVClUL1HEOrioMRK3nrhh0mGBKX7drAWJM55KsGg+ZYhZB2Hc6C1DZYWTJZf2
	 px4D6pkrMiz1IZk2hGcblSDaenGINFnmoXfV3ZxJSjOZM4LVyMBO0JS6I7ccBmgL5m
	 /oUkRjdyMGL/g==
Message-ID: <40902df6-373c-4e87-9ec7-4e72f9f0efa2@kernel.org>
Date: Mon, 13 Jul 2026 15:27:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: fix kobject leak in sysfs_slab_add error path
To: Hongling Zeng <zhongling0719@126.com>, vbabka@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: Hongling Zeng <zenghongling@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260713055829.127864-1-zenghongling@kylinos.cn>
 <bbadc488-e5b1-4868-9da8-26e2cecd93b2@kernel.org> <6A548241.8080802@126.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <6A548241.8080802@126.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------1vqnp8Gy807YDBQ4YweviOJT"
X-Rspamd-Queue-Id: E08F1140005
X-Stat-Signature: yfinzrtg8gijhszpqk17z1cu4qkrtiga
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783924064-160825
X-HE-Meta: U2FsdGVkX185+PvFELR3VPRk3RF2e7EdijJ3ylbKbGdC5KWsowAyhBh9MB9I/QAJZWxUalKQdDYNxIwbobK/239UMpb36/rN+Qls7NYX0qJmVAQwk0RfVZDkQSc2yNfJvUDAIDG3yJC614mqHae3QN2Co5P1dhW1lGRYX8oL8VmO9iXE2sIXc52bmlLbYl2WJDGZ0Ab6SbjcX/d+YOPubE6twYbDN/7l5lPoa/xPwaJ8ibrx8fQlpCcQOCeTu5BxQ8XuVAnPlwIzFQcz9/4WwAo7jhRvY8rDocuIfkRk/nAj0f5fqSfkiYIpmeYA02H4jkVSf47FRUssIQLMoR19bZm1reTq2XPBCJEz0eAjwQffxpTEcb3hfJLLwnWwW8JZBV7Lipry995q2Oniy9jQi9Mb7ehBOL0b4I/aV82vVTu739GSaZzrGmjP1JPXhnEo99lzA5Uy2xP0nyDsJXuPNGuMLIv2eCpBXHi8oc0TAv1+jIcBB/JJ8/Ag4OAS5vhH/hfOQQHsbir8MMm8XhfZ5FfM6OR2zIbwRdREGXngVeLcO4k1tnghV67viaZ8Wta/IEGQNxrrflLSdSm9BzUBiDSqlSuolwV/7JrA4SfSWStdKW9Czz46C4PiSXcUSbgh1JMMrRFERM4ENsTzm5vw6sTw4k0RejP51s7pF5jxz8CsYG7Q1wJrKb5nKMNl3+3AezdeElJGWKb5BmaPdDKPy8jVVQp4vAgUCYzG2dctbI/a/7dn9pF9OM1CqTXZHQaoVg4i+me5F1Z9EVU5ScahWutsktyLwHS3mKSnQ4MHQCz6DyydYtQgTWR2x2cHA1m21ZOimMiVjCZTrTbVJfFuFHxy4heGu+O+e9nI8dbn9bBzrArSludg8BdkJEh+N1mSnIQMAHAR3sXRjbKHiuchTrRegq9IhUcCFGzm0bLnwG3U7AFxkDHlSTH3b7zetLBtSzdKW1UvdYIfaShygrO
 LHilzWxF
 87C5ADOcpzfB3mr/dCQrtHjV72Tv5p6bXxAOkWPBo/YgYVlZt3XIaKTEz1cNOUfqpdjzCDXeJNnaJfGQEYbm7koFWcdlKLjH8b1pFb5NtzwoQ7nVYmwYAjo1QjL+OCTfUod3aA3wL189sb5uyOzCBTlMpqccX7gcadnomwVZpl/MZwBeFt3a6C1OycG6dhThaTBN5aoDTpV6vrvlDoI0V6WSywzGC6z8I766EeHbgk6BH3qFDtMZ65sQteEzsAn8Am6HYT5Fl02XsfPF/YoHi9NGIRhvXTNpmjtfDeaRyKiXg/1jdt7o+6EKbALM2jOi9SrrGy1d/n8r/YRNKX7quetiPk6ubreWCP6pJLX/qNLQtDcZNeAAQf3UiVy+naHQ3ZipA4WGiSgfkkQhxHM5lfeP3uUyGU4mwSXin+D2oH3y4saopIwNPGw8j8FtQ8PF+KW5PK7VCZ19edRL+b8jvfe2qq+9ltmUenJnoIvIkRGWsIkvMYeUTJSrqYK5SkBEWZ9L43GmX9Zlq1tI1K8JG7lG4I1E+Iq0ZWnR78Oo9I8VcGwXd6hakox7QyOe9UeUfjVDqfgpu2K4LLDSlCIcgaqavBdznsaiDg6c0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------1vqnp8Gy807YDBQ4YweviOJT
Content-Type: multipart/mixed; boundary="------------DpHrR0LBb9GL03ozRue45Iha";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hongling Zeng <zhongling0719@126.com>, vbabka@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: Hongling Zeng <zenghongling@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <40902df6-373c-4e87-9ec7-4e72f9f0efa2@kernel.org>
Subject: Re: [PATCH] mm/slub: fix kobject leak in sysfs_slab_add error path
References: <20260713055829.127864-1-zenghongling@kylinos.cn>
 <bbadc488-e5b1-4868-9da8-26e2cecd93b2@kernel.org> <6A548241.8080802@126.com>
In-Reply-To: <6A548241.8080802@126.com>

--------------DpHrR0LBb9GL03ozRue45Iha
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/13/26 3:14 PM, Hongling Zeng wrote:
>=20
> =E5=9C=A8 2026=E5=B9=B407=E6=9C=8813=E6=97=A5 14:07, Harry Yoo =E5=86=99=
=E9=81=93:
>>
>> On 7/13/26 2:58 PM, Hongling Zeng wrote:
>>> When kobject_init_and_add() fails in sysfs_slab_add(), the kobject
>>> is not properly cleaned up, causing a memory leak.
>>>
>>> According to the kobject API documentation, when kobject_init_and_add=
()
>>> returns an error, the caller must call kobject_put() to properly clea=
n
>>> up the memory associated with the object. The current code only frees=

>>> the 'name' string but forgets to release the kobject reference.
>> This was intentional, please see commit 2420baa8e046 ("mm/slab: Allow
>> cache creation to proceed even if sysfs registration fails").
> =C2=A0 Thank you for the clarification. I see now that this was an inte=
ntional
> =C2=A0 design choice to allow cache creation to proceed even when sysfs=

> =C2=A0 registration fails.
>=20
>>> Fix this by calling kobject_put() before jumping to the error label.
>>>
>>> Fixes: 54b6a731025f ("slub: fix leak of 'name' in sysfs_slab_add")
>>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>>> ---
>>
>> Uh, there was a similar attempt recently...
>>
>> https://lore.kernel.org/linux-mm/
>> gimwkjjpvwu2sg5625b3eeatw2vhv7rs6enm3vepdduhcefbf5@xen5iec7sn3z
>>
>> Sounds like we need a comment saying it is intentional!
>>
> =C2=A0Good idea. Would a patch adding a comment like this be useful?
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D kobject_=
init_and_add(&s->kobj, &slab_ktype, NULL, "%s",
> name);
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Note: Intentionall=
y not calling kobject_put() on error.
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * The kobject releas=
e callback (slab_kmem_cache_release) would
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * free the entire km=
em_cache structure. However, sysfs
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * registration failu=
res are treated as non-fatal - the cache
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * continues to be us=
ed. See commit 2420baa8e046 ("mm/slab: Allow
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * cache creation to =
proceed even if sysfs registration fails").
> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */

Could we make it bit more concise please?

Something like

"Intentionally skip kobject_put(). See commit 2420baa8e046 ("mm/slab:
Allow cache creation to proceed even if sysfs registration fails")"

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
> =20

--=20
Cheers,
Harry / Hyeonggon


--------------DpHrR0LBb9GL03ozRue45Iha--

--------------1vqnp8Gy807YDBQ4YweviOJT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalSFWQAKCRCGXBN6rc5S
1vfwAQD/EzTBbAjUAGLpOeDDHKrwVLP/t4Ujfw7f6yBtt+HqNAD/a0CjyLan7HbP
vn/n4WR0uDMGarH+OMGpXiPnAjM0ag8=
=m9ef
-----END PGP SIGNATURE-----

--------------1vqnp8Gy807YDBQ4YweviOJT--

