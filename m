Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F43F8D755
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0288D6B00A3; Thu, 16 Apr 2026 14:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BC86B00A7; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3AFE6B00A1; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 557E86B00A3
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81E50160593
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:46 +0000 (UTC)
X-FDA: 84665270172.17.5BF093C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 632748000E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NbroIOnr;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364484;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YbeOxpUCApGagwfocBCd4LJ7O7Cz527/dHavNUbND/M=;
	b=XLd7Q19Ys/JqubtjoKTSYsCSIII08NsDUndWbemK0xTh2hRoF4zUrZrWu+1Dh3dkVnJ/NY
	cNSpdBIrCGw71AI9zJkbGuZF3FBbBbh9ahRNfHKhYWfQloesWCyFHBRqNQk7qa/fdfONZr
	uLjBHAkY2FieLmEpX+O7w8NQC2Hr+lY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364484; a=rsa-sha256;
	cv=none;
	b=PXHmd1UaBUxm+r7EYqjrw/PWYMGJJUKZy01al6Ge1qOZ2PHyAIct7AZhK1cM4w7REOWn4Y
	66XpTxZYMWGSzXCzuP3CRVlSQC+pZdIQFwKuZwokjAjrBiFGr8lG17djt4gIj/TXhtawEE
	MhVwI7ssHbfoTFcBue3CQ0ZDcjSzSp0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NbroIOnr;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27C9A44474;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEB22C2BCAF;
	Thu, 16 Apr 2026 18:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364483;
	bh=BXHKITIYR9dCL2Vx1b1VPQ93m5+HvBPWS+sjmunJ/Dc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=NbroIOnrLU5kas0PZdzFYUMIs1J5gD74b13aTHTKfge8ly4Wuha6A+6t92vgNWl6A
	 oW15AUdhyOSfaJYv0o2W4kzOqRPZo0K94/jgBICHXznnVd4fpvN5rP1icFf49z2Mol
	 Yu+ddV5wU11U+F07Osuh7smb/S4KTM1AEvrpAlQVnsYWBTRvnROhOFgek02wzgq+Ba
	 tTHGTQiOzLi2l7kx6rzaq+35un27XKwJVXz1uUKmC8deJJsRddK5UUTfjyrVqDo4jw
	 xxepa8qugG55fnjZ+EWZUS8oQ0N/imO5LhUeqhXj3nevLwabRWbOpOh8x6+hX21T9t
	 hyNUz4P1DI5KQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58FBF8D755;
	Thu, 16 Apr 2026 18:34:42 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v2 00/11] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
Date: Fri, 17 Apr 2026 02:34:30 +0800
Message-Id: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13MQQ6CMBCF4auQWTum04BQV9zDsChllCZamrapG
 sLdrbhz+b/kfStEDpYjnKsVAmcb7eJKyEMFZtbuxmin0iCFPAkiwvjUHpMe74y+RtUxKzlq3Zo
 ayscHvtrX7l2G0rONaQnvnc/0XX+SlOJPyoQCSdStaiZSHTV9YmfYpaNZHjBs2/YBk6KawqwAA
 AA=
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
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776364480; l=5811;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BXHKITIYR9dCL2Vx1b1VPQ93m5+HvBPWS+sjmunJ/Dc=;
 b=IU5E1/nRV4QCH5MXlxelv6ZepS2DIxshXrThYr+GU3vZV76EwpKD55OJiQKsoOeLOme/rvOqv
 AbmPyQcE1FWBc8clLt+w8aonn2iblhYd0HhfMKtPKy7o2K78lRxcY2M
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 632748000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 9kyq3x88mmgpjcgbgeerm7g6fpahh3s9
X-Rspam-User: 
X-HE-Tag: 1776364484-423738
X-HE-Meta: U2FsdGVkX18vTtvgy8mhdp61UpzBrqq+w4fzjjKd1jGlKsMDPYO3DHX2G0o8jtO4W5FB983hnwTnlWJT7RhJ7h+6qZ2akX53bGwoAWeFlMW71G6X+2yyMufvK2BkILzYYOTaso8hbP+18poJnxq/T84mvkS5v/du2JnXqe2jtHw6qkERq4bQRgtnfUwlfEzmYHNmzKJcn8XQYcZ6cr6KuDKcbSMI0kbHcixPoT3G1IEIMS+KXk5Eln9UbVPEQKOmgtO0WxFa/9U8qTnAej1PRrfrdg2G84puVoXsrbvp3iGefELQcy/EZ1yjpfGVFmQ662F7MVcjJVd7wn3CqKPUFoa2VOMQ8aEYJf572vUZg879BtimMLCmsJyNyn3WlqnZslJ9ZFbqAGKehhTFpicBSQ8nCFc0uP2A5+Z2p3LyD+9lRrfhCWnpSupYH/gDklqYrwtDInRQrW48GKOCX7jvCIVrbCLUKGVphyrEZRNa5EEMg32VSWAXe7hlBEFJbiC+Cl4B4wCL9mEMxM4WT1cku6ge/S4+eavQnJkvFFBfd8WBc3VvuLoKoiCjT1M9F3ICbOESy3Vlxev9HIHS6TcBpET/pYZLuM2Lb88+GAsFxRf814+m5aWCGyZ72mt+haSNYvK8DyoS+xh4i2giHrs69QBnjNeMVaeRlMP8Qj1crH5W2VgUlJ5GdngvswE7PQUi3Ez/a1L2pujfBKeoLcb6IZQjbHvpa/tdsJWDEEXuX/ilvlgJVHmMykmP1L+86C2K+tGHMrssaKx9+1NMwnZBKsudaRllQU8pkwMVyql9SMW+hLiVwfTOBg8u86zIiFqVnBt6aZS2HY4tkXFXQBMDm8i152UHgQnNib6lcaUTylRkM2M35wd0Yrp9DOxkx+HAqLDTRLl7+apfKjDqU0iX1mhObE5dp1+wzKOlZS1kSkPVOrTqCvUlSgBrqb8ACaOaA0+VLHdgX/ERjvt0d7R
 Hhab3QJs
 ITM+x8VpUDXs4EPI54fk+VkegYWkEoYGYz75qeuGUoKVIqj3NS9tdpQICHc4/RNFtQULSAjiOhmiTW5u/0h6cXbbFB6I6kASOSi7zndWNo535LeeuaQh5/H7ngQmU+49vtxtCL65ApV+VzdVLMQgsMYOPOU+YBaNLikQJIFXNhTgAyT8thpz/z3VAFrAkCpP6c/XNHfaXu9y8d+JwhuCf06MS0kNlinv9gxEUrNL/beqoSuqGxtwXAslcAdJAC+OTfjKh5XHNoMcEQejbDrzoj8MCq36h7PusfPt9tbb8fy04Nc4zSuhfrLGefbIYbNeyIRaVp0zMHMVbu+natCroEHzWJCS9DQWUSogWku/sZBXRGF03Ue3m7YpsHvnn9F7oUAMwbkCawjzc99oM/DWXZD8UIKP3mtk9DW2f9l0abCzE5XZ548SE6LXQpbjzwNPyNCNCM7iqHri8b+HNWU4TfpfmypHtkK6tcGw8ZGf522BPP7ZEIpDzDg8ggtrn73XP7m4pY/cWFDBh4sAqGVaT2TJjpE1ybrGEKudEVoZKExCZ5wPpiogeipM6zL2Ka7M0+UFNPOzRQ1mEm4sAd5KOhN7Fp6fysXErjU8FcYM8wcXRnZAvFijVEkHpx5LDWPQPq9q1Oz6MgombRlBfuzI9vXgIXY4eKr0FfsM/pVL0MgK87YwAXPfVb3Nhh8/TVM/f3V68uV0K8Nv7yk+KFrWDtngtVn8LPxm/Y25bQs4o9YG/FyHDY0u7cgL2yU7/sndoezEtewzhMp38+isN4EyaN/jaFkpaXhOi3YfKjP6UhUzDGXWukJwx1otCAoNEt3IWoEivGW/tCrBmtusciZ0J0Yuewi81Ca9k5za6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series unifies the allocation and charging of anon and shmem swap
in folios, provides better synchronization, consolidates the metadata
management, hence dropping the static cgroup array, and improves the
performance. The static metadata overhead is now close to zero, and
workload performance is slightly improved.

The swap cgroup static array is gone, eliminating most static swap data.
For example, for mounting a 1TB swap device, this saves about 512MB of
memory:

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

Memory usage is ~512M lower, and we now have a close to 0 static overhead. It was about 2 bytes per slot before, now roughly 0.09375 bytes per slot (48 bytes ci info per cluster, which is 512 slots).

Performance test is also looking good, testing Redis in a 1.5G VM using
5G ZRAM as swap:

valkey-server --maxmemory 2560M
redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

Before: 3048028.953125 RPS
After:  3068843.321429 RPS (0.68% better)

Testing with build kernel under global pressure on a 48c96t system,
limiting the total memory to 8G, using 12G ZRAM, 24 test runs,
enabling THP:

make -j96, using defconfig

Before: user time 2904.59s system time 4773.99s
After:  user time 2909.38s system time 4641.55s (2.77% better)

Testing with usemem on a 32c machine using 48G ramdisk and 16G RAM, 6
test run:

usemem --init-time -O -y -x -n 48 1G

Before: Throughput (Sum): 6011.33 MB/s Free Latency: 401097.13us
After:  Throughput (Sum): 6078.67 MB/s Free Latency: 390860.36us

Seems similar, or slightly better.

This series also reduces memory thrashing, I no longer see any:
"Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF", it was
shown several times during stress testing before this series when under
great pressure.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
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
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org

---
Kairui Song (11):
      mm, swap: simplify swap cache allocation helper
      mm, swap: move common swap cache operations into standalone helpers
      mm/huge_memory: move THP gfp limit helper into header
      mm, swap: add support for stable large allocation in swap cache directly
      mm, swap: unify large folio allocation
      mm/memcg, swap: tidy up cgroup v1 memsw swap helpers
      mm, swap: support flexible batch freeing of slots in different memcg
      mm/swap: delay and unify memcg lookup and charging for swapin
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
 mm/internal.h               |   5 -
 mm/memcontrol-v1.c          |  66 ++++--
 mm/memcontrol.c             |  32 +--
 mm/memory.c                 |  88 ++------
 mm/page_io.c                |  58 ++++-
 mm/shmem.c                  | 122 +++--------
 mm/swap.h                   |  72 ++----
 mm/swap_cgroup.c            | 172 ---------------
 mm/swap_state.c             | 519 +++++++++++++++++++++++++-------------------
 mm/swap_table.h             | 134 ++++++++++--
 mm/swapfile.c               | 121 +++++++----
 mm/vmscan.c                 |   2 +-
 mm/zswap.c                  |  25 +--
 20 files changed, 709 insertions(+), 825 deletions(-)
---
base-commit: db2a1695b2b6feb071b47b72e61d0359bf1524bf
change-id: 20260111-swap-table-p4-98ee92baa7c4

Best regards,
--  
Kairui Song <kasong@tencent.com>



