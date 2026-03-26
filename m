Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E58D10A62FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 14:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC986B0089; Thu, 26 Mar 2026 10:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0866D6B008A; Thu, 26 Mar 2026 10:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90316B008C; Thu, 26 Mar 2026 10:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4B2F6B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:42:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8369813BB48
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:42:12 +0000 (UTC)
X-FDA: 84588479304.30.85E493F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B1DFA1C0003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:42:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJGW7ISV;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774536130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfVQux8xXbvE3mOKP+p6blgPBFvKdzztd0WHKrIC8h4=;
	b=IMHpoCOJTkvu5yb5liQVMcfTkX4y9Ar9B2SEy5eBKXZT2QUjfLgcXwfN4Mm9McqjCa9M5A
	s9+pf8uWC8kyDqhYTg89D2Avf/upgZLgaa+vzXWJmp4A8MlnjN9xuK59u/rwMPJXXs7ORp
	MBaMamN1IMb6X6Y4eVtEsSVMLrqQTm4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774536130; a=rsa-sha256;
	cv=none;
	b=UUhpzexzFfX2zVjwMD5O+LqRJ8dHSEhfGAHpHsPha38tgKzW9+9fJqNEjs1mdXz81NFueW
	1xujP939AX9W0o503HsYk+0VuTfIK6HvGspou1Smpd0eBVEGGUH7PRa4HbQTiMYnyKe/jl
	qipVaITVD+KC5IOkBx+JqoE2HpZEN+Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJGW7ISV;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C20934435C;
	Thu, 26 Mar 2026 14:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649AFC116C6;
	Thu, 26 Mar 2026 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774536129;
	bh=7TlnbERDNjc6uhJyi+oMJD2jmKqEDwbDwVIc+hkUZEQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oJGW7ISVLU2YiYHfmF5uSo+2vBsV7P+HyOWUTkVjZKUT8dhqGFtnzWEi1id2M6bFl
	 zK2k2qodpuiHzPdLVNhbAiq+eG4LedGvj7suugTlzkwLpNVM/aRx0DtHBy1Puv4mm9
	 0PxiWYbPDTa4UokhoT/9S0hIDIDFNuZ3u/6XGd2ESe1YfWRmfaJnflgbQSCMy64REw
	 VOIDaZ67yv0TFyxmgLT7qvHEudIoKJLA5ZmtsQlItctgitEOhgrPZmXjdFZn2hksMt
	 xnA6j1oErvGfId4Rp7xhgzQ1rOBxU+44fHaS8yWqpLw0uQUMCHFyZz1rQUveRi3uBg
	 1TNLNwaxYFUiQ==
Message-ID: <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org>
Date: Thu, 26 Mar 2026 15:42:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-US
To: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
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
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <afe9ba0a-1924-42a8-a9c5-34eec709f883@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1DFA1C0003
X-Stat-Signature: jfmbk454utg4zjkuptxww5iqu4q6kd1n
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774536130-566976
X-HE-Meta: U2FsdGVkX1/8cXPx9JIMcp4RptIkY80MwuFClOeLA6lISxoaNNgz4Bzh9T594PFxYZNItF+QBF/fswPtbC0bZJneIA41Z4clXp7kuBAaPrzalxCX3gi/y3Bu6iXa4o2/GZqzKXx6ohXt8GPuFlG6zbyFKbWTxdoAFYBvS8XK33xLtvq+fHCLamHil1eWZJIgArTEhyQY8slBazRUr7YrFPwwlrASJkojZbkHunfais/aMEH/5q6q3kHrrQhhTxHLelw4ZNUgYvhCkEocQN7iUfXG/jIUWBrtkQpdbBETqvrJbOv1Bc94fjFnIckNnMy47TIfhB9IfK7saBIiIYZJLwlDZdvRYLuvr/t98gBz2T9pBKl6uZbjhCtJ0lGgtgcj2/4UTi2VO7iG8FvM6kHGbLNWYRI1L3ePc35FFqp5CeRCNuaCiqkolumPWjGKh07z2j2JwrwQ58qUrF2M3BVWK8lfujaljyVLmHNpIS3MDjqYUAdvFpsn0B27nmzVq6hufJ9CuVgvxF82ffSFkidqqtOfDf6gWcEZS4dkjyveekvkSGghYs8Z8Pw2oAqyTXyLRdGj7GGeMO9yBH/JSUJ/AXhQjC7ytuh1uK8kbssp8+YYMTVAYr3dLkFnCbCRsZYYSdzdTFo8zjhYGjKMDnRMCAuCji3T/LxdxFf21NssXqb8gsJwAHcDllnkVvxRZ6QyR/g/U9mRQVIMKBQI9+bgrtBE2R7SAcnKIJkSYiNzsW78GJEExVr8Xy2VmL5iGMxU/r4Ykdw0x+qVNUVuvlAzobNELVbSovhK2tMXxuqG6dJfWNGZTwECLrbSaFe1s1EicSk8aKkt3GbvcMGfZ4sLNh6BmVoOncjMavGpoKqYmzeca1IIURnunxzxgsYreiM2qPncuHcxs3hQHzi8LecOPxp03MvJIgV4t30FWXmaw+M22P6rrjRkrHhoyy5flVrdrlg94eBBMGbmVlhHdRJ
 Y9J3y52X
 8NAxAvjVipq7spWrJeOcKJoqHuUk+VG8UgLICrDeXas3rSEEO832djG8+h3urSSi0cDpDP5jP/fL5D8s2HfW5OANChaTIOM+eLmet6EoEV1pRLEg88DXqDism/3i2Law2gIdE8jta44PxDXhzL3vnpLbY4tugmXDlTjHHxOqjkEU7hMpOEzEaMRO1ecYRLDggkw3nfEu7ziVvVQO8JmV55nX8tE2qde28kvbY3Mu7JQOc/yVxoLyWh0lJ34cbaKcl/sVtsI26BGTJCTQ3xdnmBRCja5iB8vY/fRCp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 13:43, Aishwarya Rambhadran wrote:
> Hi Vlastimil, Harry,

Hi!

> We have observed few kernel performance benchmark regressions,
> mainly in perf & vmalloc workloads, when comparing v6.19 mainline
> kernel results against later releases in the v7.0 cycle.
> Independent bisections on different machines consistently point
> to commits within the slab percpu sheaves series. However, towards
> the end of the bisection, the signal becomes less clear, so it's
> not yet certain which specific commit within the series is the
> root cause.
> 
> The workloads were triggered on AWS Graviton3 (arm64) & AWS Intel
> Sapphire Rapids (x86_64) systems in which the regressions are
> reproducible across different kernel release candidates.
> (R)/(I) mean statistically significant regression/improvement,
> where "statistically significant" means the 95% confidence
> intervals do not overlap”.
> 
> Below given are the performance benchmark results generated by
> Fastpath Tool, for different kernel -rc versions relative to the
> base version v6.19, executed on the mentioned SUTs. The perf/
> syscall benchmarks (execve/fork) regress consistently by ~6–11% on
> both arm64 and x86_64 across v7.0-rc1 to rc5, while vmalloc
> workloads show smaller but stable regressions (~2–10%), particularly
> in kvfree_rcu paths.
> 
> Regressions on AWS Intel Sapphire Rapids (x86_64) :

The table formatting is broken for me, can you resend it please? Maybe a
.txt attachment would work better.

> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> | Benchmark       | Result Class            |   6-19-0 (base) |  
>   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |  
>   7-0-0-rc4 |   7-0-0-rc5 |
> +=================+==========================================================+=================+=============+=============+===========================+=============+=============+=============+
> | micromm/vmalloc | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 
> (usec) |       262605.17 |      -4.94% |      -7.48% |             (R) 
> -8.11% |      -4.51% |      -6.23% |      -3.47% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 
> (usec) |       253198.67 |      -7.56% | (R) -10.57% |            (R) 
> -10.13% |  (R) -7.07% |      -6.37% |      -6.55% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)           
>   |       197904.67 |      -2.07% |      -3.38% |             -2.07% |  
>      -2.97% |  (R) -4.30% |      -3.39% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 
> (usec)  |      1707089.83 |      -2.63% |  (R) -3.69% |               
> (R) -3.25% |  (R) -2.87% |      -2.22% |  (R) -3.63% |
> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> | perf/syscall    | execve (ops/sec)            |         1202.92 |  (R) 
> -7.15% |  (R) -7.05% |         (R) -7.03% |  (R) -7.93% |  (R) -6.51% |  
> (R) -7.36% |
> |                 | fork (ops/sec)            |          996.00 |  (R) 
> -9.00% | (R) -10.27% |         (R) -9.92% | (R) -11.19% | (R) -10.69% | 
> (R) -10.28% |
> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> 
> Regressions on AWS Graviton3 (arm64) :
> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> | Benchmark       | Result Class            |   6-19-0 (base) |  
>   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |  
>   7-0-0-rc4 |   7-0-0-rc5 |
> +=================+==========================================================+=================+=============+=============+===========================+=============+=============+=============+
> | micromm/vmalloc | fix_size_alloc_test: p:1, h:0, l:500000 (usec)      
>       |       320101.50 |  (R) -4.72% |  (R) -3.81% |               (R) 
> -5.05% |      -3.06% |      -3.16% |  (R) -3.91% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)      
>       |       522072.83 |  (R) -2.15% |      -1.25% |               (R) 
> -2.16% |  (R) -2.13% |      -2.10% |      -1.82% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)      
>      |      1041640.33 |      -0.50% |  (R) -2.04% |                 
> -1.43% |      -0.69% |      -1.78% |  (R) -2.03% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)    
>       |      2255794.00 |      -1.51% |  (R) -2.24% |             (R) 
> -2.33% |      -1.14% |      -0.94% |      -1.60% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 
> (usec) |       343543.83 |  (R) -4.50% |  (R) -3.54% |             (R) 
> -5.00% |  (R) -4.88% |  (R) -4.01% |  (R) -5.54% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 
> (usec) |       342290.33 |  (R) -5.15% |  (R) -3.24% |             (R) 
> -3.76% |  (R) -5.37% |  (R) -3.74% |  (R) -5.51% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 
> (usec)  |      1209666.83 |      -2.43% |      -2.09% |                 
>    -1.19% |  (R) -4.39% |      -1.81% |      -3.15% |
> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> | perf/syscall    | execve (ops/sec)            |         1219.58 |      
>         |  (R) -8.12% |         (R) -7.37% |  (R) -7.60% |  (R) -7.86% 
> |  (R) -7.71% |
> |                 | fork (ops/sec)            |          863.67 |        
>       |  (R) -7.24% |         (R) -7.07% |  (R) -6.42% |  (R) -6.93% |  
> (R) -6.55% |
> +-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
> 
> 
> The details of latest bisections that were carried out for the above
> listed regressions, are given below :
> -Graviton3 (arm64)
>   good: v6.19 (05f7e89ab973)
>   bad:  v7.0-rc2 (11439c4635ed)
>   workload: perf/syscall (execve)
>   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
>   kmalloc_nolock()/kfree_nolock()”)
> 
> -Sapphire Rapids (x86_64)
>   good: v6.19 (05f7e89ab973)
>   bad:  v7.0-rc3 (1f318b96cc84)
>   workload: perf/syscall (fork)
>   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
>   kmalloc_nolock()/kfree_nolock()”)
> 
> -Graviton3 (arm64)
>   good: v6.19 (05f7e89ab973)
>   bad:  v7.0-rc3 (1f318b96cc84)
>   workload: perf/syscall (execve)
>   bisected to: f3421f8d154c (“slab: introduce percpu sheaves bootstrap”)

Yeah none of these are likely to introduce the regression.
We've seen other reports from e.g. lkp pointing to later commits that remove
the cpu (partial) slabs. The theory is that on benchmarks that stress vma
and maple node caches (fork and execve are likely those), the introduction
of sheaves in 6.18 (for those caches only) resulted in ~doubled percpu
caching capacity (and likely associated performance increase) - by sheaves
backed by cpu (partial) slabs,. Removing the latter then looks like a
regression in isolation in the 7.0 series.

A regression of vmalloc related to kvfree_rcu might be new. Although if it's
kvfree_rcu() of vmalloc'd objects, it would be weird. More likely they are
kvmalloc'd but small enough to be actually kmalloc'd? What are the details
of that test?

> I'm aware that some fixes for the sheaves series have already been
> merged around v7.0-rc3; however, these do not appear to resolve the
> regressions described above completely. Are there additional fixes or
> follow-ups in progress that I should evaluate? I can investigate
> further and provide additional data, if that would be useful.

We have some followups planned for 7.1 that would make a difference for
systems with memoryless nodes. That would mean "numactl -H" shows nodes that
have cpus but no memory, or that memory is all ZONE_MOVABLE and not ZONE_NORMAL.

Thanks,
Vlastimil

> Thank you.
> Aishwarya Rambhadran
> 
> 
> On 23/01/26 12:22 PM, Vlastimil Babka wrote:

