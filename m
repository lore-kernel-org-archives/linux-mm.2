Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9559EF36BA4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 03:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFADB6B0005; Thu,  9 Apr 2026 23:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB9D6B0089; Thu,  9 Apr 2026 23:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0B16B008A; Thu,  9 Apr 2026 23:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE1CC6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:08:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC4F2B838A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:08:05 +0000 (UTC)
X-FDA: 84641162130.16.3799EB4
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4D00C20008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:08:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hcos8igs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775790484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UB14TpvH+wdBdvN5Rz/r4yIdPzKNG5cYRBgIcKHvz00=;
	b=JKK83hH/7XZCS5fubV9rMDauTn8pn5/EgYqOg6FzU97fCPs0ZnFiu6mQvF120Qgy8XS82t
	5z4fR1emn+XK6/dTM4U3p24YN+JqQR9ZekrHRqxu/a3JLPIsXEVBD700TMPjKHEzkJpn3Q
	IudBL12P4l+qYjjUW8eANx2Eif2x97E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775790484; a=rsa-sha256;
	cv=none;
	b=lCB8ZrUhygmMH6XwP2p3DSob7dNln5+mINqkQvmt8yxL6MZ/NP1bD38YMjYqpi3NcBrZcR
	LNN0asyh+ZoE5L5wnuT+zjWY2YUl090DrgQXL3dQKIlkAxRgcGkM7lqq67oKYX3L/SY15G
	8eeCrf9B8qMVV109sFncupHLO3UC880=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hcos8igs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775790480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UB14TpvH+wdBdvN5Rz/r4yIdPzKNG5cYRBgIcKHvz00=;
	b=Hcos8igsEf2YlonhWWBpoVgZxButTf3+1qNZdzSeV/B7LqiLUZgGmViPvJoNBXHwD7jkM1
	b4awj4beCI/zjqe9HGCZk0FQSPEA0FEa6c+KnA2hWRUotgaUb4hmPt9kcp6CsLZ+GV/r96
	5ZQQyU0fHqVOh7Qy7x33io6fxIETBto=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [RFC PATCH] mm/sparse: remove sparse_buffer
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <adfBVc8ohLrtIe3j@kernel.org>
Date: Fri, 10 Apr 2026 11:07:21 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 yinghai@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD30B00B-76F4-4984-9B29-9668896E761F@linux.dev>
References: <20260407083951.2823915-1-songmuchun@bytedance.com>
 <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
 <70EF8E41-31A2-4B43-BABE-7218FD5F7271@linux.dev>
 <dcc3b56f-5d4c-4bb0-bfd8-49747df30f47@kernel.org>
 <adfBVc8ohLrtIe3j@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4D00C20008
X-Stat-Signature: 5i7ixpnth9xcixh6xagkym4fnk6d6exg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775790482-578879
X-HE-Meta: U2FsdGVkX18bN27n2WJxn8ZXy111JaVgV46OUsWjpckntFQtCtM7OIq71RinhkX5wNfC1U+vtXjDidRpqzl40nGQ6SvxI9sbaPqoteTDLq8OknXNCZ0va7i9F6IVnNXCJAMl6CyeBYgd8negJH0Jwkq+c9Z5vXHl0dvkvnu69eSswigyB74+iyuo2+/j5EzfIy6jQrn2nyhNTgRGZTfrVLWh2gzjPYdxLPjd1EoG0cnxiC2/UlG7ZR/H6gJEwia+WBicOzcr4YisW2sjuzGfuqF2nt9llss5xYrBrj4s27qZqI5PAGQ5zm90lX507KpZXKe+FxXzr3szZ10EXafH0/6g21WNam2KGElDRK8Y1vNww3RJ/XiKTiXFnj/zwBn+6o9oQ/BgRjMckMKhUkqFFM0fqCCcV9k4Blmk+fpXe7HrnxZlBmP8BjTzqi4eZLnyXzO1+etcaeysneNbt62/awWM6WTnkOZhpeCw3JRIPcEh4vk+6HH+4NXkPXJL1pt+quwYFrsdoLNHWLrkSPmdRq0pKO2wUSkRSOF71Y+gt7p+ZCr68FXe+SpyuKlTLMz2S0x8oAeTj+PLKLLCU1KZCBpd/l33IMIPRrYbyfCoLlul0FWV3ZFJE2/sGDhunu7zoF5rgi5CEKmIF72r7/e2R2GsTMRl3stmX9zv/dXVtildzMhwx4qI3FvniRJz0mDFOHCGoOV2GdXrWGu3c25a5G8M33/5wZkA9evqUQEnQspo3EKEh/WWvHa9/GP9URD8O761GRbq5d2hlQa6SLmLZLW0WOsQLym3t/z8JkkHWjyhSqryi7bHrsg0LWoVgM5Hh/wxECVlMWmLDmxHUtvKSH56B2hrsEmEFjl39y5rFAoWUgE7R7mJZ0f8stkty0tB3iX42iMkJ4tdBgtekx0LHVUxgiPET66Sw8Rme7WzG9z/hU1Wf4FIpPmoUkTOJEm4K2VZcWEHAK1Y3Znehj4
 NeMYbcxO
 6eDtqd8zEi3XDKsN3JsQc9KRins9SxPMx7POTTOfSyRNql7eP4oeQ8SzYP9Xw5dyTx4EIgT5Kq0GkkiSLX/X3x4fCvIUqEdWDDxLg7En6SuKCsgtCOWWUgRCaiS2kbpeUXaG/2CKs3hWNbviYFJgZIgFMLOkOyZYYnerW6ImeTRonv26h6SIW+b8EDGlEqSnIzdl3hvmPMk0AnlzD3/BSICdY+djQZKjYVgwiMbMMglHzrg6ozpck8CSyPzegN1tvA6o/+Hvj5qGkhZnnFkTLsQrCKsi28nKYNagF3tR+7VUVMKXM13FOjy3ytw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 9, 2026, at 23:10, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi,
>=20
> On Thu, Apr 09, 2026 at 02:29:38PM +0200, David Hildenbrand (Arm) =
wrote:
>> On 4/9/26 13:40, Muchun Song wrote:
>>>=20
>>>=20
>>>> On Apr 8, 2026, at 21:40, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>>>>=20
>>>> On 4/7/26 10:39, Muchun Song wrote:
>>>>> The sparse_buffer was originally introduced in commit 9bdac9142407
>>>>> ("sparsemem: Put mem map for one node together.") to allocate a
>>>>> contiguous block of memory for all memmaps of a NUMA node.
>>>>>=20
>>>>> However, the original commit message did not clearly state the =
actual
>>>>> benefits or the necessity of keeping all memmap areas strictly
>>>>> contiguous for a given node.
>>>>=20
>>>> We don't want the memmap to be scattered around, given that it is =
one of
>>>> the biggest allocations during boot.
>>>>=20
>>>> It's related to not turning too many memory blocks/sections
>>>> un-offlinable I think.
>>>>=20
>>>> I always imagined that memblock would still keep these allocations =
close
>>>> to each other. Can you verify if that is indeed true?
>>>=20
>>> You raised a very interesting point about whether memblock keeps
>>> these allocations close to each other. I've done a thorough test
>>> on a 16GB VM by printing the actual physical allocations.
>=20
> memblock always allocates in order, so if there are no other memblock
> allocations between the calls to memmap_alloc(), all these allocations =
will
> be together and they all will be coalesced to a single region in
> memblock.reserved.
>=20
>>> I enabled the existing debug logs in arch/x86/mm/init_64.c to
>>> trace the vmemmap_set_pmd allocations. Here is what really happens:
>>>=20
>>> When using vmemmap_alloc_block without sparse_buffer, the
>>> memblock allocator allocates 2MB chunks. Because memblock
>>> allocates top-down by default, the physical allocations look
>>> like this:
>>>=20
>>> [ffe6475cc0000000-ffe6475cc01fffff] PMD -> =
[ff3cb082bfc00000-ff3cb082bfdfffff] on node 0
>>> [ffe6475cc0200000-ffe6475cc03fffff] PMD -> =
[ff3cb082bfa00000-ff3cb082bfbfffff] on node 0
>>> [ffe6475cc0400000-ffe6475cc05fffff] PMD -> =
[ff3cb082bf800000-ff3cb082bf9fffff] on node 0
>=20
> ...
>=20
>>> Notice that the physical chunks are strictly adjacent to each
>>> other, but in descending order!
>>>=20
>>> So, they are NOT "scattered around" the whole node randomly.
>>> Instead, they are packed densely back-to-back in a single
>>> contiguous physical range (just mapped top-down in 2MB pieces).
>>>=20
>>> Because they are packed tightly together within the same
>>> contiguous physical memory range, they will at most consume or
>>> pollute the exact same number of memory blocks as a single
>>> contiguous allocation (like sparse_buffer did). Therefore, this
>>> will NOT turn additional memory blocks/sections into an
>>> "un-offlinable" state.
>>>=20
>>> It seems we can safely remove the sparse buffer preallocation
>>> mechanism, don't you think?
>>=20
>> Yes, what I suspected. Is there a performance implication when doing
>> many individual memmap_alloc(), for example, on a larger system with
>> many sections?
>=20
> memmap_alloc() will be slower than sparse_buffer_alloc(), allocating =
from
> memblock is more involved that sparse_buffer_alloc(), but without
> measurements it's hard to tell how much it'll affect overall =
sparse_init().

I ran a test on a 256GB VM, and the results are as follows:

	With patch:    741,292 ns
	Without patch: 199,555 ns

The performance is approximately 3.7x slower with the patch applied.

Thanks,
Muchun

>=20
>> --=20
>> Cheers,
>>=20
>> David
>=20
> --=20
> Sincerely yours,
> Mike.



