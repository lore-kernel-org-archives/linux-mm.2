Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F37606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHta1iho
Received: by kanga.kvack.org (Postfix)
	id 2168A6B05B0; Wed, 28 Oct 2026 03:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C72F6B05B1; Wed, 28 Oct 2026 03:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EEA6B05B2; Wed, 28 Oct 2026 03:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE82F6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:36:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AA0680BDC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:36:27 +0000 (UTC)
X-FDA: 85371227214.09.60B79B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1B92A0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:36:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OHta1iho;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793172985;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mE7HrhvYUQ/hkBSvppoQbLgz+hmem0TBpSvgPBfiyBM=;
	b=Y1IqI6816yVVG/WTDXW2tb0lkxeVpkrbrjGat5z3rAE4oUEhe92j1ewqxADWOxUj7mjTOj
	7Bno7faWkn6Valt3gSFkZltMqqMMRK/KUvE1EBaR4MiGdp0Q74t+soVqg0xy4Ym1TLXNac
	EirQbzLfoE6hZm/iC9lIRcya3qlY6bk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OHta1iho;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793172985;
	b=XNfSZErhFoAj5G7KgnlgF2xUVUV0x9G5kLeVdnjnaJY7QSCLc8m7GtXsgmBk6E9yAFNHW3
	mIETXjm/GxBKa7HfjWH53IDqvlhzRr3GlTWPENfMefWpnoKTSOb+fzp8sK0h0SNLn/y3No
	5ZGop9rkF4iI18SwmB9MzLAO5kq2i7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECE0F60008;
	Wed, 28 Oct 2026 07:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04EB1F01825;
	Wed, 28 Oct 2026 07:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793172983;
	bh=mE7HrhvYUQ/hkBSvppoQbLgz+hmem0TBpSvgPBfiyBM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OHta1ihopcj3sf6P1RHjYvZGyCt4kvQUWc7mdkKQjpQnehDIFr+zrmtJN5HAOaPL6
	 X5R0bhjnd8U2vKBHB3NAchHnT5eJ9U9g9Va2qi3vhJR1NHvT78o/bzIF5Jb+3BGovI
	 /mtpPSkqlz2e3oSrV3uuWlrzcyTjYDxKYWqM2OPN+Aet2fOEW6ogVCnTZJ7f9ffix1
	 8UVz4yUjI9wQxNYQXILqXW1UmM8dV5rgkjsH9pkWd4x4u9FxV0IhxLBy5Ig7hZC0Y9
	 SE3bB5RyPz0PZaT2MuV2+XcAOAAY1GxIy+ylSx7DyxGKzfZN9scJ2s1PVmxCeXK6GM
	 PXVJwXhmVaBPA==
Message-ID: <sashiko-outbox-187584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/8] slub_kunit: Add a test for slab_freelist_random=
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Down" <chris@chrisdown.name>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Kees
 Cook" <kees@kernel.org>, "Marco Elver" <elver@google.com>, "GONG Ruiqi" <gongruiqi@huaweicloud.com>, "Jan
 Kiszka" <jan.kiszka@siemens.com>, "Kieran Bingham" <kbingham@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <0af4fc45ca8e1d7027ceaad079f8f9eaac663c76.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
 <0af4fc45ca8e1d7027ceaad079f8f9eaac663c76.1793086056.git.chris@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 07:36:22 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1B92A0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jqkgragq8u6hofss4igr5q8uxqu6583w
X-HE-Tag: 1793172985-215775
X-HE-Meta: U2FsdGVkX18vRRfzKtj/+6C2QINUK7d79knprt4PM3PAFDUouny6wqC7J2gYzBCo/7m/eWirZYBjarE3dxgkquwoj7kGBywefr4XZLHVb+rFYODTPTmYIf4tL7rE5SOanF1P+YYMwcyw6cOuEP8OZ8/l3f1hc3o9WuXIeEQ3FZ8DRaInkGwuirrOZS0rBxoJRmX8AT6fhM3R3ACONnTK2a8HW3KHgCaUcH7wp+Bv5wqFfynddbr0AUGyGssu5EESSwCvyLSpz70g7kQPzHDjpWoIBeL2zpPRzT8oFAnfvbpIMeLhxgSLbH20RcqClxfV5Zj4eV+s3aI+ZjCITJ4XIyAdRM/T/6xzlnSVpomwM7vFdn0n3OuYVsOvycZjwGZWmgNsRA7H44n+D7mfhsTVTiqYjB5XFTZNdY5pq1dWuKHkzDE2XdemOMsJ87euBBF9dHTrR4b/iZZDr3gGgua/RhY1YLM1gw6PQH9msXrKKSx6rnXPlp03Un7MqXb8AGOcEyucnN/Yqje5dZFY+dAQASPkJSSRR3buEUJ5VEJu9SSnnNHqKctHw/5KYdo2DWJzFvbkFKdt6aDkThcIMGNibotL7Wze6sfQCxLdihPk26MGTDym9cwD7YuNR9PSnoHpMBsfpgcYx+SSa+WeS5hvb6ozUNyQYsiPXb+qgF5vAeB45wYbX0dwj57gAjjHNmHBymWi50ox03XFlnD+Atm6GpzdUJBpWlSR/VGo65FnAOb3WLYWodZaNvNwxvYVV80SFFEzXEiVLvqFnQku58d4vX8pyhLEHR+sEXEa5VHs5TfcPNcVGt7ixOwXpUn+bSUOcAQgYRNBuvm9vlvEAvxkXLXFTRMtzqcSOMPla/BCW74cFNyZNwt7BDE39zMtFSXkFrBajZZdy5LrZ0STt9+wjzA6IP5vZtPXqmjB8AhjB/Swrqy53gq/bHFkCMIqrA4kAkfSpxgtzsrM+aw1r3/
 hU7hFRVK
 0KjR5V9QM+Rk8NEsGaOfdmJImzutiKsZZzIO64o6FfF/byl9BujjG4IwEeFSRti77nTqONly/U+OgBIpQjI+Tmlatao5VTP09lkzoqN7jYdjrM7LDi6RWeYAiNOwPVzdEtLOMmpOSma/HAys6r0g4wfbreVlGQiCbN2lD03nNct0ilkWsNDT7ZVpX76XVyLNONxJFwMdDwT/SSKbIWbdVG6E1MPOtCitJh32QX/GsYiSSux97m0bNyOlnMWFQGObU/TmqnVq7nzQARlc7J38xYvAXMbOdzZ8dJdUO9612iEYRBLPlqSiFQhypD2q1YaHIFvvJutfTTCrFbkJv9WdFhNPkcTICwWUele3eARoFQQfbgugMpzTxrrSEZz/2RHZCMgN/t/rrcJ3b3xtzjeox6VsHJ/OygnRRvLuWzbg/jHxnUFlJzsVjSv0+G3zbPQWMxDZHow7Y7IHGWe1FvTv9NjiF9U5I3758Ou91RZOxvWKv5zomUBbNPTsgIvgPz6YrRh5G+9bt8t16BEP2k90pM8uSSBqzAt64J5bhSmVqOaLOgphgGS0IQkWBw6wxFFp1Tr8FJXkVex097Eui97lmQABWSKMp9KuyYOy4vAj30I5slOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] slub_kunit: missing kasan_reset_tag() in test_freelist_random()
--

commit a6a4a9e9d2827c11abe21a80276d4c98393a0acc
Author: Chris Down <chris@chrisdown.name>

slub_kunit: Add a test for slab_freelist_random=3D

This commit exposes slab_freelist_random to KUnit and adds a test case in
slub_kunit to verify whether slab objects are allocated in linear address
order or randomized order based on slab_freelist_random.

> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index 5ace733685231..49b9942bc564e 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c
> @@ -190,6 +190,56 @@ static void test_clobber_redzone_free(struct kunit *=
test)
>  	kmem_cache_destroy(s);
>  }
> =20
> +static void test_freelist_random(struct kunit *test)
> +{
> +	struct kmem_cache *s =3D test_kmem_cache_create("TestSlub_freelist_rand=
om",
> +					64, SLAB_CONSISTENCY_CHECKS);
> +	bool random =3D false;
> +	unsigned int i, nr, nr_linear =3D 0;
> +	void **objs, *first;
> +
> +#ifdef CONFIG_SLAB_FREELIST_RANDOM
> +	random =3D slab_freelist_random;
> +	KUNIT_EXPECT_EQ(test, !!s->random_seq, random);
> +#endif
> +	kunit_info(test, "freelist randomisation is %s\n", str_on_off(random));
> +
> +	/*
> +	 * Caches with debug flags have no sheaves, so objects come straight
> +	 * off the slab freelist.
> +	 */
> +	first =3D kmem_cache_alloc(s, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, first);
> +	nr =3D virt_to_slab(first)->objects;
> +	objs =3D kunit_kcalloc(test, nr, sizeof(*objs), GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, objs);
> +	objs[0] =3D first;
> +
> +	for (i =3D 1; i < nr; i++) {
> +		objs[i] =3D kmem_cache_alloc(s, GFP_KERNEL);
> +		KUNIT_ASSERT_NOT_NULL(test, objs[i]);
> +	}
> +
> +	for (i =3D 1; i < nr; i++) {
> +		if (virt_to_slab(objs[i]) !=3D virt_to_slab(objs[0]))
> +			break;
> +		if (objs[i] =3D=3D objs[i - 1] + s->size)
> +			nr_linear++;
> +	}
> +
> +	if (i =3D=3D nr) {
> +		/* Without randomisation, objects are handed out in address order. */
> +		KUNIT_EXPECT_EQ(test, nr_linear =3D=3D nr - 1, !random);
> +	} else {

[Severity: Medium]
Can this pointer comparison fail under tag-based KASAN modes
(CONFIG_KASAN_SW_TAGS or CONFIG_KASAN_HW_TAGS) when freelist randomization =
is
disabled?

Because test_freelist_random is registered in test_cases[] outside the
#ifndef CONFIG_KASAN block, it runs under tag-based KASAN configurations. T=
he
cache s is created without a constructor or SLAB_TYPESAFE_BY_RCU, so each
kmem_cache_alloc() call passes through:

  slab_post_alloc_hook()
    -> kasan_slab_alloc()
      -> __kasan_slab_alloc()
        -> assign_tag()
        -> set_tag()

which embeds a random tag in the top byte of each returned pointer in objs[=
].

While virt_to_slab() strips the tag via virt_to_page() so the loop reaches
i =3D=3D nr, the direct comparison:

  if (objs[i] =3D=3D objs[i - 1] + s->size)

compares the tagged pointers without calling kasan_reset_tag(). When
consecutive allocations receive different tags, nr_linear will not reach
nr - 1 even though the untagged object addresses are contiguous, causing
KUNIT_EXPECT_EQ(test, nr_linear =3D=3D nr - 1, !random) to fail when !rando=
m.

Should objs[i] and objs[i - 1] be untagged with kasan_reset_tag() before
comparing their addresses?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793086056.gi=
t.chris@chrisdown.name?part=3D4

