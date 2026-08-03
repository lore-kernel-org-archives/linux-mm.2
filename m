Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E0FC55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040546B007B; Mon,  3 Aug 2026 03:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33966B0088; Mon,  3 Aug 2026 03:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E216E6B008A; Mon,  3 Aug 2026 03:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB39C6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:54:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47B93C05DC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:54:49 +0000 (UTC)
X-FDA: 85059196698.23.C37551C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 927EFA0006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:54:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V+Yzn4Ef;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785743687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXJHyJVq8eSCZdvtdT9bf4WhjgSufN7PcFBzUWxZF+I=;
	b=Baog8oOIkz1hHRK9+2vcBovmoQ9mI0WqhleuFzVkPrHVc7XzvnF6UNAvr3mBXYRcRxJyQq
	sp4gH3qm1Pe6HMhAkPZbHqLnB9uenJRsWwAsrJC0so4+xWFMktKBbHu/m3CS0LhwhhY3Nk
	DziGF4NiefbDgxSto3qb1cf8JPqF0Bs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785743687;
	b=fUOo8Fjk97afuyRso8aA7Tzm6gqcn6vkYGsw4S7RMYuGkcr+A8A3VSl8EMnkY4B+0tpzIF
	FX/rHzqQThKpK/A09CwHMEJFOr8BrjqKfO3aoa/TxcrSDwmKZhR2VwyqGBD88bcfQFnbV+
	0DKQWTdFXWgO90RZGfUDXRdl9RTWWI0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V+Yzn4Ef;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFBB160A6A;
	Mon,  3 Aug 2026 07:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0111F000E9;
	Mon,  3 Aug 2026 07:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785743686;
	bh=BXJHyJVq8eSCZdvtdT9bf4WhjgSufN7PcFBzUWxZF+I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V+Yzn4Efg4P83a7IPaFwHq0PR/bx3sL1wXB9EPacsg7ju7bcAVds4YxIhmeqxAncl
	 Z3S+cLHbVXvk6+zB8y+gbUja0mrLMgKK9khmLbzMw/fBh6sIKA4VHX9N3nnd1PU/Pp
	 JrydOD2r6vjgmn+y0TgsqKyRrzVFEP1QvF4flOWZygDMG5Nb/td6OfWuNHoMf0QRIL
	 MPGpLZrbMlpWR9UkchWCTJtQCYZcrUZ7xNYniTszsRd3sbDd5MRn++3vFDvDewEZsz
	 HjZpJuWMLbx7WhMH4BZhrbtMWHI2gmLID57Nvk28Ts5qhzHNKti+/qxHocXjtrP21r
	 po2SYR2j/GeMw==
Message-ID: <c075be8b-4213-4ba4-8e95-6377986d7c8c@kernel.org>
Date: Mon, 3 Aug 2026 09:54:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs: ksm: fix typos in sysfs knob names
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
 shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
 <20260731083526.3953421-2-tujinjiang@huawei.com>
 <d9236dc0-3332-4fab-aa26-e74d10ad0cda@kernel.org>
 <f1f5c486-f14c-44ad-8285-a9df437f7974@huawei.com>
 <3066dc07-31b5-48ca-b14e-51b284bbb9e1@kernel.org>
 <fe724e58-f525-4eee-9471-d1765f6bdb0e@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fe724e58-f525-4eee-9471-d1765f6bdb0e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 927EFA0006
X-Stat-Signature: 4zf4h7u6oyndr4tuom9n1md4fzrnt6cr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785743687-326371
X-HE-Meta: U2FsdGVkX1+JiCmnlTAbonLOWKN8ONAlVM6Tw8n5zNQzpMWH+jpxNjEHbDLcueGFZnaZJJjxVN8Lz6cyEjUYKDqS2r1l8Fk5gqBHayWIdMji3cRut2TMIpGIE6Hs3Ywp5FNFcUKpa6IA2fSRj5DS5bK3+0ENndnvywW3L3ByiTdSWPd8lWs8IxPCYfzA7OdEJ01D5uMoZEIYm0y7MufIyoy/jDHku6VHRmcTPz7JJS/ksk6yZ7QJDH4cGBsPpt5YFtUhWSXc5j2OlOfT2OSabsSnSii588lN2DujQ5qQGJAygkIo3HzQmKpEryxvrAEnPmNfdQs9KyZ5wR+yGjwf/Mo6HKMRCJYhiJH/6d0fflrRxnOWJ3O9sR8kGLJuquyjSQD8s3iJRMyFk+A3HvSp+D/Uy4yJuRtYT6Athywf4wmaEJUeCIR/oEg6GH0voe5U8o8IkySvBk2gS7uCNhukcDA3vwFSNrrLpkXbTqRLytBRwiRXkE9f/KjsdsO6o7ZJf+f9lgihfjgWsx0+/1DKZiuFXS/YGHQig3Gq9wx+vKdseFbNMgr1RmQ1ODPVWfFiCUYF/S1/Yil0UcGvhCWQm2giFPmicykPKVdMnAOdjAI033g3X2zMcONXzE9crJlC0s7op0iMt/YZg68IpoE4Mh44YoGkHTseH++mIYXpNh/czvb8vxspJw8dzL4SO2q3eadEKsIVM1Q83+GsiMNu3q2zSMvTYbKFrgvKukYeNL5L3DHlaMOeHrSax1edIIt6ZuuUDNBdMI84wB59nQmrtxK3vDV+fHKg5UjNO7ksbLPcgB+heGeqZK3dmvsQfwruIJhtkGtSLYDmlOKoUQAcD5iAi03su0lo9bHO1TLjpAVVy7u4pB+OL9X6/LfjYUHZjGp0aXAIY6gnav7vSZZlQ4fln0uXeRdAZS+UCGqwmIYSs32DiwU60bLjZ2rPMqDQ1AtoqW/BDj6Ij+/CPs/
 NQU2EZr5
 a1VHbPY+t++V5t5HLPeHP9tMu6EXI8UJX8Il1IySeW62QcCQEgmIWywyKQ43PZ/M9+QiUtYn230uwf/2p2omBlRgckcDA8/g+daoKDMrzMPSc863gsD2Fw9AiCDDl0hVCMhrWzgt/TRUA29O2XVbbX6W911dXRCcobPGvJWDTs3Yae0zhwlohCX+wrxK+hqB4ee+4p3skInLOwfpu7iwAxB7HbnRa8aU8WtoEwateDn3xWOOPP160jrFSfJOy5buKFGLeryVeEQzuCb1XIJ91ufShaWDpdvRTjZrQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 09:15, Jinjiang Tu wrote:
> 
> 在 2026/7/31 17:25, David Hildenbrand (Arm) 写道:
>> On 7/31/26 11:22, Jinjiang Tu wrote:
>>> 在 2026/7/31 17:11, David Hildenbrand (Arm) 写道:
>>> git log --grep "Fixes" Documentation/
>>>
>>> Many commits in Documentation have fix tag.
>>> I think both are ok, since documentation changes are needed to backport.
>> What? When? How? Where?
>>
>> :)
> 
> These commits only modify Documentation/ files and contains fix tags.
> 
> 0c13ed77dd2b Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
> 0beba407d458 Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
> d7f00084f686 Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter name
> 652e1a51465f mm: fix docs for the kernel parameter ``thp_anon=``
> 14e70e4660d6 Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
> da2a06188888 Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
> 1beb8ae302a0 Docs/admin-guide/mm/zswap: remove zsmalloc's lack of writeback warning
> 0ff11f103f5d Docs/admin-guide/mm/damon: rename the title of the document
> 465d0eb0dc31 Docs/admin-guide/mm/damon/usage: fix the example code snip
> 205498012513 Docs/admin-guide/damon/reclaim: remove a paragraph that been obsolete due to online tuning support
> dd21bfa425c0 proc: fix documentation and description of pagemap
> a8db400f997c memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path
> d83fe3c99d27 memory-hotplug.rst: fix two instances of "movablecore" that should be "movable_node"
> 72a3e3e25a51 docs: hugetlbpage.rst: fix some warnings
> 8867f6109b84 docs: fix numaperf.rst and add it to the doc tree
> 
> 
> But there are also commits don't contain fix tags. Such as:
> 
> abdca14655fe Docs/admin-guide/mm/damon: fix 'parametrs' typo
> 78a00cac1e96 docs: fix 're-use' -> 'reuse' in documentation
> eb14b12c8c22 Docs/admin-guide/mm/damon/usage: fix and add missing DAMOS filter sysfs files on files hierarchy
> 472098f23323 docs: mm: fix the incorrect 'FileHugeMapped' field

That is not what I asked. You said "since documentation changes are needed to backport".

Who backports documentation fixes and to which tree?

We usually don't backport anything unless we Cc: stable. And distros don't generally
care that much about documentation backports either.

-- 
Cheers,

David

