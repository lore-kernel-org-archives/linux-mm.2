Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F95C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5BF6B0088; Tue, 15 Sep 2026 10:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC366B008C; Tue, 15 Sep 2026 10:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A706B0093; Tue, 15 Sep 2026 10:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACC646B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:09:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37221A0426
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:09:37 +0000 (UTC)
X-FDA: 85216179594.25.233B794
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	by imf18.hostedemail.com (Postfix) with ESMTP id CDC761C000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:09:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rrLMj8Ln;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789481375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYl1Eh6N+IBYe+qb5q1XhMirmXnrEURSGPUsXSO/57U=;
	b=4qjLirZoFamB8bkhnAqU2+hjDFCR5yvndYQko7Chwku2vxZ1is2PzyrCdXgDx/m6/+Jz/+
	cM+GpVTYJqGOuk79BT2td8imPMowzCino8gOIF3r/f4MlYuDvBUnXLKUqjF6cy9KxsbkxN
	pnWZYD87bDfqpCpl2CTI9Lpzm7hzhT8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rrLMj8Ln;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789481375;
	b=h4Yc15teU9Ru57gcox7iYh4if3hrsf3vSJ8yfJRMZaymtaAgICfvJoUbYM7QnMUdjcp6As
	Uv9UFpketp2EXU6+OwJ8Enojp9RuoTiOvxwOkAg5Lohc5tF1ssX8xatk0WbD3XEeRNxaRu
	Afh+S7oGVyvWiVwotSyC7GI5jbi2dZc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=He79VwyqA/A7y/x2AwYJsg4nK7NmCJ5xYttTnGrxq40=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789481373; v=1; x=1790086173;
 b=rrLMj8LnAlCdzuhjsWBTRhGXJ+59Z50PlRWzCc8NBd/3wCsnsnl5R615jfk+C78oxbT5dCGF
 2upapOS4gd9lB4Akg6wHA4DBQ6y2ArHTKLBjSYetfw/l3byW3JEkWftsgsYCFEkeLkd9HXB1yik
 /NyxgtgfrRL8vLXzMbrfvExA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 167173392c468344;
	Tue, 15 Sep 2026 14:09:23 +0000
X-Mizu-Trace-ID: 167173392c468344
X-Migadu-Flow: FLOW_OUT
Message-ID: <ae847e8a-8c16-4170-a18c-19adb1a50de2@linux.dev>
Date: Tue, 15 Sep 2026 15:09:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 00/29] mm: PMD-level swap entries for anonymous THPs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914203237.7cdfcd4c320470f4ae5cafd2@linux-foundation.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260914203237.7cdfcd4c320470f4ae5cafd2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDC761C000A
X-Stat-Signature: g6u5apzdoaawy3mwbhkee1jszntkbwu3
X-Rspam-User: 
X-HE-Tag: 1789481374-358930
X-HE-Meta: U2FsdGVkX18Oj/JaV9bqblQQR3Go2odyKtn3vU9bpSVGh6ndR1T/6P7muEU8e/BOppGdz/I3XlyxJS/wBoGQIQYHKHa617bv2Nn89j4QXHX714P3qPPkUmEzUcnDJ33EJEV+S81LRGR4yrMAr9pbKSpbjcBTvyxjre9+k/IIsDf2rrdOjmUTr8vH3Tf305bAhyXTtRdU9kMEs7yBUXsijZrD0fEQ0NjCiITo33xCth62jwvFLOQyaEmHI6pJDJhPljPDDmRyW6LIYTwE4liEi/1dwVDcm9JssRmaqMg8x3t8j4z+vYSrjiA8yJd7Ak4r6km1+NdTv/gt+BrhG+D1/+z7V0kYcfFuGOlS3hL2nvbsqcEBGexNiknE8RqnomzYmJSGV6/fIsM+fegXXGt+dnkrIoe8BU15ISg4fHGyqHZC7or8PdIzWMXEsMN2PVcCuEqoprK/PWvm+531Zd0l+gGLG3aGuHXFmjsRf3yruoeUd9mHIif/ooofpKUP3a99JbT0Ijahf74/e1t8ui9yb8bFpIsJagRgledyhSpnD8x0YWnA9E1KbqDUT5Bfp5c6UbQYvqE169PXu0yfRY0zF4M4icEU5ddZnrOGEI6ZPItZ/ufgvDXZGLZzc87qMWPTevmet+TdrRFn7TldXGcEjQrkEqgXxfbTYY2leX9dlh7bEtfR38TF7AwKD8LWZ/zmuqWUTmWy4PCJtbxltTKcp/bInm4B7J7iYrnm3FAALQDzs0IYxXEmtHrRdZpSlTCfnVcoBQMcMyujAPRgQ+wfPKcPCQbGAY+eco4J3jy6KsMvpc7XvhlKz9X1B369Q8Fl68xo8+4v2mDdD0m3fowOIvR7+poS7uwAgfzBcyAn4gC8XsEI3jMUFCgga2EcNK9xiygBz3/ClbF1DaH0XCqZYrDGKQ5Ac8qq0KQ2SksUiVcdVbX70IvFUo9aDjt+wXTlbIwmGhTUAkFjt/8VXas
 dW5MpLmc
 HbkqEXaldNtAD1vUxUMxItWF90NNEdgab7sCSHSbpAXA685vpPuFLshWyehjMciITtTkrNDHUgwnSPgtFIjZmvWWVpX0556Lyg2PoMgkDaGTIEhI+GQV3oUrGX5m+Mwxpse8WM9nL8WVAB8Wu6LBBhzyuvyk2yp0Ouc8pBlGOcvPArvZqoV00UZoXqUkHNJ3ZxljVBsL+aF7PnE/L9pSFg8zVxEgoe13nNhoIm+x0EdfmhrATGSOscoMuj4oyve4AC/ZUbVCsr3/9JLhuLRH9RbE/UmABDyJ0S12aJ8p93qGp68k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/09/2026 04:32, Andrew Morton wrote:
> On Mon, 14 Sep 2026 05:27:50 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>> split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
>> before unmap.  This series introduces a PMD-level swap entry so the
>> huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
>> can restore the PMD mapping directly on swap-in, without waiting for
>> khugepaged to collapse the range later.
> 
> Thanks.  I'd describe this as an inevitable step along our thp journey.
> Has to be done sometime.
> 
> I'll await more review, especially of the core parts: pmd swap fault
> handler (#27) and swapout producer (#28).
> 
> And it's a 29-patch performance optimization without any performance
> testing results ;)  Is efficacy testing in the works?

I previously tested an older revision and reran the test this morning
with the current revision. I used vm-scalability's case-swap-w-seq
benchmark [1].

The test configuration was:

- 4 vCPUs and 4 GiB RAM
- 4 pinned workers
- 8 GiB NOCOW raw virtio swap, cache=none,aio=native
- zswap disabled; THP allocation and defrag set to always
- 6 GiB total anonymous working set
- 8 sequential write passes

Four workers repeatedly write the working set, forcing memory to be
swapped out and back in. The results below are the medians of five
interleaved runs per kernel, following one warm-up run:

Metric                           Baseline median   Patched median   Change
Aggregate benchmark throughput   584.3 MiB/s       2,408.9 MiB/s    +312.2% (4.12x)
Elapsed time                     85.43 s           20.72 s          -75.7%
Major faults                     1,814,699         228,466          -87.4%
Swap I/O rate                    1.02 GiB/s        4.10 GiB/s       +303.9%

The results look good as this is a swap-intensive workload.
It primarily demonstrates the reduction in swap-fault and page-table
overhead from preserving PMD mappings.

For long-running workloads, where I believe the series will shine, I expect
benefits from fewer TLB misses, less khugepaged work as well as less kernel churn
due to larger folios, although there aren't a lot of benchmarks to test that.
PMD swap entries also move us closer to eliminating page-table deposits for
anonymous THPs, which would provide memory savings.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-swap-w-seq


