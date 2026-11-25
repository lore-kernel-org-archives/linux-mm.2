Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62755606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 00:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4FVoxd9
Received: by kanga.kvack.org (Postfix)
	id 710246B08C0; Tue, 24 Nov 2026 19:59:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0A96B08C1; Tue, 24 Nov 2026 19:59:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD9F6B08C2; Tue, 24 Nov 2026 19:59:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E80C6B08C0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:59:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26EFB160D1E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:59:03 +0000 (UTC)
X-FDA: 85471832166.01.EE4A5E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 747F3A000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:59:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4FVoxd9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795568341;
	b=BjG+dF0De439lOlh+LXA3lYBTZdHeEtJT5KS/25RTzX7nYvkHtQw8z5mvB3HKTsh2zF0Vj
	QifBFQUAWkIUet8tIcMKioqtklb/ounH94fCHVQW/oxQ+uhsPx4w+jwbQAmxiqXsMLdqF0
	QdOzmqOYOee4pDOn1K+XUFjOZG7b2hw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795568341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKiOmNB/wL8PK/VYoD9bXTOiao/WG65tctz9b6e9EvU=;
	b=FUyZJZPi+kEDtF8nxDWOCqDog3svRuqW3WeB2nSENEB62F9gO9NXIo4Rf/nN/iJEODAQFZ
	K5A12dhmE/sNQwRf47HPyvm8odeINySl0j8MOI81Sx+nBGqujkbe1fzmLvkyy7Q0PWJvEi
	akxtcEPsaf66/A/p3r7sh1RsiScAQ6Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4FVoxd9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B273609D3;
	Wed, 25 Nov 2026 00:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05E91F000C4;
	Wed, 25 Nov 2026 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795568340;
	bh=dKiOmNB/wL8PK/VYoD9bXTOiao/WG65tctz9b6e9EvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P4FVoxd9Eg0VsucVuGUOODM3qiX3BNDn6ApFltNWVFEyV4OIbBhhM/6R8wF1JGr+F
	 jjVBTq40su7OkPbDqFFCQG1+NeNFlI1TbUy6FBkRzRg8oYGZpRL/41+FjmFH1L9Xhv
	 bu8Iosh9wLVsMcPVgrD+P+5bjvTflSeB6sqEZ10QGb7Z8FLRaE/fktrpUNDejQsKAt
	 oVm3dGa9NJUk0vY1FkSKXWs4yzykSEmN/G1RPLo3/lp1/GgTgyQCxyG2MXSnDVg2/M
	 AeFH5O7tWyGWIah9pFCPBsJhJtt8guOsll4rqwmFM6alm6f8+ReiPDW8HyxDh2r//I
	 /44BxjZQTXbqA==
Date: Wed, 25 Nov 2026 00:58:58 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression
 batching
Message-ID: <awYsDfYqrS2ldOTw@google.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com>
 <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 747F3A000A
X-Stat-Signature: wyncu5xgkaeyg31x4uud4ocokjhrwjw8
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795568341-823777
X-HE-Meta: U2FsdGVkX1/6X600OsFiXvfYivB0COSjiQvXvdY8U78ZFhnz7gSdkNCGAL0eKonpR9FwdjEebkHlpD0wyeiB/Vhh9cIC1JE48dG8vdTeNojANIEZi7Y7trWJXcomc+dZ9x5LBCu5kk06Vsr8l2v9duJWSC3SNsoj9O1BSoShHy5eKG/uqQgmg5eKONGohXBt4wjKLP6aSgCH5uMJrNphfemQp1hgdBZ7DjoVm4wFyfI4Y320oSxoNO8PcqofmF0Sftbbm/b6S2KCHGBx8HQDIxHlCEbDwGEduj6oP3Xom9gtk8jr1MgReVtAobTqcggfUT3p8aFVkcTXIpdgwANoerTqqbv+DLYIdq1fhr3TRGoknw6A/1aU3/V1YB21lgE1phFphqca5oV4NWkG4WQbpsVzkDCRTgUOKvIL/X/S1SYecHMKRy35Ssfz32Fa3NOXyotShw4kAsQBWtGBNlfdPbCsHUAwVyMWr5+YeOpwqRILaIROcWe0h6Cyz8WIa5wkUCNk4Gjp6LQ8zrlP+MUCY+Y0chOb/l7of2MIlalEpOfBxV7bG6eKXP2A3NM1aOIaAMEha8MPBb8oe+Ui/ykte3xuRpvAt4Nor3asTNorzcUEdmGdeF9DWJM15NJaEBAdKIsQkgYj+aH1QertLs//hTizuZEjDx0heC4G2ZMwp6nrxXzhhn2x7QnHbyoWNc3OJx0gWMy+zC+ehbSeUTYKJPryle4vJzzAdPC9H4OXh/XoBF3tTM/ti0XWTVguNULrUOwEmhtZCWZZOgjh9ZBPK0LJ5cktvvE2ROy6n126Lf+7oPzreRsj7s69rczaj3s9I0yaLzA9G29x9YeaL1CsnvahufPIZPJauVUF/4VGMGmVkks5Q74uY4sTxBYdPQGhhSNtU4Lcm1MymDPHLPSaXvBGc9REbx6aXc9RIXlRoShzx85Fn6MUSXrnCFNnxNa/ZU/jgLKI2Eslf0pb3g0
 i1b5wId0
 Mqjp5GwRZXN/yK7aVyOi6n7dOEudeCwmjADxc1mqaQTcgzJUigPXih2qdPExraYCVA42FHOs08kLGhYc0118qetL/vpdY6l434/xvw7gCKEri59ti9J0aBbycRHsHw4fKak8H73LFfoI3A/tGu77MUXDhdOGUEB91/BQHVNdcS4cO4EQEcAa31rcJSXL6CMY98VzssSSFE8FG7C/mv1ispVd7bmz+scgNjhOCErOH4Xefcf3XEY+MipSmUCGFKkii4TasnDivw33WiLgNCyA6cLwryGXTPbNVxK7CwPgyx4AjCTcJ6ePpwaOCwGl8X9y5JHu6SiL485HcNzgMWzSzwOQ+QVz3ENPu+z50Ywf5rGhJZlD4PCQYdpzWzt4Jsiq3Lj1ASXwOUz+6fbBhqL4mBwJ7BuQaD7cyiXQxThWiSz9Aa5f3bz6vJkkNn2f7HyZAl02qdaSv3cdcSWKFyp9QTkCypZFYhr225QD0mQCxcBl+6DyT8ufUCMuD7d+gO8ZeCRwaKaxJ7634xm0S6nrGn0vY4AW/NproiTlcFHve+FNWGvf3ezkpXab95NDhmvfHNLxjIywWGQhlHTo7TOyyeDbw93B3YX6gyjDI7OJpftk1wFQZejczJTe8GXlzkZKyZtOm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 03:45:52PM -0800, Kanchana P. Sridhar wrote:
> On Tue, Nov 24, 2026 at 12:29 PM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Fri, Nov 20, 2026 at 03:16:32PM -0800, Nhat Pham wrote:
> [...]
> > > Have you tried perf-ing the store path to see what was the overhead
> > > source (before and after this optimization)? I'm curious.
> >
> > So I was able to reproduce the usemem30 sys/wall time improvements here
> > on a Sapphire Rapids machine (both in a VM and on baremetal), and I
> > threw my LLM at perf-ing to figure out what the overhead was. It's
> > important to note that the sys/wall time improvement I observed was on
> > the free phase, the write phase / throughput (which involves zswap
> > store) didn't show much of a change.
> >
> > Batching made more consecutive pages that compress to the same zsmalloc
> > class more likely to land in the same zspage, so the freeing path gets
> > faster as the zspage and metadata are hot in the cache, which alleviates
> > contention on the class lock.
> 
> This is a real performance gain with batching, correct?

Yes, but I don't think batching stores is the right way to get it, see below.

> > I think the memory allocated by usemem all compresses to the same class
> > size, which makes holding the class lock in the freeing path a
> > bottleneck. I confirmed this by a hacky patch to shard the class lock
> > into 32 locks, which caused the same usemem improvements and the series
> > doesn't improve performance anymore on top of that change.
> 
> I think we all agree that vm-scalability/usemem is a
> microbenchmark/standard. I am not sure I understand the value of these
> "hacks", when my patch-series posts data with the standard mm-unstable
> and my patch series with a standard usemem microbenchmark.

I think the real gain comes from making the freeing path faster. What I
am saying is that we should optimize the freeing path rather than
batching stores to get better locality in zsmalloc pages, as this only
speeds up the freeing path when most data in a batch falls into the same
size class in zsmalloc, which isn't the case for real data (e.g.
Silesia).

I am not arguing that usemem results are not valuable, I am arguing that
there's more to the data than just usemem latency/throughput being
better with the patches.

The hacks were just a way to test the theory by eliminating zsmalloc
class contention. I am looking into proper optimizations for this path,
the goal was just to see if optimizing the class lock contention in the
freeing path would achieve the desired result.

> 
> >
> > I also tried usemem with Silesia to get realistic compression data
> > (similar to Kanchana's testing on previous versions), and didn't see
> > similar improvements (because the compressed pages get distributed
> > across multiple classes). I also tried a kernel build and the munmap
> > microbenchmark in [1] (which Sergey quoted in [2]), which also didn't
> > show improvements.
> >
> > That got me curious tho, and I had my LLM explore other optimizations to
> > the freeing path. I think we can get similar improvements in usemem
> > as well as the munmap microbenchmark [1] by batching zswap entries
> > freeing. We can batch both the zsmalloc object freeing as well as the
> > LRU deletion. I am still looking into it and I might send out patches.
> >
> > But I think this series doesn't really move the needle on realistic
> > workloads, as I previously mentioned.
> 
> Your statements and hypothesis based on the kernel hacks don't explain
> why I see 6.56% additional Sys time savings with compress batching
> over the gains observed with store batching alone. I am not sure how
> to interpret your statement above without your posting any data.
> 
> Did you get a chance to see the usemem/ZSTD data with/without compress
> batching that I posted in [1], and my analysis of the breakdown
> between performance gains from store batching vs. compress batching in
> [2]?


Yes. I tried rerunning usemem on a similar setup to yours, and
aggregating throughput, total sys/wall time, as well as write/free times
over 10 runs (write comes from throughput lines, free comes from freeing
lines). I did this at the baseline, with patches 1-7, and with patch 8
on top.

usemem30 (usemem -w -O -b 5 -s 10 -n 30 10g):
      kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s)
      base     2355.6 +- 25.3       94.24    55.62    26.82    212,239
      p1-7     2366.7 +- 22.9       94.65    55.91    26.90    211,108
      p1-8     2197.0 +- 37.9       89.65    55.48    21.66    212,853
               (-6.73% vs base,
                -7.17% vs p1-7)

AFAICT the speed up happens on the freeing side, not the writing side,
so it's not really zswap stores getting faster. In the freeing phase
(66%-100% of the run), ~90-92% of cycles are spinning in zs_free(), and
total cycles drop from ~1.64T to ~1.30T (-21%).

Running perf on the baseline:
---------------------------------------------------------------------
    # Total Lost Samples: 0
    #
    # Samples: 465K of event 'cpu/cycles/P' (time slices: 66%-100%)
    # Event count (approx.): 1636895619486
    #
    # Overhead  Symbol
    # ........  ............................................
    #
        92.29%  [k] queued_spin_lock_slowpath
                |
                 --92.26%--queued_spin_lock_slowpath
                           |
                            --92.17%--zs_free
                                      zswap_entry_free
                                      zswap_invalidate
                                      __swap_cluster_free_entries
                                      swap_put_entries_cluster
                                      swap_put_entries_direct
                                      __zap_vma_range
                                      unmap_vmas
                                      unmap_region
                                      vms_complete_munmap_vmas
                                      do_vmi_align_munmap
                                      do_vmi_munmap
                                      __vm_munmap
                                      __x64_sys_munmap
                                      do_syscall_64
                                      entry_SYSCALL_64_after_hwframe
                                      0x430ef7
---------------------------------------------------------------------

With your patches:
---------------------------------------------------------------------
    # Total Lost Samples: 0
    #
    # Samples: 372K of event 'cpu/cycles/P' (time slices: 66%-100%)
    # Event count (approx.): 1295809013413
    #
    # Overhead  Symbol
    # ........  ..................................................
    #
        90.75%  [k] queued_spin_lock_slowpath
                |
                 --90.72%--queued_spin_lock_slowpath
                           |
                            --90.03%--zs_free
                                      zswap_entry_free
                                      zswap_invalidate
                                      __swap_cluster_free_entries
                                      swap_put_entries_cluster
                                      swap_put_entries_direct
                                      __zap_vma_range
                                      unmap_vmas
                                      unmap_region
                                      vms_complete_munmap_vmas
                                      do_vmi_align_munmap
                                      do_vmi_munmap
                                      __vm_munmap
                                      __x64_sys_munmap
                                      do_syscall_64
                                      entry_SYSCALL_64_after_hwframe
                                      0x430ef7
---------------------------------------------------------------------

Adding some instrumentation I figured out that ~all memory from usemem
ends up in the same size class, hence the better zspage locality from
the batching in patch 8.

Here's the bpftrace data I collected, I don't see a material change when
probing zswap_store():

    zswap_store() (2048kB PMD folios, 178.9k calls):
      metric         base           p1-8           delta
      p50            10.76 ms       10.85 ms       +0.87%
      p95            11.34 ms       11.40 ms       +0.59%
      p99            12.15 ms       12.05 ms       -0.82%
      avg            10.80 ms       10.84 ms       +0.40%


Also if I run your modified usemem with Silesia like your previous
versions, the improvement goes away (because data no longer all goes in
the same zsmalloc class):

    usemem30 + Silesia (usemem -w --read-silesia -O -b 5 -s 10 -n 30 2560m,
    memory.high=38G):
      kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s)
      base     1779.0 +- 8.5        72.84    55.34    6.92     53,290
      p1-7     1775.7 +- 7.3        72.81    55.29    6.86     53,337
      p1-8     1771.8 +- 7.8        72.58    55.19    6.83     53,435
               (-0.40% vs base,
                -0.22% vs p1-7)


> As per the data I posted, compress batching of PMD THP with ZSTD
> yields an additional 6.56% Sys time savings and additional 1.12%
> Throughput improvement over zswap store batching. Combined zswap store
> + compress batching yields 13.87% Sys time reduction and 3.85%
> Throughput increase over mm-unstable. I think this clearly
> demonstrates performance benefits to a well established
> microbenchmark, run at scale, using upstream kernel git trees and my
> patch series.

I am not saying there is no performance improvement, I am saying the
performance improvement is a side effect of locality in zsmalloc, not
faster stores, and that it doesn't reproduce on real data. If we want to
address lock contention in zsmalloc freeing we should address it as
such, not by batching compression.

> 
> I would appreciate comments from Nhat, Johannes and Andrew on these
> posted gains/analysis:
> 
> [1]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026@gmail.com/T/#m33e586ec89ed46790da284e7a2f6d99b50c9f935
> [2]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026@gmail.com/T/#m51d7d13809d508a9116904c01bf3c94fdf2981dc
> 
> An independent replication of the gains posted by me in this
> patch-series, using standard mm-unstable and vm-scalability/usemem
> would also be very useful.
> 
> Thanks,
> Kanchana
> 
> > Regarding the bpftrace
> > measurements, I couldn't reproduce them. I think one factor is that
> > probing both zswap_store() and zswap_compress() makes the zswap_store()
> > numbers different based on how many zswap_compress() calls we make
> > (which are less with batching) due to the overhead of the probe itself.
> > When I trace zswap_store() without zswap_compress(), I don't see
> > meaningful changes in latency.
> >
> > [1] https://lore.kernel.org/linux-mm/20261016120927.3191690-1-hongfengchen@xiaomi.com/
> > [2] https://lore.kernel.org/linux-mm/20261123054746.2579253-1-senozhatsky@chromium.org/

