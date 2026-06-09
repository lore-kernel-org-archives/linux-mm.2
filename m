Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50770CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86F56B0005; Tue,  9 Jun 2026 05:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DFA6B0088; Tue,  9 Jun 2026 05:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73C86B008A; Tue,  9 Jun 2026 05:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98A766B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:01:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40C1CA0495
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:01:59 +0000 (UTC)
X-FDA: 84859781958.03.00AB83A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68FB91C000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:01:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVEG0RfY;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780995717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxId/ZkrcPh6NMXcfHGchtQkdJDxhDbioRaIRwjq1xA=;
	b=Od7xl15Rbq40zxavI2l19i0bQ3kIbU3DfYenhWMlg2ecUDZSAAzc158w6uvi3MM+tCgWhn
	kPYX6kMEsGnbQWUz41CUIC3Rot4Y5e4UN5MjjTwLUE7wD7P32O712p+t+jzIqeax3cDD6A
	zQMj4aRDRClNQBtWFPn/gK5UDO29Pqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780995717;
	b=Wp9GWK3HdsD/aJZcvTzTA9kh61F6mXnqqoKS30F1ZufTzIxsz9qoa4t7qW6AOGizb+O5Pb
	2o+Le9G58T1IWNiDd3wkIFUPjgPABkVzY1xYdCe3yzp4cHXDEHP3UI+ulxoQXuqxphb9B3
	7TG1Cmba2gwJ1OhGDS2r7lyrTd5boVI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVEG0RfY;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D539460172;
	Tue,  9 Jun 2026 09:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222641F00893;
	Tue,  9 Jun 2026 09:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780995716;
	bh=DxId/ZkrcPh6NMXcfHGchtQkdJDxhDbioRaIRwjq1xA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HVEG0RfYeK5dnGD5dsqM4/3jPlLvu41Z3NuHVO4JtW3zT1XW6rVXJfW/LPRYJA35D
	 nmpC2CRMQxUfmDTxvGBzfk1SvzDr9V40AmvVB5B8ds9LwhG+GQRFULnDcEhIbdGU2K
	 VkOU8wPvTzyJPexqvqwaSRTHCCFnLaeKSds1WPeFeFrg4sbbOCSa2h7yHmnveZwBaT
	 NA+KnAPRcZkBvcZRvjfTerKHtKcv0mzBcs8lbYT2OIPJrn3/kTVwvzEVZkO1aZY4aG
	 lZjio3vqlKCcXawBokr98/cUVvkMkXh5yydcR5La2fNvodYxL+AjdKWz+21RrM2nS3
	 KDurh1L9FDjVw==
Message-ID: <74cdec57-67aa-4ae3-a416-e39846049ab1@kernel.org>
Date: Tue, 9 Jun 2026 11:01:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/mincore: present-PTE scan cost after pte_batch_hint()
 batching
To: Chengfeng Lin <chengfenglin@stu.xmu.edu.cn>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>
References: <5fb8bead.17483.19eab4626f5.Coremail.chengfenglin@stu.xmu.edu.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5fb8bead.17483.19eab4626f5.Coremail.chengfenglin@stu.xmu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 68FB91C000A
X-Stat-Signature: 1krxb3f9n7pzyq48zxrf4acntg4nj9zy
X-HE-Tag: 1780995717-827490
X-HE-Meta: U2FsdGVkX1+dAhYsprpTqx/xeQOxYk66mNTkbOlChl3vBy+3LE/7K1c/NQxXm8un8RW5pHa1sbFKF+ecDW2dsGV75VGZV7NxJclCS+q4JK5xIJUM4cm9hdnJlVC0LzbHL8NeW/gFpBnFNkrf4swqW7uxbmT0h4dgnHg+T3vtEnCuOumRvENx/gwO4iNip4N99wSR7lxbonzpuSrHLa8Fog00HiC7WSvnT5LDvWH/6Cao3MoB6S2ylklOnvuWu5GBis2AeGXbXlDoqcj/g9cJuLWkNBfRq2NrF8E0SfDTwq7eiV34zP5uCshm3pikf1IZv6l4EA8/NNZ+BRLJ/t0RicaPHjYn11O1uuR/C2Pr92IytMIGb5U0k5yiilt3N9FCJH2aRkCbW+bK1l1wHi0VAGWb3AiPb5cwiDf4yOAXz2dxZy12Iq1wNdx7bAVI0FYnPnZMzBB4fagK+Pf1z+xbhzsF1G3uIw8Kp7lYrT3kBUfvlFzuO05YYYAi2QBUbdqarjrkuJoZRnhkNd4+elz1tOudYMra6FKcyDSTP7J3o9UzBKKDGvVNVmSRyE+Q4gsihvxuRTG7CP1KNYyup/Qw1i1SHe9EgpHX3YBLvWa+sWIkkyRYDMb+w1EgH/LaBzU1frJuGpIL3/mhC0sEgw2yeRpmmez4S4o9fD9so2PfyFI5cjOb59MDrhekhoqTK5CPD/yHZypXMmVpMnuZ/NyjohQMdsKcsq+QuhC8uUcufXq2Y66em37jSPxuilGqkiR+IKLQzWZWD3YWvQFAfSfN4hWhuD3q8QDTjJeg+Mct5khlHQ9GqwFY+rZoZVIF9R7cTd/XMSAMyIk3udx0DjhIcqDQPrxw+/ZjUoqEcZ5PjpVCc6RPAaXsUhH+IrnfoYyGAjQ5XB3SA8nA2XCRx4cMA0hwOKPXc2KcnXQZYHm/bGf+3xGRCJBQntLaWyj/b1rB7HkSOYkrmx0cbtQ8TXg
 GAplCnR1
 ee5py01bPxk301d3QBWu1bCr1z8WPfXwkXhkqGslaGOjGWy5SXUvSv6jGSoghns5KRUvtXDcrcGN+uxNkQw1cGzkiPqCj/oY5B4WkAKovuxW0YiX0ZEGcFQ141ekH/bGvBDfvCY+VDAgLedOsvoa5Z/jxVYwfSCm+lLWPqqhCjpbuK91d2JpUkXxiHNsKdaO6zxkNyaalKyJUL0W0pG+743avdk16m759OTnFaR9H81ek2ZqVJ5kwVNmJI5+VtjazanJigryv7S/6/Ow4+lLlkeu60jsNtyuE4UQ/f4cakOTwQuThAWk28/Veag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 09:26, Chengfeng Lin wrote:
> Hi,

Hi,

> 
> I found a source-calibrated synthetic mincore() signal in the resident
> base-page PTE path. 

sorry, I'm confused. Did you mean to say "I found a performance regression" ?

> I do not currently have an easy arm64/mTHP validation
> setup, so before trying to arrange that more expensive validation I would like
> to ask whether the candidate fix shape below looks reasonable.
> 
> To keep the scope clear, I am not presenting this as a production application
> regression report or as a generic mincore() regression.  It is a controlled
> reproducer for a real userspace-visible syscall path, with the page-table shape
> kept intentionally simple:
> 
>   mmap() private anonymous memory
>   madvise(MADV_NOHUGEPAGE)
>   fault in all pages
>   repeatedly call mincore() over a resident 64 MiB range

Okay, so I assume a mincore() regression. On arm64?

> 
> The practical hook is that mincore() is the userspace-visible residency query
> for an address range.  The resident anonymous no-THP range is intended to
> isolate the base-page present-PTE scan and avoid file cache, swap, THP, marker,
> and unmapped-range effects.  I would read the result as source-path evidence for
> the hot path below, not as evidence that every mincore() caller or a specific
> application workload regressed.

This reads very obscure and cryptic. Was that written by, or translated by an LLM?

The way it's phrased makes it a bit hard to digest.

> 
> The intended hot path is:
> 
>   mincore()
>     -> walk_page_range()
>        -> mincore_pte_range()
> 
> The main metric is mincore_ns_per_1k_pages, lower is better.  It is the
> wall-clock time spent in the mincore() scan, normalized by the number of pages
> covered by the range and reported as nanoseconds per 1000 pages scanned.
> 
> As a release-level starting point, the matched-PREEMPT 1/2/4 CPU bridge below
> uses original release kernels, QEMU direct boot, 9 repetitions, coverage
> disabled, and the same CONFIG_ADVISE_SYSCALLS setup:
> 
>   scenario: no_thp_pte_scan_64m
>   metric:   mincore_ns_per_1k_pages, lower is better
> 
>   CPU   v6.12.77   v6.18.19   v6.19.9    v7.0.9
>   1     12827.667  15677.444  16482.667  16726.333
>   2     13628.444  16102.333  18256.889  17270.333
>   4     13798.222  16739.333  18892.111  17068.222

Okay, so we see two steps of "degradation". I assume this code is so performance
sensitive that even compiler changes might easily affect it. Because all we do
is scan page tables for present entries.

The mincore optimization went into v6.16.

> 
> This shows cumulative cost relative to v6.12 in the primary 1/2/4 CPU matrix.
> I also reran the 8CPU/16CPU release-level bridge on the same scenario.  These
> rows show the same general direction, but the shared lab was busy during this
> rerun and the high-CPU rows have higher CV, so I include them as extended
> context only:
> 
>   CPU/mem     v6.12.77   v6.18.19   v6.19.9    v7.0.9
>   8/16 GiB    17251.889  23335.556  21863.556  21664.778
>   16/32 GiB   16697.333  21428.333  21629.778  21628.333

I don't think measuring concurrency here really makes a lot of sense.

Especially, as it's becoming a rather weird, unrealistic micro-benchmark that way.

> 
> The 16CPU rerun had two QEMU returncode-139 failures in the original 36-run
> matrix; I filled the missing v6.12/v6.18 samples with a clean two-run
> supplement.  I therefore use the high-CPU rows as context for the release
> bridge, not as part of the primary matrix.
> 
> Follow-up release-ladder and A/B testing narrowed the main step to the
> v6.15 -> v6.16 window.  The strongest suspect is:
> 
>   4df65651f7075 ("mm: mincore: use pte_batch_hint() to batch process large folios")
> 
> That patch improved the mTHP/large-folio case, but in this base-page resident
> PTE scan I see a sizeable cost.  The original commit message mentioned that
> base pages did not show an obvious regression, so this may simply be a
> different x86/base-page corner than the original arm64/mTHP test.

Okay, so it is on x86 then?

On x86, pte_batch_hint() is hard-coded at 1, so the expectation is that the loop
and everything should get completely optimized out.

> 
> For the v6.16 introduction-window A/B, all rows below are lab QEMU direct boot,
> 9 repetitions, coverage disabled, same PREEMPT and CONFIG_ADVISE_SYSCALLS
> setup.  The 1/2/4 CPU rows are the primary matrix; the 8CPU/16GiB and
> 16CPU/32GiB rows are the high-CPU follow-up:
> 
>   scenario: no_thp_pte_scan_64m
>   metric:   mincore_ns_per_1k_pages, lower is better
> 
>   CPU/mem     v6.15      v6.16      v6.16 batch<=1 fastpath   v6.16 nobatch
>   1           12946.889  17117.667        14560.556              13843.222
>   2           15053.111  18214.667        15714.778              14270.556
>   4           14942.000  18338.222        14397.889              14719.667
>   8/16 GiB    15046.444  17540.222        13696.333              13200.000
>   16/32 GiB   14674.111  18928.889        13949.000              15351.111
> 
> The high-CPU matrix completed 72/72 with all_cpu_match=true,
> any_noapic=false, all_autorun_exit0=true, and all_semantic_ok=true.  One v6.15
> 16CPU timing sample in the main matrix was an obvious outlier, so the 16/32 GiB
> v6.15 value above uses a clean v6.15-only 9-repeat supplement.
> 
> I also ran ftrace attribution on the same path as mechanism evidence, not as
> clean timing.  In that run, v6.16 original had a higher mincore_pte_range
> average than v6.15, v6.16-nobatch, and the batch<=1 fastpath:
> 
>   kernel                       mincore_pte_range avg_us
>   v6.15-mainline-preempt       6.040
>   v6.16-mainline-preempt       7.899
>   v6.16-mainline-nobatch       6.031
>   v6.16-mainline-fastpath      6.103
> 
> The smaller batch<=1 fastpath helped, but later v6.18 testing suggested the
> remaining cost was more about the hot present-PTE branch layout.  The candidate
> shape I tested is to check pte_present() first, while keeping pte_batch_hint()
> for batch > 1:
> 
>   if (pte_present(pte)) {
>           batch = pte_batch_hint(ptep, pte);
>           if (batch > 1)
>                   fill vec[0..step-1];
>           else
>                   *vec = 1;
>   } else if (pte_none(pte) || pte_is_marker(pte)) {
>           __mincore_unmapped_range(...);
>   } else {
>           mincore_swap(...);
>   }
> 
> On x86, pte_batch_hint() defaults to 1, so this mainly measures the
> resident-PTE hot path layout.  On arm64 the batch > 1 path should still be
> preserved, but I have not validated mTHP/contiguous-PTE performance yet.
> 
> The v6.18 confirmation A/B.  The 1/2/4 CPU rows are the primary matrix; the
> 8CPU/16GiB and 16CPU/32GiB rows are the high-CPU follow-up.  All rows use the
> same no-THP scenario, 9 repetitions, and coverage disabled:


Which compiler are you using?

The expectation is that the whole code would get optimized on x86 such that the
behavior is just like before.


-- 
Cheers,

David

