Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDF810A88FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445FD6B0088; Thu, 26 Mar 2026 14:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DC46B0089; Thu, 26 Mar 2026 14:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35AF06B008A; Thu, 26 Mar 2026 14:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 273C86B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:24:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB6495C98B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:46 +0000 (UTC)
X-FDA: 84589040172.19.1E36155
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05D4C40019
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CpoOSRow;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774549485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIaUKJAlYIzwPXfQJvm95X176REbACqGXzLAbAeQbr8=;
	b=zi/YSKue7qP9OX0P27GVu8bw0vw8jWeeZMygddKkNy/VBuTM3dEX5ZAK5/i4tlTVO0mi/e
	XYSrt85IB4hX7wWDyZmaH4jvsKKrPd9hK0qPEreTM3aAZw2A36+3nbPttXhrHjpdehnKUz
	YzEg16QipfeGaJZ01G4S0qfiaZpplOk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CpoOSRow;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774549485; a=rsa-sha256;
	cv=none;
	b=ppljNaHbE3C4XaGyeCHZ4v0ixQipJrQKL9oYOW31ktiyXUO7lAjw/K+uMvggBqbIcV+jrJ
	Ejc0GF47D6od1EYpAM7XPzUfqVBJX1WYJF9CytTmRrAJ3urzHcBe75RnAMmrxb7GFom9Uc
	YyZIB0dPUjo5AZsZNlMqhuyaaunib0A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 640D860103;
	Thu, 26 Mar 2026 18:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D563C116C6;
	Thu, 26 Mar 2026 18:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774549484;
	bh=IHNSo2lQb/4glv2cQ687MuEaTyDzFMobiyxhmzeckqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CpoOSRowTPncy6NDxqny1BWJGN0YgqPfZFckHNyG1FTQIeQB9nru3J/2Ew20j2dUS
	 qNiKv7suYE/4lfi1mrW5IHRM1RbNGQwlW8Htxb8NHLcvw+K5MUoLhpn+qScGg0HOCr
	 JfTeGkGHAtB0xHykwg0KWHPHtod6q6ZHCnb5lEpPLHdy96Ep8GPPBAtBIgN/xjyltl
	 p36TT4XQmuB6DLPB7tpnE+6f5cnzHbwZJ/pROEGJcFD7+m7J3rCvVOUoWRfuUB4tOl
	 QcL1Q7f6dEo/z4Zv19VU1oKefEdfM8DKu5a2VGzHGQlzmp6QsO/hjEy0Wf7mvlLQ5c
	 FFFPWh19LVkyg==
Message-ID: <ea1cb2a1-b674-4d69-bbf6-00051a0e11df@kernel.org>
Date: Thu, 26 Mar 2026 19:24:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-US
To: Uladzislau Rezki <urezki@gmail.com>,
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
 "Paul E. McKenney" <paulmck@kernel.org>, ryan.roberts@arm.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <afe9ba0a-1924-42a8-a9c5-34eec709f883@arm.com>
 <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org> <acV36oPNFMgL4puz@milan>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <acV36oPNFMgL4puz@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 05D4C40019
X-Stat-Signature: t5ndg1gs6j1erj1w3s9u7e7b3nogq6eh
X-Rspam-User: 
X-HE-Tag: 1774549484-592804
X-HE-Meta: U2FsdGVkX1921FuYNLpwH7JPRugbCm6LfpJ28+eQErONw3nahXtPJawqo+xgBdwTjmKyJiPijo0pcO/zt2DkLoRnanM2QeSJz/CRycMap8XU9FPn3LNsV22tFTmocqBKCHK7V5nhAqy59hjSK0p+5/eKVRLnwAX2jvunWvwZkDwhhbO21M30FMtYJEc2CxhwEVUcy+407oeCa9KfqugioGL+F2S9Xbbm/YynZUo4EyGDGPGdpZIPUBhOWYRe9op5J2z3brRjJYeBgrqfnhQhGuj6UwVrwekebtGpdTebPD6VCgFAmOyodxhshCZFEB2vcC+EuDdhFAfWyxgiYRkVdEEB8H5V9sWUAAKEe895sbKmLOWJGgcBY1Pt9lXN4WXTdQMjniv431jEXsOtNPQLpYdZF5IJLbuiPqJrl5P02+pLK1hPmYtAwwX/DVN1t/qT8TeRq/S/mY94zf45MJz6Y4fCvukMtH8jnsOwzuae7Vuu5E1ULzBkkLRqfkmxAIWSQ8TV4+oMnfrjRfZaCd/LpcFJnBXVNDpDJHJ7t3zsKqohUP/FMrn8cZBb1cexTijJX2n6PnRmlNRK+zHEIEaJRYOqHG16XlpZRSK4s0Io1pQBXCdxbXRExJKvfzTfy4zu1fDa8xibcLIi6I2/YrpVWYjZnVyZCjnYF0ZcQ8GNT/rsBcc6c+SHgUDcqhRCihOEX7n4ph0k7E6tF0O49hg1D0UOkBx4d2csm+a6lU2Bx6q+DUwqZQa2hpAj3Exv8SA1cjKJ5ekhbqBmDozk27wxJK33FCN6DHVI3UN6s+9Fnbnf6zQ0kSDKcZ+FfiRdHSOzx4de3LqxqXlksMpgxUfKqRHl4xQ2Ei8vo71xI4jEkccPJ4wJh+OHFmO4ZrM0r0iKL6GcawDcpDFOYsDpDTEZP+3oNuAcsZd0ToMV6mU3sw/KQprZX/pDQ1ChzRH78ZNY0Oh5R84Vk+g5OzV7ai7
 XF7P9Rnu
 IBeuMvOvijOCf61VnNApcNeTuwJ168/vYYh5OUYV+9C9kGcZKTexyyLk/TB3xWvuExddkGtb5P69x3EL7yCdTCh9AYF2moNCZH+DHD5ruRBVJLJlQR88QX5AZ7xiV7crnACeLlyw6iutvS4ZdzKuMQiUMKMJD+3gE7cxc+gRIfMCdFWNLqEuOxW8YrDmZ7MvPFO12wT+xob+CACOcf1PxANxJ3aOW+UKzqgHo+bzRTiTL1xrOf8FAfCiY+yeKMWpL0PdPzPQJ4zKJURJiURZuLfrIq8Tan6SshEej
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 19:16, Uladzislau Rezki wrote:
> On Thu, Mar 26, 2026 at 03:42:02PM +0100, Vlastimil Babka (SUSE) wrote:
>> On 3/26/26 13:43, Aishwarya Rambhadran wrote:
>> > Hi Vlastimil, Harry,
>> 
>> Hi!
>> 
>> > We have observed few kernel performance benchmark regressions,
>> > mainly in perf & vmalloc workloads, when comparing v6.19 mainline
>> > kernel results against later releases in the v7.0 cycle.
>> > Independent bisections on different machines consistently point
>> > to commits within the slab percpu sheaves series. However, towards
>> > the end of the bisection, the signal becomes less clear, so it's
>> > not yet certain which specific commit within the series is the
>> > root cause.
>> > 
>> > The workloads were triggered on AWS Graviton3 (arm64) & AWS Intel
>> > Sapphire Rapids (x86_64) systems in which the regressions are
>> > reproducible across different kernel release candidates.
>> > (R)/(I) mean statistically significant regression/improvement,
>> > where "statistically significant" means the 95% confidence
>> > intervals do not overlap”.
>> > 
>> > Below given are the performance benchmark results generated by
>> > Fastpath Tool, for different kernel -rc versions relative to the
>> > base version v6.19, executed on the mentioned SUTs. The perf/
>> > syscall benchmarks (execve/fork) regress consistently by ~6–11% on
>> > both arm64 and x86_64 across v7.0-rc1 to rc5, while vmalloc
>> > workloads show smaller but stable regressions (~2–10%), particularly
>> > in kvfree_rcu paths.
>> > 
>> > Regressions on AWS Intel Sapphire Rapids (x86_64) :
>> 
>> The table formatting is broken for me, can you resend it please? Maybe a
>> .txt attachment would work better.
>> 
>> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>> > | Benchmark       | Result Class            |   6-19-0 (base) |  
>> >   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |  
>> >   7-0-0-rc4 |   7-0-0-rc5 |
>> > +=================+==========================================================+=================+=============+=============+===========================+=============+=============+=============+
>> > | micromm/vmalloc | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 
>> > (usec) |       262605.17 |      -4.94% |      -7.48% |             (R) 
>> > -8.11% |      -4.51% |      -6.23% |      -3.47% |
>> > |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 
>> > (usec) |       253198.67 |      -7.56% | (R) -10.57% |            (R) 
>> > -10.13% |  (R) -7.07% |      -6.37% |      -6.55% |
>> > |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)           
>> >   |       197904.67 |      -2.07% |      -3.38% |             -2.07% |  
>> >      -2.97% |  (R) -4.30% |      -3.39% |
>> > |                 | random_size_align_alloc_test: p:1, h:0, l:500000 
>> > (usec)  |      1707089.83 |      -2.63% |  (R) -3.69% |               
>> > (R) -3.25% |  (R) -2.87% |      -2.22% |  (R) -3.63% |
>> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>> > | perf/syscall    | execve (ops/sec)            |         1202.92 |  (R) 
>> > -7.15% |  (R) -7.05% |         (R) -7.03% |  (R) -7.93% |  (R) -6.51% |  
>> > (R) -7.36% |
>> > |                 | fork (ops/sec)            |          996.00 |  (R) 
>> > -9.00% | (R) -10.27% |         (R) -9.92% | (R) -11.19% | (R) -10.69% | 
>> > (R) -10.28% |
>> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>> > 
>> > Regressions on AWS Graviton3 (arm64) :
>> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>> > | Benchmark       | Result Class            |   6-19-0 (base) |  
>> >   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |  
>> >   7-0-0-rc4 |   7-0-0-rc5 |
>> > +=================+==========================================================+=================+=============+=============+===========================+=============+=============+=============+
>> > | micromm/vmalloc | fix_size_alloc_test: p:1, h:0, l:500000 (usec)      
>> >       |       320101.50 |  (R) -4.72% |  (R) -3.81% |               (R) 
>> > -5.05% |      -3.06% |      -3.16% |  (R) -3.91% |
>> > |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)      
>> >       |       522072.83 |  (R) -2.15% |      -1.25% |               (R) 
>> > -2.16% |  (R) -2.13% |      -2.10% |      -1.82% |
>> > |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)      
>> >      |      1041640.33 |      -0.50% |  (R) -2.04% |                 
>> > -1.43% |      -0.69% |      -1.78% |  (R) -2.03% |
>> > |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)    
>> >       |      2255794.00 |      -1.51% |  (R) -2.24% |             (R) 
>> > -2.33% |      -1.14% |      -0.94% |      -1.60% |
>> > |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 
>> > (usec) |       343543.83 |  (R) -4.50% |  (R) -3.54% |             (R) 
>> > -5.00% |  (R) -4.88% |  (R) -4.01% |  (R) -5.54% |
>> > |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 
>> > (usec) |       342290.33 |  (R) -5.15% |  (R) -3.24% |             (R) 
>> > -3.76% |  (R) -5.37% |  (R) -3.74% |  (R) -5.51% |
>> > |                 | random_size_align_alloc_test: p:1, h:0, l:500000 
>> > (usec)  |      1209666.83 |      -2.43% |      -2.09% |                 
>> >    -1.19% |  (R) -4.39% |      -1.81% |      -3.15% |
>> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>> > | perf/syscall    | execve (ops/sec)            |         1219.58 |      
>> >         |  (R) -8.12% |         (R) -7.37% |  (R) -7.60% |  (R) -7.86% 
>> > |  (R) -7.71% |
>> > |                 | fork (ops/sec)            |          863.67 |        
>> >       |  (R) -7.24% |         (R) -7.07% |  (R) -6.42% |  (R) -6.93% |  
>> > (R) -6.55% |
>> > +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
>> > 
>> > 
>> > The details of latest bisections that were carried out for the above
>> > listed regressions, are given below :
>> > -Graviton3 (arm64)
>> >   good: v6.19 (05f7e89ab973)
>> >   bad:  v7.0-rc2 (11439c4635ed)
>> >   workload: perf/syscall (execve)
>> >   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
>> >   kmalloc_nolock()/kfree_nolock()”)
>> > 
>> > -Sapphire Rapids (x86_64)
>> >   good: v6.19 (05f7e89ab973)
>> >   bad:  v7.0-rc3 (1f318b96cc84)
>> >   workload: perf/syscall (fork)
>> >   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
>> >   kmalloc_nolock()/kfree_nolock()”)
>> > 
>> > -Graviton3 (arm64)
>> >   good: v6.19 (05f7e89ab973)
>> >   bad:  v7.0-rc3 (1f318b96cc84)
>> >   workload: perf/syscall (execve)
>> >   bisected to: f3421f8d154c (“slab: introduce percpu sheaves bootstrap”)
>> 
>> Yeah none of these are likely to introduce the regression.
>> We've seen other reports from e.g. lkp pointing to later commits that remove
>> the cpu (partial) slabs. The theory is that on benchmarks that stress vma
>> and maple node caches (fork and execve are likely those), the introduction
>> of sheaves in 6.18 (for those caches only) resulted in ~doubled percpu
>> caching capacity (and likely associated performance increase) - by sheaves
>> backed by cpu (partial) slabs,. Removing the latter then looks like a
>> regression in isolation in the 7.0 series.
>> 
>> A regression of vmalloc related to kvfree_rcu might be new. Although if it's
>> kvfree_rcu() of vmalloc'd objects, it would be weird. More likely they are
>> kvmalloc'd but small enough to be actually kmalloc'd? What are the details
>> of that test?
>> 
> static int
> kvfree_rcu_2_arg_vmalloc_test(void)

Oh so that's what the test is measuring? Thanks for clarifying.

> {
> 	struct test_kvfree_rcu *p;
> 	int i;
> 
> 	for (i = 0; i < test_loop_count; i++) {
> 		p = vmalloc(1 * PAGE_SIZE);
> 		if (!p)
> 			return -1;
> 
> 		p->array[0] = 'a';
> 		kvfree_rcu(p, rcu);
> 	}
> 
> 	return 0;
> }
> 
> static bool kfree_rcu_sheaf(void *obj)
> {
> 	struct kmem_cache *s;
> 	struct slab *slab;
> 
> 	if (is_vmalloc_addr(obj))
> 		return false;
> 
> 	slab = virt_to_slab(obj);
> 	if (unlikely(!slab))
> 		return false;
> 
> 	s = slab->slab_cache;
> 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
> 		return __kfree_rcu_sheaf(s, obj);
> 
> 	return false;
> }
> 
> it does not go via sheaf since it is a vmalloc address.

Right so there should be just the overhead of the extra is_vmalloc_addr()
test. Possibly also the call of kfree_rcu_sheaf() if it's not inlined.
I'd say it's something we can just accept? It seems this is a unit test
being used as a microbenchmark, so it can be very sensitive even to such
details, but it should be negligible in practice.

> 
> --
> Uladzislau Rezki


