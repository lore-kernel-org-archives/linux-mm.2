Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEBCCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EDC56B008C; Wed, 17 Jun 2026 10:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C54E6B0092; Wed, 17 Jun 2026 10:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303D56B009B; Wed, 17 Jun 2026 10:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0FFD6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:40:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8219514033C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:40:47 +0000 (UTC)
X-FDA: 84889666134.20.18E3AD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E08A54000C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:40:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZ3DSq6l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbIei5LQuFojnG61oo9TKFoyCWfciPusCPgoFw/p6i4=;
	b=0jPwNm24Qldl406YRXvO1ZbPw+O5drDWmxMXFxee/Ou6wsydTVrldeqZHrPgpl3lPrDOQD
	Rn+9+cPjCfX/nyhx3ru4MGXVFhU8w1ZYIOhTf9v1/9eKyN5p6vC7U46yOt1hWkBAIW11xy
	/3jyup9onZvby9BroD1amQjfANqRIno=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZ3DSq6l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707245;
	b=o04Xhhi7xNKqLVZzXE1ttAecePeyfRlu/t9q+Bhutth7PLqK1HQKzMGaitCyWp/MHouk1Z
	U/FFjTLWr4eBtozzDW1vhoRk4J/y3SB9d35Saw9kAZynWkJK37wnUozhH5X0Gh7APMPXOt
	OVPElth4IdoNtXgYLzRmoR0HnaX8a0Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B7C86001D;
	Wed, 17 Jun 2026 14:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7565F1F000E9;
	Wed, 17 Jun 2026 14:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707245;
	bh=nbIei5LQuFojnG61oo9TKFoyCWfciPusCPgoFw/p6i4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jZ3DSq6l+QsHgbvMKTv3EZBc/yQZkW1DWZudDzczG0ToiC/FZhcJcb10b5j0pCQSs
	 v8E6T26mo+I5raG2Luz57wasV+M16uL1T1+p0zZ8UVhuiPT98nv41MW/9QGWvuwsHj
	 fLoCTYDnWfuYvmYOc+GYRVGVHbkQDd0aAkFWbTwKIhonIWFvPC7ekmQfWkqCKtaLWo
	 rTjJ4HNqRsBTEyUPvO+Zxk5I+fgdrp//kizFou1k46AcHc10Pf73nKgZgqKUX0Marf
	 4gAzFwLRYE+8GoedamHKn3j5hp+440s4kut6/nVmL1FiCaxP6VIHzJzv9uyjdhFiU1
	 m4ZOa7/7LFnyg==
Message-ID: <02f9c426-b568-4ddc-882f-aab8c7f31976@kernel.org>
Date: Wed, 17 Jun 2026 23:40:39 +0900
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
 <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
 <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------GV0qWTMYBB1AKSMm3bfNfef6"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: wkrn6as9wp7npx77jbmnxs7gnq8erea7
X-Rspamd-Queue-Id: E08A54000C
X-HE-Tag: 1781707245-748220
X-HE-Meta: U2FsdGVkX1/vTcGhnsq+UM80j0r8pntj53U0XxGwLxYNYvCHTFLp/+xlLjGYqlKqEOWm2XK1FHgb8itNYBEFNQI3ZP0grO0TqDbsOML7GSrBRKHEX7nLRrBqMp1tZn4t1JZLM/vB43660WjIxpUD3OTp8gwdQohm/Ra1AXmn9c5k/EixUnfqKMwYBzwEix124tvYLCcCv5C8ph0eSF6GJuw9fufWxLXV64lVB9irwWru6aQbxuntkHqvSdecGt826F5NY+3jHb9GSIUD9PgJS17+7kljxPAhfvtC8ev8szWy8SFkN9E5MtyNX11YztCqnOltZLabeULV+a/8aYqmSWscJWtNR2v5e3XvURco8ptkTmaMoPEl3xc1chJDWDIrwlR7uucmIegqhrhuYEqYYwR/8+AqtCInYecEOtZCQ02ZGJ93zA/XbMf3nQJrMzVV+q3Fqg6y0tBq/m1P4tojkP5krawQWxdO6bWXEGbW0kHq1Om0GBoRBvlgHjGm273H7QD0x1KgtYRnn52ijyBOBJs6Bs6RJf++iWQZrxCRS+RVfat+vbdtd7wCLTSiyp9OcbGOmCrDxMxaU4pBzKg17bUsTYzL7h75z+tDViRJjdWtlw0vnvZCHByXov734j3z2rO8/4EJD+NVndZ/oqq39PC940Uv+S0ixTrc5Wqk9WQBPntLD2hg24YwDfgpjhTaEoFzCbd581vOe+k5/qtkq4EhWMSglBBaKXbIb+1rr6a0ntyGf40+pMjsc1cUqj9XMwyOByEirMKE9NK2yXqxp6oPuIG0SGoEDZo07ZlKIShHNfD8CdEN76TK36unguNctlmevvn99whFxQXLhp2fsRvSJaR8V/9RZsnco344KTZyAFHHwCsxYzm8iN/a5JXRHUdt6rqIKeWJabvMmTVd1rM3ZkUkOjiR7IMlmHBmaQNt8As8rvbUuaGOKy2DUhKlW/RMUYUv8PbuZrl7iFF
 icjmoQDC
 +uKCPq1f0k8+fUG5SEfTocMUaQMLQpnpZVyfwi12wZ9SE5QGHlQ5g3gOWd9EjLg3KxSQoLU3hL0jiSomf4yaswTgCkbdq/i9kBe6/eKUlGMCJiVMsAbvS5je4EPioeYx7kNlbUAW7uNylIMM3shVxwZWBksrNwDaCn5Euvdz81TdTXMpNmUtImSEw1B8QajFtybOecgFuSiPEB6aUbxPDPfpWP+VvJYhJR6PTCjaJaO+5w7yGiiZrZgO3E8Q7MXEKYgbzqx1q1el94ynY9ZqkrZ6NFsIt7Z/eVGlt5VZjckOk654ri/zrfvix2ujQRHUaLqE1di4tNFn3LKq2oOVjjk0Q/U8+czUuTmXOGfALpUtf0X3gjXZ4EbbkJQmOIOqgiout+AJb1mhO4U/ffE88KjiV7IE2Ktxq87RTiklcL44UXHc9dVkUJiHqAFiL5gJP6B+ChjBiMUaVFAz1K4FQojPpYIN2oVkN213H21HgOYfoQ7ubI2k24XRQ2bX1r2vnuoQ60K/W448Uk54lWZ7PLf3Z+QqRl6wADvicP9HLsxxTLKKWCz7dGiaGPRRbqwK28NCDnhyvDqSvRhKUH0kIgk172D7U8vJW8mmiNLa05Xf5FNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------GV0qWTMYBB1AKSMm3bfNfef6
Content-Type: multipart/mixed; boundary="------------oVz7MBau50V4H9MeL0byYqJq";
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
Message-ID: <02f9c426-b568-4ddc-882f-aab8c7f31976@kernel.org>
Subject: Re: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
 <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
 <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
In-Reply-To: <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>

--------------oVz7MBau50V4H9MeL0byYqJq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/17/26 11:36 PM, Vlastimil Babka (SUSE) wrote:
> On 6/17/26 15:56, Harry Yoo wrote:
>> On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
>>> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself a=
nd
>>> gfp flags are a scarce resource, unlike slab's alloc_flags.
>>>
>>> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent a=
s
>>> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
>>> family function should not recurse into another kmalloc*() for the
>>> purposes of allocating auxiliary structures (obj_ext arrays or sheave=
s).
>>>
>>> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
>>> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
>>> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
>>> added. This will also pass through SLAB_ALLOC_NOLOCK so we don't need=

>>> to special case kmalloc_nolock() anymore.
>>>
>>> Note that until now the kmalloc_nolock() ignored the incoming gfp fla=
gs
>>> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass=
 on
>>> the incoming gfp flags (only augmented with __GFP_ZERO), because if
>>> alloc_flags contain SLAB_ALLOC_NOLOCK, the incoming gfp flags have to=

>>> be also compatible with it. However, we might have added __GFP_THISNO=
DE
>>> for opportunistic slab allocation, as pointed out by Hao Li, and
>>> __GFP_COMP by allocate_slab() as pointed out by Shengming Hu. Solve t=
his
>>> by adding both flags to OBJCGS_CLEAR_MASK as it makes sense to strip
>>> them anyway for non-kmalloc_nolock() allocations of sheaves or obj_ex=
t
>>> arrays as well.
>>>
>>> To avoid recursion of sheaf -> obj_ext -> sheaf -> ... allocations at=

>>> this patch, until the next patch converts sheaves to
>>> SLAB_ALLOC_NO_RECURSE, use both gfp and alloc_flags for obj_ext. The
>>> next patch will remove the gfp part.
>>>
>>> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-15-719090=
9db118@kernel.org
>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> ---
>>
>> Looks good to me,
>> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
>=20
> Thanks!
> =20
>> With some comments below.
>>
>> I was worried that perhaps replacing SLAB_ALLOC_NO_RECURSE with
>> __GFP_NO_OBJ_EXT will create a cycle of
>>
>> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
>> -> kmalloc_flags(SLAB_ALLOC_NO_RECURSE)
>> -> alloc_from_pcs(SLAB_ALLOC_NO_RECURSE)
>> -> refill_objects(SLAB_ALLOC_DEFAULT)
>> -> new_slab(SLAB_ALLOC_DEFAULT)
>> -> account_slab(SLAB_ALLOC_DEFAULT)
>> -> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
>>
>> with __GFP_NO_OBJ_EXT, it would have been passed to refill_objects(),
>> but SLAB_ALLOC_NO_RECURSE is not. However this cycle does not exist
>> because alloc_slab_obj_exts() clears __GFP_ACCOUNT (as part of
>> OBJCG_CLEAR_MASK) and memory profiling itself does not invoke
>> alloc_slab_obj_exts() when allocating new slabs if SLAB_ACCOUNT is not=

>> set (which is interesting, by the way).
>=20
> Hm yeah I think we should propagate alloc_flags to refill_objects() etc=
, to=20
> avoid later surprise. But can be done as a later cleanup.

Ack.

>> Also alloc_slab_obj_exts() propagating SLAB_ALLOC_NEW_SLAB to
>> kmalloc_flags() is little bit confusing because it does not have any
>> effect due to SLAB_ALLOC_NO_RECURSE.
>=20
> OK let's address this one by this fixup:

The fixup looks good to me, thanks!

--=20
Cheers,
Harry / Hyeonggon


--------------oVz7MBau50V4H9MeL0byYqJq--

--------------GV0qWTMYBB1AKSMm3bfNfef6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajKx5wAKCRCGXBN6rc5S
1t9iAQDiPXLnO6zy942RtBt/uX/MTobE+4pvYi/Tod2EIOc7ZgEAm+SvzDRW2ab1
rNcaW/zRWDP59NB8KIsOmgrG6w6qBAg=
=zqiN
-----END PGP SIGNATURE-----

--------------GV0qWTMYBB1AKSMm3bfNfef6--

