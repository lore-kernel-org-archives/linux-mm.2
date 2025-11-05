Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1098FCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 07:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582B08E0006; Wed,  5 Nov 2025 02:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533728E0002; Wed,  5 Nov 2025 02:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449178E0006; Wed,  5 Nov 2025 02:39:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34A2F8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:39:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6E8DC01EE
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:39:37 +0000 (UTC)
X-FDA: 84075753594.01.C348737
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 074952000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:39:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3bBg23v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762328376; a=rsa-sha256;
	cv=none;
	b=M8EndEiffIut1YpJy6gl5CwZzsWrr3yi6vNTSWZHFLhUjbDWWPNbpDpchj3AuQGBPJpl7V
	Di/1cgiSA7x1bNQLfwZtQzPPrsHxlYlfzEcQ2dsp0HeN4iAFdJNj/min89i/Q1O4dOjAUi
	UB6DTWQp0fffAEwMIHIA46UB6ENQvr8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3bBg23v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762328376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTGPaALNXtXTWKpufu61u4sGUQIgOwmDPHJoY1Snhio=;
	b=p6+OYRPWFLtEf0Y9EsgZRCeRqLCG3MmZa3ACdqSkSeGuXQh44KZ7iJQHRURIcfkrPA7hBA
	eDKuIJgEv1bVc071eXOfD2U63DEvv47Em707gehVMVQkvbZJB6nUhOj9CapkBTE5QpbYim
	pCYsZ6AKWb3ykcKy9h1KaTsjWl2gyhM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2036260213
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BB4C19421
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762328374;
	bh=/vg+7+Moo/OB+f9aYaClqZiz4nKKXBfk39XMf6w6D04=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=X3bBg23vXxkvmwX5gkjiu6Hdk8E+EWLqO/b+HlbwpovGGvXaibtyi2A7seMXvsiS8
	 hf1Z2v5LDp7N3vPCctsgXEMYraJ6QYh89J3bRX9tigO6Bzr1w4kmKcm5txay9XWz1q
	 ap4gx4ONYxU28KZtXGq4haLGJOY9kw0F6bweby3ieeadjreNiqCC2GZY2GwAbTpHNl
	 coMX9sn66ZzoV5posKdAWezgNt6uffab5FmnwMY5OX9JyVdoaVkq9aDrFRVhOsLEih
	 c97Kriej3pQiK9ho7xvsH/yFAlPp5VD+Ocfw410Pm3r19qc1yhd77J7MVjzJmzmRtN
	 mSl9djr+aPXEA==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7867497ad2fso9000987b3.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 23:39:34 -0800 (PST)
X-Gm-Message-State: AOJu0YyGPw7U1Dkmowh22YuhUWWt1SUpOMF/jSNEHKxr2jj5bKJFfSgR
	Rt8Ri8rFHl67PsIp0V+WoHxISzTd4D8ZBHI2kwAdJpqYvkzkzvwNBDmuusgJzZPGWZN7tpLQgwM
	hxUFOTYFOaT0shbo4IDDo3aktHR2QhAmDbVSsP7TB6g==
X-Google-Smtp-Source: AGHT+IGX86xgQBCmLrk/QzKuO4utxmWpZrge7RSgHnrJJ9y/6Mf1fWxn/yJu+oXQe4PK+p2VLbMWjHC84pqTrQmHqBE=
X-Received: by 2002:a05:690e:190a:b0:63e:29af:bd23 with SMTP id
 956f58d0204a3-63fc74addabmr4307350d50.4.1762328374083; Tue, 04 Nov 2025
 23:39:34 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 4 Nov 2025 23:39:22 -0800
X-Gmail-Original-Message-ID: <CACePvbWgMpKgHLB1=u0hbjb5Koncc11TpLLBd6objAs0PaKV1A@mail.gmail.com>
X-Gm-Features: AWmQ_bnIYaNmRXhdYNKfzLAmy6l6ZxVb1e89MkVAHp2LAIM_idVKUcOc1WkvZys
Message-ID: <CACePvbWgMpKgHLB1=u0hbjb5Koncc11TpLLBd6objAs0PaKV1A@mail.gmail.com>
Subject: Re: [PATCH 00/19] mm, swap: never bypass swap cache and cleanup flags
 (swap table phase II)
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 074952000B
X-Stat-Signature: iwru8ahggnegmwxct1g7n7j1ady7dzg5
X-HE-Tag: 1762328375-542951
X-HE-Meta: U2FsdGVkX1+uHgl7G0bUteuYcnjCShEvmDGg0OEOWV1f+ErNkuZui82fjbMX6b12vJdfi86AaTbYt0FJDxR03CRihjqt+Zv38Z8EgFzEZcsQXcOFa7e/vfxXWfdh77T52pDSnqD+4acyW7loFhepN6GpQQbfyLyfeajepjiPQKi0m/uLXWCTLrAnKKz1WHonnvse8zczJNqyNKP4KvEXSksTRZOCwQ6Dg28CnXBx69wTGM9V21pJgCst1/hqdFMuAxXYzaW3a4cASsVIghQOBYaCeVY0WdurLYVgqcVLRznQodOQZR1FGGjymnP2cjGDfuHO6fJVQ4oNik2EKWXGx0sJZnUjBELqexSuawtr7U3Feqth+SXevbt2SHb6NuOhST/oedpZ9YKaYxiGz/XIyqNYkNhD5s4CUTqlG3qwYVhjYer4e79zU/sV/s55SxGROZpGQh+qnNaE9AZ+sG6kghi+eMdwnnLFF/W6OMK/rV3Mt/L37eNT1syTuzzitd+V5ODa/+1U6FpQwGzm4dKqoBN3y96naXwAulxO9Ss8/oj1SybnAUetxLFTyNI6vkNr3r89fdaJn6bM+RlN59K6wf8gWYogqRQ2sAN8T51SEhV4QI/gmEm5Iw8907YQEo6uEAIvRn6UF93WNkgr0keDTcew4vjQTvzH6g92arf6+8h0VSfMaXXWPgEz2roakdceDzFJ7vdZZM690vkk48JMBbDo2NuIU4dPS9C0RvDWOcoCDN6Rn44LTgl8iCUK3lt9xD7ATVh2tpDM8MgOo/pNapJ35pT1xz81RViVP6gMpT39FjkYVg4CG71fcYqrVuBWYJH48kwEyKbJRoSSOspLiB+bG0+Mwczon5sAeObt/bAXcwI02A4Aqangkaf2fORqrg9AGroaIYL78cNXi/v20h3c/1+5/jzmZLz5dG88qkSets615xHOLjQYwpifC7PyR7qu7xFfv6gMPmNu4vh
 utYUa1vx
 LhmnmtiIEiogK5uUizJDaCrX0AgYe6D6RPAYyUAfQsBzg7pF5FrG+bN9FgDIap/DT14XWa1lxpf82RHcgSyoJWACokua22m5Jp3t+bAU25jM31FuO11GiUqFtAdGL4y5wqo7DnGSW40hTcfY7/ny3wrioW+8VwFoUiWixpdx1fJI87uDMzPlX03mZFiVuNH8GuMikYiCKOl9dMWzR4bWo7TU1kMvucr6cngEdW6juHn0ZfMZ85TDPOItzxN08P6A7urptupkYhyCGD71LSGRh6TbBVT+V8ioAKj5SyzS8v0vZMvX2D6bkt3ES/dzHpe1tr6g+th118TOB1Rht/E0V1xy8zUHJ7yKGQLeE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry I have been super busy and late to the review party.

I am still catching up on my backlogs.

The cover letter title is a bit too long, I suggest you put the swap
table phase II in the beginning of the title rather than the end. The
title is too long and "phase II" gets wrapped to another line. Maybe
just use "swap table phase II" as the cover letter title is good
enough. You can explain what this series does in more detail in the
body of the cover letter.

Also we can mention the total estimate of phases for the swap tables
(4-5 phases?). Does not need to be precise, just serves as an overall
indication of the swap table progress bar.

On Wed, Oct 29, 2025 at 8:59=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> This series removes the SWP_SYNCHRONOUS_IO swap cache bypass code and

Great job!

> special swap bits including SWAP_HAS_CACHE, along with many historical
> issues. The performance is about ~20% better for some workloads, like
> Redis with persistence. This also cleans up the code to prepare for
> later phases, some patches are from a previously posted series.

That is wonderful we can remove SWAP_HAS_CACHE and remove sync IO swap
cache bypass. Swap table is so fast the bypass does not make any sense
any more.

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
> enabled THP swapin for all folios. It's still limited to SYNC_IO
> devices, though, this limitation can will be removed later. This may

Grammer. "though, this"  "can will be"

 The THP swapin is still limited to SYNC_IO devices.  This limitation
can be removed later.

Chris

> cause more serious thrashing for certain workloads, but that's not an
> issue caused by this series, it's a common THP issue we should resolve
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
> Kairui Song (18):
>       mm/swap: rename __read_swap_cache_async to swap_cache_alloc_folio
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
>       mm, swap: consolidate cluster reclaim and check logic
>       mm, swap: split locked entry duplicating into a standalone helper
>       mm, swap: use swap cache as the swap in synchronize layer
>       mm, swap: remove workaround for unsynchronized swap map cache state
>       mm, swap: sanitize swap entry management workflow
>       mm, swap: add folio to swap cache directly on allocation
>       mm, swap: check swap table directly for checking cache
>       mm, swap: clean up and improve swap entries freeing
>       mm, swap: drop the SWAP_HAS_CACHE flag
>       mm, swap: remove no longer needed _swap_info_get
>
> Nhat Pham (1):
>       mm/shmem, swap: remove SWAP_MAP_SHMEM
>
>  arch/s390/mm/pgtable.c |   2 +-
>  include/linux/swap.h   |  77 ++---
>  kernel/power/swap.c    |  10 +-
>  mm/madvise.c           |   2 +-
>  mm/memory.c            | 270 +++++++---------
>  mm/rmap.c              |   7 +-
>  mm/shmem.c             |  75 ++---
>  mm/swap.h              |  69 +++-
>  mm/swap_state.c        | 341 +++++++++++++-------
>  mm/swapfile.c          | 849 +++++++++++++++++++++----------------------=
------
>  mm/userfaultfd.c       |  10 +-
>  mm/vmscan.c            |   1 -
>  mm/zswap.c             |   4 +-
>  13 files changed, 840 insertions(+), 877 deletions(-)
> ---
> base-commit: f30d294530d939fa4b77d61bc60f25c4284841fa
> change-id: 20251007-swap-table-p2-7d3086e5c38a
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>

