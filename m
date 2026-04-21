Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF8EBF327A8
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094D56B008A; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0403B6B008C; Tue, 21 Apr 2026 02:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4AE6B008C; Tue, 21 Apr 2026 02:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5F156B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:16:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64021BD4D7
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:57 +0000 (UTC)
X-FDA: 84681554874.18.C80E6C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6B6F98000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dbkAATn6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HIHttzqpwXXrJ3axlhOjix5Kc4HAVBCm20qxQWqya0w=;
	b=PQBYuvPMXpyWslZllLF1nSwd60UPnUXmu/uYBKAO2G3zAZSNE7PrCg6VXu43E5kPBXrgAB
	r8+inzquNDtBqmUE+UsyTHYnBwZwJq/76eIK+Ty0nJggeUHMsSEbJofSucLa59KW2DHJjr
	dTBZfKLywvgX34riHqStjBgaMTBrs3g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dbkAATn6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752215; a=rsa-sha256;
	cv=none;
	b=u2+szCcaLicybbJ7PVFUm7m+XMMhj6gOsuA5cL84l9teWqKKYX0257ZA5TP/SSlQDPl86c
	O8lbbQhyukCfESPohjJnBINW0cVtaq/+7+2OK1jfDomPzEWZ725hQq6QYOrJcw+4wDveAu
	7bF+ei5dOG3aj+pqywe6rfdTgqFPoiU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E1796011F;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12308C2BCB7;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752214;
	bh=Jq+2g/EuZYELu4Xod9IzqQhR1K4oK3YcKoIfx89cJqE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=dbkAATn61No2nYD6A7RFXIcnyVNiQtl2Wcmvr4u2Sl/qSIsbxV8CPZ+AtFQzvwmvc
	 6DFIOfQKv9YStNWkSmE8jOjiG4mf7jwSgkhVBJUPFDaa5jqYCBL5OGLEDslhU7W0l+
	 loavAPJIS8X1oSnCDk9WKgx2TNME/Je0K49miIvkdjCIT+4J6n2eJz8brv9gqUBC/K
	 6NcGgIdxD5jDkahTB2LFYQ2tITOT4pWB3y5IBOJ+w5yfHeu+QkQ2s9MzlCzFHNzNEw
	 DEFPaAuTLqlOsAEmjMK80/Gasf1OSbM4zFduZyjfaX6Gr2gLed3cEKqV1Fyswj7RqQ
	 cTAQewPbubFEw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AF6F327A8;
	Tue, 21 Apr 2026 06:16:53 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v3 00/12] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
Date: Tue, 21 Apr 2026 14:16:44 +0800
Message-Id: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13MQQ6CMBCF4auQrq3pjMVSV97DuChlkCZaSEuqh
 nB3Cy6MLN9Lvn9ikYKjyE7FxAIlF13v8zjsCmY742/EXZM3Q4FHAQA8Ps3AR1PfiQ+S64pIY22
 MspJlMwRq3WvtXa55dy6OfXiv+QTL+y0hik0pARcchFS6bEBXUJ5H8pb8uLf9gy2thD8vQW09L
 l61WQsoJVb/fp7nDzBl7KzsAAAA
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
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776752211; l=6664;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Jq+2g/EuZYELu4Xod9IzqQhR1K4oK3YcKoIfx89cJqE=;
 b=FyXzgmWAt9uW4Er33MihGGiukxDaxaaory1YWdx32QGCDV4K61FifWvn5q/a+E8K3CgvWRXDe
 a11dpN5OL8BCSceugbN/s3X8w7x6o68iIfAxhVUVNCADC6aTjSGa+HE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B6F98000B
X-Stat-Signature: f53b4ctkjo7fdy33ue56hkhhzkkxbqn9
X-HE-Tag: 1776752215-981486
X-HE-Meta: U2FsdGVkX1+zMR6+CsC1iuF1NSdSfeqPUd0Br6OmZfNbgwzyajvByCoSi6DoWnE2rBPLPaSQrs3Im2T3ZT8554B1m5w22fcVf4mPXiaYThiiGK4jBdGiHm248McUp4HBRB+5Uuv9bybZ3nG+OHLvWRw5MaZhipPBBmN0uD6zkK6h8b7zKkPmiifu6/KNH1MWQ3VGM/Dd6knKYpPUBaOIQ9/fvPncSS5nCUzabKQBefkHi2gXOPYBvr2Xg+7hYM/QXYzce47Dma0ipzF6bgZQTGj8wRI86g+Vg+IxA3cmlew3YxXu+4Blm6vy5vbdmWtKqGyuny41L6grPR0POZuQymrOZ6KrdhGFodyO7bnz/s+89yQFAFlTkbEFeQvA6t87HEJoH5pXW8KSfnNiR4zcA2V9nXUgAZSaA4nqdDqejmW6EnsUlqy7s3VrjfD+JMU6mYzI2PM9My2BdV110wojjuA/SZc1elKQL/ibTRGOfmrOegNfH5eTE6kHjN5Msmb/xE+soaFbrfHyEzz9qD3FVgTM27FJSJC47pX/LotTO81TnaTkiXBqea8zUPm1UHnu5HDB42j8IWzXcwrNkA9V8b2J52GtSbzMxzk0PVcQsMG5fTyaLHIVVBw96uGx9kc71I/1bma2jLX2jhAMqilXhvR/Cldpeg1/vCRze6/weRRLoOV5tQBlyrBFuy+qWFspfWRvGGm2QQ/+SBHm/E1KQXkkkCOmSgLhYTiPGVf7ihbBn1wlfciRLsGUL3XNzQKZe7QTuecfJ7YaFHeQwmpA9syYYRE4F+1E54oiujUPPvgeVX4yp5PW0lw5NKs64r9b6Nae/9+Sok7Bqi67Xvci/W5+F3+i0+WB8RWdqwS+Y9Wv1Wk2C1EleXCfI4VWpiTT/1Jq1+grbEBYpOpU3gKHiEpb3V3RyoG2vA64H23zrSa4Y/y4M4Cy+ZFYm71OgXUafs6n7HydqCJ9PyOZWtz
 GIojUT/R
 460dryfjKGhCiwaLq2BQaIlbyqyG1IW2C/8SSsMqRARtFDfZ00NB6kVC0Q8BbxLYWCbVP+1zdytZSxt+1OibK3/NzfrFvd9WYQHovYextFXemExzhuaX/i5/YPOIbS5pspqXl21uJ07WJr2bZqhbVCLY+wa12fHEu7hiEeZg0nHj34GVKMMrr076L3J33FgEQPodRGjSs2dx8r4Ib2GcWSf8Jin8Zti8t8dXM+JmnzNv5Gzkf0/QQwI3amia+77oZGzWyXWgGDpwWhRjeqLUX9DSGlTL4lZUGaSC9LSF9KEUyqCQiy72whTkM6fSNMLSxYVsd5Rsu/bT7tCdUq5OCipV7wQ8IvcA8LS5N6WUt5FbQzKGblNiXRkg3/DtVOz28Bz0lKwFtmoFmJwOfd0NclVfYwA4y2wZ0haD7LWG0SQF2z/C6G9q8b9qr7TBYqepqEZPubZDEiumiV52ZENqOQ+1TO1iKIOOLTOvIP9jvWGNXF1qUVFgKDfaWsOQx2udrg3KsgLTXhz0Lhvd3yrHG71Bzu5RBSVr6LlKAbOIONt1gn6w0Dd6EBU2MTA9Qppzfq93crgQ56awIXzYdNxeLuabGILLqUqpbOPRN5eDjVm3Whn3NpNuMJ3o84GNVYQLRB0/i6YXfRpGI6zWIIYSM4/O0wBiKwTwx/2Jd1gzqEerdMCTXs1D6hoWjOxnLv9/3h3Azjb/HL8yX/tQZzRoXdAI/XQ/5ZiZFBFAmsTb7YwfVxgLsqcE79HROfmjpbSOEdtb1b874uYBIhbpJAXpAbpe9sWWIkriUt19e0QHFTup7fr0aQBXobI0j4p6A/bmOWxTumf2Gb6/2aGQcaVLdPdc7y7Iv+HL3CfnUhQ4Apgptz0uexmu+k6/eUxRX5XGsNOU8iDjOVIpAW9jnKLcO1pBPBh+QIcAecx0ql4hTtcdIluz/rNZjWbL4dV4jmawsaPx1jgfNjJIJmGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Performance test is also looking good, testing Redis in a 1.5G VM using
5G ZRAM as swap:

valkey-server --maxmemory 2560M
redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

Before: 3289011.918750 RPS
After:  3312087.142241 RPS (0.99% better)

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

To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org

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
 mm/memcontrol-v1.c          |  66 +++---
 mm/memcontrol.c             |  32 +--
 mm/memory.c                 |  88 ++------
 mm/page_io.c                |  58 ++++-
 mm/shmem.c                  | 122 +++--------
 mm/swap.h                   |  91 +++-----
 mm/swap_cgroup.c            | 172 ---------------
 mm/swap_state.c             | 516 +++++++++++++++++++++++++-------------------
 mm/swap_table.h             | 169 ++++++++++++---
 mm/swapfile.c               | 212 +++++++++---------
 mm/vmscan.c                 |   2 +-
 mm/zswap.c                  |  25 +--
 20 files changed, 783 insertions(+), 899 deletions(-)
---
base-commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
change-id: 20260111-swap-table-p4-98ee92baa7c4

Best regards,
--  
Kairui Song <kasong@tencent.com>



