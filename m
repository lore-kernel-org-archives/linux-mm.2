Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AD3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E1B6B014B; Mon, 13 Jul 2026 12:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E9A6B0150; Mon, 13 Jul 2026 12:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E5B6B0152; Mon, 13 Jul 2026 12:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D25F6B014B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:43:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C316C11B1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:27:21 +0000 (UTC)
X-FDA: 84984132282.23.E46E888
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5275214000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:27:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=alh2lfRH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783956439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGM+htLZdutLBDNc5mxxfxxEn2ZysJrfQe8Dn9wLtck=;
	b=NxnU2tQ/TRDq83EGY27alM0FbqdHK5fHZzCB2dR7EpCXAxV6F+WsN1+z2DgP/PTyyEHq9Z
	XVx2eXO6QoEShRGMpFWFKy8mhiPKqoDRCY89XnFwfCqSNmTUVyUmdq4LDFrI+XkqNsYLIf
	IzoNtVu/B/cqw1GmoliTM3YUceKUw48=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=alh2lfRH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783956439;
	b=KDNe9T5BHFMlmdc0BK7uW48FaPaWTLLG/cUBhDyfhS3DbVhbomg/11I+OGpZ70o22wQt9S
	b/KXr4hbnYMc8wjkYsOhYcBHxhDyVHCHB4hBTqEGbVL5o8qYerXi3AOp+iHzVYBQ26EhdS
	D/XiYeZbgVa8tbjwJpovwWUWsbbN/kM=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783956435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BGM+htLZdutLBDNc5mxxfxxEn2ZysJrfQe8Dn9wLtck=;
	b=alh2lfRHVG8G8NevS66Gh7NDLWFYdbGR4+mqA2vynLl4THE6uFGrwsXygsFfBygmV6YUXa
	WUoAq/SHdFGJORCQFJtr6nL06Pee0SemWQfYZSu5viQC6QK9WygW+I48pL+STkIv8o2X2U
	v/8WZw4g2hHSZMLlGjkFe0nEJNtqdw4=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 15:26:48 +0000
Message-Id: <DJXJRNZFBPQ2.2S6CM4YAKHVQ5@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>
Subject: Re: [PATCH v5 13/18] mm: Remove __alloc_pages_node()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Zi Yan" <ziy@nvidia.com>, "Brendan Jackman" <jackmanb@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-13-c87b714e19d3@google.com>
 <DJP0VKJLE8TE.6EDLC2BFI1SG@nvidia.com>
In-Reply-To: <DJP0VKJLE8TE.6EDLC2BFI1SG@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3geh4138xkuc73uyuiiyydftm3jz8bzf
X-Rspamd-Queue-Id: 5275214000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783956439-205751
X-HE-Meta: U2FsdGVkX1+EhKws8yWMoXkniyTSdM4YuSwF5e1nJXoINnsG3FiWBrIz0bmvTU77J6RhWHqRBt7zeUHqCCIaQQyolgD8TYxZUqLVfWsfmGDDKm4uUmPgVLFFzFscu7JTJO+SIE+hqeVj/AbDDl7RxaiXmpvYhnN6nymrxcpur1GHDCP081WNTuMT3HEc7yUWJgCp/l//9ZPCNlid3EToaKmqmP0lwUcb/0V2TupwsEeKighhQ1tlzUkW0ZnWIvx3LeyZljioa+MdxClqOXXa9aR0cZ4xedx7OHPpStoPxTvKh8TVi7SYQaSKv9ZbXfOQJPP0z6LSgHUmkbeoAUR6oTAMa9Tfahk/zVkqDajWpw8g92WZN5dZ2cXoIqCqCKCWlNbE9sWnUk/k/hsRQXxN0YYl7cdk2jhP6vMbac4qTPZZ3wilqqUbqb98wjWsWxoSlaZhCOAziCBfYoC38CKV02e8Yrp3QNMDDTT5aBUkV0tW5ze/06VrNfpB4idcCLubLpBph1tqdlfT+XZWbkUKP+g/yZAJAhFN0HqIgMl7XC67rOl+OW5OwRiWrSlWm8YvPhIAXHIZmTVirUY0xt2uSstJT5EggtG84g3N9snQ4zj1wl4sZUS7L9J5FBR8qnvcmStu8u0M+4ccIcBVgde8Mmv2gV+xUwvkOhZotK9InfecHtzUiETZgDmt8xybkqmbX6MGkTVIsOFKR6gX7fip6klgb/FtU8Uf8D5PjcK5aLmv2TLMlJfGik4f+gkN2/AVxBAt2L/ML/7fzhZIfsocZN/T1SgacBClRFBm1Nuko3Du2At5fzdSdoVnthSwoh+sx/jRBTLg2tVTgCnz9utwClLem6cHC1Zi9MMpU3dzrM/GZHsGuIK8dtceA73Ild5Y3209Faht3Qnt2v/rqCT2arFa5UeepOYqZ3CSetWVR0p5sfd1mTYRga761aCs5EOFQJQlhCpp6jy6GNBnZZo
 SRoE9NIZ
 5bscfthmgqgGqNzTLek4SCaQHxqNI8++Sf4y9L0uP4ZZ954FsL5Lm4RsiCXD+ELzAXuFSsBRDt61XFE/5EkREVJIdzi20TFhV+BVwclTDFmDeZWQxh68wvq2p20wXG9JTMUFI2RvxT3MLXgkvmMc1Ftub0M/cESWnOk08ONQlatW7q1xTKNJHP8ZTLtuF3K2l0H55wplLxnmCj9yHv7a1Pk/GjAgTsKF2fRyywljTuA6skxIuyXHTMR3vmqS6dHCSHt9a6M9fyPS8eaV3sMievj0Lzj0NTfFTMSlIjpHPUTbcVlVBdDA8Cgt9oU876YVci1Jzh7bUts8Oy05mhT+v54u0m9/etosVI8rvIfftWSc4l0qLFXbUTSYc64+GD886GiEtJaTdDIIIK75RWBy13F8xdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 2:57 PM UTC, Zi Yan wrote:
> On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
>> There were only a few users, which have been removed. The only advantage
>> of this API over alloc_pages_node() is avoiding a single conditional
>> branch. The disadvantages are:
>>
>> 1. More API surface, more sources of confusion, more maintenance.
>>
>> 2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
>>    were using the result of cpu_to_node(); if the CPU gets hotplugged
>>    out this will return NUMA_NO_NODE. If one of these paths fails to
>>    protect against a concurrent hotplug then page_alloc.c will use
>>    NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
>>    memory corruption or other. With alloc_pages_node(), the code might
>>    just work fine.
>>
>> Ulterior motive: this frees up the __* variants of the allocator APIs to
>> serve specifically for use as mm-internal API.
>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  include/linux/gfp.h | 20 ++++----------------
>>  1 file changed, 4 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 01d6d2591f49e..3bf55a5f9143e 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -256,21 +256,6 @@ static inline void warn_if_node_offline(int this_no=
de, gfp_t gfp_mask)
>>  	dump_stack();
>>  }
>> =20
>> -/*
>> - * Allocate pages, preferring the node given as nid. The node must be v=
alid and
>> - * online. For more general interface, see alloc_pages_node().
>> - */
>> -static inline struct page *
>> -__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
>> -{
>> -	VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
>> -	warn_if_node_offline(nid, gfp_mask);
>> -
>> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
>> -}
>> -
>> -#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof=
(__VA_ARGS__))
>> -
>>  static inline
>>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, =
int nid)
>>  {
>> @@ -293,7 +278,10 @@ static inline struct page *alloc_pages_node_noprof(=
int nid, gfp_t gfp_mask,
>>  	if (nid =3D=3D NUMA_NO_NODE)
>>  		nid =3D numa_mem_id();
>> =20
>> -	return __alloc_pages_node_noprof(nid, gfp_mask, order);
>> +	VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
>
> Could this become a VM_WARN_ON?

Er, it will almost certainly crash later if this is violated. Personally
if I'm enabling DEBUG_VM I'd rather it crashes with a helpful stacktrace
instead of chasing random poihnters, likely corrupting memory, and then
crashing later in a completely undebuggable way instead.

TBH I don't really understand the "don't BUG" culture we have in Linux.
I usually just go along with it coz it doesn't seem important enough to
argue about. But now I'm wondering: if we really don't like VM_BUG_ON()
why not get rid of it completely? I wonder if there's some case-by-case
difference that I'm not picking up on.

