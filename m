Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1077DCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5516B0088; Wed, 10 Jun 2026 11:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A59B6B0093; Wed, 10 Jun 2026 11:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC2A6B0096; Wed, 10 Jun 2026 11:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB0B26B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:04:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B1F112016A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:04:33 +0000 (UTC)
X-FDA: 84864324426.08.9CB45E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 498561C0013
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:04:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvId1BCG;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781103871;
	b=IP7ayn/sIBZVgcAqPe64H4r4koQ5MgdtrG+AmRh0cNZr26qvTewADLSqcGyjJAQn6KWeIG
	KCD0jYAR9Q6xn34EugorfEhoUGLG8X7DvmL9C3wHHsKszLo6l3++2XgYmwaWYwuEFHW5qM
	FS3s0Z3ZAsHBcqWQ8lmVlkv5kabo+DQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvId1BCG;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781103871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqQ2MsiuNikXhJ97L9YlCS1PYnOleFH1f5mUL5vq1EA=;
	b=OAUk0L4ly+iMOzz6UpUC0bzsIE9lCQzQzr57gXAF1I1MCd1xpOsa2fQXl17qDoYXS1MMk8
	GiPnsdLNt+/x+BrKTTqcSgjRwIZnyAwWX7dlaKRQVaeS+DbI8pvyPzDsdsAFrmQefncU/P
	4kcOKe6l2E/UPFSFrSQSPZ11nXPDUKU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E93C43AF3;
	Wed, 10 Jun 2026 15:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730151F00893;
	Wed, 10 Jun 2026 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781103870;
	bh=bqQ2MsiuNikXhJ97L9YlCS1PYnOleFH1f5mUL5vq1EA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BvId1BCGPSToIBbE1L5b8Dn2qSkmq5lOlBrZk4c2rj4KIDlmMfMsVpugk8LRgk3ue
	 SMYk9DRM2wxdMbN8yNc616ye6N7tbzCijrvfl99chFsGQfOgt+wTKZ2mv/B1jjXLay
	 IF9zMSxV+ro0mPcL89jVsT9WHltYvwKVcfUiOMNllu6W3/jG0XZAj1Y/28Jy0NagIJ
	 h8+7OwcAaq86orIL7myxUPCOfXZWf0G4cwAU6AC3KcOD8/Bw7ksZHPIXqoAM044OZV
	 V0qU8rEzdFgA8NCPO9gv8S2Ih/EAfEchoesd7oWKQfD510H+dDupPCw0IWTw3G2tAt
	 /ymjvyHYSoDyg==
Message-ID: <e42ed4e2-c0ba-4b36-b1a5-090a5afa762d@kernel.org>
Date: Thu, 11 Jun 2026 00:04:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/15] mm/slab: introduce alloc_flags and
 slab_alloc_context
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
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
 <e650e125-5f6c-4de7-88b5-9da666bb0a4e@kernel.org>
 <0b9dce0f-f2a8-4b52-9c06-600eb13d4a7c@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <0b9dce0f-f2a8-4b52-9c06-600eb13d4a7c@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------EdfxVfiruOiCQ0OSxtJqjQYZ"
X-Rspamd-Queue-Id: 498561C0013
X-Stat-Signature: m1fw7qiqstq9z5gifcig3gdsfbf7aqrh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781103871-534849
X-HE-Meta: U2FsdGVkX19axxKAxnCoRHP5IMkoMLKwxwAH8sfL3xBvE2DBwMcVoJgxh0ix54uhZlYqUrcFmxXdXCJpG8+DVNL6EIzmSNA76NuLJRSiShg90CLR+FdMHgs9imXwDMQDCHewO+jupeO88KwQkzPesBVLCPEP3V7+QdmJv5FXH72W+CN8DZ1Ob1+SxdrUZIY7brFlv0kuFQ4N/VcUnM1JZW3LXiCC9piN/4ET5dziddDLdXUHFfH7JKkG99EBy+Uc8MxEnpS1RVhmTgM5YMKkcO/5FxnLYTpLlymEWXfXXt4sB9l0O9rk6OB8yNjDyWcuSCb6/u7F1ptP0bXNZJ6aW+KepM6Mjwal0nEodRHDWjaW5bd+hRqahRAF7gaEJx3vzl6jS9qs8j/HuRo6wOxAPGDQm4tXCfgNaMiV1ChjwoFKhVqMJVEEGhlCg9UkSCKSkn8l5dxV1zmdm7anxULk1i5mBuP8y+8yqaoUbCtMNU7QoLyr0kykm46igHOZO44sSx0VH5hG6D+6tBqKm1J1v2cKZH/vneqETAUQgTdKsHebLbf9Ff33IhPZ3ORLBEm12XYCOnqnLmH57eWCaCXz+dKVA3l7apPmuzZ0uIccJa4TlJiygxkjiCqY6jckuJO3KZQqGP12d5XpXj6DS59YbackPjyahf/NpVoj7WMtYZOaqbM8BZorwNbfkJI6pvRFeynxxydv2F0W+AwgyPcIU/ZC7zMqxirhFtyORwP0MKiIGZTMNALGLR9cHjSQprRWeET55F7pibmE+ZwVbRh9lJD0IJwW20iO4gPAhO9KlTUHafHtkM2d/0EgbrUf8Ccm1rpnrM3It8vhc6io8UJprbA8xIS0KIuz4o7mospQkLk35M/mqcc61kHqoXhMTYdAMAarlxUp0BWU3kjCrLENeAJ0rJlGhQMjxCN6HTLrBd/UhIsQvtAfVDWKps4qZ2Zq1XA2bAcCWkArMlM8T73
 MSV89kVt
 eDibG1HB7V9AI+dYOxm/nUuvtvriiFR/Z4MF/uWTsKbqsNPP3mhIpqrBPgEJnZXTWJMIkXVn/Cht8FuI8GSpsDxwO+pt9404JWeyirqS/BKfY1MryGUpxRhAhLskLPQ6X6wxGwpjZ0PKDkClofcoGG1cuGxLSJnxToc1wQC4RaCPOYCXVaHsqu5O1Fat6bf8RLJlpdzwye0BaEAVs5A4SHF5121ItGbIuqX6LV0zYaHpmJg434VLnDgFIaNziWhH7FZVhJhBaZmofOcOsb2sEFtHtUlIvu/8f2xpMg0L+RVz8kicmUAnz/MCrLHb5paXRr240GsOdzxpY8NN4cu0aCZOu3iGd3Fn/aWBYQac/WKmrvUSP/LFiY3SfqMPeHWPJ2W1QOky2YWNfJaf9HOg299BrnQ95GRLzx/5Pvsyoidznl32GyFmFGcnu+EG0Y6xmAAKPPhbnrNhagSjXoZQU3pLHw1djhGwXLMRdLDeCL5z5buvFAEuqRe5A613hmT7lQMjPEUi2ZIsFVpQVcYp3l+ntM4SHhujI3EIXcX6HTk8QCMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------EdfxVfiruOiCQ0OSxtJqjQYZ
Content-Type: multipart/mixed; boundary="------------AxdjQdvvIQrAARW40azyu6pE";
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
Message-ID: <e42ed4e2-c0ba-4b36-b1a5-090a5afa762d@kernel.org>
Subject: Re: [PATCH RFC 00/15] mm/slab: introduce alloc_flags and
 slab_alloc_context
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
 <e650e125-5f6c-4de7-88b5-9da666bb0a4e@kernel.org>
 <0b9dce0f-f2a8-4b52-9c06-600eb13d4a7c@kernel.org>
In-Reply-To: <0b9dce0f-f2a8-4b52-9c06-600eb13d4a7c@kernel.org>

--------------AxdjQdvvIQrAARW40azyu6pE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/10/26 11:04 PM, Vlastimil Babka (SUSE) wrote:
> On 6/10/26 15:46, Harry Yoo wrote:
>>
>>
>> On 6/9/26 6:17 PM, Vlastimil Babka (SUSE) wrote:
>>> This series is based on slab/for-next. If all goes well, it would
>>> hopefully go to slab/for-next soon after the 7.2 merge window, so any=

>>> other work can be based on it to avoid conflicts, as it touches a lot=

>>> parts of slab.
>>>
>>> Git: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git=
/log/?h=3Db4/slab_alloc_flags
>>>
>>> The slab implementation currently relies on gfp flags to convey
>>> some context information internally:
>>>
>>> - The absence of both __GFP_RECLAIM flags is interpreted as "cannot s=
pin
>>>   on locks", and intended to be used by kmalloc_nolock(). But false
>>>   positives are possible e.g. during early boot where gfp_allowed_mas=
k
>>>   clears __GFP_RECLAIM from all allocations. This leads to unnecessar=
y
>>>   allocation failures and workarounds such as fd3634312a04 ("debugobj=
ect:
>>>   Make it work with deferred page initialization - again").
>>>
>>> - __GFP_NO_OBJ_EXT exists and takes up valuable bit in the gfp flags
>>>   space, only to prevent recursive kmalloc() allocations for obj_ext
>>>   arrays and sheaves.
>>
>> [ Cc'ing Vishal and Matthew as it's somewhat relevant to memdescs... ]=

>>
>> When the page allocator starts allocateing slab objects,
>> we still need a way to avoid recursion for obj_ext arrays and sheaves
>> (by passing SLAB_ALLOC_NO_RECURSE).
>>
>> Looking at kmalloc_flags(), probably we'll end up introducing a separa=
te
>> gfp type for slab-specific flags?
>=20
> What do you mean by separate gfp type?

I meant the patchset is introducing a new type to specify the context
(specific to slab) other than gfp_t... which is `unsigned int
alloc_flags` now.

>> Hmm but SLAB_ALLOC_* flags are defined in mm/slab.h and kmalloc_flags(=
)
>> is defined in include/linux/slab.h. Do yo intend to restrict the slab
>> alloc flags to MM only?
>=20
> Yeah I don't expect users outside MM. If a valid one appears, we can mo=
ve
> it. I should try moving kmalloc_flags() to mm/slab.h as well, unless th=
ere's
> some header dependency issue that will prevent it.

Ack.

>>> The page allocator uses its internal alloc_flags to convey various
>>> context information, including ALLOC_TRYLOCK (meaning "cannot spin").=

>>> This series copies that concept for the slab allocator, with its own
>>> slab-specific internal flags:
>>>
>>> - SLAB_ALLOC_DEFAULT - no extra flags (the value is 0), but explicit
>>> - SLAB_ALLOC_TRYLOCK - do not spin on locks (used by kmalloc_nolock()=
)
>>> - SLAB_ALLOC_NEW_SLAB - replacing existing 'bool new_slab' parameter
>>> 			for allocating obj_ext arrays
>>> - SLAB_ALLOC_NO_RECURSE - replacing usage of __GFP_NO_OBJ_EXT
>>>
>>> To reduce the amount of parameters in various internal functions, we
>>> additionally introduce slab_alloc_context (also inspired by page
>>> allocator's alloc_context) for passing a number of existing arguments=

>>> and the new alloc_flags:
>>>
>>> /* Structure holding extra parameters for slab allocations */
>>> struct slab_alloc_context {
>>> 	unsigned long caller_addr;
>>> 	unsigned long orig_size;
>>> 	unsigned int alloc_flags;
>>> 	struct list_lru *lru;
>>> };
>>
>> Perhaps beyond the scope of the patchset, but I wonder if we could hav=
e
>> something like struct slab_alloc_context but for kmalloc callers to
>> simplify {PASS,DECL}_KMALLOC_PARAMS().
>>
>> Something like:
>>
>> struct kmalloc_params {
>> #ifdef CONFIG_SLAB_BUCKETS
>> 	kmem_buckets *b;
>> #endif
>> #ifdef CONFIG_KMALLOC_PARTITION_CACHES
>> 	kmalloc_token_t token;
>> #endif
>> };
>>
>> The idea is to move optional kmalloc parameters (depending on config)
>> into a single struct, instead of using the macros.
>>
>> void *__kmalloc_node(size_t size, gfp_t flags, int node,
>> 		     unsigned long caller,
>> 		     struct kmalloc_params params);
>>
>> void *kmalloc_node() {
>>     /* ... snip ...*/
>>     struct kmalloc_params params =3D KMALLOC_PARAMS(params.b, params.t=
oken);
>>     return __kmalloc_node(size, flags, node, _RET_IP_, params);
>> }
>>
>> The compiler should optimize away unused fields based on the config.
>>
>> Per System V AMD64 ABI, the compiler will use registers to pass the
>> struct, as long as the struct size does not exceed 16 bytes.
>> (Otherwise it will be passed on stack).
>=20
> Hm but does this work on all architectures,

apparently not on s390, unfortunately.
on s390 it works only when the struct size does not exceed 8 bytes.

> and are we doing this somewhere
> (for structures larger than a native word) already?

hmm perhaps struct timespec64?

> Also Marco noted earlier that gcc won't optimize away the struct if it
> becomes zero-sized:
>=20
> https://lore.kernel.org/all/CANpmjNO1aNm3mKphDGWasK_NUfVY8q4K9GCjyREZFq=
rOu9WLcw@mail.gmail.com/

Ouch, right. That means we still need at least one macro to define those
parameters :( Sounds less promising now...

--=20
Cheers,
Harry / Hyeonggon

--------------AxdjQdvvIQrAARW40azyu6pE--

--------------EdfxVfiruOiCQ0OSxtJqjQYZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCail8+AAKCRCGXBN6rc5S
1vHhAPwM06JdORhjTWRz+j2VmPKc0qPB2Et4CjeqHvgbP5SzsQEA9Qqx4so7C+dr
cBqCUZWqtyYkj1WQZSAHv2HY82G+OwA=
=Wshr
-----END PGP SIGNATURE-----

--------------EdfxVfiruOiCQ0OSxtJqjQYZ--

