Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6C2CD98D2
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8403A6B008C; Sat, 13 Jun 2026 01:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1706B0092; Sat, 13 Jun 2026 01:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707D86B0093; Sat, 13 Jun 2026 01:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5314E6B008C
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:42:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5E081C1A42
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:42:49 +0000 (UTC)
X-FDA: 84873795258.26.42E11D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 42F08100003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:42:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Deu9DwUf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781329368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQ9VuLrT9lWjXA95UmdYTFa3mfcUEGbFNAD+hFt7gJI=;
	b=3KrEnrzE1hOPoILLPnBo5XpadxnjMWFt3bs3I+io+VU+UWRQLCnv78Aa+vxK6DEQIJoIkz
	PIeUCYt2J93H+EJ3KRwCuHBjz8hxrwXO07YtevD0njCd0rL3FThl7T3BvEu9z3kf2mPpU4
	c+1iFN2HOwdLttQy1P010gpX1QdMbdA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Deu9DwUf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781329368;
	b=oK6/NbjfaY799XoR7b0OFeeNHzq6BAdeyzEm7se11A7YXAjcYcVSxWtmU4JL804e2Igo/W
	+CaMQuD9H0UPCw5O4ZXDqh7ieF0v4p+XKWuoRWm/KjbvqJsTDFJ15mXL+ocCJq1ilMjafC
	pc/HJ7i6i0JmSChbxMzoqFjVyzoXQt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7251260018;
	Sat, 13 Jun 2026 05:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A124D1F000E9;
	Sat, 13 Jun 2026 05:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781329367;
	bh=cQ9VuLrT9lWjXA95UmdYTFa3mfcUEGbFNAD+hFt7gJI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Deu9DwUfPvX+pf8YXRD2gCfZxGgvy5aGSubS/nTu0DBGOffo/JU1Whk7S/8xIFAeH
	 YD/VbMOYUhz1r16cGhJ8UAdwozjbE7z8kD4y22AgfpRatKCt4cEg4gPy/Py8QvrUZw
	 yem6a+k8nfXV5LDD0BdIyoXjbtXxVVDwlRtNwxAoNGPlpyPVtT2X0hlyiKeiUoKFBr
	 J77x6YwhS1lt87mUu4BlRZqMDb+X025LBPSNdWT6ugI82/MNQGS4PqnaOIrPHA8n/d
	 zOKRfr8VklRuYBFMkgo08nD0HpVYlDs80yDGxlb1pOseSwDNHOb82Bwz5vDpjsqbS6
	 t/+dBDQ4mqq6Q==
Message-ID: <d09bdcf2-c713-4195-a1f6-84117ac9884e@kernel.org>
Date: Sat, 13 Jun 2026 14:42:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Pengpeng Hou <pengpeng@iscas.ac.cn>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
 <2b5577b0-d81a-4dee-b4e2-acadcf7f7db2@kernel.org>
 <8c5d67d1-e4b0-4cb2-9336-875f4f2ca96b@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <8c5d67d1-e4b0-4cb2-9336-875f4f2ca96b@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------B9SkLUiW8DsmSGOmWKChDNmd"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: nkf6dt9mjo5s45h1qi4t31mh6fahdcib
X-Rspamd-Queue-Id: 42F08100003
X-HE-Tag: 1781329368-684021
X-HE-Meta: U2FsdGVkX1+VK8A/EiO8In1jgktffliBy+EK0VUqUwSlsmjJZR02r6MegsL2g22EAx3BVDLXdzibuicnpg+iFj6RWl3tDwAL3lr1XC1PPuGjLDRpmr/f53whzu5JI9qEUyyVEoBSRgsuyDprs1RYArcmtP6yqgoM4erzjRo+WbHAPfGU7nqPzOGTEP2jmIVAx5V+FKIlrSSkGCIISgkw+qsqZ/wr4nMluA21iQbnFc/q+7voUefNTkO2n/tu8DySGZj5b4Nhq3ojUvVPxxShMJ26t08DQjqLcnHIFlQZZrDdrL0P1TqWy9aHYFgDZBmzsqvF0xpowLg/6vozwDk1jyY55FpKDvQNepzw8BysL0bp9EuXav1AZKxoY6oR1zZ0ONGRGw/0qY3QVrATHryYz++ZnpUUbr0QJMqtcaaFhNkyfhRxGQPvFwDqATP797TxlDgtaKQtEMNU9DSXr/SrN0kjOC/N6o74Iba36V4c/ovl3L92AL+JyORBWyAdET+nuDBMqB5AwcmxLN2c35zdJ2ruzkLtpkdFHzMPiICktuH6LDfLVRRkgcaIrJ1dUfjeeGapTeEbTXgolUR66u96Kkg3WFr3cndHMc4f3yQNk7sRG0HS6Qrm1Dymze+77xsuGG//MO/x5X6EBGvWaUBo7aWEVHUytTDFyeoJ/kPFNAoozXdpio3tXAqfZvdrrGOVf0P3Vb/8G7KGNH3BgCyJbRWvvJLitpmYKaU+cyDrEiWZ7+0QpND9q+KHtJrv6qUGMA2MZL6HpGNblQqCwTJNZBpmkXqdPenK6sF5yNhZaa5kNfNtoTj7+cjE09LeFUWm85/FBsIIDH4X4sAbz5cUWqUHQvMfp+1WQUJ3niZ3RbTUSjuAsO9VsVRKn3XZhRUdfQ1VC3OMV/+KX1ZpKdY5Huc+1ZMr7zHNTS3EwwhkEXjO/cKQHcXmQO2hP3/zNJlZycSnvPYBCzMzQzuWmGL
 XvRW/GGN
 nKXyrQXIQQ5e+dUjK7hnuW20eYi0YbtCjkpdXe31ihYbS9yJfo8lo9nkusjUWB0paMlP9sMf5jHaOEo7O2Cr4SCwfmYNf0GbZWNtjNFrOmOt9+T8kSxMK3AXNWCUw+UxTP2XnKmoS6ZrR8FI08kBNvzINpYo6GD1SZrWrxKDnvwokzBvjhksLbryg8/aw4n9w4RFlGGNQd/5vcdrP0Kp5PCQd1d7AVBbSQVhvANcKzMc5ZdNdrVVDao2MXtU1fcQwbbisjxsW9JDZ4V70UCbkkQq2j05sSuNbK9klsrIQWJcbYbmfZLhguIQgdgx1LBnekV1cqIVW+eZsuqYuUyg/68o+iVVXiVERyLidYU5Fi8XjhG/DIYC9Uus2h16hBlmXZHPiMQgv7OB1mYnMzZYT/GKwCMVCPOhxv9HvF8dxhSuTwBzLW2dRQPzHD1E5qDq7cM+UmkZmghGOYO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------B9SkLUiW8DsmSGOmWKChDNmd
Content-Type: multipart/mixed; boundary="------------TC5JMruIL0kh5xzF0eWK8sF5";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Pengpeng Hou <pengpeng@iscas.ac.cn>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <d09bdcf2-c713-4195-a1f6-84117ac9884e@kernel.org>
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
 <2b5577b0-d81a-4dee-b4e2-acadcf7f7db2@kernel.org>
 <8c5d67d1-e4b0-4cb2-9336-875f4f2ca96b@kernel.org>
In-Reply-To: <8c5d67d1-e4b0-4cb2-9336-875f4f2ca96b@kernel.org>

--------------TC5JMruIL0kh5xzF0eWK8sF5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On 6/12/26 2:13 AM, Vlastimil Babka (SUSE) wrote:
> On 6/11/26 09:19, Harry Yoo wrote:
>> Hi Pengpeng,
>>
>> On 6/11/26 3:39 PM, Pengpeng Hou wrote:
>>> SLAB_STORE_USER currently stores one allocation track and one free tr=
ack
>>> for an object. This is useful, but it loses part of the previous life=
time
>>> when the object is reused: the new allocation overwrites the allocati=
on
>>> track, and a later stale free can overwrite the free track.
>>
>> I'm not sure what you meant by "stale free", UAF is accessing object
>> that are freed. What makes the free "stale"?
>=20
> I'm guessing it means 'second/duplicated free" of the previous owner.

Okay, it wasn't clear in the cover letter but now assuming the same...

> Accesses (UAF) perhaps may not happen by that owner, or if they happen =
after
> he object is reallocated, they are not recognized as such.

Right.

User A				User B
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
allocates an object
frees the object
				allocates the object
frees the object again
(poison the object)
				overwrites the object
				(not detected until freed)
				frees the object, UAF detected!

By the time it detects a UAF, free trace is from user A (of the second
free) (since we perform consistency checks before updating free trace),
alloc trace is from user B.

So the only thing we know about user A is the stack trace of double free
but no original alloc/free traces of user A.

>> In general, I don't think slab_debug=3DUP is the right tool to debug
>> use-after-frees, because slab will never know _when_ the object was
>> overwritten. It can only tell that somebody has overwritten freed
>> objects by checking if the object content is POISON_FREE or POISON_END=
=2E
>=20
> It could give more information about double frees like this, however.

Right.

>> KASAN is a better tool to debug use-after-frees, because it can
>> tell you which kernel code is accessing memory it shouldn't. (It also
>> quarantines slab objects to avoid immediately reusing the object for
>> better coverage).
>>
>> So I have to ask, "Why not use KASAN instead?" before enhancing
>> slab_debug (neither is intended for production anyway).
>=20
> From my distro experience, it's very useful to tell a user to just enab=
le
> slub_debug for a specific cache with the existing kernel, with some but=
 not
> prohibitive overhead. And with some luck it gives you enough informatio=
n to
> find the root cause too. So in that sense it can be used in production.=


Right.

> KASAN is indeed superior wrt catching issues, but almost never applicab=
le in
> such environment. It would need a rebuilt kernel and the overhead is mu=
ch
> higher. So it's a tradeoff.

Right and not all users reporting bugs are willying to do that...

--=20
Cheers,
Harry / Hyeonggon

--------------TC5JMruIL0kh5xzF0eWK8sF5--

--------------B9SkLUiW8DsmSGOmWKChDNmd
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaizt0QAKCRCGXBN6rc5S
1k1IAQDlH9d73y9KVNOffoPOZhCVjmizsVyS5PKhR8KGaNd15QD9EF1XWBhLH5GL
sjIkxJykNrDMs321EfQtA+bvk0WZEw4=
=y2SJ
-----END PGP SIGNATURE-----

--------------B9SkLUiW8DsmSGOmWKChDNmd--

