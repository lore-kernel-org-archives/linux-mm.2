Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E6560A381D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=juZk+Boh
Received: by kanga.kvack.org (Postfix)
	id 0CA7A6B05B9; Wed, 18 Nov 2026 10:38:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1536B05CE; Wed, 18 Nov 2026 10:38:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D446B05CF; Wed, 18 Nov 2026 10:38:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCF406B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:38:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33D8C1C41FE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:38:15 +0000 (UTC)
X-FDA: 85448646150.24.98BBEEA
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf24.hostedemail.com (Postfix) with ESMTP id E8384180005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:38:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=juZk+Boh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMWtXfOrBMUlXo3JAA8nnmiVWIJTNT38o6/ayrisqnY=;
	b=BS9mq2YgcDXI25Gtv4RWFhoWdiFohCpLoUErgf4H7Lc36WL3Vo3jDDfbbxtS/awpgQ+T5Q
	jHu4xOA2DbPmaBkwzIy7G9fj5BLaJPjGNNr/HKU3okhsmz/k89wpUuf9Ypk7GDqF9R1VtO
	9ytnKEVCyvDre/9gLN/jCd2TOO+ylvs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=juZk+Boh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016293;
	b=ooFcsiPiuFI4LJ6l+/wSj7vbAQZk+qao9d9b+apdjhtNlPilTno+Ae8/Vbq4dG5G723sbo
	qk8iHTYwmEzG9OL8mvuSHIzTMajyUantVfyHtIKE+wZthITafMj0MEW3ibaO9Is4JCMdsu
	sXxw54D4+qzpUJqrBMgk6AMVYqvJWLg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tf0h0de4cYP6cKKbFkMbewM2Fg/9uzvPBvnWQQYHpdg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795016291; v=1; x=1795621091;
 b=juZk+BohpBKtZxmXEqY9oZSjFzYWzOUsKub/zu36mdnJ5CdFfAhwRmSemFjcYqd23Hkgp850
 80MfpW9+CzlGXe55dimQGW3ZEurB0gtvPtXxY8s9Nt9I4OOURjh2dRhVwdwQH+nnG/CNgzSkn37
 YpUS+z5h932+VR58utuYRec0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dbede086751ede28;
	Wed, 18 Nov 2026 15:38:11 +0000
X-Mizu-Trace-ID: dbede086751ede28
X-Migadu-Flow: FLOW_OUT
Message-ID: <2e9faec6-9152-40ec-8c63-f262dc26e059@linux.dev>
Date: Wed, 18 Nov 2026 23:37:57 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for
 SPARSEMEM
To: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Lu Baolu <baolu.lu@linux.intel.com>,
 Pranjal Shrivastava <praan@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>, Mostafa Saleh <smostafa@google.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Sashiko <sashiko-bot@kernel.org>,
 kasan-dev@googlegroups.com, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Chris Down <chris@chrisdown.name>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-6-songmuchun@bytedance.com>
 <avzsFxVqO27Vf4Db@chrisdown.name>
 <3C50E682-848F-4788-9238-923D5E292DEE@linux.dev>
 <av1M9itGiTF1Akqi@chrisdown.name> <av2zkUpYGmGWPx8T@kernel.org>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <av2zkUpYGmGWPx8T@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E8384180005
X-Stat-Signature: x4bpgc7akuobzqfj8z3k3fguf3zzdn4p
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795016292-834260
X-HE-Meta: U2FsdGVkX1/gRsIn5k5fTRzIQjWSSvUN304lZoC8deiSp/RbweGAuKLNJo2Aq1DWg8skPe0CtaowgZ7g03BnBVwX1a9tnGrWpNrtbKOrLtCzuRrFnTt09TMzn7Pj2OzNiBNDkqQXTC+eKKqrJ4aAIZ+WZaZCj36gpgAeRc3H4xiDku4KSt7P96F7V7IOXcdndCjK2YoIf22M7KOrXXDPgPb64/nbH74GsY4hYVieqP4qzEVqccYe33G4H1tnd8OcIJJgaMr9Rny2pNSMsZJSJG3C6bJ7NkghLrf43OP8wgYjvIQpUVpuoXa9qoT2zzMQfWtrS86UZKRgrtBD23Ci8VQzBlz0Tsv2+zaloMuoKHbVerMgBLw+iLf6SzLJqQI5o+1uCG0WAmusfet9aJQD5aQoygLFIAzSAYBcc0fnZ7GK0SV0RkHbBu79H0sN8rOsCRkBx1hm1L0QwhcW5ajJkp5t1CdZ8oQJiIZ84sW19Ces2FnCTXrKT/pTOpBKWWJrLFlkBx45i6jb65s0acgo/Dc8i6eMP3j9NLrBA0gkP6bKBx7u/0ZQFB8ymuL6giNJp5bhmBfOayiAMJGUmHchu/Br9OeAwxW+6fGXKbOVyC8kjo1+3/JAj/7ldcqIhZ3WO4IH9+nBgD4md3fNxP8nU6m2OjrMsQ9/Ccxg+j/oThOV6vwfuPEDrFdXqElmUj1ZXeGEiJUcbpJJUAXH3CL7hx+1oQ9rdz++KXQujlCFmh3PHJ0vrnOgw+XaeqbBssGqtqtUDyrX3s9G58FrGR4D+kVMh0Nv5zVbs3p89lxBr/ozu2J4M+HxWe+VhgvzsyaT7yepyVnTaa2aKDUeN3K2upANuC6WaarNT4gPa9k9gob5x/k75n9VBTGKJMIos/HbJ42oNEWzt8rCuIRVhFXvUYKIUhC2s329W8dWucb2m7hsMa64kYcLVEuIyZiKUze6MU1smTxR5m2bf/p4a1H
 i27bbS2I
 tWkkB1qaxibMbmoXr9WYz4zfFCh/kfoXQDmputg2d8QoBSdqJzeonMj4vpzP6UPDALTMpwbW0Lvk0PjzwhYxmj3eYXfKoKADMH0v2PUDEtEjV/0XZc//NeedL3DPAfzCIFZTn1onFZxpTMEB73+dMwJjyvgFj2VaflB1nr2+bGohfIZuelDKHJT7by3alyllkEkVOks/ZNf7jLUnD/o+LLUk4pVacek7nK1XpdNyHft9WFCJuLqnRnGOToxz8mu/kmubFpQPUopwJ5DzfeGekavUMouZEI2oWLt/lSoNMn89FQDNU//MIVF8dnG3HXDBnVLkI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/18 22:17, Mike Rapoport wrote:
> On Tue, Nov 17, 2026 at 11:00:06PM -0800, Chris Down wrote:
>> Hi Muchun,
>>
>> Muchun Song writes:
>>> Mike's suggestion considerably simplifies the code, and early page_ext is
>>> only needed by optional debugging and instrumentation users. I would prefer
>>> to keep this approach.
>> You're probably right.
> I think so :)
> The memap_alloc() that essentially allocates the memory map does
>
> 	memblock_alloc_try_nid_raw(size, align, min_addr,
> 				   MEMBLOCK_ALLOC_NOLEAKTRACE, nid);
>
> so we anyway may end up with reserved memory in ZONE_MOVABLE.
>
> Until recently we had memory map allocation before the zones were setup, so
> there wasn't much we could do about it, but ...
>
>> But can I cheekily suggest something in the middle perhaps? :-)
>>
>> Given the zones are already set up before page_ext_alloc() runs, perhaps
>> you can pass the start of the node's ZONE_MOVABLE as max_addr to
>> memblock_alloc_try_nid() when the node has one. The general idea is:
>>
>>      struct zone *movable = &NODE_DATA(nid)->node_zones[ZONE_MOVABLE];
>>      phys_addr_t max_addr = MEMBLOCK_ALLOC_ACCESSIBLE;
>>
>>      if (!zone_is_empty(movable))
>>              max_addr = PFN_PHYS(movable->zone_start_pfn);
>>      addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
>>                                    max_addr, nid);
>>      if (!addr && max_addr != MEMBLOCK_ALLOC_ACCESSIBLE)
>>              addr = memblock_alloc_try_nid(size, PAGE_SIZE,
>>                                            __pa(MAX_DMA_ADDRESS),
>>                                            MEMBLOCK_ALLOC_ACCESSIBLE, nid);
> ... with zone extents known we could take it even further :)
>
> page_ext is treated as the memory map in many ways, so we can allocate the
> early page_ext sections with memmap_alloc().
> And since the latter always runs after zones are set up it could include
> this change.
>
> But I think this should come as a separate series that also could move
> memmap_boot_pages_add to memmap_alloc().

Agreed. Using memmap_alloc() for early page_ext allocations and
teaching it to avoid ZONE_MOVABLE sounds cleaner. I'll keep this
series as is and handle that in a separate series.

Thanks!

>   
>> I briefly tried that and it seems to work quite nicely.
>>
>> But I don't object to it even without that, so feel free to add either way:
>>
>> Reviewed-by: Chris Down <chris@chrisdown.name>
>>
>> Thanks!
>>
>> Chris


