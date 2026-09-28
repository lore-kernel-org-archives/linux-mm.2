Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30D8C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4E16B0088; Mon, 28 Sep 2026 06:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E6D6B008A; Mon, 28 Sep 2026 06:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C316B008C; Mon, 28 Sep 2026 06:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6984C6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:58:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA569C0177
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:58:27 +0000 (UTC)
X-FDA: 85262872254.28.667CD75
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0658240005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:58:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XA6vREtY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593106;
	b=PxEbd/IdzBfl+ZMaLjuMIYQX+5eawiMh0SR6LpCAuzC/AGaD9yaCEEcVsY/McIh23ArALZ
	zL4ZH++VuzrlASpEyGLhS7kV3i7F6PEwv0zFK7NoQ+cmJmDkSKNuG7nPsRtYC5E7NheZ6c
	5WFfIj1PFDveY+FnAID9pe0Un4hQXG0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XA6vREtY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9Fw1B6BieJW+4LuX2pRl8ceJtWx5V06DmaPfx5oJeIA=;
	b=LeJ+KvVuM73cDzY8N7mFy5GDZ0shhtWM3q4hc0pziupl8dE6V10SPNtUx3GI+03WGaxnyT
	WUAEOVOjc2LWpRz5STjOfjgTRJCLd1nBwjcKSv5zfnknH+O5D55y5Y778UZ47R82rKWZvk
	ehNZXhXMuR1UsGUrIwRVbWa7JaEOeCo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790593101; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=9Fw1B6BieJW+4LuX2pRl8ceJtWx5V06DmaPfx5oJeIA=;
	b=XA6vREtY4U10OJh16EVIt3y34ydTdxqDn35a0gGKwGvtu77ihyWvvE33ygzTarMAqL5G7iPb4ZzjJRijGKPmyuLvRHfTP6UOyefFiXplGEp1mxsjuLTemTfkjOp6rEPZA7chTKmYrVxTqqp6Fx7AgBNNHSG3vM1DvsHflfmmABo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XBma1yU_1790593086;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XBma1yU_1790593086 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Sep 2026 18:58:20 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: xiangzao@linux.alibaba.com,
	david@kernel.org,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	kaitao.cheng@linux.dev,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm: don't migrate folios containing hwpoisoned pages
Date: Mon, 28 Sep 2026 18:58:03 +0800
Message-ID: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: jx1iyiimrngt195fx5y96dxzstw6artr
X-Rspam-User: 
X-Rspamd-Queue-Id: 0658240005
X-HE-Tag: 1790593104-184957
X-HE-Meta: U2FsdGVkX1+vakpuRFpY/5clhhEhI8KX9T5UBfpzlLYYPoiJu0LX2rAyBb3QMTufF0UdCjAEpKUKip5O1Nk160SEdBU5LPyO6y5R52JmVO6TJS17+JjH36OSPCVAcH+G8z/Tpgy0Uuvssri1uRIUs+7EZSspT3pE0Nxz18bGTBWX+26zA9lW+U+284jImVFHOx5RlI5WeaeXjTvDAnJPxXtHz090jXb4woUD9GZ1s0jXsrJtWd9tSjdFYTdS5ZfuWJkZTsU01zfGZDqpgd+/15Tig8gEewmtKyZP9eIRayDV8BONQIinUTD8vbLabbOtbxVhHB0wKQ+PR9SVGgEgSWZHUu96xYyHWIJcDObVU98I/UbvjJ8Sdd4SISM9AIDuJ3F84m1fPmJY1x/Gy9LYaszhnblSgZOzD3bQYKTK3DLNYxV9aBKo5AXAq8tsHuhd5pD8owoI16DwYDB3IqcC4iq03aS8dp44mMt8mmZ61rGMGVhD47T1dXR7IVhcF6TTdvZXF9bBqXCCmq8HI6KVwBCYkHxNxiRN4aM+XSLfj40EIYt2g30DlbotYP5M/32otsVTHyTqQ7S310aqHtDDa+DObtiRAT61xbQHfw59433HXCJIRK6vjktp14Kp+fbpCxuq2XQyMqXV03GGfzUQ7t7iuVThw0S+CO9JI3Y8jKNSWmDpTkNfrJYaFiSuF4CDoClIAdPVTw5tkr3O9vnmqdOPZGkjd95lknSUwCwuZo4p83+apuaHXOHk07rB8udp71pzTczu9saGVWMD98WadlvkX6DEIQ29pzQprL2Y9iRBVUHf9F6c0IdccDRme+uLb/lWTeFtmuo+SoymRTWxYyM9r9/LRFWfXbqCMe2y0E8TypXPuZitkQBOO9EDeDjt9dy/EPzky60YedbRRjqeMVwQ6NkwSBM6FoMyYcQTKvxV3OrFCWwuHD0r/OSJS4cR3W0GrTEOiSwUYsU7HCS
 KQwC72aC
 XnOZTs8ZgvcE8+QEUqPreSTZICbet7DNHIJDPrWJxH2/YOx9aQ+/CfkJtKPLktyG3OF380Pfi20KtLpaTxJF8UNBRoA3pqiUm4JPjJhWqEisId1VJXEBc7xPmX6E6Z+JyeKv++rk8djeWUNagof4W4QzzjSDQvNdm35f5w7ZqIiSHActQqT2z1YHuTAOHEjgSZjtexlmpv644ZS3tWA+Kj7QydxpRx2TjLmpuLUAgnwUkPxq2A9aGktH/FAnNErKkB/dFPO5ph+r1hItzchUU3S0EbpVKyglEyIW1IaKJ+ZHoydR8QYeYAdsCTxTXoS7CNfBnkW9GZeCT6tTJY88MJfnJkWyjIRex+peahpmfkLADnXSJdPyC3dYtWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

memory_failure() can end up abandoning a folio while PG_hwpoison is
already set on it.  Two ways to get there:

  1. Race: any isolator (compaction, NUMA balancing, move_pages(),
     mbind(), CMA, long-term GUP) clears PG_lru from under
     memory_failure(), which then fails the HWPoisonHandlable()
     check, exhausts the get_any_page() retries and bails out with
     MF_IGNORED - without holding any reference, but with the flag
     set.
  2. No race at all: the THP-split-failure path
     (kill_procs_now() + MF_MSG_UNSPLIT_THP) leaves a large folio
     on the LRU with a PG_hwpoisoned subpage by design.

In both cases the migrator still holds the folio on its migration
list and migrates it like any other: the corrupted data is copied
into a fresh folio with no poison marker, and no hwpoison PTE entry
is installed on the way back, so the userspace mapping is silently
redirected to the corrupted copy - no SIGBUS is ever delivered.

This was reproduced on v7.3-rc4-75-g62f4c998b297 (the base of
this series): an order-0 stress workload (madvise(MADV_HWPOISON)
racing move_pages()) left the poison flag set on 8426 abandoned
folios in a 180-second run; 698 of them were subsequently
migrated, and in every case the address then served the copied
corrupted data with no SIGBUS.

folio_mc_copy() only catches the corruption at copy time, and only
where ARCH_HAS_COPY_MC is implemented (x86_64, PPC64; elsewhere
copy_mc_highpage() degrades to a plain copy).  Software-injected
poison - what MADV_HWPOISON and hwpoison-inject produce, and what
tests and fuzzers exercise - never traps during the copy on any
architecture.  Checking before the copy avoids the migration
entirely, on all architectures, for real and simulated poison
alike.

Consumers of such a folio already refuse it elsewhere,
through the folio_contain_hwpoisoned_page() helper introduced by
commit 5f5ee52d4f58 ("mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper"):
shmem fails writes to a poisoned folio; reclaim unmaps the
order-0 poisoned page and skips the hwpoisoned large folios it
cannot safely unmap
commit 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
commit 9f1e8cd0b7c4 ("mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list")
(skipping, not unmapping, after the unmap variant turned out to
crash on large folios); memory hotplug refuses to migrate it in
do_migrate_range(); and the THP split path refuses to read
poisoned subpages
commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting THP").
This series gives the remaining migrators
the same protection - skipping and refusing only, never unmapping:

  patch 1: compaction, checked at the isolation point, failing
           fast - patch 2's core check would also stop compaction's
           migrations at migrate_pages() time, but only after the
           avoidable isolation work

  patch 2: the migration core, covering move_pages(2), mbind(),
           NUMA balancing, alloc_contig_range() (CMA) and long-term
           GUP - a check at the entry of migrate_folio_unmap() (fail
           fast, before allocating the destination) plus a second
           check in migrate_folio_move() immediately before the
           copy.  The pre-copy check catches poison that lands
           between the two checks: a GUP-based injection path
           takes its reference before the unmap, and
           memory_failure() sets PG_hwpoison before releasing it,
           so a racing software poison is visible by the time
           migration is about to copy.

This series was developed independently; while preparing to
send it, we noticed that Kaitao Cheng had already proposed the
same check for the hugetlb migration path, and in v2 for
move_to_new_folio() [1].  That discussion stalled over the
concern that a check can still race with memory_failure().
Two points complete it here: the unsplit-THP state above is not
a race at all - the entry check catches it deterministically -
and for the race itself, the pre-copy check shrinks the window
to the final instructions before the copy; the measurement
below found zero leaks under adversarial load, and on copy_mc
architectures folio_mc_copy() catches real-DRAM corruption even
there.  The reproducer and the userspace-visible effects are
what that thread's review asked for.

[1] https://lore.kernel.org/r/20260707090136.52904-1-kaitao.cheng@linux.dev/

Measured results:

  - order-0 race against move_pages(): the unpatched kernel
    propagated 698 of 8426 abandoned folios; with patch 2, 0 of
    9711 (the abandoned-folio count varies between runs with the
    race rate).

  - deterministic compaction A/B (order-4 mTHP folios brought into
    the stable unsplit state, clean neighbors as controls): the
    unpatched kernel migrated 16/16 poisoned folios and 16/16
    controls; with patch 1, 0/16 poisoned folios were migrated
    while the controls still migrated 16/16.

The two patches touch different files, have no build dependency,
and each stands on its own.

No single Fixes: tag applies: the race path is as old as the
memory_failure() retry logic meeting page isolation, and the
unsplit-THP path has existed since commit
5d1fd5dc877b ("mm,hwpoison: introduce MF_MSG_UNSPLIT_THP")
(2020) - this series closes a long-standing gap rather than fixing
a regression.  No cc:stable is proposed for the same reason;
backports can be prepared on request if wanted.

Soft offline is unaffected by both patches: it sets the poison
marker only after its own migration has succeeded.  Out of reach
of any check is poison landing in the final instructions before a
copy - natively for paths that take no reference, such as a
hardware MCE or debugfs corrupt-pfn; for a GUP-based path only if
its injecting thread is delayed between taking the reference and
setting the flag - or after the copy has already happened, which
is a lost race regardless; on x86_64 folio_mc_copy()
additionally catches real-DRAM corruption at copy time.

A deterministic reproducer exists for the compaction part: fault
order-4 mTHP folios, pin a sibling subpage of each with vmsplice,
and inject MADV_HWPOISON on another subpage, so memory_failure()
takes the THP-split-failure path and leaves the folio on the LRU
with a poisoned subpage; then trigger compaction and check
/proc/kpageflags for whether each poisoned folio moved.  It needs
a boot configuration where order-4, not PMD-sized, folios are
what compaction migrates.  Both this and the race workload above
can be shared on request.

Yuanhe Shu (2):
  mm/compaction: skip folios containing hwpoisoned pages
  mm/migrate: refuse to migrate folios containing hwpoisoned pages

 mm/compaction.c |  8 ++++++++
 mm/migrate.c    | 41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

-- 
2.43.7


