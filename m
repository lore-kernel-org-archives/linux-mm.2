Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B0F606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzVr0tO7
Received: by kanga.kvack.org (Postfix)
	id CD0036B06F5; Tue, 27 Oct 2026 08:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C810D6B06F7; Tue, 27 Oct 2026 08:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F4B6B06F8; Tue, 27 Oct 2026 08:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8612F6B06F5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:22:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09E5E1409BC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:22:40 +0000 (UTC)
X-FDA: 85368319680.19.0862309
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 40D44100009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:22:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzVr0tO7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31aiTvnWZc7MSGUa9bL+A7FtcCzalOqoYWv9RWdLupI=;
	b=jz5U+zLYiWBHw6zOM7pewiUWk081bv3a/3BY3LZktxNAKYdLIwqmhDw6sUSbqjXv7INZGE
	ahOBqlW8xJxObNbvf+39ekG/lA3OkIW69S4o2geqiID1YIYNdpt/4JaX2mofSN+JUHzqc5
	AKMiW5DiW6+kZPDZQe2VO6G4oWDVD2o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzVr0tO7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103758;
	b=uQ11+0kC0KsMIXIxaZ1lXDe+kRwTo+bxiKu7CNGBj5wFEaBwFDWYEfLsrrjyxIdhf4xULV
	BQSchc23M0nNdt1kegBTSlwyaNtcnaZ5aOXGd3eSBX/YswW04sjMlaRn9/ggWzIDNvC5GT
	rx6VIorctgGuovPehN/e8BX7Ty19IE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C373460236;
	Tue, 27 Oct 2026 12:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584DE1F01825;
	Tue, 27 Oct 2026 12:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793103757;
	bh=31aiTvnWZc7MSGUa9bL+A7FtcCzalOqoYWv9RWdLupI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lzVr0tO7Sg1LVQSf6cViyxlF87nH0y/4lTuZQIB1K8gP41N8K+twipT1TjQDGFCoc
	 MbzUgwPKSuR39pOr6/xN+BpriOw5Hn6UwnLP1ZuwtE3ZmIcPx5XKjGWMZvxMhVYX4w
	 F2+ZEUETgv7iD9Z1JhxknFGxakzdyXcF6YoIwZO0uSBtRgVowrqujqdoXnnplhpheR
	 tjeXUnVvat9yP8EZRQK5w+njSp4oqb77p6nsaHMoJj1KfJyc+BdfwOQ+UPd7js4rU5
	 UjzEAAZ5D+7Ha5TLzJUTfLYKq+GMHm/JSqf5EFpZljdtKZ7LAzREpIpAJHinsYBC8Q
	 5PLbLxkQ+bTpQ==
Message-ID: <668c53f7-20b4-4400-b442-71749db88d03@kernel.org>
Date: Tue, 27 Oct 2026 13:22:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
To: Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, dipietro.salvatore@gmail.com, rvvandan@amazon.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com,
 miklos@szeredi.hu, agruenba@redhat.com, djwong@kernel.org,
 hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com, cem@kernel.org,
 dlemoal@kernel.org, naohiro.aota@wdc.com, jth@kernel.org,
 willy@infradead.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, exfat@lists.linux.dev,
 fuse-devel@lists.linux.dev, gfs2@lists.linux.dev, linux-xfs@vger.kernel.org,
 ntfs@lists.linux.dev, ntfs3@lists.linux.dev
References: <20261027112702.3747009-1-dipiets@amazon.it>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027112702.3747009-1-dipiets@amazon.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 40D44100009
X-Stat-Signature: jbpkkqfqybfniwbu5jq3xats6bzb89fc
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793103758-350995
X-HE-Meta: U2FsdGVkX19/fUxk+u+KUnOu+4uDoEW7L4fZ/2gqmdX8yucPtHzXdU/ziRXVIQ8NG++ezrwPK7gzj93GnOo7GUHrRu3FYBSm5AqfmJW2p37OHy3UPTq41N9t7XigDqCeg4+/kuRCY9sASGYiugc7Id+C6e+HvsrB7AVVIFt9AcqOhnwvlkvnkRasWx4xe9RInHxQqns0pkROcdfISlRR00bRX/pSQ0jJbitQl9hrEcl7aZHwZdtBf9MlFaz3ot9L3N57LW5r6yaIr5KnwfUZCQ4k8NNJg6W8aeKAbahSih2PGQfQqXmVBQLc624SXokB5+rmFdHqswsBtDUhmYz1rdN5AeVzzpEW5x6jpK59VLbLKe7rzc/If43ctlFtpSpuqjXLWz5OdqEZ2gx5ZsDMu0j1NImqwi9FBHWcxrvRBH2tZZRN9fGFjsoayn01oDBKseiIzI0PpRJ2A3lXHbT97LXfVZdhvLBo4IOTCAHBW08TYJELskEiKlLS2wTpfr0H6g3TTqR5s/NWKuH1EjZBsNm0EFJrQSioesLrBLerjsXs5Rr5amKgZzibbW0d7tIplJ5RtW0gKwvRJkkIBYqSRY2k8FPldLg+Frcm8RFWzMeqmuAcGDnUdADeqw2iVZBgahySLSodcnOIfyolqf3uTp6H3csEtJA2sqTjBLLCRdcXZ3+I6phwROVBSpqF9Ak7TXhkERGPmJ/smXUq6J/0g6lKSYSSjcNi1zoT88jDlPhZq3ygnsEFJtiXU9yoV/4mPiQsBGlAeVdjusWoB8nM51o6lMTdfvybIRhrmOupL0ZJSSNOOQVeFf8vsJsPaTz2srIh4ycI0XBK8U4oJHXTD9iUHBlwPoWtqEK4i5TxmBcBl5IVJUO2EyOKqgaQMZB05De9GEWAZIMTPR0QXLBudyoQXFNU6efSg1Hal8zt8Ue6n5he3Q4JUbzUM2GxUZmWrIWeS27hnqmA83lk4Od
 glpTr2Qk
 HBjk7ncvF2eJZmFC5Yt6Kz8CaUfo7r54buxzew+76h/dYQfjo0YreNa5sw67D+lIyKFYTXNQC1ddwdSl/XXcFVzLKupgD89gyznb822wRdfqrvyBni1mylLrIbN8WQsyNEcbNDwKaBL1Gv//XQMFGGSLLmGYTYtrURAN3u8UBevj1f0AbmgvCzmpeEYijOzZ11P2ymNzeEpzLp4IU2wjfFJhoydhElPzBozYaGgRKE5Qbj3H0Gb0u6Gu6I+6tIaGJNE9erp3z3BTOCkw/2L5iS9hyuJYyRMxxlLixyGRBDiuDphNSrpzs5GZmK4ORrMkeUTaoeILHQSp5aG/tVW4Rrf5FSvh0Gn2QCM0vdGNTDWINNRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 12:27, Salvatore Dipietro wrote:
> Since iomap gained per-block dirty tracking, a large folio can be
> partially dirty: struct iomap_folio_state records exactly which
> blocks are dirty, and writeback only writes those ranges.  The mm
> dirty accounting, however, still charges the whole folio even if a
> single block is dirty (up to 512x over-accounting for a 2 MB folio
> over 4 KB blocks).
> 
> balance_dirty_pages() then throttles writers against a number that
> is unrelated to how much data actually needs writing back.  On
> workloads that repeatedly dirty small ranges of large folios --
> e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
> is crossed and writers are throttled long before the real dirty data
> justifies it.  On the benchmark below, run on v7.3-rc7, the
> unpatched kernel charges ~159 TB of dirtied pages while writing
> ~6 TB to the array, a factor of 27; with this series the dirtied
> pages charged match the data actually written.
> 
> This series makes iomap charge and discharge the mm dirty counters
> per dirty page for folios that carry per-block dirty state, so a
> partially dirty large folio is accounted for the dirty part only:
> 
>   - Patch 1 adds the mm infrastructure: an AS_DIRTY_PER_BLOCK
>     mapping flag, an @accounted argument to __folio_mark_dirty()
>     and __filemap_dirty_folio() to skip the generic per-folio
>     charge, and an address_space_operations::accounted_dirty_pages()
>     callback used by the discharge and migration paths instead of
>     folio_nr_pages().  No filesystem opts in, so it is a no-op on
>     its own.
> 
>   - Patch 2 makes iomap charge per dirty page from the per-block
>     dirty bitmap and wires iomap_accounted_dirty_pages() into every
>     iomap-based filesystem.
> 
> This was benchmarked with PostgreSQL using the pgbench simple-update
> workload on v7.3-rc7.  Average throughput rises 46.8% (139.8k ->
> 205.2k tps) and run-to-run variability drops from a 23.60% to a
> 3.98% coefficient of variation: the worst iteration improves from
> 97.9k to 191.5k tps, while the best gains 8%, 199.4k -> 215.9k.
> 
> Ten iterations per kernel, same database and workload (tps):
> 
>   Kernel                     Avg     Min     Max      CV   iters   iters
>                                                              1-5    6-10
>   ______________________  ______  ______  ______  ______  ______  ______
>   v7.3-rc7                139.8k   97.9k  199.4k  23.60%  164.4k  115.2k
>   v7.3-rc7 + this series  205.2k  191.5k  215.9k   3.98%  200.1k  210.2k
> 
> On unpatched v7.3-rc7 the worst iteration lands ~51% below the best,
> and throughput decays as the run progresses: iterations 6-10 average
> 30% below iterations 1-5.  With this series the decay is gone -- the
> second half is similar to the first -- and the coefficient of
> variation stays at 3.98%.
> 
> The over-accounting has existed since commit 4ce02c679722 ("iomap: Add
> per-block dirty state tracking to improve performance"), merged in
> v6.6, where the ifs bitmap started recording partial dirty state while
> the mm counters kept charging whole folios.
> 
> The throughput collapse bisects to the v6.17 readahead series, first
> bad commit c4602f9fa77f ("mm/readahead: store folio order in struct
> file_ra_state"), which lets readahead stay at the largest folio order
> once it has ramped up, so a single dirty block charges far more than
> is written.  Patch 2 therefore carries:


How does this relate to

[RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap writes

https://lore.kernel.org/all/20260903182943.662461-1-kirill@shutemov.name/

?

I assume they try to solve different problems, but would more fine-grained folio
dirtying also make your solution benefit?

-- 
Cheers,

David

