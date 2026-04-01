Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A044FD3514A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34B16B008A; Wed,  1 Apr 2026 03:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5536B0092; Wed,  1 Apr 2026 03:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB896B0093; Wed,  1 Apr 2026 03:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1C026B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:28:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79B9E13B728
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:28:43 +0000 (UTC)
X-FDA: 84609159726.09.2360BE2
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id A8E7880010
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:28:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ekLZuRfv;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775028521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E65Yz/rtARK/BoOkD3xuTZ60cfg1ITmPfEUtw4OR+xc=;
	b=0Hn3JcDSCZ/meMJkhxnN58wq9mSCFAoqUMZpw2B5NAPiHbegf58AQ+ydD0Kw/sRNZn94oN
	hc3h6TVBrcyclHpnzNT/tpuCSyWLcsaTopiPqTOsFrpZMHqJ3coS0sS1Tlc9UXvJrIuC71
	jOOCdkj+ImFIjQ4o12yV7jBVwIca/nw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775028521; a=rsa-sha256;
	cv=none;
	b=zyrxCmXlUcD6gKfSUlKykpydPeK57K5F7HNGGOZCjEU5UORR1bzPoN0fCrgUg4ImILXy85
	XUhcg9zV7F12sWFu+q+43C1f+TPYekydjy4bbWfLmQXu5mtP2Q2JkjgWZLFbyHWuh85hAU
	v6H4/BsAOos9t4PYISHXIMlPk+4Ckjs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ekLZuRfv;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E65Yz/rtARK/BoOkD3xuTZ60cfg1ITmPfEUtw4OR+xc=;
	b=ekLZuRfvTNCtpFghyWNvQkF0dw/QlHQ/4NJCHKaG2saoB/wne2gQkqdXXi4U8SbNw3lEk7
	VcVen11Op8JslhT3MdPKrTobHFwtQRIQwyvscqZVHbDyPF22VMO0ZCk+7ITCoYkfaR8J3r
	OovXcG1rn4TEzAYcC0TMMGwRm8ak4CY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <bb05187f-2a54-4c5d-aad2-27b462707206@kernel.org>
Date: Wed, 1 Apr 2026 15:28:02 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <462D1EBC-22B7-4527-B725-6DED308D428E@linux.dev>
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <17246161-f314-45da-933a-770231ef2a49@kernel.org>
 <2183487D-0CED-4BEF-84D7-4439F3386584@linux.dev>
 <bb05187f-2a54-4c5d-aad2-27b462707206@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A8E7880010
X-Stat-Signature: sjcwuq5hwe79od4esj6ybejbdw61c75i
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775028521-229567
X-HE-Meta: U2FsdGVkX19Ce1jKVsPWtGq39rgyv02e/EN65zgaV1hYs0klJo3kx4ZZnp1Gx9NScF4Tsggq/n8n6aQs+utT8kxDj/QKMkUMuEAM+NeOJGyoy98C1acAADO016PbG2mb/T8HP4BaHqvMvzOc3EAFB/49lPfIyYHmD1o5Du6/QS4haFh+wZuMHFrZliejbRGIGCPb/IeF+UnQYpL9NFHoQruqrevYeYpA5HMUVTTe1x7tkoCwyV61tbRmnmlwV6LhGcYKHomMG0mAIGSC7AzApAtPI+QhF1H7FNuquswiqTw4EaA3OLl7FtNFVK4S1AMQqQ2hqrBGwQuF2V4hwPGgOaua9RM8n5AVP+JDCNfKZxhfM4TKhS1M3U+YvLHCihFDASi6JLwC6v+kiicH7oa88N6JWx7PaZu0pv4H7OKdIVoBuLE5ny6vC20Jjdk4rIxLaczHcORCu+2nPwwsKYzcgW0h8JoqJH8tXWTmYdpzl8to13K2OOweWc/eO+fe0lyX3yxpI28qNmvLrtWOqnpObES+XaDLvV8jz7d2rQYpmxqk/WSn0OkE8Vo4kV8ZqpRkuzwM4j263k1jzN6jD9ZBPuX7JEq1oaIr5ApxclV1hxyW9W8sOjb4AcmrVjRk6R9GxOAe+6etjDhJGFOk1iG4OVNmg6bci6ElLl4N+XkC9KvyHPmSIqt+VOElfrVRELcf1UpoKA/5bKN7sQQX4TTYKzHE6oWj+VmHTWwxkwfqXVxMoDoNshFLQFQxp5mA4Vn/NBqCSoFMxHjWQcKxHbAPvgGF+OTBaCFx6qYc28J+Jk4leolGOVujuZJNOMzWDflQAT1YzLFY8fSgfiUdA3qhXc4E/B4mMJoKREwl88kkIkVKHOKK5v7wivtYkQycTe3wiEjS7NtiyyTV8ESKMSwY+3B3cDDFr/3HlKZ3hBkwfpLsodx1sz87yC92UCoJhQ7YCe9FOKJ4SYZbvcsxb3e
 VyCH0o6L
 kz+ZH8TC03VYpDnw5CQjOTzpJwWyu55Uk8Pl5aEMIsOH6c37e2cHcQzzBQRSNMPRYawbfpDX4J9Q2W6hATn2S/Cb56s84my362UbpfCFzLKPxwLVVaDiRPIAhd1k2uNg91lHZseqxyApauNO96P1oZrsm565fluyfjaEhy+PqzzqBhe1SKmSdIQrFLC8PzTaPTbi+jfIFFbdhMoNr8EAvzPwkP4yrUv6wAtGQKy4twfo80F1JOqGzFkZe4cIhu3eS6L3gjJ+pShN+Gg+mlPJREjgz6qlqcCq0apBXTDw4N/TLm+LbdJR2VNi7EcXcWtFBajNp91Fyse9UFN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 15:25, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/1/26 04:41, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 1, 2026, at 04:42, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>>>=20
>>> On 3/31/26 13:37, Muchun Song wrote:
>>>> sparse_init_nid() is careful to leave alone every section whose =
vmemmap
>>>> has already been set up by sparse_vmemmap_init_nid_early(); it only
>>>> clears section_mem_map for the rest:
>>>>=20
>>>>       if (!preinited_vmemmap_section(ms))
>>>>               ms->section_mem_map =3D 0;
>>>>=20
>>>> A leftover line after that conditional block
>>>>=20
>>>>       ms->section_mem_map =3D 0;
>>>>=20
>>>> was supposed to be deleted but was missed in the failure path, =
causing the
>>>> field to be overwritten for all sections when memory allocation =
fails,
>>>> effectively destroying the pre-initialization check.
>>>>=20
>>>> Drop the stray assignment so that preinited sections retain their
>>>> already valid state.
>>>>=20
>>>> Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap =
section init at boot")
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> ---
>>>> mm/sparse.c | 1 -
>>>> 1 file changed, 1 deletion(-)
>>>>=20
>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>> index c2eb36bfb86d..3a14b733bf71 100644
>>>> --- a/mm/sparse.c
>>>> +++ b/mm/sparse.c
>>>> @@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
>>>> ms =3D __nr_to_section(pnum);
>>>> if (!preinited_vmemmap_section(ms))
>>>> ms->section_mem_map =3D 0;
>>>> - ms->section_mem_map =3D 0;
>>>=20
>>>=20
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>=20
>> Thanks.
>>=20
>>>=20
>>> I have some cleanup patches lying around that cleanup that code =
heavily.
>>> I think I get rid of this questionable "failed to allocate" case =
entirely.
>>=20
>> It's truly a coincidence =E2=80=94 I also have a piece of code =
locally
>> that does something similar. Since allocation failure would also
>> affect subsequent startup processes, I simply made it panic when
>> allocation fails.
>=20
> Don't use BUG_ON, use actual panic(). :)

Got it.

>=20
> And yes, we should rip out that handling.

Agree.

>=20
> --=20
> Cheers,
>=20
> David



