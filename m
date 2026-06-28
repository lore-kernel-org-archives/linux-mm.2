Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAB9C43327
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 08:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AECD16B0005; Sun, 28 Jun 2026 04:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E2C6B0088; Sun, 28 Jun 2026 04:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CC56B008A; Sun, 28 Jun 2026 04:36:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D47D6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 04:36:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD0E68D4A1
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:36:14 +0000 (UTC)
X-FDA: 84928664268.08.3575B78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 42D38160003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:36:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fmtQHkCR;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782635773;
	b=KPqkj7uJYzRhaf7IY+PQ3XKEjNQRsR9d+qhktMGlMgjnyKCCpACXT02OGmGyvCobDHYsSa
	I24VVMHrHEp0ig0QpbHBL3Jo+q3QWRCyafP1ILao4LIc8IGnUopMb9Lb/yFUU5yA/MqtmW
	HtsKazjI/eejbnRBdm0Sj+DiWPzG4xk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782635773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfvn8w/+2N4QOEp9amrUt+70kbimej+Gnuwa2CwvU4I=;
	b=GoOey1BAnG8dylrlc5aMtyXysuH5e0/c0EcpQRu5d01TW8f9sFDOP6ifQUAKEwPkX0ZqFQ
	BmGOpVIWDoSwdxfpEON5HVa8xL5jEKeNVvpKWMYxJmy6kbgTVoPpaMgVn0x7BQMD11ddwU
	URSaTGEnTd8GISGeunY3kOolKIQnY5g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fmtQHkCR;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD12E600AA;
	Sun, 28 Jun 2026 08:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601B11F000E9;
	Sun, 28 Jun 2026 08:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782635772;
	bh=nfvn8w/+2N4QOEp9amrUt+70kbimej+Gnuwa2CwvU4I=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=fmtQHkCRavnlx+8nWKlfhm97zrd3InihC0KY8/gqPbJl3lHLZA+hdoNzw9xnLUGOd
	 oFnGyl8PBncJtgyQjOmj6KHasbLjCKn3k3d2IgGGLS+dpwv4T9VpXixI7rAIFJC3/F
	 VvUvIhwrZnfa7RIjJUsjGbV9jHdCeLjlrekt9EoMe+PJhvG1udoEMXIODkPTXh2+YF
	 7SsgJn3/dnEinZxvCsUtoPksc6CafeFUzkoG8ZKvv9T4mxWRGuFYTc2dsv6YTXYSeI
	 tD9KesbSim4SukZ0xGvxVi7t/299g41XUS815QCkJYXwwC9OViglrPtyaHrDnSYa2q
	 UvP7qbAvvtaoA==
Message-ID: <0a5bd822-5076-4dc5-9c99-8b4a36d119a2@kernel.org>
Date: Sun, 28 Jun 2026 17:36:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <0925f783-1506-4a20-ab9a-3130c2f07ed3@kernel.org>
Content-Language: en-US
In-Reply-To: <0925f783-1506-4a20-ab9a-3130c2f07ed3@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3GfxXd63I9ObqmVAjGuD5Xr0"
X-Stat-Signature: krg469h9jacbaq4s9auqpbfypay6mga3
X-Rspamd-Queue-Id: 42D38160003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782635773-762633
X-HE-Meta: U2FsdGVkX1/AZIFEQJ7YDoTL950eNwXGzeTAMMLpXqpL2PnWX3YVy42FnRxhNZTQU4XwTvqQ0b2EYVyQoIkSQb3C45Fa3drN2Ndv+2s4HLFnSPkrz91j0MRtRZN1AMoi07aT5l1/kyIxX7cw9sPMVxTnUv/WftewEO1yB5z8+Y2EG1nlsy+xc9wKPFHQ42ZEANtCcOCfHpYMppJOdcZuWLYNIgeNIgDqEEI2H1dS6c6Q5nDFHpS9EgbKUfZgeghxvUe/IbEAupslzD1kehdnyOXZuRo7q27MIzXBPfWviQxpw1q6jbg7YxigIjI1vvoBfc6GZe8U7a6kcFAbr/G7qqog7VJsQD2H0+nOYybahdiw2AvaukgVpzmM+iV2Fo1dm573uBTaxv5Phr8HU/ZnKCTDJ0LHVpMO1TP1oT6nqX4yhXZDAhNp9gyp9CpXSM+T3abrHXne+5Oj7SrP671KWc9rYunLJDxSGiDjVIbIllMr8NEvey1+Zs9RLdAUGxU569VYLHJZrWbd/7L+sxep+lO0MJvtLJGsEXF7OvCgAfsL3mH6M6ltFiIO3SmlSQ2kAtTnNoKpOdWdOtjL/qgn0BX6xdzTa7jArUHpo/inW6vDqJzBwSnHedgh6scmKEr3SOKSGmlNkroi99Mh0P8JgRA4g0ioI+Rh2gwD/K6aozhRdqfokbmuLPx6PpzvRlAbMqSTZ0PWwoYYcZEcNDgDXX2tKupZfevTXbPBkh1d9htLikDU+fD6ti0BtbO/UVCtup8ZWScUAGK2c0QuSbwJONd+TcCroWz1BK2aw73PR6+HaFNeyh2479J/JGC2A+6jcFm99ImUDSXp+UskWNC9cKJ6HNhtHn67EwxpuD2gkQqXM5XC1RWSRYYRKkhvAUu3Jj6lEWYVjpuGGCa62+KFgbWdkr1/gQr/nHrNNx00My95R7hzo8DKK1exae0Pd5MVtSmVq8/AvsPAUSZlLKL
 QvlXyeeD
 aqwjfJLRIhhc3hd53RKkuPUEuapLi/16d9wy4CquXvQOPl6V0bwik8jW3qhW0YnByUdDF5ycCYLvI1OdiLrOBlU4EL+hj1hsGZ65xT9WN41CGz/DeHNk5zYfNaTb7sWByTFVbhyiTaz9oV+JaZqoyL+MDbKSR07NI0V5oG1/jraSzZT3kC2Lq3Ab1GHe+s1gXQsE/zz12NbiBzFnqgCRwIXUiOzkFpwMBFvVva8b6hEH6ZlqEFw/PzTIeK18gjIbx5mks1E+Xl0WG7yTJqz+wbx4baSvAqYjRaA506Sao7CE7VigkGpknBhwgzDUA4jc+glYWCOMajPn1b2n45Ed8DK4/6wDzEucTs+DfHSTIvXHG3dewA+6XC2/3xfkAdbUWtmA5lspIsCkcd899kSyISoMXOSmbVFlAlOUYfz5tG/dKMymm0dmwFhD5rm81cGW/XVMmqCE0qUiOEK8C6KuU8Fl10LP73x0JnmkieECB0f8EfAw2EhrgIt6xMBizlbYc5uZp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3GfxXd63I9ObqmVAjGuD5Xr0
Content-Type: multipart/mixed; boundary="------------wKfn6SOhJ4zncBuTwBK74Tnp";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
Message-ID: <0a5bd822-5076-4dc5-9c99-8b4a36d119a2@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <0925f783-1506-4a20-ab9a-3130c2f07ed3@kernel.org>
In-Reply-To: <0925f783-1506-4a20-ab9a-3130c2f07ed3@kernel.org>

--------------wKfn6SOhJ4zncBuTwBK74Tnp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/28/26 5:10 PM, Harry Yoo wrote:
>=20
>=20
> On 6/27/26 2:11 AM, Vlastimil Babka (SUSE) wrote:
>> Minimally I'd now want to only do that size bumping when allocation
>> profiling is enabled. Ideally that means both configured in and not bo=
oted
>> with "never".
>>
>> We probably should have done that already in 280ea9c3154b2.
>=20
> I think we did already.
>=20
> obj_exts allocation triggered by memcg has __GFP_ACCOUNT, kmalloc type
> is KMALLOC_CGROUP, and so is_kmalloc_normal() should return false?
>=20
> Perhaps a comment above !is_kmalloc_normal() check would be nice.
>=20
>> Because AFAIU
>> memcg-only obj_exts array don't have this issue
>> (or maybe they do have the > [1] issue? Harry?).
>=20
> memcg-only obj_exts array doesn't have this issue and [1].
>> Because obj_exts are not accounted and so we can't allocate obj_exts
> from KMALLOC_CGROUP.

Oh god, I am confused again! Commit 8dafa9f5900c says it might have this
issue. However is_kmalloc_normal(s) =3D=3D true detects that it might hav=
e
the problem when either 1) memory allocation profiling is enabled, or 2)
SLUB_TINY w/ __GFP_RECLAIMABLE|__GFP_ACCOUNT allocates accounted slab
objects from KMALLOC_NORMAL.

--=20
Cheers,
Harry / Hyeonggon


--------------wKfn6SOhJ4zncBuTwBK74Tnp--

--------------3GfxXd63I9ObqmVAjGuD5Xr0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakDc9QAKCRCGXBN6rc5S
1jIeAP4qtq+NisEYFpv03iiMzdPr6nve/wHx8YPlWmcM0mTcaQEAnILwYYfktP41
1GWR1qw3TzgjwtzfndemUjSIV6ZG1ws=
=BhXu
-----END PGP SIGNATURE-----

--------------3GfxXd63I9ObqmVAjGuD5Xr0--

