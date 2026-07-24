Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6DDC53200
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E506B0088; Fri, 24 Jul 2026 12:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315E86B008A; Fri, 24 Jul 2026 12:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204356B0095; Fri, 24 Jul 2026 12:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E03E06B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:52:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A0478032F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:52:05 +0000 (UTC)
X-FDA: 85024262610.03.A5B411C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C66FE40007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:52:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BnN5DFd3;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784911923;
	b=o4lfE6Xqbn6T6qArbkTpwaztO5LuuHOQQMUa0nM/Z941FNtHRnXpZDtx8N7Rvp49zvw7AT
	EIKFCeqwQkK4LNIdYoanneI8oOIf2SuZ4s7YRgZdI49QXMZhTXBExddup/tIeEsyOu7VQ5
	AGHsE/43hYryR59MQVvN/rt4fdXKQhE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BnN5DFd3;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784911923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ngNj00jBqy/OPE2x8gfNCz+K4mGYeO4wn+LIqAYX40=;
	b=rn/f7s+du1dZ8Cl7uqkbVqixb4Vy8aAjxTVx30h3dioFCFMYnHuX89hm6RxH5u/gH6jYdL
	x+k9iuRDqn/KHU9f7+ydBtW1kZoTkypzF2h+zDSbP2YNvfP1rGnyVy6yFhvw0iaXQ7g3vp
	XQm325X0WUpG8qHpyCHMmgPkmxU1eGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 275D3600AD;
	Fri, 24 Jul 2026 16:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F5B1F000E9;
	Fri, 24 Jul 2026 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784911922;
	bh=8ngNj00jBqy/OPE2x8gfNCz+K4mGYeO4wn+LIqAYX40=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BnN5DFd3+HUO0URnrf7glzg2MxJZ4hQc/rAx0VF1TTyw4cWJf4M+zPfDRm0K6rgLP
	 D7ZXKfEo0rwOlqwS2eEjwp1k1PE8liEVNI88xmhFIqyM0f7k5Z1SEleH9wmDmEKC4E
	 NQGU35qrnod7x9vxPDibBlFsl/t8WFgAb/GlB8cWE7l9UnUc2hWo/5miGU1M2PO1O1
	 E/8+wsMAocXb1giQzlW8vq1CR7ycV3LNp8J2cX28vduXhjbD3i8GIemLb7hidgS4JP
	 yncPIynrFhezOSH6SSAu2kQm7KE+/aB0MbG9O04kCOVlr6jM51HADEev3/hIoVajQT
	 IUXF5ZA0g1l7A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 19/21] memblock: make HugeTLB bootmem allocation work
 with KHO
In-Reply-To: <178410811939.820181.7248948033992831535.b4-review@b4> (Mike
	Rapoport's message of "Wed, 15 Jul 2026 12:35:19 +0300")
References: <20260709173821.429921-1-pratyush@kernel.org>
	<20260709173821.429921-20-pratyush@kernel.org>
	<178410811939.820181.7248948033992831535.b4-review@b4>
Date: Fri, 24 Jul 2026 18:51:59 +0200
Message-ID: <2vxzo6fwgwk0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qh9z6nhf3ite9hocmb7oh4f4k6xwoinc
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C66FE40007
X-Rspam-User: 
X-HE-Tag: 1784911923-382602
X-HE-Meta: U2FsdGVkX1+mOxF19mAR0cGJc14SvZyYPCbSkCKro6x3ss2cPQW8Eezq+Uzd4RNli+zROEQvryFlTgUouU2JyqelmBovo27utEEi4J1dmMkGIKkC1TqnSnyvjOUc8VulLh6PaUeV624lNcMZqnD/Qo0OqRomFnaGmH1D7oF8YxV1IGvzQWwEJgE0hghOexxU2mneO/derquq2qL0J6X/QgE7DumX91uGWv0M5WhnMJtVTGS2mHvAWTCobGPEgk81vWQdh7b9XyWjcK5CmtAfNGgpr1k0a72CXc4lP/MY8HdAzsu1tVnj6dI8FigMsfinp3+AED9Eg2x3Vl21i8mB333F8xIl/AMy0hWYtuuS2Gf8Fcam68RjWI0QKTn2IpLogIaL6lvs2dlRBrd0Sk/RqntI4ViPEOrCNi2QenqAWchYvYp3a7lfFNJ9r12YwbyuiJBGSQ2ihItKFttsO1GJUk68hGVAJhpzuwoZtxqExTrGDxBArRUXuRaMq8l8xUsnsCEsh6pm7Ob4cI7vwQmU+Ng5RatDFhkHyuGbohFivG001gMRsghJegcKRoeR9lsRAc33tWKKJ7fHpIjZ/1T2Re0S/XqdFdTcLTCpUcS6KkCwHFvNuzpWTKNgfo9rjUh6LU1oNe7Lv1CXEcT9m6ABk+1G5z9TruYjubDEpRI0URfR37CKj2Cj5QwQzck346Y8bD02pIXJm6u+iB2x8NgEANDBI659A/yHEYW//HffeGkcfXylgzRxWCy5oU7a5fCxcwIg60ifHklZNPbT4WKos82Po9KdHcM0JTFrtdl62qgnAThmDTmguW7mObzHigT/QAe/kJrvfOmqv9g5ngMef92uI4RhzmuYZwjn3tCBVjJhnjvCstC6r9nlgxiH/bpHkqm/mDQAx2vAWl/ZbV3QSI2CDFhLCJU1AkQ+fr7ZCxaF22CpUuI+XQP6QtSnRwd3ykdXhHEccT24nb2clpY
 beCmp6nv
 JDYMFvbPISjGDOZGdokcQ1eUbqRQQKYLNcqf1V9v8d4FviAuMv2nLXMmwEeG7FnQEFoXqf0E0czlu+RdWx/hxZVJIGJwWesG+1UBmGLUVCcgNr6ya7YsMOc1pampk40I8WUJvgUJ/DtSvnideRhCnLsvujTZZVpHPrmn/dgmxGCkmVcC6HlV87esDeXfT28dLsQQQJ/MAGIDk6sDHRzX21cHuv3Rf3C1g06Jj+E9Ssn3e53U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15 2026, Mike Rapoport wrote:

>> Gigantic huge page allocation is somewhat broken currently when KHO is
>> used.
>> 
>> Firstly, they break KHO scratch size accounting. RSRV_KERN is used to
>> track how much memory is reserved for use by the kernel. Since
>> hugetlb::alloc_bootmem() calls the memblock_alloc*() APIs, the hugepages
>> allocated also get marked as RSRV_KERN.
>> 
>> Allocations marked RSRV_KERN are used by KHO to calculate how much
>> scratch space it should reserve to make sure the next kernel has enough
>> memory to boot when it is in scratch-only phase. Counting hugepages in
>> that blows up scratch size, and can lead to the scratch allocation
>> failing, making KHO unusable. This will show up when huge pages make up
>> more than 50% of the system, which is a fairly common use case.
>> 
>> Secondly, while not supported right now, huge pages are user memory and
>> can be preserved via KHO. The scratch spaces should not have any
>> preserved memory. Allocating hugepages from scratch (on a KHO boot) can
>> lead to them being un-preservable.
>> 
>> Introduce memblock_alloc_hugetlb(). This lets memblock tailor to the
>> needs of hugetb without exposing those details to the general allocation
>> routines.
>> 
>> First, it does not use mirrored memory for hugetlb. Mirrored memory is a
>> limited resource that is best saved for kernel data structures, not user
>> memory.
>> 
>> Second, if the free memory area found by memblock_find_in_range_node()
>> is a part of a KHO scratch area, the free area is not used. Allocation
>> is retried starting after the free area to ensure no hugepages come from
>> KHO scratch.
>> 
>> Third, it simplifies the argument list by baking in some hugetlb
>> assumptions like alignment and exact_nid. This also simplifies
>> allocation logic in alloc_bootmem().
>> 
>> Also introduce MEMBLOCK_RSRV_HUGETLB to mark reservations made for
>> HugeTLB. This will be used by KHO in future patches to correctly
>> calculate scratch sizes.
>> 
>> Refactor some of the preparation logic like kmemleak tracking and
>> accepting memory into a separate helper memblock_prep_allocation(), and
>> use it from both memblock_alloc_hugetlb() and the usual
>> memblock_alloc_range_nid().
>> 
>> Add a stub for kho_scratch_overlap to memblock tests to make sure it
>> compiles.
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
[...]
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 8b2e551435ae9..ba6d887ea18eb 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -1506,6 +1506,32 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
>>  	return 0;
>>  }
>>  
>> +static void memblock_prep_allocation(phys_addr_t start, phys_addr_t size,
>> +				     bool leaktrace)
>
> Let's call this kmemleak_trace

ACK.

>
>> +{
>> +	/*
>> +	 * Skip kmemleak for those places like kasan_init() and
>> +	 * early_pgtable_alloc() due to high volume.
>> +	 */
>> +	if (leaktrace)
>> +		/*
>> +		 * Memblock allocated blocks are never reported as
>> +		 * leaks. This is because many of these blocks are
>> +		 * only referred via the physical address which is
>> +		 * not looked up by kmemleak.
>> +		 */
>> +		kmemleak_alloc_phys(start, size, 0);
[...]
>> diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
>> index b6b1d147fd750..e86bb9000b22f 100644
>> --- a/tools/testing/memblock/internal.h
>> +++ b/tools/testing/memblock/internal.h
>> @@ -66,4 +66,9 @@ static inline void init_deferred_page(unsigned long pfn, int nid)
>>  
>>  #define __SetPageReserved(p)	((void)(p))
>>  
>> +static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
>> +{
>> +	return false;
>> +}
>> +
>
> This should be in the patch that exposes kho_scratch_overlap() to kexec_handover.h

Hm, sure, why not. I added it here because _this patch_ uses
kho_scratch_overlap() for the first time on memblock.c, and with that
breaks build of the memblock tests. So I recokned it makes sense to have
it in the place that broke it.

But I don't mind, I can move it to the other patch as well.

-- 
Regards,
Pratyush Yadav

