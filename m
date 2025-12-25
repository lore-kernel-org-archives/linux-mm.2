Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0317E7AD42
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 09:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6B86B0088; Thu, 25 Dec 2025 04:49:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054806B0089; Thu, 25 Dec 2025 04:49:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC90F6B008A; Thu, 25 Dec 2025 04:49:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA6316B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 04:49:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 742748B9E7
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:49:53 +0000 (UTC)
X-FDA: 84257521866.07.B7DE22D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9FA1640002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:49:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sdZVzdq/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766656191; a=rsa-sha256;
	cv=none;
	b=mgfOHNGFq/FfbNBPXsEStHq9gk6D9BVzDkBSwucMGsaaZXqRrX288Rh57qNO3700SeyNuB
	655UKCl9g/nbxzjxd6ZeAoP+TImTL5Meo0pjGYm8m4uvK3+RvxF1UQnP6IRZb+IJMkBuG9
	9080v14xzIaSV3s+zhb1xUt+gA7mOa0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sdZVzdq/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766656191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/FS+3DnMOtidopCd0UXbT8AK2kb+AjCRo4jPdKBJmE=;
	b=mlr6kSl7TiF40QhekISCVldRqIo749PLBOnWfVwC+tfoaP8i62JDVBZUUqMpjGI7tHtxC/
	4uRHglHOJrilWxHKg4RRrZeg+iM6TXjYlpNvfrGn46rH+nNbYZPF99HqUt4Sd5OcLz9pAG
	krFJUMn/hUHqu9WshDAczjXzpfiCjHo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80C2342E19;
	Thu, 25 Dec 2025 09:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D7CC4CEF1;
	Thu, 25 Dec 2025 09:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766656190;
	bh=3nIYuigXWekDPMa/zo4CI26ZDqoA5RIjVHToKBdAf9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sdZVzdq/stOlui6Ricvxhc/BJbaDZdptSo4jseuRj+KgI2kmb7KBfsajwuPAy4PSj
	 VKJxG9qvJ75m7svZj0wEjuv+5ZPptS9/op0WlFbDKCCS3okTvVtr0UQIMuQQxa7ig2
	 VK2eC1wVYbq8Ewn8DO8KzR3qJV6RtN/IxOu5gLOhfvYDla2ysPFW2kqKyjXhs1Ceqn
	 mTA7KNtJGCk76w/4WIxo7481Qkfes0IQnZD0GfPKTTCIZ+4QvpUIjn1SJ1nTA3swOU
	 qn0uwRcRs9Q5rB+02Od76vriLXOBGC6PWyhQWcZWOVQ/xRxxE5HHWjgrdBtKeR/Kwe
	 FoxpoX3sNRznA==
Message-ID: <520e6f26-4624-4145-b959-ccde466dfda2@kernel.org>
Date: Thu, 25 Dec 2025 10:49:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 0/4] mm/hugetlb: fixes for PMD table sharing
 (incl. using mmu_gather)
To: Laurence Oberman <loberman@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20251223214037.580860-1-david@kernel.org>
 <11ab64528debf3b3515e863610fc8b679a39189c.camel@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <11ab64528debf3b3515e863610fc8b679a39189c.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9FA1640002
X-Rspamd-Server: rspam03
X-Stat-Signature: tjan8hbukp7oyr18qqj7mes9jmcd8r7e
X-Rspam-User: 
X-HE-Tag: 1766656191-411247
X-HE-Meta: U2FsdGVkX1/ykk3QkcCXPYZ/+xyDGwDTajaI44qciUcZc8P1vdBgtJA6bxsKImAJLDsJsb1cUBiwzNh52w9XSFpnvQ/oxCblJMVSqPeZqnUliByK+JbnUG9Y87eb1SBpnt1hgUosUJZrNBjwQdRCWOq3Vp1PuHIoK7CJ2jP0orl62z1IEYThQiUK+njeFe6OgSEIRmxTzgOA2YYN4ldp9eiOq4Hh32m/dYD4GbI0r6Ww9XEcX6NzR5+J8T8ccc7sI3As1zfWM9Nhk4tWWG+rrc9b/BM2FDt3qG5BGaEpNm0gxDqWPQdxVZMx/HAz1su0+y+1czVyGU4t3aVPqQB2f6v5pMUAlfed7DXeU8gLFYnOLE51G5Bq/6S2ROJRfzshinE7d115YbaIGUyozd5olNNxQfVN276hxAV2ANUoqJzJbc+fUnb2l9F8F/Yur1MRVmZodYrkmAePTPetSP8jcfbEXUkxexE9JsT2jrhWYULSo4Ie1H7pXfQHi/teEaM6sfWBAM9hNHBdDif5Cc8iklXKbJH3stGrxUPfUfO3iILWaX9scC6F3yauuDoZ5fEESHvJbMJ7y2TGtQK/k2yPE6Jx27ET8XMiDfT3mg8v7vFw5a7dcrJFLnLhSQ0mZlBCODpvlwteUrQ1PWqjRnF4LwazUaXwDQE4Kz19C/ETUCNF7QvCHdgUAaDr8U9DFMW3I0Q2qqIMko4btwN/nXAR92w25X617uydfCDztjPELbu4C9kgI9zALugJ7FosTlpW/iqrc8XLVRSFtn2+iZFZFiuf4hd7pwfgol8Fp8Vsyoq7jQ8Ccsj0naK7vqcI690zmsP3vavJjQxLE4suONRY1zkrKkAyV2ePVZ7G9GqBnqVaBGMZVdCRj9HQuLFkllnzTMm4EvEAVduHl01zRaPnXQR8irWtKeSL1MXLe2tqXcOFVzMzU/PBdebQEB8XwMLC8+0Lb5lw/lMI4j+1LpB
 kSA6YhbK
 Q1ionoEsJq/mR6S0Eo27YiFcQi8vpNJqyYyP+5tCm5qsLQ6fqvhN9MmwPu+kC5PcZxleo5qznsQ9F3T0Ve+KJpOoHFcTg08d3QAfukL+7HPT0F1irUcV966I+QSpWUzzuOB4BxowAIzzyqJWMq9i6CtMNofUPonl7FxDRTbsTs8qkPg8fsNg98aKDykNPWaoeBKg4Fmdd9fA0BAI0qwnbUGtOvC2mZMNO2iyUF+sBDcekZ5xTh6BJDyvV3QLhIJ+GP7dB7LEmDObT9pEV6t7WcqGTe3nQ3ABZdCmIOOZKp17C1rQqr9OVwmeyIopk+dJENkoyQtLfO4Q4PX1122Yv/nV07YVlvGZIgsmHeS9OSc/nSXs4qye2SyXdtfMQnN0BQtB5shOA9IQEwqtvxrEkzUdpBsl1da0vaJrUzA8e/J4r9wXMkcqOf2h4KrKCTfhj9jaib/2JU/BcNTnbdlsXcOrqPqeQaOwNTfXKzk061ODdEGDegvXkBC81JK1AwCTMAFNAPy6W4VThZmbUODQDlob0cR7Zq2SdfgopjopbveulyHi0A7mdQCUCUAfkLTLRYFHldkqWnGzLdibnZVa1EHxrXn4HuYgz/xWTLzEO/my2ha8zig1l6TUGJFqO2/dAuF+xEMdPKH2SZhw3lUoPxKRuK3cTXekNaBYx0+uD4D81uo1M/O6N6NHpboj0k16TuxOq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 00:23, Laurence Oberman wrote:
> On Tue, 2025-12-23 at 22:40 +0100, David Hildenbrand (Red Hat) wrote:
>> One functional fix, one performance regression fix, and two related
>> comment fixes.
>>
>> I cleaned up my prototype I recently shared [1] for the performance
>> fix,
>> deferring most of the cleanups I had in the prototype to a later
>> point.
>> While doing that I identified the other things.
>>
>> The goal of this patch set is to be backported to stable trees
>> "fairly"
>> easily. At least patch #1 and #4.
>>
>> Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
>> Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
>> Patch #4 is a fix for the reported performance regression due to
>> excessive
>> IPI broadcasts during fork()+exit().
>>
>> The last patch is all about TLB flushes, IPIs and mmu_gather.
>> Read: complicated
>>
>> I added as much comments + description that I possibly could, and I
>> am
>> hoping for review from Jann.
>>
>> There are plenty of cleanups in the future to be had + one reasonable
>> optimization on x86. But that's all out of scope for this series.
>>
>> Compile tested on plenty of architectures.
>>
>> Runtime tested, with a focus on fixing the performance regression
>> using
>> the original reproducer [2] on x86.
>>
>> [1]
>> https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/
>> [2]
>> https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/
>>
>> --
>>
>> v2 -> v3:
>> * Rebased to 6.19-rc2 and retested on x86
>> * Changes on last patch:
>>   * Introduce and use tlb_gather_mmu_vma() for properly setting up
>> mmu_gather
>>     for hugetlb -- thanks to Harry for pointing me once again at the
>> nasty
>>     hugetlb integration in mmu_gather
>>   * Move tlb_remove_huge_tlb_entry() after move_huge_pte()
>>   * For consistency, always call tlb_gather_mmu_vma() after
>>     flush_cache_range()
>>   * Don't pass mmu_gather to hugetlb_change_protection(), simply use
>>     a local one for now. (avoids messing with tlb_start_vma() /
>>     tlb_start_end())
>>   * Dropped Lorenzo's RB due to the changes
>>
>> v1 -> v2:
>> * Picked RB's/ACK's, hopefully I didn't miss any
>> * Added the initialization of fully_unshared_tables in
>> __tlb_gather_mmu()
>>    (Thanks Nadav!)
>> * Refined some comments based on Lorenzo's feedback.
>>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Nick Piggin <npiggin@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Muchun Song <muchun.song@linux.dev>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Pedro Falcato <pfalcato@suse.de>
>> Cc: Rik van Riel <riel@surriel.com>
>> Cc: Harry Yoo <harry.yoo@oracle.com>
>> Cc: Uschakow, Stanislav" <suschako@amazon.de>
>> Cc: Laurence Oberman <loberman@redhat.com>
>> Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
>> Cc: Nadav Amit <nadav.amit@gmail.com>
>>
>> David Hildenbrand (Red Hat) (4):
>>    mm/hugetlb: fix hugetlb_pmd_shared()
>>    mm/hugetlb: fix two comments related to huge_pmd_unshare()
>>    mm/rmap: fix two comments related to huge_pmd_unshare()
>>    mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
>>      using mmu_gather
>>
>>   include/asm-generic/tlb.h |  77 +++++++++++++++++++++-
>>   include/linux/hugetlb.h   |  17 +++--
>>   include/linux/mm_types.h  |   1 +
>>   mm/hugetlb.c              | 131 +++++++++++++++++++++---------------
>> --
>>   mm/mmu_gather.c           |  33 ++++++++++
>>   mm/rmap.c                 |  45 ++++++-------
>>   6 files changed, 213 insertions(+), 91 deletions(-)
>>
>>
>> base-commit: b927546677c876e26eba308550207c2ddf812a43
> Hello David
> 
> For the V3 series, I re-ran the tests and the original reproducer and
> its clean. I see the same almost 6x improvement for the original
> reproducer
> 
> # uname -r
> 6.19.0-rc2-hugetlbv3+
> 
> Un-patched Result of reproducer Iteration completed in 3436 ms
> V3 Patched Result of reproducer Iteration completed in 639 ms
> 
> I also ran a test to map every hugepage I could access (460GB of them)
> then fill and validate and had no issues.
> 
> Tested-by: Laurence Oberman <loberman@redhat.com>

Thanks a lot for the quick retest Laurence! I'd love to get some generic 
hugetlb testing on arm64 and powerpc, that do hugetlb TLB flushing stuff 
a bit more special.

I'll try doing some arm64 testing early in the new year myself.

-- 
Cheers

David

