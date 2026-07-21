Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A6BC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50876B008A; Tue, 21 Jul 2026 01:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01596B008C; Tue, 21 Jul 2026 01:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1196B0095; Tue, 21 Jul 2026 01:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8BF6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:53:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13F931C01E3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:53:31 +0000 (UTC)
X-FDA: 85011716622.05.F1EAD9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5E4D540002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:53:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tp53nAes;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784613209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/Ol8r5ArsVuARV2wlyP0lWho5H8ekpzbpXGHH72Syc=;
	b=VNTLTmFgNRekeS8as5Ynbn0jFGWqAxJLCUffwry4Nd8me0yoFME2xmwNuzxOdSuUr7rX4L
	LQstrxTWqFy4gZuGdrs+jmAW/7+7MjbGjKlPegZoNQyNBPU5eIYGJWSB3eNSrFmvcfwNMR
	g0kzxdIVZbiX0AxNNjPk23u1/7BWrWc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tp53nAes;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784613209;
	b=yym7tRK7OQ6BqaDAOQggEWAg1D2ebw2SLAQCEXhS7smr2U7w8DAFd8GM+nIxTV7MNsEeXT
	g8QwekFphWad6ybw4fyrJbBVGjRzmE0gqOI+0aFMtTeA3bB+s9eswZswvS4dJZxiYu29tP
	ehkfJJv1zYH49aucWxbyrlHZRrlZsVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A273240B86;
	Tue, 21 Jul 2026 05:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6682D1F000E9;
	Tue, 21 Jul 2026 05:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784613208;
	bh=X/Ol8r5ArsVuARV2wlyP0lWho5H8ekpzbpXGHH72Syc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tp53nAesptOxLEw9xI8Bk84IKtKiRYMoIF2tQCNOyAo8uQSEV7Te3XwN3bjbKbyvk
	 tnEep518SyfrjS3HGQIo3OClz0MXXyCJjQckYg1r2RgCAw78sb+h4qgxrJRYOcxipo
	 Yxodf5CE3M5VBfIwmJyP8FzV2bawKFEMwSOR2qTQ9eSzBk8wgd4oYZ5t/dpqY9GQpX
	 YRWFTZF8ahvTNPPPdYgcH1Fw5k/EvTZFSTOVqSx9e03kQ0QgFsimH8+lvcccXL5A25
	 ej7xuAJEgxZ21s3g0BYmgvziySV0d2To+lNwJEr2uNxxU4UvcsFHlpV7vwjBiMatQD
	 CE24mIW2Fd3+w==
Message-ID: <bbbd376f-dd0c-432e-abe3-7ea0e37b1db2@kernel.org>
Date: Tue, 21 Jul 2026 14:53:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/13] mm/slab: remove objs_per_slab()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------QVrUM3rJ2V0pNQ7hep9iO32R"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E4D540002
X-Rspam-User: 
X-Stat-Signature: h74aeqbjz3idiztc9md3sx8h9bmknnis
X-HE-Tag: 1784613209-705670
X-HE-Meta: U2FsdGVkX1+489+CULpkxVDe4mb5uIBk887inhGbCAnS9ng+Ih3T7gpRciHVm+g6/EnUQFizpln8eqKJ0za8bcMnp8//A9trKuZh+3OP0/ClrlDYGxRwYVoFIsj3tlbG5I97jhLVvEsXmH5pz5/Syttztma0YzFaHihJSULLhWJJ3FoBUId9rUKeChXuq+XMtn5nup48hR1dlQ4/k9z5ABMISTW9mgRB/Q7cMBQO6wbnCS/mkorqmqidzFkuKTK1ro7JYBzBmRSH3Xa7i4jqK9KzRUyf7pISCv68ZmZCP61B5uLgIcI1FRcE52SNfWmkZqWO08AJ8FeJthS9TcT8vb9+fAq8ThM3WfEC2WtrD6ZLEaJGuetpEAzJiydt38PS92O5bEdYy4K+51aQU2D96FPVGpRlRPubzm92YJ8B5p03PQqd1AezcPWhw4bfAb3SMrEYU5TW7HZ4PKmL4YpFyCZcm//wC6uACS3Ej5AT0WF/JXw8IeLwJ4l0y7XLAr0US6nn94b2ohmqGee+2AKeN2k2rxTStowLR6zS5qaulTvpjQ9K9vV495iLoamC+d1og9yFO3MY0bXiG1g+kam4D5bh3jIZTTeuJRcvmtZF8GabjZbGT+NEnDgcu2/pYTAFHs5hRfHqXw9L/IPEQOzjkgQLyl/WSrBtgeISy3Iqk4zIWhRgT4fGYeR9lluNzdhgoyyLP+QtTwDBcH752JyoclxZilR++Xk6lJi/bWDq9cv9I79JaWPJrfPlY8/RYvR576vvXezUKhgf6sLIU8t7pxm8+k3mxwi14w+fqeIENpSoqJFpt/a8NE8iuVmonR6BQ+wQd2LMfdPxiyulyEXY27VWJe9F2MwvaRQSRBgrDbZwqSbrBwoXxaFkTV7uZ3gl1Q0rjU15+S2X0SF/aAW8RQliQPgLYBgzIbpV4swK/7u6tGcU5zYzefYWiQzyvlrTroLLvu4dLHMpJoKqHg1
 4wJywFvJ
 icLemVH4vWBbK1omRiNWLeE7K1aLfo2NzBUsesevk22RVIR5gMmjq1Ar5sZATqLvCWbugID+AqPk5bJlTRKH6cbaH0ulwRG0Y3kLexp8vc1gJAObWZvMPp9n0tQnK/8Wed7zvgG7UG+65r1HERcI9nK0LV6hgoZzGIFm6eu+RhA87r3uljwKZ4M3mjf7PqgeOtq9FjLE+cpCM/Irv9WSb9nOu0JJgyxCZ4+u+YAXUDMLr23ffITdWlpj1YdJu0lZW/j6qd2UAtIk0bPM+8lVKGLYo9P+3VY5FyxLu8IeTAwIEPBHqv1/YIbNL/ldAuavCltIrWz5bu7uRSdA1iOa24TwPD56k8fnaQdi96974Qrd4yQxTB5g2I4SXm5RsAme+qlouQyexiAGMYMQCaQJGQTOMMnqMUeDPYb1K/hluRzIAqV/VJp3QZKL0e7jsQMJNvJHG7+KZIr/c0XV8bwbc3gk9E61Wssq9fJb8kTRHSNFi8BpBszVnDOVEz7LJxb2xjkTeBpMDj6EwRB6jazNp7vv1kJ6hhqHh+pRTyx7+8iw5xyDtgb3Pus6jQZNf47+G4HhS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------QVrUM3rJ2V0pNQ7hep9iO32R
Content-Type: multipart/mixed; boundary="------------0xVRzTOr1DAkrkFmXoKm6is4";
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
Message-ID: <bbbd376f-dd0c-432e-abe3-7ea0e37b1db2@kernel.org>
Subject: Re: [PATCH v2 03/13] mm/slab: remove objs_per_slab()
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>

--------------0xVRzTOr1DAkrkFmXoKm6is4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> The function has an unused kmem_cache argument and almost nothing uses
> it anyway; doing slab->objects is simpler. Remove it with the last two
> users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: =E2=80=98typeof=E2=
=80=99 applied
> to a bit-field" but we don't need to keep a wrapper just for that.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------0xVRzTOr1DAkrkFmXoKm6is4--

--------------QVrUM3rJ2V0pNQ7hep9iO32R
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8JUQAKCRCGXBN6rc5S
1hoIAQC93Of5VVke2ZLR0Ho/ZA+b1qSqrQjT9drL71MUDzG7MgEA7eAu73jtOYlK
17uyJ98yg3Uwhq4QKfO0LVAEru/U/QA=
=NQkt
-----END PGP SIGNATURE-----

--------------QVrUM3rJ2V0pNQ7hep9iO32R--

