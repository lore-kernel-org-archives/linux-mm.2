Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326B0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202ED6B00A6; Wed,  1 Jul 2026 04:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA846B00A9; Wed,  1 Jul 2026 04:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117D46B00AB; Wed,  1 Jul 2026 04:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCA276B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:43:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EB2F16557C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:43:31 +0000 (UTC)
X-FDA: 84939569022.18.F12B1D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8FDBB1C0003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:43:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcFkC3n8;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895409;
	b=GX4GAzMIenYavRkzM3APDxsC3pwXauU60i4iC2yPJ53PkUy/sWxl8Prm6i76zOE22szGxu
	MoXfYafE37xIPyuqa1hmjQKrf4zRrvb7sAGo17iZ0ya4x+Ko7PNbEyESgSp7waL8C+ClE2
	/Zb7uGyTWb8ZJWeMtIYiZyG/FKF2i+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wg0g0njCZHL6Zz09qa62R7YUBIiwi7uccWEENqLTF4c=;
	b=Fr2piCNhFb54YUqQPfFHFR2p/buDyhTNKFlhZj4e9q9aaEw5uMAMSSDQmDKnj56f6oYhlP
	8mu5DSguVELw9etmy83pN5qvZQh9XlVk14Dhe51Eyh6S5ws9Lv3q+XGjONKHDgEMb+atEq
	DGC9ih62wnRogO/40nYiycj9sSnpJDE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcFkC3n8;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B226B40A7F;
	Wed,  1 Jul 2026 08:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5C41F000E9;
	Wed,  1 Jul 2026 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782895408;
	bh=wg0g0njCZHL6Zz09qa62R7YUBIiwi7uccWEENqLTF4c=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=hcFkC3n8AHC2UQ/5CKvA8Ur1qGVOq+ZJoimSPsg/lymsNXEw6hDCkD+1aAaKZUzbF
	 EboLoiFXWX6RCKMMS95x5EetuT50ZUevkKpHh1q2EwciC75UP0Bv3S9UG3Zuv2aS7h
	 AomCbO1VGjRn073SkoxHWyKd4LdBvRNa2Qt5PIUKn/UHIGlVUOVWfiR4uVnR5lRkzG
	 07Jc5gEi5ftmPZVEIS15RXvKVPNoT6My4N+4hJMdEF1crY5YsXQEoIbbIeBODtoOLR
	 tjcrd/wz2PAqaQ3OAmwjn3896pSO2n8c0+gOwHz/G9kN2Ff7rQ0wARl9f9ai/IRfO6
	 clsd80r3SIm8g==
Message-ID: <143ed5f0-67be-451d-a592-e184dd51763a@kernel.org>
Date: Wed, 1 Jul 2026 17:43:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
 <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
 <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>
 <92bf5e21-690e-4a77-929e-5217e0d7cb0c@kernel.org>
 <68e7f6cd-cf11-46b2-84a2-d512bb22dae4@kernel.org>
Content-Language: en-US
In-Reply-To: <68e7f6cd-cf11-46b2-84a2-d512bb22dae4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FDBB1C0003
X-Rspam-User: 
X-Stat-Signature: u7xgjjgceenktt4om8fmn987mq3db31j
X-HE-Tag: 1782895409-119548
X-HE-Meta: U2FsdGVkX18sJ0ZKvdE7Dw1qPmhM+pIF6MKGZicjdAJvOerM/nuGg1DKsv3C8UzRCWAGjtjFTXezkdEse5ZgLJNPS1hzhWOd7YfXc9al+b0ha3EPcc3tYzim5SQA3Z1YuILh/hDxxnqY1WPZJXCM4JwCFw9bEP4Cy3Imx91u//tY3h4yPr95Pc/DFf5mypyGQ5U+1q9aLqrahBmmhy/C9GWQVdG/4oRdxKJrzqeCKGIw3Ruzg/2UJxqgrOxswY2BuGmQhRGBEJMjdvGeAnZhXh88J9wz58dTS7KxX0hLedfgSa7a0wfd9Ku2dZUICjEMmVotZxI+uJltcZ47S/dPhWpX105UNs9EZMTKWXPsHZWCm30F/c7ufd7Qb7buiguRnRXw4Tzk+73GByOx1Vvwl41cbMGbuhB/7Wv0z+IDFyM5I3QubZhsg3KjvwB26hx5f/DAJS9RgKNfbmp4JusSFy32UOw/3z5VH8nhOzSKt5+beXpApN6tSLb4imKaWK68/dlrfD1TlmtnZ2fKfWoAORJ28I5lPMos6dAmZ6MFujjtPjGFBcKpAr5BTCciIV9xJkqk2MtJ4/NXM9AUbvaDXBETU6jzqOyCisKxai7EkSuQ0JgmE+2WidJSVwaYEgrtWXRySfao6ZuTgD0qYbiaLNmTph5pcRgBLj0xfJNubDAktIouCl8zO0wnzoi8H3tujE/uxGL9Y3UhoRDUsxlfvEtcqWqlYaNmcH1PLxfMceYU6VGjbB/dYkOR5NzTUUsGovqziiGUtn5INcrnVTRVClfg/y7oIB5zOq8U/S4yQS915w4ERJ81eAaVKBgO7hzg3ZkZzrRv/7t0Bz0IC/niWv71T7+/UCq3EqizN2AIzmsYmk9YknLJ98/qXNc9iOmXvLsfqZKJz5PwfCC1flG6V1YmiRtpL6QIiwL6ELMlyxvhn9qlfHIv0X8dSHVzADUc8npppyPND3j1YHbh84m
 oUOIxYeO
 kaIuOGIkUESb+h/MRnplMxfvUHLB5Ud5IJlAT+Jtd6PBgVjjU2Xu+rwC4Pl8S1PPqIp+ZjsLaTRvtfLCnjd4MCbV0cgGJbgrkaslzKbJpq7rkSXOXRZpYeDW/AWVQDqoI175+XfgAeddzfvkVJYFF5eDrFVyNyh/vCh1ZHbn68UiclPDk+dLyF+YWxTemmo3CcvCNaCzkaljTGgZwZTIBQg4+0N7+gef7lXkXeyUeig/pyMyVn9L8gKj3/3w0fmK7Th+2OTFMwd2yWy6QqOL2vZGa2XcuW80+xgPA6UDc5GIryMtbNP1M2PewXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/1/26 4:42 PM, Harry Yoo wrote:
>=20
>=20
> On 7/1/26 1:53 PM, Harry Yoo wrote:
>>
>>
>> On 7/1/26 1:30 PM, Harry Yoo wrote:
>>> We can do that in pre-7.2 kernels, by teaching kmalloc_type() and
>>> kmalloc_slab() select the new KMALLOC_TYPE based on __GFP_NO_OBJ_EXT?=

>>>
>>> e.g.) Select the new KMALLOC_TYPE when KMALLOC_NOT_NORMAL_BITS is not=

>>> set AND __GFP_NO_OBJ_EXT is set.
>>
>> Uh, this is bit subtle though.
>>
>> In some cases  KMALLOC_DMA =3D=3D KMALLOC_NORMAL,
>> KMALLOC_CGROUP =3D=3D KMALLOC_NORMAL,
>> or KMALLOC_RECLAIM =3D=3D KMALLOC_NORMAL.
>>
>> Just checking KMALLOC_NOT_NORMAL_BITS is misleading.
>=20
> Here's a prototype for slab/for-next. Backporting it requires handling
> __GFP_NO_OBJ_EXT instead of SLAB_ALLOC_NO_RECURSE, but shouldn't be
> too difficult. Now writing changelog and going through testing...

Now thinking about the performance implication of sheaf allocations
for kmalloc caches being served from KMALLOC_NO_RECURSE caches won't
have sheaves at all

--=20
Cheers,
Harry / Hyeonggon


