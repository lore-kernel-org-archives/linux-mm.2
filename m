Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D8210AB802
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7786B0089; Thu, 26 Mar 2026 14:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8DC6B008A; Thu, 26 Mar 2026 14:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BEB06B008C; Thu, 26 Mar 2026 14:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC986B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:50:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97505C45AC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:50:43 +0000 (UTC)
X-FDA: 84589105566.18.5A66D5D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42432140007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:50:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rOPmq8Oc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774551041; a=rsa-sha256;
	cv=none;
	b=xrMs4ZhBRdyRxjGx/grOiutIJqZwtwE3U/pxPQ14Oy+rC9RwYhMuJHMNhuCIAdDzXK+ZGV
	4Dm4cjx1qaTM1aVvSpPIYVeLJpJ2AdCOSXO+mJNxYvA2+KDe8cWMVOxlPV4dizKg2XM2k9
	SF96pdZDgKXdUIfYsWCfD9Hjd8JyU0I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rOPmq8Oc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774551041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAtm0fNUVAYL5+qZLwfmQO+K/vAmdgBiRMAwyGFyurs=;
	b=Yz1KH71+Y0Aic8JHvmciBkLe3u7GQIxptTcwjfNISM1UmpuK4jSvj8/GVaSVxl1vFQ9DmG
	Qa63epcrXnvHKoYv+zd+xtqw3FJDz260EREBWhMdR7l47oLfHwy9TApoUM/Ll1yfxanKh/
	7zFugpTXjm55+nAdzciSJqw40hERfz4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 332982EC6;
	Thu, 26 Mar 2026 11:50:34 -0700 (PDT)
Received: from [10.57.84.204] (unknown [10.57.84.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B6D73F905;
	Thu, 26 Mar 2026 11:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774551040; bh=hX5RuAfVZuu9EjPLtOuIJgSOsJcmn+KII6lpSyZXG6M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rOPmq8OcbhwMsWDjaRQuflNsGh7tZmtGNniKq4H/xfOblZFgHneRZbOAWtPu9qNtt
	 QmZjLD7tdqg9nV5E6LklVdQW2w4jd7W2f0VMN1+cKL5cNvTYCvFbZadPnmBcP0uIvW
	 9NvZ3i/hDQiFg4l4L6EC2fpb47iNdEt8/sOfRQ6A=
Message-ID: <eafefe7a-a33b-4102-93cf-fecc33ddf49e@arm.com>
Date: Thu, 26 Mar 2026 18:50:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-GB
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <afe9ba0a-1924-42a8-a9c5-34eec709f883@arm.com>
 <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org> <acV36oPNFMgL4puz@milan>
 <ea1cb2a1-b674-4d69-bbf6-00051a0e11df@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ea1cb2a1-b674-4d69-bbf6-00051a0e11df@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ew91sz8thnp9py9d7yy9wb39m8sodo4g
X-Rspamd-Queue-Id: 42432140007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774551041-437319
X-HE-Meta: U2FsdGVkX18bSuVq/Dy6eKzioBNQ9k8JbV/kKue5/pb+XrF1+FKpxWTRf+To1R+TcheJHk8CGUggfrSfzrixgCqz/aYOF1oGEeXtf9+vwd/QYMx+1mcsDgIQT3s9O9SdPY7rT6g0GF1Arc3XZussMXmFf7kefqwMd7lonCSfTvawqKdyDWDPk8Yo+KiFpnP2rmBULvdPZHhhizBeL2gnYTGvsSnyiUXt7MUV2tgxTcZ8RmiY/WwSAlJK2HWYplfdRdComCPiM7yf2tutdenXnpNlTc7g+xGCWtmh7UbOG2n2jS852eEElv3d40XPARX4doSNOK6oKxEmokx0zQaC05+k7Yd8FR62FGf8C6Kh/igx6MVvPjnL3deIXBDIis8BjE4SS2HP+grE5ho8yrA4cZy2vnZZGmbSdH4nh9vT3C1lnSZQ+sJYgZ6Cc6E9CiFKq8E46V5UF8wSdFvYHNrUJIghQrbi+xdBuh7dbfzDeITpMu6MTeZ7s4ljGP2R4V8vtH1BiqDCINjxt8f0xz+SUm+5y9JVtHIrhTWA3QzGwyEiiUlYBebBbXlr5O5hJj/mUkpdqtQPEHUPvEcXIq/eQ7eMz/LW44weCwpZ98eLHo1sASBL/0eaM1OZ/b/Y85l+Yoffe8eyCog59yLLCIy4p498/CPuuQv0UXKwu1mPhJ1uoZlS3R7Vj1j/mqTH+Yjp1sajsFcOP4mTi8Kxzv0uoWTjUbp2pmsAEX4Z4n6FC0uOMFuxv1Uvy+2lJBBQtzMsMjnLQcnbjjNoDmYz0iBP/DiF0lFucUHdeKsfxkFdWRd1ZcujlJ7JGY0A3sg/D2U+0U4t8vQ2kQsHlsyQn34RgTtJO/nqpVyOJa2WurufNnC6ycbs3kcB4ISpANBmpZhXhACSX7shIHE3q5JlD+LCYvDGJraEI32AUJt+f1fXFPbLL9z2F7U1Ofo/E0pdp7dcw2kyu5mqs44HoUZKq2y
 OzK+uPX2
 nSF5rEAT+DHAYllJqHj1ZuGsIsQtvmewbkbj7KkCWkN2D4rakMbWgXu78HA+oE2fYl6CmQ0KAfkrbz0CnbYvMdQpT8gnwWNk5EEycq36RRILz0zhcncz2dbDHNXcdpN5Y08w8/HZ9pCTEZj9vUwGtpwdk0zdX/hMFPy/ZV0j95P0umvf+S5sXoOQgpiVd9A3nOfwN/lJqFV1XQHyozjA0KLxAQgSUeblls8cSRRRV5i8w99oKC+3sRTOzo3Ig5BYKsq3v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/03/2026 18:24, Vlastimil Babka (SUSE) wrote:
> On 3/26/26 19:16, Uladzislau Rezki wrote:
>> On Thu, Mar 26, 2026 at 03:42:02PM +0100, Vlastimil Babka (SUSE) wrote:
>>> On 3/26/26 13:43, Aishwarya Rambhadran wrote:
>>>> Hi Vlastimil, Harry,
>>>
>>> Hi!
>>>
>>>> We have observed few kernel performance benchmark regressions,
>>>> mainly in perf & vmalloc workloads, when comparing v6.19 mainline
>>>> kernel results against later releases in the v7.0 cycle.
>>>> Independent bisections on different machines consistently point
>>>> to commits within the slab percpu sheaves series. However, towards
>>>> the end of the bisection, the signal becomes less clear, so it's
>>>> not yet certain which specific commit within the series is the
>>>> root cause.
>>>>
>>>> The workloads were triggered on AWS Graviton3 (arm64) & AWS Intel
>>>> Sapphire Rapids (x86_64) systems in which the regressions are
>>>> reproducible across different kernel release candidates.
>>>> (R)/(I) mean statistically significant regression/improvement,
>>>> where "statistically significant" means the 95% confidence
>>>> intervals do not overlap”.
>>>>
>>>> Below given are the performance benchmark results generated by
>>>> Fastpath Tool, for different kernel -rc versions relative to the
>>>> base version v6.19, executed on the mentioned SUTs. The perf/
>>>> syscall benchmarks (execve/fork) regress consistently by ~6–11% on
>>>> both arm64 and x86_64 across v7.0-rc1 to rc5, while vmalloc
>>>> workloads show smaller but stable regressions (~2–10%), particularly
>>>> in kvfree_rcu paths.
>>>>
>>>> Regressions on AWS Intel Sapphire Rapids (x86_64) :
>>>
>>> The table formatting is broken for me, can you resend it please? Maybe a
>>> .txt attachment would work better.
>>>
>>>> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>>>> | Benchmark       | Result Class            |   6-19-0 (base) |  
>>>>   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |  
>>>>   7-0-0-rc4 |   7-0-0-rc5 |
>>>> +=================+==========================================================+=================+=============+=============+===========================+=============+=============+=============+
>>>> | micromm/vmalloc | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 
>>>> (usec) |       262605.17 |      -4.94% |      -7.48% |             (R) 
>>>> -8.11% |      -4.51% |      -6.23% |      -3.47% |
>>>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 
>>>> (usec) |       253198.67 |      -7.56% | (R) -10.57% |            (R) 
>>>> -10.13% |  (R) -7.07% |      -6.37% |      -6.55% |
>>>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)           
>>>>   |       197904.67 |      -2.07% |      -3.38% |             -2.07% |  
>>>>      -2.97% |  (R) -4.30% |      -3.39% |
>>>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 
>>>> (usec)  |      1707089.83 |      -2.63% |  (R) -3.69% |               
>>>> (R) -3.25% |  (R) -2.87% |      -2.22% |  (R) -3.63% |
>>>> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>>>> | perf/syscall    | execve (ops/sec)            |         1202.92 |  (R) 
>>>> -7.15% |  (R) -7.05% |         (R) -7.03% |  (R) -7.93% |  (R) -6.51% |  
>>>> (R) -7.36% |
>>>> |                 | fork (ops/sec)            |          996.00 |  (R) 
>>>> -9.00% | (R) -10.27% |         (R) -9.92% | (R) -11.19% | (R) -10.69% | 
>>>> (R) -10.28% |
>>>> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>>>>
>>>> Regressions on AWS Graviton3 (arm64) :
>>>> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>>>> | Benchmark       | Result Class            |   6-19-0 (base) |  
>>>>   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |  
>>>>   7-0-0-rc4 |   7-0-0-rc5 |
>>>> +=================+==========================================================+=================+=============+=============+===========================+=============+=============+=============+
>>>> | micromm/vmalloc | fix_size_alloc_test: p:1, h:0, l:500000 (usec)      
>>>>       |       320101.50 |  (R) -4.72% |  (R) -3.81% |               (R) 
>>>> -5.05% |      -3.06% |      -3.16% |  (R) -3.91% |
>>>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)      
>>>>       |       522072.83 |  (R) -2.15% |      -1.25% |               (R) 
>>>> -2.16% |  (R) -2.13% |      -2.10% |      -1.82% |
>>>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)      
>>>>      |      1041640.33 |      -0.50% |  (R) -2.04% |                 
>>>> -1.43% |      -0.69% |      -1.78% |  (R) -2.03% |
>>>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)    
>>>>       |      2255794.00 |      -1.51% |  (R) -2.24% |             (R) 
>>>> -2.33% |      -1.14% |      -0.94% |      -1.60% |
>>>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 
>>>> (usec) |       343543.83 |  (R) -4.50% |  (R) -3.54% |             (R) 
>>>> -5.00% |  (R) -4.88% |  (R) -4.01% |  (R) -5.54% |
>>>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 
>>>> (usec) |       342290.33 |  (R) -5.15% |  (R) -3.24% |             (R) 
>>>> -3.76% |  (R) -5.37% |  (R) -3.74% |  (R) -5.51% |
>>>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 
>>>> (usec)  |      1209666.83 |      -2.43% |      -2.09% |                 
>>>>    -1.19% |  (R) -4.39% |      -1.81% |      -3.15% |
>>>> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>>>> | perf/syscall    | execve (ops/sec)            |         1219.58 |      
>>>>         |  (R) -8.12% |         (R) -7.37% |  (R) -7.60% |  (R) -7.86% 
>>>> |  (R) -7.71% |
>>>> |                 | fork (ops/sec)            |          863.67 |        
>>>>       |  (R) -7.24% |         (R) -7.07% |  (R) -6.42% |  (R) -6.93% |  
>>>> (R) -6.55% |
>>>> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>>>>
>>>>
>>>> The details of latest bisections that were carried out for the above
>>>> listed regressions, are given below :
>>>> -Graviton3 (arm64)
>>>>   good: v6.19 (05f7e89ab973)
>>>>   bad:  v7.0-rc2 (11439c4635ed)
>>>>   workload: perf/syscall (execve)
>>>>   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
>>>>   kmalloc_nolock()/kfree_nolock()”)
>>>>
>>>> -Sapphire Rapids (x86_64)
>>>>   good: v6.19 (05f7e89ab973)
>>>>   bad:  v7.0-rc3 (1f318b96cc84)
>>>>   workload: perf/syscall (fork)
>>>>   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
>>>>   kmalloc_nolock()/kfree_nolock()”)
>>>>
>>>> -Graviton3 (arm64)
>>>>   good: v6.19 (05f7e89ab973)
>>>>   bad:  v7.0-rc3 (1f318b96cc84)
>>>>   workload: perf/syscall (execve)
>>>>   bisected to: f3421f8d154c (“slab: introduce percpu sheaves bootstrap”)
>>>
>>> Yeah none of these are likely to introduce the regression.
>>> We've seen other reports from e.g. lkp pointing to later commits that remove
>>> the cpu (partial) slabs. The theory is that on benchmarks that stress vma
>>> and maple node caches (fork and execve are likely those), the introduction
>>> of sheaves in 6.18 (for those caches only) resulted in ~doubled percpu
>>> caching capacity (and likely associated performance increase) - by sheaves
>>> backed by cpu (partial) slabs,. Removing the latter then looks like a
>>> regression in isolation in the 7.0 series.
>>>
>>> A regression of vmalloc related to kvfree_rcu might be new. Although if it's
>>> kvfree_rcu() of vmalloc'd objects, it would be weird. More likely they are
>>> kvmalloc'd but small enough to be actually kmalloc'd? What are the details
>>> of that test?
>>>
>> static int
>> kvfree_rcu_2_arg_vmalloc_test(void)
> 
> Oh so that's what the test is measuring? Thanks for clarifying.
> 
>> {
>> 	struct test_kvfree_rcu *p;
>> 	int i;
>>
>> 	for (i = 0; i < test_loop_count; i++) {
>> 		p = vmalloc(1 * PAGE_SIZE);
>> 		if (!p)
>> 			return -1;
>>
>> 		p->array[0] = 'a';
>> 		kvfree_rcu(p, rcu);
>> 	}
>>
>> 	return 0;
>> }
>>
>> static bool kfree_rcu_sheaf(void *obj)
>> {
>> 	struct kmem_cache *s;
>> 	struct slab *slab;
>>
>> 	if (is_vmalloc_addr(obj))
>> 		return false;
>>
>> 	slab = virt_to_slab(obj);
>> 	if (unlikely(!slab))
>> 		return false;
>>
>> 	s = slab->slab_cache;
>> 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
>> 		return __kfree_rcu_sheaf(s, obj);
>>
>> 	return false;
>> }
>>
>> it does not go via sheaf since it is a vmalloc address.

Isn't vmalloc doing slab allocations for vmap_area, vm_struct, etc, which will
occasionally go via sheaves though? I had assumed that was the reason of the
observed regression.

> 
> Right so there should be just the overhead of the extra is_vmalloc_addr()
> test. Possibly also the call of kfree_rcu_sheaf() if it's not inlined.
> I'd say it's something we can just accept? It seems this is a unit test
> being used as a microbenchmark, so it can be very sensitive even to such
> details, but it should be negligible in practice.

The perf/syscall cases might be a bit more concerning though? (those tests are
from "perf bench syscall fork|execve"). Yes they are microbenchmarks, but a 7%
increased cost for fork seems like something we'd want to avoid if we can.

Thanks,
Ryan


> 
>>
>> --
>> Uladzislau Rezki
> 


