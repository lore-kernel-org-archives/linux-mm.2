Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 484F1C531E3
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E426B0092; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAD06B008C; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C8A6B008C; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2CC76B0092
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 977F35AF4B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:10 +0000 (UTC)
X-FDA: 84462832020.11.266128D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7F1992000C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pnqCTMkg;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544528;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xj/CmpVESdQHG0LN7FjI3PvpOLf6HuT2Rg9DKv7LDcQ=;
	b=TKCpbxeo14Cb9kc8R9MmSXIXUn/Uq4hd1okWvftpVS1zW9Ehk1Sed7RkB0Q67Ar+Byg/gE
	0sz3P6bCX9IsMMXPIgvBBE+M4QlmMVigpOzLdjLVOUJZNdWpLdQnZFFt17Z3ujbFQqYf6j
	Xfk0J+4wvHWlD2B7QW8cl3k1ginxFZ0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pnqCTMkg;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544528; a=rsa-sha256;
	cv=none;
	b=70ergHwmUviSn+2wXGUgo/SHirMZnePA+0GR5nouwNXS8s7FyJfDOAjQJcyatIReeO3qHk
	YlObsEb35IRpAXK/Fux0MDCUHMQlmd68yM3E3oEGfWLpv01Oo63rfMjM3ntXkLljQTNxIo
	f0Et0BxhBmGEOyPpdwZot+2XWa8tY9s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 468F541A69;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A400C4CEF7;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=AKav55qicOcAvRRVOAKirVRCJ9tBFhlmEFMkkyeMvqU=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=pnqCTMkg22dbooGByVctCRCYK7QqIENzZfe499K5bmGyDkWwmxwCGXhKMYN5ExCta
	 +q6pxDUxR5i+3hs4D38hLP3OicwysASRZqVnVVMoVO23fakOpIiZTny17fuFqBYY7U
	 Ftzu0h0rKaXcjUSzNs9Bup95ojkFBZtx5FJ7RLsjjq5jBWyhPDcdy29dhnDvcX4q0r
	 RLeiT5Qjtk2GW9g844EINFH+pf1tuU2cYJddL88RRUdIIuliON4V4ZqZlFa8WFO/AX
	 7DwTpoQgBuUxeONBWinJ9yGaN6slq8K4UT/5wUaBSuYkoNMfvKNlZMU8yZijQaPOKB
	 4Kwm2pmhxawYA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2765E9A04F;
	Thu, 19 Feb 2026 23:42:06 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic ghost
 swapfile
Date: Fri, 20 Feb 2026 07:42:01 +0800
Message-Id: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQ0ND3eLyxALdksSknFTdAhNdS4vUVEujpMRE82QTJaCegqLUtMwKsHn
 RSkFuzkqxtbUAaUzH9mQAAAA=
X-Change-ID: 20260111-swap-table-p4-98ee92baa7c4
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=11242;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=AKav55qicOcAvRRVOAKirVRCJ9tBFhlmEFMkkyeMvqU=;
 b=bMefXg26orrFX/o/nP5DoOVALI8DvpdRKz5GQyxQ2ji+AkA29lvpzsGW6SlKs8POwATD89TXr
 Fhn+jBg+Dk9CCC0HTIVF4vUMHUL9EDmVX7yiEuuYe9M6qlHxOK7KjCJ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: d7kfc5qum9hjfdgedr68jj979ro4tceh
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F1992000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1771544528-970629
X-HE-Meta: U2FsdGVkX185WX/+AM2G3Ti55AK00Go1gKCIk/U17RtmeERRYNnovpH3Te2tlVSfiARF2tHL/dHceoAzLQqhHb0bDkZypFR5Tbaxvgin+Rm4/FxtPF4V8j1UbkHvpZIiqAHBch49m/kK3u5wq1FyrxwrNwv5fJNo/Z87zVYYtng7XXDgYm7uSJDmDbfgYJCipfLU6LK1ETdiYy6b0DEce73L51kFozfbGfY+sWCOQ1JlFC7ctEHPbZo/KIZ24gwDfZAwz7gz37v2ZvHHJAzQHu+CUUnuEfh2nuASoC8Mj+oMeKstQP+1ymFRmYwgxqUweCOYKx64oivk35w1X+CLGyZheFSnu2GV6P4g1xveV1aR1//P0FfwC7+4KODYwSzl4bYTLt8npDN3Ws7g86xTW4Mk0ilEj5DToKd36rULzk9Fo0+yWfxxyXFOzlgMeCY0o5uiP86WMR0pxpltRVwX8Cwns62uXClfT05hwU0XJ7ZNVKtMobIY6fwinZwwzKrL9yDezWxPJVbcxwka0VqFcSe/Ac5owdA/jXVpl4w1xPqSPIvX5VzP7utRrfv3+4/FZPU4KY6ApAkMoseVBBUixJ9PcpJARCWz072Xf2cgWsGxwifwzrY2zWGcP3fmUIt1fjJqb6VQGVIoe3EK41z0+xiPwKGq9nYQgqOqaPDjYxBm9jvOXdeZ7b7GVqs/050exBxbS3usJ90PYIf/pNo/higByz9qDzWrlXiMyOnlTnxZpYbJ6CmXGNM/gSOqDycFY77+m0F/vnImCmJvXnWoM0jn9vaj5CdqH5c5CKycaS0FrS30gOoWcIDDKmKMQ9goY2HZedNy75Sgr/4QyhXvcedPlfRyqhUzzYA5YJ3eISBKsy4wJ3uvXYN1aZIMz9RQyX5r4lhTZSlv79ZLNwDwjnOnwCMSg4slHXlFoWmgYGBDgOpBDvTTxnPETqVo10Z48pqthexNzbUMCeryhN/
 1BQB7MwX
 LFXU0imdj39ZdqV0OZvAzjRdy1+FBRL+zEnMjfdqp4lhyQumZyMkxwBryRhlh7epBYsp3JSiGyOMZts9K9Ve7qie2k63ydsJm36hT+8Wkxotb51Gpr85XpSQmb25IpH5NXgxkdVEmwAJL4iC1SvzsWzZfDt+sbWyuDb40geI52xdLR3vIMW6RSw8pz7tbgYiq8BghuEjuFOWEtPBmE06kFYelprjCpM2LQV+E0SzQPm7XtLixQX5ubm4fJvanK7fH0aSAdQmFV1x5xvN0N9dIkq4PqciGFc3A2OtgAJp7GUR6XeNBOXwjDBSYA2vwTfKohAYYKa26TtYXp61tsstqDaOLjfPydyyKBQhYeGshhiulqXFhh1F2DguWImzcFTelEAvo/PvIcedu/WOYEA1yia6cOl2a8una3YdtYhOpqeeA53TLQrfxFx8FDMUNcicGH+3vXu17grZzkTyO00X6u/YaVJft3py9a3bnRBRyIaxOp4dj1ntFIbEtcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NOTE for an RFC quality series: Swap table P4 is patch 1 - 12, and the
dynamic ghost file is patch 13 - 15. Putting them together as RFC for
easier review and discussions. Swap table P4 is stable and good to merge
if we are OK with a few memcg reparent behavior (there is also a
solution if we don't), dynamic ghost swap is yet a minimal proof of
concept. See patch 15 for more details. And see below for Swap table 4
cover letter (nice performance gain and memory save).

This is based on the latest mm-unstable, swap table P3 [1] and patches
[2] and [3], [4]. Sending this out early, as it might be helpful for us
to get a cleaner picture of the ongoing efforts, make the discussions easier.

Summary: With this approach, we can have an infinitely or dynamically
large ghost which could be identical to "virtual swap", and support
every feature we need while being *runtime configurable* with *zero
overhead* for plain swap and keep the infrastructure unified. Also
highly compatible with YoungJun's swap tiering [5], and other ideas like
swap table compaction, swapops, as it aligns with a few proposals [6]
[7] [8] [9] [10].

In the past two years, most efforts have focused on the swap
infrastructure, and we have made tremendous gains in performance,
keeping the memory usage reasonable or lower, and also greatly cleaned
up and simplified the API and conventions.

Now the infrastructures are almost ready, after P4, implementing an
infinitely or dynamically large swapfile can be done in a very easy to
maintain and flexible way, code change is minimal and progressive
for review, and makes future optimization like swap table compaction
doable too, since the infrastructure is all the same for all swaps.

The dynamic swap file is now using Xarray for the cluster info, and
inside the cluster, it's all the same swap allocator, swap table, and
existing infrastructures. A virtual table is available for any extra
data or usage. See below for the benefits and what we can achieve.

Huge thanks to Chris Li for the layered swap table and ghost swapfile
idea, without whom the work here can't be archived. Also, thanks to Nhat
for pushing and suggesting using an Xarray for the swapfile [11] for
dynamic size. I was originally planning to use a dynamic cluster
array, which requires a bit more adaptation, cleanup, and convention
changes. But during the discussion there, I got the inspiration that
Xarray can be used as the intermediate step, making this approach
doable with minimal changes. Just keep using it in the future, it
might not hurt too, as Xarray is only limited to ghost / virtual
files, so plain swaps won't have any extra overhead for lookup or high
risk of swapout allocation failure.

I'm fully open and totally fine for suggestions on naming or API
strategy, and others are highly welcome to keep the work going using
this flexible approach. Following this approach, we will have all the
following things progressively (some are already or almost there):

- 8 bytes per slot memory usage, when using only plain swap.
  - And the memory usage can be reduced to 3 or only 1 byte.
- 16 bytes per slot memory usage, when using ghost / virtual zswap.
  - Zswap can just use ci_dyn->virtual_table to free up it's content
    completely.
  - And the memory usage can be reduced to 11 or 8 bytes using the same
    code above.
  - 24 bytes only if including reverse mapping is in use.
- Minimal code review or maintenance burden. All layers are using the exact
  same infrastructure for metadata / allocation / synchronization, making
  all API and conventions consistent and easy to maintain.
- Writeback, migration and compaction are easily supportable since both
  reverse mapping and reallocation are prepared. We just need a
  folio_realloc_swap to allocate new entries for the existing entry, and
  fill the swap table with a reserve map entry.
- Fast swapoff: Just read into ghost / virtual swap cache.
- Zero static data (mostly due to swap table P4), even the clusters are
  dynamic (If using Xarray, only for ghost / virtual swap file).
- So we can have an infinitely sized swap space with no static data
  overhead.
- Everything is runtime configurable, and high-performance. An
  uncompressible workload or an offline batch workload can directly use a
  plain or remote swap for the lowest interference, memory usage, or for
  best performance.
- Highly compatible with YoungJun's swap tiering, even the ghost / virtual
  file can be just a tier. For example, if you have a huge NBD that doesn't
  care about fragmentation and compression, or the workload is
  uncompressible, setting the workload to use NBD's tier will give you only
  8 bytes of overhead per slot and peak performance, bypassing everything.
  Meanwhile, other workloads or cgroups can still use the ghost layer with
  compression or defragmentation using 16 bytes (zswap only) or 24 bytes
  (ghost swap with physical writeback) overhead.
- No force or breaking change to any existing allocation, priority, swap
  setup, or reclaim strategy. Ghost / virtual swap can be enabled or
  disabled using swapon / swapoff.

And if you consider these ops are too complex to set up and maintain, we
can then only allow one ghost / virtual file, make it infinitely large,
and be the default one and top tier, then it achieves the identical thing
to virtual swap space, but with much fewer LOC changed and being runtime
optional.

Currently, the dynamic ghost files are just reported as ordinary swap files
in /proc/swaps and we can have multiple ones, so users will have a full
view of what's going on. This is a very easy-to-change design decision.
I'm open to ideas about how we should present this to users. e.g., Hiding
it will make it more "virtual", but I don't think that's a good idea.

The size of the swapfile (si->max) is now just a number, which could be
changeable at runtime if we have a proper idea how to expose that and
might need some audit of a few remaining users. But right now, we can
already easily have a huge swap device with no overhead, for example:

free -m
               total        used        free      shared  buff/cache   available
Mem:            1465         250         927           1         356        1215
Swap:       15269887           0    15269887

And for easier testing, I added a /dev/ghostswap in this RFC. `swapon
/dev/ghostswap` enables that. Without swapon /dev/ghostswap, any existing
users, including ZRAM, won't observe any change.

===

Original cover letter for swap table phase IV:

This series unifies the allocation and charging process of anon and shmem,
provides better synchronization, and consolidates cgroup tracking, hence
dropping the cgroup array and improving the performance of mTHP by about
~15%.

Still testing with build kernel under great pressure, enabling mTHP 256kB,
on an EPYC 7K62 using 16G ZRAM, make -j48 with 1G memory limit, 12 test
runs:

Before: 2215.55s system, 2:53.03 elapsed
After:  1852.14s system, 2:41.44 elapsed (16.4% faster system time)

In some workloads, the speed gain is more than that since this reduces
memory thrashing, so even IO-bound work could benefit a lot, and I no
longer see any: "Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying
PF", it was shown from time to time before this series.

Now, the swap cache layer ensures a folio will be the exclusive owner of
the swap slot, then charge it, which leads to much smaller thrashing when
under pressure.

And besides, the swap cgroup static array is gone, so for example, mounting
a 1TB swap device saves about 512MB of memory:

Before:
        total     used     free     shared  buff/cache available
Mem:    1465      854      331      1       347        610
Swap:   1048575   0        1048575

After:
        total     used     free     shared  buff/cache available
Mem:    1465      332      838      1       363        1133
Swap:   1048575   0        1048575

It saves us ~512M of memory, we now have close to 0 static overhead.

Link: https://lore.kernel.org/linux-mm/20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com/ [1]
Link: https://lore.kernel.org/linux-mm/20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com/ [2]
Link: https://lore.kernel.org/linux-mm/20260211-shmem-swap-gfp-v1-1-e9781099a861@tencent.com/ [3]
Link: https://lore.kernel.org/linux-mm/20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com/ [4]
Link: https://lore.kernel.org/linux-mm/20260217000950.4015880-1-youngjun.park@lge.com/ [5]
Link: https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com/ [6]
Link: https://lwn.net/Articles/974587/ [7]
Link: https://lwn.net/Articles/932077/ [8]
Link: https://lwn.net/Articles/1016136/ [9]
Link: https://lore.kernel.org/linux-mm/20260208215839.87595-1-nphamcs@gmail.com/ [10]
Link: https://lore.kernel.org/linux-mm/CAKEwX=OUni7PuUqGQUhbMDtErurFN_i=1RgzyQsNXy4LABhXoA@mail.gmail.com/ [11]

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Chris Li (1):
      mm: ghost swapfile support for zswap

Kairui Song (14):
      mm: move thp_limit_gfp_mask to header
      mm, swap: simplify swap_cache_alloc_folio
      mm, swap: move conflict checking logic of out swap cache adding
      mm, swap: add support for large order folios in swap cache directly
      mm, swap: unify large folio allocation
      memcg, swap: reparent the swap entry on swapin if swapout cgroup is dead
      memcg, swap: defer the recording of memcg info and reparent flexibly
      mm, swap: store and check memcg info in the swap table
      mm, swap: support flexible batch freeing of slots in different memcg
      mm, swap: always retrieve memcg id from swap table
      mm/swap, memcg: remove swap cgroup array
      mm, swap: merge zeromap into swap table
      mm, swap: add a special device for ghost swap setup
      mm, swap: allocate cluster dynamically for ghost swapfile

 MAINTAINERS                 |   1 -
 drivers/char/mem.c          |  39 ++++
 include/linux/huge_mm.h     |  24 +++
 include/linux/memcontrol.h  |  12 +-
 include/linux/swap.h        |  30 ++-
 include/linux/swap_cgroup.h |  47 -----
 mm/Makefile                 |   3 -
 mm/internal.h               |  25 ++-
 mm/memcontrol-v1.c          |  78 ++++----
 mm/memcontrol.c             | 119 ++++++++++--
 mm/memory.c                 |  89 ++-------
 mm/page_io.c                |  46 +++--
 mm/shmem.c                  | 122 +++---------
 mm/swap.h                   | 122 +++++-------
 mm/swap_cgroup.c            | 172 ----------------
 mm/swap_state.c             | 464 ++++++++++++++++++++++++--------------------
 mm/swap_table.h             | 105 ++++++++--
 mm/swapfile.c               | 278 ++++++++++++++++++++------
 mm/vmscan.c                 |   7 +-
 mm/workingset.c             |  16 +-
 mm/zswap.c                  |  29 +--
 21 files changed, 977 insertions(+), 851 deletions(-)
---
base-commit: 4750368e2cd365ac1e02c6919013c8871f35d8f9
change-id: 20260111-swap-table-p4-98ee92baa7c4

Best regards,
-- 
Kairui Song <kasong@tencent.com>



