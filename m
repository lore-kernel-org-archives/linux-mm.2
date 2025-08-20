Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F22CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 16:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715FC6B00DD; Wed, 20 Aug 2025 12:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDBC6B00DE; Wed, 20 Aug 2025 12:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A326B00E0; Wed, 20 Aug 2025 12:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 518F76B00DD
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:01:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 07CC51DDA7F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:01:36 +0000 (UTC)
X-FDA: 83797600992.19.A035C98
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0E760C0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:01:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755705694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/FJ9n7A8QZNerxuSCWLoELDNn+Q9C4H3j3KkmEflbc=;
	b=xgi8qRdKnXQKs2yig9zNrgl1Bgqxy52N7IjQVVshB5MHZqoqV0PujGEUcvzlI4pUMjBazh
	vBUmBTuyV1wVj4s9sgueCI+8sg92oqGHq2n4auo6jzSl5wsoXtAII/dTCfu0aGneqjxbT5
	HFoTJywDzUXsE8iy8/n9vPqRGlkJRSw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755705694; a=rsa-sha256;
	cv=none;
	b=si8DDrfD1ybhZGqJyt/0KaXDybXmt13psiGIIioXVsakb/U27DG+/nHiMK+N+2FQsyxTtq
	N0IMdo6E1NmVfxSrTNtflpduPe3HZ7pu8lz3z8kHKAtxR8FxbY6J9i1loPtm6iN/xiyMYS
	SiMTOtIE8pi1tZhYLpo3PSyOSvP9hZ0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C10B51424;
	Wed, 20 Aug 2025 09:01:24 -0700 (PDT)
Received: from [10.57.90.209] (unknown [10.57.90.209])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE9AB3F63F;
	Wed, 20 Aug 2025 09:01:26 -0700 (PDT)
Message-ID: <5b5455eb-e649-4b20-8aad-6d7f5576a84a@arm.com>
Date: Wed, 20 Aug 2025 18:01:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <4a828975-d412-4a4b-975e-4702572315da@arm.com>
Content-Language: en-GB
In-Reply-To: <4a828975-d412-4a4b-975e-4702572315da@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E760C0011
X-Stat-Signature: s3nmyqeuk9wya96rqpaadferfebq7oxw
X-Rspam-User: 
X-HE-Tag: 1755705693-299079
X-HE-Meta: U2FsdGVkX1/0COk1cofip988OiYURPdiaeZVHJugGFRENDb8d1fPSCwOU5AijSqXzz/kSGX0qxX+EvUZHTiqrRwSffIoK/G80amdkro8ZaTWmXg5JtBUNiWEzezd7ZJbF9faVwW1/OKVufWwVSBvDpuZr4J/o+UrdHG9OpoagbRp2VTuMBFPZN7iDKhMXvdTi+4oQmfUtlMJSc8exgHtVcQua8OVyxvyWHOY4ICh5kM1/63RvtiQBY0n0ZT09BfYgO95vH0NgXZWsMsPmKqsodcCu41gcC0WWsMfqHCEBWaYu0If3cunY4zhfVEohA1miEmzpza4fSz9ZSkSPPvn2GFvkdnukmXGHGomIdKCSS4JlXs+/jFI1gUntdLaod9D3q+gcgZ3VvXnGhPgXpm1URRbLmvysrl5JT0ei9ymNWTO/VmKH4mEJ0IY9evW5unDHo4+C+wbG5EoBdXpyo0R16dHYoEfOLmmWgUl+MisS3E4Q+nH7MbOClWRjsqpSWdIFfPCBrORBjhpGINFnEuSWQOUTkLzi7ZTLKOPwcMtlVi3p+Oa9NxEWSSAe7W+VvrpVRe+F+1TvO5kltjHzeG1vyYkGJG5Z/kQ3xNTru20pc9su9vxXHDiou7Vvoovw6jSzwzHWi/Ngm5N5ipCz8WyQtV9drXPiMMEWW8aEWmncD/9qBvoWfDHeIC6dLUlUmjnxTA5DAdvu05/S9RXaPyU5zrAFHQ3pRVqEE2BJrSrC60mVe2L2XrEe9mjgnNRrCpXWPg7mjB9Od0D+vHlWup2RW1b0hoYZE63+SUfJtZtgza7v89gfPu8Y4V0+qbOJrr06NivnitFGLJ7fJBmYLKCcdy+J0iMglJ3LBSpl0ImdyVdhYW23KpuUi24rt7qHtVzO7x6MR/bENAA4PUsxziCobaka3T1e5dHqpUdVetfQeLuUbS10/k2iAUQm1lRNsMbqjA2kPf6en2qLfMVXv/
 RXUzZQ45
 okm2jwABLFbYv/l7TN9go4rR6XsA05EGLi1q45s9Z12R5U7MdUKMl7XHar5ZeMJdlI77i00uV+PrM+/LrECvj785GIquJxTEWtKCrzMutSMouAhWfoYOTJO0QpdXdS21tZpvG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/08/2025 17:53, Kevin Brodsky wrote:
> On 15/08/2025 10:54, Kevin Brodsky wrote:
>> [...]
>>
>> Performance
>> ===========
>>
>> No arm64 hardware currently implements POE. To estimate the performance
>> impact of kpkeys_hardened_pgtables, a mock implementation of kpkeys has
>> been used, replacing accesses to the POR_EL1 register with accesses to
>> another system register that is otherwise unused (CONTEXTIDR_EL1), and
>> leaving everything else unchanged. Most of the kpkeys overhead is
>> expected to originate from the barrier (ISB) that is required after
>> writing to POR_EL1, and from setting the POIndex (pkey) in page tables;
>> both of these are done exactly in the same way in the mock
>> implementation.
> It turns out this wasn't the case regarding the pkey setting - because
> patch 6 gates set_memory_pkey() on system_supports_poe() and not
> arch_kpkeys_enabled(), the mock implementation turned set_memory_pkey()
> into a no-op. Many thanks to Rick Edgecombe for highlighting that the
> overheads were suspiciously low for some benchmarks!
>
>> The original implementation of kpkeys_hardened_pgtables is very
>> inefficient when many PTEs are changed at once, as the kpkeys level is
>> switched twice for every PTE (two ISBs per PTE). Patch 18 introduces
>> an optimisation that makes use of the lazy_mmu mode to batch those
>> switches: 1. switch to KPKEYS_LVL_PGTABLES on arch_enter_lazy_mmu_mode(),
>> 2. skip any kpkeys switch while in that section, and 3. restore the
>> kpkeys level on arch_leave_lazy_mmu_mode(). When that last function
>> already issues an ISB (when updating kernel page tables), we get a
>> further optimisation as we can skip the ISB when restoring the kpkeys
>> level.
>>
>> Both implementations (without and with batching) were evaluated on an
>> Amazon EC2 M7g instance (Graviton3), using a variety of benchmarks that
>> involve heavy page table manipulations. The results shown below are
>> relative to the baseline for this series, which is 6.17-rc1. The
>> branches used for all three sets of results (baseline, with/without
>> batching) are available in a repository, see next section.
>>
>> Caveat: these numbers should be seen as a lower bound for the overhead
>> of a real POE-based protection. The hardware checks added by POE are
>> however not expected to incur significant extra overhead.
>>
>> Reading example: for the fix_size_alloc_test benchmark, using 1 page per
>> iteration (no hugepage), kpkeys_hardened_pgtables incurs 17.35% overhead
>> without batching, and 14.62% overhead with batching. Both results are
>> considered statistically significant (95% confidence interval),
>> indicated by "(R)".
>>
>> +-------------------+----------------------------------+------------------+---------------+
>> | Benchmark         | Result Class                     | Without batching | With batching |
>> +===================+==================================+==================+===============+
>> | mmtests/kernbench | real time                        |            0.30% |         0.11% |
>> |                   | system time                      |        (R) 3.97% |     (R) 2.17% |
>> |                   | user time                        |            0.12% |         0.02% |
>> +-------------------+----------------------------------+------------------+---------------+
>> | micromm/fork      | fork: h:0                        |      (R) 217.31% |        -0.97% |
>> |                   | fork: h:1                        |      (R) 275.25% |     (R) 2.25% |
>> +-------------------+----------------------------------+------------------+---------------+
>> | micromm/munmap    | munmap: h:0                      |       (R) 15.57% |        -1.95% |
>> |                   | munmap: h:1                      |      (R) 169.53% |     (R) 6.53% |
>> +-------------------+----------------------------------+------------------+---------------+
>> | micromm/vmalloc   | fix_size_alloc_test: p:1, h:0    |       (R) 17.35% |    (R) 14.62% |
>> |                   | fix_size_alloc_test: p:4, h:0    |       (R) 37.54% |     (R) 9.35% |
>> |                   | fix_size_alloc_test: p:16, h:0   |       (R) 66.08% |     (R) 3.15% |
>> |                   | fix_size_alloc_test: p:64, h:0   |       (R) 82.94% |        -0.39% |
>> |                   | fix_size_alloc_test: p:256, h:0  |       (R) 87.85% |        -1.67% |
>> |                   | fix_size_alloc_test: p:16, h:1   |       (R) 50.31% |         3.00% |
>> |                   | fix_size_alloc_test: p:64, h:1   |       (R) 59.73% |         2.23% |
>> |                   | fix_size_alloc_test: p:256, h:1  |       (R) 62.14% |         1.51% |
>> |                   | random_size_alloc_test: p:1, h:0 |       (R) 77.82% |        -0.21% |
>> |                   | vm_map_ram_test: p:1, h:0        |       (R) 30.66% |    (R) 27.30% |
>> +-------------------+----------------------------------+------------------+---------------+
> These numbers therefore correspond to set_memory_pkey() being a no-op,
> in other words they represent the overhead of switching the pkey
> register only.
>
> I have amended the mock implementation so that set_memory_pkey() is run
> as it would on a real POE implementation (i.e. actually setting the PTE
> bits). Here are the new results, representing the overhead of both pkey
> register switching and setting the pkey of page table pages (PTPs) on
> alloc/free:
>
> +-------------------+----------------------------------+------------------+---------------+
> | Benchmark         | Result Class                     | Without
> batching | With batching |
> +===================+==================================+==================+===============+
> | mmtests/kernbench | real time                        |           
> 0.32% |         0.35% |
> |                   | system time                      |        (R)
> 4.18% |     (R) 3.18% |
> |                   | user time                        |           
> 0.08% |         0.20% |
> +-------------------+----------------------------------+------------------+---------------+
> | micromm/fork      | fork: h:0                        |      (R)
> 221.39% |     (R) 3.35% |
> |                   | fork: h:1                        |      (R)
> 282.89% |     (R) 6.99% |
> +-------------------+----------------------------------+------------------+---------------+
> | micromm/munmap    | munmap: h:0                      |       (R)
> 17.37% |        -0.28% |
> |                   | munmap: h:1                      |      (R)
> 172.61% |     (R) 8.08% |
> +-------------------+----------------------------------+------------------+---------------+
> | micromm/vmalloc   | fix_size_alloc_test: p:1, h:0    |       (R)
> 15.54% |    (R) 12.57% |
> |                   | fix_size_alloc_test: p:4, h:0    |       (R)
> 39.18% |     (R) 9.13% |
> |                   | fix_size_alloc_test: p:16, h:0   |       (R)
> 65.81% |         2.97% |
> |                   | fix_size_alloc_test: p:64, h:0   |       (R)
> 83.39% |        -0.49% |
> |                   | fix_size_alloc_test: p:256, h:0  |       (R)
> 87.85% |    (I) -2.04% |
> |                   | fix_size_alloc_test: p:16, h:1   |       (R)
> 51.21% |         3.77% |
> |                   | fix_size_alloc_test: p:64, h:1   |       (R)
> 60.02% |         0.99% |
> |                   | fix_size_alloc_test: p:256, h:1  |       (R)
> 63.82% |         1.16% |
> |                   | random_size_alloc_test: p:1, h:0 |       (R)
> 77.79% |        -0.51% |
> |                   | vm_map_ram_test: p:1, h:0        |       (R)
> 30.67% |    (R) 27.09% |
> +-------------------+----------------------------------+------------------+---------------+

Apologies, Thunderbird helpfully decided to wrap around that table...
Here's the unmangled table:

+-------------------+----------------------------------+------------------+---------------+
| Benchmark         | Result Class                     | Without batching | With batching |
+===================+==================================+==================+===============+
| mmtests/kernbench | real time                        |            0.32% |         0.35% |
|                   | system time                      |        (R) 4.18% |     (R) 3.18% |
|                   | user time                        |            0.08% |         0.20% |
+-------------------+----------------------------------+------------------+---------------+
| micromm/fork      | fork: h:0                        |      (R) 221.39% |     (R) 3.35% |
|                   | fork: h:1                        |      (R) 282.89% |     (R) 6.99% |
+-------------------+----------------------------------+------------------+---------------+
| micromm/munmap    | munmap: h:0                      |       (R) 17.37% |        -0.28% |
|                   | munmap: h:1                      |      (R) 172.61% |     (R) 8.08% |
+-------------------+----------------------------------+------------------+---------------+
| micromm/vmalloc   | fix_size_alloc_test: p:1, h:0    |       (R) 15.54% |    (R) 12.57% |
|                   | fix_size_alloc_test: p:4, h:0    |       (R) 39.18% |     (R) 9.13% |
|                   | fix_size_alloc_test: p:16, h:0   |       (R) 65.81% |         2.97% |
|                   | fix_size_alloc_test: p:64, h:0   |       (R) 83.39% |        -0.49% |
|                   | fix_size_alloc_test: p:256, h:0  |       (R) 87.85% |    (I) -2.04% |
|                   | fix_size_alloc_test: p:16, h:1   |       (R) 51.21% |         3.77% |
|                   | fix_size_alloc_test: p:64, h:1   |       (R) 60.02% |         0.99% |
|                   | fix_size_alloc_test: p:256, h:1  |       (R) 63.82% |         1.16% |
|                   | random_size_alloc_test: p:1, h:0 |       (R) 77.79% |        -0.51% |
|                   | vm_map_ram_test: p:1, h:0        |       (R) 30.67% |    (R) 27.09% |
+-------------------+----------------------------------+------------------+---------------+

> Those results are overall very similar to the original ones.
> micromm/fork is however clearly impacted - around 4% additional overhead
> from set_memory_pkey(); it makes sense considering that forking requires
> duplicating (and therefore allocating) a full set of page tables.
> kernbench is also a fork-heavy workload and it gets a 1% hit in system
> time (with batching).
>
> It seems fair to conclude that, on arm64, setting the pkey whenever a
> PTP is allocated/freed is not particularly expensive. The situation may
> well be different on x86 as Rick pointed out, and it may also change on
> newer arm64 systems as I noted further down. Allocating/freeing PTPs in
> bulk should help if setting the pkey in the pgtable ctor/dtor proves too
> expensive.
>
> - Kevin
>
>> Benchmarks:
>> - mmtests/kernbench: running kernbench (kernel build) [4].
>> - micromm/{fork,munmap}: from David Hildenbrand's benchmark suite. A
>>   1 GB mapping is created and then fork/unmap is called. The mapping is
>>   created using either page-sized (h:0) or hugepage folios (h:1); in all
>>   cases the memory is PTE-mapped.
>> - micromm/vmalloc: from test_vmalloc.ko, varying the number of pages
>>   (p:) and whether huge pages are used (h:).
>>
>> On a "real-world" and fork-heavy workload like kernbench, the estimated
>> overhead of kpkeys_hardened_pgtables is reasonable: 4% system time
>> overhead without batching, and about half that figure (2.2%) with
>> batching. The real time overhead is negligible.
>>
>> Microbenchmarks show large overheads without batching, which increase
>> with the number of pages being manipulated. Batching drastically reduces
>> that overhead, almost negating it for micromm/fork. Because all PTEs in
>> the mapping are modified in the same lazy_mmu section, the kpkeys level
>> is changed just twice regardless of the mapping size; as a result the
>> relative overhead actually decreases as the size increases for
>> fix_size_alloc_test.
>>
>> Note: the performance impact of set_memory_pkey() is likely to be
>> relatively low on arm64 because the linear mapping uses PTE-level
>> descriptors only. This means that set_memory_pkey() simply changes the
>> attributes of some PTE descriptors. However, some systems may be able to
>> use higher-level descriptors in the future [5], meaning that
>> set_memory_pkey() may have to split mappings. Allocating page tables
>> from a contiguous cache of pages could help minimise the overhead, as
>> proposed for x86 in [1].
>>
>> [...]

