Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D49DBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D4A6B0005; Mon, 13 Jul 2026 03:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD4A6B0088; Mon, 13 Jul 2026 03:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D098C6B008A; Mon, 13 Jul 2026 03:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE34A6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:27:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A34F93E8C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:27:16 +0000 (UTC)
X-FDA: 84982922472.12.50F3E87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id ACD6BA0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:27:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YwHY8qWz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783927634;
	b=FzEwiglOhBiy2G1nV2k+H+8t6AwA8pNYMagjOYXfU74ywtZBrR64eEVzEk24JgGOC5K1or
	tlPehsaCYK3AwcLJNpu0ohcZvkee6XvZyaH65DBXfC8vuJ4lJep7BjLWYBJmGVOgj/NoEw
	gGTYQTeS7y7AHW+Rh8J2+uki7JPWZ6k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YwHY8qWz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783927634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYKnFncXJeNp/IdRDclihrL+DXMOIxQ7CXyCofknvSo=;
	b=GOTkYKxk8iOSrx9Y1RoEtE6YFyV1ZOBEYA++fxfkCayy+mYF78UENKu8Lk3D/pKLaw7344
	ijMYcP/TJfyJgYDwggAMc9GlRUsNWmb9/X4yYEtj3KxRcPFkCFifBlJ2kUmMDY0fZGj3Pl
	ds1B7Ka5N+CmxVBVjmhYctlUO1VMX7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 456476004E;
	Mon, 13 Jul 2026 07:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7181F00A3A;
	Mon, 13 Jul 2026 07:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927634;
	bh=WYKnFncXJeNp/IdRDclihrL+DXMOIxQ7CXyCofknvSo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YwHY8qWzcHzCGZtk7Sq1PHRZM8J54wVcrklJxUjnW6z/R0l+/Ly7ytc2FjLVn8inN
	 xLES1BH/9GlpMKPrOyGBQLHWKERAob5SNrrQi9bygTXT0cyQCiWVDhPX1L0m0tf8+S
	 DLuzDz/BxqEpjdYK5flQaeIwR3aPkGFWfyzYHzrZPSKZqu0SMF8tjvTD+6XqMOdygR
	 cAMZILQEE7HvWoky6cRfF5ea38Ue4FgFoXps/PplqBFzyTZSjP4p5gf1roIiKizcWZ
	 kXzdbADNw3C8ToInhKm1qo9BTuiiW88+dslKPVvIDenqLve0ht1cxlD3DCVTnjzFHy
	 LrwaCncaSecIQ==
Message-ID: <b42f2b3a-68c9-4e3c-b3b7-d940677b4609@kernel.org>
Date: Mon, 13 Jul 2026 16:26:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/slub: add comment explaining intentional kobject
 handling in sysfs_slab_add
To: Hongling Zeng <zenghongling@kylinos.cn>, vbabka@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhongling0719@126.com
References: <20260713070024.153552-1-zenghongling@kylinos.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260713070024.153552-1-zenghongling@kylinos.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qZrq4l3fGXVVi20MOTQhs4B3"
X-Rspamd-Queue-Id: ACD6BA0009
X-Rspam-User: 
X-Stat-Signature: 3pb4afypbj594ef398mp83u9m7i1wpd1
X-Rspamd-Server: rspam03
X-HE-Tag: 1783927634-830919
X-HE-Meta: U2FsdGVkX1/IWXwh2b0xjDn/BaD7dxrvmt3//IoqNODo1p7MyIqMp60r7gmfP6XeHiZB7culj/B3oMC0aEtioBLAAepBqVVzUqMiD2JEllByLgj23hYu4HDjbibbkdk8eibnqbPyVtT8Y3BE6y93+u3SnRYMlZCjuWmatX+Hl4wIqO5TA1WV3gzdI/efABRs9LNwMU3BPIOFT3RvX00Ovt3qFdifDYZDtTUdZ4WWpdyBOohZyN+D0le0VOGQAzPSzE0Emjlm4nTJTjYJH4687QYE2yTmKxDF2sw4EzExdN6PmSt0LHiwSg2N41/xDpVVbAlUSadlmbajmhazZ2mWoWCDXvtKDErr36JYHArweAy5TPlMYGzqK4YQuQ5+sybTnqIP2QzsCqQTAvCf7n7Y1Uj7hZ8qR8B2rt/WhfdF7fR8L3lKjbYw3ynNtBF/GhSoHxKAaJhCZ8OxYjIKZXEvNWGw6O6qHHpn1JLCCR8oMzuYwvWw7tb/rz7uxip24oH/QrCcpkRAeDb6PFRXskH21nqUZ9EMI/xJBUsrF7sFdALhvYMCMH2AxGDpfUuvRyGPYSg/Z4Z171c4D25L1VCmHMTnisvL6CYbXmgejfh15Ia/wGFuth7H4naqaAVIna0vo2vnkTfU1cWWg6f/XJuS1bmSoq5ZyyYrDaMx7oTPOWIC7p2vPlPefejGM6RBnZnGL5ilwDbwFHlLd8hrP7bWTtWIZXNbppziN5K/hC1JjigxLwiYu1UmLZhIQ3Th5tirPtSIG44qhFTIVu6hAR8GxI3bRakoRTGoI3Prz2mis00Rsds2+yJrdi5sror8Zsip8csr5oWWhnp0ntHdVFQFIhBKjLICxFh2XM9QM5ql2oyqHMck7unywqRo8/vHebwn0FHshg/mgFYRfBc2ZWOEv5S/RlGmkA60092XtrIhHMBMKzb+4GP9xc5B69caD3kUeCCa5Um60Lozig3frU2
 MnFKFX0C
 45E+R9JfU2KJTvsjDg7eE4h7dkJFgu5UJBC/KE2lHREx2cgq35lsIdbyxk5lO8vF0aKvAJ+U5qAuZQTENj31gslutz9zcOCrugy2/TcBf9vC4KnNCaHuoz3gMeVn0pMDqMcxDd1RV5O7eVt9o8ZStlabOEZgyPZ31zRjqY+CgkaHNDMNWsBwx7buXV019OuIbWuBkg3yCt26nNOv9pnAiAn/k6leLgDVtN+LP7k+quKexsQUykGcCjkVR4AROM7o93hEdZDdTRXeflt7V3jPWRLXwc1kwb7g8p/J3FMbFCuvjL3v/6u0ZmWQ7J2PexDS6skuazT1jYZ+y82/o+q8UXDSeEvb9w+KRFgY+rhytz1N91oBkAiBeNN1XTWHBdUpmBTQUBYr+GmwGpBT9h8mwYDZnoPRaDxYMmuWum6qIf21P3PWGmgnZHKxvCgGKeS8RjMUddP+UkhM7BylsmcPv2LmHVbHvJnhSRFCA3eYyZzm03xcH8+9/ctQfXIP4ogCdxdcCRfBEe/Or7LZH1fT0QMzCcyNZWU/v3qr75rEowFfDGWOkmBLZlEj9YE2RUH0CSGtiuG4egq6ZV8ykv2L/fxO4fkdO8ih72kHBMmJEAQB0y8b7fuQlpDNN8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------qZrq4l3fGXVVi20MOTQhs4B3
Content-Type: multipart/mixed; boundary="------------jL0A6RCvBI6v0ppT4j3zvBOH";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hongling Zeng <zenghongling@kylinos.cn>, vbabka@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhongling0719@126.com
Message-ID: <b42f2b3a-68c9-4e3c-b3b7-d940677b4609@kernel.org>
Subject: Re: [PATCH v1] mm/slub: add comment explaining intentional kobject
 handling in sysfs_slab_add
References: <20260713070024.153552-1-zenghongling@kylinos.cn>
In-Reply-To: <20260713070024.153552-1-zenghongling@kylinos.cn>

--------------jL0A6RCvBI6v0ppT4j3zvBOH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/13/26 4:00 PM, Hongling Zeng wrote:
> Add a comment to clarify why we don't call kobject_put() when
> kobject_init_and_add() fails in sysfs_slab_add().
>=20
> Per commit 2420baa8e046 ("mm/slab: Allow cache creation to proceed
> even if sysfs registration fails"), sysfs failures are treated as
> non-fatal and the cache continues to be used. Calling kobject_put()
> would trigger slab_kmem_cache_release() which frees the entire
> cache structure, so we intentionally skip it.
>=20
> Suggested-by: Harry Yoo <harry@kernel.org>
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> ---
>
>  Change in v1:
>  -Correct the email

Hmm, the email "Hyeonggon Kim <pictureone@kakao.com>" came out of
nowhere. Could you please explain why this happened?

> ---
>  mm/slub.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 9ec774dc7009..edc822d7d9ea 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -9690,6 +9690,11 @@ static int sysfs_slab_add(struct kmem_cache *s)
> =20
>  	s->kobj.kset =3D kset;
>  	err =3D kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name)=
;
> +	/*
> +	 * Intentionally skip kobject_put(). See commit 2420baa8e046
> +	 * ("mm/slab: Allow cache creation to proceed even if sysfs
> +	 * registration fails")
> +	 */
>  	if (err)
>  		goto out;
--=20
Cheers,
Harry / Hyeonggon

--------------jL0A6RCvBI6v0ppT4j3zvBOH--

--------------qZrq4l3fGXVVi20MOTQhs4B3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalSTRAAKCRCGXBN6rc5S
1njlAP4/rveoSWCzl1am752qZkVqCy+RNsMkCmfloYCKUC7zrAEAyXCnugkZftyJ
uzJYGd/4ZzKqEnO2uI/+RYt2NctePgE=
=qqg4
-----END PGP SIGNATURE-----

--------------qZrq4l3fGXVVi20MOTQhs4B3--

