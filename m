Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5910CCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5B16B009E; Fri, 15 May 2026 05:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79496B00A4; Fri, 15 May 2026 05:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A681E6B00A3; Fri, 15 May 2026 05:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84F316B009D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37C1CC2B5B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:25 +0000 (UTC)
X-FDA: 84769194090.10.B841799
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2BC0AA0007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0Oll3qK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838863;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=prNRGA4BrHZkliCYyRA2I23tQvZ8CPSLUGaFezCIy1g=;
	b=IBaB9qKzJVj9Y/KlAPm8WFCXBX6VeCS2Ut+cRrRolj7t5XqqrSeaORcUt7DovrSUtJ6yCK
	h4WnyFuhRXN3ikE5o4KSZ/FJFwAYJ5drQG/5sNAwB834n9rVlORL9TZUkD/YmlmCMal545
	Hppz82QW5OuvqYc7skMcRW0jCw/bTf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838863; a=rsa-sha256;
	cv=none;
	b=S9mt9VoPLzuQvd2xt/qpbGMLc+Pf1PNWys3A2kaT5juLMCqFUc9nV+CtcVd587jtEHdtiB
	rxUG1DNFnKDil46+SBEbX0IvXBgr1ZtkqmigPgP8ueSHd4mxJ6RiDAlrEzMLGXhzDdmmuj
	wHJkVn3liWE1wB27e077NN6WtkpbKzg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0Oll3qK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EED4D434A2;
	Fri, 15 May 2026 09:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8067C2BCB8;
	Fri, 15 May 2026 09:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838861;
	bh=rRfCO3aB9U/iOJqwoxzGYYLza2p29DrYATWT/0SQ+24=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=k0Oll3qKP67UhQmoxQmeUE6JUgAGFiwHRSgmuMkJyJZ74ZWKT76idVMtJn+MWrXV6
	 m+EGn51Rw4N07ymgpHgybR146CtzzSRzKH2S3WPIGnhjizeRpYY+OfaFCte7pE/InX
	 1YaKG7t3cfOh06Syp9xp/a3do23K5kdPR+icyfWG9mlqDKmpR3nBl3It6YZTLRdik3
	 U6Mh5Vlu4EmepWBtEY3lZ6N+UYfs/ZrfWTtzri4GzcKqsadku/afilIL6p5stlSGmQ
	 Q8xnHtVI8IiVOzkwA43vpMrDYoZiEMryTAGTU6A1yyM39XLLzDr+VsQyTEP5ixdYTh
	 uBq7DMRw8BKCw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B788CCD4851;
	Fri, 15 May 2026 09:54:21 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v4 00/12] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
Date: Fri, 15 May 2026 17:54:13 +0800
Message-Id: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XPQQ6CMBCF4auQrq3pDIVSV97DuChlkCYKhJKqI
 dzdggsVl2+S709mYp4GR54dkokNFJx3XRuH3CXMNqa9EHdV3AwF5gIAuL+bno+mvBLvJdcFkcb
 SGGUli6YfqHaPtXc6x904P3bDc80HWK7vEqLYlAJwwUFIpbMKdAHZcaTWUjvubXdjSyvgx0tQW
 4+LV3XUAjKJxb9PvzxuPwlp9FhjqjJtVF7aXz/P8wuoTi2wLAEAAA==
X-Change-ID: 20260111-swap-table-p4-98ee92baa7c4
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=6356;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BzTfwZUHtgNuqb5kM5h8jWNl9TZuFWWrTO/8ZiO5hi8=;
 b=/z+CporQVOPlwE8qWqtM/px6qF000ZygbqyZO29u6WegtlV8G0t7mj9M34l1uTmVuBiLbS8cv
 SyWBheMxXesCx00/nOjBdY1LPrLy7/Y0+h3eFO4VeJI4Qo/K2brv0tk
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2BC0AA0007
X-Stat-Signature: 4pr3ke956mo5fja9yq63j4q158fbayhm
X-Rspam-User: 
X-HE-Tag: 1778838862-439350
X-HE-Meta: U2FsdGVkX19Da/+zHVhObvrmdNrlWoh7QAu62iClJKLKzTvuAG36/ZtoORffSizUXYhcwM1Il7sUjhCFwB+vTSi1frT6ZxmBSMBDurI+4NNp88sxrDFt3szyrNiM51ak3S0iHdx+CjpHbLtLqQcaWn7xYc4ZcbBQhzCmwtBbXg1x3fszxGPfNf3mIcJe4dU9UMBAlbwuLkeJWLyGzWPQ0etm1faXMCN88kYdFFiI7M4NzchF1AqGMk00355804tkEW6S8BvYAawGvWaexRIug+chGV3bqkLBC9FPoYq0td8kuVm7PnDEn2BADk/NXrmgzdyjk072CIhpBQzX2FoN7pqUfeIfXnpDwDQThbHc7cVYXWB46ZBNpprm0Y4i/cJtAV8ZNkpOfEvmV6+cm0qoklnMS3msE/+1X/zs0YTayWNlOiLkpQCElHMOS+0FikYltK2FC2OiXvt4IAhIfPSZBHhruOVhsTigl4pl3bVAQXOSgHmu+D55GFM6S9n082yf0rNQfmN1GBQRKZtAqau0fN3UHtlh2OcoI3xrC4UjOhOx4CIUGI/GKQ+cp+F1jAtKAn9iZ21uQFGQt7aHd1NMjyRzqFaqS0Xt4pLIPwJFCih74RmIWVSu0FFoLostw60FzfgrfWRvOlpzt/zLuGCawuV2D1yiN2ZNEQHX5rmRJEbrxSk5uR7tkcQNwYcIe5ryjYw4hHRZ//vRvfFMwR/SVsRR6xf8eowMAtWWzEd6LGhRZORMTpWmyA743mpE57QN74NIG8YHheT1HFhoVYhg4YfF16aDlxDewDu+pJvk6c9oIP8XJV60IUjUbS0zypPwQfFkNNaLLbsEt5sZJ+RSig+oj18y5rVRKuYMN65nbQ6H4w3sBkWA9Km1cK5eudgNaf92NLYGU51d8/bKypBk8DjPIRCzBsCLpAY0/rcpSV+MOBW9E7ynajf8JUFw8Rzb1ilZZTxBuLpmqjYyB8m
 sK0MtjFp
 51ZwLQcNnSaI6s9yzzJPa3Z3X8XHMaEZ2PjNaQvsal1FakZJttKCxC1437te25uvYvYQbM1PObLFwspOpBRMq0cIigEQZPw4qEuwEccRmj+PKes89FIF86SnAgDbuszKS87h9Z35dIMG4NZIpC86d7mvAXXP61xkkthdq9KjRj7XJIjuPyoLbGJODJszgObGbt+ZK9LEtDfdi5rCzPxMCuQbrouNMeD22+oHX6feC8MA/Dj6JzMZZpy8/lP6tYMZ0vp4esPd6hMOZj/NOMfmCzvQFPwKwaDgrH2o5bh0XHQabA9t2FHpmg72+HIzK0L3vRBcSE5Z7p0oOyIM/VYSmPUKI6YPxUMNKcSufBUb/l/bHVc6SO6r9viZbH57sR9gpOvAcbi9/sd8o0EHNyzn7zn7jEul+XbpzmHtvAIso5mDD3gbsyLc3qPHHHFPHK5xgvFYjbqJOLbhSEbXvuoKRliUiJdHUiuDa0gfojwmymQIiq8MYQLu9jX/Zug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This series unifies the allocation and charging of anon and shmem swap
in folios, provides better synchronization, consolidates the metadata
management, hence dropping the static array and map, and improves the
performance. The static metadata overhead is now close to zero, and
workload performance is slightly improved.

For example, mounting a 1TB swap device saves about 512MB of memory:

Before:
free -m
          total   used      free   shared   buff/cache   available
Mem:       1464    805       346        1          382         658
Swap:   1048575      0   1048575

After:
free -m
          total   used      free   shared   buff/cache   available
Mem:       1464    277       899         1         356        1187
Swap:   1048575      0   1048575

Memory usage is ~512M lower, and we now have a close to 0 static
overhead. It was about 2 bytes per slot before, now roughly 0.09375
bytes per slot (48 bytes ci info per cluster, which is 512 slots).

Performance test is also looking good, testing Redis in a 2G VM using
6G ZRAM as swap:

valkey-server --maxmemory 2560M
redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

Before: 3385017.283654 RPS
After:  3433309.307292 RPS (1.42% better)

Testing with build kernel under global pressure on a 48c96t system,
limiting the total memory to 8G, using 12G ZRAM, 24 test runs,
enabling THP:

make -j96, using defconfig

Before: user time 2904.59s system time 4773.99s
After:  user time 2909.38s system time 4641.55s (2.77% better)

Testing with usemem on a 32c machine using 48G brd ramdisk and 16G
RAM, 12 test run:

usemem --init-time -O -y -x -n 48 1G

Before: Throughput (Sum): 6482.58 MB/s Free Latency: 371371.67us
After:  Throughput (Sum): 6539.28 MB/s Free Latency: 363059.88us

Seems similar, or slightly better.

This series also reduces memory thrashing, I no longer see any:
"Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF", it was
shown several times during stress testing before this series when under
great pressure:

Before: grep -Ri VM_FAULT_OOM <test logs> | wc -l => 18
After:  grep -Ri VM_FAULT_OOM <test logs> | wc -l => 0

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v4:
- Rebased on latest mm-unstable and re-test, benchmark results are
  basically the same so mostly kept unchanged. Changes in v4 are code
  style and very minor behavior change.
- Improve a few commit messages, rename a few variables as suggested by
  [ Chris Li ].
- Rename thp_limit_gfp_mask to thp_shmem_limit_gfp_mask as suggested by
  [ Zi Yan ].
- Cleanup a few allocation and code style issue [ YoungJun Park ]
- Remove the forced fallback in swap_cache_alloc_folio, the caller will
  pass in the exact orders to be used. [ Baolin Wang ]
- Rename swapin_entry to swapin_sync, it's only used by synchronization
  devices at this moment and describes what it does better
  [ David Hildenbrand ]
- Link to v3: https://patch.msgid.link/20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com

Changes in v3:
- This is based on mm-unstable, also applies to mm-new, and has no
  conflict with YoungJun's tier series, and only trivial conflict with
  Baoquan's swapops due to filename change.
- Fix zero map build issue on 32 bit archs [ YoungJun Park ]
- Cleanup memcg table allocation helpers [ YoungJun Park ]
- Fix WARN for non NUMA build:
  https://lore.kernel.org/linux-mm/CAMgjq7ANih7u7SJB8uWcQHS8XRJySNRc3ti9V-SVey0nGE3gLQ@mail.gmail.com/
- Improve of commit messages.
- Re-test several tests, the conclusion is the same as v2.
- Link to v2: https://patch.msgid.link/20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com

Changes in v2:
- Drop the RFC prefix and also the RFC part.
- Now there is zero change to cgroup or refault tracking, RFC v1 changed
  some cgroup behavior. To archive that v2 use a standalone memcg_table
  for each cluster. It can be dropped or better optimized later if we
  have a better solution. The performance gain is partly cancelled
  compared to RFC v1 since we now need an extra allocation for free cluster
  isolation and peak memory usage is 2 bytes higher. But still looking
  good. That table size is accetable (1024 bytes), no RCU needed, and
  fits for kmalloc. Even if we keep it as it is in the future,
  it's still accetable.
- Link to v1: https://lore.kernel.org/r/20260220-swap-table-p4-v1-0-104795d19815@tencent.com

---
Kairui Song (12):
      mm, swap: simplify swap cache allocation helper
      mm, swap: move common swap cache operations into standalone helpers
      mm/huge_memory: move THP gfp limit helper into header
      mm, swap: add support for stable large allocation in swap cache directly
      mm, swap: unify large folio allocation
      mm/memcg, swap: tidy up cgroup v1 memsw swap helpers
      mm, swap: support flexible batch freeing of slots in different memcgs
      mm, swap: delay and unify memcg lookup and charging for swapin
      mm, swap: consolidate cluster allocation helpers
      mm/memcg, swap: store cgroup id in cluster table directly
      mm/memcg: remove no longer used swap cgroup array
      mm, swap: merge zeromap into swap table

 MAINTAINERS                 |   1 -
 include/linux/huge_mm.h     |  30 +++
 include/linux/memcontrol.h  |  16 +-
 include/linux/swap.h        |  19 +-
 include/linux/swap_cgroup.h |  47 ----
 mm/Makefile                 |   3 -
 mm/huge_memory.c            |   2 +-
 mm/internal.h               |  11 +-
 mm/memcontrol-v1.c          |  66 ++++--
 mm/memcontrol.c             |  31 ++-
 mm/memory.c                 |  88 ++------
 mm/page_io.c                |  61 +++++-
 mm/shmem.c                  | 123 +++--------
 mm/swap.h                   |  91 +++-----
 mm/swap_cgroup.c            | 174 ---------------
 mm/swap_state.c             | 519 +++++++++++++++++++++++++-------------------
 mm/swap_table.h             | 179 ++++++++++++---
 mm/swapfile.c               | 215 +++++++++---------
 mm/vmscan.c                 |   2 +-
 mm/zswap.c                  |  25 +--
 20 files changed, 800 insertions(+), 903 deletions(-)
---
base-commit: 444fc9435e57157fcf30fc99aee44997f3458641
change-id: 20260111-swap-table-p4-98ee92baa7c4

Best regards,
--  
Kairui Song <kasong@tencent.com>



