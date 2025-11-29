Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA02CFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 17:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965FD6B000A; Sat, 29 Nov 2025 12:07:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916AE6B000C; Sat, 29 Nov 2025 12:07:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853516B000D; Sat, 29 Nov 2025 12:07:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 729B76B000A
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 12:07:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18BBFC0A3F
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 17:07:56 +0000 (UTC)
X-FDA: 84164276952.14.5FFE9B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 080502000A
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 17:07:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PoUUFewG;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764436074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=if3KkBKl7roXFUmhHcG4mQyCUUFtj8p3Txh6gT+312A=;
	b=pz8EYRfFvqRpndyfr7gk1bgw8ocOMepYWjjsewBDILQYKzhP6lfkh2+X1gIqz22EtbtTv4
	X5iqLzEGwI4YsG60EvgbobZxUgMOle0qQFzm1e+aB3GLFdaBQpdnJYBn6uLa9sHpTPwYmN
	vJr5JxkGuJQKVH66oE+D2mct8lCCYIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764436074; a=rsa-sha256;
	cv=none;
	b=wA1bOO+wtbNm0seo855wdmCokgkeYvFaqw7voULBl9D2T9aVptI9RCZ7h1Cn583CQcon9p
	iLVzlXAlt8My6XdmOMFGoDhRv/km74rj5L0N48tFYqfGVia+4re/2bInIbhoS6bqe2MHpt
	A2w2aSWtqRHaAns/lIA2xnvb1WuILtc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PoUUFewG;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1F90436A9
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 17:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7156C4CEF7
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764436072;
	bh=aEi3fUeihkx7Xs7jMI1NkgKX1nDZ4HrkE6CG0v5DbFI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PoUUFewGdGpVbfMyV7x/XSqVZCIL7hqh56LUb41NOntsEbxLWIJjBFh1MN5SvMfJN
	 2b1OJMYeQstPtLtkEhrF7Ijb+9s8qFIxWZ/sMr93A+CEImgcSxQb4+iQmCQ65O30JW
	 zGsBwsN9X05x+qPGqSxDWKNXdDtb2WfXub3HS4hwv+s2tiiklNApSk/gOQB7moPFR3
	 PdVGo4YxRds2P89tWZh3PKVHh38DnzTUY7+4Xs8PXO5/V1IeHO44y0SfqIVN/fsVTz
	 3xa17bq2k6JqLz1wREAVDjZbvKFszNaV4cfkEN3HAR0+2GIniI2POS/Tqa9Hp3HB/w
	 n3SSktgQKJ52w==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-789314f0920so22455157b3.1
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:07:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV/ilDBB0skSeN7EGu3tNJFwvDqX6DeEtW7YRxiP9Jbntynrc2UsI9bietBA6/BpxcdARUwhI94SA==@kvack.org
X-Gm-Message-State: AOJu0YybThGEjkt20IeRgjy4Fwu2eNsr4Mjcp79hgJPCnZkmojsa5zXr
	B+AKXEQsWlk/jGQyVaL7j7Z4mR3PLSCwzGQB9fRpClSMOeGFh0vO7K9yxXxbzgFbnvix6n7Ljje
	bYr2a4f01SEVVXV0p3JOloLXSFXCILe1NB9gtP32lqg==
X-Google-Smtp-Source: AGHT+IGoLbSxanxq+rFI3LIH/mqm9+e3tjcYNJ/ehzOR5pFY7jyX7qnhO//KzRpv3gftUKmEKG6CYc+E+Sr/fomqbUo=
X-Received: by 2002:a05:690c:7249:b0:788:1eae:3d7f with SMTP id
 00721157ae682-78ab6fe526dmr171463927b3.70.1764436071502; Sat, 29 Nov 2025
 09:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 29 Nov 2025 21:07:40 +0400
X-Gmail-Original-Message-ID: <CACePvbUK6uSDtz0QkBq-eqzQ_Hi9+t1gthGGt+ok7xdZtO1V8Q@mail.gmail.com>
X-Gm-Features: AWmQ_bkRNDXrXhesX6xwbiCQ91_SSNsi6Rzr-o_fwzw9asPFCsw3uZWkKu5-3HE
Message-ID: <CACePvbUK6uSDtz0QkBq-eqzQ_Hi9+t1gthGGt+ok7xdZtO1V8Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] mm, swap: swap table phase II: unify swapin use
 swap cache and cleanup flags
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 080502000A
X-Stat-Signature: y5wzb9ir4q3zrxgui8nfx5889awybahh
X-HE-Tag: 1764436073-874926
X-HE-Meta: U2FsdGVkX1/NMA9/AyyWNYnRgHI7uvKjKAYwGuxW3eTmSM+SIIXdvEfG25Vk5D1KgW8mYiO8tNI2Ysi1TgMhvrJ52C0z+qD4KHCG2lSDuBo+YvqLuIoZu1hHd7yNVVMURazyOJDEA7jD3ll2OwJw3ZETBDcWKBeJSyPGmbK//PKqzd1oeRMbHXY+Tt/a19tLAHHEGw917xurxDuQDYBXA8E6CINbGizu0TPUvnqy0TrJKlgwLktnGRfj4DqPxTGff2C3coaexhLtPSuek5homme3Qwp45dKu5liEod0fY4bjvCfll5g4bOMo+ATrLxZzxdsJKveaM4o96mapGmR/aS4gxF4WJAryCGHMYmGGvHIEUh8oZrL/1B0kAVIqotV+Vm+LnZiQV4knKL8qOamWgrPOHssp2lN7Dm9/xmSQ8tLesLfVwIbxVusbEF3aQGFOwkNd7JJJ+5tqxVIYNoZPpU4y97sAgtn2t0l650d9PRGKRY0tQUUfzRulmwj/jw9/0XpzURsbfqFoNK8VbOqRN8H+UZ5YwPiigWYUyFC3PykHQ7S9uFLODW6XF6xnLLWcbOOIpyHx4P4kF0c9/uYT2MvQGEoWDe2LAKMmLwRycpmlapovua3/+VrIw7/guXBJTXWyOfTfqgNLNx/mZuvNj96bWXcq6MDG8Og4gJ3ngxb9H9zVeuSjOTOOKZGiaLNittmG0rxcOBo/garuMgXwCszHoXiuP0YIXTHj5bFvAHhIPAMaq4GM9P60l/Jkc32M6+Qtdd+6soUQ2PE0W5S6082h1k+kFq009dBkm4buRqh80HOEqXFTdhieAGATV/9RqI36f8hOIuXEqkZ7Sa2spgeWSlpAxbY2vlATYsdR5PH/VsX2YqXwL8HcH9XE9TYQzkDbCAOtVMVF8KYICpHGMQNYdLGOWSmjET66c4sbftiLuHAWz2/6Qj8REsCrpgXli08VyDD2BFqx81MDU4b
 7i6gKydL
 YAF4fMuhyiqee1DAMQrYOD4XWGwggoxQbDvytQcgM7O88m1FNsDY/stpoDN79fFMU9a01mvpOXEisHgA+IQvCiFlotNi6yww58jcSHvKozcL5MHIxkoXfVaZHSvNewRtqt7vll4uN4G2jK0EmufGmvR5PdxbumPiprzKY/fnVesg2jwE3TLfPtAliNW+p/t2p/5+Ic/J5SzTW5K9rwvCYynHmK3so+P2an37yfhkqRvItbq9kRr65VfbdL/SY2Fqe4SXsbS6t3JNuEFHnUPfGDmHYodZqiT26ZYLupzNe6v9a7fhemn0WgLVcvhtJZUAPr1VLMiQscCUFWiMOojjRCZOdThKXMImtUfNpRjODjtw5nwE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Can you add this swap table phase II series to mm-unstable for more
exposure? The patch series has gone through V3, overall looks OK, but
I have not finished reviewing them all yet. I will keep you posted
when the series is fully reviewed.

Thanks

Chris

On Mon, Nov 24, 2025 at 11:15=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> This series removes the SWP_SYNCHRONOUS_IO swap cache bypass swapin code =
and
> special swap flag bits including SWAP_HAS_CACHE, along with many historic=
al
> issues. The performance is about ~20% better for some workloads, like
> Redis with persistence. This also cleans up the code to prepare for
> later phases, some patches are from a previously posted series.
>
> Swap cache bypassing and swap synchronization in general had many
> issues. Some are solved as workarounds, and some are still there [1]. To
> resolve them in a clean way, one good solution is to always use swap
> cache as the synchronization layer [2]. So we have to remove the swap
> cache bypass swap-in path first. It wasn't very doable due to
> performance issues, but now combined with the swap table, removing
> the swap cache bypass path will instead improve the performance,
> there is no reason to keep it.
>
> Now we can rework the swap entry and cache synchronization following
> the new design. Swap cache synchronization was heavily relying on
> SWAP_HAS_CACHE, which is the cause of many issues. By dropping the usage
> of special swap map bits and related workarounds, we get a cleaner code
> base and prepare for merging the swap count into the swap table in the
> next step.
>
> And swap_map is now only used for swap count, so in the next phase,
> swap_map can be merged into the swap table, which will clean up more
> things and start to reduce the static memory usage. Removal of
> swap_cgroup_ctrl is also doable, but needs to be done after we also
> simplify the allocation of swapin folios: always use the new
> swap_cache_alloc_folio helper so the accounting will also be managed by
> the swap layer by then.
>
> Test results:
>
> Redis / Valkey bench:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Testing on a ARM64 VM 1.5G memory:
> Server: valkey-server --maxmemory 2560M
> Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
>
>         no persistence              with BGSAVE
> Before: 460475.84 RPS               311591.19 RPS
> After:  451943.34 RPS (-1.9%)       371379.06 RPS (+19.2%)
>
> Testing on a x86_64 VM with 4G memory (system components takes about 2G):
> Server:
> Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
>
>         no persistence              with BGSAVE
> Before: 306044.38 RPS               102745.88 RPS
> After:  309645.44 RPS (+1.2%)       125313.28 RPS (+22.0%)
>
> The performance is a lot better when persistence is applied. This should
> apply to many other workloads that involve sharing memory and COW. A
> slight performance drop was observed for the ARM64 Redis test: We are
> still using swap_map to track the swap count, which is causing redundant
> cache and CPU overhead and is not very performance-friendly for some
> arches. This will be improved once we merge the swap map into the swap
> table (as already demonstrated previously [3]).
>
> vm-scabiity
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
> simulated PMEM as swap), average result of 6 test run:
>
>                            Before:         After:
> System time:               282.22s         283.47s
> Sum Throughput:            5677.35 MB/s    5688.78 MB/s
> Single process Throughput: 176.41 MB/s     176.23 MB/s
> Free latency:              518477.96 us    521488.06 us
>
> Which is almost identical.
>
> Build kernel test:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Test using ZRAM as SWAP, make -j48, defconfig, on a x86_64 VM
> with 4G RAM, under global pressure, avg of 32 test run:
>
>                 Before            After:
> System time:    1379.91s          1364.22s (-0.11%)
>
> Test using ZSWAP with NVME SWAP, make -j48, defconfig, on a x86_64 VM
> with 4G RAM, under global pressure, avg of 32 test run:
>
>                 Before            After:
> System time:    1822.52s          1803.33s (-0.11%)
>
> Which is almost identical.
>
> MySQL:
> =3D=3D=3D=3D=3D=3D
> sysbench /usr/share/sysbench/oltp_read_only.lua --tables=3D16
> --table-size=3D1000000 --threads=3D96 --time=3D600 (using ZRAM as SWAP, i=
n a
> 512M memory cgroup, buffer pool set to 3G, 3 test run and 180s warm up).
>
> Before: 318162.18 qps
> After:  318512.01 qps (+0.01%)
>
> In conclusion, the result is looking better or identical for most cases,
> and it's especially better for workloads with swap count > 1 on SYNC_IO
> devices, about ~20% gain in above test. Next phases will start to merge
> swap count into swap table and reduce memory usage.
>
> One more gain here is that we now have better support for THP swapin.
> Previously, the THP swapin was bound with swap cache bypassing, which
> only works for single-mapped folios. Removing the bypassing path also
> enabled THP swapin for all folios. The THP swapin is still limited to
> SYNC_IO devices, the limitation can be removed later.
>
> This may cause more serious THP thrashing for certain workloads, but that=
's
> not an issue caused by this series, it's a common THP issue we should res=
olve
> separately.
>
> Link: https://lore.kernel.org/linux-mm/CAMgjq7D5qoFEK9Omvd5_Zqs6M+TEoG03+=
2i_mhuP5CQPSOPrmQ@mail.gmail.com/ [1]
> Link: https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gmai=
l.com/ [2]
> Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmai=
l.com/ [3]
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Still basically same with V2, mostly comment update and build fix, and
> rebase to resolve conflicts and for easier review and testing. Stress tes=
t and
> performance test is looking good and basically same as before.
>
> Changes in v3:
> - Imporve and update comments [ Barry Song, YoungJun Park, Chris Li ]
> - Simplify the changes of cluster_reclaim_range a bit, as YoungJun points
>   out the change looked confusing.
> - Fix a few typos I found during self review.
> - Fix a few build error and warns.
> - Link to v2: https://lore.kernel.org/r/20251117-swap-table-p2-v2-0-37730=
e6ea6d5@tencent.com
>
> Changes in v2:
> - Rebased on latest mm-new to resolve conflicts, also appliable to
>   mm-unstable.
> - Imporve comment, and commit messages in multiple commits, many thanks t=
o
>   [Barry Song, YoungJun Park, Yosry Ahmed ]
> - Fix cluster usable check in allocator [ YoungJun Park]
> - Improve cover letter [ Chris Li ]
> - Collect Reviewed-by [ Yosry Ahmed ]
> - Fix a few build warning and issues from build bot.
> - Link to v1: https://lore.kernel.org/r/20251029-swap-table-p2-v1-0-3d43f=
3b6ec32@tencent.com
>
> ---
> Kairui Song (18):
>       mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
>       mm, swap: split swap cache preparation loop into a standalone helpe=
r
>       mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
>       mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devi=
ces
>       mm, swap: simplify the code and reduce indention
>       mm, swap: free the swap cache after folio is mapped
>       mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
>       mm, swap: swap entry of a bad slot should not be considered as swap=
ped out
>       mm, swap: consolidate cluster reclaim and usability check
>       mm, swap: split locked entry duplicating into a standalone helper
>       mm, swap: use swap cache as the swap in synchronize layer
>       mm, swap: remove workaround for unsynchronized swap map cache state
>       mm, swap: cleanup swap entry management workflow
>       mm, swap: add folio to swap cache directly on allocation
>       mm, swap: check swap table directly for checking cache
>       mm, swap: clean up and improve swap entries freeing
>       mm, swap: drop the SWAP_HAS_CACHE flag
>       mm, swap: remove no longer needed _swap_info_get
>
> Nhat Pham (1):
>       mm/shmem, swap: remove SWAP_MAP_SHMEM
>
>  arch/s390/mm/gmap_helpers.c |   2 +-
>  arch/s390/mm/pgtable.c      |   2 +-
>  include/linux/swap.h        |  77 ++--
>  kernel/power/swap.c         |  10 +-
>  mm/madvise.c                |   2 +-
>  mm/memory.c                 | 276 +++++++-------
>  mm/rmap.c                   |   7 +-
>  mm/shmem.c                  |  75 ++--
>  mm/swap.h                   |  70 +++-
>  mm/swap_state.c             | 338 +++++++++++------
>  mm/swapfile.c               | 856 +++++++++++++++++++-------------------=
------
>  mm/userfaultfd.c            |  10 +-
>  mm/vmscan.c                 |   1 -
>  mm/zswap.c                  |   4 +-
>  14 files changed, 854 insertions(+), 876 deletions(-)
> ---
> base-commit: 1fa8c5771a65fc5a56f6e39825561cdc8fa91e14
> change-id: 20251007-swap-table-p2-7d3086e5c38a
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>

