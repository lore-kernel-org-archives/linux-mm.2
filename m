Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806E2C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE3A6B018D; Tue, 18 Aug 2026 12:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4146B018F; Tue, 18 Aug 2026 12:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9746B0190; Tue, 18 Aug 2026 12:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3717F6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:32:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2E9F1601CE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:32:34 +0000 (UTC)
X-FDA: 85114933428.29.7A32CDC
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id B69AA1C0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:32:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787070753;
	b=B8l4GqaJx1aSM5+4ok07/+pIhjnkRII9s2KZijxS3YLguRRQrRsvMQPP8k4dtFx8wLF3vR
	zAc/mgvDY3f2LrgyXNELiykqD8IxTZfUwvTzZzJwBzVI98RHUK9HBgkeyoa94psEzq5vhL
	A3Q/8nDcVDm65w6b8cGLcIyQWCH6n5I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787070753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=EczRO5bnb+qY15LotuB8c9XcHEkME/C0squIKntfGaE=;
	b=ioHU2ZE1dusS1AhndZjnreqvscndz9hck1dQWa3+SHcuqhsTdg1Poo16M+OnKF8+4csbGG
	r+VrxzyUkElgb92W200RYcY4xCM1+seRyDAE0DsVs7NmCBI3nrYillqYwn7PB4aWPJM9ZT
	gLrdu+ERlRC3LzIjEgPZdD0+HFH9aKk=
Received: by mail.gandi.net (Postfix) with ESMTPSA id A7D0C3ED2E;
	Tue, 18 Aug 2026 16:32:23 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v3 0/3] mm: zswap: free cold writeback folios promptly
Date: Tue, 18 Aug 2026 18:31:57 +0200
Message-ID: <20260818163221.589352-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTF0zHwxzkqwjqESq93DUZrcku6xmZ9i5erTJyfeW1Ps3DGwBVGZSS+PRrjeXNOX2yNc23q+fgWKHvWls9h0J5706lLKcaKeOBdi0oPZF5veo1OE9sjvNV4RB20IHGbZQamM12I7LFpcta/AD4/MgK78VQP1Jl97zoFQnuoMBLv2tWOX3DSVGDDOhIxebNvOxj7PczBVXtp3llkhlhBlUSemVt1cxuS4l1wUzeesT6iKk4xq+EYvpP1/C7ghNJgBTJQxnjdbKJBpPOfeyXep9NEsfnGVMjN9wdWvHhdKDxkdcM4MI9SpvADlViGRPKVJjfYEOwR82tso4okNjz9SBq2YcDVCqRqamnQ4jSxeI3FamUafeoNgAVUf2OeddQYH23+vCsDs1+l+mE/eaHP+2uA3GcsYPbCSRUFhwCm53GReII7obV3DUUNe+mY9qiyALGMzNcUBGVBDtKREUlQWP3G+9AS9SCaEYrgeq0fD6jNkmfv/8/ZyASb3uQQxKoNXJ9mX+5G5atSZGjHyaMjA86PclsAJSnfoeZWOBScwS87awt2h9iibP9Hki4VCkc8BMtji+ZzF9VqxqAGhpQ3qOhCHFSeE2BXKws08Nf3BWnVdwLaBTAaBWnn2NQsybcZTTKAcrXsryUi2cBQorer7SpRMgiDtmLBBLq4ECDLeTvr8Kg
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Queue-Id: B69AA1C0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: pxbqexcobgwii4icxgspaz5qxhhi5mfg
X-HE-Tag: 1787070752-759883
X-HE-Meta: U2FsdGVkX1+Qb+EvNZLPe6pi1o0YELi8yy+XyGUhQT2fmXCWFa/SfIEPidMfOiinCn9qHt7xskpgQdTXj32OquNEKBk9f5Fqr4/SolnJKoaqJUCk5pSTuOhS57P2CjxiP47vw6F06IAzZXnPB/eNbDp0Ab5R03ioCM9jPvbWTxQfEUJVaftnG9Ss5yT3515BH9fIVHol2b1DEf5ge4Qw36kGZCKqW38px2z364wxtiTEjycEODo/2CZPgImR/02WDoZJH52kc4WagZXfU9/3nvZMGrjnZ2SCwOillQcbaKJGOmMSjNLOlffE0ZfYnnESYXuw41ZVgEGTcK6AdIEqSYoXWqx9DhU+Hpi+XhCrf8a8FPMvj3HeSVhhS3eak8X80UUK+2u0bi9curEcP0im1y3KbnRPMLs8u2bDqGBiHav381Wiw6GIKHGt0k5G0GK+YCAzAKweNEYJmkGq6jDGV9X8vAuZLLyGJf5UpiGPpqlytVwTRTg3Ferc9TDKHivNvrm28O+uaIjWzn2UcJjoT3rHzCG24Foj7jsC2WyOy/BD3TYze7c7c8KYKYu97jTF+2fYCmYlbuZzkUwCISYVvxQV2+yZ2AwzQoHCTe/Ql3f8vYy4gxpSzFgag/b8eyx8sQmMFeqLk8h39PcgsQErCKuEQewWmRWWaAe+xhxXIfa0gbTUWVtCDuy8UFfIIMYFIdiPdckmCwknKZryJvK4iEOYb67RZ1rZeYbqFlLpubtF+M1+YAJDMBsrPwJS6ZIM0JS7QVN33qUNGZ5Gv4yIoY8TJc901o20wCYaYL3WfqNnP8DDLMZWin+nPlf0IuyzKW/uYLvak0Kk0Vm9Qkur1Mvx9oIFXQL89zJrdaXYlNZJr5PkLEc/KnKj3ZRcWRFaAls/BNs4JBPzUZ/vdR3KuFuSDnE3pfQmYqVUQ3skZ8zM5KySBRBI4XqACLMnJGletSS38l9zzCvazXemFkS
 IgGWi4XG
 mUEGieq8sF0wafOMlBqDc5aiYXuJt8tmqAtGB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zswap writes an entry back, it allocates an order-0 swap cache folio,
decompresses into it, and issues the write. The folio is cold by
construction, yet today it is left on the LRU for page reclaim to find and
free later. That wastes a reclaim scan and keeps cold memory resident
longer than necessary.

Rather than implement this in zswap, extend the existing dropbehind
mechanism to swap cache folios and have zswap opt into it (Yosry). A
PG_dropbehind folio is already dropped from its cache once writeback
completes instead of being left for reclaim; for a swap cache folio that
"drop" is removing it from the swap cache.

  Patch 1 - move LRU insertion out of the swap cache allocator into its
            callers, so a folio that will be dropped on writeback completion
            (zswap writeback) can be allocated off the LRU without a flag.

  Patch 2 - drop dropbehind swap cache folios on writeback completion. The
            drop needs the folio and swap cluster locks and may sleep, but
            writeback can complete in interrupt context, so it is deferred
            to a worker via a per-CPU llist, which frees them in batches.

  Patch 3 - zswap allocates its writeback folio off the LRU and marks it
            dropbehind, opting into the mechanism above.

v1: https://lore.kernel.org/linux-mm/20260718093723.153324-1-alex@ghiti.fr/
v2: https://lore.kernel.org/linux-mm/20260727143618.1582318-1-alex@ghiti.fr/

Changes in v3:
- Drop the synchronous-IO special case in zswap writeback: those folios are
  now marked dropbehind like any other and dropped from folio_end_writeback()
  instead of inline. It was only an optimisation for zswap on a sync backend,
  which is not worth the extra code (Yosry, Nhat). This also removes
  swap_dropbehind_free_one_folio(), which had no other caller.
- Queue the deferred drop on a dedicated WQ_MEM_RECLAIM workqueue instead of
  system_wq: the work item runs on the reclaim path and the folios it frees
  stay off the LRU until it does, so it needs a rescuer to guarantee forward
  progress under memory pressure.
- Use mem_cgroup_tryget()/mem_cgroup_put() rather than css_tryget()/css_put():
  struct mem_cgroup is only defined under CONFIG_MEMCG, so the latter failed
  to build with CONFIG_MEMCG=n.
- Use raw_cpu_ptr() for the per-CPU llist: now that synchronous-IO swap also
  marks its folios dropbehind, writeback can complete in task context and the
  enqueue can run preemptible.

Changes in v2:
- Make swap dropbehind a generic core-mm mechanism that zswap opts into,
  rather than a zswap-specific implementation (Yosry).
- Allocate off the LRU by moving folio_add_lru() out of the swap cache
  allocator into its callers, instead of a skip_lru flag; rename it to
  __swap_cache_alloc_folio() (Kairui).
- Batch the freed folios in the deferred worker (folios_put) instead of a
  put per folio (Nhat).
- Skip the folio in the free path if it is still under writeback
  (defensive) (Nhat).

Results
-------
Paired baseline vs series on async swap (NVMe, Patch 2 deferred path). Each
workload runs confined to a memory cgroup (memory.max) small enough to force
zswap shrinker writeback.

Kernel build (defconfig, make -j4; memory.max = 600M):

  metric            baseline       series      delta
  pgrotated           441028         2521     -99.4%
  pgsteal_direct     3524343      2869004     -18.6%
  pgscan_direct      8393791      7765008      -7.5%
  zswpwb              705129       699019      -0.9%
  build time (s)        1155         1114      -3.6%

Of the 699019 folios written back, 698990 (99.996%) were freed promptly on
writeback completion; only 28 fell back to reclaim.

MySQL/OLTP (sysbench, 10 tables x 1M rows, 512M buffer pool, 8 threads, 300s;
memory.max = 256M):

  metric            baseline       series      delta
  transactions/s      153.87       163.30      +6.1%
  p95 latency (ms)    157.42       145.82      -7.4%
  avg latency (ms)     52.09        49.05      -5.9%
  pgrotated           743738        22460     -97.0%
  pgsteal_direct     6886490      5445278     -20.9%
  pgscan_direct     13462510     10820730     -19.6%

Future work
-----------
Barry suggested extending this to MADV_PAGEOUT and general reclaim, since on
asynchronous swap devices the memory is not freed until a later reclaim scan
even after the folio has been written out. I prototyped dropbehind for all
reclaimed swap folios (not included here) and it regressed sysbench OLTP
throughput by ~15% on NVMe swap. This matches Kairui's point that for common
reclaim the swap cache is worth keeping to catch fast refaults, unlike
synchronous-IO or zswap writeback where the reclaimer already waits.

So this series stays scoped to zswap cold writeback. I still need time to work
out whether general reclaim / MADV_PAGEOUT dropbehind is worth pursuing for
everything or only for known-cold cases, and how; I will follow up.

Alexandre Ghiti (3):
  mm: swap: move LRU insertion out of the swap cache allocator
  mm: swap: drop dropbehind swap cache folios on writeback completion
  mm: zswap: drop cold writeback folios via swap dropbehind

 fs/splice.c          |   2 +-
 include/linux/swap.h |   6 ++-
 mm/filemap.c         |  19 ++++++++
 mm/swap.h            |   6 +--
 mm/swap_state.c      | 114 ++++++++++++++++++++++++++++++++++++++++---
 mm/truncate.c        |   2 +-
 mm/vmscan.c          |  13 +++--
 mm/zswap.c           |   7 ++-
 8 files changed, 148 insertions(+), 21 deletions(-)


base-commit: 626acb37cd445144f321f1b64cac9a93760fa716
-- 
2.53.0-Meta


