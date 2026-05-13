Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85FECD4F3E
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1DE16B008C; Wed, 13 May 2026 07:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF326B0092; Wed, 13 May 2026 07:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C969F6B0093; Wed, 13 May 2026 07:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B57D76B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:36:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 806A4140819
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:36:55 +0000 (UTC)
X-FDA: 84762194790.22.AA2DFCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C4324A0009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:36:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rjvhZCn+;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778672213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QqB1afFuurILSaLvW+gd+SdLlRwCXJ25aBI+TE0XNg=;
	b=gRSSAPwEDvC8Hx9WIneNOb9AXtbNBkd3GsNLg2DagjePmePLZSwSWKdTTYI5REfqXxkUE3
	VHMB2Aet2acgbOm7e1SITCStZdP8zWoL9np8O1AouEc6XJQrVnmLiHIpR6cRwPjJNGnE9k
	uMmczl2dyioExwUeGPpkyi/Oym9E690=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rjvhZCn+;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778672213; a=rsa-sha256;
	cv=none;
	b=ZGMDXrwV9h7T66o0TgURRb5GTOuy96KPmrnvJajP+x0MuYEvD1RdCe6/jR4EB497Rl/CAr
	/ejXdRZAMtH2lYywsh2KjqlnUcOY/A7hxMMhDx0S15AWhzwXLRaaBkIESAHiLfgruG4LGL
	kmBlgCeSQ+1w+L0yhDLOKAv51JUv2/A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 099E8600CB;
	Wed, 13 May 2026 11:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA3AC2BCB7;
	Wed, 13 May 2026 11:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778672212;
	bh=2tHDcgBhOPqCxLRSH0z7aiqpxuZha9FjNCPAxIgFceM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rjvhZCn+OILCOcPitf+xlGukPANWJrni1RXlRxJCk5OMAi5L55NTTTKbSCQa6Rv7k
	 1SHhFoasRhjslQ0LmtB6xGftHLBEuUuiGge+jqLJ4imw52X6Ab4zEY9RaDSfdyOlj0
	 BYJbONskSA59FBV1yEHKMHNOfqQ7wPTHrXNw9rOGTuMJuTUogPN79k7Zi+P5CFVl2f
	 Paa+zv+4FTCwpRaTJZ8cr34FsSct1gtU1p6PqDoA4cvj7xwg1Z7GN+QVgD/wuf0kax
	 FDw1zeuOJ1morPSGBohUzET9BzkyGKZdTiwDSvo/YDIN1GUIA+twQnV0bIMcoGDF1V
	 glyYROEm3Jjeg==
Message-ID: <d7cc273b-17a2-4b5f-af6a-0dc708c8cabf@kernel.org>
Date: Wed, 13 May 2026 13:36:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
 <1ce447ceea88bbe56c7d28654a51fc2856a7f986.camel@linux.intel.com>
 <65596f86-e6a3-48b0-aa3d-2e608964e29d@kernel.org>
 <c0b5b94dfb4d04a1319bfb110f326afd2c29d48b.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c0b5b94dfb4d04a1319bfb110f326afd2c29d48b.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4324A0009
X-Rspam-User: 
X-Stat-Signature: dt3x96kdpaqofr38u8rehjgjxe79midg
X-HE-Tag: 1778672213-354502
X-HE-Meta: U2FsdGVkX18KLqSFyXmLuxMcwMHrNavJEU1qaleY+uGlgjoZQ8NQWPUeHm7uNDLJCxNzN+jdKNSFvlAh32Ca7GU+aDRuQHGvdUPk4vZXoq5eWkKV7L8KcV3aSqfHRmhtqrC9wZtkT6Kr3VOvEBwOi8AAzcxYaHmEEwBIqx/RbjDZJFYtzhOkKGjSGDucjo8GqmNpBJJs+i2KJIxAafWesyt9XKibA4MwGlqu8UFcpnpKeH7gE3W+KD0/wNuT9wS9MKt6tWyIneJYSTrq+SP2/HS3WzpwkgDYMdu8gsMOvp5q9ty76JRvX/+PVCpXXkdGRduvbSoCQRQVQzEuOakzjtGUQl/he+HKnfI/xFbuiAVhPdtPWRTo35355MlFZR/ejVs3eyVfgAcTIkTdggqQ0KvcxlL7ZgXMuHc18subVzrK95PhSPHVdHd1CT+y2Pk8azTEo1HS9cW1JIqsva0lpef2EVtamYpVVyHTfaBIhxPtfhPYXSghFP6BC1CgzgnF8c0MYq+9GMCj18ApcRGgH63q83EeQcYsNw3lZfvoIpGNsQf7e3M++CPStF6evvuH51pft0LbqwiMXjBfzY+RiiqlTS3P6wb0gzpNRUZx+Yax8y5Ib7Nt8fQr0RoCB2aR1gxUN3KGKmFk7XlgnjO9JBO99LCM7fLClpalHJWMacGdp5jxOZ3eapF6V1p93zxbXAkWzVsHVjDIo8x4Brnt/m6LKEHymJxQxovDAFXahXblMfEWUznSf8buBkbLOJu6nrGg8tk8iBJwWtzCgs9tB9zKdCrpDqb61nmHeeTuVcDn+7WcRpuW4VCtlaig3gqCx7/cRGKVkjZUzew277IincKRshkAJ86clAbamX+udZAFap3JEXGPiGn4fY6YMx+RpavJnMnaKO81HFAPCjWmQ4Lonf8Fz2MQtHR4epHWGLq+cLrtH1DfbNJT9/5YRb4SOLH8p98281JEs5uBkA4
 lc5HOD/n
 vE8GPKO427dRXMU3kWS6xyDYV7PG2HmNgoINThSiN2etMBpSjh8djTHMlImrgJPdlGg9bS83mgYAfvmbIK9LrD47V1MGH1bAZpEzX71dFc3PfuywituRj7k2L2ZmZN5V4ClBiYytFmVtSXfMvRiekVa/530+7mBkWPGTlBAwPGruwgPFRiOY4SKFEqwbYgZuGq3HH7ZERmMFrm2+sya+mGT/jZRle4CGi8CUnqIHhAfhWwxGQ6YMwvPBQEKzg02McpSW4PTQ63Uh6n7q7pHJtH6o5KXBhk2h/uF2AEOjQZ+DaRnQLdSxCDRNLBvKDm2IyEpehNSKWspQ83ii8abjBR5FGwcd9nEJi5gRQufDA+vv8u6YqslDRFfDzal8CUST55he/lUHVMmlsxjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 12:37, Thomas Hellström wrote:
> On Wed, 2026-05-13 at 12:03 +0200, David Hildenbrand (Arm) wrote:
>> On 5/13/26 10:51, Thomas Hellström wrote:
>>>
>>> FWIW, the i915 driver which uses shmem "natively" uses a special
>>> mount
>>> here that gives back THPs.
>>>
>>>
>>> Currently the drivers that use shmem in this way use
>>> "mapping_set_unevictable()" as long as the object is bound to the
>>> GPU.
>>> Then shrinkers can unbind from GPU and revert that setting.
>>
>> Right, but mapping_set_unevictable() only affects folio_evictable() -
>> -reclaim
>> behavior. Not other properties (such as folio migration).
> 
> Interesting. Does that imply that a shmem folio can be replaced
> underneath without additional measures? It looks like most DRM
> call sites imply that mapping_set_unevictable() pins underlying shmem
> folios

I don't think there is anything preventing folio migration. shmem implement the
migrate_folio() callback simply by wiring up migrate_folio().

However, any raised reference on a shmem folio would prevent migration. However,
taking longterm references on folios that are allocated as being movable (shmem
default) breaks CMA, memory hotunplug, compaction...

drm_gem_get_pages()/drm_gem_put_pages() seem to handle some part of that ... by
grabbing/putting references.

So if DRM actually might hold these references for a longer time, I suspect this
breaks CMA etc..

We have the memfd_pin_folios() interface that takes care of handling that
properly by only allowing longterm references if longterm references are
actually allowed -- and otherwise migrates pages to physical memory areas where
longterm pinning is allowed.

[...]

> x86 implementation is here:
> https://elixir.bootlin.com/linux/v7.1-rc3/source/arch/x86/mm/pat/set_memory.c#L2556
> 
> TTM calls it here:
> https://elixir.bootlin.com/linux/v7.1-rc3/source/drivers/gpu/drm/ttm/ttm_pool.c#L249
> 

Ah, the calls to set_pages_array_wc/set_pages_array_uc.

> And there are actually shmem helpers that do this as well, without
> pooling.
> https://elixir.bootlin.com/linux/v7.1-rc3/source/drivers/gpu/drm/drm_gem_shmem_helper.c#L212

Thanks for pointing me at them.

Right, after grabbing a reference, the folio is unmovable and we can modify the
directmap.

> 
> 
>>
>>> That's an
>>> extremely costly operation so TTM needs to pool such allocations.
>>> That's where using shmem natively becomes very ugly, because you
>>> can't
>>> really use a 1:1 mapping between shmem objects and DRM objects
>>> anymore.
>>
>> So you would require different caching attributes within a DRM
>> object?
> 
> The way the TTM pools work are that there are separate pools for each
> allocation order and caching modes. That would essentially mean
> allocations from a single shmem object would be spread out across
> different pools, and we'd loose the 1:1 mapping between DRM objects and
> shmem objects.

Right.

> 
> One alternative would be a single large sparse shmem object common for
> all DRM objects, with a range allocator, but that also got pretty ugly
> when I tried to implement that.

Does not sound too crazy, though.

> 
> Finally, (and I think that might be what Christian was getting at as
> well) Without CONFIG_TRANSPARENT_HUGEPAGE, we'd only see order 0 shmem
> folios, right?

Right. Because large folios do not exist in such a world. So this is expected.

If you don't set CONFIG_TRANSPARENT_HUGEPAGE, expect the system to have bad
performance.

-- 
Cheers,

David

