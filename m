Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 635DAF36BAF
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 06:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DBE96B0005; Fri, 10 Apr 2026 02:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D336B0089; Fri, 10 Apr 2026 02:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2F26B008A; Fri, 10 Apr 2026 02:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7F16B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:06:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F8C61403D0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:06:20 +0000 (UTC)
X-FDA: 84641611320.13.B114DED
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 000121C0006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:06:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qvcQTxCw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775801178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvqbrRNQVl8/GFKr7amk+i6isct8NH7Vse/3vyO7aos=;
	b=lW7RHjLShnEK7FXTJQV+rIAtrajNSSeD44zNpn8/Eb31HVIJty0UJUsx7DFnoZGXSwlg24
	MsFn8HyjatXwISUOBLMpPhRaO+I9pPFZntYOHWyWvNbTW2Zkapy2CAA1B4CB5hwerKXllw
	wZzu/MtS6gqM2K0Ezh5NIjBVvERxEZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775801178; a=rsa-sha256;
	cv=none;
	b=7GKC6jSnyYBzeJnRdtU3ejszHSEqufWzeETQqA5DnmweZM45R7mG336UKxvyVzGS+UZiUL
	XEzgmb52xqM59yU5JqwWh2k19oeKXFww9y610S9j4xuhzveviBdZxwRF2zPpKnqf/Z9VQr
	5Pnae5P3pgRa7hgDIlmsg+/4rKkM3kc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qvcQTxCw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775801175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvqbrRNQVl8/GFKr7amk+i6isct8NH7Vse/3vyO7aos=;
	b=qvcQTxCw49DKU1sE2QQGtNGvvEvnxxtNyuKmTe9H8RW60gY0W7ZBPYolAZKKqKMpWpgM1I
	J89WangBx876uhnESIdzCqHvArj8Ev3dkdqnHekRlte+Jya7BQ1Vn7wgzeE03VvEfGENwv
	BMNGoPHa5/k9L0LM9FbRKfp4ogEwJ78=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [RFC PATCH] mm/sparse: remove sparse_buffer
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <BD30B00B-76F4-4984-9B29-9668896E761F@linux.dev>
Date: Fri, 10 Apr 2026 14:05:01 +0800
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
Message-Id: <45BF3CAC-2E64-4CA7-A7B8-800FC90930D5@linux.dev>
References: <20260407083951.2823915-1-songmuchun@bytedance.com>
 <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
 <70EF8E41-31A2-4B43-BABE-7218FD5F7271@linux.dev>
 <dcc3b56f-5d4c-4bb0-bfd8-49747df30f47@kernel.org>
 <adfBVc8ohLrtIe3j@kernel.org>
 <BD30B00B-76F4-4984-9B29-9668896E761F@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 000121C0006
X-Stat-Signature: d4e7a55jhe78q8dbkm18iak4j4iezk1f
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775801177-452779
X-HE-Meta: U2FsdGVkX1/OMJnV+MqY7HNGS18J5qmA6uq0s4NF0+v0NLVEQrwN3398HzbwHSpUIn5LHXO0VTUD9umqZ3YFpWB/FnnCWKqqaPhf4YmGRrCWouJyM6Y2N7n6y8gVzfFEtGwj2JF6Zh00m+H/VNcG1vMx2PatuMDUKaQ8KVS/UCATu+nt9KRaW7Qqkq9dC3gai/hKYgoPQQMQeCfSzdyiFB0zR7B1qKNG+dmvUoMiaQREyoYI1ELScwa0Ixb9WA1z2jXsIoRJA3TOsaWDnD0u1j6LPFV+UV2HN6R6VtkUEniHLDIV5kwFg1ddqoClaZHi6KFDwLWsP8+BSzIn9T7HkvlRDB1dU8L0+krQDtUQ3wYotPfKEF3/W9peab4WIJPasAhSbqSxBdWY8dBGJjvkbtE+CvsWXAPBJoO8ZWKPrYJpv/gxi0dx6UxRevkP5wTMYgVOMbldZGa60e0pQLjkJMbtWlLFVQ3coFCwkPrOeng7rKcpZU2AaX7qEMd7kUAX+A0mVvxTBUUarMzzGBYHZ4HbIFyjSXEgSppMuP4aMNbbPvX4YvWzkzSZSEQ+mSsP0tA3r+P9Fdj38iOwfrvpxKjyuA5oUrn7K3pbg+NxZgRH3cO8eQEW4YGAdSW/6NfLytF808fFNjQijNWvdcCY6F5X/3Q0JZkv3NLNYPYXctvyRJkov1F5C9f3tY3sDhEbaQn/F3hGOLVH6C8LTqEtSuBv9YLyDtri31A+wWwcWcVkBxz1aTUlihRycKDULT6153zTDACyQ7mZQ5M2ktkEpSVrRoYu+Y2tDqQz6vlEMeygvO9MYCPZqQRKmIdJxg+gObrowLRyep5qec+5Ljem9tRQidUKhOiJcIt4v4OXCNfQEyq9gPz0KLXcw/W9H8CdAmSeAQtQjvb7KUzNdTLB/u20r0pWFOyOM4KNgaIaxjM0DIHVh7ebJYjjrSrAXKtAfpYPvR5NyQ3zw8IIn4W
 vcQqkVRF
 pVy7H5PvlQTA4UBDILjH40WSjbHIQhDBHzgBJEv0Yg63tIgdpOKqyci7XmlQ5uIYqgMBYG7QOfsSKem46Ej9MHdaSOtoCeQYE9P/dWRvT6r+tgQ+qpthULjIMUFvW9mRkvYTWa5LNcUyFiDCR50vnFVXekJPvq41bM5KToqByT/MdjSFtdziVKMp59+3lTn24s4npKHe804E5ywvXFt8vZCZq2UYPi0TjpN+eFhib3YMJ6frKQS6trCY7JTAixLVXza++KNiSIQywd/sjT3b3hVnvp67sV58OR45p5WD1LLxct8oWoT6C9tz1Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 10, 2026, at 11:07, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Apr 9, 2026, at 23:10, Mike Rapoport <rppt@kernel.org> wrote:
>>=20
>> Hi,
>>=20
>> On Thu, Apr 09, 2026 at 02:29:38PM +0200, David Hildenbrand (Arm) =
wrote:
>>> On 4/9/26 13:40, Muchun Song wrote:
>>>>=20
>>>>=20
>>>>> On Apr 8, 2026, at 21:40, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>>>>>=20
>>>>> On 4/7/26 10:39, Muchun Song wrote:
>>>>>> The sparse_buffer was originally introduced in commit =
9bdac9142407
>>>>>> ("sparsemem: Put mem map for one node together.") to allocate a
>>>>>> contiguous block of memory for all memmaps of a NUMA node.
>>>>>>=20
>>>>>> However, the original commit message did not clearly state the =
actual
>>>>>> benefits or the necessity of keeping all memmap areas strictly
>>>>>> contiguous for a given node.
>>>>>=20
>>>>> We don't want the memmap to be scattered around, given that it is =
one of
>>>>> the biggest allocations during boot.
>>>>>=20
>>>>> It's related to not turning too many memory blocks/sections
>>>>> un-offlinable I think.
>>>>>=20
>>>>> I always imagined that memblock would still keep these allocations =
close
>>>>> to each other. Can you verify if that is indeed true?
>>>>=20
>>>> You raised a very interesting point about whether memblock keeps
>>>> these allocations close to each other. I've done a thorough test
>>>> on a 16GB VM by printing the actual physical allocations.
>>=20
>> memblock always allocates in order, so if there are no other memblock
>> allocations between the calls to memmap_alloc(), all these =
allocations will
>> be together and they all will be coalesced to a single region in
>> memblock.reserved.
>>=20
>>>> I enabled the existing debug logs in arch/x86/mm/init_64.c to
>>>> trace the vmemmap_set_pmd allocations. Here is what really happens:
>>>>=20
>>>> When using vmemmap_alloc_block without sparse_buffer, the
>>>> memblock allocator allocates 2MB chunks. Because memblock
>>>> allocates top-down by default, the physical allocations look
>>>> like this:
>>>>=20
>>>> [ffe6475cc0000000-ffe6475cc01fffff] PMD -> =
[ff3cb082bfc00000-ff3cb082bfdfffff] on node 0
>>>> [ffe6475cc0200000-ffe6475cc03fffff] PMD -> =
[ff3cb082bfa00000-ff3cb082bfbfffff] on node 0
>>>> [ffe6475cc0400000-ffe6475cc05fffff] PMD -> =
[ff3cb082bf800000-ff3cb082bf9fffff] on node 0
>>=20
>> ...
>>=20
>>>> Notice that the physical chunks are strictly adjacent to each
>>>> other, but in descending order!
>>>>=20
>>>> So, they are NOT "scattered around" the whole node randomly.
>>>> Instead, they are packed densely back-to-back in a single
>>>> contiguous physical range (just mapped top-down in 2MB pieces).
>>>>=20
>>>> Because they are packed tightly together within the same
>>>> contiguous physical memory range, they will at most consume or
>>>> pollute the exact same number of memory blocks as a single
>>>> contiguous allocation (like sparse_buffer did). Therefore, this
>>>> will NOT turn additional memory blocks/sections into an
>>>> "un-offlinable" state.
>>>>=20
>>>> It seems we can safely remove the sparse buffer preallocation
>>>> mechanism, don't you think?
>>>=20
>>> Yes, what I suspected. Is there a performance implication when doing
>>> many individual memmap_alloc(), for example, on a larger system with
>>> many sections?
>>=20
>> memmap_alloc() will be slower than sparse_buffer_alloc(), allocating =
from
>> memblock is more involved that sparse_buffer_alloc(), but without
>> measurements it's hard to tell how much it'll affect overall =
sparse_init().
>=20
> I ran a test on a 256GB VM, and the results are as follows:
>=20
> With patch:    741,292 ns
> Without patch: 199,555 ns
>=20
> The performance is approximately 3.7x slower with the patch applied.

I also tested 512GB of data, and the results were roughly twice that
of 256GB, so for a 1TB machine, the memory allocation time is only a
few milliseconds. It seems we don=E2=80=99t need to worry about the 3.7x
performance drop.

>=20
> Thanks,
> Muchun
>=20
>>=20
>>> --=20
>>> Cheers,
>>>=20
>>> David
>>=20
>> --=20
>> Sincerely yours,
>> Mike.



