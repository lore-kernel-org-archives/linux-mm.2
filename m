Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFEBCD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 09:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C62886B0005; Mon, 15 Jun 2026 05:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12DD6B008A; Mon, 15 Jun 2026 05:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02B56B008C; Mon, 15 Jun 2026 05:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF096B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:02:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B89E1661B0
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:02:09 +0000 (UTC)
X-FDA: 84881555178.22.1E51504
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BF251C0015
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:02:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bpOCPu9c;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781514127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zejvIfX8d2dRdR2mAJ04OI+CXDIR6kMQOBHLrkrQTuY=;
	b=Xf1bYPHORKxW/ODOIyhG/3wyWnFOBU1sQlsQik66Ck1/FJEptwt4i6zNatzqOEGCoD1veG
	F6wW47n1OxlUedS5pyv3Uwdd2nmoWbbcQy9T2cUUL7DhLbNT0i+Bo3QuBZU2MKnp3aCKa0
	yl8DCzn4XFyTpI8yQ7+wiGLbdUAir0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781514127;
	b=65XJC6zNy2IJLmh6V/vyEW/H+VUs1vqmvPHGMn0s1ftKJUuohrYNVqRKiYqeQvf1OqeOpx
	8mZEPWOyu7+np7DX9UT93rrfhnMkYIBgPWskXGtD+7att834Er7H/l+2y9a8XqTx1OQTLr
	lv2PLA0JMwgc06b8MBtRi8/iCHUTfak=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bpOCPu9c;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3C34402F8;
	Mon, 15 Jun 2026 09:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E71F000E9;
	Mon, 15 Jun 2026 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781514126;
	bh=zejvIfX8d2dRdR2mAJ04OI+CXDIR6kMQOBHLrkrQTuY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bpOCPu9cAnQ49Uo92ymBgaDMsNNkCNFKwGJhICCG+otI4FMV/1oOM9BbFmEiw5Em4
	 C8wyRuso85zHacKQClkoVbhC99Qsbm8cmYaHrJ49uXB1J/tYEK+rCvNXsvrecquD7J
	 kVgQwxtFU+5aDWA/ytr87bu917cKElEi7bbwLi+D91RJgEQO4cmrM9yOVBM4Hfxx9P
	 SG93yjMZJnEoUuUMlo4c6fyG1UZFJuLRJfx5bN00r2+sriy+T6V/7PrtSWCk7LGuwk
	 KXVr9X83dNSbMhpQ+2NqtyD41/ZR7kSIQyPYaVUtRUYg9VfALr3666VqLlO3RG9MTk
	 pVT8qdIw+QhdQ==
Message-ID: <f927f1b4-3f60-471e-b42b-8d098c1ce5dd@kernel.org>
Date: Mon, 15 Jun 2026 11:02:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/16] mm/slab: introduce alloc_flags and
 SLAB_ALLOC_TRYLOCK
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev <kasan-dev@googlegroups.com>,
 linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>
 <aiuBoDbQc0N-l7e-@fedora>
 <CAJuCfpGSHfNUvL9AzbftSg=uGRW4cJLbO6iB15keyN6A_eSWEw@mail.gmail.com>
 <CAADnVQJPETYAOd9R9Bg2JuuF1q7grg8VtEnvdvr0fDFhxb9O6A@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAADnVQJPETYAOd9R9Bg2JuuF1q7grg8VtEnvdvr0fDFhxb9O6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7BF251C0015
X-Stat-Signature: ge4pq1nhjurr35fs6fiysyoewrgu14mx
X-HE-Tag: 1781514127-715007
X-HE-Meta: U2FsdGVkX1+V5ijN+fjU1T7CMPE9bdPRquVyB3PYDXOKDv3iFd3ndoC3Q+o1h4z6wA37WR2YQJmXnKMAYY4gxu70+fPrfttgeHZ8czqvcCbhWDJ3QymokcmhfQ/ywhx/9nySAP8GRrVAR1ECgviqd7blzn5SjqqePsBPVCmQkJARk/0+4mN1X0VvFed55FY4kekiz8FozvKevk2rWEk5b7pKrrXYAIUyh42FlsTfxa6ajjPrJXQFKb/Zg5cJs9LTANDQ5zQ4nEtD9owtheBGynRjhjdpEkPJswJYUke7zXwpmyob4s/zCxYqYsNsLhP3zBVNbEzX0dmHjM7kVKA384l5i6fDGnOplzuKZ0/fBw7k/DDFJEtMDIsnLJOPAb+inEWAfqjfMTYNNqd+PEHv+sFp+xT9ew+jtyKKXTSDcJ7Uk+M8KlBvPrte2nbHmLpj5bMkD2qnEviCK1NETG/WtRQO3CDjCvNcvXV9huahHXUB96pjmOkZLRrim7sizk3iproDBkLA22s2Vav6NNEe2O7bG4axzv1gdNYSTZNlx1YmNRJZgjmtt3XtsK5bHxO1269Trv+jLTjkE5Bh4aDuSw0W8lZGLRWJJlYn5lpzNOebWFc4KKksyEJz8N8WUxB2qPkzbO9fmhUNSEfwLgkqJdVtThbO0TTENUfiDpFOmX/p4ebPl5RNCzikYT99x02apZHPKr/iV2+6oCgeav598jEGALruWGixpFsvKzM9EzDSVl7Vj/vU0yrhtWqHzdDgIobpcK+IHvBx8/5nyDDq7lTa4ifW6hAqPaxAH17w4DafbIHwwJ8glPESplLmU1nCCkwLu14VIxwtxbd5oJeP1qkgwLXp7ttZ2OXuCpxOR0sBy3O+GeFp09LGv6IGgqxUNxjwe9okscDXpxWRlxksTNoMlI6bWC7kZPnDEfD2fynID0DujANVMOpohWuK5bEiPgWe6fRqird4m3Q3SWa
 F4ez2zTd
 gE8NZBuWStfdX8v6hq3/O5zdI6FfnUsolx1L8h/Zu0ciBQlzvRiKxSlcl1mcZg1LW4QVmVYK2vOC2IkWNXIjBzgC3CggFD5HGWZFwo+KaHvZy22x3mAPa8BputwZxVYMahaVs65yrGyrYW4+IIdJqLl9z0wYRFz8AXQxPjYKr7IQKLu0c0IjrqZXM9/YJ+XjW0XfEtJa5+p4m/m/5dhJN9e3jP14p5twUNEA+knApfkcyWEfu5qfk5nAjJlTpGGgQlnJkM7x5BYfHhZC99/4UU5SZf67bk3cw/ClGuaYaoYxVMGiNH0QyFIGrsMocp9t4mxwV5W8+RjO8FrBPq8x4pUsVLnPQQthSXgEJQwTf6RU2Ht97HtvBnZK+a5GJaEf+fkaVsBD23eZdvgh2yQCxtLvRG52TYqSIfghnDDmOJM9TpPiTWgkrBHBbHKxcKd5cPnO1qRGjY+IIm4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 04:16, Alexei Starovoitov wrote:
> On Sun, Jun 14, 2026 at 7:01 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Thu, Jun 11, 2026 at 8:50 PM Hao Li <hao.li@linux.dev> wrote:
>> >
>> > On Wed, Jun 10, 2026 at 05:40:07PM +0200, Vlastimil Babka (SUSE) wrote:
>> > > Similarly to the page allocators, introduce slab-allocator specific
>> > > alloc flags that internally control allocation behavior in addition to
>> > > gfp_flags, without occupying the limited gfp flags space.
>> > >
>> > > Introduce the first flag SLAB_ALLOC_TRYLOCK that behaves similarly to
>> > > page allocator's ALLOC_TRYLOCK and will be used to reimplement
>> > > kmalloc_nolock()'s "!allow_spin" behavior. That currently relies on
>> > > gfpflags_allow_spinning() and thus the lack of both __GFP_RECLAIM flags,
>> > > importantly __GFP_KSWAPD_RECLAIM. This can give false-positive results
>> > > e.g. in early boot with a restricted gfp_allowed_mask.
>> > >
>> > > Also introduce alloc_flags_allow_spinning() to replace the usage of
>> > > gfpflags_allow_spinning().
>> > >
>> > > Start using alloc_flags and the new check first in alloc_from_pcs() and
>> > > __pcs_replace_empty_main(). This means some slab allocations that were
>> > > falsely treated as kmalloc_nolock() due to their gfp flags will now have
>> > > higher chances of succeed, and this will further increase with followup
>>
>> nit: I think it should be either "higher chances of succeess" or
>> "higher chances to succeed".

success it is

>>
>> > > changes.
>> > >
>> > > Remove a WARN_ON_ONCE() from refill_objects() as it's now legitimate to
>> > > reach it from a slab allocation that's not _nolock() and yet lacks
>> > > __GFP_KSWAPD_RECLAIM for other reasons.
>> > >
>> > > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> > > ---
>> >
>> > Reviewed-by: Hao Li <hao.li@linux.dev>
>>
>> I would call SLAB_ALLOC_TRYLOCK something like SLAB_ALLOC_NOSPIN or
>> SLAB_ALLOC_NOLOCK but naming is hard and I don't claim myself to be
>> good at it. So, feel free to adopt my suggestion if you like it or
>> ignore it otherwise.
>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
> Just noticed "trylock" in the #define SLAB_ALLOC_TRYLOCK
> 
> Please call it SLAB_ALLOC_NOLOCK.
> 
> Initial api was using 'trylock' name and it was a mistake,
> since people assumed normal spin_trylock() like semantics.
> "trylock" implies that it fails under contention
> and retry is a normal next step. It's not the case.
> No one should be retrying. That's why the final api was kmalloc_nolock().
> So please keep this important distinction in the name.
> SLAB_ALLOC_NOLOCK should mean that spinning locks
> should not be taken. It should not mean "just go to trylock everywhere".

Eh, ok then, will change to SLAB_ALLOC_NOLOCK. Even though it's mostly internal.

So next thing we change page allocator's ALLOC_TRYLOCK to ALLOC_NOLOCK too?


