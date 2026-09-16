Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27A1C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0345F6B0096; Wed, 16 Sep 2026 07:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B7E6B0098; Wed, 16 Sep 2026 07:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E649E6B0099; Wed, 16 Sep 2026 07:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C63CF6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:26:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55EEF4069A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:26:08 +0000 (UTC)
X-FDA: 85219396416.19.5A3D557
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf18.hostedemail.com (Postfix) with ESMTP id 32A8D1C0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:26:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Yju6Ftmo;
	spf=pass (imf18.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789557966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qkFbwJ3DbJzS5ny24JTrLqbzgteYgwCCQYHKn5yzPro=;
	b=dyupuhSX04VrIxQgztpcutAHoglJrhgP5gfOsK7keDQTFWUNb1Vr3R/YnsEIl6KeqhVq5W
	h8qLkNLTCS5zJFbBZM+nd7NL62Tb237CgsKyNZJdLbig7uCIhue5XG757ipZMkj9mfCr5x
	c5wK06p9hdl4qivsKNQSMFdn9BePJGU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Yju6Ftmo;
	spf=pass (imf18.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789557966;
	b=ZIzjGmnoOmRHONFEkdYRx7ucAmmcA+tdPWPGp2OLmK8LgIzzOw8VQGZ89vIR6f3XLC6Yw2
	F8Sa1NvFcJk78+5F2U7f3kZ4hyjQNuiQ1LWTk/l55vR6aqU5MWi2aTQu5fzh/YHRXtgc7C
	iDijagMQijTRaj3RG8bCjYXKOzp9tQw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789557960; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qkFbwJ3DbJzS5ny24JTrLqbzgteYgwCCQYHKn5yzPro=;
	b=Yju6FtmoQTmuc/7SsQ0P+2OK/IEN+87df742iNU3Bjs/WPsYeMbCGtcUr9s2j8MO98HgeWUWb1DHs0bPDP29+8d+UC2s9PX+yhw8vd45kgAEberM3YibHmksVSfqzA70OhdHbCRknWAAA9Wh09EdWIaZ9Z13ZP/6dIQF+tF7/es=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XB4nUJy_1789557948;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XB4nUJy_1789557948 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Sep 2026 19:25:57 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	mgorman@techsingularity.net,
	linux-mm@kvack.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	henry.willard@oracle.com,
	david@kernel.org,
	Yuanhe Shu <xiangzao@linux.alibaba.com>
Subject: [PATCH v2] mm/page_alloc: do not boost watermarks in kdump capture kernels
Date: Wed, 16 Sep 2026 19:25:45 +0800
Message-ID: <20260916112545.3707893-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32A8D1C0007
X-Stat-Signature: o83d675obmsdn6oep3wx1sw8tqp34oe1
X-Rspam-User: 
X-HE-Tag: 1789557963-12071
X-HE-Meta: U2FsdGVkX19NWsc9GfjJKr8aTMiM/R23YY0l7mE9+NXDtnO2yuz27r4CXJpuEYshMAyYFhmV9gYNee4fAz3CQvzKD6Ze7Y3BjlEkrqnI81WC+o6jDkYQrn3nLzFO4fxsoyIIEG6fiibWQBz/PtsyDldYLE7Of/SCZnE5ovBpruoQXctwj5tNOXYQpMZuaRT4JRyqtQQf0VB/gKjGbBfAji9aJ4WSd08KpWIkqFwsmVf22pM1neJDqeO71D+pFQ94pnO3hnB2Gcq/ZF65kmLnMNTs6uRIf9lOgOlrOMXH5S+7cdZhJ97BDSXrhXj61u5aNraX9YC5Eqc6SJ74oBQ5wocYUZYvDCtEz+K/RIO/SK10T0Hr14wgWh/kjI3G2cNukVNA6oRp7TZWcFT9dxVWG1Recs7zxjOxQbdn9tY77WIAogwaTCbQ+lRpzSaX09jbCgAl4k+BniIM1z2j/j8LjV5amLPf9RuMGcpSL2xRPGcHFUO60+uNyQBAwG/ZVTHWRO67hMlyDtCZNwL9fI8pDYsKU4zUgpOGuHU1oMsCbxz4Zu4uK8caDvYAkSl33pi5o4Ko09KSHW6LUVTUXcGqv1+fu91TbMATlB7hsTslKi+YopbbSTqIT3itJ4BSaVhHVjOYQx5a0JaKLGj06BYxeXioFbFn0JFsxIrkGdueRGw4ZFETytz7phPfw+evosZiISBEDXz5VHJ+lkbsyFTgBp+M1H0SuLzkvLJXNns4Zt1JEYw38sKtLd0bQjfeyAlE1UE19I+bWuCPvWq/YwTrB/6nBS6mZmJeUyEUqa9Np63GIw77Ub2Ypz4yorvS/UNFekqMYGyLyfehpyKGi/DFThngXOOjn1HqtjAO2gTEV9xpmMTHM+c9zSuBUMUV34mY+txbWwkSuzvvYdDBjD77c5kMg68sF0B8mlygv+G7uN18tMF6As04Qtar2dC6AZ9pceG7Unvk346Gl5q7Zxy
 Sz9YOnF3
 JarAco+Tq1igS6MSPUTBe+mP9IDkNtEvBHiYB5KsOOLogxYV81XhWCmRQbKkTegXIS88VqRCuSFaIAUrkr/mdzwsCjq3OZiTJGZpWBLZf/eAQHgO1i5l1t6e66/t10YFZwM3/qbPLXarmLWnUIdFwlmpcYAxtaM17fwwuRHaPoVdtqgHrK6Qx8KYKBYvIgeFPRhFb5tHqByMgpcGtFQHDLG5wWF54I3/cTa+hi8NQv92+uqRWaSL+Muivf33M2J8bScOlPukBqXPUS17NJE7JsmaMmfijNdhpFdKwp7gh5D5IrPLJ+IsGrN+CpAAll0YNKE588pTVpHbgn7PqEk+dAwTMHhio/cXZkL6l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A watermark boost is not confined to one watermark: wmark_pages() adds
it to min, low and high alike, so every watermark check sees it,
including should_reclaim_retry() and the last ditch ALLOC_WMARK_HIGH
attempt in __alloc_pages_may_oom().  Once the boost exceeds the memory
still free the allocator gives up and invokes the OOM killer, and a
capture kernel that is still booting has nothing to kill: the boot
panics and the vmcore is lost.

Seen on an arm64 machine with 64K pages, CONFIG_PAGE_BLOCK_MAX_ORDER=10
(pageblock = 64M) and crashkernel=512M, running a distribution kernel
based on 7.0.14.  A high order UNMOVABLE allocation fell back to a
MOVABLE pageblock while the capture kernel was still in do_initcalls():

  Node 0 DMA free:68096kB boost:65536kB min:68160kB
  low:68800kB high:69440kB managed:479168kB
  Out of memory and no killable processes...
  Kernel panic - not syncing: System is deadlocked on memory

The zone was not short of memory.  Subtracting the boost gives
min:2624kB low:3264kB high:3904kB, so the 68096kB still free sat 17
times above the high watermark and the allocator would not even have
entered its slow path.  The boost supplied 65536kB of the 68160kB min
and by itself put the zone 64kB under water.  It is that large because
boost_watermark() clamps it with max(pageblock_nr_pages, max_boost);
watermark_boost_factor alone would have allowed 5824kB.

Commit 14f69140ff9c ("mm: limit boost_watermark on small zones") already
tried to protect capture kernels, but it infers them from the zone size
and skips the boost only below four pageblocks.  arm64 64K pageblocks
were 512M then, so the guard reached zones up to 2G;
CONFIG_PAGE_BLOCK_MAX_ORDER can cap them at 64M, which shrinks the guard
to zones under 256M and lets this 468M zone through.

kdump is a property of the kernel, not of the zone, so test for it
directly.  A capture kernel exits within seconds and never uses the
fragmentation avoidance the boost buys.  Normal kernels are unaffected:
the size based check still covers their genuinely tiny zones.

Passing sysctl.vm.watermark_boost_factor=0 to the capture kernel does
not cover this window: sysctl.* parameters are written through procfs
by do_sysctl_args(), which runs after do_initcalls() where the panic
above happened, and watermark_boost_factor has no early_param of its
own.

Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Cc: stable@vger.kernel.org # v5.0
Cc: Henry Willard <henry.willard@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
---
Changes in v2:
- Drop the stale kdump capture kernel mention from the small-zone
  comment in boost_watermark(): capture kernels now return earlier.
  (Vlastimil Babka)

v1: https://lore.kernel.org/r/20260914131142.2984623-1-xiangzao@linux.alibaba.com

Build tested with CONFIG_CRASH_DUMP=y and =n.

Tested on the affected machine with the original crashkernel=512M and
capture kernel command line.  Without this patch both capture boots
panicked at 7.9s inside do_initcalls() with a 64M boost in place.  With
it, and with boost_watermark() instrumented, every call was suppressed -
including those inside do_initcalls(), where the panics happened - free
memory came down to within 64kB of the min watermark, where a single
boost would have put it 65472kB under, and the dump completed.
---
 mm/page_alloc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..f52ed7d2cd34 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -37,6 +37,7 @@
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
 #include <linux/compaction.h>
+#include <linux/crash_dump.h>
 #include <trace/events/kmem.h>
 #include <trace/events/oom.h>
 #include <linux/prefetch.h>
@@ -2178,10 +2179,17 @@ static inline bool boost_watermark(struct zone *zone)
 
 	if (!watermark_boost_factor)
 		return false;
+
+	/*
+	 * A kdump capture kernel exits before a boost can pay off, while
+	 * the raised watermark can exceed the memory left for the dump.
+	 */
+	if (is_kdump_kernel())
+		return false;
+
 	/*
 	 * Don't bother in zones that are unlikely to produce results.
-	 * On small machines, including kdump capture kernels running
-	 * in a small area, boosting the watermark can cause an out of
+	 * On small machines, boosting the watermark can cause an out of
 	 * memory situation immediately.
 	 */
 	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
-- 
2.43.7


