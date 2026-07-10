Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01588C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21656B008A; Fri, 10 Jul 2026 09:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9726B008C; Fri, 10 Jul 2026 09:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CFB6B0092; Fri, 10 Jul 2026 09:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62E6D6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:45:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5C5D140464
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:44:59 +0000 (UTC)
X-FDA: 84972987918.09.B5D6B25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 32BD112000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:44:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KkAw23W7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49fCPTKiQXDe2vBs0aeAafBEApIHMn5/z21njXFh8z8=;
	b=MEDl/cV1Ju26vl1GUx8Aj5BDF0GGp5nh+BmoNUoTJI2CsYoEmuhMNhdKxfk1LD2gepId49
	ZmEQMXHtUBAn1UpES0oPzFohr1pX5QwOAwwecgt4j7pzSlhaWh2gllqf5rAWV/QdIekF5O
	VeP8GqlyPH475lyfXi3WOyB12N7asXs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KkAw23W7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691098;
	b=1eEzVQOzWrpihDpaUvcBDvlmJ6tubrUM/WaAz85K/3JCcxBjhrOgphXxKFdl4d4XyPiTML
	4n2738DH8ra5cgGEj7dAmeNAIOLhAZWJzryXS4mLY4aPdFH13kp7QC+xRI3Yvu/2g0mz5i
	uTvD4Xerx5kxAJPZWyRrzbTW3IC/oNU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A98D6111A;
	Fri, 10 Jul 2026 13:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B771F000E9;
	Fri, 10 Jul 2026 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691097;
	bh=49fCPTKiQXDe2vBs0aeAafBEApIHMn5/z21njXFh8z8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KkAw23W7nlT9mTj9JF/9M+J1GfAccKBcwwbAuUkOL0hvJ9ZJuOCqhZIpcDobZZP7i
	 YpN89UtshIQU4hKjfSMETYHO3lFJurQpMbuhNc4eZeODRULMu+OwBabnRkJNaJYbIO
	 f8dbmeVhukHVQwmp6ozzHl7wR5/C5GJS9SkHHlH7/oPS+lADBK/BT5GXWtvfpmWNYf
	 AORODajoqKwQyevmJe9EiAfvNEeJO2jG+xQidZFA9xx8JdJ/bfRLaC/Mp0dc7uMXMj
	 sBjRY9NDqD0/R+Q7+aBG00DqETqPmMtpjwFwUAbdbFDI1zCTRL6ihzo3A6afoNIIqq
	 0aQI9hJde/sRg==
Message-ID: <4a5c8eb6-90f4-412a-93bf-21360fce3c7a@kernel.org>
Date: Fri, 10 Jul 2026 22:44:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v2 0/3] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
 <32a056e2-e641-4aaa-887e-586d997feefc@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <32a056e2-e641-4aaa-887e-586d997feefc@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------bh0iCJLSq0YYjqkEhFMD4qVf"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32BD112000D
X-Stat-Signature: 8weye46dotb3yb56cdayx7gpr1esffs1
X-HE-Tag: 1783691098-57290
X-HE-Meta: U2FsdGVkX1+aB7n8wa+4eu/jKqVN4H3fzgFvZpyE2cMnL/CAWUvp4nPusNqUp51rH9pxk10HaQsiVNz6kWlNMszYLrssC3DzaTl10e+wafkQNPJqTNidbyKCafQqjL1jf6NVt7nQnaDOcvwe6Mp9yfHZKYZCOolOkx9B//HYeG5OgRz8Uw0oDN1Nkm0ukcIVYM7LVhOVnQZw93MTC+h4HAdbs6/WC2WqhRXRhi2JaT6C58x2DFwP7WX+0Xe6PKKJ+uVHrWIUe/evF5nnoMhEi/bKuhUUxzYghrzIDMHOknKwQ88NMDSDjZ2G5xemVxccKHEhfP9AAbUZw5vc3Ho5wpCOq8HLtlB9klZDzgMJxv8hdGyXvv9BVBpKOw+OKDVbfSZmA3ICjykfFWcPMHGrilnDUnK5w9vXOpJfGJLfVAbnWKnG8U3+lkMpB+3pmXYSb0JMmjIUHmcMYOc2oht7RGV8NG97yqiVQkq+LpImS2cHpszrnCLjMlM960LG96yhheLpHHkK/1iNg87Eae8DBtMEh1C8c56swu77rg+Axg95eKocHeNm9mqDgDQBtyUSfSClWXut2O3vBGX071wrPD+vRLINKqlYo4QgYElXWeixf/fxNJeNBhM0EoaEhuTf63Zo4AEqXFZE4Sr/11fenDIGcqid7KnIOmFs86Px/NkKvQVpPjuAmw1d1zdXdQOdRwpqkUpD9YTAQqG9IhFiaSDhJq2vqZffOY09s3SD/JEZUOqPh2Z5Ayk9SVgZL+X3w6Fwav7eiDhke+kEiOl+sszxpNdMO6f3g4QKY21+uwitxkFEQnyLB8+j4sSa2f1795YyfEzokKhv6HMxIklsVA5ZFHjlf6OyQIPtUGE6rIIX0jsxtGj9sYemAwtLJ4K5TXkdoFwQ3DUrj2/vhmMZkF+oxN8pW496FgsjED0pL0EtJxkUSe0SAk8AHRkn7MyeoRakKzBnn3Isl3TjKU0
 StQERx1n
 JEFUxyug0QV4wLW2icW/UIfIJFhZgFIIV48t+Jup5+84XwU4QBNQmjMm9ZPnUkWggXsbFtgeN2WCKpwOarldgLJssQZGZt3RH/mIO8fz7EIMEHl9gNeBsgLiKiSQS0HommC3sbyT0YsAx3Gi3QhIGF1dJleGwkbV1PzrcELSPtEqi30HvbLEVC7qz9G5P8Xmi4ixzkOMWJJY3MO6ax+KqNFRVuDhhMIRN6xTghMWBk6pMowldOYadZZAHjqMNS8tIIuDRsLrE7cZwL+gS+LPOAWiNNK1daTWBQVuFJfwzGB2LOTyVdwSFFqfKz6wEUatKBfk7sXerrAY32ELXzm9xSPirrT6JjNCfMjHIp+xF6msJ9B5LUbypkl96U3N6VLJhpw9m0m/BESGuZOeDc00TPKwaINRfyqj7ZNETGDYILiTPdM8Z6eo/XbtrtnRwfGa21yLb26TTPTb1KeVsIdsUh6joGYlHHBuQmGhh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------bh0iCJLSq0YYjqkEhFMD4qVf
Content-Type: multipart/mixed; boundary="------------LHSebdT4vB2ZGMN1riwkJEZQ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <4a5c8eb6-90f4-412a-93bf-21360fce3c7a@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes v2 0/3] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
References: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
 <32a056e2-e641-4aaa-887e-586d997feefc@kernel.org>
In-Reply-To: <32a056e2-e641-4aaa-887e-586d997feefc@kernel.org>

--------------LHSebdT4vB2ZGMN1riwkJEZQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/10/26 10:07 PM, Vlastimil Babka (SUSE) wrote:
> On 7/10/26 08:03, Harry Yoo (Oracle) wrote:
>> This is a follow-up fix after the recent discussion [1].
>> See patch 2 for the detailed description on the bug.
>>
>> Based on slab/for-next-fixes (72bb229f916) and will be soon available
>> at git.kernel.org [2].
>>
>> Instead preventing cycles by bumping up the allocation size of obj_ext=
s
>> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and=

>> disallow formation of cycles between kmalloc types when allocating
>> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
>> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all oth=
er
>> obj_exts arrays are served from normal kmalloc caches.
>=20
> Since we agreed to investigate later whether it makes sense to start
> allocating all obj_ext allocations from the new type, I wonder if for n=
ow we
> should not create them at all if they won't be used - if anything to av=
oid
> polluting slabinfo.

That's fair point!

> AFAIU that means only create them with mem alloc
> profiling is config-enabled and mem_profiling_support =3D=3D true?

assuming mem_profiling_support =3D=3D true means not "never"...

> (Or probably also with SLUB_TINY && MEMCG, as nonsensical as it is...)

I'll instead check "is any kmalloc type w/ higher priority than
KMALLOC_CGROUP aliased with KMALLOC_NORMAL?", which would be

IS_ENABLED(CONFIG_MEMCG) &&
(KMALLOC_DMA =3D=3D KMALLOC_NORMAL || KMALLOC_RECLAIM =3D=3D KMALLOC_NORM=
AL),


--=20
Cheers,
Harry / Hyeonggon


--------------LHSebdT4vB2ZGMN1riwkJEZQ--

--------------bh0iCJLSq0YYjqkEhFMD4qVf
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalD3QwAKCRCGXBN6rc5S
1rBbAP9swMPew8X20cwWuwn1XEQImWWSR2qmMZhLty5iWRZ7oQEA0a/HLzON3ljk
jBI8WgyBFx/efIAV1Ekatq5opFy5Pw4=
=EFDt
-----END PGP SIGNATURE-----

--------------bh0iCJLSq0YYjqkEhFMD4qVf--

