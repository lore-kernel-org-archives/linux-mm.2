Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7250F10BA420
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7EFA6B00A4; Thu, 26 Mar 2026 23:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56326B00A8; Thu, 26 Mar 2026 23:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6BF76B00AA; Thu, 26 Mar 2026 23:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B64956B00A4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:20:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61DE31A0DBE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:20:16 +0000 (UTC)
X-FDA: 84590389632.06.AA02A24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BFCF010000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:20:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z0XL+JbA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774581614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NaaY4qwN0maBgVqFABrsQO8yT+Y76Sc6HvG+SRlBmQQ=;
	b=kr68LZnZdLHxI3Sjl79hu5GVrtY5XOrWRuOAlcIDzFO1t9BdJVA3jJ0Z+NOYxRjOURyfz7
	9gWdlPh3cRMhZNfJLFy5hpDCNEgM3B1Q61iCmFR5O4peQuUo4U6hdXlVaaD6I/1Elibn5o
	IN8MDChhOrh5bDcKaNNvwFNDSXVUJpg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774581614; a=rsa-sha256;
	cv=none;
	b=CISIKXiTa7M4iZKL+PcLYzhdDFtw0faDVRxNaAyfKIrHijYjXp38lf69PFD16+z4qHWfjx
	AR1RB/Rk98NdOoY94K8uZHb2RiaD0hGkK7LfkfFqhNuQSksWCNynucuLTYKQSnr+RkTSyS
	U6bEkskDa3vItOOgMwj1Y5MKhKBdM2c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z0XL+JbA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17CC960054;
	Fri, 27 Mar 2026 03:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60289C116C6;
	Fri, 27 Mar 2026 03:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774581613;
	bh=3rohkKHMZQSs2BVw73LamMIlHPpx5pWmvpls8oac/OA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z0XL+JbAwseDsRa2gIRo+mhPVfWP36nkJqE9DU2VW9+LjgoUeic597AbmvhNA6gAF
	 HbiLKzocmNLQvYO68jqA5sLxqkVn6sIOLGp4lSw9cLWRj9sbHJdwSS6eGf6GwvdYoS
	 9sTACWuIhhiYse1jfPgrtkX7weuRp2pY7y9uZZtCKIc3AngL8U9iFjW75nRjtN4XqI
	 i7SXgX39UBWVHal+BXyxk0AtmR7y9T73E/Q/G8vi9/tqmL7mgrTtrAkQ9bZnsQyHgj
	 ann5mgDwKks8CFCOZe/A0IUP/OPBcE8EV8fQiJ87xnuiJYDqiCWO/OLmUEuxn0TnkJ
	 jVLcZyqZb1AUg==
Date: Fri, 27 Mar 2026 12:20:11 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org, kasan-dev@googlegroups.com,
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>, ryan.roberts@arm.com
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
Message-ID: <acX3a5w4JGwU_TEt@hyeyoo>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <afe9ba0a-1924-42a8-a9c5-34eec709f883@arm.com>
 <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org>
X-Rspamd-Queue-Id: BFCF010000B
X-Stat-Signature: 91a531opgxx6sarenykr74gzzrokegrh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774581614-717797
X-HE-Meta: U2FsdGVkX19r7+6oWM8MvbGhxnG9XygPxi/+nREx0PJYhfR2HCIDRXScxyY1QAZj062qpa3jLcPhvnFfwe7EV1qT3Jut2/QCAa/7uS4UJkjTvv9kdsq28KLSji4wlaXvQYNS+XnnlsTo4s79A3VwuDsSYHr5jCFl51UwIw+wSKzrB9jWa46gJjEUP/L2e2a+rUaBdVAVfM0Wa57OeNl/fjraRio9yrOq+HsM/VTaWqO3wNXZ3PsXkp1qdk0Dha329rd2QsT1ZxEU5SBBaid/7WHPxm1d8x8hF9MDI6y6iSDep2snYtV7l2bmbg/hksYIa1ZvzdVquydpjeDDaQDvHzfnQ6ouddb/Y7UBJeUrPIKQkH/c4D4qhS/jegou+POL9psvZ4a0TOyPmYp/XdqNI4vuD3VfrA/Au9xkrh+GkwEf60/ucFFRgTjODUOqIQ2nKVPzX3nOdYf7HKTkiBuMRUGYa/mI4ZpWVL2pRimdPgX6YVDI3/6tNpQjypCaiqez6TC8VpQfe6A2jyY+FBBAWK+r3a92Y3XMxwil1PsZHYSUrp6HDml2VBFBgKOnKRZ1aP0pfOfmEeM4MXYDzruWSVuypskp5bkT3lNvfWbVC59OC8De1Tjuh7GCtQyvIZBm2sNTKI1sQs6NoCSAoFzIMf6kiYWXf0mKbwnZSBWUM+TKr0HYuPHKiPHebPHgud0lKrEmoj4GgJYLKFTgWG+xF1QxJl/IDFqgbB76cUagN55L11y2PgcZOw+rmOFZJnRsVm39wOQUmjx+z/1pY07JtXkPI557bxhd+o/Tqa9Tek1pYLroCXaiVg2hNpEfR4kUfQ6WAmrhH6bZ6ZqgzVK2LWGMH8L/8eXVxiW/5Fq4Co3J85ytz9m6K31GngBXTPEJJYpRYdLV/Zse0c1FATKNiv8eixzVNvRCz3DAllPNQw5omFey2hV+5vFJou3Al28EUwFk3CZsdSzNvPtNvPK
 ge4XQr3u
 i+MJU1KZlzPDbb3ytElT+vaJTfN03Z95vVYiiA5gamjTJEtbomyDJf4qobkApmr6mdKWzJTteO1gYnFcW74eu+BzCSY+B586gBR8wx688o0GVYUnfwyWXkm+y7YmJ5YHIJG2I6tPxcf0s4GeSEILm3jCSOOEUZwRTIJxEGbFRziqwo2pIZwvwdPPjkGNnzGTXPoQOQnvFgMaxqt59yUVxZwPRnXPJzuUuBZ02qZWchjcbITvP904LTWGYtAgVBvyDaC6zNQQWw/2DCeEQtJA3TQJJMli0iMXZjUpogO0o+64KEF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:42:02PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/26/26 13:43, Aishwarya Rambhadran wrote:
> > Hi Vlastimil, Harry,
> 
> Hi!

Hi!

> > We have observed few kernel performance benchmark regressions,
> > mainly in perf & vmalloc workloads, when comparing v6.19 mainline
> > kernel results against later releases in the v7.0 cycle.
> > Independent bisections on different machines consistently point
> > to commits within the slab percpu sheaves series. However, towards
> > the end of the bisection, the signal becomes less clear, so it's
> > not yet certain which specific commit within the series is the
> > root cause.
> > 
> > The workloads were triggered on AWS Graviton3 (arm64) & AWS Intel
> > Sapphire Rapids (x86_64) systems in which the regressions are
> > reproducible across different kernel release candidates.
> > (R)/(I) mean statistically significant regression/improvement,
> > where "statistically significant" means the 95% confidence
> > intervals do not overlap”.
> >
> > Below given are the performance benchmark results generated by
> > Fastpath Tool, for different kernel -rc versions relative to the
> > base version v6.19, executed on the mentioned SUTs. The perf/
> > syscall benchmarks (execve/fork) regress consistently by ~6–11% on
> > both arm64 and x86_64 across v7.0-rc1 to rc5, while vmalloc
> > workloads show smaller but stable regressions (~2–10%), particularly
> > in kvfree_rcu paths.
> > 
> > Regressions on AWS Intel Sapphire Rapids (x86_64) :
> 
> The table formatting is broken for me, can you resend it please? Maybe a
> .txt attachment would work better.

A quick manual re-formatting with a hope that your monitor is wide enough
to cover it :)

Regressions on AWS Intel Sapphire Rapids (x86_64) :
+-----------------+----------------------------------------------------------+-----------------+-------------+-------------+---------------------------+-------------+-------------+-------------+
| Benchmark       | Result Class                                             |   6-19-0 (base) |   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |   7-0-0-rc4 |   7-0-0-rc5 |
+=================+==========================================================+=================+=============+=============+==========================+=============+=============+=============+
| micromm/vmalloc | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       262605.17 |      -4.94% |      -7.48% |             (R) -8.11%   |      -4.51% |      -6.23% |      -3.47% |
|                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       253198.67 |      -7.56% | (R) -10.57% |            (R) -10.13%   |  (R) -7.07% |      -6.37% |      -6.55% |
|                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |       197904.67 |      -2.07% |      -3.38% |                 -2.07%   |      -2.97% |  (R) -4.30% |      -3.39% |
|                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |      1707089.83 |      -2.63% |  (R) -3.69% |             (R) -3.25%   |  (R) -2.87% |      -2.22% |  (R) -3.63% |
+-----------------+----------------------------------------------------------+-----------------+-------------+-------------+--------------------------+-------------+-------------+-------------+
| perf/syscall    | execve (ops/sec)                                         |         1202.92 |  (R) -7.15% |  (R) -7.05% |             (R) -7.03%   |  (R) -7.93% |  (R) -6.51% |  (R) -7.36% |
|                 | fork (ops/sec)                                           |          996.00 |  (R) -9.00% | (R) -10.27% |             (R) -9.92%   | (R) -11.19% | (R) -10.69% | (R) -10.28% |
+-----------------+----------------------------------------------------------+-----------------+-------------+-------------+--------------------------+-------------+-------------+-------------+

Regressions on AWS Graviton3 (arm64) :
+-----------------+----------------------------------------------------------+-----------------+-------------+-------------+--------------------------+-------------+-------------+-------------+
| Benchmark       | Result Class                                             |   6-19-0 (base) |   7-0-0-rc1 |   7-0-0-rc2 |  7-0-0-rc2-gaf4e9ef3d784 |   7-0-0-rc3 |   7-0-0-rc4 |   7-0-0-rc5 |
+=================+==========================================================+=================+=============+=============+==========================+=============+=============+=============+
| micromm/vmalloc | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |       320101.50 |  (R) -4.72% |  (R) -3.81% |               (R) -5.05% |      -3.06% |      -3.16% |  (R) -3.91% |
|                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |       522072.83 |  (R) -2.15% |      -1.25% |               (R) -2.16% |  (R) -2.13% |      -2.10% |      -1.82% |
|                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |      1041640.33 |      -0.50% |  (R) -2.04% |                   -1.43% |      -0.69% |      -1.78% |  (R) -2.03% |
|                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |      2255794.00 |      -1.51% |  (R) -2.24% |               (R) -2.33% |      -1.14% |      -0.94% |      -1.60% |
|                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       343543.83 |  (R) -4.50% |  (R) -3.54% |               (R) -5.00% |  (R) -4.88% |  (R) -4.01% |  (R) -5.54% |
|                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       342290.33 |  (R) -5.15% |  (R) -3.24% |               (R) -3.76% |  (R) -5.37% |  (R) -3.74% |  (R) -5.51% |
|                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |      1209666.83 |      -2.43% |      -2.09% |                   -1.19% |  (R) -4.39% |      -1.81% |      -3.15% |
+-----------------+----------------------------------------------------------+-----------------+-------------+-------------+--------------------------+-------------+-------------+-------------+
| perf/syscall    | execve (ops/sec)                                         |         1219.58 |             |  (R) -8.12% |               (R) -7.37% |  (R) -7.60% |  (R) -7.86% |  (R) -7.71% |
|                 | fork (ops/sec)                                           |          863.67 |             |  (R) -7.24% |               (R) -7.07% |  (R) -6.42% |  (R) -6.93% |  (R) -6.55% |
+-----------------+----------------------------------------------------------+-----------------+-------------+-------------+--------------------------+-------------+-------------+-------------+ 

> > The details of latest bisections that were carried out for the above
> > listed regressions, are given below :
> > -Graviton3 (arm64)
> >   good: v6.19 (05f7e89ab973)
> >   bad:  v7.0-rc2 (11439c4635ed)
> >   workload: perf/syscall (execve)
> >   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
> >   kmalloc_nolock()/kfree_nolock()”)
> > 
> > -Sapphire Rapids (x86_64)
> >   good: v6.19 (05f7e89ab973)
> >   bad:  v7.0-rc3 (1f318b96cc84)
> >   workload: perf/syscall (fork)
> >   bisected to: f1427a1d6415 (“slab: make percpu sheaves compatible with
> >   kmalloc_nolock()/kfree_nolock()”)
> > 
> > -Graviton3 (arm64)
> >   good: v6.19 (05f7e89ab973)
> >   bad:  v7.0-rc3 (1f318b96cc84)
> >   workload: perf/syscall (execve)
> >   bisected to: f3421f8d154c (“slab: introduce percpu sheaves bootstrap”)
> 
> Yeah none of these are likely to introduce the regression.

Agreed.

> We've seen other reports from e.g. lkp pointing to later commits that remove
> the cpu (partial) slabs. The theory is that on benchmarks that stress vma
> and maple node caches (fork and execve are likely those), the introduction
> of sheaves in 6.18 (for those caches only) resulted in ~doubled percpu
> caching capacity (and likely associated performance increase) - by sheaves
> backed by cpu (partial) slabs,. Removing the latter then looks like a
> regression in isolation in the 7.0 series.

Yeah, going through a comparison similar to what Hao Li did [1] a while ago
might confirm the theory.

[1] https://lore.kernel.org/linux-mm/pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir

> > I'm aware that some fixes for the sheaves series have already been
> > merged around v7.0-rc3; however, these do not appear to resolve the
> > regressions described above completely. Are there additional fixes or
> > follow-ups in progress that I should evaluate? I can investigate
> > further and provide additional data, if that would be useful.
> 
> We have some followups planned for 7.1 that would make a difference for
> systems with memoryless nodes. That would mean "numactl -H" shows nodes that
> have cpus but no memory, or that memory is all ZONE_MOVABLE and not ZONE_NORMAL.

In any case having numactl -H for those machines would be helpful!

-- 
Cheers,
Harry / Hyeonggon

