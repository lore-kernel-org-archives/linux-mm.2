Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CA6CD484D
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2DA6B0136; Mon, 11 May 2026 12:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845F56B0137; Mon, 11 May 2026 12:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6497A6B0138; Mon, 11 May 2026 12:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0F76B0136
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:34:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B1761C0040
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:20 +0000 (UTC)
X-FDA: 84755686680.01.CF3365A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 177CD180013
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DofAni5J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aWNmeaowGMzZOcmfjCnleU0Ukw7o2XuUkaZsrHgvmM=;
	b=yaidLrJqohJ/eB8E6ja56YeG/gTjpn+g8B1eYkmeE4lGV7OlhrPkb0Svo67qDIOZI8CH0p
	78VApLOPASc0oML9HtsYxyFx5KWZzo3D1n2ZLgRwABzzohfVYAD6E2hLWFt+AQ/Asc4ScA
	e7VVB0I4H25fgXIUPpSVVGHlkE6hNcA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517258; a=rsa-sha256;
	cv=none;
	b=rqiWMaddepuPfd17h3L2tjRGIJmXG5qmjzHYBsMQsJrEVFWV4Hh1iphjS7NHrb0Hxt1Y2B
	SrD+2Rxzatp3QF1+BpYmMBfS4/T6JDjvlSXEmB0JbGecRbnh2MmmSwCxAl72CFeZLt7ev+
	+G5XGWE9sBnY1FJEsyrIHT4U4UuFqTw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DofAni5J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45D8D4452B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26080C2BCFB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517257;
	bh=3nr0vIIFvbfF0sgso3eC8e1RvYRXIeBy5fBg+8Eejk4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DofAni5JHJPiIfUAa0D+nHQ9Hp7yalueX4UqWa7EnlvCZRyn0e2Hbj3C/qkaGt9oY
	 i2AHNrQBSzidcrllKFnby7E+G5ZX01qvRxibc0xcrjiAZtyZf2HCUQxGZsnbRfj4Gq
	 OjgrEPgILHhkOq1smyDO0Uf9j8rSCUQrtoiSf6ncON4iNR7jPR+qXkFus49eaZshkA
	 oWxMeBH/AIoDW73OZt0Em0YRRQtt+0rqHS/X83ErCaQvTk6EePt1bZ3TLYSUok5t37
	 43kQL1vjYOr9VdI1O2UhotkqPWrVXAnDa9MecJg0A8c1IV1fraty2Pue4LW5gV7pf4
	 Y7shLVoim/sEQ==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65dbe04fc1bso1304979d50.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:34:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9B5O5ZlxnNbK2sF06iTciIQJllS2wVx9T/o4zUrKy7Kdj0zoZhCqHfFG9fwwgqpUe7YgicOkgZLg==@kvack.org
X-Gm-Message-State: AOJu0YzLFRPA0uglb/QWnmMexQqt5JlsYpt3GhNgMxZFlJvHEg7tzeYy
	l4tj+8Nijk1z1QydgM8Ve+8IhfM9Xr4Rsx98wd1UwNI/+YiNBht7hj6ONUeXgHaMNmuqiTFbbMl
	RYJHH0EX8z+98L2nLBMPXXPFRv1L9uoyqJjRBmL9HiA==
X-Received: by 2002:a05:690e:4087:b0:650:dbb:e79c with SMTP id
 956f58d0204a3-65d94c4c496mr14333914d50.40.1778517256388; Mon, 11 May 2026
 09:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 11 May 2026 18:34:03 +0200
X-Gmail-Original-Message-ID: <CACePvbXGVYtX8hQCRsSO1EkiDhXWpwmTFZJGxCcoF09dbLK0Xw@mail.gmail.com>
X-Gm-Features: AVHnY4LUbtJn8VCJ09yjo5GzGsZ7W7DUQUUlJ4Zgjocidx3KutvjsQwKCnBuG-c
Message-ID: <CACePvbXGVYtX8hQCRsSO1EkiDhXWpwmTFZJGxCcoF09dbLK0Xw@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 177CD180013
X-Stat-Signature: c53su4x5mqrge8qios1aohjzz6j9pp3u
X-Rspam-User: 
X-HE-Tag: 1778517257-614296
X-HE-Meta: U2FsdGVkX18KWQVtmM4BhjKO1SaIDkgcWJ+RsN/o7Y4zL/ROzfZpMeVoru5911PTGQfiMVuhK0VN5/WKMfhzQa8ZUXxMNSF03V0bwYXX7ZXh7EA+BpjVCKfw9T3wORTaXuozqpOipBMeKfXVElfhNCmiEu4VSD/zU7N1JCzcY0RYtzgyNMVgM4k5lVyYPptDydRID+7USFEMxASJwJZ5Aepl7ZgO/0irLYdR/ZQUZozUHEdC7qd0iOT6xCK1OBdWLhj2OFyFcuxmiVqTpF+lz+69CqHvQrcIOWN2g4+FNAYx6UsDlmhStw0FMAaxe063i7JWgNM4nsJ0HvDfl/WteemXZ/BYjvkZH1GfswmQu2C21CAtg34oyAR1BAf3fx3ncYe7f1L6OZRXHQnj/9LoMjlG4YWotCOhlkIkv/i5UmsAx8NbDwnhoidzgO7vEUI7r7oB7jwZiv6KhGoR1nvwVfPuLxbyYH8tO/Ys5B6oS0Jg4XHXGIb9zgfIrcZZmdVp+gXuRM5hAGYTJxpdBJ9Zs1KRjx31kxdH9dM0e9SLX7vPv3Vj3IWo8t+3crMda1XAG7hsg9ICaGxFlRHjZhg33YVDmnG/72uy8kKzhVYU1gX0jT5YQjfin0wCSuRzOwsP0rgRh2v+fzymOqsgOYMSiBAPDwDHqtFVlZZQ3fOyv3odvbxEC3tUNmElacErIzzhTFwgCR+ZFgIG883+2I00BVKeVV2LDTmwd2H1mEKkN2x67LaV3Z+lQ57z6Cjvj8zPNPwqe6r5Sz9v5ClGnsUFHDyono/AXRQ6jJ1rvS1gOx6u2/Flf8fgUEYmAejgQlG+/EUM/X42gm1ZYow1jRx1/oGSsGp5M5i+IWSEyz3cJ34oPjWUf4g86nw4EjU6dqfQQ+RGRkrBEepLa3eInXmMLeGdzJ8ditHks97yVfddf6RDKoef6fnvXXrdgPiZCxpDh5TAC0F2zKPtKgjz/Nc
 bvB4xD2e
 Okzo4UcB4YJCORBPE2rMvTnG8g+lWWhLhsY9VVlm0Kpcn0kbDkFoSEiYUhbisKtuNHl47uJQKV5PqA/tWV1mLI/GIkQgZ6WzFS/A+iAmrUPvtFN7cBjOMIGCiQRlkLdPxjDEWAZCiRYwjyIPrJx9002DDkYXEhNVhw9MxWzALB1kSKECOgWw59LNvm6UqekFiyFRM3RZ32Hjhm5mHSunwj8XET3iX/XV2ddlUPa12fJpuIu8KdxNm9IbzuVMh/6rbPfzHi3tMJqO/6tNyJcCfX84slm83cBuMJYrPgsBDMoYnrKsiLdvKpmSdXtJ7yXnIj4zJ53VdXRLclPLc7oInFR3Q1MM64oFxkHtC89du/sFgcTMna6OEmeb6XgstW6ISpt/+1q2svIpcUh1YTg5kw9gJBuXYf7c78cSI99lpEqbJ61osFQhLeiHZ+NnEnW7Uz7aIugJNSONx7etkNaQEW2eFZ3OWxJP/jNobmfBInV5S56D9y/LfE61nLcTD7sEunsUXzFxM/+n0dEvcrgez6FTlLiqfOMXn8lOaPfaoPlvwwqnwXDVBPg1j5jqn2EBx0wubNueb5rz8tDnceaenJETSo/IaX++vEMZciqmRTMv5MClneU8hL1fd0sqbSqjUAoP32gedrD+GPByuNnVtSSDYV3DiMXjGbxo46fOSTvcguOCnXvDMhksQ1HMuTlcElTd8RczUG/7ditZeedeCoR1SR/uBrcVJOJoJCI2D/S9jWbJhvlTvk+bd4kTkqgNnNIPO0LRIoBkS6Jsy8NAdaKIJ/mEXfSBwPptgj4SNvYN3Fh735pTZpFPYX8yeLDp9lGjKruUJ7C6ues5VyZ0YOSozP8poGF0Z1Qh2LR8OIk9G3mQYOp3W9vFy8k5XrZD7JOMArdFAxQGuQgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 11:16=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> This series unifies the allocation and charging of anon and shmem swap
> in folios, provides better synchronization, consolidates the metadata
> management, hence dropping the static array and map, and improves the
> performance. The static metadata overhead is now close to zero, and
> workload performance is slightly improved.
>
> For example, mounting a 1TB swap device saves about 512MB of memory:
>
> Before:
> free -m
>           total   used      free   shared   buff/cache   available
> Mem:       1464    805       346        1          382         658
> Swap:   1048575      0   1048575
>
> After:
> free -m
>           total   used      free   shared   buff/cache   available
> Mem:       1464    277       899         1         356        1187
> Swap:   1048575      0   1048575
>
> Memory usage is ~512M lower, and we now have a close to 0 static
> overhead. It was about 2 bytes per slot before, now roughly 0.09375
> bytes per slot (48 bytes ci info per cluster, which is 512 slots).
>
> Performance test is also looking good, testing Redis in a 1.5G VM using
> 5G ZRAM as swap:
>
> valkey-server --maxmemory 2560M
> redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
>
> Before: 3289011.918750 RPS
> After:  3312087.142241 RPS (0.99% better)
>
> Testing with build kernel under global pressure on a 48c96t system,
> limiting the total memory to 8G, using 12G ZRAM, 24 test runs,
> enabling THP:
>
> make -j96, using defconfig
>
> Before: user time 2904.59s system time 4773.99s
> After:  user time 2909.38s system time 4641.55s (2.77% better)
>
> Testing with usemem on a 32c machine using 48G brd ramdisk and 16G
> RAM, 12 test run:
>
> usemem --init-time -O -y -x -n 48 1G
>
> Before: Throughput (Sum): 6482.58 MB/s Free Latency: 371371.67us
> After:  Throughput (Sum): 6539.28 MB/s Free Latency: 363059.88us
>
> Seems similar, or slightly better.
>
> This series also reduces memory thrashing, I no longer see any:
> "Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF", it was
> shown several times during stress testing before this series when under
> great pressure:
>
> Before: grep -Ri VM_FAULT_OOM <test logs> | wc -l =3D> 18
> After:  grep -Ri VM_FAULT_OOM <test logs> | wc -l =3D> 0
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Hi Andrew,

I have given this swap table phase 4 series the first round of review.
Overall, it looks good with some minor nitpicks.

Can you add this to the mm-unstable for  more exposures?

Thanks

Chris

> ---
> Changes in v3:
> - This is based on mm-unstable, also applies to mm-new, and has no
>   conflict with YoungJun's tier series, and only trivial conflict with
>   Baoquan's swapops due to filename change.
> - Fix zero map build issue on 32 bit archs [ YoungJun Park ]
> - Cleanup memcg table allocation helpers [ YoungJun Park ]
> - Fix WARN for non NUMA build:
>   https://lore.kernel.org/linux-mm/CAMgjq7ANih7u7SJB8uWcQHS8XRJySNRc3ti9V=
-SVey0nGE3gLQ@mail.gmail.com/
> - Improve of commit messages.
> - Re-test several tests, the conclusion is the same as v2.
> - Link to v2: https://patch.msgid.link/20260417-swap-table-p4-v2-0-17f5d1=
015428@tencent.com
>
> Changes in v2:
> - Drop the RFC prefix and also the RFC part.
> - Now there is zero change to cgroup or refault tracking, RFC v1 changed
>   some cgroup behavior. To archive that v2 use a standalone memcg_table
>   for each cluster. It can be dropped or better optimized later if we
>   have a better solution. The performance gain is partly cancelled
>   compared to RFC v1 since we now need an extra allocation for free clust=
er
>   isolation and peak memory usage is 2 bytes higher. But still looking
>   good. That table size is accetable (1024 bytes), no RCU needed, and
>   fits for kmalloc. Even if we keep it as it is in the future,
>   it's still accetable.
> - Link to v1: https://lore.kernel.org/r/20260220-swap-table-p4-v1-0-10479=
5d19815@tencent.com
>
> To: linux-mm@kvack.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Youngjun Park <youngjun.park@lge.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Yosry Ahmed <yosry@kernel.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
>
> ---
> Kairui Song (12):
>       mm, swap: simplify swap cache allocation helper
>       mm, swap: move common swap cache operations into standalone helpers
>       mm/huge_memory: move THP gfp limit helper into header
>       mm, swap: add support for stable large allocation in swap cache dir=
ectly
>       mm, swap: unify large folio allocation
>       mm/memcg, swap: tidy up cgroup v1 memsw swap helpers
>       mm, swap: support flexible batch freeing of slots in different memc=
gs
>       mm, swap: delay and unify memcg lookup and charging for swapin
>       mm, swap: consolidate cluster allocation helpers
>       mm/memcg, swap: store cgroup id in cluster table directly
>       mm/memcg: remove no longer used swap cgroup array
>       mm, swap: merge zeromap into swap table
>
>  MAINTAINERS                 |   1 -
>  include/linux/huge_mm.h     |  30 +++
>  include/linux/memcontrol.h  |  16 +-
>  include/linux/swap.h        |  19 +-
>  include/linux/swap_cgroup.h |  47 ----
>  mm/Makefile                 |   3 -
>  mm/huge_memory.c            |   2 +-
>  mm/internal.h               |  11 +-
>  mm/memcontrol-v1.c          |  66 +++---
>  mm/memcontrol.c             |  32 +--
>  mm/memory.c                 |  88 ++------
>  mm/page_io.c                |  58 ++++-
>  mm/shmem.c                  | 122 +++--------
>  mm/swap.h                   |  91 +++-----
>  mm/swap_cgroup.c            | 172 ---------------
>  mm/swap_state.c             | 516 +++++++++++++++++++++++++-------------=
------
>  mm/swap_table.h             | 169 ++++++++++++---
>  mm/swapfile.c               | 212 +++++++++---------
>  mm/vmscan.c                 |   2 +-
>  mm/zswap.c                  |  25 +--
>  20 files changed, 783 insertions(+), 899 deletions(-)
> ---
> base-commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
> change-id: 20260111-swap-table-p4-98ee92baa7c4
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>
>

