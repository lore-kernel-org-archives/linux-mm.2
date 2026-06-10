Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04ADACD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC95C6B0005; Wed, 10 Jun 2026 09:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0386B0088; Wed, 10 Jun 2026 09:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD7E6B008A; Wed, 10 Jun 2026 09:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B08D46B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:46:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57C92160A63
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:46:42 +0000 (UTC)
X-FDA: 84864128244.24.E2B181F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B925C180011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:46:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AT2sqzeU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dx7hXdKX9Rs91i5RbhQqTgzv69QIz47hIR3AMiwNNYk=;
	b=A+ulJ7uWPSXEo+LDLo3yMt2/7rPvs4uuZeDiq/ZGHoWyor/So5Mruuhq4geqyMbyHhZ0cg
	qjgcDQt+0udaidiC7JVPMMqM9cjl226wYiD31OJK8UpdIl2+P3Y4AciTuuWB5TPNaCFv+h
	6V11Ieia5kffgoVzZvtDqQ66xR1ERIQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AT2sqzeU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099200;
	b=Jj+9/0YgPdo4Iu3u16sMYHWLOplRTFeZ/B0GLndxyV2VwVqokPUeghUz7QJnwDFX9wUbuw
	4aGqGIuDq06ANrX6lMQ+MRbs057pfakpodMqkBYHmsIl3alACgrm6QqoJ2BwCEWu2Kv3HI
	SzwEWQCCSHdCz/9Od344BPmT7fM0MxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13EDB600AB;
	Wed, 10 Jun 2026 13:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BC01F00893;
	Wed, 10 Jun 2026 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099199;
	bh=Dx7hXdKX9Rs91i5RbhQqTgzv69QIz47hIR3AMiwNNYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AT2sqzeUgrZugH1av7dSs7GGim6/jj1LiPhEhXaf2gbGcy+RAkn0wipLKagXx/Y8x
	 zd/G3vT0sch7uSZNcp5H19u7VrxHEGijOpl19p0kY38YjzG1mbaw6JuujBmWS8Wxkz
	 500EyCB/X4kdFOM6aQQkegwD8pL4LobgyW8/gHCIBMIWRzrnoNLI7n3JIjVdzsqLhy
	 qRSdT/dCWsTUkHiBpfUCDH0SjH2RC72N8fD3VhBceMCQGsnzmmldyfooAhOjA0rVuI
	 hNrPlO/rpwexNJ+BROCvROptHgC9XcgCKAvo2pXVtrqUFEHqIddlp3HxqRI4N9mXre
	 Owi9K3ADa8RZg==
Message-ID: <e650e125-5f6c-4de7-88b5-9da666bb0a4e@kernel.org>
Date: Wed, 10 Jun 2026 22:46:33 +0900
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
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lpBhgsI7Eg8uAMph6eYAI8CI"
X-Rspamd-Queue-Id: B925C180011
X-Rspam-User: 
X-Stat-Signature: 7mu4875uaw5fc3mjke1tjnstrje3m8sm
X-Rspamd-Server: rspam09
X-HE-Tag: 1781099200-852075
X-HE-Meta: U2FsdGVkX18dfp49o8K8Ogp3Pdk6ZhhaQ1hk7zh83dH6X+7v0XUsAyKnFp6d8inmEvMMTI+NjafpiVT/qa3zqexxVrY/+OJZlpJbWYXCw5JJsGjIPYvsHGSD+k36LVpT9Q3hpQ5R35bNX1X9Rj/0glS8TbpPGnauR7uiWanhkN10FAthLrrHTfCoZ2B1W96HknX8Xnr9fUArDRpxP5x+cRtHOyC97UhIpJzyXxm0Mmnq5R9L+b0ianU0cLvILerZwNtdPD4x5K/hUnjPvuB61F+GYC24Kyyw/n8gIaZu6gKmH0HQ1ERpKgRY9YtoRRfm0DhhvW3wg+2XtFqz9sadFqmVjBcEuUQU1xP9XV6I2GoK9nzMA/01MJXabzQMQTTzANgXeZgBjH7KL24NMzsd644H00Qj8Aq0EiwPnccJ9AhKxZoxOSB0inFnOxieGuq2rfyr/mCh8DEuVf/bGXvr0fZtAp9H0oaV+Gj7Xm2wwCHfdhSwFws5L2zQRkqFk9fLG+3U118FX40Nyx7hihSpE/+NE+hU70unp733ECzZ8Hk8Xrpr3iVHw4qGLxljNqyle8C4x1iVQQotOOBIj3kbiAmU7VkNUflVQqvzsrEwR4XnbMWnWUGOXHDmiy70F+snPOC+ga3301TxWJP6hWdprwdK+jj9Fhry89JKmCtSDvL+UtvU2TNSit6TVF/D58VC0Ngi39C9VsipEZ8qsFoJf+/wL3ldvEnA7AyQ8bCh9a4x2ZUOKp0MQccpYqsVVn3sHNLcOFuDT0HLCENJTHc+wg7zqo3RJUIv/sUNUoYyE+speaPBfVs/2f77z21WtIxUZy2XunrQ2lghY+dA+WWHqelwdlQ05lbryoB49uk8MByJbE4ZA0xDyJxhp3OudXScFr+FHvRP+faTBoR5U5U9urvVvNcxIuH/3yG6lazV4g2zLsDGLVQutEI6z72tpKEwg5T18SjaQcVE233Et+N
 pb1CUafe
 bChe38MG2o4oXlAVYWMRBc5FBwnnS+se8PZFv/UesYpiKz/mc6nao+oVhF7fer/GWujl6Dx7KPYTwkpZ1yfpSOu/jEQSD160j38W85aCdwR5aDo5HqvkQ17BOvYHqensWqt6IY6absQglq+syN4ytGhKAO1z0wh/1sDc7ve1UUUFk6h3tM6QiqL8v3hz+V9jk67zF+rCMWQBszfAUKMmwjUojYOqpXO3NzvBRP1GaI0KbA6UCQb3m4BBtMp4qEwGCtZideUDRm0n8SWqZLvkYo+Le9ce+1RUM4O4HA8+mlEQBQZUbtPxuU8+5WZmBDNPuQVFDudVLJZ72374rCnJAB2lC/+jdXDir471DEM94/3c4BwkPj+2Fjet1yfUIysIXON4z3SdCAm33WBhr4Qi5PtgB5ELAWj1vnFuxZNzpbTx5AN2ucOT0FRNvmkwlsjqTqGh/VjhdAfz6KS5LsSqjp5KIUCLfX75tUxxgfiiH5rr/6NOtL0mF2YaRTxcWAOYoGCZUgqJ/P7FOMTATlsWe5DnKwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lpBhgsI7Eg8uAMph6eYAI8CI
Content-Type: multipart/mixed; boundary="------------imhDaDuV79w9s0j1YWemz0d0";
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
Message-ID: <e650e125-5f6c-4de7-88b5-9da666bb0a4e@kernel.org>
Subject: Re: [PATCH RFC 00/15] mm/slab: introduce alloc_flags and
 slab_alloc_context
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>

--------------imhDaDuV79w9s0j1YWemz0d0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/9/26 6:17 PM, Vlastimil Babka (SUSE) wrote:
> This series is based on slab/for-next. If all goes well, it would
> hopefully go to slab/for-next soon after the 7.2 merge window, so any
> other work can be based on it to avoid conflicts, as it touches a lot
> parts of slab.
>=20
> Git: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/l=
og/?h=3Db4/slab_alloc_flags
>=20
> The slab implementation currently relies on gfp flags to convey
> some context information internally:
>=20
> - The absence of both __GFP_RECLAIM flags is interpreted as "cannot spi=
n
>   on locks", and intended to be used by kmalloc_nolock(). But false
>   positives are possible e.g. during early boot where gfp_allowed_mask
>   clears __GFP_RECLAIM from all allocations. This leads to unnecessary
>   allocation failures and workarounds such as fd3634312a04 ("debugobjec=
t:
>   Make it work with deferred page initialization - again").
>=20
> - __GFP_NO_OBJ_EXT exists and takes up valuable bit in the gfp flags
>   space, only to prevent recursive kmalloc() allocations for obj_ext
>   arrays and sheaves.

[ Cc'ing Vishal and Matthew as it's somewhat relevant to memdescs... ]

When the page allocator starts allocateing slab objects,
we still need a way to avoid recursion for obj_ext arrays and sheaves
(by passing SLAB_ALLOC_NO_RECURSE).

Looking at kmalloc_flags(), probably we'll end up introducing a separate
gfp type for slab-specific flags?

Hmm but SLAB_ALLOC_* flags are defined in mm/slab.h and kmalloc_flags()
is defined in include/linux/slab.h. Do yo intend to restrict the slab
alloc flags to MM only?

> The page allocator uses its internal alloc_flags to convey various
> context information, including ALLOC_TRYLOCK (meaning "cannot spin").
> This series copies that concept for the slab allocator, with its own
> slab-specific internal flags:
>=20
> - SLAB_ALLOC_DEFAULT - no extra flags (the value is 0), but explicit
> - SLAB_ALLOC_TRYLOCK - do not spin on locks (used by kmalloc_nolock())
> - SLAB_ALLOC_NEW_SLAB - replacing existing 'bool new_slab' parameter
> 			for allocating obj_ext arrays
> - SLAB_ALLOC_NO_RECURSE - replacing usage of __GFP_NO_OBJ_EXT
>=20
> To reduce the amount of parameters in various internal functions, we
> additionally introduce slab_alloc_context (also inspired by page
> allocator's alloc_context) for passing a number of existing arguments
> and the new alloc_flags:
>=20
> /* Structure holding extra parameters for slab allocations */
> struct slab_alloc_context {
> 	unsigned long caller_addr;
> 	unsigned long orig_size;
> 	unsigned int alloc_flags;
> 	struct list_lru *lru;
> };

Perhaps beyond the scope of the patchset, but I wonder if we could have
something like struct slab_alloc_context but for kmalloc callers to
simplify {PASS,DECL}_KMALLOC_PARAMS().

Something like:

struct kmalloc_params {
#ifdef CONFIG_SLAB_BUCKETS
	kmem_buckets *b;
#endif
#ifdef CONFIG_KMALLOC_PARTITION_CACHES
	kmalloc_token_t token;
#endif
};

The idea is to move optional kmalloc parameters (depending on config)
into a single struct, instead of using the macros.

void *__kmalloc_node(size_t size, gfp_t flags, int node,
		     unsigned long caller,
		     struct kmalloc_params params);

void *kmalloc_node() {
    /* ... snip ...*/
    struct kmalloc_params params =3D KMALLOC_PARAMS(params.b, params.toke=
n);
    return __kmalloc_node(size, flags, node, _RET_IP_, params);
}

The compiler should optimize away unused fields based on the config.

Per System V AMD64 ABI, the compiler will use registers to pass the
struct, as long as the struct size does not exceed 16 bytes.
(Otherwise it will be passed on stack).

> This also replaces the existing struct partial_context.
>=20
> The last necessary piece is kmalloc_flags() which can take the
> alloc_flags in addition to gfp flags and is intended for the recursive
> allocations of sheaves and obj_ext arrays, so that both
> SLAB_ALLOC_TRYLOCK and SLAB_ALLOC_NO_RECURSE can be communicated.
> Internally it decides between kmalloc_nolock() and normal kmalloc()
> depending SLAB_ALLOC_TRYLOCK.
>=20
> The rest of the series is gradually expanding the usage of both
> alloc_flags and slab_alloc_context as necessary, with bits of
> refactoring. Then, __GFP_NO_OBJ_EXT is removed completely.
>=20
> Note that some usage of gfpflags_allow_spinning() relying on absence of=

> __GFP_RECLAIM remains outside of slab (and page allocator) in memcg,
> page_owner and stackdepot code. These can thus yield false-positive
> decisions that spinning is not allowed, but should not result in
> important allocations failing anymore.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Vlastimil Babka (SUSE) (15):
>       mm/slab: always zero only requested size on alloc
>       mm/slab: stop inlining __slab_alloc_node()
>       mm/slab: introduce slab_alloc_context
>       mm/slab: introduce alloc_flags and SLAB_ALLOC_TRYLOCK
>       mm/slab: add alloc_flags to slab_alloc_context
>       mm/slab: replace struct partial_context with slab_alloc_context
>       mm/slab: pass alloc_flags to new slab allocation
>       mm/slab: pass alloc_flags through slab_post_alloc_hook() chain
>       mm/slab: replace slab_alloc_node() parameters with slab_alloc_con=
text
>       mm/slab: allow kmem_cache_alloc_bulk() with any gfp flags
>       mm/slab: pass slab_alloc_context to __do_kmalloc_node()
>       mm/slab: introduce kmalloc_flags()
>       mm/slab: remove __GFP_NO_OBJ_EXT usage from alloc_slab_obj_exts()=

>       mm/slab: replace __GFP_NO_OBJ_EXT with SLAB_ALLOC_NO_RECURSE for =
sheaves
>       mm: remove the __GFP_NO_OBJ_EXT flag
>=20
>  include/linux/gfp_types.h       |   7 -
>  include/linux/slab.h            |  14 +-
>  include/trace/events/mmflags.h  |  10 +-
>  lib/alloc_tag.c                 |   2 +-
>  mm/kfence/core.c                |   6 +-
>  mm/memcontrol.c                 |   5 +-
>  mm/slab.h                       |  16 +-
>  mm/slub.c                       | 423 ++++++++++++++++++++++++--------=
--------
>  tools/include/linux/gfp_types.h |   7 -
>  9 files changed, 288 insertions(+), 202 deletions(-)
> ---
> base-commit: 500b2c9755301742bdbb61249511ac11a4665dae
> change-id: 20260601-slab_alloc_flags-25c782b0c57c
>=20
> Best regards,
> -- =20
> Vlastimil Babka (SUSE) <vbabka@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------imhDaDuV79w9s0j1YWemz0d0--

--------------lpBhgsI7Eg8uAMph6eYAI8CI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCailquQAKCRCGXBN6rc5S
1ovPAP9O4mfAo+3btjvBHirmJAKKcqibQgDAmFz8xIhGk8mJLgD9HdM/6HoUvsSE
ZVA9uxJ1/1v9GB9cp0SmNatJJZKFWwA=
=DeYn
-----END PGP SIGNATURE-----

--------------lpBhgsI7Eg8uAMph6eYAI8CI--

