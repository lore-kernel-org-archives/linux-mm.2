Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A72C61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623A96B008C; Tue, 25 Aug 2026 13:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D57B6B0092; Tue, 25 Aug 2026 13:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3A26B0098; Tue, 25 Aug 2026 13:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2E56B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:26:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72B92140167
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:26:17 +0000 (UTC)
X-FDA: 85140470394.26.248418A
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B60AC000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:26:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787678775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=JzXDU2WESyUnYeHctLcZhtyLLJ0sEX+hQISyl2j5Oh8=;
	b=WK1v4mwTmtW9/rRLORMbVn2Dycnqp4xvltxaohs6oNwNjZxdxDztGbfXPkPw6bPFwsROzx
	n2nmD8en0VwR8KDwjV395nhzqMoqaEy1Cb1Mxs2z9LYidSX16YwcHBxzzynPDz+Kzm0byU
	61canM4NUQrf9wltpiS58MJExWqNr/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787678775;
	b=2IKUXvatoew0jyx1WgzrCdbxtlfn6QDXUlPjPFZRyoE/fey/K5bVv6CzMgjRG9LprBmuzP
	Yml1h0tODQMqEjZdxGz+UjoRvyqHg85Uo4Kktg8reFGyH3k/sQoDjFxcgnBf93/2Tk/iwG
	qikyUIA9Xp6yt/xJcFJ9EZfHU2LJgu4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id EE7C83EE35;
	Tue, 25 Aug 2026 17:26:07 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v3 0/3] mm: fix workingset refaults in the zswap writeback path
Date: Tue, 25 Aug 2026 19:24:50 +0200
Message-ID: <20260825172604.3243589-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGNmuBQoKzc+tMcv207fxPssplBQ5KNWEV7l8sZcw1AWQhmIx/kQ+SEFcsr9A8LRrx+QKYms+cgk3bVvPBWHgWWbMIN1lRRWhbPMamx5dkhWyeFKzLcLPmIubeDn61hwonwfHZZCTEshFJAX/1Ir8orrFB+DIJz2PjzIe0vK+qglUv8ZLFO6Po2kbPg7mSFE5CHzU5uQBLtBFYcpLPScLzHz57E+BcH7fpl1ZLEA+febi56UqPmMPBXkW3Gy1c7uDL7hpL6VY5TsagLnh7Wn0Q8bV/DcZKjdOXV9JT2qkEELatdFwm42o4TLpNNMijiH6DssP9KOiN1jHrSHMK+ItLKU566W3V2PfUnkHoIqeCbqWA9qOQLC4VkE2aeBrkGg59GjfI/0Tprwwwk6xRLJcyk+GA/1+UehvM3IqMqjFhdG90hQANfzW9ORCcC0NUlsUrZeiJXUmYNBI8HkG6rSLFb5CUxAtd32w9r/wPfETtGOc4EiMfiXiDu5FF+EIB4TYccIJZ0uCUbtcgu0iCHzzyKW2CWYtAC7tVGxaNBo445xLcLfiN3SMXs6aJNOh9IfQx0mJkt2yfkVN1Q4q9n3XCLdwUtoTWAbEhHoeSzD4rXLxEZFC9P2xIryH1xtHcAf6gJL69F9+xv+XoPA8xEmcSCXKLPnQHuEnCo+CdEIMImCw
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6B60AC000B
X-Stat-Signature: xrzjey9ywexss8zwcazzp3mkm5ugn149
X-HE-Tag: 1787678775-960289
X-HE-Meta: U2FsdGVkX182UqAmdsZOPubumGuift/qXSA1w5piobaKQ8/cI4BgHRu+Q41R/Uol/m2OxZ5xF/YQNFM9uosQITNkCD3N8IbMHFDz2MNBo3IPkAqx5sTW+1Gp5nUsyn55zii7bhW8PRdr5Vz0PWYX7rdMiDvHKhAfZUHI5FignBzitw3DwFdkQkBzorJb/PPmOnRrXcNzZDshYIdMBD6Eurrxf8SvE7Zq2tYxD6U3BRgfGcf2b63yI+F+b+nk612HIh4ka91q/SHimYpSgSehVpBlBX7vnBWYMTYobmleAuaw8IQLn0W8b+QF78epgWsL+NPhQB5jezNodiSfOiNIVRdBVBLWUJ2sXOiKcwObwv9Xa1LN7cWeBetbxziUTGxXPZh2H7rd+6wBN3If8DArQTAcrqdv46tdRUL8eNjBHTjL1AQeeGYA+5BEv2fdmwFaOXpeAFT0qQfk3DRfDUWo0kwl45+n0+52V1Ft/N+9ZNWhygfJj6mF1sUo1GS35CGDRSRso6/sjkh1coga27IcfSNZKeQ+xyxv5ux8bO+rDzKWjkXq9K48WsQyewIXMQf6uPgky3L62yxYHT1/ag51L/mD9ZmTcPrqcaP0xM/RkjEB3oAW8bu8HNqX/wdQFY2NfGU8k5NxRklK3VpKXF9xSW246mPaE+gt9NEdz5gYhf5/pBj53pIyrINP28NjVHy3FDUEz95UfqpDD4droJptg3R00TkAl8dbklQuwKFHUpeEEAw7ksXu2TJ48/U801ifSE4LbC+lpVVl2IYk9DaaTQTOcs99fH8v36cH/xeOKb9Kox417lj81Kd7njYWmHbB93cbzquLXaoGyIY4jdi3yFrwD/SxfphSsOa1EvnNn1ePcCbWlsjDd6xHT/kmSSqvZDbTlo0Ih0JwNehl7gwJNalkqyWne75BOIq5A7FUtxfYxeubk9HncfEatLq+ISNTWPEXudUa5yTjnjC11dn
 vmPkjyw3
 POqBYfcFnVjPDMYCtEjGwGsyxeMcY9Os0rAQJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note: patch 1 also appears as patch 1 of the zswap dropbehind series [1].
It is the same patch, byte for byte. Both series need it and both are
meant to apply on their own, so it is posted in each; whichever lands
first, the other should drop it.

When an anonymous folio is reclaimed, workingset_eviction() stores a
"shadow" (the eviction cookie) in the swap slot so that a later swap-in
can be recognised as a refault and, if the refault distance is short
enough, the page can be re-activated. This is how anon workingset/refault
detection has worked since commit aae466b0052e ("mm/swap: implement
workingset detection for anonymous LRU").

zswap writeback breaks this in two independent ways:

  - Over-count at writeback: the shrinker allocates a buffer folio in the
    swap cache, and the allocation path counts that folio as a refault.

  - Lost eviction cookie at reclaim: adding the buffer to the swap cache
    overwrites the slot's shadow, so the original cookie is lost; when the
    buffer folio is finally reclaimed a fresh, inaccurate cookie is minted
    in its place.

This series preserves the shadow within zswap itself, without any new
swap-table or swap-slot state. At writeback, instead of erasing the freed
zswap entry, the captured shadow is parked in the zswap tree in its place,
so it outlives the writeback buffer folio.

Finally, the refault evaluation is moved out of the swap-cache allocator
into the swap-in callers, so allocating the writeback buffer is no longer
miscounted as a refault.

Results
-------

Measured with a sysbench OLTP (MariaDB) workload in a memory cgroup sized
so the dataset and InnoDB buffer pool both overcommit it, with the zswap
shrinker on so entries are continuously written back to an NVMe swap
device (classic LRU; MGLRU off). Anon workingset counters over the
measured window, baseline vs this series, mean +/- stddev over 10 runs:

  workingset_refault_anon    383,242 +/- 59,345  ->  199,355 +/- 27,042   -48%
  workingset_activate_anon    54,890 +/- 11,742  ->   22,607 +/-  3,118   -59%
  workingset_restore_anon     16,212 +/-  4,590  ->    7,599 +/-  1,190   -53%

Writeback volume is comparable (zswpwb 183k +/- 16k -> 178k +/- 15k), so
the reduction is not from doing less work. Normalised per transaction the
reduction holds (-53%/-49%/-39%) while the swap work per transaction is
unchanged. A kernel build under the same pressure moves all three
counters in the same direction.

The run-to-run variance of these counters drops as well.

Throughput is unaffected: over the same 10 runs, transactions/s is
18.50 +/- 1.08 -> 18.65 +/- 0.94, i.e. +0.8% with a 95% confidence
interval of +/- 7.7%.

Changes in v3:
- David pointed out that the boolean added to workingset_refault() in v2
  makes the calling code hard to read. The boolean is now internal to
  mm/workingset.c and the callers use workingset_refault() or
  workingset_refault_lru_managed(), the same way remove_mapping() and
  remove_mapping_reclaim() do. The three existing callers are left
  untouched.
- zswap_writeback_entry() now restores the shadow into the slot on the
  error paths taken after the buffer was allocated: the allocation had
  already overwritten it and nothing was parked yet, so it was lost.
- Dropped the "if (!shadow) shadow = ZSWAP_WRITEBACK_NO_SHADOW" fallback,
  which can never be taken: the swap table already marks a swapped out
  slot with xa_mk_value(0), so swap_cache_get_shadow() never returns NULL
  for one.
- Rebased on mm-new.

Changes in v2:
- Sashiko pointed out that v1 evaluated the refault after folio_add_lru(),
  which picks the MGLRU generation before PG_workingset is set. Patch 1
  now moves the LRU insertion out of the swap cache allocator so the
  refault is evaluated before it, as it was originally.
- Sashiko also pointed out that a failed writeback redirties the buffer
  and leaves it in the swap cache with its shadow still parked, so a
  later zswap_store() on it would hand the parked value to
  zswap_entry_free(). zswap_store() now bails out for such a folio:
  writeback already decided that data belongs on disk, so it is written
  there instead of being compressed again, which also keeps the parked
  shadow intact until the folio leaves the swap cache.
- The buffer folio a swap-in consumes is already on the LRU, so the
  refault there cannot activate it by setting PG_active: that leaves the
  flag disagreeing with the list the folio is on, which shows up as an
  mm/memcontrol.c lru_size underflow when it is freed. Such a folio is now
  activated with folio_activate() instead. One still sitting in a per-CPU
  batch cannot be moved safely and just misses the activation; a counter
  on that path measured 0.0007% of the activations over a 10 run test.
  This is only needed because zswap writeback still puts its buffer on the
  LRU: once it stops doing so, workingset_refault_lru_managed() has no
  caller left and can go away.

[1] https://lore.kernel.org/linux-mm/20260818163221.589352-2-alex@ghiti.fr/

v1: https://lore.kernel.org/all/20260817144622.137133-1-alex@ghiti.fr/
v2: https://lore.kernel.org/linux-mm/20260821093606.2231216-1-alex@ghiti.fr/

Alexandre Ghiti (3):
  mm/swap: move LRU insertion out of the swap cache allocator
  mm/swap: refault on swap-in, not in the swap cache allocator
  mm/zswap: preserve the workingset shadow across writeback

 include/linux/zswap.h |  12 +++++
 mm/internal.h         |   1 +
 mm/memory.c           |   5 ++
 mm/shmem.c            |   5 ++
 mm/swap.h             |   6 +--
 mm/swap_state.c       |  50 +++++++++++++++----
 mm/vmscan.c           |   4 +-
 mm/workingset.c       |  60 ++++++++++++++++++-----
 mm/zswap.c            | 110 ++++++++++++++++++++++++++++++++++++++++--
 9 files changed, 224 insertions(+), 29 deletions(-)


base-commit: 1a46b1e97bde62afa7d925bb0dcd9f9748a1d7c3
-- 
2.53.0-Meta


