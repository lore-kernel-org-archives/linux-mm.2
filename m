Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C78CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 15:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059D66B0005; Sun, 17 May 2026 11:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B3D6B0088; Sun, 17 May 2026 11:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C1D6B008C; Sun, 17 May 2026 11:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3AEA6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 11:39:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9419A1C04B3
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:51 +0000 (UTC)
X-FDA: 84777322182.25.EC279C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 85A29140008
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6ohR27T;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779032389;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BAvyUkclJ2E2YYaXUqh/Rv2Ypq8VHTSz6APZSeurrOE=;
	b=a+sWtbWIIxfO7LFkZa+Iab9mP3tNKbZo7T3RLgyp5NXwFA8OoVmuJAT6UZyTAfTxqRCqtj
	8Aa7E8unJ3n+q4gdk7znUzNug2RQ0J1MCDyORAQi+iFbx7/RGny6vj83rfyBl0odYmnlMW
	QLKkF3BBiznikwQKhs90kHJV/HJATbU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6ohR27T;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779032389; a=rsa-sha256;
	cv=none;
	b=GgolWt5NoOyOg10Dt8GnKE5buEesC9xzIyCfMFKjAvvNmKfILELYzI/hojbq9/iQ9F1+g9
	OhrqcJBtD0IGmthj8c2ajVcsNzu04CYWvZLzAyix4k8JLV+EJOc8JbIx9/4kPdIoOVNozd
	PhdQAL6rT4orMt84KjnEhW8mxOpFOOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E534C601E9;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93DE5C2BCB0;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779032388;
	bh=HOQoFVcJQQw1qsYaDyBIUm7Bruv614kawN5bFHpz2ig=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=S6ohR27T8HnO+q3YluMoTXeCRRAXwNBv6bdk9J9Q0jjXKO6OqJCsRZVq5ylRjyjth
	 ZwUDU7zH8B3OVNrgs3QpKp1/zSCLGpTCVZqtgDhTvgG5UaF4QxBgz8+v7Ia6p/UtI4
	 sHCgmG5u+KSEXtLIavttryH0Rw2YGeIMeH/U2RsTwtL/XxnHBXqMvDHCJymQ1X7Mc0
	 qSU8kEbPWxzPmi4ZB+rpwH6DzttQ5o9oxhG2foYpPlSe7jZHgEW+bzr0dk+Aps5noI
	 t3LwAAb21RIQtWzZSD+x9hjn1/VMyQCOgQfVAX6rWMjiQ1SNbo0/J4vLl0HBVZK7y8
	 AQk/uinpOI5BQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80157CD4F3D;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v5 00/12] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
Date: Sun, 17 May 2026 23:39:39 +0800
Message-Id: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XPQW7CMBCF4asgr3HlmYyxzYp7VCwcZ1IslSSKI
 xcU5e44dEEblm+k75dmFonHyEkcd7MYOccU+64Mvd+JcPHdF8vYlC1Q4UEBgEw/fpCTr79ZDiS
 dZXZYe28CiWKGkdt4e/Y+z2VfYpr68f7MZ1ivvyVEtSllkEqCIuN0A86CPk3cBe6mj9BfxdrK+
 PIEZutx9aYtWoEmtO+++uNx+0muiscWK6OdN4c6vHt6eQ1666n4FmpybEl72/z3y7I8ALAFmGh
 sAQAA
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
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779032385; l=6878;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Yo/KeeDl/gBTDmA1BNP9TneN6E9dK8IEKyHla6LQWNw=;
 b=RUeY0aaNeQw+Ef/5Ftnfxmbj/rQuTIh5cfUj05zmQudQoO9TE71PdgxpMvvbsLihRHuuvX+xt
 eXTACL0NKG+AFDGhLBu0CWijwe1Fi20WChs0VLjKEhiVboGyYPancUe
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: pboybi4cr84ibgtm9d6g47ed9dpog1ok
X-Rspamd-Queue-Id: 85A29140008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779032389-563945
X-HE-Meta: U2FsdGVkX1881vq5cL+sFEPxg+ARWJD6Jq0iUOUFiPjDMS6v8PGnV7CZDEAlOSoMMxLMjaJINYOUW0/UsLx4YvD7Q7fhQKyVorLu0l8lK8RkPBvtOekQUtzSJ+tos5OtDn0fo40hVd8eNHyrPCh5JivbWd1iVXG679P/h5htf8YSjiwHyyTsO7ws/6CINGZ4rGTtkJtZAArDk+d+jOKF1MNcZrfK+pyIJv5EA08HSSav0v6ZAksGDt4VPoJc5AopcuqpV1ksNqkzihA0RkDrNrLBFkkoxJCFKDhfdENE38qkrxmJAaVf/eeQRumt9HL9f28j5dLGjTuUIW6nsZ66xBbmSklhiVY457iuwe4I2VHXUKjRUhh+wxvU9xe3Zgzine7HigMlsPtYUzMAIp3+15O3D4xERNQU7Qa0wWf5NetaDswtNmBierRYQgShBZMonXClupzfzWKRg5nNJFCTNEwTa+CxGl7Jst3Uy6fvUmgFV44ffDkPYfiGd7ZWz4KyPI9Ll4IxskPKR4SWCRRV7/2GL2FI5Y1eThmQnZ23RJJOLsxNTQP00ezSDQApK+IOY+TjzEy+fwx27k2yh8Uirdh9avuuglRyviKNLsYbDF8ACUseW1VnF6KD3LR+Pqghr67U4wD0FW8JlJQJZTCB60R6T81L8Dj4j44PQeLgEm+FpO0BXJxVJ6J7oxJ0a8V3RuYp+bl4BLpimqdeIny9sEjvEK6tOieitNAlzJI6MKlGrHKDv5PwWo+BF8LfnEPxuJ0nCkbFkU2EqFt48TlF08wH83ICy5u669fbptR7w8BGetc4mdf7ozW/ZH3v+H6WZ4H+wD5KOzsi7MGEUlw/gsWZ/BcbelIr/rGemiO0vZ+W40Y7NL3vXroLQcTWL4rBBn/jHHD54WQ2zsA5LklG2S1lyrc0B5qoE6IisQ1yigxiU8ZLJqHpFrTlfX8q0GRnLvFXaEiz9BPs9EWEmu2
 YOHH+8hv
 pyUajp1TNlERvs95+K9GTIylF+Fmqh6YXtzjacSbOn1B+vBHQy8aO2KOgqnR8R4mPG4LyCTrLQDEstnQ4eN7rJFRUuPWGDjBSS67B4rJq+MWAs8qzBMKd7iJnOcrIspjm06aGY+zPeZE49d7+7jgX7cioXmByyU/GNfz154KnXsjd5x7qFNqsKOoRLmuTwalczVSWeqjiew0uY6UwkWhPFmW3sxkyO0BTcypq7oFg5MwmKm0wLmAb7auV1kGqvs98h5/wjkQ4w2TxYPz4nG7k5RIxOdazUfRTFxBrr/DOXSU66YHtYR36q62yHG6SnA3qxf1Vty7F75hiM1p0XLwdTtGdI8i9STaxXlqNLcWvme3WZAEzNTwv0mqi7XJ/Z3GJxA9sjU5lIGhzMOMtrS71q/F6qkTYykWVSaykRQjqx0tYsvvVWS6YAS7PAph4vc6pzvGCdDH+IcT38hc/g1b9IlbedUH527FZM8sYvtDOEwrJ1JfGTkJwORcq4g==
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
Changes in v5:
- Fix error with !CONFIG_TRANSPARENT_HUGEPAGE:
  https://lore.kernel.org/linux-mm/agcdxIFQ8QBI9R6z@KASONG-MC4/
  The actual fix applied is different since the posted one forgot to
  check `orders` as loop breaking condition.
- Improve mem policy interleave in patch 5:
  https://lore.kernel.org/linux-mm/CAMgjq7AqKskE5UVivTEdPzmTa09_aapWZM7JeSshhmf-4GYbZw@mail.gmail.com/
- Retest is still looking good.
- Link to v4: https://patch.msgid.link/20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com

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
 mm/memory.c                 |  91 ++------
 mm/page_io.c                |  61 +++++-
 mm/shmem.c                  | 130 +++--------
 mm/swap.h                   |  91 +++-----
 mm/swap_cgroup.c            | 174 ---------------
 mm/swap_state.c             | 523 +++++++++++++++++++++++++-------------------
 mm/swap_table.h             | 179 ++++++++++++---
 mm/swapfile.c               | 215 +++++++++---------
 mm/vmscan.c                 |   2 +-
 mm/zswap.c                  |  25 +--
 20 files changed, 814 insertions(+), 903 deletions(-)
---
base-commit: 444fc9435e57157fcf30fc99aee44997f3458641
change-id: 20260111-swap-table-p4-98ee92baa7c4

Best regards,
--  
Kairui Song <kasong@tencent.com>



