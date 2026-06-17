Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9E8CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1216B0095; Wed, 17 Jun 2026 09:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988776B0096; Wed, 17 Jun 2026 09:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FBF6B0098; Wed, 17 Jun 2026 09:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 503496B0095
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:56:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8990A03A0
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:56:50 +0000 (UTC)
X-FDA: 84889555380.28.F2DE18A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 369D0100009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:56:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kraHK5CF;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781704609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mi7jxCBuTqaaYC6JDqqn8peOnTfQK8+n6GuPM4X817w=;
	b=3QBHBcp6zG+4uoJOfGlo72oajp67hSSH+Sxv31gnLd6qjsr00M81oc1IzxlPy/ijGvnGp0
	sIGm1Wz88gG4VQ/k8JaQStcr8uFGuC52hkDZjA8At/jocJR8xNlVHXfxyJHzZGMSq5WKzs
	ntK0NXt44SuhUbSsnCO7gsW8BIeqbFk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kraHK5CF;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781704609;
	b=sFySVINe43HgXgdssBuZMbJY7uy7Q+IFfbBei9hw5Qw3XP5ahfZnjCQflD/ey4Mpy5wPhn
	r4uPxloxjpMC5ys/PvYhgRa1khHNgqnMJ5zNWbxp2mWKMGo0NKQRjzU7kugNIZ+rrVtJw8
	8BJULoyl3l7y4yxqs/HxWzhU1/NDMJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B85B660052;
	Wed, 17 Jun 2026 13:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62731F000E9;
	Wed, 17 Jun 2026 13:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781704608;
	bh=Mi7jxCBuTqaaYC6JDqqn8peOnTfQK8+n6GuPM4X817w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kraHK5CF4FrRvFnQJ0VsRChLUJSHWInCzt2ZQlbzcfxiJwaZPkbZb/szb9+MAX+i7
	 t7gPjz6AE5H0WiV9bYsLcRXHAMXa62IrS8LD2lKFH7hlfwE4/LLR8yYFx14Ja4XU9J
	 g100+AcmfJ8CMsw7poJskCe+caWz7uE5qvBpnBdyWbrxS7wC6/cWekkczcgFSeaQiH
	 iqJFBRWZz4HXTsi53E/M1UspG4tGKSACwTcuWuWkDaSbhypB9XoilM0+4Sx/5H4hB7
	 jnT1bbpPzpCQ0t9EM1W+WtJvaLsHGa48iknWK4LE0Cvcgu+9Ot5Eooe4m25C7IHiYm
	 x9HRHfRAZV7Ug==
Message-ID: <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
Date: Wed, 17 Jun 2026 22:56:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
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
 <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3cY5hSMZtGl0G9UhgN7kKCMK"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 369D0100009
X-Stat-Signature: tp6yzxc7ja8d5jeokpa5t7r4xxbnurtt
X-Rspam-User: 
X-HE-Tag: 1781704609-743938
X-HE-Meta: U2FsdGVkX18oG5haGgm695iCeslv8lTPBufbxJhPL8T/xkxIEyaOswqLu5x6mCG5wGnIZINw/dYEdIebPsJyTbk670KDqEmoPssPpGO1ksphAWx9UehlS4pBWRYk0dZgfPjlm/vmzclAH4flbPEl79HWKVz9BNinJbUes8NOOOUgrs6P8HkCS1KxzWYVZ5r1OyvfhWQP294NAdRSWjhDl/rCeitQjNjtQpQEIMFQMznReAR8gQ8Bx9TpNjwOtTSsJTGPf6kqcG3hpCk4Q5DaT36W9kyclc5mDyql5GYRnIOuXTQdCI20Xj5uq+1vZGMYKyXcMe+jJopWpqMkw/+2f3KAJbHY5C0SCJi0eBYngvcho3XP9OCLG+od2qqL0GOEeKe3ynOSEGf2E2Cdb9EByBVkrryo3/4ev9/P1i3O6GLGViHR3dCJTN9RRX5ljsEDJsPMdT53PraN2AtZSttTp7qCPwNNGHeHFtEvJLbaPFup7ioLfuwnRTJ/0jvO4yrLKwkik0cm4bZE5uo2o0eu82srDlKZI/yd0nNvCOnVz/9d1EcmnFtuTHAW3AYtzSu83tZvEUJ/OauPQNJBeglY3O/CXtMHkLsT/rA/o+FgyluPYwtBZplOAvvbqEbGQa/xX7vva00gAyiNjk20blfEM5r2TcpzOEhRou9Q8OPYzJxPSB5pKLpQ5r+s+4DPNShTpIqEctyh10jxEYfbhM9jn2vUMsVUcmbhP40fnGWWfve60paVj/WwDpVMdn9+AlGmjC/B2S0y631QqTBePF9vZRTH1ecu1EA10m36P7xZ5TyuzABpPmp7V0YeFkJdVSVHaAmOsvl/SEfrzRHYOS7RodO9i6jy7KC9v4vhymZg5/GgQkro3J0Wqt7JkqYyGKFzJJN4XFY4/whRL7CS2KWiXI4f0HBHwvFO19oUdGgqD2ouXH7AixbahezeotN94azvfOibVWJ+hRPIV2P+V9K
 RNTZQSAN
 Fnbuc5RY1orZ6AEhf89vRXt4r+Rj0p1sN57K5589pk6H2XID06hGq385WY5A2pZ1IWTYPY0V1d4U1DPDV0Wmv5/APtygX2k6HXuzz0qHO6t1NnC8RG0o38ZSrXf8O1Tsscgc/YLaE7qjMQSEILaPUvfgZO3cnUbKcQvd6qCG6ysNgVF8xrF81hRy5MBZZKF8YNzH8XGkhQlpQhh3Uy+R7ai+cRtwwquO/8xSfgSI+5CgSz6t4tM+dVwe89PYbSpNkX4UbNE5SceSVyKywtU8XQRoV26t/HO+fZTldBDUKeGraAYbC3WicP/ys6iIvyPXHcVTPJdqz3dPxYkXAger3CQ/AKN7yA2AyrtIxf8b+TYpLXEqF+d9Xh0Lo1/GEZbOQm2BXAQNk7025NKDkb4fU0VBokRIkHwr0R4jeyNgtwrPKJriPg/6Ijg0C3ZvWJUMf4y+07zyctT8jRv1i5A66ZKLlSOuY7OX3K3+e2e9HKS3CugHF92JUhfxrovZPGXoyEId115D6scY18XA+3PO4bSkEV5XnRkHGmMhEmqjV2TDxm9OLf+sFMCzqeChQHEqIBi34TJ9i7nWkVHIkybWS/JGG9q1zmKh5zScg+ySDbwJV53w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3cY5hSMZtGl0G9UhgN7kKCMK
Content-Type: multipart/mixed; boundary="------------5rrQhoodNrxJ9Qsb340LQn6A";
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
Message-ID: <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
Subject: Re: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>

--------------5rrQhoodNrxJ9Qsb340LQn6A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and=

> gfp flags are a scarce resource, unlike slab's alloc_flags.
>=20
> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
> family function should not recurse into another kmalloc*() for the
> purposes of allocating auxiliary structures (obj_ext arrays or sheaves)=
=2E
>=20
> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
> added. This will also pass through SLAB_ALLOC_NOLOCK so we don't need
> to special case kmalloc_nolock() anymore.
>=20
> Note that until now the kmalloc_nolock() ignored the incoming gfp flags=

> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass o=
n
> the incoming gfp flags (only augmented with __GFP_ZERO), because if
> alloc_flags contain SLAB_ALLOC_NOLOCK, the incoming gfp flags have to
> be also compatible with it. However, we might have added __GFP_THISNODE=

> for opportunistic slab allocation, as pointed out by Hao Li, and
> __GFP_COMP by allocate_slab() as pointed out by Shengming Hu. Solve thi=
s
> by adding both flags to OBJCGS_CLEAR_MASK as it makes sense to strip
> them anyway for non-kmalloc_nolock() allocations of sheaves or obj_ext
> arrays as well.
>=20
> To avoid recursion of sheaf -> obj_ext -> sheaf -> ... allocations at
> this patch, until the next patch converts sheaves to
> SLAB_ALLOC_NO_RECURSE, use both gfp and alloc_flags for obj_ext. The
> next patch will remove the gfp part.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-15-7190909d=
b118@kernel.org
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

With some comments below.

I was worried that perhaps replacing SLAB_ALLOC_NO_RECURSE with
__GFP_NO_OBJ_EXT will create a cycle of

alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
-> kmalloc_flags(SLAB_ALLOC_NO_RECURSE)
-> alloc_from_pcs(SLAB_ALLOC_NO_RECURSE)
-> refill_objects(SLAB_ALLOC_DEFAULT)
-> new_slab(SLAB_ALLOC_DEFAULT)
-> account_slab(SLAB_ALLOC_DEFAULT)
-> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)

with __GFP_NO_OBJ_EXT, it would have been passed to refill_objects(),
but SLAB_ALLOC_NO_RECURSE is not. However this cycle does not exist
because alloc_slab_obj_exts() clears __GFP_ACCOUNT (as part of
OBJCG_CLEAR_MASK) and memory profiling itself does not invoke
alloc_slab_obj_exts() when allocating new slabs if SLAB_ACCOUNT is not
set (which is interesting, by the way).

Also alloc_slab_obj_exts() propagating SLAB_ALLOC_NEW_SLAB to
kmalloc_flags() is little bit confusing because it does not have any
effect due to SLAB_ALLOC_NO_RECURSE.

Those are quite subtle and perhaps worth some attention.
But technically, should not be a blocker for the patch.

--=20
Cheers,
Harry / Hyeonggon

--------------5rrQhoodNrxJ9Qsb340LQn6A--

--------------3cY5hSMZtGl0G9UhgN7kKCMK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajKnmgAKCRCGXBN6rc5S
1haJAQDK3uVXonDI0YBvLzkAybijWZr2Qa7jZx3GhFza1G/qjQD/dcdV6qNgaQS6
SF4LWQHTO6baylkB0+NrAe4QBdWSKQ8=
=/47q
-----END PGP SIGNATURE-----

--------------3cY5hSMZtGl0G9UhgN7kKCMK--

