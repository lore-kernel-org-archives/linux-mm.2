Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA73FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8161A6B00DE; Tue, 30 Jun 2026 00:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDA96B00DF; Tue, 30 Jun 2026 00:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705836B00E0; Tue, 30 Jun 2026 00:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 321696B00DE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:42:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9255E1A0349
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:42:27 +0000 (UTC)
X-FDA: 84935332734.13.AAE64C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EA1F24000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:42:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dh/y1LSB";
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782794546;
	b=PoYQu+1pP5C3wJSpuNCRpeHd6M2GIiBLQ93tV2HyeNsOefWrfAUhq54lgszlyysfwhyK0J
	gkCrJoBUJGuJazSN9GFnR771JClkV6SGBbFYqY+Ch8mqybBVvqX4RPQweBiG6gL0Ig3gxx
	hqk28L3P8PrzSJWzEmBARihCYOBtJQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782794546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cPiJvYZHb7avfM0My/PdqUI5x5yrUyDFJ25Fg7K9NA=;
	b=w5eFxD37vYV6h1Y5FrX2vOeWRijrefP5e4HCj2wQU2C+ulOmvxqpqRIiAsUUKi3JMTfXIM
	JU63wkaRqe2tcNq7y9mlTrirTfKd4o0yRIrJkCVl9mU8qLuXVFOTJbhV2OJsgk66y6mJn5
	2JgBXyEi8M7Cf516TipMc1XP4LCOkzM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dh/y1LSB";
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 652FC600FC;
	Tue, 30 Jun 2026 04:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2053E1F000E9;
	Tue, 30 Jun 2026 04:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782794545;
	bh=1cPiJvYZHb7avfM0My/PdqUI5x5yrUyDFJ25Fg7K9NA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dh/y1LSBjjm9REMGrHHS6hzA5F8VlHjSV+hsD3XUt9gu1RbwqhxFzbwYg/J1hzcXH
	 TrtHo1ED/uxwl1t/6QHrreM9dU/4B48NtYBqLo1mEsdv/VaEIBoq55lZgFx0xNWOH+
	 BIr7WuAyTSQQCZeqkHECIumyCEuS+QfZ9HdJoZ+83/BQY3nDaBcishhFrd984b4khR
	 5Tvj5eSdV+64nG2mtEZDM1Iqgby7NvBIRoauhKgtbz3FV8g0W0AILGoaN+/aLtx8La
	 sAVsyUsnjSq7GrhCBOuPU9S7Mqa8CUPOP5OFeMoc2s+EefpYE4GOGmFy/SItFq8l/y
	 arjgSo3tk6kSA==
Message-ID: <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
Date: Tue, 30 Jun 2026 13:42:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
 <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pghpg7w3a3bgi5howq1znhak8aq5r1na
X-Rspamd-Queue-Id: EA1F24000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782794545-398909
X-HE-Meta: U2FsdGVkX1+9sOG53+x/pSuG4bn7Ao1skhqg59Tz7GKeNaiI3gMGXQRK27N8xSYU13QgnF7S5ALWKlwF9Ecul1V317Fid0oM0lLbRDPoioK6uJETCla5fFPuvLxqoEau87W4Yya7iRRN7NRwju3w8oUab+wfP6/EBvJEiX3VpQTqnE/oWTlJE+HygPOvVoK83CPpbTad31FlBtmEgX19LWWZ4bDkShiSQPT9rk4DuPdTI5SfwivWovf5zsnlu3K/EMtPq/vVzvhdXsxxQy9v06RO/r0lIFMIZBRMBQ8Gm2I98rWk/+D9OowwU+BkRwtlXRUqZsD5duc/E2Nm3wgHkjeUqIwAPhTq/isAQyNWQS0fGtvYB8iHiNBAkC2pJ+D2lLZ0Ypq/UkpKTNy6mgOUtcYdPcB2BpCqT1V87YI7UfxCxgSz0bpYh6QqF36eByrW8auNDhvXg4nY87RCV0moE+H2axEAP7W5TPcDMEe1dj4BZmDqhfnC/0+oRrjd2Mn48LtYGJYpYsKNWTcjpSHMTFAkBZwQlgLVp965cLG+5btqvglNT9MOD0gBKCnS8f265Qim5/WdvJPeeb1DuC8GO6h1NBeq1D33vv+7DzLvkshoNEl795RPGMAJtdjIDWFBntuAKdzFxBUNH7wQjKIVyWzacZz4XfUhqe1Ou7tthzHS7IaygqnDQG+4XyesRXkoJvBLKsTRAegrGLWXbU+E9lJXnfD0d/8phz/WgU5F8oNmvgQNSjQu5NjInm8XLAjHKqT+d175m+N1ghKmXRBKg11G7cgpuEDq2dw46mc0y9JF2n5EbMeR3sN5dPd1pNEht0obbdD1CVM/QmUTXWiKZq9evWpPgBlgy2xMpPuABm8PqmTLA/Mz/MD6xFPoNSDGFKh/VrAnMfwCPEd7IvSaN1K3OfPRDtK05PohMUC0lzI2KmfBjHBlfn5HnCmGVXES/bRTtSjh8ZoZ9bXaBTd
 sRnhAgvW
 WwBnOQAb/EppYMrAoQHiIeTEFiMwHZebxoCzXeiJ6rAxfnkLJ2zCyCbk6v9iEjaDqH21fdTPWXoIHwoKWbOl6IydlUGIGSNQO+43GLxiDcZoSH4V3JEJRoW40rCFVr2tk4SlNuxOsevdINEnePtj6glEgYuKAU+m/ZBLBmYhFVAogq8FQsA+NVeQvQknRBQmfceimshPoDBe+Tu0H13sjP4fzi5th7w6XiqxW4Fvd3EQ28LE8l4JKhLelqgoOlhX9ETIR3bWqN5l/Xu5vFvH/aIRzzLN0IQwKf7B1zgy62axLiwbW5NCtas8/KsdId5u9pSODNz4TTB08sV/4maF7rqKZPVK92iBbY8rH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 1:39 PM, Suren Baghdasaryan wrote:
> On Mon, Jun 29, 2026 at 9:38=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
>>
>> On Mon, Jun 29, 2026 at 7:31=E2=80=AFPM Harry Yoo <harry@kernel.org> w=
rote:
>>>
>>>
>>>
>>> On 6/29/26 1:28 PM, Suren Baghdasaryan wrote:
>>>> On Sun, Jun 28, 2026 at 8:57=E2=80=AFPM Harry Yoo <harry@kernel.org>=
 wrote:
>>>>>> I think adding a new KMALLOC_TYPE would be the cleanest way to fix=

>>>>>> this recursion problem once and for all. This size bumping and the=

>>>>>> special case of SLUB_TINY are quite confusing.
>>>>>
>>>>> As mentioned by Vlsatimil, in the long term, using SLAB_BUCKETS
>>>>> infrastructure would be more straightforward than new KMALLOC_TYPE
>>>>> because (I think) the kmalloc type is decided purely based on GFP
>>>>> flags and we need to somehow work around that. SLAB_BUCKETS provide=
s
>>>>> a nice abstraction to do this.
>>>>>
>>>>> Luckily, SLAB_BUCKETS is introduced in v6.11.
>>>>> Unfortunately, SLAB_BUCKETS is optional.
>>>>>
>>>>>> We could define that> new KMALLOC_TYPE only if memory allocation p=
rofiling or SLUB_TINY are
>>>>>> enabled to avoid new caches when not needed. Does not seem too com=
plex
>>>>>> but maybe I'm missing something? WDYT?
>>>>>
>>>>> I think we need some enhancements to achieve that with SLAB_BUCKETS=

>>>>>
>>>>> 1. Rename SLAB_BUCKETS to SLAB_BUCKETS_HARDENING
>>>>>     (w/ SLAB_BUCKETS being a transitional config for _HARDENING)
>>>>>
>>>>> 2. Make the SLAB_BUCKETS infrastructure unconditional,
>>>>>     but the decision is made at runtime:
>>>>>
>>>>>     1) actually creating a kmem_buckets vs.
>>>>>     2) falling back to kmalloc.
>>>>>
>>>>> 3. kmem_buckets_create() creates kmem_buckets only when
>>>>>     SLAB_BUCKETS_HARDENING is enabled.
>>>>>
>>>>> 4. SLUB decides (not) to create kmem_buckets for internal use
>>>>>     during the boot process. Use the kmem_buckets for obj_exts
>>>>>     array allocation.
>>>>>
>>>>> Side note: this would unconditionally add the kmem_buckets paramete=
r to
>>>>> the kmalloc slowpath. Probably it'd be worth introducing a dedicate=
d
>>>>> entrypoint for kmem_buckets instead.
>>>>
>>>> Yeah, this sounds quite complex.
>>>
>>> I think it's not that complex, but quite some churn, yeah :)
>>>
>>>> Maybe we could use the new> kmalloc_flags() introduced by Vlastimil
>>>  > in [1] to avoid using GFP
>>>> flags to indicate that we want to use this new KMALLOC_TYPE? That
>>>> seems simpler,
>>>
>>> That indeed would be smaller changes.
>>>
>>>> though it's not backportable because kmalloc_flags() is> brand new.
>>>
>>> Right, I didn't seriously consider that option as I was (mistakenly)
>>> assuming you or Shakeel would want to backport it.
>>>
>>>> [1] https://lore.kernel.org/all/20260615-slab_alloc_flags-v3-0-ce114=
6d140fb@kernel.org/
>>>>
>>>>>
>>>>>> If it is more complex than I imaging then I'm fine with Shakeel's
>>>>>> approach as a temporary fix.
>>>>>
>>>>> Since above requires quite some changes, I'd say let's proeed with
>>>>> the fix (since it's one line of code change that fixes a bug),
>>>>> and then see how we can make SLAB_BUCKETS changes as minimal
>>>>> as possible for backporting?
>>>>
>>>> I was thinking Shakeel's approach for backports and
>>>> kmalloc_flags()+KMALLOC_TYPE going forward.
>>>
>>> Oh, I misread it then.
>>> I was assuming it's critical enough to bother backporting.

Ah, here I meant backporting either the kmalloc_flags()+KMALLOC_TYPE or
SLAB_BUCKETS approach.

>> Yes, it's worth backporting, so we can merge Shakeel's change as is

Right.

>> and then once Vlastimil's patch is merged we can implement the new

Vlastimil's patch has already landed mainline, by the way :)

>> KMALLOC_TYPE as a replacement.
>=20
> And Shakeel's patch is easily backportable.

Yes, of course!

--=20
Cheers,
Harry / Hyeonggon


