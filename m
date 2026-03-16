Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 128E1F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580D06B00C7; Mon, 16 Mar 2026 12:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541E86B02F9; Mon, 16 Mar 2026 12:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B056B02FA; Mon, 16 Mar 2026 12:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36B0E6B00C7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:06:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D08CA1401F5
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:06:37 +0000 (UTC)
X-FDA: 84552404034.18.983C086
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CDCB6100011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:06:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DeWlppA5;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIn2O1UO9o+NNd6ndwmGUY3VFuQhtoVSGRTxlJ6QDXU=;
	b=AoywkXeyqUXoOqBBXcjWFlsSGArCuPsKMzsfrIl1yTIuzl/137UPsc3I8LOiOnJEoF0inq
	Z3lxsP1g4zmZd+U6Mm52x2uvkoV9PK0U03I/6ae6gMKs8iQqHhyzbFFzZQg9s0LjAULMT5
	guRVjusD9qsNGxMAQHa2Hm8gvMrL4BU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773677195; a=rsa-sha256;
	cv=none;
	b=ba67wW+TexCcadGHCM8fl5tV5ElhdyXuP+VFaFHBRvNQVg+KtKsG9aQPrByFGF0khbKXEz
	MyQwv2+3QrVZUWyWVceEFRrSxQGZcugU9NaNYOqsSskwRcSXYN+6zfuctDf+wuKlWSavBj
	JcLHPkFLtv0vvfXqU0bnuYBY05GtZEY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DeWlppA5;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F66E60018;
	Mon, 16 Mar 2026 16:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE505C19421;
	Mon, 16 Mar 2026 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677194;
	bh=cj/5YGwp5+c5NaW2gvBI49y4YZXx3uALNGH84PsRfnQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DeWlppA5IL2ampk8lC/lAlXdW2xozEGYLFwBl9YZIQKe4hPZ8uN3N+03S+mDPUWX0
	 NZfR+s/+8ijYrFJBOD93xN6vQFoodaOwoTTJT8NOO/LMuWCum/HGpLZSeQIvbWY8na
	 tm//MejtWYxEpkak9IZVMJjAImEElE2xU8OkHOepcSDBgGC8mGOY3D3+TS0EKDTVn7
	 vHQkbomZs7tmq4EQt6Z5n4Hr82QnmcfGcwoBcpfXeNNHKTx3ya8+E8PkhGIL2sJ0kV
	 X3iTy2r6NkYCRh4UtPUd+1GxoRBm6PCvHG85M7rfxDWXv1ozPyy4hGGQPEWbW5hmhz
	 EL2ka3FW6YkPQ==
Message-ID: <be65e710-997c-413c-8455-2d687fc51fc6@kernel.org>
Date: Mon, 16 Mar 2026 17:06:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K
 pages
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, ryan.roberts@arm.com
Cc: ajd@linux.ibm.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, jack@suse.cz, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, rmclure@linux.ibm.com,
 Al Viro <viro@zeniv.linux.org.uk>, will@kernel.org, willy@infradead.org,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260310145406.3073394-1-usama.arif@linux.dev>
 <608c87ce-10d9-4012-b6e9-298d5a356801@kernel.org>
 <9e9edebb-3953-4bcd-80e2-614dcec5b402@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9e9edebb-3953-4bcd-80e2-614dcec5b402@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: eaemae4zwc7netyhdoiz7bz8b1p6d9yd
X-Rspamd-Queue-Id: CDCB6100011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773677195-963875
X-HE-Meta: U2FsdGVkX1+Z6m/np0dfb90Xdg24OnoTfQFpkw/ncmYrTTwUtJi6OC3V4s2jSu35CEzdkLjqc9GiiD1TaKpxZA5paqJyaxSuGyUyJxGtvxDBcWYqJu9NTjkfup2bERmRCncFNCMUs6Vow7Zvn9yesbUUKNgPB65MUfXMV52y6rr5s1LYCcjq2/gffA/rnDgbsIWFpCrb3riLhUauxdzKUhGJXJRs+grnNPgoO2yjFimILKCJJEVkjXP7QbgGNjhKSee10OqmAYi5FBJXXxfdRvuURSCU4F/DMchiNyl1ttHenUX/u7/Rcl/6j8vmeU2Gcmv3H5ltLHoZ+zgKqhzKgBWz0wmidrrUYFgJoLJOJSPtJP7gPbL4Gr+QVSjqT6Y2chzNP88obhN3rsDc92HM5CqCt3ltlu81y+/DVtTdqnO0WVKa/AbhQGclRoPL8sa/T810lIKGHUy06WGpksVq40PIYKtpAudHRGgOm20ebYT8TgTArMNbwPLfGJzu/smEzgmHiIYwCns/e3nVpPV0BCQ0QYSov4JVz1/Cs92Pqtsh+rxT14eUcpuXwndv5l9dl52eJFGOMedgeHahdTxRcFHOBuxwB/Pn+Dic8jdx2OOrmg9deI0lO+Y5KFBGnP+Kp/A4rFaSm07FjApaX6k8k6IUO1U3SywjGQok62vG/RLLtZMBCIBY5QQWPFC273TeCqGfQHm5pY89/vtrgQTGRIGZezZWvQ/f2Pap2k7/4SI6AIbGk6K+7mjvcogwAMsC5xJXg7xEFzD6+i40SRXjtb21u0fPE7dQklGfYgSDFIiMe3LCz1Un5MuGwMkOHDYd0grWEkyfQt++QCEmUSV+9D2QqWJA7hjNVUVhhLBSVxRy8iVZO8mFhZ2yhDjCC2HgfL4vftY0aVmn1NtcqsbG4UETeYQYZyb6KxZTSSaMH+lWnNpi4B2Z5eISE+jDiCvUbXZf3hd7f1vWxalktnk
 B437KVaw
 Z+3PVrl3jw1SgaAFtTUwc7OezmJcFt2hPFjRyRKfT5CEok/2vtLpyay918Cv0hL9er9SpJi4PhD/abj1UladjwpwKInnrhags5V4HedebHxbbgVmUEiRgvJnVbKemObyLQ2GW3C2R4AP899JrxNElPM33a1u1ZSV2haPToItA0lIGmSlgmO9edhko5dtbour5V0jm5IPlLScClApEUCsWX5gCvma8Epq6694j4fcIOxADeV3rS6aPlppiJu1ToHUu8Rpx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/13/26 20:59, Usama Arif wrote:
> 
> 
> On 13/03/2026 16:20, David Hildenbrand (Arm) wrote:
>> On 3/10/26 15:51, Usama Arif wrote:
>>> On arm64, the contpte hardware feature coalesces multiple contiguous PTEs
>>> into a single iTLB entry, reducing iTLB pressure for large executable
>>> mappings.
>>>
>>> exec_folio_order() was introduced [1] to request readahead at an
>>> arch-preferred folio order for executable memory, enabling contpte
>>> mapping on the fault path.
>>>
>>> However, several things prevent this from working optimally on 16K and
>>> 64K page configurations:
>>>
>>> 1. exec_folio_order() returns ilog2(SZ_64K >> PAGE_SHIFT), which only
>>>    produces the optimal contpte order for 4K pages. For 16K pages it
>>>    returns order 2 (64K) instead of order 7 (2M), and for 64K pages it
>>>    returns order 0 (64K) instead of order 5 (2M). Patch 1 fixes this by
>>>    using ilog2(CONT_PTES) which evaluates to the optimal order for all
>>>    page sizes.
>>>
>>> 2. Even with the optimal order, the mmap_miss heuristic in
>>>    do_sync_mmap_readahead() silently disables exec readahead after 100
>>>    page faults. The mmap_miss counter tracks whether readahead is useful
>>>    for mmap'd file access:
>>>
>>>    - Incremented by 1 in do_sync_mmap_readahead() on every page cache
>>>      miss (page needed IO).
>>>
>>>    - Decremented by N in filemap_map_pages() for N pages successfully
>>>      mapped via fault-around (pages found in cache without faulting,
>>>      evidence that readahead was useful). Only non-workingset pages
>>>      count and recently evicted and re-read pages don't count as hits.
>>>
>>>    - Decremented by 1 in do_async_mmap_readahead() when a PG_readahead
>>>      marker page is found (indicates sequential consumption of readahead
>>>      pages).
>>>
>>>    When mmap_miss exceeds MMAP_LOTSAMISS (100), all readahead is
>>>    disabled. On 64K pages, both decrement paths are inactive:
>>>
>>>    - filemap_map_pages() is never called because fault_around_pages
>>>      (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
>>>      requires fault_around_pages > 1. With only 1 page in the
>>>      fault-around window, there is nothing "around" to map.
>>>
>>>    - do_async_mmap_readahead() never fires for exec mappings because
>>>      exec readahead sets async_size = 0, so no PG_readahead markers
>>>      are placed.
>>>
>>>    With no decrements, mmap_miss monotonically increases past
>>>    MMAP_LOTSAMISS after 100 faults, disabling exec readahead
>>>    for the remainder of the mapping.
>>>    Patch 2 fixes this by moving the VM_EXEC readahead block
>>>    above the mmap_miss check, since exec readahead is targeted (one
>>>    folio at the fault location, async_size=0) not speculative prefetch.
>>>
>>> 3. Even with correct folio order and readahead, contpte mapping requires
>>>    the virtual address to be aligned to CONT_PTE_SIZE (2M on 64K pages).
>>>    The readahead path aligns file offsets and the buddy allocator aligns
>>>    physical memory, but the virtual address depends on the VMA start.
>>>    For PIE binaries, ASLR randomizes the load address at PAGE_SIZE (64K)
>>>    granularity, giving only a 1/32 chance of 2M alignment. When
>>>    misaligned, contpte_set_ptes() never sets the contiguous PTE bit for
>>>    any folio in the VMA, resulting in zero iTLB coalescing benefit.
>>>
>>>    Patch 3 fixes this for the main binary by bumping the ELF loader's
>>>    alignment to PAGE_SIZE << exec_folio_order() for ET_DYN binaries.
>>>
>>>    Patch 4 fixes this for shared libraries by adding a contpte-size
>>>    alignment fallback in thp_get_unmapped_area_vmflags(). The existing
>>>    PMD_SIZE alignment (512M on 64K pages) is too large for typical shared
>>>    libraries, so this smaller fallback (2M) succeeds where PMD fails.
>>>
>>> I created a benchmark that mmaps a large executable file and calls
>>> RET-stub functions at PAGE_SIZE offsets across it. "Cold" measures
>>> fault + readahead cost. "Random" first faults in all pages with a
>>> sequential sweep (not measured), then measures time for calling random
>>> offsets, isolating iTLB miss cost for scattered execution.
>>>
>>> The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
>>> 512MB executable file on ext4, averaged over 3 runs:
>>>
>>>   Phase      | Baseline     | Patched      | Improvement
>>>   -----------|--------------|--------------|------------------
>>>   Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
>>>   Random     | 76.0 ms      | 58.3 ms      | 23% faster
>>
>> I'm curious: is a single order really what we want?
>>
>> I'd instead assume that we might want to make decisions based on the
>> mapping size.
>>
>> Assume you have a 128M mapping, wouldn't we want to use a different
>> alignment than, say, for a 1M mapping, a 128K mapping or a 8k mapping?
>>
> 
> So I see 2 benefits from this. Page fault and iTLB coverage. IMHO page
> faults are not that big of a deal? If the text section is hot, it wont
> get flushed after faulting in. So the real benefit comes from improved
> iTLB coverage.
> 
> For a 128M mapping, 2M alignment gives 64 contpte entries. Aligning
> to something larger (say 128M) wouldn't give any additional TLB
> coalescing, each 2M-aligned region independently qualifies for contpte.
> 
> Mappings smaller than 2M can't benefit from contpte regardless of
> alignment, so falling back to PAGE_SIZE would be the optimal behaviour.
> Adding intermediate sizes (e.g. 512K, 128K) wouldn't map to any
> hardware boundary and adds complexity without TLB benefit?

I might be wrong, but I think you are mixing two things here:

(1) "Minimum" folio size (exec_folio_order())

(2) VMA alignment.


(2) should certainly be as large as (1), but assume we can get a 2M
folio on arm64 4k, why shouldn't we align it to 2M if the region is
reasonably sized, and use a PMD?


-- 
Cheers,

David

