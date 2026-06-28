Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB55C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 09:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3AA06B0005; Sun, 28 Jun 2026 05:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBF06B0088; Sun, 28 Jun 2026 05:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB876B008A; Sun, 28 Jun 2026 05:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 908BA6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 05:22:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2177120370
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:22:31 +0000 (UTC)
X-FDA: 84928780902.15.720687B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DD74AC0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:22:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dX83W0lh;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782638550;
	b=1Gg9CtqEzlMjVI0G0x3z/14Aaj1bHcNKb/vcjFSgggU/Mk4iWHIDs+/iRerLHZHVtbH2op
	B2+tZlKqKW4iVUqfel7CaxpW2q4SCWTPtjtmEUsQj0o8IVxfDB0rnw+Eu0Qm6hi3tw1qHD
	+CuqO6fmXjiMq3q5XSx4Dqnr5Emm12M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782638550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQ/aYEJVIRtbpfJ4OpCNdmweOjbbLLnGcukBKDZN/eU=;
	b=3bLfe5DqcXOIEsdtdckTBnvcvKmtgMqWFsgwcq0AoPOcDvBeCvJdf6e5mQsXT8iGGeRaTA
	TQcnSQJMkM9f0AZmSi8uNNE7tloOql2HbSfcYltpTAEuJ3NZ1pqkoJnZR7wF6+px4LRBNb
	zaUgCdsc7WAFGUw2pOKtaP1p/weCxGI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dX83W0lh;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB71543A59;
	Sun, 28 Jun 2026 09:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13311F000E9;
	Sun, 28 Jun 2026 09:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782638548;
	bh=UQ/aYEJVIRtbpfJ4OpCNdmweOjbbLLnGcukBKDZN/eU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dX83W0lh5V3fEptvqMtKYTtxrC6XcfuGCN0z+xqhJ3sKaN5fJQBCsJSGeAuPjRXb/
	 3F40fcY0U7DIT9Jhr0R7j6XqcUIQXqDdi97TxDquT49q/WQj7F0zMl2yH5k3erXIbA
	 +d1QktEA2hZNaHpCEQ4i7VN0m0j2ewQemXmXPJCW9wUT77+Xfdytfq7z+B+hxKgBl6
	 foyPcG+R4/3fPRMz95UDImUqzv1dXh702O+i6P3BKKwtkHtKsSyXmTgOMNpsho/WZn
	 916YhGzDV0Uqi+JOIICkzWqW8V4FGnYMU2XGT+WVznN4KdgOuPYtvy/T7I0PSs9fQ1
	 RBK6GcM2xS3vQ==
Message-ID: <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
Date: Sun, 28 Jun 2026 18:22:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------OEDpvwo0aWJgefRP7EiOdTve"
X-Rspam-User: 
X-Stat-Signature: n8gw9grwjhayqi7y8axiru63843ben87
X-Rspamd-Queue-Id: DD74AC0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782638549-452623
X-HE-Meta: U2FsdGVkX18LliHPll81Rqq8LQpvCyDg7uoZjpFmjht/U2dXl2ZKdxhIbBqO3lRegHvzIb8jZQMyRUL7gwMpCVh3j/ToUWdzzBwX42ZJFqaGqnebzB2tlkP0Rx08L6TktlAfrt43gwYgHS4ZOL/osxIQsa/gtKIhCT3lQEjQ7GlJDI9iY8TKwAxkE/VThliKBMaa+Uu8YqkLTK9/u6lYZ3HacbvjMkaJfYcekUilVnSOZo24G6dc67F6judd0Xsv750af6as8ru0HHir3r5DB0YkzqPwEqu9pQRjrbDi1jsepzajF2NxQaDhR1IBDEl///LWdCTf4hz0vMIljPPKwbyk8jmUlBRsdHzV2trOMTvh3y3Lx34ohUMMliS+PiZWdzAY0oLIxotkx5vVlM0nMwgG6iTq00ekaRByw86nRW95MjaGl2YvG4zYj5kDV/qPt5a7bFc8SiOvjvVwNzEoJ1Rs7yGJg0PEt4sVbF+rPfh+4RLmjvVlsDFrcIPmFk5ukP4fgSKo5x44utNwBobPR6p5vHovm24858KHNQB3lSEzFVoC5nhuLu7ou7pc+tRrB6QKBqah8dGsn6lLh/jL2aprwUZDKdHVEwDmh0WGeRixOPgSRsHs6HXZ9EvlHpdIIfsQ7CMQhGZ8Eo2fhPhUvTU6HFjjEH5Kos7wwhhH1uI8XvQM2FVAoIXJIJGWLLJqgwTWFbzyDv4IGQ4B/OYEKfyiAq8o68+6IwCA8l0YIIXrheLtfgp1X6BcyzDwDvNCP5/pHcqGpdQZYD7QrwLy/Y0RfP3jK/NSY8+e/je2bYgCGpW1ly2Z/PfPLCtkkw/HcECcURgnR6fnBDjbn8G7MvS3Rg/T+Ur7JEJ7pgm/+bZT0vCRBq0lwbo3OZDbrcNsSfUOcZBQ8Iew7NiXv/OwJVBxd/xS2BRYjzGb6G4ucAfsxH8Cz9pzHfH37VtSLP5FgX+ku0nUNuQ1MVR8g8l
 owgQZw3Y
 H2Wmt3oKMzv8Wd6UQafezQdlPzRgA/V/id5J9huxx90oeUwI7iAimiYaxVKA/Q1ooMtEyyj+UNCjLuT+m1OMy73buQVMGSUsjazwBnb8EtXWVGWp8Nq9VbBfbiBk+/kzibTvqSCO4rF3sxOQXYCvKxLGJnznmb3srsBcVYsEWNDUB0VuNv1lXoL8G05BAB7foL+tkZtoL2wqJ+yBFCBDyMy6qfOsviKapOlfauZfSk7cccjH2uXDWKk195Rgp1doC/GmJkCEWGVJpBQIFcjpIrEQ14/vdp2uKyxHkaGdIIF5+tkcIY2UNqCfUjVvLmQQx4a4U5MjziINc0/0sIVtY0J3l6009yaJto/V5XTaJvkZglSuF/dKIhtRV+9iBUndr7ySw5NPQVuCAsMmJMW3l1nsjASclH8waUMpORHAM8nmv26cMLE8aB9YJjEyk9RJdfdzS13EoKW2rkzfO466dqHFedKGRnVslq8UORwadG1yKhOsLkPOQwBQJ92uZoNxtqdKY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------OEDpvwo0aWJgefRP7EiOdTve
Content-Type: multipart/mixed; boundary="------------qCfhd81ooqA0slhNdxF44v7v";
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
Message-ID: <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
In-Reply-To: <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>

--------------qCfhd81ooqA0slhNdxF44v7v
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/28/26 4:47 PM, Vlastimil Babka (SUSE) wrote:
> On 6/28/26 5:23 AM, Shakeel Butt wrote:
>> On Sat, Jun 27, 2026 at 07:58:12PM -0700, Shakeel Butt wrote:
>>> On Fri, Jun 26, 2026 at 07:11:33PM +0200, Vlastimil Babka (SUSE) wrot=
e:
>>> [...]
>>>>>>> Fix it structurally by removing cycles of every shape: serve the =
array
>>>>>>> from a cache strictly larger than the one it describes whenever i=
t would
>>>>>>> otherwise come from the same or a smaller cache.  Every reference=
 edge
>>>>>>> then points from a smaller to a larger cache (here kmalloc-1k's a=
rray
>>>>>>> moves to kmalloc-2k), so the relation is a DAG and cannot contain=
 a cycle.
>>>>>>
>>>>>> This will fix the problem.
>>>>>>
>>>>>> But this will waste memory as we need smaller obj_exts array
>>>>>> as the size gets larger.
>>>>>>
>>>>>> We should probably create a new kmalloc type to avoid cycles inste=
ad?
>>>>>> (needed only when memory profiling is enabled, though)
>>>>>>
>>>>>> That would also prevent recursion even further.
>>>>>
>>>>> Yes but I assume that would add kmem caches even for users not usin=
g memory
>>>>> profiling. Anyways, I think that is a separate discussion. Am I und=
erstanding
>>>>> correctly that you don't have any concerns with this approach?
>>>>
>>>> Umm, the memory waste is a concern?
>>>>
>>>> Minimally I'd now want to only do that size bumping when allocation
>>>> profiling is enabled. Ideally that means both configured in and not =
booted
>>>> with "never".
>>>>
>>>> We probably should have done that already in 280ea9c3154b2. Because =
AFAIU
>>>> memcg-only obj_exts array don't have this issue (or maybe they do ha=
ve the
>>>> [1] issue? Harry?). But if memcg-only should keep avoiding the same =
size
>>>> bucket, it can keep what it was doing and only memalloc profiling wo=
uld do
>>>> the strictly larger thing.
>>>
>>> memcg should not have this issue as normal kmalloc caches do not serv=
e memcg
>>> charged objects.=20
>>
>> I am wrong here as I went back and see d8df600b67d7.

I was confused too :)

> (8dafa9f5900c upstream)
>=20
>>>
>>> So here we can do dedicated caches as Harry suggested or make this si=
ze bumping
>>> very specialized as Vlastimil suggested. What do we want long term? O=
rthogonally
>=20
> Maybe long term we make kmem_buckets unconditional and use that.
>=20
>>> we do want this fix to be backported easily to older stable kernels. =
I will see
>>> how does this narrowed down size bumping looks like.
>>>
>>
>> BTW I think we need something like the following, right?
>>
>> 	if (mem_alloc_profiling_enabled()) {
>> 		if (obj_exts_cache->object_size <=3D s->object_size)
>> 			return s->object_size + 1;
>> 	} else {
>> 		if (obj_exts_cache->object_size =3D=3D s->object_size)
>> 			return s->object_size + 1;
>> 	}

We should not add mem_alloc_profiling_enabled() check because,
then we're not fixing this issue on SLUB_TINY, when the caller specifies
__GFP_RECLAIMABLE|__GFP_ACCOUNT without memory allocation profiling.

`if (!is_kmalloc_normal(s))` check already bails out when it doesn't
need to bump the size.

So Shakeel's original code will work fine.

We're only pessimizing memory allocation profiling and
SLUB_TINY && MEMCG users, but (as Vlastimil suggests off-list)
it wouldn't make much sense to enable MEMCG on memory restricted systems
anyway. (IIRC even raspberry pis don't enable the memory controller by
default...)

I think it's okay to fix the bug first, but we need to address
the memory wastage issue sooner or later if companies (Meta and
Google I guess?) are deploying kernels with memory allocation profiling
on in production systems.

Perhaps it's worth adding a comment like this, though:

/*
 * Only bump the size when the object (not the obj_exts array) is
 * allocated from KMALLOC_NORMAL, either by memory allocation profiling
 * or memcg on SLUB_TINY with __GFP_RECLAIMABLE|__GFP_ACCOUNT.
 * Otherwise, obj_exts allocations cannot form a cycle between
 * kmalloc caches.
 */
if (!is_kmalloc_normal(s))
        return sz;

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------qCfhd81ooqA0slhNdxF44v7v--

--------------OEDpvwo0aWJgefRP7EiOdTve
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakDnzgAKCRCGXBN6rc5S
1lQ1AQC0uWuA8kOqLnc7JcxHi6c8NiDIGEK82coLHYTGzOvjeQEAuQNNB5RBK/ac
/JarFs8VAaTd1jCT3ZJkADc0Pv+l5Qk=
=rUUx
-----END PGP SIGNATURE-----

--------------OEDpvwo0aWJgefRP7EiOdTve--

